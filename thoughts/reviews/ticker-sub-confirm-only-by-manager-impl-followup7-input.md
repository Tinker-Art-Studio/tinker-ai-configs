## Fix-for-the-fix review: commit HEAD (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies the findings in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-followup6-codex.md.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests that write, no deploys).
Review ONLY this diff: does each change resolve the finding it cites, and does it introduce anything new (a stale toggle
left on screen, a detail swapped behind another request's box, a message that states something false, a test that passes a
broken version)? Keep it short. Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to push for deploy review — yes/no.

## Diff (git show HEAD)
commit 59f1cdb2a5fa8cd2555db182499ce9c8955de3d2
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Tue Sep 29 22:24:57 2026 -0600

    fix: the request detail's last-call-wins guard uses a per-call token, not the request id
    
    From the Codex check of b189778: two refreshes of the SAME request can resolve out of order,
    and an id comparison let the older snapshot draw last, restoring stale toggles. Each
    openTimeOffDetail call now takes a sequence number and only the latest draws. The hung-save
    advice is pinned word for word. Both mutation-checked.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/js/app.js b/js/app.js
index e6a8701..3b57d4a 100644
--- a/js/app.js
+++ b/js/app.js
@@ -6790,6 +6790,7 @@ let openedSubs = null;        // name -> { confirmed, hasRecord, entry }
 let openedDates = null;       // normalizeRequestDates(document dates) — never timeoffFormDates, whose rows are edited in place
 let allTimeoffRequests = [];  // cached for admin
 let viewingRequestId = null;  // currently open detail modal
+let detailLoadSeq = 0;         // each openTimeOffDetail call's number; only the latest may draw
 let editingTimeOffId = null;  // non-null when editing an existing request
 
 // ─── Init Time Off Listeners ────────────────────────
@@ -7630,21 +7631,23 @@ async function handleSubmitTimeOff() {
 
 async function openTimeOffDetail(requestId) {
   viewingRequestId = requestId;
+  const loadSeq = ++detailLoadSeq;
   const modal = document.getElementById('timeoff-detail-modal');
   const body = document.getElementById('timeoff-detail-body');
   body.innerHTML = '<div class="empty-state">Loading...</div>';
   modal.classList.add('open');
 
-  // Load the request fresh. The LAST request opened wins: a slower read for an earlier one (e.g. a confirm's
-  // follow-up refresh) must not draw its detail over the request now being viewed.
+  // Load the request fresh. The LAST call wins: a slower read from an earlier call — for another request, or an
+  // older snapshot of this one (e.g. a confirm's follow-up refresh) — must not draw over a newer one, or stale
+  // toggles would be left on screen (and a toggle acts on the fresh state, i.e. the opposite of its stale label).
   let req;
   try {
     const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
-    if (viewingRequestId !== requestId) return;
+    if (loadSeq !== detailLoadSeq) return;
     if (!doc.exists) { body.innerHTML = '<div class="empty-state">Request not found</div>'; return; }
     req = { id: doc.id, ...doc.data() };
   } catch (err) {
-    if (viewingRequestId !== requestId) return;
+    if (loadSeq !== detailLoadSeq) return;
     body.innerHTML = '<div class="empty-state">Failed to load request</div>';
     return;
   }
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index a01df6b..2ba78d4 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2371,7 +2371,7 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close — of its OWN box only
     expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true, ctx\);/);   // a stale box cannot be retried
     expect(submit).toMatch(/_confirmSubBusy = true;\s*_confirmSubBusySince = Date\.now\(\);/);
-    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^}]*?alert\(Date\.now\(\) - _confirmSubBusySince > 60000\s*\? 'The last confirmation has been saving for over a minute and never finished\. Reload the page[^\n]*\n\s*: 'Still saving the last confirmation — try again in a moment\.'\);\s*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time; says "reload" once hung
+    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^}]*?alert\(Date\.now\(\) - _confirmSubBusySince > 60000\s*\? 'The last confirmation has been saving for over a minute and never finished\. Reload the page before confirming anyone else — and check both the request and the sub\\'s schedule first: the shift may be on their schedule even if they don\\'t show as confirmed\.'\s*: 'Still saving the last confirmation — try again in a moment\.'\);\s*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time; says "reload" once hung
     const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'const requestDates =');
     expect(open).toMatch(/if \(_confirmSubBusy && document\.getElementById\('confirm-sub-modal'\)\.classList\.contains\('open'\)\) \{\s*alert\([^\n]*\);\s*return;\s*\}/);
     // a reopened box never inherits a hung save's disabled "Confirming…" button
@@ -2433,11 +2433,13 @@ describe('"Coverage: Secured" is a label, so it warns while a sub is unconfirmed
   });
 });
 
-describe('the request detail: the last request opened wins', () => {
-  test('a slower read for an earlier request does not draw over the one now being viewed', () => {
+describe('the request detail: the last call wins', () => {
+  test('a slower read from an earlier call — another request OR an older snapshot of the same one — never draws', () => {
     const fn = src.slice(src.indexOf('async function openTimeOffDetail(requestId)'), src.indexOf('const isOwner = req.uid === currentUser.uid;'));
-    expect(fn).toMatch(/viewingRequestId = requestId;/);
-    expect(fn).toMatch(/\.doc\(requestId\)\.get\(\);\s*if \(viewingRequestId !== requestId\) return;\s*if \(!doc\.exists\)/);
-    expect(fn).toMatch(/\} catch \(err\) \{\s*if \(viewingRequestId !== requestId\) return;/);
+    // a per-call token, not the request id (two refreshes of the SAME request can resolve out of order)
+    expect(fn).toMatch(/viewingRequestId = requestId;\s*const loadSeq = \+\+detailLoadSeq;/);
+    expect(fn).toMatch(/\.doc\(requestId\)\.get\(\);\s*if \(loadSeq !== detailLoadSeq\) return;\s*if \(!doc\.exists\)/);
+    expect(fn).toMatch(/\} catch \(err\) \{\s*if \(loadSeq !== detailLoadSeq\) return;/);
+    expect(fn).not.toMatch(/viewingRequestId !== requestId/);
   });
 });
