# Plan review — Classbook SDOC Phase 3 (revision 1)

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html` § `id="phase-3"` + top Decisions Log entry.
Code read-only @ `2ef2e62`.

## Verdict: CHANGES NEEDED — 1 HIGH, 4 MEDIUM, 2 LOW

Design is sound and read-only: no new fields, writers, collections or rules; it reuses
`buildDayOffSlots`/`dayOffCampTitles`/`calculateLessonProgress`/`openPlanEditor` correctly. The findings are in
the refresh path, the freshness story and two counting/formatting specs.

---

### 1. HIGH — `refreshDayOffYear()` is ungated: a slow refresh reverts newer data and stamps it "as of now"
`loadDayOffCampData()` defaults `isCurrent = () => true` (`js/firebase-data.js:2120`, `:2144-2149`) and installs
`currentDayOffEvents/Camps/Plans/Signoffs` wholesale. The listener's reload *is* generation-gated
(`:1123`, `:1130`) and fires on every `curriculum/lessonData` snapshot, redrawing the grid
(`js/app.js:5040-5041`). A refresh issued first but resolving last overwrites the listener's newer result —
a teacher's save from another device, a camp another planner removed — then paints the newest "as of" time on
the oldest data. The install-sequence protection (`js/firebase-data.js:2139-2143`) only covers *this tab's*
verified saves, so "a refresh racing the listener's reload is harmless … the install-sequence protection covers
verified saves either way" is false for exactly the case Phase 3 exists to show.
**Fix:** give the refresh a monotonic token and pass `isCurrent` into `loadDayOffCampData`, discarding a
superseded result (install nothing, leave the stamp) — or call the existing gated `summerReloadHook()` /
`reloadSummerForModeChange()` (`:1107-1110`, `:1164-1169`), which already loads every SDOC year, merges, heals,
drives the guard and re-renders. Also state what `previous` the refresh hands `mergeSummerReload()`; omitted, it
returns `fresh` at `:1053` and drops an in-flight autosave's `keepMine`.

### 2. MEDIUM — the load-guard sentence contradicts itself
"a refresh that fails … keeps the previous figures" vs "it does not trip the app-wide load guard any differently
from today's loads". Today's SDOC loads **do** trip it: `reloadSummer`'s catch sets
`lessonDataLoadedSuccessfully = false`, shows the banner and retries (`js/firebase-data.js:1146-1158`). If the
refresh swallows its error into an inline message, a rules regression denying `dayOffCamps_*` reads leaves the
admin list **writable** (`writable = lessonDataLoadedSuccessfully !== false`, `js/app.js:12520`) over stale
figures — the silent-failure class the repo's "data disappeared" rule is about.
**Fix:** route through the gated reload so a failure trips the guard as today; show the inline message *as well*.

### 3. MEDIUM — no hook exists for "re-read when Curriculum Admin is opened"
The plan names none. The only per-tab hook is the tab-button handler → `initCurriculumAdmin()`
(`js/app.js:218-219`), which is `if (caInitialized) return;` (`js/app.js:5015-5016`) — once per page load. A build
that hangs the refresh there satisfies BDD "(or re-enters Curriculum Admin)" on the first entry and never again.
**Fix:** name the sites — the tab click handler (`js/app.js:205-222`) and the semester-change branch
(`js/app.js:132-138`), both gated on `isDayOffYear()`. Add a BDD pinning **one** refresh per entry and **zero**
per tick (the plan rightly keeps it out of `renderAdminGrid()`, which fires on every tick —
`js/app.js:13155`, `:13316-13333`, `:13402` — but nothing tests that).

### 4. MEDIUM — "dates via `formatDayOffDate`" prints `lastEditedAt` raw
`formatDayOffDate(iso)` parses `` `${iso}T00:00:00` `` (`js/firebase-data.js:2005-2008`); `lastEditedAt` is a full
ISO timestamp (`new Date().toISOString()`, `js/firebase-data.js:1371`), so the concatenation is invalid and the
function returns its input unchanged — the row reads "last edited by Mariah, 2026-10-05T14:22:31.123Z". "A
malformed `lastEditedAt` is simply not shown" won't catch it: the value is well-formed.
**Fix:** `formatDayOffDate(String(lastEditedAt).slice(0, 10))` (or a separate formatter); have the BDD assert the
rendered form, not merely "shows its last editor/date".

### 5. MEDIUM — roll-up counting is unspecified for one title in two camps of an event
"n = the event's plannable projects across its camps; a project that runs on two days counts once" is right
*within* a camp (`dayOffCampTitles()` dedupes by title, `js/firebase-data.js:2058-2069`) but silent on the case
2A.1 calls out: the same title in two camps of one event is two records and two plans. Keying the roll-up by
title merges them.
**Fix:** state "counted per (campId, title)" and add a BDD — one event, two camps each with a "Canvas" project,
one complete → "1 of 2 complete". The listed BDD uses three distinct titles and passes either implementation.

### 6. LOW — three pills, four labels
Teacher View renders `getProgressLabel(calculateLessonProgress(slot))` (`js/app.js:1762`, `:1768`), which has a
fourth state `'ready'` → **"Almost Done"** (`:929`, `:937`). It is unreachable for SDOC only because
`calculateLessonProgress` zeroes `hasMaterials` whenever `lesson.campName` is set (`:922-924`) and every SDOC slot
carries `campName` (`js/firebase-data.js:2088`). "Both views always agree" rests on that accident.
**Fix:** say so, and reuse `getProgressLabel()` rather than a new three-way map.

### 7. LOW — freshness: cache-backed `.get()`, and the stamp misses the listener
`loadDayOffCampData`'s three queries use plain `.get()` (`js/firebase-data.js:2126-2128`), unlike
`dayOffServerDocs` (`:2114`) and `readDayOffPlanForEditor` (`:2631`), which force `source: 'server'`. Offline the
SDK falls back to cache, the refresh "succeeds", and a new time is stamped on unchanged data. Separately the
listener's reload refreshes the same data and redraws the grid without moving the stamp, so the label also
*understates* freshness.
**Fix:** force server source for the refresh (or surface `metadata.fromCache`), and set the stamp wherever an
SDOC year is installed, not only in `refreshDayOffYear`.

---

## Verified as correct (no change needed)
- Citations `app.js:914`, `:11506`, `:12180` all resolve. `finishClose` (`:12180-12184`) does call
  `renderTeacherView()` then `onClosed?.()`.
- `getAdminSemKey() === getTvSemKey() === getActiveSemesterKey()` (`:4141-4143`, `:635-638`), so that
  `renderTeacherView()` takes the SDOC branch and the plan's `syncDayOffTeacherPicker` side-effect note is
  accurate — and mild: `tvCurrentTeacher` survives unless the selected name left the camps (`:1706-1707`).
- `canEditDayOffPlan(slot)`'s `slot?.yearKey || getTvSemKey()` fallback (`:617-619`) is safe: `buildDayOffSlots`
  sets `yearKey` on every slot (`js/firebase-data.js:2083`).
- `loadDayOffCampData` does protect plans verified after its queries began (`:2139-2143`), as claimed.
- Unused/no-plan exclusion is right: `dayOffCampTitles` → `isDayOffNoPlanTitle` → `isDayOffUnusedBlock` +
  `isSummerNoPlanTitle` (`js/firebase-data.js:2013-2024`, `js/app.js:4148-4152`).
- **XSS:** sound. `sdocEsc`/`sdocEscA` = `escHtml`/`escAttr` (`js/app.js:12491-12492`, `:8149-8161`). Note
  `escAttr` escapes `"` but **not** `'`, so "the plan key only in a `data-` attribute, never interpolated into
  `onclick`" is load-bearing — the existing SDOC buttons interpolate auto-IDs into single-quoted `onclick`s
  (`:12562-12577`) and a project title there breaks out on an apostrophe. Worth one sentence in the plan.

## Would the BDD catch a partial implementation?
Mostly — status, roll-up, editor rights, refresh-on-demand and escaping are pinned. It would **not** catch:
refresh wired into `renderAdminGrid` (F3), a title-keyed roll-up (F5), a stale refresh reverting newer data (F1),
or a raw-ISO edit date (F4). Add one scenario each.
