## Implementation review round 4 — narrow. Do NOT edit files or deploy.
Repo /Users/christiehubley/summer-camp-app. Round-3 reviews (the reason for this change): /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-27-impl-review-copied-camp-review-r3-{claude,codex}.md.
HEAD replaces the "flush the auto-save, then stamp" approach with "Save & mark reviewed" = the normal Save, then the stamp (read `git show HEAD` and js/app.js at HEAD: writeCampReview, setCampReviewed, saveCurriculum, saveCurriculumNow, settleCurriculumAutoSave, openCurriculumEditor, closeModal and the editor close handlers).
1. Can a camp now be marked reviewed while ANY change visible in the editor form is unsaved? Consider every saveCurriculumNow return path (true / 'needs-name' / undefined after a declined rename confirm or a dependents-check error / false), openStudio inputs, co-teacher list not loaded, the rename path, a second click.
2. Anything the old approach did that is now lost, or a new problem (the stamp happens after saveCurriculumNow hid the modal; loadCurriculum 3 s later; campReviewEditing vs CURRICULUM_CAMPS; Undo's op token)?
3. Do the rewritten tests prove their names?
Numbered findings with severity, file:line, scenario, fix. End with "safe to ship" or "not safe to ship: <why>". Under 500 words.
