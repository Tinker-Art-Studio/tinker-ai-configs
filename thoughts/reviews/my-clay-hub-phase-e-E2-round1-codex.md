codex
## Findings

- **Blocking — reconcile can remove a live record without proving it is older than the batch.** [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:105) and [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:132) skip removal only when `priorTime` is truthy and at/after the batch. If `storedReadTime()` returns `null` for a missing or unreadable timestamp, both member and staff records are tombstoned. E-2 requires removals to have a `sourceReadTime` older than the batch. Concrete scenario: a live member without a usable stored timestamp is absent from one reconcile; the code removes it and drops its contact fields even though age was never established. This should fail closed or leave that record untouched.

- **Should-fix — a contract-valid 2999 end date can crash recompute.** [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:161) calls `addDaysYMD()` unconditionally for every valid pause end and final-access date. `2999-12-31` is valid under the contract, but adding one day throws because year 3000 is unsupported. I reproduced a member whose pause begins `2999-12-01` and ends `2999-12-31`: the status changes on the start date, then recompute throws while deciding whether it is explained. No partial write occurs, but the whole daily job fails for valid stored data.

- **Should-fix — recompute does not recreate a missing member profile.** [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:184) only writes a profile when `memberProfiles` already exists. Concrete scenario: a live member has a missing profile and crosses a pause boundary; recompute updates `members.status` but leaves the profile absent, rather than writing status and profile together. Normal atomic ingest should prevent this state, but the pure plan does not enforce the stated projection invariant when recovering from it.

- **Should-fix — the rules’ claimed future-proof denial is not real Firestore behavior.** [firestore.rules](/Users/christiehubley/my-clay-hub/firestore.rules:15) says the explicit false rules prevent another rule from opening these collections. Firestore combines matching `allow` expressions with OR semantics. A later broad `match /{document=**}` allow would open them despite these blocks, and the structural test at [firestore.test.js](/Users/christiehubley/my-clay-hub/tests/rules/firestore.test.js:116) would not detect a generic broad allow because it searches for collection names. There is **no current client exposure**: the committed rules deny every operation.

- **Nit — override lifetime loses Timestamp precision.** [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:39) represents `createTime` and `expiresAt` as milliseconds, and [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:53) compares those rounded values. Two Firestore Timestamps whose true difference exceeds 24 hours by less than a millisecond can pass. The exact contract calls for Timestamp-based expiry.

## Decisions outside the plan

The listed implementation decisions are otherwise sound:

- Treating `statusDate` as volatile correctly makes a same-content reapply `unchanged` while advancing its derivation date.
- Leaving an unchanged profile unwritten matches the reconcile rule.
- Single-trigger ingest re-deriving status for today is consistent with the contract; only reconcile is prohibited from applying a purely date-driven change.
- Counting distinct touched IDs for the 249 cap is safe: each member contributes at most two document writes, plus one override consumption.
- Writing `statusDate` daily while moving `updatedAt` only for a status/content change matches `DATA-MODEL.md`.
- Carrying byte-identical shared files inside the deployable codebase is appropriate. I verified both copies are identical.

The #72 thresholds, source-driven comparison, held-ID denominator, additions/reappearance, override limit merging, and current deny-all behavior otherwise match the plan.

## Pure-layer test gaps

The planned pure behavior is not yet fully pinned:

- A→B→A through reconcile, not just single-envelope ingest.
- Reappearance restoring the exact full members/profile allowlists.
- An already-tombstoned record omitted from reconcile remaining untouched.
- The staff version of the newer-trigger-versus-removal race.
- Recompute’s 249 cap and 200 alert boundary; the existing cap test exercises member reconcile only.
- Recompute advancing every live `statusDate` while preserving member `updatedAt` when status is unchanged.
- Exact profile pause movement and `updatedAt` at start/end boundaries.
- A recompute stop explicitly returning no writes.
- Valid staff and recompute override schemas, negative/fractional limits, the exact 24-hour boundary, and nanosecond expiry behavior.
- Missing/unreadable stored `sourceReadTime` removal behavior.
- The valid `2999-12-31` boundary and a missing profile.

Transaction retries, both ingest/recompute race orders, actual override consumption with a server timestamp, error logging, and PII-free logs appropriately remain integration tests for step 3.

NOT SAFE TO MERGE
