# Implementation review ROUND 2 (confirmation) — Classbook SDOC Phase 2C
Repo /Users/christiehubley/tinker-spring-curriculum, branch sdoc-2c-project-details: committed 2C + uncommitted fixes,
together = `git diff 44a5159` (saved at ~/tinker-ai-configs/thoughts/reviews/2026-09-28-impl-review-sdoc-2c-r2.diff).
Read-only. Round 1: ~/tinker-ai-configs/thoughts/reviews/2026-09-28-impl-review-sdoc-2c-codex.md and ...-claude.md.
Fixes: Array.isArray/typeof guards in the teacher About block and the materials button marker; dayOffPlanHasUserData
counts present malformed values; the details writer refuses when stored fields are malformed; Done blocked while a
details save is in flight; savedSince wording; long-link message names it; dead params removed; SDOC_BLOCKS comment;
details error box has its own class (was colliding with the materials .sdoc-errors); tests D8 (projectLinks
allow-list), D10 (n/a → real title), D11 (malformed shapes), T22 (ordinary teacher save keeps details; malformed links
don't crash the editor), T23 (Teacher View unused blocks). Data note: the live "n/a" record's items were copied by
Christie onto part 1/part 2; the n/a record remains and will surface as a leftover list she can discard.
Confirm each round-1 finding; only NEW HIGH/MEDIUM block. Verdict READY / CHANGES NEEDED; ≤500 words.
