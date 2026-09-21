1. **blocker — [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:35), [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:182), [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:189): production safety boundaries are injectable.**  
   `DEPLOY_GUARD_REPO=/tmp/other-repo scripts/deploy-rules.sh --approved <sha>` validates and deploys a different repository despite the stated pinned-repo invariant. Likewise, prepending a fake `npm` or `firebase` to `PATH` makes tests/deploy report success and produces a receipt even though no real deploy occurred—the test harness demonstrates this exact mechanism.  
   **Exact change:** remove `DEPLOY_GUARD_REPO` from the production script and invoke allow-listed absolute/realpath-validated `npm` and `firebase` binaries. For testing, generate a patched temporary copy of the guard with the test repository/binaries compiled into that copy, or test lower-level functions rather than leaving production injection points enabled.

2. **blocker — [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:160), [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:182), [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:189), [scripts/predeploy-check.sh](/Users/christiehubley/studio-hub/scripts/predeploy-check.sh:18): the approved commit controls the machinery that decides what is tested and shipped.**  
   A commit on `origin/main` can change `firebase.json` to `"rules": "other.rules"` and remove or replace the predeploy hook. The guard still tests and hashes `firestore.rules`, while Firebase ships `other.rules`; the resulting receipt names and hashes the wrong file. An older rollback commit also lacks the hook entirely—the seeded `1da12e3` version of `firebase.json` has no predeploy entry. Similarly, a commit can change `package.json` so `npm test` does nothing.  
   **Exact change:** separate trusted deploy machinery from approved payload content. Pin and validate the control files (`firebase.json`, `package.json`, `scripts/predeploy-check.sh`) against known trusted blob IDs, or generate a minimal trusted Firebase config with fixed target paths and a fixed byte-check command. Refuse before testing/deploying if the approved commit changes those files unexpectedly. Also perform the byte comparison in the guard itself immediately before and after Firebase returns.

3. **should-fix — [firebase.json](/Users/christiehubley/studio-hub/firebase.json:1): the Firebase predeploy hook can be skipped with `--config`.**  
   For example, `TINKER_DEPLOY_SHA=<sha> firebase --config /tmp/no-hook.json deploy --only firestore:rules --project tinker-hq-apps` uses a config without the hook. Firebase CLI 15.22.3 exposes `-c, --config <path>` globally. There is no ordinary deploy-specific “skip hooks” flag, but selecting another config has the same effect. Thus the comments and commit message claiming that raw terminal, wrapper, absolute-path, and `npx` invocations are mechanically forced through the check are too strong.  
   **Exact change:** either move deployment credentials to an execution boundary that only the guard can use, or explicitly treat the Phase 2 command hook as required enforcement and make it reject every raw deploy including `--config`. At minimum, correct the Phase 1 documentation so it does not claim `firebase.json` alone is unbypassable.

4. **should-fix — [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:137): reconciliation treats tag names as proof and publishes every local `deployed/*` tag.**  
   A hand-created tag under that namespace is automatically pushed and becomes a purported production receipt. Also, if origin already has the same tag name pointing to a different annotated-tag object, the stripped `ls-remote` name makes reconciliation consider it published; it never compares object IDs. A same-second/same-sha7 collision between clones can produce precisely that state.  
   **Exact change:** persist the exact pending receipt ref and expected tag-object ID when a post-deploy push fails, then reconcile only that pending receipt. Compare the local and remote tag-object IDs and refuse on disagreement. Validate that it is annotated and that its commit/file/hash/message fields are internally consistent before publishing.

5. **should-fix — [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:84): status and diff do not explicitly synchronize receipt refs.**  
   They fetch only `origin main`, then select a local tag. Git normally auto-follows applicable tags, and this repository currently has no `remote.origin.tagOpt=no-tags`, but that is not guaranteed. A deploy from another clone or a locally deleted receipt can therefore make `--status` report an older receipt or “none.” Conversely, a receipt deleted only on origin remains “live” locally and the next deploy republishes it. If `origin/main` has never been fetched and origin is unreachable, line 87 exits with an unhandled Git error rather than the advertised warning/sentence.  
   **Exact change:** explicitly fetch the receipt namespace, reject tag-object conflicts, and calculate “latest” from synchronized refs. If the fetch fails, use a verified cached `origin/main` and cached receipt set or refuse plainly when either is absent.

