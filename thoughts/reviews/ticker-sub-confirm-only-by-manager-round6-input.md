## Focused check (ROUND 6, fix-for-the-fix): v5 -> v6 edits only
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html (v6). Round-5 reviews:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-round5-{claude,codex}.md.
Repo /Users/christiehubley/tinker-timeclock is READ-ONLY for you (no edits, no tests, no deploys).

Review ONLY the diff below (v5 -> v6). For each change: does it correctly resolve the round-5 finding it cites, and does it
introduce any new defect (wrong schedule write, false confirmation, false refusal, contradiction with the rest of the plan)?
Especially: openedSubs.entry deep-copy restore, openedDates source + required argument, reason order subs-changed -> dates-changed-elsewhere -> D1, step-2 generic wording, Phase 3 status tolerance.
Rank BLOCKING / MEDIUM / LOW with evidence. End with: execution-ready yes/no.

## Diff
--- /private/tmp/claude-501/-Users-christiehubley-tinker-timeclock/92756f73-ecc1-41ac-bd54-eb53fa5189a2/scratchpad/plan-v5.html	2026-09-29 16:04:22
+++ ../plans/ticker-sub-confirm-only-by-manager.html	2026-09-29 16:05:39
@@ -21,9 +21,9 @@
 <body>
 <h1>Plan: A sub is confirmed only by a manager, on the request's real dates</h1>
 <p><strong>App:</strong> Tinker Ticker (<code>~/tinker-timeclock</code>) &middot; <strong>Drafted:</strong> Sep 29 2026
-&middot; <strong>v5</strong> after design review rounds 1&ndash;4 (round 4: Codex "execution-ready: yes", no findings;
-Claude no BLOCKING, three plan-text MEDIUMs, folded in here) &middot; <strong>execution-ready: false</strong>
-&mdash; <em>waiting on a short check of the v5 edits, then Christie's written approval to edit the repo.</em></p>
+&middot; <strong>v6</strong> after design review rounds 1&ndash;5 (round 5 checked only the v5 edits: both reviewers, no
+BLOCKING, no wrong schedule write or false confirmation; four plan-text MEDIUMs, folded in here) &middot; <strong>execution-ready: false</strong>
+&mdash; <em>waiting on a short check of the v6 edits, then Christie's written approval to edit the repo.</em></p>
 
 <div class="status">
   <strong>Goal:</strong> a sub shows as <strong>Confirmed</strong> only after a manager used <strong>Mark
@@ -79,32 +79,42 @@
 
 <h2>The one rule behind Phase 1</h2>
 <p>Once the checkbox is gone, <strong>the edit form has no say over <code>confirmed</code></strong>. The form remembers
-each sub's state as it was when the form <em>opened</em> (<code>openedSubs</code>: name &rarr; <code>{ confirmed, hasRecord }</code>,
-reset at the top of <code>openTimeOffForm</code> beside <code>timeoffFormSubs</code> (<code>js/app.js:7021</code>), filled only
-in the edit branch), and the request's dates as loaded (<code>openedDates</code>, same lifecycle). <strong>Re-adding a removed name that <code>openedSubs</code> says was confirmed restores the original
+each sub's state as it was when the form <em>opened</em> (<code>openedSubs</code>: name &rarr; <code>{ confirmed, hasRecord, entry }</code>, where <code>entry</code> is a deep copy of the
+form-shaped object built at <code>:7068</code> (<code>{name, email, dates, confirmed}</code>), reset at the top of
+<code>openTimeOffForm</code> beside <code>timeoffFormSubs</code> (<code>js/app.js:7021</code>), filled only in the edit branch), and
+the request's dates as loaded (<code>openedDates = normalizeRequestDates(existingRequest.dates)</code>: a fresh array computed
+from the <strong>document</strong>, never from, or aliasing, <code>timeoffFormDates</code>, whose rows the inline handlers mutate
+in place (<code>:7120–7122</code>). Otherwise every legitimate date edit would look like "someone else changed the dates" and D1
+would never fire (round 5, Claude M3 / Codex M1). It is reset with <code>openedSubs</code>.) <strong>Re-adding a removed name that <code>openedSubs</code> says was confirmed restores the original
 entry</strong> (<code>confirmed: true</code>, so reconcile carries its link and nothing reverses): removing then re-adding
 is an undo, not an un-confirm (round 3, both reviewers). At save, if the document
 disagrees with that memory for any sub still in the form, the save is refused: <em>"A manager confirmed or un-confirmed a
 sub while you were editing, so nothing was saved. Close this form, reopen the request, and try again."</em> A form that
 is out of date can't decide anything, in either direction. The one deliberate exception (round 4, Claude L7): if Ivy removes a
 confirmed Sam, the reversal lands, and a manager re-confirms Sam before the save, the manager's newer confirmation wins and Sam
