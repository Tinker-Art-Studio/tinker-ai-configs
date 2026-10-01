## Fix-for-the-fix review: commit 76122ad (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies findings from /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-phase3-claude.md
(M2, M3, L1, L2, L3). Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests that write, no deploys).

Review ONLY this diff. Focus: the confirm box's busy/close/open logic in js/app.js (openConfirmSubModal, closeConfirmSubModal(force,
onlyIfCtx), submitConfirmSub's one-save-at-a-time refusal and _confirmSubBusySince). Can any sequence now: confirm after a cancel the
manager believed worked; close or clear a box/context that is not the saving one; leave the box permanently unclosable; leave
_confirmSubBusy true forever on a settled path; or let two saves run at once? Is every early return before `_confirmSubBusy = true`
safe (button state)? Do the new tests pin the behaviour (would they fail on a broken version)?
Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to push for deploy review — yes/no.

## Diff (git show 76122ad)
commit 76122ad1fd2e1f34f96062fe8c79f6b0a28c9bfb
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Tue Sep 29 22:00:17 2026 -0600

    fix: phase 3 review follow-ups — a hung save cannot lock the confirm box, polarity-pinned tests
    
    From the final implementation review (Codex: no findings; Claude: ready, with these):
    - The "still saving" guard is bounded: after a minute with no answer (e.g. offline), × /
      Cancel may close the box after a warning that it may still finish. A save closes only its
      OWN box, a new box can open once the previous one has closed, and a second save waits for
      the first to finish (one at a time), so the guard can no longer be cleared early.
    - Opening a box while one is still saving now says so instead of doing nothing.
    - The Secured warning never names a sub with no name as "undefined".
    - The Phase 3 wiring tests now pin polarity: it is Cancel (!confirm) that returns without
      writing, and only when someone is unconfirmed.
    - Coverage help text: "exactly one person on the roster who has signed in to Ticker".
    
    Checked in a local tab (new code confirmed loaded): Cancel refused while saving; after a
    minute the manager is asked, "no" keeps the box, "yes" closes it and drops the context.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/index.html b/index.html
index 69d30fb..e550875 100644
--- a/index.html
+++ b/index.html
@@ -708,7 +708,7 @@
         <!-- Coverage -->
         <div style="margin-bottom:16px;">
           <label style="font-size:13px; font-weight:700; display:block; margin-bottom:6px;">Coverage</label>
-          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub and, when Ticker can match them to one person on the roster, adds the shift to their schedule.</p>
+          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub and, when they match exactly one person on the roster who has signed in to Ticker, adds the shift to their schedule.</p>
           <div id="timeoff-subs-list"></div>
           <select id="timeoff-sub-picker" style="width:100%; padding:8px 10px; border:1px solid var(--border-light); border-radius:6px; font-family:inherit; font-size:13px; background:var(--bg-white); margin-bottom:8px;">
             <option value="">Add a coworker for coverage...</option>
diff --git a/js/app.js b/js/app.js
index 292fbfe..9aaea69 100644
--- a/js/app.js
+++ b/js/app.js
@@ -7918,6 +7918,7 @@ let _confirmSubCtx = null; // tracks requestId/subIndex/dates/uids for the confi
 // True while a confirm is writing. × and Cancel are refused meanwhile: closing cannot stop a write already under
 // way, so letting the box close would look like a cancel that then confirms anyway.
 let _confirmSubBusy = false;
+let _confirmSubBusySince = 0;   // a save that never settles (offline) must not lock the box for the whole session
 
 // Statuses on which a sub may be confirmed or un-confirmed by hand — the same list the button is gated on
 // (Option A: 'approved' included). Checked in the function too (Phase 4, review finding): a stale tab's
