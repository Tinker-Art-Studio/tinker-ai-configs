## Verdict: **merge after fixes**

One blocking gap (a one-line data fix), five should-fix, four nits. The core machinery is sound: I could not find a path where production changes without a record, nor where `deploy_verified=yes` is written wrongly. The expected-hash computation is faithful to 15.22.3, the F8 field names match `endpointFromFunction`, the public-invoker closure holds, and the `receipts.sh` extraction is behaviour-identical.

### What I verified in source

**Expected hash (F8/K17) — correct.** `cache/hash.js:getEndpointHash` = `sha1(sourceHash + envHash + secretsHash)`; `getEnvironmentVariablesHash` reads **backend**-level `environmentVariables`, which `prepare.js:110` sets to `{...userEnvs, ...firebaseEnvs}` and which `inferDetailsFromExisting` (`prepare.js:269`, per-endpoint only) never mutates — and `applyBackendHashToBackends` is the *last* call in `prepare` (line 227 of the tail), so `functions-hash.mjs:35` overwriting it with `loadFirebaseEnvs(...)` alone is exactly right for the no-`.env`/no-params case. `populateDefaultParams` marks every built-in `ParamValue(…, true, …)` **internal**, and `prepare.js:116` skips internal params, so omitting that loop is correct. `packageSource` reads only `config.ignore`, so passing `{...entry, ignore:[...entry.ignore]}` is equivalent — and the `[...]` copy is necessary, since `packageSource` *mutates* `ignore` (`prepareFunctionsUpload.js:78`). `runtimeConfig: undefined` ⇒ `configHash=""` ⇒ `hash = sourceHash`, matching. `tests/unit/functions-hash.test.js:46` recomputes K17 independently.

**F8 read-back vs `functions:list --json` — correct.** `commands/functions-list.js` returns `backend.allEndpoints(existing)`, so `.result[]` is `endpointFromFunction` output; every field `JQ_F8`/`JQ_CANON` reads exists with those spellings (`serviceAccount` renamed from `serviceAccountEmail`, `availableMemoryMb` from `availableMemory`, `cpu` from `availableCpu`, `hash` only when the label exists → absent fails closed). The five env keys are right: `cloudfunctionsv2.js:84,134` sets `FUNCTION_TARGET = entryPoint.replaceAll("-", ".")` and `LOG_EXECUTION_ID: "true"` on **both** create and update; `EVENTARC_CLOUD_EVENT_SOURCE` comes from `prepare.js:133`; `GOOGLE_NODE_RUN_SCRIPTS` goes on `buildConfig`, not `serviceConfig`, so it correctly never appears. `--json` suppresses `useConsoleLoggers()` (`command.js:175`), so the table never pollutes stdout.

**Public-path closure — holds.** `proto.getInvokerMembers` returns `["allUsers"]` only for the literal `"public"`; anything else goes through `formatServiceAccount`, which throws without `@` (`proto.js:98`). So `allUsers`/`allAuthenticatedUsers` cannot be smuggled through `declarations.json`. Skip line confirmed verbatim at `release/planner.js:41`.

**receipts.sh extraction — behaviour-identical.** Every call site in `deploy-rules.sh` (lines 85, 110, 115, 128, 178, 229, 238, 264) is argument-less, and `receipt_rows`'s new `p="${1:-$TAG_PREFIX}"` plus `latest_receipt`/`newest_stamp`'s `receipt_rows "${1:-}"` resolve to `$TAG_PREFIX` (`:-` covers the empty string). The awk, the sort keys, `local`-on-its-own-line and the fail-closed/fail-soft split are byte-for-byte the originals; the added readers introduce no name collisions.

**bash 3.2:** I found no `local x="$(cmd)"` masking on a fallible read, no `declare -A`, and every `[ … ] && cmd` that ends a loop body or block is errexit-exempt (left-hand failure). `${STAMP//[TZ]/}` and `=~ {40}` are fine on 3.2.

**Tests I ran:** `bash scripts/deploy-functions.test.sh` → **507 passed, 0 failed**. Its shared-code test exercises the real `deploy-rules.sh --status` through the extracted library and names the same tag. I could **not** run `deploy-rules.test.sh` or `test:unit` — both were denied by this session's permissions, so "the rules suite is green after the extraction" is inspection-only from me.

