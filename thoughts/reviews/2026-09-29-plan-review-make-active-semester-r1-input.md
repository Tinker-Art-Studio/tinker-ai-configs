## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html — read it in full. Repo (read-only; main at 2ef2e62, line numbers in the plan are at that commit): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .

## What I want reviewed (adversarial; verify every "what exists today" claim against the code, cite lines)
- Is the approach safe given the Firebase safety invariants (updateDoc/update only named paths, awaited, exact restore on failure, no new collection so no rules change — confirm)?
- Are there consumers of activeSemester / globalSemesterKey the plan missed (all js files index.html loads; other Tinker apps under /Users/christiehubley reading curriculum/appData)? Anything that breaks when the active semester changes (week numbers, prep dashboard, Curriculum Admin, delete guards, summer/SDOC special cases, loadConfig defaults)?
- Phase 2's once-per-browser switch: correctness with multiple tabs, shared devices, users who can't see the semester, first load after deploy, clock skew, the ordering relative to the existing pick at app.js:65-70 and any code that reads globalSemesterKey earlier (app.js:13).
- Are the BDD scenarios sufficient to catch a partial implementation? Is the e2e plan (adding and removing a test semester in appData, restoring activeSemester) safe for the other specs, and does anything else in appData need restoring?
- What did I miss? Say plainly if nothing real.
Do not edit files.
