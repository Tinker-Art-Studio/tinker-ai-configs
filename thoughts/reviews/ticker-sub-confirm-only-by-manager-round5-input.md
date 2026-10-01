## Focused check (ROUND 5, fix-for-the-fix): v4 -> v5 edits only
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html (v5). Round-4 reviews:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-round4-{claude,codex}.md.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests, no deploys).

Review ONLY the diff below (v4 -> v5). For each change: does it correctly resolve the round-4 finding it cites, and does it
introduce any new defect (wrong schedule write, false confirmation, false refusal, contradiction with the rest of the plan)?
Especially: the new openedDates / 'dates-changed-elsewhere' reason (ordering vs D1 at step 1 and step 2, and vs the transaction
guard); re-add restoring the entry verbatim; subMissingWriteNote owning the gate.
Rank BLOCKING / MEDIUM / LOW with evidence. End with: execution-ready yes/no.

## Diff
--- /private/tmp/claude-501/-Users-christiehubley-tinker-timeclock/92756f73-ecc1-41ac-bd54-eb53fa5189a2/scratchpad/plan-v4.html	2026-09-29 15:56:25
+++ ../plans/ticker-sub-confirm-only-by-manager.html	2026-09-29 15:56:25
@@ -21,9 +21,9 @@
 <body>
 <h1>Plan: A sub is confirmed only by a manager, on the request's real dates</h1>
 <p><strong>App:</strong> Tinker Ticker (<code>~/tinker-timeclock</code>) &middot; <strong>Drafted:</strong> Sep 29 2026
-&middot; <strong>v4</strong> after design review rounds 1&ndash;3 (Claude + Codex each round; round 3: Codex no BLOCKING,
-Claude two cheap BLOCKING; every finding folded in or answered in the Decisions Log) &middot; <strong>execution-ready: false</strong>
-&mdash; <em>waiting on a round-4 check of v4, then Christie's written approval to edit the repo.</em></p>
+&middot; <strong>v5</strong> after design review rounds 1&ndash;4 (round 4: Codex "execution-ready: yes", no findings;
+Claude no BLOCKING, three plan-text MEDIUMs, folded in here) &middot; <strong>execution-ready: false</strong>
+&mdash; <em>waiting on a short check of the v5 edits, then Christie's written approval to edit the repo.</em></p>
 
 <div class="status">
   <strong>Goal:</strong> a sub shows as <strong>Confirmed</strong> only after a manager used <strong>Mark
@@ -69,8 +69,8 @@
 
 <h2>Christie's decisions (Sep 29)</h2>
 <div class="decision-needed">
-<p><strong>D1: refuse</strong> an edit that changes the dates while any sub is confirmed: <em>"Sam is confirmed to cover
-this request. Ask a manager to Undo Sam first, then change the dates."</em></p>
+<p><strong>D1: refuse</strong> an edit that changes the dates while any sub is confirmed (exact wording under "The one rule";
+it distinguishes "you changed them" from "someone else did").</p>
 <p><strong>D2: yes</strong>, the confirm box lists the request's dates as checkboxes (roster-matched subs; the
 unmatched-name path writes no schedule and is unchanged).</p>
 <p><strong>D3: yes</strong>, a display-only amber line when a confirmed sub has no record of a shift being added,
@@ -81,31 +81,42 @@
 <p>Once the checkbox is gone, <strong>the edit form has no say over <code>confirmed</code></strong>. The form remembers
 each sub's state as it was when the form <em>opened</em> (<code>openedSubs</code>: name &rarr; <code>{ confirmed, hasRecord }</code>,
 reset at the top of <code>openTimeOffForm</code> beside <code>timeoffFormSubs</code> (<code>js/app.js:7021</code>), filled only
