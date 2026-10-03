## Findings

### Blocking

1. The functions-guard test can target the real repository for deletion if `mktemp` fails.

The suite does not use `set -e`; it assigns `T` from `mktemp` without checking success, then `cd "$T"` with an empty value. Bash treats `cd ""` as staying in the current directory, so `T` becomes the repository path and the EXIT trap runs `rm -rf "$T"` ([deploy-functions.test.sh:19](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:19), [deploy-functions.test.sh:23](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:23), [deploy-functions.test.sh:25](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:25)).

This occurred when I attempted `npm run test:functions-guard` in the read-only environment: `mktemp` failed, setup continued in the repository, and cleanup attempted to remove it. Sandbox permissions prevented every write/removal; `git status` remains clean and the workspace is intact. The test must fail immediately unless a non-empty temporary directory was successfully created, and the cleanup target should be validated before `rm -rf`.

This defect predates the branch, but it makes the required test command unsafe, so I consider it blocking.

### Should-fix

None in the production guard changes.

### Nit

The round-2 directory-symlink assertion remains ineffective. It searches the fake npm log for `outside-vault` ([deploy-functions.test.sh:517](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:517)), but fake npm records the supplied unresolved prefix, not its physical destination ([deploy-functions.test.sh:54](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:54)). The refusal and message assertions are meaningful, and the new pre-install F3 proof adds protection, but this specific “npm never installed there” assertion still cannot prove what it says.

## Requested checks

The substantive round-2 guard findings are resolved:

- Every selected codebase passes F3 and the lockfile rule before its lifecycle-enabled `npm ci` ([deploy-functions.sh:646](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:646), [deploy-functions.sh:648](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:648), [deploy-functions.sh:650](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:650)).
- Every other codebase passes the same folder proof and lockfile rule before its test-only, `--ignore-scripts` install ([deploy-functions.sh:597](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:597), [deploy-functions.sh:600](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:600)).
- F3 rejects committed symlinks and compares every on-disk regular file against the commit ([predeploy-check.sh:143](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:143), [predeploy-check.sh:151](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:151), [predeploy-check.sh:164](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:164)).
- The lockfile rule rejects links and every non-registry or non-sha512 dependency ([deploy-functions.sh:611](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:611)).
- Other-codebase source is now included as a whole tree in `CONTROL_FILES`, so it is tip-pinned and named by `--diff` ([deploy-functions.sh:561](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:561)).
- The formerly vacuous selected-install assertion now first proves the log line exists and then checks that exact line for `--ignore-scripts` ([deploy-functions.test.sh:335](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:335)).

The real core and vault lockfiles are compatible: both are lockfile v3 ([core package-lock:3](/Users/christiehubley/my-clay-hub/functions/core/package-lock.json:3), [vault package-lock:3](/Users/christiehubley/my-clay-hub/functions/vault/package-lock.json:3)). I checked all 265 non-root entries in each; none violates the registry/sha512 predicate.

Reconcile and reverify remain viable. They require verifier-change acknowledgment before rebuilding ([deploy-functions.sh:802](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:802)), then use the newly hardened `build_expected` ([deploy-functions.sh:1150](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1150), [deploy-functions.sh:1194](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1194)). The locally recorded core attempts also have v3 lockfiles satisfying the new rule.

The new refusal, ordering, source-pinning, and non-vacuity tests are otherwise meaningful ([deploy-functions.test.sh:337](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:337), [deploy-functions.test.sh:525](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:525), [deploy-functions.test.sh:532](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:532), [deploy-functions.test.sh:542](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:542)).

`bash -n` and `git diff --check` passed. The full guard suite could not safely complete for the blocking reason above. No files were modified, no deployment occurred, and no Google call was made.

not ready
