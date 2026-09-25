## Verdicts

- Phase 2A.1 — **READY**
- Phase 2B — **CHANGES NEEDED**
- Top three Sep 25 Decisions Log entries — **READY** as historical summaries; update the top entry after resolving the finding below.

All round-1 findings are correctly incorporated. This includes the branch before `lessonStoreFor()`, separate SDOC resolver, clear allow-list, transaction authorization, canonical key/year validation, Teacher View initialization/listener behavior, editor split details, repeated-title controls, 2A.1 view token/context, tick re-keying, sign-off synchronization, photo path, reload model, and added BDD coverage.

The round-2 changes are also present: slot-derived routing plus `opts.dayOffAuth`, classbook-gated authorization, unique-first-name matching, paired photo deletion, sign-off refresh on checklist open, `{reload:false}`, Print binding guard, real-call-path BDD, and Kathy/Allie edit rights. The authorization design works for planners/prep: `canTickDayOffMaterials()` admits planners directly and prep only with `classbook` ([app.js:261](/Users/christiehubley/tinker-spring-curriculum/js/app.js:261), [app.js:268](/Users/christiehubley/tinker-spring-curriculum/js/app.js:268)), consistent with the rules ([firestore.rules:699](</Users/christiehubley/studio-hub/firestore.rules:699>)).

## Finding

1. **HIGH — The concurrency-tolerant verifier still treats a later write over a clear as a failed save**

   **Plan text:** The verifier accepts a differing written content/photo/`planComplete` value when the server has a newer `lastEditedAt`, but requires every cleared field to remain strictly absent ([plan:307](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:307)). The BDD only covers two teachers writing non-empty `closure` values ([plan:414](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html:414)).

   **Code evidence:** Emptying an existing content field produces `fieldsToClear` ([app.js:11520](/Users/christiehubley/tinker-spring-curriculum/js/app.js:11520)). Therefore:

   1. Teacher A clears `closure`.
   2. Teacher B saves new `closure` text after A’s transaction but before A’s read-back.
   3. A’s verifier finds `closure` present and reports failure, even though both saves succeeded and B legitimately won.

   This recreates round 2’s HIGH failure mode: the false failure invites A to retry and overwrite B. It also affects photo removal racing a replacement. Additionally, “newer” is determined using client wall-clock timestamps, which the existing code explicitly describes as a skew-prone heuristic ([firebase-data.js:1004](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1004)).

   **Fix:** Apply the benign-intervening-save rule to cleared fields as well as written fields. After the transaction has resolved and the canonical identity still matches:

   - If the returned edit stamp equals this save’s stamp, require all written values and clears exactly.
   - If the stamp differs, treat any content/photo/`planComplete` difference—including a cleared field becoming present—as an intervening save, without relying on timestamp ordering.
   - Keep identity verification strict and the rename/missing-document branch separate.

   Add BDD cases for “clear versus later text” and “photo removal versus later replacement.”

No other new HIGH/MEDIUM issue was found. The rename-before-read-back case, transaction locking, photo-pair translation, reload suppression, unique-name resolver, sign-off refresh, and Kathy/Allie path are otherwise sound.
