You are an independent implementation reviewer. READ-ONLY: do not edit, commit, or run any deploy command. Do not read ~/.config/configstore/firebase-tools.json.

Repo: /Users/christiehubley/Documents/New project (Training Hub; Vite + React 19 + TS; Firebase compat SDK on window.firebase).
Review the diff: `git -C "/Users/christiehubley/Documents/New project" diff 7de92fe..claude/step4-data-loss-panel`
Plan it implements: /Users/christiehubley/tinker-ai-configs/thoughts/plans/training-hub-data-loss-check-panel.html
Rules (production source of truth): `git -C /Users/christiehubley/studio-hub show origin/main:firestore.rules`

Goal: wire a data-loss tripwire into a manager-only Dashboard card. Reads only, baseline in localStorage, runs once automatically per sign-in when a baseline exists, Check now / Record baseline buttons.

Hunt for real bugs:
- Does the real compat SDK accept collection(...).get({ source: 'server' }) and surface offline as an error with code 'unavailable'? Is error.code preserved?
- Hook correctness (src/hooks/useDataLossCheck.ts): StrictMode double effects, the run-once guard, stale closures, busy guard, results after unmount/sign-out, and whether `enabled` can flip true before the viewer is really a manager (App.tsx dataSafetyEnabled). Hook order/early returns in TrainingApp.
- Engine (src/lib/dataLossIncidentCheck.ts): ratchet semantics, replace semantics, baselineFromCheck, legacy baseline loading, zero baselines.
- Could a non-manager or demo mode ever trigger the reads or see the card?
- Could Record baseline ever bless a loss without a confirm (e.g. ratchet runs inside runCheck before the confirm; a collection with no prior baseline)?
- UI copy that's misleading; anything that writes to Firestore (must be none).
- Tests: do they actually test the behavior they claim?

Run `npx tsc -b` and `npx vitest run` in that repo if useful (both should pass).
Report findings ranked HIGH/MEDIUM/LOW with file:line and a concrete fix, under 600 words. End with a verdict: SAFE TO SHIP / SHIP AFTER FIXES / DO NOT SHIP.
