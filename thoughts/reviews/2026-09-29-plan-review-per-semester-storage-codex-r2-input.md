## Codex round 2 — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (revision 3; read the Decisions Log entry "revision 3"). Your round 1: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules/tests: /Users/christiehubley/studio-hub/firestore.rules, rules.test.js . Also /Users/christiehubley/studio-hub/js/alerts.js and /Users/christiehubley/tinker-backups/backup.js (read only).
1. For each of your 8 minimum items: RESOLVED / NOT, with plan-line citations.
2. Check what revision 3 introduced, against the code: the rule-enforced edit pause on lessons_spring-2026 (get() on storageMigrations; roles; create-only-if-absent; delete before/after verified); the Phase C transaction (can one transaction do tx.set on a new doc + tx.update deleting a key in a ~1 MB doc + tx.set merge, under the Phase A rules for a manager?); the reverse transaction needing a manager re-add of spring-2026 while not verified (is it in the Phase A rules?); Studio Hub alert re-keying; the headroom estimator.
3. Anything that can still lose, hide, or misroute a lesson.
Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
