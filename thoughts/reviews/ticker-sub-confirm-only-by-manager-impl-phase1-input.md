## Implementation review — Phase 1 of ticker-sub-confirm-only-by-manager
Plan (the spec): /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html — read
"The one rule behind Phase 1" and "Phase 1" in full. Repo: /Users/christiehubley/tinker-timeclock, branch
fix/sub-confirm-manager-only, commit e7e11d6 (diff below, against 4ac3d09). READ-ONLY for you: no edits, no tests that write,
no deploys. You may read any file.

## What to check
- Does the code do exactly what Phase 1 specifies? List every place it deviates, is incomplete, or goes beyond the plan.
- Bugs: wrong schedule write, false confirmation, a legitimate save wrongly refused, a stale form that still decides something,
  a refusal that leaves the Save button disabled, a message that states something false.
- Trace these end-to-end through handleSubmitTimeOff (the non-reset branch and the reset branch), carryCurrentSubs,
  reconcileEditedProposedSubs, reverseConfirmedTimeOffSubs, updateTimeOffRequestIfStatus:
  * reason-only edit with a confirmed sub (must save; link kept)
  * remove a confirmed sub (reversal lands) → save
  * remove + re-add a confirmed sub
  * the round-1 and round-2 races, D1, dates-changed-elsewhere, step-2 refusal after a landed removal
  * a brand-new request (openedSubs/openedDates null — must not throw; create path)
  * editing a request whose existingDoc no longer exists
  * the reset branch (approved/completed/denied) — must be unchanged
- Firebase invariants: no undefined written; guarded writes; awaited writes.
- Are the new tests real (would they fail on a broken implementation)? Any test that passes vacuously?
- Rank BLOCKING / MEDIUM / LOW with file:line. End with: Phase 1 OK to build on — yes/no.

## Diff (git diff 4ac3d09 e7e11d6)
diff --git a/index.html b/index.html
index f8e592a..5edf10e 100644
--- a/index.html
+++ b/index.html
@@ -708,7 +708,7 @@
         <!-- Coverage -->
         <div style="margin-bottom:16px;">
           <label style="font-size:13px; font-weight:700; display:block; margin-bottom:6px;">Coverage</label>
-          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below.</p>
+          <p style="font-size:12px; color:var(--text-medium); margin-bottom:8px;">Have you reached out to anyone about covering your shifts? Requests with confirmed coverage are approved much faster. Add anyone you've talked to (or plan to) below. If someone has said yes, note it in Coverage Notes &mdash; a manager confirms the sub and adds the shift to their schedule.</p>
           <div id="timeoff-subs-list"></div>
           <select id="timeoff-sub-picker" style="width:100%; padding:8px 10px; border:1px solid var(--border-light); border-radius:6px; font-family:inherit; font-size:13px; background:var(--bg-white); margin-bottom:8px;">
             <option value="">Add a coworker for coverage...</option>
