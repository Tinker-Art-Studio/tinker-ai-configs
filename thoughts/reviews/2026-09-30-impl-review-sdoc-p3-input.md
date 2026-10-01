# Implementation review — Classbook SDOC Phase 3 (commit c7400df on branch claude/sdoc-phase3-overview, base 132fef2)
Repo READ-ONLY: /Users/christiehubley/tinker-spring-curriculum. Do NOT edit, run tests that write, or deploy.
Diff: ~/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-sdoc-p3.diff (or `git -C <repo> diff 132fef2 c7400df`).
Design: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3" (revision 5 + the
"Re-verification against 132fef2" paragraph). The design was reviewed over 6 rounds; review the CODE against it.

What changed:
- js/app.js: onLessonDataReload() + teacherViewOnReload() (both views register the one callback);
  refreshDayOffYear() (shared in-flight promise → reloadSummerForModeChange(); redraw on non-stale outcome);
  header refresh controls, Plans column, roll-up, openDayOffPlanFromAdmin(); lifecycle calls in the tab handler and
  setGlobalSemester(); SDOC editor read-only while lessonDataLoadedSuccessfully === false.
- js/firebase-data.js: dayOffLastRefreshAt / dayOffRefreshFailed (+ markDayOffYearInstalled) set only where a full
  load installs or fails; loadDayOffCampData's three queries use {source:'server'}; readDayOffPlanForEditor() reads
  inside a read-only runTransaction.
- css, and e2e/day-off-overview.spec.js (P1–P16).

Look hard at:
1. Any behaviour change for weekly / summer semesters or Teacher View from the shared callback (it now redraws every
   INITIALISED view on every reload, incl. Spring's own-doc listener callbacks). Anything that runs while hidden and
   shouldn't, or state a hidden redraw clobbers (e.g. an open admin modal, an expanded summer camp, the grid action state)?
2. refreshDayOffYear(): the in-flight promise, its finally/done handling, 'no-listener', the second redraw, and the
   lifecycle calls (could they fire on startup, loop, or race the first init?). setGlobalSemester's previousKey.
3. The stamp/failure flags: set in every success/failure path and only there? A camp-season failure marks SDOC years
   failed — right? Startup marking when a LATER year fails?
4. The transactional open read: correct in the compat SDK, offline behaviour, any test that counted runTransaction calls.
5. Escaping/XSS in the new HTML (sdocEsc/sdocEscA), and the PR #3 onclick ratchet.
6. Do the tests pin the behaviour (would they fail on a broken version)? Missing cases?
Rank HIGH / MEDIUM / LOW with file:line. End with: ready to merge — yes/no. ≤500 words.
