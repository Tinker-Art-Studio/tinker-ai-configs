## Confirming review — functions guard: install every codebase for the tests (round 2)

Repo /Users/christiehubley/my-clay-hub, branch `d4-guard-install-all`. Round 1 reviewed c3380be; this round's fixes
are the newest commit: `git -C /Users/christiehubley/my-clay-hub show HEAD` (whole change: `git diff main...d4-guard-install-all`).
Round-1 reviews: ~/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-v4-guard-install-round1-codex.md and …-claude.md.

Check (cite file:line): (1) each round-1 finding is resolved — path escape (names, symlinks, worktree containment),
lifecycle scripts (--ignore-scripts for test-only installs), the other codebases' package files pinned to the tip and
shown in --diff; (2) the new validation in codebase_on_tip can't wrongly refuse the real firebase.json (core + vault) or
break --status/--diff/--reconcile/--reverify/--attest/--clear-inflight (CONTROL_FILES grows by the other codebases'
package files — what does that do to verifier_fields / --acknowledge-verifier-change for existing attempts?);
(3) anything still escaping or still executing unapproved code; (4) the new tests are meaningful.
Classify blocking / should-fix / nit; end with "safe to merge" / "merge after fixes" / "not ready". Do not modify
files, deploy, or call Google.
