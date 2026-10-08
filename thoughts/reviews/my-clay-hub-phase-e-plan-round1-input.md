## Plan review, round 1 — My Clay Hub Phase E (the live link from Membership Manager)
Read-only: read files only; do not modify anything, run deploys, or use the network.

Plan under review: /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html (draft, Oct 8 2026; open questions Q1–Q5 with recommendations, not yet answered by Christie).
Parent design (already decided, don't reopen unless it's unsafe): /Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html — Phase E section, decisions D2, D4, D4a, D11, D21, D22, D23 and the IAM inventory.
Related: /Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html (M1, F13, K10, K11, K13, round-1 retry finding); /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html (the gate; Decisions log Oct 5–8).
Repos: /Users/christiehubley/my-clay-hub (receiver: scripts/deploy-functions.sh, scripts/predeploy-check.sh, functions/, shared/derive-status.js, docs/my-clay-hub/DATA-MODEL.md, SPEC.md, DECISIONS.md, firestore.rules); /Users/christiehubley/studio-hub (sender: firestore.rules, rules.test.js, js/app.js — no functions yet); /Users/christiehubley/clay-hub-membership (Membership Manager: js/firebase-data.js, js/member-status.js, js/app.js).

Context: two Firebase projects — tinker-hq-apps (every staff app; rules affect all of them) and my-clay-hub (members app, not live; empty, deny-all; first weekly off-project vault export Sunday Oct 11). Christie is the only operator; Console/IAM changes are hers; deploys only through each project's guard after her sha-specific approval phrase. Hard invariants: one-way only (never write back to tinker-hq-apps), full phone never leaves tinker-hq-apps, no client reads members/*, every new collection gets a rule in the same commit, emulator-only tests, never read the Firebase CLI credential file.

Please review for:
1. Safety: anything that could break the staff apps in tinker-hq-apps (rules, IAM, K13's project-wide grants, API enablement, the Compute account change), leak forbidden member fields or the full phone, or let anything write to tinker-hq-apps.
2. Correctness of the link design as planned: ordering/readTime gate, tombstones, conflicts, reconcile vs triggers, the 10%/5% stops, the staff roster, the recompute schedule (Q1), deriveStatus inputs (priorTerm), the cross-project OIDC call.
3. Phase order and gates: is anything real-data before the vault gate? Can the E-6 probe be done without real data? Interrupt/rollback paths.
4. Gaps: missing phases, tests or BDD scenarios that would let a partial implementation pass; facts F1–F11 that look wrong (verify against the code).
5. Your view on Q1–Q5's recommendations.

Reply: verdict (ready / ready after fixes / not ready), then numbered findings each marked blocking / should-fix / nit, with the plan section or file:line.
