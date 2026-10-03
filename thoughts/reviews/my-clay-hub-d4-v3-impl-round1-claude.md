I've read the full change, the plan (J1–J16, V1–V14, O1–O6, phase V-3), the installed client sources in `functions/vault/node_modules`, and the guard. I did **not** run the suite (the sandbox refused the `TINKER_FUNCTIONS_TESTS=required npm test` and `node --test` invocations); everything below is from reading.

## Answers to your seven questions

**1. `export-run.js` against V7/V8.** Every branch matches the plan, and I could not find a path that reports success without a complete folder, starts a second export when the first is visible, or reuses a prefix. Success is gated on `completeMetadata` in all three terminal paths (`export-run.js:99`, `:120`, `:160`); step 2 filters by prefix *after* a strict decode and fails closed on anything it can't read (`:108`, `:118`, `:121`, `readExportOperation:77-78`); the deadline is absolute from run start (`:126`, `:142`) so steps 1–2 spend from the same budget; `done` — not `state` — is treated as final (`:156`, and the comment at `:163` is correct). The one thing the budget does **not** bound is the client calls themselves — see should-fix 2.

**2. Real client surfaces — correct.** `v1.FirestoreAdminClient` and `protos` are both exported (`build/src/index.js:20`, `build/src/v1/index.js:21`). `exportDocuments` → `[LROperation, …]` with `.name` (gax `longrunning.js:89`); `getOperation(request)` → `Promise<[Operation]>` (`firestore_admin_client.d.ts:1549`); `listOperationsAsync(request)` → `AsyncIterable<IOperation>` (`:1580`); `databasePath(project, database)` (`:1745`). `IExportDocumentsRequest` has exactly `name/collectionIds/outputUriPrefix/namespaceIds/snapshotTime` (`protos.d.ts:6567-6583`), and `snapshotTime: {seconds, nanos}` is a normal `google.protobuf.Timestamp` — accepted.

The `type_url` claim is right, for both calls. Both go through the same gax `OperationsClient` (`firestore_admin_client.js:246, 2191, 2223`), built from `google-gax/build/protos/operations.json`, where the `Any` field is literally `"type_url"` (`operations.json:1233`); `loadProtoJSON` (`grpc.js:276-287`) uses `Protobuf.Root.fromJSON`, which does not re-case JSON descriptor field names, and `options.json` is unset so protobufjs's `Any` wrapper does not expand the payload. `defaults: true` (`grpc.js:209-213`) also means `metadata` is `null` rather than absent when there is none — handled at `export-run.js:68-70`. Storage: `getFiles` really does `callback(null, files, nextQuery, resp)` (`bucket.js:2257`) and is promisified non-singular (`:3701`, `:3707`), so `[files, nextQuery, apiResponse]` with `apiResponse.prefixes` is exactly right.

Worth recording as a positive: `ExportDocuments` is `retry_codes_name: "non_idempotent"` with `non_idempotent: []` (`firestore_admin_client_config.json:5, 63-67`), so gax never retries it — a client retry cannot produce two exports at the same prefix.

**3. Permissions (V4).** Nothing needs more. `exportDocuments`/`listOperationsAsync`/`getOperation` map 1:1 to `datastore.databases.export`/`operations.list`/`operations.get`; `bucket.getFiles` is `GET /b/<bucket>/o` → `storage.objects.list` only. No `exists()`/`getMetadata()`/`download()` anywhere (asserted textually at `surface.test.js:50-52`), and `freshness.js:19` takes `timeCreated` from the listing, not a metadata fetch. `new Storage({projectId: 'my-clay-hub'})` against a bucket in `tinker-hq-vault` needs no `userProject` (not requester-pays) and no `buckets.get`. `vault-watch@` uses `listFolders`/`completeMetadata` only. ✓

