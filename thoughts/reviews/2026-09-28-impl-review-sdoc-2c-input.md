# Implementation review — Classbook SDOC Phase 2C (project details + "n/a" blocks)

Repo /Users/christiehubley/tinker-spring-curriculum, branch sdoc-2c-project-details, commit HEAD (08af635-rebased)
vs 44a5159: `git diff 44a5159 HEAD` (saved at ~/tinker-ai-configs/thoughts/reviews/2026-09-28-impl-review-sdoc-2c.diff).
Read-only: do NOT edit anything.

Design: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html → id="phase-2c" (revision 6,
reviewed over 5 rounds). Files: js/firebase-data.js (isDayOffUnusedBlock, isDayOffNoPlanTitle wrapper,
dayOffPlanHasUserData, verifyDayOffPlanWrite idField, validateDayOffProjectDetails, saveDayOffProjectDetails),
js/app.js (Teacher View unused blocks, editor sdocAboutHtml, dayOffLinkHtml, popup Details section: render/clear/
dirty/save, openDayOffMaterials view token, closeDayOffMaterials, materials button marker), index.html (new
#sdoc-materials-details container), css, tests e2e/day-off-materials.spec.js D1–D10 and day-off-teacher.spec.js T22.

Check: faithful to the design (stale baseline semantics, write shape, read-back/ownership, install via
dayOffInstallVerified, container lifecycle + token incl. catch, n/a sites, summer untouched); data safety (materials,
ticks, sign-off, teacher plans, rename/removal guards); XSS (every render path of details/links, incl. hostile stored
values, quotes); anything the tests would miss. Verdict READY / CHANGES NEEDED; findings with severity + file:line +
fix; under ~900 words.
