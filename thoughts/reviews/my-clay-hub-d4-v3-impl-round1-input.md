## Change under review — My Clay Hub D-4, phase V-3: the `vault` functions codebase

Repo: /Users/christiehubley/my-clay-hub, branch `d4-vault-codebase` (one commit on top of `main` @ 289f716).
Read the change with: `git -C /Users/christiehubley/my-clay-hub diff main...d4-vault-codebase` (and read the new files
under functions/vault/ and tests/functions/vault/ in full).

Plan (the source of truth for what this phase must do): ~/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html
— read "Facts" J1–J16, "Choices" V1–V14, Christie's decisions O1–O6, and the phase "V-3" (its steps, acceptance and
BDD scenarios). V-0, V-1 (Console) and V-2 (the guard) are done; the newest Decisions-log entries record them.

What the change does:
- functions/vault/: index.js (vaultExport = onSchedule; vaultFresh = onRequest with withReached), export-run.js (V7/V8
  run logic, pure, injected clients), freshness.js (V9, pure), vault-bucket.js (folder listing + completeness, list-only),
  clients.js (real clients, refused in the emulator), vault-config.js (constants), reached.js (copy of core's),
  package.json + lockfile (direct pins: @google-cloud/firestore-api 0.2.0, @google-cloud/storage 8.2.0,
  firebase-admin 14.5.0, firebase-functions 7.4.0).
  DEVIATION from V1's text: `@google-cloud/firestore-api` instead of `@google-cloud/firestore` — in Firestore 9.3.0 the
  v1 FirestoreAdminClient and the generated protos live in firestore-api (Firestore's own `.v1` getter requires it);
  same resolved version, one copy in the tree.
- firebase.json: the vault entry; functions/declarations.json: vault/vaultExport (schedule) and vault/vaultFresh
  (https, invoker = the Monitoring notification agent read in V-0); functions/iam-expectations.json: vault-export@ →
  [projects/my-clay-hub/roles/vaultExporter], vault-watch@ → [].
- Tests: tests/functions/vault/ (export-run, freshness, surface — fake clients with production-shaped operations built
  by encoding with the pinned protos and decoding with @grpc/proto-loader using google-gax's options; emulator test);
  tests/functions/manifest.test.js (vault's discovered manifest, whole); updated existing tests that pinned "one
  codebase" (canary emulator test, firebase-config, predeploy-cli-path — the M5 RESOURCE_DIR refusal now fires for real
  because firebase.json has two codebases; deploy-functions.test.sh's IAM-reading fixture now takes runtimeAccounts
  from iam-expectations.json).
- Docs: docs/my-clay-hub/DATA-RESTORE.md (V14), DECISIONS #63, OPEN-ITEMS, CLAUDE.md, FUNCTIONS-ROLLBACK.md §10;
  a comment in scripts/predeploy-check.sh.

## Acceptance (from the plan)
The code only reports success when Google says the export finished cleanly AND the complete folder is in the bucket; a
retry never starts a second export when the first is visible; a duplicate can only ever be a separate complete copy;
the freshness endpoint answers "stale" after 7 days 18 hours. All proven without touching Google.

## What I want reviewed (be concrete; cite file:line)
1. Correctness of export-run.js against V7/V8 — every branch: done-already, running, done SUCCESSFUL without folder,
   history (FAILED/CANCELLED/error), wait budget, prefix checks, caps, pagination, run key. Any path that could report
   success without a complete export, start a second export when the first is visible, reuse a prefix, or hang past
   Cloud Run's 1,800 s.
2. The real client surfaces: does the code call @google-cloud/firestore-api 0.2.0 (FirestoreAdminClient:
   exportDocuments, listOperationsAsync, getOperation, databasePath) and @google-cloud/storage 8.2.0 (bucket.getFiles
   with autoPaginate:false → [files, nextQuery, apiResponse]) correctly, in the shapes they really return? Read the
   installed sources in functions/vault/node_modules to check. Is the raw Operation's metadata really {type_url, value}
   from listOperationsAsync AND getOperation over gRPC? Is snapshotTime {seconds, nanos} accepted?
3. Permissions (V4): does anything need more than vault-export@'s datastore.databases.export/operations.get/
   operations.list + storage.objects.list, or more than vault-watch@'s storage.objects.list?
4. freshness.js / vaultFresh against V9 (threshold, statuses, body content, caps, errors → 500).
5. Whether the tests would catch a regression (are the fakes faithful? anything asserted vacuously?).
6. The guard interplay: will `scripts/deploy-functions.sh --approved <sha> --codebase vault` accept this manifest
   (JQ_MANIFEST, JQ_F8, JQ_ATTEST, JQ_SCHED), and does anything about core's next deploy/attest change unexpectedly?
7. Docs: is DATA-RESTORE.md correct and safe (import semantics, the temporary grant, who can import)?

Classify each finding as blocking / should-fix / nit, and end with one verdict line:
"merge after fixes" / "safe to merge" / "not ready".
Do not modify any files. Do not deploy, call Google, or run any firebase deploy. Running the repo's tests locally
(`TINKER_FUNCTIONS_TESTS=required npm test`, ~10 min) is fine but not required.
