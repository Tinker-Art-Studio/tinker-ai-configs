Verdict: **not ready**. Most Round 2 findings are genuinely fixed, including the core `held`/race-safe reconcile, atomic recompute, Q9 service IAM model, deployment order, and exact stored schemas. Two safety-critical parts remain underspecified.

## Findings

1. **Blocking — “Source-driven” status counting has no implementable causal rule.**  
   The reconcile excludes a status change when it “differs only because the date moved,” but it does not define how to determine that when a source edit and a date transition happen together. For example, an email edit on the first day of a pause changes the source snapshot and the persisted status, even though the source edit did not cause the status transition.

   Define it counterfactually inside the transaction:

   - `oldTodayStatus = deriveStatus(storedSourceShape, todayDenver)`
   - `newTodayStatus = deriveStatus(incomingSourceShape, todayDenver)`
   - Count one source-driven status change only when those differ.
   - Do not compare the incoming status directly with the possibly day-stale persisted status.

   Add tests where an irrelevant source edit coincides with a pause start/end and where a genuinely status-changing source edit coincides with a date transition. The current “counted once” test does not state the expected status-change count.  
   [Plan E-2 reconcile](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:147), [tests](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:152)

2. **Blocking — `settings/linkLimits` is not yet a safe, one-time override contract.**  
   Firestore rules protect it from clients, but not from Console/Admin writes. The plan does not define:

   - Which operation it authorizes: member reconcile, staff reconcile, or recompute.
   - The exact permitted fields, numeric bounds, and unknown-field behavior.
   - Whether it raises status, removal, or staff limits independently.
   - How “once” is enforced. An expiring document can currently authorize every run for 24 hours.
   - What is recorded for audit or how Christie verifies the proposed IDs/counts rather than trusting only logged totals.
   - How consumption interacts with the 500-write limit. Atomically consuming an override adds a write, so a 250-member reconcile could become 501 writes.

   Give it an exact scoped schema, strict validation, bounded values, and either atomically consume it—with the member cap reduced accordingly—or stop calling it one-time. Log its identifier, scope, accepted limits, expiry, observed counts, and result without PII. The stop runbook should require comparing the proposed change with Membership Manager before applying it; “read the logged counts” alone defeats the safety stop.  
   [Plan E-2 override](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:147), [stop-email runbook](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:250)

3. **Should-fix — Q6’s malformed-container behavior is internally ambiguous.**  
   The contract requires a non-object `scheduledPause` to remain malformed and produce `review`, while E-pre says `deriveStatus` ignores any scheduled pause whose `processed` is not true. A string marker has no true `processed`, so a literal implementation could silently ignore malformed data.

   Specify that only an object canonicalized with `processed:false` is ignored; a non-null, non-object container remains malformed. Also make the malformed-date BDD explicitly use `processed:true`.  
   [Snapshot contract](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:91), [E-pre](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:122), [BDD](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:161)

4. **Should-fix — Q9-before-first-fill does not preserve E-8 as the first authenticated call or first data arrival.**  
   Once Q9 is granted, pending or new member events can invoke ingest before E-8. Pausing `reconcileLink` prevents the scheduled complete fill but does not pause the event triggers. This contradicts both E-6 and E-8.

   The clean sequence is: deploy → pause reconcile → remove K13 grants → force the complete reconcile → grant Q9 per service → save one member and prove delivery → resume → attest. Alternatively, explicitly call E-8 the “first complete reconcile” and accept/document that triggers may have partially populated the projection first.  
   [E-6 claim](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:214), [E-7 order](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:222), [E-8 first fill](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:232)

5. **Should-fix — The Pub/Sub Token Creator finding still lacks a remediation gate.**  
   V3 verifies the grant only during the final attestation, after the trigger proof. If the CLI did not create it, E-8 fails and invokes the full stop/re-plan path even though the narrow corrective action is known. Add an immediate post-deploy reading and say exactly whether a missing grant causes a stop or a recorded, narrowly scoped grant before trigger proof.  
   [E-3 attestation](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:173), [E-7/E-8](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:218)

6. **Should-fix — The stop runbook assumes recompute is harmless for every incident.**  
   Leaving recompute enabled is appropriate for a sender/transport outage, but not necessarily for a bad `deriveStatus`, projection-shape, or receiver release: recompute runs the same status logic and changes authorization-visible fields. Define two stop classes:

   - Link/transport stop: leave recompute enabled.
   - Status/receiver-integrity stop: pause recompute too and explicitly record that scheduler attestation will remain non-green until recovery.

   The current “otherwise stop the link” instruction also does not actually stop a repeatedly failing recompute.  
   [Stop runbook](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:245)

7. **Should-fix — Race-safe removal needs an explicit staff test.**  
   The contract’s “held record” wording can cover both scopes, but the test list names only a member removal racing a newer trigger. Add the corresponding staff case: a staff grant arrives after the reconcile read but before its POST, and the older reconcile must not tombstone it.  
   [Reconcile contract](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:97), [tests](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:152)

8. **Should-fix — State the recompute overflow behavior explicitly.**  
   The 250-member refusal and alert-from-200 rule is stated only for reconcile. Recompute should have the same preflight behavior rather than relying on “≤250, as above,” especially if override consumption adds a transaction write.  
   [Capacity note](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:113), [recompute](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:148)

## Round 2 resolution audit

Fully resolved:

- Conflicting/malformed member sets, explicit `held`, duplicate rejection, and member removal read-time gating.
- Advancing `sourceReadTime` on newer unchanged deliveries.
- Staff grant/tombstone behavior and the separate “more than one removal” stop.
- Stored member/profile/staff schemas and PII-clearing tombstones.
- One-transaction recompute with transactional retry.
- Complete function settings and exact retry-key names.
- 401/403/404 retry behavior and the guarded `["private"]` stop.
- K13 failure now stops and re-plans rather than restoring broad grants.
- Profile pause recomputation.
- Rules-guard isolation, E-0 ordering, Netlify acceptance, alert channel, phone normalization, negative IAM reading, and removal of the redundant first-fill exemption.
- Evidence-based E-8 trigger proof.

Partially resolved:

- Codex Round 2 #3/#6 and Claude #10: schemas and malformed canonicalization are substantially fixed, but Q6 introduces the ambiguity in finding 3.
- Claude #3: Q9 is technically sound as a proposed, recorded exception, conditional on Christie accepting Q9. The installed CLI does set the event delivery service account but does not set an event service invoker, confirming the need for the per-service grant. [cloudfunctionsv2.js](/opt/homebrew/lib/node_modules/firebase-tools/lib/gcp/cloudfunctionsv2.js:209), [fabricator.js](/opt/homebrew/lib/node_modules/firebase-tools/lib/deploy/functions/release/fabricator.js:344)
- Claude #4: member removal races are covered; staff coverage should be explicit.
- Claude #7: date-driven cascading is addressed in principle, but the counting algorithm and override contract remain blocking.
- Codex #10: Token Creator is attested, but the requested remediation gate remains absent.
- Claude #18: reconcile has an explicit cap; recompute needs matching refusal/alert wording.

Q9 itself is appropriately narrow: exactly two service-level bindings, no project-level grant, plus per-service and project-IAM attestation. I found no new Q9 design blocker beyond Christie’s required decision and the ordering issue above.

No files were modified, nothing was released, no network was used, and the Firebase CLI credential file was not read.
