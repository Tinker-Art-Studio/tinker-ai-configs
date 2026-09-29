## Implementation review — do NOT edit any files, do NOT run deploys.
Repo: /Users/christiehubley/summer-camp-app. Change under review: commits 3deb70f (phase 1) and 2df5be5 (phase 2),
i.e. `git diff dcb7777..HEAD` (also saved at /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-27-impl-review-copied-camp-review.diff).
Plan (design already reviewed twice): /Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-copied-camp-review.html
Rules: /Users/christiehubley/studio-hub/firestore.rules (summerCamps_curriculum ~827, users ~103).

What it does: camps copied by carry-forward (curriculum doc has carriedForwardFrom, no reviewedAt) show a
"Not yet reviewed for <summer>" badge on Curriculum/Lesson Plans/Project Details/Materials; a curriculum-editor band
lets manager/admin (current summer only) Mark reviewed / Undo (update reviewedAt/reviewedBy by doc id).
Also: loadCurriculum's users read no longer fails the tab for staff/prep (users list is manager+ under the rules).
Production today: 23 copied 2027 camps, all unreviewed.

## Check
- Firebase invariants: update not set; awaited; no undefined written; FieldValue.delete through Season.patch works
  (read js/season.js patch()); Season.writeRef gating.
- Correctness of setCampReviewed: flush of pending auto-save (queueCurriculumAutoSave/curriculumAutoSaveChain), the
  guards, campReviewEditing vs window.CURRICULUM_CAMPS after loadCurriculum replaces the array (Save → reload), a
  rename, closing/reopening the editor mid-write, the add-mode path, the error path.
- renderCurriculumGrid now escapes campTopic in the card title — any double-escaping or behaviour change?
- The staff/prep users-read change: any other place that assumed STAFF_NAMES is complete, or that relied on the
  tab failing?
- Phase 2 joins: unreviewedCampNames, Lesson Plans' separate read (does it add latency or a failure mode?),
  lessonUnreviewedNames staleness across filter clicks / season switches; Materials card badge.
- Tests: do e2e/camp-review.spec.js and test/carry-forward.emulator.test.js actually prove what their names say?
  Any vacuous assertion? The e2e/helpers/emulator-admin.js registerSeason change — does registerSeason2027 produce
  byte-identical 2027 docs to before for the existing specs?
- Cache-busters: index.html app.js v58, carry-forward v2, styles v7 (live is app v57, carry-forward v1, styles v6).
Output: numbered findings with severity (HIGH/MED/LOW), file:line, failure scenario, concrete fix. End with one
line: "safe to ship" or "not safe to ship: <why>". Under 900 words.
