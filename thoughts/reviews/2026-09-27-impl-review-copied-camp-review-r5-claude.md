Read HEAD's diff, both round-4 reviews, and the six functions plus `index.html`'s grid and the modal bounds.

## Round 5 — implementation review

**Taken findings — all four fixed correctly.**

- **Open Studio (Codex 2 / Claude 3).** `app.js:385` uses `input.defaultValue`. The grid cells are `<textarea>`s whose child text is the literal `Open Studio` (`index.html:1179-1183`); `defaultValue` reflects that text node, which `cloneNode(true)` copies, so it survives every reopening. Order is right: reset (384) → clone (390) → populate (418). Safe under *both* textarea cloning behaviours — if the clone propagates the raw value it keeps what 385 set; if not it falls back to the same text. The production `blocks`-key check in the commit message closes Claude 3's pre-ship condition.
- **Co-teachers (Codex 1).** `app.js:250` gates on `coTeacherListLoadedFor === coTeacherListOpenId`, and `loadCoTeachersForEditor` sets that only after `container.innerHTML` (482) — so the checkboxes are in the DOM before `fields` snapshots and disables them (541-543). The late-insert window Codex described is closed for the review path.
- **Re-queued auto-save (Claude 1).** `app.js:572` runs after the lock clears, as a microtask, so it snapshots the same camp's DOM; `autoSaveCurriculum:9385` uses `CURRICULUM_EDIT_NAME`, so a declined rename cannot write the new name. `needs-name` no-ops at `9375`. Correct.
- **Declined-rename message (Claude 2).** `app.js:573`, gated on `saved === undefined && reviewId`. Correct.

**Not taken (no Save timeout — Codex 3 / Claude 4):** justified for Save, which always had this lock. Worth noting the review button *did* have a 20 s bound before; offline, the editor now freezes un-closable until the write settles. Disclosed in the message; not a blocker.

### New findings

1. **Low-Med — `js/app.js:465-468` (also `483-487`).** `staff.length === 0` and the catch both return without setting `coTeacherListLoadedFor`. Scenario: `users` yields no doc with `name` → `window.STAFF_NAMES = {}` caches for the session → "Save & mark reviewed" refuses forever with "try again in a moment", which never becomes true. Fails closed (no bad write), but the reviewer is stuck. Fix: set `coTeacherListLoadedFor = openId` on the empty-list branch; on the error branch keep refusing but say the staff list failed.
2. **Low — `js/app.js:573`.** "Nothing was saved" is now untrue: line 572 just re-queued an auto-save that writes every field but the name. Reword to "The camp was not renamed or marked reviewed — your other changes were saved."
3. **Low, pre-existing — `js/app.js:9186-9189`, `365`.** Neither closing nor reopening the editor clears `curriculumAutoSaveTimer`, so a timer armed in camp A fires against camp B's form: A's typing is dropped, B is rewritten. HEAD makes it strictly better (template, not A's text). Not a stamp path — `settleCurriculumAutoSave` always runs first. Fix: `clearTimeout` on close/open.

**Q3 — no.** Every control that can appear or re-enable mid-save is accounted for: grid textareas and co-teacher boxes are inside `#curriculum-editor-modal` and in `fields`; `setupGridAutoSave` can't run (367); the band is only redrawn after the lock clears (566); `lockPastSeasonFields` only ever disables (5850, no unlock path); `checkForOrphanedLessonData` touches nothing in the editor. Stamp is strict `saved === true`, by captured `reviewId`.

**Safe to ship.** Findings 1–3 are follow-ups, not blockers.
