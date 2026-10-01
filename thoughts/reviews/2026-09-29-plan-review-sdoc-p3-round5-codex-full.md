OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f075-afac-7d11-8ee7-8d645b2baf8f
--------
user
# Plan review ROUND 5 (short, targeted confirmation) — Classbook SDOC Phase 3, revision 5
Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3". Re-read ONLY:
the "Redraw on every install — one shared listener callback" paragraph, the last two sentences of the "Failure"
paragraph, the last three BDDs of the Phase 3 BDD block, and the top Decisions Log entry.

Code is READ-ONLY and pinned to 2ef2e62: `git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/app.js`
(and `:js/firebase-data.js`). Do NOT edit anything anywhere.

Round 4: ~/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-{codex-full,claude}.md — both found
the startup race (Curriculum Admin can register the single listener last, after Teacher View built), so revision 4's
"reverse redraw not needed" claim was wrong. Revision 5: both inits register ONE shared onLessonDataReload() that runs
each INITIALISED view's existing per-tick redraw (Teacher View's body moved into teacherViewOnReload(); Curriculum
Admin's renderAdminGrid()+renderHelpQueue()), then renderTeacherMappingTable() once. Also dayOffRefreshFailed is now
set inside the gated reload's failure path behind isCurrent().

Check: (a) round-4 findings fixed; (b) running each initialised view's redraw regardless of which tab is showing is
truly behaviour each view's own callback already has today (no new behaviour), and nothing in Teacher View's body
misbehaves when Curriculum Admin is the visible tab or vice versa; (c) the gating on tvInitialized / caInitialized is
right given caInitialized is set BEFORE its awaits (app.js:5016-5017) and tvInitialized can be reset (668-672).
Only NEW HIGH/MEDIUM block. Verdict READY / CHANGES NEEDED; ≤300 words.

