Verdict: **merge after fixes**

## Blocking

- [scripts/predeploy-check.sh:129](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:129), [scripts/predeploy-check.sh:193](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:193): the cleanup trap removes only `$work`. After `cp` creates `functions/core/functions.yaml`, failures from `cp` after a partial write, `chmod`, `shasum`, or `awk` exit through `set -e` without deleting the manifest. This violates the required “every refusal leaves no `functions.yaml` behind” property and can leave later runs blocked by the stale file. Copy atomically through a temporary destination and register cleanup before the first write; on every nonzero exit remove both the temporary and final manifest. Add failure-injection tests for `cp`, `chmod`, and hashing—not only hash mismatch.

## Should-fix

- [scripts/predeploy-check.sh:152](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:152), [scripts/predeploy-check.sh:193](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:193): the byte/mode check and seal are subject to a final-use race. A background process can modify an already-hashed source file after the `find` loop, or modify `functions.yaml` after line 195 hashes it, and the script still prints success before the CLI reads/packages those paths. In D2-3 this is mitigated by using a private temporary worktree, but neither the backstop nor the plan currently makes that isolation an enforced invariant. Make D2-3 create the worktree with restrictive permissions, prevent unrelated writers during the CLI call, and perform a final source/seal verification as close as possible to packaging. At minimum, document this as the deliberate same-user bypass boundary instead of claiming an unconditional byte closure.

- [tests/functions/manifest.test.js:86](/Users/christiehubley/my-clay-hub/tests/functions/manifest.test.js:86): the test says it verifies refusal on Node other than 22, but every invocation uses `process.execPath` inside the Node-22 emulator session. Removing the Node-major check from `functions-discover.mjs` would leave this test green. Spawn the helper once with the host Node 20 binary, or refactor the version predicate for direct testing.

- [tests/unit/predeploy-cli-path.test.js:56](/Users/christiehubley/my-clay-hub/tests/unit/predeploy-cli-path.test.js:56): the claimed CLI-path `RESOURCE_DIR` test never reaches that check. It changes `firebase.json` without committing the change, so the backstop refuses at the earlier approved-bytes check, as its assertion at line 65 confirms. Build a committed two-codebase fixture so lifecycle hooks invoke the backstop with the second codebase’s real `RESOURCE_DIR`, while `TINKER_DEPLOY_CODEBASE=core`; assert the line-124 refusal.

## Nit

- [tests/unit/functions-fixture.js:52](/Users/christiehubley/my-clay-hub/tests/unit/functions-fixture.js:52), [tests/unit/predeploy-check-functions.test.js:14](/Users/christiehubley/my-clay-hub/tests/unit/predeploy-check-functions.test.js:14): teardown assumes fixture creation succeeded. When `mkdtemp` fails, `after()` dereferences an undefined fixture and turns one setup failure into a large cascade. Guard teardown with `fx?.cleanup()`.

The canary is explicitly private, the emulator launcher redirects `HOME` before the CLI loads and removes the relevant credential variables, and I found no D2-2 change that breaks the existing rules guard or rollback route. The parent-plan amendments match M1–M7; remaining old `functions-build@` text is identified as superseded or records historical steps.

I attempted `node --test tests/unit/`, but this review environment forbids temporary-directory creation, producing `EPERM` fixture failures; it did not provide a meaningful independent green/red test result. Also, the two plan files are currently clean and committed in `tinker-ai-configs` at `c7485ea`, rather than uncommitted as described.
