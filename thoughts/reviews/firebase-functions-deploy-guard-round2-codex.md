I found four round-1 issues that are still not actually resolved, plus several new blockers. The load-bearing K facts are mostly accurate, but the proposed hash, scheduled-function read-back, dependency install, and receipt-finalization mechanisms will not work as claimed.

1. **Blocking — F8: the independently computed expected hash is wrong.**

   Evidence: F8 computes the endpoint label using an “empty env” ([plan:140](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:140)). In 15.22.3, prepare always adds `FIREBASE_CONFIG` and `GCLOUD_PROJECT` ([env.js:247](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/functions/env.js:247), [prepare.js:87](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:87)); `getEnvironmentVariablesHash` hashes the whole backend environment ([hash.js:10](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/cache/hash.js:10)). On updates with no dotenv file, the CLI also preserves existing production environment variables ([prepare.js:260](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:260)).

   Therefore an empty-env calculation cannot equal a normal deployed label. Worse, simply copying the live environment into the calculation would make the proof circular and would silently accept manually injected variables.

   Concrete fix: specify how the guard independently obtains and normalizes the exact Firebase-generated environment, reject unexpected live environment-variable keys before deploying, and calculate the label with that known environment. Add tests for the two mandatory Firebase variables and a pre-existing unexpected variable. If this cannot be done without trusting production values, stop calling the label independent proof of source and use a read-back of the uploaded source object/generation instead.

2. **Blocking — F8: `functions:list` cannot verify a schedule or `retryConfig`.**

   Evidence: F8 promises “the same trigger kind and schedule” ([plan:142](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:142)). For a deployed v2 scheduled function, 15.22.3 reconstructs only `scheduleTrigger: {}` from the `deployment-scheduled` label ([cloudfunctionsv2.js:299](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudfunctionsv2.js:299)). It does not query the Cloud Scheduler job, so schedule, timezone, and retry settings are absent from `functions:list`.

   This breaks the next planned consumer, D-4, whose UTC schedule and explicit retry policy are security/resilience requirements.

   Concrete fix: add an authenticated, read-only Cloud Scheduler job read using an allowed non-gcloud mechanism, normalize its schedule, timezone, target identity, URI, and retry fields, and incorporate those into `deploy_match`. Alternatively, require and record a Console read-back after every scheduled deploy. Add one mutation test per field.

