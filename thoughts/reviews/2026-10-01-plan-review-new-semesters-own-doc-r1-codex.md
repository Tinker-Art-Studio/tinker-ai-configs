# Verdict: NOT READY

The storage model and general rules direction are sound, but the proposed create/delete sequencing still permits inconsistent state and a delete-time data-loss race.

1. **Blocker — semester creation should be one atomic transaction.**  
   **Evidence:** Plan separates target-document creation from the `appData` update ([plan:71](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:71)). The current non-atomic implementation already needs compensation because lesson data is written before config ([app.js:4986](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4986), [app.js:5070](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5070), [app.js:5080](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5080)).  
   **Fix:** In one transaction, read `appData` and `lessons_<key>`, validate both, `tx.set()` the newly created lesson document or update/adopt the existing allowed document, and `tx.update()` only `semesters.<key>` plus stamps. Rules can validate the resulting membership with `getAfter(appData)`. This removes compensation, crash-created orphans, and the same-name race.

2. **Blocker — routed delete can erase edits newer than its JSON backup.**  
   **Evidence:** The plan reads/downloads the document, removes config, then deletes the document ([plan:74](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:74), [plan:170](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:170)). Own-document updates are not gated on semester membership ([plan:73](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:73)). A stale teacher tab can therefore write after the backup read but before the delete; that edit is absent from the download and then erased.  
   **Fix:** Cut routed delete from the Oct. 5 release and retain today’s refusal ([app.js:4619](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4619)). Design it later as a two-phase operation: atomically mark the semester deleting; rules refuse all lesson updates while marked; obtain/download the server snapshot; then atomically remove `appData.semesters.<key>` and the lesson document. Clear the marker if snapshot/download fails.