diff --git a/js/app.js b/js/app.js
index 01db884..ff87faf 100644
--- a/js/app.js
+++ b/js/app.js
@@ -6784,6 +6784,10 @@ async function confirmAssignUser(empId, uid) {
 
 let timeoffFormDates = [];    // [{date, type, partialStart, partialEnd, flexible}]
 let timeoffFormSubs = [];     // [{name, dates}]
+// What an EDIT form opened with (plan: ticker-sub-confirm-only-by-manager). The form cannot confirm anyone,
+// so at save these decide whether the form is out of date (checkEditAgainstDocument). null until an edit loads.
+let openedSubs = null;        // name -> { confirmed, hasRecord, entry }
+let openedDates = null;       // normalizeRequestDates(document dates) — never timeoffFormDates, whose rows are edited in place
 let allTimeoffRequests = [];  // cached for admin
 let viewingRequestId = null;  // currently open detail modal
 let editingTimeOffId = null;  // non-null when editing an existing request
@@ -7019,6 +7023,8 @@ function openTimeOffForm(existingRequest) {
   editingTimeOffId = existingRequest ? existingRequest.id : null;
   timeoffFormDates = [];
   timeoffFormSubs = [];
+  openedSubs = null;
+  openedDates = null;
 
   // Populate category dropdown
   const cats = (appSettings && appSettings.timeoffCategories) || DEFAULT_SETTINGS.timeoffCategories;
@@ -7066,6 +7072,16 @@ function openTimeOffForm(existingRequest) {
 
     // Subs
     timeoffFormSubs = (existingRequest.proposedSubs || []).map(s => ({ name: s.name, email: s.email || '', dates: s.dates || [], confirmed: s.confirmed || false }));
+    // Snapshots from the DOCUMENT, deep-copied so nothing the form edits can alias them.
+    openedSubs = {};
+    (existingRequest.proposedSubs || []).forEach((s, i) => {
+      openedSubs[s.name] = {
+        confirmed: !!s.confirmed,
+        hasRecord: Object.keys(s.appliedOverrides || {}).length > 0,
+        entry: JSON.parse(JSON.stringify(timeoffFormSubs[i])),
+      };
+    });
+    openedDates = normalizeRequestDates(existingRequest.dates);
     renderTimeOffSubs();
 
     document.getElementById('timeoff-notice-warning').classList.add('hidden');
@@ -7274,6 +7290,16 @@ function addTimeOffSub() {
   if (!name) return;
   if (timeoffFormSubs.find(s => s.name === name)) { picker.value = ''; return; }
 
+  // Removing a confirmed sub and adding them back is an undo, not an un-confirm: restore the entry exactly as
+  // the form loaded it (a fresh copy), so the save carries their confirmation and nothing is reversed.
+  const opened = openedSubs && openedSubs[name];
+  if (opened && opened.confirmed) {
+    timeoffFormSubs.push(JSON.parse(JSON.stringify(opened.entry)));
+    picker.value = '';
+    renderTimeOffSubs();
+    return;
+  }
+
   const selectedOption = picker.options[picker.selectedIndex];
   const email = selectedOption ? selectedOption.getAttribute('data-email') || '' : '';
 
@@ -7288,15 +7314,23 @@ function addTimeOffSub() {
 }
 
 function removeTimeOffSub(index) {
+  const sub = timeoffFormSubs[index];
+  if (!sub) return;
+  if (sub.confirmed) {
+    // Removing a confirmed sub reverses their coverage on save, so say what will happen first.
+    const hasRecord = !!(openedSubs && openedSubs[sub.name] && openedSubs[sub.name].hasRecord);
+    const picker = document.getElementById('timeoff-sub-picker');
+    const canReAdd = !!picker && Array.from(picker.options).some(o => o.value === sub.name);
+    const lead = hasRecord
+      ? `${sub.name} is confirmed and has a shift on their schedule for this. Removing ${sub.name} takes it off (or asks a manager to).`
+      : `${sub.name} is marked confirmed.`;
+    const noReAdd = canReAdd ? '' : ` ${sub.name} can't be added back from this form.`;
+    if (!confirm(`${lead}${noReAdd} Remove ${sub.name}?`)) return;
+  }
   timeoffFormSubs.splice(index, 1);
   renderTimeOffSubs();
 }
 
-function toggleFormSubConfirmed(index) {
-  timeoffFormSubs[index].confirmed = !timeoffFormSubs[index].confirmed;
-  renderTimeOffSubs();
-}
-
 function renderTimeOffSubs() {
   const container = document.getElementById('timeoff-subs-list');
   if (!timeoffFormSubs.length) {
@@ -7314,10 +7348,7 @@ function renderTimeOffSubs() {
           <div>${emailLine}</div>
         </div>
         <div style="display:flex; align-items:center; gap:8px;">
-          <label style="display:flex; align-items:center; gap:4px; font-size:12px; color:var(--text-dark); cursor:pointer; background:${s.confirmed ? 'var(--green-light)' : 'var(--bg-cream)'}; padding:4px 10px; border-radius:6px; border:1px solid ${s.confirmed ? 'var(--green)' : 'var(--border-light)'};">
-            <input type="checkbox" ${s.confirmed ? 'checked' : ''} onchange="toggleFormSubConfirmed(${i})">
-            ${s.confirmed ? 'They said yes!' : 'They agreed to cover'}
-          </label>
+          ${s.confirmed ? '<span style="font-size:12px; color:var(--text-dark); background:var(--green-light); padding:4px 10px; border-radius:6px; border:1px solid var(--green);">Confirmed</span>' : ''}
           <button class="remove-date" onclick="removeTimeOffSub(${i})" style="background:none; border:none; color:var(--red); font-size:18px; cursor:pointer;">&times;</button>
         </div>
       </div>`;
@@ -7326,6 +7357,25 @@ function renderTimeOffSubs() {
 
 // ─── Submit Request ─────────────────────────────────
 
+// What to say when an edit's FIRST check (before anything is written) refuses the save. Nothing has
+// changed yet, so each reason can say so. `formSubs` names any confirmed sub the edit also removed.
+function editRefusalMessage(check, formSubs) {
+  const list = (names) => names.length <= 1 ? (names[0] || '') : `${names.slice(0, -1).join(', ')} and ${names[names.length - 1]}`;
+  if (check.reason === 'subs-changed') {
+    return `A manager confirmed or un-confirmed ${list(check.names)} while you were editing, so nothing was saved or changed. Close this form, reopen the request, and try again.`;
+  }
+  if (check.reason === 'dates-changed-elsewhere') {
+    return 'This request\'s dates were changed by someone else while you were editing, so nothing was saved or changed. Close this form and reopen the request.';
+  }
+  // 'dates-while-confirmed' (D1): this user changed the dates while a sub is confirmed.
+  const who = list(check.names);
+  const one = check.names.length === 1;
+  const inForm = new Set((formSubs || []).map(s => s.name));
+  const removed = Object.keys(openedSubs || {}).filter(n => openedSubs[n].confirmed && !inForm.has(n));
+  const removeNote = removed.length ? ` To remove ${list(removed)}, save that change on its own first.` : '';
+  return `${who} ${one ? 'is' : 'are'} confirmed to cover this request. ${who} ${one ? 'has' : 'have'} to be un-confirmed (Undo, by a manager if their shift is on their schedule) before the dates can change. Nothing was saved or changed.${removeNote}`;
+}
+
 async function handleSubmitTimeOff() {
   // Validate dates
   const validDates = timeoffFormDates.filter(d => d.date);
@@ -7405,6 +7455,7 @@ async function handleSubmitTimeOff() {
   // as the fresh post-reversal read saw them — anything else (an un-approve, withdrawal, or sub change in
   // another tab) refuses the save rather than overwriting it. Set on both edit paths.
   let saveGuard = null;
+  let reconfirmedNames = [];
   const giveBack = () => { btn.disabled = false; btn.textContent = editingTimeOffId ? 'Save Changes' : 'Submit Request'; };
   if (editingTimeOffId) {
     // If editing an approved/completed/denied request, reset to under_review and undo overrides
@@ -7449,9 +7500,17 @@ async function handleSubmitTimeOff() {
       } else {
         // Not a status reset — a confirmed sub's real schedule-write link must survive an unrelated edit
         // (e.g. fixing a typo in the reason) rather than being silently dropped by the edit form's plain
-        // {name,email,dates,confirmed} shape. Also caught by review: reverses any sub whose confirmation
-        // was actually removed via the edit form's checkbox (or the sub itself removed from the list),
-        // since that path has no other way to trigger the real reversal.
+        // {name,email,dates,confirmed} shape. Also caught by review: reverses any confirmed sub removed from
+        // the list, since that path has no other way to trigger the real reversal.
+        // Step 1 (plan: ticker-sub-confirm-only-by-manager): the form cannot confirm anyone, so a form that
+        // opened on different sub states or dates than the document now holds is out of date and decides
+        // nothing. Checked before any reversal, so a refusal here changes nothing.
+        const first = checkEditAgainstDocument({ openedSubs, openedDates, formSubs: formData.proposedSubs, formDates: formData.dates, docSubs: existingData.proposedSubs, docDates: existingData.dates });
+        if (!first.ok) {
+          giveBack();
+          alert(editRefusalMessage(first, formData.proposedSubs));
+          return;
+        }
         const { subs, toReverse } = reconcileEditedProposedSubs(formData.proposedSubs, existingData.proposedSubs);
         // Phase 4: the same transaction-guarded per-sub reversal deny/withdraw use, restricted to the subs the
         // edit un-ticked or removed; then the document as it now stands decides which subs are confirmed —
@@ -7472,8 +7531,21 @@ async function handleSubmitTimeOff() {
         }
         const carried = await carryCurrentSubs(editingTimeOffId, subs);
         if (!carried) { giveBack(); return; }
+        // Step 2: the same check on the post-reversal read. Subs whose reversal by THIS save landed are its own
+        // change and are skipped; anything else that moved since step 1 refuses. Removals above may already
+        // have landed, so this refusal says so rather than "nothing was saved".
+        const failedIdx = new Set(subsResult.failed.map(f => f.index));
+        const reversedNames = toReverse.filter(t => !failedIdx.has(t.index)).map(t => t.name);
+        const second = checkEditAgainstDocument({ openedSubs, openedDates, formSubs: formData.proposedSubs, formDates: formData.dates, docSubs: carried.current, docDates: carried.currentDates, reversedNames });
+        if (!second.ok) {
+          giveBack();
+          alert(`A sub or the dates changed while you were editing, so your edits were NOT saved.${reversedNames.length ? ' Any sub coverage removed above stays removed.' : ''} Close this form, reopen the request, and try again.`);
+          return;
+        }
+        // A sub this save removed and a manager re-confirmed before it: the newer confirmation stands. Say so.
+        reconfirmedNames = reversedNames.filter(n => (carried.current || []).some(c => c.name === n && c.confirmed));
         formData.proposedSubs = carried.subs;
-        saveGuard = { statuses: [existingData.status], expect: { proposedSubs: carried.current, appliedOverrides: requesterRecord } };
+        saveGuard = { statuses: [existingData.status], expect: { proposedSubs: carried.current, appliedOverrides: requesterRecord, dates: carried.currentDates } };
       }
     }
     // Update existing request — guarded when the edit made decisions on a read (Phase 4), plain otherwise.
@@ -7482,7 +7554,7 @@ async function handleSubmitTimeOff() {
       success = saved.success;
       if (!success && ['status-changed', 'changed', 'not-found'].includes(saved.reason)) {
         giveBack();
-        alert(`This request changed while the form was open (${saved.reason === 'status-changed' ? 'its status is now ' + String(saved.status || '').replace('_', ' ') : saved.reason === 'not-found' ? 'it no longer exists' : saved.field === 'proposedSubs' ? 'its subs changed' : 'its schedule record changed'}), so your edits were NOT saved. Any sub coverage removed above stays removed${saveGuard.reset ? ', and so does the requester\'s own time off — the request still shows it as applied until it is edited or returned to review again, which will clear that record' : ''}. Close this form, reopen the request, and try again.`);
+        alert(`This request changed while the form was open (${saved.reason === 'status-changed' ? 'its status is now ' + String(saved.status || '').replace('_', ' ') : saved.reason === 'not-found' ? 'it no longer exists' : saved.field === 'proposedSubs' ? 'its subs changed' : saved.field === 'dates' ? 'its dates changed' : 'its schedule record changed'}), so your edits were NOT saved. Any sub coverage removed above stays removed${saveGuard.reset ? ', and so does the requester\'s own time off — the request still shows it as applied until it is edited or returned to review again, which will clear that record' : ''}. Close this form, reopen the request, and try again.`);
         return;
       }
     } else {
@@ -7495,6 +7567,9 @@ async function handleSubmitTimeOff() {
       name: currentUser.name || currentUser.email,
       email: currentUser.email || '',
       ...formData,
+      // Only a manager confirms a sub (Mark Confirmed writes the shift and sends the email). After the
+      // spread, so the form can never save a confirmation into a new request.
+      proposedSubs: formData.proposedSubs.map(s => ({ ...s, confirmed: false })),
       status: 'submitted',
       coverageStatus: 'pending',
       comments: [],
@@ -7517,7 +7592,11 @@ async function handleSubmitTimeOff() {
     document.getElementById('timeoff-form-modal').classList.remove('open');
     allTimeoffRequests = await getAllTimeOffRequests();
     await renderTimeOffTab();
-    showToast('Request saved');
+    if (reconfirmedNames.length) {
+      alert(`Saved. ${reconfirmedNames.join(', ')} ${reconfirmedNames.length === 1 ? 'was' : 'were'} re-confirmed by a manager while you were editing, so they stay on this request.`);
+    } else {
+      showToast('Request saved');
+    }
     if (!wasEditingTimeOff) {
       sendPushToAllAdmins('New Time Off Request', `${currentUser.name || 'A staff member'} submitted a time off request.`);
       sendTimeOffSubmissionEmail(currentUser.name || currentUser.email || 'A staff member', formData.dates, reason, requestStudios, coverageNotes, currentUser.email);
@@ -7599,30 +7678,22 @@ async function openTimeOffDetail(requestId) {
     req.proposedSubs.forEach((s, i) => {
       const confirmBadge = s.confirmed
         ? '<span style="font-size:11px; font-weight:700; color:var(--green);">Confirmed</span>'
-        : '<span style="font-size:11px; font-weight:700; color:var(--amber);">Not confirmed</span>';
+        : `<span style="font-size:11px; font-weight:700; color:var(--amber);">Not confirmed${isAdmin ? '' : ' · a manager confirms coverage'}</span>`;
       const emailLink = s.email
         ? ` <a href="mailto:${escapeHtml(s.email)}" style="font-size:11px; color:var(--teal); text-decoration:none;">${escapeHtml(s.email)}</a>`
         : '';
-      // Both owner and admin can toggle confirmation. Includes 'approved' (Option A, Decisions Log
-      // Sep 3/Aug 31) — a sub can be confirmed either before or after the request itself is approved.
-      const canToggle = (isOwner || isAdmin) && ['submitted', 'under_review', 'approved'].includes(req.status);
+      // Only a manager confirms (Mark Confirmed writes the sub's shift and sends the email); the owner keeps
+      // Undo on a confirmed sub (Sep 29 2026, plan: ticker-sub-confirm-only-by-manager). Includes 'approved'
+      // (Option A, Decisions Log Sep 3/Aug 31) — a sub can be confirmed before or after the request is approved.
+      const canToggle = (s.confirmed ? (isOwner || isAdmin) : isAdmin) && ['submitted', 'under_review', 'approved'].includes(req.status);
       const toggleBtn = canToggle
         ? ` <button class="btn btn-sm btn-secondary" onclick="handleSubConfirmToggle('${req.id}', ${i})">${s.confirmed ? 'Undo' : 'Mark Confirmed'}</button>`
         : '';
-      // Confirmed but no schedule write happened (no/ambiguous/unclaimed roster match) — persistent note,
-      // not just a one-time alert, so it's still visible whenever this request is reopened later.
-      let matchNote = '';
-      if (s.confirmed && !s.subUid) {
-        const match = resolveSubRosterMatch(s.name, employeeRoster);
-        const notes = {
-          'no-match': 'No matching roster entry — add their shift manually.',
-          'ambiguous': 'Multiple roster entries match this name — add their shift manually.',
-          'unclaimed': 'This person hasn’t signed in yet — add their shift manually once they do.',
-        };
-        if (notes[match.status]) {
-          matchNote = `<div style="font-size:11px; color:var(--amber); margin-top:2px;">${notes[match.status]}</div>`;
-        }
-      }
+      // Confirmed but Ticker holds no record of a shift written for them — an unmatched name confirmed on
+      // purpose, or an old confirmation the requester ticked on the form (D3). Persistent, so it is still visible
+      // whenever this request is reopened. The predicate lives in subMissingWriteNote (schedule-helpers.js).
+      const missingNote = s.confirmed ? subMissingWriteNote(s, resolveSubRosterMatch(s.name, employeeRoster).status) : '';
+      const matchNote = missingNote ? `<div style="font-size:11px; color:var(--amber); margin-top:2px;">${missingNote}</div>` : '';
       html += `<div class="timeoff-sub-row">
         <div>
           <span style="font-weight:600;">${escapeHtml(s.name)}</span>${emailLink}
@@ -7854,6 +7925,13 @@ async function handleSubConfirmToggle(requestId, subIndex) {
       return;
     }
 
+    // Only a manager confirms a sub — both roster branches below, not just the one that writes a schedule
+    // (an unmatched name confirms without one). The owner's Undo above is unaffected.
+    if (!isManagerUser()) {
+      alert('Only a manager can confirm a sub.');
+      return;
+    }
+
     const match = resolveSubRosterMatch(sub.name, employeeRoster);
     if (match.status !== 'matched') {
       const notes = {
@@ -7937,6 +8015,10 @@ function toggleConfirmSubTimeMode() {
 }
 
 async function submitConfirmSub() {
+  if (!isManagerUser()) {
+    alert('Only a manager can confirm a sub.');
+    return;
+  }
   const ctx = _confirmSubCtx;
   if (!ctx) return;
 
@@ -8725,7 +8807,9 @@ async function carryCurrentSubs(requestId, subs) {
   }
   // `current` rides along so the save can be guarded on exactly the subs this decision was made on.
   const currentSubs = current.data.proposedSubs === undefined ? null : current.data.proposedSubs;
-  return { subs: carryConfirmedSubs(subs, current.data.proposedSubs), current: currentSubs };
+  // `currentDates`: the same read's dates, for the edit's second check and its save guard (absence stays null).
+  const currentDates = current.data.dates === undefined ? null : current.data.dates;
+  return { subs: carryConfirmedSubs(subs, current.data.proposedSubs), current: currentSubs, currentDates };
 }
 
 // What to tell the admin when a sub's coverage shift could not be removed on an edit (Phase 4): that sub
diff --git a/js/schedule-helpers.js b/js/schedule-helpers.js
index eb52e82..bc7c38e 100644
--- a/js/schedule-helpers.js
+++ b/js/schedule-helpers.js
@@ -1013,15 +1013,16 @@ function reconcileEditedProposedSubs(newSubs, existingSubs) {
 // the pre-edit snapshot would have overwritten the newer confirmation). The wholesale save that follows
 // then cannot drop a record the schedule still depends on. A sub the form itself newly ticked (confirmed
 // with no write) is left as the form has it.
-// The reverse direction holds too (review finding): a form entry CARRYING a link — attached by
-// reconcileEditedProposedSubs from the pre-edit read — whose sub is no longer confirmed on the document
-// (un-done in another tab meanwhile) is un-confirmed and stripped, never saved back with a record whose
-// shift is gone. A newly ticked entry carries no link, so it is left alone.
+// The reverse direction holds too (review finding): a form entry claiming `confirmed` that the document no
+// longer has — a link attached by reconcileEditedProposedSubs from the pre-edit read, OR a link-less
+// confirmation the form merely loaded — is un-confirmed and stripped, never saved back. Sep 29 2026
+// ("sub confirmed only by a manager"): the form can no longer confirm anyone, so the document decides in
+// both directions. The old `hasLink` exemption kept a link-less form "confirmed" alive, which let a stale
+// edit form resurrect a confirmation a manager had just undone.
 function carryConfirmedSubs(subs, currentSubs) {
   const current = currentSubs || [];
   const confirmedNow = new Set(current.filter(c => c.confirmed).map(c => c.name));
-  const hasLink = (s) => s.subUid != null || Object.keys(s.appliedOverrides || {}).length > 0 || 'appliedOverrides' in s;
-  const out = (subs || []).map(s => (s.confirmed && hasLink(s) && !confirmedNow.has(s.name))
+  const out = (subs || []).map(s => (s.confirmed && !confirmedNow.has(s.name))
     ? { ...s, confirmed: false, subUid: null, appliedOverrides: {} }
     : s);
   current.forEach(cur => {
@@ -1034,6 +1035,81 @@ function carryConfirmedSubs(subs, currentSubs) {
   return out;
 }
 
+// A time-off request's dates in one comparable shape (plan: ticker-sub-confirm-only-by-manager). The edit
+// form LOADS a date with `type || 'full'` and `partialStart || ''`, and SAVES it with null partial times
+// unless the day is partial — so a legacy document that omits `type` or stores `partialStart: ''` differs
+// from itself after one load/save round-trip. Comparing raw would refuse edits that changed no date.
+// Sorted by date; `flexible` is not a date and is dropped. A missing/non-array value is [].
+function normalizeRequestDates(dates) {
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
+
+// "A stale edit form decides nothing" (plan: ticker-sub-confirm-only-by-manager, "The one rule"). The form
+// can no longer confirm or un-confirm a sub, so if the document's confirmed state differs from what the form
+// OPENED with, the form is out of date and the save is refused, in either direction. The dates the form
+// opened on are compared the same way, so a move made by someone else is never blamed on this user.
+//   openedSubs   name -> { confirmed, hasRecord, entry } as the form loaded it
+//   openedDates  normalizeRequestDates(document dates) as the form loaded it. REQUIRED: defaulting it
+//                to [] would make every dated request look moved by someone else.
+//   reversedNames  (step 2 only) subs whose reversal by this save LANDED; their change is this save's own.
+// Reasons, in this order: 'subs-changed', 'dates-changed-elsewhere', 'dates-while-confirmed' (D1).
+function checkEditAgainstDocument({ openedSubs, openedDates, formSubs, formDates, docSubs, docDates, reversedNames }) {
+  if (!Array.isArray(openedDates)) throw new Error('checkEditAgainstDocument: openedDates is required');
+  const opened = openedSubs || {};
+  const skip = new Set(reversedNames || []);
+  const docConfirmed = new Map((docSubs || []).map(s => [s.name, !!s.confirmed]));
+  const formNames = new Set((formSubs || []).map(s => s.name));
+  const wasConfirmed = (name) => !!(opened[name] && opened[name].confirmed);
+
+  const changed = [];
+  formNames.forEach(name => {
+    if (skip.has(name)) return;
+    if (wasConfirmed(name) !== !!docConfirmed.get(name)) changed.push(name);
+  });
+  // A sub the form removed (or never loaded) that is confirmed on the document although it was not when the
+  // form opened: confirmed meanwhile, so the × prompt never showed. Removing it would reverse real coverage.
+  (docSubs || []).forEach(s => {
+    if (formNames.has(s.name) || skip.has(s.name) || changed.includes(s.name)) return;
+    if (s.confirmed && !wasConfirmed(s.name)) changed.push(s.name);
+  });
+  if (changed.length) return { ok: false, reason: 'subs-changed', names: changed };
+
+  const docNorm = normalizeRequestDates(docDates);
+  if (!sameStructure(docNorm, normalizeRequestDates(openedDates))) {
+    return { ok: false, reason: 'dates-changed-elsewhere', names: [] };
+  }
+  const confirmedNow = (docSubs || []).filter(s => s.confirmed).map(s => s.name);
+  if (confirmedNow.length && !sameStructure(normalizeRequestDates(formDates), docNorm)) {
+    return { ok: false, reason: 'dates-while-confirmed', names: confirmedNow };
+  }
+  return { ok: true };
+}
+
+// The amber line under a confirmed sub in the request detail (D3). Plain text — the caller wraps it — or ''.
+// It fires only when Ticker holds NO record of a shift written for this sub (appliedOverrides empty): the
+// state a requester-ticked "They agreed to cover" left, and the state an unmatched name is confirmed into on
+// purpose. A record without a subUid (a partial failure) has a record, so it is not flagged.
+function subMissingWriteNote(sub, rosterStatus) {
+  if (!sub || !sub.confirmed) return '';
+  if (Object.keys(sub.appliedOverrides || {}).length) return '';
+  const notes = {
+    'no-match': 'No matching roster entry — add their shift manually.',
+    'ambiguous': 'Multiple roster entries match this name — add their shift manually.',
+    'unclaimed': 'This person hasn’t signed in yet — add their shift manually once they do.',
+    'matched': 'Ticker has no record of a shift being added to their schedule for this. Check their schedule, or Undo and use Mark Confirmed.',
+  };
+  return notes[rosterStatus] || '';
+}
+
 // Key-order-independent structural equality. Used by the transaction guards in js/firebase-data.js and by
 // partitionRollback below: one side of those compares is an in-memory literal (keys in the order the code
 // wrote them) and the other a Firestore round-trip (keys sorted), so a plain JSON compare would call the
@@ -1516,6 +1592,9 @@ if (typeof module !== 'undefined' && module.exports) {
     applyScheduleEdits,
     isRealDate,
     carryConfirmedSubs,
+    normalizeRequestDates,
+    checkEditAgainstDocument,
+    subMissingWriteNote,
     partitionRollback,
     sameStructure,
     buildShiftDetail,
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index 97f1dd3..994491c 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -1561,7 +1561,7 @@ describe('Phase 4: sub-coverage reversals are checked, never cleared blind', ()
     const submit = slice('async function submitConfirmSub()', 'async function unconfirmTimeOffSub(');
     expect(submit).toMatch(/\}, \{\}, \{ confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES \}\);/);
     // and the button's gate is the same list
-    expect(src).toMatch(/const canToggle = \(isOwner \|\| isAdmin\) && \['submitted', 'under_review', 'approved'\]\.includes\(req\.status\);/);
+    expect(src).toMatch(/const canToggle = \(s\.confirmed \? \(isOwner \|\| isAdmin\) : isAdmin\) && \['submitted', 'under_review', 'approved'\]\.includes\(req\.status\);/);
     // the data layer honours `confirmed`
     const fn = data.slice(data.indexOf('async function confirmTimeOffSub'), data.indexOf('// ─── Streak Data'));
     expect(fn).toMatch(/if \(want\.confirmed !== undefined && !!subs\[subIndex\]\.confirmed !== want\.confirmed\) return \{ success: false, reason: 'sub-changed', field: 'confirmed' \};/);
@@ -1622,7 +1622,11 @@ describe('Phase 4: sub-coverage reversals are checked, never cleared blind', ()
     // the owner cannot write the sub's schedule: for them a write failure is a hand-off, not "retry once fixed"
     expect(edit).toMatch(/if \(!isManagerUser\(\) && stuck\.length\) \{\s*const noted = await handOffSubRemovalToManager\(\{ id: editingTimeOffId, name: existingData\.name, requestStudios: existingData\.requestStudios \}, stuck\);/);
     expect(edit).toMatch(/if \(rest\.length\) alert\(failedSubsNote\(rest\)\);/);   // mixed failures: the rest are not hidden behind the hand-off
-    expect(edit).toMatch(/\} else \{\s*alert\(failedSubsNote\(subsResult\.failed\)\);\s*\}\s*\}\s*const carried = await carryCurrentSubs\(editingTimeOffId, subs\);\s*if \(!carried\) \{ giveBack\(\); return; \}\s*formData\.proposedSubs = carried\.subs;\s*saveGuard = \{ statuses: \[existingData\.status\], expect: \{ proposedSubs: carried\.current, appliedOverrides: requesterRecord \} \};/);
+    expect(edit).toMatch(/\} else \{\s*alert\(failedSubsNote\(subsResult\.failed\)\);\s*\}\s*\}\s*const carried = await carryCurrentSubs\(editingTimeOffId, subs\);\s*if \(!carried\) \{ giveBack\(\); return; \}/);
+    // the second check (plan: ticker-sub-confirm-only-by-manager) sits between the carry and the save, and the save
+    // guard now also expects the dates that read saw
+    expect(edit).toMatch(/const second = checkEditAgainstDocument\([^)]*docSubs: carried\.current, docDates: carried\.currentDates, reversedNames \}\);\s*if \(!second\.ok\) \{\s*giveBack\(\);/);
+    expect(edit).toMatch(/formData\.proposedSubs = carried\.subs;\s*saveGuard = \{ statuses: \[existingData\.status\], expect: \{ proposedSubs: carried\.current, appliedOverrides: requesterRecord, dates: carried\.currentDates \} \};/);
     expect(edit).not.toMatch(/await removeTimeOffOverrides\(subUid, appliedOverrides\)/);   // no bare, unchecked reversal remains
     // the save itself is GUARDED on status + the fresh subs + the requester's record (review finding: an
     // un-approve/re-approve or withdrawal in another tab was overwritten by the wholesale save)
@@ -1642,7 +1646,8 @@ describe('Phase 4: sub-coverage reversals are checked, never cleared blind', ()
     // the carry helper refuses the save on an unreadable request
     const carry = slice('async function carryCurrentSubs(requestId, subs)', '// What to tell the admin when a sub');
     expect(carry).toMatch(/const current = await getTimeOffRequestResult\(requestId\);\s*if \(!current\.ok \|\| !current\.exists\) \{\s*alert\([^)]*so it was not saved/);
-    expect(carry).toMatch(/return \{ subs: carryConfirmedSubs\(subs, current\.data\.proposedSubs\), current: currentSubs \};/);
+    expect(carry).toMatch(/return \{ subs: carryConfirmedSubs\(subs, current\.data\.proposedSubs\), current: currentSubs, currentDates \};/);
+    expect(carry).toMatch(/const currentDates = current\.data\.dates === undefined \? null : current\.data\.dates;/);   // absence stays null, never []
     // the note: per-reason wording, said BEFORE the save so "will be", and record-not-cleared is not a schedule failure
     const note = slice('function failedSubsNote(failed)', '// Dates a reversal deliberately left alone');
     expect(note).toMatch(/return `The request will be saved, BUT/);
@@ -2185,3 +2190,100 @@ describe('Notify an employee of a schedule change (Sep 17 2026)', () => {
     expect(pkg).toContain('schedule-dates-update.emulator.test.js');
   });
 });
+
+// ─── A sub is confirmed only by a manager (plan: ticker-sub-confirm-only-by-manager, Sep 29 2026) ────────
+// Ivy's request: her form's "They agreed to cover" checkbox saved the sub as confirmed with no shift and no
+// email, which hid Mark Confirmed from the manager. These pin that the form cannot confirm anyone, that only
+// a manager can, and that a stale edit form decides nothing.
+describe('a sub is confirmed only by a manager', () => {
+  const slice = (from, to) => { const a = src.indexOf(from); const b = src.indexOf(to, a); expect(a).toBeGreaterThan(-1); expect(b).toBeGreaterThan(a); return src.slice(a, b); };
+
+  test('the request form has no confirm control', () => {
+    expect(src).not.toMatch(/toggleFormSubConfirmed/);
+    expect(src).not.toMatch(/They agreed to cover/);
+    const render = slice('function renderTimeOffSubs()', '// ─── Submit Request');
+    expect(render).not.toMatch(/type="checkbox"/);
+  });
+
+  test('a new request saves every sub unconfirmed — AFTER the ...formData spread, or the spread would win', () => {
+    const create = slice('// Create new request', 'success = await addTimeOffRequest(request);');
+    const spread = create.indexOf('...formData,');
+    const forced = create.indexOf('proposedSubs: formData.proposedSubs.map(s => ({ ...s, confirmed: false })),');
+    expect(spread).toBeGreaterThan(-1);
+    expect(forced).toBeGreaterThan(spread);
+  });
+
+  test('openedSubs / openedDates are reset on every open and filled from the DOCUMENT at edit load', () => {
+    const open = slice('function openTimeOffForm(existingRequest)', '// Populate category dropdown');
+    expect(open).toMatch(/openedSubs = null;\s*openedDates = null;/);
+    const load = slice('    // Subs\n    timeoffFormSubs = (existingRequest.proposedSubs', 'renderTimeOffSubs();');
+    expect(load).toMatch(/entry: JSON\.parse\(JSON\.stringify\(timeoffFormSubs\[i\]\)\)/);
+    expect(load).toMatch(/hasRecord: Object\.keys\(s\.appliedOverrides \|\| \{\}\)\.length > 0/);
+    expect(load).toMatch(/openedDates = normalizeRequestDates\(existingRequest\.dates\);/);
+    expect(src).not.toMatch(/openedDates = [^;]*timeoffFormDates/);   // the form's rows are edited in place
+  });
+
+  test('re-adding a sub that was confirmed when the form opened restores a COPY of the original entry', () => {
+    const add = slice('function addTimeOffSub()', 'function removeTimeOffSub(');
+    expect(add).toMatch(/const opened = openedSubs && openedSubs\[name\];\s*if \(opened && opened\.confirmed\) \{\s*timeoffFormSubs\.push\(JSON\.parse\(JSON\.stringify\(opened\.entry\)\)\);/);
+  });
+
+  test('removing a confirmed sub asks first, and says when they cannot be added back', () => {
+    const remove = slice('function removeTimeOffSub(index)', 'function renderTimeOffSubs()');
+    expect(remove).toMatch(/if \(sub\.confirmed\) \{/);
+    expect(remove).toMatch(/if \(!confirm\(/);
+    expect(remove).toMatch(/can't be added back from this form/);
+  });
+
+  test('step 1 runs on the first read, BEFORE reconcile and any reversal, and gives the Save button back', () => {
+    const branch = slice('// Not a status reset', 'const subsResult = await reverseConfirmedTimeOffSubs(editingTimeOffId, existingData.proposedSubs, new Set(');
+    expect(branch).toMatch(/const first = checkEditAgainstDocument\(\{ openedSubs, openedDates, formSubs: formData\.proposedSubs, formDates: formData\.dates, docSubs: existingData\.proposedSubs, docDates: existingData\.dates \}\);\s*if \(!first\.ok\) \{\s*giveBack\(\);\s*alert\(editRefusalMessage\(first, formData\.proposedSubs\)\);\s*return;\s*\}\s*const \{ subs, toReverse \} = reconcileEditedProposedSubs/);
+  });
+
+  test('step 2 passes only LANDED reversals, and says removals stay removed only when there were some', () => {
+    const branch = slice('const carried = await carryCurrentSubs(editingTimeOffId, subs);', '// Update existing request');
+    expect(branch).toMatch(/const failedIdx = new Set\(subsResult\.failed\.map\(f => f\.index\)\);\s*const reversedNames = toReverse\.filter\(t => !failedIdx\.has\(t\.index\)\)\.map\(t => t\.name\);/);
+    expect(branch).toMatch(/const second = checkEditAgainstDocument\(\{ openedSubs, openedDates, /);
+    expect(branch).toMatch(/\$\{reversedNames\.length \? ' Any sub coverage removed above stays removed\.' : ''\}/);
+    // a sub this save removed that a manager re-confirmed before it: named, not a plain "Request saved"
+    expect(branch).toMatch(/reconfirmedNames = reversedNames\.filter\(n => \(carried\.current \|\| \[\]\)\.some\(c => c\.name === n && c\.confirmed\)\);/);
+    const after = slice('if (success) {\n    editingTimeOffId = null;', '} else {\n    alert(\'Failed to save. Please try again.\');');
+    expect(after).toMatch(/if \(reconfirmedNames\.length\) \{\s*alert\(`Saved\./);
+    expect(after).toMatch(/\} else \{\s*showToast\('Request saved'\);/);
+  });
+
+  test('the save-refusal text names a date change as a date change', () => {
+    expect(src).toMatch(/saved\.field === 'proposedSubs' \? 'its subs changed' : saved\.field === 'dates' \? 'its dates changed' : 'its schedule record changed'/);
+  });
+
+  test('step-1 refusal wording: never tells anyone to Undo for a date move they did not make', () => {
+    const msg = slice('function editRefusalMessage(check, formSubs)', 'async function handleSubmitTimeOff()');
+    const elsewhere = msg.slice(msg.indexOf("'dates-changed-elsewhere'"), msg.indexOf("// 'dates-while-confirmed'"));
+    expect(elsewhere).toMatch(/changed by someone else/);
+    expect(elsewhere).not.toMatch(/Undo/);
+    expect(msg).toMatch(/save that change on its own first/);
+  });
+
+  test('Mark Confirmed renders for managers only; the owner keeps Undo on a confirmed sub', () => {
+    expect(src).toMatch(/const canToggle = \(s\.confirmed \? \(isOwner \|\| isAdmin\) : isAdmin\) && /);
+    expect(src).toMatch(/Not confirmed\$\{isAdmin \? '' : ' · a manager confirms coverage'\}/);
+  });
+
+  test('the manager check sits AFTER the owner\'s Undo branch and BEFORE the roster match, and opens submitConfirmSub', () => {
+    const toggle = slice('async function handleSubConfirmToggle(requestId, subIndex)', 'function openConfirmSubModal(');
+    const undo = toggle.indexOf('await unconfirmTimeOffSub(req, subIndex, sub);');
+    const check = toggle.indexOf("if (!isManagerUser()) {\n      alert('Only a manager can confirm a sub.');");
+    const roster = toggle.indexOf('const match = resolveSubRosterMatch(sub.name, employeeRoster);');
+    expect(undo).toBeGreaterThan(-1);
+    expect(check).toBeGreaterThan(undo);
+    expect(roster).toBeGreaterThan(check);
+    const submit = slice('async function submitConfirmSub()', 'const ctx = _confirmSubCtx;');
+    expect(submit).toMatch(/if \(!isManagerUser\(\)\) \{\s*alert\('Only a manager can confirm a sub\.'\);\s*return;\s*\}/);
+  });
+
+  test('D3: the amber line comes from subMissingWriteNote and keeps the existing amber style', () => {
+    expect(src).toMatch(/const missingNote = s\.confirmed \? subMissingWriteNote\(s, resolveSubRosterMatch\(s\.name, employeeRoster\)\.status\) : '';/);
+    expect(src).toMatch(/const matchNote = missingNote \? `<div style="font-size:11px; color:var\(--amber\); margin-top:2px;">\$\{missingNote\}<\/div>` : '';/);
+    expect(src).not.toMatch(/if \(s\.confirmed && !s\.subUid\) \{/);   // the old gate missed a link-less sub with a matched name
+  });
+});
diff --git a/schedule-helpers.test.js b/schedule-helpers.test.js
index 36f7b55..1368132 100644
--- a/schedule-helpers.test.js
+++ b/schedule-helpers.test.js
@@ -29,6 +29,9 @@ const {
   applyScheduleEdits,
   isRealDate,
   carryConfirmedSubs,
+  normalizeRequestDates,
+  checkEditAgainstDocument,
+  subMissingWriteNote,
   partitionRollback,
   sameStructure,
   buildShiftDetail,
@@ -729,12 +732,16 @@ describe('carryConfirmedSubs (Phase 4: the document as it stands after the rever
     expect(out).toEqual([{ name: 'Kayleigh Wood', email: 'k@x.com', dates: [], confirmed: false, subUid: null, appliedOverrides: {} }]);
     // a link with an empty record (subUid only) counts as a link too
     expect(carryConfirmedSubs([{ name: 'K', confirmed: true, subUid: 'u', appliedOverrides: {} }], [{ name: 'K', confirmed: false }])[0].confirmed).toBe(false);
-    // but a newly ticked entry (no link) is the form's decision and stays
-    expect(carryConfirmedSubs([{ name: 'K', confirmed: true }], [{ name: 'K', confirmed: false }])[0].confirmed).toBe(true);
+    // and so does a link-less "confirmed" (Sep 29 2026, plan: ticker-sub-confirm-only-by-manager): the form can
+    // no longer confirm anyone, so the document decides. The old exemption let a stale edit form resurrect a
+    // confirmation a manager had just undone — Ivy's request.
+    expect(carryConfirmedSubs([{ name: 'K', confirmed: true }], [{ name: 'K', confirmed: false }])[0].confirmed).toBe(false);
   });
 
-  test('a sub the form newly ticked (confirmed, no write) stays ticked; a record with no subUid carries subUid null', () => {
-    expect(carryConfirmedSubs([{ name: 'New Person', confirmed: true }], [{ name: 'New Person', confirmed: false }])).toEqual([{ name: 'New Person', confirmed: true }]);
+  test('the document decides in both directions: a form "confirmed" the document lacks is stripped; a record with no subUid carries subUid null', () => {
+    expect(carryConfirmedSubs([{ name: 'New Person', confirmed: true }], [{ name: 'New Person', confirmed: false }])).toEqual([{ name: 'New Person', confirmed: false, subUid: null, appliedOverrides: {} }]);
+    // absent from the document entirely counts as not confirmed
+    expect(carryConfirmedSubs([{ name: 'New Person', confirmed: true }], [])[0].confirmed).toBe(false);
     expect(carryConfirmedSubs([{ name: 'K', confirmed: false }], [{ name: 'K', confirmed: true, appliedOverrides: REC }])[0]).toEqual({ name: 'K', confirmed: true, subUid: null, appliedOverrides: REC });
   });
 
@@ -2897,3 +2904,142 @@ describe('payroll snapshot shape (Sep 28) — findMalformedTotal', () => {
     for (const v of [null, undefined, 'x', 5, [1, 2]]) expect(findMalformedTotal(v)).toBeNull();
   });
 });
+
+// ─── A sub is confirmed only by a manager (plan: ticker-sub-confirm-only-by-manager, Sep 29 2026) ────────
+
+describe('normalizeRequestDates', () => {
+  test('a legacy date (no type, empty-string partials) equals itself after the edit form\'s load → save round-trip', () => {
+    const stored = [{ date: '2026-10-03', partialStart: '', partialEnd: '' }];
+    // what the form loads (app.js: type || 'full', partialStart || '') and then saves (null unless partial)
+    const loaded = stored.map(d => ({ date: d.date, type: d.type || 'full', partialStart: d.partialStart || '', partialEnd: d.partialEnd || '', flexible: d.flexible || false }));
+    const saved = loaded.map(d => ({ date: d.date, type: d.type, partialStart: d.type === 'partial' ? d.partialStart : null, partialEnd: d.type === 'partial' ? d.partialEnd : null, flexible: d.flexible || false }));
+    expect(sameStructure(normalizeRequestDates(stored), normalizeRequestDates(saved))).toBe(true);
+  });
+
+  test('type undefined, null and "" all mean full', () => {
+    const full = normalizeRequestDates([{ date: '2026-10-03', type: 'full' }]);
+    [undefined, null, ''].forEach(type => {
+      expect(normalizeRequestDates([{ date: '2026-10-03', type }])).toEqual(full);
+    });
+  });
+
+  test('order and the flexible flag do not matter; partial times do', () => {
+    const a = [{ date: '2026-10-04', type: 'full', flexible: true }, { date: '2026-10-03', type: 'partial', partialStart: '09:00', partialEnd: '12:00' }];
+    const b = [{ date: '2026-10-03', type: 'partial', partialStart: '09:00', partialEnd: '12:00' }, { date: '2026-10-04', type: 'full', flexible: false }];
+    expect(sameStructure(normalizeRequestDates(a), normalizeRequestDates(b))).toBe(true);
+    const c = [{ date: '2026-10-03', type: 'partial', partialStart: '09:00', partialEnd: '13:00' }, { date: '2026-10-04', type: 'full' }];
+    expect(sameStructure(normalizeRequestDates(a), normalizeRequestDates(c))).toBe(false);
+  });
+
+  test('full-day rows drop any stored partial times; a missing or non-array value is []', () => {
+    expect(normalizeRequestDates([{ date: '2026-10-03', type: 'full', partialStart: '09:00' }]))
+      .toEqual([{ date: '2026-10-03', type: 'full', partialStart: null, partialEnd: null }]);
+    expect(normalizeRequestDates(undefined)).toEqual([]);
+    expect(normalizeRequestDates(null)).toEqual([]);
+  });
+});
+
+describe('checkEditAgainstDocument — a stale edit form decides nothing', () => {
+  const OCT3 = [{ date: '2026-10-03', type: 'full' }];
+  const OCT4 = [{ date: '2026-10-04', type: 'full' }];
+  const opened = (confirmedByName) => Object.fromEntries(Object.entries(confirmedByName).map(([name, confirmed]) => [name, { confirmed, hasRecord: confirmed, entry: { name, confirmed } }]));
+  const base = { openedDates: normalizeRequestDates(OCT3), formDates: OCT3, docDates: OCT3 };
+
+  test('nothing moved → ok', () => {
+    expect(checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: true }), formSubs: [{ name: 'Sam', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: true }] })).toEqual({ ok: true });
+  });
+
+  test('round-1 race: form opened with Sam confirmed, a manager undid Sam → subs-changed', () => {
+    const r = checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: true }), formSubs: [{ name: 'Sam', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: false }] });
+    expect(r).toEqual({ ok: false, reason: 'subs-changed', names: ['Sam'] });
+  });
+
+  test('round-2 race: form opened with Sam unconfirmed, a manager confirmed Sam → subs-changed (no reversal can follow)', () => {
+    const r = checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: false }), formSubs: [{ name: 'Sam', confirmed: false }], docSubs: [{ name: 'Sam', confirmed: true }] });
+    expect(r.reason).toBe('subs-changed');
+  });
+
+  test('round-2 race, removal: Sam removed from a form that opened with him unconfirmed, confirmed meanwhile → subs-changed', () => {
+    const r = checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: false }), formSubs: [], docSubs: [{ name: 'Sam', confirmed: true }] });
+    expect(r).toEqual({ ok: false, reason: 'subs-changed', names: ['Sam'] });
+  });
+
+  test('removing a sub that was confirmed when the form opened is this edit\'s own change → ok', () => {
+    expect(checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: true }), formSubs: [], docSubs: [{ name: 'Sam', confirmed: true }] })).toEqual({ ok: true });
+  });
+
+  test('step 2: a landed reversal (reversedNames) is skipped; a removed sub confirmed meanwhile is NOT', () => {
+    // Sam removed and his reversal landed → unconfirmed on the document now: fine
+    expect(checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: true }), formSubs: [], docSubs: [{ name: 'Sam', confirmed: false }], reversedNames: ['Sam'] })).toEqual({ ok: true });
+    // Kayleigh removed while unconfirmed, confirmed between the reads, never reversed → refused
+    const r = checkEditAgainstDocument({ ...base, openedSubs: opened({ Kayleigh: false }), formSubs: [], docSubs: [{ name: 'Kayleigh', confirmed: true }], reversedNames: [] });
+    expect(r.reason).toBe('subs-changed');
+  });
+
+  test('a manager un-confirming a sub still in the form between the reads refuses step 2', () => {
+    const r = checkEditAgainstDocument({ ...base, openedSubs: opened({ Sam: true, Kayleigh: true }), formSubs: [{ name: 'Kayleigh', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: false }, { name: 'Kayleigh', confirmed: false }], reversedNames: ['Sam'] });
+    expect(r).toEqual({ ok: false, reason: 'subs-changed', names: ['Kayleigh'] });
+  });
+
+  test('dates moved by someone else → dates-changed-elsewhere, never D1 (even with a sub confirmed)', () => {
+    const r = checkEditAgainstDocument({ openedSubs: opened({ Sam: true }), openedDates: normalizeRequestDates(OCT3), formDates: OCT3, formSubs: [{ name: 'Sam', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: true }], docDates: OCT4 });
+    expect(r).toEqual({ ok: false, reason: 'dates-changed-elsewhere', names: [] });
+  });
+
+  test('dates moved by someone else with no sub confirmed → still refused (the old save wrote the old dates back)', () => {
+    const r = checkEditAgainstDocument({ openedSubs: opened({}), openedDates: normalizeRequestDates(OCT3), formDates: OCT3, formSubs: [], docSubs: [], docDates: OCT4 });
+    expect(r.reason).toBe('dates-changed-elsewhere');
+  });
+
+  test('D1: this user changed the dates while Sam is confirmed → dates-while-confirmed, naming Sam', () => {
+    const r = checkEditAgainstDocument({ ...base, formDates: OCT4, openedSubs: opened({ Sam: true }), formSubs: [{ name: 'Sam', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: true }] });
+    expect(r).toEqual({ ok: false, reason: 'dates-while-confirmed', names: ['Sam'] });
+  });
+
+  test('D1 does not fire with no sub confirmed, and a legacy date shape is not a date change', () => {
+    expect(checkEditAgainstDocument({ ...base, formDates: OCT4, openedSubs: opened({ Sam: false }), formSubs: [{ name: 'Sam', confirmed: false }], docSubs: [{ name: 'Sam', confirmed: false }] })).toEqual({ ok: true });
+    const legacy = [{ date: '2026-10-03', partialStart: '' }];
+    const resaved = [{ date: '2026-10-03', type: 'full', partialStart: null, partialEnd: null, flexible: false }];
+    expect(checkEditAgainstDocument({ openedSubs: opened({ Sam: true }), openedDates: normalizeRequestDates(legacy), formDates: resaved, formSubs: [{ name: 'Sam', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: true }], docDates: legacy })).toEqual({ ok: true });
+  });
+
+  test('D1 + removal of the confirmed sub is still D1 (the removal needs its own save)', () => {
+    const r = checkEditAgainstDocument({ ...base, formDates: OCT4, openedSubs: opened({ Sam: true }), formSubs: [], docSubs: [{ name: 'Sam', confirmed: true }] });
+    expect(r.reason).toBe('dates-while-confirmed');
+  });
+
+  test('reasons are ordered: subs-changed beats a date move', () => {
+    const r = checkEditAgainstDocument({ openedSubs: opened({ Sam: true }), openedDates: normalizeRequestDates(OCT3), formDates: OCT3, formSubs: [{ name: 'Sam', confirmed: true }], docSubs: [{ name: 'Sam', confirmed: false }], docDates: OCT4 });
+    expect(r.reason).toBe('subs-changed');
+  });
+
+  test('a missing openedDates throws — a default of [] would make every dated request look moved', () => {
+    expect(() => checkEditAgainstDocument({ openedSubs: {}, formSubs: [], formDates: OCT3, docSubs: [], docDates: OCT3 })).toThrow(/openedDates is required/);
+    expect(() => checkEditAgainstDocument({ openedSubs: {}, openedDates: null, formSubs: [], formDates: OCT3, docSubs: [], docDates: OCT3 })).toThrow();
+  });
+});
+
+describe('subMissingWriteNote — the amber line under a confirmed sub with no record of a shift', () => {
+  const REC = { '2026-10-03': { had: false, previousOverride: null, wrote: { start: '09:00', end: '15:00', studio: 'tinker' } } };
+
+  test('link-less confirmed (the requester-ticked shape) → the "no record" line when the roster matches', () => {
+    expect(subMissingWriteNote({ name: 'Sam', confirmed: true }, 'matched')).toMatch(/^Ticker has no record of a shift/);
+  });
+  test('a real record → nothing', () => {
+    expect(subMissingWriteNote({ name: 'Sam', confirmed: true, subUid: 'u', appliedOverrides: REC }, 'matched')).toBe('');
+  });
+  test('a record without a subUid (partial failure) → nothing: there IS a record', () => {
+    expect(subMissingWriteNote({ name: 'Sam', confirmed: true, subUid: null, appliedOverrides: REC }, 'matched')).toBe('');
+  });
+  test('a subUid with an empty record (legacy/fixtures) → the line: there is no record', () => {
+    expect(subMissingWriteNote({ name: 'Sam', confirmed: true, subUid: 'u', appliedOverrides: {} }, 'matched')).toMatch(/no record/);
+  });
+  test('unconfirmed (including dismissed entries) → nothing', () => {
+    expect(subMissingWriteNote({ name: 'Sam', confirmed: false, dismissedOverrides: REC }, 'matched')).toBe('');
+  });
+  test('an unmatched / ambiguous / unclaimed name keeps today\'s "add their shift manually" notes', () => {
+    expect(subMissingWriteNote({ name: 'X', confirmed: true }, 'no-match')).toMatch(/No matching roster entry/);
+    expect(subMissingWriteNote({ name: 'X', confirmed: true }, 'ambiguous')).toMatch(/Multiple roster entries/);
+    expect(subMissingWriteNote({ name: 'X', confirmed: true }, 'unclaimed')).toMatch(/hasn’t signed in yet/);
+  });
+});