-in the edit branch). <strong>Re-adding a removed name that <code>openedSubs</code> says was confirmed restores the original
+in the edit branch), and the request's dates as loaded (<code>openedDates</code>, same lifecycle). <strong>Re-adding a removed name that <code>openedSubs</code> says was confirmed restores the original
 entry</strong> (<code>confirmed: true</code>, so reconcile carries its link and nothing reverses): removing then re-adding
 is an undo, not an un-confirm (round 3, both reviewers). At save, if the document
 disagrees with that memory for any sub still in the form, the save is refused: <em>"A manager confirmed or un-confirmed a
 sub while you were editing, so nothing was saved. Close this form, reopen the request, and try again."</em> A form that
-is out of date can't decide anything, in either direction. This closes the round-1 race (stale "confirmed"), the round-2
+is out of date can't decide anything, in either direction. The one deliberate exception (round 4, Claude L7): if Ivy removes a
+confirmed Sam, the reversal lands, and a manager re-confirms Sam before the save, the manager's newer confirmation wins and Sam
+stays. That's consistent data, and the manager acted last. This closes the round-1 race (stale "confirmed"), the round-2
 race (stale "unconfirmed" → reversal) and the "removed a sub that just got confirmed without seeing the × prompt" race
 in one check. <code>carryConfirmedSubs</code> also loses its <code>hasLink</code> exemption, as defence in depth.</p>
 <p>The check is a pure helper, <code>checkEditAgainstDocument({ openedSubs, formSubs, formDates, docSubs, docDates })</code>
 in <code>js/schedule-helpers.js</code>, taking an optional <code>reversedNames</code>, returning <code>{ ok: true }</code> or <code>{ ok: false, reason: 'subs-changed' |
-'dates-while-confirmed', names }</code>. It is the real exported function, so its unit tests exercise production code
+'dates-while-confirmed' | 'dates-changed-elsewhere', names }</code>,
+and also takes <code>openedDates</code>. It is the real exported function, so its unit tests exercise production code
 (round 2, Claude M4: the emulator harness re-implements app logic and can't test the orchestration itself).</p>
 <ul>
   <li><strong>subs-changed:</strong> for each sub name in <code>formSubs</code>, the document's <code>confirmed</code>
   ≠ <code>openedSubs</code>' <code>confirmed</code> (absent on either side counts as unconfirmed). For each sub the form
   <em>removed</em>: the document now says confirmed but <code>openedSubs</code> said unconfirmed (it was confirmed after the
   form opened, so the × prompt never showed). An optional <code>reversedNames</code> set is skipped entirely (step 2 only).</li>
-  <li><strong>dates-while-confirmed (D1):</strong> any sub is confirmed on the document AND
-  <code>normalizeRequestDates(formDates)</code> ≠ <code>normalizeRequestDates(docDates)</code>.</li>
+  <li><strong>dates-changed-elsewhere</strong> (checked first; round 4, Claude M1): <code>normalizeRequestDates(docDates)</code>
+  ≠ <code>normalizeRequestDates(openedDates)</code>. Someone else moved the dates since the form opened, so this user can't be
+  told they changed them. Message: <em>"This request's dates were changed by someone else while you were editing, so nothing was
+  saved. Close this form and reopen the request."</em> It never tells anyone to Undo a sub.</li>
+  <li><strong>dates-while-confirmed (D1):</strong> the document's dates still equal <code>openedDates</code>, any sub is confirmed on
+  the document, AND <code>normalizeRequestDates(formDates)</code> ≠ <code>normalizeRequestDates(docDates)</code>, so this user did
+  change them. Message: <em>"Sam is confirmed to cover this request. Sam has to be un-confirmed (Undo, by a manager if Sam's shift
+  is on their schedule) before the dates can change."</em> The wording works for a manager editing too (round 4, Claude L9).</li>
   <li><code>normalizeRequestDates</code> (round 2, Claude B1 + Codex): sort by <code>date</code>; <code>type</code> missing
   → <code>'full'</code>; <code>partialStart</code>/<code>partialEnd</code> kept only when <code>type === 'partial'</code>, with
   <code>''</code>/<code>undefined</code> → <code>null</code>; <code>flexible</code> dropped. Precisely <code>type: d.type || 'full'</code>,
   so stored <code>undefined</code>, <code>null</code> and <code>''</code> all mean full, matching the load (round 3, Codex).
   Known limit (round 3, Claude L2): a hand-edited <code>type: 'partial'</code> with no times can't round-trip, because the form