3. **Major — the proposed create and delete rules should use `appData` membership symmetrically.**  
   **Evidence:** Delete checks `getAfter(appData)`, but update checks only migration status ([plan:73](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:73)). This leaves orphan documents editable and creates the delete race above.  
   **Fix:** Require `getAfter(appData).data.semesters` to contain `semKey` for every normal `lessons_*` create/update, and require it not to contain the key for delete. Perform create/config and delete/config atomically. `getAfter()` is expressly intended for enforcing related transaction/batch writes ([Firebase](https://firebase.google.com/docs/firestore/security/rules-conditions)).

4. **Major — “seed unchanged” contradicts the new source-selection rule.**  
   **Evidence:** The plan says an own-doc semester without a migration record and without its document is `missing`, with legacy fallback only for migration records ([plan:132](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:132)), but also says the default seed stays unchanged ([plan:140](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:140)). The seed has Spring solely inside `lessonData` ([curriculum.json:59](/Users/christiehubley/tinker-spring-curriculum/e2e/fixtures/seed/curriculum.json:59)); `resetStorageMove()` deliberately restores that obsolete shape ([storage-move.js:32](/Users/christiehubley/tinker-spring-curriculum/e2e/helpers/storage-move.js:32)).  
   **Fix:** Make the base seed production-shaped: `lessons_spring-2026`, no Spring key in `lessonData`, and `storageMigrations.spring-2026.verified=true`. Give migration tests an explicit `stageLegacySpring()` fixture and restore the new baseline afterward.

5. **Major — the empty-field safety claim is false.**  
   **Evidence:** The plan says copied slots remain today’s templates and that no empty fields are written ([plan:214](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:214)). Today’s template writes numerous empty strings and an empty array ([app.js:5038](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5038)); roster slot creation does likewise ([app.js:11548](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11548)). This conflicts with the stated non-negotiable “strip undefined/empty” constraint.  
   **Fix:** Define one sanitized minimal slot builder and use it in both paths. Keep only required identity fields and meaningful defaults; omit `''`, empty arrays, and undefined optional fields.

6. **Major — migration-gate behavior is underspecified and under-tested.**  
   **Evidence:** Tests cover a missing semester record, one false record, and Spring’s true record ([plan:113](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:113)). They do not cover an absent `storageMigrations` document, malformed/non-map records, missing `verified`, or attempted reversal of Spring verification. Current Spring safety is literal and one-way in `firestore.rules` origin/main:675–677 and 752–772.  
   **Fix:** Specify: absent document or absent semester key means born-own-doc and allowed; any present record must be a map with `verified == true`, otherwise deny. Preserve the current Spring one-way verification tests. Do not claim Phase A safely supports Fall verification unless `storageMigrations` transition validation is also generalized; unchanged current rules validate only Spring.

7. **Minor — the top-level-key fence is correct in principle, but the shown syntax needs tightening.**  
   **Evidence:** The added-key expression at [plan:103](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:103) has the right semantics: existing unexpected keys may change or disappear, while a removed unexpected key cannot later be re-added. `difference()` and `hasOnly()` support this ([Firebase Set reference](https://firebase.google.com/docs/reference/rules/rules.Set)). `LEGACY + meta`, however, is not a safe concrete list-composition form.  
   **Fix:** Return one literal list from a helper, or use `.concat()`, e.g. `legacyLessonDataKeys().concat(['lastUpdated','lastUpdatedBy','qaData'])`. Test a single update that adds both one allowed and one forbidden key, and confirm it is denied. Create must use `request.resource.data.keys().hasOnly(...)`; update uses final-key set difference.

8. **Minor — regex extraction is implementable; folding Spring is conditionally safe.**  
   **Evidence:** Whole-string `matches()` and regex `replace()` are supported ([Firebase String reference](https://firebase.google.com/docs/reference/rules/rules.String)). The current ordinary-doc grants are correctly excluded only for the three literal storage docs in `firestore.rules` origin/main:672–750.  
   **Fix:** The proposed `isLessonsDoc()` exclusion is safe provided every generic create/update/delete branch is tested and the current `storageMigrations` one-way guarantees remain. Add tests for empty suffix, uppercase, underscore in suffix, and a valid longest expected slug.

9. **Major — arbitrary listener lifecycle needs explicit ownership and multi-document tests.**  
   **Evidence:** Current listener teardown is an unkeyed array and every legacy snapshot carries a literal list ([firebase-data.js:1332](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1332), [firebase-data.js:1410](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1410), [firebase-data.js:1435](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1435)). The plan merely says creation starts another listener ([plan:75](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:75)).  
   **Fix:** Use `Map<semKey, unsubscribe>` and a reconcile function that starts missing listeners and stops removed ones. Test at least Spring 2026 plus Spring 2027 simultaneously: legacy snapshots preserve both; one listener error affects only its semester; deletion/reconfiguration unsubscribes it; repeated setup creates no duplicates.

10. **Major — the Studio Hub range listener must replace, filter, and prune its source set.**  
    **Evidence:** Current code knows an exact expected list and does not rebuild until every source responds (`alerts.js` origin/main:570–664). A range query also returns invalid ordinary documents such as `lessons_X Y`, which the rules intentionally leave ordinary ([plan:120](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:120)).  
    **Fix:** On every query snapshot, replace—not merge—the entire `ownDocs` map; accept only IDs matching the same `^lessons_[a-z0-9-]+$`; rebuild after the query’s initial snapshot; retain the last complete map on listener error. Test document addition, modification, deletion, invalid IDs, initial query failure, dismissal compatibility, and that deleting a source removes its alert.

11. **Minor — the config-fallback premise is outdated.**  
    **Evidence:** The plan says permission errors silently fall back to defaults ([plan:79](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:79), [plan:207](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:207)). Current code instead sets `configLoadFailed`, nulls config, disables lesson writes, and displays a rules-specific red banner ([firebase-data.js:285](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:285), [firebase-data.js:305](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:305)); startup stops immediately ([app.js:151](/Users/christiehubley/tinker-spring-curriculum/js/app.js:151)).  
    **Fix:** Record this as historical rationale, not current behavior. Add a regression scenario proving a denied `appData` read starts no own-document listeners and permits no writes.

12. **Major — Oct. 5 is achievable only with reduced scope.**  
    **Evidence:** Phase B currently bundles atomic storage creation, all routing/listener work, destructive delete, two apps, two deployments, and broad test changes ([plan:127](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:127)).  
    **Fix:** Ship by Oct. 5 only:

    - Phase 0 inventory.
    - Generic rules fence and create/update behavior.
    - Atomic own-document semester creation.
    - Missing-state/read/write/listener/count/gauge support.
    - Production-shaped fixtures and full emulator tests.
    - Studio Hub range alerts before Spring 2027 is published.

    Keep own-document deletion disabled and defer its two-phase design. This preserves every historical semester and leaves future cross-semester search straightforward: query valid `lessons_*` documents, merge the explicit legacy keys, and use `appData.semesters` only for metadata—not as the sole discovery index.

No production, deploy, credential, or file-write operations were performed.
