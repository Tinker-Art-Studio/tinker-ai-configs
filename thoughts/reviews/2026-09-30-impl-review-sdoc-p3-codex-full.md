OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f55f-b2e8-7031-82f5-7df576ef1bf8
--------
user
# Implementation review — Classbook SDOC Phase 3 (commit c7400df on branch claude/sdoc-phase3-overview, base 132fef2)
Repo READ-ONLY: /Users/christiehubley/tinker-spring-curriculum. Do NOT edit, run tests that write, or deploy.
Diff: ~/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3.diff (or `git -C <repo> diff 132fef2 c7400df`).
Design: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3" (revision 5 + the
"Re-verification against 132fef2" paragraph). The design was reviewed over 6 rounds; review the CODE against it.

What changed:
- js/app.js: onLessonDataReload() + teacherViewOnReload() (both views register the one callback);
  refreshDayOffYear() (shared in-flight promise → reloadSummerForModeChange(); redraw on non-stale outcome);
  header refresh controls, Plans column, roll-up, openDayOffPlanFromAdmin(); lifecycle calls in the tab handler and
  setGlobalSemester(); SDOC editor read-only while lessonDataLoadedSuccessfully === false.
- js/firebase-data.js: dayOffLastRefreshAt / dayOffRefreshFailed (+ markDayOffYearInstalled) set only where a full
  load installs or fails; loadDayOffCampData's three queries use {source:'server'}; readDayOffPlanForEditor() reads
  inside a read-only runTransaction.
- css, and e2e/day-off-overview.spec.js (P1–P16).

Look hard at:
1. Any behaviour change for weekly / summer semesters or Teacher View from the shared callback (it now redraws every
   INITIALISED view on every reload, incl. Spring's own-doc listener callbacks). Anything that runs while hidden and
   shouldn't, or state a hidden redraw clobbers (e.g. an open admin modal, an expanded summer camp, the grid action state)?
2. refreshDayOffYear(): the in-flight promise, its finally/done handling, 'no-listener', the second redraw, and the
   lifecycle calls (could they fire on startup, loop, or race the first init?). setGlobalSemester's previousKey.
3. The stamp/failure flags: set in every success/failure path and only there? A camp-season failure marks SDOC years
   failed — right? Startup marking when a LATER year fails?
4. The transactional open read: correct in the compat SDK, offline behaviour, any test that counted runTransaction calls.
5. Escaping/XSS in the new HTML (sdocEsc/sdocEscA), and the PR #3 onclick ratchet.
6. Do the tests pin the behaviour (would they fail on a broken version)? Missing cases?
Rank HIGH / MEDIUM / LOW with file:line. End with: ready to merge — yes/no. ≤500 words.

codex
I’ll inspect the specified commit diff and the Phase 3 design, then trace the affected lifecycle and test paths without running any tests or modifying files.
exec
/bin/zsh -lc "git status --short --branch && git diff --stat 132fef2 c7400df && git diff --check 132fef2 c7400df && rg -n 'id=\"phase-3\"|Re-verification against 132fef2' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-3CUiYVwc' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-iKGJnIN6' (errno=Operation not permitted)
## claude/sdoc-phase3-overview...origin/claude/sdoc-phase3-overview
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-xX7QajSs' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Wd63Pcdm' (errno=Operation not permitted)
 css/styles.css               |   9 +
 e2e/day-off-overview.spec.js | 406 +++++++++++++++++++++++++++++++++++++++++++
 js/app.js                    | 192 ++++++++++++++++----
 js/firebase-data.js          |  30 +++-
 4 files changed, 595 insertions(+), 42 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-OleswjGf' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-65v3H1Io' (errno=Operation not permitted)
608:<div class="phase" id="phase-3">

exec
/bin/zsh -lc "sed -n '608,920p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html && git diff --unified=80 132fef2 c7400df -- js/firebase-data.js" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
<div class="phase" id="phase-3">
  <h3>Phase 3 — Planner's plan overview (status per project + per-event roll-up) — DESIGN, revision 5 (Sep 29, 2026, after review rounds 1–4; line numbers @ <code>2ef2e62</code>) — <span class="status-tag ready">execution-ready: true (design) — BUILD GATED on <code>classbook-per-semester-lesson-storage</code> landing</span></h3>
  <p><strong>Build sequencing (Christie, Sep 29):</strong> the design is finished now; the <em>build</em> waits until <code>classbook-per-semester-lesson-storage</code> has landed (another session, in progress) — it reworks the <code>curriculum/lessonData</code> listener and loads this design hooks into. Before building: re-verify every line reference and the listener/reload shape against that code, and run a short targeted review if it moved materially.</p>
  <p><strong>Re-verification against <code>132fef2</code> (Sep 30, after the storage move landed — PR #5).</strong> The design's line numbers above are pinned to <code>2ef2e62</code>; at build time use this map (<code>132fef2</code>): Teacher View's listener callback app.js:686-711 (SDOC branch 692-696; its load-guard exit 678-681); Curriculum Admin's callback 5114-5120; <code>initCurriculumAdmin()</code> 5091 (<code>caInitialized</code> 5092-5093), awaited at startup app.js:190, tab branch 220-221; <code>calculateLessonProgress()</code> 924, <code>getProgressLabel()</code> 943, <code>canEditDayOffPlan()</code> 622; <code>openPlanEditor()</code> 11639 (<code>canEdit</code> 11648), <code>finishClose</code> 12313; <code>renderDayOffAdmin()</code> 12647; firebase-data.js: <code>reloadSummerForModeChange()</code> 1310, unsubscribe 1319, gated failure path: catch 1351-1364 (<code>isCurrent()</code> 1353, retries 1356-1362, <code>return 'failed'</code> 1363), <code>summerReloadHook</code> 1369, the <code>lessonData</code> snapshot reload 1376-1416, <code>isIsoDate()</code> 2264, <code>dayOffCampTitles()</code> 2322, <code>dayOffServerDocs()</code> 2377, <code>loadDayOffCampData()</code> 2384. None of these functions' bodies changed except <code>setGlobalSemester()</code> and startup (one <code>updateOwnDocPausedNotice()</code> line each) and <code>renderDayOffAdmin()</code>, whose camp/event buttons now use <code>escForOnclick()</code> (PR #3) — harmless for Phase 3 (round 6, Claude LOW). <strong>What did change, and how Phase 3 meets it:</strong> (1) <em>Spring's own-document listeners</em> (firebase-data.js:1420-1457) and <code>recheckOwnDocAfterLegacyLoss()</code> now also call the listener's <code>callback</code> — without a summer/SDOC reload. With the shared <code>onLessonDataReload()</code> they simply redraw each initialised view, as they do today for the owning view; they install no SDOC data, so the stamp and <code>dayOffRefreshFailed</code> don't move (both change only in the gated reload). Re-registering tears the own-doc listeners down and re-adds them (1321) — unchanged by Phase 3, since it keeps the two registration sites. (2) <em>A <code>get({source:'server'})</code> can return stale data after a Listen-stream transport error</em> (found in the storage move's Phase C, Sep 30). Phase 3's SDOC queries can't use a transaction (queries aren't transactional in this SDK), so the overview accepts it as a <strong>known limitation</strong>: in that rare case the list can show older statuses under a fresh "Last full refresh" time until the next refresh or reload corrects it. For the overview itself it is display-only (Phase 3 writes nothing). <strong>Correction (round 6, both MEDIUM): the 2B editor is NOT covered.</strong> Its open read, <code>readDayOffPlanForEditor()</code> (firebase-data.js:2891-2897), is the same <code>get({source:'server'})</code> and marks the copy verified (<code>dayOffInstallVerified()</code>); the save transaction (2940-2965) re-reads the plan but never compares it with the opened version and writes with <code>merge: true</code>, and <code>verifyDayOffPlanWrite()</code> only confirms its own <code>lastEditId</code>. So a stale open lets a teacher save over a co-teacher's newer text with a plain "Saved" — the "edited since" notice can't fire. This is a <em>live 2B gap</em>, not new in Phase 3, but Phase 3's Open plan is one more way into that editor. <strong>Fix — in the Phase 3 build (Christie, Sep 30: "#1"):</strong> open the plan with a read-only <code>runTransaction(tx =&gt; tx.get(planRef))</code> — single-document transactional reads are always fresh, the storage move's own lesson — with no change to the save path. And <code>source: 'server'</code> still delivers what Christie approved it for (a failed read trips the guard instead of showing a cached or empty year as editable). (3) <code>escForOnclick()</code> now exists (PR #3, app.js:8283); Phase 3 still puts the plan key in a <code>data-</code> attribute and binds the handler in code, so no inline handler value is added.</p>
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
  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
  <p><strong>Lifecycle (round 1, both).</strong> <code>initCurriculumAdmin()</code> runs once per page load (app.js:5015-5016), so the two automatic call sites are named: the tab-click handler's <code>curriculum-admin</code> branch (app.js:218-219) calls <code>refreshDayOffYear()</code> when Curriculum Admin is already initialised and the admin year is SDOC; and <code>setGlobalSemester()</code>'s <code>curriculum-admin</code> branch (app.js:132-138) does the same when switching <em>to</em> an SDOC year. Never from <code>renderAdminGrid()</code> (it runs after every tick); the button is disabled while a refresh is in flight.</p>
  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw. <em>Build notes (round 5, Claude LOW):</em> wrap each branch of <code>onLessonDataReload()</code> in its own try/catch (log and continue) so a throw in Teacher View's redraw can't skip the admin redraw; <code>tvInitialized</code> is also true during Teacher View's own <code>await loadLessonData()</code> (app.js:657→661) — harmless, it converges through the existing empty-picker reset (app.js:690-696).</p>
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
Then: without pressing Refresh, the SDOC list redraws and its stamp moves; the weekly grid shows the other device's change

Given: startup's Curriculum Admin initialisation is held open (its change-log load delayed), Christie clicks Teacher View, it builds, then Curriculum Admin finishes and registers
When: a snapshot-triggered reload arrives while Teacher View is showing
Then: Teacher View redraws with the new data, and the admin grid redraws too (spy: both render once)</div>
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
    <tr><td>New collections → rules in the same commit; <code>npm test</code>; Fable 5.1 review of the rules diff; "approved to change firebase"; <code>--only firestore:rules</code></td><td><strong>Yes — three new collections</strong> (<code>dayOffCamps_events</code>, <code>dayOffCamps_camps</code>, <code>dayOffCamps_lessonData</code>), all in Phase 1's single rules change (1.1) so the whole plan needs one deploy and one Fable review. Modeled on <code>summerCamps_lessonData</code> and <code>/curriculum</code>. The <code>backup.js</code> listing (both arrays) is a separate, grep-verified pre-deploy step — <code>~/tinker-backups</code> is not a git repository — recorded in the rules commit message. No Storage rules change (photos use the existing <code>/curriculum/**</code> path).</td></tr>
    <tr><td>Partial updates via <code>updateDoc</code>/per-field paths</td><td>Events and camps: one document each, created with a single <code>set()</code> of the stripped payload and updated with <code>update()</code> of only the changed fields (dirty-diff); plans (Phase 2): <code>saveSingleLesson()</code>'s existing targeted merge write. The year itself (create, Settings) goes through the seasons plan's <code>updateAppData()</code> field-path writer (1.2 there — <code>saveConfig()</code> is deleted by that plan).</td></tr>
    <tr><td>Snapshot before bulk ops</td><td>No bulk ops; no existing data migrated. The only multi-doc write is a camp delete's batch (camp + its content-less plan docs), guarded by a forced-server content check.</td></tr>
    <tr><td>Strip empty/undefined fields; await writes; no fire-and-forget</td><td>Event/camp payloads: JSON round-trip, drop <code>undefined</code> and empty strings, keep <code>[]</code>/<code>false</code>/<code>0</code>; every write awaited; creates read back from the server.</td></tr>
    <tr><td>Red test on real Firestore per data-write phase; dual implementation review; Console spot-check</td><td>Phases 1, 2, 3. TEST-scoped year key <code>TEST_DATA_SAFETY_sdoc</code> (matches the helpers' <code>TEST_SEMESTER_KEY</code> guard) injected in-page; a <code>deleteTestDayOffDocs(yearKey)</code> helper refuses any other year.</td></tr>
  </table>
</div>

<h2 id="completeness">Completeness check — what if this is interrupted?</h2>
<div class="phase">
  <ul>
    <li><strong>After Phase 1:</strong> Christie has a private, fully usable planning list for the year (events, camps, placements, teachers, per-day projects); nothing is visible to teachers (the Publish toggle is hidden for the type until Phase 2); nothing else in the app changed. A perfectly good stopping point for weeks.</li>
    <li><strong>Rules deployed, app not yet:</strong> three empty collections with rules nobody uses. Safe indefinitely.</li>
    <li><strong>App deployed, rules not:</strong> prevented by the order in 1.1 — and if it happened anyway, the startup load of any SDOC year would hit permission-denied and put the <em>whole app</em> behind the red banner with all writers refusing (the global load guard), never a quiet empty list.</li>
    <li><strong>After Phase 2:</strong> teachers can plan; admins read via Phase 1's list but edit only through the teacher path until Phase 3 — acceptable.</li>
    <li><strong>Rules deployed before UI, or UI before rules:</strong> rules must land first — the app's load guard turns a missing rule into a loud, app-wide banner rather than a quiet empty list, but nobody wants that banner in front of teachers. Phase 1's order is therefore: rules commit + deploy → then the UI deploy.</li>
  </ul>
</div>

<h2 id="decisions-log">Decisions Log</h2>
<ul>
  <li><strong>Sep 30, 2026 (Christie: "#1"):</strong> the transactional open read for the 2B editor is folded into the Phase 3 build — <code>readDayOffPlanForEditor()</code> reads through a read-only <code>runTransaction(tx =&gt; tx.get(planRef))</code>, save path unchanged; its own red test (a stale <code>source:'server'</code> answer must not be what the editor opens). Next: build — red emulator tests first.</li>
  <li><strong>Sep 30, 2026 (Phase 3 review round 6 — CHANGES NEEDED from both, one MEDIUM, same finding):</strong> the line map checks out (Claude: 35 anchors), the shared callback is clean with Spring's own-doc listeners, and the "queries can't be transactional" claim is correct (Firebase 10.8.0 compat). But my "the 2B editor keeps its own checks" was wrong: <code>readDayOffPlanForEditor()</code> uses the same possibly-stale <code>get({source:'server'})</code>, and the save never compares with the opened version, so a stale open can silently overwrite a co-teacher's newer text. Live 2B gap, widened slightly by Phase 3's new entry point. Text corrected; LOWs folded (<code>renderDayOffAdmin()</code> carve-out, catch line numbers). <strong>Open for Christie:</strong> fold the transactional open read into the Phase 3 build (recommended), or record it as a 2B limitation for the concurrency plan.</li>
  <li><strong>Sep 30, 2026 (storage move landed — Phase 3 re-verified against <code>132fef2</code>):</strong> PR #5 (Spring 2026 in its own document) merged. Every Phase 3 reference re-located (map in the "Re-verification" paragraph); no referenced body changed. Two interactions recorded: Spring's own-doc listeners also call the shared callback (redraw only — no stamp or refresh-failure change), and the storage session's finding that <code>get({source:'server'})</code> can be stale after a Listen transport error — accepted as a display-only known limitation (no Phase 3 writes). Next: a short targeted review of the re-verification, then build (red tests first).</li>
  <li><strong>Sep 29, 2026 (Christie's GO on Phase 3):</strong> "yes to both" — (1) the design as written (revision 5), and (2) <code>source: 'server'</code> for all SDOC loads, accepting that an offline start shows the load banner + retry instead of a cached/empty SDOC year. Phase 3 is execution-ready as a design; <strong>the build starts only after <code>classbook-per-semester-lesson-storage</code> has landed</strong> — first step then: re-verify every line reference and the listener/reload shape against the new code (a short targeted review if it moved materially), then red emulator tests → build → dual implementation review → "okay to deploy".</li>
  <li><strong>Sep 29, 2026 (Phase 3 review round 5 — READY from both, design COMPLETE):</strong> Codex and Claude both confirmed the shared <code>onLessonDataReload()</code> fixes the startup race, that each branch is behaviour its view's own callback already has (Teacher View's single tab check is kept inside its helper; Curriculum Admin already redraws unconditionally), that the <code>tvInitialized</code> / <code>caInitialized</code> gates are right (the early admin draw before its awaits is safe — nothing it renders reads the change log, cut or future projects), and that <code>dayOffRefreshFailed</code> behind <code>isCurrent()</code> covers button, retry and snapshot failures. No new HIGH/MEDIUM. Two build-time LOWs recorded in the "Redraw on every install" paragraph. Reviews: <code>thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round5-{codex-full,claude}.md</code>. <strong>Next: Christie's go on the design, including her yes to <code>source: 'server'</code> for all SDOC loads.</strong> The build then waits for <code>classbook-per-semester-lesson-storage</code> to land; re-verify line references against it first.</li>
  <li><strong>Sep 29, 2026 (Phase 3 review round 4 → revision 5):</strong> Claude READY (2 LOW); Codex CHANGES NEEDED (1 MEDIUM). Both found the same thing: revision 4's claim that the reverse redraw was unneeded was <strong>wrong</strong> — a startup race (a Teacher View click while <code>initCurriculumAdmin()</code> awaits its loads) lets Curriculum Admin register last, so Teacher View stops redrawing (pre-existing; Claude rated it LOW for Phase 3, Codex MEDIUM). Verified at app.js:182-188 and 5015-5038. <strong>Folded:</strong> both inits now register one shared <code>onLessonDataReload()</code> that runs each <em>initialised</em> view's existing redraw — ownership no longer matters, no new behaviour; <code>dayOffRefreshFailed</code> is set inside the gated reload's failure path (Claude LOW). BDD +1 (the startup race). Next: round 5 (short), then Christie's go incl. <code>source: 'server'</code>. Build still waits for the storage migration.</li>
  <li><strong>Sep 29, 2026 (Phase 3 round-3 MEDIUM folded — revision 4; its "reverse not needed" claim was corrected in revision 5):</strong> Teacher View's listener callback now also calls <code>renderAdminGrid()</code> + <code>renderHelpQueue()</code> when Curriculum Admin is the active tab (before its SDOC early return), so the automatic retries and snapshot reloads redraw Curriculum Admin after a Teacher View visit — which also closes a pre-existing gap for the weekly grid. The "Couldn't refresh" message is derived at render time (<code>dayOffRefreshFailed[yearKey]</code>, cleared where the stamp is set). The "vice versa" from round 3 was dropped after checking the code: Curriculum Admin's callback can own the listener only while Teacher View has never finished initialising (its guard exit resets <code>tvInitialized</code>), so there is nothing to redraw. BDD +2. <strong>Christie, Sep 29: finish the design now, but build only after <code>classbook-per-semester-lesson-storage</code> lands</strong> (it reworks the same listener) — re-verify line references then. Next: round 4 (short, targeted), then Christie's go incl. her yes to <code>source: 'server'</code>.</li>
  <li><strong>Sep 29, 2026 (Phase 3 review round 3 — PAUSED here, Christie moving locations):</strong> both confirmed every round-2 fix; both found ONE remaining MEDIUM, not yet folded: two other install paths also redraw through the single global listener's callback, which after a Teacher View visit belongs to Teacher View — (1) the failed reload's automatic retries (firebase-data.js:1151-1157) and (2) a snapshot-triggered reload (firebase-data.js:1190-1194) — so on Curriculum Admin the rows, stamp, "Couldn't refresh" message and editability can go stale after recovery. <strong>Agreed fix to fold next:</strong> make every listener callback redraw whichever tab is active (Teacher View's callback also calls <code>renderAdminGrid()</code> when Curriculum Admin is active, and vice versa), and add a BDD: visit Teacher View → back to Curriculum Admin → refresh fails → automatic retry succeeds → message gone, rows + stamp fresh, editing re-enabled. Then a short round 4, then Christie's go (which must also include her yes to <code>source: 'server'</code> for all SDOC loads — see the Refresh paragraph). No code written for Phase 3 yet; Classbook <code>main</code> is clean at <code>2ef2e62</code>.</li>
  <li><strong>Sep 29, 2026 (Phase 3 review round 2 — both confirmed every round-1 fix; folded, revision 3):</strong> HIGH (both): the single global listener's callback belongs to whichever view initialised last, so after a Teacher View visit a refresh would install fresh data without redrawing the admin list while the stamp advanced → <code>refreshDayOffYear()</code> redraws the list itself on any non-stale outcome; one shared in-flight refresh. MEDIUM (Claude): <code>source: 'server'</code> also changes startup for teachers (offline → guard + banner instead of a cached/empty year) — stated, Christie's yes asked with the go; the editor's guard is scoped to SDOC (summer untouched). LOW: the stamp is set on startup's load too; <code>isIsoDate</code> before formatting. BDD +2. Next: round 3 (targeted).</li>
  <li><strong>Sep 29, 2026 (Phase 3 review round 1 — Codex + Claude, both CHANGES NEEDED; folded, revision 2):</strong> HIGH (both): an independent refresh would be ungated — an older one resolving last could revert a newer reload and stamp it "now" → refresh goes through the listener's own generation-gated reload (<code>reloadSummerForModeChange</code>); SDOC loads become <code>source: 'server'</code>; the stamp ("Last full refresh") advances only when a gated reload installs. HIGH/MEDIUM: a failed refresh trips the existing guard (banner + retry), keeps prior figures, and the editor opens read-only while guarded. MEDIUM: the two automatic call sites are named (tab re-entry, header switch to SDOC on Curriculum Admin); <code>lastEditedAt</code> is sliced before formatting; plans are counted per (camp, title). LOW: pill labels via <code>getProgressLabel</code> ('ready' unreachable); the no-apostrophe-in-onclick reason recorded. BDD +6. Next: round 2.</li>
  <li><strong>Sep 29, 2026 (Phase 3 designed, revision 1 — not yet reviewed):</strong> Christie: "yes design it with the roll-up". Read-only overview in the planner's camp list: per-project status (same <code>calculateLessonProgress</code> as Teacher View), last editor, Open plan (the 2B editor), a per-event roll-up, and an explicit "as of" time with ↻ Refresh + re-read on Curriculum Admin entry (no live listener on SDOC collections). No data, rules or writer changes. Next: review round.</li>
  <li><strong>Sep 28, 2026 (Phase 2C DEPLOYED):</strong> Christie ran <code>npm run deploy</code> at <code>1745e95</code> (also ships <code>44a5159</code>, the Teacher Mapping fix). Claude re-ran <code>scripts/check-live.sh</code>: every file byte-identical, every dev path 404, <code>[check-live] ok</code>. Next for Christie: discard the Northern Lights "n/a" leftover list; publish the SDOC year when ready. Then Phase 3 and the follow-ups listed in the 2B/2C entries.</li>
  <li><strong>Sep 28, 2026 (Phase 2C BUILT — <code>main</code> @ <code>1745e95</code>, pushed; awaiting "okay to deploy", which also ships another session's <code>44a5159</code> Teacher Mapping fix):</strong> Built as designed (revision 6). Build-time live-data check found a real "n/a" record on Northern Lights holding Canvas + Uniposcas; Christie copied them onto Canvas Painting part 1 / part 2 before deploy (verified in the 17:58 backup); the n/a record surfaces as a discardable leftover list (pinned in D10). Dual implementation review (Codex + Claude), 2 rounds, READY from both: round 1 — links/details of an unexpected stored shape could crash the teacher editor and escape the user-data guards → type guards, malformed values count as content, the writer refuses a malformed stored shape; Done blocked during a save; inputs locked during a save; the details error box got its own class (it collided with 2A's tests M9/M15); several test names tightened and cases added (D8 links allow-list, D10 n/a → real title, D11 malformed shapes, T22 ordinary teacher save keeps details, T23 Teacher View unused blocks). Test-environment note: two full runs were disturbed by another session's emulators in this shared checkout (22 then 11 timeouts, all green when re-run alone; an orphaned test server of theirs on 8097 was stopped); the final full suite is 321/321.</li>
  <li><strong>Sep 28, 2026 (Phase 2C review round 5, Claude targeted; revision 6):</strong> round-4 fix confirmed; the last gap was the view token covering only the successful read — now a superseded open does nothing on success <em>or</em> failure (BDD extended). LOWs: citations 13032/13090; the details read-back's record-gone case reports "renamed or removed" like 2B's <code>renamed</code>. Review converged (Codex READY at round 3; Claude's rounds 3–5 each found one narrower spec gap in the previous fix, all folded). <strong>Design complete — awaiting Christie's go.</strong> The implementation review will check the built code against it.</li>
  <li><strong>Sep 28, 2026 (Phase 2C review round 4, Claude targeted):</strong> both round-3 fixes confirmed; one new MEDIUM folded (revision 5): <code>openDayOffMaterials()</code> gets a view token so a superseded open's read is dropped instead of rendering (and, with Details, saving) project A under project B — also closes the same pre-existing 2A gap for the materials rows. BDD added. Next: round 5 (Claude, targeted).</li>
  <li><strong>Sep 28, 2026 (Phase 2C review round 3):</strong> Codex <strong>READY</strong>. Claude confirmed every round-2 fix; two new spec gaps, folded (revision 4): the Details container's lifecycle (emptied + baseline dropped on Loading/read-failure/close; drawn only after a successful open read; Save re-checks the view's camp/title) so text can't be saved onto another project; the different-<code>detailsEditId</code> branch installs the server read-back and re-bases on it, via the generalised <code>verifyDayOffPlanWrite()</code>. LOW citation fixes. BDD: A→B popup switch incl. a failed read. Next: round 4 (Claude, targeted).</li>
  <li><strong>Sep 28, 2026 (Phase 2C review round 2 — both confirmed every round-1 fix; both CHANGES NEEDED on the fixes themselves; folded, revision 3):</strong> Codex: the writer's signature now carries <code>expected</code> and <code>auth</code> (both required), and the stray "the rules' planner condition matches" claim is gone. Claude: the stale-editor baseline is defined (set by the popup's open read, re-set only by its own verified save — never from the tick-refreshed <code>v.plan</code>); the Details section lives outside the materials redraw, so ticks never disturb typing (focus/caret kept; no draft bag); a <code>detailsEditId</code> tells "someone saved after me" from a real failure; install via <code>dayOffInstallVerified</code>; the no-plan refusal in <code>saveDayOffPlan</code> uses the broadened wrapper; <code>isDayOffUnusedBlock('')</code> is false. BDD: two saves without reopening; another planner's links arriving under a tick redraw; focus kept through a tick. Next: round 3.</li>
  <li><strong>Sep 28, 2026 (Phase 2C review round 1 — Codex + Claude, both CHANGES NEEDED; all verified and folded, revision 2):</strong> Claude HIGH: <code>linkifyText()</code> does not escape quotes, so a stored URL could break out of <code>href</code> → the vision is rendered escaped with line breaks and no auto-linking; links via <code>new URL()</code> + attribute-escaped href; the same pre-existing hole in summer's reference fields is flagged as its own task. Codex HIGH: "planner-owned" is not rules-enforced → stated as UI-level (the 2A <code>materialItems</code> gap), writer takes an explicit <code>auth</code> argument; rules field-pin stays a follow-up. MEDIUMs (both): one merge-set write shape with delete sentinels, no-op when absent and empty; stale-editor guard (links written whole); explicit read-back comparison; "About this project" as its own block in the SDOC branch; a separate details draft + close-confirm; the n/a change made at the <code>isDayOffNoPlanTitle</code> wrapper with each site named (validator keeps the broad rule; Teacher View takes the unused helper; admin list/editor grid show text as typed); re-check live data at build time. BDD extended: every spelling + duplicates, real→n/a prompted removal, concurrent planners, links-only creation and protection, limits, the quote payload, the teacher allow-list refusal, drafts across failures. Next: round 2.</li>
  <li><strong>Sep 28, 2026 (Phase 2C designed, revision 1 — not yet reviewed):</strong> Christie asked for per-project vision text + inspo links for teachers. Her choices: typed in the project popup; several links; "n/a"/"none" = not used (like "—"). Design: two planner-owned fields (<code>projectDetails</code>, <code>projectLinks</code>) on the existing project record, a transactional planner-only writer, rendered to teachers as "About this project", http(s)-only links, counted as user data; <code>isDayOffUnusedBlock()</code> for "—"/n/a/none without touching the summer rule. No rules change. Next: one Codex + Claude review round.</li>
  <li><strong>Sep 28, 2026 (2A.1 + 2B DEPLOYED):</strong> Christie ran <code>npm run deploy</code> herself (the auto-mode classifier blocked Claude's attempt — which was malformed, carrying a stray second background deploy; no deploy ran from it). Netlify <code>6aba91a48eab0ebcc7f29cd8</code>, commit <code>22ed027</code>. The script's immediate live check reported 3 DIFFs (CDN propagation); re-run a minute later: every file byte-identical, every dev path 404, <code>[check-live] ok</code>. The SDOC year stays unpublished until Christie publishes it. Next: Christie publishes when ready; confirm a teacher sees her camp; then Phase 3.</li>
  <li><strong>Sep 26, 2026 (Phase 2B BUILT — <code>main</code> @ <code>22ed027</code>, pushed; 2A.1 + 2B await ONE "okay to deploy", by Christie's choice to batch them):</strong> Built as designed (revision 7). Deviations, logged: (a) the save path and editor find a plan's camp/title from the camp list (<code>dayOffFindProject</code>), not the slot map — the first test runs showed a reload can briefly swap <code>currentLessonData</code>, so the SDOC list also rebuilds its slots when they don't cover the camps; (b) the plan's explicit summer-editor regression cases were not written as new tests: the existing summer suite (data-safety.spec.js — open/save/read-back/photo/serialized saves/revert/close-wait) drives the split's summer path through <code>openLessonModal</code> and stayed green, which Claude's implementation review confirmed; (c) the Teacher View's own semester selector is CSS-hidden (styles.css, "Hide individual semester selectors") — its handler now calls <code>setGlobalSemester</code> anyway. Implementation review round 1 (Codex + Claude, both CHANGES NEEDED, no data-loss path): one-sided photo clears → the pair is enforced across payload and clears; Teacher View re-entry after a semester change on another tab, leaving SDOC (picker names, teacher group) → fixed; the Q&A activity panel could show an SDOC <code>qaThread</code> → cleared for SDOC; two SDOC years could briefly show a pre-save slot → <code>healDayOffYearAfterReload</code> (per-year start seq); T12 was vacuous (no input event) → fixed; missing tests → T14 drives the three Q&A writers, T18 failed save after upload, T19 sign-off byte-identity + tick interleavings, T20 SDOC ↔ weekly transitions, T21 Q&A panel, T5 same-millisecond + photo-removal races. Round 2: <strong>READY from both</strong>; two LOWs applied (editor meta via <code>sdocEsc</code>; Publish refuses after a failed load). <strong>Follow-ups, not done:</strong> the heal rebuilds the whole year (could rebuild only keys verified after the reload began); an editor-open read is marked verified (a newer reload result can lose to it until the next reload); no two-SDOC-year test; print for SDOC plans; the rules field-pin for <code>dayOffCamps_lessonData</code>; the admin plan-status columns (Phase 3). Tests T1–T21 stable ×3; full suite 307/307. Reviews: <code>thoughts/reviews/2026-09-26-impl-review-sdoc-2b-*</code>. <strong>After deploy:</strong> Christie publishes SDOC 2026-27 when she's ready (Curriculum Admin → Published); Mariah and Kaitlyn then see their camps — their names in the year's pool are first names, matched to their accounts by first name (unique today).</li>
  <li><strong>Sep 26, 2026 (Phase 2A.1 BUILT on branch <code>sdoc-2a1-event-checklist</code>; awaiting "okay to deploy"):</strong> Built as designed; red first (M16–M21 failed for the missing button, then passed). Dual implementation review, three rounds. Round 1 (Codex + Claude, both CHANGES NEEDED, no data-safety or write-path problem): rows and the sign-off badge read two models → one model (both render from the shared caches; the view keeps only read/sign-off/tick error channels, separately); a successful tick could erase a sign-off load failure → separate channels, sign-off controls withheld while it failed; "Materials complete" was a silent no-op when its pre-check read failed (pre-existing in 2A) → wrapped, alerts; closing/reopening mid-action → <code>isCurrent</code> checked after every await in <code>markDayOffCampComplete</code>; Undo cleared load errors → only a completed re-read clears them; close kept the body under the card's class names → cleared, own classes; test gaps → M22 (teacher gate), M23 (shared item id), M24 (failed sign-off read), M25 (close/reopen during load), button text, Esc, backdrop, write spy, quotes. Round 2: Codex — a cached complete sign-off with a failed list still showed badge/Undo → withheld entirely (M26); Claude — a superseded open's reads could land after a newer open's → each open's reads chained behind the previous (M25 updated). Round 3: Claude READY; Codex — one never-settling read would strand later opens → the chain wait is capped at 10 s (M27; accepted residual: a stuck read could then land late, re-read by any tick or reload). Suite 285/285 before the cap; Phase 2A specs 27/27 after it. Reviews: <code>thoughts/reviews/2026-09-26-impl-review-sdoc-2a1-*</code>.</li>
  <li><strong>Sep 26, 2026 (Christie: "go"):</strong> Phase 2A.1 and Phase 2B marked execution-ready. Order: 2A.1 (red tests → build → full suite → dual implementation review → "okay to deploy"), then 2B the same way. No rules change in either.</li>
  <li><strong>Sep 25, 2026 (plan review round 6 — 2B only):</strong> Claude <strong>READY</strong> (two LOW wording notes, folded: the id is generated once before <code>runTransaction</code>; "no read-back message" for the no-op). Codex CHANGES NEEDED, one MEDIUM, verified against the code and folded: a reload whose query predates a teacher's save can re-install the pre-save text on screen, because the reload captures its previous map at start and SDOC installs replace maps wholesale → a clock-free install sequence (<code>dayOffInstallSeq</code>) makes the reload keep any plan verified after it started; BDD with a genuinely stale query added. Both confirmed the round-5 fixes and the rejection of round-5 L-3. Round 7 (Codex, targeted): the sequence covers both reload paths, the generation gate and 2A tick installs, but <code>mergeSummerReload()</code>'s clock-based <code>keepMine</code> ran after it and could still copy old text back → protected keys bypass it (folded; BDD with a skewed clock). Round 8 (Codex, targeted): <strong>READY</strong>. With Claude READY in round 6, <strong>Phase 2B design reviews are CLEAN</strong> — awaiting Christie's go.</li>
  <li><strong>Sep 25, 2026 (plan review round 5 — 2B only):</strong> both confirmed every round-4 fix (Claude traced three through the code: the no-op test reads content fields only; <code>planComplete:false</code> survives the strip; the skipped re-install only ever fired in the two bad cases). Remaining findings were plan wording, all folded in: <code>lastEditId</code> is generated inside <code>saveDayOffPlan()</code> (not caller-writable, not clearable) and passed to the verifier; the model's field list names it; the no-op BDD keeps the editor's "✓ Saved"; the id uses the <code>getRandomValues</code> fallback pattern; own-name wording covers the same window. Not adopted: Claude L-3's "SDOC has no <code>mergeSummerReload</code> equivalent" — firebase-data.js:1126-1128 runs it for every SDOC year (verified). Next: round 6 (final confirmation).</li>
  <li><strong>Sep 25, 2026 (plan review round 4 — 2B only, Codex + Claude):</strong> both confirmed every round-3 fix, and cleared the three named risks (2A writers never touch <code>lastEditedBy/At</code>; the ISO string survives the JSON round-trip). New, folded in: a unique <code>lastEditId</code> per save decides ownership (a name + millisecond can repeat — Codex MEDIUM); no-op saves return before the verifier (Claude M1); <code>written</code> is post-strip/post-translation, a removed photo pair counts as cleared (M2); the editor's clock-based post-save re-install is skipped for SDOC (M3); own-name wording for a second window (LOW). Three BDD cases added. Next: round 5 (confirmation).</li>
  <li><strong>Sep 25, 2026 (plan review round 3 — Codex + Claude):</strong> <strong>Phase 2A.1: READY from both</strong> (Codex READY since round 2) — awaiting Christie's go. Phase 2B: both confirmed every round-2 fix; both found the same HIGH/MEDIUM — the read-back kept <em>cleared</em> fields strict, so "A clears closure, B then writes it" re-created the false failure round 2 removed, and "newer lastEditedAt" leaned on client clocks → the verifier now compares by <strong>edit stamp</strong>: own stamp ⇒ strict; different stamp ⇒ any content/photo/planComplete difference is the later save winning ("edited since" message). Claude MEDIUMs: rename paths now schedule the SDOC reload so "reopen the camp" shows the new title; the SDOC branch sits after the stamping lines so narrow Plan complete writes carry a stamp. LOWs: the save-call row (<code>dayOffAuth</code> at save time); a stale <code>teacherMappings</code> name outside the pool falls through to matching. Five BDD cases added. Reviews: <code>…-round3-{codex,claude,claude-full}.md</code>. Next: round 4 (2B only).</li>
  <li><strong>Sep 25, 2026 (plan review round 2 — confirmation, Codex + Claude):</strong> both confirmed every round-1 fix correct against 2894adf; Codex: 2A.1 READY, 2B CHANGES NEEDED; Claude: both CHANGES NEEDED. New findings, all folded in: (HIGH, Claude) a strict equality read-back would report a co-teacher's later save as a failed save and invite a clobbering re-save → identity/clears strict, content accepts a newer server <code>lastEditedAt</code> with a "Lisa has edited this since" message; (HIGH, Codex / MEDIUM, Claude) the branch's inputs had no source (<code>ref</code> undefined) → slot lookup + optional <code>opts</code> fifth parameter; photo removal was empty strings, not clears → the pair is translated to deletes; the in-transaction check must not reach app.js through a <code>typeof</code> guard → the caller passes <code>dayOffAuth</code>, missing throws; the teacher arm must require the <code>classbook</code> key; first-name fallback only when unique; 2A.1 must refresh each camp's sign-off on open; teacher autosaves must not schedule the three-query SDOC reload. LOWs: <code>markDayOffCampComplete</code> signature keeps its <code>onclick</code> callers; the Print listener binding must become conditional; the "SDOC editor sends no summer identity fields" sentence made explicit. Six BDD cases added. Reviews: <code>thoughts/reviews/2026-09-25-plan-review-sdoc-2a1-2b-round2-{codex,claude}.md</code>. Next: round 3 (confirmation).</li>
  <li><strong>Sep 25, 2026 (plan review round 1 — 2A.1 + 2B, Codex + Claude; both CHANGES NEEDED; every finding verified against 2894adf and folded in):</strong> Claude HIGH: widening <code>lessonStoreFor()</code> would turn six callers' "throw" into a weekly write to <code>curriculum/lessonData</code> → the SDOC save now branches in <code>saveSingleLesson()</code> <em>before</em> <code>lessonStoreFor()</code>, which keeps throwing. Claude HIGH: the shared name resolver matches joined "A + B" strings, so the live two-teacher camps would have been view-only for both teachers → a separate SDOC resolver + a no-mapping second-teacher BDD. Codex HIGH ×3: <code>fieldsToClear</code> was outside the allow-list (could delete <code>materialItems</code>/identity) → writable + clearable sets, anything else throws (Claude had it MEDIUM); no re-check that the saver is still on the camp → re-checked on the fresh camp inside the transaction; the summer read-back verifies only non-empty content → <code>verifyDayOffPlanWrite()</code> checks every written/cleared field and returns the document installed. MEDIUMs folded: key parsing without <code>split('|||')</code> + <code>camp.yearKey</code>; <code>initTeacherView()</code> listener binding + <code>tvInitialized</code>; the Teacher View listener's SDOC branch; the editor table (read marks, reference section, Print hidden, <code>finishClose</code> without the old parameters, no backdrop close); Plan complete disabled without rights + every checkbox sharing a key; summer regression tests before the split; 2A.1 view token + <code>allSettled</code> + explicit <code>{yearKey, campId}</code> + <code>pendingDayOffTicks</code> re-keyed at both sites + sign-off re-sync. LOWs: photo path via <code>dayOffPlanDocId()</code>; the rename-before-read-back message; the model's stale materialsList/kept-fields note; the "camp read is the lock" argument recorded. BDD added: second teacher w/o mapping, removed teacher, clear allow-list + normal clear, sign-off byte-identical, save during a pending reload, <code>curriculum/lessonData</code> untouched, no camp write from 2A.1. Both confirmed: transactions sound, publish blockers fully inventoried (three consumers), permissions consistent with the rules, XSS handled. Reviews: <code>thoughts/reviews/2026-09-25-plan-review-sdoc-2a1-2b-{codex,claude-full}.md</code>. Next: round 2 (confirmation).</li>
  <li><strong>Sep 25, 2026 (Phase 2A.1 + Phase 2B designed, revision 1 — NOT yet reviewed):</strong> Christie, before the design: "we can skip the help queue entirely for SDOCs. we just chat with teachers, no need for the ask a question flow" → no SDOC Q&amp;A in any phase (Phase 3's Q&amp;A dropped; the Q&amp;A/help writers keep refusing SDOC keys); an unfilled block shows the teacher "project not assigned yet". Mid-design she asked for "a pop up that shows all materials for all projects in that SDOC event container … grouped by project" → Phase 2A.1 (UI only over 2A's reviewed writers, grouped camp → project because the camp is the sign-off unit and a title can run in two camps), sequenced before 2B. Research (read-only inventory @ 2894adf) corrected the model's assumption: the type switch is <code>lessonStoreFor()</code>, not inside <code>saveSingleLesson()</code>, and it has seven callers; <code>seasonForSemester()</code> throws for SDOC keys (so the summer save/photo/unread/camp-complete paths cannot be reused as-is); SDOC slots carry a joined <code>teacher</code> string, so every <code>l.teacher === name</code> site needs the <code>teachers</code> array. Design choices: plan saves in a transaction that re-checks the camp still has the title (closes the rename race), payload allow-list + identity stamped from the camp, forced read on editor open, <code>openLessonModal()</code> split into a summer lookup + shared <code>openPlanEditor()</code>, edit rights for planners + Kathy/Allie (via <code>canTickDayOffMaterials()</code>) + the camp's teachers — Christie chose edit for Kathy/Allie "to match the other semester/camps" (the first draft had them read-only), no rules change, Phase 4 marked superseded. Wipe monitor: SDOC is <em>not</em> added to <code>computeLiveContentCountByTeacher()</code> (backup.js Tier-1 per-collection tripwire covers it). Christie, later Sep 25: Kathy and Allie <strong>can edit</strong> SDOC plans "to match the other semester/camps". Next: Codex + Claude review of 2A.1 and 2B.</li>
  <li><strong>Sep 24, 2026 (late — Phase 2A BUILT, on <code>main</code> @ <code>b0407c4</code>, awaiting "okay to deploy"):</strong> Built as designed (revision 3) in <code>bcb0996</code>. Dual implementation review (Codex + Claude): camp removal didn't re-read the camp in its transaction (orphan race); stale popups could edit a kept leftover; Materials complete could cover a list changed after the warning; item ids reached <code>onclick</code> strings (a hand-made key could run script — the rules let any classbook user write this collection); quick ticks were dropped — all fixed in <code>5980102</code>. Codex confirmation round: junk keys still counted, pre-refresh didn't forget moved titles, concurrent tick read-backs could show a tick unticked — fixed in <code>b0407c4</code>. Tests: <code>e2e/day-off-materials.spec.js</code> M1–M14 (planner + prep sessions, incl. races via an injected pre-transaction write); full suite 273/273. <strong>Test-environment note:</strong> tonight's first full runs crashed because another session's Summer Camp App e2e run shared the OS temp folder with the Storage emulator (and the machine); the Classbook run now needs a private <code>TMPDIR</code> when another emulator suite is active — worth making the harness set it itself (not done).</li>
  <li><strong>Sep 24, 2026 (evening — Phase 2A designed; 3 review rounds, Codex + Claude):</strong> Christie's decisions: Kathy/Allie view-only for events/camps; materials hashed out in the build phase by the planner (not in teacher plans); simple fields; per-item ticks + a camp "Materials complete" button on the card; no prep dashboard for SDOC; 2A before teachers (2B). Round 1 (both CHANGES NEEDED): rename/delete races → transactions; sign-off must not drift → per-camp sign-off doc that planner changes clear; <code>materials</code> name collides with the existing text field → <code>materialItems</code>/<code>materialChecks</code>; capability gates matching the rules; prep users need <code>classbook</code>. Round 2 (both CHANGES NEEDED): Undo would be a delete the rules deny for staff → update to <code>complete:false</code>; a bare generation bump would swallow load failures → re-run the gated reload; normative transaction mechanics; cell-based rename pairing; stale-editor guard; Teacher View selector's pre-existing draft rule deliberately unchanged. Round 3: Codex READY; Claude text-only fixes (leftover "deletes" wording, sign-off never counts as user data, debounced reload, checklist in its own modal) applied. <strong>Christie, Sep 24 evening: go — 2A execution-ready.</strong> Same message: <strong>hide draft semesters from Kathy/Allie in Teacher View too</strong> — so <code>canSeeSemester()</code> now governs the Teacher View selector as well (reverses round 2's "left unchanged"); prep staff then see only published semesters plus the unpublished SDOC year, in both selectors.</li>
  <li><strong>Sep 24, 2026 (later — Christie, entering the first real camp): MODEL CHANGE to a camp's projects.</strong> "There should be 2 project blocks and 1 Open Studio block per day, like our summer camps … we don't have them all yet, but I want to create the camp container … a note that says how many blocks still need to be filled in." So <code>camp.projects[date]</code> is now <code>{ block1, block2, openStudio }</code> (replacing "1–3 titles per day"): an empty block is absent and counts as "to fill in"; "—" marks a block deliberately unused (no plan, counted as filled); projects are no longer required to save a camp (a real title repeated within a day is still refused). The camp editor's projects section is the Summer Camp App's Build Curriculum grid (days as columns, Block 1 / Block 2 / Open Studio as rows, Open Studio pre-filled) with a live "N of M project blocks still to fill in"; the list shows "to fill" per block and a per-camp count. Slots/plans stay keyed by title (so Phase 2's plan model is unchanged); the slot's display block is "Block 1"/"Block 2". The first-deploy array shape is still read everywhere (<code>normaliseDayOffDayBlocks()</code>) and normalised before dirty-diffing (Codex MEDIUM, fixed). Also from her use: both SDOC editors no longer close on a backdrop click (<code>data-sticky</code>), and × / Cancel ask before discarding typed work; Settings' Teacher Names now says "first name only, spelled exactly as in other semesters". And a pre-existing Settings hazard she surfaced: the form only redrew on a semester change made while on Settings, and Save writes to the header's semester — fixed (form tracks its semester, redraws on mismatch from the tab or footer link, Save refuses a mismatch). Commits <code>b2e9078</code>, <code>91bcdf9</code> (deployed), <code>3167d8d</code>, <code>c655b68</code>, <code>967bf17</code>; suite 259/259.</li>
  <li><strong>Sep 24, 2026 (Phase 1 BUILT — rules live, app on branch <code>sdoc-phase1</code>, NOT yet deployed to Netlify):</strong> Prerequisite confirmed: the seasons plan's Phase 1 shipped Sep 24 (<code>b2bbaac</code>, stamped 14:45Z) — nothing carried. <strong>1.1:</strong> <code>~/tinker-backups/backup.js</code> lists the three collections in both <code>COLLECTIONS</code> and <code>TIER1_COLLECTIONS</code> (verified by parsing both arrays); rules commit <code>da87ce3</code> (red first: 13 failing) + <code>97f7915</code> (Fable 5.1 review CLEAN, its two LOW test gaps closed: a curriculum-admin-only fixture and an archived classbook fixture now pin the exclusions) — 300/300 rules, 141/141 guard — deployed through the studio-hub guard on Christie's "approved to change firebase 97f79155…", receipt <code>20260924T150725Z-97f7915</code>. The raw CLI deploy wording in 1.1 is superseded by the guard. <strong>1.2–1.5</strong> implemented as designed (<code>a1b8b86</code>). <strong>1.6</strong> deviations, logged: (a) the e2e suite is emulator-only since Sep 21 (the plan said "production, TEST-scoped"); (b) SDOC specs run as the seeded MANAGER (global-setup now saves a manager session) because the suite's curriculum-admin staff account is denied SDOC writes by design; (c) the TEST purge runs in the manager's page, not <code>e2e/helpers/firestore.js</code>, for the same reason — it still refuses any non-TEST yearKey before a query; (d) the app tests were written alongside the implementation, not strictly red-first (the rules were red-first; the stamp-fix regression test was proven red on the old code). <strong>Dual implementation review</strong> (Codex + Claude) of <code>a1b8b86</code>: 2 HIGH (typed <code>materials</code> text not counted as user data — the model's own <code>dayOffPlanHasUserData()</code> definition above missed that field; Settings' teacher-in-use guard blind to the × button), stale-editor guard bypasses (event dates, camp rename, teacher pool — now judged against forced-server reads), and pre-existing header-selector issues (remembered invisible semester; unescaped names) — all fixed in <code>9dc2a18</code> with tests SDOC R1–R5; suite 250/250. <strong>Declined</strong> (Codex MEDIUM): <code>updateAppData()</code> does not consult the lesson-load guard — pre-existing for every settings/publish write; those writes are not built from lesson data, and the SDOC Settings guards read the server directly. <strong>Also in this branch:</strong> the seasons migration's read-back now compares key-order-insensitively (its Sep 24 production run reported four false "changed unexpectedly"). <strong>Open for Phase 2</strong> (moot in Phase 1 — only manager+ can open an unpublished year): Kathy and Allie hold only the legacy <code>curriculum-admin</code> key (nobody holds <code>classbook-admin</code>), so once the year is published they would see Curriculum Admin for it but be denied event/camp writes by rule — decide then: grant them <code>classbook-admin</code>, or hide SDOC editing from curriculum-admin-only users. Next: confirmation review round → Christie's "okay to deploy" → Netlify → Christie creates the real year + one event → Console spot-check.</li>
  <li><strong>Sep 21, 2026 (Christie answers the studio-list question):</strong> "we really just run camps from a fixed list of studios, but not all studios every time. I don't think we need it editable — option A should work just fine." Decision: <code>SDOC_STUDIOS</code> stays a Classbook constant (the same six names the Summer Camp App seeds into its registry); the camp editor's placement picker offers the full list and a camp uses whichever subset applies. No Settings editor. Follow-up, not Phase 1: once the Summer Camp App's season registry exists, point the picker at its <code>studios</code> value so there is one list, not two.</li>
  <li><strong>Sep 21, 2026 (Christie: "go — mark all three execution-ready"):</strong> Phase 1 marked <strong>execution-ready: true</strong>; Phases 2–4 stay draft shape (not execution-ready). Order (1.1 → 1.6): <code>backup.js</code> edit + grep of both arrays → rules commit in studio-hub (blocks + tests; other sessions' rules edits committed/stashed first) → <code>npm test</code> → Fable 5.1 review → "approved to change firebase" → <code>firebase deploy --only firestore:rules</code> → red e2e tests → implementation → dual implementation review → "okay to deploy". Hard prerequisite: the seasons plan's Phase 1 shipped, or its five items carried here (log which).</li>
  <li><strong>Sep 21, 2026 (plan review round 4 — the post-round-3 edits only, Codex + Claude): CLEAN after two text fixes.</strong> Both reviewers found the same leftover: the safety table and Resume step (4) still said the rules commit carries <code>backup.js</code> (it cannot — not a git repo) — fixed to the pre-deploy step. Also: the model's Plan row now hedges which phase adds the existence check's SDOC branch (per the Phase 2 Q&amp;A sequencing decision); <code>COLLECTIONS</code> cited as <code>:44-86</code>. The teacher-list builders, the Q&amp;A sequencing claim and the historical <code>saveConfig</code> mentions were confirmed. No new HIGH/MEDIUM. Nothing in this document is unreviewed.</li>
  <li><strong>Sep 21, 2026 (plan review round 3 — final confirmation, Codex + Claude): CLEAN for Phase 1.</strong> Every round-2 item confirmed against the code by both reviewers; no new HIGH/MEDIUM design findings (Claude checked and rejected the camp-delete check-to-batch race, the any-teacher plan write rule and the extra per-snapshot queries as recorded trade-offs). Folded in: (1) <code>~/tinker-backups</code> is not a git repository, so the <code>backup.js</code> edit cannot ride in the rules commit — it is now an explicit, grep-verified pre-deploy step recorded in the rules commit message (Codex MEDIUM; the script's lack of version control is noted as a standing gap); (2) the Phase 2 draft now states the SDOC Q&amp;A sequencing question — the teacher-side question path is the weekly writer, so Phase 2 owns both that branch and the existence check's, or defers all SDOC Q&amp;A to Phase 3 (Claude); (3) the model names both teacher-list builders (<code>app.js:611</code> inline and <code>populateTvTeacherList()</code> <code>:732</code>) for Phase 2; (4) process note: studio-hub's working tree already carries another session's uncommitted rules edits — commit or stash them before cutting the SDOC rules commit so the Fable review sees only the three blocks. Codex flagged the two remaining <code>saveConfig</code> mentions as stale; both are explanatory ("deleted by that plan", "the stub moves") and stay. <strong>Ready for Christie's go-ahead.</strong></li>
  <li><strong>Sep 21, 2026 (plan review round 2 — confirmation, Codex + Claude):</strong> every round-1 fix confirmed present and correct; no design defects found. Folded in: (1) explicit clears — an emptied optional string (<code>district</code>, <code>notes</code>) gets <code>FieldValue.delete()</code> after sanitisation rather than being silently omitted (Codex MEDIUM; the <code>buildLessonFieldUpdates()</code> pattern); (2) Settings refuses to narrow the school-year bounds past an existing event's date (Codex MEDIUM — the model's invariant now holds on both sides); (3) the nested-field whole-write sentence moved from the event writer to the camp writer where those fields live; (4) the Phase 2 flag that <code>mergeSummerReload()</code>'s kept-fields list must include <code>materialsList</code> for SDOC slots (user-edited, no hub — Claude); (5) stale text: the safety table and a test bullet still named the deleted <code>saveConfig()</code>, the meta/readiness lines said four dependencies (five), the <code>backup.js</code> check covered one array (both), the BDD said "four writers" (the seasons plan's switch set is now seven sites incl. the admin reply writers and the existence check — a BDD scenario added here too); (6) rules citations re-pinned to studio-hub <code>706a8b2</code> (moved twice today under parallel sessions) with block names as the stable reference. Next: round 3 (final confirmation), then Christie's go-ahead.</li>
  <li><strong>Sep 21, 2026 (plan review round 1 — Codex + Claude, model + Phase 1):</strong> Codex 5 HIGH / 7 MEDIUM / 2 LOW, Claude 1 HIGH / 8 MEDIUM / ~11 LOW; every finding verified against the code; all folded in. Design changes: (1) the delete/rename guards used <code>lessonHasContent()</code> (seven text fields only) — a photo-only, Q&amp;A-only, planComplete-only or materials-only plan would have been batch-deleted with its camp → <code>dayOffPlanHasUserData()</code> covers every persisted user-authored field, with a test per field; (2) <code>curriculum-admin</code> (the legacy alias) removed from the three new rule blocks — extending it to new collections is a widening CLAUDE.md forbids without Christie's say-so, and it has no test fixture; (3) editing an event's dates now refuses to drop a date any camp still uses (referential integrity); (4) "a date in only one event" downgraded from an invariant to a best-effort forced-server check — a query-then-create cannot be transactional without a claim collection, judged not worth it for a one-person list; (5) camp validation completed (location, studio membership + uniqueness, age range, hours, sorted unique dates, ≥ 1 title per day, no duplicate titles per day, unique teachers) and made server-authoritative (the event is re-read before every camp write); nested fields written whole on change so removed day keys cannot linger; (6) a fifth dependency on the seasons plan named — <code>updateAppData()</code>, the field-path appData writer — and Settings for an SDOC year writes only its four owned fields (the first draft's "spread the existing semester" would have polluted the schema with <code>numWeeks: 16</code> and the default roster on the first save); (7) the model now says plainly that visibility is UI gating (the rules let every teacher read every SDOC doc), that shared-plan editing is dirty-field merge with last-write-wins per field, that the Help Queue's <em>data path</em> is reused but its writers/labels need a Phase 3 branch, that the teacher-facing sites which assume one teacher per lesson (teacher list, name fallback, <code>canEditLesson()</code>, content count, the "Loading…" branch) are Phase 2 work, and that the SDOC editor needs the weekly editor's editable materials table (no hub); (8) the plans rule stays in Phase 1 with the rationale spelled out (one rules deploy for the plan; the guards query the collection), while the <code>canEditLesson()</code>/name-fallback changes move to Phase 2; (9) all three collections go in <code>backup.js</code> Tier 1; (10) test cleanup runs before + finally and the helper refuses non-TEST years before any request; (11) the completeness section and the danger box now state the real blast radius — a <code>dayOffCamps_*</code> permission error at load trips the app-wide guard; (12) a teacher-pool removal guard added; <code>block</code> defined as first-seen position, display-only. Citations moved to studio-hub <code>43173d6</code> (<code>/curriculum</code> 538-569, <code>summerCamps_lessonData</code> 644-647, Default-deny describe <code>rules.test.js:1580</code>). Both reviewers confirmed sound: the events/camps/plans model against D2/D4/D5/D6, auto-ID per-event docs, one shared plan keyed by <code>campId</code>, headcount from placements, Q&amp;A on the plan doc, Storage reuse, rules-first ordering, Publish hidden until Phase 2. Next: round 2 (confirmation), then Christie's go-ahead.</li>
  <li><strong>Sep 21, 2026 (model redraw + Phase 1 detailed design — same session as the Classbook seasons Phase 0/1 design):</strong> Research against <code>a08dbeb</code> (shared inventory <code>handoffs/classbook-seasons-phase1-sites.txt</code>). <strong>Model:</strong> the planning unit is an <em>event</em> (one or more dates: a single day-off or a 2–5-day break) hosting several <em>camps</em> (topic × slot × location, with studio/age-band <em>placements</em> whose capacities sum to the headcount, one or more teachers, a subset of the event's days, and 1–3 projects + Open Studio per day); <strong>one plan per camp-project shared by all of the camp's teachers</strong> (D4's "maybe they can both edit" — no teacher in the plan key, unlike summer's per-teacher slots), keyed by the camp's auto-ID so renaming a camp never orphans plans (renaming a <em>project title</em> still does, so the camp editor guards it). Three new collections — <code>dayOffCamps_events</code>, <code>dayOffCamps_camps</code>, <code>dayOffCamps_lessonData</code> — all in Phase 1's one rules change; <strong>rejected:</strong> storing SDOC docs inside <code>curriculum/</code> to avoid a rules change (it would put them beside <code>appData</code>/<code>lessonData</code> under a broader teacher-write rule and outside the backup tripwire's per-collection view), and a fourth "1–3" afternoon slot (the hours are a text field on AM/PM/Full). Q&amp;A lives on the plan doc (the weekly-lesson pattern) so the Help Queue works unchanged and <code>summerCamps_prepHelpQueue</code> stays the Summer Camp App's alone. Photos reuse <code>curriculum/{yearKey}/…</code> → no Storage rules change. <strong>Phase 1</strong> is admin-only: rules + tests (matrix per role), year creation via the seasons plan's Type radio, event/camp editors with validation (dates inside the year, no date in two events, projects only on the camp's days, teachers from the year's pool), delete guards (event with camps; camp with a content-bearing plan — forced-server checks), the project-rename guard written now so Phase 2 inherits it, Publish hidden for the type until Phase 2, <code>backup.js</code> updated in the rules commit. Dependencies on the seasons plan's Phase 1 named explicitly (four items) with the fallback of carrying them here. Studio list: Christie confirmed Sep 21 that a fixed list is right (see the entry above) — <code>SDOC_STUDIOS</code> stays a constant. Next: second-model review rounds, then her go-ahead.</li>
   <li><strong>Sep 20, 2026 (evening — Christie answered D1–D6 in the reviewer; recorded here verbatim in substance):</strong>
   <strong>D1 — yes</strong>, a third semester type is the right container ("agreed, yes that's correct").
   <strong>D2 — the real shape of a day-off date:</strong> single-day SDOCs run about <strong>3 morning camps (9–12)</strong> and <strong>1–2 afternoon camps (1–3 or 1–4 depending on the day)</strong>; there are also <strong>multi-day SDOCs</strong> — 2-day, 3-day (Thanksgiving Break), 4-day (Winter Break), and a full 5-day week (Spring Break). Within a camp at Tinker, "2 morning camps" usually means <strong>the same topic split by age across 2 studios</strong>; a camp usually has <strong>2 teaching blocks but most commonly 1 main project plus Open Studio</strong> — though it <em>could</em> be two different projects. At Clay Hub it's 1 main project over the 3-hour camp. Afternoons 1–3 are typically a canvas-painting project; 1–4 afternoons follow the morning structure (one or two main projects + Open Studio). <em>Design consequence:</em> the session layer is real and visible in v1 (a date has several sessions: time slot × studio/age band × location), a "date" may span consecutive days (multi-day SDOCs are one camp over 2–5 dates, closer to a summer camp week than to a single day), and a session's plan needs to allow 1–2 projects plus Open Studio rather than exactly one — the summer plan's block/project structure is the closer model, not a single four-step arc.
   <strong>D3 — BVSD's calendar.</strong> Either works; "it might be nice to start from a baseline of the BVSD calendar and then verify that we run camps on all the days" (Tinker is closed one week over Christmas when school is out) — "not absolutely essential if manual entry is better". <em>Design consequence:</em> manual entry stays the v1 mechanism; a BVSD-calendar import (or a pasted list of dates) that pre-fills candidate dates for Christie to confirm/delete is a nice-to-have, not a dependency.
   <strong>D4 — (b)</strong>, "follows how we do other things in classbook" — <strong>but two teachers are often assigned to the same camp/topic; one enters the plans and the other must still SEE them — "Can I assign 2 teachers? Maybe they can both edit?"</strong> <em>Design consequence:</em> a session takes one or more teachers, all of whom can see and edit its plan (the summer camps' <code>sharedWith</code>/co-teacher model, which <code>canEditLesson()</code> already honours).
   <strong>D5 — needs a clearer explanation before she can answer</strong> ("tell me a little more about what you're proposing, I don't totally understand") — and she confirmed the premise: <strong>SDOCs live inside the Classbook</strong>, not the Summer Camp App. What D5 was proposing, restated: in v1 each session plan carries a day-of materials field exactly like a summer plan does, and the prep team reads it there; there is no automatic Materials Hub / prep-dashboard integration yet; a "next SDOC: Oct 12 — materials needed" card on the prep dashboard would follow once the model is real. <strong>D6 reshapes this — see below.</strong>
   <strong>D6 — capacity matters for MATERIALS and prep lists</strong> ("it needs capacity/enrollment in regards to materials and prep lists… Roster Manager handles actual rosters"). <em>Design consequence:</em> each session carries a capacity/expected-headcount number, and the plan's materials should be a quantity-bearing materials list (the summer <code>materialsList</code>/Materials Hub pattern, which scales by <code>classSize</code>), not a free-text field — which means the D5 answer is effectively "materials integration IS in v1, at least the materials list; the prep-dashboard card can still follow". No rosters, no kid data in the Classbook.
   <strong>Naming:</strong> the year should read <strong>"SDOC 2026-27"</strong>, not "School Day Off Camps 2026-27" — keep titles short.
   <strong>D5 — CONFIRMED by Christie the same evening ("D5 confirmed"):</strong> a quantity-bearing materials list (the summer <code>materialsList</code> / Materials Hub pattern, scaled by the session's headcount) is in v1; the prep-dashboard "next SDOC" card comes later. <strong>All six decisions are now closed.</strong>
   <strong>Next:</strong> Then the detailed Phase 1 design can start — but it still waits on the seasons plan's D3 (the New Semester "Type" field), and D2's multi-day/multi-session answer means the model section above must be redrawn before any phase is designed: session = (date-range, time slot, location/studio, age band, teachers[], capacity), plan = 1–2 projects + Open Studio.</li>
  <li><strong>Sep 20, 2026 (created):</strong> From Christie's request and clarifications (new structure; whole 2026-27 school year as the container; publish flag already handles teacher visibility). Proposed modeling the year as a third <code>semesterType</code> to reuse selector/publish/gating, per-date documents (not a shared array) to avoid the concurrency class the companion plans fight, and summer-shaped plan documents saved through the hardened <code>saveSingleLesson()</code> path. Sequenced after <code>classbook-camp-seasons.html</code> Phase 1 (explicit semester types). D1–D6 open for Christie.</li>
</ul>

<h2 id="resume">Resume Instructions</h2>
<div class="phase">
  <p><strong>Status (Sep 29, 2026) — read this first:</strong> Phases 1–2C LIVE (<code>1745e95</code>; <code>main</code> now <code>2ef2e62</code> with the linkify XSS fix merged, not yet deployed). <strong>Phase 3 design is COMPLETE and APPROVED (revision 5; Christie's go + yes to <code>source: 'server'</code>, Sep 29) — build waits for <code>classbook-per-semester-lesson-storage</code> to land; then re-verify line refs first</strong> — see the top Decisions Log entry. The Phase 3 <em>build</em> waits for <code>classbook-per-semester-lesson-storage</code> to land (Christie, Sep 29). Later on Sep 29: <code>main</code> @ <code>e25d9db</code> is LIVE (XSS fix #2, onclick quoting #3, Teacher View collapse + pop-up links #4). Earlier status: <strong>Phases 2A.1 and 2B are LIVE</strong> (<code>22ed027</code>, Netlify <code>6aba91a4</code>, Sep 28). Christie publishes the SDOC year when she wants teachers to see it. Then Phase 3 (planner plan-status columns) and the follow-ups in the top Decisions Log entry. Earlier: Christie's Sep 25 materials are confirmed in the 11:54 backup (Beanie Painting: 2 items; no ticks yet). <strong>Phase 2A.1 (event materials checklist, revision 3) and Phase 2B (teachers plan, revision 7) are designed and their Codex + Claude reviews are CLEAN</strong> (2A.1 after 3 rounds, 2B after 8 — see the Decisions Log). Next: Christie's go per phase (2A.1 first) → red emulator tests → build → dual implementation review → "okay to deploy". No rules change in either. Earlier the same day: Phase 1 and Phase 2A are LIVE (Classbook <code>main</code> @ <code>67583e3</code>, Netlify <code>6ab683df</code>; rules <code>97f7915</code>). Christie has real data in production: SDOC 2026-27 (teachers Mariah, Kaitlyn), 3 events, 4 camps, some materials. <strong>Next, in order:</strong> (1) confirm her Sep 25 materials and a Kathy/Allie tick + Materials complete in a backup; (2) <strong>design Phase 2B</strong> (teachers plan their days; the Publish toggle for the type; Q&amp;A sequencing — see the Phase 2B draft and the model) to the same standard as 2A: write the design here → Codex + Claude review rounds until clean → Christie's go → build with emulator tests (use a private <code>TMPDIR</code> if another emulator suite is running) → dual implementation review → "okay to deploy". The Sep 24 Decisions Log entries hold every decision made in use (blocks grid, optional projects, materials in the build phase, prep check-off, view-only Kathy/Allie, drafts hidden in Teacher View).</p>
  <p><strong>Earlier status (Sep 21, 2026):</strong> model redrawn; Phase 1 designed in detail (real line numbers @ <code>a08dbeb</code>). Nothing built. Next, in order: (1) <code>/second-model-review</code> (Codex + Claude) on the model + Phase 1 until a round comes back clean — <strong>done — three rounds Sep 21, round 3 clean from both reviewers</strong> (see the Decisions Log); (2) <strong>done — Christie's go given Sep 21 ("go — mark all three execution-ready"); Phase 1 is execution-ready</strong>; (3) confirm the seasons plan's Phase 1 has shipped (or carry its five items — see the note under Phase 1); (4) build in the 1.1 → 1.6 order: <code>backup.js</code> edit + grep of both arrays (outside git) → rules commit in <code>studio-hub</code> (blocks, tests; other sessions' rules edits committed or stashed first) → Fable review → "approved to change firebase" → rules deploy → red e2e tests → implementation → dual implementation review → "okay to deploy"; (5) design Phase 2 in the same detail (the editor reuse, <code>saveSingleLesson()</code>'s third branch, Publish for the type). <strong>First step in any new session:</strong> check the plan reviewer (<code>plan-review index</code>) for Christie's comments, then re-read the model section — every later phase hangs off it. Do not touch product code before step (2).</p>
  <p><strong>Standing rules that apply:</strong> red test on real Firestore first; commit per phase; per-phase Codex + Claude implementation review of the actual diff; Console/read-only spot-check; Netlify deploy only on Christie's explicit "okay to deploy"; rules changes need "approved to change firebase" plus a Fable 5.1 second review of the rules diff.</p>
</div>

</body>
</html>
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-d2gWyPf0' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-4tRlBDRx' (errno=Operation not permitted)
diff --git a/js/firebase-data.js b/js/firebase-data.js
index 3138c56..c156e28 100644
--- a/js/firebase-data.js
+++ b/js/firebase-data.js
@@ -891,160 +891,161 @@ function campSeasonLoadPlan() {
 async function loadOneCampSeason(plan, opts = {}) {
   if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
   return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
 }
 
 // Initial load for own-doc semesters and the migration record (called by
 // loadLessonData, after the legacy document). A failed read of the record is
 // treated as "not verified" (edits stay paused); a failed read of a semester's own
 // document marks it 'error' — shown from whatever lessonData still holds, never
 // writable, with a visible notice.
 async function loadOwnDocSemesters() {
   if (!curriculumDb) initCurriculumFirestore();
   try {
     const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
     storageMigrationState = m.exists ? (m.data() || {}) : {};
   } catch (err) {
     console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
     storageMigrationState = {};
   }
   for (const semKey of OWN_DOC_SEMESTERS) {
     try {
       const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
       if (own.exists) {
         ownDocSource[semKey] = 'ownDoc';
         currentLessonData[semKey] = ownDocLessonMap(own.data());
       } else {
         ownDocSource[semKey] = 'legacy';
       }
     } catch (err) {
       console.error(`❌ Could not read curriculum/${ownDocIdFor(semKey)}:`, err);
       ownDocSource[semKey] = 'error';
       showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
     }
   }
 }
 
 // The legacy snapshot no longer holds an own-doc semester this tab was showing
 // from lessonData: the move just happened (or the page is stale). Never blank it —
 // keep the lessons on screen, look for its own document, and if that isn't there
 // either, say so.
 async function recheckOwnDocAfterLegacyLoss(semKey, callback, token) {
   try {
     const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
     // A later snapshot (the own-doc listener, or a rollback) has spoken since this
     // read began — its state is newer than this answer, so drop it.
     if (ownDocTransitionToken[semKey] !== token || ownDocSource[semKey] === 'ownDoc') return;
     if (own.exists) {
       ownDocSource[semKey] = 'ownDoc';
       currentLessonData[semKey] = ownDocLessonMap(own.data());
       updateOwnDocPausedNotice();
       if (callback) callback(currentLessonData);
       return;
     }
   } catch (err) {
     console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
   }
   if (ownDocTransitionToken[semKey] !== token) return;
   showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
 }
 
 async function loadLessonData() {
   if (!curriculumDb) initCurriculumFirestore();
   try {
     const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
     currentLessonData = doc.exists ? doc.data() : {};
     lastLegacyLessonData = doc.exists ? doc.data() : {};
     await loadOwnDocSemesters();
 
     // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
     try {
       const plans = campSeasonLoadPlan();
       console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
       for (const plan of plans) {
         currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
         console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
       }
       // School Day Off Camps years: their own three collections. A failure
       // trips the same app-wide guard — loud, never a quiet empty list.
       for (const yearKey of dayOffYearKeys()) {
         currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
+        markDayOffYearInstalled(yearKey);
         console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
       }
       lessonDataLoadedSuccessfully = true;
     } catch (err) {
       // One season failing trips the guard for the whole app: a partially
       // loaded model is not a safe base for any writer, in any semester.
       console.error('❌ Could not load camp season data:', err);
       lessonDataLoadedSuccessfully = false;
     }
   } catch (err) {
     console.error('Error loading lesson data:', err);
     currentLessonData = {};
     lessonDataLoadedSuccessfully = false;
   }
   return currentLessonData;
 }
 
 // Whole-semester bulk writer (restoreFromBackup, createNewSemester,
 // createLessonSlotsForRoster). Guarded the same way as
 // saveSingleLesson(): after a failed load, `lessons` is built from an empty or
 // partial currentLessonData (or, for restoreFromBackup, would land over a
 // semester whose current state this client never confirmed), and merge:true
 // would still write it over the real semester map. Throws rather than no-ops —
 // every caller treats a resolved promise as "the write landed" (backtracking
 // audit, Phase 11).
 async function saveLessonData(semesterKey, lessons) {
   if (lessonDataLoadedSuccessfully === false) {
     throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   }
   if (!curriculumDb) initCurriculumFirestore();
 
   // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
   // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
   // and any other type is refused rather than misrouted.
   if (lessonStoreFor(semesterKey) === 'camp') {
     return await saveSummerCampLessonData(semesterKey, lessons);
   }
 
   // Regular semester: save to curriculum/lessonData — or, for an own-doc
   // semester, to its own document (the whole map at the top level).
   const user = getAuthUser();
   const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
   if (isOwnDocSemester(semesterKey)) {
     const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
     await ref.set({ ...lessons, ...stamp }, { merge: true });
     return;
   }
   await curriculumDb.collection('curriculum').doc('lessonData').set({
     [semesterKey]: lessons,
     ...stamp
   }, { merge: true });
 }
 
 // Explicitly delete a single lesson key from the nested map.
 // More reliable than resaving the full semester when cutting a project,
 // because Firestore's merge:true may not remove nested map keys.
 async function deleteLessonKey(semesterKey, lessonKey) {
   if (!curriculumDb) initCurriculumFirestore();
   const user = getAuthUser();
   const { ref, prefix } = weeklyLessonTarget(semesterKey);
   await ref.update({
     [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
     lastUpdated: new Date().toISOString(),
     lastUpdatedBy: user?.name || 'Unknown'
   });
 }
 
 async function saveSummerCampLessonData(semKey, lessons) {
   if (!curriculumDb) initCurriculumFirestore();
   // Resolved once, before any batch work — a semester with no valid season
   // throws here, so nothing is queued.
   const season = seasonForSemester(semKey);
   const user = getAuthUser();
   const batch = curriculumDb.batch();
 
   console.log('💾 Saving Summer Camp lesson data...', { semKey, season });
 
   const hasContent = lessonHasContent;
 
   let writeCount = 0;
@@ -1216,220 +1217,233 @@ function lessonEditedAtMs(lesson) {
 // (everything else on the slot — teacher, camp, materials, sharedWith, class
 // size… — is rebuilt from the other collections on every reload and must
 // always come from the fresh read).
 const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
 // A reload's read can only plausibly predate a save this recent; a stamp
 // older than this — or further than this into the future — is a skewed clock
 // or a doc deleted/restored underneath us, and the fresh read wins.
 const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
 // When the merge keeps an in-memory copy, the server copy it displaced is
 // parked here so the summer editor can fall back to it if the in-flight save
 // that made the in-memory copy "newer" then fails (see openLessonModal()).
 // Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
 // share a lesson key — same teacher, camp, block and project in 2026 and
 // 2027 — and a single-keyed map would park one season's server copy under
 // the other's, then hand it back to the wrong editor.
 const displacedSummerServerCopies = new Map();
 const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
 
 // Backtracking audit Phase 7, handed over by Phase 10: a reload's collection
 // read can predate a save that has since landed (or is in flight,
 // optimistically installed). The fresh read is authoritative for WHICH
 // lessons exist and for every scaffold-derived field; for the saved-doc
 // fields, keep the in-memory copy when it is strictly newer — recently — than
 // the freshly read one. The in-memory OBJECT is kept (updated in place), so
 // the editor's identity checks on its optimistic entry still hold.
 // protectedKeys (SDOC, Phase 2B): lessons whose fresh copy is a VERIFIED save
 // newer than this reload's query — taken whole, never overridden by the
 // clock-based keepMine below and never parked (a faster clock on an older
 // in-memory copy must not put old text back). Defaults to the set
 // loadDayOffCampData() attached to its result; summer results carry none.
 function mergeSummerReload(semKey, previous, fresh, protectedKeys = fresh?.[DAY_OFF_PROTECTED] || null) {
   // A lesson the fresh scaffold no longer has is gone — nothing parked for it
   // may be resurrected by an editor fallback later. Only THIS semester's
   // parked copies are considered: pruning globally would evict the other
   // season's on every reload.
   const prefix = `${semKey}|`;
   for (const key of displacedSummerServerCopies.keys()) {
     if (!key.startsWith(prefix)) continue;
     if (!(key.slice(prefix.length) in fresh)) displacedSummerServerCopies.delete(key);
   }
   if (!previous) return fresh;
   const now = Date.now();
   for (const key of Object.keys(fresh)) {
     if (protectedKeys?.has(key)) { displacedSummerServerCopies.delete(displacedKey(semKey, key)); continue; }
     const mine = previous[key];
     const mineAt = lessonEditedAtMs(mine);
     const keepMine = mine && mineAt > lessonEditedAtMs(fresh[key]) && Math.abs(now - mineAt) < SUMMER_KEEP_MINE_WINDOW_MS;
     if (keepMine) {
       const saved = {};
       SUMMER_SAVED_FIELDS.forEach(f => { if (f in mine) saved[f] = mine[f]; });
       displacedSummerServerCopies.set(displacedKey(semKey, key), fresh[key]);
       // `mine` becomes exactly "fresh scaffold + my saved fields" — anything
       // else that was sitting on it (e.g. legacy Q&A mirror fields another
       // path installed) goes, so the object never carries stale extras.
       for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
       Object.assign(mine, fresh[key], saved);
       fresh[key] = mine;
     } else {
       displacedSummerServerCopies.delete(displacedKey(semKey, key));
     }
   }
   return fresh;
 }
 
 // Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
 // shared curriculum/lessonData doc re-runs the summer collection reload.
 // Its outcome now drives the load-guard and the banner like the initial
 // load does — a failure trips them, a later success resets them — and only
 // the LATEST reload's outcome may do so: callbacks resolve out of order, and
 // unsubscribing a listener does not cancel its in-flight callback, so the
 // generation counter is module-scoped across every setupLessonDataListener()
 // call (and bumped by the call itself, so an old listener's in-flight reload
 // is stale from the moment it is replaced). A tripped guard blocks every
 // writer in the app, so a failed reload is retried a bounded number of times
 // on its own — a wifi blip self-heals, a real outage keeps the banner.
 // Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
 // the reload takes (it used to vanish, so the summer view rendered nothing
 // and an in-flight save's optimistic entry had no map to live in), and the
 // reload is merged per lesson keeping the newer copy (mergeSummerReload).
 const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
+// SDOC Phase 3: when each School Day Off year was last read in full and
+// installed (a Date), and whether the latest full reload of it failed. Both
+// change only where a full load installs or fails — never on a single-plan
+// read — and Curriculum Admin's overview derives its message from them at
+// render time, so any redraw after a recovery shows the truth.
+const dayOffLastRefreshAt = {};
+const dayOffRefreshFailed = {};
+function markDayOffYearInstalled(yearKey) {
+  dayOffLastRefreshAt[yearKey] = new Date();
+  delete dayOffRefreshFailed[yearKey];
+}
 // The camp seasons currently in memory, by semester key.
 function snapshotCampSeasons() {
   const out = {};
   for (const semKey of Object.keys(currentLessonData || {})) {
     if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
   }
   return out;
 }
 
 // Set by setupLessonDataListener() so a season-registry mode change (legacy →
 // filtered, or unknown healing) re-runs the summer load through that
 // listener's own generation-gated path — never a second, competing one
 // (Phase 1, 1.3).
 let summerReloadHook = null;
 async function reloadSummerForModeChange() {
   if (typeof summerReloadHook !== 'function') return 'no-listener';
   return await summerReloadHook();
 }
 
 function setupLessonDataListener(callback) {
   console.log('📚 Setting up lesson data listener...');
   if (!curriculumDb) initCurriculumFirestore();
   globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
   if (lessonDataUnsubscribe) lessonDataUnsubscribe();
   // The own-doc listeners (Spring 2026 storage move) are torn down together.
   while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
 
   // One reload attempt for one snapshot generation. Only the latest
   // generation may touch the guard, the banner, or the summer cache.
   // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
   // outcome was discarded (a newer snapshot took over while it ran).
   const reloadSummer = async (myGeneration, previousSummer, attempt) => {
     const isCurrent = () => myGeneration === globalListenerGeneration;
     try {
       console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
       const plans = campSeasonLoadPlan();
       const fresh = {};
       for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
       const dayOffKeys = dayOffYearKeys();
       for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
       if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
       for (const yearKey of dayOffKeys) {
         currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
         healDayOffYearAfterReload(yearKey, fresh[yearKey]);
+        markDayOffYearInstalled(yearKey);
       }
       for (const plan of plans) {
         // Each season merges against ITS OWN previous map — mergeSummerReload
         // prunes parked copies that are absent from `fresh`, so merging one
         // season against another's would evict the other's on every reload.
         currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
       }
       console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
       lessonDataLoadedSuccessfully = true;
       document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
       return 'ok';
     } catch (err) {
       console.error('❌ Could not load camp season / day-off camp data:', err);
       if (!isCurrent()) return 'stale';
       lessonDataLoadedSuccessfully = false;
       document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
+      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
       const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
       if (delay !== undefined) {
         setTimeout(() => {
           if (!isCurrent()) return; // a newer snapshot has taken over
           reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
         }, delay);
       }
       return 'failed';
     }
   };
 
   // The registry-change entry point: same reload, same generation gate, and it
   // renders through the same callback when it is still the current generation.
   summerReloadHook = async () => {
     const myGeneration = ++globalListenerGeneration;
     const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
     if (outcome !== 'stale' && callback) callback(currentLessonData);
     return outcome;
   };
 
   lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
     .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
       // Skip cache-only updates
       if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
         console.log('📚 Skipping cache-only snapshot, waiting for server data...');
         return;
       }
       console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
       if (!doc.exists) return;
 
       const myGeneration = ++globalListenerGeneration;
       // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
       // in their own collection, so carry their current maps across the swap
       // and let the reload below refresh each one (Phase 1, 1.4).
       const previousSummer = snapshotCampSeasons();
       // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
       // document once moved, so carry them across the swap like the camp seasons —
       // their own listeners below keep them current.
       const previousOwn = {};
       for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
       currentLessonData = doc.data();
       lastLegacyLessonData = doc.data();
       for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
       for (const semKey of OWN_DOC_SEMESTERS) {
         const token = bumpOwnDocToken(semKey);
         if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
           if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
         } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
           currentLessonData[semKey] = previousOwn[semKey];   // never blank it
           recheckOwnDocAfterLegacyLoss(semKey, callback, token);
         } else if (semKey in currentLessonData) {
           document.getElementById('storage-notice-banner')?.classList.add('hidden');
         }
       }
       console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
 
       const outcome = await reloadSummer(myGeneration, previousSummer, 0);
       // A superseded reload renders nothing — the newer snapshot's own
       // callback already did (or will), with the same live object. A failed
       // one still renders: the non-summer semesters in this snapshot are new.
       if (outcome !== 'stale' && callback) callback(currentLessonData);
     });
 
   // Own-doc semesters: one listener per document, plus the migration record.
   // They never bump globalListenerGeneration and never touch
   // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
   // only that semester unwritable.
   ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
     .onSnapshot(snap => {
       if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
       storageMigrationState = snap.exists ? (snap.data() || {}) : {};
       updateOwnDocPausedNotice();
     }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));
   for (const semKey of OWN_DOC_SEMESTERS) {
     ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
       .onSnapshot({ includeMetadataChanges: false }, snap => {
         if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
         bumpOwnDocToken(semKey);
         if (snap.exists) {
           ownDocSource[semKey] = 'ownDoc';
@@ -2309,164 +2323,166 @@ function dayOffPlanHasUserData(plan) {
   // A camp's sign-off record is never "user data" — it never blocks removal.
   return false;
 }
 
 function dayOffLessonKey(yearKey, campId, projectTitle) { return `${yearKey}|||${campId}|||${projectTitle}`; }
 function dayOffPlanDocId(yearKey, campId, projectTitle) { return encodeFirestoreKey(dayOffLessonKey(yearKey, campId, projectTitle)); }
 
 function dayOffHeadcount(camp) {
   return (camp?.placements || []).reduce((sum, p) => sum + (Number.isInteger(p?.capacity) ? p.capacity : 0), 0);
 }
 
 // Each camp's plannable titles, in first-seen order across its days, with the
 // position each first appears at (display-only "block").
 function dayOffCampTitles(camp) {
   const seen = new Map();
   for (const date of camp?.dates || []) {
     const day = normaliseDayOffDayBlocks(camp?.projects?.[date]);
     for (const { key, label } of SDOC_BLOCKS) {
       const title = day[key];
       if (!title || isDayOffNoPlanTitle(title) || seen.has(title)) continue;
       seen.set(title, label);
     }
   }
   return seen;
 }
 
 // The in-memory slot map for one year: one slot per camp-project, scaffold
 // from the event + camp, saved fields from the plan doc (Phase 2 writes them).
 function buildDayOffSlots(yearKey, events, camps, plans = {}) {
   const eventsById = Object.fromEntries((events || []).map(e => [e.id, e]));
   const slots = {};
   for (const camp of camps || []) {
     const event = eventsById[camp.eventId] || {};
     const teachers = Array.isArray(camp.teachers) ? camp.teachers : [];
     for (const [projectTitle, blockLabel] of dayOffCampTitles(camp)) {
       const lessonKey = dayOffLessonKey(yearKey, camp.id, projectTitle);
       slots[lessonKey] = {
         ...(plans[lessonKey] || {}),
         yearKey,
         eventId: camp.eventId,
         eventLabel: event.label || '',
         dates: camp.dates || [],
         campId: camp.id,
         campName: camp.title || '',
         timeSlot: camp.timeSlot || '',
         timeLabel: camp.timeLabel || '',
         location: camp.location || '',
         placements: camp.placements || [],
         classSize: String(dayOffHeadcount(camp)),
         teachers,
         teacher: teachers.join(' + '),
         block: blockLabel,
         projectTitle,
         hasDetails: true,
         materialsList: plans[lessonKey]?.materialsList || [],
       };
     }
   }
   return slots;
 }
 
 function sortDayOffEvents(events) {
   return [...events].sort((a, b) => String(a.dates?.[0] || '').localeCompare(String(b.dates?.[0] || '')) || String(a.label || '').localeCompare(String(b.label || '')));
 }
 
 function dayOffQuery(coll, field, value) {
   return curriculumDb.collection(DAY_OFF_COLLECTIONS[coll]).where(field, '==', value);
 }
 async function dayOffServerDocs(coll, field, value) {
   const snap = await dayOffQuery(coll, field, value).get({ source: 'server' });
   return snap.docs.map(d => ({ id: d.id, ...d.data() }));
 }
 
 // Three single-field equality queries — no composite index. A permission error
 // (or any failure) throws, so the caller trips the app-wide load guard.
 async function loadDayOffCampData({ yearKey, isCurrent = () => true } = {}) {
   if (!curriculumDb) initCurriculumFirestore();
   // Read BEFORE the queries: any plan verified after this point is newer than
   // what they return (Phase 2B — a reload must not undo a verified save).
   const startSeq = dayOffInstallSeq;
+  // Server reads (Phase 3, Christie's yes Sep 29): offline, the load fails and
+  // trips the guard instead of serving a cached or empty year as editable.
   const [eventSnap, campSnap, planSnap] = await Promise.all([
-    dayOffQuery('events', 'yearKey', yearKey).get(),
-    dayOffQuery('camps', 'yearKey', yearKey).get(),
-    dayOffQuery('plans', 'yearKey', yearKey).get(),
+    dayOffQuery('events', 'yearKey', yearKey).get({ source: 'server' }),
+    dayOffQuery('camps', 'yearKey', yearKey).get({ source: 'server' }),
+    dayOffQuery('plans', 'yearKey', yearKey).get({ source: 'server' }),
   ]);
   const events = sortDayOffEvents(eventSnap.docs.map(d => ({ id: d.id, ...d.data() })));
   const camps = campSnap.docs.map(d => ({ id: d.id, ...d.data() }));
   const plans = {};
   const signoffs = {};
   planSnap.docs.forEach(d => {
     const p = d.data();
     if (isDayOffSignoffDoc(p)) { signoffs[p.campId] = p; return; }   // never a plan, never a slot
     plans[dayOffLessonKey(yearKey, p.campId, p.projectTitle)] = p;
   });
   const protectedKeys = new Set();
   for (const [key, seq] of Object.entries(dayOffVerifiedAt[yearKey] || {})) {
     const verified = currentDayOffPlans[yearKey]?.[key];
     if (seq > startSeq && verified) { plans[key] = verified; protectedKeys.add(key); }
   }
   if (isCurrent()) {
     currentDayOffEvents[yearKey] = events;
     currentDayOffCamps[yearKey] = camps;
     currentDayOffPlans[yearKey] = plans;
     currentDayOffSignoffs[yearKey] = signoffs;
   }
   const slots = buildDayOffSlots(yearKey, events, camps, plans);
   Object.defineProperty(slots, DAY_OFF_PROTECTED, { value: protectedKeys, enumerable: false });
   Object.defineProperty(slots, DAY_OFF_LOAD_START, { value: startSeq, enumerable: false });
   return slots;
 }
 
 function rebuildDayOffSlots(yearKey) {
   if (!currentLessonData) currentLessonData = {};
   currentLessonData[yearKey] = buildDayOffSlots(yearKey, currentDayOffEvents[yearKey], currentDayOffCamps[yearKey], currentDayOffPlans[yearKey]);
 }
 
 // ─── Validation (pure — the tests call these directly too) ─────────────────
 
 function trimOrEmpty(v) { return typeof v === 'string' ? v.trim() : ''; }
 
 function normaliseDayOffEvent(input) {
   return {
     label: trimOrEmpty(input.label),
     dates: [...new Set((input.dates || []).map(d => String(d).trim()))].sort(),
     rawDates: (input.dates || []).map(d => String(d).trim()),
     district: trimOrEmpty(input.district),
     notes: trimOrEmpty(input.notes),
   };
 }
 
 function validateDayOffEvent(year, ev, otherEvents = []) {
   const problems = [];
   if (!ev.label) problems.push('Give the event a name (e.g. "Thanksgiving Break").');
   if (ev.dates.length === 0) problems.push('Pick at least one date.');
   if (ev.rawDates.length !== ev.dates.length) problems.push('A date is listed twice.');
   const bad = ev.rawDates.filter(d => !isIsoDate(d));
   if (bad.length) problems.push(`Not a valid date: ${bad.join(', ')}.`);
   const outside = ev.dates.filter(d => isIsoDate(d) && (d < year.startDate || d > year.endDate));
   if (outside.length) problems.push(`${outside.map(d => formatDayOffDate(d, { month: 'short', day: 'numeric', year: 'numeric' })).join(', ')} ${outside.length === 1 ? 'is' : 'are'} outside the school year (${year.startDate} – ${year.endDate}).`);
   if (ev.district && !SDOC_DISTRICTS.includes(ev.district)) problems.push(`District must be one of ${SDOC_DISTRICTS.join(', ')} (or blank).`);
   for (const other of otherEvents) {
     const clash = (other.dates || []).filter(d => ev.dates.includes(d));
     if (clash.length) problems.push(`${clash.map(d => formatDayOffDate(d)).join(', ')} ${clash.length === 1 ? 'is' : 'are'} already in "${other.label}".`);
   }
   return problems;
 }
 
 function normaliseDayOffCamp(input) {
   const dates = [...new Set((input.dates || []).map(d => String(d).trim()))].sort();
   const projects = {};
   for (const [date, day] of Object.entries(input.projects || {})) {
     projects[String(date).trim()] = normaliseDayOffDayBlocks(day);
   }
   return {
     eventId: trimOrEmpty(input.eventId),
     title: trimOrEmpty(input.title),
     timeSlot: trimOrEmpty(input.timeSlot),
     timeLabel: trimOrEmpty(input.timeLabel),
     location: trimOrEmpty(input.location),
     placements: (input.placements || []).map(p => ({
       studio: trimOrEmpty(p.studio),
       ageRange: trimOrEmpty(p.ageRange),
       capacity: typeof p.capacity === 'number' ? p.capacity : (String(p.capacity ?? '').trim() === '' ? NaN : Number(p.capacity)),
     })),
@@ -2810,166 +2826,170 @@ async function deleteDayOffCamp(yearKey, campId) {
   await curriculumDb.runTransaction(async (tx) => {
     const campTx = await tx.get(campRef);
     const snaps = [];
     for (const r of refs) snaps.push(await tx.get(r));
     // The camp must still have exactly the projects the refs were derived
     // from — a project another tab added since then has a record we did not
     // read (review HIGH).
     const titlesTx = campTx.exists ? [...dayOffCampTitles(campTx.data()).keys()] : [];
     if (stableJson(titlesTx) !== stableJson(titles)) {
       throw new DayOffValidationError(['This camp was changed in another tab — reload and try again. Nothing was removed.']);
     }
     const withData = snaps.filter(sn => sn.exists && dayOffPlanHasUserData(sn.data())).map(sn => sn.data().projectTitle);
     if (withData.length) {
       throw new DayOffValidationError([`It has projects with a plan or materials list: ${[...new Set(withData)].join(', ')}. Nothing was removed.`]);
     }
     tx.delete(campRef);
     snaps.forEach(sn => { if (sn.exists) tx.delete(sn.ref); });
   });
   currentDayOffCamps[yearKey] = (currentDayOffCamps[yearKey] || []).filter(c => c.id !== campId);
   const planMap = currentDayOffPlans[yearKey] || {};
   for (const k of Object.keys(planMap)) { if (planMap[k]?.campId === campId) delete planMap[k]; }
   if (currentDayOffSignoffs[yearKey]) delete currentDayOffSignoffs[yearKey][campId];
   rebuildDayOffSlots(yearKey);
   scheduleDayOffReload();
 }
 
 // ─── Phase 2B: teacher plans ────────────────────────────────────────────────
 // A teacher's plan is the camp-project's record in dayOffCamps_lessonData (the
 // same doc 2A's materials live on). The deployed rules let any classbook user
 // write any field there, so these allow-lists are what keep a plan save off
 // materialItems / materialChecks / identity (plan, round 1).
 const DAY_OFF_PLAN_WRITABLE = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
 const DAY_OFF_PLAN_CLEARABLE = [...CONTENT_FIELDS, 'photoUrl', 'photoPath'];
 const DAY_OFF_PROTECTED = Symbol('dayOffProtectedKeys');
 const DAY_OFF_LOAD_START = Symbol('dayOffLoadStartSeq');
 // After a reload merged an SDOC year: if any plan was verified after THIS
 // year's queries began — including while a later year was still loading, when
 // its protected set was already frozen (impl review) — rebuild the year's
 // slots from the plan map, which holds every verified copy.
 function healDayOffYearAfterReload(yearKey, loaded) {
   const startSeq = loaded?.[DAY_OFF_LOAD_START];
   if (startSeq == null) return;
   if (Object.values(dayOffVerifiedAt[yearKey] || {}).some(seq => seq > startSeq)) rebuildDayOffSlots(yearKey);
 }
 // Clock-free ordering of verified installs (plan, round 6): a reload keeps any
 // plan verified after its queries started.
 let dayOffInstallSeq = 0;
 const dayOffVerifiedAt = {};   // yearKey → { lessonKey: seq }
 
 function newDayOffEditId() {
   const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
   const buf = (typeof crypto !== 'undefined' && crypto.getRandomValues) ? crypto.getRandomValues(new Uint8Array(15)) : Array.from({ length: 15 }, () => Math.floor(Math.random() * 256));
   let id = 'e';
   for (const b of buf) id += chars[b % chars.length];
   return id;
 }
 
 // A server copy of a plan this tab has verified (opened fresh, or saved and
 // read back): installed, marked newer than any reload already in flight, slots
 // rebuilt — no reload scheduled (a teacher's autosaves must not each cost
 // three queries; plan, round 2).
 function dayOffInstallVerified(yearKey, lessonKey, data) {
   const map = currentDayOffPlans[yearKey] = currentDayOffPlans[yearKey] || {};
   if (data) map[lessonKey] = data; else delete map[lessonKey];
   (dayOffVerifiedAt[yearKey] = dayOffVerifiedAt[yearKey] || {})[lessonKey] = ++dayOffInstallSeq;
   rebuildDayOffSlots(yearKey);
 }
 
 // Which camp and project a plan key names — from the camp list itself, not the
 // slot map (a reload can briefly swap currentLessonData out from under a save).
 function dayOffFindProject(yearKey, lessonKey) {
   for (const camp of currentDayOffCamps[yearKey] || []) {
     for (const title of dayOffCampTitles(camp).keys()) {
       if (dayOffLessonKey(yearKey, camp.id, title) === lessonKey) return { campId: camp.id, projectTitle: title };
     }
   }
   return null;
 }
 
 // Fresh server copy of one plan, for the editor to open from (shared plans:
-// a co-teacher may have saved since this page loaded).
+// a co-teacher may have saved since this page loaded). Read inside a read-only
+// transaction (Phase 3, Christie "#1", Sep 30): a get({source:'server'}) can
+// answer with stale data after a Listen transport error (found in the Spring
+// storage move), and the editor would then save over newer text unawares.
 async function readDayOffPlanForEditor(yearKey, lessonKey) {
   const slot = dayOffFindProject(yearKey, lessonKey);
   if (!slot) return null;
   if (!curriculumDb) initCurriculumFirestore();
-  const snap = await curriculumDb.collection(DAY_OFF_COLLECTIONS.plans).doc(dayOffPlanDocId(yearKey, slot.campId, slot.projectTitle)).get({ source: 'server' });
+  const ref = curriculumDb.collection(DAY_OFF_COLLECTIONS.plans).doc(dayOffPlanDocId(yearKey, slot.campId, slot.projectTitle));
+  const snap = await curriculumDb.runTransaction(tx => tx.get(ref));
   dayOffInstallVerified(yearKey, lessonKey, snap.exists ? snap.data() : null);
   return currentLessonData[yearKey]?.[lessonKey] || null;
 }
 
 const DAY_OFF_RENAMED_MESSAGE = 'This project was renamed or removed by the planner — copy your text, close, and reopen the camp.';
 
 // saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
 //   'saved'      — my write is what the server holds;
 //   'savedSince' — my write landed, then someone saved over it (last write
 //                  wins; `by` names them, `own` = it was my own name);
 //   'renamed'    — landed, then the planner renamed the project (the rename
 //                  move carried the text to the new title);
 //   'noop'       — nothing changed, nothing written.
 // Throws on anything else (refusals, a real failed write).
 async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
   assertDayOffWritable();
   if (!auth || typeof auth !== 'object') throw new Error('An SDOC plan save needs dayOffAuth — refusing to save without the permission check.');
   const found = dayOffFindProject(yearKey, lessonKey);
   if (!found) throw new DayOffValidationError([DAY_OFF_RENAMED_MESSAGE]);
   const { campId, projectTitle } = found;
   if (lessonKey !== dayOffLessonKey(yearKey, campId, projectTitle)) throw new Error('This plan key does not match its camp and project — refusing to save.');
   if (isDayOffNoPlanTitle(projectTitle) || projectTitle === DAY_OFF_SIGNOFF_TITLE) throw new Error(`"${projectTitle}" has no plan — refusing to save.`);
 
   const extra = Object.keys(lessonData).filter(k => !DAY_OFF_PLAN_WRITABLE.includes(k));
   if (extra.length) throw new Error(`An SDOC plan save may not write ${extra.join(', ')} — refused.`);
   const badClears = fieldsToClear.filter(f => !DAY_OFF_PLAN_CLEARABLE.includes(f));
   if (badClears.length) throw new Error(`An SDOC plan save may not clear ${badClears.join(', ')} — refused.`);
   if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
 
   const payload = { ...lessonData };
   const clears = new Set(fieldsToClear);
   // The photo's URL and Storage path only ever change together — across the
   // payload AND the clears (a one-sided clear would leave a shown photo whose
   // object can never be cleaned up, or a dangling path; impl review). The
   // shared editor sends a removal as an empty pair; that becomes a real delete
   // of both fields, never two empty strings.
   const hasUrl = 'photoUrl' in payload, hasPath = 'photoPath' in payload;
   if (hasUrl !== hasPath || (hasUrl && !payload.photoUrl !== !payload.photoPath)
       || clears.has('photoUrl') !== clears.has('photoPath') || (hasUrl && clears.has('photoUrl'))) {
     throw new Error('photoUrl and photoPath must change together — refused.');
   }
   if (hasUrl && !payload.photoUrl) { delete payload.photoUrl; delete payload.photoPath; clears.add('photoUrl'); clears.add('photoPath'); }
 
   // Nothing changed → nothing written, nothing read back.
   if (!lessonHasContent(payload) && !('photoUrl' in payload) && !('planComplete' in payload) && clears.size === 0) return { status: 'noop' };
 
   CONTENT_FIELDS.forEach(f => { if (!payload[f] || !String(payload[f]).trim()) delete payload[f]; });
   const clean = JSON.parse(JSON.stringify(payload));
   for (const f of clears) delete clean[f];   // a clear wins over a value
   const editId = newDayOffEditId();          // once, before the transaction: a retry must not regenerate it
   const plansColl = curriculumDb.collection(DAY_OFF_COLLECTIONS.plans);
   const planRef = plansColl.doc(dayOffPlanDocId(yearKey, campId, projectTitle));
   const campRef = curriculumDb.collection(DAY_OFF_COLLECTIONS.camps).doc(campId);
   let identity;
   try {
     await curriculumDb.runTransaction(async (tx) => {
       // The camp read is the lock: a rename move or a removal writes the camp,
       // so a concurrent one forces this to retry, and the retry fails here.
       const campSnap = await tx.get(campRef);
       await tx.get(planRef);
       const camp = dayOffAssertCampHasTitle(campSnap, projectTitle);
       if (camp.yearKey !== yearKey) throw new Error('This camp belongs to a different school year — refused.');
       const onCamp = auth.hasClassbook && !!auth.myTeacherName && (camp.teachers || []).includes(auth.myTeacherName);
       if (!auth.canEditAnywhere && !onCamp) throw new DayOffValidationError(["You're no longer on this camp — your text is still in the form; copy it and reload."]);
       identity = { yearKey, eventId: camp.eventId, campId, projectTitle };
       const data = { ...clean };
       for (const f of clears) data[f] = firebase.firestore.FieldValue.delete();
       Object.assign(data, identity, { lastEditId: editId });
       tx.set(planRef, data, { merge: true });
     });
   } catch (err) {
     if (err instanceof DayOffValidationError && /no longer a project|was removed in another tab/.test(err.message)) {
       scheduleDayOffReload(0);   // so reopening the camp shows the new title
       throw new DayOffValidationError([DAY_OFF_RENAMED_MESSAGE]);
     }
     throw err;
   }
 
   const written = Object.fromEntries(Object.entries(clean).filter(([f]) => f !== 'lastEditedBy' && f !== 'lastEditedAt'));
   const server = await verifyDayOffPlanWrite(planRef, editId, written, [...clears], identity);

exec
/bin/zsh -lc "sed -n '608,706p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
<div class="phase" id="phase-3">
  <h3>Phase 3 — Planner's plan overview (status per project + per-event roll-up) — DESIGN, revision 5 (Sep 29, 2026, after review rounds 1–4; line numbers @ <code>2ef2e62</code>) — <span class="status-tag ready">execution-ready: true (design) — BUILD GATED on <code>classbook-per-semester-lesson-storage</code> landing</span></h3>
  <p><strong>Build sequencing (Christie, Sep 29):</strong> the design is finished now; the <em>build</em> waits until <code>classbook-per-semester-lesson-storage</code> has landed (another session, in progress) — it reworks the <code>curriculum/lessonData</code> listener and loads this design hooks into. Before building: re-verify every line reference and the listener/reload shape against that code, and run a short targeted review if it moved materially.</p>
  <p><strong>Re-verification against <code>132fef2</code> (Sep 30, after the storage move landed — PR #5).</strong> The design's line numbers above are pinned to <code>2ef2e62</code>; at build time use this map (<code>132fef2</code>): Teacher View's listener callback app.js:686-711 (SDOC branch 692-696; its load-guard exit 678-681); Curriculum Admin's callback 5114-5120; <code>initCurriculumAdmin()</code> 5091 (<code>caInitialized</code> 5092-5093), awaited at startup app.js:190, tab branch 220-221; <code>calculateLessonProgress()</code> 924, <code>getProgressLabel()</code> 943, <code>canEditDayOffPlan()</code> 622; <code>openPlanEditor()</code> 11639 (<code>canEdit</code> 11648), <code>finishClose</code> 12313; <code>renderDayOffAdmin()</code> 12647; firebase-data.js: <code>reloadSummerForModeChange()</code> 1310, unsubscribe 1319, gated failure path: catch 1351-1364 (<code>isCurrent()</code> 1353, retries 1356-1362, <code>return 'failed'</code> 1363), <code>summerReloadHook</code> 1369, the <code>lessonData</code> snapshot reload 1376-1416, <code>isIsoDate()</code> 2264, <code>dayOffCampTitles()</code> 2322, <code>dayOffServerDocs()</code> 2377, <code>loadDayOffCampData()</code> 2384. None of these functions' bodies changed except <code>setGlobalSemester()</code> and startup (one <code>updateOwnDocPausedNotice()</code> line each) and <code>renderDayOffAdmin()</code>, whose camp/event buttons now use <code>escForOnclick()</code> (PR #3) — harmless for Phase 3 (round 6, Claude LOW). <strong>What did change, and how Phase 3 meets it:</strong> (1) <em>Spring's own-document listeners</em> (firebase-data.js:1420-1457) and <code>recheckOwnDocAfterLegacyLoss()</code> now also call the listener's <code>callback</code> — without a summer/SDOC reload. With the shared <code>onLessonDataReload()</code> they simply redraw each initialised view, as they do today for the owning view; they install no SDOC data, so the stamp and <code>dayOffRefreshFailed</code> don't move (both change only in the gated reload). Re-registering tears the own-doc listeners down and re-adds them (1321) — unchanged by Phase 3, since it keeps the two registration sites. (2) <em>A <code>get({source:'server'})</code> can return stale data after a Listen-stream transport error</em> (found in the storage move's Phase C, Sep 30). Phase 3's SDOC queries can't use a transaction (queries aren't transactional in this SDK), so the overview accepts it as a <strong>known limitation</strong>: in that rare case the list can show older statuses under a fresh "Last full refresh" time until the next refresh or reload corrects it. For the overview itself it is display-only (Phase 3 writes nothing). <strong>Correction (round 6, both MEDIUM): the 2B editor is NOT covered.</strong> Its open read, <code>readDayOffPlanForEditor()</code> (firebase-data.js:2891-2897), is the same <code>get({source:'server'})</code> and marks the copy verified (<code>dayOffInstallVerified()</code>); the save transaction (2940-2965) re-reads the plan but never compares it with the opened version and writes with <code>merge: true</code>, and <code>verifyDayOffPlanWrite()</code> only confirms its own <code>lastEditId</code>. So a stale open lets a teacher save over a co-teacher's newer text with a plain "Saved" — the "edited since" notice can't fire. This is a <em>live 2B gap</em>, not new in Phase 3, but Phase 3's Open plan is one more way into that editor. <strong>Fix — in the Phase 3 build (Christie, Sep 30: "#1"):</strong> open the plan with a read-only <code>runTransaction(tx =&gt; tx.get(planRef))</code> — single-document transactional reads are always fresh, the storage move's own lesson — with no change to the save path. And <code>source: 'server'</code> still delivers what Christie approved it for (a failed read trips the guard instead of showing a cached or empty year as editable). (3) <code>escForOnclick()</code> now exists (PR #3, app.js:8283); Phase 3 still puts the plan key in a <code>data-</code> attribute and binds the handler in code, so no inline handler value is added.</p>
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
  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
  <p><strong>Lifecycle (round 1, both).</strong> <code>initCurriculumAdmin()</code> runs once per page load (app.js:5015-5016), so the two automatic call sites are named: the tab-click handler's <code>curriculum-admin</code> branch (app.js:218-219) calls <code>refreshDayOffYear()</code> when Curriculum Admin is already initialised and the admin year is SDOC; and <code>setGlobalSemester()</code>'s <code>curriculum-admin</code> branch (app.js:132-138) does the same when switching <em>to</em> an SDOC year. Never from <code>renderAdminGrid()</code> (it runs after every tick); the button is disabled while a refresh is in flight.</p>
  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw. <em>Build notes (round 5, Claude LOW):</em> wrap each branch of <code>onLessonDataReload()</code> in its own try/catch (log and continue) so a throw in Teacher View's redraw can't skip the admin redraw; <code>tvInitialized</code> is also true during Teacher View's own <code>await loadLessonData()</code> (app.js:657→661) — harmless, it converges through the existing empty-picker reset (app.js:690-696).</p>
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
Then: without pressing Refresh, the SDOC list redraws and its stamp moves; the weekly grid shows the other device's change

Given: startup's Curriculum Admin initialisation is held open (its change-log load delayed), Christie clicks Teacher View, it builds, then Curriculum Admin finishes and registers
When: a snapshot-triggered reload arrives while Teacher View is showing
Then: Teacher View redraws with the new data, and the admin grid redraws too (spy: both render once)</div>
  <p><strong>Tests (emulator, red first):</strong> new cases P1–P8 in <code>e2e/day-off-camps.spec.js</code> or a new <code>e2e/day-off-overview.spec.js</code> (planner + prep sessions; a direct write stands in for the teacher's other-device save); write spy on render and refresh; full suite before the dual implementation review.</p>
  <p><strong>Not in 3:</strong> the "not started, camp soon" warning (offered, declined for now); filtering or sorting by status; emailing teachers.</p>
</div>


exec
/bin/zsh -lc 'git diff --unified=45 132fef2 c7400df -- js/app.js' in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-JcRHXF1Y' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-SeclgJTo' (errno=Operation not permitted)
diff --git a/js/app.js b/js/app.js
index f5dce8c..82e0946 100644
--- a/js/app.js
+++ b/js/app.js
@@ -54,212 +54,217 @@ function initGlobalSemesterSelector() {
   const isAdmin = user && ['admin', 'manager'].includes(user.role);
   const semesters = currentConfig.semesters;
   const keys = Object.keys(semesters);
 
   // Filter semesters: canSeeSemester() — manager+ all; others published, plus
   // an unpublished SDOC year for the prep team (Phase 2A).
   const visibleKeys = keys.filter(canSeeSemester);
 
   // Set initial global semester if not set — or if the remembered one is not
   // visible to THIS user (a shared device where a manager last picked a draft
   // semester must not leave a teacher inside it — review).
   if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
     // …and the fallback must be visible too (review: an unpublished active
     // semester would otherwise put the teacher straight back inside it).
     globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
     localStorage.setItem('globalSemesterKey', globalSemesterKey);
   }
 
   // Populate dropdown
   let html = '';
   for (const key of visibleKeys) {
     const sem = semesters[key];
     const isActive = key === currentConfig.activeSemester;
     const isDraft = sem.published === false;
     let label = sem.name;
     if (isActive) label += ' (active)';
     if (isDraft && isAdmin) label += ' [draft]';
     html += `<option value="${escAttr(key)}" ${key === globalSemesterKey ? 'selected' : ''}>${escHtml(String(label ?? ''))}</option>`;
   }
   select.innerHTML = html;
 
   // Handle changes
   select.addEventListener('change', () => {
     setGlobalSemester(select.value);
   });
 
   // Show user name
   if (userSpan && user) {
     userSpan.textContent = user.name || user.email;
   }
 }
 
 function setGlobalSemester(key) {
   if (!currentConfig?.semesters?.[key]) return;
 
+  const previousKey = globalSemesterKey;
   globalSemesterKey = key;
   localStorage.setItem('globalSemesterKey', key);
   updateOwnDocPausedNotice();   // Spring 2026 storage move: standing "editing is paused" notice
 
   // Hide/show Prep Dashboard tab based on semester type
   const semester = currentConfig.semesters[key];
   const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   if (prepDashboardTab) {
     if (!isWeeklySemester(key)) {   // camp seasons and SDOC years have no prep dashboard
       prepDashboardTab.style.display = 'none';
       // If currently on Prep Dashboard, switch to Teacher View
       if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
         switchTab('teacher-view');
         return; // Exit early since switchTab will handle the rest
       }
     } else {
       prepDashboardTab.style.display = '';
     }
   }
 
   // Hide/show Curriculum Admin tab for non-manager users on summer semesters
   updateCurriculumAdminTab();
 
   // Refresh all tabs to use new semester
   const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
 
   if (activeTab === 'teacher-view') {
     renderTvSemesterSelector();
     renderProgressDashboard();
     renderQaActivityPanel();
     updateClassFilter(); // Update class dropdown for new semester
     renderTeacherView();
   } else if (activeTab === 'prep-dashboard') {
     const weekNum = document.getElementById('week-select')?.value || 1;
     loadWeekData(parseInt(weekNum));
   } else if (activeTab === 'curriculum-admin') {
     renderSemesterSelector();
     renderAdminGrid();
     renderHelpQueue();
     renderCutBank();
     renderIdeaBank();
     renderChangeHistory();
+    // Switching TO an SDOC year re-reads it for the overview (Phase 3).
+    if (key !== previousKey && isDayOffYear(key) && caInitialized) refreshDayOffYear(key);
   } else if (activeTab === 'settings') {
     loadSettingsForm();
   }
 }
 
 // ─── Initialization ─────────────────────────────────
 
 document.addEventListener('DOMContentLoaded', async () => {
   const user = await requireAuth();
   if (!user) return;
 
   initCurriculumFirestore();
   await loadConfig();
   // A failed config read is fatal to the whole app by design (Phase 1, 1.2) —
   // nothing below can be trusted, and loadLessonData() must not run.
   if (configLoadFailed) return;
   await loadPrepData();
 
   initGlobalSemesterSelector();
 
   // Decide how the shared summer collections may be read BEFORE anything reads
   // them (Phase 1, 1.3): a forced-server read of the registry's switch, then a
   // listener — never awaited — so this tab follows the Summer Camp App
   // switching seasons on, and heals if it started offline.
   await loadSeasonRegistryMode();
   watchSeasonRegistry({
     onModeChange: () => { reloadSummerForModeChange(); },
   });
 
   // Pre-load lesson data on startup so any load failure is detected immediately
   await loadLessonData();
   updateOwnDocPausedNotice();   // Spring 2026 storage move: standing notice if the selected semester is paused
   if (lessonDataLoadedSuccessfully === false) {
     document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   }
 
   // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
   const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
   const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
     prepDashboardTab.style.display = 'none';
   }
 
   setupTabs();
   setupRoleAccess();
   setupFooter();
   loadSettingsForm();
 
   // Initialize Curriculum Admin (default tab)
   await initCurriculumAdmin();
 
   // Real-time sync for prep data
   setupPrepDataListener(onPrepDataChange);
 });
 
 // ─── Tab Navigation ─────────────────────────────────
 
 let lastDiagFingerprint = null;  // Track which diagnostic item we navigated from
 
 function switchTab(tabId) {
   const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
   if (btn) btn.click();
 }
 
 function setupTabs() {
   document.querySelectorAll('.tab-btn').forEach(btn => {
     btn.addEventListener('click', () => {
       const tabId = btn.dataset.tab;
 
       document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
       btn.classList.add('active');
 
       document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
       document.getElementById(tabId)?.classList.add('active');
 
       if (tabId === 'teacher-view') {
         initTeacherView();
       } else if (tabId === 'prep-dashboard') {
         initPrepDashboard();
       } else if (tabId === 'curriculum-admin') {
+        // Already built: an SDOC year's overview re-reads on every return (Phase 3).
+        if (caInitialized && isDayOffYear(getAdminSemKey())) refreshDayOffYear(getAdminSemKey());
         initCurriculumAdmin();
       } else if (tabId === 'settings') {
         ensureSettingsFormMatchesHeader();
       }
       if (tabId === 'settings' && lastDiagFingerprint) {
         // Scroll back to the diagnostic item we came from
         setTimeout(() => {
           scrollToDiagItem(lastDiagFingerprint);
           lastDiagFingerprint = null;
         }, 100);
       }
     });
   });
 }
 
 function scrollToDiagItem(fingerprint) {
   // Find the diagnostic item by its fingerprint (stored on dismiss/undismiss/note buttons)
   const allBtns = document.querySelectorAll(`[data-fp="${CSS.escape(fingerprint)}"]`);
   if (allBtns.length === 0) return;
   // Find the parent .diag-item
   const item = allBtns[0].closest('.diag-item');
   if (!item) return;
   item.scrollIntoView({ behavior: 'smooth', block: 'center' });
   item.classList.add('diag-highlight-flash');
   setTimeout(() => item.classList.remove('diag-highlight-flash'), 2000);
 }
 
 // ─── Role-Based Access ──────────────────────────────
 
 function hasCurriculumAdminAccess() {
   const user = getAuthUser();
   if (!user) return false;
   // Admin or manager role = full access to everything
   if (user.role === 'admin' || user.role === 'manager') return true;
   // Or explicit curriculum-admin permission in appAccess array
   return user.appAccess && (user.appAccess.includes('curriculum-admin') || user.appAccess.includes('classbook-admin'));
 }
 
 // ─── School Day Off Camps capabilities (Phase 2A) — each mirrors the rules ───
 // Planners: the rules' event/camp write condition (manager+ or classbook-admin).
 // NOT hasCurriculumAdminAccess(): it includes the legacy curriculum-admin key,
 // which the SDOC rules deliberately deny.
 function canPlanDayOffCamps() {
   const user = getAuthUser();
   if (!user) return false;
@@ -615,143 +620,160 @@ function getDayOffTeacherNameForCurrentUser(yearKey) {
 function dayOffAuthFor(yearKey) {
   return {
     canEditAnywhere: canTickDayOffMaterials(),   // planners, and prep (Kathy/Allie) with classbook — Christie, Sep 25
     hasClassbook: !!getAuthUser()?.appAccess?.includes('classbook'),
     myTeacherName: getDayOffTeacherNameForCurrentUser(yearKey),
   };
 }
 function canEditDayOffPlan(slot) {
   const a = dayOffAuthFor(slot?.yearKey || getTvSemKey());
   return a.canEditAnywhere || (a.hasClassbook && !!a.myTeacherName && (slot?.teachers || []).includes(a.myTeacherName));
 }
 
 // The dates of the camp on which this plan's title runs.
 function dayOffTitleDates(yearKey, slot) {
   const camp = (currentDayOffCamps[yearKey] || []).find(c => c.id === slot?.campId);
   return (camp?.dates || []).filter(d => Object.values(normaliseDayOffDayBlocks(camp.projects?.[d])).includes(slot.projectTitle));
 }
 
 let tvInitialized = false;
 let tvCurrentView = 'my-schedule';
 // By Week / By Class sections start collapsed (except the current week in By
 // Week); whatever a teacher opens or closes stays that way across re-renders
 // (e.g. ticking Plan Complete) for the rest of the visit.
 const tvExpandedSections = new Set();
 const tvToggledSections = new Set();
 let tvCurrentTeacher = '';
 let tvCurrentClassFilter = 'all';
 let tvNavStack = [];  // Stack of { teacher, classFilter, scrollY } for back navigation
 let campCompleteData = {};
 
 function getTvSemKey() {
   // Now uses global semester instead of per-tab selection
   return getActiveSemesterKey();
 }
 
 function isCoTeacherForCurrentSemester() {
   const user = getAuthUser();
   if (!user || tvCurrentTeacher) return false;
   const semKey = getTvSemKey();
   const lessons = currentLessonData?.[semKey];
   return !!lessons && Object.values(lessons).some(l =>
     Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
   );
 }
 
+// Teacher View's part of every lesson-data reload (its old listener callback).
+function teacherViewOnReload() {
+  renderProgressDashboard();
+  // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
+  // no sharedWith — so re-render on every reload while the year is showing
+  // (the list and the teacher picker are rebuilt from the camps each time).
+  if (isDayOffYear(getTvSemKey())) {
+    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
+    return;
+  }
+  // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
+  const semKey = getTvSemKey();
+  const lessons = currentLessonData?.[semKey];
+  if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
+    const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
+    if (!hasTeachers) {
+      tvInitialized = false;
+      initTeacherView();
+    }
+  }
+  // Skip re-render while a camp is expanded — preserves expanded state on live data updates
+  const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
+  if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
+}
+
+// The ONE lesson-data listener callback (SDOC Phase 3). There is one listener
+// and both Teacher View and Curriculum Admin register it; with a callback each,
+// whichever registered last owned every redraw and the other view went stale
+// (after one Teacher View visit, Curriculum Admin stopped redrawing — and a
+// startup race could do the reverse). Each branch is what that view's own
+// callback did on every tick; each is isolated so one throwing can't skip the other.
+function onLessonDataReload(data) {
+  currentLessonData = data;
+  if (tvInitialized) {
+    try { teacherViewOnReload(); } catch (err) { console.error('Teacher View redraw after reload failed:', err); }
+  }
+  if (caInitialized) {
+    try { renderAdminGrid(); renderHelpQueue(); } catch (err) { console.error('Curriculum Admin redraw after reload failed:', err); }
+  }
+  // Refresh teacher mapping table in Settings if it exists
+  try { renderTeacherMappingTable(); } catch (err) { console.error('Teacher mapping redraw after reload failed:', err); }
+}
+
 async function initTeacherView() {
   // Already built: the semester may have changed on another tab — refresh for
   // it (renderTeacherView handles SDOC, and leaving SDOC, itself).
   if (tvInitialized) {
     if (isDayOffYear(getTvSemKey()) || tvTeacherListFor) { renderTvSemesterSelector(); renderQaActivityPanel(); renderTeacherView(); }
     return;
   }
   tvInitialized = true;
 
   // Load lesson data if not already loaded
   if (!currentLessonData) {
     await loadLessonData();
   }
 
   // Show banner and abort if load failed — prevents stale blank data from being saved.
   // Not "initialized": the guard can trip transiently now (a listener reload
   // that fails and self-heals — Backtracking audit Phase 7), and the next
   // visit to this tab must be allowed to build it.
   if (lessonDataLoadedSuccessfully === false) {
     tvInitialized = false;
     document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
     return;
   }
 
   // Set up real-time listener FIRST so the retry mechanism fires even if
   // summer camp data isn't ready yet when we reach the early-return below.
-  setupLessonDataListener((data) => {
-    currentLessonData = data;
-    renderProgressDashboard();
-    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
-    // no sharedWith — so re-render on every reload while the year is showing
-    // (the list and the teacher picker are rebuilt from the camps each time).
-    if (isDayOffYear(getTvSemKey())) {
-      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
-      renderTeacherMappingTable();
-      return;
-    }
-    // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
-    const semKey = getTvSemKey();
-    const lessons = currentLessonData?.[semKey];
-    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
-      const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
-      if (!hasTeachers) {
-        tvInitialized = false;
-        initTeacherView();
-      }
-    }
-    // Skip re-render while a camp is expanded — preserves expanded state on live data updates
-    const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
-    if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
-    // Refresh teacher mapping table in Settings if it exists
-    renderTeacherMappingTable();
-  });
+  setupLessonDataListener(onLessonDataReload);
 
   // Build semester selector (only show if multiple published semesters)
   renderTvSemesterSelector();
 
   const semKey = getTvSemKey();
   const lessons = currentLessonData?.[semKey];
 
   // Before the empty-map "Loading…" branch below — an SDOC year with no camps
   // (or only empty blocks) is an empty map and would otherwise say "Loading"
   // forever. Initialized like any other type (Phase 2B): the listener above is
   // subscribed once, and the controls are bound once; renderTeacherView()
   // builds the SDOC teacher list itself.
   if (isDayOffYear(semKey)) {
     bindTeacherViewControlsOnce();
     renderTeacherView();
     return;
   }
 
   if (!lessons || Object.keys(lessons).length === 0) {
     document.getElementById('tv-content').innerHTML =
       '<div class="tv-placeholder">Loading teacher data…</div>';
     return;
   }
 
   // Build teacher list from lesson data
   populateTvTeacherList(lessons);
 
   // Auto-select teacher for staff users who have a matched teacher name
   const teacherSelect = document.getElementById('tv-teacher-select');
   const matchedTeacher = getTeacherNameForCurrentUser();
   const teachers = [...new Set(Object.values(lessons).map(l => l.teacher).filter(Boolean))].sort();
 
   let selectedTeacher = null;
   if (matchedTeacher && teachers.includes(matchedTeacher)) {
     selectedTeacher = matchedTeacher;
   }
 
   if (selectedTeacher) {
     teacherSelect.value = selectedTeacher;
     tvCurrentTeacher = selectedTeacher;
     updateClassFilter();
     renderTeacherView();
   } else if (!tvCurrentTeacher) {
     if (isCoTeacherForCurrentSemester()) {
       renderTeacherView();
@@ -5068,98 +5090,92 @@ async function createNewSemester() {
     if (lessonDataCommitted) {
       try {
         await deleteLessonData(key);
       } catch (cleanupErr) {
         console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
       }
     }
     alert('Could not create the new semester. Please try again.');
     return;
   } finally {
     creatingSemester = false;
   }
 
   closeNewSemesterModal();
   caCurrentSemester = key;
   renderSemesterSelector();
   renderAdminGrid();
   renderHelpQueue();
   renderCutBank();
   renderIdeaBank();
   renderChangeHistory();
 }
 
 async function initCurriculumAdmin() {
   if (caInitialized) return;
   caInitialized = true;
 
   if (!currentLessonData) await loadLessonData();
   if (!currentChangeLog) await loadChangeLog();
   if (!currentCutProjects) await loadCutProjects();
   if (!currentFutureProjects) await loadFutureProjects();
 
   renderSemesterSelector();
   renderAdminGrid();
   renderHelpQueue();
   renderCutBank();
   renderIdeaBank();
   renderChangeHistory();
 
   // Modal close
   document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
   document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
     if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
   });
 
-  // Real-time updates
-  setupLessonDataListener((data) => {
-    currentLessonData = data;
-    renderAdminGrid();
-    renderHelpQueue();
-    // Refresh teacher mapping table in Settings if it exists
-    renderTeacherMappingTable();
-  });
+  // Real-time updates — the same callback Teacher View registers (Phase 3)
+  setupLessonDataListener(onLessonDataReload);
 }
 
 function renderAdminGrid() {
   const wrapper = document.getElementById('ca-grid-wrapper');
   const semKey = getAdminSemKey();
   const lessons = currentLessonData?.[semKey];
 
   // School Day Off Camps years: the event/camp planning list (Phase 1).
   if (isDayOffYear(semKey)) {
     document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
     renderDayOffAdmin(semKey);
     return;
   }
   // Camp seasons get their own view instead of the weekly curriculum grid
   if (isCampSeason(semKey)) {
     document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
     renderSummerCA(lessons);
     return;
   }
   document.querySelector('.ca-grid-hint')?.style.removeProperty('display');
 
   const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
   const numWeeks = semester?.numWeeks || 16;
   const breakWeeks = semester?.breakWeeks || [];
   const currentWeek = semKey === getActiveSemesterKey() ? getCurrentWeekNum() : null;
 
   if (!lessons || Object.keys(lessons).length === 0) {
     wrapper.innerHTML = `<div class="tv-placeholder">${semKey === getActiveSemesterKey()
       ? 'No lesson data. Set up the class roster in Settings to create lesson slots.'
       : 'No lesson data for this semester yet. Import lessons or paste from Cut/Idea Bank.'}</div>`;
     return;
   }
 
   // Build teacher+class combos
   const combos = {};
   for (const [key, lesson] of Object.entries(lessons)) {
     const comboKey = `${lesson.teacher}|||${lesson.className}`;
     if (!combos[comboKey]) {
       combos[comboKey] = { teacher: lesson.teacher, className: lesson.className, weeks: {} };
     }
     combos[comboKey].weeks[lesson.weekNum] = { key, ...lesson };
   }
 
   const sortedCombos = Object.values(combos).sort((a, b) => {
     const da = getDayOrder(a.className);
@@ -11603,91 +11619,92 @@ function openLessonModal(campName, projectTitle, block) {
   // Find lesson for the current teacher first — shared camps (teacher = "A + B") generate
   // separate slots per teacher with the same campName/projectTitle/block, so we must
   // find the slot belonging to tvCurrentTeacher to save to the right doc ID.
   let lessonKey = null;
   let lesson = null;
   for (const [key, l] of Object.entries(lessons)) {
     if (l.campName === campName && l.projectTitle === projectTitle && l.block === block) {
       if (l.teacher === tvCurrentTeacher) {
         lessonKey = key;
         lesson = l;
         break; // exact match for current teacher
       }
       if (!lessonKey) {
         lessonKey = key; // fallback (admin viewing another teacher's slot)
         lesson = l;
       }
     }
   }
 
   if (!lesson) {
     alert('Lesson not found');
     return;
   }
 
   markQaAsRead(lessonKey);
   return openPlanEditor(semKey, lessonKey, { onClosed: () => restoreSummerCampExpansion(campName, projectTitle, block) });
 }
 
 // The plan editor's shared body (SDOC Phase 2B split): the summer entry point
 // above resolves a lessonKey from camp/project/block; the SDOC list calls this
 // directly with the plan key. For an SDOC year the plan is read fresh from the
 // server first (a co-teacher may have saved since this page loaded), and a
 // handful of pieces differ — materials from the planner's list, no Q&A, no
 // Print, no reference section, no backdrop close, and a read-only mode for
 // people who can see but not edit. The save chain, dirty-diff, close-wait
 // and failure revert are the same code for both.
 async function openPlanEditor(semKey, lessonKey, { onClosed = null } = {}) {
   const sdoc = isDayOffYear(semKey);
   if (sdoc) {
     try { await readDayOffPlanForEditor(semKey, lessonKey); }
     catch (err) { alert(`Couldn't open this plan — ${err.message}`); return; }
   }
   let lesson = currentLessonData?.[semKey]?.[lessonKey];
   if (!lesson) { alert(sdoc ? DAY_OFF_RENAMED_MESSAGE : 'Lesson not found'); return; }
   const { campName, projectTitle, block } = lesson;
-  const canEdit = sdoc ? canEditDayOffPlan(lesson) : true;   // summer: canEditLesson() gates each save, as before
+  // SDOC: read-only while the load guard is tripped (Phase 3) — its save refuses anyway.
+  const canEdit = sdoc ? (canEditDayOffPlan(lesson) && lessonDataLoadedSuccessfully !== false) : true;   // summer: canEditLesson() gates each save, as before
 
   // Remove existing modal
   document.getElementById('summer-lesson-modal')?.remove();
 
   const modal = document.createElement('div');
   modal.id = 'summer-lesson-modal';
   modal.className = 'te-modal-overlay';
 
   // Build materials table HTML
   let materialsHtml = '';
   if (lesson.materialsList && lesson.materialsList.length > 0) {
     materialsHtml = `<table class="materials-table">
       <thead><tr><th>Material</th><th>Qty/Camper</th><th>Prep Category</th><th>How to Prep</th></tr></thead>
       <tbody>`;
     for (const m of lesson.materialsList) {
       materialsHtml += `<tr>
         <td>${escHtml(m.name || '')}</td>
         <td>${escHtml(m.qtyPerCamper || '')}</td>
         <td>${escHtml(m.prepCategory || '')}</td>
         <td>${escHtml(m.howToPrep || '')}</td>
       </tr>`;
     }
     materialsHtml += '</tbody></table>';
   }
 
   const headcount = Number(lesson.classSize) || 0;
   const sdocItems = sdoc ? dayOffSortedItems(lesson) : [];
   // Phase 2C: the planner's vision + inspo links. The vision is escaped with
   // line breaks and never auto-linked; links only if they parse as http(s).
   // Stored values are treated as hostile (any classbook user may write this
   // record): only a string vision and an array of links are shown.
   const aboutText = sdoc && typeof lesson.projectDetails === 'string' ? lesson.projectDetails.trim() : '';
   const aboutLinks = sdoc && Array.isArray(lesson.projectLinks) ? lesson.projectLinks : [];
   const sdocAboutHtml = !aboutText && !aboutLinks.length ? '' : `
         <div class="field-group sdoc-editor-about">
           <label>About this project</label>
           ${aboutText ? `<div class="field-text">${sdocEsc(aboutText).replace(/\n/g, '<br>')}</div>` : ''}
           ${aboutLinks.length ? `<ul class="sdoc-details-links">${aboutLinks.map(dayOffLinkHtml).join('')}</ul>` : ''}
         </div>`;
   const sdocMaterialsHtml = !sdoc ? '' : `
         <div class="field-group sdoc-editor-materials">
           <label>Materials (from the planner — headcount ${headcount})</label>
           ${sdocItems.length ? `<table class="materials-table">
             <thead><tr><th>Material</th><th>Total</th><th>Per</th><th>Size / specs</th><th>Notes</th></tr></thead>
             <tbody>${sdocItems.map(it => `<tr><td>${sdocEsc(it.name)}</td><td>${sdocEsc(dayOffItemTotal(it, headcount))}</td><td>${sdocEsc(it.scope)}</td><td>${sdocEsc(it.size)}</td><td>${sdocEsc(it.notes)}</td></tr>`).join('')}</tbody>
@@ -12602,158 +12619,259 @@ function generateSummerPrintOutput(campName, projects, allCampLessons) {
     printHtml += `<div class="lesson-footer">Tinker Art Studio — Summer Camp — ${esc(campName)} — ${esc(lesson.teacher)}</div>`;
     printHtml += `</div>`;
   }
 
   printHtml += '</body></html>';
 
   // Open print window
   const printWindow = window.open('', '_blank');
   printWindow.document.write(printHtml);
   printWindow.document.close();
   printWindow.onload = () => {
     printWindow.print();
   };
 }
 
 // ═════════════════════════════════════════════════════
 // SCHOOL DAY OFF CAMPS — Curriculum Admin (Phase 1)
 // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html
 // Admin-only by construction: an SDOC year is unpublished and cannot be
 // published until Phase 2, and only manager+ can select an unpublished year.
 // ═════════════════════════════════════════════════════
 
 const sdocEsc = (v) => escHtml(String(v ?? ''));
 const sdocEscA = (v) => escAttr(String(v ?? ''));
 
 // "Mon Nov 23 – Wed Nov 25", "Mon Oct 12" — consecutive calendar days merge.
 function dayOffDateRuns(dates) {
   const sorted = [...(dates || [])].sort();
   const runs = [];
   for (const d of sorted) {
     const last = runs[runs.length - 1];
     const next = last && new Date(`${last.end}T00:00:00Z`);
     if (next) next.setUTCDate(next.getUTCDate() + 1);
     if (last && next.toISOString().slice(0, 10) === d) last.end = d;
     else runs.push({ start: d, end: d });
   }
   return runs.map(r => r.start === r.end ? formatDayOffDate(r.start) : `${formatDayOffDate(r.start)} – ${formatDayOffDate(r.end)}`);
 }
 
 // An event's camps in card order: AM, full day, PM, then by title.
 function dayOffEventCamps(yearKey, eventId) {
   return (currentDayOffCamps[yearKey] || []).filter(c => c.eventId === eventId)
     .sort((a, b) => ['AM', 'FULL', 'PM'].indexOf(a.timeSlot) - ['AM', 'FULL', 'PM'].indexOf(b.timeSlot) || String(a.title).localeCompare(String(b.title)));
 }
 
+// ─── Plan overview (SDOC Phase 3) ───────────────────
+// Read-only: computed from the slots buildDayOffSlots() already builds. Teachers
+// save on other devices and there is no SDOC listener, so the year is re-read on
+// Curriculum Admin entry, on switching to it, and by ↻ Refresh — always through
+// the listener's own generation-gated reload, never a second loader.
+let dayOffRefreshInFlight = null;
+
+function refreshDayOffYear(yearKey) {
+  if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
+  const run = (async () => {
+    const outcome = await reloadSummerForModeChange();
+    // The listener's callback redraws Curriculum Admin too, but draw here as
+    // well: a failed outcome must show its message whoever registered last.
+    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
+    return outcome;
+  })();
+  dayOffRefreshInFlight = run;
+  const done = () => {
+    if (dayOffRefreshInFlight === run) dayOffRefreshInFlight = null;
+    if (isDayOffYear(getAdminSemKey())) renderDayOffRefreshControls(getAdminSemKey());
+  };
+  run.then(done, done);
+  renderDayOffRefreshControls(yearKey);   // disable the button now
+  return run;
+}
+
+function formatDayOffRefreshTime(d) {
+  return d instanceof Date && !isNaN(d) ? d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' }) : '';
+}
+
+function dayOffRefreshControlsHtml(yearKey) {
+  const at = formatDayOffRefreshTime(dayOffLastRefreshAt[yearKey]);
+  const busy = !!dayOffRefreshInFlight;
+  const failed = !!dayOffRefreshFailed[yearKey];
+  return `<span class="sdoc-refresh" id="sdoc-refresh">
+      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
+      <button class="btn-text" id="sdoc-refresh-btn" type="button" onclick="refreshDayOffYear(getAdminSemKey())" ${busy ? 'disabled' : ''}>${busy ? 'Refreshing…' : '↻ Refresh'}</button>
+      ${failed ? `<span id="sdoc-refresh-error" class="sdoc-refresh-error">Couldn't refresh — showing the last full refresh${at ? ` (${sdocEsc(at)})` : ''}</span>` : ''}
+    </span>`;
+}
+
+// Just the header controls (busy state) — the rows wait for the outcome's redraw.
+function renderDayOffRefreshControls(yearKey) {
+  const el = document.getElementById('sdoc-refresh');
+  if (el) el.outerHTML = dayOffRefreshControlsHtml(yearKey);
+}
+
+// Same status the teachers' list shows; 'ready' ("Almost Done") can't happen for
+// an SDOC slot (campName zeroes materials) and reads as In Progress if it ever does.
+function dayOffPlanProgress(slot) {
+  const p = calculateLessonProgress(slot);
+  return p === 'ready' ? 'in-progress' : p;
+}
+
+// A camp's plans in dayOffCampTitles() order — one per title, however many days it runs.
+function dayOffCampPlanSlots(yearKey, camp) {
+  const slots = currentLessonData?.[yearKey] || {};
+  return [...dayOffCampTitles(camp).keys()]
+    .map(title => ({ lessonKey: dayOffLessonKey(yearKey, camp.id, title), title }))
+    .filter(({ lessonKey }) => slots[lessonKey])
+    .map(p => ({ ...p, slot: slots[p.lessonKey] }));
+}
+
+function renderDayOffPlansCell(yearKey, camp) {
+  const plans = dayOffCampPlanSlots(yearKey, camp);
+  if (!plans.length) return '<span class="settings-hint">no projects yet</span>';
+  return plans.map(({ lessonKey, title, slot }) => {
+    const progress = dayOffPlanProgress(slot);
+    const date = String(slot.lastEditedAt || '').slice(0, 10);
+    const edited = slot.lastEditedBy
+      ? `<div class="sdoc-plan-edited settings-hint">last edited by ${sdocEsc(slot.lastEditedBy)}${isIsoDate(date) ? `, ${sdocEsc(formatDayOffDate(date, { month: 'short', day: 'numeric' }))}` : ''}</div>`
+      : '';
+    return `<div class="sdoc-plan" data-lesson-key="${sdocEscA(lessonKey)}">
+        <span class="sdoc-plan-title">${sdocEsc(title)}</span>
+        <span class="sdoc-plan-status sdoc-tv-status progress-${progress}">${getProgressLabel(progress)}</span>
+        <button class="btn-text sdoc-plan-open-btn" type="button" onclick="openDayOffPlanFromAdmin(this.closest('.sdoc-plan').dataset.lessonKey)">Open plan</button>
+        ${edited}
+      </div>`;
+  }).join('');
+}
+
+// "Plans: c of n complete · k not started" — n counts (camp, title) pairs.
+function dayOffEventRollupHtml(yearKey, evCamps) {
+  const plans = evCamps.flatMap(c => dayOffCampPlanSlots(yearKey, c));
+  if (!plans.length) return '';
+  const progress = plans.map(p => dayOffPlanProgress(p.slot));
+  const complete = progress.filter(p => p === 'complete').length;
+  const notStarted = progress.filter(p => p === 'not-started').length;
+  return `<div class="sdoc-event-rollup">Plans: ${complete} of ${plans.length} complete${notStarted ? ` · ${notStarted} not started` : ''}</div>`;
+}
+
+function openDayOffPlanFromAdmin(lessonKey) {
+  const yearKey = getAdminSemKey();
+  return openPlanEditor(yearKey, lessonKey, {
+    onClosed: () => { if (getAdminSemKey() === yearKey) renderAdminGrid(); },
+  });
+}
+
 function renderDayOffAdmin(yearKey) {
   const wrapper = document.getElementById('ca-grid-wrapper');
   if (!wrapper) return;
   const year = currentConfig?.semesters?.[yearKey] || {};
   const events = currentDayOffEvents[yearKey] || [];
   const camps = currentDayOffCamps[yearKey] || [];
   const writable = lessonDataLoadedSuccessfully !== false;
   // Planner buttons only for users the rules let save them (Phase 2A);
   // the prep team sees the list read-only, with the materials checklist.
   const planner = canPlanDayOffCamps();
   const ticker = canTickDayOffMaterials();
   const dis = writable ? '' : 'disabled';
 
   const head = `
     <div class="sdoc-admin-header">
       <h2>${sdocEsc(year.name)}<span class="sdoc-count">${events.length} event${events.length === 1 ? '' : 's'}, ${camps.length} camp${camps.length === 1 ? '' : 's'}</span></h2>
+      ${dayOffRefreshControlsHtml(yearKey)}
       ${planner ? `<button class="btn-primary write-control" onclick="openDayOffEventEditor(null)" ${dis}>+ Add event</button>` : '<span class="settings-hint">View only — events and camps are planned by Christie and Anika.</span>'}
     </div>`;
   if (events.length === 0) {
     wrapper.innerHTML = `<div class="sdoc-admin">${head}<div class="tv-placeholder">No day-off dates yet — add the first one from the district calendar.</div></div>`;
     return;
   }
 
   let html = '';
   let month = '';
   for (const ev of events) {
     const m = formatDayOffDate(ev.dates?.[0], { month: 'long', year: 'numeric' });
     if (m !== month) { html += `<div class="sdoc-month">${sdocEsc(m)}</div>`; month = m; }
     const evCamps = dayOffEventCamps(yearKey, ev.id);
     // Phase 2A.1: one checklist for the whole event, for everyone who ticks —
     // shown once any of its camps has an item.
     const evMat = evCamps.reduce((t, c) => { const s = dayOffCampMaterialsSummary(yearKey, c); return { items: t.items + s.items, ticked: t.ticked + s.ticked }; }, { items: 0, ticked: 0 });
     const evMatBtn = ticker && evMat.items
       ? `<button class="btn-secondary sdoc-event-mat-btn" onclick="openDayOffEventMaterials(this.closest('.sdoc-event-card').dataset.eventId)">Materials checklist · ${evMat.ticked} of ${evMat.items} ticked</button>`
       : '';
     const rows = evCamps.map(c => `
       <tr data-camp-id="${sdocEscA(c.id)}">
         <td><strong>${sdocEsc(c.title)}</strong>${c.notes ? `<div class="settings-hint">${sdocEsc(c.notes)}</div>` : ''}</td>
         <td>${sdocEsc(c.timeSlot === 'FULL' ? 'Full day' : c.timeSlot)} · ${sdocEsc(c.timeLabel)}</td>
         <td>${sdocEsc(c.location)}<div class="settings-hint">${(c.placements || []).map(p => `${sdocEsc(p.studio)} ${sdocEsc(p.ageRange)} ×${sdocEsc(p.capacity)}`).join(', ')} — <span class="sdoc-headcount">${dayOffHeadcount(c)}</span></div></td>
         <td>${(c.teachers || []).length ? sdocEsc(c.teachers.join(', ')) : '<span class="settings-hint">none yet</span>'}</td>
         <td>${(c.dates || []).map(d => {
           const day = normaliseDayOffDayBlocks(c.projects?.[d]);
           const parts = SDOC_BLOCKS.map(b => day[b.key] ? sdocEsc(day[b.key]) : (SDOC_PROJECT_BLOCK_KEYS.includes(b.key) ? '<span class="sdoc-tbd">to fill</span>' : '')).filter(Boolean);
           return `<div class="sdoc-day-line"><strong>${sdocEsc(formatDayOffDate(d, { weekday: 'short' }))}</strong> ${parts.join(' · ')}</div>`;
         }).join('')}${(() => { const f = dayOffBlocksToFill(c); return f.empty ? `<div class="sdoc-to-fill">${f.empty} of ${f.total} blocks to fill</div>` : ''; })()}</td>
+        <td class="sdoc-plans-cell">${renderDayOffPlansCell(yearKey, c)}</td>
         <td>${renderDayOffMaterialsCell(yearKey, c, { planner, ticker, dis })}</td>
         <td class="sdoc-actions">${planner ? `
           <button class="btn-text write-control" onclick="openDayOffCampEditor(${escForOnclick(ev.id)}, ${escForOnclick(c.id)})" ${dis}>Edit</button>
           <button class="btn-text write-control" onclick="removeDayOffCamp(${escForOnclick(c.id)})" ${dis}>Remove</button>` : ''}
         </td>
       </tr>`).join('');
     html += `
       <div class="sdoc-event-card" data-event-id="${sdocEscA(ev.id)}">
         <div class="sdoc-event-head">
           <div>
             <div class="sdoc-event-title">${sdocEsc(ev.label)}</div>
             <div class="sdoc-chips">${dayOffDateRuns(ev.dates).map(r => `<span class="sdoc-chip">${sdocEsc(r)}</span>`).join('')}${ev.district ? `<span class="sdoc-chip sdoc-district">${sdocEsc(ev.district)}</span>` : ''}</div>
             ${ev.notes ? `<div class="sdoc-event-notes">${sdocEsc(ev.notes)}</div>` : ''}
+            ${dayOffEventRollupHtml(yearKey, evCamps)}
           </div>
           <div class="sdoc-actions">${evMatBtn}${planner ? `
             <button class="btn-secondary write-control" onclick="openDayOffCampEditor(${escForOnclick(ev.id)}, null)" ${dis}>+ Add camp</button>
             <button class="btn-text write-control" onclick="openDayOffEventEditor(${escForOnclick(ev.id)})" ${dis}>Edit</button>
             <button class="btn-text write-control" onclick="removeDayOffEvent(${escForOnclick(ev.id)})" ${dis}>Remove</button>` : ''}
           </div>
         </div>
         ${evCamps.length ? `<div class="sdoc-table-scroll"><table class="sdoc-camps-table">
-          <thead><tr><th>Camp</th><th>Slot &amp; hours</th><th>Location · placements · headcount</th><th>Teachers</th><th>Days &amp; projects</th><th>Materials</th><th></th></tr></thead>
+          <thead><tr><th>Camp</th><th>Slot &amp; hours</th><th>Location · placements · headcount</th><th>Teachers</th><th>Days &amp; projects</th><th>Plans</th><th>Materials</th><th></th></tr></thead>
           <tbody>${rows}</tbody></table></div>` : '<div class="sdoc-empty">No camps yet.</div>'}
       </div>`;
   }
   wrapper.innerHTML = `<div class="sdoc-admin">${head}${html}</div>`;
 }
 
 function closeDayOffEditor(id, { force = false } = {}) {
   if (!force && dayOffEditor?.dirty && !confirm('Discard your changes?')) return;
   document.getElementById(id)?.classList.remove('open');
   dayOffEditor = null;
 }
 
 function markDayOffEditorDirty() { if (dayOffEditor) dayOffEditor.dirty = true; }
 
 let dayOffEditor = null;   // { kind: 'event'|'camp', yearKey, original, … }
 let dayOffSaving = false;
 
 function showDayOffErrors(id, err) {
   const box = document.getElementById(id);
   if (!box) return;
   box.textContent = err ? (err.problems ? err.problems.join('\n') : err.message) : '';
   if (err) box.scrollIntoView({ block: 'nearest' });
 }
 
 // ─── Event editor ───────────────────────────────────
 
 function weekdaysBetween(start, end) {
   const out = [];
   if (!isIsoDate(start) || !isIsoDate(end) || end < start) return out;
   const d = new Date(`${start}T00:00:00Z`);
   for (let i = 0; i < 400 && d.toISOString().slice(0, 10) <= end; i++) {
     const day = d.getUTCDay();
     if (day !== 0 && day !== 6) out.push(d.toISOString().slice(0, 10));
     d.setUTCDate(d.getUTCDate() + 1);
   }
   return out;
 }
 
 function openDayOffEventEditor(eventId) {
   const yearKey = getAdminSemKey();
   if (!isDayOffYear(yearKey)) return;
   const original = eventId ? (currentDayOffEvents[yearKey] || []).find(e => e.id === eventId) : null;
   if (eventId && !original) { alert('That event is no longer here — reload the page.'); return; }
   const snapshot = original ? JSON.parse(JSON.stringify(original)) : null;
   const dates = snapshot?.dates || [];

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '100,250p;640,770p;5100,5185p;12610,12885p'; nl -ba js/firebase-data.js | sed -n '20,95p;740,850p;1290,1435p;2880,2925p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
   100	  globalSemesterKey = key;
   101	  localStorage.setItem('globalSemesterKey', key);
   102	  updateOwnDocPausedNotice();   // Spring 2026 storage move: standing "editing is paused" notice
   103	
   104	  // Hide/show Prep Dashboard tab based on semester type
   105	  const semester = currentConfig.semesters[key];
   106	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   107	  if (prepDashboardTab) {
   108	    if (!isWeeklySemester(key)) {   // camp seasons and SDOC years have no prep dashboard
   109	      prepDashboardTab.style.display = 'none';
   110	      // If currently on Prep Dashboard, switch to Teacher View
   111	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
   112	        switchTab('teacher-view');
   113	        return; // Exit early since switchTab will handle the rest
   114	      }
   115	    } else {
   116	      prepDashboardTab.style.display = '';
   117	    }
   118	  }
   119	
   120	  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
   121	  updateCurriculumAdminTab();
   122	
   123	  // Refresh all tabs to use new semester
   124	  const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
   125	
   126	  if (activeTab === 'teacher-view') {
   127	    renderTvSemesterSelector();
   128	    renderProgressDashboard();
   129	    renderQaActivityPanel();
   130	    updateClassFilter(); // Update class dropdown for new semester
   131	    renderTeacherView();
   132	  } else if (activeTab === 'prep-dashboard') {
   133	    const weekNum = document.getElementById('week-select')?.value || 1;
   134	    loadWeekData(parseInt(weekNum));
   135	  } else if (activeTab === 'curriculum-admin') {
   136	    renderSemesterSelector();
   137	    renderAdminGrid();
   138	    renderHelpQueue();
   139	    renderCutBank();
   140	    renderIdeaBank();
   141	    renderChangeHistory();
   142	    // Switching TO an SDOC year re-reads it for the overview (Phase 3).
   143	    if (key !== previousKey && isDayOffYear(key) && caInitialized) refreshDayOffYear(key);
   144	  } else if (activeTab === 'settings') {
   145	    loadSettingsForm();
   146	  }
   147	}
   148	
   149	// ─── Initialization ─────────────────────────────────
   150	
   151	document.addEventListener('DOMContentLoaded', async () => {
   152	  const user = await requireAuth();
   153	  if (!user) return;
   154	
   155	  initCurriculumFirestore();
   156	  await loadConfig();
   157	  // A failed config read is fatal to the whole app by design (Phase 1, 1.2) —
   158	  // nothing below can be trusted, and loadLessonData() must not run.
   159	  if (configLoadFailed) return;
   160	  await loadPrepData();
   161	
   162	  initGlobalSemesterSelector();
   163	
   164	  // Decide how the shared summer collections may be read BEFORE anything reads
   165	  // them (Phase 1, 1.3): a forced-server read of the registry's switch, then a
   166	  // listener — never awaited — so this tab follows the Summer Camp App
   167	  // switching seasons on, and heals if it started offline.
   168	  await loadSeasonRegistryMode();
   169	  watchSeasonRegistry({
   170	    onModeChange: () => { reloadSummerForModeChange(); },
   171	  });
   172	
   173	  // Pre-load lesson data on startup so any load failure is detected immediately
   174	  await loadLessonData();
   175	  updateOwnDocPausedNotice();   // Spring 2026 storage move: standing notice if the selected semester is paused
   176	  if (lessonDataLoadedSuccessfully === false) {
   177	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   178	  }
   179	
   180	  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
   181	  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
   182	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   183	  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
   184	    prepDashboardTab.style.display = 'none';
   185	  }
   186	
   187	  setupTabs();
   188	  setupRoleAccess();
   189	  setupFooter();
   190	  loadSettingsForm();
   191	
   192	  // Initialize Curriculum Admin (default tab)
   193	  await initCurriculumAdmin();
   194	
   195	  // Real-time sync for prep data
   196	  setupPrepDataListener(onPrepDataChange);
   197	});
   198	
   199	// ─── Tab Navigation ─────────────────────────────────
   200	
   201	let lastDiagFingerprint = null;  // Track which diagnostic item we navigated from
   202	
   203	function switchTab(tabId) {
   204	  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
   205	  if (btn) btn.click();
   206	}
   207	
   208	function setupTabs() {
   209	  document.querySelectorAll('.tab-btn').forEach(btn => {
   210	    btn.addEventListener('click', () => {
   211	      const tabId = btn.dataset.tab;
   212	
   213	      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
   214	      btn.classList.add('active');
   215	
   216	      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
   217	      document.getElementById(tabId)?.classList.add('active');
   218	
   219	      if (tabId === 'teacher-view') {
   220	        initTeacherView();
   221	      } else if (tabId === 'prep-dashboard') {
   222	        initPrepDashboard();
   223	      } else if (tabId === 'curriculum-admin') {
   224	        // Already built: an SDOC year's overview re-reads on every return (Phase 3).
   225	        if (caInitialized && isDayOffYear(getAdminSemKey())) refreshDayOffYear(getAdminSemKey());
   226	        initCurriculumAdmin();
   227	      } else if (tabId === 'settings') {
   228	        ensureSettingsFormMatchesHeader();
   229	      }
   230	      if (tabId === 'settings' && lastDiagFingerprint) {
   231	        // Scroll back to the diagnostic item we came from
   232	        setTimeout(() => {
   233	          scrollToDiagItem(lastDiagFingerprint);
   234	          lastDiagFingerprint = null;
   235	        }, 100);
   236	      }
   237	    });
   238	  });
   239	}
   240	
   241	function scrollToDiagItem(fingerprint) {
   242	  // Find the diagnostic item by its fingerprint (stored on dismiss/undismiss/note buttons)
   243	  const allBtns = document.querySelectorAll(`[data-fp="${CSS.escape(fingerprint)}"]`);
   244	  if (allBtns.length === 0) return;
   245	  // Find the parent .diag-item
   246	  const item = allBtns[0].closest('.diag-item');
   247	  if (!item) return;
   248	  item.scrollIntoView({ behavior: 'smooth', block: 'center' });
   249	  item.classList.add('diag-highlight-flash');
   250	  setTimeout(() => item.classList.remove('diag-highlight-flash'), 2000);
   640	// By Week / By Class sections start collapsed (except the current week in By
   641	// Week); whatever a teacher opens or closes stays that way across re-renders
   642	// (e.g. ticking Plan Complete) for the rest of the visit.
   643	const tvExpandedSections = new Set();
   644	const tvToggledSections = new Set();
   645	let tvCurrentTeacher = '';
   646	let tvCurrentClassFilter = 'all';
   647	let tvNavStack = [];  // Stack of { teacher, classFilter, scrollY } for back navigation
   648	let campCompleteData = {};
   649	
   650	function getTvSemKey() {
   651	  // Now uses global semester instead of per-tab selection
   652	  return getActiveSemesterKey();
   653	}
   654	
   655	function isCoTeacherForCurrentSemester() {
   656	  const user = getAuthUser();
   657	  if (!user || tvCurrentTeacher) return false;
   658	  const semKey = getTvSemKey();
   659	  const lessons = currentLessonData?.[semKey];
   660	  return !!lessons && Object.values(lessons).some(l =>
   661	    Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
   662	  );
   663	}
   664	
   665	// Teacher View's part of every lesson-data reload (its old listener callback).
   666	function teacherViewOnReload() {
   667	  renderProgressDashboard();
   668	  // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
   669	  // no sharedWith — so re-render on every reload while the year is showing
   670	  // (the list and the teacher picker are rebuilt from the camps each time).
   671	  if (isDayOffYear(getTvSemKey())) {
   672	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
   673	    return;
   674	  }
   675	  // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
   676	  const semKey = getTvSemKey();
   677	  const lessons = currentLessonData?.[semKey];
   678	  if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
   679	    const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
   680	    if (!hasTeachers) {
   681	      tvInitialized = false;
   682	      initTeacherView();
   683	    }
   684	  }
   685	  // Skip re-render while a camp is expanded — preserves expanded state on live data updates
   686	  const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
   687	  if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
   688	}
   689	
   690	// The ONE lesson-data listener callback (SDOC Phase 3). There is one listener
   691	// and both Teacher View and Curriculum Admin register it; with a callback each,
   692	// whichever registered last owned every redraw and the other view went stale
   693	// (after one Teacher View visit, Curriculum Admin stopped redrawing — and a
   694	// startup race could do the reverse). Each branch is what that view's own
   695	// callback did on every tick; each is isolated so one throwing can't skip the other.
   696	function onLessonDataReload(data) {
   697	  currentLessonData = data;
   698	  if (tvInitialized) {
   699	    try { teacherViewOnReload(); } catch (err) { console.error('Teacher View redraw after reload failed:', err); }
   700	  }
   701	  if (caInitialized) {
   702	    try { renderAdminGrid(); renderHelpQueue(); } catch (err) { console.error('Curriculum Admin redraw after reload failed:', err); }
   703	  }
   704	  // Refresh teacher mapping table in Settings if it exists
   705	  try { renderTeacherMappingTable(); } catch (err) { console.error('Teacher mapping redraw after reload failed:', err); }
   706	}
   707	
   708	async function initTeacherView() {
   709	  // Already built: the semester may have changed on another tab — refresh for
   710	  // it (renderTeacherView handles SDOC, and leaving SDOC, itself).
   711	  if (tvInitialized) {
   712	    if (isDayOffYear(getTvSemKey()) || tvTeacherListFor) { renderTvSemesterSelector(); renderQaActivityPanel(); renderTeacherView(); }
   713	    return;
   714	  }
   715	  tvInitialized = true;
   716	
   717	  // Load lesson data if not already loaded
   718	  if (!currentLessonData) {
   719	    await loadLessonData();
   720	  }
   721	
   722	  // Show banner and abort if load failed — prevents stale blank data from being saved.
   723	  // Not "initialized": the guard can trip transiently now (a listener reload
   724	  // that fails and self-heals — Backtracking audit Phase 7), and the next
   725	  // visit to this tab must be allowed to build it.
   726	  if (lessonDataLoadedSuccessfully === false) {
   727	    tvInitialized = false;
   728	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   729	    return;
   730	  }
   731	
   732	  // Set up real-time listener FIRST so the retry mechanism fires even if
   733	  // summer camp data isn't ready yet when we reach the early-return below.
   734	  setupLessonDataListener(onLessonDataReload);
   735	
   736	  // Build semester selector (only show if multiple published semesters)
   737	  renderTvSemesterSelector();
   738	
   739	  const semKey = getTvSemKey();
   740	  const lessons = currentLessonData?.[semKey];
   741	
   742	  // Before the empty-map "Loading…" branch below — an SDOC year with no camps
   743	  // (or only empty blocks) is an empty map and would otherwise say "Loading"
   744	  // forever. Initialized like any other type (Phase 2B): the listener above is
   745	  // subscribed once, and the controls are bound once; renderTeacherView()
   746	  // builds the SDOC teacher list itself.
   747	  if (isDayOffYear(semKey)) {
   748	    bindTeacherViewControlsOnce();
   749	    renderTeacherView();
   750	    return;
   751	  }
   752	
   753	  if (!lessons || Object.keys(lessons).length === 0) {
   754	    document.getElementById('tv-content').innerHTML =
   755	      '<div class="tv-placeholder">Loading teacher data…</div>';
   756	    return;
   757	  }
   758	
   759	  // Build teacher list from lesson data
   760	  populateTvTeacherList(lessons);
   761	
   762	  // Auto-select teacher for staff users who have a matched teacher name
   763	  const teacherSelect = document.getElementById('tv-teacher-select');
   764	  const matchedTeacher = getTeacherNameForCurrentUser();
   765	  const teachers = [...new Set(Object.values(lessons).map(l => l.teacher).filter(Boolean))].sort();
   766	
   767	  let selectedTeacher = null;
   768	  if (matchedTeacher && teachers.includes(matchedTeacher)) {
   769	    selectedTeacher = matchedTeacher;
   770	  }
  5100	    creatingSemester = false;
  5101	  }
  5102	
  5103	  closeNewSemesterModal();
  5104	  caCurrentSemester = key;
  5105	  renderSemesterSelector();
  5106	  renderAdminGrid();
  5107	  renderHelpQueue();
  5108	  renderCutBank();
  5109	  renderIdeaBank();
  5110	  renderChangeHistory();
  5111	}
  5112	
  5113	async function initCurriculumAdmin() {
  5114	  if (caInitialized) return;
  5115	  caInitialized = true;
  5116	
  5117	  if (!currentLessonData) await loadLessonData();
  5118	  if (!currentChangeLog) await loadChangeLog();
  5119	  if (!currentCutProjects) await loadCutProjects();
  5120	  if (!currentFutureProjects) await loadFutureProjects();
  5121	
  5122	  renderSemesterSelector();
  5123	  renderAdminGrid();
  5124	  renderHelpQueue();
  5125	  renderCutBank();
  5126	  renderIdeaBank();
  5127	  renderChangeHistory();
  5128	
  5129	  // Modal close
  5130	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5131	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5132	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5133	  });
  5134	
  5135	  // Real-time updates — the same callback Teacher View registers (Phase 3)
  5136	  setupLessonDataListener(onLessonDataReload);
  5137	}
  5138	
  5139	function renderAdminGrid() {
  5140	  const wrapper = document.getElementById('ca-grid-wrapper');
  5141	  const semKey = getAdminSemKey();
  5142	  const lessons = currentLessonData?.[semKey];
  5143	
  5144	  // School Day Off Camps years: the event/camp planning list (Phase 1).
  5145	  if (isDayOffYear(semKey)) {
  5146	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5147	    renderDayOffAdmin(semKey);
  5148	    return;
  5149	  }
  5150	  // Camp seasons get their own view instead of the weekly curriculum grid
  5151	  if (isCampSeason(semKey)) {
  5152	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5153	    renderSummerCA(lessons);
  5154	    return;
  5155	  }
  5156	  document.querySelector('.ca-grid-hint')?.style.removeProperty('display');
  5157	
  5158	  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
  5159	  const numWeeks = semester?.numWeeks || 16;
  5160	  const breakWeeks = semester?.breakWeeks || [];
  5161	  const currentWeek = semKey === getActiveSemesterKey() ? getCurrentWeekNum() : null;
  5162	
  5163	  if (!lessons || Object.keys(lessons).length === 0) {
  5164	    wrapper.innerHTML = `<div class="tv-placeholder">${semKey === getActiveSemesterKey()
  5165	      ? 'No lesson data. Set up the class roster in Settings to create lesson slots.'
  5166	      : 'No lesson data for this semester yet. Import lessons or paste from Cut/Idea Bank.'}</div>`;
  5167	    return;
  5168	  }
  5169	
  5170	  // Build teacher+class combos
  5171	  const combos = {};
  5172	  for (const [key, lesson] of Object.entries(lessons)) {
  5173	    const comboKey = `${lesson.teacher}|||${lesson.className}`;
  5174	    if (!combos[comboKey]) {
  5175	      combos[comboKey] = { teacher: lesson.teacher, className: lesson.className, weeks: {} };
  5176	    }
  5177	    combos[comboKey].weeks[lesson.weekNum] = { key, ...lesson };
  5178	  }
  5179	
  5180	  const sortedCombos = Object.values(combos).sort((a, b) => {
  5181	    const da = getDayOrder(a.className);
  5182	    const db = getDayOrder(b.className);
  5183	    if (da !== db) return da - db;
  5184	    if (a.teacher !== b.teacher) return a.teacher.localeCompare(b.teacher);
  5185	    return a.className.localeCompare(b.className);
 12610	          <td>${esc(m.name || '')}</td>
 12611	          <td>${esc(m.qtyPerCamper || '')}</td>
 12612	          <td>${esc(m.prepCategory || '')}</td>
 12613	          <td>${esc(m.howToPrep || '')}</td>
 12614	        </tr>`;
 12615	      }
 12616	      printHtml += `</tbody></table></div>`;
 12617	    }
 12618	
 12619	    printHtml += `<div class="lesson-footer">Tinker Art Studio — Summer Camp — ${esc(campName)} — ${esc(lesson.teacher)}</div>`;
 12620	    printHtml += `</div>`;
 12621	  }
 12622	
 12623	  printHtml += '</body></html>';
 12624	
 12625	  // Open print window
 12626	  const printWindow = window.open('', '_blank');
 12627	  printWindow.document.write(printHtml);
 12628	  printWindow.document.close();
 12629	  printWindow.onload = () => {
 12630	    printWindow.print();
 12631	  };
 12632	}
 12633	
 12634	// ═════════════════════════════════════════════════════
 12635	// SCHOOL DAY OFF CAMPS — Curriculum Admin (Phase 1)
 12636	// Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html
 12637	// Admin-only by construction: an SDOC year is unpublished and cannot be
 12638	// published until Phase 2, and only manager+ can select an unpublished year.
 12639	// ═════════════════════════════════════════════════════
 12640	
 12641	const sdocEsc = (v) => escHtml(String(v ?? ''));
 12642	const sdocEscA = (v) => escAttr(String(v ?? ''));
 12643	
 12644	// "Mon Nov 23 – Wed Nov 25", "Mon Oct 12" — consecutive calendar days merge.
 12645	function dayOffDateRuns(dates) {
 12646	  const sorted = [...(dates || [])].sort();
 12647	  const runs = [];
 12648	  for (const d of sorted) {
 12649	    const last = runs[runs.length - 1];
 12650	    const next = last && new Date(`${last.end}T00:00:00Z`);
 12651	    if (next) next.setUTCDate(next.getUTCDate() + 1);
 12652	    if (last && next.toISOString().slice(0, 10) === d) last.end = d;
 12653	    else runs.push({ start: d, end: d });
 12654	  }
 12655	  return runs.map(r => r.start === r.end ? formatDayOffDate(r.start) : `${formatDayOffDate(r.start)} – ${formatDayOffDate(r.end)}`);
 12656	}
 12657	
 12658	// An event's camps in card order: AM, full day, PM, then by title.
 12659	function dayOffEventCamps(yearKey, eventId) {
 12660	  return (currentDayOffCamps[yearKey] || []).filter(c => c.eventId === eventId)
 12661	    .sort((a, b) => ['AM', 'FULL', 'PM'].indexOf(a.timeSlot) - ['AM', 'FULL', 'PM'].indexOf(b.timeSlot) || String(a.title).localeCompare(String(b.title)));
 12662	}
 12663	
 12664	// ─── Plan overview (SDOC Phase 3) ───────────────────
 12665	// Read-only: computed from the slots buildDayOffSlots() already builds. Teachers
 12666	// save on other devices and there is no SDOC listener, so the year is re-read on
 12667	// Curriculum Admin entry, on switching to it, and by ↻ Refresh — always through
 12668	// the listener's own generation-gated reload, never a second loader.
 12669	let dayOffRefreshInFlight = null;
 12670	
 12671	function refreshDayOffYear(yearKey) {
 12672	  if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
 12673	  const run = (async () => {
 12674	    const outcome = await reloadSummerForModeChange();
 12675	    // The listener's callback redraws Curriculum Admin too, but draw here as
 12676	    // well: a failed outcome must show its message whoever registered last.
 12677	    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
 12678	    return outcome;
 12679	  })();
 12680	  dayOffRefreshInFlight = run;
 12681	  const done = () => {
 12682	    if (dayOffRefreshInFlight === run) dayOffRefreshInFlight = null;
 12683	    if (isDayOffYear(getAdminSemKey())) renderDayOffRefreshControls(getAdminSemKey());
 12684	  };
 12685	  run.then(done, done);
 12686	  renderDayOffRefreshControls(yearKey);   // disable the button now
 12687	  return run;
 12688	}
 12689	
 12690	function formatDayOffRefreshTime(d) {
 12691	  return d instanceof Date && !isNaN(d) ? d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' }) : '';
 12692	}
 12693	
 12694	function dayOffRefreshControlsHtml(yearKey) {
 12695	  const at = formatDayOffRefreshTime(dayOffLastRefreshAt[yearKey]);
 12696	  const busy = !!dayOffRefreshInFlight;
 12697	  const failed = !!dayOffRefreshFailed[yearKey];
 12698	  return `<span class="sdoc-refresh" id="sdoc-refresh">
 12699	      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
 12700	      <button class="btn-text" id="sdoc-refresh-btn" type="button" onclick="refreshDayOffYear(getAdminSemKey())" ${busy ? 'disabled' : ''}>${busy ? 'Refreshing…' : '↻ Refresh'}</button>
 12701	      ${failed ? `<span id="sdoc-refresh-error" class="sdoc-refresh-error">Couldn't refresh — showing the last full refresh${at ? ` (${sdocEsc(at)})` : ''}</span>` : ''}
 12702	    </span>`;
 12703	}
 12704	
 12705	// Just the header controls (busy state) — the rows wait for the outcome's redraw.
 12706	function renderDayOffRefreshControls(yearKey) {
 12707	  const el = document.getElementById('sdoc-refresh');
 12708	  if (el) el.outerHTML = dayOffRefreshControlsHtml(yearKey);
 12709	}
 12710	
 12711	// Same status the teachers' list shows; 'ready' ("Almost Done") can't happen for
 12712	// an SDOC slot (campName zeroes materials) and reads as In Progress if it ever does.
 12713	function dayOffPlanProgress(slot) {
 12714	  const p = calculateLessonProgress(slot);
 12715	  return p === 'ready' ? 'in-progress' : p;
 12716	}
 12717	
 12718	// A camp's plans in dayOffCampTitles() order — one per title, however many days it runs.
 12719	function dayOffCampPlanSlots(yearKey, camp) {
 12720	  const slots = currentLessonData?.[yearKey] || {};
 12721	  return [...dayOffCampTitles(camp).keys()]
 12722	    .map(title => ({ lessonKey: dayOffLessonKey(yearKey, camp.id, title), title }))
 12723	    .filter(({ lessonKey }) => slots[lessonKey])
 12724	    .map(p => ({ ...p, slot: slots[p.lessonKey] }));
 12725	}
 12726	
 12727	function renderDayOffPlansCell(yearKey, camp) {
 12728	  const plans = dayOffCampPlanSlots(yearKey, camp);
 12729	  if (!plans.length) return '<span class="settings-hint">no projects yet</span>';
 12730	  return plans.map(({ lessonKey, title, slot }) => {
 12731	    const progress = dayOffPlanProgress(slot);
 12732	    const date = String(slot.lastEditedAt || '').slice(0, 10);
 12733	    const edited = slot.lastEditedBy
 12734	      ? `<div class="sdoc-plan-edited settings-hint">last edited by ${sdocEsc(slot.lastEditedBy)}${isIsoDate(date) ? `, ${sdocEsc(formatDayOffDate(date, { month: 'short', day: 'numeric' }))}` : ''}</div>`
 12735	      : '';
 12736	    return `<div class="sdoc-plan" data-lesson-key="${sdocEscA(lessonKey)}">
 12737	        <span class="sdoc-plan-title">${sdocEsc(title)}</span>
 12738	        <span class="sdoc-plan-status sdoc-tv-status progress-${progress}">${getProgressLabel(progress)}</span>
 12739	        <button class="btn-text sdoc-plan-open-btn" type="button" onclick="openDayOffPlanFromAdmin(this.closest('.sdoc-plan').dataset.lessonKey)">Open plan</button>
 12740	        ${edited}
 12741	      </div>`;
 12742	  }).join('');
 12743	}
 12744	
 12745	// "Plans: c of n complete · k not started" — n counts (camp, title) pairs.
 12746	function dayOffEventRollupHtml(yearKey, evCamps) {
 12747	  const plans = evCamps.flatMap(c => dayOffCampPlanSlots(yearKey, c));
 12748	  if (!plans.length) return '';
 12749	  const progress = plans.map(p => dayOffPlanProgress(p.slot));
 12750	  const complete = progress.filter(p => p === 'complete').length;
 12751	  const notStarted = progress.filter(p => p === 'not-started').length;
 12752	  return `<div class="sdoc-event-rollup">Plans: ${complete} of ${plans.length} complete${notStarted ? ` · ${notStarted} not started` : ''}</div>`;
 12753	}
 12754	
 12755	function openDayOffPlanFromAdmin(lessonKey) {
 12756	  const yearKey = getAdminSemKey();
 12757	  return openPlanEditor(yearKey, lessonKey, {
 12758	    onClosed: () => { if (getAdminSemKey() === yearKey) renderAdminGrid(); },
 12759	  });
 12760	}
 12761	
 12762	function renderDayOffAdmin(yearKey) {
 12763	  const wrapper = document.getElementById('ca-grid-wrapper');
 12764	  if (!wrapper) return;
 12765	  const year = currentConfig?.semesters?.[yearKey] || {};
 12766	  const events = currentDayOffEvents[yearKey] || [];
 12767	  const camps = currentDayOffCamps[yearKey] || [];
 12768	  const writable = lessonDataLoadedSuccessfully !== false;
 12769	  // Planner buttons only for users the rules let save them (Phase 2A);
 12770	  // the prep team sees the list read-only, with the materials checklist.
 12771	  const planner = canPlanDayOffCamps();
 12772	  const ticker = canTickDayOffMaterials();
 12773	  const dis = writable ? '' : 'disabled';
 12774	
 12775	  const head = `
 12776	    <div class="sdoc-admin-header">
 12777	      <h2>${sdocEsc(year.name)}<span class="sdoc-count">${events.length} event${events.length === 1 ? '' : 's'}, ${camps.length} camp${camps.length === 1 ? '' : 's'}</span></h2>
 12778	      ${dayOffRefreshControlsHtml(yearKey)}
 12779	      ${planner ? `<button class="btn-primary write-control" onclick="openDayOffEventEditor(null)" ${dis}>+ Add event</button>` : '<span class="settings-hint">View only — events and camps are planned by Christie and Anika.</span>'}
 12780	    </div>`;
 12781	  if (events.length === 0) {
 12782	    wrapper.innerHTML = `<div class="sdoc-admin">${head}<div class="tv-placeholder">No day-off dates yet — add the first one from the district calendar.</div></div>`;
 12783	    return;
 12784	  }
 12785	
 12786	  let html = '';
 12787	  let month = '';
 12788	  for (const ev of events) {
 12789	    const m = formatDayOffDate(ev.dates?.[0], { month: 'long', year: 'numeric' });
 12790	    if (m !== month) { html += `<div class="sdoc-month">${sdocEsc(m)}</div>`; month = m; }
 12791	    const evCamps = dayOffEventCamps(yearKey, ev.id);
 12792	    // Phase 2A.1: one checklist for the whole event, for everyone who ticks —
 12793	    // shown once any of its camps has an item.
 12794	    const evMat = evCamps.reduce((t, c) => { const s = dayOffCampMaterialsSummary(yearKey, c); return { items: t.items + s.items, ticked: t.ticked + s.ticked }; }, { items: 0, ticked: 0 });
 12795	    const evMatBtn = ticker && evMat.items
 12796	      ? `<button class="btn-secondary sdoc-event-mat-btn" onclick="openDayOffEventMaterials(this.closest('.sdoc-event-card').dataset.eventId)">Materials checklist · ${evMat.ticked} of ${evMat.items} ticked</button>`
 12797	      : '';
 12798	    const rows = evCamps.map(c => `
 12799	      <tr data-camp-id="${sdocEscA(c.id)}">
 12800	        <td><strong>${sdocEsc(c.title)}</strong>${c.notes ? `<div class="settings-hint">${sdocEsc(c.notes)}</div>` : ''}</td>
 12801	        <td>${sdocEsc(c.timeSlot === 'FULL' ? 'Full day' : c.timeSlot)} · ${sdocEsc(c.timeLabel)}</td>
 12802	        <td>${sdocEsc(c.location)}<div class="settings-hint">${(c.placements || []).map(p => `${sdocEsc(p.studio)} ${sdocEsc(p.ageRange)} ×${sdocEsc(p.capacity)}`).join(', ')} — <span class="sdoc-headcount">${dayOffHeadcount(c)}</span></div></td>
 12803	        <td>${(c.teachers || []).length ? sdocEsc(c.teachers.join(', ')) : '<span class="settings-hint">none yet</span>'}</td>
 12804	        <td>${(c.dates || []).map(d => {
 12805	          const day = normaliseDayOffDayBlocks(c.projects?.[d]);
 12806	          const parts = SDOC_BLOCKS.map(b => day[b.key] ? sdocEsc(day[b.key]) : (SDOC_PROJECT_BLOCK_KEYS.includes(b.key) ? '<span class="sdoc-tbd">to fill</span>' : '')).filter(Boolean);
 12807	          return `<div class="sdoc-day-line"><strong>${sdocEsc(formatDayOffDate(d, { weekday: 'short' }))}</strong> ${parts.join(' · ')}</div>`;
 12808	        }).join('')}${(() => { const f = dayOffBlocksToFill(c); return f.empty ? `<div class="sdoc-to-fill">${f.empty} of ${f.total} blocks to fill</div>` : ''; })()}</td>
 12809	        <td class="sdoc-plans-cell">${renderDayOffPlansCell(yearKey, c)}</td>
 12810	        <td>${renderDayOffMaterialsCell(yearKey, c, { planner, ticker, dis })}</td>
 12811	        <td class="sdoc-actions">${planner ? `
 12812	          <button class="btn-text write-control" onclick="openDayOffCampEditor(${escForOnclick(ev.id)}, ${escForOnclick(c.id)})" ${dis}>Edit</button>
 12813	          <button class="btn-text write-control" onclick="removeDayOffCamp(${escForOnclick(c.id)})" ${dis}>Remove</button>` : ''}
 12814	        </td>
 12815	      </tr>`).join('');
 12816	    html += `
 12817	      <div class="sdoc-event-card" data-event-id="${sdocEscA(ev.id)}">
 12818	        <div class="sdoc-event-head">
 12819	          <div>
 12820	            <div class="sdoc-event-title">${sdocEsc(ev.label)}</div>
 12821	            <div class="sdoc-chips">${dayOffDateRuns(ev.dates).map(r => `<span class="sdoc-chip">${sdocEsc(r)}</span>`).join('')}${ev.district ? `<span class="sdoc-chip sdoc-district">${sdocEsc(ev.district)}</span>` : ''}</div>
 12822	            ${ev.notes ? `<div class="sdoc-event-notes">${sdocEsc(ev.notes)}</div>` : ''}
 12823	            ${dayOffEventRollupHtml(yearKey, evCamps)}
 12824	          </div>
 12825	          <div class="sdoc-actions">${evMatBtn}${planner ? `
 12826	            <button class="btn-secondary write-control" onclick="openDayOffCampEditor(${escForOnclick(ev.id)}, null)" ${dis}>+ Add camp</button>
 12827	            <button class="btn-text write-control" onclick="openDayOffEventEditor(${escForOnclick(ev.id)})" ${dis}>Edit</button>
 12828	            <button class="btn-text write-control" onclick="removeDayOffEvent(${escForOnclick(ev.id)})" ${dis}>Remove</button>` : ''}
 12829	          </div>
 12830	        </div>
 12831	        ${evCamps.length ? `<div class="sdoc-table-scroll"><table class="sdoc-camps-table">
 12832	          <thead><tr><th>Camp</th><th>Slot &amp; hours</th><th>Location · placements · headcount</th><th>Teachers</th><th>Days &amp; projects</th><th>Plans</th><th>Materials</th><th></th></tr></thead>
 12833	          <tbody>${rows}</tbody></table></div>` : '<div class="sdoc-empty">No camps yet.</div>'}
 12834	      </div>`;
 12835	  }
 12836	  wrapper.innerHTML = `<div class="sdoc-admin">${head}${html}</div>`;
 12837	}
 12838	
 12839	function closeDayOffEditor(id, { force = false } = {}) {
 12840	  if (!force && dayOffEditor?.dirty && !confirm('Discard your changes?')) return;
 12841	  document.getElementById(id)?.classList.remove('open');
 12842	  dayOffEditor = null;
 12843	}
 12844	
 12845	function markDayOffEditorDirty() { if (dayOffEditor) dayOffEditor.dirty = true; }
 12846	
 12847	let dayOffEditor = null;   // { kind: 'event'|'camp', yearKey, original, … }
 12848	let dayOffSaving = false;
 12849	
 12850	function showDayOffErrors(id, err) {
 12851	  const box = document.getElementById(id);
 12852	  if (!box) return;
 12853	  box.textContent = err ? (err.problems ? err.problems.join('\n') : err.message) : '';
 12854	  if (err) box.scrollIntoView({ block: 'nearest' });
 12855	}
 12856	
 12857	// ─── Event editor ───────────────────────────────────
 12858	
 12859	function weekdaysBetween(start, end) {
 12860	  const out = [];
 12861	  if (!isIsoDate(start) || !isIsoDate(end) || end < start) return out;
 12862	  const d = new Date(`${start}T00:00:00Z`);
 12863	  for (let i = 0; i < 400 && d.toISOString().slice(0, 10) <= end; i++) {
 12864	    const day = d.getUTCDay();
 12865	    if (day !== 0 && day !== 6) out.push(d.toISOString().slice(0, 10));
 12866	    d.setUTCDate(d.getUTCDate() + 1);
 12867	  }
 12868	  return out;
 12869	}
 12870	
 12871	function openDayOffEventEditor(eventId) {
 12872	  const yearKey = getAdminSemKey();
 12873	  if (!isDayOffYear(yearKey)) return;
 12874	  const original = eventId ? (currentDayOffEvents[yearKey] || []).find(e => e.id === eventId) : null;
 12875	  if (eventId && !original) { alert('That event is no longer here — reload the page.'); return; }
 12876	  const snapshot = original ? JSON.parse(JSON.stringify(original)) : null;
 12877	  const dates = snapshot?.dates || [];
 12878	  // "Extras" = dates the range can't produce (weekends, or added by hand).
 12879	  const rangeDays = dates.length ? weekdaysBetween(dates[0], dates[dates.length - 1]) : [];
 12880	  dayOffEditor = { kind: 'event', yearKey, original: snapshot, candidates: [...dates], checked: new Set(dates), extras: new Set(dates.filter(d => !rangeDays.includes(d))) };
 12881	  document.getElementById('sdoc-event-modal-title').textContent = original ? `Edit “${original.label}”` : 'Add a day-off event';
 12882	  document.getElementById('sdoc-event-modal-body').innerHTML = `
 12883	    <div class="sdoc-errors" id="sdoc-ev-errors"></div>
 12884	    <div class="settings-form-group">
 12885	      <label for="sdoc-ev-label">Name</label>
    20	const CONTENT_FIELDS = ['introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'dayOfMaterials'];
    21	function lessonHasContent(lesson) {
    22	  return !!lesson && CONTENT_FIELDS.some(f => lesson[f] && String(lesson[f]).trim());
    23	}
    24	
    25	// Firestore doc IDs cannot contain '/'. Encode lesson keys for storage.
    26	function encodeFirestoreKey(key) { return key.replace(/\//g, '__SLASH__'); }
    27	function decodeFirestoreKey(key) { return key.replace(/__SLASH__/g, '/'); }
    28	
    29	// ─── Semester types (camp seasons Phase 1, 1.1) ──────────────────────────────
    30	// Every semester stores its kind explicitly. Nothing in the app may infer a
    31	// kind from a key: "does this key start with summer-?" was how a weekly
    32	// semester named "Summer Enrichment" could be routed into the summer
    33	// collections (R5-3), and how Summer 2026 was the only camp season that could
    34	// ever exist.
    35	const SEMESTER_TYPES = { weekly: 'weekly', camp: 'summer-camp', dayOff: 'day-off-camps' };
    36	
    37	// The stored type, or 'weekly' when absent — with ONE quarantined exception:
    38	// an absent type on the literal key `summer-2026` is a camp season. That
    39	// covers two real windows: the minutes between this deploy and Christie
    40	// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
    41	// whole-document saveConfig() could strip the field. It is the only place
    42	// that literal may appear — a static test fails the build on any other
    43	// functional occurrence. In practice it almost never fires: the May 2026
    44	// auto-add already stored semesterType on the server's summer-2026.
    45	const LEGACY_CAMP_SEMESTER_KEY = 'summer-2026';
    46	function semesterTypeOf(semKey) {
    47	  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
    48	  if (stored) return stored;
    49	  if (semKey === LEGACY_CAMP_SEMESTER_KEY) return SEMESTER_TYPES.camp;
    50	  return SEMESTER_TYPES.weekly;
    51	}
    52	// Read the type only through these — never re-derive it from a key.
    53	function isCampSeason(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.camp; }
    54	function isWeeklySemester(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.weekly; }
    55	
    56	// Which lesson store a semester's lessons live in: 'camp' (one document per
    57	// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
    58	// shared curriculum/lessonData document). The seven sites that choose between
    59	// those two stores — the four lesson writers, the two admin reply writers and
    60	// the existence check — all route through this, so a THIRD type is refused
    61	// rather than treated as weekly: the reply writers' weekly branch update()s
    62	// dotted `{semKey}.{key}.qaThread` paths, which for an SDOC key would quietly
    63	// create a nested map inside the shared weekly document (camp seasons
    64	// Phase 1, 1.1; cross-plan with classbook-school-day-off-camps).
    65	function lessonStoreFor(semKey) {
    66	  const type = semesterTypeOf(semKey);
    67	  switch (type) {
    68	    case SEMESTER_TYPES.camp:   return 'camp';
    69	    case SEMESTER_TYPES.weekly: return 'weekly';
    70	    default:
    71	      throw new Error(`Semester "${semKey}" is a "${type}" semester — this app has no lesson store for that type yet, so it refuses to read or write its lessons.`);
    72	  }
    73	}
    74	
    75	// ─── Own-document weekly semesters (Spring 2026 storage move, Sep 2026) ──────
    76	// curriculum/lessonData holds every weekly semester in ONE Firestore document,
    77	// and it reached 95% of the 1 MiB document cap (Sep 29 2026). A finished weekly
    78	// semester moves to its own document, curriculum/lessons_<semKey>, in one manager
    79	// transaction. Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
    80	// (Phase B). The studio-hub rules (Phase A, deployed 0caf415) fence the key in
    81	// lessonData, and allow edits to the new document only once
    82	// curriculum/storageMigrations says the move is verified.
    83	//
    84	// Changed only by a code deploy, just as the rules fence changes only by a rules deploy.
    85	const OWN_DOC_SEMESTERS = ['spring-2026'];
    86	const OWN_DOC_PAUSED_MESSAGE = 'Spring 2026 is being moved to new storage — editing it is paused for a few days. Viewing works as normal.';
    87	
    88	function isOwnDocSemester(semKey) { return OWN_DOC_SEMESTERS.includes(semKey); }
    89	function ownDocIdFor(semKey) { return `lessons_${semKey}`; }
    90	
    91	// Where each own-doc semester's lessons are served from right now:
    92	// 'legacy' (still inside lessonData), 'ownDoc' (its own document), or 'error'
    93	// (its document couldn't be read — shown from whatever we have, never writable).
    94	const ownDocSource = {};
    95	// curriculum/storageMigrations as last read ({} when absent; null = not yet known).
   740	        currentPrepData = doc.data();
   741	        if (callback) callback(currentPrepData);
   742	      }
   743	    });
   744	}
   745	
   746	// ─── Prep Cycle Config (curriculum/prepCycleConfig) ──
   747	
   748	const DEFAULT_PREP_CYCLE_CONFIG = {
   749	  phases: [
   750	    {
   751	      id: 'monitor-plan',
   752	      name: 'Monitor & Plan',
   753	      emoji: '📋',
   754	      days: ['Monday', 'Thursday'],
   755	      description: 'Check on Thurs for Friday and Monday; make action plan on Mon for Tues.',
   756	      goals: [
   757	        'Prioritized prep task list ready for Tuesday morning',
   758	        'List ready of items needed from storage',
   759	        'Items returning to storage staged on shelving and ready',
   760	        'Prep any day-of items needed for Friday or Monday',
   761	        'Generate trials and process sheets for shared projects — 3 weeks in advance of project',
   762	        'Use Weekly Curriculum meeting to clarify projects and materials'
   763	      ]
   764	    },
   765	    {
   766	      id: 'return-gather',
   767	      name: 'Return & Gather',
   768	      emoji: '📦',
   769	      days: ['Tuesday'],
   770	      description: "Return staged materials to storage and gather what's needed for this week.",
   771	      goals: [
   772	        'Return staged materials to storage (aim for ~2 trips/week)',
   773	        'Delegated prep tasks completed for the day',
   774	        'Prep task list for Wednesday is ready',
   775	        'Keep up on reset materials (threaded needles, model magic, canvas unwrap, etc.)',
   776	        'Use Weekly Curriculum meeting to clarify projects and materials',
   777	        'Cross reference Teacher Process Sheet with Curriculum Map if prep is missing from Prep Dashboard'
   778	      ]
   779	    },
   780	    {
   781	      id: 'prep',
   782	      name: 'Prep',
   783	      emoji: '🎨',
   784	      days: ['Tuesday', 'Wednesday'],
   785	      description: 'Work blocks — prepare items as requested. Prep work should be 2 weeks ahead of project.',
   786	      goals: [
   787	        'Prep work is 2 weeks ahead of project',
   788	        'Keep on top of low supplies — flag via Supply Low List or to manager',
   789	        'Keep list of Friday/Monday reset tasks and daily resets',
   790	        'Keep in communication with SDOC prep lead — trials, process sheets, materials (several weeks ahead)',
   791	        'Cross reference Teacher Process Sheet with Curriculum Map if prep is missing from Prep Dashboard',
   792	        'Cross reference materials needed with list of reset tasks — include day-of materials'
   793	      ]
   794	    },
   795	    {
   796	      id: 'distribute',
   797	      name: 'Distribute',
   798	      emoji: '📤',
   799	      days: ['Tuesday', 'Wednesday'],
   800	      description: 'Prepped items go to teacher tubs or common project shelving.',
   801	      goals: [
   802	        'Prepped materials labeled for teacher: class code, week #, size, quantity',
   803	        'Delegated prep tasks completed for the day',
   804	        'Labeled prepped items distributed to teacher tubs',
   805	        'Keep up on materials needing reset for current week',
   806	        'Cross reference class totals and totals for multiple class projects',
   807	        'Cross reference materials needed with list of reset tasks — include day-of materials'
   808	      ]
   809	    },
   810	    {
   811	      id: 'stage',
   812	      name: 'Stage',
   813	      emoji: '🗂️',
   814	      days: ['Wednesday'],
   815	      description: 'Stage prepped multi-class projects & items to and from storage.',
   816	      goals: [
   817	        'Multi-class project materials staged on shelf in workroom, labeled with example and process sheet',
   818	        'Materials teachers may need later placed on wait shelf',
   819	        'Workroom reset — weekly clear surfaces, keep labeled and accessible',
   820	        'Storage organized — monthly quick reset; keep Materials Locater updated',
   821	        'Cross reference class totals and totals for multiple class projects',
   822	        'Delegate tasks in prep log — each entry labeled with Week #, Class name, total students, Material, quantity, size'
   823	      ]
   824	    },
   825	    {
   826	      id: 'breakdown',
   827	      name: 'Breakdown',
   828	      emoji: '🔄',
   829	      days: ['Wednesday', 'Thursday'],
   830	      description: 'Breakdown returned & unused materials. Stage items on Return shelf.',
   831	      goals: [
   832	        'Materials no longer needed put away; items going to storage staged on return shelf',
   833	        'Look ahead for materials finished with one project but needed for an upcoming project — redistribute',
   834	        'Thursday: review curriculum for Friday & Monday needs; prep as needed; prep Open Studio for Monday',
   835	        'Keep up on materials needing reset for current week',
   836	        'Delegate tasks in prep log — each entry labeled with Week #, Class name, total students, Material, quantity, size',
   837	        'Generate trials and process sheets for shared projects — 3 weeks in advance of project'
   838	      ]
   839	    }
   840	  ]
   841	};
   842	
   843	async function getPrepCycleConfig() {
   844	  if (!curriculumDb) initCurriculumFirestore();
   845	  try {
   846	    const doc = await curriculumDb.collection('curriculum').doc('prepCycleConfig').get();
   847	    if (doc.exists && doc.data().phases?.length) {
   848	      return doc.data();
   849	    }
   850	  } catch (err) {
  1290	// writer in the app, so a failed reload is retried a bounded number of times
  1291	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1292	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1293	// the reload takes (it used to vanish, so the summer view rendered nothing
  1294	// and an in-flight save's optimistic entry had no map to live in), and the
  1295	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1296	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1297	// SDOC Phase 3: when each School Day Off year was last read in full and
  1298	// installed (a Date), and whether the latest full reload of it failed. Both
  1299	// change only where a full load installs or fails — never on a single-plan
  1300	// read — and Curriculum Admin's overview derives its message from them at
  1301	// render time, so any redraw after a recovery shows the truth.
  1302	const dayOffLastRefreshAt = {};
  1303	const dayOffRefreshFailed = {};
  1304	function markDayOffYearInstalled(yearKey) {
  1305	  dayOffLastRefreshAt[yearKey] = new Date();
  1306	  delete dayOffRefreshFailed[yearKey];
  1307	}
  1308	// The camp seasons currently in memory, by semester key.
  1309	function snapshotCampSeasons() {
  1310	  const out = {};
  1311	  for (const semKey of Object.keys(currentLessonData || {})) {
  1312	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1313	  }
  1314	  return out;
  1315	}
  1316	
  1317	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1318	// filtered, or unknown healing) re-runs the summer load through that
  1319	// listener's own generation-gated path — never a second, competing one
  1320	// (Phase 1, 1.3).
  1321	let summerReloadHook = null;
  1322	async function reloadSummerForModeChange() {
  1323	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1324	  return await summerReloadHook();
  1325	}
  1326	
  1327	function setupLessonDataListener(callback) {
  1328	  console.log('📚 Setting up lesson data listener...');
  1329	  if (!curriculumDb) initCurriculumFirestore();
  1330	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1331	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1332	  // The own-doc listeners (Spring 2026 storage move) are torn down together.
  1333	  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
  1334	
  1335	  // One reload attempt for one snapshot generation. Only the latest
  1336	  // generation may touch the guard, the banner, or the summer cache.
  1337	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1338	  // outcome was discarded (a newer snapshot took over while it ran).
  1339	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1340	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1341	    try {
  1342	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1343	      const plans = campSeasonLoadPlan();
  1344	      const fresh = {};
  1345	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1346	      const dayOffKeys = dayOffYearKeys();
  1347	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1348	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1349	      for (const yearKey of dayOffKeys) {
  1350	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1351	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1352	        markDayOffYearInstalled(yearKey);
  1353	      }
  1354	      for (const plan of plans) {
  1355	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1356	        // prunes parked copies that are absent from `fresh`, so merging one
  1357	        // season against another's would evict the other's on every reload.
  1358	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1359	      }
  1360	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1361	      lessonDataLoadedSuccessfully = true;
  1362	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1363	      return 'ok';
  1364	    } catch (err) {
  1365	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1366	      if (!isCurrent()) return 'stale';
  1367	      lessonDataLoadedSuccessfully = false;
  1368	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1369	      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
  1370	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1371	      if (delay !== undefined) {
  1372	        setTimeout(() => {
  1373	          if (!isCurrent()) return; // a newer snapshot has taken over
  1374	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1375	        }, delay);
  1376	      }
  1377	      return 'failed';
  1378	    }
  1379	  };
  1380	
  1381	  // The registry-change entry point: same reload, same generation gate, and it
  1382	  // renders through the same callback when it is still the current generation.
  1383	  summerReloadHook = async () => {
  1384	    const myGeneration = ++globalListenerGeneration;
  1385	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1386	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1387	    return outcome;
  1388	  };
  1389	
  1390	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1391	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1392	      // Skip cache-only updates
  1393	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1394	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1395	        return;
  1396	      }
  1397	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1398	      if (!doc.exists) return;
  1399	
  1400	      const myGeneration = ++globalListenerGeneration;
  1401	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1402	      // in their own collection, so carry their current maps across the swap
  1403	      // and let the reload below refresh each one (Phase 1, 1.4).
  1404	      const previousSummer = snapshotCampSeasons();
  1405	      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
  1406	      // document once moved, so carry them across the swap like the camp seasons —
  1407	      // their own listeners below keep them current.
  1408	      const previousOwn = {};
  1409	      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
  1410	      currentLessonData = doc.data();
  1411	      lastLegacyLessonData = doc.data();
  1412	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1413	      for (const semKey of OWN_DOC_SEMESTERS) {
  1414	        const token = bumpOwnDocToken(semKey);
  1415	        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
  1416	          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
  1417	        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
  1418	          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
  1419	          recheckOwnDocAfterLegacyLoss(semKey, callback, token);
  1420	        } else if (semKey in currentLessonData) {
  1421	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1422	        }
  1423	      }
  1424	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1425	
  1426	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1427	      // A superseded reload renders nothing — the newer snapshot's own
  1428	      // callback already did (or will), with the same live object. A failed
  1429	      // one still renders: the non-summer semesters in this snapshot are new.
  1430	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1431	    });
  1432	
  1433	  // Own-doc semesters: one listener per document, plus the migration record.
  1434	  // They never bump globalListenerGeneration and never touch
  1435	  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
  2880	  return id;
  2881	}
  2882	
  2883	// A server copy of a plan this tab has verified (opened fresh, or saved and
  2884	// read back): installed, marked newer than any reload already in flight, slots
  2885	// rebuilt — no reload scheduled (a teacher's autosaves must not each cost
  2886	// three queries; plan, round 2).
  2887	function dayOffInstallVerified(yearKey, lessonKey, data) {
  2888	  const map = currentDayOffPlans[yearKey] = currentDayOffPlans[yearKey] || {};
  2889	  if (data) map[lessonKey] = data; else delete map[lessonKey];
  2890	  (dayOffVerifiedAt[yearKey] = dayOffVerifiedAt[yearKey] || {})[lessonKey] = ++dayOffInstallSeq;
  2891	  rebuildDayOffSlots(yearKey);
  2892	}
  2893	
  2894	// Which camp and project a plan key names — from the camp list itself, not the
  2895	// slot map (a reload can briefly swap currentLessonData out from under a save).
  2896	function dayOffFindProject(yearKey, lessonKey) {
  2897	  for (const camp of currentDayOffCamps[yearKey] || []) {
  2898	    for (const title of dayOffCampTitles(camp).keys()) {
  2899	      if (dayOffLessonKey(yearKey, camp.id, title) === lessonKey) return { campId: camp.id, projectTitle: title };
  2900	    }
  2901	  }
  2902	  return null;
  2903	}
  2904	
  2905	// Fresh server copy of one plan, for the editor to open from (shared plans:
  2906	// a co-teacher may have saved since this page loaded). Read inside a read-only
  2907	// transaction (Phase 3, Christie "#1", Sep 30): a get({source:'server'}) can
  2908	// answer with stale data after a Listen transport error (found in the Spring
  2909	// storage move), and the editor would then save over newer text unawares.
  2910	async function readDayOffPlanForEditor(yearKey, lessonKey) {
  2911	  const slot = dayOffFindProject(yearKey, lessonKey);
  2912	  if (!slot) return null;
  2913	  if (!curriculumDb) initCurriculumFirestore();
  2914	  const ref = curriculumDb.collection(DAY_OFF_COLLECTIONS.plans).doc(dayOffPlanDocId(yearKey, slot.campId, slot.projectTitle));
  2915	  const snap = await curriculumDb.runTransaction(tx => tx.get(ref));
  2916	  dayOffInstallVerified(yearKey, lessonKey, snap.exists ? snap.data() : null);
  2917	  return currentLessonData[yearKey]?.[lessonKey] || null;
  2918	}
  2919	
  2920	const DAY_OFF_RENAMED_MESSAGE = 'This project was renamed or removed by the planner — copy your text, close, and reopen the camp.';
  2921	
  2922	// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
  2923	//   'saved'      — my write is what the server holds;
  2924	//   'savedSince' — my write landed, then someone saved over it (last write
  2925	//                  wins; `by` names them, `own` = it was my own name);

exec
/bin/zsh -lc "rg -n \"markDayOffYearInstalled|dayOffRefreshFailed|loadDayOffCampData|async function loadLessonData|runTransaction\" js/firebase-data.js e2e/day-off-overview.spec.js; nl -ba js/firebase-data.js | sed -n '1170,1290p;1335,1485p;2350,2445p'; nl -ba js/app.js | sed -n '12658,12845p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
e2e/day-off-overview.spec.js:92:    const realRun = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-overview.spec.js:93:    curriculumDb.runTransaction = (fn) => realRun(async (tx) => {
e2e/day-off-overview.spec.js:170:      const real = window.loadDayOffCampData;
e2e/day-off-overview.spec.js:172:      window.loadDayOffCampData = async (opts) => { if (failNext) { failNext = false; throw new Error('TEST injected SDOC read failure'); } return real(opts); };
e2e/day-off-overview.spec.js:265:      const real = window.loadDayOffCampData;
e2e/day-off-overview.spec.js:268:      window.loadDayOffCampData = async (opts) => {
e2e/day-off-overview.spec.js:372:      try { await loadDayOffCampData({ yearKey: Y }); } finally { proto.get = real; }
js/firebase-data.js:951:async function loadLessonData() {
js/firebase-data.js:970:        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
js/firebase-data.js:971:        markDayOffYearInstalled(yearKey);
js/firebase-data.js:1246:// loadDayOffCampData() attached to its result; summer results carry none.
js/firebase-data.js:1303:const dayOffRefreshFailed = {};
js/firebase-data.js:1304:function markDayOffYearInstalled(yearKey) {
js/firebase-data.js:1306:  delete dayOffRefreshFailed[yearKey];
js/firebase-data.js:1347:      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
js/firebase-data.js:1352:        markDayOffYearInstalled(yearKey);
js/firebase-data.js:1369:      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
js/firebase-data.js:2398:async function loadDayOffCampData({ yearKey, isCurrent = () => true } = {}) {
js/firebase-data.js:2732:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:2826:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:2915:  const snap = await curriculumDb.runTransaction(tx => tx.get(ref));
js/firebase-data.js:2971:    await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3089:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3190:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3222:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3244:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3272:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3321:  await curriculumDb.runTransaction(async (tx) => {
js/firebase-data.js:3354:  await curriculumDb.runTransaction(async (tx) => {
  1170	  });
  1171	}
  1172	
  1173	// Forced-server read of one semester's whole lesson map in curriculum/lessonData
  1174	// (null when absent). Bypasses both the in-memory model and the SDK cache —
  1175	// used where the local cache is known to be untrustworthy for this key, e.g.
  1176	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
  1177	// when its server-side delete failed). Backtracking audit, Phase 11.
  1178	async function readServerSemesterLessonMap(semesterKey) {
  1179	  if (!curriculumDb) initCurriculumFirestore();
  1180	  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
  1181	}
  1182	
  1183	async function backupLessonData(semesterKey) {
  1184	  if (!curriculumDb) initCurriculumFirestore();
  1185	  const existing = currentLessonData?.[semesterKey];
  1186	  if (!existing || Object.keys(existing).length === 0) return 0;
  1187	  const count = Object.keys(existing).length;
  1188	  const user = getAuthUser();
  1189	  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
  1190	    [semesterKey]: existing,
  1191	    backupDate: new Date().toISOString(),
  1192	    backupBy: user?.name || 'Unknown'
  1193	  }, { merge: true });
  1194	  return count;
  1195	}
  1196	
  1197	async function restoreFromBackup(semesterKey) {
  1198	  if (!curriculumDb) initCurriculumFirestore();
  1199	  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
  1200	  if (!backupDoc.exists) return null;
  1201	  const backupData = backupDoc.data();
  1202	  const lessons = backupData?.[semesterKey];
  1203	  if (!lessons || Object.keys(lessons).length === 0) return null;
  1204	  await saveLessonData(semesterKey, lessons);
  1205	  return Object.keys(lessons).length;
  1206	}
  1207	
  1208	// "Which copy of a lesson is newer", by lastEditedAt — the only revision
  1209	// marker the data has (a client wall-clock heuristic: ties and missing values
  1210	// resolve to "not newer"). Shared by the listener merge below and the summer
  1211	// editor's own adoption/re-install logic (Backtracking audit Phase 10).
  1212	function lessonEditedAtMs(lesson) {
  1213	  return Date.parse(lesson?.lastEditedAt || '') || 0;
  1214	}
  1215	
  1216	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
  1217	// (everything else on the slot — teacher, camp, materials, sharedWith, class
  1218	// size… — is rebuilt from the other collections on every reload and must
  1219	// always come from the fresh read).
  1220	const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
  1221	// A reload's read can only plausibly predate a save this recent; a stamp
  1222	// older than this — or further than this into the future — is a skewed clock
  1223	// or a doc deleted/restored underneath us, and the fresh read wins.
  1224	const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
  1225	// When the merge keeps an in-memory copy, the server copy it displaced is
  1226	// parked here so the summer editor can fall back to it if the in-flight save
  1227	// that made the in-memory copy "newer" then fails (see openLessonModal()).
  1228	// Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
  1229	// share a lesson key — same teacher, camp, block and project in 2026 and
  1230	// 2027 — and a single-keyed map would park one season's server copy under
  1231	// the other's, then hand it back to the wrong editor.
  1232	const displacedSummerServerCopies = new Map();
  1233	const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
  1234	
  1235	// Backtracking audit Phase 7, handed over by Phase 10: a reload's collection
  1236	// read can predate a save that has since landed (or is in flight,
  1237	// optimistically installed). The fresh read is authoritative for WHICH
  1238	// lessons exist and for every scaffold-derived field; for the saved-doc
  1239	// fields, keep the in-memory copy when it is strictly newer — recently — than
  1240	// the freshly read one. The in-memory OBJECT is kept (updated in place), so
  1241	// the editor's identity checks on its optimistic entry still hold.
  1242	// protectedKeys (SDOC, Phase 2B): lessons whose fresh copy is a VERIFIED save
  1243	// newer than this reload's query — taken whole, never overridden by the
  1244	// clock-based keepMine below and never parked (a faster clock on an older
  1245	// in-memory copy must not put old text back). Defaults to the set
  1246	// loadDayOffCampData() attached to its result; summer results carry none.
  1247	function mergeSummerReload(semKey, previous, fresh, protectedKeys = fresh?.[DAY_OFF_PROTECTED] || null) {
  1248	  // A lesson the fresh scaffold no longer has is gone — nothing parked for it
  1249	  // may be resurrected by an editor fallback later. Only THIS semester's
  1250	  // parked copies are considered: pruning globally would evict the other
  1251	  // season's on every reload.
  1252	  const prefix = `${semKey}|`;
  1253	  for (const key of displacedSummerServerCopies.keys()) {
  1254	    if (!key.startsWith(prefix)) continue;
  1255	    if (!(key.slice(prefix.length) in fresh)) displacedSummerServerCopies.delete(key);
  1256	  }
  1257	  if (!previous) return fresh;
  1258	  const now = Date.now();
  1259	  for (const key of Object.keys(fresh)) {
  1260	    if (protectedKeys?.has(key)) { displacedSummerServerCopies.delete(displacedKey(semKey, key)); continue; }
  1261	    const mine = previous[key];
  1262	    const mineAt = lessonEditedAtMs(mine);
  1263	    const keepMine = mine && mineAt > lessonEditedAtMs(fresh[key]) && Math.abs(now - mineAt) < SUMMER_KEEP_MINE_WINDOW_MS;
  1264	    if (keepMine) {
  1265	      const saved = {};
  1266	      SUMMER_SAVED_FIELDS.forEach(f => { if (f in mine) saved[f] = mine[f]; });
  1267	      displacedSummerServerCopies.set(displacedKey(semKey, key), fresh[key]);
  1268	      // `mine` becomes exactly "fresh scaffold + my saved fields" — anything
  1269	      // else that was sitting on it (e.g. legacy Q&A mirror fields another
  1270	      // path installed) goes, so the object never carries stale extras.
  1271	      for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
  1272	      Object.assign(mine, fresh[key], saved);
  1273	      fresh[key] = mine;
  1274	    } else {
  1275	      displacedSummerServerCopies.delete(displacedKey(semKey, key));
  1276	    }
  1277	  }
  1278	  return fresh;
  1279	}
  1280	
  1281	// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
  1282	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1283	// Its outcome now drives the load-guard and the banner like the initial
  1284	// load does — a failure trips them, a later success resets them — and only
  1285	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1286	// unsubscribing a listener does not cancel its in-flight callback, so the
  1287	// generation counter is module-scoped across every setupLessonDataListener()
  1288	// call (and bumped by the call itself, so an old listener's in-flight reload
  1289	// is stale from the moment it is replaced). A tripped guard blocks every
  1290	// writer in the app, so a failed reload is retried a bounded number of times
  1335	  // One reload attempt for one snapshot generation. Only the latest
  1336	  // generation may touch the guard, the banner, or the summer cache.
  1337	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1338	  // outcome was discarded (a newer snapshot took over while it ran).
  1339	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1340	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1341	    try {
  1342	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1343	      const plans = campSeasonLoadPlan();
  1344	      const fresh = {};
  1345	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1346	      const dayOffKeys = dayOffYearKeys();
  1347	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1348	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1349	      for (const yearKey of dayOffKeys) {
  1350	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1351	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1352	        markDayOffYearInstalled(yearKey);
  1353	      }
  1354	      for (const plan of plans) {
  1355	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1356	        // prunes parked copies that are absent from `fresh`, so merging one
  1357	        // season against another's would evict the other's on every reload.
  1358	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1359	      }
  1360	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1361	      lessonDataLoadedSuccessfully = true;
  1362	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1363	      return 'ok';
  1364	    } catch (err) {
  1365	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1366	      if (!isCurrent()) return 'stale';
  1367	      lessonDataLoadedSuccessfully = false;
  1368	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1369	      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
  1370	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1371	      if (delay !== undefined) {
  1372	        setTimeout(() => {
  1373	          if (!isCurrent()) return; // a newer snapshot has taken over
  1374	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1375	        }, delay);
  1376	      }
  1377	      return 'failed';
  1378	    }
  1379	  };
  1380	
  1381	  // The registry-change entry point: same reload, same generation gate, and it
  1382	  // renders through the same callback when it is still the current generation.
  1383	  summerReloadHook = async () => {
  1384	    const myGeneration = ++globalListenerGeneration;
  1385	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1386	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1387	    return outcome;
  1388	  };
  1389	
  1390	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1391	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1392	      // Skip cache-only updates
  1393	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1394	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1395	        return;
  1396	      }
  1397	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1398	      if (!doc.exists) return;
  1399	
  1400	      const myGeneration = ++globalListenerGeneration;
  1401	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1402	      // in their own collection, so carry their current maps across the swap
  1403	      // and let the reload below refresh each one (Phase 1, 1.4).
  1404	      const previousSummer = snapshotCampSeasons();
  1405	      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
  1406	      // document once moved, so carry them across the swap like the camp seasons —
  1407	      // their own listeners below keep them current.
  1408	      const previousOwn = {};
  1409	      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
  1410	      currentLessonData = doc.data();
  1411	      lastLegacyLessonData = doc.data();
  1412	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1413	      for (const semKey of OWN_DOC_SEMESTERS) {
  1414	        const token = bumpOwnDocToken(semKey);
  1415	        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
  1416	          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
  1417	        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
  1418	          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
  1419	          recheckOwnDocAfterLegacyLoss(semKey, callback, token);
  1420	        } else if (semKey in currentLessonData) {
  1421	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1422	        }
  1423	      }
  1424	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1425	
  1426	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1427	      // A superseded reload renders nothing — the newer snapshot's own
  1428	      // callback already did (or will), with the same live object. A failed
  1429	      // one still renders: the non-summer semesters in this snapshot are new.
  1430	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1431	    });
  1432	
  1433	  // Own-doc semesters: one listener per document, plus the migration record.
  1434	  // They never bump globalListenerGeneration and never touch
  1435	  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
  1436	  // only that semester unwritable.
  1437	  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
  1438	    .onSnapshot(snap => {
  1439	      if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1440	      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
  1441	      updateOwnDocPausedNotice();
  1442	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));
  1443	  for (const semKey of OWN_DOC_SEMESTERS) {
  1444	    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
  1445	      .onSnapshot({ includeMetadataChanges: false }, snap => {
  1446	        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1447	        bumpOwnDocToken(semKey);
  1448	        if (snap.exists) {
  1449	          ownDocSource[semKey] = 'ownDoc';
  1450	          currentLessonData = currentLessonData || {};
  1451	          currentLessonData[semKey] = ownDocLessonMap(snap.data());
  1452	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1453	        } else if (ownDocSource[semKey] === 'ownDoc') {
  1454	          // Rolled back: the own document is gone — fall back to lessonData.
  1455	          ownDocSource[semKey] = 'legacy';
  1456	          const legacyMap = lastLegacyLessonData?.[semKey];
  1457	          if (legacyMap) currentLessonData[semKey] = legacyMap;
  1458	          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
  1459	        } else {
  1460	          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
  1461	          return;   // nothing changed for this tab
  1462	        }
  1463	        updateOwnDocPausedNotice();
  1464	        if (callback) callback(currentLessonData);
  1465	      }, err => {
  1466	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
  1467	        ownDocSource[semKey] = 'error';
  1468	        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
  1469	        updateOwnDocPausedNotice();
  1470	      }));
  1471	  }
  1472	}
  1473	
  1474	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1475	
  1476	async function loadCutProjects() {
  1477	  if (!curriculumDb) initCurriculumFirestore();
  1478	  try {
  1479	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1480	    currentCutProjects = doc.exists ? doc.data() : {};
  1481	  } catch (err) {
  1482	    console.error('Error loading cut projects:', err);
  1483	    currentCutProjects = {};
  1484	  }
  1485	  return currentCutProjects;
  2350	// from the event + camp, saved fields from the plan doc (Phase 2 writes them).
  2351	function buildDayOffSlots(yearKey, events, camps, plans = {}) {
  2352	  const eventsById = Object.fromEntries((events || []).map(e => [e.id, e]));
  2353	  const slots = {};
  2354	  for (const camp of camps || []) {
  2355	    const event = eventsById[camp.eventId] || {};
  2356	    const teachers = Array.isArray(camp.teachers) ? camp.teachers : [];
  2357	    for (const [projectTitle, blockLabel] of dayOffCampTitles(camp)) {
  2358	      const lessonKey = dayOffLessonKey(yearKey, camp.id, projectTitle);
  2359	      slots[lessonKey] = {
  2360	        ...(plans[lessonKey] || {}),
  2361	        yearKey,
  2362	        eventId: camp.eventId,
  2363	        eventLabel: event.label || '',
  2364	        dates: camp.dates || [],
  2365	        campId: camp.id,
  2366	        campName: camp.title || '',
  2367	        timeSlot: camp.timeSlot || '',
  2368	        timeLabel: camp.timeLabel || '',
  2369	        location: camp.location || '',
  2370	        placements: camp.placements || [],
  2371	        classSize: String(dayOffHeadcount(camp)),
  2372	        teachers,
  2373	        teacher: teachers.join(' + '),
  2374	        block: blockLabel,
  2375	        projectTitle,
  2376	        hasDetails: true,
  2377	        materialsList: plans[lessonKey]?.materialsList || [],
  2378	      };
  2379	    }
  2380	  }
  2381	  return slots;
  2382	}
  2383	
  2384	function sortDayOffEvents(events) {
  2385	  return [...events].sort((a, b) => String(a.dates?.[0] || '').localeCompare(String(b.dates?.[0] || '')) || String(a.label || '').localeCompare(String(b.label || '')));
  2386	}
  2387	
  2388	function dayOffQuery(coll, field, value) {
  2389	  return curriculumDb.collection(DAY_OFF_COLLECTIONS[coll]).where(field, '==', value);
  2390	}
  2391	async function dayOffServerDocs(coll, field, value) {
  2392	  const snap = await dayOffQuery(coll, field, value).get({ source: 'server' });
  2393	  return snap.docs.map(d => ({ id: d.id, ...d.data() }));
  2394	}
  2395	
  2396	// Three single-field equality queries — no composite index. A permission error
  2397	// (or any failure) throws, so the caller trips the app-wide load guard.
  2398	async function loadDayOffCampData({ yearKey, isCurrent = () => true } = {}) {
  2399	  if (!curriculumDb) initCurriculumFirestore();
  2400	  // Read BEFORE the queries: any plan verified after this point is newer than
  2401	  // what they return (Phase 2B — a reload must not undo a verified save).
  2402	  const startSeq = dayOffInstallSeq;
  2403	  // Server reads (Phase 3, Christie's yes Sep 29): offline, the load fails and
  2404	  // trips the guard instead of serving a cached or empty year as editable.
  2405	  const [eventSnap, campSnap, planSnap] = await Promise.all([
  2406	    dayOffQuery('events', 'yearKey', yearKey).get({ source: 'server' }),
  2407	    dayOffQuery('camps', 'yearKey', yearKey).get({ source: 'server' }),
  2408	    dayOffQuery('plans', 'yearKey', yearKey).get({ source: 'server' }),
  2409	  ]);
  2410	  const events = sortDayOffEvents(eventSnap.docs.map(d => ({ id: d.id, ...d.data() })));
  2411	  const camps = campSnap.docs.map(d => ({ id: d.id, ...d.data() }));
  2412	  const plans = {};
  2413	  const signoffs = {};
  2414	  planSnap.docs.forEach(d => {
  2415	    const p = d.data();
  2416	    if (isDayOffSignoffDoc(p)) { signoffs[p.campId] = p; return; }   // never a plan, never a slot
  2417	    plans[dayOffLessonKey(yearKey, p.campId, p.projectTitle)] = p;
  2418	  });
  2419	  const protectedKeys = new Set();
  2420	  for (const [key, seq] of Object.entries(dayOffVerifiedAt[yearKey] || {})) {
  2421	    const verified = currentDayOffPlans[yearKey]?.[key];
  2422	    if (seq > startSeq && verified) { plans[key] = verified; protectedKeys.add(key); }
  2423	  }
  2424	  if (isCurrent()) {
  2425	    currentDayOffEvents[yearKey] = events;
  2426	    currentDayOffCamps[yearKey] = camps;
  2427	    currentDayOffPlans[yearKey] = plans;
  2428	    currentDayOffSignoffs[yearKey] = signoffs;
  2429	  }
  2430	  const slots = buildDayOffSlots(yearKey, events, camps, plans);
  2431	  Object.defineProperty(slots, DAY_OFF_PROTECTED, { value: protectedKeys, enumerable: false });
  2432	  Object.defineProperty(slots, DAY_OFF_LOAD_START, { value: startSeq, enumerable: false });
  2433	  return slots;
  2434	}
  2435	
  2436	function rebuildDayOffSlots(yearKey) {
  2437	  if (!currentLessonData) currentLessonData = {};
  2438	  currentLessonData[yearKey] = buildDayOffSlots(yearKey, currentDayOffEvents[yearKey], currentDayOffCamps[yearKey], currentDayOffPlans[yearKey]);
  2439	}
  2440	
  2441	// ─── Validation (pure — the tests call these directly too) ─────────────────
  2442	
  2443	function trimOrEmpty(v) { return typeof v === 'string' ? v.trim() : ''; }
  2444	
  2445	function normaliseDayOffEvent(input) {
 12658	// An event's camps in card order: AM, full day, PM, then by title.
 12659	function dayOffEventCamps(yearKey, eventId) {
 12660	  return (currentDayOffCamps[yearKey] || []).filter(c => c.eventId === eventId)
 12661	    .sort((a, b) => ['AM', 'FULL', 'PM'].indexOf(a.timeSlot) - ['AM', 'FULL', 'PM'].indexOf(b.timeSlot) || String(a.title).localeCompare(String(b.title)));
 12662	}
 12663	
 12664	// ─── Plan overview (SDOC Phase 3) ───────────────────
 12665	// Read-only: computed from the slots buildDayOffSlots() already builds. Teachers
 12666	// save on other devices and there is no SDOC listener, so the year is re-read on
 12667	// Curriculum Admin entry, on switching to it, and by ↻ Refresh — always through
 12668	// the listener's own generation-gated reload, never a second loader.
 12669	let dayOffRefreshInFlight = null;
 12670	
 12671	function refreshDayOffYear(yearKey) {
 12672	  if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
 12673	  const run = (async () => {
 12674	    const outcome = await reloadSummerForModeChange();
 12675	    // The listener's callback redraws Curriculum Admin too, but draw here as
 12676	    // well: a failed outcome must show its message whoever registered last.
 12677	    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
 12678	    return outcome;
 12679	  })();
 12680	  dayOffRefreshInFlight = run;
 12681	  const done = () => {
 12682	    if (dayOffRefreshInFlight === run) dayOffRefreshInFlight = null;
 12683	    if (isDayOffYear(getAdminSemKey())) renderDayOffRefreshControls(getAdminSemKey());
 12684	  };
 12685	  run.then(done, done);
 12686	  renderDayOffRefreshControls(yearKey);   // disable the button now
 12687	  return run;
 12688	}
 12689	
 12690	function formatDayOffRefreshTime(d) {
 12691	  return d instanceof Date && !isNaN(d) ? d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' }) : '';
 12692	}
 12693	
 12694	function dayOffRefreshControlsHtml(yearKey) {
 12695	  const at = formatDayOffRefreshTime(dayOffLastRefreshAt[yearKey]);
 12696	  const busy = !!dayOffRefreshInFlight;
 12697	  const failed = !!dayOffRefreshFailed[yearKey];
 12698	  return `<span class="sdoc-refresh" id="sdoc-refresh">
 12699	      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
 12700	      <button class="btn-text" id="sdoc-refresh-btn" type="button" onclick="refreshDayOffYear(getAdminSemKey())" ${busy ? 'disabled' : ''}>${busy ? 'Refreshing…' : '↻ Refresh'}</button>
 12701	      ${failed ? `<span id="sdoc-refresh-error" class="sdoc-refresh-error">Couldn't refresh — showing the last full refresh${at ? ` (${sdocEsc(at)})` : ''}</span>` : ''}
 12702	    </span>`;
 12703	}
 12704	
 12705	// Just the header controls (busy state) — the rows wait for the outcome's redraw.
 12706	function renderDayOffRefreshControls(yearKey) {
 12707	  const el = document.getElementById('sdoc-refresh');
 12708	  if (el) el.outerHTML = dayOffRefreshControlsHtml(yearKey);
 12709	}
 12710	
 12711	// Same status the teachers' list shows; 'ready' ("Almost Done") can't happen for
 12712	// an SDOC slot (campName zeroes materials) and reads as In Progress if it ever does.
 12713	function dayOffPlanProgress(slot) {
 12714	  const p = calculateLessonProgress(slot);
 12715	  return p === 'ready' ? 'in-progress' : p;
 12716	}
 12717	
 12718	// A camp's plans in dayOffCampTitles() order — one per title, however many days it runs.
 12719	function dayOffCampPlanSlots(yearKey, camp) {
 12720	  const slots = currentLessonData?.[yearKey] || {};
 12721	  return [...dayOffCampTitles(camp).keys()]
 12722	    .map(title => ({ lessonKey: dayOffLessonKey(yearKey, camp.id, title), title }))
 12723	    .filter(({ lessonKey }) => slots[lessonKey])
 12724	    .map(p => ({ ...p, slot: slots[p.lessonKey] }));
 12725	}
 12726	
 12727	function renderDayOffPlansCell(yearKey, camp) {
 12728	  const plans = dayOffCampPlanSlots(yearKey, camp);
 12729	  if (!plans.length) return '<span class="settings-hint">no projects yet</span>';
 12730	  return plans.map(({ lessonKey, title, slot }) => {
 12731	    const progress = dayOffPlanProgress(slot);
 12732	    const date = String(slot.lastEditedAt || '').slice(0, 10);
 12733	    const edited = slot.lastEditedBy
 12734	      ? `<div class="sdoc-plan-edited settings-hint">last edited by ${sdocEsc(slot.lastEditedBy)}${isIsoDate(date) ? `, ${sdocEsc(formatDayOffDate(date, { month: 'short', day: 'numeric' }))}` : ''}</div>`
 12735	      : '';
 12736	    return `<div class="sdoc-plan" data-lesson-key="${sdocEscA(lessonKey)}">
 12737	        <span class="sdoc-plan-title">${sdocEsc(title)}</span>
 12738	        <span class="sdoc-plan-status sdoc-tv-status progress-${progress}">${getProgressLabel(progress)}</span>
 12739	        <button class="btn-text sdoc-plan-open-btn" type="button" onclick="openDayOffPlanFromAdmin(this.closest('.sdoc-plan').dataset.lessonKey)">Open plan</button>
 12740	        ${edited}
 12741	      </div>`;
 12742	  }).join('');
 12743	}
 12744	
 12745	// "Plans: c of n complete · k not started" — n counts (camp, title) pairs.
 12746	function dayOffEventRollupHtml(yearKey, evCamps) {
 12747	  const plans = evCamps.flatMap(c => dayOffCampPlanSlots(yearKey, c));
 12748	  if (!plans.length) return '';
 12749	  const progress = plans.map(p => dayOffPlanProgress(p.slot));
 12750	  const complete = progress.filter(p => p === 'complete').length;
 12751	  const notStarted = progress.filter(p => p === 'not-started').length;
 12752	  return `<div class="sdoc-event-rollup">Plans: ${complete} of ${plans.length} complete${notStarted ? ` · ${notStarted} not started` : ''}</div>`;
 12753	}
 12754	
 12755	function openDayOffPlanFromAdmin(lessonKey) {
 12756	  const yearKey = getAdminSemKey();
 12757	  return openPlanEditor(yearKey, lessonKey, {
 12758	    onClosed: () => { if (getAdminSemKey() === yearKey) renderAdminGrid(); },
 12759	  });
 12760	}
 12761	
 12762	function renderDayOffAdmin(yearKey) {
 12763	  const wrapper = document.getElementById('ca-grid-wrapper');
 12764	  if (!wrapper) return;
 12765	  const year = currentConfig?.semesters?.[yearKey] || {};
 12766	  const events = currentDayOffEvents[yearKey] || [];
 12767	  const camps = currentDayOffCamps[yearKey] || [];
 12768	  const writable = lessonDataLoadedSuccessfully !== false;
 12769	  // Planner buttons only for users the rules let save them (Phase 2A);
 12770	  // the prep team sees the list read-only, with the materials checklist.
 12771	  const planner = canPlanDayOffCamps();
 12772	  const ticker = canTickDayOffMaterials();
 12773	  const dis = writable ? '' : 'disabled';
 12774	
 12775	  const head = `
 12776	    <div class="sdoc-admin-header">
 12777	      <h2>${sdocEsc(year.name)}<span class="sdoc-count">${events.length} event${events.length === 1 ? '' : 's'}, ${camps.length} camp${camps.length === 1 ? '' : 's'}</span></h2>
 12778	      ${dayOffRefreshControlsHtml(yearKey)}
 12779	      ${planner ? `<button class="btn-primary write-control" onclick="openDayOffEventEditor(null)" ${dis}>+ Add event</button>` : '<span class="settings-hint">View only — events and camps are planned by Christie and Anika.</span>'}
 12780	    </div>`;
 12781	  if (events.length === 0) {
 12782	    wrapper.innerHTML = `<div class="sdoc-admin">${head}<div class="tv-placeholder">No day-off dates yet — add the first one from the district calendar.</div></div>`;
 12783	    return;
 12784	  }
 12785	
 12786	  let html = '';
 12787	  let month = '';
 12788	  for (const ev of events) {
 12789	    const m = formatDayOffDate(ev.dates?.[0], { month: 'long', year: 'numeric' });
 12790	    if (m !== month) { html += `<div class="sdoc-month">${sdocEsc(m)}</div>`; month = m; }
 12791	    const evCamps = dayOffEventCamps(yearKey, ev.id);
 12792	    // Phase 2A.1: one checklist for the whole event, for everyone who ticks —
 12793	    // shown once any of its camps has an item.
 12794	    const evMat = evCamps.reduce((t, c) => { const s = dayOffCampMaterialsSummary(yearKey, c); return { items: t.items + s.items, ticked: t.ticked + s.ticked }; }, { items: 0, ticked: 0 });
 12795	    const evMatBtn = ticker && evMat.items
 12796	      ? `<button class="btn-secondary sdoc-event-mat-btn" onclick="openDayOffEventMaterials(this.closest('.sdoc-event-card').dataset.eventId)">Materials checklist · ${evMat.ticked} of ${evMat.items} ticked</button>`
 12797	      : '';
 12798	    const rows = evCamps.map(c => `
 12799	      <tr data-camp-id="${sdocEscA(c.id)}">
 12800	        <td><strong>${sdocEsc(c.title)}</strong>${c.notes ? `<div class="settings-hint">${sdocEsc(c.notes)}</div>` : ''}</td>
 12801	        <td>${sdocEsc(c.timeSlot === 'FULL' ? 'Full day' : c.timeSlot)} · ${sdocEsc(c.timeLabel)}</td>
 12802	        <td>${sdocEsc(c.location)}<div class="settings-hint">${(c.placements || []).map(p => `${sdocEsc(p.studio)} ${sdocEsc(p.ageRange)} ×${sdocEsc(p.capacity)}`).join(', ')} — <span class="sdoc-headcount">${dayOffHeadcount(c)}</span></div></td>
 12803	        <td>${(c.teachers || []).length ? sdocEsc(c.teachers.join(', ')) : '<span class="settings-hint">none yet</span>'}</td>
 12804	        <td>${(c.dates || []).map(d => {
 12805	          const day = normaliseDayOffDayBlocks(c.projects?.[d]);
 12806	          const parts = SDOC_BLOCKS.map(b => day[b.key] ? sdocEsc(day[b.key]) : (SDOC_PROJECT_BLOCK_KEYS.includes(b.key) ? '<span class="sdoc-tbd">to fill</span>' : '')).filter(Boolean);
 12807	          return `<div class="sdoc-day-line"><strong>${sdocEsc(formatDayOffDate(d, { weekday: 'short' }))}</strong> ${parts.join(' · ')}</div>`;
 12808	        }).join('')}${(() => { const f = dayOffBlocksToFill(c); return f.empty ? `<div class="sdoc-to-fill">${f.empty} of ${f.total} blocks to fill</div>` : ''; })()}</td>
 12809	        <td class="sdoc-plans-cell">${renderDayOffPlansCell(yearKey, c)}</td>
 12810	        <td>${renderDayOffMaterialsCell(yearKey, c, { planner, ticker, dis })}</td>
 12811	        <td class="sdoc-actions">${planner ? `
 12812	          <button class="btn-text write-control" onclick="openDayOffCampEditor(${escForOnclick(ev.id)}, ${escForOnclick(c.id)})" ${dis}>Edit</button>
 12813	          <button class="btn-text write-control" onclick="removeDayOffCamp(${escForOnclick(c.id)})" ${dis}>Remove</button>` : ''}
 12814	        </td>
 12815	      </tr>`).join('');
 12816	    html += `
 12817	      <div class="sdoc-event-card" data-event-id="${sdocEscA(ev.id)}">
 12818	        <div class="sdoc-event-head">
 12819	          <div>
 12820	            <div class="sdoc-event-title">${sdocEsc(ev.label)}</div>
 12821	            <div class="sdoc-chips">${dayOffDateRuns(ev.dates).map(r => `<span class="sdoc-chip">${sdocEsc(r)}</span>`).join('')}${ev.district ? `<span class="sdoc-chip sdoc-district">${sdocEsc(ev.district)}</span>` : ''}</div>
 12822	            ${ev.notes ? `<div class="sdoc-event-notes">${sdocEsc(ev.notes)}</div>` : ''}
 12823	            ${dayOffEventRollupHtml(yearKey, evCamps)}
 12824	          </div>
 12825	          <div class="sdoc-actions">${evMatBtn}${planner ? `
 12826	            <button class="btn-secondary write-control" onclick="openDayOffCampEditor(${escForOnclick(ev.id)}, null)" ${dis}>+ Add camp</button>
 12827	            <button class="btn-text write-control" onclick="openDayOffEventEditor(${escForOnclick(ev.id)})" ${dis}>Edit</button>
 12828	            <button class="btn-text write-control" onclick="removeDayOffEvent(${escForOnclick(ev.id)})" ${dis}>Remove</button>` : ''}
 12829	          </div>
 12830	        </div>
 12831	        ${evCamps.length ? `<div class="sdoc-table-scroll"><table class="sdoc-camps-table">
 12832	          <thead><tr><th>Camp</th><th>Slot &amp; hours</th><th>Location · placements · headcount</th><th>Teachers</th><th>Days &amp; projects</th><th>Plans</th><th>Materials</th><th></th></tr></thead>
 12833	          <tbody>${rows}</tbody></table></div>` : '<div class="sdoc-empty">No camps yet.</div>'}
 12834	      </div>`;
 12835	  }
 12836	  wrapper.innerHTML = `<div class="sdoc-admin">${head}${html}</div>`;
 12837	}
 12838	
 12839	function closeDayOffEditor(id, { force = false } = {}) {
 12840	  if (!force && dayOffEditor?.dirty && !confirm('Discard your changes?')) return;
 12841	  document.getElementById(id)?.classList.remove('open');
 12842	  dayOffEditor = null;
 12843	}
 12844	
 12845	function markDayOffEditorDirty() { if (dayOffEditor) dayOffEditor.dirty = true; }

codex
The main integration is internally consistent so far. I’m now checking the less obvious regressions: hidden-view redraw state, multi-year failure attribution, refresh concurrency semantics, and whether P1–P16 actually detect those failures.
exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '930,1015p;1435,1472p'; rg -n \"function renderSummerCA|ca-grid-wrapper|expanded|summer.*expand|action\" js/app.js | head -100; nl -ba e2e/day-off-overview.spec.js | sed -n '1,430p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
   930	// either, say so.
   931	async function recheckOwnDocAfterLegacyLoss(semKey, callback, token) {
   932	  try {
   933	    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
   934	    // A later snapshot (the own-doc listener, or a rollback) has spoken since this
   935	    // read began — its state is newer than this answer, so drop it.
   936	    if (ownDocTransitionToken[semKey] !== token || ownDocSource[semKey] === 'ownDoc') return;
   937	    if (own.exists) {
   938	      ownDocSource[semKey] = 'ownDoc';
   939	      currentLessonData[semKey] = ownDocLessonMap(own.data());
   940	      updateOwnDocPausedNotice();
   941	      if (callback) callback(currentLessonData);
   942	      return;
   943	    }
   944	  } catch (err) {
   945	    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
   946	  }
   947	  if (ownDocTransitionToken[semKey] !== token) return;
   948	  showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
   949	}
   950	
   951	async function loadLessonData() {
   952	  if (!curriculumDb) initCurriculumFirestore();
   953	  try {
   954	    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
   955	    currentLessonData = doc.exists ? doc.data() : {};
   956	    lastLegacyLessonData = doc.exists ? doc.data() : {};
   957	    await loadOwnDocSemesters();
   958	
   959	    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
   960	    try {
   961	      const plans = campSeasonLoadPlan();
   962	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   963	      for (const plan of plans) {
   964	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   965	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   966	      }
   967	      // School Day Off Camps years: their own three collections. A failure
   968	      // trips the same app-wide guard — loud, never a quiet empty list.
   969	      for (const yearKey of dayOffYearKeys()) {
   970	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
   971	        markDayOffYearInstalled(yearKey);
   972	        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
   973	      }
   974	      lessonDataLoadedSuccessfully = true;
   975	    } catch (err) {
   976	      // One season failing trips the guard for the whole app: a partially
   977	      // loaded model is not a safe base for any writer, in any semester.
   978	      console.error('❌ Could not load camp season data:', err);
   979	      lessonDataLoadedSuccessfully = false;
   980	    }
   981	  } catch (err) {
   982	    console.error('Error loading lesson data:', err);
   983	    currentLessonData = {};
   984	    lessonDataLoadedSuccessfully = false;
   985	  }
   986	  return currentLessonData;
   987	}
   988	
   989	// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
   990	// createLessonSlotsForRoster). Guarded the same way as
   991	// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
   992	// partial currentLessonData (or, for restoreFromBackup, would land over a
   993	// semester whose current state this client never confirmed), and merge:true
   994	// would still write it over the real semester map. Throws rather than no-ops —
   995	// every caller treats a resolved promise as "the write landed" (backtracking
   996	// audit, Phase 11).
   997	async function saveLessonData(semesterKey, lessons) {
   998	  if (lessonDataLoadedSuccessfully === false) {
   999	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1000	  }
  1001	  if (!curriculumDb) initCurriculumFirestore();
  1002	
  1003	  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
  1004	  // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
  1005	  // and any other type is refused rather than misrouted.
  1006	  if (lessonStoreFor(semesterKey) === 'camp') {
  1007	    return await saveSummerCampLessonData(semesterKey, lessons);
  1008	  }
  1009	
  1010	  // Regular semester: save to curriculum/lessonData — or, for an own-doc
  1011	  // semester, to its own document (the whole map at the top level).
  1012	  const user = getAuthUser();
  1013	  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
  1014	  if (isOwnDocSemester(semesterKey)) {
  1015	    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
  1435	  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
  1436	  // only that semester unwritable.
  1437	  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
  1438	    .onSnapshot(snap => {
  1439	      if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1440	      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
  1441	      updateOwnDocPausedNotice();
  1442	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));
  1443	  for (const semKey of OWN_DOC_SEMESTERS) {
  1444	    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
  1445	      .onSnapshot({ includeMetadataChanges: false }, snap => {
  1446	        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1447	        bumpOwnDocToken(semKey);
  1448	        if (snap.exists) {
  1449	          ownDocSource[semKey] = 'ownDoc';
  1450	          currentLessonData = currentLessonData || {};
  1451	          currentLessonData[semKey] = ownDocLessonMap(snap.data());
  1452	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1453	        } else if (ownDocSource[semKey] === 'ownDoc') {
  1454	          // Rolled back: the own document is gone — fall back to lessonData.
  1455	          ownDocSource[semKey] = 'legacy';
  1456	          const legacyMap = lastLegacyLessonData?.[semKey];
  1457	          if (legacyMap) currentLessonData[semKey] = legacyMap;
  1458	          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
  1459	        } else {
  1460	          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
  1461	          return;   // nothing changed for this tab
  1462	        }
  1463	        updateOwnDocPausedNotice();
  1464	        if (callback) callback(currentLessonData);
  1465	      }, err => {
  1466	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
  1467	        ownDocSource[semKey] = 'error';
  1468	        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
  1469	        updateOwnDocPausedNotice();
  1470	      }));
  1471	  }
  1472	}
476:          <span class="status-card-fraction">${complete}/${total} complete</span>
618:// against the fresh camp inside the save's transaction. The classbook key is
685:  // Skip re-render while a camp is expanded — preserves expanded state on live data updates
1047:  const expanded = container.dataset.expanded === 'true';
1052:        <span class="progress-collapse-icon">${expanded ? '&#9660;' : '&#9654;'}</span>
1055:      <div class="progress-dashboard-body" id="progress-dashboard-body" style="display: ${expanded ? 'block' : 'none'};">
1076:    container.dataset.expanded = wasExpanded ? 'false' : 'true';
1229:  const expanded = container.dataset.expanded === 'true'; // Default to collapsed
1234:        <span class="progress-collapse-icon">${expanded ? '&#9660;' : '&#9654;'}</span>
1237:      <div class="progress-dashboard-body" id="progress-dashboard-body" style="display: ${expanded ? 'block' : 'none'};">
1259:    container.dataset.expanded = wasExpanded ? 'false' : 'true';
1347:  // Check saved state, or default to expanded if there are admin replies
1348:  const savedState = panel.dataset.expanded;
1349:  const expanded = savedState !== undefined ? savedState !== 'false' : adminReplies.length > 0;
1353:      <span id="tv-qa-toggle-icon">${expanded ? '&#9660;' : '&#9654;'}</span>
1356:    <div class="tv-qa-panel-list" id="tv-qa-panel-list" style="display: ${expanded ? 'block' : 'none'};">`;
1416:            if (expandBtn && expandBtn.dataset.expanded === 'false') {
1434:  panel.dataset.expanded = wasExpanded ? 'false' : 'true';
2202:            <div class="tv-week-actions">
2208:          <div id="${detailId}" class="tv-expanded-content hidden">
2284:          </div> <!-- End tv-expanded-content -->
2286:          <!-- Plan Complete checkbox (appears after "Show details" when collapsed, at bottom when expanded) -->
2609:      <div class="tv-class-header tv-collapse-toggle" role="button" tabindex="0" aria-expanded="${open}">
2671:      <div class="tv-week-header tv-collapse-toggle" role="button" tabindex="0" aria-expanded="${open}">
2788:    html += `<button class="tv-expand-btn" data-expanded="false">Show details</button>
2789:    <div class="tv-expanded-content" style="display: none;">`;
2851:  section.querySelector('.tv-collapse-toggle')?.setAttribute('aria-expanded', String(open));
2875:      const expanded = btn.dataset.expanded === 'true';
2876:      btn.dataset.expanded = expanded ? 'false' : 'true';
2877:      btn.textContent = expanded ? 'Show details' : 'Hide details';
2878:      content.style.display = expanded ? 'none' : 'block';
3996:    action: 'edit',
4294:function renderSummerCA(lessons) {
4295:  const wrapper = document.getElementById('ca-grid-wrapper');
5140:  const wrapper = document.getElementById('ca-grid-wrapper');
5283:        html += `<td class="ca-grid-cell ca-filled-cell ${isCurr ? 'ca-current-col' : ''} ${isSource ? 'ca-source-cell' : ''} ${isActionTarget ? 'ca-action-target' : ''}"
5295:        html += `<td class="ca-grid-cell ca-empty-cell ${isCurr ? 'ca-current-col' : ''} ${isActionTarget ? 'ca-action-target' : ''}"
5308:    html = `<div class="ca-action-banner">
5327:  // If in action mode (move/swap), handle destination
5418:    html += `<div class="ca-actions">
5419:      <button class="btn-primary ca-action-btn" onclick="showAdminEdit(${escForOnclick(key)}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">&#9998; Edit</button>
5420:      <button class="btn-primary ca-action-btn" onclick="printSingleLesson(${escForOnclick(key)})">&#128424; Print</button>
5421:      <button class="btn-primary ca-action-btn" onclick="startMove(${escForOnclick(key)})">Move</button>
5422:      <button class="btn-primary ca-action-btn ca-swap-btn" onclick="startSwap(${escForOnclick(key)})">Swap</button>
5423:      ${hasPlanContent && shared.length > 0 ? `<button class="btn-primary ca-action-btn ca-copy-btn" onclick="openCopyPlanUI(${escForOnclick(key)})">Copy Plan to Others</button>` : ''}
5424:      <button class="btn-secondary ca-action-btn ca-cut-btn" onclick="cutProject(${escForOnclick(key)})">Cut</button>
5438:    html += `<div class="ca-actions">
5439:      <button class="btn-secondary ca-action-btn" onclick="showPasteFromCutBank(${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Paste from Cut Bank</button>
5440:      <button class="btn-secondary ca-action-btn" style="border-color:var(--tinker-teal);color:var(--tinker-teal)" onclick="showPasteFromIdeaBank(${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Paste from Idea Bank</button>
5601:    <div class="ca-actions" style="margin-top:12px">
5602:      <button class="btn-primary ca-action-btn" onclick="saveAdminEdit(${escForOnclick(key)}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Save</button>
5603:      <button class="btn-secondary ca-action-btn" onclick="printAdminLesson(${escForOnclick(key)})">&#128438; Print</button>
5604:      <button class="btn-secondary ca-action-btn" onclick="closeAdminModal()">Cancel</button>
5663:  // Every action button in the modal body — the form's own Save/Print/Cancel
5667:  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
5896:      action: existing.projectTitle ? 'edit' : 'create',
5939:// machine loop; closing it fully would need a Firestore transaction.
5961:// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
6055:          action: 'move',
6153:          action: 'swap',
6227:    <div class="ca-actions" style="margin-top: 16px;">
6228:      <button class="btn-primary ca-action-btn ca-copy-btn" onclick="executeCopyPlan(${escForOnclick(sourceKey)})">Copy Plan</button>
6229:      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData[${escForOnclick(semKey)}][${escForOnclick(sourceKey)}], ${escForOnclick(sourceKey)}, ${escForOnclick(source.teacher)}, ${escForOnclick(source.className)}, ${source.weekNum})">Back</button>
6308:        action: 'copy',
6438:      action: 'cut',
6616:      action: 'paste',
6672:      <div class="ca-cutbank-expanded" style="display:none">`;
6692:  html += `<div class="ca-cutbank-actions">
6822:      <div class="ca-ideabank-item-actions">
6863:    <div class="ca-ideabank-form-actions">
7102:      action: 'paste',
7437:    stats[entry.action] = (stats[entry.action] || 0) + 1;
7456:    switch (entry.action) {
7487:        desc = `${entry.action}: ${d.projectTitle || ''}`;
7490:    if (entry.action === 'copy' && d.previousPlan) {
7505:      <span class="ca-history-action ca-action-${entry.action}">${entry.action}</span>
7883:    html += `<div class="forecast-project ${isDismissed ? 'forecast-dismissed' : ''}" data-expanded="false" data-norm-key="${escAttr(normKey)}">
7948:      const expanded = proj.dataset.expanded === 'true';
7949:      proj.dataset.expanded = String(!expanded);
11008:    <div class="settings-actions" style="justify-content:flex-start;gap:0.5rem;">
12353:// After the summer editor closes: re-expand the camp and the project it came from.
12355:    // Restore expanded state after render completes
12763:  const wrapper = document.getElementById('ca-grid-wrapper');
12811:        <td class="sdoc-actions">${planner ? `
12825:          <div class="sdoc-actions">${evMatBtn}${planner ? `
12911:    <div class="settings-actions">
13063:    <div class="settings-actions">
13275:// ticks and material actions — which redraw the materials body wholesale —
13319:      <div class="sdoc-details-actions">
13449:      <td class="sdoc-actions"><button class="btn-primary" onclick="saveDayOffMaterialRow(this)">${it ? 'Save' : 'Add'}</button>${it ? '<button class="btn-text" onclick="cancelDayOffMaterialEdit(this)">Cancel</button>' : ''}</td>
13463:      <td class="sdoc-actions">${planner ? `
13477:    <div class="settings-actions"><button class="btn-secondary" onclick="closeDayOffMaterials()">Done</button></div>`;
13709:    <div class="settings-actions"><button class="btn-secondary" onclick="closeDayOffEventMaterials()">Done</button></div>`;
     1	/**
     2	 * School Day Off Camps — Phase 3: the planner's plan overview.
     3	 * Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 3, revision 5,
     4	 * re-verified against 132fef2; Christie's go Sep 29, "#1" Sep 30).
     5	 *
     6	 * Curriculum Admin on an SDOC year: a Plans column per camp (status, last editor, Open plan),
     7	 * a per-event roll-up, "Last full refresh" + ↻ Refresh. Plus the two shared pieces the design
     8	 * changes: one listener callback for both views (onLessonDataReload), and the 2B editor's
     9	 * transactional open read.
    10	 *
    11	 * EMULATOR ONLY. Sessions: planner = the seeded MANAGER; prep = the suite's default account
    12	 * (['classbook', 'curriculum-admin'] — Kathy and Allie's access). The TEST year lives only in
    13	 * each page's currentConfig; every doc carries yearKey TEST_DATA_SAFETY_sdoc and is purged.
    14	 */
    15	const { test, expect } = require('@playwright/test');
    16	const { MANAGER_STATE_PATH } = require('./helpers/login');
    17	const { Y, setup, teardown, attempt, makeEvent } = require('./helpers/sdoc');
    18	
    19	let planner, plannerCtx, prep;
    20	
    21	test.beforeEach(async ({ browser, page }) => {
    22	  plannerCtx = await browser.newContext({ storageState: MANAGER_STATE_PATH });
    23	  planner = await plannerCtx.newPage();
    24	  await setup(planner, 'manager');
    25	  prep = page;
    26	  await setup(prep, 'admin', { purge: false });
    27	});
    28	
    29	test.afterEach(async () => {
    30	  await teardown(planner);
    31	  await plannerCtx.close();
    32	});
    33	
    34	const key = (camp, title) => `${Y}|||${camp.id}|||${title}`;
    35	const cssStr = (v) => v.replace(/\\/g, '\\\\').replace(/"/g, '\\"');   // a CSS attribute-selector string
    36	const planRow = (page, camp, title) => page.locator(`.sdoc-plans-cell .sdoc-plan[data-lesson-key="${cssStr(key(camp, title))}"]`);
    37	const rollup = (page, ev) => page.locator(`.sdoc-event-card[data-event-id="${ev.id}"] .sdoc-event-rollup`);
    38	
    39	async function saveCamp(page, camp) {
    40	  const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, camp, null), { Y, camp });
    41	  expect(r.ok, r.message).toBe(true);
    42	  return r.value;
    43	}
    44	// "Another device": a direct write of plan fields (merge), as a teacher's save would leave them.
    45	async function writePlan(page, camp, title, fields) {
    46	  await page.evaluate(({ Y, id, title, fields }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, title))
    47	    .set({ yearKey: Y, campId: id, projectTitle: title, ...fields }, { merge: true }), { Y, id: camp.id, title, fields });
    48	}
    49	const readPlan = (page, camp, title) =>
    50	  page.evaluate(({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
    51	
    52	// Thanksgiving: Clay Creatures camp (Mon "Clay Creatures" + n/a + Open Studio, Tue "Glaze Day" + "—",
    53	// Wed "Clay Creatures" again) and Paint Party (Mon "Canvas").
    54	async function makeThanksgiving(page = planner) {
    55	  const ev = await makeEvent(page);
    56	  const clay = await saveCamp(page, {
    57	    eventId: ev.id, title: 'TEST Clay Creatures', timeSlot: 'AM', timeLabel: '9–12', location: 'Tinker',
    58	    placements: [{ studio: 'AG', ageRange: '5–7', capacity: 12 }],
    59	    teachers: ['TESTteacher1', 'TESTteacher2'], dates: ['2026-11-23', '2026-11-24', '2026-11-25'],
    60	    projects: {
    61	      '2026-11-23': { block1: 'Clay Creatures', block2: 'n/a', openStudio: 'Open Studio' },
    62	      '2026-11-24': { block1: 'Glaze Day', block2: '—' },
    63	      '2026-11-25': { block1: 'Clay Creatures' },
    64	    },
    65	    notes: '',
    66	  });
    67	  const paint = await saveCamp(page, {
    68	    eventId: ev.id, title: 'TEST Paint Party', timeSlot: 'PM', timeLabel: '1–3', location: 'Tinker',
    69	    placements: [{ studio: 'AG', ageRange: '5–7', capacity: 10 }],
    70	    teachers: ['TESTteacher1'], dates: ['2026-11-23'], projects: { '2026-11-23': { block1: 'Canvas' } }, notes: '',
    71	  });
    72	  return { ev, clay, paint };
    73	}
    74	
    75	// Show the SDOC year on Curriculum Admin (the header switch — itself one automatic refresh).
    76	async function showYear(page) {
    77	  await page.evaluate((Y) => { switchTab('curriculum-admin'); setGlobalSemester(Y); }, Y);
    78	  await page.evaluate((Y) => refreshDayOffYear(Y), Y);   // shares the in-flight one the switch started
    79	  await expect(page.locator('.sdoc-admin')).toBeVisible();
    80	}
    81	
    82	// Records every DocumentReference set/update/delete and every transaction write.
    83	async function spyWrites(page) {
    84	  await page.evaluate(() => {
    85	    const proto = Object.getPrototypeOf(curriculumDb.collection('x').doc('y'));
    86	    const calls = [];
    87	    window.__writes = calls;
    88	    for (const m of ['set', 'update', 'delete']) {
    89	      const real = proto[m];
    90	      proto[m] = function (...args) { calls.push(`${m} ${this.path}`); return real.apply(this, args); };
    91	    }
    92	    const realRun = curriculumDb.runTransaction.bind(curriculumDb);
    93	    curriculumDb.runTransaction = (fn) => realRun(async (tx) => {
    94	      for (const m of ['set', 'update', 'delete']) {
    95	        const real = tx[m].bind(tx);
    96	        tx[m] = (ref, ...rest) => { calls.push(`tx.${m} ${ref.path}`); return real(ref, ...rest); };
    97	      }
    98	      return fn(tx);
    99	    });
   100	  });
   101	}
   102	const writes = (page) => page.evaluate(() => window.__writes.slice());
   103	
   104	test.describe('School Day Off Camps — Phase 3: the planner\'s plan overview', () => {
   105	
   106	  test('P1: statuses, last editor and the roll-up — the same status the teachers\' list shows; a bad date shows no date', async () => {
   107	    const { ev, clay, paint } = await makeThanksgiving();
   108	    await writePlan(planner, clay, 'Clay Creatures', { introPitch: 'TEST intro', processStep1: 'TEST step', lastEditedBy: 'TESTteacher2', lastEditedAt: '2026-10-05T14:22:31.123Z', lastEditId: 'eotherdevice0001' });
   109	    await writePlan(planner, paint, 'Canvas', { planComplete: true, lastEditedBy: 'TESTteacher1', lastEditedAt: 'garbage', lastEditId: 'eotherdevice0002' });
   110	    await showYear(planner);
   111	
   112	    await expect(planRow(planner, clay, 'Clay Creatures').locator('.sdoc-plan-status')).toHaveText('In Progress');
   113	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('Not Started');
   114	    await expect(planRow(planner, paint, 'Canvas').locator('.sdoc-plan-status')).toHaveText('Complete');
   115	    await expect(planRow(planner, clay, 'Clay Creatures').locator('.sdoc-plan-edited')).toHaveText('last edited by TESTteacher2, Oct 5');
   116	    await expect(planRow(planner, paint, 'Canvas').locator('.sdoc-plan-edited')).toHaveText('last edited by TESTteacher1');
   117	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-edited')).toHaveCount(0);
   118	    await expect(rollup(planner, ev)).toHaveText('Plans: 1 of 3 complete · 1 not started');
   119	
   120	    // Agrees with the teachers' list for every slot (same calculateLessonProgress + getProgressLabel).
   121	    const agree = await planner.evaluate((Y) => Object.entries(currentLessonData[Y]).every(([k, s]) => {
   122	      const shown = document.querySelector(`.sdoc-plan[data-lesson-key="${CSS.escape(k)}"] .sdoc-plan-status`)?.textContent;
   123	      const p = calculateLessonProgress(s);
   124	      return shown === getProgressLabel(p === 'ready' ? 'in-progress' : p);
   125	    }), Y);
   126	    expect(agree).toBe(true);
   127	  });
   128	
   129	  test('P2: only plannable projects are listed — "n/a", "—" and Open Studio are not; a repeated title is one plan; the same title in two camps is two', async () => {
   130	    const { ev, clay, paint } = await makeThanksgiving();
   131	    const paint2 = await saveCamp(planner, {
   132	      eventId: ev.id, title: 'TEST Paint Party 2', timeSlot: 'PM', timeLabel: '1–3', location: 'Tinker',
   133	      placements: [{ studio: 'GR', ageRange: '8–12', capacity: 10 }],
   134	      teachers: ['TESTteacher2'], dates: ['2026-11-24'], projects: { '2026-11-24': { block1: 'Canvas' } }, notes: '',
   135	    });
   136	    await showYear(planner);
   137	    const titles = (camp) => planner.locator(`tr[data-camp-id="${camp.id}"] .sdoc-plans-cell .sdoc-plan-title`).allTextContents();
   138	    expect(await titles(clay)).toEqual(['Clay Creatures', 'Glaze Day']);
   139	    expect(await titles(paint)).toEqual(['Canvas']);
   140	    expect(await titles(paint2)).toEqual(['Canvas']);
   141	    await expect(rollup(planner, ev)).toHaveText('Plans: 0 of 4 complete · 4 not started');
   142	  });
   143	
   144	  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
   145	    const { clay } = await makeThanksgiving();
   146	    await showYear(planner);
   147	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('Not Started');
   148	    await planner.evaluate((Y) => { dayOffLastRefreshAt[Y] = new Date(2020, 0, 1, 3, 7); renderAdminGrid(); }, Y);
   149	    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('3:07');
   150	    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST closure from Mariah', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0003' });
   151	    await spyWrites(planner);
   152	    await planner.click('#sdoc-refresh-btn');
   153	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
   154	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-edited')).toContainText('last edited by TESTteacher2');
   155	    await expect(planner.locator('#sdoc-refresh-stamp')).not.toContainText('3:07');
   156	    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('Last full refresh');
   157	    expect(await writes(planner)).toEqual([]);
   158	  });
   159	
   160	  test('P4: a failed refresh keeps the figures, says so, and opens plans read-only — then, after a Teacher View visit, the automatic retry recovers with no click', async () => {
   161	    const { clay } = await makeThanksgiving();
   162	    await showYear(planner);
   163	    await planner.evaluate(() => { switchTab('teacher-view'); switchTab('curriculum-admin'); });   // Teacher View has now registered too
   164	    await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
   165	    const stampBefore = await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y);
   166	    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST newer text', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0004' });
   167	    // The next SDOC read fails once; the automatic retry comes 4 s later.
   168	    await planner.evaluate(() => {
   169	      SUMMER_RELOAD_RETRY_DELAYS_MS[0] = 4000;
   170	      const real = window.loadDayOffCampData;
   171	      let failNext = true;
   172	      window.loadDayOffCampData = async (opts) => { if (failNext) { failNext = false; throw new Error('TEST injected SDOC read failure'); } return real(opts); };
   173	    });
   174	    const outcome = await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
   175	    expect(outcome).toBe('failed');
   176	    await expect(planner.locator('#sdoc-refresh-error')).toContainText("Couldn't refresh");
   177	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('Not Started');   // previous figures
   178	    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBe(stampBefore);
   179	    expect(await planner.evaluate(() => lessonDataLoadedSuccessfully)).toBe(false);
   180	    // Inside the retry window: Open plan is read-only.
   181	    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   182	    await expect(planner.locator('#summer-lesson-modal')).toHaveClass(/view-only/);
   183	    await planner.click('#summer-lesson-close');
   184	    await expect(planner.locator('#summer-lesson-modal')).toHaveCount(0);
   185	    // The automatic retry succeeds: message gone, rows + stamp fresh, editing back — with no click.
   186	    await expect(planner.locator('#sdoc-refresh-error')).toBeHidden({ timeout: 15_000 });
   187	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
   188	    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBeGreaterThan(stampBefore);
   189	    expect(await planner.evaluate(() => lessonDataLoadedSuccessfully)).toBe(true);
   190	    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   191	    await expect(planner.locator('#summer-lesson-modal')).toBeVisible();
   192	    await expect(planner.locator('#summer-lesson-modal')).not.toHaveClass(/view-only/);
   193	  });
   194	
   195	  test('P5: a guarded page opens Open plan read-only and writes nothing', async () => {
   196	    const { clay } = await makeThanksgiving();
   197	    await showYear(planner);
   198	    await planner.evaluate(() => { lessonDataLoadedSuccessfully = false; });
   199	    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   200	    await expect(planner.locator('#summer-lesson-modal')).toHaveClass(/view-only/);
   201	    await expect(planner.locator('#summer-lesson-save')).toBeHidden();
   202	  });
   203	
   204	  test('P6: Open plan → type → close saves through the 2B path, and the row reads "In Progress"', async () => {
   205	    const { clay } = await makeThanksgiving();
   206	    await showYear(planner);
   207	    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   208	    await expect(planner.locator('#summer-lesson-modal .te-modal-meta')).toContainText('Glaze Day');
   209	    await planner.fill('#summer-closure', 'TEST closure by the planner');
   210	    await planner.click('#summer-lesson-save');
   211	    await expect(planner.locator('#summer-autosave-status')).toContainText(/Saved/);
   212	    await planner.click('#summer-lesson-close');
   213	    await expect(planner.locator('#summer-lesson-modal')).toHaveCount(0);
   214	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
   215	    const saved = await readPlan(planner, clay, 'Glaze Day');
   216	    expect(saved).toMatchObject({ yearKey: Y, campId: clay.id, projectTitle: 'Glaze Day', closure: 'TEST closure by the planner' });
   217	    expect(saved.lastEditId).toMatch(/^e[a-z0-9]{15}$/);
   218	  });
   219	
   220	  test('P7: prep (Kathy/Allie) sees the overview and can edit; a curriculum-admin user without classbook gets a read-only editor', async () => {
   221	    const { clay } = await makeThanksgiving();
   222	    await showYear(prep);
   223	    await expect(planRow(prep, clay, 'Glaze Day')).toBeVisible();
   224	    await planRow(prep, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   225	    await expect(prep.locator('#summer-lesson-modal')).not.toHaveClass(/view-only/);
   226	    await prep.click('#summer-lesson-close');
   227	    await prep.evaluate(() => { const real = window.getAuthUser; window.getAuthUser = () => ({ ...real(), role: 'staff', appAccess: ['curriculum-admin'] }); });
   228	    await planRow(prep, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   229	    await expect(prep.locator('#summer-lesson-modal')).toHaveClass(/view-only/);
   230	  });
   231	
   232	  test('P8: hostile titles and names render as text, and Open plan still opens the right plan', async () => {
   233	    const ev = await makeEvent(planner);
   234	    const evil = `TEST <img src=x onerror="window.__xss=1"> it's "bad"`;
   235	    const camp = await saveCamp(planner, {
   236	      eventId: ev.id, title: 'TEST Hostile', timeSlot: 'AM', timeLabel: '9–12', location: 'Tinker',
   237	      placements: [{ studio: 'AG', ageRange: '5–7', capacity: 8 }], teachers: ['TESTteacher1'],
   238	      dates: ['2026-11-23'], projects: { '2026-11-23': { block1: evil } }, notes: '',
   239	    });
   240	    await writePlan(planner, camp, evil, { introPitch: 'TEST', lastEditedBy: `<b onmouseover="window.__xss=2">x</b>`, lastEditedAt: '2026-10-05T00:00:00.000Z', lastEditId: 'eotherdevice0005' });
   241	    await showYear(planner);
   242	    await expect(planRow(planner, camp, evil).locator('.sdoc-plan-title')).toHaveText(evil);
   243	    await expect(planRow(planner, camp, evil).locator('.sdoc-plan-edited')).toContainText('<b onmouseover=');
   244	    await planRow(planner, camp, evil).locator('.sdoc-plan-open-btn').click();
   245	    await expect(planner.locator('#summer-lesson-modal .te-modal-meta')).toContainText(evil);
   246	    expect(await planner.evaluate(() => window.__xss)).toBeUndefined();
   247	  });
   248	
   249	  test('P9: an event with no projects shows no roll-up', async () => {
   250	    const ev = await makeEvent(planner);
   251	    await saveCamp(planner, {
   252	      eventId: ev.id, title: 'TEST Empty', timeSlot: 'AM', timeLabel: '9–12', location: 'Tinker',
   253	      placements: [{ studio: 'AG', ageRange: '5–7', capacity: 8 }], teachers: ['TESTteacher1'],
   254	      dates: ['2026-11-23'], projects: { '2026-11-23': { block1: '', openStudio: 'Open Studio' } }, notes: '',
   255	    });
   256	    await showYear(planner);
   257	    await expect(planner.locator(`.sdoc-event-card[data-event-id="${ev.id}"]`)).toBeVisible();
   258	    await expect(rollup(planner, ev)).toHaveCount(0);
   259	  });
   260	
   261	  test('P10: an older refresh that resolves last cannot undo a newer reload; the stamp is the newer one\'s', async () => {
   262	    const { clay } = await makeThanksgiving();
   263	    await showYear(planner);
   264	    await planner.evaluate(() => {
   265	      const real = window.loadDayOffCampData;
   266	      let first = true;
   267	      window.__release = null;
   268	      window.loadDayOffCampData = async (opts) => {
   269	        if (first) { first = false; await new Promise(r => { window.__release = r; }); }
   270	        return real(opts);
   271	      };
   272	    });
   273	    await planner.evaluate((Y) => { window.__firstRefresh = refreshDayOffYear(Y); }, Y);
   274	    await planner.waitForFunction(() => typeof window.__release === 'function');
   275	    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST newer', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0006' });
   276	    const second = await planner.evaluate(async () => { const o = await reloadSummerForModeChange(); window.__secondStamp = +dayOffLastRefreshAt[getAdminSemKey()]; return o; });
   277	    expect(second).toBe('ok');
   278	    const first = await planner.evaluate(async () => { window.__release(); return await window.__firstRefresh; });
   279	    expect(first).toBe('stale');
   280	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
   281	    expect(await planner.evaluate(() => +dayOffLastRefreshAt[getAdminSemKey()] === window.__secondStamp)).toBe(true);
   282	  });
   283	
   284	  test('P11: one refresh on tab re-entry and one on switching the header to the SDOC year; ticking or redrawing triggers none; one in flight at a time', async () => {
   285	    await makeThanksgiving();
   286	    await showYear(planner);
   287	    await planner.evaluate(() => {
   288	      window.__refreshes = 0;
   289	      const real = window.refreshDayOffYear;
   290	      window.refreshDayOffYear = (...a) => { window.__refreshes++; return real(...a); };
   291	    });
   292	    await planner.evaluate(() => { switchTab('teacher-view'); switchTab('curriculum-admin'); });
   293	    expect(await planner.evaluate(() => window.__refreshes)).toBe(1);
   294	    await planner.evaluate((Y) => { setGlobalSemester('spring-2026'); setGlobalSemester(Y); }, Y);
   295	    expect(await planner.evaluate(() => window.__refreshes)).toBe(2);
   296	    await planner.evaluate(() => { renderAdminGrid(); renderAdminGrid(); });
   297	    expect(await planner.evaluate(() => window.__refreshes)).toBe(2);
   298	    // Shared in-flight promise: two calls while one runs start one reload.
   299	    const reloads = await planner.evaluate(async (Y) => {
   300	      await (dayOffRefreshInFlight || Promise.resolve());   // the header switch's refresh settles first
   301	      let n = 0; const real = window.reloadSummerForModeChange;
   302	      window.reloadSummerForModeChange = (...a) => { n++; return real(...a); };
   303	      const a = refreshDayOffYear(Y); const b = refreshDayOffYear(Y);
   304	      await Promise.all([a, b]);
   305	      window.reloadSummerForModeChange = real;
   306	      return { n, same: a === b };
   307	    }, Y);
   308	    expect(reloads).toEqual({ n: 1, same: true });
   309	  });
   310	
   311	  test('P12: opening a plan (a single-plan read) does not move "Last full refresh"', async () => {
   312	    const { clay } = await makeThanksgiving();
   313	    await showYear(planner);
   314	    const before = await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y);
   315	    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   316	    await expect(planner.locator('#summer-lesson-modal')).toBeVisible();
   317	    await planner.click('#summer-lesson-close');
   318	    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBe(before);
   319	  });
   320	
   321	  test('P13: after a Teacher View visit, a reload triggered by a weekly lessonData change redraws Curriculum Admin with no click', async () => {
   322	    const { clay } = await makeThanksgiving();
   323	    await showYear(planner);
   324	    await planner.evaluate(() => { switchTab('teacher-view'); switchTab('curriculum-admin'); });
   325	    await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
   326	    await planner.evaluate((Y) => { dayOffLastRefreshAt[Y] = new Date(2020, 0, 1, 3, 7); renderAdminGrid(); }, Y);
   327	    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST via snapshot', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0007' });
   328	    // Any change to curriculum/lessonData fires the listener → full reload (the weekly semesters' snapshot).
   329	    await planner.evaluate(() => curriculumDb.collection('curriculum').doc('lessonData').update({ lastUpdated: new Date().toISOString(), lastUpdatedBy: 'TEST snapshot trigger' }));
   330	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress', { timeout: 10_000 });
   331	    await expect(planner.locator('#sdoc-refresh-stamp')).not.toContainText('3:07');
   332	  });
   333	
   334	  test('P14: one shared listener callback — both views register the same function, and either order redraws both', async () => {
   335	    await makeThanksgiving();
   336	    await showYear(planner);
   337	    const src = await planner.evaluate(async () => (await fetch('/js/app.js')).text());
   338	    const regs = src.match(/setupLessonDataListener\(([^)]*)\)/g) || [];
   339	    expect(regs).toEqual(['setupLessonDataListener(onLessonDataReload)', 'setupLessonDataListener(onLessonDataReload)']);
   340	    // The startup race: Teacher View built and showing, Curriculum Admin registers LAST.
   341	    const drawn = await planner.evaluate(async () => {
   342	      switchTab('teacher-view');
   343	      setupLessonDataListener(onLessonDataReload);   // what initCurriculumAdmin() does after its awaits
   344	      const calls = { tv: 0, ca: 0 };
   345	      const rtv = window.renderTeacherView, rca = window.renderAdminGrid;
   346	      window.renderTeacherView = (...a) => { calls.tv++; return rtv(...a); };
   347	      window.renderAdminGrid = (...a) => { calls.ca++; return rca(...a); };
   348	      try { onLessonDataReload(currentLessonData); } finally { window.renderTeacherView = rtv; window.renderAdminGrid = rca; }
   349	      switchTab('curriculum-admin');
   350	      return calls;
   351	    });
   352	    expect(drawn.tv).toBeGreaterThanOrEqual(1);
   353	    expect(drawn.ca).toBeGreaterThanOrEqual(1);
   354	    // A throw in Teacher View's redraw cannot skip the admin redraw.
   355	    const adminDrew = await planner.evaluate(() => {
   356	      let ca = 0; const rtv = window.teacherViewOnReload, rca = window.renderAdminGrid;
   357	      window.teacherViewOnReload = () => { throw new Error('TEST throw'); };
   358	      window.renderAdminGrid = (...a) => { ca++; return rca(...a); };
   359	      try { onLessonDataReload(currentLessonData); } finally { window.teacherViewOnReload = rtv; window.renderAdminGrid = rca; }
   360	      return ca;
   361	    });
   362	    expect(adminDrew).toBe(1);
   363	  });
   364	
   365	  test('P15: SDOC loads are server reads, and offline they trip the load guard instead of showing a cached year as editable', async () => {
   366	    await makeThanksgiving();
   367	    await showYear(planner);
   368	    const opts = await planner.evaluate(async (Y) => {
   369	      const proto = Object.getPrototypeOf(curriculumDb.collection('x').where('a', '==', 1));
   370	      const real = proto.get; const seen = [];
   371	      proto.get = function (o) { seen.push(o?.source || 'default'); return real.call(this, o); };
   372	      try { await loadDayOffCampData({ yearKey: Y }); } finally { proto.get = real; }
   373	      return seen;
   374	    }, Y);
   375	    expect(opts).toEqual(['server', 'server', 'server']);
   376	    const ok = await planner.evaluate(async () => {
   377	      await curriculumDb.disableNetwork();
   378	      try { await loadLessonData(); return lessonDataLoadedSuccessfully; }
   379	      finally { await curriculumDb.enableNetwork(); }
   380	    });
   381	    expect(ok).toBe(false);
   382	  });
   383	
   384	  test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {
   385	    const { clay } = await makeThanksgiving();
   386	    await showYear(planner);
   387	    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST fresh text', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0008' });
   388	    // Every plain DocumentReference.get() now answers with a stale "no plan yet" — what a
   389	    // get({source:'server'}) after a Listen transport error can do.
   390	    await planner.evaluate(() => {
   391	      const proto = Object.getPrototypeOf(curriculumDb.collection('x').doc('y'));
   392	      const real = proto.get;
   393	      window.__restoreGet = () => { proto.get = real; };
   394	      proto.get = function (o) {
   395	        if (this.path.startsWith('dayOffCamps_lessonData/')) return Promise.resolve({ exists: false, data: () => undefined, id: this.id, ref: this, metadata: { fromCache: false } });
   396	        return real.call(this, o);
   397	      };
   398	    });
   399	    try {
   400	      await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
   401	      await expect(planner.locator('#summer-closure')).toHaveValue('TEST fresh text');
   402	    } finally {
   403	      await planner.evaluate(() => window.__restoreGet());
   404	    }
   405	  });
   406	});

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '4260,4365p;5240,5350p;12320,12385p'; nl -ba e2e/day-off-overview.spec.js | sed -n '75,145p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
  4260	// Hard-coding them is how a second camp season would have rendered 2026's
  4261	// calendar with 2026's dates.
  4262	// Before the type migration runs, a camp season has no stored timeSlots — so
  4263	// the fallback must be exactly what the app renders TODAY, or the
  4264	// deploy-to-migration window would quietly drop the hours from every row label.
  4265	const SUMMER_FALLBACK_TIME_SLOTS = [{ key: 'AM', label: 'AM (9am-12pm)' }, { key: 'PM', label: 'PM (1pm-4pm)' }];
  4266	function campSeasonFacts(semKey) {
  4267	  const sem = currentConfig?.semesters?.[semKey] || {};
  4268	  const timeSlots = Array.isArray(sem.timeSlots) && sem.timeSlots.length ? sem.timeSlots : SUMMER_FALLBACK_TIME_SLOTS;
  4269	  return {
  4270	    numWeeks: Number(sem.numWeeks) > 0 ? Number(sem.numWeeks) : 11,
  4271	    breakWeeks: Array.isArray(sem.breakWeeks) ? sem.breakWeeks : [],
  4272	    timeSlots,
  4273	    slotKeys: timeSlots.map(s => s.key),
  4274	    slotLabel: (key) => (timeSlots.find(s => s.key === key)?.label) || key,
  4275	    studios: Array.isArray(sem.studios) && sem.studios.length ? sem.studios : [],
  4276	    startDate: sem.startDate || null,
  4277	  };
  4278	}
  4279	
  4280	// The Monday of a camp week, derived from the season's start date and its
  4281	// break positions — which is why the migration seeds breakWeeks [6] for 2026.
  4282	// Camp week w sits at calendar position w plus the number of breaks before it.
  4283	function getSummerWeekDate(w, semKey) {
  4284	  const { breakWeeks, startDate } = campSeasonFacts(semKey || getAdminSemKey());
  4285	  if (!startDate) return '';
  4286	  const breaksBefore = breakWeeks.filter(pos => pos <= w + breakWeeks.filter(p => p <= pos).length - 1).length;
  4287	  const calPos = w + breaksBefore;
  4288	  const start = new Date(`${startDate}T00:00:00`);
  4289	  if (Number.isNaN(start.getTime())) return '';
  4290	  start.setDate(start.getDate() + 7 * (calPos - 1));
  4291	  return `${start.getMonth() + 1}/${start.getDate()}`;
  4292	}
  4293	
  4294	function renderSummerCA(lessons) {
  4295	  const wrapper = document.getElementById('ca-grid-wrapper');
  4296	  const facts = campSeasonFacts(getAdminSemKey());
  4297	  const weekOptions = Array.from({length: facts.numWeeks}, (_, i) => i + 1)
  4298	    .map(w => `<option value="${w}" ${w === summerByWeekNum ? 'selected' : ''}>Week ${w}</option>`).join('');
  4299	
  4300	  let content = '';
  4301	  if (summerCAView === 'schedule') {
  4302	    content = buildSummerScheduleGridHtml(lessons);
  4303	  } else {
  4304	    content = buildSummerByWeekHtml(lessons, summerByWeekNum);
  4305	  }
  4306	
  4307	  wrapper.innerHTML = `
  4308	    <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1rem;flex-wrap:wrap;">
  4309	      <div style="display:inline-flex;border:2px solid var(--purple);border-radius:999px;overflow:hidden;font-size:0.875rem;font-weight:600;box-shadow:0 1px 3px rgba(0,0,0,0.08);">
  4310	        <button onclick="setSummerCAView('schedule')" style="padding:0.4rem 1.1rem;border:none;background:${summerCAView === 'schedule' ? 'var(--purple)' : 'white'};color:${summerCAView === 'schedule' ? 'white' : 'var(--purple)'};cursor:pointer;transition:background 0.15s;">Schedule Grid</button>
  4311	        <button onclick="setSummerCAView('byweek')" style="padding:0.4rem 1.1rem;border:none;border-left:2px solid var(--purple);background:${summerCAView === 'byweek' ? 'var(--purple)' : 'white'};color:${summerCAView === 'byweek' ? 'white' : 'var(--purple)'};cursor:pointer;transition:background 0.15s;">By Week</button>
  4312	      </div>
  4313	      ${summerCAView === 'byweek' ? `
  4314	        <select onchange="setSummerByWeek(this.value)" style="padding:0.3rem 0.75rem;border:2px solid var(--gray-300);border-radius:var(--radius);font-size:0.85rem;">
  4315	          ${weekOptions}
  4316	        </select>` : ''}
  4317	    </div>
  4318	    ${content}
  4319	  `;
  4320	}
  4321	
  4322	function setSummerCAView(view) {
  4323	  summerCAView = view;
  4324	  renderAdminGrid();
  4325	}
  4326	
  4327	function setSummerByWeek(weekNum) {
  4328	  summerByWeekNum = parseInt(weekNum);
  4329	  renderAdminGrid();
  4330	}
  4331	
  4332	function buildSummerScheduleGridHtml(lessons) {
  4333	  const sessions = summerSessionsFor(getAdminSemKey());
  4334	  if (!sessions || sessions.length === 0) {
  4335	    return '<div class="tv-placeholder">No schedule sessions loaded. Summer Camp data may still be loading.</div>';
  4336	  }
  4337	
  4338	  // Normalize time slots
  4339	  // Map a schedule document's timeSlot onto one of THIS season's slot keys
  4340	  // (Phase 1 review): the lookup used to normalise to a literal AM/PM while
  4341	  // the grid iterated the season's own keys — a season whose registry defines
  4342	  // e.g. a single 'FULL' slot would have produced a table with headers and no
  4343	  // rows at all, silently.
  4344	  const seasonSlotKeys = campSeasonFacts(getAdminSemKey()).slotKeys;
  4345	  const normalizeSlot = s => {
  4346	    const u = (s || '').toUpperCase().trim();
  4347	    // Prefer one of this season's own keys, matched case-insensitively on the
  4348	    // prefix — so 'AM (9am-12pm)' matches 'AM' and 'Full day' matches 'FULL'.
  4349	    // Longest key first, and never an empty one: first-match-wins put every
  4350	    // 'AM2' session in the 'AM' row, and a slot defined with no key made
  4351	    // ''.startsWith('') true for everything, collapsing the whole grid into
  4352	    // one row. The sibling registry already ships prefix-overlapping keys
  4353	    // (sensory / sensoryTable).
  4354	    const own = seasonSlotKeys
  4355	      .filter(k => String(k || '').trim().length > 0)
  4356	      .sort((a, b) => String(b).length - String(a).length)
  4357	      .find(k => u === String(k).toUpperCase() || u.startsWith(String(k).toUpperCase()));
  4358	    if (own) return own;
  4359	    return u.startsWith('AM') ? 'AM' : u.startsWith('PM') ? 'PM' : s;
  4360	  };
  4361	
  4362	  // Build lookup: studio → timeSlot → week → session
  4363	  const lookup = {};
  4364	  sessions.forEach(s => {
  4365	    const slot = normalizeSlot(s.timeSlot);
  5240	      }
  5241	
  5242	      if (lesson && lesson.projectTitle) {
  5243	        const progress = calculateLessonProgress(lesson);
  5244	        const title = lesson.projectTitle || '';
  5245	        const truncTitle = title.length > 40 ? title.substring(0, 38) + '...' : title;
  5246	
  5247	        // Build rich tooltip content
  5248	        const qaThread = getQaThread(lesson);
  5249	        const matCount = (lesson.materialsList?.length || 0) || (lesson.materials ? 1 : 0);
  5250	        const hasIntro = !!lesson.introPitch;
  5251	        const hasSteps = !!lesson.processStep1;
  5252	        let tooltipHtml = `<div class="ca-grid-tooltip">
  5253	          <div class="ca-tooltip-title">${escHtml(title)}</div>
  5254	          <div class="ca-tooltip-meta">
  5255	            <span class="ca-tooltip-badge ca-tooltip-badge-${progress}">${getProgressLabel(progress)}</span>
  5256	          </div>`;
  5257	        if (lesson.shortDetails) {
  5258	          const shortPrev = lesson.shortDetails.length > 80 ? lesson.shortDetails.substring(0, 78) + '...' : lesson.shortDetails;
  5259	          tooltipHtml += `<div class="ca-tooltip-detail">${escHtml(shortPrev)}</div>`;
  5260	        }
  5261	        if (safeHttpUrl(lesson.inspoLink)) tooltipHtml += `<div class="ca-tooltip-detail" style="color:var(--tinker-teal)">&#128279; Has inspo link</div>`;
  5262	        const planParts = [];
  5263	        if (hasIntro) planParts.push('Intro');
  5264	        if (hasSteps) planParts.push('Steps');
  5265	        if (lesson.closure) planParts.push('Closure');
  5266	        if (planParts.length > 0) {
  5267	          tooltipHtml += `<div class="ca-tooltip-detail">Plan: ${planParts.join(', ')}</div>`;
  5268	        }
  5269	        if (matCount > 0) {
  5270	          tooltipHtml += `<div class="ca-tooltip-detail">${matCount} material${matCount > 1 ? 's' : ''} listed</div>`;
  5271	        }
  5272	        if (qaThread.length > 0) {
  5273	          const unanswered = hasUnansweredQuestion(lesson);
  5274	          tooltipHtml += `<div class="ca-tooltip-qa ${unanswered ? 'ca-tooltip-qa-needs' : 'ca-tooltip-qa-replied'}">${unanswered ? 'Q&A: Needs reply' : 'Q&A: Replied'}</div>`;
  5275	        }
  5276	        if (safeHttpUrl(lesson.photoUrl)) {
  5277	          tooltipHtml += `<div class="ca-tooltip-photo"><img src="${escAttr(safeHttpUrl(lesson.photoUrl))}" alt="" loading="lazy"></div>`;
  5278	        }
  5279	        tooltipHtml += '</div>';
  5280	
  5281	        const isSource = caActionMode && lesson.key === caSourceKey;
  5282	        const isActionTarget = caActionMode && !isSource;
  5283	        html += `<td class="ca-grid-cell ca-filled-cell ${isCurr ? 'ca-current-col' : ''} ${isSource ? 'ca-source-cell' : ''} ${isActionTarget ? 'ca-action-target' : ''}"
  5284	          data-key="${escAttr(lesson.key)}" data-teacher="${escAttr(combo.teacher)}"
  5285	          data-class="${escAttr(combo.className)}" data-week="${w}"
  5286	          onclick="onGridCellClick(this)">
  5287	          <span class="ca-status-dot ca-dot-${progress}"></span>
  5288	          ${safeHttpUrl(lesson.photoUrl) ? '<span class="ca-photo-icon">&#128247;</span>' : ''}
  5289	          <span class="ca-cell-title">${escHtml(truncTitle)}</span>
  5290	          ${tooltipHtml}
  5291	        </td>`;
  5292	      } else {
  5293	        const emptyKey = (lesson && lesson.key) ? lesson.key : makeLessonKey(combo.teacher, combo.className, w);
  5294	        const isActionTarget = !!caActionMode;
  5295	        html += `<td class="ca-grid-cell ca-empty-cell ${isCurr ? 'ca-current-col' : ''} ${isActionTarget ? 'ca-action-target' : ''}"
  5296	          data-key="${escAttr(emptyKey)}" data-teacher="${escAttr(combo.teacher)}"
  5297	          data-class="${escAttr(combo.className)}" data-week="${w}"
  5298	          onclick="onGridCellClick(this)">&mdash;</td>`;
  5299	      }
  5300	    }
  5301	    html += '</tr>';
  5302	  }
  5303	
  5304	  html += '</tbody></table></div>';
  5305	
  5306	  // Action mode banner
  5307	  if (caActionMode) {
  5308	    html = `<div class="ca-action-banner">
  5309	      <span>${caActionMode === 'move' ? 'Click a destination cell to MOVE the project' : 'Click a cell to SWAP with'}</span>
  5310	      <button class="btn-secondary" onclick="cancelGridAction()">Cancel</button>
  5311	    </div>` + html;
  5312	  }
  5313	
  5314	  wrapper.innerHTML = html;
  5315	}
  5316	
  5317	function onGridCellClick(cell) {
  5318	  const semKey = getAdminSemKey();
  5319	  const lessons = currentLessonData?.[semKey];
  5320	  if (!lessons) return;
  5321	
  5322	  const key = cell.dataset.key;
  5323	  const teacher = cell.dataset.teacher;
  5324	  const className = cell.dataset.class;
  5325	  const weekNum = parseInt(cell.dataset.week);
  5326	
  5327	  // If in action mode (move/swap), handle destination
  5328	  if (caActionMode && caSourceKey) {
  5329	    handleGridAction(teacher, className, weekNum, key);
  5330	    return;
  5331	  }
  5332	
  5333	  // Open detail modal
  5334	  const lesson = lessons[key];
  5335	  openDetailModal(lesson, key, teacher, className, weekNum);
  5336	}
  5337	
  5338	function openDetailModal(lesson, key, teacher, className, weekNum) {
  5339	  const modal = document.getElementById('ca-detail-modal');
  5340	  const title = document.getElementById('ca-modal-title');
  5341	  const body = document.getElementById('ca-modal-body');
  5342	  const semKey = getAdminSemKey();
  5343	
  5344	  const hasProject = lesson && lesson.projectTitle;
  5345	  title.textContent = hasProject ? lesson.projectTitle : `Week ${weekNum} — Empty`;
  5346	
  5347	  let html = `<div class="ca-detail-meta">
  5348	    <span><strong>Teacher:</strong> ${escHtml(teacher)}</span>
  5349	    <span><strong>Class:</strong> ${escHtml(className)}</span>
  5350	    <span><strong>Week:</strong> ${weekNum}</span>
 12320	        if (closing) return; // already force-closed; that path reports
 12321	        closeWaitedOut = false;
 12322	        setFormFrozen(false);
 12323	        const btn = saveBtn();
 12324	        if (btn) { btn.textContent = 'Save'; btn.disabled = false; }
 12325	        if (late === 'saved') { autoSaveStatus.textContent = '✓ Saved'; autoSaveStatus.style.color = ''; }
 12326	      });
 12327	    });
 12328	  };
 12329	
 12330	  const finishClose = () => {
 12331	    modal.remove();
 12332	    renderTeacherView(); // Refresh view when closing
 12333	    onClosed?.();
 12334	  };
 12335	
 12336	  // Save button - trigger manual save
 12337	  document.getElementById('summer-lesson-save').addEventListener('click', async () => {
 12338	    await saveLesson(true);
 12339	  });
 12340	
 12341	  // Print is summer-only; the binding is conditional so its absence never
 12342	  // stops the close handlers below from being bound.
 12343	  document.getElementById('summer-lesson-print')?.addEventListener('click', () => {
 12344	    printProject(campName, projectTitle);
 12345	  });
 12346	
 12347	  document.getElementById('summer-lesson-close').addEventListener('click', () => closeModal(true));
 12348	  document.getElementById('summer-lesson-cancel').addEventListener('click', () => closeModal(true));
 12349	  // SDOC editors never close on a stray backdrop click (Christie, Sep 24).
 12350	  if (!sdoc) modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(false); });
 12351	}
 12352	
 12353	// After the summer editor closes: re-expand the camp and the project it came from.
 12354	function restoreSummerCampExpansion(restoreCampName, restoreProjectTitle, restoreBlock) {
 12355	    // Restore expanded state after render completes
 12356	    setTimeout(() => {
 12357	      // Find and expand the camp section
 12358	      const campId = `camp-${restoreCampName.replace(/[^a-zA-Z0-9]/g, '-')}`;
 12359	      const campHeader = document.querySelector(`#${campId} .summer-camp-title`);
 12360	      const campContent = document.querySelector(`#${campId} .summer-camp-content`);
 12361	
 12362	      if (campHeader && campContent) {
 12363	        campHeader.classList.remove('collapsed');
 12364	        campContent.classList.remove('hidden');
 12365	
 12366	        // Find and expand the specific lesson details
 12367	        // Look for the lesson with matching project title and block
 12368	        const projectSections = campContent.querySelectorAll('.tv-week-section');
 12369	        projectSections.forEach(section => {
 12370	          const titleEl = section.querySelector('.tv-project-title');
 12371	          const blockEl = section.querySelector('.tv-week-dates');
 12372	          if (titleEl && blockEl &&
 12373	              titleEl.textContent.trim() === restoreProjectTitle &&
 12374	              blockEl.textContent.trim() === restoreBlock) {
 12375	            const detailsLink = section.querySelector('.tv-show-details-link');
 12376	            const detailsDiv = section.querySelector('[id^="detail-"]');
 12377	            if (detailsLink && detailsDiv) {
 12378	              detailsDiv.classList.remove('hidden');
 12379	              detailsLink.textContent = 'Hide details';
 12380	            }
 12381	          }
 12382	        });
 12383	      }
 12384	    }, 50);
 12385	}
    75	// Show the SDOC year on Curriculum Admin (the header switch — itself one automatic refresh).
    76	async function showYear(page) {
    77	  await page.evaluate((Y) => { switchTab('curriculum-admin'); setGlobalSemester(Y); }, Y);
    78	  await page.evaluate((Y) => refreshDayOffYear(Y), Y);   // shares the in-flight one the switch started
    79	  await expect(page.locator('.sdoc-admin')).toBeVisible();
    80	}
    81	
    82	// Records every DocumentReference set/update/delete and every transaction write.
    83	async function spyWrites(page) {
    84	  await page.evaluate(() => {
    85	    const proto = Object.getPrototypeOf(curriculumDb.collection('x').doc('y'));
    86	    const calls = [];
    87	    window.__writes = calls;
    88	    for (const m of ['set', 'update', 'delete']) {
    89	      const real = proto[m];
    90	      proto[m] = function (...args) { calls.push(`${m} ${this.path}`); return real.apply(this, args); };
    91	    }
    92	    const realRun = curriculumDb.runTransaction.bind(curriculumDb);
    93	    curriculumDb.runTransaction = (fn) => realRun(async (tx) => {
    94	      for (const m of ['set', 'update', 'delete']) {
    95	        const real = tx[m].bind(tx);
    96	        tx[m] = (ref, ...rest) => { calls.push(`tx.${m} ${ref.path}`); return real(ref, ...rest); };
    97	      }
    98	      return fn(tx);
    99	    });
   100	  });
   101	}
   102	const writes = (page) => page.evaluate(() => window.__writes.slice());
   103	
   104	test.describe('School Day Off Camps — Phase 3: the planner\'s plan overview', () => {
   105	
   106	  test('P1: statuses, last editor and the roll-up — the same status the teachers\' list shows; a bad date shows no date', async () => {
   107	    const { ev, clay, paint } = await makeThanksgiving();
   108	    await writePlan(planner, clay, 'Clay Creatures', { introPitch: 'TEST intro', processStep1: 'TEST step', lastEditedBy: 'TESTteacher2', lastEditedAt: '2026-10-05T14:22:31.123Z', lastEditId: 'eotherdevice0001' });
   109	    await writePlan(planner, paint, 'Canvas', { planComplete: true, lastEditedBy: 'TESTteacher1', lastEditedAt: 'garbage', lastEditId: 'eotherdevice0002' });
   110	    await showYear(planner);
   111	
   112	    await expect(planRow(planner, clay, 'Clay Creatures').locator('.sdoc-plan-status')).toHaveText('In Progress');
   113	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('Not Started');
   114	    await expect(planRow(planner, paint, 'Canvas').locator('.sdoc-plan-status')).toHaveText('Complete');
   115	    await expect(planRow(planner, clay, 'Clay Creatures').locator('.sdoc-plan-edited')).toHaveText('last edited by TESTteacher2, Oct 5');
   116	    await expect(planRow(planner, paint, 'Canvas').locator('.sdoc-plan-edited')).toHaveText('last edited by TESTteacher1');
   117	    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-edited')).toHaveCount(0);
   118	    await expect(rollup(planner, ev)).toHaveText('Plans: 1 of 3 complete · 1 not started');
   119	
   120	    // Agrees with the teachers' list for every slot (same calculateLessonProgress + getProgressLabel).
   121	    const agree = await planner.evaluate((Y) => Object.entries(currentLessonData[Y]).every(([k, s]) => {
   122	      const shown = document.querySelector(`.sdoc-plan[data-lesson-key="${CSS.escape(k)}"] .sdoc-plan-status`)?.textContent;
   123	      const p = calculateLessonProgress(s);
   124	      return shown === getProgressLabel(p === 'ready' ? 'in-progress' : p);
   125	    }), Y);
   126	    expect(agree).toBe(true);
   127	  });
   128	
   129	  test('P2: only plannable projects are listed — "n/a", "—" and Open Studio are not; a repeated title is one plan; the same title in two camps is two', async () => {
   130	    const { ev, clay, paint } = await makeThanksgiving();
   131	    const paint2 = await saveCamp(planner, {
   132	      eventId: ev.id, title: 'TEST Paint Party 2', timeSlot: 'PM', timeLabel: '1–3', location: 'Tinker',
   133	      placements: [{ studio: 'GR', ageRange: '8–12', capacity: 10 }],
   134	      teachers: ['TESTteacher2'], dates: ['2026-11-24'], projects: { '2026-11-24': { block1: 'Canvas' } }, notes: '',
   135	    });
   136	    await showYear(planner);
   137	    const titles = (camp) => planner.locator(`tr[data-camp-id="${camp.id}"] .sdoc-plans-cell .sdoc-plan-title`).allTextContents();
   138	    expect(await titles(clay)).toEqual(['Clay Creatures', 'Glaze Day']);
   139	    expect(await titles(paint)).toEqual(['Canvas']);
   140	    expect(await titles(paint2)).toEqual(['Canvas']);
   141	    await expect(rollup(planner, ev)).toHaveText('Plans: 0 of 4 complete · 4 not started');
   142	  });
   143	
   144	  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
   145	    const { clay } = await makeThanksgiving();

exec
/bin/zsh -lc "rg -n \"runTransaction|readDayOffPlanForEditor|transaction\" e2e --glob '*.spec.js' | head -200; rg -n \"function getProgressLabel|function calculateLessonProgress|const caActionMode|let caActionMode|caSourceKey\" js/app.js | head -40; git diff --unified=20 132fef2 c7400df -- e2e/day-off-overview.spec.js | rg '"'^'"\\+.*(P1|P2|P3|P4|P5|P6|P7|P8|P9|P10|P11|P12|P13|P14|P15|P16|test\\()'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
e2e/day-off-camps.spec.js:291:  test('SDOC 12: a camp with only empty scaffold plans is removed together with them in one transaction', async ({ page }) => {
e2e/day-off-teacher.spec.js:243:      const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-teacher.spec.js:244:      curriculumDb.runTransaction = async (fn) => {
e2e/day-off-teacher.spec.js:246:        curriculumDb.runTransaction = real;
e2e/day-off-teacher.spec.js:253:      finally { curriculumDb.runTransaction = real; }
e2e/day-off-teacher.spec.js:276:      const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-teacher.spec.js:277:      curriculumDb.runTransaction = async (fn) => {
e2e/day-off-teacher.spec.js:279:        curriculumDb.runTransaction = real;
e2e/day-off-teacher.spec.js:288:      finally { curriculumDb.runTransaction = real; }
e2e/day-off-teacher.spec.js:307:      const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-teacher.spec.js:308:      curriculumDb.runTransaction = async (fn) => {
e2e/day-off-teacher.spec.js:310:        curriculumDb.runTransaction = real;
e2e/day-off-teacher.spec.js:326:      const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-teacher.spec.js:327:      curriculumDb.runTransaction = async (fn) => {
e2e/day-off-teacher.spec.js:334:        curriculumDb.runTransaction = real;
e2e/day-off-teacher.spec.js:339:      finally { curriculumDb.runTransaction = real; }
e2e/day-off-teacher.spec.js:463:      let n = 0; const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-teacher.spec.js:464:      curriculumDb.runTransaction = (fn) => { n++; return real(fn); };
e2e/day-off-teacher.spec.js:471:      } finally { curriculumDb.runTransaction = real; }
e2e/day-off-teacher.spec.js:612:    // The next save's transaction fails (after the upload).
e2e/day-off-teacher.spec.js:614:      const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-teacher.spec.js:615:      curriculumDb.runTransaction = async () => { curriculumDb.runTransaction = real; throw new Error('TEST simulated write failure'); };
e2e/day-off-overview.spec.js:9: * transactional open read.
e2e/day-off-overview.spec.js:82:// Records every DocumentReference set/update/delete and every transaction write.
e2e/day-off-overview.spec.js:92:    const realRun = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-overview.spec.js:93:    curriculumDb.runTransaction = (fn) => realRun(async (tx) => {
e2e/day-off-overview.spec.js:384:  test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {
e2e/day-off-materials.spec.js:278:  // Runs `inject` (another tab's write) just before the NEXT transaction this page starts.
e2e/day-off-materials.spec.js:280:    const real = curriculumDb.runTransaction.bind(curriculumDb);
e2e/day-off-materials.spec.js:281:    curriculumDb.runTransaction = async (fn) => { curriculumDb.runTransaction = real; await (0, eval)(`(${src})`)(); return real(fn); };
946:function calculateLessonProgress(lesson) {
965:function getProgressLabel(progress) {
4226:let caActionMode = null;   // null, 'move', 'swap'
4227:let caSourceKey = null;     // key of source cell for move/swap
5281:        const isSource = caActionMode && lesson.key === caSourceKey;
5328:  if (caActionMode && caSourceKey) {
5501:  caSourceKey = sourceKey;
5905:  caSourceKey = sourceKey;
5912:  caSourceKey = null;
5978:  const sourceLesson = lessons[caSourceKey];
5986:  if (caSourceKey === destKey) {
6018:    delete lessons[caSourceKey];
6021:    const sourceKeyToDelete = caSourceKey;
6025:    caSourceKey = null;
6085:    const sourceKeyForSwap = caSourceKey;
6144:    caSourceKey = null;
6174:  caSourceKey = null;
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-vAJ2YOOK' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-9a6RCxkV' (errno=Operation not permitted)
+  test('P1: statuses, last editor and the roll-up — the same status the teachers\' list shows; a bad date shows no date', async () => {
+  test('P2: only plannable projects are listed — "n/a", "—" and Open Studio are not; a repeated title is one plan; the same title in two camps is two', async () => {
+  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
+  test('P4: a failed refresh keeps the figures, says so, and opens plans read-only — then, after a Teacher View visit, the automatic retry recovers with no click', async () => {
+  test('P5: a guarded page opens Open plan read-only and writes nothing', async () => {
+  test('P6: Open plan → type → close saves through the 2B path, and the row reads "In Progress"', async () => {
+  test('P7: prep (Kathy/Allie) sees the overview and can edit; a curriculum-admin user without classbook gets a read-only editor', async () => {
+  test('P8: hostile titles and names render as text, and Open plan still opens the right plan', async () => {
+  test('P9: an event with no projects shows no roll-up', async () => {
+  test('P10: an older refresh that resolves last cannot undo a newer reload; the stamp is the newer one\'s', async () => {
+  test('P11: one refresh on tab re-entry and one on switching the header to the SDOC year; ticking or redrawing triggers none; one in flight at a time', async () => {
+  test('P12: opening a plan (a single-plan read) does not move "Last full refresh"', async () => {
+  test('P13: after a Teacher View visit, a reload triggered by a weekly lessonData change redraws Curriculum Admin with no click', async () => {
+  test('P14: one shared listener callback — both views register the same function, and either order redraws both', async () => {
+  test('P15: SDOC loads are server reads, and offline they trip the load guard instead of showing a cached year as editable', async () => {
+  test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {

exec
/bin/zsh -lc "nl -ba e2e/day-off-teacher.spec.js | sed -n '220,350p;440,485p;590,635p'; nl -ba js/app.js | sed -n '930,980p;4208,4240p;5480,5520p;5890,5920p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
   220	      } finally { window.getAuthUser = real; delete currentConfig.teacherMappings[real().uid]; }
   221	    }, Y);
   222	    expect(out).toEqual({ second: 'TESTteacher2', canEdit: true, alex: null, stale: 'Fixture Teacher' });
   223	    // And the shared resolver is untouched for weekly/summer.
   224	    expect(await t.evaluate(() => typeof getTeacherNameForCurrentUser)).toBe('function');
   225	    void clay;
   226	  });
   227	
   228	  test('T5: co-teachers editing different fields both survive; a later save over mine reads "edited since", never a failure — for a written field and for a clear', async ({ browser }) => {
   229	    const { clay } = await makeCamps();
   230	    const t = await teacherSession(browser);
   231	    const auth = await authOf(t);
   232	    const K = key(clay, 'Clay Creatures');
   233	    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST mine', closure: 'TEST closure' }, [], { dayOffAuth: auth }), { Y, K, auth });
   234	    expect(r.ok, r.message).toBe(true);
   235	    expect(r.value.status).toBe('saved');
   236	    // Another teacher saves a different field — both present.
   237	    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
   238	      .update({ processStep1: 'TEST step by co-teacher', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00002' }), { Y, id: clay.id });
   239	    expect(await readPlan(planner, clay, 'Clay Creatures')).toMatchObject({ introPitch: 'TEST mine', processStep1: 'TEST step by co-teacher' });
   240	
   241	    // Inject "TESTteacher2 saves right after my commit, before my read-back".
   242	    const racedSave = async (payload, clears, coWrite) => t.evaluate(async ({ Y, K, auth, payload, clears, coWrite }) => {
   243	      const real = curriculumDb.runTransaction.bind(curriculumDb);
   244	      curriculumDb.runTransaction = async (fn) => {
   245	        const res = await real(fn);
   246	        curriculumDb.runTransaction = real;
   247	        const [, campId, title] = K.split('|||');
   248	        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title)).update(coWrite);
   249	        return res;
   250	      };
   251	      try { return { ok: true, value: await saveSingleLesson(Y, K, payload, clears, { dayOffAuth: auth }) }; }
   252	      catch (e) { return { ok: false, message: e.message }; }
   253	      finally { curriculumDb.runTransaction = real; }
   254	    }, { Y, K, auth, payload, clears, coWrite });
   255	    const co = (fields) => ({ ...fields, lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00003' });
   256	
   257	    r = await racedSave({ closure: 'TEST my closure' }, [], co({ closure: 'TEST their closure' }));
   258	    expect(r.ok, r.message).toBe(true);
   259	    expect(r.value.status).toBe('savedSince');
   260	    expect(r.value.by).toBe('TESTteacher2');
   261	    expect((await readPlan(planner, clay, 'Clay Creatures')).closure).toBe('TEST their closure');
   262	
   263	    r = await racedSave({}, ['closure'], co({ closure: 'TEST their closure again' }));
   264	    expect(r.ok, r.message).toBe(true);
   265	    expect(r.value.status).toBe('savedSince');
   266	    expect((await readPlan(planner, clay, 'Clay Creatures')).closure).toBe('TEST their closure again');
   267	
   268	    // Same window, same name (the Plan complete box or a second tab): the "another window" wording.
   269	    const me = await t.evaluate(() => getAuthUser().name);
   270	    r = await racedSave({ closure: 'TEST x' }, [], { closure: 'TEST y', lastEditedBy: me, lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00004' });
   271	    expect(r.value.status).toBe('savedSince');
   272	    expect(r.value.own).toBe(true);
   273	
   274	    // Same user, same millisecond (identical lastEditedBy AND lastEditedAt) — still told apart by the save id.
   275	    r = await t.evaluate(async ({ Y, K, auth }) => {
   276	      const real = curriculumDb.runTransaction.bind(curriculumDb);
   277	      curriculumDb.runTransaction = async (fn) => {
   278	        const res = await real(fn);
   279	        curriculumDb.runTransaction = real;
   280	        const [, campId, title] = K.split('|||');
   281	        const ref = curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title));
   282	        const mine = (await ref.get({ source: 'server' })).data();
   283	        await ref.update({ closure: 'TEST same-ms other save', lastEditedBy: mine.lastEditedBy, lastEditedAt: mine.lastEditedAt, lastEditId: 'eothersave00009' });
   284	        return res;
   285	      };
   286	      try { return { ok: true, value: await saveSingleLesson(Y, K, { closure: 'TEST first' }, [], { dayOffAuth: auth }) }; }
   287	      catch (e) { return { ok: false, message: e.message }; }
   288	      finally { curriculumDb.runTransaction = real; }
   289	    }, { Y, K, auth });
   290	    expect(r.ok, r.message).toBe(true);
   291	    expect(r.value.status).toBe('savedSince');
   292	
   293	    // Photo removal racing a co-teacher's replacement: the later save wins, reported as such.
   294	    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
   295	      .update({ photoUrl: 'https://example.test/old.jpg', photoPath: 'curriculum/TEST/old.jpg' }), { Y, id: clay.id });
   296	    await t.evaluate(async (Y) => { currentLessonData[Y] = await loadDayOffCampData({ yearKey: Y }); }, Y);
   297	    r = await racedSave({ photoUrl: '', photoPath: '' }, [], co({ photoUrl: 'https://example.test/theirs.jpg', photoPath: 'curriculum/TEST/theirs.jpg' }));
   298	    expect(r.ok, r.message).toBe(true);
   299	    expect(r.value.status).toBe('savedSince');
   300	    expect((await readPlan(planner, clay, 'Clay Creatures')).photoPath).toBe('curriculum/TEST/theirs.jpg');
   301	
   302	    // The editor shows it.
   303	    await openTeacherView(t);
   304	    await openPlan(t, clay, 'Clay Creatures');
   305	    await t.fill('#summer-step2', 'TEST step 2');
   306	    await t.evaluate(({ id }) => {
   307	      const real = curriculumDb.runTransaction.bind(curriculumDb);
   308	      curriculumDb.runTransaction = async (fn) => {
   309	        const res = await real(fn);
   310	        curriculumDb.runTransaction = real;
   311	        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId('TEST_DATA_SAFETY_sdoc', id, 'Clay Creatures'))
   312	          .update({ processStep2: 'TEST co-teacher step 2', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00005' });
   313	        return res;
   314	      };
   315	    }, { id: clay.id });
   316	    await t.click('#summer-lesson-save');
   317	    await expect(t.locator('#summer-autosave-status')).toContainText('TESTteacher2 has edited this plan since');
   318	  });
   319	
   320	  test('T6: a real failure is still caught — the read-back carries my own save id but a field did not land', async ({ browser }) => {
   321	    const { clay } = await makeCamps();
   322	    const t = await teacherSession(browser);
   323	    const auth = await authOf(t);
   324	    const K = key(clay, 'Clay Creatures');
   325	    const r = await t.evaluate(async ({ Y, K, auth }) => {
   326	      const real = curriculumDb.runTransaction.bind(curriculumDb);
   327	      curriculumDb.runTransaction = async (fn) => {
   328	        // Wrap tx.set so the write lands WITHOUT the closure but with this save's id.
   329	        const res = await real(async (tx) => {
   330	          const realSet = tx.set.bind(tx);
   331	          tx.set = (ref, data, opts) => { const d = { ...data }; delete d.closure; return realSet(ref, d, opts); };
   332	          return fn(tx);
   333	        });
   334	        curriculumDb.runTransaction = real;
   335	        return res;
   336	      };
   337	      try { await saveSingleLesson(Y, K, { closure: 'TEST lost' }, [], { dayOffAuth: auth }); return { ok: true }; }
   338	      catch (e) { return { ok: false, message: e.message }; }
   339	      finally { curriculumDb.runTransaction = real; }
   340	    }, { Y, K, auth });
   341	    expect(r.ok).toBe(false);
   342	    expect(r.message).toContain('Save may not have completed');
   343	  });
   344	
   345	  test('T7: rename while the editor is open — the save is refused, the text stays, no old-title doc, and the camp shows the new title after the reload', async ({ browser }) => {
   346	    const { clay } = await makeCamps();
   347	    const t = await teacherSession(browser);
   348	    await openTeacherView(t);
   349	    await openPlan(t, clay, 'Clay Creatures');
   350	    const camp = await planner.evaluate(({ Y, id }) => currentDayOffCamps[Y].find(c => c.id === id), { Y, id: clay.id });
   440	    expect(Object.keys(doc).filter(k => ['introPitch', 'closure', 'processStep1'].includes(k))).toEqual([]);
   441	    // Someone who can see but not edit gets a disabled box.
   442	    const disabled = await t.evaluate(({ Y, K }) => {
   443	      const real = window.getAuthUser;
   444	      window.getAuthUser = () => ({ ...real(), appAccess: ['curriculum-admin'] });
   445	      try { const c = document.createElement('div'); renderDayOffTeacherView(c, Y); return c.querySelector(`.sdoc-tv-pc-cb[data-lesson-key="${CSS.escape(K)}"]`)?.disabled; }
   446	      finally { window.getAuthUser = real; }
   447	    }, { Y, K });
   448	    expect(disabled).toBe(true);
   449	  });
   450	
   451	  test('T12: a curriculum-admin user WITHOUT classbook whose name is on the camp gets a read-only editor and writes nothing', async ({ browser }) => {
   452	    const { clay } = await makeCamps();
   453	    const t = await teacherSession(browser);
   454	    await t.evaluate(() => { const real = window.getAuthUser; window.__realUser = real; window.getAuthUser = () => ({ ...real(), appAccess: ['curriculum-admin'] }); });
   455	    await openTeacherView(t);
   456	    await pickTeacher(t, 'Fixture Teacher');
   457	    await openPlan(t, clay, 'Clay Creatures');
   458	    await expect(t.locator('#summer-lesson-modal')).toHaveClass(/view-only/);
   459	    await expect(t.locator('#summer-lesson-save')).toBeHidden();
   460	    await expect(t.locator('#summer-intro-pitch')).not.toBeEditable();
   461	    await expect(t.locator('#summer-autosave-status')).toContainText('View only');
   462	    const writes = await t.evaluate(async ({ Y, K }) => {
   463	      let n = 0; const real = curriculumDb.runTransaction.bind(curriculumDb);
   464	      curriculumDb.runTransaction = (fn) => { n++; return real(fn); };
   465	      try {
   466	        const ta = document.getElementById('summer-intro-pitch');
   467	        ta.value = 'x';
   468	        ta.dispatchEvent(new Event('input', { bubbles: true }));   // what typing fires — arms autosave if anything would
   469	        document.getElementById('summer-lesson-save')?.click();      // hidden, but a scripted click must still do nothing
   470	        await new Promise(r => setTimeout(r, 2600));
   471	      } finally { curriculumDb.runTransaction = real; }
   472	      return n;
   473	    }, { Y, K: key(clay, 'Clay Creatures') });
   474	    expect(writes).toBe(0);
   475	    expect(await readPlan(planner, clay, 'Clay Creatures')).toBeNull();
   476	  });
   477	
   478	  test('T13: publishing — an SDOC year can be published; a camp with no teacher asks first; unpublished stays invisible to the teacher', async ({ browser }) => {
   479	    await makeCamps();
   480	    const ev = await makeEvent(planner, { label: 'TEST Winter Break', dates: ['2026-12-21'] });
   481	    const r = await attempt(planner, ({ Y, eventId }) => saveDayOffCamp(Y, {
   482	      eventId, title: 'TEST Nobody Yet', timeSlot: 'AM', timeLabel: '9–12', location: 'Tinker',
   483	      placements: [{ studio: 'AG', ageRange: '5–7', capacity: 8 }], teachers: [], dates: ['2026-12-21'], projects: {}, notes: '',
   484	    }, null), { Y, eventId: ev.id });
   485	    expect(r.ok, r.message).toBe(true);
   590	      projects: { '2026-11-23': { block1: `TEST ${evil}` } }, notes: '',
   591	    }, null), { Y, eventId: ev.id, evil });
   592	    expect(r.ok, r.message).toBe(true);
   593	    const t = await teacherSession(browser);
   594	    await openTeacherView(t);
   595	    await expect(t.locator('.sdoc-tv')).toContainText(`TEST ${evil}`);
   596	    await t.locator('.sdoc-tv-open-btn').first().click();
   597	    await expect(t.locator('#summer-lesson-modal .te-modal-meta')).toContainText(`TEST ${evil}`);
   598	    await typeAndSave(t, '#summer-intro-pitch', 'TEST safe');
   599	    expect(await t.evaluate(() => window.__pwned || 0)).toBe(0);
   600	  });
   601	
   602	  test('T18: a save that fails after a new photo uploaded keeps the old photo in Storage and in the plan; the new upload is an orphan at its own path', async ({ browser }) => {
   603	    const { clay } = await makeCamps();
   604	    const t = await teacherSession(browser);
   605	    await openTeacherView(t);
   606	    await openPlan(t, clay, 'Clay Creatures');
   607	    const png = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==', 'base64');
   608	    await t.setInputFiles('#summer-photo-input', { name: 'a.png', mimeType: 'image/png', buffer: png });
   609	    await t.click('#summer-lesson-save');
   610	    await expect(t.locator('#summer-autosave-status')).toContainText('Saved');
   611	    const first = await readPlan(planner, clay, 'Clay Creatures');
   612	    // The next save's transaction fails (after the upload).
   613	    await t.evaluate(() => {
   614	      const real = curriculumDb.runTransaction.bind(curriculumDb);
   615	      curriculumDb.runTransaction = async () => { curriculumDb.runTransaction = real; throw new Error('TEST simulated write failure'); };
   616	    });
   617	    await t.setInputFiles('#summer-photo-input', { name: 'b.png', mimeType: 'image/png', buffer: png });
   618	    await t.click('#summer-lesson-save');
   619	    await expect(t.locator('#summer-autosave-status')).toContainText('Save failed');
   620	    const after = await readPlan(planner, clay, 'Clay Creatures');
   621	    expect(after.photoPath).toBe(first.photoPath);
   622	    expect(after.photoUrl).toBe(first.photoUrl);
   623	    expect(await t.evaluate(async (p) => { try { await getFirebaseStorage().ref(p).getMetadata(); return true; } catch { return false; } }, first.photoPath)).toBe(true);
   624	    // A retry saves the new photo and only THEN deletes the original.
   625	    await t.click('#summer-lesson-save');
   626	    await expect(t.locator('#summer-autosave-status')).toContainText('Saved');
   627	    const retried = await readPlan(planner, clay, 'Clay Creatures');
   628	    expect(retried.photoPath).not.toBe(first.photoPath);
   629	    expect(await t.evaluate(async (p) => { try { await getFirebaseStorage().ref(p).getMetadata(); return true; } catch { return false; } }, first.photoPath)).toBe(false);
   630	  });
   631	
   632	  test('T19: a teacher save leaves the camp\'s sign-off doc byte-identical, and a prep tick racing it survives on both sides', async ({ browser }) => {
   633	    const { clay } = await makeCamps();
   634	    const item = (await addItem(clay, 'Clay Creatures', { name: 'TEST clay', qty: 1, scope: 'class set' })).value;
   635	    let r = await attempt(planner, ({ Y, c }) => setDayOffCampSignoff(Y, c, true, null), { Y, c: clay.id });
   930	
   931	  const classSet = new Set();
   932	  for (const lesson of Object.values(lessons)) {
   933	    if (lesson.teacher === tvCurrentTeacher && lesson.className) {
   934	      classSet.add(lesson.className);
   935	    }
   936	  }
   937	
   938	  const classes = [...classSet].sort((a, b) => getDayOrder(a) - getDayOrder(b) || a.localeCompare(b));
   939	  const classFilter = document.getElementById('tv-class-filter');
   940	  classFilter.innerHTML = '<option value="all">All Classes</option>' +
   941	    classes.map(c => `<option value="${escAttr(c)}">${escHtml(c)}</option>`).join('');
   942	  tvCurrentClassFilter = 'all';
   943	}
   944	
   945	// Auto-calculated progress from field completion
   946	function calculateLessonProgress(lesson) {
   947	  if (lesson.planComplete) return 'complete';
   948	
   949	  const hasIntro = !!(lesson.introPitch || '').trim();
   950	  const hasSteps = !!(lesson.processStep1 || '').trim();
   951	  const hasClosure = !!(lesson.closure || '').trim();
   952	  // Summer camp lessons have materials pre-loaded from the Materials Hub (not teacher input),
   953	  // so don't count them toward teacher progress. Teachers fill in dayOfMaterials separately.
   954	  const hasMaterials = lesson.campName
   955	    ? false
   956	    : (lesson.materialsList && lesson.materialsList.length > 0) || !!(lesson.materials || '').trim();
   957	
   958	  const filledCount = [hasIntro, hasSteps, hasClosure, hasMaterials].filter(Boolean).length;
   959	
   960	  if (filledCount === 0) return 'not-started';
   961	  if (filledCount === 4) return 'ready';
   962	  return 'in-progress';
   963	}
   964	
   965	function getProgressLabel(progress) {
   966	  switch (progress) {
   967	    case 'complete': return 'Complete';
   968	    case 'ready': return 'Almost Done';
   969	    case 'in-progress': return 'In Progress';
   970	    default: return 'Not Started';
   971	  }
   972	}
   973	
   974	function renderSummerProgressDashboard(container, lessons, isAdminOrManager) {
   975	  // Build teacher → camp → lessons map
   976	  const teacherMap = {};
   977	
   978	  for (const lesson of Object.values(lessons)) {
   979	    if (!lesson.teacher || !lesson.campName) continue;
   980	    // Non-managers only see published camps
  4208	}
  4209	
  4210	
  4211	function printSingleLesson(key) {
  4212	  const semKey = getAdminSemKey();
  4213	  const lesson = currentLessonData?.[semKey]?.[key];
  4214	  if (!lesson || !lesson.projectTitle) {
  4215	    alert('No lesson data to print.');
  4216	    return;
  4217	  }
  4218	  generatePrintOutput(lesson.weekNum, [lesson]);
  4219	}
  4220	
  4221	// ═════════════════════════════════════════════════════
  4222	// CURRICULUM ADMIN — Grid + Move/Swap/Cut
  4223	// ═════════════════════════════════════════════════════
  4224	
  4225	let caInitialized = false;
  4226	let caActionMode = null;   // null, 'move', 'swap'
  4227	let caSourceKey = null;     // key of source cell for move/swap
  4228	let hqFilterNeedsReply = false;
  4229	let summerCAView = 'schedule'; // 'schedule' or 'byweek'
  4230	let summerTeacherView = 'plans'; // 'plans' or 'calendar'
  4231	let summerByWeekNum = 1;
  4232	
  4233	function getAdminSemKey() {
  4234	  return getActiveSemesterKey();
  4235	}
  4236	
  4237	// ─── Summer CA Views ──────────────────────────────────────────────────────────
  4238	
  4239	// Titles that have no lesson plan — show as plain text, not clickable
  4240	function isSummerNoPlanTitle(title) {
  5480	function captureAdminEditSnapshot(lesson) {
  5481	  const l = lesson || {};
  5482	  caEditLessonExisted = !!lesson;
  5483	  caEditOriginalData = {};
  5484	  for (const f of CA_EDIT_FIELDS) caEditOriginalData[f] = (l[f] || '').trim();
  5485	}
  5486	
  5487	// force === true: the in-flight save closing its own popup on success. Any
  5488	// other close (Cancel, the × button, the overlay — the latter two pass a click
  5489	// Event here, hence the strict check) is refused while a save is pending:
  5490	// otherwise the admin could open a second lesson mid-save and have the first
  5491	// save's completion close it and discard the new text.
  5492	function closeAdminModal(force) {
  5493	  if (caEditSaveInFlight && force !== true) return;
  5494	  document.getElementById('ca-detail-modal')?.classList.remove('open');
  5495	  caEditOriginalData = null;
  5496	  caEditLessonExisted = false;
  5497	}
  5498	
  5499	function startMove(sourceKey) {
  5500	  caActionMode = 'move';
  5501	  caSourceKey = sourceKey;
  5502	  closeAdminModal();
  5503	  renderAdminGrid();
  5504	}
  5505	
  5506	function renderAdminEditForm(lesson, key, teacher, className, weekNum) {
  5507	  const l = lesson || {};
  5508	  // Summer lessons are built from the Summer Camp App's curriculum: the title,
  5509	  // short details, inspo link and materials come from there on every load and
  5510	  // are never read back from the lesson doc (see SUMMER_SAVED_FIELDS), so an
  5511	  // edit here could only "save" and vanish — or, for the title, make the doc
  5512	  // look orphaned to the Summer Camp App. Render them read-only (same ids, so
  5513	  // the save-time diff sees them unchanged); saveAdminEditInner() still
  5514	  // refuses them as a backstop.
  5515	  const isSummerSchema = isCampSeason(getAdminSemKey());   // Phase 1, 1.1
  5516	  const ro = isSummerSchema ? ' readonly class="ca-edit-readonly" title="Managed in the Summer Camp App"' : '';
  5517	  const summerNote = isSummerSchema
  5518	    ? `<p class="te-photo-hint" style="margin:0 0 10px">Title, short details, inspo link and materials come from the Summer Camp App — edit them there. Everything below saves here.</p>`
  5519	    : '';
  5520	
  5890	
  5891	  try {
  5892	    // Log the title that was actually kept — for summer a refused retitle
  5893	    // must not show up in Change History under the refused name.
  5894	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5895	    await appendChangeLogEntry(semKey, {
  5896	      action: existing.projectTitle ? 'edit' : 'create',
  5897	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5898	    });
  5899	    renderChangeHistory();
  5900	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5901	}
  5902	
  5903	function startSwap(sourceKey) {
  5904	  caActionMode = 'swap';
  5905	  caSourceKey = sourceKey;
  5906	  closeAdminModal();
  5907	  renderAdminGrid();
  5908	}
  5909	
  5910	function cancelGridAction() {
  5911	  caActionMode = null;
  5912	  caSourceKey = null;
  5913	  renderAdminGrid();
  5914	}
  5915	
  5916	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5917	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5918	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5919	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5920	

exec
/bin/zsh -lc "rg -n \"function dayOffYearKeys|dayOffYearKeys\" js/firebase-data.js js/app.js; nl -ba js/firebase-data.js | sed -n '310,350p'; git show 132fef2:js/app.js | nl -ba | sed -n '650,730p;5085,5130p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
js/firebase-data.js:873:function dayOffYearKeys() {
js/firebase-data.js:969:      for (const yearKey of dayOffYearKeys()) {
js/firebase-data.js:1346:      const dayOffKeys = dayOffYearKeys();
js/firebase-data.js:1369:      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
   310	    currentConfig = doc.exists ? doc.data() : getDefaultConfig();
   311	  } catch (err) {
   312	    console.error('❌ Could not read curriculum/appData — refusing to guess at the configuration:', err);
   313	    configLoadFailed = true;
   314	    lessonDataLoadedSuccessfully = false;
   315	    currentConfig = null;
   316	    showConfigLoadErrorBanner(err);
   317	  }
   318	  return currentConfig;
   319	}
   320	
   321	function showConfigLoadErrorBanner(err) {
   322	  const banner = document.getElementById('lesson-load-error-banner');
   323	  if (!banner) return;
   324	  const denied = err?.code === 'permission-denied';
   325	  const msg = denied
   326	    ? "Can't read the app configuration — check Firestore rules. Nothing was changed, and saving is disabled until this is fixed."
   327	    : "Can't read the app configuration — check your connection. Nothing was changed, and saving is disabled until this is fixed.";
   328	  const target = banner.querySelector('[data-role="message"]') || banner;
   329	  target.textContent = msg;
   330	  banner.classList.remove('hidden');
   331	}
   332	
   333	// ─── appData writes — one update(), only the paths named (Phase 1, 1.2) ──────
   334	// `updates` is a flat map of dotted field paths → values (FieldValue.delete()
   335	// allowed). Semester keys are slugified [a-z0-9-], so a dotted path never
   336	// needs quoting. Dotted STRINGS, not FieldPath objects: the compat SDK's
   337	// FieldPath form needs the varargs overload, an easy mistake.
   338	function nestFieldPaths(flat) {
   339	  const nested = {};
   340	  for (const [path, value] of Object.entries(flat)) {
   341	    const parts = path.split('.');
   342	    let node = nested;
   343	    while (parts.length > 1) { const k = parts.shift(); node = node[k] = node[k] || {}; }
   344	    node[parts[0]] = value;
   345	  }
   346	  return nested;
   347	}
   348	
   349	async function updateAppData(updates) {
   350	  if (!curriculumDb) initCurriculumFirestore();
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-afXWuif0' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-dUzN486e' (errno=Operation not permitted)
   650	function isCoTeacherForCurrentSemester() {
   651	  const user = getAuthUser();
   652	  if (!user || tvCurrentTeacher) return false;
   653	  const semKey = getTvSemKey();
   654	  const lessons = currentLessonData?.[semKey];
   655	  return !!lessons && Object.values(lessons).some(l =>
   656	    Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
   657	  );
   658	}
   659	
   660	async function initTeacherView() {
   661	  // Already built: the semester may have changed on another tab — refresh for
   662	  // it (renderTeacherView handles SDOC, and leaving SDOC, itself).
   663	  if (tvInitialized) {
   664	    if (isDayOffYear(getTvSemKey()) || tvTeacherListFor) { renderTvSemesterSelector(); renderQaActivityPanel(); renderTeacherView(); }
   665	    return;
   666	  }
   667	  tvInitialized = true;
   668	
   669	  // Load lesson data if not already loaded
   670	  if (!currentLessonData) {
   671	    await loadLessonData();
   672	  }
   673	
   674	  // Show banner and abort if load failed — prevents stale blank data from being saved.
   675	  // Not "initialized": the guard can trip transiently now (a listener reload
   676	  // that fails and self-heals — Backtracking audit Phase 7), and the next
   677	  // visit to this tab must be allowed to build it.
   678	  if (lessonDataLoadedSuccessfully === false) {
   679	    tvInitialized = false;
   680	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   681	    return;
   682	  }
   683	
   684	  // Set up real-time listener FIRST so the retry mechanism fires even if
   685	  // summer camp data isn't ready yet when we reach the early-return below.
   686	  setupLessonDataListener((data) => {
   687	    currentLessonData = data;
   688	    renderProgressDashboard();
   689	    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
   690	    // no sharedWith — so re-render on every reload while the year is showing
   691	    // (the list and the teacher picker are rebuilt from the camps each time).
   692	    if (isDayOffYear(getTvSemKey())) {
   693	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
   694	      renderTeacherMappingTable();
   695	      return;
   696	    }
   697	    // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
   698	    const semKey = getTvSemKey();
   699	    const lessons = currentLessonData?.[semKey];
   700	    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
   701	      const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
   702	      if (!hasTeachers) {
   703	        tvInitialized = false;
   704	        initTeacherView();
   705	      }
   706	    }
   707	    // Skip re-render while a camp is expanded — preserves expanded state on live data updates
   708	    const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
   709	    if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
   710	    // Refresh teacher mapping table in Settings if it exists
   711	    renderTeacherMappingTable();
   712	  });
   713	
   714	  // Build semester selector (only show if multiple published semesters)
   715	  renderTvSemesterSelector();
   716	
   717	  const semKey = getTvSemKey();
   718	  const lessons = currentLessonData?.[semKey];
   719	
   720	  // Before the empty-map "Loading…" branch below — an SDOC year with no camps
   721	  // (or only empty blocks) is an empty map and would otherwise say "Loading"
   722	  // forever. Initialized like any other type (Phase 2B): the listener above is
   723	  // subscribed once, and the controls are bound once; renderTeacherView()
   724	  // builds the SDOC teacher list itself.
   725	  if (isDayOffYear(semKey)) {
   726	    bindTeacherViewControlsOnce();
   727	    renderTeacherView();
   728	    return;
   729	  }
   730	
  5085	  renderHelpQueue();
  5086	  renderCutBank();
  5087	  renderIdeaBank();
  5088	  renderChangeHistory();
  5089	}
  5090	
  5091	async function initCurriculumAdmin() {
  5092	  if (caInitialized) return;
  5093	  caInitialized = true;
  5094	
  5095	  if (!currentLessonData) await loadLessonData();
  5096	  if (!currentChangeLog) await loadChangeLog();
  5097	  if (!currentCutProjects) await loadCutProjects();
  5098	  if (!currentFutureProjects) await loadFutureProjects();
  5099	
  5100	  renderSemesterSelector();
  5101	  renderAdminGrid();
  5102	  renderHelpQueue();
  5103	  renderCutBank();
  5104	  renderIdeaBank();
  5105	  renderChangeHistory();
  5106	
  5107	  // Modal close
  5108	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5109	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5110	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5111	  });
  5112	
  5113	  // Real-time updates
  5114	  setupLessonDataListener((data) => {
  5115	    currentLessonData = data;
  5116	    renderAdminGrid();
  5117	    renderHelpQueue();
  5118	    // Refresh teacher mapping table in Settings if it exists
  5119	    renderTeacherMappingTable();
  5120	  });
  5121	}
  5122	
  5123	function renderAdminGrid() {
  5124	  const wrapper = document.getElementById('ca-grid-wrapper');
  5125	  const semKey = getAdminSemKey();
  5126	  const lessons = currentLessonData?.[semKey];
  5127	
  5128	  // School Day Off Camps years: the event/camp planning list (Phase 1).
  5129	  if (isDayOffYear(semKey)) {
  5130	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '855,885p'; git status --short" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
   855	
   856	async function savePrepCycleConfig(config) {
   857	  if (!curriculumDb) initCurriculumFirestore();
   858	  const user = getAuthUser();
   859	  const toSave = {
   860	    ...config,
   861	    lastUpdated: new Date().toISOString(),
   862	    lastUpdatedBy: user?.name || 'Unknown'
   863	  };
   864	  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
   865	}
   866	
   867	// ─── Lesson Data (curriculum/lessonData) ─────────────
   868	
   869	// Every camp-season semester in the config, with the season each one reads.
   870	// In legacy mode the 2026 season reads unfiltered (it is the only season that
   871	// exists by definition) and any other camp season loads nothing at all —
   872	// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
   873	function dayOffYearKeys() {
   874	  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
   875	}
   876	
   877	function campSeasonLoadPlan() {
   878	  const semesters = currentConfig?.semesters || {};
   879	  return Object.keys(semesters)
   880	    .filter(isCampSeason)
   881	    .map(semKey => {
   882	      const season = seasonForSemester(semKey);
   883	      if (seasonRegistryMode === 'legacy') {
   884	        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
   885	      }
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-brdb98Cf' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-cpjgVzdl' (errno=Operation not permitted)

codex
- **MEDIUM** — A failed multi-year reload can partially install data despite the requirement to preserve previous figures. `loadDayOffCampData()` mutates `currentDayOffEvents/Camps/Plans` immediately, before the reload knows every year succeeded. If year A succeeds and a later year B fails, A’s new camp structure is rendered against its old slot map, while all years are marked failed. [firebase-data.js:2424](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2424), [firebase-data.js:1346](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1346), [firebase-data.js:1369](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1369). P4 only fails the first SDOC read, so it cannot catch this. [day-off-overview.spec.js:168](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:168)

- **MEDIUM** — Startup failures never set `dayOffRefreshFailed`. If a camp season or later SDOC year fails during `loadLessonData()`, the guard trips, but affected SDOC headers show “Not refreshed yet” rather than “Couldn’t refresh.” Earlier years may already have stamps and partially installed side maps. [firebase-data.js:959](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:959), [firebase-data.js:975](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:975). P15 verifies only the guard. [day-off-overview.spec.js:365](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:365)

- **MEDIUM** — The documented `no-listener` assumption is false during startup. `caInitialized` becomes true before several awaited loads and listener registration, while lesson data was already preloaded. A fast tab entry/year switch invokes `refreshDayOffYear()`, receives `no-listener`, and is never retried after registration. [app.js:5113](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5113), [app.js:12671](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12671). P11 runs after initialization; P14 manually installs the listener.

- **LOW** — A genuinely offline guarded page cannot open the promised read-only editor: the transactional server read happens before `canEdit` is calculated and transactions fail offline, producing only the alert. P4/P5 simulate the guard while Firestore remains reachable. [app.js:11642](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11642), [firebase-data.js:2915](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2915)

The compat transaction usage and escaping/onclick handling otherwise look correct. No tests were run, per instruction.

**Ready to merge — no.**
tokens used
114,547
- **MEDIUM** — A failed multi-year reload can partially install data despite the requirement to preserve previous figures. `loadDayOffCampData()` mutates `currentDayOffEvents/Camps/Plans` immediately, before the reload knows every year succeeded. If year A succeeds and a later year B fails, A’s new camp structure is rendered against its old slot map, while all years are marked failed. [firebase-data.js:2424](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2424), [firebase-data.js:1346](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1346), [firebase-data.js:1369](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1369). P4 only fails the first SDOC read, so it cannot catch this. [day-off-overview.spec.js:168](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:168)

- **MEDIUM** — Startup failures never set `dayOffRefreshFailed`. If a camp season or later SDOC year fails during `loadLessonData()`, the guard trips, but affected SDOC headers show “Not refreshed yet” rather than “Couldn’t refresh.” Earlier years may already have stamps and partially installed side maps. [firebase-data.js:959](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:959), [firebase-data.js:975](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:975). P15 verifies only the guard. [day-off-overview.spec.js:365](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:365)

- **MEDIUM** — The documented `no-listener` assumption is false during startup. `caInitialized` becomes true before several awaited loads and listener registration, while lesson data was already preloaded. A fast tab entry/year switch invokes `refreshDayOffYear()`, receives `no-listener`, and is never retried after registration. [app.js:5113](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5113), [app.js:12671](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12671). P11 runs after initialization; P14 manually installs the listener.

- **LOW** — A genuinely offline guarded page cannot open the promised read-only editor: the transactional server read happens before `canEdit` is calculated and transactions fail offline, producing only the alert. P4/P5 simulate the guard while Firestore remains reachable. [app.js:11642](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11642), [firebase-data.js:2915](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2915)

The compat transaction usage and escaping/onclick handling otherwise look correct. No tests were run, per instruction.

**Ready to merge — no.**