-stays. That's consistent data, and the manager acted last. This closes the round-1 race (stale "confirmed"), the round-2
+stays. That's consistent data, and the manager acted last. The save then says so rather than reporting plain success: <em>"Saved.
+Sam was re-confirmed by a manager while you were editing, so Sam stays on this request."</em> (round 5, Claude L8). This closes the round-1 race (stale "confirmed"), the round-2
 race (stale "unconfirmed" → reversal) and the "removed a sub that just got confirmed without seeing the × prompt" race
 in one check. <code>carryConfirmedSubs</code> also loses its <code>hasLink</code> exemption, as defence in depth.</p>
-<p>The check is a pure helper, <code>checkEditAgainstDocument({ openedSubs, formSubs, formDates, docSubs, docDates })</code>
-in <code>js/schedule-helpers.js</code>, taking an optional <code>reversedNames</code>, returning <code>{ ok: true }</code> or <code>{ ok: false, reason: 'subs-changed' |
-'dates-while-confirmed' | 'dates-changed-elsewhere', names }</code>,
-and also takes <code>openedDates</code>. It is the real exported function, so its unit tests exercise production code
+<p>The check is a pure helper, <code>checkEditAgainstDocument({ openedSubs, openedDates, formSubs, formDates, docSubs, docDates,
+reversedNames })</code> in <code>js/schedule-helpers.js</code> (<code>reversedNames</code> optional, step 2 only), returning
+<code>{ ok: true }</code> or <code>{ ok: false, reason: 'subs-changed' | 'dates-changed-elsewhere' | 'dates-while-confirmed', names }</code>.
+The reasons are evaluated <strong>in that order</strong> (round 5, Claude L4), so the sub-race BDDs (dates untouched) resolve to
+<code>subs-changed</code>, and a date move by someone else is reported before D1 can give Undo advice. A missing
+<code>openedDates</code> argument throws rather than defaulting to <code>[]</code>, because a default would false-refuse every dated
+request (round 5, Codex M1). It is the real exported function, so its unit tests exercise production code
 (round 2, Claude M4: the emulator harness re-implements app logic and can't test the orchestration itself).</p>
 <ul>
   <li><strong>subs-changed:</strong> for each sub name in <code>formSubs</code>, the document's <code>confirmed</code>
   ≠ <code>openedSubs</code>' <code>confirmed</code> (absent on either side counts as unconfirmed). For each sub the form
   <em>removed</em>: the document now says confirmed but <code>openedSubs</code> said unconfirmed (it was confirmed after the
   form opened, so the × prompt never showed). An optional <code>reversedNames</code> set is skipped entirely (step 2 only).</li>
-  <li><strong>dates-changed-elsewhere</strong> (checked first; round 4, Claude M1): <code>normalizeRequestDates(docDates)</code>
+  <li><strong>dates-changed-elsewhere</strong> (checked after subs-changed and before D1; round 4, Claude M1): <code>normalizeRequestDates(docDates)</code>
   ≠ <code>normalizeRequestDates(openedDates)</code>. Someone else moved the dates since the form opened, so this user can't be
   told they changed them. Message: <em>"This request's dates were changed by someone else while you were editing, so nothing was
-  saved. Close this form and reopen the request."</em> It never tells anyone to Undo a sub.</li>
+  saved. Close this form and reopen the request."</em> It never tells anyone to Undo a sub. This fires whether or not any sub is confirmed, which is a deliberate small scope
+  widening: today such a save silently writes the old dates back over the other person's change (<code>:7363</code>) (round 5,
+  Claude L1).</li>
   <li><strong>dates-while-confirmed (D1):</strong> the document's dates still equal <code>openedDates</code>, any sub is confirmed on
   the document, AND <code>normalizeRequestDates(formDates)</code> ≠ <code>normalizeRequestDates(docDates)</code>, so this user did
   change them. Message: <em>"Sam is confirmed to cover this request. Sam has to be un-confirmed (Undo, by a manager if Sam's shift
@@ -116,7 +126,8 @@
   Known limit (round 3, Claude L2): a hand-edited <code>type: 'partial'</code> with no times can't round-trip, because the form
   forces times in, so D1 refuses its edits while a sub is confirmed. The same goes for a stored <code>date: ''</code> row or a
   request with no <code>dates</code>, which <code>validDates</code> (<code>:7331</code>) drops. No app path writes these shapes
