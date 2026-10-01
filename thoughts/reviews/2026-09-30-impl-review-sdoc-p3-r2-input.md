# Implementation review ROUND 2 (short) — Classbook SDOC Phase 3, fixes commit 6d9392c on top of c7400df
Repo READ-ONLY: /Users/christiehubley/tinker-spring-curriculum (branch claude/sdoc-phase3-overview). Do NOT edit/write/deploy.
Fix diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-r2.diff (`git -C <repo> diff c7400df HEAD`). Round 1: ~/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3-{claude,codex-full}.md
Decisions on round 1: FIXED — hung refresh deadline (30 s gate release); startup failure sets dayOffRefreshFailed; stamp only
after the whole reload installs; single redraw via the shared callback; weekday in an old stamp. NOT FIXED, with reasons in
the commit message — (a) 'no-listener' during startup: the listener's first server snapshot always runs a full reload and
redraws, so it self-resolves; (b) multi-year partial side-map install: pre-existing 2B loader behaviour, fixing it touches
verified-save ordering, deferred to its own design; (c) offline read-only editor: the old get({source:'server'}) failed offline
the same way. Confirm the fixes are correct (esp. the deadline: can the released gate let two reloads overlap in a harmful
way? does the hung promise ever release a NEWER run's gate?), whether each "not fixed" reason holds, and whether P17–P19 pin
the fixes. Only NEW HIGH/MEDIUM block. End with: ready to merge — yes/no. ≤300 words.