---

## Blocking

**1. `--attest` can never check the one grant D2-1 removed, so D2-5 step 3 is unexecutable as specified — `functions/iam-expectations.json:4`**

F7 promises "the attestation then confirms neither candidate holds Editor or `cloudbuild.builds.builder`", and D2-5 step 3 has Christie read exactly that. `JQ_ATTEST` (`scripts/deploy-functions.sh:275`) requires `($ev.projectRoles | keys) == ($iam.projectRoles | keys)` — and `iam-expectations.json` lists only `run.invoker`, `cloudfunctions.invoker`, `owner`, `editor`. So the reading is caught in a vice:

- Christie includes `roles/cloudbuild.builds.builder` (as D2-5 step 3 instructs) → keys differ → `iam_attested=no` with a spurious "project roles read […], expected […]".
- She omits it → keys match → **`iam_attested=yes` while the role was never read**.

Failure scenario: between D2-1 step 4 and D2-5, `roles/cloudbuild.builds.builder` is re-granted to `760301318440@cloudbuild.gserviceaccount.com` (a re-run of an old grant, an org policy, a console mis-click). The build then runs under a broadly-privileged account; `--attest` records `iam_attested=yes`, and the record asserts an IAM state nobody checked. Fix: add `"roles/cloudbuild.builds.builder": []` to `projectRoles` (one line; the comparison machinery already handles it). Worth adding the three O3 roles the same way if F7's "only the actual build account holds O3" is to be script-checked.

---

## Should-fix

**2. `iam-expectations.json`'s `runtimeAccounts` is never cross-checked against `declarations.json` — `scripts/deploy-functions.sh:278`**

`--attest` compares the reading's `runtimeAccounts` keys to `iam-expectations.json`'s, but nothing ties that set to the `serviceAccount` values the attempt actually declared. Scenario: a later phase adds `functions/core/report` running as `reports@my-clay-hub.iam.gserviceaccount.com` and updates `declarations.json` but not `iam-expectations.json`. Christie reads the accounts `iam-expectations.json` names (just `canary@`), the keys match, and `iam_attested=yes` — while the roles on the account the new function actually runs as were never read. Add a refusal (or a reason) unless `$iam.runtimeAccounts | keys` equals the set of `$dc[].serviceAccount`.

**3. `--diff` can print "(no change)" when the verification machinery changed — `scripts/deploy-functions.sh:664` (and the `--approved` diff at `:746`)**

`SHOWN_PATHS` (`:113`) is the codebase, `firebase.json`, `declarations.json`, `iam-expectations.json`, `firebase-config.json`. `CONTROL_FILES` (`:119`) also holds `scripts/predeploy-check.sh`, `scripts/deploy-functions.sh`, `scripts/lib/receipts.sh`, `scripts/functions-discover.mjs`, `scripts/lib/functions-hash.mjs` and `tests` — all of which decide *how* the deploy is checked, and none of which appear in the diff Christie approves. Scenario: a commit lands on `main` that deletes the backstop's independent declarations cross-check (`predeploy-check.sh:221-234`) and changes nothing else. `--diff --codebase core` prints "(no change to functions/core firebase.json … since <attempt>)" and exits 0; Christie says the phrase for that sha; the deploy runs with the weakened backstop, and the global rule "if the diff contains hunks you did not write, stop" had nothing to look at. Either widen the diff to `CONTROL_FILES`, or at minimum name the control files that changed since the last verified attempt.

**4. A `functions:list` failure is recorded and printed with no cause — `scripts/deploy-functions.sh:295`, `:554`, `:751`, `:859`**

