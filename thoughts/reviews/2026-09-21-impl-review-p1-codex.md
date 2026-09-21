## Findings

1. **blocker** — [js/app.js:3213](/Users/christiehubley/tinker-timeclock/js/app.js:3213) — Editing an existing flagged override silently unticks it.  
   Concrete input: sub coverage creates `{ start:'09:00', end:'17:00', remind:true, remindUid:'sub-uid' }`. A manager opens it, changes the end to `18:00`, and presses Add Override. `handleAddOverride()` reconstructs the value from only start/end/studio/note, dropping both reminder keys. `buildOverridesWrite()` then correctly interprets that loss as an intentional untick and persists delete sentinels.  
   **Exact change:** until Phase 3 adds the checkbox, preserve `remind:true` and a valid `remindUid` from `editingOverrides[editingOverrideDate]` when committing an edit or move. Phase 3 can replace this implicit preservation with the checkbox state. Add an editor-path test covering flagged override → edit hours → saved value remains flagged.

2. **should-fix** — [js/schedule-helpers.js:351](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:351) — `selectRemindersDue()` can select a flagged recurring shift, contrary to the acceptance criterion.  
   Concrete input:
   ```js
   {
     uid: 'u',
     recurring: {
       Mon: { start:'10:00', end:'14:00', remind:true, remindUid:'u' }
     }
   }
   ```
   with date `2026-10-19` returns a due reminder. I reproduced this directly with Node. The test at [schedule-helpers.test.js:1969](/Users/christiehubley/tinker-timeclock/schedule-helpers.test.js:1969) does not catch it because a `null` override on that Monday shadows the recurring shift.  
   **Exact change:** determine the active schedule layer using the same future-window rule, require that its `overrides` map owns `dateStr`, and only then resolve with `getShiftForDate()`. Add separate tests for flagged base recurring and flagged future recurring with no same-date override.

3. **should-fix** — [js/app.js:5780](/Users/christiehubley/tinker-timeclock/js/app.js:5780) — The in-app Future Schedule CSV writer still deletes every future override and reminder flag.  
   Concrete input: a future block has a flagged `2026-10-17` override; importing updated weekdays constructs `overrides:{}` and writes `futureSchedule` using `mergeFields:['futureSchedule']`, replacing the whole block. The override disappears. This is acknowledged for Phase 3, but means commit `2ad3860` does not independently meet Phase 1’s “no writer drops the flag” outcome.  
   **Exact change:** omit `overrides` entirely, write recurring changes through `buildRecurringWrite()`/leaf updates, and update bounds without replacing the `futureSchedule` container. Use `update()` for existing documents and reserve `set()` for intentional creation. Add an emulator regression proving multiple flagged future overrides survive re-import.

## Checked and found sound

- `applyScheduleEdits()` routes each date before mutation; earlier dates cannot change future-window bounds, so reading `existing` from `after` is safe. SET, PRESERVE, stripping model-supplied keys, and `after` mirroring are otherwise correct.
- Base and nested future unticks produce real delete sentinels; the emulator tests exercise stored results.
- `sameOverride()` is the sole modern reversal comparison and correctly ignores both reminder keys. Legacy cleanup, flagged-original apply/reverse, `sameStructure()`, and `scheduleSignature()` behave appropriately.
- `REMINDER_KEYS` has no TDZ/load-order issue: the earlier functions only close over it and cannot execute until the IIFE has finished initialization.
- `normaliseShift()` continues to ignore reminder metadata, and reminder sentinels do not affect the destructive-save count.
- `hourCycle:'h23'` is specified as `0…23`; `% 24` is redundant but harmless. The current Node 20 runtime resolved `en-US` to Latin digits and produced `00` at Denver midnight. This is also the standardized behavior for compliant Node, Safari, and Chrome implementations. [ECMA-402 specification](https://tc39.es/ecma402/2022/)
- New critical writes are awaited; AI edits use transactional leaf-path `update()`. No collection or rules change was introduced.
- The Summer importer’s recursive merge preserves omitted override dates; a same-date `null` correctly removes a flag because the date becomes a day off.
- I could not rerun Jest/emulator tests in the read-only review sandbox because Jest could not create its cache; the recurring-selection defect was reproduced directly with the committed helper under Node.