-  forces times in, so D1 refuses its edits while a sub is confirmed. No app path writes that shape. So a legacy document compares
+  forces times in, so D1 refuses its edits while a sub is confirmed. The same goes for a stored <code>date: ''</code> row or a
+  request with no <code>dates</code>, which <code>validDates</code> (<code>:7331</code>) drops. No app path writes these shapes
+  (round 4, Claude L9). So a legacy document compares
   equal to itself after the form's load (<code>:7063</code>: <code>|| 'full'</code>, <code>|| ''</code>) and save
   (<code>:7366</code>: <code>null</code> when not partial).</li>
 </ul>
@@ -126,7 +137,9 @@
   edits were NOT saved. Any sub coverage removed above stays removed. Close this form, reopen the request, and try again."</em>
   The step-1 refusal really is clean and says "nothing was saved or changed". Both call <code>giveBack()</code> before
   returning (round 3, Claude L1).</li>
-  <li>The transaction: <code>saveGuard.expect</code> gains <code>dates: carried.currentDates</code>, so a date change
+  <li>The transaction: <code>saveGuard.expect</code> gains <code>dates: carried.currentDates</code> (and the refusal text at
+  <code>:7485</code> gains a <code>saved.field === 'dates' ? 'its dates changed'</code> arm, so it no longer says "its schedule
+  record changed" for a date change (round 4, Claude M2); the ratchet pins that arm), so a date change
   between step 2 and the write refuses via <code>updateTimeOffRequestIfStatus</code>'s generic <code>expect</code> loop
   (<code>js/firebase-data.js:865</code>). A confirm landing in that window is already caught by
   <code>expect.proposedSubs</code>.</li>
@@ -165,7 +178,10 @@
   <code>renderTimeOffSubs</code>/<code>removeTimeOffSub</code>. <code>openedSubs</code> (name → <code>{confirmed, hasRecord}</code>)
   is reset in <code>openTimeOffForm</code> and filled from <code>existingRequest.proposedSubs</code> at <code>:7068</code>, never
   reconstructed at submit. The edit-load mapping keeps each entry's <code>confirmed</code>. <code>addTimeOffSub</code> restores a
-  removed name's original entry when <code>openedSubs[name].confirmed</code>. Name-keyed like reconcile and carry
+  removed name's <strong>original entry verbatim</strong> (its own <code>dates</code> and <code>email</code>, kept in
+  <code>openedSubs</code>) when <code>openedSubs[name].confirmed</code>, not a rebuilt one (round 4, Claude L2). Known limit: a
+  confirmed sub whose name is no longer in the picker (inactive roster entry, legacy free text) can't be re-added, so for them
+  × is final. The × prompt says so in that case: <em>"…and Sam can't be added back from this form."</em> Name-keyed like reconcile and carry
   (<code>js/schedule-helpers.js:989</code>, <code>:1030</code>): two subs with one name is a known shared assumption.</li>
   <li><code>checkEditAgainstDocument</code> + <code>normalizeRequestDates</code> in <code>schedule-helpers.js</code> (exported),
   called at the two points above. <code>carryCurrentSubs</code> returns <code>currentDates</code>. <code>saveGuard.expect.dates</code>.</li>
@@ -184,8 +200,9 @@
   <code>s.confirmed &amp;&amp; !Object.keys(s.appliedOverrides || {}).length</code>. Inside it, an unmatched / ambiguous /
   unclaimed roster status shows today's note (manager adds the shift by hand). A <code>matched</code> status shows the new
   line: <em>"Ticker has no record of a shift being added to their schedule for this. Check their schedule, or Undo and use
