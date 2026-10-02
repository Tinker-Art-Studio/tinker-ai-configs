# Verdict: NOT READY

Revision 3 fixes the other round-2 findings, but three real gaps remain.

1. **Blocker — the appData-absent create branch replaces the usable defaults with a partial configuration.**

   **Evidence:** The transaction merge-creates only `semesters.<newKey>` and stamps ([plan:68](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:68)). When `appData` is absent, the app currently uses defaults containing Spring 2026 ([firebase-data.js:305](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:305), [firebase-data.js:639](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:639)). After that partial document is created, reload uses it instead of the defaults, so Spring 2026 disappears from the semester selectors ([firebase-data.js:310](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:310), [app.js:10823](/Users/christiehubley/tinker-spring-curriculum/js/app.js:10823)). This violates the all-past-semesters requirement.

   **Fix:** If the transaction finds `appData` absent, refuse creation and require restoring/initializing the configuration from a verified source. Make the BDD expectation deterministic—remove “writes … or refuses”—and assert that neither document is created.

2. **Major — the second refusal of Codex r2-5 overlooks a real stale-app deletion path.**

   **Evidence:** The cited writers do use dotted paths, and new B2 code will refuse own-doc deletion. But a pre-B2 tab recognizes only Spring 2026 as own-doc ([firebase-data.js:85](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:85), [app.js:4624](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4624)). The plan explicitly allows such a tab to create a config-only semester, later repaired by “Create its storage” ([plan:71](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:71), [plan:269](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:269)). That old tab can subsequently run `deleteSemester`, remove the config entry ([app.js:4660](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4660)), and target only `lessonData` ([app.js:4681](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4681)), leaving the repaired own document orphaned. Generic updates remain allowed without membership ([plan:121](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:121)).

   **Fix:** Do not enable/use “Create its storage” until every manager/admin Classbook tab has been closed or refreshed after Phase B. Add this as a deployment gate and test the stale-tab sequence. Also adopt `semesterInConfigAfter()` for generic normal updates so any accidental orphan is at least unwritable; Phase E must provide recovery before permitting config removal.

3. **Major — the new storage-state table omits one data-loss state.**

   **Evidence:** It defines absent document + unverified record only when a legacy map exists ([plan:79](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:79)). It then jumps to absent + no record and absent + verified/malformed/unknown ([plan:80](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:80)). An absent document with an unverified migration record and no legacy map is unspecified—the dangerous “both copies missing” state.

   **Fix:** Add: “absent + unverified record + no confirmed legacy map → red data-loss/error state; config retained, nothing writable, restore from backup.” Add an e2e scenario distinct from the successful rollback-fallback test.

The added-key fence, map-diff semantics, regex/`replace`, guarded migration gate, Spring rollback exception, PR/merge/deploy order, and targeted absent-slot transactions for both Fall and own documents are otherwise sound. No files or external state were changed.
