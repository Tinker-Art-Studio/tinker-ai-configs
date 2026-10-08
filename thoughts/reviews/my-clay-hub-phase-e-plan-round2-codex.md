Verdict: **not ready**. V2 genuinely resolves many round-1 findings, but the reconcile contract, staff behavior, recompute atomicity, and deploy settings still have blocking ambiguities.

## Findings

1. **Blocking — A conflicted or malformed source set can make reconcile delete the wrong member.**  
   The trigger path detects multiple live documents for a `memberId`, but the reconcile path merely sends “every live source record.” It does not require grouping by `memberId`, rejecting duplicates, or aborting when a live document lacks a valid `memberId`. If the sender skips such a record, the receiver interprets its absence as a removal; if it includes duplicates, behavior is undefined.  
   Require source-set validation before either scope is sent: every member has a valid ID, IDs are unique, and any conflict/malformed record aborts the entire member reconcile with no POST. The receiver must independently reject duplicate item IDs.  
   [Plan: reconcile contract](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:91), [E-2](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:138), [E-4](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:172)

2. **Blocking — Staff reconciliation is not defined consistently, and Q8’s member thresholds are unsafe for a small roster.**  
   The staff contract permits `{staff: {…, grant:false}}`, while E-2 tests say unticking/demotion produces a tombstone. Reconcile includes every source user, so it is unclear whether never-granted users create stored records/tombstones or are omitted. Applying the member removal floor of four “the same” to staff would allow an entire roster of fewer than five people to disappear without stopping.  
   Define one rule: preferably send/store only granted staff; an ungranted or malformed user produces a tombstone only if the receiver already holds that UID, otherwise it is a no-op. Give staff a separate threshold—e.g. stop any reconcile removing more than one existing staff member unless explicitly approved.  
   [Staff contract](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:90), [E-2 reconcile](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:138), [E-8 expectation](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:216)

3. **Blocking — The projection contract is still not exact enough to implement independently.**  
   The nested source allowlist is now good, but required/optional/null/type behavior remains unspecified for `name`, `email`, `emailLower`, `memberSince`, `retired`, malformed `pauseHistory` containers, and malformed cancellation objects. `emailLower` is not a source field, but its normalization is not defined. More importantly, the exact live `memberProfiles` shape and the algorithm selecting its “current or next pause window” are absent. “Likewise” also cannot define three different tombstone schemas for `members`, `memberProfiles`, and `staffRoster`.  
   Add exact schemas and exact stored tombstones for all three collections, including whether IDs are stored in documents and which malformed markers may reach the member-readable profile.  
   [Contract](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:84), [Stored tombstones](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:92), [DATA-MODEL.md](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:108)

4. **Blocking — Recompute is not atomic despite the plan’s atomicity claim.**  
   A dry run followed by separate per-member transactions prevents a stale ingest overwrite, but it does not provide all-or-nothing behavior. A runtime failure after member 20 leaves a partial recompute; values can also change between the threshold calculation and later transactions. The safety checklist nevertheless says stopped bulk changes are atomic.  
   At today’s size, read and write the full recompute in one Firestore transaction—two writes per changed member, capped safely below 500—or explicitly weaken the invariant, define partial-failure recovery, and stop calling it atomic. Thresholds must be recalculated on transaction retry.  
   [E-2 recompute](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:139), [Safety checklist](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:242)

5. **Blocking — The settings table is still incomplete and does not use the guard’s exact names.**  
   The current guard refuses any function whose `maxInstances`, `concurrency`, `timeoutSeconds`, memory, or CPU is unset. It also fixes `minInstances` at zero and declarations require ingress. The table omits several of those values, especially for both event triggers, and uses `minBackoff`/`maxBackoff` instead of `minBackoffSeconds`/`maxBackoffSeconds`. “As above” does not define CPU or concurrency because the preceding trigger row does not either.  
   Give every function an explicit region, ingress, timeout, memory, CPU, concurrency, max/min instances, and—in schedules—the exact five declaration/SDK retry keys.  
   [Settings table](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:97), [guard requirements](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:231), [schedule declaration check](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:242)

6. **Should-fix — `!malformed` works, but not as broadly as the plan claims.**  
   Source verification confirms that `"!malformed"` produces `review` when used as an unknown stage, invalid date, non-object pause entry, or non-array `pauseHistory`. It is not a special marker; it works because the existing validators reject it in those positions. However, `deriveStatus` returns `not_yet` for onboarding/touring and `removed` for tombstones/retired records before inspecting malformed pause data. Thus “each malformed value → review” is false without stage-qualified fixtures. The contract also needs to say how malformed cancellation containers are represented.  
   [Plan contract](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:87), [derive-status.js](/Users/christiehubley/my-clay-hub/shared/derive-status.js:25), [status precedence](/Users/christiehubley/my-clay-hub/shared/derive-status.js:79)

