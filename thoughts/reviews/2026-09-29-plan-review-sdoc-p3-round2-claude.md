# Verdict: CHANGES NEEDED — 1 HIGH, 2 MEDIUM

**All seven round-1 findings are genuinely fixed**, and each fix checks out against the code: the refresh now goes through `reloadSummerForModeChange()` → `summerReloadHook()` (`firebase-data.js:1107-1110`, `:1164-1169`), whose generation gate is real (`:1119`, `'stale'` at `:1131`) and whose `loadDayOffCampData` installs only `if (isCurrent())` (`:2144-2149`); `snapshotCampSeasons()` supplies `previous`; the failure path keeps the existing guard/banner/retry (`:1146-1158`); the two lifecycle call sites are named correctly; `formatDayOffDate` does take an opts param (`:2005`); the `(camp, title)` counting matches `dayOffCampTitles` (`:2058-2069`); the `data-lesson-key` pattern matches existing code at `app.js:1769`.

## NEW — HIGH: the refresh installs fresh data but never redraws the admin list

`summerReloadHook` is set by `setupLessonDataListener`, which has **two** callers — `initTeacherView()` (`app.js:676`) and `initCurriculumAdmin()` (`app.js:5038`). Last call wins, and the default startup order makes Teacher View the later one:

1. `app.js:187` — `await initCurriculumAdmin()` on load (default tab).
2. Planner opens Teacher View once → the **teacher** callback replaces the hook.
3. Back to Curriculum Admin → `initCurriculumAdmin()` early-returns (`caInitialized`, `:5016`); the hook is not re-registered.

After that, `refreshDayOffYear()` installs the data correctly but fires the teacher callback, whose SDOC branch is `if (activeTab === 'teacher-view') renderTeacherView(); …; return;` (`app.js:683-687`) — nothing renders while Curriculum Admin is showing. Statuses stay stale while "Last full refresh 10:42" advances: the exact freshness lie Phase 3 exists to remove. The same gap swallows the failed-refresh message and disabled state.

**Fix:** `refreshDayOffYear()` awaits the outcome and calls `renderAdminGrid()` itself when it isn't `'stale'` (including on `'failed'`); don't rely on the hook's callback. Correct "Curriculum Admin sets that listener up (app.js:5037)".

## NEW — MEDIUM: `source:'server'` for every SDOC load also changes startup

`loadDayOffCampData` has a second caller the plan doesn't mention — `loadLessonData()` (`firebase-data.js:775-776`), whose catch trips the **app-wide** guard (`:783-784`). Forcing server source is the right direction (today an offline query falls back to cache and returns an empty snapshot with writers enabled — the repo's "data disappeared" hazard), but it changes behaviour for **teachers on Teacher View**, not just the planner's refresh. Say so, add a BDD for a failed initial load, and get Christie's yes.

## NEW — MEDIUM: the guard sentence catches the summer editor too

`app.js:11515` is `const canEdit = sdoc ? canEditDayOffPlan(lesson) : true;`. Written as `canEdit = … && lessonDataLoadedSuccessfully !== false`, the guard lands on both branches. Scope it to the `sdoc` branch, or say the summer change is deliberate.

## LOW (no re-review needed)

The stamp is set only on the gated-reload path, so the header is blank from first paint until the first snapshot; the `"garbage"` BDD needs `isIsoDate()` (`:2000`) since `formatDayOffDate` returns its input unchanged; the two automatic call sites aren't de-duped against the in-flight button; each CA entry now reloads every camp season and SDOC year with forced-server queries.

Full write-up: `/Users/christiehubley/.claude/plans/plan-review-round-eager-dragonfly.md` — it's a review, not an implementation plan, so there's nothing to execute from it. A round 3 only needs to re-read the Refresh, Failure and Lifecycle paragraphs plus the new BDDs.
