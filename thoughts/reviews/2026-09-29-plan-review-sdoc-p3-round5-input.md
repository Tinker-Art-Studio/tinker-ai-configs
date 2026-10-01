# Plan review ROUND 5 (short, targeted confirmation) — Classbook SDOC Phase 3, revision 5
Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3". Re-read ONLY:
the "Redraw on every install — one shared listener callback" paragraph, the last two sentences of the "Failure"
paragraph, the last three BDDs of the Phase 3 BDD block, and the top Decisions Log entry.

Code is READ-ONLY and pinned to 2ef2e62: `git -C /Users/christiehubley/tinker-spring-curriculum show 2ef2e62:js/app.js`
(and `:js/firebase-data.js`). Do NOT edit anything anywhere.

Round 4: ~/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-sdoc-p3-round4-{codex-full,claude}.md — both found
the startup race (Curriculum Admin can register the single listener last, after Teacher View built), so revision 4's
"reverse redraw not needed" claim was wrong. Revision 5: both inits register ONE shared onLessonDataReload() that runs
each INITIALISED view's existing per-tick redraw (Teacher View's body moved into teacherViewOnReload(); Curriculum
Admin's renderAdminGrid()+renderHelpQueue()), then renderTeacherMappingTable() once. Also dayOffRefreshFailed is now
set inside the gated reload's failure path behind isCurrent().

Check: (a) round-4 findings fixed; (b) running each initialised view's redraw regardless of which tab is showing is
truly behaviour each view's own callback already has today (no new behaviour), and nothing in Teacher View's body
misbehaves when Curriculum Admin is the visible tab or vice versa; (c) the gating on tvInitialized / caInitialized is
right given caInitialized is set BEFORE its awaits (app.js:5016-5017) and tvInitialized can be reset (668-672).
Only NEW HIGH/MEDIUM block. Verdict READY / CHANGES NEEDED; ≤300 words.
