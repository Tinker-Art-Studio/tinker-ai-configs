## Fix-for-the-fix review: commit HEAD (after 76122ad) (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies findings from /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-followup3-{claude,codex}.md
(both reviews of 76122ad). Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests that write, no deploys).

Review ONLY this diff. Focus: the confirm box's busy/close/open logic in js/app.js (openConfirmSubModal, closeConfirmSubModal(force,
onlyIfCtx), submitConfirmSub's one-save-at-a-time refusal and _confirmSubBusySince). Can any sequence now: confirm after a cancel the
manager believed worked; close or clear a box/context that is not the saving one; leave the box permanently unclosable; leave
_confirmSubBusy true forever on a settled path; or let two saves run at once? Is every early return before `_confirmSubBusy = true`
safe (button state)? Do the new tests pin the behaviour (would they fail on a broken version)?
Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to push for deploy review — yes/no.

## Diff (git show HEAD)
commit a53d872cb6f0410d0f9f6eb3fb8e8d78c3ea672d
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Tue Sep 29 22:09:17 2026 -0600

    fix: the confirm box's escape hatch leaves a usable box, and its tests pin the exact behaviour
    
    From the fix-for-the-fix review of 76122ad (both: no data-safety issue; Claude/Codex: MEDIUMs):
    - Only the box whose save is running is held open (_confirmSubSavingCtx). A box opened after
      the one-minute escape hatch closes normally instead of claiming it is still saving.
    - Opening the box resets its Confirm button, so it never inherits a hung save's disabled
      "Confirming…"; the one-save-at-a-time refusal is now the live gate.
    - A save that lands late leaves another open box and the detail behind it alone, and its
      toast names the sub.
    - An unconfirmed sub with no name still triggers the Secured warning ("a sub with no name").
    - Tests pin the whole close function (the return under a minute, the !confirm polarity, the
      saving-box scope), the open refusal's return, the button reset, and finally's button restore.
      Mutation-checked: removing the return, flipping the polarity, or dropping the reset each fails.
    
    Checked in a fresh local tab: hung save → hatch closes box 1 → box 2 opens with a usable
    button and closes without the "still saving" prompt.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/js/app.js b/js/app.js
index 9aaea69..b04b4b7 100644
--- a/js/app.js
+++ b/js/app.js
@@ -7919,6 +7919,7 @@ let _confirmSubCtx = null; // tracks requestId/subIndex/dates/uids for the confi
 // way, so letting the box close would look like a cancel that then confirms anyway.
 let _confirmSubBusy = false;
 let _confirmSubBusySince = 0;   // a save that never settles (offline) must not lock the box for the whole session
+let _confirmSubSavingCtx = null; // the box whose save is running — only THAT box is held open
 
 // Statuses on which a sub may be confirmed or un-confirmed by hand — the same list the button is gated on
 // (Option A: 'approved' included). Checked in the function too (Phase 4, review finding): a stale tab's
@@ -8047,6 +8048,9 @@ function openConfirmSubModal(req, subIndex, sub, match) {
     row.appendChild(document.createTextNode(' ' + new Date(d + 'T12:00:00').toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })));
     datesBox.appendChild(row);
   });
+  // A box reopened after the escape hatch must not inherit the hung save's "Confirming…" button.
+  const submitBtn = document.getElementById('confirm-sub-submit-btn');
+  if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = 'Confirm & Add to Schedule'; }
   document.querySelector('input[name="confirm-sub-mode"][value="full"]').checked = true;
   document.getElementById('confirm-sub-custom-times').classList.add('hidden');
   document.getElementById('confirm-sub-start').value = '';
