## Implementation review — Phase 2 of ticker-sub-confirm-only-by-manager (+ the Phase 1 follow-up commit)
Plan (the spec): /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html — read
"Phase 2" in full, and the Phase 1 section for context. Phase 1 was reviewed at e7e11d6
(reviews: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-impl-phase1-{claude,codex}.md).
Repo: /Users/christiehubley/tinker-timeclock, branch fix/sub-confirm-manager-only. Diff below covers TWO commits:
2f0d2b6 (fixes applied from the Phase 1 review — review these as new code) and 7e7ebba (Phase 2).
READ-ONLY for you: no edits, no tests that write, no deploys. You may read any file.

## What to check
- 2f0d2b6: did each fix do what it claims, and did it introduce anything new (the try/catch + !exists refusals, the
  neutral wording, editRefusalMessage's new parameter, the re-confirm notice)?
- 7e7ebba vs Phase 2 spec: every deviation, omission, or overreach.
- Bugs: wrong schedule write (dates the manager unticked, dates from a stale box), a colleague's shift deleted by the
  rollback, false confirmation, a refusal that leaves the Confirm button disabled, a message that states something false,
  XSS in the checkbox labels/values.
- Trace submitConfirmSub end-to-end for: all dates ticked; one unticked; none ticked; a ticked date with no normal shift
  (full mode) + another that works; all ticked dates without a normal shift; the overwrite prompt cancelled; the request's
  dates moved while the box was open (full rollback + new lead); dates moved AND a colleague confirmed (must be sub-changed →
  partitionRollback); the fresh re-read failing in the sub-changed branch (the fixed ${dates} message); Cancel/× then reopen
  for another request; a stale call to submitConfirmSub with the box closed.
- confirmTimeOffSub: the dates guard's position, and that its other five callers are unaffected.
- Is the emulator mirror really verbatim and is the new wiring comparison sound (would it catch drift)?
- Firebase invariants: no undefined written; guarded writes; awaited writes.
- Are the new tests real (would they fail on a broken implementation)?
- Rank BLOCKING / MEDIUM / LOW with file:line. End with: Phase 2 OK to build on — yes/no.

## Diff (git diff e7e11d6 7e7ebba)
diff --git a/index.html b/index.html
index 5edf10e..d8ae094 100644
--- a/index.html
+++ b/index.html
@@ -708,7 +708,7 @@
         <!-- Coverage -->
         <div style="margin-bottom:16px;">
           <label style="font-size:13px; font-weight:700; display:block; margin-bottom:6px;">Coverage</label>
-          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub and adds the shift to their schedule.</p>
+          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub (and, for anyone signed in to Ticker, adds the shift to their schedule).</p>
           <div id="timeoff-subs-list"></div>
           <select id="timeoff-sub-picker" style="width:100%; padding:8px 10px; border:1px solid var(--border-light); border-radius:6px; font-family:inherit; font-size:13px; background:var(--bg-white); margin-bottom:8px;">
             <option value="">Add a coworker for coverage...</option>
@@ -1180,10 +1180,11 @@
   <div class="simple-modal" style="max-width:420px;">
     <div class="simple-modal-header">
       <h3>Confirm <span id="confirm-sub-name"></span></h3>
-      <button class="simple-modal-close" onclick="document.getElementById('confirm-sub-modal').classList.remove('open')">&times;</button>
+      <button class="simple-modal-close" onclick="closeConfirmSubModal()">&times;</button>
     </div>
     <div class="simple-modal-body">
-      <p style="font-size:13px; color:var(--text-medium); margin-bottom:12px;">Covering: <span id="confirm-sub-dates"></span></p>
+      <p style="font-size:13px; color:var(--text-medium); margin-bottom:6px;">Covering (untick any day they aren't covering):</p>
+      <div id="confirm-sub-dates" style="display:flex; flex-direction:column; gap:4px; margin-bottom:12px;"></div>
       <label style="display:flex; align-items:center; gap:6px; font-size:13px; margin-bottom:8px; cursor:pointer;">
         <input type="radio" name="confirm-sub-mode" value="full" checked onchange="toggleConfirmSubTimeMode()">
         Full shift (matches the requester's normal hours)
@@ -1198,7 +1199,7 @@
       </div>
       <div style="display:flex; gap:8px;">
         <button id="confirm-sub-submit-btn" class="btn btn-secondary btn-full" onclick="submitConfirmSub()">Confirm &amp; Add to Schedule</button>
-        <button class="btn btn-full" style="background:transparent; border:1px solid var(--border-light); color:var(--text-medium);" onclick="document.getElementById('confirm-sub-modal').classList.remove('open')">Cancel</button>
+        <button class="btn btn-full" style="background:transparent; border:1px solid var(--border-light); color:var(--text-medium);" onclick="closeConfirmSubModal()">Cancel</button>
       </div>
     </div>
   </div>
diff --git a/js/app.js b/js/app.js
index ff87faf..dde1e32 100644
--- a/js/app.js
+++ b/js/app.js
@@ -7359,10 +7359,10 @@ function renderTimeOffSubs() {
 
 // What to say when an edit's FIRST check (before anything is written) refuses the save. Nothing has
 // changed yet, so each reason can say so. `formSubs` names any confirmed sub the edit also removed.
-function editRefusalMessage(check, formSubs) {
+function editRefusalMessage(check, formSubs, opened) {
   const list = (names) => names.length <= 1 ? (names[0] || '') : `${names.slice(0, -1).join(', ')} and ${names[names.length - 1]}`;
   if (check.reason === 'subs-changed') {
-    return `A manager confirmed or un-confirmed ${list(check.names)} while you were editing, so nothing was saved or changed. Close this form, reopen the request, and try again.`;
+    return `${list(check.names)} ${check.names.length === 1 ? 'was' : 'were'} confirmed, un-confirmed or removed by someone else while you were editing, so nothing was saved or changed. Close this form, reopen the request, and try again.`;
   }
   if (check.reason === 'dates-changed-elsewhere') {
     return 'This request\'s dates were changed by someone else while you were editing, so nothing was saved or changed. Close this form and reopen the request.';
@@ -7371,7 +7371,7 @@ function editRefusalMessage(check, formSubs) {
   const who = list(check.names);
   const one = check.names.length === 1;
   const inForm = new Set((formSubs || []).map(s => s.name));
-  const removed = Object.keys(openedSubs || {}).filter(n => openedSubs[n].confirmed && !inForm.has(n));
+  const removed = Object.keys(opened || {}).filter(n => opened[n].confirmed && !inForm.has(n));
   const removeNote = removed.length ? ` To remove ${list(removed)}, save that change on its own first.` : '';
   return `${who} ${one ? 'is' : 'are'} confirmed to cover this request. ${who} ${one ? 'has' : 'have'} to be un-confirmed (Undo, by a manager if their shift is on their schedule) before the dates can change. Nothing was saved or changed.${removeNote}`;
 }
@@ -7459,7 +7459,20 @@ async function handleSubmitTimeOff() {
   const giveBack = () => { btn.disabled = false; btn.textContent = editingTimeOffId ? 'Save Changes' : 'Submit Request'; };
   if (editingTimeOffId) {
     // If editing an approved/completed/denied request, reset to under_review and undo overrides
-    const existingDoc = await getDb().collection('timeclock_timeoff').doc(editingTimeOffId).get();
+    let existingDoc;
+    try {
+      existingDoc = await getDb().collection('timeclock_timeoff').doc(editingTimeOffId).get();
+    } catch (err) {
+      console.error('Failed to read the request before saving:', err);
+      giveBack();
+      alert('Could not read this request, so nothing was saved. Please try again.');
+      return;
+    }
+    if (!existingDoc.exists) {
+      giveBack();
+      alert('This request no longer exists, so your edits were not saved.');
+      return;
+    }
     if (existingDoc.exists) {
       const existingData = existingDoc.data();
       const requesterRecord = existingData.appliedOverrides === undefined ? null : existingData.appliedOverrides;
@@ -7508,7 +7521,7 @@ async function handleSubmitTimeOff() {
         const first = checkEditAgainstDocument({ openedSubs, openedDates, formSubs: formData.proposedSubs, formDates: formData.dates, docSubs: existingData.proposedSubs, docDates: existingData.dates });
         if (!first.ok) {
           giveBack();
-          alert(editRefusalMessage(first, formData.proposedSubs));
+          alert(editRefusalMessage(first, formData.proposedSubs, openedSubs));
           return;
         }
         const { subs, toReverse } = reconcileEditedProposedSubs(formData.proposedSubs, existingData.proposedSubs);
@@ -7593,7 +7606,8 @@ async function handleSubmitTimeOff() {
     allTimeoffRequests = await getAllTimeOffRequests();
     await renderTimeOffTab();
     if (reconfirmedNames.length) {
-      alert(`Saved. ${reconfirmedNames.join(', ')} ${reconfirmedNames.length === 1 ? 'was' : 'were'} re-confirmed by a manager while you were editing, so they stay on this request.`);
+      const who = reconfirmedNames.length === 1 ? reconfirmedNames[0] : `${reconfirmedNames.slice(0, -1).join(', ')} and ${reconfirmedNames[reconfirmedNames.length - 1]}`;
+      alert(`Saved. ${who} ${reconfirmedNames.length === 1 ? 'was' : 'were'} re-confirmed by a manager while you were editing, so ${who} ${reconfirmedNames.length === 1 ? 'stays' : 'stay'} on this request.`);
     } else {
       showToast('Request saved');
     }
@@ -7978,13 +7992,19 @@ async function handleSubConfirmToggle(requestId, subIndex) {
 }
 
 function openConfirmSubModal(req, subIndex, sub, match) {
-  const dates = getSubCoverageDates(sub, (req.dates || []).map(d => d.date));
+  // D2: the manager picks the dates from the request's REAL dates. Pre-ticked from the sub's own proposed dates,
+  // or all of them when those no longer line up (Ivy's "no covered dates", Sep 29).
+  const requestDates = (req.dates || []).map(d => d.date).filter(Boolean);
+  const preticked = new Set(confirmDatePreticks(sub, requestDates));
   _confirmSubCtx = {
     requestId: req.id,
     subIndex,
     subName: sub.name,
     subEmail: sub.email || '',
-    dates,
+    requestDates,
+    // What the checkboxes were built from; the confirm transaction refuses if the request's dates move meanwhile.
+    requestDatesSnapshot: normalizeRequestDates(req.dates),
+    dates: [],   // set from the ticked boxes at submit
     requesterUid: req.uid,
     requesterName: req.name,
     requesterEmail: req.email || '',
@@ -7995,12 +8015,12 @@ function openConfirmSubModal(req, subIndex, sub, match) {
   };
 
   document.getElementById('confirm-sub-name').textContent = sub.name;
-  document.getElementById('confirm-sub-dates').textContent = dates.length
-    ? dates.map(d => {
-        const dt = new Date(d + 'T12:00:00');
-        return dt.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
-      }).join(', ')
-    : 'no dates on this request';
+  document.getElementById('confirm-sub-dates').innerHTML = requestDates.length
+    ? requestDates.map(d => {
+        const label = new Date(d + 'T12:00:00').toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
+        return `<label style="display:flex; align-items:center; gap:6px; font-size:13px; cursor:pointer;"><input type="checkbox" class="confirm-sub-date" value="${escapeHtml(d)}" ${preticked.has(d) ? 'checked' : ''}> ${escapeHtml(label)}</label>`;
+      }).join('')
+    : '<span style="font-size:13px; color:var(--text-medium);">no dates on this request</span>';
   document.querySelector('input[name="confirm-sub-mode"][value="full"]').checked = true;
   document.getElementById('confirm-sub-custom-times').classList.add('hidden');
   document.getElementById('confirm-sub-start').value = '';
@@ -8008,6 +8028,13 @@ function openConfirmSubModal(req, subIndex, sub, match) {
   document.getElementById('confirm-sub-modal').classList.add('open');
 }
 
+// The one way the confirm box closes (× and Cancel both call this): the context goes with it, so nothing from
+// this request can be submitted later or leak into the next one opened.
+function closeConfirmSubModal() {
+  document.getElementById('confirm-sub-modal').classList.remove('open');
+  _confirmSubCtx = null;
+}
+
 function toggleConfirmSubTimeMode() {
   const checked = document.querySelector('input[name="confirm-sub-mode"]:checked');
   const mode = checked ? checked.value : 'full';
@@ -8020,7 +8047,8 @@ async function submitConfirmSub() {
     return;
   }
   const ctx = _confirmSubCtx;
-  if (!ctx) return;
+  const modal = document.getElementById('confirm-sub-modal');
+  if (!ctx || !modal || !modal.classList.contains('open')) return;
 
   const modeInput = document.querySelector('input[name="confirm-sub-mode"]:checked');
   const mode = modeInput ? modeInput.value : 'full';
@@ -8031,8 +8059,15 @@ async function submitConfirmSub() {
     alert('Please enter both a start and end time.');
     return;
   }
+  if (!ctx.requestDates.length) {
+    alert('This sub has no covered dates to write a shift for.');   // the request itself has no dates (legacy/hand-edited)
+    return;
+  }
+  // D2: exactly the ticked dates, before anything below reads them — conflicts, the payload, the record, the
+  // email and the reminder dates all derive from ctx.dates.
+  ctx.dates = Array.from(document.querySelectorAll('#confirm-sub-dates input.confirm-sub-date:checked')).map(i => i.value);
   if (!ctx.dates.length) {
-    alert('This sub has no covered dates to write a shift for.');
+    alert('Tick at least one date to confirm.');
     return;
   }
 
@@ -8047,12 +8082,13 @@ async function submitConfirmSub() {
 
     const overridesToWrite = {};
     const conflictDates = [];
+    const noShiftDates = [];   // ticked, but full-shift mode found no normal shift to copy — named afterwards
     for (const dateStr of ctx.dates) {
       const dt = new Date(dateStr + 'T12:00:00');
       const dayKey = DAYS[(dt.getDay() + 6) % 7];
       const requesterRecurringShift = getNormalRecurringShift(requesterSchedule, dateStr, dayKey);
       const override = buildSubScheduleOverride({ mode, customStart, customEnd, requesterRecurringShift, requesterName: ctx.requesterName, subUid: ctx.subUid });
-      if (!override) continue; // e.g. full-shift mode but the requester has no recurring shift that day
+      if (!override) { noShiftDates.push(dateStr); continue; } // e.g. full-shift mode but the requester has no recurring shift that day
 
       const existingShift = subSchedule ? getShiftForDate(subSchedule, dateStr, dayKey) : null;
       if (existingShift) conflictDates.push(dateStr);
@@ -8106,7 +8142,7 @@ async function submitConfirmSub() {
       confirmed: true,
       subUid: ctx.subUid,
       appliedOverrides,
-    }, {}, { confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES });
+    }, {}, { confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES, dates: ctx.requestDatesSnapshot });
 
     if (!result.success) {
       // The schedule write already landed but the request doc update was refused or failed. Roll the
@@ -8123,7 +8159,7 @@ async function submitConfirmSub() {
         if (!fresh.ok) {
           // Cannot tell whether someone else now owns this sub's schedule — a blind rollback here is exactly
           // the deletion this branch exists to prevent (review finding). Leave the schedule; say so.
-          alert(`Could not confirm — this request may have changed — and it could not be re-read to decide safely, so nothing was rolled back. Your shift write for ${dates} may still be on ${ctx.subName}'s schedule; please refresh, then check it by hand.`);
+          alert(`Could not confirm — this request may have changed — and it could not be re-read to decide safely, so nothing was rolled back. Your shift write for ${Object.keys(appliedOverrides).sort().join(', ')} may still be on ${ctx.subName}'s schedule; please refresh, then check it by hand.`);
           console.error('Sub confirm: re-read failed after a refused write; nothing rolled back', { subUid: ctx.subUid, appliedOverrides });
           return;
         }
@@ -8137,7 +8173,9 @@ async function submitConfirmSub() {
       const why = rb.reason === 'schedule-read-failed' ? 'their schedule could not be read' : rb.reason === 'schedule-missing' ? 'their schedule document could not be found' : 'their schedule could not be updated';
       const lead = theirs
         ? `${ctx.subName} was confirmed by someone else while this dialog was open, so your confirmation was not recorded; theirs stands.`
-        : 'Could not confirm — this request may have changed.';
+        : result.field === 'dates'
+          ? 'This request\'s dates changed while the box was open, so nothing was confirmed.'
+          : 'Could not confirm — this request may have changed.';
       const rolled = !Object.keys(rollBack).length ? ''
         : rb.ok ? ` Your schedule write for ${Object.keys(rollBack).sort().join(', ')} was rolled back${skippedDatesNote(rb)}.`
         : ` Your schedule write for ${Object.keys(rollBack).sort().join(', ')} could NOT be rolled back (${why}) and may still be on ${ctx.subName}'s schedule — please check it by hand.`;
@@ -8147,8 +8185,7 @@ async function submitConfirmSub() {
       return;
     }
 
-    document.getElementById('confirm-sub-modal').classList.remove('open');
-    _confirmSubCtx = null;
+    closeConfirmSubModal();
     allTimeoffRequests = await getAllTimeOffRequests();
     renderAdminAllTimeOff();
     openTimeOffDetail(ctx.requestId);
@@ -8174,6 +8211,10 @@ async function submitConfirmSub() {
       subPlanDelivery: ctx.subPlanDelivery,
       subPlanNotes: ctx.subPlanNotes,
     });
+    if (noShiftDates.length) {
+      const labels = noShiftDates.map(ds => new Date(ds + 'T12:00:00').toLocaleDateString('en-US', { month: 'short', day: 'numeric' })).join(', ');
+      alert(`No normal shift to copy on ${labels}, so nothing was written for ${noShiftDates.length === 1 ? 'it' : 'them'}. Use custom times, or add ${noShiftDates.length === 1 ? 'it' : 'them'} to ${ctx.subName}'s schedule by hand.`);
+    }
   } catch (err) {
     console.error('Failed to confirm sub:', err);
     alert('Something went wrong confirming this sub.');
diff --git a/js/firebase-data.js b/js/firebase-data.js
index 465492d..79fefe8 100644
--- a/js/firebase-data.js
+++ b/js/firebase-data.js
@@ -801,6 +801,11 @@ async function confirmTimeOffSub(requestId, subIndex, expectedSubName, patch, ex
       if (want.reversalPending !== undefined && !!data.reversalPending !== want.reversalPending) return { success: false, reason: 'changed', field: 'reversalPending' };
       if (want.subUid !== undefined && (subs[subIndex].subUid || null) !== (want.subUid || null)) return { success: false, reason: 'sub-changed', field: 'subUid' };
       if (want.confirmed !== undefined && !!subs[subIndex].confirmed !== want.confirmed) return { success: false, reason: 'sub-changed', field: 'confirmed' };
+      // `dates` (optional, plan: ticker-sub-confirm-only-by-manager): the request's dates the confirm box was built
+      // from, normalized. AFTER the confirmed/subUid checks on purpose: if someone else confirmed this sub AND the
+      // dates moved, the caller must see 'sub-changed' — that path partitions the rollback and keeps their shift;
+      // a 'dates' refusal rolls ours back whole, which could delete a colleague's confirmed coverage.
+      if (want.dates !== undefined && !sameStructure(normalizeRequestDates(data.dates), want.dates)) return { success: false, reason: 'changed', field: 'dates' };
       subs[subIndex] = { ...subs[subIndex], ...patch };
       const allConfirmed = subs.every(s => s.confirmed);
       const someConfirmed = subs.some(s => s.confirmed);
diff --git a/js/schedule-helpers.js b/js/schedule-helpers.js
index bc7c38e..bfa4f68 100644
--- a/js/schedule-helpers.js
+++ b/js/schedule-helpers.js
@@ -212,6 +212,15 @@ function getSubCoverageDates(sub, requestDates) {
   return sub.dates.filter(d => allDates.includes(d));
 }
 
+// Which of the request's dates the confirm box ticks to begin with (D2, plan: ticker-sub-confirm-only-by-manager).
+// The sub's own proposed dates where they still line up with the request; if none do — the sub was added
+// before the date was picked, or the date moved since (Ivy's request, Sep 29) — every date, so the manager
+// sees the request's real dates rather than "no covered dates". The manager can untick any of them.
+function confirmDatePreticks(sub, requestDates) {
+  const own = getSubCoverageDates(sub, requestDates);
+  return own.length ? own : (requestDates || []).slice();
+}
+
 // Computes the shift override to write onto a confirmed sub's schedule for one covered date.
 // 'full' mode copies the requester's own normal recurring shift for that day of week exactly (start/end/
 // studio) — returns null when the requester has no recurring shift on that day at all, since there's
@@ -1592,6 +1601,7 @@ if (typeof module !== 'undefined' && module.exports) {
     applyScheduleEdits,
     isRealDate,
     carryConfirmedSubs,
+    confirmDatePreticks,
     normalizeRequestDates,
     checkEditAgainstDocument,
     subMissingWriteNote,
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index 994491c..b0cbc73 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -1559,7 +1559,7 @@ describe('Phase 4: sub-coverage reversals are checked, never cleared blind', ()
     expect(toggle.indexOf('SUB_TOGGLE_STATUSES.includes(req.status)')).toBeLessThan(toggle.indexOf('unconfirmTimeOffSub(req, subIndex, sub)'));
     expect(toggle).toMatch(/confirmTimeOffSub\(requestId, subIndex, sub\.name, \{ confirmed: true \}, \{\}, \{ confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES \}\)/);
     const submit = slice('async function submitConfirmSub()', 'async function unconfirmTimeOffSub(');
-    expect(submit).toMatch(/\}, \{\}, \{ confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES \}\);/);
+    expect(submit).toMatch(/\}, \{\}, \{ confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES, dates: ctx\.requestDatesSnapshot \}\);/);
     // and the button's gate is the same list
     expect(src).toMatch(/const canToggle = \(s\.confirmed \? \(isOwner \|\| isAdmin\) : isAdmin\) && \['submitted', 'under_review', 'approved'\]\.includes\(req\.status\);/);
     // the data layer honours `confirmed`
@@ -2233,11 +2233,14 @@ describe('a sub is confirmed only by a manager', () => {
     expect(remove).toMatch(/if \(sub\.confirmed\) \{/);
     expect(remove).toMatch(/if \(!confirm\(/);
     expect(remove).toMatch(/can't be added back from this form/);
+    // the record-bearing wording is chosen by hasRecord, not the other way round
+    expect(remove).toMatch(/const lead = hasRecord\s*\? `\$\{sub\.name\} is confirmed and has a shift on their schedule for this\./);
+    expect(remove).toMatch(/: `\$\{sub\.name\} is marked confirmed\.`;/);
   });
 
   test('step 1 runs on the first read, BEFORE reconcile and any reversal, and gives the Save button back', () => {
     const branch = slice('// Not a status reset', 'const subsResult = await reverseConfirmedTimeOffSubs(editingTimeOffId, existingData.proposedSubs, new Set(');
-    expect(branch).toMatch(/const first = checkEditAgainstDocument\(\{ openedSubs, openedDates, formSubs: formData\.proposedSubs, formDates: formData\.dates, docSubs: existingData\.proposedSubs, docDates: existingData\.dates \}\);\s*if \(!first\.ok\) \{\s*giveBack\(\);\s*alert\(editRefusalMessage\(first, formData\.proposedSubs\)\);\s*return;\s*\}\s*const \{ subs, toReverse \} = reconcileEditedProposedSubs/);
+    expect(branch).toMatch(/const first = checkEditAgainstDocument\(\{ openedSubs, openedDates, formSubs: formData\.proposedSubs, formDates: formData\.dates, docSubs: existingData\.proposedSubs, docDates: existingData\.dates \}\);\s*if \(!first\.ok\) \{\s*giveBack\(\);\s*alert\(editRefusalMessage\(first, formData\.proposedSubs, openedSubs\)\);\s*return;\s*\}\s*const \{ subs, toReverse \} = reconcileEditedProposedSubs/);
   });
 
   test('step 2 passes only LANDED reversals, and says removals stay removed only when there were some', () => {
@@ -2248,16 +2251,23 @@ describe('a sub is confirmed only by a manager', () => {
     // a sub this save removed that a manager re-confirmed before it: named, not a plain "Request saved"
     expect(branch).toMatch(/reconfirmedNames = reversedNames\.filter\(n => \(carried\.current \|\| \[\]\)\.some\(c => c\.name === n && c\.confirmed\)\);/);
     const after = slice('if (success) {\n    editingTimeOffId = null;', '} else {\n    alert(\'Failed to save. Please try again.\');');
-    expect(after).toMatch(/if \(reconfirmedNames\.length\) \{\s*alert\(`Saved\./);
+    expect(after).toMatch(/if \(reconfirmedNames\.length\) \{\s*const who = [^\n]*\n\s*alert\(`Saved\. \$\{who\}/);
     expect(after).toMatch(/\} else \{\s*showToast\('Request saved'\);/);
   });
 
+  test('an unreadable or deleted request refuses the edit plainly and gives the Save button back', () => {
+    const edit = slice("if (editingTimeOffId) {\n    // If editing an approved/completed/denied request", "if (['approved', 'completed', 'denied'].includes(existingData.status)) {");
+    expect(edit).toMatch(/\} catch \(err\) \{\s*console\.error\([^)]*\);\s*giveBack\(\);\s*alert\('Could not read this request, so nothing was saved\. Please try again\.'\);\s*return;\s*\}/);
+    expect(edit).toMatch(/if \(!existingDoc\.exists\) \{\s*giveBack\(\);\s*alert\('This request no longer exists, so your edits were not saved\.'\);\s*return;\s*\}/);
+  });
+
   test('the save-refusal text names a date change as a date change', () => {
     expect(src).toMatch(/saved\.field === 'proposedSubs' \? 'its subs changed' : saved\.field === 'dates' \? 'its dates changed' : 'its schedule record changed'/);
   });
 
   test('step-1 refusal wording: never tells anyone to Undo for a date move they did not make', () => {
-    const msg = slice('function editRefusalMessage(check, formSubs)', 'async function handleSubmitTimeOff()');
+    const msg = slice('function editRefusalMessage(check, formSubs, opened)', 'async function handleSubmitTimeOff()');
+    expect(msg).not.toMatch(/openedSubs/);   // takes what the form opened with as a parameter, not the global
     const elsewhere = msg.slice(msg.indexOf("'dates-changed-elsewhere'"), msg.indexOf("// 'dates-while-confirmed'"));
     expect(elsewhere).toMatch(/changed by someone else/);
     expect(elsewhere).not.toMatch(/Undo/);
@@ -2287,3 +2297,71 @@ describe('a sub is confirmed only by a manager', () => {
     expect(src).not.toMatch(/if \(s\.confirmed && !s\.subUid\) \{/);   // the old gate missed a link-less sub with a matched name
   });
 });
+
+// ─── Phase 2: the manager chooses the dates when confirming (D2) ─────────────────────────────────────────
+describe('the confirm box: the manager picks from the request\'s real dates, and a stale box cannot confirm', () => {
+  const slice = (from, to) => { const a = src.indexOf(from); const b = src.indexOf(to, a); expect(a).toBeGreaterThan(-1); expect(b).toBeGreaterThan(a); return src.slice(a, b); };
+  const html = fs.readFileSync(`${__dirname}/index.html`, 'utf8');
+  const data = fs.readFileSync(`${__dirname}/js/firebase-data.js`, 'utf8');
+
+  test('the box renders one checkbox per request date, pre-ticked by confirmDatePreticks, labels escaped', () => {
+    const open = slice('function openConfirmSubModal(req, subIndex, sub, match)', 'function closeConfirmSubModal()');
+    expect(open).toMatch(/const preticked = new Set\(confirmDatePreticks\(sub, requestDates\)\);/);
+    expect(open).toMatch(/requestDatesSnapshot: normalizeRequestDates\(req\.dates\),/);
+    expect(open).toMatch(/<input type="checkbox" class="confirm-sub-date" value="\$\{escapeHtml\(d\)\}" \$\{preticked\.has\(d\) \? 'checked' : ''\}> \$\{escapeHtml\(label\)\}/);
+    expect(html).toMatch(/<div id="confirm-sub-dates"/);
+    expect(html).not.toMatch(/<span id="confirm-sub-dates">/);
+  });
+
+  test('ctx.dates comes from the TICKED boxes, before the loop every write and email derives from', () => {
+    const submit = slice('async function submitConfirmSub()', 'function isManagerUser()');
+    const assign = submit.indexOf("ctx.dates = Array.from(document.querySelectorAll('#confirm-sub-dates input.confirm-sub-date:checked')).map(i => i.value);");
+    const loop = submit.indexOf('for (const dateStr of ctx.dates) {');
+    expect(assign).toBeGreaterThan(-1);
+    expect(loop).toBeGreaterThan(assign);
+    expect(submit).toMatch(/if \(!ctx\.dates\.length\) \{\s*alert\('Tick at least one date to confirm\.'\);\s*return;\s*\}/);
+    expect(submit).not.toMatch(/getSubCoverageDates/);   // the box decides, not a recomputation
+  });
+
+  test('a ticked date with nothing to copy is collected and named, not silently dropped', () => {
+    const submit = slice('async function submitConfirmSub()', 'function isManagerUser()');
+    expect(submit).toMatch(/if \(!override\) \{ noShiftDates\.push\(dateStr\); continue; \}/);
+    expect(submit).toMatch(/if \(noShiftDates\.length\) \{[\s\S]*?alert\(`No normal shift to copy on/);
+  });
+
+  test('a date refusal gets its own lead; the other two leads are unchanged', () => {
+    const submit = slice('async function submitConfirmSub()', 'function isManagerUser()');
+    expect(submit).toMatch(/: result\.field === 'dates'\s*\? 'This request\\'s dates changed while the box was open, so nothing was confirmed\.'\s*: 'Could not confirm — this request may have changed\.';/);
+    expect(submit).not.toMatch(/\$\{dates\}/);   // the undefined identifier that turned the no-rollback message into "Something went wrong"
+  });
+
+  test('confirmTimeOffSub compares NORMALIZED dates, and only AFTER the confirmed check', () => {
+    const fn = data.slice(data.indexOf('async function confirmTimeOffSub'), data.indexOf('// ─── Streak Data'));
+    expect(fn).toMatch(/if \(want\.dates !== undefined && !sameStructure\(normalizeRequestDates\(data\.dates\), want\.dates\)\) return \{ success: false, reason: 'changed', field: 'dates' \};/);
+    const confirmedAt = fn.indexOf("field: 'confirmed' };");
+    const datesAt = fn.indexOf("field: 'dates' };");
+    expect(confirmedAt).toBeGreaterThan(-1);
+    expect(datesAt).toBeGreaterThan(confirmedAt);   // else a colleague's confirmation takes the full-rollback path
+    expect(datesAt).toBeLessThan(fn.indexOf('subs[subIndex] = { ...subs[subIndex], ...patch }'));
+  });
+
+  test('× and Cancel both close through closeConfirmSubModal, which drops the context; submit needs the box open', () => {
+    expect(src).toMatch(/function closeConfirmSubModal\(\) \{\s*document\.getElementById\('confirm-sub-modal'\)\.classList\.remove\('open'\);\s*_confirmSubCtx = null;\s*\}/);
+    const box = html.slice(html.indexOf('<div id="confirm-sub-modal"'), html.indexOf('</div>\n</div>', html.indexOf('<div id="confirm-sub-modal"')));
+    expect((box.match(/onclick="closeConfirmSubModal\(\)"/g) || []).length).toBe(2);
+    expect(box).not.toMatch(/classList\.remove\('open'\)/);
+    const submit = slice('async function submitConfirmSub()', 'const modeInput');
+    expect(submit).toMatch(/if \(!ctx \|\| !modal \|\| !modal\.classList\.contains\('open'\)\) return;/);
+  });
+
+  test('the emulator test\'s mirrored helpers are verbatim copies of js/schedule-helpers.js', () => {
+    const helpers = fs.readFileSync(`${__dirname}/js/schedule-helpers.js`, 'utf8');
+    const mirror = fs.readFileSync(`${__dirname}/timeoff-sub-confirm.emulator.test.js`, 'utf8');
+    const body = (text, name) => { const a = text.indexOf(`function ${name}(`); expect(a).toBeGreaterThan(-1); return text.slice(a, text.indexOf('\n}\n', a) + 2); };
+    ['sameStructure', 'normalizeRequestDates'].forEach(name => {
+      expect(body(mirror, name).replace(/\s+\/\/ verbatim from js\/schedule-helpers\.js/, '')).toBe(body(helpers, name));
+    });
+    // and the mirror's transaction carries the same dates guard, in the same place
+    expect(mirror).toMatch(/if \(want\.dates !== undefined && !sameStructure\(normalizeRequestDates\(data\.dates\), want\.dates\)\) return \{ success: false, reason: 'changed', field: 'dates' \};/);
+  });
+});
diff --git a/schedule-helpers.test.js b/schedule-helpers.test.js
index 1368132..141ae6d 100644
--- a/schedule-helpers.test.js
+++ b/schedule-helpers.test.js
@@ -29,6 +29,7 @@ const {
   applyScheduleEdits,
   isRealDate,
   carryConfirmedSubs,
+  confirmDatePreticks,
   normalizeRequestDates,
   checkEditAgainstDocument,
   subMissingWriteNote,
@@ -2931,6 +2932,12 @@ describe('normalizeRequestDates', () => {
     expect(sameStructure(normalizeRequestDates(a), normalizeRequestDates(c))).toBe(false);
   });
 
+  test('a partial row with empty or missing times normalizes them to null', () => {
+    const want = [{ date: '2026-10-03', type: 'partial', partialStart: null, partialEnd: null }];
+    expect(normalizeRequestDates([{ date: '2026-10-03', type: 'partial', partialStart: '', partialEnd: '' }])).toEqual(want);
+    expect(normalizeRequestDates([{ date: '2026-10-03', type: 'partial' }])).toEqual(want);
+  });
+
   test('full-day rows drop any stored partial times; a missing or non-array value is []', () => {
     expect(normalizeRequestDates([{ date: '2026-10-03', type: 'full', partialStart: '09:00' }]))
       .toEqual([{ date: '2026-10-03', type: 'full', partialStart: null, partialEnd: null }]);
@@ -2976,6 +2983,13 @@ describe('checkEditAgainstDocument — a stale edit form decides nothing', () =>
     expect(r.reason).toBe('subs-changed');
   });
 
+  test('reversedNames really is what exempts a sub the form un-ticked (the old cached page shape) — without it, refused', () => {
+    // Sam still in the form but flagged unconfirmed there (the pre-Sep-29 un-tick), reversed by this save:
+    const args = { ...base, openedSubs: opened({ Sam: true }), formSubs: [{ name: 'Sam', confirmed: false }], docSubs: [{ name: 'Sam', confirmed: false }] };
+    expect(checkEditAgainstDocument({ ...args, reversedNames: ['Sam'] })).toEqual({ ok: true });
+    expect(checkEditAgainstDocument(args)).toEqual({ ok: false, reason: 'subs-changed', names: ['Sam'] });
+  });
+
   test('a manager un-confirming a sub still in the form between the reads refuses step 2', () => {
     const r = checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: true, Kayleigh: true }), formSubs: [{ name: 'Kayleigh', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: false }, { name: 'Kayleigh', confirmed: false }], reversedNames: ['Sam'] });
     expect(r).toEqual({ ok: false, reason: 'subs-changed', names: ['Kayleigh'] });
@@ -3043,3 +3057,27 @@ describe('subMissingWriteNote — the amber line under a confirmed sub with no r
     expect(subMissingWriteNote({ name: 'X', confirmed: true }, 'unclaimed')).toMatch(/hasn’t signed in yet/);
   });
 });
+
+describe('confirmDatePreticks — which dates the confirm box ticks to begin with', () => {
+  const REQ = ['2026-10-03', '2026-10-04'];
+  test('the sub\'s own dates where they line up with the request', () => {
+    expect(confirmDatePreticks({ dates: ['2026-10-03'] }, REQ)).toEqual(['2026-10-03']);
+  });
+  test('none line up (added before the date was picked, or the date moved — Ivy\'s case) → every request date', () => {
+    expect(confirmDatePreticks({ dates: [] }, REQ)).toEqual(REQ);
+    expect(confirmDatePreticks({ dates: ['2026-09-30'] }, REQ)).toEqual(REQ);
+  });
+  test('a legacy free-text dates field → every request date; the request list is not mutated', () => {
+    const req = REQ.slice();
+    const out = confirmDatePreticks({ dates: 'Oct 3-4' }, req);
+    expect(out).toEqual(REQ);
+    out.push('x');
+    expect(req).toEqual(REQ);
+  });
+  test('no request dates → nothing to tick', () => {
+    expect(confirmDatePreticks({ dates: [] }, [])).toEqual([]);
+  });
+  test('getSubCoverageDates keeps its meaning: an empty array still means no dates (the fallback lives here)', () => {
+    expect(getSubCoverageDates({ dates: [] }, REQ)).toEqual([]);
+  });
+});
diff --git a/timeoff-sub-confirm.emulator.test.js b/timeoff-sub-confirm.emulator.test.js
index 1e3c6b1..db9559b 100644
--- a/timeoff-sub-confirm.emulator.test.js
+++ b/timeoff-sub-confirm.emulator.test.js
@@ -43,6 +43,18 @@ function sameStructure(a, b) {   // verbatim from js/schedule-helpers.js
   return JSON.stringify(norm(a)) === JSON.stringify(norm(b));
 }
 
+function normalizeRequestDates(dates) {   // verbatim from js/schedule-helpers.js
+  return (Array.isArray(dates) ? dates : []).map(d => {
+    const type = (d && d.type) || 'full';
+    const partial = type === 'partial';
+    return {
+      date: (d && d.date) || null,
+      type,
+      partialStart: partial ? (d.partialStart || null) : null,
+      partialEnd: partial ? (d.partialEnd || null) : null,
+    };
+  }).sort((a, b) => String(a.date).localeCompare(String(b.date)));
+}
 // Mirrors confirmTimeOffSub()'s real transaction logic exactly: fresh read, index+name guard, the Phase 3b
 // exact-record guard (`expectApplied`) and request guard (`expectRequest`: status allowlist, marker, the
 // entry's subUid), patch one sub entry, recompute coverageStatus, single transactional write.
@@ -66,6 +78,7 @@ async function confirmTimeOffSub(requestId, subIndex, expectedSubName, patch, ex
     if (want.reversalPending !== undefined && !!data.reversalPending !== want.reversalPending) return { success: false, reason: 'changed', field: 'reversalPending' };
     if (want.subUid !== undefined && (subs[subIndex].subUid || null) !== (want.subUid || null)) return { success: false, reason: 'sub-changed', field: 'subUid' };
     if (want.confirmed !== undefined && !!subs[subIndex].confirmed !== want.confirmed) return { success: false, reason: 'sub-changed', field: 'confirmed' };
+    if (want.dates !== undefined && !sameStructure(normalizeRequestDates(data.dates), want.dates)) return { success: false, reason: 'changed', field: 'dates' };
     subs[subIndex] = { ...subs[subIndex], ...patch };
     const allConfirmed = subs.every(s => s.confirmed);
     const someConfirmed = subs.some(s => s.confirmed);
@@ -274,3 +287,41 @@ test('the record guard is key-order independent: the same record with keys in an
   const r = await confirmTimeOffSub('req-15', 0, 'Kayleigh Wood', CLEAR, reordered, { subUid: 'uid-kayleigh', confirmed: true });
   expect(r).toEqual({ success: true });
 });
+
+// ─── The request's dates guard (plan: ticker-sub-confirm-only-by-manager, Phase 2) ──────────────────────────
+// A confirm box built on one set of dates must not confirm after the request moved to others; a pure
+// shape rewrite is not a move; and a colleague's confirmation must win over a date refusal.
+describe('confirmTimeOffSub dates guard', () => {
+  const OCT3 = [{ date: '2026-10-03', type: 'full', partialStart: null, partialEnd: null, flexible: false }];
+  const seed = (dates, subOverrides = {}) => db.collection('timeclock_timeoff').doc('req-dates').set({
+    uid: 'uid-ivy', status: 'approved', coverageStatus: 'pending', dates,
+    proposedSubs: [{ name: 'Sam', email: '', dates: [], confirmed: false, ...subOverrides }],
+  });
+  const confirm = (snapshot) => confirmTimeOffSub('req-dates', 0, 'Sam',
+    { confirmed: true, subUid: 'uid-sam', appliedOverrides: { '2026-10-03': { had: false, previousOverride: null } } },
+    {}, { confirmed: false, subUid: null, statuses: ['submitted', 'under_review', 'approved'], dates: snapshot });
+
+  test('the request moved to Oct 4 after the box opened on Oct 3 → refused, entry stays unconfirmed', async () => {
+    await seed([{ date: '2026-10-04', type: 'full', partialStart: null, partialEnd: null, flexible: false }]);
+    const r = await confirm(normalizeRequestDates(OCT3));
+    expect(r).toEqual({ success: false, reason: 'changed', field: 'dates' });
+    const data = (await db.collection('timeclock_timeoff').doc('req-dates').get()).data();
+    expect(data.proposedSubs[0].confirmed).toBe(false);
+    expect(data.coverageStatus).toBe('pending');
+  });
+
+  test('a legacy-shaped Oct 3 (no type, empty partials) vs the normalized snapshot is NOT a change → confirmed', async () => {
+    await seed([{ date: '2026-10-03', partialStart: '', partialEnd: '' }]);
+    const r = await confirm(normalizeRequestDates(OCT3));
+    expect(r).toEqual({ success: true });
+  });
+
+  test('dates moved AND someone else confirmed the sub → sub-changed (partitioned rollback), not a dates refusal', async () => {
+    await seed([{ date: '2026-10-04', type: 'full' }], { confirmed: true, subUid: 'uid-sam', appliedOverrides: { '2026-10-04': { had: false, previousOverride: null } } });
+    const r = await confirm(normalizeRequestDates(OCT3));
+    // whichever entry guard notices first (the empty-record expectation, here), it is a SUB change, never 'dates'
+    expect(r.success).toBe(false);
+    expect(r.reason).toBe('sub-changed');
+    expect(r.field).not.toBe('dates');
+  });
+});
