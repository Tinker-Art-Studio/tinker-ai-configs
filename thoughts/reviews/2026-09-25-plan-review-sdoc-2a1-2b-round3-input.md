# Plan review ROUND 3 (final confirmation) — Classbook SDOC Phase 2A.1 + Phase 2B, revision 3

Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html — sections id="phase-2a1" and
id="phase-2b", and the top three Decisions Log entries (Sep 25). Code (read-only, do NOT edit anything):
/Users/christiehubley/tinker-spring-curriculum @ 2894adf; rules /Users/christiehubley/studio-hub/firestore.rules, storage.rules.

Round 1 findings (Codex: ~/tinker-ai-configs/thoughts/reviews/2026-09-25-plan-review-sdoc-2a1-2b-codex.md;
Claude: .../2026-09-25-plan-review-sdoc-2a1-2b-claude-full.md) were folded in — the top Decisions Log entry lists how.
Also changed since round 1 by Christie's decision: Kathy/Allie (prep with classbook) CAN edit SDOC plans
(canEditDayOffPlan = canTickDayOffMaterials() or the camp's teachers include my name).

Please:
1. Confirm each round-1 finding is correctly fixed in the plan text (check against the code). Say which are not.
2. Look for NEW problems introduced by the fixes — especially: saveDayOffPlan routed before lessonStoreFor();
   the separate SDOC name resolver; the in-transaction authorization re-check (how it gets the canonical name
   and whether it works for planners/prep); verifyDayOffPlanWrite + the rename-before-read-back "benign" case;
   the clear allow-list vs the summer editor's photo-removal/clear behaviour; Kathy/Allie edit rights.
3. Anything still missing that would let an implementation pass the BDD but lose or corrupt data.

Output: verdict per section (READY / CHANGES NEEDED), then numbered findings with severity, plan text,
code evidence (file:line), fix. Under ~1000 words. Only HIGH/MEDIUM should block READY.

ROUND 3 NOTE: round 2 findings are in .../2026-09-25-plan-review-sdoc-2a1-2b-round2-{codex,claude}.md and the top
Decisions Log entry lists how each was folded in. Confirm them; look only for NEW HIGH/MEDIUM problems the round-2
fixes introduced (the opts.dayOffAuth parameter, the lastEditedAt-tolerant read-back, photo-pair translation,
dayOffInstallPlan {reload:false}, unique-first-name resolver, 2A.1 sign-off refresh). Say READY if none.
