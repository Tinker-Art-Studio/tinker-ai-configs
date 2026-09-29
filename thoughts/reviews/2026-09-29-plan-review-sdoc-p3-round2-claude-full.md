# Plan review ROUND 2 — Classbook SDOC Phase 3, revision 2

Plan `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html` § `id="phase-3"` + top Decisions Log.
Code read-only @ `2ef2e62`. Nothing edited.

## Verdict: CHANGES NEEDED — 1 HIGH, 2 MEDIUM

### Round-1 findings — all seven confirmed fixed in the plan text

| # (codex / claude) | Fix in rev 2 | Verified against code |
|---|---|---|
| Ungated refresh (C1 / L1) | refresh = `reloadSummerForModeChange()` → `summerReloadHook()` | `firebase-data.js:1107-1110`, `:1164-1169`; gate `:1119`, `'stale'` `:1131`; `loadDayOffCampData` installs only `if (isCurrent())` `:2144-2149` ✓ |
| `previous` for merge | `snapshotCampSeasons()` | passed by the hook itself `:1166` ✓ |
| Guard on failure (C2 / L2) | failed reload keeps existing guard + banner + retries | `:1146-1158` ✓; `writable = lessonDataLoadedSuccessfully !== false` `app.js:12520` disables planner buttons ✓ |
| Read-only editor | guard added to `openPlanEditor`'s edit decision | `app.js:11515` ✓ |
| Lifecycle (C3 / L3) | two call sites named | tab handler `app.js:218-219`; `setGlobalSemester` CA branch `app.js:132-138`; `caInitialized` early-return `:5016` ✓ |
| Freshness wording (C4 / L7) | "Last full refresh", per year, only on a successful gated install; `source:'server'` | `formatDayOffDate` opts param exists `:2005`; `dayOffServerDocs` precedent `:2114` ✓ |
| `lastEditedAt` raw ISO (L4) | `.slice(0,10)` + `{month:'short',day:'numeric'}` | ✓ (needs `isIsoDate` `:2000` for the "garbage" BDD — the function returns its input unchanged) |
| Counting (C5 / L5) | "distinct (camp, title) pairs" + BDD | `dayOffCampTitles` dedupes within a camp `:2058-2069` ✓ |
| 4th pill (L6) | 'ready' unreachable, stated | `app.js:922-924`, `:937` ✓ |
| XSS (both) | `data-lesson-key` + `this.dataset` | matches existing `app.js:1769`; `escAttr` does not escape `'` `:8149-8151` ✓ |

---

## NEW — HIGH: the refresh installs fresh data but does not redraw the admin list

`summerReloadHook` is set by **`setupLessonDataListener`**, which has **two** callers, not one:
`initTeacherView()` (`app.js:676`) and `initCurriculumAdmin()` (`app.js:5038`). The last call wins — it
replaces `summerReloadHook`, and the hook fires *that* callback (`firebase-data.js:1164-1169`).

The default startup path makes Teacher View the later one:

1. `app.js:187` — `await initCurriculumAdmin()` on load (default tab) → admin callback registered.
2. Planner opens Teacher View once → `initTeacherView()` registers the **teacher** callback (`:676`).
3. Back to Curriculum Admin → `initCurriculumAdmin()` early-returns (`caInitialized`, `:5016`); the hook
   is **not** re-registered.

From then on `refreshDayOffYear()` → hook → data installs correctly, but the callback that runs is the
teacher one, whose SDOC branch is `if (activeTab === 'teacher-view') renderTeacherView(); …; return;`
(`app.js:683-687`) — **nothing renders while Curriculum Admin is showing**. The statuses stay stale while
"Last full refresh 10:42" advances: the exact freshness lie Phase 3 exists to remove. The same gap
swallows the failed-refresh case — "Couldn't refresh…" and the disabled state also arrive only via that
callback. `switchTab('teacher-view')` is also reached automatically (`app.js:110`, `:312`, `:340`).

**Fix:** `refreshDayOffYear()` awaits the hook's outcome and, when it is not `'stale'`, calls
`renderAdminGrid()` itself (idempotent; a duplicate render is harmless) — including on `'failed'`, to paint
the message and the disabled buttons. Do not rely on the hook's callback. Correct the plan's
"Curriculum Admin sets that listener up (app.js:5037)" — both tabs do, and the last one owns it.
Add a BDD: visit Teacher View, return to Curriculum Admin, refresh → the list redraws.

## NEW — MEDIUM: `source:'server'` for *every* SDOC load also changes the startup path

`loadDayOffCampData` has a second caller the plan does not mention: `loadLessonData()`
(`firebase-data.js:775-776`), the initial load — and its catch trips the **app-wide** guard for every
semester (`:783-784`). Forcing `source:'server'` there is the right direction (today an offline query
falls back to cache and returns an *empty* snapshot with writers still enabled — the repo's "data
disappeared" hazard), but it is a behaviour change for **teachers on Teacher View**, not just the
planner's refresh: a reload on flaky wifi now means the red banner and every writer refusing app-wide.

**Fix:** say so explicitly in the plan (it is beyond Phase 3's "read-only, admin-only" framing), and add a
BDD for the initial load failing → banner, never a silent empty SDOC list. Worth Christie's yes.

## NEW — MEDIUM: the guard sentence would make the *summer* editor read-only too

`app.js:11515` is `const canEdit = sdoc ? canEditDayOffPlan(lesson) : true;` — the `: true` is summer,
where "`canEditLesson()` gates each save, as before". Written as `canEdit = … && lessonDataLoadedSuccessfully
!== false`, the guard lands on both branches, changing summer editor behaviour outside this phase's scope.

**Fix:** state it applies inside the `sdoc` branch only — or say the summer change is deliberate.

## LOW (note, no re-review needed)

- The stamp is set only on the gated-reload success path, but `loadLessonData()` (`:775-776`) also installs
  SDOC years — so the header reads blank from first paint until the first server snapshot lands. One clause.
- The `'garbage'` BDD needs `isIsoDate()` (`:2000`); `formatDayOffDate` returns its input unchanged.
- The button is disabled in flight, but the two automatic sites are not de-duped against it.
- The refresh reloads every camp season and every SDOC year (3 forced-server queries each) on each CA entry.

## Re-review scope

The HIGH and the two MEDIUMs are plan-text changes. A round 3 only needs to re-read the Refresh, Failure
and Lifecycle paragraphs plus the new BDDs.
