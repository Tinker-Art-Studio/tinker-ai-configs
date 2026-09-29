## Plan under review (round 1)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html — read it in full. Context: production curriculum/lessonData is at 95% of Firestore's 1 MiB cap; this plan moves each class semester into its own document.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules (+ its rules tests under /Users/christiehubley/studio-hub). Other readers: /Users/christiehubley/studio-hub/js/alerts.js, backups under /Users/christiehubley/summer-camp-app/scripts and /Users/christiehubley/tinker-backups.
Be adversarial; verify every "what exists today" claim, cite file:line, give concrete failing inputs:
1. Data safety of Phases 3–4 (the move transaction, verification, the removal). Any way a lesson edit is lost, duplicated, or silently goes to the wrong document — including tabs loaded before Phase 1's deploy (old code), tabs loaded before the move, and saves in flight.
2. Is the list of lessonData readers/writers complete (all loaded scripts; refs held in variables; transactions/batches; other apps; prep dashboard, diagnostics, material forecasts, change history, copy-from, createNewSemester, lessonData_backup)?
3. Phase 2 rules design: feasibility and risk (affectedKeys on a ~1 MB doc, get() on appData in rules, narrowing the manager catch-all without breaking any other app or the Classbook's own flows; rules test coverage in studio-hub).
4. Loading/listeners: correctness and cost of per-semester listeners alongside the legacy one; the existing listener generation / summer reload logic.
5. Anything missing, and is the ordering right given ~52 KB of headroom? Is there a faster safe path to relief?
Verdict: EXECUTION-READY or NOT (minimum list). Do not edit files or run tests.