**4. `freshness.js` / `vaultFresh` against V9.** Threshold, statuses, caps and body are all as specified, including the inclusive boundary (`freshness.js:26`, `ageMs <= FRESH_MS`) and `ageHours` in tenths. Errors → 500 with the reason only in the log (`:34-36`). The uncalled-`vaultBucket` trick at `index.js:65` correctly turns a client-construction failure into a 500 too.

**5. Tests.** The fakes are unusually faithful — operations are genuinely encoded with the pinned protos and decoded through `@grpc/proto-loader` with gax's own options (`fakes.js:11-18, 41`), and the bucket imitates `prefixes`-omitted-when-empty, `nextQuery` and the three-element return. I found no vacuous assertions; the cap boundaries are exact (50/51, 999+1/1001, 499+1/501). Gaps are listed as nits 9 and 11, plus should-fix 5.

**6. Guard interplay.** `--approved … --codebase vault` will accept this manifest. I walked `VAULT_MANIFEST` through `JQ_MANIFEST` (`deploy-functions.sh:157-247`): every endpoint key is in `$allowed` (`:164-166`); `$hasSched` is true so `requiredAPIs` must be exactly `[{api,reason}]` for cloudscheduler (`:171-176`) — it is; both declarations have exactly the required key sets (`:185`, `:189-191`); `scheduleTrigger`'s keys are `["retryConfig","schedule","timeZone"]` (`:215`) and all five retries are numbers equal to the declaration (`:221-224`); `timeoutSeconds` 1800 ≤ 1800 (`:226`). `JQ_F8` wants `scheduleTrigger` only plus the `deployment-scheduled` label for `vaultExport` and no such label for `vaultFresh` (`:285-291`) — consistent with J1. `JQ_ATTEST` derives `vaultExport`'s expected `run.invoker` as `[serviceAccount:vault-export@…]` (`:357`), and `JQ_SCHED`'s `$wantList` resolves to exactly `firebase-schedule-vaultExport-us-central1` (`:393`).

For **core**, three things change, all expected: (a) `firebase.json`, `functions/declarations.json` and `functions/iam-expectations.json` are all in `ATTEST_FILES` (`:768`), so core's next deploy will say an IAM reading is needed; (b) every core reading must now list all three runtime accounts — `attest_help` generates that from `iam-expectations.json` (`:848`), so the printed template is right; (c) core's expected Scheduler job list stays `[]` until vault has an attempt, then becomes vault's one job (`:1187-1195`), matching V-2's BDD. `--reverify`/`--attest` of the existing Oct-1 core attempt still needs `--acknowledge-verifier-change` (`CONTROL_FILES`, `:121`) — already true after V-2.

**7. Docs.** `DATA-RESTORE.md`'s import semantics (overwrite-matching, delete-nothing, merge-not-rollback), the temporary bucket-only grant and "only Christie holds `datastore.databases.import`" are all correct. Two problems below (should-fix 1 and 4).

---

## Findings

### Should-fix

**1. `docs/my-clay-hub/DATA-RESTORE.md:39-40` — the pre-restore "fresh copy" can silently not happen.**
"first take a fresh copy of the database as it is now (a Force run of `vaultExport`…), so the restore itself can be undone." If a complete folder already exists for today's UTC date, `export-run.js:98-99` returns `already done` and exports nothing — which is precisely what V-4 step 9 is written to prove. A restore done on a Sunday after 09:00 UTC, or after any earlier Force run that day, would proceed with an "undo copy" that is hours stale or simply the morning's copy. Say so explicitly and point at PITR / an on-demand managed backup as the pre-restore snapshot.

**2. `functions/vault/export-run.js:149-166` with `vault-config.js:21` — the 1,500 s budget bounds the sleeps, not the calls.**
V7 claims the throw "always runs before Cloud Run's 1,800 s kill". No call carries a deadline: gax's `GetOperation`/`ListOperations` have `total_timeout_millis: 600000` (`google-gax/build/src/operations_client_config.json`), and `bucket.getFiles` inherits storage's default `maxRetries: 3, totalTimeout: 600` s (`storage.js:367-373`). One stuck call entered just under the budget can carry the run to ~2,100 s, so Cloud Run kills the request and the function's own error log never happens. V13's request-log alert still fires, so this is a weakened property rather than a silent failure — but the stated invariant doesn't hold. Pass a per-call timeout derived from `deadline - now()`.