6. **should-fix — [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:49): missing option operands exit silently with status 1.**  
   On macOS Bash 3.2, both `scripts/deploy-rules.sh --approved` and `scripts/deploy-rules.sh --status --target` hit `shift 2` with only one argument. I confirmed both produce no sentence and exit `1`, bypassing `EX_USAGE=10`.  
   **Exact change:** before consuming either option, require at least two arguments and call `die "$EX_USAGE" "...requires a value"`.

7. **should-fix — [scripts/deploy-rules.test.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.test.sh:34): the fake Firebase does not faithfully select the requested target’s hook.**  
   It extracts the first `predeploy` entry in the JSON, so the storage integration test actually runs the Firestore hook. There is no `firestore:indexes` integration test. The fake also proves only that its own hand-written hook emulation runs, not that Firebase’s target reduction invokes it.  
   **Exact change:** have the fake parse its `--only` argument and select the corresponding config block, then add separate rules/indexes/storage assertions. Pin the Firebase behavior with a test or source-level compatibility check for `filterTargets`/`lifecycleHooks`.

8. **nit — [scripts/deploy-rules.sh](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:74): `latest_receipt` is a `head` pipeline under `pipefail`.**  
   Once enough receipt names fill the pipe buffer, `head -n 1` can close early and make `git tag` exit on SIGPIPE, causing an unexplained guard exit.  
   **Exact change:** use `git for-each-ref --sort=-refname --count=1 --format='%(refname:short)' "refs/tags/${TAG_PREFIX}"`, avoiding the pipeline.

### Plan claims not pinned by the tests

The suite does not currently prove:

- Repository paths or `TMPDIR` containing spaces.
- `npm test` itself ran from the worktree; only Firebase’s cwd is asserted.
- `firestore:indexes`, or that Firestore rules/index subtargets both invoke the Firestore hook.
- A changed/missing `firestore.indexes.json`.
- A changed `firebase.json`, predeploy script, or test command.
- `.gitattributes` clean/smudge/EOL behavior, symlink targets, or gitlinks.
- Fetch refreshing a previously stale `origin/main`.
- Fetch/`ls-remote` failures and their exact exit codes/messages.
- Remote-only, locally deleted, malformed, lightweight, hand-created, or same-name/different-object receipt tags.
- Timestamp collision behavior.
- Cleanup after SIGINT, worktree creation failure, tag creation failure, or receipt-push failure.
- That the push was exactly one non-force tag refspec rather than merely observing the final remote state.
- Every receipt annotation field and the fact that the receipt object is annotated.
- `--status`/`--diff` with an unreachable origin, missing cached branch, broken receipt, or remote-only receipt.
- Missing option operands.
- The absence of a Firebase configuration override bypass.

### Checked and found sound

- The scripts parse under this Mac’s `/bin/bash` 3.2.57; the substring expansions and `[[ … =~ … ]]` used here are supported.
- The full-SHA check, commit peeling, fetch-before-ancestor test, and `merge-base --is-ancestor` logic are correct for the selected repository.
- Quoting around the worktree, lock, node_modules link, target, and rule-file paths is generally correct; the fixed tag names cannot contain shell whitespace, so the reconciliation loop’s word splitting is not currently exploitable.
- A worktree checkout transformed by `.gitattributes`, CRLF conversion, or a clean/smudge filter would be rejected by the raw-blob `git show | cmp`; it does not silently bypass the byte check.
- The `git show | cmp` pipeline behaves correctly under `pipefail`.
- `--only firestore:rules` and `--only firestore:indexes` both reduce to Firebase’s top-level `firestore` target. Firebase-tools runs the target predeploy before prepare/deploy, from the config project directory.
- The timestamp format sorts lexicographically in chronological order for well-formed receipt names. The `ls-remote` peeling cleanup correctly normalizes ordinary annotated-tag names, though it loses the object-ID integrity needed in finding 4.
- The EXIT cleanup is quoted and covers ordinary success/failure and normal SIGINT-driven shell exit after the trap is installed. SIGKILL and the very small interval between lock creation and trap installation cannot be covered.
- The current real repository has the seeded annotated receipt, normal Git identity, a real `node_modules` directory, no relevant `.gitattributes`, and no `tagOpt=no-tags`.

I did not run the 71-test harness because this review environment is filesystem read-only and the harness necessarily creates a temporary origin and clone. I did run Bash syntax checks and read-only Git/Firebase CLI inspections; no files or deployment state were changed.
