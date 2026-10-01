# Round 5 — Verdict: **READY** (no new HIGH/MEDIUM)

**(a) Round-4 findings fixed.** The shared `onLessonDataReload()` is described correctly, the startup race is the last BDD in the block, and `dayOffRefreshFailed` is now set inside the gated reload's own `catch` behind `isCurrent()` — actual gate is firebase-data.js:1148 inside the catch at 1146, so the plan's 1143-1150 is in range. The Decisions Log entry matches the body (no drift, and it correctly labels revision 4's claim as corrected rather than deleting it).

**(b) "Each view's existing per-tick redraw, no new behaviour" — holds.**
- Teacher View's callback body (app.js:677-701) contains exactly **one** tab check — inside the SDOC branch (683). Everything else already runs on every tick while Curriculum Admin is the visible tab. `teacherViewOnReload()` keeps that check, so no SDOC teacher render happens behind the admin tab, and making its `return` helper-local is precisely what stops it skipping the admin redraw.
- Curriculum Admin's callback (5039-5044) already runs `renderAdminGrid()` + `renderHelpQueue()` every tick regardless of tab.
- `getAdminSemKey()` is just `getActiveSemesterKey()` (4141-4143) — no DOM/selector dependency, so an unrendered `ca-semester-select` can't produce a bad semKey.

**(c) Gating is right.**
- `caInitialized` at 5017 precedes the awaits, so the CA branch can draw before CA's own first render. Verified safe: `renderAdminGrid`, `renderDayOffAdmin`, `renderSummerCA` and `renderHelpQueue` reference none of `currentChangeLog` / `currentCutProjects` / `currentFutureProjects`; any transient draw is overwritten at 5025.
- The `tvInitialized = false` reset (669) happens *before* registration (676), so a Teacher View that bailed on the load guard never answers the shared callback.

**Two LOWs for build time, no revision needed:** `tvInitialized` is also true during `await loadLessonData()` (657→661) — reachable only if CA registers first, and it converges via the existing empty-select reset (690-696); and a throw in `teacherViewOnReload()` would now skip the CA redraw, so wrap each branch.

Review written to the plan file.