-  Mark Confirmed."</em> The mapping is a pure exported helper, <code>subMissingWriteNote(sub, rosterStatus)</code>, so the five
-  shapes below are unit assertions, not prose (round 3, Claude). The wording claims "no record", not "no shift" (round 2, Codex M4). Cases: link-less (amber);
+  Mark Confirmed."</em> The whole predicate is a pure exported helper, <code>subMissingWriteNote(sub, rosterStatus)</code>, which returns the note
+  or <code>''</code> (gate included). <code>:7615</code> becomes <code>const matchNote = subMissingWriteNote(s,
+  resolveSubRosterMatch(s.name, employeeRoster).status)</code>, so the five shapes below are unit assertions (round 4, Claude M3). The wording claims "no record", not "no shift" (round 2, Codex M4). Cases: link-less (amber);
   a real record (none); a record without <code>subUid</code>, the partial-failure state (none); <code>subUid</code> with an
   empty record, legacy/fixtures (amber, correct: no record); <code>dismissedOverrides</code> entries (none, they are unconfirmed).</li>
 </ul>
@@ -195,7 +212,13 @@
 <code>&lt;select&gt;</code> is gated (<code>:7740</code>) (round 3, Claude L5). A page running an old cached
 <code>app.js</code> (the service worker is cache-first; <code>CACHE_NAME</code> is bumped by hand, <code>sw.js:64</code>) has
 none of these checks until it refreshes. The deploy bumps it. D3's amber line is the net for anything that slips through.
-A rules-level guarantee would need a rules release through the guard and is out of scope.</div>
+A rules-level guarantee would need a rules release through the guard and is out of scope.
+<br><br>Also deliberate: the unmatched-name confirm (<code>:7865</code>) passes no <code>dates</code> guard. It writes no schedule,
+and D3's amber line surfaces its result (round 4, Claude L10). Pre-existing and unchanged: in <code>confirmTimeOffSub</code> the
+<code>status-changed</code> check (<code>js/firebase-data.js:800</code>) precedes the <code>confirmed</code> check, so a status change
+concurrent with another manager's confirm of the same sub still takes the full rollback. <code>removeTimeOffOverrides</code>'
+<code>stillHoldsWhatWeWrote</code> (<code>js/timeoff-schedule.js:194</code>) is the net there. The new ordered ratchet covers only
+<code>confirmed</code> vs <code>dates</code> (round 4, Claude L8).</div>
 <div class="bdd"><strong>Happy:</strong> Ivy submits naming Sam → a manager sees "Not confirmed · Mark Confirmed" →
 Confirm writes Sam's shift and one combined email goes to Sam and Ivy.</div>
 <div class="bdd"><strong>Edge (round-1 race):</strong> Ivy's form opens with Sam confirmed → a manager Undoes Sam in another
@@ -216,6 +239,9 @@
 <div class="bdd"><strong>Failure (D1):</strong> Sam confirmed on an under-review Oct 3 request → Ivy changes it to Oct 4 → the
 D1 message; nothing saved or reversed; the form stays open. The same with Sam also removed → D1 message + "save that change
 on its own first".</div>
+<div class="bdd"><strong>Edge (dates moved by someone else, round 4):</strong> Ivy's form opens on Oct 3 with Sam confirmed →
+a manager moves the request to Oct 4 → Ivy saves a reason-only edit → "changed by someone else… reopen" (no Undo advice). After
+reopening, her reason edit saves.</div>
 <div class="bdd"><strong>Failure (D1 mid-save race):</strong> Ivy's unconfirmed Oct 3 request is edited to Oct 4 → a manager
 confirms Sam between the first read and the save → refused at the second check or by the transaction's
 <code>expect.proposedSubs</code>/<code>dates</code>.</div>
