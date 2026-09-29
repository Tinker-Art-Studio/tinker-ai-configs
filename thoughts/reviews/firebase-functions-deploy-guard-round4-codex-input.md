You are an independent ROUND-4 (confirming, Codex) reviewer of a PLAN (no code exists yet). Round 1 found blocking issues; the plan was rewritten and its Reviews section maps each round-1 finding to a disposition. Earlier rounds: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/firebase-functions-deploy-guard-round1-codex.md and ...-round1-claude.md, ...-round2-codex.md, ...-round2-claude.md. Christie scoped D2 to HTTP functions only and required Node 22 after round 2; round 3 (...-round3-codex.md, ...-round3-claude.md) and a Claude round 4 (...-round4-claude.md) were applied; Christie approved amendments M1-M6 (M7 pending her OK). This is a CONFIRMING round: focus on whether each round-3 finding is truly resolved and whether the round-3 edits introduced anything new. Do not re-litigate settled owner decisions (no gcloud, HTTP only, Node 22, M1-M6). Check (a) each round-1 finding is really resolved, not just claimed, (b) the rewrite introduced no new problem, then everything below. Read-only: do NOT edit files, commit, or run any firebase/gcloud command against a real project, and do not install anything. You MAY read local files, including the firebase-tools 15.22.3 source under /Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib (the version this plan targets) to verify claims.

## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html — My Clay Hub Phase D2: a guarded deploy path for 2nd-gen Cloud Functions to Firebase project `my-clay-hub`.

Context files:
- Existing rules guard it extends: /Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh, scripts/predeploy-check.sh, scripts/deploy-rules.test.sh, firebase.json, package.json
- Parent plan (Phase D2 requirements, IAM inventory D23/D11): /Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html
- Phase D plan (C3/C5, D-4 vault export requirements): /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html
- Global hook: /Users/christiehubley/tinker-ai-configs/scripts/firebase-deploy-hook.sh
- Global rules for all sessions: /Users/christiehubley/.claude/CLAUDE.md (FIREBASE RULES)

Constraints fixed by the owner (Christie): no gcloud on the laptop (read-back of "not public" is an anonymous HTTP probe); my-clay-hub only now, the tinker-hq-apps copy comes later; deploy approval phrase is sha-specific; never read ~/.config/configstore/firebase-tools.json.

## What I want reviewed
1. Are the facts K1–K14 correct for firebase-tools 15.22.3? Spot-check the most load-bearing ones against the source (K1 packaging/ignore, K4 skip-unchanged, K5 selector parsing, K6 deletion timing, K8 cleanup-policy exit, K11 invoker, K12 build SA).
2. Security: can anything in D2 make a function public, give it broad permissions, let unapproved bytes ship, or change production without a receipt? Is the F7 build-identity plan sound (order of Compute API enable → strip Editor → narrow roles), and are the roles sufficient and minimal? Is the anonymous probe a valid proof of "not public", and what does it miss (e.g. allAuthenticatedUsers)?
3. Gaps: requirements from the foundation plan's Phase D2 list that this plan doesn't meet; failure paths without a BDD scenario; places where a partial implementation would still pass the acceptance criteria.
4. Is the receipt design (outcome=complete|partial|unsafe; --status uses newest complete) coherent with the rules guard's receipt ordering logic it copies?
5. Anything that will simply not work as described (e.g. discovery preview, predeploy env vars, running the real CLI in tests without network, npm ci in the worktree, the hook regex extension).

Report numbered findings, each with severity (blocking / should-fix / nit), the plan section (e.g. F8, D2-3 step 4), evidence (file path / doc URL), and a concrete fix. End with ONE verdict line: "ready", "ready after fixes", or "not ready".
