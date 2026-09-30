## Implementation review round 2 — Phase B (Classbook + Studio Hub alerts)
Round 1 (Codex): /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-codex.md — five findings.
Full diffs now:
- Classbook: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff (worktree read-only: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81)
- Studio Hub: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-studiohub.diff (worktree read-only: /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc; includes the new alerts-classbook.test.js)
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase B). Phase A rules are live (studio-hub 0caf415).
1. For each round-1 finding: RESOLVED / NOT with file:line.
2. Adversarially check the fixes and the whole change again: any Spring workflow that still writes something before refusing (search every caller of saveSingleLesson / saveMultipleLessonFields / deleteLessonKey / saveLessonData / uploadLessonPhoto / saveCutProjects / updateAppData that can act on a weekly semester); anything that changes behaviour for Fall or other semesters; the token logic; the standing notice; the Studio Hub migration-once marker and error handling; test quality.
Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
