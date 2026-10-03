## Findings

### Blocking

1. **Other-codebase paths can escape the private worktree.**

`install_other_codebases` does not validate each `codebase` against the normal codebase-name regex. The equality check `source == functions/${codebase}` still accepts, for example, a codebase containing `../` segments. The subsequent `-d` check also follows symlinks. Consequently, `npm ci --prefix` can target a directory outside the worktree ([scripts/deploy-functions.sh:570](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:570), [scripts/deploy-functions.sh:574](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:574), [scripts/deploy-functions.sh:575](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:575), [scripts/deploy-functions.sh:577](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:577)).

This also applies to a validly named `functions/foo` committed as a symlink: `-d` follows it, whereas the F3 regular-file/symlink protection is run only for the selected codebase ([scripts/predeploy-check.sh:138](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:138), [scripts/predeploy-check.sh:164](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:164)).

The guard should validate every entry’s types and codebase syntax, reject duplicates/missing names, and prove each resolved source is a real, non-symlinked directory beneath the worktree. Tests should cover `../`, an absolute-target symlink, malformed/missing codebase fields, and duplicates.

2. **The new installs execute unreviewed arbitrary lifecycle code after the target has been checked and discovered.**

`npm ci` runs package and dependency lifecycle scripts by default. Both current lockfiles contain dependencies marked `hasInstallScript`, so this is not merely theoretical ([functions/vault/package-lock.json:131](/Users/christiehubley/my-clay-hub/functions/vault/package-lock.json:131), [functions/vault/package-lock.json:2468](/Users/christiehubley/my-clay-hub/functions/vault/package-lock.json:2468)).

The target’s two F3 checks, discovery, manifest validation, and expected source hash are completed first ([scripts/deploy-functions.sh:610](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:610)); other lifecycle scripts then execute at [scripts/deploy-functions.sh:991](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:991). Such a script can write anywhere the user can:

- inside the target codebase;
- elsewhere in the worktree;
- into the manifest/discovery area adjacent to the worktree;
- through the root `node_modules` symlink into the real repository ([scripts/deploy-functions.sh:555](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:555));
- directly elsewhere outside the worktree.

The later CLI predeploy hook does protect the target’s tracked source and rechecks the sealed manifest ([scripts/predeploy-check.sh:138](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:138), [scripts/predeploy-check.sh:203](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:203)). It does not validate the other codebase, the rest of the worktree, or the shared root `node_modules`. In particular, the pinned CLI is later executed from that shared repository installation ([scripts/deploy-functions.sh:423](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:423), [scripts/deploy-functions.sh:1034](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1034)).

Also, the other codebases’ `package.json` and lockfiles are absent from `CONTROL_FILES` and `SHOWN_PATHS`, even though they now determine executable behavior during a deploy ([scripts/deploy-functions.sh:115](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:115), [scripts/deploy-functions.sh:121](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:121), [scripts/deploy-functions.sh:916](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:916)). Thus `--diff` is no longer the promised full review surface.

At minimum, either disable lifecycle scripts for these test-only installs if the suites do not need them, or explicitly contain and verify their effects. Every package/lockfile whose install is executed must also be included in the approval/control-file surface.

### Should-fix

3. **The added tests cover normal behavior and simple failures, but not the safety boundary introduced here.**

The happy-path assertion, other-codebase `npm ci` failure, odd source, and missing folder tests are meaningful ([scripts/deploy-functions.test.sh:329](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:329), [scripts/deploy-functions.test.sh:481](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:481)). However, the fake npm only creates `node_modules`; it cannot expose lifecycle mutation or path-following problems ([scripts/deploy-functions.test.sh:54](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:54)). Add tests for the two blocking cases above and confirm the target’s proof/discovery occurs after any permitted executable install activity.

The changed older schedule-attestation scenario remains meaningful. Adding `functions/other` merely makes its new prerequisite real; the assertions still test whether an undeployed versus deployed other codebase contributes to the expected Scheduler job list ([scripts/deploy-functions.test.sh:1032](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:1032)).

## Other conclusions

- With ordinary, contained paths and non-hostile lifecycle behavior, the target remains the only codebase selected for upload because the CLI receives `--only functions:${CB}` ([scripts/deploy-functions.sh:1035](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1035)). Other `node_modules` are outside its source and are not uploaded.
- The source hash and manifest are computed before the new installs, but the predeploy F3 and seal checks prevent an ordinary later target-source or manifest mutation from silently shipping. They do not address CLI/shared-repository tampering.
- Bad source, missing folder, or `npm ci` failure occurs before the attempt stamp, production read, in-flight record, and CLI call ([scripts/deploy-functions.sh:991](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:991), [scripts/deploy-functions.sh:995](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:995), [scripts/deploy-functions.sh:1009](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1009)). It therefore fails closed with respect to Firebase deployment, although a lifecycle script may already have changed local files.
- `--reconcile`, `--reverify`, `--clear-inflight`, and `--attest` never call `install_other_codebases`; only `--approved` does. As expected for any guard change, operations on older attempts can still require `--acknowledge-verifier-change` through `verifier_fields` ([scripts/deploy-functions.sh:764](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:764), [scripts/deploy-functions.sh:1100](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1100), [scripts/deploy-functions.sh:1156](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1156), [scripts/deploy-functions.sh:1189](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1189)).
- `git diff --check` and both shell syntax checks passed. I did not run the write-heavy test suite in the read-only review environment.

merge after fixes
