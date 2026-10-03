## Confirming review — functions guard: install every codebase for the tests (round 5)

Repo /Users/christiehubley/my-clay-hub, branch `d4-guard-install-all`. Round 4 reviewed bbfe95b; this round's fixes are
the newest commit: `git -C /Users/christiehubley/my-clay-hub show HEAD` (whole change: `git diff main...d4-guard-install-all`).
Round-4 reviews: ~/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-v4-guard-install-round4-codex.md and …-claude.md.

Check (cite file:line): (1) each round-4 should-fix is resolved — shared/ fixture coverage in the functions suite, shared/
pinned in the rules guard (scripts/deploy-rules.sh) with its fixture and test, a --codebase vault scenario with core as
the other codebase; (2) does pinning shared/ in the RULES guard change anything for a rules deploy that should keep
working (the last released rules commit and today's tip)? (3) anything blocking left anywhere in the branch.
Do NOT run the guard test scripts if your sandbox can't create a temp folder. Classify blocking / should-fix / nit; end
with "safe to merge" / "merge after fixes" / "not ready". Do not modify files, deploy, or call Google.
