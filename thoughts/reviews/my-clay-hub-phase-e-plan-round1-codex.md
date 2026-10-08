Verdict: **not ready**. The D22 trigger ordering model is sound, but the reconcile protocol, first-trigger IAM sequence, OIDC probe, rollback, and projection contract need design fixes before implementation.

1. **Blocking — The reconcile cannot enforce its stated stops with the planned interfaces.**  
   [Phase E draft:141](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:141) says the sender obtains target IDs “from ingest” and stops for more than 10% status changes or 5% removals. But status may only be derived inside `my-clay-hub` ([DATA-MODEL.md:57](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:57)), and E-2 defines only single-envelope writes, not an inventory or preflight operation ([draft:103](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:103)). The sender therefore cannot know prospective status changes without duplicating `deriveStatus`, violating D4.

   Define a receiver-side batch reconcile operation on the same private function: the sender supplies the complete, single-readTime source snapshot; the receiver validates the whole batch, reads current targets, derives statuses, calculates effective changes after readTime gates, applies both stops, and only then writes. Define denominators, rounding, whether additions count, and ensure the initial empty-to-66 fill is allowed. Staff reconciliation needs the same complete-set treatment.

2. **Blocking — The ordering key has no wire format, so nanosecond ordering can be lost.**  
   The envelope merely names `readTime` ([draft:94–99](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:94)). Specify its exact JSON representation, accepted range, nanosecond preservation, conversion to a Firestore `Timestamp`, and comparison rules. Millisecond ISO strings can collapse two distinct reads into equality and drop the newer change. Add tests for equal timestamps, same-millisecond/different-nanosecond timestamps, invalid encodings, and round-trip storage. The staff trigger must re-read the current `users/{uid}` document—including a nonexistent document after deletion—and use that read’s time; [draft:140](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:140) does not currently say that explicitly.

3. **Blocking — The projection schema is not exact enough to guarantee privacy or correct `review` statuses.**  
   The plan needs an exact nested schema, not just the F2 field names. Member pause objects currently contain notes, billing and Sawyer metadata ([Membership Manager app.js:550](/Users/christiehubley/clay-hub-membership/js/app.js:550), [app.js:3608](/Users/christiehubley/clay-hub-membership/js/app.js:3608)); the sender must reconstruct each nested object from allowed keys rather than copy and delete known bad keys.

   Also, “strict validation” must not reject malformed domain values that `deriveStatus` is required to turn into `review`: unknown stage, malformed date, non-object pause, missing end date, and malformed historical/prior-term pause ([derive-status.js:79](/Users/christiehubley/my-clay-hub/shared/derive-status.js:79)). Canonicalize malformed structures without carrying their raw possibly-sensitive contents. Otherwise the old projection remains active instead of becoming `review`.

   Resolve these contract gaps too:

   - Exact behavior for blank, short or malformed phones; only ASCII digits should contribute to `phoneLast4`.
   - Whether `firstName` and `lastInitial` are transmitted or computed—the current model names them but F2 does not ([DATA-MODEL.md:53](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:53)).
   - The exact `memberProfiles` current/next-pause projection.
   - Tombstones must replace old documents and clear former email, phone digits, dates and profile fields—not merge a flag into retained PII.
   - Logs and alerts must never include request bodies, email, phone, notes or source documents.

4. **Blocking — Staff roster input must fail closed; F5 overstates the source schema.**  
   `users` documents can contain additional fields such as `createdAt` and `pin`, and administrators have broad writes to other user documents ([studio-hub app.js:148](/Users/christiehubley/studio-hub/js/app.js:148), [firestore.rules:172](/Users/christiehubley/studio-hub/firestore.rules:172)). The rules do not enforce F5’s claimed complete shape or role enum. Because `staffRoster` becomes an authorization control, malformed `role`, `active`, or `appAccess` must tombstone/fail closed and alert—never accidentally grant through loose JavaScript coercion.

   The sender should consume only `role`, `active`, and `appAccess`; output only `{name, role, active, grant}` as documented ([DATA-MODEL.md:113](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:113)). Email, source `appAccess`, PINs and unrelated fields should never cross projects.

5. **Blocking — Q3’s K13 sequence rests on an unproven delivery-identity assumption.**  
   [Draft:72](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:72) suggests that the triggers run as `clayhub-link@`, so the automatically granted Compute-account roles can be removed. Runtime identity and Eventarc delivery identity are distinct concepts; the draft itself says this still needs confirmation. Make successful event delivery after removal of the Compute grants an explicit gate, not an inference.

   Before changing the default Compute account in the shared production project, E-5 also needs a production workload inventory and recent-use/audit check—not only repository grep. F11 proves no checked local code names that account; it cannot prove Cloud Run, Functions, Scheduler, build triggers, VMs or another managed service does not use it. Enumerate the expected API-created service agents and IAM rows so “exactly the planned changes” is testable.

6. **Blocking — The E-6 “real OIDC call” has no executable, guarded mechanism.**  
   [Draft:170–172](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:170) refers to a “one-off, logged invocation in `tinker-hq-apps`” but does not say what workload runs it. A temporary function would itself require declaration, guarded deployment and a deletion path that does not exist. Cloud Shell impersonation would require an explicit token-minting authorization and would not prove the deployed runtime path.

   Define the mechanism and its IAM before E-6, or move the smoke call into a carefully sequenced E-7 deployment. The phase also needs the promised negative write tests against both databases; the checklist claims E-6 tests a source write refusal ([draft:200](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:200)), but E-6 currently does not.

   The synthetic tombstone is permanent under the no-delete design, so E-8 should expect 66 live members plus the reserved synthetic tombstone, not simply “66 members” ([draft:184](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:184)).