@@ -7995,7 +7996,12 @@ async function handleSubConfirmToggle(requestId, subIndex) {
 }
 
 function openConfirmSubModal(req, subIndex, sub, match) {
-  if (_confirmSubBusy) return;   // a confirm is still writing; its box stays until it finishes
+  // A confirm still writing keeps its box. Once that box has closed (the success path closes it before its
+  // follow-up refresh), a new one may open: the earlier save only closes a box that is still its own.
+  if (_confirmSubBusy && document.getElementById('confirm-sub-modal').classList.contains('open')) {
+    alert('Still saving the last confirmation — try again in a moment.');
+    return;
+  }
   // D2: the manager picks the dates from the request's REAL dates. Pre-ticked from the sub's own proposed dates,
   // or all of them when those no longer line up (Ivy's "no covered dates", Sep 29).
   const requestDates = (req.dates || []).map(d => d.date).filter(Boolean);
@@ -8050,10 +8056,15 @@ function openConfirmSubModal(req, subIndex, sub, match) {
 
 // The one way the confirm box closes (× and Cancel both call this): the context goes with it, so nothing from
 // this request can be submitted later or leak into the next one opened.
-function closeConfirmSubModal(force) {
+function closeConfirmSubModal(force, onlyIfCtx) {
+  if (onlyIfCtx && _confirmSubCtx !== onlyIfCtx) return;   // a later box is open now; leave it alone
   if (_confirmSubBusy && !force) {
-    alert('Still saving this confirmation — it can\'t be cancelled part-way. The box closes when it finishes.');
-    return;
+    if (Date.now() - _confirmSubBusySince < 60000) {
+      alert('Still saving this confirmation — it can\'t be cancelled part-way. The box closes when it finishes.');
+      return;
+    }
+    // Over a minute with no answer (e.g. the connection dropped): let the manager out, and say what that means.
+    if (!confirm('This confirmation has been saving for over a minute. Close the box anyway? It may still finish — reopen the request to check whether the sub shows as confirmed.')) return;
   }
   document.getElementById('confirm-sub-modal').classList.remove('open');
   _confirmSubCtx = null;
@@ -8096,8 +8107,13 @@ async function submitConfirmSub() {
   }
 
   const btn = document.getElementById('confirm-sub-submit-btn');
+  if (_confirmSubBusy) {   // the previous confirm is still finishing its refresh; one save at a time
+    alert('Still saving the last confirmation — try again in a moment.');
+    return;
+  }
   if (btn) { btn.disabled = true; btn.textContent = 'Confirming...'; }
   _confirmSubBusy = true;
+  _confirmSubBusySince = Date.now();
 
   try {
     const [requesterSchedule, subSchedule] = await Promise.all([
@@ -8208,12 +8224,12 @@ async function submitConfirmSub() {
       const differs = mismatch.length ? ` For ${mismatch.sort().join(', ')} the times you entered differ from theirs (or could not be compared) and the schedule may show yours — check ${ctx.subName}'s schedule for those dates and correct it by hand if needed.` : '';
       alert(`${lead}${rolled}${differs} Please refresh.`);
       // The box's checkboxes describe dates the request no longer has, so a retry could never pass: close it.
-      if (result.field === 'dates') closeConfirmSubModal(true);
+      if (result.field === 'dates') closeConfirmSubModal(true, ctx);
       if (!rb.ok || mismatch.length) console.error('Sub confirm rollback:', { rb, mismatch, subUid: ctx.subUid, appliedOverrides, theirs });
       return;
     }
 
-    closeConfirmSubModal(true);
+    closeConfirmSubModal(true, ctx);
     allTimeoffRequests = await getAllTimeOffRequests();
     renderAdminAllTimeOff();
     openTimeOffDetail(ctx.requestId);
diff --git a/js/schedule-helpers.js b/js/schedule-helpers.js
index 0d4f85f..0003d2d 100644
--- a/js/schedule-helpers.js
+++ b/js/schedule-helpers.js
@@ -215,7 +215,7 @@ function getSubCoverageDates(sub, requestDates) {
 // The proposed subs a manager has not confirmed yet, by name — what the "Coverage: Secured" warning names
 // (plan: ticker-sub-confirm-only-by-manager, Phase 3). Secured is only a label; it writes no shift and sends no email.
 function unconfirmedSubNames(proposedSubs) {
-  return (Array.isArray(proposedSubs) ? proposedSubs : []).filter(s => s && !s.confirmed).map(s => s.name);
+  return (Array.isArray(proposedSubs) ? proposedSubs : []).filter(s => s && !s.confirmed).map(s => s.name).filter(Boolean);
 }
 
 // Which of the request's dates the confirm box ticks to begin with (D2, plan: ticker-sub-confirm-only-by-manager).
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index eb586ec..d922b1b 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2350,7 +2350,7 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
   });
 
   test('× and Cancel both close through closeConfirmSubModal, which drops the context; submit needs the box open', () => {
-    expect(src).toMatch(/function closeConfirmSubModal\(force\) \{\s*if \(_confirmSubBusy && !force\) \{[\s\S]*?return;\s*\}\s*document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
+    expect(src).toMatch(/function closeConfirmSubModal\(force, onlyIfCtx\) \{\s*if \(onlyIfCtx && _confirmSubCtx !== onlyIfCtx\) return;[\s\S]*?document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
     const box = html.slice(html.indexOf('<div id="confirm-sub-modal"'), html.indexOf('</div>\n</div>', html.indexOf('<div id="confirm-sub-modal"')));
     expect((box.match(/onclick="closeConfirmSubModal\(\)"/g) || []).length).toBe(2);
     expect(box).not.toMatch(/classList\.remove\('open'\)/);
@@ -2366,10 +2366,14 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(tryAt).toBeGreaterThan(busyOn);
     expect(submit.slice(busyOn, tryAt)).not.toMatch(/return/);   // nothing between can leave it stuck on
     expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;/);
-    expect(submit).toMatch(/closeConfirmSubModal\(true\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close
-    expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true\);/);   // a stale box cannot be retried
+    expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close — of its OWN box only
+    expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true, ctx\);/);   // a stale box cannot be retried
+    expect(submit).toMatch(/_confirmSubBusy = true;\s*_confirmSubBusySince = Date\.now\(\);/);
+    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^}]*alert\('Still saving the last confirmation[^}]*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time
     const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'const requestDates =');
-    expect(open).toMatch(/if \(_confirmSubBusy\) return;/);
+    expect(open).toMatch(/if \(_confirmSubBusy && document\.getElementById\('confirm-sub-modal'\)\.classList\.contains\('open'\)\) \{\s*alert\(/);
+    // a save that never settles cannot lock the box forever: after a minute × / Cancel may close it, with a warning
+    expect(src).toMatch(/if \(Date\.now\(\) - _confirmSubBusySince < 60000\) \{/);
   });
 
   test('the emulator test\'s mirrored helpers are verbatim copies of js/schedule-helpers.js', () => {
@@ -2396,9 +2400,10 @@ describe('"Coverage: Secured" is a label, so it warns while a sub is unconfirmed
 
   test('every Cancel / refusal re-renders the detail BEFORE returning (the select already shows the unsaved value)', () => {
     // warning cancelled
-    expect(fn).toMatch(/Mark coverage Secured anyway\?`\)\) \{\s*openTimeOffDetail\(requestId\);\s*return;\s*\}/);
+    // polarity pinned: it is CANCEL (!confirm) that returns without writing, and only when someone is unconfirmed
+    expect(fn).toMatch(/if \(names\.length\) \{[\s\S]*?if \(!confirm\(`\$\{who\}[\s\S]*?Mark coverage Secured anyway\?`\)\) \{\s*openTimeOffDetail\(requestId\);\s*return;\s*\}/);
     // failed read, cancelled
-    expect(fn).toMatch(/Mark coverage Secured anyway\?'\)\) \{ openTimeOffDetail\(requestId\); return; \}/);
+    expect(fn).toMatch(/if \(!confirm\('Couldn\\'t check the subs on this request\. Mark coverage Secured anyway\?'\)\) \{ openTimeOffDetail\(requestId\); return; \}/);
     // request gone
     expect(fn).toMatch(/if \(read\.ok && !read\.exists\) \{\s*alert\('This request no longer exists\.'\);\s*openTimeOffDetail\(requestId\);\s*return;\s*\}/);
     // write refused or failed: an error, a re-render, and NO success toast
diff --git a/schedule-helpers.test.js b/schedule-helpers.test.js
index 2614cd5..65c891f 100644
--- a/schedule-helpers.test.js
+++ b/schedule-helpers.test.js
@@ -3087,6 +3087,9 @@ describe('unconfirmedSubNames — who the "Coverage: Secured" warning names', ()
   test('only the unconfirmed subs, in order', () => {
     expect(unconfirmedSubNames([{ name: 'Sam', confirmed: false }, { name: 'Kayleigh', confirmed: true }, { name: 'Alex' }])).toEqual(['Sam', 'Alex']);
   });
+  test('an entry with no name is not named as "undefined"', () => {
+    expect(unconfirmedSubNames([{ confirmed: false }, { name: 'Sam', confirmed: false }])).toEqual(['Sam']);
+  });
   test('no subs, all confirmed, or a missing list → nobody (no warning)', () => {
     expect(unconfirmedSubNames([])).toEqual([]);
     expect(unconfirmedSubNames([{ name: 'Sam', confirmed: true }])).toEqual([]);
