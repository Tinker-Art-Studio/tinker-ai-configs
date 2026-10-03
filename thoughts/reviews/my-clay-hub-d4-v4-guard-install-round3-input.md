## Confirming review — functions guard: install every codebase for the tests (round 3)

Repo /Users/christiehubley/my-clay-hub, branch `d4-guard-install-all`. Round 2 reviewed 9d3874d; this round's fixes are
the newest commit: `git -C /Users/christiehubley/my-clay-hub show HEAD` (whole change: `git diff main...d4-guard-install-all`).
Round-2 reviews: ~/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-v4-guard-install-round2-codex.md and …-claude.md.

Check (cite file:line): (1) each round-2 finding is resolved — package files escaping via symlinks or local
(file:/link:/git) dependencies; the deployed codebase's npm ci running before its folder was proven; npm test loading
the other codebase's unpinned, unshown source; the vacuous assertion. (2) Can the new pre-install folder proof or the
lockfile rule wrongly refuse the real core and vault (read functions/*/package-lock.json), or break --reconcile /
--reverify (they call build_expected too)? (3) Anything still executing or installing content Christie didn't approve.
(4) Are the new tests meaningful? Classify blocking / should-fix / nit; end with "safe to merge" / "merge after fixes" /
"not ready". Do not modify files, deploy, or call Google.