-  (round 4, Claude L9). So a legacy document compares
+  (round 4, Claude L9). Every <em>other</em> stored shape, i.e. every shape the app writes plus legacy
+  missing/falsy <code>type</code> and empty-string partials, compares
   equal to itself after the form's load (<code>:7063</code>: <code>|| 'full'</code>, <code>|| ''</code>) and save
   (<code>:7366</code>: <code>null</code> when not partial).</li>
 </ul>
@@ -135,14 +146,19 @@
   removed subs may already have landed, and another tab may have moved the document's dates. So its message carries the same
   clause as the transaction refusal at <code>:7485</code>: <em>"A sub or the dates changed while you were editing, so your
   edits were NOT saved. Any sub coverage removed above stays removed. Close this form, reopen the request, and try again."</em>
-  The step-1 refusal really is clean and says "nothing was saved or changed". Both call <code>giveBack()</code> before
+  <strong>The per-reason wordings below are step-1 only.</strong> At step 2, all three reasons use this one generic sentence,
+  because a removal may already have landed (round 5, Claude M2). The step-1 refusal really is clean and says "nothing was saved
+  or changed". Both call <code>giveBack()</code> before
   returning (round 3, Claude L1).</li>
   <li>The transaction: <code>saveGuard.expect</code> gains <code>dates: carried.currentDates</code> (and the refusal text at
   <code>:7485</code> gains a <code>saved.field === 'dates' ? 'its dates changed'</code> arm, so it no longer says "its schedule
   record changed" for a date change (round 4, Claude M2); the ratchet pins that arm), so a date change
   between step 2 and the write refuses via <code>updateTimeOffRequestIfStatus</code>'s generic <code>expect</code> loop
   (<code>js/firebase-data.js:865</code>). A confirm landing in that window is already caught by
-  <code>expect.proposedSubs</code>.</li>
+  <code>expect.proposedSubs</code>. Two deliberate asymmetries (round 5, Claude L5/L6): the <strong>reset</strong> branch's guard
+  (<code>:7448</code>) does not gain <code>dates</code>, because every sub and the requester's record are reversed before it and the
+  request goes back to review anyway. And this transaction compares <code>dates</code> raw through the generic loop, not normalized.
+  A concurrent save that only rewrote a legacy shape also rewrote <code>proposedSubs</code>, so it refuses either way.</li>
 </ol>
 
 <h2>Phases</h2>
@@ -175,13 +191,14 @@
 <p><strong>Changes:</strong></p>
 <ul>
   <li>Delete <code>toggleFormSubConfirmed</code> and the checkbox. Add the chip and the × prompt in
-  <code>renderTimeOffSubs</code>/<code>removeTimeOffSub</code>. <code>openedSubs</code> (name → <code>{confirmed, hasRecord}</code>)
+  <code>renderTimeOffSubs</code>/<code>removeTimeOffSub</code>. <code>openedSubs</code> (name → <code>{confirmed, hasRecord, entry}</code>)
   is reset in <code>openTimeOffForm</code> and filled from <code>existingRequest.proposedSubs</code> at <code>:7068</code>, never
   reconstructed at submit. The edit-load mapping keeps each entry's <code>confirmed</code>. <code>addTimeOffSub</code> restores a
-  removed name's <strong>original entry verbatim</strong> (its own <code>dates</code> and <code>email</code>, kept in
-  <code>openedSubs</code>) when <code>openedSubs[name].confirmed</code>, not a rebuilt one (round 4, Claude L2). Known limit: a
-  confirmed sub whose name is no longer in the picker (inactive roster entry, legacy free text) can't be re-added, so for them
-  × is final. The × prompt says so in that case: <em>"…and Sam can't be added back from this form."</em> Name-keyed like reconcile and carry
+  removed name's <strong>original entry</strong> by pushing a fresh deep copy of <code>openedSubs[name].entry</code> (never the
+  stored object itself, and never <code>hasRecord</code>) when <code>openedSubs[name].confirmed</code>, not a rebuilt one (round 4,
+  Claude L2; round 5, both). Known limit: a confirmed sub whose name isn't among the picker's options can't be re-added, so for
+  them × is final. That covers an inactive roster entry, legacy free text, and the editor's own name, which
+  <code>openTimeOffForm</code> leaves out (<code>:7036</code>). The condition tests the picker's actual options (round 5, Claude L7). The × prompt says so in that case: <em>"…and Sam can't be added back from this form."</em> Name-keyed like reconcile and carry
   (<code>js/schedule-helpers.js:989</code>, <code>:1030</code>): two subs with one name is a known shared assumption.</li>
   <li><code>checkEditAgainstDocument</code> + <code>normalizeRequestDates</code> in <code>schedule-helpers.js</code> (exported),
   called at the two points above. <code>carryCurrentSubs</code> returns <code>currentDates</code>. <code>saveGuard.expect.dates</code>.</li>
