# Plan review ROUND 4 (short, targeted confirmation) — Classbook SDOC Phase 3, revision 4
Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3". Re-read ONLY:
the "Build sequencing" paragraph, the last two sentences of the "Failure" paragraph, the new
"Redraw on every install" paragraph, the last two BDDs in the Phase 3 BDD block, and the top Decisions Log entry.

Code is READ-ONLY and pinned to commit 2ef2e62 (the plan's line numbers). The checkout at
/Users/christiehubley/tinker-spring-curriculum has moved on; read the pinned code with
`git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/app.js` and `...:js/firebase-data.js`.
Do NOT edit anything anywhere.

Round 3 (both reviewers, one MEDIUM): ~/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round3-{codex,claude}.md
— after a Teacher View visit the single listener's callback is Teacher View's, so the failed reload's automatic
retries (firebase-data.js:1151-1157) and snapshot-triggered reloads (1190-1194) did not redraw Curriculum Admin.

Revision 4 changes to check:
1. Teacher View's callback (app.js:676) also calls renderAdminGrid(); renderHelpQueue(); when the active tab is
   curriculum-admin, before its SDOC early return (682-686).
2. The round-3 "vice versa" was DROPPED with a claim: Curriculum Admin's callback can own the listener only while
   Teacher View has never finished initialising, because initTeacherView's only early exit before registering
   (668-672) resets tvInitialized = false. VERIFY this claim against the code (including initTeacherView's
   await loadLessonData() before registration, and any other path that calls setupLessonDataListener).
3. The "Couldn't refresh" message is derived at render time: dayOffRefreshFailed[yearKey] set on a 'failed' refresh,
   cleared wherever the stamp is set.
4. BDD +2; build deferred until the per-semester lesson storage migration lands.

Confirm the round-3 MEDIUM is fixed; only NEW HIGH/MEDIUM block. Verdict READY / CHANGES NEEDED; ≤300 words.
