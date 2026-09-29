Read the plan (rev 3), the round-2 review, and verified every claim against the worktree at `2ef2e62`.

## Round-2 blockers

| | Status | Where |
|---|---|---|
| **(a)** header sync on the Settings dropdown | **RESOLVED** | plan:91 — "set `#global-semester-select`'s value *first*, then `setGlobalSemester(value)`", which is exactly `app.js:826-830`. Regression BDD at plan:144-147. |
| **(b)** Phase 2 placement + client ISO `at` | **RESOLVED** | plan:190. Citations are exact: `requireAuth` `app.js:148`, `loadConfig()` `:152`, `initGlobalSemesterSelector()` `:158`; "never inside `initGlobalSemesterSelector`" stated. `String(sw.at)` comparison at plan:190. |
| **(c)** non-managers can reach Settings via the footer | **RESOLVED** | plan:76, 92 (hide `#settings-link` + dot, gate `switchTab`, render for admin/manager only, `makeSemesterActive` refuses), BDD plan:138-142 with "assert not visible, not count 0". |
| **(d)** e2e restore surface | **RESOLVED** | plan:264-267 — manager browser context + `readAppDataFromServer()` read-back, camp scenario stubbed so `summer-2026.published` can't leak, `activeSemesterSwitch` leak given top billing. |
| **(e)** weekly-delete guard | **RESOLVED** | plan:95 + BDD plan:164-173 — `readServerSemesterLessonMap`, corrected text, one modal, three named tests. |

## "Also taken" items
`isPublishableType` before auto-publish — RESOLVED (plan:93). Name fallback in the confirm — RESOLVED (plan:93). Settings options filtered by `canSeeSemester` — RESOLVED (plan:91; today unfiltered at `app.js:10683-10688`, confirmed). Camp-active consequences in the confirm and BDD — RESOLVED (plan:82, 149-151). Stale-seen asymmetry as a decision — RESOLVED (plan:197). Round-2 §3 mechanics (stub-vs-spy payload, `permission-denied` specifically, teacher fresh-context ordering, re-count tests) — RESOLVED (plan:268, 269, 270, 273).

One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.

## New in revision 3 — checked

- **`switchTab('settings')` gating is safe.** The only in-app caller is the footer handler (`app.js:360-363`); every other `switchTab` call is `'teacher-view'` (`:110, :312, :340, :7855`). `e2e/day-off-camps.spec.js:499` clicks `#settings-link` but in the admin context. One implementation detail: the dot has no id and `.footer-dot` matches three spans (`index.html:513, 515, 520`) — hide `.footer-dot.write-control`, which is only `:515`.
- **`confirmModal` in `deleteSemester` — the three tests are the right three.** Weekly path: `data-safety.spec.js:7782`, `:8535`, `:9114`. Camp (`:8493`) and SDOC (`day-off-camps.spec.js:680`) keep `confirm()`, correctly. Not visible in the plan's one line: all three `await deleteSemester(...)` *inside* a single `page.evaluate` that installs and restores its own stubs — a modal that resolves on a click means each must be split (start the evaluate, drive the modal from Playwright, then await). Real work, but mechanical.
- **`readServerSemesterLessonMap` (`firebase-data.js:973-977`)** does a forced-server `get()` of the whole `curriculum/lessonData` doc and returns `null` when the doc *or* the key is absent; it throws only on a read failure. So `null` = 0 lessons and the delete must proceed. The BDD (plan:170) says "rejects", which is right, but plan:95's "a failed read refuses" should say null ≠ failure so a legitimately empty semester isn't blocked.
- **Phase ordering nit:** Phase 1 builds `confirmModal` for delete, yet the activation confirmation stays a plain `confirm()` until Phase 2 adds the checkbox (plan:78 vs plan:183) — so Phase 1's new activation tests get rewritten in Phase 2. Cheaper to use `confirmModal` for the activation in Phase 1 too.
- Citation spot-check (~12): `app.js:148-152/158`, `826-830`, `10918`, `10683-10712`, `index.html:411`, `firebase-data.js:973-977`, `data-safety.spec.js:7778-7790/8537` all exact. (`deleteLessonData` cited as `961-966`, actually `961-965`.)

## Verdict

**EXECUTION-READY.** The four clarifications above are one-liners for the executor, not another review round.
