## Round-3 confirmation — copied-camp review (735ddf8)

**Round-2 items all land.** The skip paths now flag (`js/app.js:9372`, `9374`) and the gate checks them (`253`) — the new test at `e2e/camp-review.spec.js:223` discriminates via the doc *and* the unique message, and would have been green-free on `f0a2fca`. The flag is keyed to the id captured at the auto-save's start (`9371`, `9409`, `9415`), so camp A's late failure no longer blocks camp B. The op token (`231`, `274`, `404`) fixes the unlock-across-openings finding and cannot get stuck `true` (a second `setCampReviewed` is refused at `227`; `openCurriculumEditor` always clears it itself). The 20 s race (`244-249`) clears its timer on both outcomes — no dangling timer, no stuck `campReviewFlushing`. The switch test is now non-vacuous: `Fixture Newcomers` exists (`spec:72`), so the title and `CURRICULUM_EDIT_ID` would change if the guard were removed.

### Findings

1. **MED — `js/app.js:236-262`, with `538-545`.** The flush awaits the chain *as it stood* when the race was built; the grid inputs stay enabled throughout. *Scenario:* manager clicks Mark reviewed with a pending change, keeps typing during the round-trip → the `input` listener sets a fresh 2 s timer, the awaited chain resolves, the successful save clears `curriculumAutoSaveUnsavedId`, and the review write commits with that newest cell unsaved. It normally lands 2 s later, but closing and opening another camp inside those 2 s makes the queued entry read the *next* camp's form (`9371`) and the change is gone — camp marked reviewed, edit lost. *Fix:* disable the editor fields for the flush as `saveCurriculum:557-559` does, or after the flush refuse/re-flush while `curriculumAutoSaveTimer` is non-null.

2. **LOW — `js/app.js:406` + `index.html:1179-1183`, with `398-403`.** The reset's premise ("the form is refilled from the stored camp") is false for openStudio: `400` deliberately skips those inputs, and `430-436` only overwrites days the stored doc has. A camp whose doc lacks `blocks.openStudio.<day>` (e.g. `blocks: {}`, as at `spec:72`) keeps last opening's typed openStudio text on the form while the unsaved flag is cleared → Mark reviewed succeeds with it unpersisted. *Fix:* reset openStudio inputs to their default text too.

3. **LOW — `js/app.js:554`, `9195`.** Round-2's "say something instead of returning silently" was applied to × and Cancel (`9177`, `9186`) but not to Save or the backdrop: clicking Save during a flush does nothing, with no feedback. *Fix:* same `showError`.

4. **LOW — `js/app.js:253-257`.** On the 20 s give-up the flush lock is released while a not-yet-started chain entry remains; switching camps then makes it write the new camp's form, dropping the old change — while the message ("Still saving your last change") implies it will land. *Fix:* also set `curriculumAutoSaveUnsavedId = id` on timeout and soften the wording.

Tests not re-run here (emulators); commit claims 144/144. Both new/changed tests prove their names.

**not safe to ship: Mark reviewed can still succeed with the latest grid change unsaved — a cell typed during the flush window (1), and residual openStudio text after the flag reset (2).** Both fixes are a few lines.
