1. **MED — Source-neutral header was folded in inconsistently.**  
   Design specifies “23 copied camps · 23 not yet reviewed” (`plan:73`), but Phase 1 BDD still expects “1 camp copied from Summer 2026…” (`plan:94`). This wrongly folds Codex #4 and creates conflicting implementation targets.  
   **Fix:** change `plan:94` to the source-neutral wording; source remains on each card.

2. **MED — The duplicate-name finding was not fully folded into tests.**  
   The design says Lesson Plans must log duplicate curriculum names rather than guess (`plan:75`), addressing Claude #12/Codex #6, but Phase 2 tests omit that case (`plan:113`). An implementation using `Map.set(campTopic, camp)` and silently selecting one duplicate could pass every listed test.  
   **Fix:** add a malformed duplicate-curriculum-name test asserting a warning is logged and no ambiguous badge is assigned.

3. **MED — The 2028 helper reference is inaccurate.**  
   `emulator-admin.js:27-37` can register only hard-coded 2027. `setCurrentSeason()` can move `_current` to an arbitrary value (`emulator-admin.js:39-41`), but it cannot register 2028. Therefore the past-view test promised at `plan:100,105` is not presently constructible through the cited helper alone.  
   **Fix:** plan an explicit generalized `registerSeason(year, …)` helper or `registerSeason2028()` before using `setCurrentSeason('2028')`.

4. **MED — The race test cannot prove the folded-in ordering requirement.**  
   The design requires awaiting `settleCurriculumAutoSave()` and sharing the manual-save lock (`plan:66`), but the BDD asks for an autosave landing *after* Mark and merely checks that `reviewedAt` survives (`plan:98`). That passes without synchronization because autosave is already a partial update that never touches review fields (`app.js:9235-9240`). It also does not verify the review button joins the disable list at `app.js:396`.  
   **Fix:** use a deferred autosave and assert the review write does not begin until it resolves; separately assert the button is disabled during manual Save and its handler is inert while `curriculumManualSaving`.

5. **MED — Role and past-season tests can pass without the planned client guards.**  
   “Direct handler invocation writes nothing” (`plan:99`) can succeed solely because Firestore rejects staff/prep updates (`firestore.rules:827-830`), even if the handler omits `canReviewCamp()`. Likewise, the past-view button can be absent through conditional rendering while its selector is missing from `PAST_SEASON_HIDE` (`app.js:5634-5661`).  
   **Fix:** spy on `Season.writeRef` and assert zero invocation for unauthorized roles; add a structural assertion covering the new selector in `PAST_SEASON_HIDE`.

Claude #4 is correctly rejected: `firestore.rules:827-830` has manager-only create/update/delete and no field allow-list. All other cited code references are accurate: `canManageSchedule` (`app.js:4009`), autosave state/settling (`353,361`), save disable list (`396`), past-season list (`5634`), and `window.CURRICULUM_CAMPS` (`160,7657`).

not execution-ready: conflicting header BDD, missing duplicate coverage, nonexistent 2028 registration helper, and tests that do not prove the required client-side guards or save ordering.
