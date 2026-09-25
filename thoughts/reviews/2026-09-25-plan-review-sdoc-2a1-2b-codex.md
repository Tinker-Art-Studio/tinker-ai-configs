## Verdicts

- Phase 2A.1 — **CHANGES NEEDED**
- Phase 2B — **CHANGES NEEDED**
- Sep 25 Decisions Log/model alignment — **CHANGES NEEDED**

The core transaction strategy is sound, but several safety and state-management requirements need to be explicit before execution.

1. **HIGH — Day-off payload allow-list is incomplete**

   **Plan:** Phase 2B lines 293–299 allow-lists the payload, but says nothing about allow-listing `fieldsToClear`.

   **Evidence:** `saveSingleLesson()` accepts arbitrary clear names and turns them into `FieldValue.delete()` ([firebase-data.js:1342](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1342), [firebase-data.js:1393](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1393)). Consequently an SDOC caller could delete `materialItems`, `materialChecks`, or identity fields despite filtering `lessonData`.

   **Fix:** Define separate SDOC writable and clearable sets. Reject/drop every payload and clear-list field outside the content/photo/plan-complete set. Identity must always override caller values after sanitization.

2. **HIGH — The transaction does not re-check that the teacher remains assigned**

   **Plan:** The transaction only re-checks that the camp still contains the title; editing is described as planners plus the camp’s teachers.

   **Evidence:** Current authorization is entirely cached UI state ([app.js:564](/Users/christiehubley/tinker-spring-curriculum/js/app.js:564)); rules allow every `classbook` user to update every SDOC plan ([firestore.rules:699](/Users/christiehubley/studio-hub/firestore.rules:699)). If a planner removes a teacher while their editor is open, the proposed transaction would still save because the title remains.

   **Fix:** Inside the transaction, after reading the camp, require either `canPlanDayOffCamps()` or that the fresh `camp.teachers` contains the authenticated user’s canonical teacher name. Add a removed-teacher-while-open scenario.

3. **HIGH — “Forced read-back” currently does not verify most SDOC writes**

   **Plan:** Line 299 says to reuse `verifySummerLessonWrite()` and install its read-back.

   **Evidence:** The helper returns nothing and checks only non-empty `CONTENT_FIELDS` ([firebase-data.js:1319](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1319)). It does not verify identity, `planComplete`, photos, or clears. The current summer branch only calls it when a content field was written ([firebase-data.js:1408](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1408)).

   **Fix:** Specify a verifier that always returns the server document and checks every written value plus absence of every cleared field. Use that returned document for `currentDayOffPlans`. Photo removal should use explicit deletes; otherwise empty `photoUrl`/`photoPath` survive because current stripping only covers content fields ([firebase-data.js:1388](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1388)).

4. **MEDIUM — Canonical key/year validation is underspecified**

   **Plan:** Identity is stamped from the camp, but it does not say how `campId` and `projectTitle` are safely obtained from `lessonKey`.

   **Evidence:** Keys are composed with `|||`, while project titles are not forbidden from containing that delimiter ([firebase-data.js:2003](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2003), [firebase-data.js:2175](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2175)). `dayOffAssertCampHasTitle()` does not check `camp.yearKey` ([firebase-data.js:2536](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2536)).

   **Fix:** Do not naïvely `split('|||')`. Extract the known year prefix and first following delimiter, then require `lessonKey === dayOffLessonKey(yearKey, campId, title)` and `camp.yearKey === yearKey`. Explicitly reject `#signoff`.

5. **MEDIUM — Phase 2A.1 needs captured context and stale-open protection**

   **Plan:** `markDayOffCampComplete()` only gains `onDone`; project reads run in parallel with per-section errors.

   **Evidence:** The current function derives the year from the mutable global selector ([app.js:12769](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12769)). The existing project modal also assigns through global modal state after an await without confirming it is still the same view ([app.js:12601](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12601)). Switching semester/modal while reads are pending can update the wrong UI.

   **Fix:** Pass explicit `{yearKey, campId}` to sign-off operations; capture a local view token and check identity after every await. Require `Promise.allSettled`, not rejecting `Promise.all`, to deliver the promised per-project error isolation.

