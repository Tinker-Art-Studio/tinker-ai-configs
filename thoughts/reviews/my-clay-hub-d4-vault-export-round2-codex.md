## Verdict: ready after fixes

The round-1 findings are operationally resolved under Christie’s O5/O6 decisions. The Scheduler claim is correct: `X-CloudScheduler-ScheduleTime` contains the original scheduled invocation time and remains constant across retries. [Google Cloud Scheduler documentation](https://docs.cloud.google.com/scheduler/docs/overview)

Two pinned-client details still block safe implementation.

### Blocking

1. **V7 — listed operations expose raw `Any` metadata**

The plan assumes operations returned by `listOperationsAsync` expose `metadata.outputUriPrefix` and `metadata.operationState` directly ([plan V7](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:109>)). In the pinned Firestore 9.3.0 types, a listed `google.longrunning.Operation.metadata` is `google.protobuf.Any`, not decoded `ExportDocumentsMetadata` ([proto type](</Users/christiehubley/my-clay-hub/functions/core/node_modules/@google-cloud/firestore/types/protos/firestore_admin_v1_proto_api.d.ts:10355>)). Decoding also yields a numeric operation-state enum unless explicitly converted.

The fake-client tests and method-existence check at [V-3](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:232>) would not catch an implementation that silently sees no prefix and starts duplicates.

Required fix: specify and test decoding only the expected `ExportDocumentsMetadata` type URL using the pinned protobuf, normalize the enum, and fail closed on malformed/unknown export metadata. Use a production-shaped encoded `Any` fixture.

2. **V7/V9 — folder-prefix paging needs the pinned Storage response shape**

With `delimiter: "/"`, folder names are returned in `apiResponse.prefixes`. Storage 8.2.0 specifically says to use `autoPaginate: false` to preserve that response while paging ([pinned declaration](</Users/christiehubley/my-clay-hub/functions/core/node_modules/@google-cloud/storage/build/cjs/src/bucket.d.ts:636>)).

The plan currently says only “delimiter” and “paged” ([V7](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:108>), [V9](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:116>)). A natural `getFiles()` implementation could inspect only the returned files, find no folders, and either create another export or report false staleness.

Required fix: pin `autoPaginate: false`, consume `apiResponse.prefixes`, follow `nextQuery`, and test that exact client-shaped response.

### Should-fix

1. **V-2/V-3 — the “only four existing tests change” inventory is incomplete**

[V-2 step 5](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:200>) names four tests, but adding `trigger` already changes the exact declaration assertion in [firebase-config.test.js](</Users/christiehubley/my-clay-hub/tests/unit/firebase-config.test.js:42>). Adding the vault declarations also breaks [manifest.test.js](</Users/christiehubley/my-clay-hub/tests/functions/manifest.test.js:107>), which currently compares all declaration keys with only `core`’s discovered functions.

Name these changes explicitly; make the manifest test filter declarations by codebase and validate the new trigger schema.

2. **J8/V-0/V-4 — the round-2 bootstrap correction left contradictory text**

J16 and the main V-4 branch now correctly say service-agent creation timing and denied-principal logging are undocumented, with a safe fallback and stop condition ([J16](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:73>), [V-4 step 7](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:267>)).

But J8 still says the agent “is created on demand” ([J8](</Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html:65>)), V-0 says the first export creates it, and V-4’s BDD still requires the log to name the principal. Remove those unconditional claims. The operational branch itself is safe.

3. **V7/V9 — caps remain unspecified**

“Expected count plus headroom” is not a testable bound. Rare duplicates plus manual exports can exceed the suggested 8–12 folders while all retained data is valid. Pin numerical caps and test the boundary.

### Nits

- V6’s rationale still says retries finish in “the next hour and a quarter,” although the main text correctly distinguishes fast failures from 1,500-second attempts.
- In the Reviews table, change “after the first failing export creates it” to the conditional J16 bootstrap wording.

V2’s always-present keys, global job-list comparison, `scheduler_attested=n/a`, and old-record compatibility are now coherent. V3’s exact declaration schemas are also sound once the omitted test updates are included. No cloud action or deployment is needed to resolve these findings.
