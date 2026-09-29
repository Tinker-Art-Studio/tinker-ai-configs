## Round 2 — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 2). Read it in full, including the Decisions Log entry "revision 2, after round-1 review", and the round-1 review at /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md.
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .

Note: since round 1, production activeSemester was switched to fall-2026 by console, and Christie chose to allow Summer camp seasons (not SDOC years) to be made active.

## What I want reviewed (adversarial; cite lines)
1. Did revision 2 actually resolve each round-1 finding, or introduce new problems? Especially: fixing the Settings dropdown via setGlobalSemester (side effects on Settings form state, unsaved edits, tab switching); the weekly-delete typed-name guard (lesson count source when lessons aren't loaded; prompt() in the app); Phase 2's {to, at} logic and "not marked seen when invisible".
2. Making a camp season active: anything in the code that reads activeSemester / getActiveSemesterKey() / getActiveSemester() and assumes a weekly semester (week numbers, prep dashboard, cut bank, change history, Today View placeholders at app.js ~5069-5072, CA reset at ~4590)?
3. Is the e2e plan (stub-and-payload, one manager round-trip with restore, staff refusal, fresh teacher sign-in) workable with the harness in e2e/ ? Anything that will leak into other specs?
4. Is anything still unsafe or missing before this can be marked execution-ready? Say plainly if nothing real.
Do not edit files.
