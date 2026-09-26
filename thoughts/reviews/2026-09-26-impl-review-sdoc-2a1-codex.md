## Verdict: CHANGES NEEDED

1. **MEDIUM — sign-off flow lacks the required view-token checks after awaits.**  
   [js/app.js:12793](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12793), [js/app.js:12799](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12799)  
   Closing/reopening the checklist or switching semesters while `markDayOffCampComplete()` refreshes plans does not stop the old action from showing a confirmation and writing a sign-off. After the sign-off await, it also unconditionally redraws the current grid. The wrapper’s token check only runs later in `onDone`.  
   **Fix:** accept an `isCurrent` callback/token in `markDayOffCampComplete`; check it after every plan read, before initiating the sign-off write, and after the sign-off await before any alert/render/callback. Preserve unconditional behavior for existing card callers.

2. **MEDIUM — checklist sign-off controls can use stale state instead of the freshly loaded view.**  
   [js/app.js:12831](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12831), [js/app.js:12901](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12901)  
   Plans are captured in `view.plans`, but sign-offs and camp totals are rendered from the mutable global caches. If `refreshDayOffSignoff()` fails, the prior cached sign-off remains and the modal can show both an error and a stale “Materials complete” badge. Overlapping close/reopen reads can likewise let an older refresh overwrite the global value used by the newer view. A background reload can also make the sign-off’s unticked count disagree with the rows/count rendered from `view.plans`.  
   **Fix:** store each sign-off result—or an error sentinel—in the view and derive each camp summary from `view.plans`. Suppress sign-off controls when their required fresh reads failed. Refresh those view-local values after sign-off.

3. **LOW — M16–M21 do not exercise the lifecycle and stale-state claims above.**  
   [e2e/day-off-materials.spec.js:477](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-materials.spec.js:477), [e2e/day-off-materials.spec.js:528](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-materials.spec.js:528), [e2e/day-off-materials.spec.js:563](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-materials.spec.js:563)  
   There is no delayed-read test for close/reopen, semester switching, or sign-off during closure; M20 fails only a plan read, not sign-off refresh; and M19 does not spy on sign-off writes to prove no camp write occurs. M17’s two items have different generated IDs, so an implementation still keyed only by `itemId` would pass.  
   **Fix:** add deterministic delayed-read lifecycle tests, a failing sign-off-refresh case with stale cached completion, write spying around complete/Undo, and two project records sharing the same valid item ID to pin the composite pending key.
