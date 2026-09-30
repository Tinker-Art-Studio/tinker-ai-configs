# Verdict: merge after fixes

## Blocking

- [scripts/predeploy-check.sh:229](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:229), [scripts/predeploy-check.sh:234](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:234): the cleanup fix still permits a non-zero invocation to leave `functions.yaml`. `sealed=1` is set before the final success `echo`. If that write fails—for example, the deploy output pipe closes—the script exits non-zero but the trap preserves the manifest. Also, under `set -e`, failure of the trap’s initial `rm -rf "$work"` prevents the manifest-removal command from running. Capture `$?` in the trap, disable/reliably tolerate cleanup errors, and remove `functions.yaml` whenever the saved status is non-zero. Add a failure injection after `sealed=1`.

## Should-fix

- [scripts/functions-discover.mjs:65](/Users/christiehubley/my-clay-hub/scripts/functions-discover.mjs:65): the “codebase’s own SDK” check verifies only that `.bin/firebase-functions` exists. It may be a symlink or executable pointing outside that installation, while line 67 reports the unrelated local package’s version. A stale or redirected binary could therefore generate the sealed manifest while the output claims version 7.4.0. Resolve the binary and verify it belongs to `functions/core/node_modules/firebase-functions`, or otherwise verify the invoked SDK itself. D2-3’s fresh `npm ci` mitigates this during guarded deployment, but the earlier finding was not fully fixed in this script.

## Nit

None.

Disposition of the earlier reviews:

- Fixed: SIGPIPE handling, declarations/manifest comparison, rules-control files, host-Node refusal test, emulator allowlist, real two-codebase lifecycle test, teardown guards, hub port, seal-path symlink refusal, quoted filenames, documentation, and unrelated em-dash churn.
- Correctly deferred to D2-3: post-check source/seal races, fresh private worktree per attempt, and guard cleanup of a successful seal.
- Still open: unconditional cleanup after every non-zero backstop exit, as described above.
- Partially fixed: proving discovery used the codebase’s actual SDK binary.

The jq check correctly refuses absent/public/wrong invokers, wrong or missing service accounts, wrong ingress, missing/extra endpoints, and non-HTTP or additional triggers. The real canary shape matches it.

The second `trap` does replace the first and contains both cleanup operations, but those operations are not failure-independent. Without an external mutation or untrusted `PATH`, a normal zero exit leaves the named SHA’s bytes; the documented post-hash race remains deferred to D2-3.

The emulator allowlist removes parent credential and project/emulator variables while retaining the variables needed by the tested CLI path. I found no omitted variable required for the Functions emulator. I did not rerun the suites because this environment blocks their temporary-directory setup.
