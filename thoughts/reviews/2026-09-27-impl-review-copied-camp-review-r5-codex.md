Accepted fixes are otherwise correct: Open Studio defaults survive `cloneNode`, declined renames autosave other edits without renaming, and loaded co-teacher controls are frozen before collection. The timeout rejection is justified as a pre-existing availability issue, not an integrity regression.

1. **MEDIUM — `js/app.js:569-577, 9364-9385`.** The re-queue does not preserve typing after `'needs-name'`. It runs immediately, but `autoSaveCurriculum()` exits when the visible name is blank. Restoring the name does not re-trigger grid autosave, so closing can still lose the grid change. Fix: for an existing camp, autosave using `CURRICULUM_EDIT_NAME` even when the visible name is blank, or defer/re-arm autosave until a valid name returns.

2. **LOW — `js/app.js:247-251, 463-482`.** If no named staff exist, `loadCoTeachersForEditor()` returns without setting `coTeacherListLoadedFor`; a read failure does likewise. “Save & mark reviewed” then remains permanently blocked as “Still loading,” although no editable co-teacher checkbox exists. Fix: represent loading, loaded-empty, and failed explicitly; allow review after loaded-empty, and show an accurate retry-required message after failure.

I found no path where “Save & mark reviewed” stamps while a visible editor change is unsaved: the co-teacher gate runs before the synchronous form lock, the loader marks completion only after insertion, and stamping remains gated on `saved === true`.

**not safe to ship: the accepted aborted-save fix still loses pending grid typing in the `needs-name` path.**
