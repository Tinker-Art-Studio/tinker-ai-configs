## Findings

1. **Blocking — the 1,500-second budget does not bound Google client calls.**  
   [export-run.js](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:86) records the start time, but the folder listing, operation listing, `exportDocuments`, and `getOperation` calls have no deadline. The only budget check occurs after `getOperation` returns at [export-run.js](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:164). The pinned operations client can retry one call for 600 seconds ([operations_client_config.json](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/google-gax/build/src/operations_client_config.json:12)), and Storage’s default total retry timeout is also 600 seconds ([storage.js](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/@google-cloud/storage/build/cjs/src/storage.js:357)). Consequently:

   - Initial listings can consume the budget and the code can still start a new export at [export-run.js](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:135).
   - A polling call begun near the deadline can run past the 1,800-second Cloud Run timeout, defeating the promised error/alert path.
   - `vaultFresh` can likewise be killed at its 30-second timeout instead of returning V9’s `{case:"error"}` 500, because it uses the same default Storage client at [clients.js](/Users/christiehubley/my-clay-hub/functions/vault/clients.js:27).

   The tests do not detect this because fake I/O consumes no fake-clock time; only `sleep()` advances it ([fakes.js](/Users/christiehubley/my-clay-hub/tests/functions/vault/fakes.js:62)). Add deadline-aware client options/checks before starting an export and delayed/hung-call regression tests.

2. **Blocking — the restore runbook’s “fresh copy” instruction is not reliable.**  
   [DATA-RESTORE.md](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:39) says a Force run of `vaultExport` can take a fresh pre-import copy. But `vaultExport` returns “already done” whenever that UTC date already has a complete folder ([export-run.js](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:97)). A same-day Force run therefore may create nothing, leaving no snapshot of the state immediately before an import. The runbook needs a backup procedure that guarantees and verifies a newly created pre-restore artifact; a “point-in-time read” should not be described as taking a fresh copy either.

3. **Should-fix — the restore error path permits an unreviewed IAM widening.**  
   [DATA-RESTORE.md](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:79) says to grant whatever additional permission an error names. That contradicts the preceding exact two-permission role and the plan’s rule that widening needs Christie’s approval. It should say to stop, record the denial, and obtain explicit approval before altering `vaultImportReader`. The planned `storage.buckets.get` plus `storage.objects.get` custom role is otherwise exactly what Google documents for cross-project imports. [Google’s import/export permissions](https://docs.cloud.google.com/datastore/docs/export-import-entities)

4. **Nit — DECISIONS #63 overstates who can import.**  
   [DECISIONS.md](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DECISIONS.md:80) says “No identity can import into production,” while the runbook correctly states Christie’s Owner identity can initiate imports at [DATA-RESTORE.md](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:61). Say “no deployed/runtime service identity” instead.

## Checks that passed

- V7/V8 branch behavior is otherwise fail-closed: complete-folder detection, running-operation resume, failed/cancelled history, expected-prefix verification, operation/folder caps, run key, snapshot minute, and successful-operation completeness checks are correct.
- The real client surfaces are correct. `exportDocuments` returns an LRO wrapper with `name`; `getOperation` and `listOperationsAsync` return raw operations; the production-shaped `Any` fixtures faithfully use the pinned gRPC decoder. `{seconds, nanos}` is accepted for `snapshotTime`.
- Storage’s promise response really is `[files, nextQuery, apiResponse]`, and `autoPaginate:false` is required to retain `apiResponse.prefixes` ([bucket.d.ts](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/@google-cloud/storage/build/cjs/src/bucket.d.ts:636)).
- No code path needs broader IAM than V4 describes: exporter uses export/get/list plus object listing; watcher only lists objects.
- Fresh/stale/none logic and the exact 7-day-18-hour boundary are correct.
- The guard manifest, declarations, required Scheduler API, runtime identities, and schedule fields align with `JQ_MANIFEST`, `JQ_F8`, `JQ_ATTEST`, and `JQ_SCHED`. Core’s next attestation will deliberately include the vault accounts and, once deployed, the vault Scheduler job; the verifier-change acknowledgment behavior is expected.
- The import merge semantics in the runbook are correct: matching document IDs are overwritten and unaffected documents remain. [Firestore import behavior](https://docs.cloud.google.com/firestore/native/docs/manage-data/export-import)
- Focused vault tests passed: **33/33**. `npm ls` and `git diff --check` also passed. The full emulator/guard suite was not run.

**merge after fixes**
