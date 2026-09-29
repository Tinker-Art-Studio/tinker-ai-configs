## Verdict: CHANGES NEEDED

Reviewed read-only at `2ef2e629cac2d6e8e7ae8ff702a3de3a67e755ca`.

1. **HIGH — Refresh is neither guaranteed server-fresh nor safely ordered against the listener reload.**  
   [plan:620](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:620>), [firebase-data.js:1122](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1122), [firebase-data.js:2125](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2125)  
   `loadDayOffCampData()` uses ordinary `.get()`, not `{ source: 'server' }`, contradicting “re-read from the server.” It also installs `currentDayOffEvents/Camps/Plans` directly. The listener has a generation gate, but the proposed independent refresh does not; an older manual refresh can therefore overwrite a newer listener result. The 2B install sequence protects locally verified plan saves, not one reload from another.  
   **Fix:** route both entry/button refreshes through a shared generation-gated reload coordinator, use forced-server queries for an explicit refresh, capture the previous slot map before reading, and allow only the latest request to install/redraw/update freshness.

2. **HIGH — Failed-refresh load-guard behavior is not implementable as written and risks leaving writes enabled over stale data.**  
   [plan:620](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:620>), [firebase-data.js:1143](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1143), [firebase-data.js:1146](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1146), [firebase-data.js:2120](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2120), [app.js:11515](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11515)  
   The loader itself only throws; the listener wrapper is what sets `lessonDataLoadedSuccessfully=false`, shows the banner, retries, and later heals the guard. A standalone refresh catch would keep old figures but—unless explicitly coordinated—leave writes enabled. Conversely, once the guard is false, `openPlanEditor()` still calculates editable mode without consulting it, although saving later refuses.  
   **Fix:** specify that the latest failed refresh trips the shared guard/banner while retaining the prior display; a later successful refresh clears it. Make the admin editor read-only while guarded. Add a BDD asserting retained figures, unchanged timestamp, guard false, all writes refused, and recovery after a successful refresh.

3. **MEDIUM — “On entry or year switch” needs explicit lifecycle wiring.**  
   [plan:616](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:616>), [app.js:96](/Users/christiehubley/tinker-spring-curriculum/js/app.js:96), [app.js:198](/Users/christiehubley/tinker-spring-curriculum/js/app.js:198), [app.js:5015](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5015)  
   Re-entering Curriculum Admin calls `initCurriculumAdmin()`, which immediately returns after first initialization. Switching semesters currently only redraws. A button-only implementation would satisfy much of P1–P8 while missing both automatic refresh paths.  
   **Fix:** name the two call sites: Curriculum Admin tab activation after initialization, and `setGlobalSemester()` while Curriculum Admin is active. Add separate BDD cases for tab re-entry and switching from a non-SDOC year.

4. **MEDIUM — Freshness wording overstates a mixed-age cache.**  
   [plan:616](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:616>), [plan:621](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:621>), [firebase-data.js:2627](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2627)  
   Opening an editor performs a fresh single-plan read, and listener reloads can also change the cache without advancing the proposed time. “Plan status as of” therefore suggests a coherent snapshot that the page does not retain.  
   **Fix:** label it “Last full refresh …”, store it per year, and advance it only after a successful full-year refresh. Test that editor reads, listener redraws, and failed refreshes do not advance it.

5. **MEDIUM — Counting BDD does not distinguish per-camp identity from title deduplication.**  
   [plan:615](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:615>), [plan:627](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:627>), [firebase-data.js:2058](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2058)  
   `dayOffCampTitles()` correctly deduplicates a title across days within one camp. But two camps with the same title are two different plans and must count twice. The current BDD would not catch an erroneous event-wide title `Set`.  
   **Fix:** add two camps in one event sharing a title; assert two rows/plans and denominator 2, while the same title repeated across days in one camp remains 1.

The unused/no-plan logic and cited line references are correct. The proposed `data-*` key handling plus `sdocEsc/sdocEscA` is XSS-sound, provided the implementation uses a real/delegated listener rather than rebuilding an inline handler.
