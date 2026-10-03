## Findings

### Blocking

1. Other-codebase package metadata can still escape the worktree.

The new checks prove `functions/<codebase>` itself is a contained, non-symlinked directory, but do not validate `package.json` or `package-lock.json` as regular contained files before `npm ci` reads them ([deploy-functions.sh:584](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:584), [deploy-functions.sh:591](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:591), [deploy-functions.sh:596](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:596)).

`CONTROL_FILES` pins a Git symlink’s blob—the link target text—not the bytes of the external file ([deploy-functions.sh:123](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:123), [deploy-functions.sh:561](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:561)). Therefore, an approved `functions/vault/package-lock.json -> /outside/lock.json` can change after approval and control what is installed. `--ignore-scripts` prevents installation hooks, but the subsequent required test run can load the installed dependencies through the functions emulator ([deploy-functions.sh:1012](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1012), [functions-emulator.mjs:99](/Users/christiehubley/my-clay-hub/scripts/functions-emulator.mjs:99)).

Likewise, regular package files can contain an escaping `file:`/`link:` dependency whose out-of-tree contents are not pinned. The present real lockfiles contain no such dependency, but the guard does not enforce that invariant.

Require both package files to be regular, non-symlinked files matching their Git blobs, and refuse or contain local dependency paths before installation.

2. The selected codebase still executes `npm ci` before any containment/symlink proof.

`make_worktree` accepts the selected source using `-d`, which follows symlinks; `install_codebase` then runs lifecycle-enabled `npm ci`. Only afterward does `folder_check` invoke F3 ([deploy-functions.sh:565](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:565), [deploy-functions.sh:571](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:571), [deploy-functions.sh:573](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:573), [deploy-functions.sh:629](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:629)).

Thus a committed `functions/core` symlink—or symlinked selected package file—can direct lifecycle-enabled npm at mutable external content. F3 will eventually reject it ([predeploy-check.sh:138](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:138), [predeploy-check.sh:151](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:151)), but only after unapproved code may have executed. This predates round 2, but it remains an execution escape explicitly within review item 3.

Run a containment/regular-file F3 proof before the selected install, while retaining the post-install proofs.

### Should-fix

None beyond the blockers.

### Nits

- The new happy-path assertion intended to prove the selected install still permits scripts contains `*`, but `assert_lacks` uses fixed-string matching, so the assertion cannot match a real log line and is ineffective ([deploy-functions.test.sh:34](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:34), [deploy-functions.test.sh:335](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:335)).
- The folder-symlink scenario meaningfully checks the refusal and message, but the “npm never installed there” assertion searches for `outside-vault`; the fake npm logs the unresolved worktree prefix, so that assertion would not detect an escaped write if both containment checks regressed ([deploy-functions.test.sh:506](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:506), [deploy-functions.test.sh:511](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:511)).

## Requested checks

The direct round-1 fixes are otherwise present:

- Invalid, missing, duplicate and `../` codebase names are rejected from tip `firebase.json` ([deploy-functions.sh:544](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:544)).
- Other codebase directories are checked for parent containment, symlinks and physical-path equality ([deploy-functions.sh:584](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:584)).
- Other installs use `--ignore-scripts`; the selected install remains lifecycle-enabled ([deploy-functions.sh:573](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:573), [deploy-functions.sh:595](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:595)).
- Other package files join `CONTROL_FILES`, so they are tip-pinned and named by `--diff` machinery output ([deploy-functions.sh:561](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:561), [deploy-functions.sh:134](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:134)).
- The real core/vault `firebase.json` satisfies the new validation.

Growing `CONTROL_FILES` does not make historical operations impossible. It means changes to another codebase’s package files now count as verifier changes: `--reconcile`, `--reverify`, `--attest`, and `--clear-inflight` refuse old attempts until `--acknowledge-verifier-change` is supplied ([deploy-functions.sh:783](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:783), [deploy-functions.sh:1119](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1119), [deploy-functions.sh:1131](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1131), [deploy-functions.sh:1175](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1175), [deploy-functions.sh:1208](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1208)). `--status` and `--diff` do not call `verifier_fields`, so they remain read-only and unaffected.

The validation tests are meaningful for malformed entries, duplicate names, directory symlinks, tip pinning and diff visibility ([deploy-functions.test.sh:496](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:496), [deploy-functions.test.sh:505](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:505), [deploy-functions.test.sh:513](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:513)), but they lack package-file symlink/local-dependency coverage.

`bash -n` for both scripts and `git diff --check` passed. I did not run the write-heavy suite in the read-only environment. No files were modified and no Google calls were made.

not ready
