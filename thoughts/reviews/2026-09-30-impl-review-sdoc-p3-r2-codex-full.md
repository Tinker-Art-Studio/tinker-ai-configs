OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f570-d84f-7aa3-afa0-f6095f0efe2b
--------
user
# Implementation review ROUND 2 (short) — Classbook SDOC Phase 3, fixes commit 6d9392c on top of c7400df
Repo READ-ONLY: /Users/christiehubley/tinker-spring-curriculum (branch claude/sdoc-phase3-overview). Do NOT edit/write/deploy.
Fix diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-r2.diff (`git -C <repo> diff c7400df HEAD`). Round 1: ~/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-{claude,codex-full}.md
Decisions on round 1: FIXED — hung refresh deadline (30 s gate release); startup failure sets dayOffRefreshFailed; stamp only
after the whole reload installs; single redraw via the shared callback; weekday in an old stamp. NOT FIXED, with reasons in
the commit message — (a) 'no-listener' during startup: the listener's first server snapshot always runs a full reload and
redraws, so it self-resolves; (b) multi-year partial side-map install: pre-existing 2B loader behaviour, fixing it touches
verified-save ordering, deferred to its own design; (c) offline read-only editor: the old get({source:'server'}) failed offline
the same way. Confirm the fixes are correct (esp. the deadline: can the released gate let two reloads overlap in a harmful
way? does the hung promise ever release a NEWER run's gate?), whether each "not fixed" reason holds, and whether P17–P19 pin
the fixes. Only NEW HIGH/MEDIUM block. End with: ready to merge — yes/no. ≤300 words.

codex
I’ll review the supplied diff and both round-one reports, then trace the refresh-generation/gate behavior and the P17–P19 assertions. I’ll keep the repo strictly read-only.
exec
/bin/zsh -lc "pwd && git status --short --branch && git log --oneline -5 && sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-r2.diff && printf '\\n--- CLAUDE R1 ---\\n' && sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-claude.md && printf '\\n--- CODEX R1 ---\\n' && sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-codex-full.md" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
/Users/christiehubley/tinker-spring-curriculum
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-rYFMyQ6s' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Kslb4kxC' (errno=Operation not permitted)
## claude/sdoc-phase3-overview...origin/claude/sdoc-phase3-overview
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-gmGGOS3p' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-v6By7Z8q' (errno=Operation not permitted)
6d9392c SDOC Phase 3 review round 1: hung-refresh deadline, startup failure flag, stamp after full install
c7400df SDOC Phase 3: planner's plan overview, one shared listener callback, transactional editor open
132fef2 Merge pull request #5 from Tinker-Art-Studio/claude/spring-own-doc
9e551c2 Phase B review round 2 (Claude): manager-only storage readout; no stray test writes; verified-path UI test
9275732 Phase B review round 2: notice on migration-listener error; real-UI and real-race tests
diff --git a/e2e/day-off-overview.spec.js b/e2e/day-off-overview.spec.js
index 2a1e829..7ffa49b 100644
--- a/e2e/day-off-overview.spec.js
+++ b/e2e/day-off-overview.spec.js
@@ -381,6 +381,51 @@ test.describe('School Day Off Camps — Phase 3: the planner\'s plan overview',
     expect(ok).toBe(false);
   });
 
