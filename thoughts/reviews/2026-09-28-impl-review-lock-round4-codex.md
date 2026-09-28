I would not approve `aea3a54` as-is. I found two substantive issues, including one that leaves the prior HIGH unresolved.

## Findings

1. **HIGH — assigning the roster does not make the locked totals match what the manager reviewed.**

   The manager confirms at [js/app.js:2830](/Users/christiehubley/tinker-timeclock/js/app.js:2830). Only afterward does the handler re-read entries and roster, replace the global at [js/app.js:2854](/Users/christiehubley/tinker-timeclock/js/app.js:2854), calculate different totals, and write them at [js/app.js:2862](/Users/christiehubley/tinker-timeclock/js/app.js:2862).

   The screen is re-rendered only after the write succeeds, at [js/app.js:2864](/Users/christiehubley/tinker-timeclock/js/app.js:2864). Therefore:

   - Screen was rendered with roster A.
   - Manager reviews roster-A attribution and clicks Confirm.
   - Handler reads newer roster B.
   - Snapshot is calculated and stored with roster B.
   - Only then does the screen show roster B.

   That is still “store totals nobody saw.” The assignment makes the post-lock screen converge, not the reviewed screen.

   The same problem applies to the fresh entries read: entries changed after rendering are also locked after the only confirmation.

   A safe structure would read the fresh inputs first, calculate the candidate snapshot, then either:

   - re-render those exact inputs and require a new confirmation, or
   - compare them with a fingerprint/version of the rendered inputs and refuse if anything changed.

   Also, the comment at [js/app.js:2009](/Users/christiehubley/tinker-timeclock/js/app.js:2009) says `calcPeriodTotals` is shared by rendering and locking, but `renderAdminTimesheets` duplicates the merge and calculation instead of calling it. That weakens any convergence guarantee.

2. **MEDIUM — missing rosters are a legitimate supported state, but locking is now impossible in that state.**

   The application explicitly treats “no roster yet” as valid:

   - `checkNameClaim()` skips claiming when the roster is empty.
   - Users can continue initialization and create UID-keyed clock entries.
   - `handleSeedEmployees()` is an optional initialization action.
   - `calcPeriodTotals(entries, [])` works normally; it simply performs no `emp_ → claimedBy` merges.

   Consequently, a studio that has never created `timeclock_settings/employees` can have perfectly valid UID-keyed hours, but is refused at [js/app.js:2850](/Users/christiehubley/tinker-timeclock/js/app.js:2850).

   An absent document and an existing `{roster: []}` document produce identical totals. The code currently accepts the latter but rejects the former, so this is an initialization-state distinction rather than a calculation-safety distinction.

   Refusing an absent document may be reasonable as protection against deletion of an established roster, but then first-run setup needs an explicit initialization/migration path and a truthful message. “Could not be read from the server” is incorrect when the server successfully reported that it does not exist.

3. **MEDIUM/LOW — `getPayPeriodByKey` does not enforce the canonical period claimed by its comment and test.**

   At [js/app.js:1883](/Users/christiehubley/tinker-timeclock/js/app.js:1883), the regex enforces only the textual shape. JavaScript normalizes some impossible dates:

   - `2026-02-29` becomes March 1.
   - `2026-02-30` becomes March 2.
   - `2026-04-31` becomes May 1.

   All pass `getTime()` validation. It also accepts valid but non-pay-period ranges such as `2026-01-02_2026-01-03`, even though `getPayPeriod()` can only produce `1–15` or `16–last day`.

   Thus a date-looking but noncanonical key can reach the destructive deletion. The normal rendered button supplies a canonical key, limiting practical exposure, but the fail-closed contract is not actually enforced.

   Fixed-width ISO string comparison is correct for ordering. Leap years and normal February dates work. `handleUnlockPeriod` is the only caller and checks `null`, so I found no null dereference.

## Finite-total audit

`Number.isFinite` is safe for the legitimate cases you named:

- Zero-hours person with at least one entry: emits `regular: 0`, `overtime: 0`, `totalHours: 0`.
- Merged `emp_` person: emits one row keyed by `claimedBy`, with all three numeric fields.
- Only an open clock-in: emits all three totals as zero.
- Only a missed-shift record:
  - approved with valid in/out times: finite calculated hours;
  - pending, denied, or incomplete request: zero;
  - malformed approved times: potentially `NaN`, correctly refused.

A roster-only employee with no entries produces no snapshot row at all, which is existing behavior. I found no legitimate path where `calcPeriodTotals` omits `regular` or `overtime`.

The new emulator cases validate hand-built malformed objects, but there is no behavioral test connecting malformed clock data → `calcPeriodTotals` → refusal.

## Global side-effect assessment

The array replacement itself is atomic. I found no code retaining a long-lived reference to the old `employeeRoster` array, and the relevant render/export sections do not `await` after beginning their roster-dependent merge, so they cannot observe a half-transition.

However, failed/cancelled lock paths after [js/app.js:2854](/Users/christiehubley/tinker-timeclock/js/app.js:2854) do not re-render:

- empty-period second confirmation cancelled;
- malformed totals;
- generic write failure.

In those cases, the global roster changes while the visible timesheet and roster-derived schedule partitions remain based on earlier state. This is another reason the lock handler should not silently own application-wide roster synchronization.

## Firebase invariants

Verified from the real diff:

- Lock remains a transaction-protected merge, not a blind overwrite.
- The transaction is awaited.
- Unlock’s existing merge-delete is awaited.
- No new collection.
- No rules change.
- No bulk delete/import.
- Managers still have read/write access to `timeclock_settings` in the real rules.
- The changed write path introduces no new `undefined` values; calculated names fall back to `''`.

No production or Firebase credentials were accessed. I could not rerun Jest because the read-only environment prevented Jest from creating its temporary haste-map file; `git diff --check` completed without diff errors.
