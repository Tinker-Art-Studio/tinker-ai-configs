## Findings

- **HIGH — A materials-only plan is treated as empty and permanently deleted.**  
  [js/firebase-data.js:1900](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1900), [js/firebase-data.js:2274](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2274)  
  `dayOffPlanHasUserData()` checks `materialsList` but not the persisted `materials` text field included in the plan model. Given a plan containing only `materials: "clay, glaze"`, removing its camp classifies the plan as scaffold-only and batch-deletes both camp and plan. The rename warning is bypassed for the same plan.

- **MEDIUM — The app-wide failed-load guard does not cover appData writers.**  
  [js/firebase-data.js:212](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:212)  
  `updateAppData()` checks `configLoadFailed` and season-registry state, but not `lessonDataLoadedSuccessfully === false`. If an SDOC collection returns permission-denied, the red banner appears, yet creating another SDOC year—and weekly Settings/publish operations—can still write successfully. This contradicts the required “every writer refuses after a failed load” invariant.

- **MEDIUM — Stale event snapshots can bypass the “camp uses this date” guard.**  
  [js/firebase-data.js:2181](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2181)  
  Removed dates are calculated against the editor’s open-state `original`, not the current server event. Example: A opens an event containing Mon/Tue; B adds Wed and a camp using Wed; A changes the date selection and saves Mon only. Wed was absent from A’s `original`, so it is never checked, but the whole dates array overwrites the server event and leaves B’s camp outside its event.

- **MEDIUM — The project-rename warning has the equivalent stale-snapshot bypass.**  
  [js/firebase-data.js:2254](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2254)  
  “Leaving” titles are derived from the editor snapshot. If B adds project “Glaze” and gives its plan content after A opens the camp, then A changes another project/day such that the whole projects map is written, “Glaze” is removed without warning because it was never in A’s snapshot. Its plan remains silently orphaned.

- **MEDIUM — Teacher-pool removal can bypass its usage guard under concurrent Settings edits.**  
  [js/app.js:10897](/Users/christiehubley/tinker-spring-curriculum/js/app.js:10897), [js/app.js:10914](/Users/christiehubley/tinker-spring-curriculum/js/app.js:10914)  
  Removed names are computed from stale `currentConfig`, while the entire `teacherNames` array is written. If B adds Bob and assigns him to a camp after A loaded Settings, A’s next save omits Bob; because Bob was absent from A’s local pool, he is not checked by `dayOffTeachersInUse()`, leaving the camp assigned to a teacher no longer in the year pool.

- **MEDIUM — An unpublished SDOC year can remain selected for a teacher via localStorage.**  
  [js/app.js:58](/Users/christiehubley/tinker-spring-curriculum/js/app.js:58), [js/app.js:65](/Users/christiehubley/tinker-spring-curriculum/js/app.js:65)  
  The selector removes unpublished years from `visibleKeys`, but only resets `globalSemesterKey` when the stored key no longer exists—not when it is invisible. On a shared browser, a manager selects the draft SDOC year and signs out; the next teacher inherits that key and renders the SDOC placeholder despite the year being absent from their dropdown.

- **LOW — SDOC names reach an existing unescaped selector sink.**  
  [js/app.js:79](/Users/christiehubley/tinker-spring-curriculum/js/app.js:79), [js/app.js:4417](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4417)  
  The editable SDOC name is stored verbatim, while the global semester selector interpolates names into `innerHTML` without `escHtml()`. A name such as `</option></select><img src=x onerror=...>` becomes persisted script-capable markup for managers loading the app.

No files were changed and no tests or deploy commands were run.
