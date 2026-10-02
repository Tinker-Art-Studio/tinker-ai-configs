**Verdict: SAFE TO DEPLOY.** No finding below blocks the deploy. None of the write paths can put a new semester key into lessonData, write an own-doc semester outside the 'editable' state, or overwrite existing lessons with a stale copy.

## Findings

1. **LOW, Classbook count has no legacy exclusion.** `js/app.js:7613-7620` adds every `lessons_*` id to `countedFromOwnDoc`, so a stray `lessons_fall-2026` would shadow Fall's lessonData count. Studio Hub filters this at `js/classbook-qa-alerts.js:29-33`. Count only, and Phase 0 found no such document. Fix: skip ids that fail `SEMESTER_KEY_PATTERN` or sit in `LEGACY_LESSONDATA_SEMESTERS` inside the `forEach`.

2. **LOW, "Copy from" an unloaded own-doc source yields zero slots silently.** `js/app.js:5027` uses `currentLessonData[copyFromKey] || {}`. If the source is an own-doc semester in missing/error/unknown state, the roster is copied and no slots are created, with no alert. Copy from Fall 2026 is unaffected. Fix: refuse when the source is own-doc and `ownDocStorageState(copyFromKey) !== 'editable'`.

3. **LOW, shared storage banner is hidden by any semester's snapshot.** `js/firebase-data.js:1665` and `:1616` hide `storage-notice-banner` on any own-doc or legacy snapshot that exists, so Spring 2027's snapshot can hide Spring 2026's "removed elsewhere" banner. The per-semester standing notice and the `weeklyLessonTarget` refusal are unaffected, so no write risk. Fix later: track which semester raised the banner and hide only for that one.

4. **LOW, test gaps against the plan's scenario list.** Not covered: a listener error on one own-doc semester leaving the other editable; the gauge's 85% warning; a true concurrent two-tab slot write. The in-flight test lost its "before release" assertion, but a missing guard still fails the test by hanging. The rewritten data-safety blocks are equivalent or stronger: the orphan pre-check became an in-transaction server read with a byte-for-byte assertion, the compensating-delete tests became a real rules-denied atomicity test, and the roster-slot real-Firestore test now proves existing content survives.

5. **INFO, rollback with unknown migration state keeps the previous legacy copy.** `js/firebase-data.js:1606-1611`: `hasRecord` is false when `storageMigrationState` is null, so the fresh snapshot's copy is discarded. Harmless, since lessonData's spring-2026 key is fenced and both copies are identical.

6. **INFO, deploy-order dependency.** The ratchet at `e2e/new-semester-own-doc.spec.js:216-227` reads rules from `e2e/emulators/config.js:54`, defaulting to the studio-hub main checkout. Classbook main's suite is red until Phase A is merged and that checkout pulled, exactly as the plan states.

## Verified against the real code

- **Write paths.** `createNewSemester` writes only through `createWeeklySemesterStorage` at `js/app.js:5060`. `saveLessonData` has one caller, `restoreFromBackup`, which has none. `addMissingLessonSlots`, `deleteLessonKey`, `saveSingleLesson`, `saveMultipleLessonFields` and the three Q&A writers all route through `weeklyLessonTarget`, which throws unless the state is 'editable' at `js/firebase-data.js:187-188`. `deleteLessonData` refuses own-doc keys at `:1354`.
- **Transaction.** Both reads precede both writes at `:527-535`. Thrown refusals abort without retry; contention retries re-run every check. Refuses absent appData, an existing config key, and an existing document. Post-commit install precedes reconcile at `js/app.js:5072-5075`.
- **Slots.** `addMissingLessonSlots` writes one dotted update of absent keys only at `:1195-1207`, refuses a missing document, and the Settings caller reports a slot failure as "Settings saved, but" at `js/app.js:11479-11486`.
- **State table.** All eight rows match `:136-153`, including vanished and unknown. The button appears only in 'missing' for admin/manager at `:271`, matching the rules' `isManagerOrAbove`. `createOwnDocStorage` re-checks the state and refuses an existing document inside the transaction.
- **Listeners.** Map by key, torn down with the migrations listener at `:1519-1522`, carry-over for every own-doc key at `:1598-1618`, idempotent reconcile, and the rollback branch guarded by the legacy map's presence.
- **Regressions.** Fall's paths are unchanged except the roster slots, which the rules allow as `fall-2026.<key>` updates. Spring 2026 is verified, so editable. Counts use a list query the rules grant to classbook roles and managers.
- **Studio Hub.** Replace semantics, regex plus legacy filtering, first-snapshot degraded handling, last-good-on-error, and the dismissal migration are all as the plan specifies, and the range bounds match the Classbook's.
- **Invariants.** Dotted updates everywhere, every write awaited, no `undefined`. Empty strings reach Firestore only in the two approved places: the create transaction's set on an absent document and the slot transaction's absent keys. The `startDate: ''` in the appData entry is pre-existing behaviour, not new.