@@ -257,7 +283,8 @@
   <li>No dates ticked → "Tick at least one date", and nothing is written. The existing "This sub has no covered dates"
   (<code>:7953</code>) remains only for a request that itself has no dates (legacy/hand-edited).</li>
   <li>Closing the box (Cancel or ×) clears <code>_confirmSubCtx</code> through one <code>closeConfirmSubModal()</code>
-  helper. <code>submitConfirmSub</code> refuses unless the box is open (round 2, Codex M6).</li>
+  helper, and both inline handlers (<code>index.html:1183</code> ×, <code>:1201</code> Cancel) are rewired to call it and ratcheted
+  (round 4, Claude L1). <code>submitConfirmSub</code> refuses unless the box is open (round 2, Codex M6).</li>
   <li>Nothing on the saved request changes. <code>getSubCoverageDates</code> keeps its meaning (its "empty array → no
   dates" test stays green); the "all dates" fallback lives in the pre-tick helper.</li>
   <li>Pre-existing bug fixed in passing: <code>`${dates}`</code> at <code>:8044</code> is an undefined identifier that turns
@@ -312,7 +339,9 @@
   <code>openTimeOffDetail</code> (which renders "Request not found").</li>
   <li><strong>The write is guarded on what was checked (round 3, Codex M2):</strong> when the read succeeded, Secured is written with
   <code>updateTimeOffRequestIfStatus(requestId, [read.status], { coverageStatus }, { proposedSubs: read.proposedSubs })</code>.
-  If a sub was confirmed or undone in between → "The subs changed while you were choosing; nothing was saved", then re-render.
+  If a sub was confirmed or undone in between (<code>changed</code>) → "The subs changed while you were choosing; nothing was
+  saved". <code>status-changed</code> (e.g. auto-completed) → "This request's status changed; nothing was saved".
+  <code>not-found</code> → "This request no longer exists". Each then re-renders (round 4, Claude L4).
   Only the failed-read "anyway" path and the non-Secured statuses use the plain write.</li>
   <li>A failed label write → an error message, no "Coverage updated" toast, and the detail re-renders.</li>
   <li>The duplicate <code>renderAdminAllTimeOff()</code> (<code>:8253–8254</code>) is dropped.</li>
@@ -349,12 +378,15 @@
   ways); <code>normalizeRequestDates</code> (order, missing type, <code>''</code>/null/undefined partials, full-day partials,
   flexible ignored, and a legacy doc equal to its own load→save round-trip); <code>checkEditAgainstDocument</code> (stale
   confirmed, stale unconfirmed, removal of a since-confirmed sub, removed subs excluded at the second check, D1 with/without a
-  confirmed sub, D1 + removal, <code>reversedNames</code> skipping only landed reversals, the remove-then-re-add case);
+  confirmed sub, D1 + removal, <code>reversedNames</code> skipping only landed reversals, dates-changed-elsewhere vs
+dates-while-confirmed);
 <code>confirmDatePreticks</code>; <code>unconfirmedSubNames</code>; <code>subMissingWriteNote</code> (the five shapes × roster
 statuses). <code>normalizeRequestDates</code> also covers <code>type</code> <code>null</code>/<code>''</code>.</li>
   <li><strong>Emulator:</strong> <code>timeoff-sub-confirm.emulator.test.js</code> gains the dates guard (refused when the
   request's dates changed; the entry stays unconfirmed; a legacy-shaped vs normalized pair is NOT a change; and dates changed
-  <em>plus</em> the entry confirmed by someone else returns <code>sub-changed</code>, not <code>changed</code>). As that file states (<code>:8–12</code>), it mirrors the transaction
+  <em>plus</em> the entry confirmed by someone else returns <code>sub-changed</code>, not <code>changed</code>). The mirror copies
+  <code>normalizeRequestDates</code> verbatim beside its existing verbatim <code>sameStructure</code> (<code>:37</code>), and the
+  source ratchet pins both copies against <code>js/schedule-helpers.js</code> (round 4, Claude L5). As that file states (<code>:8–12</code>), it mirrors the transaction
   rather than requiring <code>app.js</code>. Its source ratchet is what ties the mirror to the real code. No new emulator test
   claims to cover the edit orchestration; the harness can't (round 2, Claude M4).</li>
   <li><strong>Wiring ratchets:</strong> no <code>toggleFormSubConfirmed</code>; Mark Confirmed only under <code>isAdmin</code>
