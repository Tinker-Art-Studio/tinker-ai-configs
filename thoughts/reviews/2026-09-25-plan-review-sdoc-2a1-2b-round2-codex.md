## Verdicts

- Phase 2A.1: **READY**
- Phase 2B: **CHANGES NEEDED**

Round 1 coverage: the plan correctly incorporates every 2A.1 finding. For 2B, the listener/editor/table/verifier/allow-list/race/repeated-checkbox/regression-test findings are present, but two fixes remain incomplete in executable detail: routing the SDOC reference into `saveSingleLesson()`, and photo removal through the clear path.

## Findings

1. **HIGH — SDOC save routing references an undefined `ref`**

   **Plan text:** `saveSingleLesson()` calls `saveDayOffPlan(semesterKey, lessonKey, ref, lessonData, fieldsToClear)` before `lessonStoreFor()`, while item 4 says the caller supplies `{ yearKey, campId, projectTitle }`.

   **Code evidence:** `saveSingleLesson()` currently has only four parameters and no `ref` local ([firebase-data.js:1357](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1357)). The shared editor calls it with those four arguments ([app.js:11595](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11595)); Plan Complete callers similarly provide no SDOC reference ([app.js:2119](/Users/christiehubley/tinker-spring-curriculum/js/app.js:2119)).

   **Fix:** Specify the complete API, e.g. `saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear, dayOffRef)`, require `dayOffRef` for an SDOC, and have both the editor and Plan Complete handler pass the slot-derived triple. Keep the canonical-key equality check. Add a BDD that invokes the real UI call path, not only `saveDayOffPlan()` directly.

2. **MEDIUM — Shared-editor photo removal does not use the promised clear mechanism**

   **Plan text:** Photo removal is “an explicit clear of both photo fields”; clearable includes `photoUrl`/`photoPath`; the summer save chain remains shared.

   **Code evidence:** The summer editor represents removal by putting `photoUrl: ''` and `photoPath: ''` in the payload ([app.js:11551](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11551), [app.js:11572](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11572)); it does not add them to `fieldsToClear`, which is derived only from content fields ([app.js:11525](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11525)). A merge therefore stores empty strings rather than removing the fields.

   **Fix:** For SDOC, append both photo fields to `fieldsToClear` on removal and omit them from the written payload—or have `saveDayOffPlan()` explicitly translate paired empty photo values into deletes. Add a successful photo-removal BDD asserting both Firestore fields are absent and the old Storage object is deleted only after verified save.

3. **MEDIUM — The edit/re-check predicate omits the teacher’s required `classbook` access**

   **Plan text:** `canEditDayOffPlan(slot) = canTickDayOffMaterials() or slot.teachers includes my name`; the transaction repeats that test.

   **Code evidence:** Rules permit an ordinary teacher write only through `hasAppAccess('classbook')` ([firestore.rules:699](</Users/christiehubley/studio-hub/firestore.rules:699>)). The proposed teacher-name arm has no equivalent access check. Consequently a `curriculum-admin` user without `classbook`, whose resolved name happens to be assigned, receives an editor and passes the client transaction check before Firestore rejects the write—contradicting the read-only acceptance test.

   **Fix:** Use `canTickDayOffMaterials() || (has classbook && freshCamp.teachers.includes(canonicalName))` in both UI and transaction authorization. Make the existing no-classbook BDD assign that user’s resolved name to the camp.

4. **MEDIUM — First-name fuzzy matching is unsafe for authorization**

   **Plan text:** The separate resolver falls back to first-name matching, and its result controls both the editor and in-transaction authorization.

   **Code evidence:** The existing algorithm returns the first matching first name without checking uniqueness ([app.js:553](/Users/christiehubley/tinker-spring-curriculum/js/app.js:553)). Two teachers named “Alex” could therefore resolve one account to the other and authorize the wrong camp. Broad collection rules would accept the resulting write ([firestore.rules:700](</Users/christiehubley/studio-hub/firestore.rules:700>)).

   **Fix:** Accept mapping or exact full-name matches; permit first-name fallback only when exactly one candidate has that first name. Otherwise return `null`. Add a duplicate-first-name BDD.

The rename/read-back case is otherwise sound: the camp document acts as the transaction lock, and a rename after commit carries the saved fields before deleting the old document. Kathy/Allie’s intended path also works when using their actual `classbook + curriculum-admin` access; `canTickDayOffMaterials()` correctly bypasses teacher-name resolution for them.