7. **Should-fix — The stop runbook contradicts the response contract.**  
   Removing the invoker causes 401/403 responses. The sender is specified to throw only for 5xx, 429, and timeouts, so it will acknowledge those authorization failures and Eventarc will not retry them. Recovery through a forced reconcile is still sound, but “Eventarc retries them” and “whatever the retries dropped” are inaccurate. Decide whether 401/403 should retry or be deliberately dropped during a stop, then document the resulting backlog, alert, and cost behavior.  
   [Responses](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:93), [Stop runbook](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:228)

8. **Should-fix — E-7 does not reliably preserve E-8 as the first authenticated fill.**  
   Deploying “right after” a schedule boundary gives operational breathing room but is not a gate. Deployment, readings, attestation, K13 cleanup, or an interruption can last until the next enabled reconcile. The completeness section explicitly says that scheduled reconcile may fill the projection before E-8. Pause the newly created Scheduler job immediately after deployment and before K13 work, then resume it after the logged first fill.  
   [E-7 order](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:204), [E-8](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:214), [Interrupted state](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:250)

9. **Should-fix — The K13 failure instruction authorizes an unclear broad-role restoration.**  
   “Restore the grant” does not identify which of the two project-wide grants to restore, who is authorized to do so, or how that reconciles with the plan’s prohibition on hand-granting invoker access. A failed proof should stop/pause the link and trigger a re-plan; it should not casually restore broad production IAM.  
   [E-8 delivery proof](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:217), [Stop rule](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:230)

10. **Should-fix — The Pub/Sub Token Creator check has no remediation gate.**  
    E-3 makes attestation read the grant, but E-5 only lists created agents and grants. State explicitly: if the Pub/Sub service agent lacks `iam.serviceAccountTokenCreator`, stop and add the narrowly scoped required grant before deploying; otherwise event delivery may fail only at E-8.  
    [E-3 attestation](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:164), [E-5](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:190)

## Round-1 resolution audit

Substantively resolved:

- Nanosecond `readTime` representation and comparison.
- Nested pause/cancellation allowlisting.
- Receiver-side complete-set reconcile concept and first-fill exemption.
- F5 correction and basic fail-closed staff validation.
- K13 workload inventory plus post-removal delivery proof.
- Removal of the unimplementable E-6 authenticated synthetic probe.
- `["private"]` as the guarded no-caller declaration.
- E-pre decisions and the vault/#64 gates.
- Rules-guard isolation: the studio-hub source confirms why this is necessary, and v2 now calls for a separate backstop and keeps `npm test` rules-only. The existing guard indeed pins `firebase.json`, `package.json`, and `predeploy-check.sh`, runs `npm test`, and its current backstop accepts only rules targets.  
  [deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:199), [test invocation](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:345), [predeploy-check.sh](/Users/christiehubley/studio-hub/scripts/predeploy-check.sh:20)
- Alerts moved before sender deployment; hard-coded URL; App Engine inventory; Firestore-wide read residual; retry response categories; tombstone PII clearing; phone behavior made exact; E-0 tests corrected.

Only partially resolved:

- Reconcile thresholds/atomicity: receiver-side member batching is fixed, but source conflicts, staff thresholds, and recompute atomicity are not.
- Exact projection: nested leakage is fixed, but `memberProfiles`, tombstones, malformed containers, and computed-field rules remain incomplete.
- Staff behavior: malformed inputs fail closed, but grant-false/no-op/tombstone and reconcile population are inconsistent.
- Settings: a table exists, but it is not exact enough for the guards.
- Stop procedure: the immediate revocation and `["private"]` redeploy are correct, but retry behavior is not.
- Quick Log: correctly elevated to Q6, but Option B cannot be implemented with the current contract because `scheduledAt` is deliberately stripped.
- Negative write proof: static “no write imports” plus IAM readings are useful, but v2 does not retain the round-1 request for an explicit denial proof against both projects.

## Q6–Q8 recommendations

- **Q6: choose Option B**—an unprocessed Quick Log request should not remove booking access when Membership Manager itself has not started the pause. Do not transmit the raw audit timestamp merely to decide this. Add a narrowly defined boolean such as `scheduledPause.processed`, derived from valid `scheduledAt` presence on the sender, and update `deriveStatus` in its own reviewed change so it remains the sole status authority. Add tests for processed, unprocessed, malformed, and legacy pauses.

- **Q7: approve the recommendation.** Replacing removed-member documents with PII-free tombstones is the right privacy boundary. Specify separate exact tombstone schemas for `members`, `memberProfiles`, and `staffRoster`.

- **Q8: approve only for members, with precision.** Define stops as `statusChanges > max(ceil(0.10 × liveHeld), 10)` and `removals > max(ceil(0.05 × liveHeld), 4)`. State whether removals also count as status changes; I recommend they count only in the removal bucket. Keep additions excluded and exempt only a genuinely empty collection. Do not reuse those floors for staff; use a much tighter staff-specific stop.

No files were modified, no deploys were run, no network was used, and the Firebase CLI credential file was not read.
