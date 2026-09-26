# Implementation review — Classbook SDOC Phase 2B (teachers plan their days)

## Change under review
Repo /Users/christiehubley/tinker-spring-curriculum, branch sdoc-2b-teacher-plans, uncommitted working tree vs `main`
(218f622). `git diff main` — also saved at ~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2b.diff.
Read-only: do NOT edit anything.

Files: js/firebase-data.js (saveSingleLesson opts + SDOC branch before lessonStoreFor; saveDayOffPlan;
verifyDayOffPlanWrite; dayOffFindProject; readDayOffPlanForEditor; dayOffInstallVerified + dayOffInstallSeq /
dayOffVerifiedAt; loadDayOffCampData protected keys; mergeSummerReload protectedKeys; uploadDayOffPlanPhoto;
buildDayOffSlots yearKey), js/app.js (openLessonModal → openPlanEditor split with SDOC branches; SDOC name resolver,
dayOffAuthFor, canEditDayOffPlan; Teacher View: bindTeacherViewControlsOnce, listener SDOC branch, renderTeacherView
SDOC branch + leaving-SDOC picker rebuild, syncDayOffTeacherPicker, renderDayOffTeacherView,
openDayOffPlanFromList, toggleDayOffPlanComplete; Publish enabled for SDOC with a no-teacher confirm),
css/styles.css, e2e/day-off-teacher.spec.js (T1–T17), updated pinned tests in e2e/day-off-camps.spec.js (SDOC 1/16/17)
and e2e/data-safety.spec.js (RED 1.1).

## Design it implements
~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html → section id="phase-2b" (revision 7; reviewed
clean after 8 design rounds). Read it: the save path, allow-lists, edit-stamp/lastEditId verifier, reload protection,
editor split table, Teacher View, permissions (Kathy/Allie edit via canTickDayOffMaterials; teachers need classbook +
their single name on the fresh camp), no SDOC Q&A, "not assigned yet".

## What to check
1. Data safety: can any path lose/corrupt a plan, materials, ticks, the sign-off doc, curriculum/lessonData, or a
   summer lesson? Transaction correctness (compat SDK), allow-lists, photo pair translation, clears, read-back.
2. Summer regression: is the openLessonModal split behaviour-preserving for summer (open, save, photo, Q&A,
   close-wait, failure revert, restore expansion, backdrop close)?
3. Deviations from the design, or design items missing in the code.
4. Teacher View: listener binding once, tvInitialized, switching SDOC ↔ weekly/summer, picker for staff vs admins,
   XSS (everything escaped; keys only via data- attributes), read-only mode really read-only.
5. Reload protection (seq captured before queries, protected keys through mergeSummerReload) — correct and
   complete on both reload paths?
6. Test adequacy: would a broken implementation still pass T1–T17? Anything untested that matters.

## Output
Verdict READY / CHANGES NEEDED; numbered findings with severity (HIGH/MEDIUM/LOW), file:line, concrete fix.
Under ~1200 words.
