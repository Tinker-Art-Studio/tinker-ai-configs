## Implementation review — My Clay Hub functions guard: install every codebase for the tests (D-4, V-4 fix)

Repo /Users/christiehubley/my-clay-hub, branch `d4-guard-install-all`, one commit on top of main (af5a87d):
`git -C /Users/christiehubley/my-clay-hub show c3380be` (or `git diff main...d4-guard-install-all`).

Why: vault's first guarded deploy (`scripts/deploy-functions.sh --approved af5a87d… --codebase vault`) refused at the
npm test step, nothing deployed: the guard installed only the codebase being deployed in its private worktree, but
`npm test` runs every codebase's functions suites with TINKER_FUNCTIONS_TESTS=required (scripts/functions-emulator.mjs),
so it SKIPPED-and-failed on functions/core. The fix adds `install_other_codebases` (scripts/deploy-functions.sh), called
just before npm test in --approved, which npm-ci's every other codebase from the commit's firebase.json in the worktree.

Context: the guard's design and safety properties are in the file's header and in
~/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html (F1–F14, D2-3) and
~/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html (V-2, V-4). Runbook: FUNCTIONS-ROLLBACK.md.

Please check (cite file:line):
1. Can installing the OTHER codebases' node_modules in the worktree change what is checked, sealed or uploaded for the
   codebase being deployed (F3 folder proof, the seal/manifest, the source hash, the CLI's packaging and predeploy hook)?
   Note the predeploy hook runs `--only functions:<cb>`. Could another codebase's install scripts (npm lifecycle scripts)
   do anything harmful in the worktree or outside it (the root node_modules is a symlink to the repo's)?
2. Is the placement right (after build_expected's two folder checks, before npm test), and is it fail-closed (bad source,
   missing folder, npm ci failure → refuse, nothing deployed)? Any input from firebase.json that could make the path
   escape the worktree?
3. Are --reconcile / --reverify / --clear-inflight / --attest affected (they don't run npm test)?
4. Are the new and changed tests in scripts/deploy-functions.test.sh meaningful, and is the one changed older scenario
   (the `other` codebase now gets a folder) still testing what it tested?
5. Anything else this misses.

Classify findings blocking / should-fix / nit. End with one verdict line: "safe to merge" / "merge after fixes" /
"not ready". Do not modify files, deploy, or call Google.