@@ -200,9 +217,11 @@
   <code>s.confirmed &amp;&amp; !Object.keys(s.appliedOverrides || {}).length</code>. Inside it, an unmatched / ambiguous /
   unclaimed roster status shows today's note (manager adds the shift by hand). A <code>matched</code> status shows the new
   line: <em>"Ticker has no record of a shift being added to their schedule for this. Check their schedule, or Undo and use
-  Mark Confirmed."</em> The whole predicate is a pure exported helper, <code>subMissingWriteNote(sub, rosterStatus)</code>, which returns the note
-  or <code>''</code> (gate included). <code>:7615</code> becomes <code>const matchNote = subMissingWriteNote(s,
-  resolveSubRosterMatch(s.name, employeeRoster).status)</code>, so the five shapes below are unit assertions (round 4, Claude M3). The wording claims "no record", not "no shift" (round 2, Codex M4). Cases: link-less (amber);
+  Mark Confirmed."</em> The whole predicate is a pure exported helper, <code>subMissingWriteNote(sub, rosterStatus)</code>, which returns the note as
+  <strong>plain text</strong> or <code>''</code> (gate included; <code>schedule-helpers.js</code> stays markup-free). At
+  <code>:7614–7625</code> the caller wraps it in the existing amber <code>&lt;div style="font-size:11px; color:var(--amber);
+  margin-top:2px;"&gt;</code> when non-empty. The notes are constants, so there's no escaping concern. The five shapes are unit
+  assertions on the helper, plus one ratchet on the wrap (round 4, Claude M3; round 5, both). The wording claims "no record", not "no shift" (round 2, Codex M4). Cases: link-less (amber);
   a real record (none); a record without <code>subUid</code>, the partial-failure state (none); <code>subUid</code> with an
   empty record, legacy/fixtures (amber, correct: no record); <code>dismissedOverrides</code> entries (none, they are unconfirmed).</li>
 </ul>
@@ -338,7 +357,9 @@
   Secured anyway?" A request that no longer exists → "This request no longer exists", no write, and
   <code>openTimeOffDetail</code> (which renders "Request not found").</li>
   <li><strong>The write is guarded on what was checked (round 3, Codex M2):</strong> when the read succeeded, Secured is written with
