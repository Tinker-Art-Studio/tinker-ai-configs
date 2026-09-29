## Codex confirmation round — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 4). Your previous review: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md. Read the Decisions Log entry "revision 4".
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .

For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
- activateSemesterTx / deleteWeeklySemesterTx: transaction reads/writes across curriculum/appData and curriculum/lessonData — do the rules allow a manager to do both in one transaction? Does anything else write these docs concurrently in a way the transaction mishandles (lesson saves to lessonData are frequent — contention/retries on a large doc)? Do they correctly preserve updateAppData's guards?
- The JSON snapshot download: are cutProjects and changeLog actually keyed by semester in curriculum/cutProjects and curriculum/changeLog? Anything else keyed by the semester that becomes unreachable (prepData? backup)?
- Per-uid seen marker: is getAuthUser().uid available at that point in DOMContentLoaded?
Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
