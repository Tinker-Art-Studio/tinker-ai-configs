## Implementation review — Phase 3 of ticker-sub-confirm-only-by-manager (+ the Phase 2 follow-up commit)
Plan (the spec): /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html — read
"Phase 3" in full (and Phase 2 for the follow-ups). Phase 2 was reviewed at 7e7ebba (reviews:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-phase2-{claude,codex}.md).
Repo: /Users/christiehubley/tinker-timeclock, branch fix/sub-confirm-manager-only. Diff below covers TWO commits:
64fb45d (fixes from the Phase 2 review — review as new code: DOM-built checkboxes, the _confirmSubBusy guard, the
dates-refusal close, new messages, the guard-order emulator case) and 6bf822b (Phase 3).
READ-ONLY for you: no edits, no tests that write, no deploys. You may read any file.

## What to check
- 64fb45d: does the busy guard really prevent a "cancel that confirms anyway"? Any path where _confirmSubBusy stays true
  forever (box stuck open), or where the success path's forced close / the dates-refusal close misbehaves? Is the DOM build
  free of injection? Any other way (outside × / Cancel) the box or context can change mid-save?
- 6bf822b vs the Phase 3 spec: every deviation, omission, or overreach.
- Trace updateCoverageStatus for: Secured with no subs; all confirmed; one unconfirmed → Cancel; → OK; two unconfirmed;
  failed read → Cancel / OK; request deleted; a sub confirmed/undone in another tab between the read and the write;
  approved → completed auto-complete between them; any other status change; a failed write; Pending/Partial/Not Needed.
  In each: what is written, what the manager sees, and what the dropdown shows afterwards.
- Firebase invariants: no undefined written; guarded writes; awaited writes.
- Are the new tests real (would they fail on a broken implementation)?
- Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to push for deploy review — yes/no.

## Diff (git diff 7e7ebba 6bf822b)
diff --git a/index.html b/index.html
index d8ae094..69d30fb 100644
--- a/index.html
+++ b/index.html
@@ -708,7 +708,7 @@
         <!-- Coverage -->
         <div style="margin-bottom:16px;">
           <label style="font-size:13px; font-weight:700; display:block; margin-bottom:6px;">Coverage</label>
-          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub (and, for anyone signed in to Ticker, adds the shift to their schedule).</p>
+          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub and, when Ticker can match them to one person on the roster, adds the shift to their schedule.</p>
           <div id="timeoff-subs-list"></div>
           <select id="timeoff-sub-picker" style="width:100%; padding:8px 10px; border:1px solid var(--border-light); border-radius:6px; font-family:inherit; font-size:13px; background:var(--bg-white); margin-bottom:8px;">
             <option value="">Add a coworker for coverage...</option>