@@ -8058,7 +8062,7 @@ function openConfirmSubModal(req, subIndex, sub, match) {
 // this request can be submitted later or leak into the next one opened.
 function closeConfirmSubModal(force, onlyIfCtx) {
   if (onlyIfCtx && _confirmSubCtx !== onlyIfCtx) return;   // a later box is open now; leave it alone
-  if (_confirmSubBusy && !force) {
+  if (_confirmSubBusy && !force && _confirmSubCtx === _confirmSubSavingCtx) {
     if (Date.now() - _confirmSubBusySince < 60000) {
       alert('Still saving this confirmation — it can\'t be cancelled part-way. The box closes when it finishes.');
       return;
@@ -8114,6 +8118,7 @@ async function submitConfirmSub() {
   if (btn) { btn.disabled = true; btn.textContent = 'Confirming...'; }
   _confirmSubBusy = true;
   _confirmSubBusySince = Date.now();
+  _confirmSubSavingCtx = ctx;
 
   try {
     const [requesterSchedule, subSchedule] = await Promise.all([
@@ -8229,11 +8234,14 @@ async function submitConfirmSub() {
       return;
     }
 
+    // Another box may be open by now (the manager used the one-minute escape hatch): leave it and the detail
+    // behind it alone, and name whose confirmation this was.
+    const anotherBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx;
     closeConfirmSubModal(true, ctx);
     allTimeoffRequests = await getAllTimeOffRequests();
     renderAdminAllTimeOff();
-    openTimeOffDetail(ctx.requestId);
-    showToast('Sub confirmed and shift added to their schedule');
+    if (!anotherBoxOpen) openTimeOffDetail(ctx.requestId);
+    showToast(`${ctx.subName} confirmed and the shift added to their schedule`);
     // Plan 2, Phase 4 — a real schedule write happened, so both the sub and the requester get notified.
     // The requester's email lists only the dates that actually got a shift written (Object.keys of
     // overridesToWrite), not ctx.dates wholesale — buildSubScheduleOverride() can return null for a date
@@ -8264,6 +8272,7 @@ async function submitConfirmSub() {
     alert('Something went wrong confirming this sub.');
   } finally {
     _confirmSubBusy = false;
+    _confirmSubSavingCtx = null;
     if (btn) { btn.disabled = false; btn.textContent = 'Confirm & Add to Schedule'; }
   }
 }
diff --git a/js/schedule-helpers.js b/js/schedule-helpers.js
index 0003d2d..d152438 100644
--- a/js/schedule-helpers.js
+++ b/js/schedule-helpers.js
@@ -215,7 +215,7 @@ function getSubCoverageDates(sub, requestDates) {
 // The proposed subs a manager has not confirmed yet, by name — what the "Coverage: Secured" warning names
 // (plan: ticker-sub-confirm-only-by-manager, Phase 3). Secured is only a label; it writes no shift and sends no email.
 function unconfirmedSubNames(proposedSubs) {
-  return (Array.isArray(proposedSubs) ? proposedSubs : []).filter(s => s && !s.confirmed).map(s => s.name).filter(Boolean);
+  return (Array.isArray(proposedSubs) ? proposedSubs : []).filter(s => s && !s.confirmed).map(s => s.name || 'a sub with no name');
 }
 
 // Which of the request's dates the confirm box ticks to begin with (D2, plan: ticker-sub-confirm-only-by-manager).
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index d922b1b..104ab78 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2350,7 +2350,9 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
   });
 
   test('× and Cancel both close through closeConfirmSubModal, which drops the context; submit needs the box open', () => {
-    expect(src).toMatch(/function closeConfirmSubModal\(force, onlyIfCtx\) \{\s*if \(onlyIfCtx && _confirmSubCtx !== onlyIfCtx\) return;[\s\S]*?document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
+    // the whole close, pinned: only the SAVING box is held; under a minute it RETURNS after the alert; after a minute
+    // it closes only if the manager says yes (!confirm → return)
+    expect(src).toMatch(/function closeConfirmSubModal\(force, onlyIfCtx\) \{\s*if \(onlyIfCtx && _confirmSubCtx !== onlyIfCtx\) return;[^\n]*\n\s*if \(_confirmSubBusy && !force && _confirmSubCtx === _confirmSubSavingCtx\) \{\s*if \(Date\.now\(\) - _confirmSubBusySince < 60000\) \{\s*alert\([^\n]*\);\s*return;\s*\}\s*(\/\/[^\n]*\n\s*)?if \(!confirm\([^\n]*\)\) return;\s*\}\s*document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
     const box = html.slice(html.indexOf('<div id="confirm-sub-modal"'), html.indexOf('</div>\n</div>', html.indexOf('<div id="confirm-sub-modal"')));
     expect((box.match(/onclick="closeConfirmSubModal\(\)"/g) || []).length).toBe(2);
     expect(box).not.toMatch(/classList\.remove\('open'\)/);
@@ -2365,13 +2367,21 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(busyOn).toBeGreaterThan(submit.indexOf("btn.textContent = 'Confirming...'"));
     expect(tryAt).toBeGreaterThan(busyOn);
     expect(submit.slice(busyOn, tryAt)).not.toMatch(/return/);   // nothing between can leave it stuck on
-    expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;/);
+    expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;\s*_confirmSubSavingCtx = null;/);
     expect(submit).toMatch(/closeConfirmSubModal\(true, ctx\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close — of its OWN box only
     expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true, ctx\);/);   // a stale box cannot be retried
     expect(submit).toMatch(/_confirmSubBusy = true;\s*_confirmSubBusySince = Date\.now\(\);/);
     expect(submit).toMatch(/if \(_confirmSubBusy\) \{[^}]*alert\('Still saving the last confirmation[^}]*return;\s*\}\s*if \(btn\) \{ btn\.disabled = true;/);   // one save at a time
     const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'const requestDates =');
-    expect(open).toMatch(/if \(_confirmSubBusy && document\.getElementById\('confirm-sub-modal'\)\.classList\.contains\('open'\)\) \{\s*alert\(/);
+    expect(open).toMatch(/if \(_confirmSubBusy && document\.getElementById\('confirm-sub-modal'\)\.classList\.contains\('open'\)\) \{\s*alert\([^\n]*\);\s*return;\s*\}/);
+    // a reopened box never inherits a hung save's disabled "Confirming…" button
+    const openAll = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'function closeConfirmSubModal(');
+    expect(openAll).toMatch(/if \(submitBtn\) \{ submitBtn\.disabled = false; submitBtn\.textContent = 'Confirm & Add to Schedule'; \}/);
+    // the saving box is recorded with the flag and cleared with it; finally also gives the button back
+    expect(submit).toMatch(/_confirmSubBusySince = Date\.now\(\);\s*_confirmSubSavingCtx = ctx;/);
+    expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;\s*_confirmSubSavingCtx = null;\s*if \(btn\) \{ btn\.disabled = false; btn\.textContent = 'Confirm & Add to Schedule'; \}\s*\}/);
+    // a late save does not swap the detail behind another open box
+    expect(submit).toMatch(/const anotherBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx;[\s\S]*?if \(!anotherBoxOpen\) openTimeOffDetail\(ctx\.requestId\);/);
     // a save that never settles cannot lock the box forever: after a minute × / Cancel may close it, with a warning
     expect(src).toMatch(/if \(Date\.now\(\) - _confirmSubBusySince < 60000\) \{/);
   });
diff --git a/schedule-helpers.test.js b/schedule-helpers.test.js
index 65c891f..b48187d 100644
--- a/schedule-helpers.test.js
+++ b/schedule-helpers.test.js
@@ -3087,8 +3087,8 @@ describe('unconfirmedSubNames — who the "Coverage: Secured" warning names', ()
   test('only the unconfirmed subs, in order', () => {
     expect(unconfirmedSubNames([{ name: 'Sam', confirmed: false }, { name: 'Kayleigh', confirmed: true }, { name: 'Alex' }])).toEqual(['Sam', 'Alex']);
   });
-  test('an entry with no name is not named as "undefined"', () => {
-    expect(unconfirmedSubNames([{ confirmed: false }, { name: 'Sam', confirmed: false }])).toEqual(['Sam']);
+  test('an entry with no name still triggers the warning, without reading "undefined"', () => {
+    expect(unconfirmedSubNames([{ confirmed: false }, { name: 'Sam', confirmed: false }])).toEqual(['a sub with no name', 'Sam']);
   });
   test('no subs, all confirmed, or a missing list → nobody (no warning)', () => {
     expect(unconfirmedSubNames([])).toEqual([]);
