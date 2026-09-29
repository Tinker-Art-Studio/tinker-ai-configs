I found several blocking design issues. No files or external project state were changed.

Fact check summary: K2–K6, K8–K9, K11, K13, and K14 are substantially correct for firebase-tools 15.22.3. K1 is correct with two caveats: the CLI always appends extra ignores, and its walker follows symlinks. K7 is correct but conflicts with the proposed “never `--force`” policy. K10 has an incorrect field name and overstates what the hash proves. K12’s “CLI cannot choose the build account” is correct, but its claimed default identity is not established for this project.

1. **Blocking — K12/F7/D2-1: the plan secures an assumed build identity, not the verified one.**

   Evidence: K12 says Christie has no organization, but the completed Phase D record says `tinkerartstudio.com` exists and its policies cannot be viewed: [my-clay-hub-phase-d-project.html:399](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:399). It also records an existing principal with the Cloud Build Service Account role: [line 409](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:409). For projects in an organization, the selected default depends on Cloud Build organization-policy state; it cannot be inferred solely from project creation date. See [Cloud Build default service account change](https://docs.cloud.google.com/build/docs/cloud-build-service-account-updates?hl=en).

   The Compute API → immediately remove Editor → grant narrow roles order is sound *if Compute is verified as the selected build identity*. The three proposed roles are Google’s documented minimum for a custom build account, but Google separately recommends `roles/cloudbuild.builds.builder` when using the implicit default Compute account, so sufficiency in this implicit-default configuration remains unresolved. See [Cloud Run functions build process](https://docs.cloud.google.com/functions/docs/building).

   Concrete fix: before deleting `functions-build@` or granting build roles, add a hard Console read-back of Cloud Build’s actual default account. Record the principal and policy evidence. Secure that exact principal. If the Console cannot establish it, or the selected account cannot be reduced to a documented minimum without organization-policy access, stop D2-1. Resolve O3 before marking the plan execution-ready.

2. **Blocking — F5/K7: the guard cannot deploy Phase E’s required retry-enabled event functions.**

   Evidence: firebase-tools throws under `--non-interactive` whenever retry is newly enabled unless `--force` is present: [prompts.js:20](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prompts.js:20), especially lines 37–43. The foundation requires Phase E retries on, while F5 permanently prohibits `--force`: [firebase-functions-deploy-guard.html:78](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:78).

   Concrete fix: design a guarded retry-approval path. One viable design is to preflight and prove there are no deletions, unsafe trigger migrations, minimum-instance increases, missing APIs, or missing cleanup policy, then permit `--force` solely for an explicitly detected retry transition. Add fake-CLI and real-manifest scenarios proving every other effect that `--force` could authorize is rejected first.

3. **Blocking — F3/F4: the approved-byte closure has two holes.**

   Evidence:

   - The package walker uses `statSync` and recursively follows symlinked directories because `ignoreSymlinks` is false: [fsAsync.js:36](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/fsAsync.js:36). Git’s tree records a symlink target string, not the target’s bytes.
   - After predeploy has checked that no `.env*` exists, prepare can create `.env.<project>` from resolved parameters: [prepare.js:101](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:101), [env.js:167](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/functions/env.js:167). Packaging happens later, so generated unapproved bytes can enter the archive.

   Concrete fix: reject every symlink anywhere in the source tree except within excluded `node_modules`, with positive and negative tests. Also reject any discovered non-secret parameter/default until a separately reviewed configuration design exists, or independently reproduce and verify the final package contents after parameter resolution.

4. **Blocking — F9/D2-3: production can change without a receipt.**

   Evidence: the copied rules logic explicitly acknowledges a window after deployment and before tag creation: [deploy-rules.sh:415](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:415). Its pending file is created only after a tag exists but cannot be pushed, at lines 426–430. A termination after the CLI mutates one function, or during read-back, leaves neither tag nor pending record.

   Concrete fix: write a durable, fsynced pending-attempt record in the common git directory before invoking Firebase. It should contain stamp, SHA, codebase, folder tree, and attempt state. `--status` and every later deployment must reconcile it through live read-back before proceeding. Add scenarios for SIGINT/termination after CLI return, read-back failure, tag failure, and push failure.

5. **Blocking — F9: “newest complete is what shipped” is not truthful after a newer partial or unsafe deployment.**

   Evidence: the existing rules guard makes the newest receipt the deployment base because selecting the wrong base invalidates the approval diff: [deploy-rules.sh:78](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:78). F9 instead labels an older complete receipt “what shipped” even after a newer attempt may have changed some or all functions: [firebase-functions-deploy-guard.html:82](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:82).

   `unsafe` and `partial` also are not mutually exclusive, and a fully updated but public deployment may have shipped the newer commit even though status names the older one.

   Concrete fix: separate receipt dimensions, for example `deploy_match=yes|no|unknown`, `access_safe=yes|no|unknown`, and `cli_exit=N`. The newest receipt is always the latest attempt. Only claim a verified deployed commit when read-back proves one. If the newest attempt is mixed or unknown, `--status` must say production is mixed/unverified and `--diff` should refuse until reconciliation, rather than diffing from an older complete receipt.

6. **Blocking — F8: the hash read-back does not prove the deployed function configuration or revision.**

   Evidence: `firebase-functions-hash` contains source, environment, and secret hashes only: [hash.js:10](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/cache/hash.js:10). It does not cover generation, region, trigger, retry, runtime, service account, invoker, ingress, concurrency, or instance limits. The plan also never defines how the expected hash is independently calculated; a partial implementation could simply accept the observed hash.

   K10/F8 additionally name the field `ingress`, but `functions:list --json` returns the normalized endpoint field `ingressSettings`, with values such as `ALLOW_ALL`: [cloudfunctionsv2.js:392](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudfunctionsv2.js:392).

   Concrete fix: define an independently computed expected source hash using the pinned 15.22.3 algorithm, and compare a normalized expected-versus-live endpoint manifest covering platform, runtime, region, trigger and retry, service account, ingress, max/min instances, concurrency, and other security/cost options. Test each field with a mutation that must produce `partial`.

7. **Should-fix — F8: the anonymous probe is useful but is not proof of the IAM policy.**

   An anonymous 401/403 proves only that this particular unauthenticated request was refused. It misses:

   - `allAuthenticatedUsers`, because the request is not authenticated.
   - `allUsers` when public function code itself returns 401/403.
   - Whether the refusal came from Cloud Run IAM, ingress, or application logic.

   The canary is stronger because its known public behavior is 204, so making it public should produce 204. That does not generalize to arbitrary HTTP functions.

   Concrete fix: describe the probe as an unauthenticated-access test, not an invoker-policy read-back. Under the no-gcloud constraint, require the Console invoker-list check after every HTTP-function deploy if IAM proof is required, or explicitly accept and record the `allAuthenticatedUsers`/application-403 residual. Add a public function whose handler returns 403 and an `allAuthenticatedUsers` scenario to prevent overclaiming.

8. **Should-fix — D2-2: the real Firebase CLI test will attempt network/auth work before predeploy.**

   Evidence: the deploy command performs permission and service-account IAM checks before its deploy action: [commands/deploy.js:100](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/commands/deploy.js:100). Predeploy runs only inside that later action. Therefore “nothing reaches the network because predeploy runs before prepare” is false.

   Concrete fix: run the pinned real CLI with an isolated config home, a dummy token, and outbound HTTPS forced to a closed local endpoint; assert no production endpoint was reachable and that the swallowed IAM checks are followed by the expected predeploy refusal. Alternatively revise the acceptance criterion to test the lifecycle module directly and stop claiming it is an unmodified end-to-end CLI test.

9. **Should-fix — D2-3 step 4: discovery is not execution-ready.**

   Evidence: `internaltesting:functions:discover` is registered only when the non-public `internaltesting` experiment is enabled: [commands/index.js:182](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/commands/index.js:182). The command itself obtains Admin SDK configuration and may query Runtime Config: [internaltesting-functions-discover.js:17](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/commands/internaltesting-functions-discover.js:17). The fallback “run the discovery binary directly” lacks the required environment, manifest-output path, YAML parsing, timeout, and cleanup contract.

   Concrete fix: choose the fallback now. Specify an offline helper that invokes the codebase’s pinned `firebase-functions` binary with `FUNCTIONS_CONTROL_API` and `FUNCTIONS_MANIFEST_OUTPUT_PATH`, supplies a minimal non-secret Firebase config, parses the emitted YAML, and deletes the temporary manifest. Test it against the actual pinned binary, not only fake JSON.

10. **Should-fix — F5/D2-3 step 3: dependency and CLI selection are contradictory and unpinned at execution.**

   D2-3 says both “`npm ci` at the root” and “root `node_modules` is symlinked as today”: [firebase-functions-deploy-guard.html:169](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:169). Running `npm ci` against a symlink is at best contradictory and risks modifying/removing the shared install. The production command is also bare `firebase`, so a different global version could execute despite all facts targeting 15.22.3.

   Concrete fix: perform a fresh root `npm ci` with a real worktree-local `node_modules`; do not create the root symlink. Invoke `$TMP/node_modules/.bin/firebase` explicitly and assert its version is exactly 15.22.3. Tests should place their fake at that exact path rather than relying on `PATH`.

11. **Should-fix — D2-3 preview/read-back does not enforce the project’s declared function invariants.**

   Evidence: the plan says 2nd gen, Node 22, `us-central1`, explicit retry, and explicit `maxInstances` are already decided: [firebase-functions-deploy-guard.html:45](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:45). The preview rejects only deletions, public HTTP, and missing/default runtime identity: [lines 170–176](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:170).

   A partial implementation could therefore pass while deploying gen 1, the wrong runtime/region, an implicit retry policy, or no instance ceiling.

   Concrete fix: make these manifest invariants mandatory in preview and normalized live read-back. Add one failing BDD/mutation scenario per invariant, including trigger location where applicable.

12. **Should-fix — D2-2/F10: two foundation requirements are quietly weakened.**

   The foundation explicitly requires the predeploy backstop to reject the wrong codebase and requires Functions emulator tests first: [clayhub-members-foundation.html:573](/Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html:573), [line 576](/Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html:576). The proposed backstop validates only that `RESOURCE_DIR` is *a* configured source, and F10 postpones the emulator.

   Concrete fix: pass and require a guard-only `TINKER_DEPLOY_CODEBASE`, map it exactly to `RESOURCE_DIR`, and test missing/mismatched values through the CLI. Either add a pinned Functions emulator HTTP test for the canary now or record Christie’s explicit supersession of that parent requirement in both plans.

13. **Should-fix — F9/K8: `complete` is possible despite a nonzero CLI exit.**

   F9 defines `partial` only as a read-back mismatch and `unsafe` only as probe failure. Thus exit 1 with a fully matching read-back can become `complete`, contradicting F11’s statement that the cleanup-policy error is never success.

   Concrete fix: require `cli_exit=0`, structural match, and safe probe for `complete`. Define outcomes for nonzero-exit/full-match and read-back-unavailable cases. Add BDD scenarios for exit 1/full match, exit 2/full match, malformed list JSON, list failure, probe timeout, and simultaneous mismatch plus unsafe probe.

14. **Should-fix — F12/D2-4: the hook command inventory is incomplete and its test matrix is underspecified.**

   firebase-tools 15.22.3 also exposes `functions:deletegcfartifacts`, which deletes deployed build artifacts: [functions-deletegcfartifacts.js:18](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/commands/functions-deletegcfartifacts.js:18). It is absent from F12. “A deny for each new command form” could also be satisfied by testing only bare commands, missing absolute paths, `npx firebase-tools`, global flags, compound commands, and quoted non-command mentions.

   Concrete fix: include `functions:deletegcfartifacts`; enumerate the same invocation matrix used by the existing deploy-regex tests for every changing command; retain explicit allow cases for `functions:list`, `functions:log`, config reads, secrets reads, and quoted prose.

not ready