diff --git a/js/app.js b/js/app.js
index dde1e32..292fbfe 100644
--- a/js/app.js
+++ b/js/app.js
@@ -7915,6 +7915,9 @@ async function addTimeOffComment(requestId) {
 // ─── Sub Confirmation + Auto-Assignment (Plan 2, Phase 3) ─────────
 
 let _confirmSubCtx = null; // tracks requestId/subIndex/dates/uids for the confirm-sub modal flow
+// True while a confirm is writing. × and Cancel are refused meanwhile: closing cannot stop a write already under
+// way, so letting the box close would look like a cancel that then confirms anyway.
+let _confirmSubBusy = false;
 
 // Statuses on which a sub may be confirmed or un-confirmed by hand — the same list the button is gated on
 // (Option A: 'approved' included). Checked in the function too (Phase 4, review finding): a stale tab's
@@ -7992,6 +7995,7 @@ async function handleSubConfirmToggle(requestId, subIndex) {
 }
 
 function openConfirmSubModal(req, subIndex, sub, match) {
+  if (_confirmSubBusy) return;   // a confirm is still writing; its box stays until it finishes
   // D2: the manager picks the dates from the request's REAL dates. Pre-ticked from the sub's own proposed dates,
   // or all of them when those no longer line up (Ivy's "no covered dates", Sep 29).
   const requestDates = (req.dates || []).map(d => d.date).filter(Boolean);
@@ -8015,12 +8019,28 @@ function openConfirmSubModal(req, subIndex, sub, match) {
   };
 
   document.getElementById('confirm-sub-name').textContent = sub.name;
-  document.getElementById('confirm-sub-dates').innerHTML = requestDates.length
-    ? requestDates.map(d => {
-        const label = new Date(d + 'T12:00:00').toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
-        return `<label style="display:flex; align-items:center; gap:6px; font-size:13px; cursor:pointer;"><input type="checkbox" class="confirm-sub-date" value="${escapeHtml(d)}" ${preticked.has(d) ? 'checked' : ''}> ${escapeHtml(label)}</label>`;
-      }).join('')
-    : '<span style="font-size:13px; color:var(--text-medium);">no dates on this request</span>';
+  // Built with DOM properties, not an HTML string: the dates come from the request document, which its requester
+  // can write, and escapeHtml() does not encode quotes, so it is not safe inside an attribute.
+  const datesBox = document.getElementById('confirm-sub-dates');
+  datesBox.textContent = '';
+  if (!requestDates.length) {
+    const none = document.createElement('span');
+    none.style.cssText = 'font-size:13px; color:var(--text-medium);';
+    none.textContent = 'no dates on this request';
+    datesBox.appendChild(none);
+  }
+  requestDates.forEach(d => {
+    const row = document.createElement('label');
+    row.style.cssText = 'display:flex; align-items:center; gap:6px; font-size:13px; cursor:pointer;';
+    const box = document.createElement('input');
+    box.type = 'checkbox';
+    box.className = 'confirm-sub-date';
+    box.value = d;
+    box.checked = preticked.has(d);
+    row.appendChild(box);
+    row.appendChild(document.createTextNode(' ' + new Date(d + 'T12:00:00').toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })));
+    datesBox.appendChild(row);
+  });
   document.querySelector('input[name="confirm-sub-mode"][value="full"]').checked = true;
   document.getElementById('confirm-sub-custom-times').classList.add('hidden');
   document.getElementById('confirm-sub-start').value = '';
