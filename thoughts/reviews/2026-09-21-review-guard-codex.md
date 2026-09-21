1. **Blocker — Design / guard preflight:** The original incident still fits through a test-time race. Session A validates clean HEAD `X` and starts `npm test`; session B edits `firestore.rules` while tests run; A then deploys B’s uncommitted file from the shared directory. A second cleanliness check only narrows the window. **Exact change:** deploy and test from an immutable temporary checkout/archive of the full approved commit, including `firebase.json`, `.firebaserc`, target file, tests, and package metadata. Never run Firebase against the shared working tree. Add a test that mutates the original checkout after preflight and proves the fake Firebase receives the approved snapshot.

2. **Blocker — Phase 2 / fail-closed claim:** The claim is false for current Claude Code. A missing/non-executable hook exits around 127, an ordinary crash exits 1, and a timeout produces no decision; all are non-blocking for `PreToolUse`. Only exit 2 or valid deny JSON blocks. Anthropic explicitly warns that a mistyped hook path leaves the gate disabled and that timed-out command hooks allow the tool call. [Claude Code hooks reference](https://code.claude.com/docs/en/hooks#exit-code-output) **Exact change:** remove every unconditional “fails closed” statement. Have the hook explicitly `exit 2` on parse/internal errors, and invoke it through a small stable launcher that converts missing-script/non-2 exits to 2. Keep the Phase 2 missing/crash/timeout experiments, but document that timeout remains fail-open; a Bash hook cannot provide absolute fail-closed enforcement.

3. **Blocker — Hook design:** The proposed allow rule creates a direct bypass:

   ```bash
   scripts/deploy-rules.sh --status; firebase deploy --only firestore:rules
   ```

   The command both matches `firebase deploy` and “invokes” the guard, so the whole Bash call is allowed. **Exact change:** delete the guard exception entirely. A normal guard invocation contains no literal `firebase deploy`, because its subprocess is invisible to the hook, so it already passes.

4. **Blocker — Hook coverage:** No regex over the Bash tool’s command string can enforce “only the guard may deploy.” The current expression catches `firebase  deploy`, literal `$(firebase deploy)`, literal heredocs, `bash -c 'firebase deploy'`, and literal `eval 'firebase deploy'`. It misses:

   - `npx firebase-tools deploy`
   - `/path/to/firebase deploy`
   - `node_modules/.bin/firebase deploy`
   - aliases or variable-built commands
   - `sh scripts/deploy-directly.sh`
   - a script written using Write/Edit and later executed

   **Exact change:** describe the hook as an accidental-direct-invocation guard, not a security boundary. The smallest useful detector is basename-aware matching for `*/firebase … deploy` plus an explicit `npx (firebase|firebase-tools) … deploy` case, with tests for tabs/multiple spaces, absolute paths, `.bin/firebase`, substitutions, heredocs, and compound commands. If mechanical non-bypassability is truly required, move deployment behind a credential/CI boundary where Claude sessions cannot invoke the authenticated Firebase CLI directly. A more elaborate regex will never cover arbitrary wrapper scripts.

5. **Should-fix — Guard condition 3:** “HEAD is on origin” is too weak and can be stale. A session can push an unreviewed commit to `origin/feature-x`; `git branch -r --contains HEAD` passes. It can also pass from stale remote-tracking refs without contacting the remote. **Exact change:** fetch the production ref, then require exact equality with `origin/main`:

   ```bash
   git fetch origin main
   test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)"
   ```

   For this one-person production flow, hotfixes should land on `main` first. If direct hotfix-branch deployment is genuinely needed, make it an explicit break-glass mode with a different approval phrase—not “any origin branch.”

6. **Should-fix — Guard concurrency:** Two guards can deploy concurrently. With separate worktrees or `--dir` values, A can deploy `X`, B deploy `Y`, then tag publication can occur in the opposite order and record `X` as live even though `Y` is live. Same-minute immutable tag names can also collide after a successful deploy. **Exact change:** take one interprocess lock per Firebase project and target before validation and hold it through testing, deploy, and receipt publication. Use seconds plus SHA in receipt names. The immutable snapshot from finding 1 is still required because the lock does not prevent ordinary editors from changing the shared checkout.

7. **Should-fix — Tags / post-deploy truth:** Firebase deployment and Git tag publication cannot be atomic. If deployment succeeds and tag push fails, production changed while `rules-live` remains old; `--status` lies. A manual terminal deploy does the same. Therefore the goal’s “what is live is answered by git, never the console” is not supportable. **Exact change:** call tags “guarded-deployment receipts,” not proof of current production. On post-deploy publication failure, print a distinct high-severity result: “DEPLOY SUCCEEDED; RECEIPT NOT PUBLISHED,” preserve enough local state to retry recording, and prevent another guarded deploy until reconciled.

8. **Should-fix — Tag push mechanics:** `git push origin --tags` pushes every local tag, not only the two created by the guard. `--force-with-lease` can target a tag ref, but the safe form supplies the exact expected remote object; implicit lease forms rely on tracking information and are explicitly cautioned against. [Git push documentation](https://git-scm.com/docs/git-push#Documentation/git-push.txt---force-with-leaseltrefnamegtltexpectgt) **Exact change:** either:

   - Prefer the simpler design: only immutable annotated receipt tags such as `deployed/tinker-hq-apps/firestore-rules/20260921T220501Z-1da12e3`, push that one explicit ref, and derive latest from the receipt list; or
   - If retaining `live/*`, push only the two explicit fully qualified refspecs with `--atomic`, and protect the moving tag with `--force-with-lease=refs/tags/live/...:<previous-remote-oid>`.

   Annotated receipts can record project, target, full commit SHA, target blob SHA, and deployment timestamp. Avoid `--tags`.

9. **Should-fix — Approval identity and combined commits:** Accepting seven-character prefixes is unnecessary ambiguity and permits deliberate prefix-collision construction. Also, cleanliness does not establish authorship: A can leave unreviewed edits, B can commit them together with B’s work, and the guard sees a clean approved commit. **Exact change:** require the full canonical object ID printed by `git rev-parse HEAD`; resolve it as a commit and compare exact IDs. Make the approval workflow explicitly: show the complete `live-receipt..SHA` target-file diff, then Christie names that full SHA. The guard cannot distinguish “someone else’s edit” once it is committed; review of the full content is the control.

10. **Should-fix — Phase 3 / rollback runbook:** Deployment receipts do make rollback safer than `git log -- firestore.rules`, because Git history includes rules commits that may never have been deployed. But they are only strictly safer when receipt publication succeeded and no out-of-band deployment occurred. **Exact change:** the runbook should:

    1. Confirm the latest successfully published deployment receipt.
    2. Select and inspect the previous receipt.
    3. Restore only `firestore.rules` from it.
    4. Commit that restoration to `main`, push it, obtain approval for the new full SHA, then run the guard.

    Avoid a vague `git revert`, which can revert unrelated files from a mixed commit. State how to recover when deployment succeeded but receipt publication failed.

11. **Should-fix — Phase 3 / documentation completeness:** The plan updates global [CLAUDE.md](/Users/christiehubley/.claude/CLAUDE.md) and [RULES-ROLLBACK.md](/Users/christiehubley/studio-hub/RULES-ROLLBACK.md), but leaves direct-deploy instructions in [repo CLAUDE.md](/Users/christiehubley/studio-hub/CLAUDE.md), [AGENTS.md](/Users/christiehubley/studio-hub/AGENTS.md), and [DEPLOY-SAFETY-CHECKLIST.md](/Users/christiehubley/studio-hub/DEPLOY-SAFETY-CHECKLIST.md). Sessions will keep attempting the forbidden command. The plan also hardcodes “199 tests,” contradicting AGENTS.md’s instruction not to hardcode a drifting count; the current files themselves disagree about counts. **Exact change:** add all three repo documents to Phase 3 and remove the numeric test count from the plan.

12. **Nit — Scope / `--dir` and Netlify:** Generic `--dir` and automatic arbitrary-project discovery expand v1 beyond the stated Tinker incident and make wrong-project deployment easier. Netlify has a different risk—cost approval rather than a shared rules-file race. **Exact change:** v1 should allowlist the real Studio Hub path, `tinker-hq-apps`, and the three known target-to-file mappings. Add Hubley Hub only as an explicit allowlisted configuration when needed. Leave Netlify as a separate follow-up.

What checked and found sound:

- I read the entire [plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-deploy-guard.html).
- [firebase.json](/Users/christiehubley/studio-hub/firebase.json) maps the three stated targets to `firestore.rules`, `firestore.indexes.json`, and `storage.rules`.
- [.firebaserc](/Users/christiehubley/studio-hub/.firebaserc) names `tinker-hq-apps`.
- [package.json](/Users/christiehubley/studio-hub/package.json) runs the Firestore emulator suite and does not currently contain guard scripts.
- `~/.claude/settings.json` currently has no hooks or permission rules, matching the plan.
- The working tree is clean; `HEAD`, local `main`, and `origin/main` currently equal full SHA `1da12e3dbb3c4aeeb85e3f9f7d9f51e31604b0b6`.
- The only current tag is `rules-2026-08-12`, matching the plan.
- Approved exact commit + clean source + tests + target-scoped Firebase command is the right core model. The missing pieces are immutable deployment input, serialization, production-ref enforcement, honest receipt semantics, and acknowledging that the Claude hook is best-effort rather than an unbypassable gate.
