Verdict: **ready after fixes**. No blocking findings. The substantive round-3 issues are resolved; one override-contract ambiguity should be fixed before execution.

## Findings

1. **Should-fix — `linkOverrides` is not quite an exact schema after consumption or across scopes.**  
   The schema defines `usedAt: null`, but consumption changes `usedAt` without specifying its resulting type. It also permits both limit fields for every scope and does not define omitted-field behavior. Specify:

   - consumed `usedAt` is a server timestamp;
   - `staff` requires `maxRemovals` and forbids `maxStatusChanges`;
   - `recompute` requires `maxStatusChanges` and forbids `maxRemovals`;
   - for `members`, at least one limit is required and an omitted limit retains its ordinary Q8 threshold;
   - expiry is checked against Firestore’s document `createTime`, since the exact stored schema has no `createdAt`;
   - multiple eligible overrides for one scope cause a safe refusal, or define deterministic selection.

   This preserves the intended scoped, bounded, independently raised safety limits. [Plan E-2 override](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:148), [override tests](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:153)

2. **Nit — E-7 contains a stale step reference introduced by the reorder.**  
   “Until step 6” has no target in E-7; the grant now occurs in E-8 step 2. Say “until E-8 step 2.” The operative order itself is clear and correct. [Plan E-7](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:223)

## Round-3 confirmation

- The source-driven rule is now implementable and correctly counterfactual, using stored and incoming source shapes against the same Denver date inside the transaction. Unchanged source advances only `sourceReadTime`; it does not rewrite date-driven status or `updatedAt`. The two coincidence tests are explicit.
- `linkOverrides` is now isolated in a permanent deny-all collection, bounded to 249, scoped, expiring, transactionally consumed, audited, and tied to an ID-by-ID Membership Manager check. Finding 1 is the remaining contract exactness issue.
- Q6 now matches `isProcessedScheduledPause` at `clay-hub-membership/js/member-status.js:127-131`, including real ISO-string fixtures. The malformed-container check explicitly precedes the unprocessed-object check, and malformed dates use `processed:true`.
- The release sequence is correctly: release → pause → remove K13 → verify Token Creator → first fill → Q9 → delivery proof → resume → attest.
- Missing Token Creator now causes an explicit stop-and-ask gate.
- Link/transport and status/receiver-integrity stops are separately defined; the latter also pauses recompute.
- Reconcile reads, gates, thresholds, override handling, and retry recomputation are explicitly inside one transaction.
- E-2 merge timing now acknowledges the shared-declarations scheduler-attestation window and places the merge after #64’s attestation.
- Staff removal-race coverage, recompute capacity behavior, null handling, `updatedAt` behavior, trigger-delivery alerts, paused-job Force-run fallback, K13 recreation behavior, and malformed-source catch-up blocking are all addressed.

No other new v4 problems found. No files were modified, nothing was released, no network was used, and the Firebase CLI credential file was not read.