@@ -8030,7 +8050,11 @@ function openConfirmSubModal(req, subIndex, sub, match) {
 
 // The one way the confirm box closes (× and Cancel both call this): the context goes with it, so nothing from
 // this request can be submitted later or leak into the next one opened.
-function closeConfirmSubModal() {
+function closeConfirmSubModal(force) {
+  if (_confirmSubBusy && !force) {
+    alert('Still saving this confirmation — it can\'t be cancelled part-way. The box closes when it finishes.');
+    return;
+  }
   document.getElementById('confirm-sub-modal').classList.remove('open');
   _confirmSubCtx = null;
 }
@@ -8073,6 +8097,7 @@ async function submitConfirmSub() {
 
   const btn = document.getElementById('confirm-sub-submit-btn');
   if (btn) { btn.disabled = true; btn.textContent = 'Confirming...'; }
+  _confirmSubBusy = true;
 
   try {
     const [requesterSchedule, subSchedule] = await Promise.all([
@@ -8097,7 +8122,8 @@ async function submitConfirmSub() {
     }
 
     if (!Object.keys(overridesToWrite).length) {
-      alert('Could not determine a shift time to write for any covered date — the requester may have no normal recurring shift then. Add the sub’s shift manually.');
+      const labels = noShiftDates.map(ds => new Date(ds + 'T12:00:00').toLocaleDateString('en-US', { month: 'short', day: 'numeric' })).join(', ');
+      alert(`No normal shift to copy on ${labels}, so nothing was written and ${ctx.subName} is not confirmed. Choose Custom times and try again.`);
       return;
     }
 
@@ -8181,11 +8207,13 @@ async function submitConfirmSub() {
         : ` Your schedule write for ${Object.keys(rollBack).sort().join(', ')} could NOT be rolled back (${why}) and may still be on ${ctx.subName}'s schedule — please check it by hand.`;
       const differs = mismatch.length ? ` For ${mismatch.sort().join(', ')} the times you entered differ from theirs (or could not be compared) and the schedule may show yours — check ${ctx.subName}'s schedule for those dates and correct it by hand if needed.` : '';
       alert(`${lead}${rolled}${differs} Please refresh.`);
+      // The box's checkboxes describe dates the request no longer has, so a retry could never pass: close it.
+      if (result.field === 'dates') closeConfirmSubModal(true);
       if (!rb.ok || mismatch.length) console.error('Sub confirm rollback:', { rb, mismatch, subUid: ctx.subUid, appliedOverrides, theirs });
       return;
     }
 
-    closeConfirmSubModal();
+    closeConfirmSubModal(true);
     allTimeoffRequests = await getAllTimeOffRequests();
     renderAdminAllTimeOff();
     openTimeOffDetail(ctx.requestId);
@@ -8213,12 +8241,13 @@ async function submitConfirmSub() {
     });
     if (noShiftDates.length) {
       const labels = noShiftDates.map(ds => new Date(ds + 'T12:00:00').toLocaleDateString('en-US', { month: 'short', day: 'numeric' })).join(', ');
-      alert(`No normal shift to copy on ${labels}, so nothing was written for ${noShiftDates.length === 1 ? 'it' : 'them'}. Use custom times, or add ${noShiftDates.length === 1 ? 'it' : 'them'} to ${ctx.subName}'s schedule by hand.`);
+      alert(`No normal shift to copy on ${labels}, so nothing was written for ${noShiftDates.length === 1 ? 'it' : 'them'}. Add ${noShiftDates.length === 1 ? 'it' : 'them'} to ${ctx.subName}'s schedule by hand, or Undo and confirm again with Custom times.`);
     }
   } catch (err) {
     console.error('Failed to confirm sub:', err);
     alert('Something went wrong confirming this sub.');
   } finally {
+    _confirmSubBusy = false;
     if (btn) { btn.disabled = false; btn.textContent = 'Confirm & Add to Schedule'; }
   }
 }
@@ -8370,11 +8399,51 @@ async function reverseConfirmedTimeOffSubs(requestId, proposedSubs, onlyIndexes)
 
 // ─── Coverage Status Update ─────────────────────────
 
+// The dropdown is a LABEL: it writes no shift and sends no email — Mark Confirmed does. So picking "Secured"
+// while a sub is still unconfirmed warns first, naming them (plan: ticker-sub-confirm-only-by-manager,
+// Phase 3). The request is read fresh (the in-memory list can be hours old), and the label is written only if
+// the subs are still exactly what the warning was decided on. Every exit re-renders the detail: the select's
+// value already changed when onchange fired, and must never show a value that was not saved.
 async function updateCoverageStatus(requestId, status) {
-  await updateTimeOffRequest(requestId, { coverageStatus: status });
+  let result;
+  if (status === 'secured') {
+    const read = await getTimeOffRequestResult(requestId);
+    if (read.ok && !read.exists) {
+      alert('This request no longer exists.');
+      openTimeOffDetail(requestId);
+      return;
+    }
+    if (!read.ok) {
+      if (!confirm('Couldn\'t check the subs on this request. Mark coverage Secured anyway?')) { openTimeOffDetail(requestId); return; }
+      result = { success: await updateTimeOffRequest(requestId, { coverageStatus: status }) };
+    } else {
+      const names = unconfirmedSubNames(read.data.proposedSubs);
+      if (names.length) {
+        const one = names.length === 1;
+        const who = one ? names[0] : `${names.slice(0, -1).join(', ')} and ${names[names.length - 1]}`;
+        if (!confirm(`${who} ${one ? 'isn\'t' : 'aren\'t'} confirmed yet, so nothing has been added to their schedule and they haven't been emailed. Use Mark Confirmed next to ${one ? 'their name' : 'each name'} to do that.\n\nMark coverage Secured anyway?`)) {
+          openTimeOffDetail(requestId);
+          return;
+        }
+      }
+      // `approved` may auto-complete while the box is open — the same tolerance as the edit save.
+      const statuses = read.data.status === 'approved' ? ['approved', 'completed'] : [read.data.status];
+      result = await updateTimeOffRequestIfStatus(requestId, statuses, { coverageStatus: status },
+        { proposedSubs: read.data.proposedSubs === undefined ? null : read.data.proposedSubs });
+    }
+  } else {
+    result = { success: await updateTimeOffRequest(requestId, { coverageStatus: status }) };
+  }
+  if (!result.success) {
+    alert(result.reason === 'changed' ? 'The subs on this request changed while you were choosing, so nothing was saved.'
+      : result.reason === 'status-changed' ? 'This request\'s status changed, so nothing was saved.'
+      : result.reason === 'not-found' ? 'This request no longer exists.'
+      : 'Could not update coverage. Please try again.');
+    openTimeOffDetail(requestId);
+    return;
+  }
   allTimeoffRequests = await getAllTimeOffRequests();
   renderAdminAllTimeOff();
-  renderAdminAllTimeOff();
   openTimeOffDetail(requestId);
   showToast('Coverage updated');
 }
diff --git a/js/schedule-helpers.js b/js/schedule-helpers.js
index bfa4f68..0d4f85f 100644
--- a/js/schedule-helpers.js
+++ b/js/schedule-helpers.js
@@ -212,6 +212,12 @@ function getSubCoverageDates(sub, requestDates) {
   return sub.dates.filter(d => allDates.includes(d));
 }
 
+// The proposed subs a manager has not confirmed yet, by name — what the "Coverage: Secured" warning names
+// (plan: ticker-sub-confirm-only-by-manager, Phase 3). Secured is only a label; it writes no shift and sends no email.
+function unconfirmedSubNames(proposedSubs) {
+  return (Array.isArray(proposedSubs) ? proposedSubs : []).filter(s => s && !s.confirmed).map(s => s.name);
+}
+
 // Which of the request's dates the confirm box ticks to begin with (D2, plan: ticker-sub-confirm-only-by-manager).
 // The sub's own proposed dates where they still line up with the request; if none do — the sub was added
 // before the date was picked, or the date moved since (Ivy's request, Sep 29) — every date, so the manager
@@ -1601,6 +1607,7 @@ if (typeof module !== 'undefined' && module.exports) {
     applyScheduleEdits,
     isRealDate,
     carryConfirmedSubs,
+    unconfirmedSubNames,
     confirmDatePreticks,
     normalizeRequestDates,
     checkEditAgainstDocument,
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index b0cbc73..eb586ec 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2304,11 +2304,15 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
   const html = fs.readFileSync(`${__dirname}/index.html`, 'utf8');
   const data = fs.readFileSync(`${__dirname}/js/firebase-data.js`, 'utf8');
 
-  test('the box renders one checkbox per request date, pre-ticked by confirmDatePreticks, labels escaped', () => {
-    const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'function closeConfirmSubModal()');
+  test('the box renders one checkbox per request date, pre-ticked by confirmDatePreticks, built with DOM properties', () => {
+    const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'function closeConfirmSubModal(');
     expect(open).toMatch(/const preticked = new Set\(confirmDatePreticks\(sub, requestDates\)\);/);
     expect(open).toMatch(/requestDatesSnapshot: normalizeRequestDates\(req\.dates\),/);
-    expect(open).toMatch(/<input type="checkbox" class="confirm-sub-date" value="\$\{escapeHtml\(d\)\}" \$\{preticked\.has\(d\) \? 'checked' : ''\}> \$\{escapeHtml\(label\)\}/);
+    // the dates are requester-writable and escapeHtml() does not encode quotes: never an HTML string here
+    expect(open).toMatch(/box\.value = d;\s*box\.checked = preticked\.has\(d\);/);
+    expect(open).toMatch(/document\.createTextNode\(/);
+    expect(open).not.toMatch(/innerHTML/);
+    expect(open).not.toMatch(/value="\$\{/);
     expect(html).toMatch(/<div id="confirm-sub-dates"/);
     expect(html).not.toMatch(/<span id="confirm-sub-dates">/);
   });
@@ -2346,7 +2350,7 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
   });
 
   test('× and Cancel both close through closeConfirmSubModal, which drops the context; submit needs the box open', () => {
-    expect(src).toMatch(/function closeConfirmSubModal\(\) \{\s*document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
+    expect(src).toMatch(/function closeConfirmSubModal\(force\) \{\s*if \(_confirmSubBusy && !force\) \{[\s\S]*?return;\s*\}\s*document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
     const box = html.slice(html.indexOf('<div id="confirm-sub-modal"'), html.indexOf('</div>\n</div>', html.indexOf('<div id="confirm-sub-modal"')));
     expect((box.match(/onclick="closeConfirmSubModal\(\)"/g) || []).length).toBe(2);
     expect(box).not.toMatch(/classList\.remove\('open'\)/);
@@ -2354,6 +2358,20 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(submit).toMatch(/if \(!ctx \|\| !modal \|\| !modal\.classList\.contains\('open'\)\) return;/);
   });
 
+  test('while a confirm is writing, × / Cancel cannot close the box and another cannot open (no cancel-that-confirms-anyway)', () => {
+    const submit = slice('async function submitConfirmSub()', 'function isManagerUser()');
+    const busyOn = submit.indexOf('_confirmSubBusy = true;');
+    const tryAt = submit.indexOf('try {', busyOn);
+    expect(busyOn).toBeGreaterThan(submit.indexOf("btn.textContent = 'Confirming...'"));
+    expect(tryAt).toBeGreaterThan(busyOn);
+    expect(submit.slice(busyOn, tryAt)).not.toMatch(/return/);   // nothing between can leave it stuck on
+    expect(submit).toMatch(/\} finally \{\s*_confirmSubBusy = false;/);
+    expect(submit).toMatch(/closeConfirmSubModal\(true\);\s*allTimeoffRequests = await getAllTimeOffRequests\(\);/);   // success forces the close
+    expect(submit).toMatch(/if \(result\.field === 'dates'\) closeConfirmSubModal\(true\);/);   // a stale box cannot be retried
+    const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'const requestDates =');
+    expect(open).toMatch(/if \(_confirmSubBusy\) return;/);
+  });
+
   test('the emulator test\'s mirrored helpers are verbatim copies of js/schedule-helpers.js', () => {
     const helpers = fs.readFileSync(`${__dirname}/js/schedule-helpers.js`, 'utf8');
     const mirror = fs.readFileSync(`${__dirname}/timeoff-sub-confirm.emulator.test.js`, 'utf8');
@@ -2365,3 +2383,37 @@ describe('the confirm box: the manager picks from the request\'s real dates, and
     expect(mirror).toMatch(/if \(want\.dates !== undefined && !sameStructure\(normalizeRequestDates\(data\.dates\), want\.dates\)\) return \{ success: false, reason: 'changed', field: 'dates' \};/);
   });
 });
+
+// ─── Phase 3: "Coverage: Secured" warns while a sub is unconfirmed ───────────────────────────────────────
+describe('"Coverage: Secured" is a label, so it warns while a sub is unconfirmed', () => {
+  const fn = src.slice(src.indexOf('async function updateCoverageStatus(requestId, status)'), src.indexOf('// ─── Status Actions'));
+
+  test('Secured reads the request FRESH and names the unconfirmed subs', () => {
+    expect(fn).toMatch(/if \(status === 'secured'\) \{\s*const read = await getTimeOffRequestResult\(requestId\);/);
+    expect(fn).toMatch(/const names = unconfirmedSubNames\(read\.data\.proposedSubs\);/);
+    expect(fn).not.toMatch(/allTimeoffRequests\.find/);   // never the in-memory list, which can be hours old
+  });
+
+  test('every Cancel / refusal re-renders the detail BEFORE returning (the select already shows the unsaved value)', () => {
+    // warning cancelled
+    expect(fn).toMatch(/Mark coverage Secured anyway\?`\)\) \{\s*openTimeOffDetail\(requestId\);\s*return;\s*\}/);
+    // failed read, cancelled
+    expect(fn).toMatch(/Mark coverage Secured anyway\?'\)\) \{ openTimeOffDetail\(requestId\); return; \}/);
+    // request gone
+    expect(fn).toMatch(/if \(read\.ok && !read\.exists\) \{\s*alert\('This request no longer exists\.'\);\s*openTimeOffDetail\(requestId\);\s*return;\s*\}/);
+    // write refused or failed: an error, a re-render, and NO success toast
+    expect(fn).toMatch(/if \(!result\.success\) \{\s*alert\([\s\S]*?\);\s*openTimeOffDetail\(requestId\);\s*return;\s*\}/);
+    expect(fn.indexOf("showToast('Coverage updated')")).toBeGreaterThan(fn.indexOf('if (!result.success) {'));
+  });
+
+  test('the Secured write is guarded on the exact subs the warning was decided on, tolerating an auto-complete', () => {
+    expect(fn).toMatch(/const statuses = read\.data\.status === 'approved' \? \['approved', 'completed'\] : \[read\.data\.status\];/);
+    expect(fn).toMatch(/result = await updateTimeOffRequestIfStatus\(requestId, statuses, \{ coverageStatus: status \},\s*\{ proposedSubs: read\.data\.proposedSubs === undefined \? null : read\.data\.proposedSubs \}\);/);
+    expect(fn).toMatch(/result\.reason === 'changed' \? 'The subs on this request changed while you were choosing, so nothing was saved\.'/);
+  });
+
+  test('other statuses are written as before, and the duplicate list render is gone', () => {
+    expect(fn).toMatch(/\} else \{\s*result = \{ success: await updateTimeOffRequest\(requestId, \{ coverageStatus: status \}\) \};\s*\}/);
+    expect((fn.match(/renderAdminAllTimeOff\(\);/g) || []).length).toBe(1);
+  });
+});
diff --git a/schedule-helpers.test.js b/schedule-helpers.test.js
index 141ae6d..2614cd5 100644
--- a/schedule-helpers.test.js
+++ b/schedule-helpers.test.js
@@ -29,6 +29,7 @@ const {
   applyScheduleEdits,
   isRealDate,
   carryConfirmedSubs,
+  unconfirmedSubNames,
   confirmDatePreticks,
   normalizeRequestDates,
   checkEditAgainstDocument,
@@ -3081,3 +3082,14 @@ describe('confirmDatePreticks — which dates the confirm box ticks to begin wit
     expect(getSubCoverageDates({ dates: [] }, REQ)).toEqual([]);
   });
 });
+
+describe('unconfirmedSubNames — who the "Coverage: Secured" warning names', () => {
+  test('only the unconfirmed subs, in order', () => {
+    expect(unconfirmedSubNames([{ name: 'Sam', confirmed: false }, { name: 'Kayleigh', confirmed: true }, { name: 'Alex' }])).toEqual(['Sam', 'Alex']);
+  });
+  test('no subs, all confirmed, or a missing list → nobody (no warning)', () => {
+    expect(unconfirmedSubNames([])).toEqual([]);
+    expect(unconfirmedSubNames([{ name: 'Sam', confirmed: true }])).toEqual([]);
+    expect(unconfirmedSubNames(undefined)).toEqual([]);
+  });
+});
diff --git a/timeoff-sub-confirm.emulator.test.js b/timeoff-sub-confirm.emulator.test.js
index db9559b..b75b397 100644
--- a/timeoff-sub-confirm.emulator.test.js
+++ b/timeoff-sub-confirm.emulator.test.js
@@ -324,4 +324,12 @@ describe('confirmTimeOffSub dates guard', () => {
     expect(r.reason).toBe('sub-changed');
     expect(r.field).not.toBe('dates');
   });
+
+  test('guard ORDER: dates moved AND the sub was confirmed with no record (the unmatched-name path) → the confirmed guard wins', async () => {
+    // {confirmed: true} with no subUid and no record walks past the appliedOverrides and subUid guards, so only
+    // the order of the confirmed and dates checks decides the answer (Phase 2 review: the case above cannot).
+    await seed([{ date: '2026-10-04', type: 'full' }], { confirmed: true });
+    const r = await confirm(normalizeRequestDates(OCT3));
+    expect(r).toEqual({ success: false, reason: 'sub-changed', field: 'confirmed' });
+  });
 });
