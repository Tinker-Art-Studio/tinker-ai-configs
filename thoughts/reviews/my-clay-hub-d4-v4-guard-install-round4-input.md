## Confirming review — functions guard: install every codebase for the tests (round 4)

Repo /Users/christiehubley/my-clay-hub, branch `d4-guard-install-all`. Round 3 reviewed cb8dd22; this round's fixes are
the newest commit: `git -C /Users/christiehubley/my-clay-hub show HEAD` (whole change: `git diff main...d4-guard-install-all`).
Round-3 reviews: ~/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-v4-guard-install-round3-codex.md and …-claude.md.

Check (cite file:line): (1) each round-3 finding is resolved — the test harnesses' mktemp/rm -rf hazard (both
scripts/deploy-functions.test.sh and scripts/deploy-rules.test.sh), shared/ pinned and shown, the stale order comments,
the two weak assertions; (2) can the new harness guard or trap pattern itself misfire (refuse a valid scratch folder,
or remove something it shouldn't)? (3) does adding `shared` to CONTROL_FILES break anything (e.g. --reverify of the
existing core attempt, or a guard-suite fixture with no shared/)? (4) anything else this whole branch still misses.
Do NOT run the guard test scripts if your sandbox can't create a temp folder. Classify blocking / should-fix / nit; end
with "safe to merge" / "merge after fixes" / "not ready". Do not modify files, deploy, or call Google.
