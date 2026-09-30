not ready

## Findings

### Blocking — IAM attestation can write `iam_attested=yes` without proving F7

[scripts/deploy-functions.sh:288](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:288) independently checks:

- project-role holders against the static expectations file; and
- that `buildAccount` is either permitted candidate.

It never requires the O3 role holders to equal the reported `buildAccount`.

Concrete failure: evidence reports the legacy Cloud Build account as the actual builder, while `roles/logging.logWriter` and `roles/storage.objectViewer` remain on the Compute account exactly as currently declared in [iam-expectations.json:4](/Users/christiehubley/my-clay-hub/functions/iam-expectations.json:4). All comparisons pass and `iam_attested=yes` is written, although F7 requires only the actual build account to hold O3.

Two more F7 properties are not representable by the evidence schema:

- The required condition limiting Storage Object Viewer to function-source buckets. Removing that condition leaves the same holder array, so attestation still passes.
- Artifact Registry Writer on `gcf-artifacts`. Repository-level permissions do not appear anywhere in `JQ_ATTEST_SHAPE` at [deploy-functions.sh:262](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:262).

Therefore `iam_attested=yes` currently overclaims build-account safety. Bind the expected O3 principals dynamically to `buildAccount`, represent/check the Storage Object Viewer condition, and include the repository-level Artifact Registry grant—or explicitly narrow what `iam_attested` claims and amend F7.

### Should-fix — the printed and documented attestation shape is now stale

The deployment instructions at [deploy-functions.sh:632](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:632) show only four project roles. The actual expectations now require seven, including:

- `roles/cloudbuild.builds.builder`
- `roles/logging.logWriter`
- `roles/storage.objectViewer`

Following the guard’s own printed JSON shape therefore yields `iam_attested=no` because the project-role keys differ. The runbook repeats the incomplete list at [FUNCTIONS-ROLLBACK.md:108](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:108).

The guard should generate the example from `iam-expectations.json`, or the text and runbook must list every required field.

### Should-fix — changed-verifier records do not consistently use the recorded verifier

`verifier_fields` records the fetched `origin/main` tip as the verifier at [deploy-functions.sh:622](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:622). But `--reconcile` and `--reverify` call `build_expected "$SHA"` at [deploy-functions.sh:871](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:871) and [deploy-functions.sh:917](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:917), where `$SHA` is the old attempt commit.

That worktree then runs the attempt’s versions of:

- `scripts/predeploy-check.sh`
- `scripts/functions-discover.mjs`
- `scripts/lib/functions-hash.mjs`

See [deploy-functions.sh:430](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:430) and [deploy-functions.sh:443](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:443).

Thus, after `--acknowledge-verifier-change`, a record can say verifier commit X while important verification helpers actually came from older attempt Y. `--attest` and `--clear-inflight` do not create a verifier worktree at all. This does not satisfy F9’s requirement that every tag-writing mode run its checks from a clean worktree at the fetched tip.

Use the attempt for payload bytes but the tip for verification machinery, or record the exact mixed provenance and amend the plan.

### Should-fix — tests miss both issues above

The matching IAM fixture hardcodes the Compute account as both builder and role holder at [deploy-functions.test.sh:238](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:238). The only build-account negative case uses an entirely invalid account at [deploy-functions.test.sh:658](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:658).

Missing cases include:

- valid legacy `buildAccount` while O3 remains on Compute;
- missing/widened Storage Object Viewer condition;
- missing or extra Artifact Registry Writer;
- evidence constructed from the guard’s printed example.

The changed-verifier test at [deploy-functions.test.sh:677](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:677) changes only the top-level guard. It does not mutate `functions-discover.mjs`, `functions-hash.mjs`, or `predeploy-check.sh`, so it passes while old helper code is still used.

The suite also claims broad refusal coverage but does not directly exercise several `JQ_MANIFEST` branches, including bad `specVersion`, extensions, an empty endpoint set, extra `httpsTrigger` keys, and malformed declaration fields.

## Verified as sound

- The expected-hash implementation matches firebase-tools 15.22.3: source packaging via `prepareFunctionsUpload`, backend Firebase env hashing, secrets hashing, and `applyBackendHashToBackends`. See [functions-hash.mjs:24](/Users/christiehubley/my-clay-hub/scripts/lib/functions-hash.mjs:24).
- F8 uses the real `endpointFromFunction` names correctly: `serviceAccount`, `availableMemoryMb`, `cpu`, `environmentVariables`, `uri`, `codebase`, and `hash`. The five runtime env keys and hyphen-to-dot `FUNCTION_TARGET` behavior match the installed CLI source.
- The pinned `FIREBASE_CONFIG` deviation fails closed: a wrong value/order produces hash and live-config mismatches and cannot yield `deploy_verified=yes`.
- The `cli_exit` in-flight extension and newest-verification-record semantics are coherent.
- I found no route to an incorrect `deploy_verified=yes`; the blocking false-positive is confined to `iam_attested=yes`.
- The rules receipt extraction preserves the old rules behavior: optional-prefix changes default back to `TAG_PREFIX`, and existing rules call sites remain argumentless.
- Bash 3.2 syntax, JavaScript syntax, and `git diff --check` passed. I did not rerun the mutating temp-repository suites in this read-only execution environment.
