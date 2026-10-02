## Confirming review — My Clay Hub D-4 phase V-2 (scheduled functions in the functions deploy guard), round 2

Repo: /Users/christiehubley/my-clay-hub, branch `d4-guard-schedules` (PR Tinker-Art-Studio/my-clay-hub#9). Commits: `c8141f8` is the change; `d63df9c` applies round 1's fixes. Diff: `git diff origin/main...d4-guard-schedules`, and `git show d63df9c` for the fixes.
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html (V2, V3, phase V-2).

Round 1 reviews, both "merge after fixes" (read them):
- /Users/christiehubley/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-v2-impl-round1-codex.md
- /Users/christiehubley/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-v2-impl-round1-claude.md

### What to do
1. Confirm each round-1 finding is actually fixed in d63df9c, and say how. Name any that are not, or only partly.
2. Look for NEW problems the fixes introduced. In particular:
   - the deployed-job-list construction (each other codebase's newest attempt);
   - the per-key verify/attempt fallback;
   - attest format 2 and the legacy declaration normalisation, in both the guard and the backstop;
   - the headers rule.
3. Say whether anything is still blocking a merge. Christie's decisions O5/O6 are not to be reopened.

The test suites are offline, and you may run them:
- `bash scripts/deploy-functions.test.sh` (~5 min)
- `node --test tests/unit/*.test.js`

The reported results are unit 227, functions guard 863, rules guard 196, functions emulator 15, and rules 194, all passing.

### Constraints
This is a read-only review. Run no deploy, nothing that changes cloud state, and no git writes. Never read ~/.config/configstore/firebase-tools.json.

### Output
Give a verdict ("safe to merge", "merge after fixes", "not ready"). Then list findings as blocking / should-fix / nits, with file:line. Be concise.
