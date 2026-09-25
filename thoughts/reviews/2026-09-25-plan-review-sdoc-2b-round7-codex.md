## Verdict: CHANGES NEEDED

**NEW MEDIUM — `mergeSummerReload()` can still undo the protected save.**

The install sequence correctly covers both reload entry paths:

- `summerReloadHook()` and the listener’s `reloadSummer()` both call `loadDayOffCampData()`.
- The generation gate prevents superseded reloads from installing.
- A concurrent 2A tick mutates the same preserved plan object, while the transactions ensure the verified teacher read contains any tick committed first.

However, after `loadDayOffCampData()` preserves the verified document, `reloadSummer()` still passes its resulting slot through `mergeSummerReload()` unchanged ([firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1126)). That merge compares the captured pre-save slot and fresh protected slot using client-clock `lastEditedAt` ([firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1051)).

If the pre-save slot has a later timestamp because its editor’s clock was ahead, the merge copies its old content fields over the verified document. Worse, `lastEditId` is not in `SUMMER_SAVED_FIELDS`, so the resulting slot can carry the verified save’s ID with the old text.

The plan must make the merge honor the protected-key set—for example, bypass `keepMine` for keys whose verified sequence exceeds that reload’s start sequence—or reapply those verified slots after the merge. Add the stale-query BDD with the pre-save slot’s `lastEditedAt` later than the verified save’s.

No other new HIGH/MEDIUM issue found. No files edited.