+  test('P17: a failed SDOC load at startup says "Couldn\'t refresh" in the overview (not a quiet empty year)', async () => {
+    await makeThanksgiving();
+    await showYear(planner);
+    const failed = await planner.evaluate(async (Y) => {
+      const real = window.loadDayOffCampData;
+      window.loadDayOffCampData = async () => { throw new Error('TEST injected startup failure'); };
+      try { await loadLessonData(); } finally { window.loadDayOffCampData = real; }
+      return { failed: dayOffRefreshFailed[Y] === true, guard: lessonDataLoadedSuccessfully };
+    }, Y);
+    expect(failed).toEqual({ failed: true, guard: false });
+    await planner.evaluate(() => renderAdminGrid());
+    await expect(planner.locator('#sdoc-refresh-error')).toContainText("Couldn't refresh");
+  });
+
+  test('P18: a refresh that hangs releases the gate after the deadline — the next refresh runs a new reload', async () => {
+    await makeThanksgiving();
+    await showYear(planner);
+    const n = await planner.evaluate(async (Y) => {
+      DAY_OFF_REFRESH_DEADLINE_MS = 300;
+      const real = window.reloadSummerForModeChange;
+      let calls = 0;
+      window.reloadSummerForModeChange = () => { calls++; return calls === 1 ? new Promise(() => {}) : real(); };   // the first never answers
+      try {
+        refreshDayOffYear(Y);
+        const busy = document.getElementById('sdoc-refresh-btn').disabled;
+        await new Promise(r => setTimeout(r, 500));
+        const outcome = await refreshDayOffYear(Y);
+        return { calls, busy, outcome };
+      } finally { window.reloadSummerForModeChange = real; DAY_OFF_REFRESH_DEADLINE_MS = 30000; }
+    }, Y);
+    expect(n).toEqual({ calls: 2, busy: true, outcome: 'ok' });
+    await expect(planner.locator('#sdoc-refresh-btn')).toBeEnabled();
+  });
+
+  test('P19: a refresh from an earlier day shows the weekday with the time', async () => {
+    await makeThanksgiving();
+    await showYear(planner);
+    const label = await planner.evaluate((Y) => {
+      const d = new Date(); d.setDate(d.getDate() - 2); d.setHours(15, 7, 0, 0);
+      dayOffLastRefreshAt[Y] = d; renderAdminGrid();
+      return d.toLocaleDateString([], { weekday: 'short' });
+    }, Y);
+    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText(`Last full refresh ${label} 3:07`);
+  });
+
   test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {
     const { clay } = await makeThanksgiving();
     await showYear(planner);
diff --git a/js/app.js b/js/app.js
index 82e0946..07a5fea 100644
--- a/js/app.js
+++ b/js/app.js
@@ -12667,28 +12667,35 @@ function dayOffEventCamps(yearKey, eventId) {
 // Curriculum Admin entry, on switching to it, and by ↻ Refresh — always through
 // the listener's own generation-gated reload, never a second loader.
 let dayOffRefreshInFlight = null;
-
+// A read that hangs (connected but stalled) must not hold the gate for the rest
+// of the visit: after this long a new refresh may start — its generation bump
+// makes the hung one 'stale' if it ever answers.
+let DAY_OFF_REFRESH_DEADLINE_MS = 30000;   // let: the e2e suite shortens it
+
+// Resolves with the reload's outcome. The listener's callback (onLessonDataReload)
+// redraws Curriculum Admin on 'ok' and 'failed' alike. 'no-listener' only happens
+// before initCurriculumAdmin() has registered the listener — and registering it
+// always runs a full reload on the first server snapshot, which redraws.
 function refreshDayOffYear(yearKey) {
   if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
-  const run = (async () => {
-    const outcome = await reloadSummerForModeChange();
-    // The listener's callback redraws Curriculum Admin too, but draw here as
-    // well: a failed outcome must show its message whoever registered last.
-    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
-    return outcome;
-  })();
+  const run = reloadSummerForModeChange();
   dayOffRefreshInFlight = run;
-  const done = () => {
-    if (dayOffRefreshInFlight === run) dayOffRefreshInFlight = null;
+  const release = () => {
+    if (dayOffRefreshInFlight !== run) return;
+    dayOffRefreshInFlight = null;
     if (isDayOffYear(getAdminSemKey())) renderDayOffRefreshControls(getAdminSemKey());
   };
-  run.then(done, done);
+  run.then(release, release);
+  setTimeout(release, DAY_OFF_REFRESH_DEADLINE_MS);
   renderDayOffRefreshControls(yearKey);   // disable the button now
   return run;
 }
 
+// "3:07 PM" today; "Mon 3:07 PM" otherwise (a page left open overnight).
 function formatDayOffRefreshTime(d) {
-  return d instanceof Date && !isNaN(d) ? d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' }) : '';
+  if (!(d instanceof Date) || isNaN(d)) return '';
+  const time = d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
+  return d.toDateString() === new Date().toDateString() ? time : `${d.toLocaleDateString([], { weekday: 'short' })} ${time}`;
 }
 
 function dayOffRefreshControlsHtml(yearKey) {
diff --git a/js/firebase-data.js b/js/firebase-data.js
index c156e28..c35ecf5 100644
--- a/js/firebase-data.js
+++ b/js/firebase-data.js
@@ -977,11 +977,13 @@ async function loadLessonData() {
       // loaded model is not a safe base for any writer, in any semester.
       console.error('❌ Could not load camp season data:', err);
       lessonDataLoadedSuccessfully = false;
+      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // SDOC Phase 3: say so in the overview
     }
   } catch (err) {
     console.error('Error loading lesson data:', err);
     currentLessonData = {};
     lessonDataLoadedSuccessfully = false;
+    for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;
   }
   return currentLessonData;
 }
@@ -1349,7 +1351,6 @@ function setupLessonDataListener(callback) {
       for (const yearKey of dayOffKeys) {
         currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
         healDayOffYearAfterReload(yearKey, fresh[yearKey]);
-        markDayOffYearInstalled(yearKey);
       }
       for (const plan of plans) {
         // Each season merges against ITS OWN previous map — mergeSummerReload
@@ -1358,6 +1359,7 @@ function setupLessonDataListener(callback) {
         currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
       }
       console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
+      for (const yearKey of dayOffKeys) markDayOffYearInstalled(yearKey);   // only once everything installed
       lessonDataLoadedSuccessfully = true;
       document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
       return 'ok';

--- CLAUDE R1 ---
# Implementation review — SDOC Phase 3 (`c7400df`)

## MEDIUM — a stalled refresh is swallowed for the rest of the session
`js/app.js:12669-12687`. `dayOffRefreshInFlight` clears only in `done()`, on settle. A `get({source:'server'})` on a connected-but-stalled socket doesn't reject, so one hung reload leaves ↻ at "Refreshing…" **and makes every later automatic refresh return the same dead promise** — exactly the staleness Phase 3 exists to kill, with no message. Fix: a deadline on the gate.

## MEDIUM — a startup SDOC failure never sets the failure flag
`js/firebase-data.js:977-980`. `loadLessonData`'s catch trips the guard but not `dayOffRefreshFailed`, unlike the listener's catch (`:1367-1369`). The panel then reads "No day-off dates yet" + "Not refreshed yet" with no "Couldn't refresh" — the misleading-empty-state shape this app has history with. Mitigated: `initCurriculumAdmin` registers the listener unconditionally and its first snapshot reload sets the flag, so the window is ~1 s. One-line fix.

## LOW
- `js/app.js:12677` — the second `renderAdminGrid()` is dead weight: `summerReloadHook` already calls the callback on both `'ok'` and `'failed'`, so each refresh rebuilds the table twice.
- `js/app.js:12677` — `'no-listener'` is a silent no-op (CA re-entry racing `initCurriculumAdmin`'s awaits): ↻ does nothing, no message, stamp unmoved.
- `js/firebase-data.js:1349-1353` vs `:1369` — a throw in `healDayOffYearAfterReload`/`mergeSummerReload` *after* the stamp is set gives stamp-now + failed, i.e. "Couldn't refresh — showing the last full refresh (now)".
- `js/app.js:702` — `renderAdminGrid(); renderHelpQueue();` share one `try`; isolation is per view, not per call (same for TV's branch).
- `js/app.js:12690` — time-only stamp; a page open overnight shows an ambiguous "3:07".
- Test hazard: the one-shot `runTransaction` hooks (`e2e/day-off-teacher.spec.js:243,276,307,326`, `e2e/day-off-materials.spec.js:280`) are all installed *after* any editor open, so none breaks — but one installed before "Open plan" would now be eaten by the editor's read.
- Test gap: `teacherViewOnReload`'s non-SDOC branches (`js/app.js:666-689`) are unpinned — nothing tests that an expanded summer camp survives a reload, or the `hasTeachers` re-init.

## Verified clean
Hidden redraws clobber nothing (SDOC/CA modals are static `index.html` elements outside `#ca-grid-wrapper`; summer CA keeps no expansion state; TV keeps its `anyExpanded` guard); `tvInitialized` is set before registration, so the gate never skips a redraw; lifecycle calls can't fire on startup or loop (`previousKey` captured pre-mutation; P11 pins it); a camp-season failure marking all SDOC years **is** right — nothing installs before the generation gate; the compat `runTransaction(tx => tx.get(ref))` resolves to the snapshot, commits zero writes, and rejects offline into the existing `catch` at `js/app.js:11658`; escaping is sound (text via `sdocEsc`, attributes via `sdocEscA`, both new `onclick`s carry no `${…}`, so the PR #3 ratchet at `e2e/onclick-quotes.spec.js:126` stays green); 8 `<th>`/8 `<td>`; P10, P14 and P16 would each fail on the pre-Phase-3 code.

**ready to merge — yes** (the two MEDIUMs as follow-ups).

Review written to `/Users/christiehubley/.claude/plans/implementation-review-fancy-liskov.md`. I made no changes to the repo and ran nothing that writes.

--- CODEX R1 ---
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

exec
/bin/zsh -lc "git show --format=fuller --stat --oneline 6d9392c && git show --format=fuller --no-patch 6d9392c && rg -n \"function (refreshDayOffYear|reloadSummerForModeChange|setupLessonDataListener|loadLessonData|markDayOffYearInstalled)|dayOffRefresh(InFlight|Failed|Generation|LastRefresh)|summerReloadHook|lessonDataReloadGeneration|reloadGeneration\" js/app.js js/firebase-data.js e2e/day-off-overview.spec.js && sed -n '12640,12730p' js/app.js && sed -n '900,1010p' js/firebase-data.js && sed -n '1270,1410p' js/firebase-data.js && sed -n '350,460p' e2e/day-off-overview.spec.js" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-tmfdq1SZ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-zU2iYsMG' (errno=Operation not permitted)
6d9392c SDOC Phase 3 review round 1: hung-refresh deadline, startup failure flag, stamp after full install
 e2e/day-off-overview.spec.js | 45 ++++++++++++++++++++++++++++++++++++++++++++
 js/app.js                    | 31 ++++++++++++++++++------------
 js/firebase-data.js          |  4 +++-
 3 files changed, 67 insertions(+), 13 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-EC9wW6Hf' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-7hF7OBvq' (errno=Operation not permitted)
commit 6d9392c5954087b9c88fa76bd7632dfe06fcef47
Author:     Christie Hubley <christie@tinkerartstudio.com>
AuthorDate: Wed Sep 30 21:10:06 2026 -0600
Commit:     Christie Hubley <christie@tinkerartstudio.com>
CommitDate: Wed Sep 30 21:10:06 2026 -0600

    SDOC Phase 3 review round 1: hung-refresh deadline, startup failure flag, stamp after full install
    
    From the dual implementation review (Claude: ready w/ 2 MEDIUM; Codex: 3 MEDIUM):
    - A refresh whose read hangs releases the one-at-a-time gate after 30 s, so
      later refreshes aren't swallowed for the rest of the visit (Claude).
    - A failed SDOC/camp-season load at startup sets dayOffRefreshFailed, so the
      overview says "Couldn't refresh" instead of a quiet empty year (both).
    - The stamp moves only once the whole gated reload has installed (Claude LOW).
    - refreshDayOffYear() no longer redraws twice — the shared callback draws on
      'ok' and 'failed'; why 'no-listener' self-resolves is documented (Codex).
    - "Last full refresh" shows the weekday when it wasn't today (Claude LOW).
    Not changed here (recorded in the plan): a failed reload across two SDOC
    years can install one year's side maps early — a pre-existing 2B loader trait;
    fixing it touches verified-save ordering, so it gets its own design.
    
    Tests: P17–P19. Full suite: 372 passed.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
e2e/day-off-overview.spec.js:300:      await (dayOffRefreshInFlight || Promise.resolve());   // the header switch's refresh settles first
e2e/day-off-overview.spec.js:391:      return { failed: dayOffRefreshFailed[Y] === true, guard: lessonDataLoadedSuccessfully };
js/firebase-data.js:951:async function loadLessonData() {
js/firebase-data.js:980:      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // SDOC Phase 3: say so in the overview
js/firebase-data.js:986:    for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;
js/firebase-data.js:1305:const dayOffRefreshFailed = {};
js/firebase-data.js:1306:function markDayOffYearInstalled(yearKey) {
js/firebase-data.js:1308:  delete dayOffRefreshFailed[yearKey];
js/firebase-data.js:1323:let summerReloadHook = null;
js/firebase-data.js:1324:async function reloadSummerForModeChange() {
js/firebase-data.js:1325:  if (typeof summerReloadHook !== 'function') return 'no-listener';
js/firebase-data.js:1326:  return await summerReloadHook();
js/firebase-data.js:1329:function setupLessonDataListener(callback) {
js/firebase-data.js:1371:      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
js/firebase-data.js:1385:  summerReloadHook = async () => {
js/app.js:12669:let dayOffRefreshInFlight = null;
js/app.js:12679:function refreshDayOffYear(yearKey) {
js/app.js:12680:  if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
js/app.js:12682:  dayOffRefreshInFlight = run;
js/app.js:12684:    if (dayOffRefreshInFlight !== run) return;
js/app.js:12685:    dayOffRefreshInFlight = null;
js/app.js:12703:  const busy = !!dayOffRefreshInFlight;
js/app.js:12704:  const failed = !!dayOffRefreshFailed[yearKey];

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

// ─── Plan overview (SDOC Phase 3) ───────────────────
// Read-only: computed from the slots buildDayOffSlots() already builds. Teachers
// save on other devices and there is no SDOC listener, so the year is re-read on
// Curriculum Admin entry, on switching to it, and by ↻ Refresh — always through
// the listener's own generation-gated reload, never a second loader.
let dayOffRefreshInFlight = null;
// A read that hangs (connected but stalled) must not hold the gate for the rest
// of the visit: after this long a new refresh may start — its generation bump
// makes the hung one 'stale' if it ever answers.
let DAY_OFF_REFRESH_DEADLINE_MS = 30000;   // let: the e2e suite shortens it

// Resolves with the reload's outcome. The listener's callback (onLessonDataReload)
// redraws Curriculum Admin on 'ok' and 'failed' alike. 'no-listener' only happens
// before initCurriculumAdmin() has registered the listener — and registering it
// always runs a full reload on the first server snapshot, which redraws.
function refreshDayOffYear(yearKey) {
  if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
  const run = reloadSummerForModeChange();
  dayOffRefreshInFlight = run;
  const release = () => {
    if (dayOffRefreshInFlight !== run) return;
    dayOffRefreshInFlight = null;
    if (isDayOffYear(getAdminSemKey())) renderDayOffRefreshControls(getAdminSemKey());
  };
  run.then(release, release);
  setTimeout(release, DAY_OFF_REFRESH_DEADLINE_MS);
  renderDayOffRefreshControls(yearKey);   // disable the button now
  return run;
}

// "3:07 PM" today; "Mon 3:07 PM" otherwise (a page left open overnight).
function formatDayOffRefreshTime(d) {
  if (!(d instanceof Date) || isNaN(d)) return '';
  const time = d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
  return d.toDateString() === new Date().toDateString() ? time : `${d.toLocaleDateString([], { weekday: 'short' })} ${time}`;
}

function dayOffRefreshControlsHtml(yearKey) {
  const at = formatDayOffRefreshTime(dayOffLastRefreshAt[yearKey]);
  const busy = !!dayOffRefreshInFlight;
  const failed = !!dayOffRefreshFailed[yearKey];
  return `<span class="sdoc-refresh" id="sdoc-refresh">
      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
      <button class="btn-text" id="sdoc-refresh-btn" type="button" onclick="refreshDayOffYear(getAdminSemKey())" ${busy ? 'disabled' : ''}>${busy ? 'Refreshing…' : '↻ Refresh'}</button>
      ${failed ? `<span id="sdoc-refresh-error" class="sdoc-refresh-error">Couldn't refresh — showing the last full refresh${at ? ` (${sdocEsc(at)})` : ''}</span>` : ''}
    </span>`;
}

// Just the header controls (busy state) — the rows wait for the outcome's redraw.
function renderDayOffRefreshControls(yearKey) {
  const el = document.getElementById('sdoc-refresh');
  if (el) el.outerHTML = dayOffRefreshControlsHtml(yearKey);
}

// Same status the teachers' list shows; 'ready' ("Almost Done") can't happen for
// an SDOC slot (campName zeroes materials) and reads as In Progress if it ever does.
function dayOffPlanProgress(slot) {
  const p = calculateLessonProgress(slot);
  return p === 'ready' ? 'in-progress' : p;
}

// A camp's plans in dayOffCampTitles() order — one per title, however many days it runs.
function dayOffCampPlanSlots(yearKey, camp) {
  const slots = currentLessonData?.[yearKey] || {};
  return [...dayOffCampTitles(camp).keys()]
    .map(title => ({ lessonKey: dayOffLessonKey(yearKey, camp.id, title), title }))
    .filter(({ lessonKey }) => slots[lessonKey])
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
        markDayOffYearInstalled(yearKey);
        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
      }
      lessonDataLoadedSuccessfully = true;
    } catch (err) {
      // One season failing trips the guard for the whole app: a partially
      // loaded model is not a safe base for any writer, in any semester.
      console.error('❌ Could not load camp season data:', err);
      lessonDataLoadedSuccessfully = false;
      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // SDOC Phase 3: say so in the overview
    }
  } catch (err) {
    console.error('Error loading lesson data:', err);
    currentLessonData = {};
    lessonDataLoadedSuccessfully = false;
    for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;
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
// SDOC Phase 3: when each School Day Off year was last read in full and
// installed (a Date), and whether the latest full reload of it failed. Both
// change only where a full load installs or fails — never on a single-plan
// read — and Curriculum Admin's overview derives its message from them at
// render time, so any redraw after a recovery shows the truth.
const dayOffLastRefreshAt = {};
const dayOffRefreshFailed = {};
function markDayOffYearInstalled(yearKey) {
  dayOffLastRefreshAt[yearKey] = new Date();
  delete dayOffRefreshFailed[yearKey];
}
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
      }
      for (const plan of plans) {
        // Each season merges against ITS OWN previous map — mergeSummerReload
        // prunes parked copies that are absent from `fresh`, so merging one
        // season against another's would evict the other's on every reload.
        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
      }
      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
      for (const yearKey of dayOffKeys) markDayOffYearInstalled(yearKey);   // only once everything installed
      lessonDataLoadedSuccessfully = true;
      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
      return 'ok';
    } catch (err) {
      console.error('❌ Could not load camp season / day-off camp data:', err);
      if (!isCurrent()) return 'stale';
      lessonDataLoadedSuccessfully = false;
      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
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
      return calls;
    });
    expect(drawn.tv).toBeGreaterThanOrEqual(1);
    expect(drawn.ca).toBeGreaterThanOrEqual(1);
    // A throw in Teacher View's redraw cannot skip the admin redraw.
    const adminDrew = await planner.evaluate(() => {
      let ca = 0; const rtv = window.teacherViewOnReload, rca = window.renderAdminGrid;
      window.teacherViewOnReload = () => { throw new Error('TEST throw'); };
      window.renderAdminGrid = (...a) => { ca++; return rca(...a); };
      try { onLessonDataReload(currentLessonData); } finally { window.teacherViewOnReload = rtv; window.renderAdminGrid = rca; }
      return ca;
    });
    expect(adminDrew).toBe(1);
  });

  test('P15: SDOC loads are server reads, and offline they trip the load guard instead of showing a cached year as editable', async () => {
    await makeThanksgiving();
    await showYear(planner);
    const opts = await planner.evaluate(async (Y) => {
      const proto = Object.getPrototypeOf(curriculumDb.collection('x').where('a', '==', 1));
      const real = proto.get; const seen = [];
      proto.get = function (o) { seen.push(o?.source || 'default'); return real.call(this, o); };
      try { await loadDayOffCampData({ yearKey: Y }); } finally { proto.get = real; }
      return seen;
    }, Y);
    expect(opts).toEqual(['server', 'server', 'server']);
    const ok = await planner.evaluate(async () => {
      await curriculumDb.disableNetwork();
      try { await loadLessonData(); return lessonDataLoadedSuccessfully; }
      finally { await curriculumDb.enableNetwork(); }
    });
    expect(ok).toBe(false);
  });

  test('P17: a failed SDOC load at startup says "Couldn\'t refresh" in the overview (not a quiet empty year)', async () => {
    await makeThanksgiving();
    await showYear(planner);
    const failed = await planner.evaluate(async (Y) => {
      const real = window.loadDayOffCampData;
      window.loadDayOffCampData = async () => { throw new Error('TEST injected startup failure'); };
      try { await loadLessonData(); } finally { window.loadDayOffCampData = real; }
      return { failed: dayOffRefreshFailed[Y] === true, guard: lessonDataLoadedSuccessfully };
    }, Y);
    expect(failed).toEqual({ failed: true, guard: false });
    await planner.evaluate(() => renderAdminGrid());
    await expect(planner.locator('#sdoc-refresh-error')).toContainText("Couldn't refresh");
  });

  test('P18: a refresh that hangs releases the gate after the deadline — the next refresh runs a new reload', async () => {
    await makeThanksgiving();
    await showYear(planner);
    const n = await planner.evaluate(async (Y) => {
      DAY_OFF_REFRESH_DEADLINE_MS = 300;
      const real = window.reloadSummerForModeChange;
      let calls = 0;
      window.reloadSummerForModeChange = () => { calls++; return calls === 1 ? new Promise(() => {}) : real(); };   // the first never answers
      try {
        refreshDayOffYear(Y);
        const busy = document.getElementById('sdoc-refresh-btn').disabled;
        await new Promise(r => setTimeout(r, 500));
        const outcome = await refreshDayOffYear(Y);
        return { calls, busy, outcome };
      } finally { window.reloadSummerForModeChange = real; DAY_OFF_REFRESH_DEADLINE_MS = 30000; }
    }, Y);
    expect(n).toEqual({ calls: 2, busy: true, outcome: 'ok' });
    await expect(planner.locator('#sdoc-refresh-btn')).toBeEnabled();
  });

  test('P19: a refresh from an earlier day shows the weekday with the time', async () => {
    await makeThanksgiving();
    await showYear(planner);
    const label = await planner.evaluate((Y) => {
      const d = new Date(); d.setDate(d.getDate() - 2); d.setHours(15, 7, 0, 0);
      dayOffLastRefreshAt[Y] = d; renderAdminGrid();
      return d.toLocaleDateString([], { weekday: 'short' });
    }, Y);
    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText(`Last full refresh ${label} 3:07`);
  });

  test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {
    const { clay } = await makeThanksgiving();
    await showYear(planner);
    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST fresh text', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0008' });
    // Every plain DocumentReference.get() now answers with a stale "no plan yet" — what a
    // get({source:'server'}) after a Listen transport error can do.
    await planner.evaluate(() => {
      const proto = Object.getPrototypeOf(curriculumDb.collection('x').doc('y'));
      const real = proto.get;
      window.__restoreGet = () => { proto.get = real; };
      proto.get = function (o) {
        if (this.path.startsWith('dayOffCamps_lessonData/')) return Promise.resolve({ exists: false, data: () => undefined, id: this.id, ref: this, metadata: { fromCache: false } });
        return real.call(this, o);
      };
    });
    try {
      await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
      await expect(planner.locator('#summer-closure')).toHaveValue('TEST fresh text');
    } finally {
      await planner.evaluate(() => window.__restoreGet());
    }
  });
});

codex
The identity check on gate release is promising: an old timer/settlement cannot clear a newer run’s gate. I’m now checking the deeper generation boundary—especially whether an expired run can still mutate side maps or schedule retries after a newer reload starts—and whether P18 actually exercises that race.
exec
/bin/zsh -lc "sed -n '1380,1495p' js/firebase-data.js && sed -n '2320,2465p' js/firebase-data.js && rg -n \"function loadOneCampSeason|async function loadOneCampSeason|isCurrent\" js/firebase-data.js | head -60 && sed -n '1180,1285p' js/firebase-data.js && rg -n \"P1[0-9]|refreshDayOffYear|markDayOffYearInstalled|Last full refresh|dayOffRefreshFailed\" e2e/day-off-overview.spec.js" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
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
          currentLessonData = currentLessonData || {};
          currentLessonData[semKey] = ownDocLessonMap(snap.data());
          document.getElementById('storage-notice-banner')?.classList.add('hidden');
        } else if (ownDocSource[semKey] === 'ownDoc') {
          // Rolled back: the own document is gone — fall back to lessonData.
          ownDocSource[semKey] = 'legacy';
          const legacyMap = lastLegacyLessonData?.[semKey];
          if (legacyMap) currentLessonData[semKey] = legacyMap;
          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
        } else {
          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
          return;   // nothing changed for this tab
        }
        updateOwnDocPausedNotice();
        if (callback) callback(currentLessonData);
      }, err => {
        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
        ownDocSource[semKey] = 'error';
        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
        updateOwnDocPausedNotice();
      }));
  }
}

// ─── Cut Projects (curriculum/cutProjects) ───────────

async function loadCutProjects() {
  if (!curriculumDb) initCurriculumFirestore();
  try {
    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
    currentCutProjects = doc.exists ? doc.data() : {};
  } catch (err) {
    console.error('Error loading cut projects:', err);
    currentCutProjects = {};
  }
  return currentCutProjects;
}

async function saveCutProjects(semesterKey, projects) {
  if (!curriculumDb) initCurriculumFirestore();
  const user = getAuthUser();
  await curriculumDb.collection('curriculum').doc('cutProjects').set({
    [semesterKey]: projects,
    lastUpdated: new Date().toISOString(),
  if (plan.projectDetails != null && !(typeof plan.projectDetails === 'string' && !plan.projectDetails.trim())) return true;
  if (plan.projectLinks != null && !(Array.isArray(plan.projectLinks) && plan.projectLinks.length === 0)) return true;
  // Phase 2A: a planner-built list, or a tick on an item that still exists.
  if (dayOffValidItemIds(plan).length > 0) return true;
  if (dayOffLiveChecks(plan).length > 0) return true;
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
  // Server reads (Phase 3, Christie's yes Sep 29): offline, the load fails and
  // trips the guard instead of serving a cached or empty year as editable.
  const [eventSnap, campSnap, planSnap] = await Promise.all([
    dayOffQuery('events', 'yearKey', yearKey).get({ source: 'server' }),
    dayOffQuery('camps', 'yearKey', yearKey).get({ source: 'server' }),
    dayOffQuery('plans', 'yearKey', yearKey).get({ source: 'server' }),
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
891:async function loadOneCampSeason(plan, opts = {}) {
1342:    const isCurrent = () => myGeneration === globalListenerGeneration;
1347:      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
1349:      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
1350:      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
1368:      if (!isCurrent()) return 'stale';
1375:          if (!isCurrent()) return; // a newer snapshot has taken over
1910:// opts.isCurrent (optional): a predicate the listener passes so a reload that
1917:  const isCurrent = typeof opts.isCurrent === 'function' ? opts.isCurrent : () => true;
2142:    if (isCurrent() && opts.semKey) currentSummerSessionsBySemester[opts.semKey] = sessions;
2400:async function loadDayOffCampData({ yearKey, isCurrent = () => true } = {}) {
2426:  if (isCurrent()) {
async function readServerSemesterLessonMap(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
}

async function backupLessonData(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  const existing = currentLessonData?.[semesterKey];
  if (!existing || Object.keys(existing).length === 0) return 0;
  const count = Object.keys(existing).length;
  const user = getAuthUser();
  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
    [semesterKey]: existing,
    backupDate: new Date().toISOString(),
    backupBy: user?.name || 'Unknown'
  }, { merge: true });
  return count;
}

async function restoreFromBackup(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
  if (!backupDoc.exists) return null;
  const backupData = backupDoc.data();
  const lessons = backupData?.[semesterKey];
  if (!lessons || Object.keys(lessons).length === 0) return null;
  await saveLessonData(semesterKey, lessons);
  return Object.keys(lessons).length;
}

// "Which copy of a lesson is newer", by lastEditedAt — the only revision
// marker the data has (a client wall-clock heuristic: ties and missing values
// resolve to "not newer"). Shared by the listener merge below and the summer
// editor's own adoption/re-install logic (Backtracking audit Phase 10).
function lessonEditedAtMs(lesson) {
  return Date.parse(lesson?.lastEditedAt || '') || 0;
}

// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
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
7: * a per-event roll-up, "Last full refresh" + ↻ Refresh. Plus the two shared pieces the design
78:  await page.evaluate((Y) => refreshDayOffYear(Y), Y);   // shares the in-flight one the switch started
156:    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('Last full refresh');
164:    await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
174:    const outcome = await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
261:  test('P10: an older refresh that resolves last cannot undo a newer reload; the stamp is the newer one\'s', async () => {
273:    await planner.evaluate((Y) => { window.__firstRefresh = refreshDayOffYear(Y); }, Y);
284:  test('P11: one refresh on tab re-entry and one on switching the header to the SDOC year; ticking or redrawing triggers none; one in flight at a time', async () => {
289:      const real = window.refreshDayOffYear;
290:      window.refreshDayOffYear = (...a) => { window.__refreshes++; return real(...a); };
303:      const a = refreshDayOffYear(Y); const b = refreshDayOffYear(Y);
311:  test('P12: opening a plan (a single-plan read) does not move "Last full refresh"', async () => {
321:  test('P13: after a Teacher View visit, a reload triggered by a weekly lessonData change redraws Curriculum Admin with no click', async () => {
325:    await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
334:  test('P14: one shared listener callback — both views register the same function, and either order redraws both', async () => {
365:  test('P15: SDOC loads are server reads, and offline they trip the load guard instead of showing a cached year as editable', async () => {
384:  test('P17: a failed SDOC load at startup says "Couldn\'t refresh" in the overview (not a quiet empty year)', async () => {
391:      return { failed: dayOffRefreshFailed[Y] === true, guard: lessonDataLoadedSuccessfully };
398:  test('P18: a refresh that hangs releases the gate after the deadline — the next refresh runs a new reload', async () => {
407:        refreshDayOffYear(Y);
410:        const outcome = await refreshDayOffYear(Y);
418:  test('P19: a refresh from an earlier day shows the weekday with the time', async () => {
426:    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText(`Last full refresh ${label} 3:07`);
429:  test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {

exec
/bin/zsh -lc "sed -n '130,190p' e2e/day-off-overview.spec.js && sed -n '245,315p' e2e/day-off-overview.spec.js && sed -n '860,930p' js/firebase-data.js && sed -n '1900,2160p' js/firebase-data.js" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
    const { ev, clay, paint } = await makeThanksgiving();
    const paint2 = await saveCamp(planner, {
      eventId: ev.id, title: 'TEST Paint Party 2', timeSlot: 'PM', timeLabel: '1–3', location: 'Tinker',
      placements: [{ studio: 'GR', ageRange: '8–12', capacity: 10 }],
      teachers: ['TESTteacher2'], dates: ['2026-11-24'], projects: { '2026-11-24': { block1: 'Canvas' } }, notes: '',
    });
    await showYear(planner);
    const titles = (camp) => planner.locator(`tr[data-camp-id="${camp.id}"] .sdoc-plans-cell .sdoc-plan-title`).allTextContents();
    expect(await titles(clay)).toEqual(['Clay Creatures', 'Glaze Day']);
    expect(await titles(paint)).toEqual(['Canvas']);
    expect(await titles(paint2)).toEqual(['Canvas']);
    await expect(rollup(planner, ev)).toHaveText('Plans: 0 of 4 complete · 4 not started');
  });

  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
    const { clay } = await makeThanksgiving();
    await showYear(planner);
    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('Not Started');
    await planner.evaluate((Y) => { dayOffLastRefreshAt[Y] = new Date(2020, 0, 1, 3, 7); renderAdminGrid(); }, Y);
    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('3:07');
    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST closure from Mariah', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0003' });
    await spyWrites(planner);
    await planner.click('#sdoc-refresh-btn');
    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-edited')).toContainText('last edited by TESTteacher2');
    await expect(planner.locator('#sdoc-refresh-stamp')).not.toContainText('3:07');
    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('Last full refresh');
    expect(await writes(planner)).toEqual([]);
  });

  test('P4: a failed refresh keeps the figures, says so, and opens plans read-only — then, after a Teacher View visit, the automatic retry recovers with no click', async () => {
    const { clay } = await makeThanksgiving();
    await showYear(planner);
    await planner.evaluate(() => { switchTab('teacher-view'); switchTab('curriculum-admin'); });   // Teacher View has now registered too
    await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
    const stampBefore = await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y);
    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST newer text', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0004' });
    // The next SDOC read fails once; the automatic retry comes 4 s later.
    await planner.evaluate(() => {
      SUMMER_RELOAD_RETRY_DELAYS_MS[0] = 4000;
      const real = window.loadDayOffCampData;
      let failNext = true;
      window.loadDayOffCampData = async (opts) => { if (failNext) { failNext = false; throw new Error('TEST injected SDOC read failure'); } return real(opts); };
    });
    const outcome = await planner.evaluate((Y) => refreshDayOffYear(Y), Y);
    expect(outcome).toBe('failed');
    await expect(planner.locator('#sdoc-refresh-error')).toContainText("Couldn't refresh");
    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('Not Started');   // previous figures
    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBe(stampBefore);
    expect(await planner.evaluate(() => lessonDataLoadedSuccessfully)).toBe(false);
    // Inside the retry window: Open plan is read-only.
    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
    await expect(planner.locator('#summer-lesson-modal')).toHaveClass(/view-only/);
    await planner.click('#summer-lesson-close');
    await expect(planner.locator('#summer-lesson-modal')).toHaveCount(0);
    // The automatic retry succeeds: message gone, rows + stamp fresh, editing back — with no click.
    await expect(planner.locator('#sdoc-refresh-error')).toBeHidden({ timeout: 15_000 });
    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBeGreaterThan(stampBefore);
    expect(await planner.evaluate(() => lessonDataLoadedSuccessfully)).toBe(true);
    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
    await expect(planner.locator('#summer-lesson-modal .te-modal-meta')).toContainText(evil);
    expect(await planner.evaluate(() => window.__xss)).toBeUndefined();
  });

  test('P9: an event with no projects shows no roll-up', async () => {
    const ev = await makeEvent(planner);
    await saveCamp(planner, {
      eventId: ev.id, title: 'TEST Empty', timeSlot: 'AM', timeLabel: '9–12', location: 'Tinker',
      placements: [{ studio: 'AG', ageRange: '5–7', capacity: 8 }], teachers: ['TESTteacher1'],
      dates: ['2026-11-23'], projects: { '2026-11-23': { block1: '', openStudio: 'Open Studio' } }, notes: '',
    });
    await showYear(planner);
    await expect(planner.locator(`.sdoc-event-card[data-event-id="${ev.id}"]`)).toBeVisible();
    await expect(rollup(planner, ev)).toHaveCount(0);
  });

  test('P10: an older refresh that resolves last cannot undo a newer reload; the stamp is the newer one\'s', async () => {
    const { clay } = await makeThanksgiving();
    await showYear(planner);
    await planner.evaluate(() => {
      const real = window.loadDayOffCampData;
      let first = true;
      window.__release = null;
      window.loadDayOffCampData = async (opts) => {
        if (first) { first = false; await new Promise(r => { window.__release = r; }); }
        return real(opts);
      };
    });
    await planner.evaluate((Y) => { window.__firstRefresh = refreshDayOffYear(Y); }, Y);
    await planner.waitForFunction(() => typeof window.__release === 'function');
    await writePlan(prep, clay, 'Glaze Day', { closure: 'TEST newer', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eotherdevice0006' });
    const second = await planner.evaluate(async () => { const o = await reloadSummerForModeChange(); window.__secondStamp = +dayOffLastRefreshAt[getAdminSemKey()]; return o; });
    expect(second).toBe('ok');
    const first = await planner.evaluate(async () => { window.__release(); return await window.__firstRefresh; });
    expect(first).toBe('stale');
    await expect(planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-status')).toHaveText('In Progress');
    expect(await planner.evaluate(() => +dayOffLastRefreshAt[getAdminSemKey()] === window.__secondStamp)).toBe(true);
  });

  test('P11: one refresh on tab re-entry and one on switching the header to the SDOC year; ticking or redrawing triggers none; one in flight at a time', async () => {
    await makeThanksgiving();
    await showYear(planner);
    await planner.evaluate(() => {
      window.__refreshes = 0;
      const real = window.refreshDayOffYear;
      window.refreshDayOffYear = (...a) => { window.__refreshes++; return real(...a); };
    });
    await planner.evaluate(() => { switchTab('teacher-view'); switchTab('curriculum-admin'); });
    expect(await planner.evaluate(() => window.__refreshes)).toBe(1);
    await planner.evaluate((Y) => { setGlobalSemester('spring-2026'); setGlobalSemester(Y); }, Y);
    expect(await planner.evaluate(() => window.__refreshes)).toBe(2);
    await planner.evaluate(() => { renderAdminGrid(); renderAdminGrid(); });
    expect(await planner.evaluate(() => window.__refreshes)).toBe(2);
    // Shared in-flight promise: two calls while one runs start one reload.
    const reloads = await planner.evaluate(async (Y) => {
      await (dayOffRefreshInFlight || Promise.resolve());   // the header switch's refresh settles first
      let n = 0; const real = window.reloadSummerForModeChange;
      window.reloadSummerForModeChange = (...a) => { n++; return real(...a); };
      const a = refreshDayOffYear(Y); const b = refreshDayOffYear(Y);
      await Promise.all([a, b]);
      window.reloadSummerForModeChange = real;
      return { n, same: a === b };
    }, Y);
    expect(reloads).toEqual({ n: 1, same: true });
  });

  test('P12: opening a plan (a single-plan read) does not move "Last full refresh"', async () => {
    const { clay } = await makeThanksgiving();
    await showYear(planner);
    const before = await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y);
    await planRow(planner, clay, 'Glaze Day').locator('.sdoc-plan-open-btn').click();
    ...config,
    lastUpdated: new Date().toISOString(),
    lastUpdatedBy: user?.name || 'Unknown'
  };
  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
}

// ─── Lesson Data (curriculum/lessonData) ─────────────

// Every camp-season semester in the config, with the season each one reads.
// In legacy mode the 2026 season reads unfiltered (it is the only season that
// exists by definition) and any other camp season loads nothing at all —
// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
function dayOffYearKeys() {
  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
}

function campSeasonLoadPlan() {
  const semesters = currentConfig?.semesters || {};
  return Object.keys(semesters)
    .filter(isCampSeason)
    .map(semKey => {
      const season = seasonForSemester(semKey);
      if (seasonRegistryMode === 'legacy') {
        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
      }
      return { semKey, season };
    });
}

// One camp season's lessons, or an empty map when legacy mode cannot serve it.
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
      img.onerror = () => reject(new Error('Failed to load image'));
      img.src = e.target.result;
    };
    reader.onerror = () => reject(new Error('Failed to read file'));
    reader.readAsDataURL(file);
  });
}

// ─── Summer Camp Integration ─────────────────────────

// opts.isCurrent (optional): a predicate the listener passes so a reload that
// has been superseded by a newer snapshot does not commit its schedule read
// over the newer one (the lessons it returns are gated by the caller).
// season: a 4-digit string, or null for the legacy unfiltered read — which is
// allowed ONLY for 2026 while the registry says legacy, because in that state
// 2026 is by definition the only season that exists (Phase 1, 1.4).
async function loadSummerCampData(opts = {}) {
  const isCurrent = typeof opts.isCurrent === 'function' ? opts.isCurrent : () => true;
  const season = opts.season ?? null;
  if (season !== null && !/^\d{4}$/.test(String(season))) {
    throw new Error(`loadSummerCampData() needs a 4-digit season or null, got "${season}".`);
  }
  if (season === null && seasonRegistryMode !== 'legacy') {
    throw new Error('An unfiltered summer read is only allowed while the season registry says legacy.');
  }
  // One filter, applied identically to every collection below.
  const scoped = (name) => {
    const col = curriculumDb.collection(name);
    return season === null ? col : col.where('season', '==', season);
  };
  // The registry mode is a PRECONDITION here, not a hint (Phase 1, 1.3).
  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
  // re-hides the banner — so a mode set at startup would be wiped by the very
  // next load, since the summer collections' own rules are fine and only the
  // registry was denied. Checking it here is what keeps the app refused.
  if (seasonRegistryMode === 'error' || seasonRegistryMode === 'unknown') {
    throw new Error(`Refusing to read summer camp data: the season registry is ${seasonRegistryMode === 'unknown' ? 'unreachable' : 'unreadable or malformed'}.`);
  }
  if (!curriculumDb) initCurriculumFirestore();

  try {
    console.log('🌞 Loading Summer Camp curriculum data...');

    // 1. Fetch all camps from Summer Camp app
    const campsSnap = await scoped('summerCamps_curriculum').get();
    if (campsSnap.empty && season === null) {
      throw new Error('No camps found in summerCamps_curriculum collection');
    }

    // 2. Fetch schedule data to get max capacity for each camp
    const scheduleSnap = await scoped('summerCamps_schedule').get();
    const maxCapacityByCamp = {}; // campTopic → total max capacity
    const sessions = []; // becomes this semester's entry in currentSummerSessionsBySemester, only if this load is still current
    scheduleSnap.forEach(doc => {
      const session = { id: doc.id, ...doc.data() };
      sessions.push(session);
      const campTopic = session.campTopic || '';
      if (!campTopic) return;

      if (!maxCapacityByCamp[campTopic]) {
        maxCapacityByCamp[campTopic] = 0;
      }
      // Sum up max capacity across all sessions (different time slots) for this camp
      maxCapacityByCamp[campTopic] += (session.maxCapacity || 0);
    });
    console.log('📊 Max capacity by camp:', maxCapacityByCamp);

    // 3. Fetch all materials for lookup
    const materialsSnap = await scoped('summerCamps_materialsHub').get();
    const materialsByProject = {};
    materialsSnap.forEach(doc => {
      const mat = doc.data();
      const key = `${mat.campTopic}|||${mat.project}`;
      if (!materialsByProject[key]) materialsByProject[key] = [];
      materialsByProject[key].push({
        name: mat.name || '',
        qtyPerCamper: mat.qtyPerCamper || '',
        scope: mat.scope || '',
        sizeSpecs: mat.sizeSpecs || '',
        totalQtyNeed: mat.totalQtyNeed || '',
        prepCategory: mat.prepCategory || '',
        howToPrep: mat.howToPrep || '',
        wherePrepped: mat.wherePrepped || '',
        prepDone: mat.prepDone || false
      });
    });

    // 4. Fetch project details (Details, Inspiration, Notes)
    const projectDetailsSnap = await scoped('summerCamps_projectDetails').get();
    const projectDetailsByKey = {};
    console.log('📋 Project details count:', projectDetailsSnap.size);
    projectDetailsSnap.forEach(doc => {
      const detail = doc.data();
      const key = `${detail.campTopic}|||${detail.projectName}`; // FIX: Use projectName
      // Debug first document
      if (Object.keys(projectDetailsByKey).length === 0) {
        console.log('📋 Sample project detail fields:', Object.keys(detail));
        console.log('📋 Sample project detail:', detail);
      }
      projectDetailsByKey[key] = {
        details: detail.shortDetails || '',
        inspiration: detail.inspirationLinks || '',
        adminNotes: detail.notes || '',
        photos: detail.photos || []
      };
    });
    console.log('📋 Project details loaded:', Object.keys(projectDetailsByKey).length);

    // 5. Build lesson slots
    const lessons = {};
    const blockNames = ['Block 1', 'Block 2', 'Block 3', 'Open Studio'];
    const blockKeys = ['block1', 'block2', 'block3', 'openStudio'];
    const dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
    let slotCount = 0;

    campsSnap.forEach(campDoc => {
      const camp = campDoc.data();
      const campTopic = camp.campTopic || '';
      const teacherStr = camp.teacher || '';
      const sharedWith = Array.isArray(camp.sharedWith) ? camp.sharedWith : [];

      if (!campTopic || !teacherStr) return;

      // Parse teachers ("Kathy + Sonia" or "Mariah / Lisa" → ["Kathy", "Sonia"])
      const teachers = teacherStr.split('+').flatMap(t => t.split('/')).map(t => t.trim()).filter(t => t);

      // For each teacher
      teachers.forEach(teacher => {
        // For each block
        blockKeys.forEach((blockKey, blockIndex) => {
          const blockName = blockNames[blockIndex];
          const blockData = camp.blocks?.[blockKey];
          if (!blockData) return;

          // One lesson plan per unique project title in this block.
          // Collect all days each project appears on (for the overview grid).
          const projectDays = {}; // projectTitle → [dayName, ...]
          for (const dayKey of dayNames) {
            const projectTitle = blockData[dayKey] || '';
            if (!projectTitle) continue;
            const dayLabel = dayKey.charAt(0).toUpperCase() + dayKey.slice(1);
            if (!projectDays[projectTitle]) projectDays[projectTitle] = [];
            projectDays[projectTitle].push(dayLabel);
          }

          for (const [projectTitle, days] of Object.entries(projectDays)) {
            // Get materials and project details for this project
            const matKey = `${campTopic}|||${projectTitle}`;
            const materialsArray = materialsByProject[matKey] || [];
            const projectDetails = projectDetailsByKey[matKey];

            // Get max capacity for this camp (total across all sessions)
            const campMaxCapacity = maxCapacityByCamp[campTopic] || 0;

            // Key: teacher + camp + block + project (no weekNum — one plan per project)
            const lessonKey = `${teacher}|||${campTopic}|||${blockName}|||${projectTitle}`;

            lessons[lessonKey] = {
              teacher,
              campName: campTopic,
              campPublished: camp.publishedToClassbook === true,
              sharedWith,
              className: `${campTopic} - ${blockName}`,
              block: blockName,
              projectTitle,
              days, // All days this project appears in this block (for overview grid)
              dayName: days[0], // First day — kept for sort compatibility
              hasDetails: !!projectDetails,
              projectDetails: projectDetails?.details || '',
              projectInspiration: projectDetails?.inspiration || '',
              projectAdminNotes: projectDetails?.adminNotes || '',
              projectPhotos: projectDetails?.photos || [],
              introPitch: '',
              processStep1: '',
              processStep2: '',
              processStep3: '',
              processStep4: '',
              closure: '',
              materials: materialsArray.map(m => m.name).filter(n => n).join('\n'),
              materialsList: materialsArray,
              dayOfMaterials: '',
              qaThread: [],
              planComplete: false,
              classSize: String(campMaxCapacity),
              lastEditedBy: '',
              lastEditedAt: ''
            };

            slotCount++;
          }
        });
      });
    });

    // 6. Load saved lesson plans from summerCamps_lessonData
    try {
      console.log('📖 Loading saved Summer Camp lesson plans...');
      const savedLessonsSnap = await scoped('summerCamps_lessonData').get();
      let mergedCount = 0;
      let skippedForeignSeason = 0;

      savedLessonsSnap.forEach(doc => {
        const parsed = parseSummerDocId(doc.id);
        // Belt and braces behind the season filter: a document from another
        // season must never be merged into this season's scaffold, where an
        // identical teacher/camp/block/project would silently overwrite it.
        if (season !== null && parsed.season !== season) { skippedForeignSeason++; return; }
        const lessonKey = decodeFirestoreKey(parsed.legacyId);
        const savedData = doc.data();

        // Only merge if lesson key exists in generated lessons
        if (lessons[lessonKey]) {
          // Merge saved lesson plan fields (introPitch, processSteps, closure, dayOfMaterials, photo)
          lessons[lessonKey] = {
            ...lessons[lessonKey],
            introPitch: savedData.introPitch || lessons[lessonKey].introPitch,
            processStep1: savedData.processStep1 || lessons[lessonKey].processStep1,
            processStep2: savedData.processStep2 || lessons[lessonKey].processStep2,
            processStep3: savedData.processStep3 || lessons[lessonKey].processStep3,
            processStep4: savedData.processStep4 || lessons[lessonKey].processStep4,
            closure: savedData.closure || lessons[lessonKey].closure,
            dayOfMaterials: savedData.dayOfMaterials || lessons[lessonKey].dayOfMaterials,
            photoUrl: savedData.photoUrl || lessons[lessonKey].photoUrl || '',
            photoPath: savedData.photoPath || lessons[lessonKey].photoPath || '',
            planComplete: savedData.planComplete === true,
            lastEditedBy: savedData.lastEditedBy || '',
            lastEditedAt: savedData.lastEditedAt || ''
          };
          mergedCount++;
        }
      });

      console.log(`✅ Merged ${mergedCount} saved lesson plans`);

      if (skippedForeignSeason > 0) console.warn(`⚠️ Skipped ${skippedForeignSeason} summerCamps_lessonData document(s) stamped for another season.`);
    } catch (err) {
      console.warn('⚠️  Could not load saved Summer Camp lesson plans:', err);
      // Rethrow — lesson content would be blank, saves would wipe real teacher data
      throw err;
    }

    // 7. Commit the schedule read (unless superseded) and return lessons
    if (isCurrent() && opts.semKey) currentSummerSessionsBySemester[opts.semKey] = sessions;
    console.log(`✅ Loaded ${slotCount} lesson slots from Summer Camp`);
    return lessons;

  } catch (err) {
    console.error('❌ Failed to load Summer Camp data:', err);
    throw err; // Propagate so loadLessonData can set the failure flag
  }
}

// ─── Day Off Camps (School Day Off Camps, Phase 1) ───────────────────────────
// Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html
// A school year is a semester of type 'day-off-camps' in appData. Its events,
// camps and (from Phase 2) plans are one document each in three collections,
// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
// any summerCamps_* collection.
const DAY_OFF_COLLECTIONS = { events: 'dayOffCamps_events', camps: 'dayOffCamps_camps', plans: 'dayOffCamps_lessonData' };
// The same six names the Summer Camp App seeds into its season registry — a
// constant by Christie's choice (Sep 21): a camp uses whichever subset applies.

exec
/bin/zsh -lc 'rg -n "''^(##|###)|MEDIUM|HIGH|no-listener|multi-year|partial|offline|stamp|side-map|side map" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-codex-full.md | head -100 && git show c7400df:js/firebase-data.js | sed -n '"'1328,1380p' && git diff --check c7400df HEAD" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
33:2. refreshDayOffYear(): the in-flight promise, its finally/done handling, 'no-listener', the second redraw, and the
35:3. The stamp/failure flags: set in every success/failure path and only there? A camp-season failure marks SDOC years
37:4. The transactional open read: correct in the compat SDK, offline behaviour, any test that counted runTransaction calls.
40:Rank HIGH / MEDIUM / LOW with file:line. End with: ready to merge — yes/no. ≤500 words.
51:## claude/sdoc-phase3-overview...origin/claude/sdoc-phase3-overview
73:  <p><strong>Re-verification against <code>132fef2</code> (Sep 30, after the storage move landed — PR #5).</strong> The design's line numbers above are pinned to <code>2ef2e62</code>; at build time use this map (<code>132fef2</code>): Teacher View's listener callback app.js:686-711 (SDOC branch 692-696; its load-guard exit 678-681); Curriculum Admin's callback 5114-5120; <code>initCurriculumAdmin()</code> 5091 (<code>caInitialized</code> 5092-5093), awaited at startup app.js:190, tab branch 220-221; <code>calculateLessonProgress()</code> 924, <code>getProgressLabel()</code> 943, <code>canEditDayOffPlan()</code> 622; <code>openPlanEditor()</code> 11639 (<code>canEdit</code> 11648), <code>finishClose</code> 12313; <code>renderDayOffAdmin()</code> 12647; firebase-data.js: <code>reloadSummerForModeChange()</code> 1310, unsubscribe 1319, gated failure path: catch 1351-1364 (<code>isCurrent()</code> 1353, retries 1356-1362, <code>return 'failed'</code> 1363), <code>summerReloadHook</code> 1369, the <code>lessonData</code> snapshot reload 1376-1416, <code>isIsoDate()</code> 2264, <code>dayOffCampTitles()</code> 2322, <code>dayOffServerDocs()</code> 2377, <code>loadDayOffCampData()</code> 2384. None of these functions' bodies changed except <code>setGlobalSemester()</code> and startup (one <code>updateOwnDocPausedNotice()</code> line each) and <code>renderDayOffAdmin()</code>, whose camp/event buttons now use <code>escForOnclick()</code> (PR #3) — harmless for Phase 3 (round 6, Claude LOW). <strong>What did change, and how Phase 3 meets it:</strong> (1) <em>Spring's own-document listeners</em> (firebase-data.js:1420-1457) and <code>recheckOwnDocAfterLegacyLoss()</code> now also call the listener's <code>callback</code> — without a summer/SDOC reload. With the shared <code>onLessonDataReload()</code> they simply redraw each initialised view, as they do today for the owning view; they install no SDOC data, so the stamp and <code>dayOffRefreshFailed</code> don't move (both change only in the gated reload). Re-registering tears the own-doc listeners down and re-adds them (1321) — unchanged by Phase 3, since it keeps the two registration sites. (2) <em>A <code>get({source:'server'})</code> can return stale data after a Listen-stream transport error</em> (found in the storage move's Phase C, Sep 30). Phase 3's SDOC queries can't use a transaction (queries aren't transactional in this SDK), so the overview accepts it as a <strong>known limitation</strong>: in that rare case the list can show older statuses under a fresh "Last full refresh" time until the next refresh or reload corrects it. For the overview itself it is display-only (Phase 3 writes nothing). <strong>Correction (round 6, both MEDIUM): the 2B editor is NOT covered.</strong> Its open read, <code>readDayOffPlanForEditor()</code> (firebase-data.js:2891-2897), is the same <code>get({source:'server'})</code> and marks the copy verified (<code>dayOffInstallVerified()</code>); the save transaction (2940-2965) re-reads the plan but never compares it with the opened version and writes with <code>merge: true</code>, and <code>verifyDayOffPlanWrite()</code> only confirms its own <code>lastEditId</code>. So a stale open lets a teacher save over a co-teacher's newer text with a plain "Saved" — the "edited since" notice can't fire. This is a <em>live 2B gap</em>, not new in Phase 3, but Phase 3's Open plan is one more way into that editor. <strong>Fix — in the Phase 3 build (Christie, Sep 30: "#1"):</strong> open the plan with a read-only <code>runTransaction(tx =&gt; tx.get(planRef))</code> — single-document transactional reads are always fresh, the storage move's own lesson — with no change to the save path. And <code>source: 'server'</code> still delivers what Christie approved it for (a failed read trips the guard instead of showing a cached or empty year as editable). (3) <code>escForOnclick()</code> now exists (PR #3, app.js:8283); Phase 3 still puts the plan key in a <code>data-</code> attribute and binds the handler in code, so no inline handler value is added.</p>
77:    <li>In Curriculum Admin for an SDOC year, each camp row gains a <strong>Plans</strong> column listing each of its projects (the <code>dayOffCampTitles()</code> order — unused and no-plan blocks excluded): title, a status pill from the same <code>calculateLessonProgress()</code> (app.js:914) + <code>getProgressLabel()</code> the teachers' list uses, so both views always agree — <em>Not started</em> / <em>In progress</em> / <em>Complete</em> (its fourth value, <code>'ready'</code> → "Almost Done", is unreachable for SDOC because a slot's <code>campName</code> zeroes <code>hasMaterials</code>, app.js:922-924; rendered as In progress if it ever appears) — and "last edited by <em>name</em>, <em>Oct 5</em>" when the plan has an edit stamp (the date is <code>lastEditedAt.slice(0, 10)</code>, shown only if <code>isIsoDate()</code> (firebase-data.js:2000) accepts it, through <code>formatDayOffDate(…, { month: 'short', day: 'numeric' })</code> — which returns unparseable input unchanged, hence the check), plus an <strong>Open plan</strong> button.
84:  <p><strong>Refresh — through the existing gated reload (round 1, both HIGH).</strong> No new loader: <code>refreshDayOffYear()</code> calls <code>reloadSummerForModeChange()</code> (firebase-data.js:1107) → <code>summerReloadHook()</code>, the listener's own generation-gated reload (Curriculum Admin sets that listener up, app.js:5037). So a refresh and a snapshot-triggered reload are the <em>same</em> mechanism: only the newest generation installs and redraws (an older one resolving last returns <code>'stale'</code>, firebase-data.js:1125), <code>previous</code> is captured by <code>snapshotCampSeasons()</code> for <code>mergeSummerReload()</code>, and 2B's heal runs. If no listener exists yet (<code>'no-listener'</code>), <code>initCurriculumAdmin()</code> hasn't run and its own first load covers it. <strong>The refresh redraws the list itself (round 2, both):</strong> there is one global listener, and whichever of <code>initTeacherView()</code> (app.js:676) / <code>initCurriculumAdmin()</code> (app.js:5038) ran last owns its callback — after a visit to Teacher View it is Teacher View's, whose SDOC branch renders only Teacher View — so <code>refreshDayOffYear()</code> awaits the outcome and calls <code>renderAdminGrid()</code> itself for any outcome but <code>'stale'</code> (including <code>'failed'</code>, so the message shows). A single in-flight refresh promise is shared: the two automatic call sites and the button never start a second one while one runs. <strong>Server-fresh:</strong> <code>loadDayOffCampData()</code>'s three queries switch to <code>get({ source: 'server' })</code> (like <code>dayOffServerDocs</code>, firebase-data.js:2114). <em>This changes every SDOC load, including startup's <code>loadLessonData()</code> (firebase-data.js:775-776) that teachers hit (round 2, Claude):</em> today an offline start can fall back to the cache and show an empty or old SDOC year with editing enabled — the "data disappeared" shape; with the change it trips the app-wide load guard and banner instead (the same as any failed load). Safer, but a visible behaviour change for anyone opening the app offline — <strong>Christie's yes is asked with the go.</strong> <strong>The stamp:</strong> <code>dayOffLastRefreshAt[yearKey]</code> is set wherever a full SDOC-year load <em>installs</em> successfully — startup's <code>loadLessonData()</code> and the gated <code>reloadSummer</code> success path — so the header is never blank after a good load, listener reloads (also full reads) advance it truthfully, and an editor's single-plan read, a stale reload and a failed one never do.</p>
85:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
87:  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw. <em>Build notes (round 5, Claude LOW):</em> wrap each branch of <code>onLessonDataReload()</code> in its own try/catch (log and continue) so a throw in Teacher View's redraw can't skip the admin redraw; <code>tvInitialized</code> is also true during Teacher View's own <code>await loadLessonData()</code> (app.js:657→661) — harmless, it converges through the existing empty-picker reset (app.js:690-696).</p>
128:Then: the newer reload's data stays (the older returns 'stale'); the stamp is the newer reload's time
132:Then: the previous figures stay, "Couldn't refresh" shows, the stamp does not move, the load guard is false and Open plan opens read-only; after a successful refresh the guard clears and editing works
148:Then: the row's status and "last edited by Mariah" update AND the stamp moves (the refresh redraws the list itself)
150:Given: the app starts offline (the SDOC queries fail)
156:Then: "Couldn't refresh" is gone, the rows and the stamp are fresh, the load guard is true, and Open plan opens editable
160:Then: without pressing Refresh, the SDOC list redraws and its stamp moves; the weekly grid shows the other device's change
200:  <li><strong>Sep 30, 2026 (Phase 3 review round 6 — CHANGES NEEDED from both, one MEDIUM, same finding):</strong> the line map checks out (Claude: 35 anchors), the shared callback is clean with Spring's own-doc listeners, and the "queries can't be transactional" claim is correct (Firebase 10.8.0 compat). But my "the 2B editor keeps its own checks" was wrong: <code>readDayOffPlanForEditor()</code> uses the same possibly-stale <code>get({source:'server'})</code>, and the save never compares with the opened version, so a stale open can silently overwrite a co-teacher's newer text. Live 2B gap, widened slightly by Phase 3's new entry point. Text corrected; LOWs folded (<code>renderDayOffAdmin()</code> carve-out, catch line numbers). <strong>Open for Christie:</strong> fold the transactional open read into the Phase 3 build (recommended), or record it as a 2B limitation for the concurrency plan.</li>
201:  <li><strong>Sep 30, 2026 (storage move landed — Phase 3 re-verified against <code>132fef2</code>):</strong> PR #5 (Spring 2026 in its own document) merged. Every Phase 3 reference re-located (map in the "Re-verification" paragraph); no referenced body changed. Two interactions recorded: Spring's own-doc listeners also call the shared callback (redraw only — no stamp or refresh-failure change), and the storage session's finding that <code>get({source:'server'})</code> can be stale after a Listen transport error — accepted as a display-only known limitation (no Phase 3 writes). Next: a short targeted review of the re-verification, then build (red tests first).</li>
202:  <li><strong>Sep 29, 2026 (Christie's GO on Phase 3):</strong> "yes to both" — (1) the design as written (revision 5), and (2) <code>source: 'server'</code> for all SDOC loads, accepting that an offline start shows the load banner + retry instead of a cached/empty SDOC year. Phase 3 is execution-ready as a design; <strong>the build starts only after <code>classbook-per-semester-lesson-storage</code> has landed</strong> — first step then: re-verify every line reference and the listener/reload shape against the new code (a short targeted review if it moved materially), then red emulator tests → build → dual implementation review → "okay to deploy".</li>
203:  <li><strong>Sep 29, 2026 (Phase 3 review round 5 — READY from both, design COMPLETE):</strong> Codex and Claude both confirmed the shared <code>onLessonDataReload()</code> fixes the startup race, that each branch is behaviour its view's own callback already has (Teacher View's single tab check is kept inside its helper; Curriculum Admin already redraws unconditionally), that the <code>tvInitialized</code> / <code>caInitialized</code> gates are right (the early admin draw before its awaits is safe — nothing it renders reads the change log, cut or future projects), and that <code>dayOffRefreshFailed</code> behind <code>isCurrent()</code> covers button, retry and snapshot failures. No new HIGH/MEDIUM. Two build-time LOWs recorded in the "Redraw on every install" paragraph. Reviews: <code>thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round5-{codex-full,claude}.md</code>. <strong>Next: Christie's go on the design, including her yes to <code>source: 'server'</code> for all SDOC loads.</strong> The build then waits for <code>classbook-per-semester-lesson-storage</code> to land; re-verify line references against it first.</li>
204:  <li><strong>Sep 29, 2026 (Phase 3 review round 4 → revision 5):</strong> Claude READY (2 LOW); Codex CHANGES NEEDED (1 MEDIUM). Both found the same thing: revision 4's claim that the reverse redraw was unneeded was <strong>wrong</strong> — a startup race (a Teacher View click while <code>initCurriculumAdmin()</code> awaits its loads) lets Curriculum Admin register last, so Teacher View stops redrawing (pre-existing; Claude rated it LOW for Phase 3, Codex MEDIUM). Verified at app.js:182-188 and 5015-5038. <strong>Folded:</strong> both inits now register one shared <code>onLessonDataReload()</code> that runs each <em>initialised</em> view's existing redraw — ownership no longer matters, no new behaviour; <code>dayOffRefreshFailed</code> is set inside the gated reload's failure path (Claude LOW). BDD +1 (the startup race). Next: round 5 (short), then Christie's go incl. <code>source: 'server'</code>. Build still waits for the storage migration.</li>
205:  <li><strong>Sep 29, 2026 (Phase 3 round-3 MEDIUM folded — revision 4; its "reverse not needed" claim was corrected in revision 5):</strong> Teacher View's listener callback now also calls <code>renderAdminGrid()</code> + <code>renderHelpQueue()</code> when Curriculum Admin is the active tab (before its SDOC early return), so the automatic retries and snapshot reloads redraw Curriculum Admin after a Teacher View visit — which also closes a pre-existing gap for the weekly grid. The "Couldn't refresh" message is derived at render time (<code>dayOffRefreshFailed[yearKey]</code>, cleared where the stamp is set). The "vice versa" from round 3 was dropped after checking the code: Curriculum Admin's callback can own the listener only while Teacher View has never finished initialising (its guard exit resets <code>tvInitialized</code>), so there is nothing to redraw. BDD +2. <strong>Christie, Sep 29: finish the design now, but build only after <code>classbook-per-semester-lesson-storage</code> lands</strong> (it reworks the same listener) — re-verify line references then. Next: round 4 (short, targeted), then Christie's go incl. her yes to <code>source: 'server'</code>.</li>
206:  <li><strong>Sep 29, 2026 (Phase 3 review round 3 — PAUSED here, Christie moving locations):</strong> both confirmed every round-2 fix; both found ONE remaining MEDIUM, not yet folded: two other install paths also redraw through the single global listener's callback, which after a Teacher View visit belongs to Teacher View — (1) the failed reload's automatic retries (firebase-data.js:1151-1157) and (2) a snapshot-triggered reload (firebase-data.js:1190-1194) — so on Curriculum Admin the rows, stamp, "Couldn't refresh" message and editability can go stale after recovery. <strong>Agreed fix to fold next:</strong> make every listener callback redraw whichever tab is active (Teacher View's callback also calls <code>renderAdminGrid()</code> when Curriculum Admin is active, and vice versa), and add a BDD: visit Teacher View → back to Curriculum Admin → refresh fails → automatic retry succeeds → message gone, rows + stamp fresh, editing re-enabled. Then a short round 4, then Christie's go (which must also include her yes to <code>source: 'server'</code> for all SDOC loads — see the Refresh paragraph). No code written for Phase 3 yet; Classbook <code>main</code> is clean at <code>2ef2e62</code>.</li>
207:  <li><strong>Sep 29, 2026 (Phase 3 review round 2 — both confirmed every round-1 fix; folded, revision 3):</strong> HIGH (both): the single global listener's callback belongs to whichever view initialised last, so after a Teacher View visit a refresh would install fresh data without redrawing the admin list while the stamp advanced → <code>refreshDayOffYear()</code> redraws the list itself on any non-stale outcome; one shared in-flight refresh. MEDIUM (Claude): <code>source: 'server'</code> also changes startup for teachers (offline → guard + banner instead of a cached/empty year) — stated, Christie's yes asked with the go; the editor's guard is scoped to SDOC (summer untouched). LOW: the stamp is set on startup's load too; <code>isIsoDate</code> before formatting. BDD +2. Next: round 3 (targeted).</li>
208:  <li><strong>Sep 29, 2026 (Phase 3 review round 1 — Codex + Claude, both CHANGES NEEDED; folded, revision 2):</strong> HIGH (both): an independent refresh would be ungated — an older one resolving last could revert a newer reload and stamp it "now" → refresh goes through the listener's own generation-gated reload (<code>reloadSummerForModeChange</code>); SDOC loads become <code>source: 'server'</code>; the stamp ("Last full refresh") advances only when a gated reload installs. HIGH/MEDIUM: a failed refresh trips the existing guard (banner + retry), keeps prior figures, and the editor opens read-only while guarded. MEDIUM: the two automatic call sites are named (tab re-entry, header switch to SDOC on Curriculum Admin); <code>lastEditedAt</code> is sliced before formatting; plans are counted per (camp, title). LOW: pill labels via <code>getProgressLabel</code> ('ready' unreachable); the no-apostrophe-in-onclick reason recorded. BDD +6. Next: round 2.</li>
213:  <li><strong>Sep 28, 2026 (Phase 2C review round 4, Claude targeted):</strong> both round-3 fixes confirmed; one new MEDIUM folded (revision 5): <code>openDayOffMaterials()</code> gets a view token so a superseded open's read is dropped instead of rendering (and, with Details, saving) project A under project B — also closes the same pre-existing 2A gap for the materials rows. BDD added. Next: round 5 (Claude, targeted).</li>
216:  <li><strong>Sep 28, 2026 (Phase 2C review round 1 — Codex + Claude, both CHANGES NEEDED; all verified and folded, revision 2):</strong> Claude HIGH: <code>linkifyText()</code> does not escape quotes, so a stored URL could break out of <code>href</code> → the vision is rendered escaped with line breaks and no auto-linking; links via <code>new URL()</code> + attribute-escaped href; the same pre-existing hole in summer's reference fields is flagged as its own task. Codex HIGH: "planner-owned" is not rules-enforced → stated as UI-level (the 2A <code>materialItems</code> gap), writer takes an explicit <code>auth</code> argument; rules field-pin stays a follow-up. MEDIUMs (both): one merge-set write shape with delete sentinels, no-op when absent and empty; stale-editor guard (links written whole); explicit read-back comparison; "About this project" as its own block in the SDOC branch; a separate details draft + close-confirm; the n/a change made at the <code>isDayOffNoPlanTitle</code> wrapper with each site named (validator keeps the broad rule; Teacher View takes the unused helper; admin list/editor grid show text as typed); re-check live data at build time. BDD extended: every spelling + duplicates, real→n/a prompted removal, concurrent planners, links-only creation and protection, limits, the quote payload, the teacher allow-list refusal, drafts across failures. Next: round 2.</li>
222:  <li><strong>Sep 25, 2026 (plan review round 6 — 2B only):</strong> Claude <strong>READY</strong> (two LOW wording notes, folded: the id is generated once before <code>runTransaction</code>; "no read-back message" for the no-op). Codex CHANGES NEEDED, one MEDIUM, verified against the code and folded: a reload whose query predates a teacher's save can re-install the pre-save text on screen, because the reload captures its previous map at start and SDOC installs replace maps wholesale → a clock-free install sequence (<code>dayOffInstallSeq</code>) makes the reload keep any plan verified after it started; BDD with a genuinely stale query added. Both confirmed the round-5 fixes and the rejection of round-5 L-3. Round 7 (Codex, targeted): the sequence covers both reload paths, the generation gate and 2A tick installs, but <code>mergeSummerReload()</code>'s clock-based <code>keepMine</code> ran after it and could still copy old text back → protected keys bypass it (folded; BDD with a skewed clock). Round 8 (Codex, targeted): <strong>READY</strong>. With Claude READY in round 6, <strong>Phase 2B design reviews are CLEAN</strong> — awaiting Christie's go.</li>
224:  <li><strong>Sep 25, 2026 (plan review round 4 — 2B only, Codex + Claude):</strong> both confirmed every round-3 fix, and cleared the three named risks (2A writers never touch <code>lastEditedBy/At</code>; the ISO string survives the JSON round-trip). New, folded in: a unique <code>lastEditId</code> per save decides ownership (a name + millisecond can repeat — Codex MEDIUM); no-op saves return before the verifier (Claude M1); <code>written</code> is post-strip/post-translation, a removed photo pair counts as cleared (M2); the editor's clock-based post-save re-install is skipped for SDOC (M3); own-name wording for a second window (LOW). Three BDD cases added. Next: round 5 (confirmation).</li>
225:  <li><strong>Sep 25, 2026 (plan review round 3 — Codex + Claude):</strong> <strong>Phase 2A.1: READY from both</strong> (Codex READY since round 2) — awaiting Christie's go. Phase 2B: both confirmed every round-2 fix; both found the same HIGH/MEDIUM — the read-back kept <em>cleared</em> fields strict, so "A clears closure, B then writes it" re-created the false failure round 2 removed, and "newer lastEditedAt" leaned on client clocks → the verifier now compares by <strong>edit stamp</strong>: own stamp ⇒ strict; different stamp ⇒ any content/photo/planComplete difference is the later save winning ("edited since" message). Claude MEDIUMs: rename paths now schedule the SDOC reload so "reopen the camp" shows the new title; the SDOC branch sits after the stamping lines so narrow Plan complete writes carry a stamp. LOWs: the save-call row (<code>dayOffAuth</code> at save time); a stale <code>teacherMappings</code> name outside the pool falls through to matching. Five BDD cases added. Reviews: <code>…-round3-{codex,claude,claude-full}.md</code>. Next: round 4 (2B only).</li>
226:  <li><strong>Sep 25, 2026 (plan review round 2 — confirmation, Codex + Claude):</strong> both confirmed every round-1 fix correct against 2894adf; Codex: 2A.1 READY, 2B CHANGES NEEDED; Claude: both CHANGES NEEDED. New findings, all folded in: (HIGH, Claude) a strict equality read-back would report a co-teacher's later save as a failed save and invite a clobbering re-save → identity/clears strict, content accepts a newer server <code>lastEditedAt</code> with a "Lisa has edited this since" message; (HIGH, Codex / MEDIUM, Claude) the branch's inputs had no source (<code>ref</code> undefined) → slot lookup + optional <code>opts</code> fifth parameter; photo removal was empty strings, not clears → the pair is translated to deletes; the in-transaction check must not reach app.js through a <code>typeof</code> guard → the caller passes <code>dayOffAuth</code>, missing throws; the teacher arm must require the <code>classbook</code> key; first-name fallback only when unique; 2A.1 must refresh each camp's sign-off on open; teacher autosaves must not schedule the three-query SDOC reload. LOWs: <code>markDayOffCampComplete</code> signature keeps its <code>onclick</code> callers; the Print listener binding must become conditional; the "SDOC editor sends no summer identity fields" sentence made explicit. Six BDD cases added. Reviews: <code>thoughts/reviews/2026-09-25-plan-review-sdoc-2a1-2b-round2-{codex,claude}.md</code>. Next: round 3 (confirmation).</li>
227:  <li><strong>Sep 25, 2026 (plan review round 1 — 2A.1 + 2B, Codex + Claude; both CHANGES NEEDED; every finding verified against 2894adf and folded in):</strong> Claude HIGH: widening <code>lessonStoreFor()</code> would turn six callers' "throw" into a weekly write to <code>curriculum/lessonData</code> → the SDOC save now branches in <code>saveSingleLesson()</code> <em>before</em> <code>lessonStoreFor()</code>, which keeps throwing. Claude HIGH: the shared name resolver matches joined "A + B" strings, so the live two-teacher camps would have been view-only for both teachers → a separate SDOC resolver + a no-mapping second-teacher BDD. Codex HIGH ×3: <code>fieldsToClear</code> was outside the allow-list (could delete <code>materialItems</code>/identity) → writable + clearable sets, anything else throws (Claude had it MEDIUM); no re-check that the saver is still on the camp → re-checked on the fresh camp inside the transaction; the summer read-back verifies only non-empty content → <code>verifyDayOffPlanWrite()</code> checks every written/cleared field and returns the document installed. MEDIUMs folded: key parsing without <code>split('|||')</code> + <code>camp.yearKey</code>; <code>initTeacherView()</code> listener binding + <code>tvInitialized</code>; the Teacher View listener's SDOC branch; the editor table (read marks, reference section, Print hidden, <code>finishClose</code> without the old parameters, no backdrop close); Plan complete disabled without rights + every checkbox sharing a key; summer regression tests before the split; 2A.1 view token + <code>allSettled</code> + explicit <code>{yearKey, campId}</code> + <code>pendingDayOffTicks</code> re-keyed at both sites + sign-off re-sync. LOWs: photo path via <code>dayOffPlanDocId()</code>; the rename-before-read-back message; the model's stale materialsList/kept-fields note; the "camp read is the lock" argument recorded. BDD added: second teacher w/o mapping, removed teacher, clear allow-list + normal clear, sign-off byte-identical, save during a pending reload, <code>curriculum/lessonData</code> untouched, no camp write from 2A.1. Both confirmed: transactions sound, publish blockers fully inventoried (three consumers), permissions consistent with the rules, XSS handled. Reviews: <code>thoughts/reviews/2026-09-25-plan-review-sdoc-2a1-2b-{codex,claude-full}.md</code>. Next: round 2 (confirmation).</li>
228:  <li><strong>Sep 25, 2026 (Phase 2A.1 + Phase 2B designed, revision 1 — NOT yet reviewed):</strong> Christie, before the design: "we can skip the help queue entirely for SDOCs. we just chat with teachers, no need for the ask a question flow" → no SDOC Q&amp;A in any phase (Phase 3's Q&amp;A dropped; the Q&amp;A/help writers keep refusing SDOC keys); an unfilled block shows the teacher "project not assigned yet". Mid-design she asked for "a pop up that shows all materials for all projects in that SDOC event container … grouped by project" → Phase 2A.1 (UI only over 2A's reviewed writers, grouped camp → project because the camp is the sign-off unit and a title can run in two camps), sequenced before 2B. Research (read-only inventory @ 2894adf) corrected the model's assumption: the type switch is <code>lessonStoreFor()</code>, not inside <code>saveSingleLesson()</code>, and it has seven callers; <code>seasonForSemester()</code> throws for SDOC keys (so the summer save/photo/unread/camp-complete paths cannot be reused as-is); SDOC slots carry a joined <code>teacher</code> string, so every <code>l.teacher === name</code> site needs the <code>teachers</code> array. Design choices: plan saves in a transaction that re-checks the camp still has the title (closes the rename race), payload allow-list + identity stamped from the camp, forced read on editor open, <code>openLessonModal()</code> split into a summer lookup + shared <code>openPlanEditor()</code>, edit rights for planners + Kathy/Allie (via <code>canTickDayOffMaterials()</code>) + the camp's teachers — Christie chose edit for Kathy/Allie "to match the other semester/camps" (the first draft had them read-only), no rules change, Phase 4 marked superseded. Wipe monitor: SDOC is <em>not</em> added to <code>computeLiveContentCountByTeacher()</code> (backup.js Tier-1 per-collection tripwire covers it). Christie, later Sep 25: Kathy and Allie <strong>can edit</strong> SDOC plans "to match the other semester/camps". Next: Codex + Claude review of 2A.1 and 2B.</li>
231:  <li><strong>Sep 24, 2026 (later — Christie, entering the first real camp): MODEL CHANGE to a camp's projects.</strong> "There should be 2 project blocks and 1 Open Studio block per day, like our summer camps … we don't have them all yet, but I want to create the camp container … a note that says how many blocks still need to be filled in." So <code>camp.projects[date]</code> is now <code>{ block1, block2, openStudio }</code> (replacing "1–3 titles per day"): an empty block is absent and counts as "to fill in"; "—" marks a block deliberately unused (no plan, counted as filled); projects are no longer required to save a camp (a real title repeated within a day is still refused). The camp editor's projects section is the Summer Camp App's Build Curriculum grid (days as columns, Block 1 / Block 2 / Open Studio as rows, Open Studio pre-filled) with a live "N of M project blocks still to fill in"; the list shows "to fill" per block and a per-camp count. Slots/plans stay keyed by title (so Phase 2's plan model is unchanged); the slot's display block is "Block 1"/"Block 2". The first-deploy array shape is still read everywhere (<code>normaliseDayOffDayBlocks()</code>) and normalised before dirty-diffing (Codex MEDIUM, fixed). Also from her use: both SDOC editors no longer close on a backdrop click (<code>data-sticky</code>), and × / Cancel ask before discarding typed work; Settings' Teacher Names now says "first name only, spelled exactly as in other semesters". And a pre-existing Settings hazard she surfaced: the form only redrew on a semester change made while on Settings, and Save writes to the header's semester — fixed (form tracks its semester, redraws on mismatch from the tab or footer link, Save refuses a mismatch). Commits <code>b2e9078</code>, <code>91bcdf9</code> (deployed), <code>3167d8d</code>, <code>c655b68</code>, <code>967bf17</code>; suite 259/259.</li>
232:  <li><strong>Sep 24, 2026 (Phase 1 BUILT — rules live, app on branch <code>sdoc-phase1</code>, NOT yet deployed to Netlify):</strong> Prerequisite confirmed: the seasons plan's Phase 1 shipped Sep 24 (<code>b2bbaac</code>, stamped 14:45Z) — nothing carried. <strong>1.1:</strong> <code>~/tinker-backups/backup.js</code> lists the three collections in both <code>COLLECTIONS</code> and <code>TIER1_COLLECTIONS</code> (verified by parsing both arrays); rules commit <code>da87ce3</code> (red first: 13 failing) + <code>97f7915</code> (Fable 5.1 review CLEAN, its two LOW test gaps closed: a curriculum-admin-only fixture and an archived classbook fixture now pin the exclusions) — 300/300 rules, 141/141 guard — deployed through the studio-hub guard on Christie's "approved to change firebase 97f79155…", receipt <code>20260924T150725Z-97f7915</code>. The raw CLI deploy wording in 1.1 is superseded by the guard. <strong>1.2–1.5</strong> implemented as designed (<code>a1b8b86</code>). <strong>1.6</strong> deviations, logged: (a) the e2e suite is emulator-only since Sep 21 (the plan said "production, TEST-scoped"); (b) SDOC specs run as the seeded MANAGER (global-setup now saves a manager session) because the suite's curriculum-admin staff account is denied SDOC writes by design; (c) the TEST purge runs in the manager's page, not <code>e2e/helpers/firestore.js</code>, for the same reason — it still refuses any non-TEST yearKey before a query; (d) the app tests were written alongside the implementation, not strictly red-first (the rules were red-first; the stamp-fix regression test was proven red on the old code). <strong>Dual implementation review</strong> (Codex + Claude) of <code>a1b8b86</code>: 2 HIGH (typed <code>materials</code> text not counted as user data — the model's own <code>dayOffPlanHasUserData()</code> definition above missed that field; Settings' teacher-in-use guard blind to the × button), stale-editor guard bypasses (event dates, camp rename, teacher pool — now judged against forced-server reads), and pre-existing header-selector issues (remembered invisible semester; unescaped names) — all fixed in <code>9dc2a18</code> with tests SDOC R1–R5; suite 250/250. <strong>Declined</strong> (Codex MEDIUM): <code>updateAppData()</code> does not consult the lesson-load guard — pre-existing for every settings/publish write; those writes are not built from lesson data, and the SDOC Settings guards read the server directly. <strong>Also in this branch:</strong> the seasons migration's read-back now compares key-order-insensitively (its Sep 24 production run reported four false "changed unexpectedly"). <strong>Open for Phase 2</strong> (moot in Phase 1 — only manager+ can open an unpublished year): Kathy and Allie hold only the legacy <code>curriculum-admin</code> key (nobody holds <code>classbook-admin</code>), so once the year is published they would see Curriculum Admin for it but be denied event/camp writes by rule — decide then: grant them <code>classbook-admin</code>, or hide SDOC editing from curriculum-admin-only users. Next: confirmation review round → Christie's "okay to deploy" → Netlify → Christie creates the real year + one event → Console spot-check.</li>
235:  <li><strong>Sep 21, 2026 (plan review round 4 — the post-round-3 edits only, Codex + Claude): CLEAN after two text fixes.</strong> Both reviewers found the same leftover: the safety table and Resume step (4) still said the rules commit carries <code>backup.js</code> (it cannot — not a git repo) — fixed to the pre-deploy step. Also: the model's Plan row now hedges which phase adds the existence check's SDOC branch (per the Phase 2 Q&amp;A sequencing decision); <code>COLLECTIONS</code> cited as <code>:44-86</code>. The teacher-list builders, the Q&amp;A sequencing claim and the historical <code>saveConfig</code> mentions were confirmed. No new HIGH/MEDIUM. Nothing in this document is unreviewed.</li>
236:  <li><strong>Sep 21, 2026 (plan review round 3 — final confirmation, Codex + Claude): CLEAN for Phase 1.</strong> Every round-2 item confirmed against the code by both reviewers; no new HIGH/MEDIUM design findings (Claude checked and rejected the camp-delete check-to-batch race, the any-teacher plan write rule and the extra per-snapshot queries as recorded trade-offs). Folded in: (1) <code>~/tinker-backups</code> is not a git repository, so the <code>backup.js</code> edit cannot ride in the rules commit — it is now an explicit, grep-verified pre-deploy step recorded in the rules commit message (Codex MEDIUM; the script's lack of version control is noted as a standing gap); (2) the Phase 2 draft now states the SDOC Q&amp;A sequencing question — the teacher-side question path is the weekly writer, so Phase 2 owns both that branch and the existence check's, or defers all SDOC Q&amp;A to Phase 3 (Claude); (3) the model names both teacher-list builders (<code>app.js:611</code> inline and <code>populateTvTeacherList()</code> <code>:732</code>) for Phase 2; (4) process note: studio-hub's working tree already carries another session's uncommitted rules edits — commit or stash them before cutting the SDOC rules commit so the Fable review sees only the three blocks. Codex flagged the two remaining <code>saveConfig</code> mentions as stale; both are explanatory ("deleted by that plan", "the stub moves") and stay. <strong>Ready for Christie's go-ahead.</strong></li>
237:  <li><strong>Sep 21, 2026 (plan review round 2 — confirmation, Codex + Claude):</strong> every round-1 fix confirmed present and correct; no design defects found. Folded in: (1) explicit clears — an emptied optional string (<code>district</code>, <code>notes</code>) gets <code>FieldValue.delete()</code> after sanitisation rather than being silently omitted (Codex MEDIUM; the <code>buildLessonFieldUpdates()</code> pattern); (2) Settings refuses to narrow the school-year bounds past an existing event's date (Codex MEDIUM — the model's invariant now holds on both sides); (3) the nested-field whole-write sentence moved from the event writer to the camp writer where those fields live; (4) the Phase 2 flag that <code>mergeSummerReload()</code>'s kept-fields list must include <code>materialsList</code> for SDOC slots (user-edited, no hub — Claude); (5) stale text: the safety table and a test bullet still named the deleted <code>saveConfig()</code>, the meta/readiness lines said four dependencies (five), the <code>backup.js</code> check covered one array (both), the BDD said "four writers" (the seasons plan's switch set is now seven sites incl. the admin reply writers and the existence check — a BDD scenario added here too); (6) rules citations re-pinned to studio-hub <code>706a8b2</code> (moved twice today under parallel sessions) with block names as the stable reference. Next: round 3 (final confirmation), then Christie's go-ahead.</li>
238:  <li><strong>Sep 21, 2026 (plan review round 1 — Codex + Claude, model + Phase 1):</strong> Codex 5 HIGH / 7 MEDIUM / 2 LOW, Claude 1 HIGH / 8 MEDIUM / ~11 LOW; every finding verified against the code; all folded in. Design changes: (1) the delete/rename guards used <code>lessonHasContent()</code> (seven text fields only) — a photo-only, Q&amp;A-only, planComplete-only or materials-only plan would have been batch-deleted with its camp → <code>dayOffPlanHasUserData()</code> covers every persisted user-authored field, with a test per field; (2) <code>curriculum-admin</code> (the legacy alias) removed from the three new rule blocks — extending it to new collections is a widening CLAUDE.md forbids without Christie's say-so, and it has no test fixture; (3) editing an event's dates now refuses to drop a date any camp still uses (referential integrity); (4) "a date in only one event" downgraded from an invariant to a best-effort forced-server check — a query-then-create cannot be transactional without a claim collection, judged not worth it for a one-person list; (5) camp validation completed (location, studio membership + uniqueness, age range, hours, sorted unique dates, ≥ 1 title per day, no duplicate titles per day, unique teachers) and made server-authoritative (the event is re-read before every camp write); nested fields written whole on change so removed day keys cannot linger; (6) a fifth dependency on the seasons plan named — <code>updateAppData()</code>, the field-path appData writer — and Settings for an SDOC year writes only its four owned fields (the first draft's "spread the existing semester" would have polluted the schema with <code>numWeeks: 16</code> and the default roster on the first save); (7) the model now says plainly that visibility is UI gating (the rules let every teacher read every SDOC doc), that shared-plan editing is dirty-field merge with last-write-wins per field, that the Help Queue's <em>data path</em> is reused but its writers/labels need a Phase 3 branch, that the teacher-facing sites which assume one teacher per lesson (teacher list, name fallback, <code>canEditLesson()</code>, content count, the "Loading…" branch) are Phase 2 work, and that the SDOC editor needs the weekly editor's editable materials table (no hub); (8) the plans rule stays in Phase 1 with the rationale spelled out (one rules deploy for the plan; the guards query the collection), while the <code>canEditLesson()</code>/name-fallback changes move to Phase 2; (9) all three collections go in <code>backup.js</code> Tier 1; (10) test cleanup runs before + finally and the helper refuses non-TEST years before any request; (11) the completeness section and the danger box now state the real blast radius — a <code>dayOffCamps_*</code> permission error at load trips the app-wide guard; (12) a teacher-pool removal guard added; <code>block</code> defined as first-seen position, display-only. Citations moved to studio-hub <code>43173d6</code> (<code>/curriculum</code> 538-569, <code>summerCamps_lessonData</code> 644-647, Default-deny describe <code>rules.test.js:1580</code>). Both reviewers confirmed sound: the events/camps/plans model against D2/D4/D5/D6, auto-ID per-event docs, one shared plan keyed by <code>campId</code>, headcount from placements, Q&amp;A on the plan doc, Storage reuse, rules-first ordering, Publish hidden until Phase 2. Next: round 2 (confirmation), then Christie's go-ahead.</li>
356:       // One season failing trips the guard for the whole app: a partially
372: // partial currentLessonData (or, for restoreFromBackup, would land over a
393:   const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
396:     await ref.set({ ...lessons, ...stamp }, { merge: true });
401:     ...stamp
437: // A reload's read can only plausibly predate a save this recent; a stamp
539:   if (typeof summerReloadHook !== 'function') return 'no-listener';
747:+  // Server reads (Phase 3, Christie's yes Sep 29): offline, the load fails and
843:     // read (review HIGH).
956:   if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
1016:  <p><strong>Re-verification against <code>132fef2</code> (Sep 30, after the storage move landed — PR #5).</strong> The design's line numbers above are pinned to <code>2ef2e62</code>; at build time use this map (<code>132fef2</code>): Teacher View's listener callback app.js:686-711 (SDOC branch 692-696; its load-guard exit 678-681); Curriculum Admin's callback 5114-5120; <code>initCurriculumAdmin()</code> 5091 (<code>caInitialized</code> 5092-5093), awaited at startup app.js:190, tab branch 220-221; <code>calculateLessonProgress()</code> 924, <code>getProgressLabel()</code> 943, <code>canEditDayOffPlan()</code> 622; <code>openPlanEditor()</code> 11639 (<code>canEdit</code> 11648), <code>finishClose</code> 12313; <code>renderDayOffAdmin()</code> 12647; firebase-data.js: <code>reloadSummerForModeChange()</code> 1310, unsubscribe 1319, gated failure path: catch 1351-1364 (<code>isCurrent()</code> 1353, retries 1356-1362, <code>return 'failed'</code> 1363), <code>summerReloadHook</code> 1369, the <code>lessonData</code> snapshot reload 1376-1416, <code>isIsoDate()</code> 2264, <code>dayOffCampTitles()</code> 2322, <code>dayOffServerDocs()</code> 2377, <code>loadDayOffCampData()</code> 2384. None of these functions' bodies changed except <code>setGlobalSemester()</code> and startup (one <code>updateOwnDocPausedNotice()</code> line each) and <code>renderDayOffAdmin()</code>, whose camp/event buttons now use <code>escForOnclick()</code> (PR #3) — harmless for Phase 3 (round 6, Claude LOW). <strong>What did change, and how Phase 3 meets it:</strong> (1) <em>Spring's own-document listeners</em> (firebase-data.js:1420-1457) and <code>recheckOwnDocAfterLegacyLoss()</code> now also call the listener's <code>callback</code> — without a summer/SDOC reload. With the shared <code>onLessonDataReload()</code> they simply redraw each initialised view, as they do today for the owning view; they install no SDOC data, so the stamp and <code>dayOffRefreshFailed</code> don't move (both change only in the gated reload). Re-registering tears the own-doc listeners down and re-adds them (1321) — unchanged by Phase 3, since it keeps the two registration sites. (2) <em>A <code>get({source:'server'})</code> can return stale data after a Listen-stream transport error</em> (found in the storage move's Phase C, Sep 30). Phase 3's SDOC queries can't use a transaction (queries aren't transactional in this SDK), so the overview accepts it as a <strong>known limitation</strong>: in that rare case the list can show older statuses under a fresh "Last full refresh" time until the next refresh or reload corrects it. For the overview itself it is display-only (Phase 3 writes nothing). <strong>Correction (round 6, both MEDIUM): the 2B editor is NOT covered.</strong> Its open read, <code>readDayOffPlanForEditor()</code> (firebase-data.js:2891-2897), is the same <code>get({source:'server'})</code> and marks the copy verified (<code>dayOffInstallVerified()</code>); the save transaction (2940-2965) re-reads the plan but never compares it with the opened version and writes with <code>merge: true</code>, and <code>verifyDayOffPlanWrite()</code> only confirms its own <code>lastEditId</code>. So a stale open lets a teacher save over a co-teacher's newer text with a plain "Saved" — the "edited since" notice can't fire. This is a <em>live 2B gap</em>, not new in Phase 3, but Phase 3's Open plan is one more way into that editor. <strong>Fix — in the Phase 3 build (Christie, Sep 30: "#1"):</strong> open the plan with a read-only <code>runTransaction(tx =&gt; tx.get(planRef))</code> — single-document transactional reads are always fresh, the storage move's own lesson — with no change to the save path. And <code>source: 'server'</code> still delivers what Christie approved it for (a failed read trips the guard instead of showing a cached or empty year as editable). (3) <code>escForOnclick()</code> now exists (PR #3, app.js:8283); Phase 3 still puts the plan key in a <code>data-</code> attribute and binds the handler in code, so no inline handler value is added.</p>
1020:    <li>In Curriculum Admin for an SDOC year, each camp row gains a <strong>Plans</strong> column listing each of its projects (the <code>dayOffCampTitles()</code> order — unused and no-plan blocks excluded): title, a status pill from the same <code>calculateLessonProgress()</code> (app.js:914) + <code>getProgressLabel()</code> the teachers' list uses, so both views always agree — <em>Not started</em> / <em>In progress</em> / <em>Complete</em> (its fourth value, <code>'ready'</code> → "Almost Done", is unreachable for SDOC because a slot's <code>campName</code> zeroes <code>hasMaterials</code>, app.js:922-924; rendered as In progress if it ever appears) — and "last edited by <em>name</em>, <em>Oct 5</em>" when the plan has an edit stamp (the date is <code>lastEditedAt.slice(0, 10)</code>, shown only if <code>isIsoDate()</code> (firebase-data.js:2000) accepts it, through <code>formatDayOffDate(…, { month: 'short', day: 'numeric' })</code> — which returns unparseable input unchanged, hence the check), plus an <strong>Open plan</strong> button.
1027:  <p><strong>Refresh — through the existing gated reload (round 1, both HIGH).</strong> No new loader: <code>refreshDayOffYear()</code> calls <code>reloadSummerForModeChange()</code> (firebase-data.js:1107) → <code>summerReloadHook()</code>, the listener's own generation-gated reload (Curriculum Admin sets that listener up, app.js:5037). So a refresh and a snapshot-triggered reload are the <em>same</em> mechanism: only the newest generation installs and redraws (an older one resolving last returns <code>'stale'</code>, firebase-data.js:1125), <code>previous</code> is captured by <code>snapshotCampSeasons()</code> for <code>mergeSummerReload()</code>, and 2B's heal runs. If no listener exists yet (<code>'no-listener'</code>), <code>initCurriculumAdmin()</code> hasn't run and its own first load covers it. <strong>The refresh redraws the list itself (round 2, both):</strong> there is one global listener, and whichever of <code>initTeacherView()</code> (app.js:676) / <code>initCurriculumAdmin()</code> (app.js:5038) ran last owns its callback — after a visit to Teacher View it is Teacher View's, whose SDOC branch renders only Teacher View — so <code>refreshDayOffYear()</code> awaits the outcome and calls <code>renderAdminGrid()</code> itself for any outcome but <code>'stale'</code> (including <code>'failed'</code>, so the message shows). A single in-flight refresh promise is shared: the two automatic call sites and the button never start a second one while one runs. <strong>Server-fresh:</strong> <code>loadDayOffCampData()</code>'s three queries switch to <code>get({ source: 'server' })</code> (like <code>dayOffServerDocs</code>, firebase-data.js:2114). <em>This changes every SDOC load, including startup's <code>loadLessonData()</code> (firebase-data.js:775-776) that teachers hit (round 2, Claude):</em> today an offline start can fall back to the cache and show an empty or old SDOC year with editing enabled — the "data disappeared" shape; with the change it trips the app-wide load guard and banner instead (the same as any failed load). Safer, but a visible behaviour change for anyone opening the app offline — <strong>Christie's yes is asked with the go.</strong> <strong>The stamp:</strong> <code>dayOffLastRefreshAt[yearKey]</code> is set wherever a full SDOC-year load <em>installs</em> successfully — startup's <code>loadLessonData()</code> and the gated <code>reloadSummer</code> success path — so the header is never blank after a good load, listener reloads (also full reads) advance it truthfully, and an editor's single-plan read, a stale reload and a failed one never do.</p>
1028:  <p><strong>Failure (round 1, both).</strong> A failed refresh is a failed gated reload: it already sets <code>lessonDataLoadedSuccessfully = false</code>, shows the banner and retries (firebase-data.js:1143-1158) — kept as is, so nothing can be edited over data that failed to load. The admin list keeps its previous figures (the failed reload installs nothing), adds "Couldn't refresh — showing the last full refresh (10:42)" beside the button, and the stamp does not move. <code>openPlanEditor()</code> gains the guard in its <strong>SDOC</strong> edit decision only — <code>canEdit = sdoc ? (canEditDayOffPlan(lesson) &amp;&amp; lessonDataLoadedSuccessfully !== false) : true</code> (app.js:11515; the summer branch is untouched, round 2) — so an SDOC editor opens read-only while guarded (its save already refuses). A later successful reload — the button's, an automatic retry, or a snapshot-triggered one — clears the guard (existing behaviour) and the message: the message is <em>derived at render time</em>, not set once — <code>dayOffRefreshFailed[yearKey]</code> is set inside the gated reload's own failure path, behind <code>isCurrent()</code> (firebase-data.js:1143-1150) — so a failed automatic retry or snapshot reload shows it too, not only the button's (round 4, Claude LOW) — and cleared wherever the stamp is set (a successful install), and <code>renderAdminGrid()</code> reads it; the next redraw (see "Redraw on every install") shows the truth.</p>
1030:  <p><strong>Redraw on every install — one shared listener callback (round 3 MEDIUM; revision 5 after round 4).</strong> Round 2 made the button's refresh redraw the list itself, but two other paths install SDOC data (moving the stamp and the guard) and redraw <em>only</em> through the listener's callback: the failed reload's automatic retries (firebase-data.js:1151-1157) and a snapshot-triggered reload (firebase-data.js:1190-1194). Today there are two callbacks and one listener, and whichever registration ran last owns it: <code>initTeacherView()</code> (app.js:676) and <code>initCurriculumAdmin()</code> (app.js:5038) each register once. Usually Teacher View's wins (first visit after startup), leaving Curriculum Admin — <strong>weekly grid included (a pre-existing gap)</strong> — without redraws on any reload; but in a startup race (round 4, both) Curriculum Admin's wins: startup installs the tab handlers and then awaits <code>initCurriculumAdmin()</code> (app.js:182-188), which sets <code>caInitialized</code> and awaits the change-log / cut / future-project loads before registering (app.js:5015-5038) — a fast click on Teacher View builds and registers it inside that window, Curriculum Admin then registers last, and Teacher View (which never re-registers, app.js:653-656) stops redrawing for the page's life. <strong>Fix — make ownership irrelevant:</strong> both inits register the <em>same</em> function, <code>onLessonDataReload(data)</code>: <code>currentLessonData = data</code>; if <code>tvInitialized</code>, call <code>teacherViewOnReload()</code> — Teacher View's current callback body (app.js:678-699, minus the assignment and the mapping-table calls) moved into its own function, so its SDOC branch's early <code>return</code> (app.js:682-686) exits only that helper and can never skip the admin redraw; if <code>caInitialized</code>, run <code>renderAdminGrid(); renderHelpQueue();</code>; then <code>renderTeacherMappingTable()</code> once. Each branch is exactly what that view's own callback does on every tick today, whether or not its tab is showing, so no new behaviour runs — the redraw just no longer depends on registration order. Re-registering the same function stays as today (unsubscribe + generation bump, firebase-data.js:1114-1116). <code>refreshDayOffYear()</code> keeps its own redraw (round 2) — a harmless second draw. <em>Build notes (round 5, Claude LOW):</em> wrap each branch of <code>onLessonDataReload()</code> in its own try/catch (log and continue) so a throw in Teacher View's redraw can't skip the admin redraw; <code>tvInitialized</code> is also true during Teacher View's own <code>await loadLessonData()</code> (app.js:657→661) — harmless, it converges through the existing empty-picker reset (app.js:690-696).</p>
1071:Then: the newer reload's data stays (the older returns 'stale'); the stamp is the newer reload's time
1075:Then: the previous figures stay, "Couldn't refresh" shows, the stamp does not move, the load guard is false and Open plan opens read-only; after a successful refresh the guard clears and editing works
1091:Then: the row's status and "last edited by Mariah" update AND the stamp moves (the refresh redraws the list itself)
1093:Given: the app starts offline (the SDOC queries fail)
1099:Then: "Couldn't refresh" is gone, the rows and the stamp are fresh, the load guard is true, and Open plan opens editable
1103:Then: without pressing Refresh, the SDOC list redraws and its stamp moves; the weekly grid shows the other device's change
1238:   // switching seasons on, and heals if it started offline.
1784:+    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
1806:+      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
2057:   167	  // switching seasons on, and heals if it started offline.
2425: 12677	    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
2447: 12699	      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
2854:  1323	  if (typeof summerReloadHook !== 'function') return 'no-listener';
3097:  1221	// A reload's read can only plausibly predate a save this recent; a stamp
3371:  2403	  // Server reads (Phase 3, Christie's yes Sep 29): offline, the load fails and
3433: 12677	    if (outcome !== 'stale' && outcome !== 'no-listener' && isDayOffYear(getAdminSemKey())) renderAdminGrid();
3455: 12699	      <span id="sdoc-refresh-stamp" class="settings-hint">${at ? `Last full refresh ${sdocEsc(at)}` : 'Not refreshed yet'}</span>
3604:The main integration is internally consistent so far. I’m now checking the less obvious regressions: hidden-view redraw state, multi-year failure attribution, refresh concurrency semantics, and whether P1–P16 actually detect those failures.
3654:   976	      // One season failing trips the guard for the whole app: a partially
3670:   992	// partial currentLessonData (or, for restoreFromBackup, would land over a
3691:  1013	  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
3968:   144	  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
3973:   149	    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('3:07');
3979:   155	    await expect(planner.locator('#sdoc-refresh-stamp')).not.toContainText('3:07');
3980:   156	    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText('Last full refresh');
3989:   165	    const stampBefore = await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y);
4002:   178	    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBe(stampBefore);
4009:   185	    // The automatic retry succeeds: message gone, rows + stamp fresh, editing back — with no click.
4012:   188	    expect(await planner.evaluate((Y) => +dayOffLastRefreshAt[Y], Y)).toBeGreaterThan(stampBefore);
4085:   261	  test('P10: an older refresh that resolves last cannot undo a newer reload; the stamp is the newer one\'s', async () => {
4155:   331	    await expect(planner.locator('#sdoc-refresh-stamp')).not.toContainText('3:07');
4189:   365	  test('P15: SDOC loads are server reads, and offline they trip the load guard instead of showing a cached year as editable', async () => {
4587:   144	  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
4646:+  test('P3: ↻ Refresh shows a save made on another device after the page loaded, moves the stamp, and writes nothing', async () => {
4653:+  test('P10: an older refresh that resolves last cannot undo a newer reload; the stamp is the newer one\'s', async () => {
4658:+  test('P15: SDOC loads are server reads, and offline they trip the load guard instead of showing a cached year as editable', async () => {
5244:   872	// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
5264:- **MEDIUM** — A failed multi-year reload can partially install data despite the requirement to preserve previous figures. `loadDayOffCampData()` mutates `currentDayOffEvents/Camps/Plans` immediately, before the reload knows every year succeeded. If year A succeeds and a later year B fails, A’s new camp structure is rendered against its old slot map, while all years are marked failed. [firebase-data.js:2424](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2424), [firebase-data.js:1346](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1346), [firebase-data.js:1369](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1369). P4 only fails the first SDOC read, so it cannot catch this. [day-off-overview.spec.js:168](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:168)
5266:- **MEDIUM** — Startup failures never set `dayOffRefreshFailed`. If a camp season or later SDOC year fails during `loadLessonData()`, the guard trips, but affected SDOC headers show “Not refreshed yet” rather than “Couldn’t refresh.” Earlier years may already have stamps and partially installed side maps. [firebase-data.js:959](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:959), [firebase-data.js:975](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:975). P15 verifies only the guard. [day-off-overview.spec.js:365](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:365)
5268:- **MEDIUM** — The documented `no-listener` assumption is false during startup. `caInitialized` becomes true before several awaited loads and listener registration, while lesson data was already preloaded. A fast tab entry/year switch invokes `refreshDayOffYear()`, receives `no-listener`, and is never retried after registration. [app.js:5113](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5113), [app.js:12671](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12671). P11 runs after initialization; P14 manually installs the listener.
5270:- **LOW** — A genuinely offline guarded page cannot open the promised read-only editor: the transactional server read happens before `canEdit` is calculated and transactions fail offline, producing only the alert. P4/P5 simulate the guard while Firestore remains reachable. [app.js:11642](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11642), [firebase-data.js:2915](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2915)
5277:- **MEDIUM** — A failed multi-year reload can partially install data despite the requirement to preserve previous figures. `loadDayOffCampData()` mutates `currentDayOffEvents/Camps/Plans` immediately, before the reload knows every year succeeded. If year A succeeds and a later year B fails, A’s new camp structure is rendered against its old slot map, while all years are marked failed. [firebase-data.js:2424](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2424), [firebase-data.js:1346](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1346), [firebase-data.js:1369](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1369). P4 only fails the first SDOC read, so it cannot catch this. [day-off-overview.spec.js:168](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:168)
5279:- **MEDIUM** — Startup failures never set `dayOffRefreshFailed`. If a camp season or later SDOC year fails during `loadLessonData()`, the guard trips, but affected SDOC headers show “Not refreshed yet” rather than “Couldn’t refresh.” Earlier years may already have stamps and partially installed side maps. [firebase-data.js:959](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:959), [firebase-data.js:975](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:975). P15 verifies only the guard. [day-off-overview.spec.js:365](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-overview.spec.js:365)
5281:- **MEDIUM** — The documented `no-listener` assumption is false during startup. `caInitialized` becomes true before several awaited loads and listener registration, while lesson data was already preloaded. A fast tab entry/year switch invokes `refreshDayOffYear()`, receives `no-listener`, and is never retried after registration. [app.js:5113](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5113), [app.js:12671](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12671). P11 runs after initialization; P14 manually installs the listener.
5283:- **LOW** — A genuinely offline guarded page cannot open the promised read-only editor: the transactional server read happens before `canEdit` is calculated and transactions fail offline, producing only the alert. P4/P5 simulate the guard while Firestore remains reachable. [app.js:11642](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11642), [firebase-data.js:2915](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2915)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-WmQiZgYW' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-kOE5y5zq' (errno=Operation not permitted)
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
        markDayOffYearInstalled(yearKey);
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
      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
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

git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-OkCfXKhA' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-NKd0HhTz' (errno=Operation not permitted)

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '12665,12705p'; nl -ba js/firebase-data.js | sed -n '968,990p;1298,1312p;1338,1398p;2395,2438p'; nl -ba e2e/day-off-overview.spec.js | sed -n '384,430p'; nl -ba js/app.js | sed -n '5085,5135p'; nl -ba js/app.js | sed -n '175,230p'" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
 12665	// Read-only: computed from the slots buildDayOffSlots() already builds. Teachers
 12666	// save on other devices and there is no SDOC listener, so the year is re-read on
 12667	// Curriculum Admin entry, on switching to it, and by ↻ Refresh — always through
 12668	// the listener's own generation-gated reload, never a second loader.
 12669	let dayOffRefreshInFlight = null;
 12670	// A read that hangs (connected but stalled) must not hold the gate for the rest
 12671	// of the visit: after this long a new refresh may start — its generation bump
 12672	// makes the hung one 'stale' if it ever answers.
 12673	let DAY_OFF_REFRESH_DEADLINE_MS = 30000;   // let: the e2e suite shortens it
 12674	
 12675	// Resolves with the reload's outcome. The listener's callback (onLessonDataReload)
 12676	// redraws Curriculum Admin on 'ok' and 'failed' alike. 'no-listener' only happens
 12677	// before initCurriculumAdmin() has registered the listener — and registering it
 12678	// always runs a full reload on the first server snapshot, which redraws.
 12679	function refreshDayOffYear(yearKey) {
 12680	  if (dayOffRefreshInFlight) return dayOffRefreshInFlight;   // one at a time: the button and both automatic calls share it
 12681	  const run = reloadSummerForModeChange();
 12682	  dayOffRefreshInFlight = run;
 12683	  const release = () => {
 12684	    if (dayOffRefreshInFlight !== run) return;
 12685	    dayOffRefreshInFlight = null;
 12686	    if (isDayOffYear(getAdminSemKey())) renderDayOffRefreshControls(getAdminSemKey());
 12687	  };
 12688	  run.then(release, release);
 12689	  setTimeout(release, DAY_OFF_REFRESH_DEADLINE_MS);
 12690	  renderDayOffRefreshControls(yearKey);   // disable the button now
 12691	  return run;
 12692	}
 12693	
 12694	// "3:07 PM" today; "Mon 3:07 PM" otherwise (a page left open overnight).
 12695	function formatDayOffRefreshTime(d) {
 12696	  if (!(d instanceof Date) || isNaN(d)) return '';
 12697	  const time = d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
 12698	  return d.toDateString() === new Date().toDateString() ? time : `${d.toLocaleDateString([], { weekday: 'short' })} ${time}`;
 12699	}
 12700	
 12701	function dayOffRefreshControlsHtml(yearKey) {
 12702	  const at = formatDayOffRefreshTime(dayOffLastRefreshAt[yearKey]);
 12703	  const busy = !!dayOffRefreshInFlight;
 12704	  const failed = !!dayOffRefreshFailed[yearKey];
 12705	  return `<span class="sdoc-refresh" id="sdoc-refresh">
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
   980	      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // SDOC Phase 3: say so in the overview
   981	    }
   982	  } catch (err) {
   983	    console.error('Error loading lesson data:', err);
   984	    currentLessonData = {};
   985	    lessonDataLoadedSuccessfully = false;
   986	    for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;
   987	  }
   988	  return currentLessonData;
   989	}
   990	
  1298	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1299	// SDOC Phase 3: when each School Day Off year was last read in full and
  1300	// installed (a Date), and whether the latest full reload of it failed. Both
  1301	// change only where a full load installs or fails — never on a single-plan
  1302	// read — and Curriculum Admin's overview derives its message from them at
  1303	// render time, so any redraw after a recovery shows the truth.
  1304	const dayOffLastRefreshAt = {};
  1305	const dayOffRefreshFailed = {};
  1306	function markDayOffYearInstalled(yearKey) {
  1307	  dayOffLastRefreshAt[yearKey] = new Date();
  1308	  delete dayOffRefreshFailed[yearKey];
  1309	}
  1310	// The camp seasons currently in memory, by semester key.
  1311	function snapshotCampSeasons() {
  1312	  const out = {};
  1338	  // generation may touch the guard, the banner, or the summer cache.
  1339	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1340	  // outcome was discarded (a newer snapshot took over while it ran).
  1341	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1342	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1343	    try {
  1344	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1345	      const plans = campSeasonLoadPlan();
  1346	      const fresh = {};
  1347	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1348	      const dayOffKeys = dayOffYearKeys();
  1349	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1350	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1351	      for (const yearKey of dayOffKeys) {
  1352	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1353	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1354	      }
  1355	      for (const plan of plans) {
  1356	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1357	        // prunes parked copies that are absent from `fresh`, so merging one
  1358	        // season against another's would evict the other's on every reload.
  1359	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1360	      }
  1361	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1362	      for (const yearKey of dayOffKeys) markDayOffYearInstalled(yearKey);   // only once everything installed
  1363	      lessonDataLoadedSuccessfully = true;
  1364	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1365	      return 'ok';
  1366	    } catch (err) {
  1367	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1368	      if (!isCurrent()) return 'stale';
  1369	      lessonDataLoadedSuccessfully = false;
  1370	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1371	      for (const yearKey of dayOffYearKeys()) dayOffRefreshFailed[yearKey] = true;   // nothing of this reload installed
  1372	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1373	      if (delay !== undefined) {
  1374	        setTimeout(() => {
  1375	          if (!isCurrent()) return; // a newer snapshot has taken over
  1376	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1377	        }, delay);
  1378	      }
  1379	      return 'failed';
  1380	    }
  1381	  };
  1382	
  1383	  // The registry-change entry point: same reload, same generation gate, and it
  1384	  // renders through the same callback when it is still the current generation.
  1385	  summerReloadHook = async () => {
  1386	    const myGeneration = ++globalListenerGeneration;
  1387	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1388	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1389	    return outcome;
  1390	  };
  1391	
  1392	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1393	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1394	      // Skip cache-only updates
  1395	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1396	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1397	        return;
  1398	      }
  2395	  return snap.docs.map(d => ({ id: d.id, ...d.data() }));
  2396	}
  2397	
  2398	// Three single-field equality queries — no composite index. A permission error
  2399	// (or any failure) throws, so the caller trips the app-wide load guard.
  2400	async function loadDayOffCampData({ yearKey, isCurrent = () => true } = {}) {
  2401	  if (!curriculumDb) initCurriculumFirestore();
  2402	  // Read BEFORE the queries: any plan verified after this point is newer than
  2403	  // what they return (Phase 2B — a reload must not undo a verified save).
  2404	  const startSeq = dayOffInstallSeq;
  2405	  // Server reads (Phase 3, Christie's yes Sep 29): offline, the load fails and
  2406	  // trips the guard instead of serving a cached or empty year as editable.
  2407	  const [eventSnap, campSnap, planSnap] = await Promise.all([
  2408	    dayOffQuery('events', 'yearKey', yearKey).get({ source: 'server' }),
  2409	    dayOffQuery('camps', 'yearKey', yearKey).get({ source: 'server' }),
  2410	    dayOffQuery('plans', 'yearKey', yearKey).get({ source: 'server' }),
  2411	  ]);
  2412	  const events = sortDayOffEvents(eventSnap.docs.map(d => ({ id: d.id, ...d.data() })));
  2413	  const camps = campSnap.docs.map(d => ({ id: d.id, ...d.data() }));
  2414	  const plans = {};
  2415	  const signoffs = {};
  2416	  planSnap.docs.forEach(d => {
  2417	    const p = d.data();
  2418	    if (isDayOffSignoffDoc(p)) { signoffs[p.campId] = p; return; }   // never a plan, never a slot
  2419	    plans[dayOffLessonKey(yearKey, p.campId, p.projectTitle)] = p;
  2420	  });
  2421	  const protectedKeys = new Set();
  2422	  for (const [key, seq] of Object.entries(dayOffVerifiedAt[yearKey] || {})) {
  2423	    const verified = currentDayOffPlans[yearKey]?.[key];
  2424	    if (seq > startSeq && verified) { plans[key] = verified; protectedKeys.add(key); }
  2425	  }
  2426	  if (isCurrent()) {
  2427	    currentDayOffEvents[yearKey] = events;
  2428	    currentDayOffCamps[yearKey] = camps;
  2429	    currentDayOffPlans[yearKey] = plans;
  2430	    currentDayOffSignoffs[yearKey] = signoffs;
  2431	  }
  2432	  const slots = buildDayOffSlots(yearKey, events, camps, plans);
  2433	  Object.defineProperty(slots, DAY_OFF_PROTECTED, { value: protectedKeys, enumerable: false });
  2434	  Object.defineProperty(slots, DAY_OFF_LOAD_START, { value: startSeq, enumerable: false });
  2435	  return slots;
  2436	}
  2437	
  2438	function rebuildDayOffSlots(yearKey) {
   384	  test('P17: a failed SDOC load at startup says "Couldn\'t refresh" in the overview (not a quiet empty year)', async () => {
   385	    await makeThanksgiving();
   386	    await showYear(planner);
   387	    const failed = await planner.evaluate(async (Y) => {
   388	      const real = window.loadDayOffCampData;
   389	      window.loadDayOffCampData = async () => { throw new Error('TEST injected startup failure'); };
   390	      try { await loadLessonData(); } finally { window.loadDayOffCampData = real; }
   391	      return { failed: dayOffRefreshFailed[Y] === true, guard: lessonDataLoadedSuccessfully };
   392	    }, Y);
   393	    expect(failed).toEqual({ failed: true, guard: false });
   394	    await planner.evaluate(() => renderAdminGrid());
   395	    await expect(planner.locator('#sdoc-refresh-error')).toContainText("Couldn't refresh");
   396	  });
   397	
   398	  test('P18: a refresh that hangs releases the gate after the deadline — the next refresh runs a new reload', async () => {
   399	    await makeThanksgiving();
   400	    await showYear(planner);
   401	    const n = await planner.evaluate(async (Y) => {
   402	      DAY_OFF_REFRESH_DEADLINE_MS = 300;
   403	      const real = window.reloadSummerForModeChange;
   404	      let calls = 0;
   405	      window.reloadSummerForModeChange = () => { calls++; return calls === 1 ? new Promise(() => {}) : real(); };   // the first never answers
   406	      try {
   407	        refreshDayOffYear(Y);
   408	        const busy = document.getElementById('sdoc-refresh-btn').disabled;
   409	        await new Promise(r => setTimeout(r, 500));
   410	        const outcome = await refreshDayOffYear(Y);
   411	        return { calls, busy, outcome };
   412	      } finally { window.reloadSummerForModeChange = real; DAY_OFF_REFRESH_DEADLINE_MS = 30000; }
   413	    }, Y);
   414	    expect(n).toEqual({ calls: 2, busy: true, outcome: 'ok' });
   415	    await expect(planner.locator('#sdoc-refresh-btn')).toBeEnabled();
   416	  });
   417	
   418	  test('P19: a refresh from an earlier day shows the weekday with the time', async () => {
   419	    await makeThanksgiving();
   420	    await showYear(planner);
   421	    const label = await planner.evaluate((Y) => {
   422	      const d = new Date(); d.setDate(d.getDate() - 2); d.setHours(15, 7, 0, 0);
   423	      dayOffLastRefreshAt[Y] = d; renderAdminGrid();
   424	      return d.toLocaleDateString([], { weekday: 'short' });
   425	    }, Y);
   426	    await expect(planner.locator('#sdoc-refresh-stamp')).toContainText(`Last full refresh ${label} 3:07`);
   427	  });
   428	
   429	  test('P16: the 2B editor opens from a transactional read — a stale server answer is never what it shows', async () => {
   430	    const { clay } = await makeThanksgiving();
  5085	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5086	    // R4-11: the empty lesson slots may already be persisted even though the
  5087	    // config never was — clean up the orphaned server-side write, not just the
  5088	    // local copy. Safe: this data is template-empty by construction (never had
  5089	    // real content), so deleting it loses nothing.
  5090	    if (lessonDataCommitted) {
  5091	      try {
  5092	        await deleteLessonData(key);
  5093	      } catch (cleanupErr) {
  5094	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5095	      }
  5096	    }
  5097	    alert('Could not create the new semester. Please try again.');
  5098	    return;
  5099	  } finally {
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

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '5130,5150p'; nl -ba js/firebase-data.js | sed -n '1392,1435p'; git status --porcelain" in /Users/christiehubley/tinker-spring-curriculum
 succeeded in 0ms:
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
  1392	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1393	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1394	      // Skip cache-only updates
  1395	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1396	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1397	        return;
  1398	      }
  1399	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1400	      if (!doc.exists) return;
  1401	
  1402	      const myGeneration = ++globalListenerGeneration;
  1403	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1404	      // in their own collection, so carry their current maps across the swap
  1405	      // and let the reload below refresh each one (Phase 1, 1.4).
  1406	      const previousSummer = snapshotCampSeasons();
  1407	      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
  1408	      // document once moved, so carry them across the swap like the camp seasons —
  1409	      // their own listeners below keep them current.
  1410	      const previousOwn = {};
  1411	      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
  1412	      currentLessonData = doc.data();
  1413	      lastLegacyLessonData = doc.data();
  1414	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1415	      for (const semKey of OWN_DOC_SEMESTERS) {
  1416	        const token = bumpOwnDocToken(semKey);
  1417	        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
  1418	          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
  1419	        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
  1420	          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
  1421	          recheckOwnDocAfterLegacyLoss(semKey, callback, token);
  1422	        } else if (semKey in currentLessonData) {
  1423	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1424	        }
  1425	      }
  1426	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1427	
  1428	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1429	      // A superseded reload renders nothing — the newer snapshot's own
  1430	      // callback already did (or will), with the same live object. A failed
  1431	      // one still renders: the non-summer semesters in this snapshot are new.
  1432	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1433	    });
  1434	
  1435	  // Own-doc semesters: one listener per document, plus the migration record.
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-901ges3C' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-XB828KVr' (errno=Operation not permitted)

codex
No new HIGH/MEDIUM findings.

The 30-second deadline is sound. The expired run’s timer or eventual settlement cannot release a newer gate because `release()` verifies promise identity ([app.js:12683](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12683)). Starting the next reload increments `globalListenerGeneration`; the older reload then returns `stale` and cannot install final data, change flags, redraw, or schedule retries ([firebase-data.js:1342](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1342)). Concurrent reads may briefly overlap, but the only mutation risk is the already-acknowledged partial side-map behavior.

The other fixes are correct:

- Startup failure now sets every SDOC year’s failure flag in both catch paths.
- Listener stamps move only after all year and camp-season maps install.
- Successful/failed refreshes redraw once through the shared callback.
- Prior-day stamps include the weekday.

The deferred reasons hold:

- `no-listener`: registration’s first server snapshot performs the full reload/redraw. Offline startup already trips the load guard/failure state.
- Multi-year side-map staging is genuinely pre-existing and entangled with verified-save preservation; deferring it to a designed change is reasonable.
- Offline transactional editor opening retains the prior server-read failure behavior; Phase 3 did not regress it.

Tests: P17 directly pins startup failure; P18 pins deadline release and a subsequent reload; P19 pins weekday formatting. P18 does not explicitly settle the old promise while a newer gate is active, but the identity guard is clear, and P10 separately pins stale-generation rejection. The moved stamp boundary lacks a dedicated post-partial-install throw test, but that is a LOW coverage gap within the deferred multi-year case.

Repository remained unchanged; tests were not run because the requested review was read-only.

ready to merge — yes
tokens used
62,284
No new HIGH/MEDIUM findings.

The 30-second deadline is sound. The expired run’s timer or eventual settlement cannot release a newer gate because `release()` verifies promise identity ([app.js:12683](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12683)). Starting the next reload increments `globalListenerGeneration`; the older reload then returns `stale` and cannot install final data, change flags, redraw, or schedule retries ([firebase-data.js:1342](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1342)). Concurrent reads may briefly overlap, but the only mutation risk is the already-acknowledged partial side-map behavior.

The other fixes are correct:

- Startup failure now sets every SDOC year’s failure flag in both catch paths.
- Listener stamps move only after all year and camp-season maps install.
- Successful/failed refreshes redraw once through the shared callback.
- Prior-day stamps include the weekday.

The deferred reasons hold:

- `no-listener`: registration’s first server snapshot performs the full reload/redraw. Offline startup already trips the load guard/failure state.
- Multi-year side-map staging is genuinely pre-existing and entangled with verified-save preservation; deferring it to a designed change is reasonable.
- Offline transactional editor opening retains the prior server-read failure behavior; Phase 3 did not regress it.

Tests: P17 directly pins startup failure; P18 pins deadline release and a subsequent reload; P19 pins weekday formatting. P18 does not explicitly settle the old promise while a newer gate is active, but the identity guard is clear, and P10 separately pins stale-generation rejection. The moved stamp boundary lacks a dedicated post-partial-install throw test, but that is a LOW coverage gap within the deferred multi-year case.

Repository remained unchanged; tests were not run because the requested review was read-only.

ready to merge — yes
