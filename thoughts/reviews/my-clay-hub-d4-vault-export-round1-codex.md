Verdict: **not ready**

The outline coverage is strong, the IAM design is mostly sound, and V9 is technically viable. However, V7 does not yet guarantee one export per week, V5’s failure test cannot work as written, the first-time Firestore service-agent path is circular, and the scheduled-function response conflicts with the repo’s mandatory header rule.

## Blocking

1. **V7 — the operations list is not a sufficient idempotency store**

The design has an unclosed ambiguity window:

- `exportDocuments` can be accepted while the client loses the response containing the operation name.
- The retry immediately interprets “no matching operation” as permission to start another export.
- Google documents the list API and its generic filter, but not read-after-write consistency or filtering on `metadata.outputUriPrefix`; the implementation must paginate and filter client-side. [operations.list reference](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.operations/list)
- Completed operations are retained only for “a few days,” while a manual run later in the same week can occur after the successful operation disappears. [Firestore long-running operations](https://cloud.google.com/firestore/docs/query-data/indexing)
- The Native-mode API does not document output-prefix reuse as an idempotency guarantee. That guarantee appears in Datastore-mode documentation, not the Native-mode API used here. The Native API only defines the supplied prefix and generated-prefix behavior. [exportDocuments reference](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases/exportDocuments)
- `maxInstances: 1` is not a mutex. Cloud Run says the limit is per revision, can temporarily be exceeded, and old and new revisions can overlap during deployment. [Cloud Run autoscaling](https://docs.cloud.google.com/run/docs/about-instance-autoscaling)

This breaks the absolute claim “retries never make a second export” in [the plan, V7](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:96>) and the acceptance criterion at [line 220](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:220>).

Required fix: add durable coordination with an explicit lease/state machine, plus a reconciliation state for an indeterminate `exportDocuments` call. The state should distinguish:

- definitely not submitted;
- submission outcome unknown;
- operation name known/running;
- succeeded;
- failed and eligible for the next attempt suffix.

A stable prefix and bucket metadata can help reconcile, but neither an eventually visible operation list nor `maxInstances` should be the sole lock. If Firestore state is chosen, this becomes a data-write/rules phase and needs the required failing emulator test and reviewed plan adjustment.

2. **V-5 — the planned export failure test cannot trigger an export**

V-4 already creates a successful export for the current week and verifies that another force-run returns “already done” ([V-4 steps 5–6](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:242>)). V-5 then removes the writer grant and force-runs the same weekly job ([V-5 step 1](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:265>)).

Under V7, that run finds the prior success and performs no storage write, so it succeeds instead of firing the failure alert. It also cannot later produce “a new attempt suffix this week” while a successful operation exists.

Move the deliberate writer-denial test before the first successful export, or provide a separately isolated test path that cannot affect production deduplication. The final sequence should be: fail a fresh attempt, observe the email, restore the exact binding, allow a retry/new suffix to succeed, then prove subsequent runs deduplicate.

3. **V-0/V-1 — the “service agent does not yet exist” fallback is circular**

The plan says that if the Import/Export page shows no Firestore service agent, V-1 waits for the first export attempt to create it ([V-0 BDD](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:144>)). But V-1 precedes deployment and requires granting the role to that agent ([V-1 steps 4–5](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:160>)); the first export is not attempted until V-4.

Define a bootstrap branch explicitly: deploy, attempt once expecting the missing cross-project grant, read the authorization principal Google created, grant only that principal on the new bucket, wait for IAM propagation, then retry. Do not mark V-1 accepted before this branch is resolved.

4. **V2/V3 — Scheduler attestation is post-deploy and does not fully attest the HTTP target**

A scheduled function necessarily exists before Christie can read its generated Scheduler job. Therefore, the guard cannot prevent it from “shipping unverified”; it can only refuse to mark the attempt attested. This matches the existing F8/F9 model, where automated production configuration is checked after deployment and IAM is manually attested ([current F8](</Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:223>), [current attestation](</Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:265>), [known limits](</Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:123>)).

The operational gate must therefore say:

- a newly created/changed Scheduler job is immediately paused until attestation succeeds, or deployment occurs in a guaranteed non-firing window and any failed attestation requires immediate pause;
- the Phase E gate requires `deploy_verified=yes`, `iam_attested=yes`, and `scheduler_attested=yes`;
- a later deploy cannot inherit a stale Scheduler attestation when schedule-related declaration/manifest files changed.

The evidence block should also attest:

- OIDC audience is absent/default or exactly the live function URI;
- no unexpected request body;
- expected headers only;
- the reading is a complete Scheduler-job list for the relevant region, so “no extra job” is meaningful.

The pinned CLI does generate the documented name, POST target, and runtime-account OIDC identity ([cloudscheduler.js lines 118–166](</Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudscheduler.js:118>)). But the planned fields at [V2](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:77>) omit the audience/body aspects.

Christie’s Console reading proves only what was visible at that moment; it cannot prove authenticity cryptographically or detect later manual drift. That is consistent with M3, but the plan should state the limitation plainly.

5. **V3 — `onSchedule` cannot satisfy the repository’s response-header invariant**

The repository requires every HTTP response to set `x-tinker-reached` ([CLAUDE.md](</Users/christiehubley/my-clay-hub/CLAUDE.md:64>)). The pinned `onSchedule` wrapper owns the HTTP response and sends empty 200/500 responses without exposing `res` to the handler ([scheduler.js lines 42–67](</Users/christiehubley/my-clay-hub/functions/core/node_modules/firebase-functions/lib/v2/providers/scheduler.js:42>)).

The plan adds `withReached` only to `vaultFresh`, not `vaultExport` ([V-3 step 1](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:208>)). Resolve this before execution: either Christie approves and records a narrow exception for SDK-owned scheduled responses, or the design changes. The plan cannot silently violate the documented invariant.

## Should-fix

1. **J11/V6 — retry semantics are misstated**

With both `retryCount` and a nonzero `maxRetryDuration`, Cloud Scheduler can retry beyond `retryCount`; both limits must be reached. The plan’s statement that this yields “three more tries within 6 hours” is therefore wrong at [V6](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:95>). [Cloud Scheduler retry documentation](https://docs.cloud.google.com/scheduler/docs/configuring/retry-jobs)

If exactly three retries are intended, use `retryCount: 3` with `maxRetrySeconds: 0`, while still explicitly supplying all five fields. Otherwise document the true maximum behavior and test it accordingly.

2. **V9 — the promised eight-day alert actually arrives after roughly eight days plus six hours**

`vaultFresh` first fails at age eight days, then the policy waits six more hours before opening an incident ([V9](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:106>)). That does not satisfy the stated goal that Christie is emailed when no good export has landed “for 8 days” ([goal](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:32>)).

Either lower the endpoint threshold to 7 days 18 hours, shorten the alert retest window, or explicitly promise an alert by 8 days 6 hours.

3. **V9 — authentication is viable, but configuration should be more explicit**

Google supports Service Agent Authentication for HTTPS uptime checks, generating an identity token for the Monitoring service agent, and explicitly supports Cloud Run targets when the caller has `run.routes.invoke`. [Uptime-check documentation](https://docs.cloud.google.com/monitoring/uptime-checks)

The Firebase-deployed v2 HTTP function is a Cloud Run service, and an explicit service-account invoker is compatible with the current guard’s F2 model. The third identity is therefore sound.

Specify that the target resource type is the Cloud Run service, not merely an arbitrary URL, and attest the exact Cloud Run `run.invoker` member. `maxInstances: 1, concurrency: 10` should handle the minimum three uptime-check locations; a six-hour failure window makes transient cold starts unlikely to alert.

4. **V0 — expected IAM deltas omit Google service-agent roles**

Enabling Scheduler/Monitoring or creating their service identities can add:

- `roles/cloudscheduler.serviceAgent` to `service-…@gcp-sa-cloudscheduler…`;
- `roles/monitoring.notificationServiceAgent` to `service-…@gcp-sa-monitoring-notification…`.

Google documents both as project-level service-agent grants. [Google service agents](https://docs.cloud.google.com/iam/docs/service-agents)

Consequently, V-0’s assertion that the only before/after difference is `vaultExporter` on `vault-export@` ([lines 134–139](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:134>)) may fail for a legitimate reason. Record the exact expected Google-managed deltas and add them to `iam-expectations.json` when applicable.

5. **J8 — qualify the source as Datastore-mode documentation**

The four-permission `firestoreExportWriter` role is explicitly documented for cross-project exports in the Datastore-mode guide: `storage.buckets.get`, `storage.objects.create`, `storage.objects.delete`, and `storage.objects.list`. [Datastore export permissions](https://docs.cloud.google.com/datastore/docs/export-import-entities)

Native-mode documentation currently says Storage Admin and does not enumerate that exact export-only set. Therefore V4 is a defensible least-privilege experiment, but J8 currently overstates the Native-mode documentation. Preserve the real-export proof and bucket-scoped Storage Admin fallback.

6. **V4 — least privilege is otherwise sufficient**

The proposed roles are minimal for the exact algorithms:

- `vaultExporter`: export, get operation, list operations;
- `firestoreExportWriter`: Google’s documented four write-side permissions;
- `vaultLister`: `storage.objects.list`, provided the freshness code only calls object listing and does not fetch bucket metadata.

The caller does not ordinarily need access to the cross-project bucket: `exportDocuments` is authorized by `datastore.databases.export`, while the Firestore service agent performs Storage operations. The first real export is still the right proof because Native-mode documentation is broader.

Ensure the Admin client is constructed with the explicit project/database and does not perform convenience project discovery that could require extra permissions.

7. **V7/V-3 — add partial-state and adversarial tests**

The current tests at [V-3 step 3](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:215>) should additionally cover:

- POST accepted but the response is lost;
- matching operation initially absent, then visible;
- operations-list pagination;
- multiple matching operations in contradictory states;
- completed operation expired from the list but metadata exists;
- two concurrent callers;
- overlap during a new revision deployment;
- partial objects from a failed/cancelled export;
- reused-prefix rejection;
- transient list/get errors versus definite “not found”;
- `done: true` with missing or unknown operation state;
- freshness listing pagination;
- a metadata-looking object in the wrong folder;
- IAM propagation delay after the deliberate break/restore.

8. **V9 — the freshness signal should validate a complete export more carefully**

Finding a filename ending in `.overall_export_metadata` is a good durable success signal, but require the filename to equal its parent directory name. Google requires that invariant for importable exports. [Firestore export metadata rules](https://docs.cloud.google.com/firestore/native/docs/manage-data/export-import)

Also use the metadata object’s immutable creation time, not a mutable update time, and document how soft-deleted/noncurrent objects are excluded.

## Nits

- **J3:** Correct for the pinned CLI: scheduled create and update set the invoker to the runtime account ([fabricator.js create](</Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/release/fabricator.js:382>), [update](</Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/release/fabricator.js:484>)). “Exactly” should be described as the Cloud Run service-level `run.invoker` binding; folder/organization inheritance remains outside attestation.
- **J4/J5/J6:** These are accurate against the pinned sources. The deadline clamp is 180–1800 seconds ([cloudscheduler.js](</Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudscheduler.js:147>)); retry removal is not detected ([lines 84–108](</Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudscheduler.js:84>)); the SDK exposes all five retry fields and falls back to current time when the header is missing ([scheduler.js](</Users/christiehubley/my-clay-hub/functions/core/node_modules/firebase-functions/lib/v2/providers/scheduler.js:15>)).
- **J10:** Split this fact into Native-mode API facts, Datastore-mode prefix behavior, and the short-lived operation-list observation. It currently presents them as one equally supported contract.
- **V14:** Say “the importing database’s active Firestore import/export authorization principal,” rather than simply “the agent,” because a scratch target may use a different service agent.
- **Cost:** “~300 tiny requests a day” understates a global uptime check because at least three checkers run each interval, but it remains operationally negligible.

## Scope safety

Nothing in the proposed repo changes or deployment path needs to touch `tinker-hq-apps`. The guard is pinned to `my-clay-hub`, and the new bucket grants are bucket-scoped.

`tinker-hq-vault-backups` is read for comparison only. The main remaining risk is human Console selection, so the before/after screenshots and explicit new-bucket name remain worthwhile. No command was run against cloud state, and no files were changed.
