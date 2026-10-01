OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f06f-5598-7291-9149-fc6f3b39d45e
--------
user
# Plan review ROUND 4 (short, targeted confirmation) — Classbook SDOC Phase 3, revision 4
Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3". Re-read ONLY:
the "Build sequencing" paragraph, the last two sentences of the "Failure" paragraph, the new
"Redraw on every install" paragraph, the last two BDDs in the Phase 3 BDD block, and the top Decisions Log entry.

Code is READ-ONLY and pinned to commit 2ef2e62 (the plan's line numbers). The checkout at
/Users/christiehubley/tinker-spring-curriculum has moved on; read the pinned code with
`git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/app.js` and `...:js/firebase-data.js`.
Do NOT edit anything anywhere.

Round 3 (both reviewers, one MEDIUM): ~/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-{codex,claude}.md
— after a Teacher View visit the single listener's callback is Teacher View's, so the failed reload's automatic
retries (firebase-data.js:1151-1157) and snapshot-triggered reloads (1190-1194) did not redraw Curriculum Admin.

Revision 4 changes to check:
1. Teacher View's callback (app.js:676) also calls renderAdminGrid(); renderHelpQueue(); when the active tab is
   curriculum-admin, before its SDOC early return (682-686).
2. The round-3 "vice versa" was DROPPED with a claim: Curriculum Admin's callback can own the listener only while
   Teacher View has never finished initialising, because initTeacherView's only early exit before registering
   (668-672) resets tvInitialized = false. VERIFY this claim against the code (including initTeacherView's
   await loadLessonData() before registration, and any other path that calls setupLessonDataListener).
3. The "Couldn't refresh" message is derived at render time: dayOffRefreshFailed[yearKey] set on a 'failed' refresh,
   cleared wherever the stamp is set.
4. BDD +2; build deferred until the per-semester lesson storage migration lands.

Confirm the round-3 MEDIUM is fixed; only NEW HIGH/MEDIUM block. Verdict READY / CHANGES NEEDED; ≤300 words.

codex
I’ll do the narrow Round 4 review only, comparing the specified plan excerpts and prior findings against the pinned commit. I’ll keep everything read-only.
exec
/bin/zsh -lc "rg -n 'Build sequencing|Failure|Redraw on every install|Decisions Log|phase-3|Phase 3' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html && rg -n 'MEDIUM|listener|vice versa|Teacher View|Curriculum Admin' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-{codex,claude}.md" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
37:  <span class="status-tag ready">execution-ready: true — Phase 1</span> — <strong>Christie, Sep 21, 2026: "go — mark all three execution-ready". The model is redrawn for multi-day, multi-camp SDOCs with shared plans; Phase 1 (rules, data layer, admin UI, tests) is execution-ready after four Codex + Claude review rounds; Phases 2–4 remain draft shape and are NOT. Sequenced after <code>classbook-camp-seasons.html</code> Phase 1 (or carries its five small prerequisites itself — log it if so).</strong> Earlier: scoping complete, D1–D6 all decided Sep 20 (see Decisions Log).
58:    <tr><td><strong>Plan</strong><br><code>dayOffCamps_lessonData/{docId}</code></td><td><code>docId = encodeFirestoreKey(`${yearKey}|||${campId}|||${projectTitle}`)</code>; fields <code>{ yearKey, eventId, campId, projectTitle, introPitch, processStep1–4, closure, materials, materialsList, dayOfMaterials, photoUrl, photoPath, planComplete, qaThread, lastEditedBy, lastEditedAt } <em>(Sep 25, Phase 2B: plus <code>lastEditId</code>, a per-save id written only by <code>saveDayOffPlan()</code>; no SDOC <code>qaThread</code> is ever written — Christie dropped SDOC Q&amp;A.)</em> <em>(Sep 24, Phase 2A: plus admin-built <code>materialItems</code> and prep <code>materialChecks</code>; <code>materialsList</code> here is superseded — teachers see the admin list read-only)</em></code> — the summer plan's shape (<code>CONTENT_FIELDS</code>, <code>SUMMER_SAVED_FIELDS</code>, <code>firebase-data.js:19, :546</code>) plus its identity fields. <strong>One plan per camp-project, no teacher in the key</strong> (D4: "one enters the plans and the other must SEE them — maybe they can both edit"); every teacher in <code>camp.teachers</code> can edit it (Phase 2: <code>canEditLesson()</code>, <code>app.js:518-528</code>, gains "<code>lesson.teachers</code> includes my teacher name"). Authorisation is UI-level, exactly as for summer plans — the rule lets any classbook teacher update any plan (the same accepted gap the <code>summerCamps_lessonData</code> block has). Two assigned teachers editing at once: each save is a targeted set-merge of the fields that changed (the summer editor's dirty-diff, backtracking audit Phase 10), so edits to different fields both survive; a same-field collision is last-write-wins and is accepted (a Phase 2 BDD scenario states it). The same title on two of the camp's days is one plan. Q&amp;A lives on the plan doc itself (<code>qaThread</code>, like weekly lessons), so the Curriculum Admin Help Queue's <em>data path</em> (<code>renderHelpQueue()</code> reads <code>lesson.qaThread</code> from the in-memory map, <code>:6327-6345</code>) is reused — but not its writers: <code>sendHelpResponse()</code>/<code>sendQaReply()</code> route by type to <code>summerCamps_lessonData</code> or <code>curriculum/lessonData</code> (<code>:6468-6485</code>, <code>:6535-6550</code>), as does <code>adminLessonStillExistsWithRetry()</code> (<code>:5149-5156</code>), and the item label prints <code>Week {weekNum}</code> (<code>:6381</code>) — Phase 3 adds the admin reply writers' <code>dayOffCamps_lessonData</code> branch and SDOC labels (the existence check's branch lands in Phase 2 or Phase 3 per the Q&amp;A sequencing decision in the Phase 2 draft). SDOC questions never touch <code>summerCamps_prepHelpQueue</code> (the Summer Camp App's season scans would see them as junk). Photos: <code>curriculum/{yearKey}/{lessonKey}/demo-{unique}.jpg</code> via the existing <code>getPhotoPath()</code>/<code>uploadLessonPhoto()</code> (<code>firebase-data.js:984-1003</code>) — already allowed by <code>storage.rules:12-18</code>, so <strong>no Storage rules change</strong>. Saved through <code>saveSingleLesson()</code> with a new routing branch for <code>semesterTypeOf(semKey) === 'day-off-camps'</code> (Phase 2; until then the seasons plan's <code>switch … default: throw</code> refuses the type in every weekly/summer writer). <strong>What counts as user data on a plan</strong> — for the delete and rename guards below — is <code>dayOffPlanHasUserData(doc)</code>: any of the seven <code>CONTENT_FIELDS</code> with text, <em>or</em> <code>photoUrl</code>/<code>photoPath</code>, a non-empty <code>qaThread</code>, <code>planComplete === true</code>, or a non-empty <code>materialsList</code> (round 1, both reviewers: <code>lessonHasContent()</code> checks only the seven text fields, <code>firebase-data.js:19-22</code>, so a photo-only or Q&amp;A-only plan would have been classified "scaffold" and batch-deleted). <strong>Superseded Sep 24 by Phase 2A:</strong> materials are admin-built per project in <code>materialItems</code> (with prep <code>materialChecks</code> and a per-camp sign-off doc) and shown to teachers read-only, as in summer — the teacher-editable table below no longer applies. Original note: the summer editor renders <code>materialsList</code> read-only from the Materials Hub (<code>app.js:10496-10508</code>); SDOC has no hub, so its editor needs the <em>weekly</em> editor's editable materials table (<code>:3004-3086</code>) — a real delta, not a small one.</td></tr>
61:    <tr><td><strong>Admin view</strong> (Phase 1)</td><td>The chronological event list with every camp, its placements, teachers, days and projects; add/edit/remove events and camps; plan status columns light up in Phase 3.</td></tr>
68:  <div class="safe"><strong>Nothing open here.</strong> Answers (full text in the Decisions Log, Sep 20 evening): <strong>D1</strong> yes, a third semester type. <strong>D2</strong> an event = one or more day-off dates hosting several camps (AM/PM, studios/ages, locations), each with project blocks + Open Studio. <strong>D3</strong> manual date entry; a BVSD import is a nice-to-have. <strong>D4</strong> (b) teachers see only their own camps; co-teachers share one plan and both edit. <strong>D5</strong> a quantity-bearing materials list is in v1 (built by the planner in 2A). <strong>D6</strong> a headcount per camp (from placements) for materials; no rosters. The questions below are kept as asked, for history.</div>
97:// added here because SDOC admins edit plans through the admin path in Phase 3); per-teacher isolation is
112:    <li><code>saveDayOffCamp(yearKey, camp)</code>: validates, server-authoritatively (the event is re-read forced-server before every write, not taken from the loaded state): title non-empty; <code>eventId</code> exists; <code>timeSlot</code> ∈ AM/PM/FULL and <code>timeLabel</code> non-empty; <code>location</code> ∈ the location list; <code>dates</code> ISO, unique, sorted, non-empty, ⊆ the event's dates; every <code>projects[date]</code> key ∈ <code>dates</code> and every selected date has ≥ 1 title (no-plan titles such as Open Studio count), titles trimmed, non-empty, ≤ 3 per day and unique within a day; <code>placements</code> non-empty, each <code>studio</code> ∈ <code>SDOC_STUDIOS</code> and unique within the camp, <code>ageRange</code> non-empty, integer <code>capacity ≥ 0</code>; <code>teachers</code> unique, ⊆ the year's <code>teacherNames</code>, may be empty while planning. Same create/update/strip/read-back/explicit-clear rules (clearable optionals here: <code>notes</code>, a placement's <code>ageRange</code> is required so never cleared); a changed <code>dates</code>, <code>projects</code>, <code>placements</code> or <code>teachers</code> is written <em>whole</em> (the nested map/array replaced, never merged — a per-key merge would leave removed day keys behind). <strong>Rename/removal guard:</strong> when an update drops or renames a title that has a plan with user data (<code>countDayOffPlansWithUserData(yearKey, campId, [titles])</code> — forced-server query <code>where('campId','==',campId)</code> filtered in memory with <code>dayOffPlanHasUserData()</code>, defined in the model), the editor lists the affected plans and offers <em>Keep the old title</em> or <em>Continue (the plan stays in Firestore under the old title; nothing is deleted)</em> — an orphan can be re-attached by renaming back. No automatic re-keying in Phase 1 (a reassign/Cut Bank flow for SDOC is a Phase 3 item, mirroring the Summer Camp App's). In Phase 1 the guard can never fire (no plans exist yet) — it is written and tested now, with a seeded TEST plan doc, so Phase 2 inherits it.</li>
176:Given: an SDOC year is selected and an admin replies to a question, or opens the admin edit path, before Phase 3 adds the SDOC branches
276:  <p><strong>Christie's decisions (Sep 25):</strong> (1) <strong>No Q&amp;A for SDOCs at all</strong> — "we can skip the help queue entirely for SDOCs. we just chat with teachers, no need for the ask a question flow." The SDOC editor has no question box; Phase 3's Q&amp;A part is dropped; <code>sendTeacherQaMessage()</code>, <code>adminLessonStillExistsWithRetry()</code>, <code>sendHelpResponse()</code>, <code>sendQaReply()</code> keep refusing SDOC keys (nothing writes an SDOC <code>qaThread</code>). (2) An <strong>unfilled block shows to the teacher as "project not assigned yet"</strong> (no editor), and fills in once the planner names it.</p>
475:  <p><strong>Not in 2B:</strong> Q&amp;A (dropped by Christie), print, teacher-side prep ticks, a rules field-pin, the wipe-monitor tally, the admin plan-status columns (Phase 3).</p>
608:<div class="phase" id="phase-3">
609:  <h3>Phase 3 — Planner's plan overview (status per project + per-event roll-up) — DESIGN, revision 4 (Sep 29, 2026, after review rounds 1–3; line numbers @ <code>2ef2e62</code>) — <span class="status-tag not-ready">execution-ready: false</span></h3>
610:  <p><strong>Build sequencing (Christie, Sep 29):</strong> the design is finished now; the <em>build</em> waits until <code>classbook-per-semester-lesson-storage</code> has landed (another session, in progress) — it reworks the <code>curriculum/lessonData</code> listener and loads this design hooks into. Before building: re-verify every line reference and the listener/reload shape against that code, and run a short targeted review if it moved materially.</p>
611:  <p><strong>Christie, Sep 29:</strong> "yes design it with the roll-up" — the core (status per project, open any plan) plus a per-event roll-up; the "not started and camp is under two weeks away" warning was offered and left out. Q&amp;A was dropped from Phase 3 on Sep 25.</p>
622:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set when a refresh returns <code>'failed'</code> and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
624:  <p><strong>Redraw on every install — each callback also redraws the other active view (round 3, both MEDIUM).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). The listener is registered by <code>initCurriculumAdmin()</code> at startup (app.js:188 → 5038) and again by the first <code>initTeacherView()</code> (app.js:676; later visits return early, app.js:653-656), so after one Teacher View visit the callback is Teacher View's for the rest of the page's life — and Curriculum Admin, <strong>weekly grid included (a pre-existing gap)</strong>, stops redrawing on any reload. <strong>Fix:</strong> Teacher View's callback, right after <code>currentLessonData = data</code>, also calls <code>renderAdminGrid(); renderHelpQueue();</code> when Curriculum Admin's tab is the active one (<code>document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin'</code>) — placed before its SDOC branch's early <code>return</code> (app.js:682-686) so both branches do it. These are exactly the calls Curriculum Admin's own callback makes on every tick (app.js:5038-5043), so nothing new runs; the admin redraw just stops depending on which view registered last. <em>The reverse direction is not needed (revision 4, verified):</em> Curriculum Admin's callback can only own the listener while Teacher View has never finished initialising — its only early exit before registering (the load-guard <code>return</code>, app.js:668-672) resets <code>tvInitialized = false</code>, so there is no built Teacher View to redraw, and the next visit builds it and takes the listener. <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw when the callback also drew.</p>
725:    <li><strong>After Phase 2:</strong> teachers can plan; admins read via Phase 1's list but edit only through the teacher path until Phase 3 — acceptable.</li>
730:<h2 id="decisions-log">Decisions Log</h2>
732:  <li><strong>Sep 29, 2026 (Phase 3 round-3 MEDIUM folded — revision 4):</strong> Teacher View's listener callback now also calls <code>renderAdminGrid()</code> + <code>renderHelpQueue()</code> when Curriculum Admin is the active tab (before its SDOC early return), so the automatic retries and snapshot reloads redraw Curriculum Admin after a Teacher View visit — which also closes a pre-existing gap for the weekly grid. The "Couldn't refresh" message is derived at render time (<code>dayOffRefreshFailed[yearKey]</code>, cleared where the stamp is set). The "vice versa" from round 3 was dropped after checking the code: Curriculum Admin's callback can own the listener only while Teacher View has never finished initialising (its guard exit resets <code>tvInitialized</code>), so there is nothing to redraw. BDD +2. <strong>Christie, Sep 29: finish the design now, but build only after <code>classbook-per-semester-lesson-storage</code> lands</strong> (it reworks the same listener) — re-verify line references then. Next: round 4 (short, targeted), then Christie's go incl. her yes to <code>source: 'server'</code>.</li>
733:  <li><strong>Sep 29, 2026 (Phase 3 review round 3 — PAUSED here, Christie moving locations):</strong> both confirmed every round-2 fix; both found ONE remaining MEDIUM, not yet folded: two other install paths also redraw through the single global listener's callback, which after a Teacher View visit belongs to Teacher View — (1) the failed reload's automatic retries (firebase-data.js:1151-1157) and (2) a snapshot-triggered reload (firebase-data.js:1190-1194) — so on Curriculum Admin the rows, stamp, "Couldn't refresh" message and editability can go stale after recovery. <strong>Agreed fix to fold next:</strong> make every listener callback redraw whichever tab is active (Teacher View's callback also calls <code>renderAdminGrid()</code> when Curriculum Admin is active, and vice versa), and add a BDD: visit Teacher View → back to Curriculum Admin → refresh fails → automatic retry succeeds → message gone, rows + stamp fresh, editing re-enabled. Then a short round 4, then Christie's go (which must also include her yes to <code>source: 'server'</code> for all SDOC loads — see the Refresh paragraph). No code written for Phase 3 yet; Classbook <code>main</code> is clean at <code>2ef2e62</code>.</li>
734:  <li><strong>Sep 29, 2026 (Phase 3 review round 2 — both confirmed every round-1 fix; folded, revision 3):</strong> HIGH (both): the single global listener's callback belongs to whichever view initialised last, so after a Teacher View visit a refresh would install fresh data without redrawing the admin list while the stamp advanced → <code>refreshDayOffYear()</code> redraws the list itself on any non-stale outcome; one shared in-flight refresh. MEDIUM (Claude): <code>source: 'server'</code> also changes startup for teachers (offline → guard + banner instead of a cached/empty year) — stated, Christie's yes asked with the go; the editor's guard is scoped to SDOC (summer untouched). LOW: the stamp is set on startup's load too; <code>isIsoDate</code> before formatting. BDD +2. Next: round 3 (targeted).</li>
735:  <li><strong>Sep 29, 2026 (Phase 3 review round 1 — Codex + Claude, both CHANGES NEEDED; folded, revision 2):</strong> HIGH (both): an independent refresh would be ungated — an older one resolving last could revert a newer reload and stamp it "now" → refresh goes through the listener's own generation-gated reload (<code>reloadSummerForModeChange</code>); SDOC loads become <code>source: 'server'</code>; the stamp ("Last full refresh") advances only when a gated reload installs. HIGH/MEDIUM: a failed refresh trips the existing guard (banner + retry), keeps prior figures, and the editor opens read-only while guarded. MEDIUM: the two automatic call sites are named (tab re-entry, header switch to SDOC on Curriculum Admin); <code>lastEditedAt</code> is sliced before formatting; plans are counted per (camp, title). LOW: pill labels via <code>getProgressLabel</code> ('ready' unreachable); the no-apostrophe-in-onclick reason recorded. BDD +6. Next: round 2.</li>
736:  <li><strong>Sep 29, 2026 (Phase 3 designed, revision 1 — not yet reviewed):</strong> Christie: "yes design it with the roll-up". Read-only overview in the planner's camp list: per-project status (same <code>calculateLessonProgress</code> as Teacher View), last editor, Open plan (the 2B editor), a per-event roll-up, and an explicit "as of" time with ↻ Refresh + re-read on Curriculum Admin entry (no live listener on SDOC collections). No data, rules or writer changes. Next: review round.</li>
737:  <li><strong>Sep 28, 2026 (Phase 2C DEPLOYED):</strong> Christie ran <code>npm run deploy</code> at <code>1745e95</code> (also ships <code>44a5159</code>, the Teacher Mapping fix). Claude re-ran <code>scripts/check-live.sh</code>: every file byte-identical, every dev path 404, <code>[check-live] ok</code>. Next for Christie: discard the Northern Lights "n/a" leftover list; publish the SDOC year when ready. Then Phase 3 and the follow-ups listed in the 2B/2C entries.</li>
745:  <li><strong>Sep 28, 2026 (2A.1 + 2B DEPLOYED):</strong> Christie ran <code>npm run deploy</code> herself (the auto-mode classifier blocked Claude's attempt — which was malformed, carrying a stray second background deploy; no deploy ran from it). Netlify <code>6aba91a48eab0ebcc7f29cd8</code>, commit <code>22ed027</code>. The script's immediate live check reported 3 DIFFs (CDN propagation); re-run a minute later: every file byte-identical, every dev path 404, <code>[check-live] ok</code>. The SDOC year stays unpublished until Christie publishes it. Next: Christie publishes when ready; confirm a teacher sees her camp; then Phase 3.</li>
746:  <li><strong>Sep 26, 2026 (Phase 2B BUILT — <code>main</code> @ <code>22ed027</code>, pushed; 2A.1 + 2B await ONE "okay to deploy", by Christie's choice to batch them):</strong> Built as designed (revision 7). Deviations, logged: (a) the save path and editor find a plan's camp/title from the camp list (<code>dayOffFindProject</code>), not the slot map — the first test runs showed a reload can briefly swap <code>currentLessonData</code>, so the SDOC list also rebuilds its slots when they don't cover the camps; (b) the plan's explicit summer-editor regression cases were not written as new tests: the existing summer suite (data-safety.spec.js — open/save/read-back/photo/serialized saves/revert/close-wait) drives the split's summer path through <code>openLessonModal</code> and stayed green, which Claude's implementation review confirmed; (c) the Teacher View's own semester selector is CSS-hidden (styles.css, "Hide individual semester selectors") — its handler now calls <code>setGlobalSemester</code> anyway. Implementation review round 1 (Codex + Claude, both CHANGES NEEDED, no data-loss path): one-sided photo clears → the pair is enforced across payload and clears; Teacher View re-entry after a semester change on another tab, leaving SDOC (picker names, teacher group) → fixed; the Q&A activity panel could show an SDOC <code>qaThread</code> → cleared for SDOC; two SDOC years could briefly show a pre-save slot → <code>healDayOffYearAfterReload</code> (per-year start seq); T12 was vacuous (no input event) → fixed; missing tests → T14 drives the three Q&A writers, T18 failed save after upload, T19 sign-off byte-identity + tick interleavings, T20 SDOC ↔ weekly transitions, T21 Q&A panel, T5 same-millisecond + photo-removal races. Round 2: <strong>READY from both</strong>; two LOWs applied (editor meta via <code>sdocEsc</code>; Publish refuses after a failed load). <strong>Follow-ups, not done:</strong> the heal rebuilds the whole year (could rebuild only keys verified after the reload began); an editor-open read is marked verified (a newer reload result can lose to it until the next reload); no two-SDOC-year test; print for SDOC plans; the rules field-pin for <code>dayOffCamps_lessonData</code>; the admin plan-status columns (Phase 3). Tests T1–T21 stable ×3; full suite 307/307. Reviews: <code>thoughts/reviews/2026-09-26-impl-review-sdoc-2b-*</code>. <strong>After deploy:</strong> Christie publishes SDOC 2026-27 when she's ready (Curriculum Admin → Published); Mariah and Kaitlyn then see their camps — their names in the year's pool are first names, matched to their accounts by first name (unique today).</li>
755:  <li><strong>Sep 25, 2026 (Phase 2A.1 + Phase 2B designed, revision 1 — NOT yet reviewed):</strong> Christie, before the design: "we can skip the help queue entirely for SDOCs. we just chat with teachers, no need for the ask a question flow" → no SDOC Q&amp;A in any phase (Phase 3's Q&amp;A dropped; the Q&amp;A/help writers keep refusing SDOC keys); an unfilled block shows the teacher "project not assigned yet". Mid-design she asked for "a pop up that shows all materials for all projects in that SDOC event container … grouped by project" → Phase 2A.1 (UI only over 2A's reviewed writers, grouped camp → project because the camp is the sign-off unit and a title can run in two camps), sequenced before 2B. Research (read-only inventory @ 2894adf) corrected the model's assumption: the type switch is <code>lessonStoreFor()</code>, not inside <code>saveSingleLesson()</code>, and it has seven callers; <code>seasonForSemester()</code> throws for SDOC keys (so the summer save/photo/unread/camp-complete paths cannot be reused as-is); SDOC slots carry a joined <code>teacher</code> string, so every <code>l.teacher === name</code> site needs the <code>teachers</code> array. Design choices: plan saves in a transaction that re-checks the camp still has the title (closes the rename race), payload allow-list + identity stamped from the camp, forced read on editor open, <code>openLessonModal()</code> split into a summer lookup + shared <code>openPlanEditor()</code>, edit rights for planners + Kathy/Allie (via <code>canTickDayOffMaterials()</code>) + the camp's teachers — Christie chose edit for Kathy/Allie "to match the other semester/camps" (the first draft had them read-only), no rules change, Phase 4 marked superseded. Wipe monitor: SDOC is <em>not</em> added to <code>computeLiveContentCountByTeacher()</code> (backup.js Tier-1 per-collection tripwire covers it). Christie, later Sep 25: Kathy and Allie <strong>can edit</strong> SDOC plans "to match the other semester/camps". Next: Codex + Claude review of 2A.1 and 2B.</li>
763:  <li><strong>Sep 21, 2026 (plan review round 3 — final confirmation, Codex + Claude): CLEAN for Phase 1.</strong> Every round-2 item confirmed against the code by both reviewers; no new HIGH/MEDIUM design findings (Claude checked and rejected the camp-delete check-to-batch race, the any-teacher plan write rule and the extra per-snapshot queries as recorded trade-offs). Folded in: (1) <code>~/tinker-backups</code> is not a git repository, so the <code>backup.js</code> edit cannot ride in the rules commit — it is now an explicit, grep-verified pre-deploy step recorded in the rules commit message (Codex MEDIUM; the script's lack of version control is noted as a standing gap); (2) the Phase 2 draft now states the SDOC Q&amp;A sequencing question — the teacher-side question path is the weekly writer, so Phase 2 owns both that branch and the existence check's, or defers all SDOC Q&amp;A to Phase 3 (Claude); (3) the model names both teacher-list builders (<code>app.js:611</code> inline and <code>populateTvTeacherList()</code> <code>:732</code>) for Phase 2; (4) process note: studio-hub's working tree already carries another session's uncommitted rules edits — commit or stash them before cutting the SDOC rules commit so the Fable review sees only the three blocks. Codex flagged the two remaining <code>saveConfig</code> mentions as stale; both are explanatory ("deleted by that plan", "the stub moves") and stay. <strong>Ready for Christie's go-ahead.</strong></li>
765:  <li><strong>Sep 21, 2026 (plan review round 1 — Codex + Claude, model + Phase 1):</strong> Codex 5 HIGH / 7 MEDIUM / 2 LOW, Claude 1 HIGH / 8 MEDIUM / ~11 LOW; every finding verified against the code; all folded in. Design changes: (1) the delete/rename guards used <code>lessonHasContent()</code> (seven text fields only) — a photo-only, Q&amp;A-only, planComplete-only or materials-only plan would have been batch-deleted with its camp → <code>dayOffPlanHasUserData()</code> covers every persisted user-authored field, with a test per field; (2) <code>curriculum-admin</code> (the legacy alias) removed from the three new rule blocks — extending it to new collections is a widening CLAUDE.md forbids without Christie's say-so, and it has no test fixture; (3) editing an event's dates now refuses to drop a date any camp still uses (referential integrity); (4) "a date in only one event" downgraded from an invariant to a best-effort forced-server check — a query-then-create cannot be transactional without a claim collection, judged not worth it for a one-person list; (5) camp validation completed (location, studio membership + uniqueness, age range, hours, sorted unique dates, ≥ 1 title per day, no duplicate titles per day, unique teachers) and made server-authoritative (the event is re-read before every camp write); nested fields written whole on change so removed day keys cannot linger; (6) a fifth dependency on the seasons plan named — <code>updateAppData()</code>, the field-path appData writer — and Settings for an SDOC year writes only its four owned fields (the first draft's "spread the existing semester" would have polluted the schema with <code>numWeeks: 16</code> and the default roster on the first save); (7) the model now says plainly that visibility is UI gating (the rules let every teacher read every SDOC doc), that shared-plan editing is dirty-field merge with last-write-wins per field, that the Help Queue's <em>data path</em> is reused but its writers/labels need a Phase 3 branch, that the teacher-facing sites which assume one teacher per lesson (teacher list, name fallback, <code>canEditLesson()</code>, content count, the "Loading…" branch) are Phase 2 work, and that the SDOC editor needs the weekly editor's editable materials table (no hub); (8) the plans rule stays in Phase 1 with the rationale spelled out (one rules deploy for the plan; the guards query the collection), while the <code>canEditLesson()</code>/name-fallback changes move to Phase 2; (9) all three collections go in <code>backup.js</code> Tier 1; (10) test cleanup runs before + finally and the helper refuses non-TEST years before any request; (11) the completeness section and the danger box now state the real blast radius — a <code>dayOffCamps_*</code> permission error at load trips the app-wide guard; (12) a teacher-pool removal guard added; <code>block</code> defined as first-seen position, display-only. Citations moved to studio-hub <code>43173d6</code> (<code>/curriculum</code> 538-569, <code>summerCamps_lessonData</code> 644-647, Default-deny describe <code>rules.test.js:1580</code>). Both reviewers confirmed sound: the events/camps/plans model against D2/D4/D5/D6, auto-ID per-event docs, one shared plan keyed by <code>campId</code>, headcount from placements, Q&amp;A on the plan doc, Storage reuse, rules-first ordering, Publish hidden until Phase 2. Next: round 2 (confirmation), then Christie's go-ahead.</li>
782:  <p><strong>Status (Sep 29, 2026) — read this first:</strong> Phases 1–2C LIVE (<code>1745e95</code>; <code>main</code> now <code>2ef2e62</code> with the linkify XSS fix merged, not yet deployed). <strong>Phase 3 is mid-design (revision 4 — round 3's MEDIUM folded; next: review round 4)</strong> — see the top Decisions Log entry. The Phase 3 <em>build</em> waits for <code>classbook-per-semester-lesson-storage</code> to land (Christie, Sep 29). Later on Sep 29: <code>main</code> @ <code>e25d9db</code> is LIVE (XSS fix #2, onclick quoting #3, Teacher View collapse + pop-up links #4). Earlier status: <strong>Phases 2A.1 and 2B are LIVE</strong> (<code>22ed027</code>, Netlify <code>6aba91a4</code>, Sep 28). Christie publishes the SDOC year when she wants teachers to see it. Then Phase 3 (planner plan-status columns) and the follow-ups in the top Decisions Log entry. Earlier: Christie's Sep 25 materials are confirmed in the 11:54 backup (Beanie Painting: 2 items; no ticks yet). <strong>Phase 2A.1 (event materials checklist, revision 3) and Phase 2B (teachers plan, revision 7) are designed and their Codex + Claude reviews are CLEAN</strong> (2A.1 after 3 rounds, 2B after 8 — see the Decisions Log). Next: Christie's go per phase (2A.1 first) → red emulator tests → build → dual implementation review → "okay to deploy". No rules change in either. Earlier the same day: Phase 1 and Phase 2A are LIVE (Classbook <code>main</code> @ <code>67583e3</code>, Netlify <code>6ab683df</code>; rules <code>97f7915</code>). Christie has real data in production: SDOC 2026-27 (teachers Mariah, Kaitlyn), 3 events, 4 camps, some materials. <strong>Next, in order:</strong> (1) confirm her Sep 25 materials and a Kathy/Allie tick + Materials complete in a backup; (2) <strong>design Phase 2B</strong> (teachers plan their days; the Publish toggle for the type; Q&amp;A sequencing — see the Phase 2B draft and the model) to the same standard as 2A: write the design here → Codex + Claude review rounds until clean → Christie's go → build with emulator tests (use a private <code>TMPDIR</code> if another emulator suite is running) → dual implementation review → "okay to deploy". The Sep 24 Decisions Log entries hold every decision made in use (blocks grid, optional projects, materials in the build phase, prep check-off, view-only Kathy/Allie, drafts hidden in Teacher View).</p>
783:  <p><strong>Earlier status (Sep 21, 2026):</strong> model redrawn; Phase 1 designed in detail (real line numbers @ <code>a08dbeb</code>). Nothing built. Next, in order: (1) <code>/second-model-review</code> (Codex + Claude) on the model + Phase 1 until a round comes back clean — <strong>done — three rounds Sep 21, round 3 clean from both reviewers</strong> (see the Decisions Log); (2) <strong>done — Christie's go given Sep 21 ("go — mark all three execution-ready"); Phase 1 is execution-ready</strong>; (3) confirm the seasons plan's Phase 1 has shipped (or carry its five items — see the note under Phase 1); (4) build in the 1.1 → 1.6 order: <code>backup.js</code> edit + grep of both arrays (outside git) → rules commit in <code>studio-hub</code> (blocks, tests; other sessions' rules edits committed or stashed first) → Fable review → "approved to change firebase" → rules deploy → red e2e tests → implementation → dual implementation review → "okay to deploy"; (5) design Phase 2 in the same detail (the editor reuse, <code>saveSingleLesson()</code>'s third branch, Publish for the type). <strong>First step in any new session:</strong> check the plan reviewer (<code>plan-review index</code>) for Christie's comments, then re-read the model section — every later phase hangs off it. Do not touch product code before step (2).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:1:## Verdict: CHANGES NEEDED — 1 new MEDIUM
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:5:- HIGH (no redraw): `refreshDayOffYear()` now awaits the outcome and calls `renderAdminGrid()` itself for any non-`'stale'` outcome including `'failed'`; the "Curriculum Admin sets that listener up" claim is corrected — both `initTeacherView` (`js/app.js:676`) and `initCurriculumAdmin` (`js/app.js:5038`) register it, last wins; shared in-flight promise; BDD added (plan line 681).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:6:- MEDIUM (`source:'server'`): stated plainly, `loadLessonData()` cited (`js/firebase-data.js:775-776`), offline start → guard + banner, Christie's yes asked with the go; BDD added (line 685).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:7:- MEDIUM (editor guard): scoped to the `sdoc` branch only, summer's `: true` untouched — matches `js/app.js:11515`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:10:## NEW — MEDIUM: two other install paths still redraw through the wrong callback
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:12:The fix covers only the outcome `refreshDayOffYear()` awaits. Two paths install SDOC data and move the stamp/guard but redraw via `callback` — after a Teacher View visit that is Teacher View's, which returns without touching the admin grid (`js/app.js:683-687`):
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-claude.md:15:2. **A snapshot-triggered reload** (`js/firebase-data.js:1190-1194`) while she sits on Curriculum Admin: it re-reads every SDOC year and, per the stamp sentence, advances it with no redraw.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:3:The round-2 findings are addressed: refresh redraws Curriculum Admin directly, server-only startup behavior is explicit and awaiting Christie’s approval, the load guard is SDOC-only, stamps cover successful startup loads, date validation is specified, and both requested BDDs are present.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:5:One new MEDIUM blocker remains:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:7:### MEDIUM — Automatic retry can still leave Curriculum Admin stale
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:9:After visiting Teacher View, its callback owns the single global listener. `refreshDayOffYear()` now redraws Curriculum Admin after the initial outcome, including `'failed'`, which fixes round 2.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:11:However, a failed reload schedules automatic retries inside [firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1143). When a retry succeeds, it invokes the listener owner’s callback directly. The Teacher View callback does not redraw Curriculum Admin while that tab is active ([app.js](/Users/christiehubley/tinker-spring-curriculum/js/app.js:683)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:16:- Curriculum Admin can retain “Couldn’t refresh,” disabled controls, old rows, and the old displayed stamp;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-codex.md:19:Specify callback-independent redraw for successful retries—preferably every current callback redraws Curriculum Admin when it is the active tab—or route retry completion through the same refresh redraw helper. Add a BDD covering Teacher View visit → return to Curriculum Admin → refresh fails → automatic retry succeeds → rows, stamp, message, and disabled state all update.

exec
/bin/zsh -lc "sed -n '608,710p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html

git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/app.js | nl -ba | sed -n '630,705p;5015,5060p'

git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/firebase-data.js | nl -ba | sed -n '1125,1205p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
<div class="phase" id="phase-3">
  <h3>Phase 3 — Planner's plan overview (status per project + per-event roll-up) — DESIGN, revision 4 (Sep 29, 2026, after review rounds 1–3; line numbers @ <code>2ef2e62</code>) — <span class="status-tag not-ready">execution-ready: false</span></h3>
  <p><strong>Build sequencing (Christie, Sep 29):</strong> the design is finished now; the <em>build</em> waits until <code>classbook-per-semester-lesson-storage</code> has landed (another session, in progress) — it reworks the <code>curriculum/lessonData</code> listener and loads this design hooks into. Before building: re-verify every line reference and the listener/reload shape against that code, and run a short targeted review if it moved materially.</p>
  <p><strong>Christie, Sep 29:</strong> "yes design it with the roll-up" — the core (status per project, open any plan) plus a per-event roll-up; the "not started and camp is under two weeks away" warning was offered and left out. Q&amp;A was dropped from Phase 3 on Sep 25.</p>
  <p><strong>Acceptance (user outcomes):</strong></p>
  <ul>
    <li>In Curriculum Admin for an SDOC year, each camp row gains a <strong>Plans</strong> column listing each of its projects (the <code>dayOffCampTitles()</code> order — unused and no-plan blocks excluded): title, a status pill from the same <code>calculateLessonProgress()</code> (app.js:914) + <code>getProgressLabel()</code> the teachers' list uses, so both views always agree — <em>Not started</em> / <em>In progress</em> / <em>Complete</em> (its fourth value, <code>'ready'</code> → "Almost Done", is unreachable for SDOC because a slot's <code>campName</code> zeroes <code>hasMaterials</code>, app.js:922-924; rendered as In progress if it ever appears) — and "last edited by <em>name</em>, <em>Oct 5</em>" when the plan has an edit stamp (the date is <code>lastEditedAt.slice(0, 10)</code>, shown only if <code>isIsoDate()</code> (firebase-data.js:2000) accepts it, through <code>formatDayOffDate(…, { month: 'short', day: 'numeric' })</code> — which returns unparseable input unchanged, hence the check), plus an <strong>Open plan</strong> button.
    <li><strong>Open plan</strong> opens the 2B editor (<code>openPlanEditor(yearKey, lessonKey, { onClosed })</code>, app.js:11506) — editable for planners and Kathy/Allie (<code>canEditDayOffPlan</code>), read-only otherwise, exactly as from Teacher View; it reads the plan fresh on open. On close the camp list redraws with the new status.</li>
    <li>Each event card's header gains a <strong>roll-up</strong>: "Plans: <em>c</em> of <em>n</em> complete" and, when any, "· <em>k</em> not started". <em>n</em> counts plans, i.e. distinct <strong>(camp, title)</strong> pairs across the event's camps: a title that runs on two days of one camp is one plan; the same title in two camps of the event is two plans (two records — 2A.1). No roll-up on an event with no projects.</li>
    <li>The figures are as fresh as the page's data, and say so: the SDOC header shows <strong>"Last full refresh 10:42 AM"</strong> with a <strong>↻ Refresh</strong> button, and the year is re-read when Curriculum Admin is shown for it (tab entry, and switching to the SDOC year while on Curriculum Admin) — teachers' saves happen on other devices, and the page's only listener is on <code>curriculum/lessonData</code>, whose snapshots also trigger a full reload (app.js:5037-5042).</li>
    <li>Visible to everyone who sees the SDOC camp list today (planners and Kathy/Allie); nothing new for teachers.</li>
  </ul>
  <p><strong>Data — read-only.</strong> No new fields, collections, writers or rules. Everything is computed from the slots <code>buildDayOffSlots()</code> already builds from <code>currentDayOffPlans</code> (plan text, <code>planComplete</code>, <code>lastEditedBy</code>/<code>lastEditedAt</code>).</p>
  <p><strong>Refresh — through the existing gated reload (round 1, both HIGH).</strong> No new loader: <code>refreshDayOffYear()</code> calls <code>reloadSummerForModeChange()</code> (firebase-data.js:1107) → <code>summerReloadHook()</code>, the listener's own generation-gated reload (Curriculum Admin sets that listener up, app.js:5037). So a refresh and a snapshot-triggered reload are the <em>same</em> mechanism: only the newest generation installs and redraws (an older one resolving last returns <code>'stale'</code>, firebase-data.js:1125), <code>previous</code> is captured by <code>snapshotCampSeasons()</code> for <code>mergeSummerReload()</code>, and 2B's heal runs. If no listener exists yet (<code>'no-listener'</code>), <code>initCurriculumAdmin()</code> hasn't run and its own first load covers it. <strong>The refresh redraws the list itself (round 2, both):</strong> there is one global listener, and whichever of <code>initTeacherView()</code> (app.js:676) / <code>initCurriculumAdmin()</code> (app.js:5038) ran last owns its callback — after a visit to Teacher View it is Teacher View's, whose SDOC branch renders only Teacher View — so <code>refreshDayOffYear()</code> awaits the outcome and calls <code>renderAdminGrid()</code> itself for any outcome but <code>'stale'</code> (including <code>'failed'</code>, so the message shows). A single in-flight refresh promise is shared: the two automatic call sites and the button never start a second one while one runs. <strong>Server-fresh:</strong> <code>loadDayOffCampData()</code>'s three queries switch to <code>get({ source: 'server' })</code> (like <code>dayOffServerDocs</code>, firebase-data.js:2114). <em>This changes every SDOC load, including startup's <code>loadLessonData()</code> (firebase-data.js:775-776) that teachers hit (round 2, Claude):</em> today an offline start can fall back to the cache and show an empty or old SDOC year with editing enabled — the "data disappeared" shape; with the change it trips the app-wide load guard and banner instead (the same as any failed load). Safer, but a visible behaviour change for anyone opening the app offline — <strong>Christie's yes is asked with the go.</strong> <strong>The stamp:</strong> <code>dayOffLastRefreshAt[yearKey]</code> is set wherever a full SDOC-year load <em>installs</em> successfully — startup's <code>loadLessonData()</code> and the gated <code>reloadSummer</code> success path — so the header is never blank after a good load, listener reloads (also full reads) advance it truthfully, and an editor's single-plan read, a stale reload and a failed one never do.</p>
  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set when a refresh returns <code>'failed'</code> and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
  <p><strong>Lifecycle (round 1, both).</strong> <code>initCurriculumAdmin()</code> runs once per page load (app.js:5015-5016), so the two automatic call sites are named: the tab-click handler's <code>curriculum-admin</code> branch (app.js:218-219) calls <code>refreshDayOffYear()</code> when Curriculum Admin is already initialised and the admin year is SDOC; and <code>setGlobalSemester()</code>'s <code>curriculum-admin</code> branch (app.js:132-138) does the same when switching <em>to</em> an SDOC year. Never from <code>renderAdminGrid()</code> (it runs after every tick); the button is disabled while a refresh is in flight.</p>
  <p><strong>Redraw on every install — each callback also redraws the other active view (round 3, both MEDIUM).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). The listener is registered by <code>initCurriculumAdmin()</code> at startup (app.js:188 → 5038) and again by the first <code>initTeacherView()</code> (app.js:676; later visits return early, app.js:653-656), so after one Teacher View visit the callback is Teacher View's for the rest of the page's life — and Curriculum Admin, <strong>weekly grid included (a pre-existing gap)</strong>, stops redrawing on any reload. <strong>Fix:</strong> Teacher View's callback, right after <code>currentLessonData = data</code>, also calls <code>renderAdminGrid(); renderHelpQueue();</code> when Curriculum Admin's tab is the active one (<code>document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin'</code>) — placed before its SDOC branch's early <code>return</code> (app.js:682-686) so both branches do it. These are exactly the calls Curriculum Admin's own callback makes on every tick (app.js:5038-5043), so nothing new runs; the admin redraw just stops depending on which view registered last. <em>The reverse direction is not needed (revision 4, verified):</em> Curriculum Admin's callback can only own the listener while Teacher View has never finished initialising — its only early exit before registering (the load-guard <code>return</code>, app.js:668-672) resets <code>tvInitialized = false</code>, so there is no built Teacher View to redraw, and the next visit builds it and takes the listener. <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw when the callback also drew.</p>
  <p><strong>Editor from Curriculum Admin.</strong> <code>openPlanEditor</code>'s <code>finishClose</code> (app.js:12180) always calls <code>renderTeacherView()</code> — harmless while Teacher View is hidden (it renders into its own panel), but it must not steal state: the SDOC branch's <code>syncDayOffTeacherPicker()</code> may reset <code>tvCurrentTeacher</code> for a planner; acceptable (the picker re-resolves on next visit). <code>onClosed</code> redraws the admin grid. The editor's year comes from its argument, never <code>getTvSemKey()</code> — check the one fallback in <code>canEditDayOffPlan</code> (<code>slot.yearKey</code> is set on every SDOC slot since 2B).</p>
  <p><strong>Rendering/safety:</strong> titles and names via <code>sdocEsc</code>; the plan key only in a <code>data-</code> attribute, read by the handler as <code>this.dataset.lessonKey</code> — never interpolated into an <code>onclick</code> string: <code>escAttr</code> escapes <code>"</code> but not <code>'</code> (app.js:8149-8151), so a title with an apostrophe inside a single-quoted <code>onclick</code> argument would break out (round 1, Claude — the existing camp buttons interpolate only auto-IDs, which is why they are safe).</p>
  <div class="bdd">Given: Thanksgiving has Clay Creatures (Clay Creatures: intro + steps written; Glaze Day: nothing) and Paint Party (Canvas: Plan complete)
When: Christie opens Curriculum Admin on the SDOC year
Then: Clay Creatures → "In progress", Glaze Day → "Not started", Canvas → "Complete"; the Thanksgiving header reads "Plans: 1 of 3 complete · 1 not started"; each shows its last editor/date when it has one

Given: a camp day with "n/a", "—" and Open Studio blocks, and a title that runs Monday and Wednesday
When: the list renders
Then: only plannable projects are listed, the repeated title once, and the roll-up counts it once

Given: Mariah saves a plan on her own device after Christie's page loaded
When: Christie presses ↻ Refresh (or re-enters Curriculum Admin)
Then: that project's status and "last edited by Mariah" update; the "as of" time moves; nothing is written (spy)

Given: the refresh's read fails
When: she presses ↻ Refresh
Then: an error shows beside the button; the previous figures stay on screen

Given: Christie presses Open plan on Glaze Day, types a closure, and closes
When: the editor closes
Then: the plan is saved through the 2B path (identity + lastEditId, forced read-back) and the row now reads "In progress"

Given: Allie (prep) views the list
When: she presses Open plan
Then: she can edit (Christie's Sep 25 decision); a curriculum-admin user without classbook gets the read-only editor

Given: project titles and teacher names containing quotes and &lt;img onerror&gt;
When: the list and roll-up render
Then: nothing executes; Open plan still opens the right plan

Given: an event whose camps have no projects yet
When: the list renders
Then: no roll-up is shown for it

Given: two camps in one event both have a project titled "Canvas", and a third title runs Monday and Wednesday in one camp
When: the roll-up counts
Then: "Canvas" is two plans (two rows, denominator counts both); the Monday/Wednesday title is one

Given: a refresh is started, then a snapshot-triggered reload starts and finishes, then the first refresh resolves last
When: both settle
Then: the newer reload's data stays (the older returns 'stale'); the stamp is the newer reload's time

Given: a refresh fails (injected)
When: it settles
Then: the previous figures stay, "Couldn't refresh" shows, the stamp does not move, the load guard is false and Open plan opens read-only; after a successful refresh the guard clears and editing works

Given: Christie leaves Curriculum Admin and comes back, and separately switches the header from a weekly semester to the SDOC year while on Curriculum Admin
When: each happens
Then: exactly one refresh each; ticking a material (renderAdminGrid) triggers none

Given: a plan with lastEditedAt "2026-10-05T14:22:31.123Z" and one with lastEditedAt "garbage"
When: the list renders
Then: "Oct 5" for the first; no date for the second

Given: Christie opens a plan (a fresh single-plan read) but does not refresh
When: the list redraws
Then: the "Last full refresh" time has not moved

Given: Christie visits Teacher View once, returns to Curriculum Admin, and Mariah saves a plan elsewhere
When: Christie presses ↻ Refresh
Then: the row's status and "last edited by Mariah" update AND the stamp moves (the refresh redraws the list itself)

Given: the app starts offline (the SDOC queries fail)
When: it loads
Then: the load guard trips with the banner — no empty or cached SDOC year is shown as editable

Given: Christie visits Teacher View once, returns to Curriculum Admin on the SDOC year, and a ↻ Refresh fails (injected once)
When: the automatic retry succeeds (no click)
Then: "Couldn't refresh" is gone, the rows and the stamp are fresh, the load guard is true, and Open plan opens editable

Given: Christie visits Teacher View once and returns to Curriculum Admin — once on the SDOC year, once on a weekly semester
When: a weekly lesson save elsewhere changes curriculum/lessonData (a snapshot-triggered reload)
Then: without pressing Refresh, the SDOC list redraws and its stamp moves; the weekly grid shows the other device's change</div>
  <p><strong>Tests (emulator, red first):</strong> new cases P1–P8 in <code>e2e/day-off-camps.spec.js</code> or a new <code>e2e/day-off-overview.spec.js</code> (planner + prep sessions; a direct write stands in for the teacher's other-device save); write spy on render and refresh; full suite before the dual implementation review.</p>
  <p><strong>Not in 3:</strong> the "not started, camp soon" warning (offered, declined for now); filtering or sorting by status; emailing teachers.</p>
</div>

<div class="phase">
  <h3>Phase 4 — Prep integration — superseded</h3>
  <p>Superseded by 2A (materials built by the planner, ticked by prep) and 2A.1 (one checklist per event). Christie, Sep 24: no prep dashboard for SDOC.</p>
</div>

<h2 id="safety">Firebase safety checklist</h2>
<div class="phase">
  <table>
    <tr><th>Gate</th><th>This plan</th></tr>
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Xtt8FkqR' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-DnyRCU8q' (errno=Operation not permitted)
   630	let tvCurrentTeacher = '';
   631	let tvCurrentClassFilter = 'all';
   632	let tvNavStack = [];  // Stack of { teacher, classFilter, scrollY } for back navigation
   633	let campCompleteData = {};
   634	
   635	function getTvSemKey() {
   636	  // Now uses global semester instead of per-tab selection
   637	  return getActiveSemesterKey();
   638	}
   639	
   640	function isCoTeacherForCurrentSemester() {
   641	  const user = getAuthUser();
   642	  if (!user || tvCurrentTeacher) return false;
   643	  const semKey = getTvSemKey();
   644	  const lessons = currentLessonData?.[semKey];
   645	  return !!lessons && Object.values(lessons).some(l =>
   646	    Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
   647	  );
   648	}
   649	
   650	async function initTeacherView() {
   651	  // Already built: the semester may have changed on another tab — refresh for
   652	  // it (renderTeacherView handles SDOC, and leaving SDOC, itself).
   653	  if (tvInitialized) {
   654	    if (isDayOffYear(getTvSemKey()) || tvTeacherListFor) { renderTvSemesterSelector(); renderQaActivityPanel(); renderTeacherView(); }
   655	    return;
   656	  }
   657	  tvInitialized = true;
   658	
   659	  // Load lesson data if not already loaded
   660	  if (!currentLessonData) {
   661	    await loadLessonData();
   662	  }
   663	
   664	  // Show banner and abort if load failed — prevents stale blank data from being saved.
   665	  // Not "initialized": the guard can trip transiently now (a listener reload
   666	  // that fails and self-heals — Backtracking audit Phase 7), and the next
   667	  // visit to this tab must be allowed to build it.
   668	  if (lessonDataLoadedSuccessfully === false) {
   669	    tvInitialized = false;
   670	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   671	    return;
   672	  }
   673	
   674	  // Set up real-time listener FIRST so the retry mechanism fires even if
   675	  // summer camp data isn't ready yet when we reach the early-return below.
   676	  setupLessonDataListener((data) => {
   677	    currentLessonData = data;
   678	    renderProgressDashboard();
   679	    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
   680	    // no sharedWith — so re-render on every reload while the year is showing
   681	    // (the list and the teacher picker are rebuilt from the camps each time).
   682	    if (isDayOffYear(getTvSemKey())) {
   683	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
   684	      renderTeacherMappingTable();
   685	      return;
   686	    }
   687	    // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
   688	    const semKey = getTvSemKey();
   689	    const lessons = currentLessonData?.[semKey];
   690	    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
   691	      const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
   692	      if (!hasTeachers) {
   693	        tvInitialized = false;
   694	        initTeacherView();
   695	      }
   696	    }
   697	    // Skip re-render while a camp is expanded — preserves expanded state on live data updates
   698	    const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
   699	    if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
   700	    // Refresh teacher mapping table in Settings if it exists
   701	    renderTeacherMappingTable();
   702	  });
   703	
   704	  // Build semester selector (only show if multiple published semesters)
   705	  renderTvSemesterSelector();
  5015	async function initCurriculumAdmin() {
  5016	  if (caInitialized) return;
  5017	  caInitialized = true;
  5018	
  5019	  if (!currentLessonData) await loadLessonData();
  5020	  if (!currentChangeLog) await loadChangeLog();
  5021	  if (!currentCutProjects) await loadCutProjects();
  5022	  if (!currentFutureProjects) await loadFutureProjects();
  5023	
  5024	  renderSemesterSelector();
  5025	  renderAdminGrid();
  5026	  renderHelpQueue();
  5027	  renderCutBank();
  5028	  renderIdeaBank();
  5029	  renderChangeHistory();
  5030	
  5031	  // Modal close
  5032	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5033	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5034	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5035	  });
  5036	
  5037	  // Real-time updates
  5038	  setupLessonDataListener((data) => {
  5039	    currentLessonData = data;
  5040	    renderAdminGrid();
  5041	    renderHelpQueue();
  5042	    // Refresh teacher mapping table in Settings if it exists
  5043	    renderTeacherMappingTable();
  5044	  });
  5045	}
  5046	
  5047	function renderAdminGrid() {
  5048	  const wrapper = document.getElementById('ca-grid-wrapper');
  5049	  const semKey = getAdminSemKey();
  5050	  const lessons = currentLessonData?.[semKey];
  5051	
  5052	  // School Day Off Camps years: the event/camp planning list (Phase 1).
  5053	  if (isDayOffYear(semKey)) {
  5054	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5055	    renderDayOffAdmin(semKey);
  5056	    return;
  5057	  }
  5058	  // Camp seasons get their own view instead of the weekly curriculum grid
  5059	  if (isCampSeason(semKey)) {
  5060	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-AIkJKQfQ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-aJSZv5o6' (errno=Operation not permitted)
  1125	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1126	      const plans = campSeasonLoadPlan();
  1127	      const fresh = {};
  1128	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1129	      const dayOffKeys = dayOffYearKeys();
  1130	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1131	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1132	      for (const yearKey of dayOffKeys) {
  1133	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1134	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1135	      }
  1136	      for (const plan of plans) {
  1137	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1138	        // prunes parked copies that are absent from `fresh`, so merging one
  1139	        // season against another's would evict the other's on every reload.
  1140	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1141	      }
  1142	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1143	      lessonDataLoadedSuccessfully = true;
  1144	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1145	      return 'ok';
  1146	    } catch (err) {
  1147	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1148	      if (!isCurrent()) return 'stale';
  1149	      lessonDataLoadedSuccessfully = false;
  1150	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1151	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1152	      if (delay !== undefined) {
  1153	        setTimeout(() => {
  1154	          if (!isCurrent()) return; // a newer snapshot has taken over
  1155	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1156	        }, delay);
  1157	      }
  1158	      return 'failed';
  1159	    }
  1160	  };
  1161	
  1162	  // The registry-change entry point: same reload, same generation gate, and it
  1163	  // renders through the same callback when it is still the current generation.
  1164	  summerReloadHook = async () => {
  1165	    const myGeneration = ++globalListenerGeneration;
  1166	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1167	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1168	    return outcome;
  1169	  };
  1170	
  1171	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1172	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1173	      // Skip cache-only updates
  1174	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1175	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1176	        return;
  1177	      }
  1178	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1179	      if (!doc.exists) return;
  1180	
  1181	      const myGeneration = ++globalListenerGeneration;
  1182	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1183	      // in their own collection, so carry their current maps across the swap
  1184	      // and let the reload below refresh each one (Phase 1, 1.4).
  1185	      const previousSummer = snapshotCampSeasons();
  1186	      currentLessonData = doc.data();
  1187	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1188	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1189	
  1190	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1191	      // A superseded reload renders nothing — the newer snapshot's own
  1192	      // callback already did (or will), with the same live object. A failed
  1193	      // one still renders: the non-summer semesters in this snapshot are new.
  1194	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1195	    });
  1196	}
  1197	
  1198	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1199	
  1200	async function loadCutProjects() {
  1201	  if (!curriculumDb) initCurriculumFirestore();
  1202	  try {
  1203	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1204	    currentCutProjects = doc.exists ? doc.data() : {};
  1205	  } catch (err) {

exec
/bin/zsh -lc "git -C /Users/christiehubley/tinker-spring-curriculum grep -n 'setupLessonDataListener\\|initTeacherView\\|initCurriculumAdmin' 2ef2e62 -- js/app.js js/firebase-data.js

git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/app.js | nl -ba | sed -n '95,235p;450,535p'

git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/firebase-data.js | nl -ba | sed -n '735,805p;1070,1128p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-N6ZRpGEF' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-zsHJTYQc' (errno=Operation not permitted)
2ef2e62:js/app.js:188:  await initCurriculumAdmin();
2ef2e62:js/app.js:215:        initTeacherView();
2ef2e62:js/app.js:219:        initCurriculumAdmin();
2ef2e62:js/app.js:650:async function initTeacherView() {
2ef2e62:js/app.js:676:  setupLessonDataListener((data) => {
2ef2e62:js/app.js:694:        initTeacherView();
2ef2e62:js/app.js:1612:  // this semester the way initTeacherView() does.
2ef2e62:js/app.js:5015:async function initCurriculumAdmin() {
2ef2e62:js/app.js:5038:  setupLessonDataListener((data) => {
2ef2e62:js/firebase-data.js:1083:// generation counter is module-scoped across every setupLessonDataListener()
2ef2e62:js/firebase-data.js:1102:// Set by setupLessonDataListener() so a season-registry mode change (legacy →
2ef2e62:js/firebase-data.js:1112:function setupLessonDataListener(callback) {
2ef2e62:js/firebase-data.js:1323:// distinction setupLessonDataListener already makes for snapshots, above).
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-DcifA8he' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-48ZK0nZj' (errno=Operation not permitted)
    95	
    96	function setGlobalSemester(key) {
    97	  if (!currentConfig?.semesters?.[key]) return;
    98	
    99	  globalSemesterKey = key;
   100	  localStorage.setItem('globalSemesterKey', key);
   101	
   102	  // Hide/show Prep Dashboard tab based on semester type
   103	  const semester = currentConfig.semesters[key];
   104	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   105	  if (prepDashboardTab) {
   106	    if (!isWeeklySemester(key)) {   // camp seasons and SDOC years have no prep dashboard
   107	      prepDashboardTab.style.display = 'none';
   108	      // If currently on Prep Dashboard, switch to Teacher View
   109	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
   110	        switchTab('teacher-view');
   111	        return; // Exit early since switchTab will handle the rest
   112	      }
   113	    } else {
   114	      prepDashboardTab.style.display = '';
   115	    }
   116	  }
   117	
   118	  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
   119	  updateCurriculumAdminTab();
   120	
   121	  // Refresh all tabs to use new semester
   122	  const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
   123	
   124	  if (activeTab === 'teacher-view') {
   125	    renderTvSemesterSelector();
   126	    renderProgressDashboard();
   127	    renderQaActivityPanel();
   128	    updateClassFilter(); // Update class dropdown for new semester
   129	    renderTeacherView();
   130	  } else if (activeTab === 'prep-dashboard') {
   131	    const weekNum = document.getElementById('week-select')?.value || 1;
   132	    loadWeekData(parseInt(weekNum));
   133	  } else if (activeTab === 'curriculum-admin') {
   134	    renderSemesterSelector();
   135	    renderAdminGrid();
   136	    renderHelpQueue();
   137	    renderCutBank();
   138	    renderIdeaBank();
   139	    renderChangeHistory();
   140	  } else if (activeTab === 'settings') {
   141	    loadSettingsForm();
   142	  }
   143	}
   144	
   145	// ─── Initialization ─────────────────────────────────
   146	
   147	document.addEventListener('DOMContentLoaded', async () => {
   148	  const user = await requireAuth();
   149	  if (!user) return;
   150	
   151	  initCurriculumFirestore();
   152	  await loadConfig();
   153	  // A failed config read is fatal to the whole app by design (Phase 1, 1.2) —
   154	  // nothing below can be trusted, and loadLessonData() must not run.
   155	  if (configLoadFailed) return;
   156	  await loadPrepData();
   157	
   158	  initGlobalSemesterSelector();
   159	
   160	  // Decide how the shared summer collections may be read BEFORE anything reads
   161	  // them (Phase 1, 1.3): a forced-server read of the registry's switch, then a
   162	  // listener — never awaited — so this tab follows the Summer Camp App
   163	  // switching seasons on, and heals if it started offline.
   164	  await loadSeasonRegistryMode();
   165	  watchSeasonRegistry({
   166	    onModeChange: () => { reloadSummerForModeChange(); },
   167	  });
   168	
   169	  // Pre-load lesson data on startup so any load failure is detected immediately
   170	  await loadLessonData();
   171	  if (lessonDataLoadedSuccessfully === false) {
   172	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   173	  }
   174	
   175	  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
   176	  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
   177	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   178	  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
   179	    prepDashboardTab.style.display = 'none';
   180	  }
   181	
   182	  setupTabs();
   183	  setupRoleAccess();
   184	  setupFooter();
   185	  loadSettingsForm();
   186	
   187	  // Initialize Curriculum Admin (default tab)
   188	  await initCurriculumAdmin();
   189	
   190	  // Real-time sync for prep data
   191	  setupPrepDataListener(onPrepDataChange);
   192	});
   193	
   194	// ─── Tab Navigation ─────────────────────────────────
   195	
   196	let lastDiagFingerprint = null;  // Track which diagnostic item we navigated from
   197	
   198	function switchTab(tabId) {
   199	  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
   200	  if (btn) btn.click();
   201	}
   202	
   203	function setupTabs() {
   204	  document.querySelectorAll('.tab-btn').forEach(btn => {
   205	    btn.addEventListener('click', () => {
   206	      const tabId = btn.dataset.tab;
   207	
   208	      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
   209	      btn.classList.add('active');
   210	
   211	      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
   212	      document.getElementById(tabId)?.classList.add('active');
   213	
   214	      if (tabId === 'teacher-view') {
   215	        initTeacherView();
   216	      } else if (tabId === 'prep-dashboard') {
   217	        initPrepDashboard();
   218	      } else if (tabId === 'curriculum-admin') {
   219	        initCurriculumAdmin();
   220	      } else if (tabId === 'settings') {
   221	        ensureSettingsFormMatchesHeader();
   222	      }
   223	      if (tabId === 'settings' && lastDiagFingerprint) {
   224	        // Scroll back to the diagnostic item we came from
   225	        setTimeout(() => {
   226	          scrollToDiagItem(lastDiagFingerprint);
   227	          lastDiagFingerprint = null;
   228	        }, 100);
   229	      }
   230	    });
   231	  });
   232	}
   233	
   234	function scrollToDiagItem(fingerprint) {
   235	  // Find the diagnostic item by its fingerprint (stored on dismiss/undismiss/note buttons)
   450	    const pct = total > 0 ? Math.round((complete / total) * 100) : 100;
   451	    const cardId = `teacher-detail-${teacher.name.replace(/\s+/g, '-')}`;
   452	
   453	    const incomplete = teacher.lessons.filter(l => l._progress !== 'complete');
   454	    incomplete.sort((a, b) => (a.weekNum || 0) - (b.weekNum || 0));
   455	
   456	    let statusBadges = '';
   457	    if (ready > 0) statusBadges += `<span class="urgency-badge" style="background:#E3F2FD;color:#1565C0;">${ready} almost done</span>`;
   458	    if (inProgress > 0) statusBadges += `<span class="urgency-badge" style="background:#FFF8E1;color:#F57F17;">${inProgress} in progress</span>`;
   459	    if (notStarted > 0) statusBadges += `<span class="urgency-badge" style="background:#F0F0F0;color:#999;">${notStarted} not started</span>`;
   460	
   461	    html += `
   462	      <div class="status-card ${isGood ? 'status-card-good' : 'status-card-warn'}"
   463	           onclick="toggleTeacherDetail('${cardId}')" ${incomplete.length === 0 ? 'style="cursor: default;"' : ''}>
   464	        <div class="status-card-header">
   465	          <h3 class="status-card-name">${escHtml(teacher.name)}</h3>
   466	          <span class="status-card-fraction">${complete}/${total} complete</span>
   467	        </div>
   468	        <div class="status-progress-bar">
   469	          <div class="status-progress-fill ${isGood ? 'fill-good' : 'fill-warn'}" style="width: ${pct}%"></div>
   470	        </div>
   471	        ${statusBadges ? `<div class="status-card-urgency">${statusBadges}</div>` : ''}
   472	        ${incomplete.length > 0 ? `<div class="status-card-hint">Click to see ${incomplete.length} incomplete lesson${incomplete.length !== 1 ? 's' : ''}</div>` : ''}
   473	      </div>
   474	      ${incomplete.length > 0 ? renderTeacherDetail(cardId, incomplete) : ''}
   475	    `;
   476	  }
   477	
   478	  html += '</div>';
   479	  html += `<div class="status-recheck"><button class="check-status-btn" onclick="checkPublishStatus()">Re-check Progress</button></div>`;
   480	  dashboard.innerHTML = html;
   481	}
   482	
   483	function renderTeacherDetail(cardId, issues) {
   484	  let rows = '';
   485	  for (const lesson of issues) {
   486	    const projText = lesson.projectTitle || '<em>(no project yet)</em>';
   487	    const progress = lesson._progress || calculateLessonProgress(lesson);
   488	    const progressLabel = getProgressLabel(progress);
   489	    const progressClass = progress === 'ready' ? 'badge-blue'
   490	                        : progress === 'in-progress' ? 'badge-orange'
   491	                        : progress === 'not-started' ? 'badge-gray' : 'badge-green';
   492	
   493	    rows += `
   494	      <tr>
   495	        <td>${escHtml(lesson.className || '')}</td>
   496	        <td>${lesson.weekNum || lesson.week || ''}</td>
   497	        <td>${escHtml(lesson.weekDate || lesson.weekDates || '')}</td>
   498	        <td>${projText}</td>
   499	        <td><span class="status-badge-cell ${progressClass}">${progressLabel}</span></td>
   500	      </tr>
   501	    `;
   502	  }
   503	
   504	  return `
   505	    <div class="teacher-detail" id="${cardId}" style="display: none;">
   506	      <table class="status-table">
   507	        <thead><tr><th>Class Name</th><th>Week</th><th>Week Dates</th><th>Project Title</th><th>Progress</th></tr></thead>
   508	        <tbody>${rows}</tbody>
   509	      </table>
   510	    </div>
   511	  `;
   512	}
   513	
   514	function toggleTeacherDetail(cardId) {
   515	  const detail = document.getElementById(cardId);
   516	  if (!detail) return;
   517	  detail.style.display = detail.style.display !== 'none' ? 'none' : 'block';
   518	}
   519	
   520	
   521	// ═════════════════════════════════════════════════════
   522	// TEACHER VIEW
   523	// ═════════════════════════════════════════════════════
   524	
   525	// ─── Teacher Name Mapping ────────────────────────
   526	
   527	function getTeacherNameForCurrentUser() {
   528	  const user = getAuthUser();
   529	  if (!user) return null;
   530	
   531	  // 1. Check explicit UID → teacher name mappings in config
   532	  const mappings = currentConfig?.teacherMappings;
   533	  if (mappings && mappings[user.uid]) return mappings[user.uid];
   534	
   535	  // 2. Fuzzy-match user display name against known teacher names
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-eNc7rMvw' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-5GadzNzp' (errno=Operation not permitted)
   735	// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
   736	function dayOffYearKeys() {
   737	  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
   738	}
   739	
   740	function campSeasonLoadPlan() {
   741	  const semesters = currentConfig?.semesters || {};
   742	  return Object.keys(semesters)
   743	    .filter(isCampSeason)
   744	    .map(semKey => {
   745	      const season = seasonForSemester(semKey);
   746	      if (seasonRegistryMode === 'legacy') {
   747	        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
   748	      }
   749	      return { semKey, season };
   750	    });
   751	}
   752	
   753	// One camp season's lessons, or an empty map when legacy mode cannot serve it.
   754	async function loadOneCampSeason(plan, opts = {}) {
   755	  if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
   756	  return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
   757	}
   758	
   759	async function loadLessonData() {
   760	  if (!curriculumDb) initCurriculumFirestore();
   761	  try {
   762	    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
   763	    currentLessonData = doc.exists ? doc.data() : {};
   764	
   765	    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
   766	    try {
   767	      const plans = campSeasonLoadPlan();
   768	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   769	      for (const plan of plans) {
   770	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   771	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   772	      }
   773	      // School Day Off Camps years: their own three collections. A failure
   774	      // trips the same app-wide guard — loud, never a quiet empty list.
   775	      for (const yearKey of dayOffYearKeys()) {
   776	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
   777	        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
   778	      }
   779	      lessonDataLoadedSuccessfully = true;
   780	    } catch (err) {
   781	      // One season failing trips the guard for the whole app: a partially
   782	      // loaded model is not a safe base for any writer, in any semester.
   783	      console.error('❌ Could not load camp season data:', err);
   784	      lessonDataLoadedSuccessfully = false;
   785	    }
   786	  } catch (err) {
   787	    console.error('Error loading lesson data:', err);
   788	    currentLessonData = {};
   789	    lessonDataLoadedSuccessfully = false;
   790	  }
   791	  return currentLessonData;
   792	}
   793	
   794	// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
   795	// createLessonSlotsForRoster). Guarded the same way as
   796	// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
   797	// partial currentLessonData (or, for restoreFromBackup, would land over a
   798	// semester whose current state this client never confirmed), and merge:true
   799	// would still write it over the real semester map. Throws rather than no-ops —
   800	// every caller treats a resolved promise as "the write landed" (backtracking
   801	// audit, Phase 11).
   802	async function saveLessonData(semesterKey, lessons) {
   803	  if (lessonDataLoadedSuccessfully === false) {
   804	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   805	  }
  1070	    } else {
  1071	      displacedSummerServerCopies.delete(displacedKey(semKey, key));
  1072	    }
  1073	  }
  1074	  return fresh;
  1075	}
  1076	
  1077	// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
  1078	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1079	// Its outcome now drives the load-guard and the banner like the initial
  1080	// load does — a failure trips them, a later success resets them — and only
  1081	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1082	// unsubscribing a listener does not cancel its in-flight callback, so the
  1083	// generation counter is module-scoped across every setupLessonDataListener()
  1084	// call (and bumped by the call itself, so an old listener's in-flight reload
  1085	// is stale from the moment it is replaced). A tripped guard blocks every
  1086	// writer in the app, so a failed reload is retried a bounded number of times
  1087	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1088	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1089	// the reload takes (it used to vanish, so the summer view rendered nothing
  1090	// and an in-flight save's optimistic entry had no map to live in), and the
  1091	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1092	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1093	// The camp seasons currently in memory, by semester key.
  1094	function snapshotCampSeasons() {
  1095	  const out = {};
  1096	  for (const semKey of Object.keys(currentLessonData || {})) {
  1097	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1098	  }
  1099	  return out;
  1100	}
  1101	
  1102	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1103	// filtered, or unknown healing) re-runs the summer load through that
  1104	// listener's own generation-gated path — never a second, competing one
  1105	// (Phase 1, 1.3).
  1106	let summerReloadHook = null;
  1107	async function reloadSummerForModeChange() {
  1108	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1109	  return await summerReloadHook();
  1110	}
  1111	
  1112	function setupLessonDataListener(callback) {
  1113	  console.log('📚 Setting up lesson data listener...');
  1114	  if (!curriculumDb) initCurriculumFirestore();
  1115	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1116	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1117	
  1118	  // One reload attempt for one snapshot generation. Only the latest
  1119	  // generation may touch the guard, the banner, or the summer cache.
  1120	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1121	  // outcome was discarded (a newer snapshot took over while it ran).
  1122	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1123	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1124	    try {
  1125	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1126	      const plans = campSeasonLoadPlan();
  1127	      const fresh = {};
  1128	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });

codex
The main Round 3 path is now covered, but the “vice versa is unnecessary” claim has an initialization-race edge case. I’m checking that sequence against the pinned startup flow before issuing the verdict.
exec
/bin/zsh -lc "git -C /Users/christiehubley/tinker-spring-curriculum grep -n 'let currentChangeLog\\|let currentCutProjects\\|let currentFutureProjects\\|var currentChangeLog\\|const currentChangeLog' 2ef2e62 -- js/*.js" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-U4DT7EPp' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-hBvDBeJj' (errno=Operation not permitted)
2ef2e62:js/firebase-data.js:129:let currentCutProjects = null;
2ef2e62:js/firebase-data.js:130:let currentChangeLog = null;
2ef2e62:js/firebase-data.js:131:let currentFutureProjects = null;

codex
## Verdict: CHANGES NEEDED — 1 new MEDIUM

The Round 3 MEDIUM is fixed for the intended sequence: Teacher View’s callback will redraw active Curriculum Admin before the SDOC early return. The two new BDDs cover automatic-retry recovery and snapshot-triggered reloads. Derived failure state and deferred build sequencing are coherent.

### MEDIUM — “Vice versa” is still needed

The claim that Curriculum Admin can own the listener only before Teacher View finishes initializing is false due to startup concurrency:

1. Startup installs tab handlers, then awaits `initCurriculumAdmin()` (`app.js:182–188`).
2. `initCurriculumAdmin()` sets `caInitialized = true`, then awaits change-log, cut-project, and future-project loads before registering its listener (`:5015–5038`).
3. During those awaits, a user can click Teacher View. `initTeacherView()` can finish and register Teacher View’s callback (`:650–702`).
4. Curriculum Admin then resumes and registers its callback last.
5. Later Teacher View visits return early because `tvInitialized` remains true (`:653–655`), so it never retakes ownership.

Therefore, Curriculum Admin’s callback can permanently own the listener while Teacher View is fully initialized. Snapshot reloads then fail to redraw an active Teacher View.

Restore symmetric active-view redraw—or centralize callback dispatch—and add a BDD that delays Curriculum Admin’s awaited initialization, visits Teacher View, lets Curriculum Admin finish, then verifies a snapshot updates Teacher View.

No files changed.
tokens used
34,800
## Verdict: CHANGES NEEDED — 1 new MEDIUM

The Round 3 MEDIUM is fixed for the intended sequence: Teacher View’s callback will redraw active Curriculum Admin before the SDOC early return. The two new BDDs cover automatic-retry recovery and snapshot-triggered reloads. Derived failure state and deferred build sequencing are coherent.

### MEDIUM — “Vice versa” is still needed

The claim that Curriculum Admin can own the listener only before Teacher View finishes initializing is false due to startup concurrency:

1. Startup installs tab handlers, then awaits `initCurriculumAdmin()` (`app.js:182–188`).
2. `initCurriculumAdmin()` sets `caInitialized = true`, then awaits change-log, cut-project, and future-project loads before registering its listener (`:5015–5038`).
3. During those awaits, a user can click Teacher View. `initTeacherView()` can finish and register Teacher View’s callback (`:650–702`).
4. Curriculum Admin then resumes and registers its callback last.
5. Later Teacher View visits return early because `tvInitialized` remains true (`:653–655`), so it never retakes ownership.

Therefore, Curriculum Admin’s callback can permanently own the listener while Teacher View is fully initialized. Snapshot reloads then fail to redraw an active Teacher View.

Restore symmetric active-view redraw—or centralize callback dispatch—and add a BDD that delays Curriculum Admin’s awaited initialization, visits Teacher View, lets Curriculum Admin finish, then verifies a snapshot updates Teacher View.

No files changed.
