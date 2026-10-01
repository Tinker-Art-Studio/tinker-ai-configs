## Fix-for-the-fix review: commit b189778 (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies the findings in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-followup5-{claude,codex}.md.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests that write, no deploys).
Review ONLY this diff: does each change resolve the finding it cites, and does it introduce anything new (a stale toggle
left on screen, a detail swapped behind another request's box, a message that states something false, a test that passes a
broken version)? Keep it short. Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to push for deploy review — yes/no.

## Diff (git show b189778)
commit b189778c3ab471ddf70c0830aac0b05e71cba781
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Tue Sep 29 22:23:18 2026 -0600

    fix: the request detail draws only the request opened last; clearer hung-save advice
    
    From the review of 6108d69 (Claude: ready, LOWs only; Codex: one MEDIUM):
    - openTimeOffDetail ignores its own read if another request was opened meanwhile, so a
      confirm's follow-up refresh (or any slow read) can no longer draw an earlier request's detail
      behind the one being viewed. Pinned by a wiring test (mutation-checked).
    - The hung-save advice says to check both the request and the sub's schedule (the shift is
      written before the request is marked confirmed).
    - Secured warning: "next to that sub" / "next to each unconfirmed sub".
    - Test tidy: a stale comment removed; the one-at-a-time regex no longer crosses braces.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/js/app.js b/js/app.js
index 2564167..e6a8701 100644
--- a/js/app.js
+++ b/js/app.js
@@ -7635,13 +7635,16 @@ async function openTimeOffDetail(requestId) {
   body.innerHTML = '<div class="empty-state">Loading...</div>';
   modal.classList.add('open');
 
-  // Load the request fresh
+  // Load the request fresh. The LAST request opened wins: a slower read for an earlier one (e.g. a confirm's
+  // follow-up refresh) must not draw its detail over the request now being viewed.
   let req;
   try {
     const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
+    if (viewingRequestId !== requestId) return;
     if (!doc.exists) { body.innerHTML = '<div class="empty-state">Request not found</div>'; return; }
     req = { id: doc.id, ...doc.data() };
   } catch (err) {
+    if (viewingRequestId !== requestId) return;
     body.innerHTML = '<div class="empty-state">Failed to load request</div>';
     return;
   }
@@ -8113,7 +8116,7 @@ async function submitConfirmSub() {
   const btn = document.getElementById('confirm-sub-submit-btn');
   if (_confirmSubBusy) {   // the previous confirm is still finishing; one save at a time
     alert(Date.now() - _confirmSubBusySince > 60000
-      ? 'The last confirmation has been saving for over a minute and never finished. Reload the page before confirming anyone else — and check first whether it went through.'
+      ? 'The last confirmation has been saving for over a minute and never finished. Reload the page before confirming anyone else — and check both the request and the sub\'s schedule first: the shift may be on their schedule even if they don\'t show as confirmed.'
       : 'Still saving the last confirmation — try again in a moment.');
     return;
   }
@@ -8449,7 +8452,7 @@ async function updateCoverageStatus(requestId, status) {
       if (names.length) {
         const one = names.length === 1;
         const who = one ? names[0] : `${names.slice(0, -1).join(', ')} and ${names[names.length - 1]}`;
-        if (!confirm(`${who} ${one ? 'isn\'t' : 'aren\'t'} confirmed yet, so nothing has been added to their schedule and they haven't been emailed. Use Mark Confirmed next to each unconfirmed sub to do that.\n\nMark coverage Secured anyway?`)) {
+        if (!confirm(`${who} ${one ? 'isn\'t' : 'aren\'t'} confirmed yet, so nothing has been added to their schedule and they haven't been emailed. Use Mark Confirmed next to ${one ? 'that sub' : 'each unconfirmed sub'} to do that.\n\nMark coverage Secured anyway?`)) {
           openTimeOffDetail(requestId);
           return;
         }
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index dd6da52..a01df6b 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2371,7 +2371,7 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close — of its OWN box only
     expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true, ctx\);/);   // a stale box cannot be retried
     expect(submit).toMatch(/_confirmSubBusy = true;\s*_confirmSubBusySince = Date\.now\(\);/);
-    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^]*?alert\(Date\.now\(\) - _confirmSubBusySince > 60000\s*\? 'The last confirmation has been saving for over a minute and never finished\. Reload the page[^]*?: 'Still saving the last confirmation — try again in a moment\.'\);\s*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time; says "reload" once hung
+    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^}]*?alert\(Date\.now\(\) - _confirmSubBusySince > 60000\s*\? 'The last confirmation has been saving for over a minute and never finished\. Reload the page[^\n]*\n\s*: 'Still saving the last confirmation — try again in a moment\.'\);\s*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time; says "reload" once hung
     const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'const requestDates =');
     expect(open).toMatch(/if \(_confirmSubBusy && document\.getElementById\('confirm-sub-modal'\)\.classList\.contains\('open'\)\) \{\s*alert\([^\n]*\);\s*return;\s*\}/);
     // a reopened box never inherits a hung save's disabled "Confirming…" button
@@ -2380,7 +2380,6 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     // the saving box is recorded with the flag and cleared with it; finally also gives the button back
     expect(submit).toMatch(/_confirmSubBusySince = Date\.now\(\);\s*_confirmSubSavingCtx = ctx;/);
     expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;\s*_confirmSubSavingCtx = null;\s*if \(btn\) \{ btn\.disabled = false; btn\.textContent = 'Confirm & Add to Schedule'; \}\s*\}/);
-    // a late save does not swap the detail behind another open box
     // the detail is refreshed unless a box for a DIFFERENT request is open — decided AFTER the refresh await
     expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);\s*renderAdminAllTimeOff\(\);[\s\S]*?const otherRequestBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx && _confirmSubCtx\.requestId !== ctx\.requestId;\s*if \(!otherRequestBoxOpen\) openTimeOffDetail\(ctx\.requestId\);/);
     // a save that never settles cannot lock the box forever: after a minute × / Cancel may close it, with a warning
@@ -2433,3 +2432,12 @@ describe('"Coverage: Secured" is a label, so it warns while a sub is unconfirmed
     expect((fn.match(/renderAdminAllTimeOff\(\);/g) || []).length).toBe(1);
   });
 });
+
+describe('the request detail: the last request opened wins', () => {
+  test('a slower read for an earlier request does not draw over the one now being viewed', () => {
+    const fn = src.slice(src.indexOf('async function openTimeOffDetail(requestId)'), src.indexOf('const isOwner = req.uid === currentUser.uid;'));
+    expect(fn).toMatch(/viewingRequestId = requestId;/);
+    expect(fn).toMatch(/\.doc\(requestId\)\.get\(\);\s*if \(viewingRequestId !== requestId\) return;\s*if \(!doc\.exists\)/);
+    expect(fn).toMatch(/\} catch \(err\) \{\s*if \(viewingRequestId !== requestId\) return;/);
+  });
+});