**3. `functions/vault/vault-bucket.js:5-6, 53-67` — the completeness test rests on an unverified assumption.**
"Already done" (`export-run.js:99`), the post-wait check (`:160`) and the whole freshness answer all treat the presence of `<folder>/<folder>.overall_export_metadata` as proof that the export finished. That is J10, and both plan review rounds accepted it, but nothing in this change or in V-4 proves *when* Firestore writes that object. If it were written at the start of an export, a run could report success over an export still in flight, and `vaultFresh` could call a failed export fresh. Cheap fix: add a V-4 step that, while the first real export is running, checks whether the metadata object is already in the folder.

**4. `docs/my-clay-hub/DATA-RESTORE.md:37-38` — the rehearsal database's rules aren't addressed.**
Per O3 the rehearsal happens in Phase E, so `restore-<date>` would hold a full copy of real member data. This repo's `firestore.rules` covers `(default)` only, and a Console-created database gets whatever rules the wizard offers. The runbook should require the scratch database to be deny-all before the import, alongside "delete it afterwards" (`:38`).

**5. `functions/vault/index.js:39-47` — `vaultExport`'s handler body is executed by no test.**
The emulator lists the trigger but never serves it (`emulator.test.js:49-53`), and `clients.js:12` refuses there anyway, so `admin: firestoreAdmin(), bucket: vaultBucket()` — the one place the real clients are wired into `runExport` — first runs on V-4's Force run. A swapped or misnamed argument would surface as a production error, not a test failure. A small unit test that requires `index.js` with `clients.js` stubbed and calls `.run({scheduleTime})` would close it. (V-4's failure-first bootstrap does catch it before anything depends on it, which is why this isn't blocking.)

### Nits

**6. `export-run.js:131-133`** — the fresh suffix is drawn without excluding the folders step 1 just listed or the prefixes step 2 just read, both of which are in hand. A collision with an *incomplete* folder is the one way to get the mixed folder O5 rules out. ~2e-8, but the exclusion is free.

**7. `export-run.js:77-78`** — an unknown `operationState` is rejected before `outputUriPrefix` is looked at, so one odd export operation anywhere in the database's list (another date, another bucket, a state enum Google adds later) fails every run for as long as it is listed — which spans all four retries of a scheduled run. Checking the prefix first would let a clearly-not-ours operation be ignored, while keeping fail-closed for anything whose ownership can't be determined.

**8. `vault-bucket.js:15-37`** — `listFolders` caps folders but not pages, while `completeMetadata:56` caps pages. Under `weekly/` the page count tracks entries, not folders, so there's no bound at all on the loop; `vaultFresh` has 30 s to finish.

**9. `export-run.js:120`** — `return finish('already done', folder, op.name)` is effectively unreachable: step 1 lists the same prefix and GCS listings are strongly consistent. No test covers it.

**10. `functions/vault/package.json:12`** — `firebase-admin` is declared but never required anywhere in `functions/vault` (I grepped). It is what drags `@google-cloud/firestore` 9.3.0 and ~100 other packages into a function that holds `datastore.databases.export`. Plan V1 named it, so dropping it is Christie's call — and `surface.test.js:20-21, 32` would need adjusting.

**11. Untested defensive branches** in `vault-bucket.js` (`api === null` at `:22`, non-array `prefixes` at `:25`, the folder-name guard at `:27`, "a next page without a page token" at `:34`/`:63`) and `completeMetadata`'s `MAX_META_PAGES` at `:66`. These are the paths that stop a malformed response being read as "no folders", so they're worth a test each.

---

**merge after fixes**
