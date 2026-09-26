Verdict: **CHANGES NEEDED**

1. **MEDIUM — Photo fields can be cleared independently, corrupting the URL/path pair.**  
   [js/firebase-data.js:2637](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2637)  
   Pair validation only examines values in `lessonData`. A caller can pass `fieldsToClear: ['photoPath']` or `['photoUrl']`; both fields are individually allow-listed and the transaction will delete only one. Clearing only `photoPath` leaves a displayed photo whose Storage object can never be cleaned up; clearing only `photoUrl` leaves an invisible dangling path.  
   **Fix:** require `photoUrl` and `photoPath` to be changed together across the union of payload keys and clear keys. Reject one-sided payloads or clears before the transaction. Add a test for each one-sided clear.

2. **MEDIUM — Teacher View semester switching is not correctly wired and can leave stale SDOC/weekly content.**  
   [js/app.js:650](/Users/christiehubley/tinker-spring-curriculum/js/app.js:650), [js/app.js:819](/Users/christiehubley/tinker-spring-curriculum/js/app.js:819)  
   `tvInitialized` now remains true, so returning to Teacher View after changing the global semester on another tab makes `initTeacherView()` return without refreshing. Separately, the visible Teacher View semester selector assigns `tvCurrentSemester`, which nothing reads, then builds the picker from `getTvSemKey()`—still the global semester. Selecting SDOC there therefore does not switch to SDOC at all. This misses the design’s explicit SDOC semester-change branch and makes SDOC ↔ weekly/summer transitions unreliable.  
   **Fix:** have the Teacher View selector call `setGlobalSemester(select.value)`, and when an already-initialized Teacher View is re-entered, refresh its semester selector, picker, controls, and content for `getTvSemKey()`. Add transitions in both directions, including changing semester while another tab is active.

3. **MEDIUM — “No SDOC Q&A” is not enforced in the Teacher View activity panel.**  
   [js/app.js:1252](/Users/christiehubley/tinker-spring-curriculum/js/app.js:1252), [js/app.js:1587](/Users/christiehubley/tinker-spring-curriculum/js/app.js:1587)  
   The SDOC renderer clears the progress dashboard but not `#tv-qa-activity`. `setGlobalSemester()` calls `renderQaActivityPanel()` before the SDOC render, and that function has no SDOC refusal. A one-teacher SDOC plan containing a legacy or directly written `qaThread` matches `lesson.teacher` and renders a Q&A card, contrary to the design.  
   **Fix:** make `renderQaActivityPanel()` immediately clear and return for `isDayOffYear(semKey)`, and pin this with a legacy-`qaThread` test.

4. **MEDIUM — T1–T17 leave several reviewed safety behaviors unpinned, and T14 overstates its coverage.**  
   [e2e/day-off-teacher.spec.js:375](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-teacher.spec.js:375), [e2e/day-off-teacher.spec.js:466](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-teacher.spec.js:466), [e2e/day-off-teacher.spec.js:498](/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-teacher.spec.js:498)  
   T14 says “six other lesson writers” but exercises only `lessonStoreFor`, `saveLessonData`, `saveMultipleLessonFields`, and `adminLessonStillExistsWithRetry`; it does not call `sendTeacherQaMessage`, `sendHelpResponse`, or `sendQaReply`. The suite also omits the designed failed-photo-save ordering, sign-off byte-identity, concurrent material-tick/reload case, photo-replacement/clear `savedSince` races, frozen-clock edit IDs, hostile teacher names, and SDOC ↔ summer/weekly transitions. T16 covers stale text but not preservation of a concurrent tick. A broken implementation in these areas would pass T1–T17.  
   **Fix:** add those targeted cases, especially the three actual Q&A entry points, failed photo save, tick-plus-save race, and transition tests. The reviewed design also required explicit summer split-regression coverage; existing tests exercise many pieces independently, but no new end-to-end split guard was added.

No HIGH-severity write-path flaw was found: the compat transaction ordering, camp-lock rename protection, payload allow-list, edit-id read-back, identity stamping, and normal verified-save reload protection are otherwise sound. Static syntax checks and `git diff --check` passed; the emulator suite was not run in this read-only review.