@@ -367,7 +399,11 @@
   <code>ctx.dates</code> is assigned from the checked inputs before the <code>overridesToWrite</code> loop; <code>lead</code> has a
   <code>field === 'dates'</code> wording pinned beside the existing two leads; the create-branch <code>confirmed: false</code> map
   sits after <code>...formData</code>; <code>openedSubs</code> is reset in <code>openTimeOffForm</code> and filled at edit load;
-  <code>addTimeOffSub</code> restores a confirmed opened entry; the step-2 call passes landed <code>reversedNames</code> and its
+  <code>addTimeOffSub</code> restores a confirmed opened entry verbatim
+(this, plus the existing reconcile tests at <code>schedule-helpers.test.js:637–643</code>, is the remove-then-re-add protection;
+<code>checkEditAgainstDocument</code> can't see the form flag, round 4 Claude L3); the <code>:7485</code> refusal has a
+<code>'dates'</code> arm; the null-override dates are collected and reported (a ratchet on the <code>:7973</code> branch, round 4
+Claude L6); the step-2 call passes landed <code>reversedNames</code> and its
   refusal carries "stays removed" and <code>giveBack()</code>; <code>closeConfirmSubModal</code> nulls the context; <code>updateCoverageStatus</code> reads fresh,
   calls <code>openTimeOffDetail</code> before returning on Cancel and on not-found, writes Secured through
   <code>updateTimeOffRequestIfStatus</code> with <code>proposedSubs</code> expected, and checks the write result; the D3 gate uses
@@ -413,7 +449,8 @@
 <h2>Progress</h2>
 <ul>
   <li>Sep 29: v1 → round 1 (both "not ready") → v2 → D1–D3 answered → round 2 (both "not ready", "much closer") → v3 →
-  round 3 (Codex: no BLOCKING, 3 MEDIUM; Claude: 2 BLOCKING, both one-sentence fixes) → v4. Nothing executed.</li>
+  round 3 (Codex: no BLOCKING, 3 MEDIUM; Claude: 2 BLOCKING, both one-sentence fixes) → v4 → round 4 (Codex: execution-ready,
+  no findings; Claude: no BLOCKING, 3 MEDIUM plan-text) → v5. Nothing executed.</li>
 </ul>
 
 <h2>Decisions Log</h2>
@@ -462,6 +499,13 @@
       trap-box wording; <code>openedSubs</code> reset; the name-keyed assumption; test titles rewritten; not_needed also
       recomputed; pre-existing non-atomic windows stated.</li>
     </ul></li>
+  <li><strong>Sep 29, round 4 → v5:</strong> Codex: "execution-ready: yes", no findings. Claude: no BLOCKING. MEDIUM M1: the D1
+  message could tell someone to Undo real coverage for a date change they didn't make; now <code>openedDates</code> gives a
+  separate "changed by someone else" reason. M2: the <code>:7485</code> refusal gets a <code>'dates'</code> arm. M3:
+  <code>subMissingWriteNote</code> owns the whole predicate. LOW folded in: close handlers rewired, the re-add restores the entry
+  verbatim and states its limits, the re-add test claim is moved to where it's true, Phase 3's other refusal reasons, the mirror
+  copies <code>normalizeRequestDates</code>, the null-override ratchet, the manager re-confirm exception, the status-before-confirmed
+  note, the D1 wording for managers, and the unmatched-path note.</li>
 </ul>
 </body>
 </html>