Under `--json`, `command.js:134-140` writes `{"status":"error","error":"…"}` to **stdout**, and `errorOut` → `logError` → `logger.error` goes nowhere because `useConsoleLoggers()` is skipped in json mode. `list_live` captures stdout in `$2` and stderr in `$2.err`, then every diagnostic reads `$2.err` — which will be empty. Scenario: the deployer lacks `run.services.list` (one of `functions:list`'s two `requirePermissions`), or the Cloud Functions API is off. `--approved` refuses with literally `REFUSED: could not read production (functions:list):  — nothing was deployed.`; post-deploy, the record says `mismatch=functions:list failed or returned malformed JSON: ` and `deploy_match=unknown` with no reason preserved. Read `head -c 400 "$2"` as well (the error JSON is right there).

**5. A wrong `functions/firebase-config.json` pin has no `--reverify` path, contradicting the plan's D2-5 step 2 — `scripts/deploy-functions.sh:434`, `:901`**

The pin's `locationId`/key order is unconfirmed (deviation 1), and the pin feeds the expected hash. If it's wrong, the first deploy records `deploy_verified=no` (correctly). But `--reverify` rebuilds from the **attempt's** commit (`build_expected "$SHA"` → `--firebase-config "${TMP}/functions/firebase-config.json"`), so it re-derives the *same wrong* hash, passes the `:901` equality check against the record, and fails F8 again — forever. Committing the corrected pin doesn't help: `--reverify` never reads the tip's copy. So the plan's D2-5 step 2 ("the fix … is committed, reviewed, and followed by `--reverify` of that same attempt. Nothing is re-deployed") is unreachable for the most likely failure. `FUNCTIONS-ROLLBACK.md:125-131` already says the honest thing ("run the guard again under a new approval"), so this is a plan/expectation divergence, not a code bug — but Christie should know before D2-5 that a pin mismatch means a **second deploy under a second approval**, not a re-verify. (The second deploy does then verify: the source hash and live env are unchanged, so the live hash label is stable.)

**6. `RULES-ROLLBACK.md:32` understates how long the emergency path now holds the lock**

It still says the rules guard re-runs "`npm test` (unit, guard, functions and emulator rules suites)" and notes that the functions suite "prints a SKIPPED line … so it never holds up a rules rollback". `npm test` now also runs `test:functions-guard`, which does **not** skip and takes several minutes (the change's own description: ~4). F10 asked for the stale `npm test` descriptions to be fixed in `deploy-rules.sh --status` and `CLAUDE.md` — both were — but this one is the runbook someone reads while production rules are broken, and it's the one that now materially misleads about the lock hold.

---

## Nits

**7. Preflight and two other refusals have no test — `scripts/deploy-functions.test.sh:249`**

The suite's standard is "every refusal is a test", and `EX_PREFLIGHT` (28) never appears in it: a missing `curl`/`jq`, a non-22 `$NODE22`, the wrong pinned npm version, a missing or wrong-version CLI. All are testable through the harness (it already rewrites `NODE22`, `NPM22_CLI` and `CURL` to fakes — pointing one at a nonexistent path would do it). Also untested: `--codebase core-verify` (the namespace-collision refusal at `:92`), the `cmp -s … "$SELF"` branch of `verifier_is_tip` (`:402`, running a copy of the guard from outside the repo), and `--status`'s "functions unchanged by Y" branch (`:688`) — reachable with a same-sha redeploy whose CLI exits 1.

**8. `scripts/lib/receipts.sh` is sourced before the tip check — `scripts/deploy-functions.sh:101` vs `:711`**

`verifier_is_tip` compares the on-disk library to `origin/main`, but the library has already been sourced by then, and it is sourced *after* `die`/`say`/`warn` are defined (`:64-66`), so a modified copy could shadow them. The circularity is real (`fetch_state` lives in the library and `MAIN_SHA` needs the fetch), and the practical case — an accidental uncommitted edit — is still caught before anything is written or deployed. Closing it fully would mean comparing the library against the pre-fetch `origin/main` before sourcing, or re-sourcing after the check.

**9. `usage()` truncates the help — `scripts/deploy-functions.sh:67`**

`sed -n '2,10p'` stops one line short of line 11, the `--acknowledge-verifier-change` note; `-h` and every usage refusal therefore omit the one flag an operator is most likely to need looking up.

**10. `atomic_write` leaves its temp file on a write failure — `scripts/deploy-functions.sh:302`**

`cat > "$tmp" || return 1` returns without removing `$tmp` (the `rm -f` is only on the node-side failure path), so a full disk leaves `tinker-deploy-inflight-functions.tmp.<pid>` in `.git/` next to a refusal that says nothing about it.