-  <code>updateTimeOffRequestIfStatus(requestId, [read.status], { coverageStatus }, { proposedSubs: read.proposedSubs })</code>.
+  <code>updateTimeOffRequestIfStatus(requestId, statuses, { coverageStatus }, { proposedSubs: read.proposedSubs })</code>, with
+  <code>statuses</code> = <code>['approved', 'completed']</code> when the read was approved (the same tolerance as the edit path,
+  <code>:7448</code>, so an auto-complete doesn't refuse a label), else <code>[read.status]</code> (round 5, Claude L9).
   If a sub was confirmed or undone in between (<code>changed</code>) → "The subs changed while you were choosing; nothing was
   saved". <code>status-changed</code> (e.g. auto-completed) → "This request's status changed; nothing was saved".
   <code>not-found</code> → "This request no longer exists". Each then re-renders (round 4, Claude L4).
@@ -385,8 +406,9 @@
   <li><strong>Emulator:</strong> <code>timeoff-sub-confirm.emulator.test.js</code> gains the dates guard (refused when the
   request's dates changed; the entry stays unconfirmed; a legacy-shaped vs normalized pair is NOT a change; and dates changed
   <em>plus</em> the entry confirmed by someone else returns <code>sub-changed</code>, not <code>changed</code>). The mirror copies
-  <code>normalizeRequestDates</code> verbatim beside its existing verbatim <code>sameStructure</code> (<code>:37</code>), and the
-  source ratchet pins both copies against <code>js/schedule-helpers.js</code> (round 4, Claude L5). As that file states (<code>:8–12</code>), it mirrors the transaction
+  <code>normalizeRequestDates</code> verbatim beside its existing verbatim <code>sameStructure</code> (<code>:37</code>). A
+  <strong>new</strong> wiring assertion compares the mirror's copies of both functions with <code>js/schedule-helpers.js</code>
+  text; today nothing does, and the verbatim copy is held by convention only (round 4, Claude L5; round 5, Claude L2). As that file states (<code>:8–12</code>), it mirrors the transaction
   rather than requiring <code>app.js</code>. Its source ratchet is what ties the mirror to the real code. No new emulator test
   claims to cover the edit orchestration; the harness can't (round 2, Claude M4).</li>
   <li><strong>Wiring ratchets:</strong> no <code>toggleFormSubConfirmed</code>; Mark Confirmed only under <code>isAdmin</code>
@@ -398,9 +420,12 @@
   <code>field: 'dates'</code> (an ordered <code>indexOf</code> assertion, round 3 Claude B2); in <code>submitConfirmSub</code>
   <code>ctx.dates</code> is assigned from the checked inputs before the <code>overridesToWrite</code> loop; <code>lead</code> has a
   <code>field === 'dates'</code> wording pinned beside the existing two leads; the create-branch <code>confirmed: false</code> map
-  sits after <code>...formData</code>; <code>openedSubs</code> is reset in <code>openTimeOffForm</code> and filled at edit load;
+  sits after <code>...formData</code>; <code>openedSubs</code> and <code>openedDates</code> are reset in <code>openTimeOffForm</code> and filled at edit load
+(<code>openedDates</code> from <code>normalizeRequestDates(existingRequest.dates)</code>, never <code>timeoffFormDates</code>);
+both <code>checkEditAgainstDocument</code> calls pass <code>openedDates</code>; the D3 amber wrap;
   <code>addTimeOffSub</code> restores a confirmed opened entry verbatim
-(this, plus the existing reconcile tests at <code>schedule-helpers.test.js:637–643</code>, is the remove-then-re-add protection;
+(this, plus the existing reconcile tests at <code>schedule-helpers.test.js:618–627</code> (both sides confirmed → link carried,
+nothing queued) and <code>:629–635</code>, is the remove-then-re-add protection;
 <code>checkEditAgainstDocument</code> can't see the form flag, round 4 Claude L3); the <code>:7485</code> refusal has a
 <code>'dates'</code> arm; the null-override dates are collected and reported (a ratchet on the <code>:7973</code> branch, round 4
 Claude L6); the step-2 call passes landed <code>reversedNames</code> and its
@@ -450,7 +475,8 @@
 <ul>
   <li>Sep 29: v1 → round 1 (both "not ready") → v2 → D1–D3 answered → round 2 (both "not ready", "much closer") → v3 →
   round 3 (Codex: no BLOCKING, 3 MEDIUM; Claude: 2 BLOCKING, both one-sentence fixes) → v4 → round 4 (Codex: execution-ready,
-  no findings; Claude: no BLOCKING, 3 MEDIUM plan-text) → v5. Nothing executed.</li>
+  no findings; Claude: no BLOCKING, 3 MEDIUM plan-text) → v5 → round 5 on the v5 edits (both: no BLOCKING; 4 plan-text MEDIUM)
+  → v6. Nothing executed.</li>
 </ul>
 
 <h2>Decisions Log</h2>
@@ -506,6 +532,14 @@
   verbatim and states its limits, the re-add test claim is moved to where it's true, Phase 3's other refusal reasons, the mirror
   copies <code>normalizeRequestDates</code>, the null-override ratchet, the manager re-confirm exception, the status-before-confirmed
   note, the D1 wording for managers, and the unmatched-path note.</li>
+  <li><strong>Sep 29, round 5 (v5 edits only) → v6:</strong> both reviewers found no BLOCKING and confirmed no v5 edit causes a
+  wrong schedule write or a false confirmation. Folded in: <code>openedSubs</code> holds <code>entry</code> (deep-copied on
+  restore); <code>openedDates</code> comes from the document, is required, and is ratcheted at both calls; the step-2 refusal
+  always uses the generic "stays removed" sentence; <code>subMissingWriteNote</code> returns text and the caller keeps the amber
+  wrap; the reason order is fixed; the dates-changed-elsewhere scope widening is stated; the mirror ratchet is described as new;
+  the re-add test lines are corrected; the picker-options condition, the re-confirm notice, and Phase 3's
+  <code>['approved','completed']</code> tolerance are added; the reset-branch and raw-compare asymmetries are explained; the
+  legacy round-trip claim is qualified.</li>
 </ul>
 </body>
 </html>