3. **Blocking — F5/F10/D2-3 step 4: the workspace install design remains contradictory.**

   Evidence: the rewrite keeps a symlinked root `node_modules`, runs `npm ci` inside `functions/<cb>` ([plan:126](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:126)), and declares that folder an npm workspace installed by root `npm ci` ([plan:165](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:165)). npm workspace dependencies are normally linked/hoisted into the root `node_modules`, and `npm ci` is an operation on that installation tree. See [npm’s workspace/ci behavior](https://docs.npmjs.com/cli/commands/npm-ci/).

   Thus the codebase may have no local `.bin/firebase-functions`, or the inner `npm ci` may operate on/remove the symlinked root tree. Round 1’s install blocker was changed, not resolved.

   Concrete fix: choose one coherent model:

   - Prefer a real worktree-local root `node_modules`: run root `npm ci`, invoke that worktree’s pinned CLI, and do not symlink the shared installation; or
   - Do not use npm workspaces: keep each codebase as an independent package with its own lock and `npm ci`.

   Test the exact install layout with npm 10.8.2 and assert both pinned binaries resolve from the intended paths.

4. **Blocking — F5/F4: preview and actual deployment do not consume the same manifest.**

   Evidence: the direct preview only says to invoke the SDK binary with `FUNCTIONS_MANIFEST_OUTPUT_PATH` ([plan:127](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:127)). The CLI actually also sets `FUNCTIONS_CONTROL_API=true` and supplies its own Firebase/runtime environment ([runtimes/node/index.js:119](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/runtimes/node/index.js:119)). During the real deploy, predeploy runs first and then the CLI executes the source again during prepare. Approved code can therefore emit a different manifest based on environment, time, or other local state. Discovery code can also modify files after the backstop check and before packaging.

   A safe preview followed by an actual callable or public HTTP manifest could change production before F8 detects it.

   Concrete fix: seal the preview result and force the real CLI to consume that exact manifest. One viable design is:

   - Run preview with the correct control environment.
   - Re-run the folder-integrity check after preview.
   - Have predeploy install the sealed manifest as a temporary `functions.yaml`.
   - Add `functions.yaml` to the exact ignore list so it drives discovery but is not uploaded.
   - Verify its hash against guard-supplied metadata and remove it during cleanup.

   Add tests for environment-dependent discovery and source mutation during discovery.

5. **Blocking — F8/F9/D2-5: invoker-policy verification cannot be recorded as designed.**

   Evidence: the amendment says the Console IAM reading is logged in the “receipt’s follow-up line” ([plan:71](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:71)). But F9 creates the immutable receipt before the command exits, removes the in-flight record, and only then tells Christie to inspect Permissions ([plan:152](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:152), [plan:272](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:272)). No mechanism exists to append to an immutable pushed tag.

   Consequently `verified=yes` can exist while `allAuthenticatedUsers` or a stray principal is present. The anonymous request cannot detect either. It also does not literally prove “no stranger can call it”; it proves only that one unauthenticated request was refused.

   Concrete fix: separate automated deployment verification from IAM attestation. Create a second immutable attestation tag or leave the attempt pending until Christie records the exact invoker list. `--status` should distinguish `deploy_verified` from `iam_verified`. Replace “no stranger” with “an unauthenticated request was refused.”

6. **Blocking — F8/O2: the first canary receipt cannot safely be `verified=yes`.**

   Evidence: O2 says the Google refusal signature is learned during the first live deploy and later back-ported into tests ([plan:370](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:370)), while D2-5 requires that same first receipt to say `verified=yes` ([plan:331](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:331)). Before the signature is known and implemented, the guard cannot reliably distinguish a platform denial from application code returning 403.

   Concrete fix: make the bootstrap deploy unverified by construction. Observe and document the signature, commit the classifier and fixture, review that commit, then re-probe/reconcile or perform a second guarded deploy. Do not retroactively claim that the first implementation verified something it did not yet know how to recognize.

7. **Blocking — F1/F9: copying the rules guard’s stamp behavior breaks “newest receipt = latest attempt.”**

   Evidence: F1 requires every new stamp to order after every earlier outcome ([plan:107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:107)). The copied rules guard deliberately proceeds after ten seconds with a stale clock and writes a tag that sorts below the prior receipt ([deploy-rules.sh:370](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:370), especially lines 398–403). If copied unchanged, `--status` can hide the actual latest functions attempt.

   Concrete fix: for functions, stale-clock exhaustion must refuse before the CLI call. Add a test where the existing receipt’s stamp is in the future and prove no deployment occurs.

8. **Blocking — F9: an unverified reconciliation does not stop a later deploy racing a still-running operation.**

   Evidence: an in-flight record blocks only until `--reconcile` writes a receipt ([plan:162](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:162)). Killing the local CLI does not necessarily cancel Google’s long-running create/update operation. A quick reconciliation may see the old function, write `verified=no`, remove the marker, and permit another deployment while the first operation later completes.

   Concrete fix: keep recovery blocked until the relevant Google operation is terminal, or require a documented Console operation-state check and explicit recovery authorization. A mere mismatching `functions:list` snapshot is not sufficient. Add a scenario where production changes after the first reconciliation read.

9. **Blocking — F2/F13: runtime identity is insufficiently constrained.**

   Evidence: the generic guard accepts any named service-account email that is not the selected build account ([plan:142](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:142), [plan:258](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:258)). It would accept the Firebase Admin SDK service account or another broad project account.

   For the canary, F2 happens to prescribe `canary@`, but the guard intended for D-4 and later phases does not enforce a per-function identity inventory.

   Concrete fix: require an exact function-to-runtime-account allowlist in reviewed configuration and categorically deny default Compute, legacy Cloud Build, Firebase Admin SDK, build, and unknown service accounts. Add a broad-runtime-account mutation test.

10. **Should-fix — K12/F7/O3: the build-role plan is close, but two claims are unsound.**

   Evidence:

   - K12 says enabling Compute creates the account “with Editor” ([plan:96](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:96)). That is not guaranteed: the automatic-grants organization policy can create it without Editor. Google specifically notes that newer organizations do this. [Cloud Build default-account documentation](https://docs.cloud.google.com/build/docs/cloud-build-service-account-updates).
   - O3 says any real build failure can trigger fallback to broad `roles/cloudbuild.builds.builder` ([plan:377](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:377)). A generic failure does not prove that entire role is required.

   The identify-first ordering is otherwise sound, and Google documents Logs Writer, repository-scoped Artifact Registry Writer, and condition-scoped Storage Object Viewer for a custom build identity. [Cloud Run functions build process](https://docs.cloud.google.com/functions/docs/building).

   Concrete fix: say “inspect and remove Editor if present.” Treat a build failure as a stop: diagnose the exact denied permission and obtain Christie’s approval for any widening. Do not automatically fall back to `builds.builder`.

11. **Blocking — Amendments/F10: the foundation requirements are still unsatisfied and owner approval is pending.**

   Evidence: the foundation explicitly requires a direct CLI test, invoker-policy/revision read-back, and Functions emulator tests first ([foundation:573](/Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html:573)). The rewrite labels all three as amendments needing Christie’s OK ([plan:68](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:68)).

   The emulator rationale is also factually wrong: the canary is an HTTP-triggered function, so it does have a trigger that the Functions emulator can exercise.

   Concrete fix: either add a pinned Functions emulator test for the canary and preserve the parent requirements, or obtain explicit owner approval and append the deviations to the foundation plan’s decision log. The lifecycle module test is useful, but it is not “calling the Firebase CLI directly.”

12. **Should-fix — F13/D2-3: explicit schedule retry enforcement has no acceptance test.**

   Evidence: F13 requires explicit `retryConfig` ([plan:168](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:168)), but D2-3’s enumerated discovery refusals omit missing/default retry configuration, and the test matrix has no retry/timezone mutation. This permits a partial guard to pass while violating D23.

   Concrete fix: add discovery refusals and positive pairs for missing retry config, wrong timezone, wrong schedule, and the exact accepted “retries off/on” representation. Pair this with finding 2’s Cloud Scheduler read-back.

13. **Should-fix — O4: tests and discovery run under the wrong Node major.**

   Evidence: the target runtime is Node 22, but the laptop is Node 20.20.2; O4 treats installing/using Node 22 as optional ([plan:378](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:378)). The CLI source confirms discovery uses the host executable and only warns about a mismatch.

   Concrete fix: require a pinned Node 22 executable for install, tests, and both discovery paths, and refuse if its major is not 22. This matters more now because Node 20 reaches the recorded decommission date on October 30, 2026.

14. **Should-fix — F9: the in-flight record is not fully crash-durable as specified.**

   Evidence: F9 says only that the file is written and fsynced ([plan:154](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:154)). A kill or power loss during creation can leave a truncated record; fsyncing a file does not by itself make the directory entry/rename durable.

   Concrete fix: write a temporary file in the common git directory, fsync it, atomically rename it, fsync the directory, and fail closed on any malformed marker. Add truncated-marker and interrupted-write tests.

Round-1 disposition summary: the rewrite genuinely fixes symlink packaging, generated params, trigger allowlisting, exact `firebase.json`, wrong-codebase detection, exit-code semantics, command inventory, configuration-field comparison, and creation of a pre-CLI attempt marker. The workspace install, invoker proof, emulator requirement, and receipt-ordering issues remain unresolved; the hash and schedule-read-back designs introduce new blockers.

**Verdict: not ready**
