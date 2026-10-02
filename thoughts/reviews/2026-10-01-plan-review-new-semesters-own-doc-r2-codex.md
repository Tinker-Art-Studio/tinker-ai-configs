# Verdict: NOT READY

Revision 2 resolves most round-1 findings, but two data-loss/test-order blockers and four major correctness gaps remain.

1. **Blocker — the B1 → Phase A deploy → B2 order cannot produce the promised green suite.**

   **Evidence:** The plan says B1 alone precedes Phase A deployment ([plan:146](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:146), [plan:270](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:270)). B1 moves the test semester to an own document, but until B2 the app recognizes only literal Spring 2026 as own-doc ([firebase-data.js:85](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:85)). Its writers therefore still target `lessonData`, where Phase A denies the new key. This contradicts the “both suites green together” requirement at plan:140.

   **Fix:** Build and test B1+B2 together against the Phase A rules branch before deploying either. Then deploy Phase A first and the already-green Classbook build immediately afterward. Update the resume order accordingly.

2. **Blocker — no-copy adoption can overwrite the exact real lessons it is meant to preserve.**

   **Evidence:** The transaction adopts an existing real-content document on the no-copy path, then `tx.set`s “stamp only” ([plan:68](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:68)). A `set` without merge replaces the document. The safety section does not unambiguously require merge for this branch ([plan:252](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:252)). Today’s adoption path intentionally writes nothing to the surviving lessons ([app.js:5009](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5009)).

   **Fix:** Specify three distinct branches:

   - Absent target: `tx.set(full new document)`.
   - Template-empty target with Copy from: intentional replacement, explicitly defined and tested.
   - Existing target adopted without Copy from: no lesson-document write, or stamp-only `tx.set(..., {merge:true})`.

   Add a byte-for-byte preservation test for real adopted lessons.

3. **Major — the new `lessonData` fence breaks Spring’s unchanged rollback rules.**

   **Evidence:** Every existing Spring update branch is to be ANDed with `noNewLessonDataKeys()` ([plan:106](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:106)), but Spring is absent from the allowed-new-key list ([plan:93](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:93)). Consequently, `springKeyRolledBack()` cannot re-add Spring, contradicting both “literal rules unchanged” and “every existing Spring-fence test passing” ([plan:70](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:70), [plan:120](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:120); `origin/main:firestore.rules:689-695`).

   **Fix:** Apply the added-key fence to normal/removed-key branches, but leave the tightly constrained `springKeyRolledBack()` branch separate. Its existing `affectedKeys().hasOnly(['spring-2026'])` condition already prevents unrelated additions. The set-difference expression itself is otherwise correct. [Firebase Set semantics](https://firebase.google.com/docs/reference/rules/rules.Set).

4. **Major — the “missing” state needs a complete migration-state table.**

   **Evidence:** The plan says any migration record permits legacy fallback and no record means missing ([plan:67](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:67), [plan:155](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:155)). It does not distinguish absent, verified, unverified, malformed, or unreadable migration state. Current migration-read failure is represented as `{}` ([firebase-data.js:903](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:903)); under the new semantics that can be mistaken for “born own-doc.” A verified semester whose target disappears must not become deletable config-only or silently show a stale legacy copy.

   **Fix:** Specify and test:

   - Target exists + no record: writable born-own-doc.
   - Target exists + verified record: writable.
   - Target exists + unverified/malformed/unreadable record: paused.
   - Target absent + unverified record + confirmed legacy map: paused legacy rollback state.
   - Target absent + no record: `missing`, config-only remedy permitted.
   - Target absent + verified/malformed/unreadable record: data-loss/error state; preserve config and restore from backup.

   Reconcile again when migration state arrives, and never map a migration read error to “record absent.”

5. **Major — the rejected update-membership finding still holds.**

   **Evidence:** Generic updates check only role and migration state ([plan:109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:109)). The Decisions Log claims no path can leave an editable orphan ([plan:289](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:289)), but manager clients may update `appData` directly under the current rules (`origin/main:firestore.rules:698-700`). Removing a config entry therefore leaves an unselectable document that stale teacher tabs may continue editing.

   **Fix:** Require `semesterInConfigAfter(k)` on normal generic updates as well as creates. Accept the additional rules read, or explicitly document the orphan-edit risk and add a separate rule preventing removal of an own-doc config entry. `getAfter()` is designed for enforcing related atomic state. [Firebase transaction-rule documentation](https://firebase.google.com/docs/firestore/manage-data/transactions#data_validation_for_atomic_operations).

6. **Major — the empty-slot rationale conflicts with the stated non-negotiable constraint.**

   **Evidence:** Revision 2 deliberately keeps empty strings and arrays ([plan:253](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:253), [plan:290](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:290)). Both current builders write many such values ([app.js:5038](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5038), [app.js:11550](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11550)). The current review constraints explicitly require stripping undefined/empty fields; “existing schema” does not satisfy that invariant.

   **Fix:** Use one minimal slot builder containing identity fields and meaningful defaults only. If Christie intends to override the invariant for slot-schema defaults, record that as an explicit exception to the Firebase safety policy rather than claiming compliance.

7. **Minor — add tests for the new failure-sensitive branches.**

   **Evidence:** The BDD list lacks explicit coverage for the defects above and does not test listener removal or the new legacy roster-slot transaction ([plan:175](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:175), [plan:185](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:185)).

   **Fix:** Add tests for:

   - Adopted real document remains byte-for-byte unchanged.
   - Spring rollback remains allowed while unrelated added keys remain denied.
   - Migration listener/read failure stays paused.
   - Verified target disappearance preserves config.
   - Reconcile unsubscribes a removed missing semester.
   - Targeted roster-slot creation for both Fall legacy storage and own-doc storage.
   - Concurrent slot creation never overwrites either tab’s slot.
   - Missing `appData` causes an explicit create refusal.
   - If update membership is adopted, config-absent own-doc updates are denied.

With findings 1–6 fixed, the Oct. 5 target remains plausible: keep own-doc deletion deferred, prepare B1+B2 before the rules deployment, and let Studio Hub alerts trail until immediately before teacher publication. The generic regex, `replace`, guarded migration expression, delete/undo branch, range listener design, parallel loading, and future cross-semester search direction are otherwise sound.

Reviewed the current on-disk plan (`SHA-256 704844…557e`); it changed during review to add the targeted roster-slot transaction. No files, deployments, credentials, or production data were touched.
