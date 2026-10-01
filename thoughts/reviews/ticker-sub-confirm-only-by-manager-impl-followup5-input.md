## Fix-for-the-fix review: commit 6108d69 (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies the findings in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-followup4-{claude,codex}.md.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests that write, no deploys).
Review ONLY this diff: does each change resolve the finding it cites, and does it introduce anything new (a stale toggle
left on screen, a detail swapped behind another request's box, a message that states something false, a test that passes a
broken version)? Keep it short. Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to push for deploy review — yes/no.

## Diff (git show 6108d69)
commit 6108d69553f7d6d66913a580ccf6528dd94faec8
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Tue Sep 29 22:17:25 2026 -0600

    fix: a late confirm always refreshes its own request's detail; a hung save says to reload
    
    From the review of a53d872 (both: no data-safety issue in the gate itself; both MEDIUM):
    - The "another box is open" decision is made AFTER the refresh await, and it only skips the
      detail refresh when the open box is for a DIFFERENT request. Skipping it for the same request
      left Sam's toggle reading "Mark Confirmed" after Sam was confirmed — and the toggle acts on the
      fresh state, so a click would have silently UN-confirmed Sam and removed the shift.
    - Once the previous save is over a minute old, the one-at-a-time refusal says to reload (and
      check whether it went through) instead of "try again in a moment", which would never come true.
    - The Secured warning says "next to each unconfirmed sub" (reads right for a nameless entry).
    - Tests pin the after-await placement (mutation-checked: moving it before the await fails), the
      submit-button lookup as well as its reset, and the reload wording.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/js/app.js b/js/app.js
index b04b4b7..2564167 100644
--- a/js/app.js
+++ b/js/app.js
@@ -8111,8 +8111,10 @@ async function submitConfirmSub() {
   }
 
   const btn = document.getElementById('confirm-sub-submit-btn');
-  if (_confirmSubBusy) {   // the previous confirm is still finishing its refresh; one save at a time
-    alert('Still saving the last confirmation — try again in a moment.');
+  if (_confirmSubBusy) {   // the previous confirm is still finishing; one save at a time
+    alert(Date.now() - _confirmSubBusySince > 60000
+      ? 'The last confirmation has been saving for over a minute and never finished. Reload the page before confirming anyone else — and check first whether it went through.'
+      : 'Still saving the last confirmation — try again in a moment.');
     return;
   }
   if (btn) { btn.disabled = true; btn.textContent = 'Confirming...'; }
@@ -8234,13 +8236,14 @@ async function submitConfirmSub() {
       return;
     }
 
-    // Another box may be open by now (the manager used the one-minute escape hatch): leave it and the detail
-    // behind it alone, and name whose confirmation this was.
-    const anotherBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx;
     closeConfirmSubModal(true, ctx);
     allTimeoffRequests = await getAllTimeOffRequests();
     renderAdminAllTimeOff();
-    if (!anotherBoxOpen) openTimeOffDetail(ctx.requestId);
+    // Refresh this request's detail — its toggles must show the new state, or a stale "Mark Confirmed" would, on
+    // click, UN-confirm (the toggle acts on the fresh state). Skipped only when a box for a DIFFERENT request is
+    // open now (after the escape hatch), whose detail must stay behind it. Decided AFTER the await above.
+    const otherRequestBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx && _confirmSubCtx.requestId !== ctx.requestId;
+    if (!otherRequestBoxOpen) openTimeOffDetail(ctx.requestId);
     showToast(`${ctx.subName} confirmed and the shift added to their schedule`);
     // Plan 2, Phase 4 — a real schedule write happened, so both the sub and the requester get notified.
     // The requester's email lists only the dates that actually got a shift written (Object.keys of
@@ -8446,7 +8449,7 @@ async function updateCoverageStatus(requestId, status) {
       if (names.length) {
         const one = names.length === 1;
         const who = one ? names[0] : `${names.slice(0, -1).join(', ')} and ${names[names.length - 1]}`;
-        if (!confirm(`${who} ${one ? 'isn\'t' : 'aren\'t'} confirmed yet, so nothing has been added to their schedule and they haven't been emailed. Use Mark Confirmed next to ${one ? 'their name' : 'each name'} to do that.\n\nMark coverage Secured anyway?`)) {
+        if (!confirm(`${who} ${one ? 'isn\'t' : 'aren\'t'} confirmed yet, so nothing has been added to their schedule and they haven't been emailed. Use Mark Confirmed next to each unconfirmed sub to do that.\n\nMark coverage Secured anyway?`)) {
           openTimeOffDetail(requestId);
           return;
         }
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index 104ab78..dd6da52 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2371,17 +2371,18 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close — of its OWN box only
     expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true, ctx\);/);   // a stale box cannot be retried
     expect(submit).toMatch(/_confirmSubBusy = true;\s*_confirmSubBusySince = Date\.now\(\);/);
-    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^}]*alert\('Still saving the last confirmation[^}]*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time
+    expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^]*?alert\(Date\.now\(\) - _confirmSubBusySince > 60000\s*\? 'The last confirmation has been saving for over a minute and never finished\. Reload the page[^]*?: 'Still saving the last confirmation — try again in a moment\.'\);\s*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time; says "reload" once hung
     const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'const requestDates =');
     expect(open).toMatch(/if \(_confirmSubBusy && document\.getElementById\('confirm-sub-modal'\)\.classList\.contains\('open'\)\) \{\s*alert\([^\n]*\);\s*return;\s*\}/);
     // a reopened box never inherits a hung save's disabled "Confirming…" button
     const openAll = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'function closeConfirmSubModal(');
-    expect(openAll).toMatch(/if \(submitBtn\) \{ submitBtn\.disabled = false; submitBtn\.textContent = 'Confirm & Add to Schedule'; \}/);
+    expect(openAll).toMatch(/const submitBtn = document\.getElementById\('confirm-sub-submit-btn'\);\s*if \(submitBtn\) \{ submitBtn\.disabled = false; submitBtn\.textContent = 'Confirm & Add to Schedule'; \}/);
     // the saving box is recorded with the flag and cleared with it; finally also gives the button back
     expect(submit).toMatch(/_confirmSubBusySince = Date\.now\(\);\s*_confirmSubSavingCtx = ctx;/);
     expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;\s*_confirmSubSavingCtx = null;\s*if \(btn\) \{ btn\.disabled = false; btn\.textContent = 'Confirm & Add to Schedule'; \}\s*\}/);
     // a late save does not swap the detail behind another open box
-    expect(submit).toMatch(/const anotherBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx;[\s\S]*?if \(!anotherBoxOpen\) openTimeOffDetail\(ctx\.requestId\);/);
+    // the detail is refreshed unless a box for a DIFFERENT request is open — decided AFTER the refresh await
+    expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);\s*renderAdminAllTimeOff\(\);[\s\S]*?const otherRequestBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx && _confirmSubCtx\.requestId !== ctx\.requestId;\s*if \(!otherRequestBoxOpen\) openTimeOffDetail\(ctx\.requestId\);/);
     // a save that never settles cannot lock the box forever: after a minute × / Cancel may close it, with a warning
     expect(src).toMatch(/if \(Date\.now\(\) - _confirmSubBusySince < 60000\) \{/);
   });
