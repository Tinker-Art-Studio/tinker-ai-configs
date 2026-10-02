## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html
(My Clay Hub Phase D-4: a weekly Firestore export from project `my-clay-hub` to a bucket in project `tinker-hq-vault`, plus extending the repo's functions deploy guard to support scheduled functions.)

Parent material (read the relevant parts):
- /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html — section id="d4" (the outline this plan must satisfy), choices C2/C3
- /Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html — choices F1–F14, facts K1–K17, amendment M6 (the guard's design)
- Repo /Users/christiehubley/my-clay-hub: scripts/deploy-functions.sh, scripts/predeploy-check.sh, scripts/lib/receipts.sh, scripts/deploy-functions.test.sh, functions/declarations.json, functions/iam-expectations.json, functions/core/, firebase.json, FUNCTIONS-ROLLBACK.md, docs/my-clay-hub/DECISIONS.md, CLAUDE.md
- Pinned tools: node_modules/firebase-tools (15.22.3: lib/gcp/cloudscheduler.js, lib/deploy/functions/release/fabricator.js, lib/gcp/cloudfunctionsv2.js) and functions/core/node_modules/firebase-functions (7.4.0: lib/v2/providers/scheduler.js)

## What I want reviewed
- Does the plan meet every requirement of the D-4 outline and M6? Are the deliberate deviations sound? (V7: export state taken from Firestore's operations list instead of a stored record. V9: an uptime-check freshness endpoint with a third identity.)
- Verify the J-facts against the pinned source and Google's docs where you can. Flag any that are wrong.
- V7 idempotency: is listing Firestore export operations by outputUriPrefix reliable enough? Consider the operation list's retention, filter support, a prefix that can't be reused, a run that dies before the operation appears in the list, and concurrent instances. What breaks?
- Least privilege: are the custom roles sufficient and minimal?
  - vaultExporter: datastore.databases.export, operations.get, operations.list
  - firestoreExportWriter, on the bucket: storage.buckets.get, objects.create, objects.delete, objects.list
  - vaultLister: storage.objects.list
  Does the caller need anything on the cross-project bucket?
- The guard extension (V2/V3):
  - Is there any way a scheduled function could ship unverified, with the wrong retry or schedule settings, or public?
  - Does the attestation actually prove the Scheduler job? It is Christie's Console reading; no gcloud is available.
  - How does it interact with the existing F8/F9/#61 logic?
- V9:
  - Does Cloud Monitoring's uptime-check service-agent authentication work against a private Cloud Run function deployed by Firebase?
  - Is the declared-invoker approach compatible with the guard (F2/K11)?
  - Could concurrency or maxInstances cause false alerts?
- Are the BDD scenarios sufficient? What's missing for interruption and partial states?
- Could anything touch tinker-hq-apps or the staff backup bucket tinker-hq-vault-backups?
- What did I miss?

## Constraints
- There's no gcloud on this laptop. Christie does the Console steps; Claude verifies from her readings and screenshots.
- Never read ~/.config/configstore/firebase-tools.json. Run no deploy and no command that changes cloud state; this is a read-only review.
- Deploys go only through scripts/deploy-functions.sh, after "approved to change firebase <full sha>".
- The my-clay-hub database is empty. Phase E (real member data) is gated on this plan's first successful export.

## Output
Give a verdict ("ready", "ready after fixes", "not ready"). Then give findings grouped as blocking / should-fix / nits. For each, name the plan section it concerns and the evidence (file:line or doc URL).