codex
I’ll do the narrowly scoped read-only check against the specified plan excerpts, prior round-4 reviews, and pinned commit. No files will be changed.
exec
/bin/zsh -lc "rg -n 'Redraw on every install|Failure|Given|Scenario|Decisions Log|onLessonDataReload|dayOffRefreshFailed|tvInitialized|caInitialized' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-claude.md" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-claude.md:11:**LOW 1 — the "vice versa" claim is over-broad, though the drop is still correct.** `initCurriculumAdmin` is guarded by `caInitialized`, never reset, so it registers once — but it is *awaited at startup after* `setupTabs()` (183 → 188) and then awaits `loadChangeLog/loadCutProjects/loadFutureProjects`. Clicking Teacher View inside that window lets `initTeacherView` fully build and register (no await: `currentLessonData` is already loaded at 168), after which `initCurriculumAdmin` resumes and clobbers it at 5038. So Curriculum Admin's callback *can* own the listener with Teacher View fully initialised. Phase 3 is unharmed (that callback redraws the admin list), and stale Teacher View is pre-existing — reword the claim rather than re-adding the fix.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-claude.md:13:**LOW 2** — say `dayOffRefreshFailed[yearKey]` is set inside the gated reload's `'failed'` resolution (behind `isCurrent()`), not only at the button's call site, mirroring where the stamp clears it; otherwise a retry/snapshot failure shows only the global banner.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:37:  <span class="status-tag ready">execution-ready: true — Phase 1</span> — <strong>Christie, Sep 21, 2026: "go — mark all three execution-ready". The model is redrawn for multi-day, multi-camp SDOCs with shared plans; Phase 1 (rules, data layer, admin UI, tests) is execution-ready after four Codex + Claude review rounds; Phases 2–4 remain draft shape and are NOT. Sequenced after <code>classbook-camp-seasons.html</code> Phase 1 (or carries its five small prerequisites itself — log it if so).</strong> Earlier: scoping complete, D1–D6 all decided Sep 20 (see Decisions Log).
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:68:  <div class="safe"><strong>Nothing open here.</strong> Answers (full text in the Decisions Log, Sep 20 evening): <strong>D1</strong> yes, a third semester type. <strong>D2</strong> an event = one or more day-off dates hosting several camps (AM/PM, studios/ages, locations), each with project blocks + Open Studio. <strong>D3</strong> manual date entry; a BVSD import is a nice-to-have. <strong>D4</strong> (b) teachers see only their own camps; co-teachers share one plan and both edit. <strong>D5</strong> a quantity-bearing materials list is in v1 (built by the planner in 2A). <strong>D6</strong> a headcount per camp (from placements) for materials; no rosters. The questions below are kept as asked, for history.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:144:  <div class="bdd">Given: the rules are deployed and Christie opens + New Semester → Type = School Day Off Camps with Aug 1, 2026 – May 31, 2027
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:148:Given: the SDOC year is selected in Curriculum Admin
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:152:Given: two admins add different events to the same year within a minute
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:156:Given: Christie enters Nov 24 in a second event, or Jul 4 2027 (outside the year), or leaves the label blank
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:160:Given: a camp's project "Clay Creatures" has a plan with content (seeded) and Christie renames it to "Clay Critters"
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:164:Given: an event still has two camps, and separately a camp whose project has a plan with content
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:168:Given: a camp with only content-less scaffold plan docs
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:172:Given: a manager, a classbook-admin, a plain teacher, a summer-camp-only user and an archived user
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:176:Given: an SDOC year is selected and an admin replies to a question, or opens the admin edit path, before Phase 3 adds the SDOC branches
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:180:Given: the SDOC year is selected by an admin
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:184:Given: Phase 1 is deployed
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:247:  <div class="bdd">Given: Thanksgiving Break has "Clay Creatures" (Beanie Painting: 2 items; Glaze Day: 3 items) and "Paint Party" (Canvas: 1 item)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:251:Given: the checklist is open
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:255:Given: the planner removed "Uniposcas" after Allie opened the checklist
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:259:Given: Clay Creatures has 1 unticked item
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:263:Given: a teacher (classbook only, not prep) is signed in
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:267:Given: Clay Creatures was signed off, then the planner changed an item's quantity (which clears the sign-off)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:335:    <li><code>initTeacherView()</code>'s SDOC branch (:647-651) today sets <code>tvInitialized = false</code> and returns <em>above</em> the auto-select (:661-684), the <code>teacherSelect</code> change listener (:686-693) and the class filter (:695-699) (Claude MEDIUM). 2B stops returning early and sets <code>tvInitialized = true</code> like the other types (so <code>setupLessonDataListener()</code>, :620, is not re-subscribed each visit); the select listener is bound once, guarded by <code>dataset.listenerAttached</code> as :743 does; the class filter stays hidden for SDOC. It it builds the teacher list from <code>currentDayOffCamps[yearKey]</code> (<em>camps</em>, not slots, so a teacher whose camps have only empty blocks still appears), flattening <code>teachers</code>; the same in the semester-change handler (:759) and <code>populateTvTeacherList()</code> (:784-809). Non-admin users are fixed to their own name (unchanged rule).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:345:  <div class="bdd">Given: "Clay Creatures" (Thanksgiving Break) has teachers Fixture Teacher + TESTteacher2 and "Paint Party" the same day has TESTteacher3, each with a plan
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:349:Given: TESTteacher2 opens the same plan afterwards
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:353:Given: both teachers have the plan open and edit different fields
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:357:Given: the planner renames "Beanie Painting" to "Beanie Art" while Fixture Teacher's editor is open
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:361:Given: a save fails after a new photo uploaded
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:365:Given: Allie (prep, classbook) opens a teacher's SDOC plan from Teacher View and edits the closure
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:369:Given: a curriculum-admin user WITHOUT the classbook key opens an SDOC plan
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:373:Given: Monday has Block 1 named and Block 2 empty; Tuesday has Block 2 set to "—"
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:377:Given: a title runs Monday (Block 1) and Tuesday (Block 2)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:381:Given: the SDOC year is unpublished
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:385:Given: a manager publishes the SDOC year with one camp that has no teachers
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:389:Given: an SDOC key reaches sendTeacherQaMessage / adminLessonStillExistsWithRetry / sendHelpResponse / sendQaReply / saveLessonData / saveMultipleLessonFields
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:393:Given: Clay Creatures has TESTteacher1 + TESTteacher2 and NO teacherMappings entry for either
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:397:Given: the planner removes TESTteacher2 from the camp while her editor is open
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:401:Given: a caller passes fieldsToClear: ['materialItems'] (or campId, yearKey) to an SDOC save
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:405:Given: Clay Creatures is signed off (Materials complete)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:409:Given: scheduleDayOffReload() is mid-flight (a 2A tick just happened)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:413:Given: a reload whose plan query is forced to resolve with the PRE-save documents (injected delay: the query result is captured, the teacher's save verifies, then the reload installs)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:417:Given: Fixture Teacher removes the demo photo in the editor and saves
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:421:Given: Fixture Teacher and TESTteacher2 both edit "closure" seconds apart
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:425:Given: Fixture Teacher empties "closure" (a clear) and TESTteacher2 saves new closure text just after
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:429:Given: Fixture Teacher removes the photo and TESTteacher2 uploads a replacement just after
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:433:Given: the clock is frozen and Fixture Teacher saves twice from two tabs (identical lastEditedAt), the second restoring the first's field
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:437:Given: Fixture Teacher opens a never-planned project and presses Save without typing
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:441:Given: a co-teacher's later save (different lastEditId) is installed by the verifier and her clock is behind mine
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:445:Given: a save whose read-back carries THIS save's own lastEditId but a field did not land (injected)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:449:Given: Plan complete is ticked from the list
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:453:Given: two teachers "Alex Smith" and "Alex Jones" are in the year's pool and the signed-in "Alex" has no mapping
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:457:Given: a curriculum-admin user without classbook whose name IS on the camp
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:461:Given: Fixture Teacher types for a while (10 autosaves)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:465:Given: the plan is saved through the real editor Save button and through the list's Plan complete checkbox
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:469:Given: a project title and teacher name containing &lt;img onerror&gt;
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:509:  <div class="bdd">Given: a planner opens "Canvas Painting part 1 — Materials" for Northern Lights
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:513:Given: the planner types a vision and, before saving, a prep user's tick redraws the popup
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:517:Given: a link "javascript:alert(1)" or "www.pinterest.com/x" (no scheme)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:521:Given: a hand-written record carrying projectLinks ["javascript:window.__pwned=1"] and details containing &lt;img onerror&gt;
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:525:Given: the teacher (Mariah) opens that project's plan once the year is published
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:529:Given: a planner clears the vision and removes every link, then saves
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:533:Given: a teacher's plan save (2B) races a planner's details save on the same record
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:537:Given: the planner renames "Canvas Painting part 1" → "Aurora Canvas" in the camp editor
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:541:Given: a record whose only content is projectDetails
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:545:Given: Kathy (prep) opens the popup
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:549:Given: a camp day with Block 2 "N/A" and Open Studio "none"
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:553:Given: every spelling — "—", "-", "n/a", "N/A", " na ", "NONE" — and "n/a" typed in two blocks of one day
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:557:Given: a real project "Clay Creatures" with a list, changed to "n/a" in the camp editor
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:561:Given: two planners open the same project popup; A adds a link and saves; B then adds a different link and saves
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:565:Given: a project with no record, only a link typed (no vision)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:569:Given: 5,001 characters of vision, 11 links, or two identical links
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:573:Given: a vision payload containing  https://x.com/"onmouseover="window.__pwned=1  and a stored link of the same shape
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:577:Given: a teacher calls saveSingleLesson on an SDOC plan with projectDetails or projectLinks in the payload
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:581:Given: a record whose only content is projectLinks
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:585:Given: a details draft typed in the popup, with the caret mid-paragraph
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:589:Given: the planner types details in project A's popup, closes (discarding), then opens project B — once normally and once with B's read failing
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:593:Given: A's read is held; the planner opens B (B's read completes); then A's read resolves
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:597:Given: planner A saves details, then saves again without reopening
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:601:Given: planner A has the popup open; planner B saves new links; a prep tick then redraws A's materials
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:622:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:624:  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:627:  <div class="bdd">Given: Thanksgiving has Clay Creatures (Clay Creatures: intro + steps written; Glaze Day: nothing) and Paint Party (Canvas: Plan complete)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:631:Given: a camp day with "n/a", "—" and Open Studio blocks, and a title that runs Monday and Wednesday
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:635:Given: Mariah saves a plan on her own device after Christie's page loaded
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:639:Given: the refresh's read fails
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:643:Given: Christie presses Open plan on Glaze Day, types a closure, and closes
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:647:Given: Allie (prep) views the list
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:651:Given: project titles and teacher names containing quotes and &lt;img onerror&gt;
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:655:Given: an event whose camps have no projects yet
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:659:Given: two camps in one event both have a project titled "Canvas", and a third title runs Monday and Wednesday in one camp
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:663:Given: a refresh is started, then a snapshot-triggered reload starts and finishes, then the first refresh resolves last
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:667:Given: a refresh fails (injected)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:671:Given: Christie leaves Curriculum Admin and comes back, and separately switches the header from a weekly semester to the SDOC year while on Curriculum Admin
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:675:Given: a plan with lastEditedAt "2026-10-05T14:22:31.123Z" and one with lastEditedAt "garbage"
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:679:Given: Christie opens a plan (a fresh single-plan read) but does not refresh
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:683:Given: Christie visits Teacher View once, returns to Curriculum Admin, and Mariah saves a plan elsewhere
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:687:Given: the app starts offline (the SDOC queries fail)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:691:Given: Christie visits Teacher View once, returns to Curriculum Admin on the SDOC year, and a ↻ Refresh fails (injected once)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:695:Given: Christie visits Teacher View once and returns to Curriculum Admin — once on the SDOC year, once on a weekly semester
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:699:Given: startup's Curriculum Admin initialisation is held open (its change-log load delayed), Christie clicks Teacher View, it builds, then Curriculum Admin finishes and registers
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:734:<h2 id="decisions-log">Decisions Log</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:736:  <li><strong>Sep 29, 2026 (Phase 3 review round 4 → revision 5):</strong> Claude READY (2 LOW); Codex CHANGES NEEDED (1 MEDIUM). Both found the same thing: revision 4's claim that the reverse redraw was unneeded was <strong>wrong</strong> — a startup race (a Teacher View click while <code>initCurriculumAdmin()</code> awaits its loads) lets Curriculum Admin register last, so Teacher View stops redrawing (pre-existing; Claude rated it LOW for Phase 3, Codex MEDIUM). Verified at app.js:182-188 and 5015-5038. <strong>Folded:</strong> both inits now register one shared <code>onLessonDataReload()</code> that runs each <em>initialised</em> view's existing redraw — ownership no longer matters, no new behaviour; <code>dayOffRefreshFailed</code> is set inside the gated reload's failure path (Claude LOW). BDD +1 (the startup race). Next: round 5 (short), then Christie's go incl. <code>source: 'server'</code>. Build still waits for the storage migration.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:737:  <li><strong>Sep 29, 2026 (Phase 3 round-3 MEDIUM folded — revision 4; its "reverse not needed" claim was corrected in revision 5):</strong> Teacher View's listener callback now also calls <code>renderAdminGrid()</code> + <code>renderHelpQueue()</code> when Curriculum Admin is the active tab (before its SDOC early return), so the automatic retries and snapshot reloads redraw Curriculum Admin after a Teacher View visit — which also closes a pre-existing gap for the weekly grid. The "Couldn't refresh" message is derived at render time (<code>dayOffRefreshFailed[yearKey]</code>, cleared where the stamp is set). The "vice versa" from round 3 was dropped after checking the code: Curriculum Admin's callback can own the listener only while Teacher View has never finished initialising (its guard exit resets <code>tvInitialized</code>), so there is nothing to redraw. BDD +2. <strong>Christie, Sep 29: finish the design now, but build only after <code>classbook-per-semester-lesson-storage</code> lands</strong> (it reworks the same listener) — re-verify line references then. Next: round 4 (short, targeted), then Christie's go incl. her yes to <code>source: 'server'</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:759:  <li><strong>Sep 25, 2026 (plan review round 1 — 2A.1 + 2B, Codex + Claude; both CHANGES NEEDED; every finding verified against 2894adf and folded in):</strong> Claude HIGH: widening <code>lessonStoreFor()</code> would turn six callers' "throw" into a weekly write to <code>curriculum/lessonData</code> → the SDOC save now branches in <code>saveSingleLesson()</code> <em>before</em> <code>lessonStoreFor()</code>, which keeps throwing. Claude HIGH: the shared name resolver matches joined "A + B" strings, so the live two-teacher camps would have been view-only for both teachers → a separate SDOC resolver + a no-mapping second-teacher BDD. Codex HIGH ×3: <code>fieldsToClear</code> was outside the allow-list (could delete <code>materialItems</code>/identity) → writable + clearable sets, anything else throws (Claude had it MEDIUM); no re-check that the saver is still on the camp → re-checked on the fresh camp inside the transaction; the summer read-back verifies only non-empty content → <code>verifyDayOffPlanWrite()</code> checks every written/cleared field and returns the document installed. MEDIUMs folded: key parsing without <code>split('|||')</code> + <code>camp.yearKey</code>; <code>initTeacherView()</code> listener binding + <code>tvInitialized</code>; the Teacher View listener's SDOC branch; the editor table (read marks, reference section, Print hidden, <code>finishClose</code> without the old parameters, no backdrop close); Plan complete disabled without rights + every checkbox sharing a key; summer regression tests before the split; 2A.1 view token + <code>allSettled</code> + explicit <code>{yearKey, campId}</code> + <code>pendingDayOffTicks</code> re-keyed at both sites + sign-off re-sync. LOWs: photo path via <code>dayOffPlanDocId()</code>; the rename-before-read-back message; the model's stale materialsList/kept-fields note; the "camp read is the lock" argument recorded. BDD added: second teacher w/o mapping, removed teacher, clear allow-list + normal clear, sign-off byte-identical, save during a pending reload, <code>curriculum/lessonData</code> untouched, no camp write from 2A.1. Both confirmed: transactions sound, publish blockers fully inventoried (three consumers), permissions consistent with the rules, XSS handled. Reviews: <code>thoughts/reviews/2026-09-25-plan-review-sdoc-2a1-2b-{codex,claude-full}.md</code>. Next: round 2 (confirmation).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:787:  <p><strong>Status (Sep 29, 2026) — read this first:</strong> Phases 1–2C LIVE (<code>1745e95</code>; <code>main</code> now <code>2ef2e62</code> with the linkify XSS fix merged, not yet deployed). <strong>Phase 3 is mid-design (revision 5 — round 4 folded; next: review round 5)</strong> — see the top Decisions Log entry. The Phase 3 <em>build</em> waits for <code>classbook-per-semester-lesson-storage</code> to land (Christie, Sep 29). Later on Sep 29: <code>main</code> @ <code>e25d9db</code> is LIVE (XSS fix #2, onclick quoting #3, Teacher View collapse + pop-up links #4). Earlier status: <strong>Phases 2A.1 and 2B are LIVE</strong> (<code>22ed027</code>, Netlify <code>6aba91a4</code>, Sep 28). Christie publishes the SDOC year when she wants teachers to see it. Then Phase 3 (planner plan-status columns) and the follow-ups in the top Decisions Log entry. Earlier: Christie's Sep 25 materials are confirmed in the 11:54 backup (Beanie Painting: 2 items; no ticks yet). <strong>Phase 2A.1 (event materials checklist, revision 3) and Phase 2B (teachers plan, revision 7) are designed and their Codex + Claude reviews are CLEAN</strong> (2A.1 after 3 rounds, 2B after 8 — see the Decisions Log). Next: Christie's go per phase (2A.1 first) → red emulator tests → build → dual implementation review → "okay to deploy". No rules change in either. Earlier the same day: Phase 1 and Phase 2A are LIVE (Classbook <code>main</code> @ <code>67583e3</code>, Netlify <code>6ab683df</code>; rules <code>97f7915</code>). Christie has real data in production: SDOC 2026-27 (teachers Mariah, Kaitlyn), 3 events, 4 camps, some materials. <strong>Next, in order:</strong> (1) confirm her Sep 25 materials and a Kathy/Allie tick + Materials complete in a backup; (2) <strong>design Phase 2B</strong> (teachers plan their days; the Publish toggle for the type; Q&amp;A sequencing — see the Phase 2B draft and the model) to the same standard as 2A: write the design here → Codex + Claude review rounds until clean → Christie's go → build with emulator tests (use a private <code>TMPDIR</code> if another emulator suite is running) → dual implementation review → "okay to deploy". The Sep 24 Decisions Log entries hold every decision made in use (blocks grid, optional projects, materials in the build phase, prep check-off, view-only Kathy/Allie, drafts hidden in Teacher View).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:788:  <p><strong>Earlier status (Sep 21, 2026):</strong> model redrawn; Phase 1 designed in detail (real line numbers @ <code>a08dbeb</code>). Nothing built. Next, in order: (1) <code>/second-model-review</code> (Codex + Claude) on the model + Phase 1 until a round comes back clean — <strong>done — three rounds Sep 21, round 3 clean from both reviewers</strong> (see the Decisions Log); (2) <strong>done — Christie's go given Sep 21 ("go — mark all three execution-ready"); Phase 1 is execution-ready</strong>; (3) confirm the seasons plan's Phase 1 has shipped (or carry its five items — see the note under Phase 1); (4) build in the 1.1 → 1.6 order: <code>backup.js</code> edit + grep of both arrays (outside git) → rules commit in <code>studio-hub</code> (blocks, tests; other sessions' rules edits committed or stashed first) → Fable review → "approved to change firebase" → rules deploy → red e2e tests → implementation → dual implementation review → "okay to deploy"; (5) design Phase 2 in the same detail (the editor reuse, <code>saveSingleLesson()</code>'s third branch, Publish for the type). <strong>First step in any new session:</strong> check the plan reviewer (<code>plan-review index</code>) for Christie's comments, then re-read the model section — every later phase hangs off it. Do not touch product code before step (2).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:15:the "Build sequencing" paragraph, the last two sentences of the "Failure" paragraph, the new
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:16:"Redraw on every install" paragraph, the last two BDDs in the Phase 3 BDD block, and the top Decisions Log entry.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:32:   (668-672) resets tvInitialized = false. VERIFY this claim against the code (including initTeacherView's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:34:3. The "Couldn't refresh" message is derived at render time: dayOffRefreshFailed[yearKey] set on a 'failed' refresh,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:43:/bin/zsh -lc "rg -n 'Build sequencing|Failure|Redraw on every install|Decisions Log|phase-3|Phase 3' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html && rg -n 'MEDIUM|listener|vice versa|Teacher View|Curriculum Admin' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-{codex,claude}.md" in /Users/christiehubley/tinker-spring-curriculum
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:45:37:  <span class="status-tag ready">execution-ready: true — Phase 1</span> — <strong>Christie, Sep 21, 2026: "go — mark all three execution-ready". The model is redrawn for multi-day, multi-camp SDOCs with shared plans; Phase 1 (rules, data layer, admin UI, tests) is execution-ready after four Codex + Claude review rounds; Phases 2–4 remain draft shape and are NOT. Sequenced after <code>classbook-camp-seasons.html</code> Phase 1 (or carries its five small prerequisites itself — log it if so).</strong> Earlier: scoping complete, D1–D6 all decided Sep 20 (see Decisions Log).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:48:68:  <div class="safe"><strong>Nothing open here.</strong> Answers (full text in the Decisions Log, Sep 20 evening): <strong>D1</strong> yes, a third semester type. <strong>D2</strong> an event = one or more day-off dates hosting several camps (AM/PM, studios/ages, locations), each with project blocks + Open Studio. <strong>D3</strong> manual date entry; a BVSD import is a nice-to-have. <strong>D4</strong> (b) teachers see only their own camps; co-teachers share one plan and both edit. <strong>D5</strong> a quantity-bearing materials list is in v1 (built by the planner in 2A). <strong>D6</strong> a headcount per camp (from placements) for materials; no rosters. The questions below are kept as asked, for history.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:51:176:Given: an SDOC year is selected and an admin replies to a question, or opens the admin edit path, before Phase 3 adds the SDOC branches
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:58:622:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set when a refresh returns <code>'failed'</code> and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:59:624:  <p><strong>Redraw on every install — each callback also redraws the other active view (round 3, both MEDIUM).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). The listener is registered by <code>initCurriculumAdmin()</code> at startup (app.js:188 → 5038) and again by the first <code>initTeacherView()</code> (app.js:676; later visits return early, app.js:653-656), so after one Teacher View visit the callback is Teacher View's for the rest of the page's life — and Curriculum Admin, <strong>weekly grid included (a pre-existing gap)</strong>, stops redrawing on any reload. <strong>Fix:</strong> Teacher View's callback, right after <code>currentLessonData = data</code>, also calls <code>renderAdminGrid(); renderHelpQueue();</code> when Curriculum Admin's tab is the active one (<code>document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin'</code>) — placed before its SDOC branch's early <code>return</code> (app.js:682-686) so both branches do it. These are exactly the calls Curriculum Admin's own callback makes on every tick (app.js:5038-5043), so nothing new runs; the admin redraw just stops depending on which view registered last. <em>The reverse direction is not needed (revision 4, verified):</em> Curriculum Admin's callback can only own the listener while Teacher View has never finished initialising — its only early exit before registering (the load-guard <code>return</code>, app.js:668-672) resets <code>tvInitialized = false</code>, so there is no built Teacher View to redraw, and the next visit builds it and takes the listener. <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw when the callback also drew.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:61:730:<h2 id="decisions-log">Decisions Log</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:62:732:  <li><strong>Sep 29, 2026 (Phase 3 round-3 MEDIUM folded — revision 4):</strong> Teacher View's listener callback now also calls <code>renderAdminGrid()</code> + <code>renderHelpQueue()</code> when Curriculum Admin is the active tab (before its SDOC early return), so the automatic retries and snapshot reloads redraw Curriculum Admin after a Teacher View visit — which also closes a pre-existing gap for the weekly grid. The "Couldn't refresh" message is derived at render time (<code>dayOffRefreshFailed[yearKey]</code>, cleared where the stamp is set). The "vice versa" from round 3 was dropped after checking the code: Curriculum Admin's callback can own the listener only while Teacher View has never finished initialising (its guard exit resets <code>tvInitialized</code>), so there is nothing to redraw. BDD +2. <strong>Christie, Sep 29: finish the design now, but build only after <code>classbook-per-semester-lesson-storage</code> lands</strong> (it reworks the same listener) — re-verify line references then. Next: round 4 (short, targeted), then Christie's go incl. her yes to <code>source: 'server'</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:73:782:  <p><strong>Status (Sep 29, 2026) — read this first:</strong> Phases 1–2C LIVE (<code>1745e95</code>; <code>main</code> now <code>2ef2e62</code> with the linkify XSS fix merged, not yet deployed). <strong>Phase 3 is mid-design (revision 4 — round 3's MEDIUM folded; next: review round 4)</strong> — see the top Decisions Log entry. The Phase 3 <em>build</em> waits for <code>classbook-per-semester-lesson-storage</code> to land (Christie, Sep 29). Later on Sep 29: <code>main</code> @ <code>e25d9db</code> is LIVE (XSS fix #2, onclick quoting #3, Teacher View collapse + pop-up links #4). Earlier status: <strong>Phases 2A.1 and 2B are LIVE</strong> (<code>22ed027</code>, Netlify <code>6aba91a4</code>, Sep 28). Christie publishes the SDOC year when she wants teachers to see it. Then Phase 3 (planner plan-status columns) and the follow-ups in the top Decisions Log entry. Earlier: Christie's Sep 25 materials are confirmed in the 11:54 backup (Beanie Painting: 2 items; no ticks yet). <strong>Phase 2A.1 (event materials checklist, revision 3) and Phase 2B (teachers plan, revision 7) are designed and their Codex + Claude reviews are CLEAN</strong> (2A.1 after 3 rounds, 2B after 8 — see the Decisions Log). Next: Christie's go per phase (2A.1 first) → red emulator tests → build → dual implementation review → "okay to deploy". No rules change in either. Earlier the same day: Phase 1 and Phase 2A are LIVE (Classbook <code>main</code> @ <code>67583e3</code>, Netlify <code>6ab683df</code>; rules <code>97f7915</code>). Christie has real data in production: SDOC 2026-27 (teachers Mariah, Kaitlyn), 3 events, 4 camps, some materials. <strong>Next, in order:</strong> (1) confirm her Sep 25 materials and a Kathy/Allie tick + Materials complete in a backup; (2) <strong>design Phase 2B</strong> (teachers plan their days; the Publish toggle for the type; Q&amp;A sequencing — see the Phase 2B draft and the model) to the same standard as 2A: write the design here → Codex + Claude review rounds until clean → Christie's go → build with emulator tests (use a private <code>TMPDIR</code> if another emulator suite is running) → dual implementation review → "okay to deploy". The Sep 24 Decisions Log entries hold every decision made in use (blocks grid, optional projects, materials in the build phase, prep check-off, view-only Kathy/Allie, drafts hidden in Teacher View).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:74:783:  <p><strong>Earlier status (Sep 21, 2026):</strong> model redrawn; Phase 1 designed in detail (real line numbers @ <code>a08dbeb</code>). Nothing built. Next, in order: (1) <code>/second-model-review</code> (Codex + Claude) on the model + Phase 1 until a round comes back clean — <strong>done — three rounds Sep 21, round 3 clean from both reviewers</strong> (see the Decisions Log); (2) <strong>done — Christie's go given Sep 21 ("go — mark all three execution-ready"); Phase 1 is execution-ready</strong>; (3) confirm the seasons plan's Phase 1 has shipped (or carry its five items — see the note under Phase 1); (4) build in the 1.1 → 1.6 order: <code>backup.js</code> edit + grep of both arrays (outside git) → rules commit in <code>studio-hub</code> (blocks, tests; other sessions' rules edits committed or stashed first) → Fable review → "approved to change firebase" → rules deploy → red e2e tests → implementation → dual implementation review → "okay to deploy"; (5) design Phase 2 in the same detail (the editor reuse, <code>saveSingleLesson()</code>'s third branch, Publish for the type). <strong>First step in any new session:</strong> check the plan reviewer (<code>plan-review index</code>) for Christie's comments, then re-read the model section — every later phase hangs off it. Do not touch product code before step (2).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:111:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set when a refresh returns <code>'failed'</code> and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:113:  <p><strong>Redraw on every install — each callback also redraws the other active view (round 3, both MEDIUM).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). The listener is registered by <code>initCurriculumAdmin()</code> at startup (app.js:188 → 5038) and again by the first <code>initTeacherView()</code> (app.js:676; later visits return early, app.js:653-656), so after one Teacher View visit the callback is Teacher View's for the rest of the page's life — and Curriculum Admin, <strong>weekly grid included (a pre-existing gap)</strong>, stops redrawing on any reload. <strong>Fix:</strong> Teacher View's callback, right after <code>currentLessonData = data</code>, also calls <code>renderAdminGrid(); renderHelpQueue();</code> when Curriculum Admin's tab is the active one (<code>document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin'</code>) — placed before its SDOC branch's early <code>return</code> (app.js:682-686) so both branches do it. These are exactly the calls Curriculum Admin's own callback makes on every tick (app.js:5038-5043), so nothing new runs; the admin redraw just stops depending on which view registered last. <em>The reverse direction is not needed (revision 4, verified):</em> Curriculum Admin's callback can only own the listener while Teacher View has never finished initialising — its only early exit before registering (the load-guard <code>return</code>, app.js:668-672) resets <code>tvInitialized = false</code>, so there is no built Teacher View to redraw, and the next visit builds it and takes the listener. <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw when the callback also drew.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:116:  <div class="bdd">Given: Thanksgiving has Clay Creatures (Clay Creatures: intro + steps written; Glaze Day: nothing) and Paint Party (Canvas: Plan complete)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:120:Given: a camp day with "n/a", "—" and Open Studio blocks, and a title that runs Monday and Wednesday
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:124:Given: Mariah saves a plan on her own device after Christie's page loaded
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:128:Given: the refresh's read fails
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:132:Given: Christie presses Open plan on Glaze Day, types a closure, and closes
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:136:Given: Allie (prep) views the list
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:140:Given: project titles and teacher names containing quotes and &lt;img onerror&gt;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:144:Given: an event whose camps have no projects yet
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:148:Given: two camps in one event both have a project titled "Canvas", and a third title runs Monday and Wednesday in one camp
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:152:Given: a refresh is started, then a snapshot-triggered reload starts and finishes, then the first refresh resolves last
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:156:Given: a refresh fails (injected)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:160:Given: Christie leaves Curriculum Admin and comes back, and separately switches the header from a weekly semester to the SDOC year while on Curriculum Admin
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:164:Given: a plan with lastEditedAt "2026-10-05T14:22:31.123Z" and one with lastEditedAt "garbage"
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:168:Given: Christie opens a plan (a fresh single-plan read) but does not refresh
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:172:Given: Christie visits Teacher View once, returns to Curriculum Admin, and Mariah saves a plan elsewhere
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:176:Given: the app starts offline (the SDOC queries fail)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:180:Given: Christie visits Teacher View once, returns to Curriculum Admin on the SDOC year, and a ↻ Refresh fails (injected once)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:184:Given: Christie visits Teacher View once and returns to Curriculum Admin — once on the SDOC year, once on a weekly semester
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:227:   653	  if (tvInitialized) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:231:   657	  tvInitialized = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:243:   669	    tvInitialized = false;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:264:   690	    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:267:   693	        tvInitialized = false;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:281:  5016	  if (caInitialized) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:282:  5017	  caInitialized = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:825:2. `initCurriculumAdmin()` sets `caInitialized = true`, then awaits change-log, cut-project, and future-project loads before registering its listener (`:5015–5038`).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:828:5. Later Teacher View visits return early because `tvInitialized` remains true (`:653–655`), so it never retakes ownership.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:846:2. `initCurriculumAdmin()` sets `caInitialized = true`, then awaits change-log, cut-project, and future-project loads before registering its listener (`:5015–5038`).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-codex-full.md:849:5. Later Teacher View visits return early because `tvInitialized` remains true (`:653–655`), so it never retakes ownership.

exec
/bin/zsh -lc "sed -n '620,690p;730,736p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
  <p><strong>Data — read-only.</strong> No new fields, collections, writers or rules. Everything is computed from the slots <code>buildDayOffSlots()</code> already builds from <code>currentDayOffPlans</code> (plan text, <code>planComplete</code>, <code>lastEditedBy</code>/<code>lastEditedAt</code>).</p>
  <p><strong>Refresh — through the existing gated reload (round 1, both HIGH).</strong> No new loader: <code>refreshDayOffYear()</code> calls <code>reloadSummerForModeChange()</code> (firebase-data.js:1107) → <code>summerReloadHook()</code>, the listener's own generation-gated reload (Curriculum Admin sets that listener up, app.js:5037). So a refresh and a snapshot-triggered reload are the <em>same</em> mechanism: only the newest generation installs and redraws (an older one resolving last returns <code>'stale'</code>, firebase-data.js:1125), <code>previous</code> is captured by <code>snapshotCampSeasons()</code> for <code>mergeSummerReload()</code>, and 2B's heal runs. If no listener exists yet (<code>'no-listener'</code>), <code>initCurriculumAdmin()</code> hasn't run and its own first load covers it. <strong>The refresh redraws the list itself (round 2, both):</strong> there is one global listener, and whichever of <code>initTeacherView()</code> (app.js:676) / <code>initCurriculumAdmin()</code> (app.js:5038) ran last owns its callback — after a visit to Teacher View it is Teacher View's, whose SDOC branch renders only Teacher View — so <code>refreshDayOffYear()</code> awaits the outcome and calls <code>renderAdminGrid()</code> itself for any outcome but <code>'stale'</code> (including <code>'failed'</code>, so the message shows). A single in-flight refresh promise is shared: the two automatic call sites and the button never start a second one while one runs. <strong>Server-fresh:</strong> <code>loadDayOffCampData()</code>'s three queries switch to <code>get({ source: 'server' })</code> (like <code>dayOffServerDocs</code>, firebase-data.js:2114). <em>This changes every SDOC load, including startup's <code>loadLessonData()</code> (firebase-data.js:775-776) that teachers hit (round 2, Claude):</em> today an offline start can fall back to the cache and show an empty or old SDOC year with editing enabled — the "data disappeared" shape; with the change it trips the app-wide load guard and banner instead (the same as any failed load). Safer, but a visible behaviour change for anyone opening the app offline — <strong>Christie's yes is asked with the go.</strong> <strong>The stamp:</strong> <code>dayOffLastRefreshAt[yearKey]</code> is set wherever a full SDOC-year load <em>installs</em> successfully — startup's <code>loadLessonData()</code> and the gated <code>reloadSummer</code> success path — so the header is never blank after a good load, listener reloads (also full reads) advance it truthfully, and an editor's single-plan read, a stale reload and a failed one never do.</p>
  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
  <p><strong>Lifecycle (round 1, both).</strong> <code>initCurriculumAdmin()</code> runs once per page load (app.js:5015-5016), so the two automatic call sites are named: the tab-click handler's <code>curriculum-admin</code> branch (app.js:218-219) calls <code>refreshDayOffYear()</code> when Curriculum Admin is already initialised and the admin year is SDOC; and <code>setGlobalSemester()</code>'s <code>curriculum-admin</code> branch (app.js:132-138) does the same when switching <em>to</em> an SDOC year. Never from <code>renderAdminGrid()</code> (it runs after every tick); the button is disabled while a refresh is in flight.</p>
  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw.</p>
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

    <li><strong>Rules deployed before UI, or UI before rules:</strong> rules must land first — the app's load guard turns a missing rule into a loud, app-wide banner rather than a quiet empty list, but nobody wants that banner in front of teachers. Phase 1's order is therefore: rules commit + deploy → then the UI deploy.</li>
  </ul>
</div>

<h2 id="decisions-log">Decisions Log</h2>
<ul>
  <li><strong>Sep 29, 2026 (Phase 3 review round 4 → revision 5):</strong> Claude READY (2 LOW); Codex CHANGES NEEDED (1 MEDIUM). Both found the same thing: revision 4's claim that the reverse redraw was unneeded was <strong>wrong</strong> — a startup race (a Teacher View click while <code>initCurriculumAdmin()</code> awaits its loads) lets Curriculum Admin register last, so Teacher View stops redrawing (pre-existing; Claude rated it LOW for Phase 3, Codex MEDIUM). Verified at app.js:182-188 and 5015-5038. <strong>Folded:</strong> both inits now register one shared <code>onLessonDataReload()</code> that runs each <em>initialised</em> view's existing redraw — ownership no longer matters, no new behaviour; <code>dayOffRefreshFailed</code> is set inside the gated reload's failure path (Claude LOW). BDD +1 (the startup race). Next: round 5 (short), then Christie's go incl. <code>source: 'server'</code>. Build still waits for the storage migration.</li>

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html | sed -n '650,690p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
   650	
   651	Given: project titles and teacher names containing quotes and &lt;img onerror&gt;
   652	When: the list and roll-up render
   653	Then: nothing executes; Open plan still opens the right plan
   654	
   655	Given: an event whose camps have no projects yet
   656	When: the list renders
   657	Then: no roll-up is shown for it
   658	
   659	Given: two camps in one event both have a project titled "Canvas", and a third title runs Monday and Wednesday in one camp
   660	When: the roll-up counts
   661	Then: "Canvas" is two plans (two rows, denominator counts both); the Monday/Wednesday title is one
   662	
   663	Given: a refresh is started, then a snapshot-triggered reload starts and finishes, then the first refresh resolves last
   664	When: both settle
   665	Then: the newer reload's data stays (the older returns 'stale'); the stamp is the newer reload's time
   666	
   667	Given: a refresh fails (injected)
   668	When: it settles
   669	Then: the previous figures stay, "Couldn't refresh" shows, the stamp does not move, the load guard is false and Open plan opens read-only; after a successful refresh the guard clears and editing works
   670	
   671	Given: Christie leaves Curriculum Admin and comes back, and separately switches the header from a weekly semester to the SDOC year while on Curriculum Admin
   672	When: each happens
   673	Then: exactly one refresh each; ticking a material (renderAdminGrid) triggers none
   674	
   675	Given: a plan with lastEditedAt "2026-10-05T14:22:31.123Z" and one with lastEditedAt "garbage"
   676	When: the list renders
   677	Then: "Oct 5" for the first; no date for the second
   678	
   679	Given: Christie opens a plan (a fresh single-plan read) but does not refresh
   680	When: the list redraws
   681	Then: the "Last full refresh" time has not moved
   682	
   683	Given: Christie visits Teacher View once, returns to Curriculum Admin, and Mariah saves a plan elsewhere
   684	When: Christie presses ↻ Refresh
   685	Then: the row's status and "last edited by Mariah" update AND the stamp moves (the refresh redraws the list itself)
   686	
   687	Given: the app starts offline (the SDOC queries fail)
   688	When: it loads
   689	Then: the load guard trips with the banner — no empty or cached SDOC year is shown as editable
   690	

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html | sed -n '687,715p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
   687	Given: the app starts offline (the SDOC queries fail)
   688	When: it loads
   689	Then: the load guard trips with the banner — no empty or cached SDOC year is shown as editable
   690	
   691	Given: Christie visits Teacher View once, returns to Curriculum Admin on the SDOC year, and a ↻ Refresh fails (injected once)
   692	When: the automatic retry succeeds (no click)
   693	Then: "Couldn't refresh" is gone, the rows and the stamp are fresh, the load guard is true, and Open plan opens editable
   694	
   695	Given: Christie visits Teacher View once and returns to Curriculum Admin — once on the SDOC year, once on a weekly semester
   696	When: a weekly lesson save elsewhere changes curriculum/lessonData (a snapshot-triggered reload)
   697	Then: without pressing Refresh, the SDOC list redraws and its stamp moves; the weekly grid shows the other device's change
   698	
   699	Given: startup's Curriculum Admin initialisation is held open (its change-log load delayed), Christie clicks Teacher View, it builds, then Curriculum Admin finishes and registers
   700	When: a snapshot-triggered reload arrives while Teacher View is showing
   701	Then: Teacher View redraws with the new data, and the admin grid redraws too (spy: both render once)</div>
   702	  <p><strong>Tests (emulator, red first):</strong> new cases P1–P8 in <code>e2e/day-off-camps.spec.js</code> or a new <code>e2e/day-off-overview.spec.js</code> (planner + prep sessions; a direct write stands in for the teacher's other-device save); write spy on render and refresh; full suite before the dual implementation review.</p>
   703	  <p><strong>Not in 3:</strong> the "not started, camp soon" warning (offered, declined for now); filtering or sorting by status; emailing teachers.</p>
   704	</div>
   705	
   706	<div class="phase">
   707	  <h3>Phase 4 — Prep integration — superseded</h3>
   708	  <p>Superseded by 2A (materials built by the planner, ticked by prep) and 2A.1 (one checklist per event). Christie, Sep 24: no prep dashboard for SDOC.</p>
   709	</div>
   710	
   711	<h2 id="safety">Firebase safety checklist</h2>
   712	<div class="phase">
   713	  <table>
   714	    <tr><th>Gate</th><th>This plan</th></tr>
   715	    <tr><td>New collections → rules in the same commit; <code>npm test</code>; Fable 5.1 review of the rules diff; "approved to change firebase"; <code>--only firestore:rules</code></td><td><strong>Yes — three new collections</strong> (<code>dayOffCamps_events</code>, <code>dayOffCamps_camps</code>, <code>dayOffCamps_lessonData</code>), all in Phase 1's single rules change (1.1) so the whole plan needs one deploy and one Fable review. Modeled on <code>summerCamps_lessonData</code> and <code>/curriculum</code>. The <code>backup.js</code> listing (both arrays) is a separate, grep-verified pre-deploy step — <code>~/tinker-backups</code> is not a git repository — recorded in the rules commit message. No Storage rules change (photos use the existing <code>/curriculum/**</code> path).</td></tr>

codex
I found the revision-5 text and the three targeted BDDs. I’m now checking the shared callback’s proposed gates against the exact pinned callback bodies and initialization/reset paths, especially hidden-tab DOM/state effects.
exec
/bin/zsh -lc "git show 2ef2e62:js/app.js | nl -ba | sed -n '110,230p;620,715p;4990,5065p' && git show 2ef2e62:js/firebase-data.js | nl -ba | sed -n '1090,1210p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-SjdB6gQv' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Rq2Ffnrc' (errno=Operation not permitted)
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
   620	}
   621	
   622	// The dates of the camp on which this plan's title runs.
   623	function dayOffTitleDates(yearKey, slot) {
   624	  const camp = (currentDayOffCamps[yearKey] || []).find(c => c.id === slot?.campId);
   625	  return (camp?.dates || []).filter(d => Object.values(normaliseDayOffDayBlocks(camp.projects?.[d])).includes(slot.projectTitle));
   626	}
   627	
   628	let tvInitialized = false;
   629	let tvCurrentView = 'my-schedule';
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
   706	
   707	  const semKey = getTvSemKey();
   708	  const lessons = currentLessonData?.[semKey];
   709	
   710	  // Before the empty-map "Loading…" branch below — an SDOC year with no camps
   711	  // (or only empty blocks) is an empty map and would otherwise say "Loading"
   712	  // forever. Initialized like any other type (Phase 2B): the listener above is
   713	  // subscribed once, and the controls are bound once; renderTeacherView()
   714	  // builds the SDOC teacher list itself.
   715	  if (isDayOffYear(semKey)) {
  4990	    // local copy. Safe: this data is template-empty by construction (never had
  4991	    // real content), so deleting it loses nothing.
  4992	    if (lessonDataCommitted) {
  4993	      try {
  4994	        await deleteLessonData(key);
  4995	      } catch (cleanupErr) {
  4996	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  4997	      }
  4998	    }
  4999	    alert('Could not create the new semester. Please try again.');
  5000	    return;
  5001	  } finally {
  5002	    creatingSemester = false;
  5003	  }
  5004	
  5005	  closeNewSemesterModal();
  5006	  caCurrentSemester = key;
  5007	  renderSemesterSelector();
  5008	  renderAdminGrid();
  5009	  renderHelpQueue();
  5010	  renderCutBank();
  5011	  renderIdeaBank();
  5012	  renderChangeHistory();
  5013	}
  5014	
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
  5061	    renderSummerCA(lessons);
  5062	    return;
  5063	  }
  5064	  document.querySelector('.ca-grid-hint')?.style.removeProperty('display');
  5065	
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-GdS6WFYw' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-nC1UQPES' (errno=Operation not permitted)
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
  1206	    console.error('Error loading cut projects:', err);
  1207	    currentCutProjects = {};
  1208	  }
  1209	  return currentCutProjects;
  1210	}

