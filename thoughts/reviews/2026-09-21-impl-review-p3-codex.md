No blocker findings. Three should-fix issues remain.

## Findings

1. **Should-fix — CSV import can resurrect a schedule document deleted after the dry run** — [js/app.js:5859](/Users/christiehubley/tinker-timeclock/js/app.js:5859)

Concrete input:

- Dry run reads `timeclock_schedules/uid-kayleigh`; `existingData` is present and contains three flagged future overrides.
- Another manager deletes that schedule document before Write.
- The importer executes `set(payload, { merge: true })`.

Wrong output: Firestore recreates `timeclock_schedules/uid-kayleigh` containing only the imported `futureSchedule` weekdays and bounds. The deletion is silently undone, while the previously snapshotted base schedule, identity fields, and three overrides remain deleted. The UI reports the row as successfully written.

Exact change: perform each write in a transaction. If `entry.existingData` was non-null at dry run, require the document still to exist before `tx.set(payload, { merge: true })`; otherwise throw and mark that row failed. Preserve intentional creation when the document did not exist at dry run.

Add an emulator test:

1. Create the document and capture `existingData`.
2. Delete it.
3. Run the importer-shaped transaction.
4. Assert the operation fails and the document remains absent.

The current emulator helper at [future-schedule-write.emulator.test.js:47](/Users/christiehubley/tinker-timeclock/future-schedule-write.emulator.test.js:47) duplicates the production write rather than invoking it, and has no disappearance case, so this implementation passes.

2. **Should-fix — the confirmation endpoint/template can promise reminders for dates that were never written or are already too late** — [send-timeoff-confirmation-email.js:40](/Users/christiehubley/tinker-timeclock/netlify/functions/send-timeoff-confirmation-email.js:40), [timeoff-confirmation.js:47](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/timeoff-confirmation.js:47)

Concrete input:

```js
shiftsWritten: [{ date: '2026-10-17', ... }],
reminderDates: ['2026-10-18']
```

Wrong output:

> Sub will also get an automatic reminder email … before the shift on Sun, Oct 18, 2026.

October 18 was never written. Likewise, a direct request can submit today’s date: the endpoint checks only the string shape, not the Denver cutoff.

The browser currently supplies the right subset at [js/app.js:7496](/Users/christiehubley/tinker-timeclock/js/app.js:7496), but the email boundary trusts that claim. The requirement is that the email itself only promises reminders for written, reachable dates.

Exact change: at the endpoint, normalize `reminderDates` by intersecting it with valid dates in `shiftsWritten` and filtering against a server-computed `addCalendarDays(denverNow().date, 1)` cutoff before calling the template. As defense in depth, `buildReminderLine` should also intersect with `shiftsWritten`.

Add tests for:

- An unrelated `reminderDates` entry.
- A same-day entry.
- A mixture of valid and unrelated dates.
- Duplicates.

The existing tests cover valid client-generated subsets only, so this passes.

3. **Should-fix — AI status can count a rejected edit as “Reminders set”** — [js/app.js:5326](/Users/christiehubley/tinker-timeclock/js/app.js:5326)

Concrete input:

- October 17 is a valid new AI shift.
- October 18 is already flagged but the AI edit for it is invalid, such as `start: "29:00"`.
- The batch reminder checkbox is ticked.

`applyScheduleEditsTransaction` writes October 17 and reports October 18 in `r.rejected`. Because the count uses every key in `g.edits`, the unchanged, pre-existing October 18 flag is also counted.

Wrong output: `Reminders set for 2 dates.` Only one accepted date was written by this batch.

Exact change:

```js
const rejectedDates = new Set(r.rejected.map(x => x.date));
const acceptedDates = Object.keys(g.edits).filter(d => !rejectedDates.has(d));
remindersSet += countFlaggedDates(r.after, acceptedDates);
```

Prefer returning accepted dates explicitly from `applyScheduleEdits` so status and email reporting share the same authoritative set. Add a mixed valid/rejected test where the rejected date was already flagged. The current wiring test at [schedule-editor-wiring.test.js:1742](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:1742) only pins the problematic source expression.

## Checked and found sound

- The editor checkbox defaults off, resets in `clearOverrideForm`, hides for Day Off, and is prefilled from literal `remind === true`.
- Unticking rebuilds the logical override without either reminder key; `buildOverridesWrite` emits child delete sentinels for both `remind` and `remindUid`. It never writes `false`, `null`, or an empty UID.
- `resolveReminderUid` handles both requested identity cases:
  - An `emp_` schedule resolves through the roster’s `claimedBy`.
  - A UID-keyed schedule still resolves when `allUsers` is empty, provided the roster loaded and identifies that UID through `claimedBy`.
  - An existing stored UID is retained when neither lookup resolves.
- AI unticked mode preserves an existing flag and writes no flag on a new date. Ticked mode retains a stored UID if fresh resolution fails.
- Flag-only changes remain invisible to `sameShift`/`diffScheduleDates`, so the editor produces “no date changes to notify about.”
- The normal CSV write shape does not contain an `overrides` key. Recursive merge preserves existing and concurrently added overrides.
- Weekday deletion sentinels are limited to weekdays present in the dry-run snapshot. A weekday added under a previously absent key after dry run survives.
- Empty maps are passed through `omitEmptyMaps`; valid parsed CSV rows always supply at least one weekday and both bounds.
- The browser cutoff uses `denverNow().date` plus calendar-day arithmetic, so ordinary same-day versus tomorrow decisions are based on Denver rather than the browser or Lambda timezone.
- The email reminder sentence itself contains no time of day.
- `activeOverridesFor` applies the same future/base-layer rule as `getShiftForDate`; both `countFlaggedDates` and `selectRemindersDue` use it. This is suitable for Phase 4 and Phase 5.
- Bells receive the resolved shift object in My Schedule and Who’s Working week/month; `buildShiftDetail` retains the boolean for the popup.
- Critical Firestore operations introduced here are awaited and row failures are surfaced. No new collection or rule change was introduced.

## Test execution

`npm test` could not run because the sandbox prohibits binding the Firestore emulator ports (`EPERM` on 4400, 4500, 8080, and 9150). Direct Jest execution also failed because Jest could not create its haste-map cache in the read-only temporary directory.

No repository files were edited.