6. **MEDIUM — Teacher View listener behavior is not covered**

   **Plan:** Line 324 says the existing listener “re-renders SDOC as it does summer.”

   **Evidence:** It only reinitializes an admin when a nonempty slot map appears and only re-renders when `tvCurrentTeacher` or summer `sharedWith` state exists ([app.js:619](/Users/christiehubley/tinker-spring-curriculum/js/app.js:619)). SDOC currently returns before building any teacher picker ([app.js:647](/Users/christiehubley/tinker-spring-curriculum/js/app.js:647)). A newly assigned teacher or a camp containing only empty blocks can remain invisible.

   **Fix:** Add an explicit SDOC listener branch that rebuilds names from `currentDayOffCamps`, re-runs canonical-name selection, and renders the no-camp/empty-block state regardless of slot count.

7. **MEDIUM — The editor split table misses summer-specific behavior**

   **Plan:** Lines 304–316 call the split behavior-preserving.

   **Evidence:** The shared body also contains `markQaAsRead()` ([app.js:11191](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11191)), summer Q&A loading/writers ([app.js:11342](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11342)), the Print button and `printProject()` ([app.js:11842](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11842)), and summer reload/displaced-copy handling ([app.js:11609](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11609)). The table mentions Q&A but not read marks, Print, reference fields, or intentional reuse of reload recovery.

   **Fix:** Expand the table: summer-only read marking/Q&A/Print/reference data; SDOC omits them. State explicitly that save chains and displaced-copy recovery remain shared. Add summer open/save/photo/Q&A/close-wait regression tests, not merely “suite stays green.”

8. **MEDIUM — Read-only and repeated-title controls need explicit handling**

   **Plan:** Read-only is described mainly for the modal; the list always describes a Plan Complete checkbox.

   **Evidence:** The deployed rules will accept a write from prep or an unassigned classbook teacher. Also, a repeated title produces multiple rows with one `data-lesson-key`; the existing summer logic updates only the first matching checkbox via `querySelector()` ([app.js:2106](/Users/christiehubley/tinker-spring-curriculum/js/app.js:2106)).

   **Fix:** Render Plan Complete as noninteractive unless `canEditDayOffPlan(slot)` succeeds. Update/revert all controls matching the lesson key or rerender the SDOC view after settlement.

9. **LOW — The seven `lessonStoreFor()` callers are correctly inventoried**

   **Plan:** Line 293 identifies the target plus six other callers.

   **Evidence:** There are exactly seven call sites: three in `firebase-data.js` and four in `app.js`. Today each non-target caller relies on the third type throwing; once `'dayOff'` is returned, its `else` path would be weekly.

   **Fix:** Keep the proposed refusal BDD, but implement explicit exhaustive switches—never `if camp, else weekly`. No additional caller was found.

10. **LOW — Decisions Log/model contradict Phase 2B**

   **Plan:** The Sep 25 log says the wipe tally “adds” SDOC; Phase 2B line 327 and line 380 defer it. The model still says SDOC `materialsList` is teacher-edited and requires extending kept fields.

   **Evidence:** The actual tally is summer plus weekly only ([app.js:7257](/Users/christiehubley/tinker-spring-curriculum/js/app.js:7257)); Phase 2A now uses `materialItems` ([firebase-data.js:1897](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1897)).

   **Fix:** Choose and record one wipe-monitor decision, and remove the obsolete model statement about teacher-edited `materialsList`.

The rename/save, tick/save, and sign-off/save transactions are otherwise compatible with Firebase 10.8 compat transactions and leave no lost-update race on their shared documents. Publish gating is fully inventoried: the publishable-type set, two UI branches, and `toggleSemesterPublish()` refusal are the only SDOC-specific blockers found.