exec
/bin/zsh -lc "git show 2ef2e62:js/app.js | rg -n 'let caInitialized|let caCurrentSemester|function getAdminSemKey|function renderHelpQueue|function renderProgressDashboard|function renderTeacherMappingTable' && git show 2ef2e62:js/app.js | nl -ba | sed -n '4960,4990p;5047,5160p;5750,5840p;12400,12520p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-oJjsOc7z' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-uniY0Xb1' (errno=Operation not permitted)
1048:function renderProgressDashboard() {
4133:let caInitialized = false;
4141:function getAdminSemKey() {
7026:function renderHelpQueue() {
11111:function renderTeacherMappingTable() {
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-1bDfNLJw' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-eoLKJ7Kr' (errno=Operation not permitted)
  4960	          };
  4961	        }
  4962	      }
  4963	
  4964	      if (Object.keys(emptyLessons).length > 0) {
  4965	        await saveLessonData(key, emptyLessons);
  4966	        if (!currentLessonData) currentLessonData = {};
  4967	        currentLessonData[key] = emptyLessons;
  4968	        lessonDataCommitted = true;
  4969	      }
  4970	    }
  4971	
  4972	    // Confirm on the SERVER that the key is free — the check at the top of this
  4973	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  4974	    // remaining read-to-update window is accepted: one admin, same class as the
  4975	    // existing residual on the Q&A path.
  4976	    const serverConfig = await readAppDataFromServer();
  4977	    if (serverConfig?.semesters?.[key]) {
  4978	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  4979	    }
  4980	    currentConfig.semesters[key] = newSem;
  4981	    await updateAppData({ [`semesters.${key}`]: newSem });
  4982	  } catch (err) {
  4983	    console.error('❌ Could not create new semester:', err);
  4984	    // Revert both local mutations so a retry isn't blocked by a phantom
  4985	    // "already exists" and the grid doesn't render a semester that never saved.
  4986	    delete currentConfig.semesters[key];
  4987	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  4988	    // R4-11: the empty lesson slots may already be persisted even though the
  4989	    // config never was — clean up the orphaned server-side write, not just the
  4990	    // local copy. Safe: this data is template-empty by construction (never had
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
  5061	    renderSummerCA(lessons);
  5062	    return;
  5063	  }
  5064	  document.querySelector('.ca-grid-hint')?.style.removeProperty('display');
  5065	
  5066	  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
  5067	  const numWeeks = semester?.numWeeks || 16;
  5068	  const breakWeeks = semester?.breakWeeks || [];
  5069	  const currentWeek = semKey === getActiveSemesterKey() ? getCurrentWeekNum() : null;
  5070	
  5071	  if (!lessons || Object.keys(lessons).length === 0) {
  5072	    wrapper.innerHTML = `<div class="tv-placeholder">${semKey === getActiveSemesterKey()
  5073	      ? 'No lesson data. Set up the class roster in Settings to create lesson slots.'
  5074	      : 'No lesson data for this semester yet. Import lessons or paste from Cut/Idea Bank.'}</div>`;
  5075	    return;
  5076	  }
  5077	
  5078	  // Build teacher+class combos
  5079	  const combos = {};
  5080	  for (const [key, lesson] of Object.entries(lessons)) {
  5081	    const comboKey = `${lesson.teacher}|||${lesson.className}`;
  5082	    if (!combos[comboKey]) {
  5083	      combos[comboKey] = { teacher: lesson.teacher, className: lesson.className, weeks: {} };
  5084	    }
  5085	    combos[comboKey].weeks[lesson.weekNum] = { key, ...lesson };
  5086	  }
  5087	
  5088	  const sortedCombos = Object.values(combos).sort((a, b) => {
  5089	    const da = getDayOrder(a.className);
  5090	    const db = getDayOrder(b.className);
  5091	    if (da !== db) return da - db;
  5092	    if (a.teacher !== b.teacher) return a.teacher.localeCompare(b.teacher);
  5093	    return a.className.localeCompare(b.className);
  5094	  });
  5095	
  5096	  // Build column list: teaching weeks + break markers
  5097	  const breakPositions = getBreakPositions(breakWeeks);
  5098	  const columns = [];
  5099	  for (let w = 1; w <= numWeeks; w++) {
  5100	    columns.push({ type: 'week', weekNum: w });
  5101	    // Insert break column after this teaching week if applicable
  5102	    for (const bp of breakPositions) {
  5103	      if (bp.afterTeachingWeek === w) {
  5104	        columns.push({ type: 'break', label: bp.label });
  5105	      }
  5106	    }
  5107	  }
  5108	
  5109	  // Render grid table
  5110	  let html = '<div class="ca-grid-scroll"><table class="ca-grid-table"><thead><tr>';
  5111	  html += '<th class="ca-grid-header-cell ca-grid-frozen">Teacher / Class</th>';
  5112	  for (const col of columns) {
  5113	    if (col.type === 'break') {
  5114	      html += `<th class="ca-grid-header-cell ca-break-col">Break</th>`;
  5115	    } else {
  5116	      const isCurr = col.weekNum === currentWeek;
  5117	      const weekDateLabel = getWeekStartLabel(semester, col.weekNum);
  5118	      html += `<th class="ca-grid-header-cell ${isCurr ? 'ca-current-col' : ''}">W${col.weekNum}${weekDateLabel ? `<br><span class="ca-header-date">${weekDateLabel}</span>` : ''}</th>`;
  5119	    }
  5120	  }
  5121	  html += '</tr></thead><tbody>';
  5122	
  5123	  for (const combo of sortedCombos) {
  5124	    html += '<tr>';
  5125	    html += `<td class="ca-grid-row-header ca-grid-frozen">
  5126	      <span class="ca-class-name">${escHtml(combo.className)}</span><br>
  5127	      <span class="ca-teacher-name">${escHtml(combo.teacher)}</span>
  5128	    </td>`;
  5129	
  5130	    for (const col of columns) {
  5131	      if (col.type === 'break') {
  5132	        html += `<td class="ca-grid-cell ca-break-col"></td>`;
  5133	        continue;
  5134	      }
  5135	
  5136	      const w = col.weekNum;
  5137	      const isCurr = w === currentWeek;
  5138	      const lesson = combo.weeks[w];
  5139	
  5140	      // Check if this class is closed on this week (holiday/closure date)
  5141	      const closureDate = getClosureForWeek(semester, w, combo.className);
  5142	      if (closureDate) {
  5143	        const closureLabel = formatClosureLabel(closureDate);
  5144	        html += `<td class="ca-grid-cell ca-closure-cell ${isCurr ? 'ca-current-col' : ''}" title="No class — ${closureLabel}">
  5145	          <span class="ca-closure-label">No Class</span>
  5146	        </td>`;
  5147	        continue;
  5148	      }
  5149	
  5150	      if (lesson && lesson.projectTitle) {
  5151	        const progress = calculateLessonProgress(lesson);
  5152	        const title = lesson.projectTitle || '';
  5153	        const truncTitle = title.length > 40 ? title.substring(0, 38) + '...' : title;
  5154	
  5155	        // Build rich tooltip content
  5156	        const qaThread = getQaThread(lesson);
  5157	        const matCount = (lesson.materialsList?.length || 0) || (lesson.materials ? 1 : 0);
  5158	        const hasIntro = !!lesson.introPitch;
  5159	        const hasSteps = !!lesson.processStep1;
  5160	        let tooltipHtml = `<div class="ca-grid-tooltip">
  5750	    // guard can't refuse a legitimate save from here: for summer every
  5751	    // editable non-content field is curriculum-owned and refused above, so
  5752	    // what remains is content, a clear, or a photo — each admitted.)
  5753	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5754	
  5755	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5756	    // Firestore has confirmed the new reference — and only when THIS save
  5757	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5758	    // edit leaves the old path untouched in both Firestore and Storage.
  5759	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5760	      try {
  5761	        await deleteLessonPhoto(oldPhotoPath);
  5762	      } catch (cleanupErr) {
  5763	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5764	      }
  5765	    }
  5766	  } catch (err) {
  5767	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5768	    // execution falls through to commit currentLessonData, close the modal,
  5769	    // and log a fake edit even though the save never actually succeeded. The
  5770	    // snapshot is kept so the still-open popup can retry against it.
  5771	    console.error('❌ Admin edit failed to save:', err);
  5772	    alert('This edit could not be saved. Please try again.');
  5773	    return;
  5774	  }
  5775	
  5776	  // Local display/cache only — never sent to Firestore, so keeping the full
  5777	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5778	  // listener's next delivery, same as the teacher editor).
  5779	  lessons[key] = {
  5780	    ...existing,
  5781	    teacher, className, weekNum,
  5782	    weekDate: firestorePayload.weekDate,
  5783	    classSize: firestorePayload.classSize,
  5784	    ...changedData,
  5785	    lastImported: firestorePayload.lastImported,
  5786	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5787	    lastEditedAt: firestorePayload.lastEditedAt
  5788	  };
  5789	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5790	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5791	  currentLessonData[semKey] = lessons;
  5792	
  5793	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5794	  renderAdminGrid();
  5795	  renderChangeHistory();
  5796	
  5797	  try {
  5798	    // Log the title that was actually kept — for summer a refused retitle
  5799	    // must not show up in Change History under the refused name.
  5800	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5801	    await appendChangeLogEntry(semKey, {
  5802	      action: existing.projectTitle ? 'edit' : 'create',
  5803	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5804	    });
  5805	    renderChangeHistory();
  5806	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5807	}
  5808	
  5809	function startSwap(sourceKey) {
  5810	  caActionMode = 'swap';
  5811	  caSourceKey = sourceKey;
  5812	  closeAdminModal();
  5813	  renderAdminGrid();
  5814	}
  5815	
  5816	function cancelGridAction() {
  5817	  caActionMode = null;
  5818	  caSourceKey = null;
  5819	  renderAdminGrid();
  5820	}
  5821	
  5822	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5823	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5824	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5825	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5826	
  5827	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5828	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5829	// opts.source === 'server' param, needed by Phase 8's
  5830	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5831	// preserves the exact prior (cache-permitting) default for any future caller.
  5832	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5833	  if (!curriculumDb) initCurriculumFirestore();
  5834	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5835	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
  5836	  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
  5837	}
  5838	
  5839	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5840	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
 12400	        inspoPhotos.forEach(p => {
 12401	          printHtml += `<img src="${esc(safeHttpUrl(p.url))}" alt="Inspiration photo" class="reference-inspo-thumb">`;
 12402	        });
 12403	        printHtml += `</div>`;
 12404	      }
 12405	
 12406	      // Demo photo on left if available
 12407	      if (safeHttpUrl(lesson.photoUrl)) {
 12408	        printHtml += `<img src="${esc(safeHttpUrl(lesson.photoUrl))}" alt="Demo photo" class="reference-photo">`;
 12409	      }
 12410	
 12411	      // Text content
 12412	      printHtml += `<div class="reference-text">`;
 12413	      if (lesson.projectDetails) {
 12414	        printHtml += `<p><strong>Project Details:</strong><br>${esc(lesson.projectDetails).replace(/\n/g, '<br>')}</p>`;
 12415	      }
 12416	      if (lesson.projectInspiration) {
 12417	        printHtml += `<p><strong>Inspiration Links:</strong> ${esc(lesson.projectInspiration)}</p>`;
 12418	      }
 12419	      if (lesson.projectAdminNotes) {
 12420	        printHtml += `<p><strong>Admin Notes:</strong><br>${esc(lesson.projectAdminNotes).replace(/\n/g, '<br>')}</p>`;
 12421	      }
 12422	      printHtml += `</div></div></div>`;
 12423	    }
 12424	
 12425	    // Lesson Plan Sections
 12426	    if (lesson.introPitch) {
 12427	      printHtml += `<div class="lesson-section"><h3>Intro / Pitch</h3><p>${esc(lesson.introPitch)}</p></div>`;
 12428	    }
 12429	
 12430	    if (lesson.processStep1 || lesson.processStep2 || lesson.processStep3 || lesson.processStep4) {
 12431	      printHtml += `<div class="lesson-section"><h3>Process Steps</h3><ol class="lesson-steps">`;
 12432	      if (lesson.processStep1) printHtml += `<li>${esc(lesson.processStep1)}</li>`;
 12433	      if (lesson.processStep2) printHtml += `<li>${esc(lesson.processStep2)}</li>`;
 12434	      if (lesson.processStep3) printHtml += `<li>${esc(lesson.processStep3)}</li>`;
 12435	      if (lesson.processStep4) printHtml += `<li>${esc(lesson.processStep4)}</li>`;
 12436	      printHtml += `</ol></div>`;
 12437	    }
 12438	
 12439	    if (lesson.closure) {
 12440	      printHtml += `<div class="lesson-section"><h3>Closure</h3><p>${esc(lesson.closure)}</p></div>`;
 12441	    }
 12442	
 12443	    if (lesson.dayOfMaterials) {
 12444	      printHtml += `<div class="lesson-section"><h3>Setup Notes</h3><p>${esc(lesson.dayOfMaterials)}</p></div>`;
 12445	    }
 12446	
 12447	    // Materials Table
 12448	    if (lesson.materialsList && lesson.materialsList.length > 0) {
 12449	      printHtml += `<div class="lesson-section"><h3>Materials to Prep</h3>
 12450	        <table class="materials-table">
 12451	          <thead><tr>
 12452	            <th>Material</th>
 12453	            <th>Qty/Camper</th>
 12454	            <th>Prep Category</th>
 12455	            <th>How to Prep</th>
 12456	          </tr></thead>
 12457	          <tbody>`;
 12458	      for (const m of lesson.materialsList) {
 12459	        printHtml += `<tr>
 12460	          <td>${esc(m.name || '')}</td>
 12461	          <td>${esc(m.qtyPerCamper || '')}</td>
 12462	          <td>${esc(m.prepCategory || '')}</td>
 12463	          <td>${esc(m.howToPrep || '')}</td>
 12464	        </tr>`;
 12465	      }
 12466	      printHtml += `</tbody></table></div>`;
 12467	    }
 12468	
 12469	    printHtml += `<div class="lesson-footer">Tinker Art Studio — Summer Camp — ${esc(campName)} — ${esc(lesson.teacher)}</div>`;
 12470	    printHtml += `</div>`;
 12471	  }
 12472	
 12473	  printHtml += '</body></html>';
 12474	
 12475	  // Open print window
 12476	  const printWindow = window.open('', '_blank');
 12477	  printWindow.document.write(printHtml);
 12478	  printWindow.document.close();
 12479	  printWindow.onload = () => {
 12480	    printWindow.print();
 12481	  };
 12482	}
 12483	
 12484	// ═════════════════════════════════════════════════════
 12485	// SCHOOL DAY OFF CAMPS — Curriculum Admin (Phase 1)
 12486	// Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html
 12487	// Admin-only by construction: an SDOC year is unpublished and cannot be
 12488	// published until Phase 2, and only manager+ can select an unpublished year.
 12489	// ═════════════════════════════════════════════════════
 12490	
 12491	const sdocEsc = (v) => escHtml(String(v ?? ''));
 12492	const sdocEscA = (v) => escAttr(String(v ?? ''));
 12493	
 12494	// "Mon Nov 23 – Wed Nov 25", "Mon Oct 12" — consecutive calendar days merge.
 12495	function dayOffDateRuns(dates) {
 12496	  const sorted = [...(dates || [])].sort();
 12497	  const runs = [];
 12498	  for (const d of sorted) {
 12499	    const last = runs[runs.length - 1];
 12500	    const next = last && new Date(`${last.end}T00:00:00Z`);
 12501	    if (next) next.setUTCDate(next.getUTCDate() + 1);
 12502	    if (last && next.toISOString().slice(0, 10) === d) last.end = d;
 12503	    else runs.push({ start: d, end: d });
 12504	  }
 12505	  return runs.map(r => r.start === r.end ? formatDayOffDate(r.start) : `${formatDayOffDate(r.start)} – ${formatDayOffDate(r.end)}`);
 12506	}
 12507	
 12508	// An event's camps in card order: AM, full day, PM, then by title.
 12509	function dayOffEventCamps(yearKey, eventId) {
 12510	  return (currentDayOffCamps[yearKey] || []).filter(c => c.eventId === eventId)
 12511	    .sort((a, b) => ['AM', 'FULL', 'PM'].indexOf(a.timeSlot) - ['AM', 'FULL', 'PM'].indexOf(b.timeSlot) || String(a.title).localeCompare(String(b.title)));
 12512	}
 12513	
 12514	function renderDayOffAdmin(yearKey) {
 12515	  const wrapper = document.getElementById('ca-grid-wrapper');
 12516	  if (!wrapper) return;
 12517	  const year = currentConfig?.semesters?.[yearKey] || {};
 12518	  const events = currentDayOffEvents[yearKey] || [];
 12519	  const camps = currentDayOffCamps[yearKey] || [];
 12520	  const writable = lessonDataLoadedSuccessfully !== false;

exec
/bin/zsh -lc "git show 2ef2e62:js/app.js | nl -ba | sed -n '1025,1095p;4115,4155p;7000,7095p;11090,11165p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-lIzNWI1U' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-qsMUi3dv' (errno=Operation not permitted)
  1025	          <span class="progress-key-item"><span class="progress-dot progress-dot-not-started"></span> Not Started</span>
  1026	          <span class="progress-key-item"><span class="progress-dot progress-dot-in-progress"></span> In Progress</span>
  1027	          <span class="progress-key-item"><span class="progress-dot progress-dot-ready"></span> Almost Done</span>
  1028	          <span class="progress-key-item"><span class="progress-dot progress-dot-complete"></span> Complete</span>
  1029	        </div>
  1030	        <table class="progress-grid">
  1031	          <thead><tr><th>Teacher</th>${campHeaders}<th>Progress</th></tr></thead>
  1032	          <tbody>${bodyRows}</tbody>
  1033	        </table>
  1034	      </div>
  1035	    </div>
  1036	  `;
  1037	
  1038	  document.getElementById('progress-dashboard-toggle').addEventListener('click', () => {
  1039	    const body = document.getElementById('progress-dashboard-body');
  1040	    const icon = document.querySelector('.progress-collapse-icon');
  1041	    const wasExpanded = body.style.display !== 'none';
  1042	    body.style.display = wasExpanded ? 'none' : 'block';
  1043	    if (icon) icon.innerHTML = wasExpanded ? '&#9654;' : '&#9660;';
  1044	    container.dataset.expanded = wasExpanded ? 'false' : 'true';
  1045	  });
  1046	}
  1047	
  1048	function renderProgressDashboard() {
  1049	  const container = document.getElementById('tv-progress-dashboard');
  1050	  if (!container) return;
  1051	
  1052	  const semKey = getTvSemKey();
  1053	  const lessons = currentLessonData?.[semKey];
  1054	  if (!lessons || Object.keys(lessons).length === 0 || isDayOffYear(semKey)) {
  1055	    container.innerHTML = '';
  1056	    return;
  1057	  }
  1058	
  1059	  const user = getAuthUser();
  1060	  const isAdminOrManager = user && ['admin', 'manager'].includes(user.role);
  1061	  const semester = getActiveSemester();
  1062	
  1063	  // Summer camp semesters: group by camp name instead of week number
  1064	  if (semester?.semesterType === 'summer-camp') {
  1065	    renderSummerProgressDashboard(container, lessons, isAdminOrManager);
  1066	    return;
  1067	  }
  1068	
  1069	  const numWeeks = semester?.numWeeks || 16;
  1070	
  1071	  // Build teacher → week → lessons map
  1072	  const teacherMap = {};
  1073	  for (const lesson of Object.values(lessons)) {
  1074	    if (!lesson.teacher) continue;
  1075	    if (!teacherMap[lesson.teacher]) teacherMap[lesson.teacher] = {};
  1076	    const w = lesson.weekNum || 0;
  1077	    if (!teacherMap[lesson.teacher][w]) teacherMap[lesson.teacher][w] = [];
  1078	    teacherMap[lesson.teacher][w].push(lesson);
  1079	  }
  1080	
  1081	  const allTeacherNames = Object.keys(teacherMap).sort();
  1082	  const currentTeacher = tvCurrentTeacher;
  1083	
  1084	  // Non-admin users only see their own row
  1085	  const teacherNames = isAdminOrManager ? allTeacherNames : allTeacherNames.filter(t => t === currentTeacher);
  1086	  if (teacherNames.length === 0) {
  1087	    container.innerHTML = '';
  1088	    return;
  1089	  }
  1090	
  1091	  // Build grid
  1092	  let weekHeaders = '';
  1093	  for (let w = 1; w <= numWeeks; w++) {
  1094	    weekHeaders += `<th>${w}</th>`;
  1095	  }
  4115	  };
  4116	}
  4117	
  4118	
  4119	function printSingleLesson(key) {
  4120	  const semKey = getAdminSemKey();
  4121	  const lesson = currentLessonData?.[semKey]?.[key];
  4122	  if (!lesson || !lesson.projectTitle) {
  4123	    alert('No lesson data to print.');
  4124	    return;
  4125	  }
  4126	  generatePrintOutput(lesson.weekNum, [lesson]);
  4127	}
  4128	
  4129	// ═════════════════════════════════════════════════════
  4130	// CURRICULUM ADMIN — Grid + Move/Swap/Cut
  4131	// ═════════════════════════════════════════════════════
  4132	
  4133	let caInitialized = false;
  4134	let caActionMode = null;   // null, 'move', 'swap'
  4135	let caSourceKey = null;     // key of source cell for move/swap
  4136	let hqFilterNeedsReply = false;
  4137	let summerCAView = 'schedule'; // 'schedule' or 'byweek'
  4138	let summerTeacherView = 'plans'; // 'plans' or 'calendar'
  4139	let summerByWeekNum = 1;
  4140	
  4141	function getAdminSemKey() {
  4142	  return getActiveSemesterKey();
  4143	}
  4144	
  4145	// ─── Summer CA Views ──────────────────────────────────────────────────────────
  4146	
  4147	// Titles that have no lesson plan — show as plain text, not clickable
  4148	function isSummerNoPlanTitle(title) {
  4149	  if (!title) return true;
  4150	  const t = title.trim().toLowerCase();
  4151	  return t === 'open studio' || t === 'wrap up + art show' || t === '—' || t === '';
  4152	}
  4153	
  4154	function getSummerTeacherColor(teacher) {
  4155	  const colors = {
  7000	        projectTitle: proj.title,
  7001	        teacher,
  7002	        className,
  7003	        toWeek: weekNum,
  7004	        fromIdeaBank: true
  7005	      }
  7006	    });
  7007	  } catch (logErr) {
  7008	    console.error('⚠️ Idea pasted, but Change History logging failed:', logErr);
  7009	  }
  7010	
  7011	  closeAdminModal();
  7012	  renderAdminGrid();
  7013	  renderIdeaBank();
  7014	  renderChangeHistory();
  7015	}
  7016	
  7017	// ─── Help Queue ──────────────────────────────────────
  7018	
  7019	function getLatestMessageTimestamp(lesson) {
  7020	  const thread = getQaThread(lesson);
  7021	  if (thread.length === 0) return 0;
  7022	  const last = thread[thread.length - 1];
  7023	  return last.timestamp ? new Date(last.timestamp).getTime() : 0;
  7024	}
  7025	
  7026	function renderHelpQueue() {
  7027	  const semKey = getAdminSemKey();
  7028	  const lessons = currentLessonData?.[semKey];
  7029	  const container = document.getElementById('ca-help-content');
  7030	  const badge = document.getElementById('ca-help-badge');
  7031	  if (!container) return;
  7032	
  7033	  if (!lessons) {
  7034	    container.innerHTML = '<p class="ca-empty-hint">No lesson data loaded.</p>';
  7035	    badge.style.display = 'none';
  7036	    return;
  7037	  }
  7038	
  7039	  // Show lessons with active Q&A threads (has messages from teachers)
  7040	  const helpItems = Object.entries(lessons)
  7041	    .filter(([, l]) => {
  7042	      const qa = l.qaThread || [];
  7043	      return qa.length > 0 && qa.some(msg => msg.from === 'teacher');
  7044	    })
  7045	    .sort((a, b) => getLatestMessageTimestamp(b[1]) - getLatestMessageTimestamp(a[1]));
  7046	
  7047	  // Count items needing admin response (last message is from teacher)
  7048	  const needsResponse = helpItems.filter(([, l]) => hasUnansweredQuestion(l));
  7049	
  7050	  if (helpItems.length === 0) {
  7051	    container.innerHTML = '<p class="ca-empty-hint">No teachers need help right now.</p>';
  7052	    badge.style.display = 'none';
  7053	    return;
  7054	  }
  7055	
  7056	  badge.textContent = needsResponse.length || helpItems.length;
  7057	  badge.style.display = 'inline-block';
  7058	
  7059	  let html = '';
  7060	  if (needsResponse.length > 0) {
  7061	    html += `<div class="ca-help-summary" style="display:flex;align-items:center;gap:0.75rem;">
  7062	      <span>${needsResponse.length} awaiting your response</span>
  7063	      <div style="display:flex;border:2px solid var(--purple);border-radius:999px;overflow:hidden;font-size:0.8rem;font-weight:600;">
  7064	        <button onclick="if(hqFilterNeedsReply){toggleHqFilter()}" style="padding:0.25rem 0.75rem;border:none;background:${!hqFilterNeedsReply ? 'var(--purple)' : 'transparent'};color:${!hqFilterNeedsReply ? 'white' : 'var(--purple)'};cursor:pointer;">All</button>
  7065	        <button onclick="if(!hqFilterNeedsReply){toggleHqFilter()}" style="padding:0.25rem 0.75rem;border:none;background:${hqFilterNeedsReply ? 'var(--purple)' : 'transparent'};color:${hqFilterNeedsReply ? 'white' : 'var(--purple)'};cursor:pointer;">Needs Reply</button>
  7066	      </div>
  7067	    </div>`;
  7068	  }
  7069	
  7070	  const displayItems = hqFilterNeedsReply ? needsResponse : helpItems;
  7071	  for (const [key, lesson] of displayItems) {
  7072	    const thread = getQaThread(lesson);
  7073	    const unanswered = hasUnansweredQuestion(lesson);
  7074	    const lastMsg = thread[thread.length - 1];
  7075	    const timeAgo = lastMsg?.timestamp ? getTimeAgo(lastMsg.timestamp) : '';
  7076	
  7077	    html += `<div class="ca-help-item ${unanswered ? 'ca-help-unanswered' : 'ca-help-answered'}">
  7078	      <div class="ca-help-item-header">
  7079	        ${unanswered ? '<span class="ca-help-new-badge">Needs Reply</span>' : '<span class="ca-help-replied-badge">Replied</span>'}
  7080	        <strong>${escHtml(lesson.teacher)}</strong> &mdash; ${escHtml(lesson.className)} &middot; Week ${lesson.weekNum}
  7081	        ${timeAgo ? `<span class="ca-help-time">${timeAgo}</span>` : ''}
  7082	      </div>
  7083	      <div class="ca-help-item-project">${escHtml(lesson.projectTitle)}</div>
  7084	      ${thread.length > 0 ? renderQaThread(thread) : ''}
  7085	      <div class="ca-help-respond">
  7086	        <input type="text" class="ca-help-input" placeholder="Type a response..." id="ca-help-input-${escAttr(key)}">
  7087	        <button class="btn-primary ca-help-send-btn" onclick="sendHelpResponse('${escAttr(key)}')">Respond</button>
  7088	      </div>
  7089	    </div>`;
  7090	  }
  7091	
  7092	  container.innerHTML = html;
  7093	}
  7094	
  7095	function toggleHqFilter() {
 11090	    <td><select data-roster-field="teacher">
 11091	      ${teachers.map(t => `<option value="${t}">${t || '(none)'}</option>`).join('')}
 11092	    </select></td>
 11093	    <td><select data-roster-field="day">
 11094	      ${['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'].map(d =>
 11095	        `<option value="${d}">${d}</option>`
 11096	      ).join('')}
 11097	    </select></td>
 11098	    <td><input type="text" value="" data-roster-field="time" placeholder="e.g. 3:30pm"></td>
 11099	    <td><input type="number" value="0" data-roster-field="enrollment" min="0" placeholder="0"></td>
 11100	    <td><input type="number" value="1" data-roster-field="sessions" min="1" placeholder="1"></td>
 11101	    <td><input type="number" value="0" data-roster-field="waitlist" min="0" placeholder="0"></td>
 11102	  `;
 11103	
 11104	  tbody.appendChild(newRow);
 11105	  // Focus the class name input
 11106	  newRow.querySelector('input[data-roster-field="className"]')?.focus();
 11107	}
 11108	
 11109	// ─── Teacher Name Mapping ────────────────────────
 11110	
 11111	function renderTeacherMappingTable() {
 11112	  const tbody = document.getElementById('teacher-mapping-body');
 11113	  if (!tbody) return;
 11114	
 11115	  const semKey = getActiveSemesterKey();
 11116	  const lessons = currentLessonData?.[semKey] || {};
 11117	  const mappings = currentConfig?.teacherMappings || {};
 11118	
 11119	  // Get known teacher names from lesson data
 11120	  const teacherNames = new Set();
 11121	  for (const lesson of Object.values(lessons)) {
 11122	    if (lesson.teacher) teacherNames.add(lesson.teacher);
 11123	  }
 11124	
 11125	  if (teacherNames.size === 0) {
 11126	    tbody.innerHTML = '<tr><td colspan="3" style="text-align:center; color: var(--text-light); padding: 16px;">Set up a class roster with teacher names first.</td></tr>';
 11127	    return;
 11128	  }
 11129	
 11130	  // Build UID → name reverse lookup
 11131	  const uidToTeacher = {};
 11132	  for (const [uid, name] of Object.entries(mappings)) {
 11133	    uidToTeacher[uid] = name;
 11134	  }
 11135	
 11136	  const sorted = [...teacherNames].sort();
 11137	  tbody.innerHTML = sorted.map(name => {
 11138	    // Find the UID mapped to this teacher, if any
 11139	    const mappedUid = Object.entries(mappings).find(([, n]) => n === name)?.[0] || '';
 11140	    const mappedLabel = mappedUid ? getUserLabelByUid(mappedUid) : '';
 11141	    return `<tr data-teacher-name="${escAttr(name)}">
 11142	      <td class="roster-class-name">${escHtml(name)}</td>
 11143	      <td>
 11144	        <select class="teacher-mapping-select" data-teacher="${escAttr(name)}">
 11145	          <option value="">— Not mapped —</option>
 11146	        </select>
 11147	        ${mappedLabel ? `<span class="mapping-current">${escHtml(mappedLabel)}</span>` : ''}
 11148	      </td>
 11149	      <td>${mappedUid ? `<button class="btn-text mapping-clear-btn" onclick="clearTeacherMapping('${escAttr(name)}')" title="Clear mapping">&times;</button>` : ''}</td>
 11150	    </tr>`;
 11151	  }).join('');
 11152	
 11153	  // Populate user dropdowns from Firestore users collection
 11154	  loadTeamUsersForMapping();
 11155	}
 11156	
 11157	async function loadTeamUsersForMapping() {
 11158	  try {
 11159	    const db = initFirebaseApp();
 11160	    const snapshot = await db.collection('users').get();
 11161	    // Offer only people who can use the Classbook now: not archived in Tinker HQ (active === false),
 11162	    // and with Classbook access (or a manager/admin role). An account that is already mapped stays in
 11163	    // its own dropdown, labelled, so saving Settings never drops a mapping silently (Christie, Sep 28 2026).
 11164	    const users = [];
 11165	    snapshot.forEach(doc => {

exec
/bin/zsh -lc "rg -n -C 2 'dayOffRefreshFailed' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
620-  <p><strong>Data — read-only.</strong> No new fields, collections, writers or rules. Everything is computed from the slots <code>buildDayOffSlots()</code> already builds from <code>currentDayOffPlans</code> (plan text, <code>planComplete</code>, <code>lastEditedBy</code>/<code>lastEditedAt</code>).</p>
621-  <p><strong>Refresh — through the existing gated reload (round 1, both HIGH).</strong> No new loader: <code>refreshDayOffYear()</code> calls <code>reloadSummerForModeChange()</code> (firebase-data.js:1107) → <code>summerReloadHook()</code>, the listener's own generation-gated reload (Curriculum Admin sets that listener up, app.js:5037). So a refresh and a snapshot-triggered reload are the <em>same</em> mechanism: only the newest generation installs and redraws (an older one resolving last returns <code>'stale'</code>, firebase-data.js:1125), <code>previous</code> is captured by <code>snapshotCampSeasons()</code> for <code>mergeSummerReload()</code>, and 2B's heal runs. If no listener exists yet (<code>'no-listener'</code>), <code>initCurriculumAdmin()</code> hasn't run and its own first load covers it. <strong>The refresh redraws the list itself (round 2, both):</strong> there is one global listener, and whichever of <code>initTeacherView()</code> (app.js:676) / <code>initCurriculumAdmin()</code> (app.js:5038) ran last owns its callback — after a visit to Teacher View it is Teacher View's, whose SDOC branch renders only Teacher View — so <code>refreshDayOffYear()</code> awaits the outcome and calls <code>renderAdminGrid()</code> itself for any outcome but <code>'stale'</code> (including <code>'failed'</code>, so the message shows). A single in-flight refresh promise is shared: the two automatic call sites and the button never start a second one while one runs. <strong>Server-fresh:</strong> <code>loadDayOffCampData()</code>'s three queries switch to <code>get({ source: 'server' })</code> (like <code>dayOffServerDocs</code>, firebase-data.js:2114). <em>This changes every SDOC load, including startup's <code>loadLessonData()</code> (firebase-data.js:775-776) that teachers hit (round 2, Claude):</em> today an offline start can fall back to the cache and show an empty or old SDOC year with editing enabled — the "data disappeared" shape; with the change it trips the app-wide load guard and banner instead (the same as any failed load). Safer, but a visible behaviour change for anyone opening the app offline — <strong>Christie's yes is asked with the go.</strong> <strong>The stamp:</strong> <code>dayOffLastRefreshAt[yearKey]</code> is set wherever a full SDOC-year load <em>installs</em> successfully — startup's <code>loadLessonData()</code> and the gated <code>reloadSummer</code> success path — so the header is never blank after a good load, listener reloads (also full reads) advance it truthfully, and an editor's single-plan read, a stale reload and a failed one never do.</p>
622:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
623-  <p><strong>Lifecycle (round 1, both).</strong> <code>initCurriculumAdmin()</code> runs once per page load (app.js:5015-5016), so the two automatic call sites are named: the tab-click handler's <code>curriculum-admin</code> branch (app.js:218-219) calls <code>refreshDayOffYear()</code> when Curriculum Admin is already initialised and the admin year is SDOC; and <code>setGlobalSemester()</code>'s <code>curriculum-admin</code> branch (app.js:132-138) does the same when switching <em>to</em> an SDOC year. Never from <code>renderAdminGrid()</code> (it runs after every tick); the button is disabled while a refresh is in flight.</p>
624-  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw.</p>
--
734-<h2 id="decisions-log">Decisions Log</h2>
735-<ul>
736:  <li><strong>Sep 29, 2026 (Phase 3 review round 4 → revision 5):</strong> Claude READY (2 LOW); Codex CHANGES NEEDED (1 MEDIUM). Both found the same thing: revision 4's claim that the reverse redraw was unneeded was <strong>wrong</strong> — a startup race (a Teacher View click while <code>initCurriculumAdmin()</code> awaits its loads) lets Curriculum Admin register last, so Teacher View stops redrawing (pre-existing; Claude rated it LOW for Phase 3, Codex MEDIUM). Verified at app.js:182-188 and 5015-5038. <strong>Folded:</strong> both inits now register one shared <code>onLessonDataReload()</code> that runs each <em>initialised</em> view's existing redraw — ownership no longer matters, no new behaviour; <code>dayOffRefreshFailed</code> is set inside the gated reload's failure path (Claude LOW). BDD +1 (the startup race). Next: round 5 (short), then Christie's go incl. <code>source: 'server'</code>. Build still waits for the storage migration.</li>
737:  <li><strong>Sep 29, 2026 (Phase 3 round-3 MEDIUM folded — revision 4; its "reverse not needed" claim was corrected in revision 5):</strong> Teacher View's listener callback now also calls <code>renderAdminGrid()</code> + <code>renderHelpQueue()</code> when Curriculum Admin is the active tab (before its SDOC early return), so the automatic retries and snapshot reloads redraw Curriculum Admin after a Teacher View visit — which also closes a pre-existing gap for the weekly grid. The "Couldn't refresh" message is derived at render time (<code>dayOffRefreshFailed[yearKey]</code>, cleared where the stamp is set). The "vice versa" from round 3 was dropped after checking the code: Curriculum Admin's callback can own the listener only while Teacher View has never finished initialising (its guard exit resets <code>tvInitialized</code>), so there is nothing to redraw. BDD +2. <strong>Christie, Sep 29: finish the design now, but build only after <code>classbook-per-semester-lesson-storage</code> lands</strong> (it reworks the same listener) — re-verify line references then. Next: round 4 (short, targeted), then Christie's go incl. her yes to <code>source: 'server'</code>.</li>
738-  <li><strong>Sep 29, 2026 (Phase 3 review round 3 — PAUSED here, Christie moving locations):</strong> both confirmed every round-2 fix; both found ONE remaining MEDIUM, not yet folded: two other install paths also redraw through the single global listener's callback, which after a Teacher View visit belongs to Teacher View — (1) the failed reload's automatic retries (firebase-data.js:1151-1157) and (2) a snapshot-triggered reload (firebase-data.js:1190-1194) — so on Curriculum Admin the rows, stamp, "Couldn't refresh" message and editability can go stale after recovery. <strong>Agreed fix to fold next:</strong> make every listener callback redraw whichever tab is active (Teacher View's callback also calls <code>renderAdminGrid()</code> when Curriculum Admin is active, and vice versa), and add a BDD: visit Teacher View → back to Curriculum Admin → refresh fails → automatic retry succeeds → message gone, rows + stamp fresh, editing re-enabled. Then a short round 4, then Christie's go (which must also include her yes to <code>source: 'server'</code> for all SDOC loads — see the Refresh paragraph). No code written for Phase 3 yet; Classbook <code>main</code> is clean at <code>2ef2e62</code>.</li>
739-  <li><strong>Sep 29, 2026 (Phase 3 review round 2 — both confirmed every round-1 fix; folded, revision 3):</strong> HIGH (both): the single global listener's callback belongs to whichever view initialised last, so after a Teacher View visit a refresh would install fresh data without redrawing the admin list while the stamp advanced → <code>refreshDayOffYear()</code> redraws the list itself on any non-stale outcome; one shared in-flight refresh. MEDIUM (Claude): <code>source: 'server'</code> also changes startup for teachers (offline → guard + banner instead of a cached/empty year) — stated, Christie's yes asked with the go; the editor's guard is scoped to SDOC (summer untouched). LOW: the stamp is set on startup's load too; <code>isIsoDate</code> before formatting. BDD +2. Next: round 3 (targeted).</li>

codex
**Verdict: READY**

No new HIGH/MEDIUM findings.

- Round-4 startup race is fixed: either registration now installs the same callback, which redraws both initialized views regardless of registration order.
- The redraw behavior matches today’s callbacks. Teacher View already performs its callback work while hidden, except its existing SDOC active-tab guard; Curriculum Admin already redraws unconditionally. Neither hidden-view path has harmful state or DOM effects.
- `tvInitialized` is the correct gate: the load-failure exit resets it before listener registration, while its later callback reset immediately re-enters initialization.
- `caInitialized` becomes true before its awaits, but early `renderAdminGrid()`/`renderHelpQueue()` calls are safe: their required DOM and lesson/config data already exist, and neither depends on the awaited change-log, cut-project, or future-project loads. The later normal initialization redraw remains harmless.
- `dayOffRefreshFailed` is now correctly placed behind `isCurrent()` in the gated failure path, covering button, retry, and snapshot failures without allowing stale generations to change the message.
- The final three BDDs cover recovery, hidden-view redraws for both SDOC and weekly data, and the precise startup race.
tokens used
47,170
**Verdict: READY**

No new HIGH/MEDIUM findings.

- Round-4 startup race is fixed: either registration now installs the same callback, which redraws both initialized views regardless of registration order.
- The redraw behavior matches today’s callbacks. Teacher View already performs its callback work while hidden, except its existing SDOC active-tab guard; Curriculum Admin already redraws unconditionally. Neither hidden-view path has harmful state or DOM effects.
- `tvInitialized` is the correct gate: the load-failure exit resets it before listener registration, while its later callback reset immediately re-enters initialization.
- `caInitialized` becomes true before its awaits, but early `renderAdminGrid()`/`renderHelpQueue()` calls are safe: their required DOM and lesson/config data already exist, and neither depends on the awaited change-log, cut-project, or future-project loads. The later normal initialization redraw remains harmless.
- `dayOffRefreshFailed` is now correctly placed behind `isCurrent()` in the gated failure path, covering button, retry, and snapshot failures without allowing stale generations to change the message.
- The final three BDDs cover recovery, hidden-view redraws for both SDOC and weekly data, and the precise startup race.
