## Independent review — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 3, marked execution-ready after three Claude review rounds; those reviews are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md — read them so you don't repeat settled points, but do not trust them).
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Firestore rules: /Users/christiehubley/studio-hub/firestore.rules .

You are the independent second model. Be adversarial and verify against the code, citing file:line and concrete failing inputs:
1. Anything in Phase 1 or Phase 2 that is unsafe for production data (curriculum/appData, curriculum/lessonData) or would lose/hide data?
2. Anything the three Claude rounds missed: other readers of activeSemester / globalSemesterKey / localStorage keys; interactions with the Summer camp season as active; the "switch everyone" once-per-browser logic; the weekly-delete modal; the Settings access gating.
3. Is the e2e plan workable with the harness in e2e/ and safe for the other specs (shared emulator state, restore)?
4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
Do not edit files. Do not run tests.