7. **Blocking — The emergency stop procedure is rejected by the existing guard.**  
   [Draft:212](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:212) says to redeploy with an empty invoker list. The guard explicitly rejects an empty list ([deploy-functions.sh:184](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:184)). Its supported no-caller representation is `invoker: ["private"]`, which attestation maps to an empty IAM binding ([deploy-functions.sh:358](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:358)).

   Write an exact guarded stop/resume runbook: pause both schedules, redeploy ingest as `["private"]`, attest it, describe the retry backlog/logging/cost, and explain safe re-enablement. “Triggers then fail and retry harmlessly” is too strong without retry-retention and alert-storm handling.

8. **Blocking — Decisions and vault gates are sequenced too late or omitted.**  
   Q1 changes the documented “3:30 AM Denver” rule in [SPEC.md:381](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/SPEC.md:381), yet the draft postpones decision logging until E-9, after deployment ([draft:192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:192)). Record Q1–Q5 and update affected source-of-truth docs before implementation.

   E-7 should name all real-data gates:

   - V-4 has `deploy_verified=yes`, `iam_attested=yes`, `scheduler_attested=yes`, and a verified complete export.
   - The #64 Force-run fix is deployed and attested; its plan says it must ship before Phase E ([vault plan:450](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:450)).
   - After the initial real fill, run and verify a new off-project export, then retain the restore-rehearsal follow-up required by the vault plan ([vault plan:314](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:314)).

9. **Blocking — Recompute needs atomicity and concurrency semantics.**  
   [Draft:106](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:106) does not say that recompute updates `members.status` and `memberProfiles.status` together, performs a complete dry run before any write, or safely races with ingest. A recompute based on an older document must not overwrite a newer ingest result. Use a transaction or equivalent all-read-before-write design that retries and re-derives from the current stored source shape. Test recompute-versus-ingest in both orders, threshold refusal with zero writes, tombstones excluded from the denominator, and profiles staying in sync.

   The safety statement that `ingestMemberUpdate` is the “only writer” is also false once `recomputeStatuses` writes statuses ([draft:199](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:199)). State the narrower invariant accurately.

10. **Should-fix — Function operational settings are not execution-ready.**  
    Both schedules need exact cron strings, all five retry values, timeout, memory, CPU, concurrency and `maxInstances`; triggers and HTTP functions need their exact limits too. The guard requires explicit schedule retry values ([predeploy-check.sh:242](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:242)), while the draft currently gives only “09:30 UTC” and “every 6 h.” Add tests for unexpected retry prompts, prompt text drift, EOF, same-sha continuation after a partial deploy, and refusal of any undeclared trigger setting.

11. **Should-fix — Release ordering leaves avoidable monitoring and rules gaps.**  
    Deploy the explicit deny rules before the receiving function/probe, even though today’s recursive catch-all already denies access ([firestore.rules:13](/Users/christiehubley/my-clay-hub/firestore.rules:13)). Create failure/conflict/reconcile/recompute alerts before enabling the sender, not in E-8 afterward ([draft:176](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:176), [draft:187](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:187)). Also control the first six-hour schedule boundary so the initial fill is the logged E-8 operation, rather than an unnoticed automatic run.

12. **Should-fix — F1–F11 audit corrections.**  
    [Draft facts:51–64](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:51):

    - F1’s save behavior and ID format are supported by code; the 66/66 count is supported by the dated backup log, not independently verifiable from code offline.
    - F2/F6 are substantially correct. `priorTerm` entries are intentionally still read by `deriveStatus`; malformed old entries therefore produce `review`.
    - F3 and F7–F9 are supported.
    - F4 should say authorized Clay Hub writers may create documents without rules-level schema/memberId validation—not “create is unrestricted” ([studio-hub firestore.rules:942](/Users/christiehubley/studio-hub/firestore.rules:942)).
    - F5 is only a list of fields the link uses, not the complete `users` schema.
    - F10 is evidence that one cross-project grant succeeded, but organization policies can differ by project/resource; E-6 remains the authority.
    - F11 is a code-search result, not sufficient evidence for neutralizing a production service account.

13. **Should-fix — Add BDD cases that close the remaining false-pass paths.**

    - Nanosecond readTime ordering and malformed wire timestamps.
    - Reconcile preflight failure after source read but before writes; threshold stop leaves both collections unchanged.
    - Initial fill, exact 10%/5% boundaries, small denominators, additions, already-tombstoned members and stale candidates.
    - Tombstone removes all former PII; reappearance restores only the allowlist.
    - Malformed stage/date/pause becomes `review`, while forbidden nested fields never cross.
    - Blank/short/legacy phone behavior and no sensitive logging.
    - Malformed staff role/appAccess/active fails closed; delete and re-create in both event orders.
    - Recompute versus ingest races.
    - Event delivery still works after K13 cleanup.
    - The sender runtime’s attempted writes to both projects are denied.

14. **Should-fix — Q1–Q5 recommendations.**

    - **Q1:** Agree with 09:30 UTC. It is 03:30 MDT / 02:30 MST, always after Denver midnight and before 05:00. Record that it intentionally changes the winter wall-clock time and run the DST tests.
    - **Q2:** Agree: keep E-3 inside Phase E, but treat it as its own independently reviewed sub-plan/PR.
    - **Q3:** Agree with neutralizing broad roles and removing K13 grants, conditional on an observed successful event after removal and a production workload-use audit. Do not rely on the runtime-identity inference.
    - **Q4:** Agree with building the roster machinery now, but not the Manage Team UI. Make the staff input/output allowlists and fail-closed behavior explicit.
    - **Q5:** Agree. Treat delete/re-create as a new identity: old memberId tombstones, new memberId starts fresh. Preserve the dedicated B4 plan.

No files were modified, no deploys were run, and no network access was used.
