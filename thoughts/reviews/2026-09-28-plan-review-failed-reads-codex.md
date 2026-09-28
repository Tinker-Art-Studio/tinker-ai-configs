The plan is not execution-ready yet. Its headline is correct, but Phase 1 does not fully protect the payroll snapshot, and the inventory is complete only under a very narrow “`catch` inside `firebase-data.js`” definition.

## Highest-priority findings

1. **The `getLockedPeriods` overwrite chain is real.**

   - Failure becomes `{}` in [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:172).
   - `renderAdminTimesheets()` computes `!!lockedPeriods[period.key]`, hides the locked state, and enables Lock in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2050).
   - `handleLockPeriod()` performs no lock-status recheck in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2811).
   - `lockPayPeriod()` rewrites `lockedAt`, `lockedBy`, and `employeeTotals` with merge-set in [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:142).
   - The rules permit a manager to perform that overwrite; there is no immutability condition in [firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:442).
   - Payroll uses those stored values as authoritative hours in [index.html](/Users/christiehubley/payroll-tool/index.html:2828).

   So the plan’s headline is true, including destruction of the original “what was paid” snapshot.

2. **Disabling the button after a failed read is necessary but insufficient.**

   The same overwrite remains possible through:

   - stale offline-cache data that returns successfully;
   - another manager locking after the page rendered but before the click;
   - a second click/tab while the first lock is in flight;
   - any future caller invoking `lockPayPeriod()` directly.

   The write itself should atomically refuse an existing `periodKey`, normally with a transaction. A UI guard is defense in depth, not the invariant.

3. **A failed entries read can independently write an empty payroll snapshot.**

   `handleLockPeriod()` re-reads entries, calculates totals, and writes without checking whether that read succeeded. Today failure becomes `[]`, `calcPeriodTotals([])` becomes `{}`, and the lock is written. This needs its own acceptance criterion:

   > Given the lock status is known-unlocked but the lock-time entries read fails, no lock document is written.

4. **The roster read is missing from Tier 1.**

   `loadEmployeeRosterResult()` already distinguishes failure, but initialization discards `ok` through the legacy wrapper in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2854). If that read fails:

   - `employeeRoster` becomes `[]`;
   - `calcPeriodTotals()` cannot perform the deliberate `emp_` → claimed-user merge;
   - a manager can lock a split or incorrectly attributed `employeeTotals` snapshot.

   Locking must require known-good entries, settings, roster, and lock status.

5. **`loadSettings` is correctly Tier 1, but the plan understates its effects.**

   Settings control:

   - overtime threshold, which changes regular versus overtime hours in the locked snapshot;
   - break auto-end timing, which can change paid time;
   - early clock-in gating;
   - alerts and time-off behavior.

   `overtimeMultiplier` itself is returned by the calculation but is not included in `employeeTotals`; the payroll-critical setting is primarily `overtimeWeeklyThreshold`, plus break behavior.

   There is another missing write guard: failed settings currently populate the Settings modal with defaults, and Save can overwrite the real configuration via [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:5487) and [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:5798). Therefore Phase 1 does affect more than one write path.

## Inventory verdict

The table contains all eleven `firebase-data.js` reads whose failure path returns an empty-looking value. The prose saying “ten places” is simply wrong.

But the active application inventory is not complete:

- `getAllTodayEntries()` has no production caller. Its claimed “Who’s Working” effect is wrong. Who’s Working uses `getEntriesByDateRange()` in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:5117).
- `listenTodayEntries()` only logs listener failure and leaves initial or stale status on screen in [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:83).
- The admin entry editor catches a failed direct query, assigns `[]`, and renders “No entries for this date” in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2394).
- The dashboard still calls the swallowing `getHfwaByDateRange()` wrapper and can show “Nothing pending” after HFWA failures in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:4707). Therefore HFWA is not fully “already correct.”
- Existing Result APIs are bypassed by legacy wrappers at consequential sites:
  - `loadEmployeeRoster()` during initialization and roster writes;
  - `loadSchedule()` during time-off routing and sub confirmation;
  - `loadAllUsers()` during account assignment.
- `getPendingTimeOffRequests()` deliberately tolerates failure of its `reversalPending` query. That can return a successful-looking partial list and say “Nothing pending” while reversal work exists. It needs a partial-load state, not merely outer `{ok:false}`.

Excluding writes is reasonable for this plan’s scope, but “`false` is an honest signal” is only true at the data-layer boundary. Callers must check it. For example, `autoCompletePassedTimeOff()` ignores the returned boolean and mutates its local request to `completed` anyway in [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:6827). Keep writes as a separate audit, but revise the wording.

## Tiering

Recommended Tier 1:

- lock status result;
- period entries result, including the lock-time read;
- settings result;
- employee roster result;
- atomic “do not overwrite an existing lock” enforcement.

Consider today-status/listener handling Tier 1 or 1.5: a failure calls the user clocked out and suppresses the shift-end timer, which can leave an open punch and affect paid hours. The plan’s “offers a second clock-in” BDD is inaccurate for the personal UI—the normal clock buttons are intentionally hidden. The kiosk uses a separate direct-read flow that fails back to PIN entry.

`loadStreakData` can remain low urgency, but its description is incomplete: clock-in/out update functions load defaults on failure and then save derived values, potentially overwriting an existing streak. It is not merely a zero-looking card.

## Proposed design

The `{ok, data}` Result shape fits the existing codebase and is the right low-risk direction. I would not replace it with one global banner.

Use:

- local failure states beside the affected data;
- disabled controls where that data authorizes a write;
- one persistent app-level banner only for global dependencies such as settings/roster;
- a small shared failure-message renderer for consistency.

Keep wrappers only where migration genuinely must be incremental, mark them as swallowing/deprecated, and enumerate every remaining wrapper caller. Otherwise they make “the Result API exists” look like completion when the UI still lies.

## Deadline behavior

Fail closed. A manager unable to lock during a connection failure is inconvenient; allowing an unverified lock can overwrite completed payroll or certify incomplete totals. The safe recovery is retry/reconnect, never “lock anyway.”

For the authoritative action, require fresh successful reads and an atomic write that refuses an already-existing period. Cached data can still be displayed as stale, but it must not authorize Lock.

## Test gaps

The proposed structural tests are insufficient. Add behavioral tests for:

- `{ok:false, entries:[]}` renders failure, proving failure wins over empty by observable output—not merely source order;
- `{ok:true, entries:[]}` renders genuine empty;
- not-ready and rejected-read paths;
- failed lock-status read never calls the lock write;
- failed lock-time entries read never calls the lock write;
- failed settings or roster read prevents payroll totals and locking;
- settings failure prevents saving displayed defaults;
- transaction refuses overwriting an existing lock;
- two concurrent lock attempts produce one winner;
- partial `getPendingTimeOffRequests` failure displays “incomplete/could not fully load” while retaining known requests;
- a later successful retry clears the error and restores controls;
- every `getEntriesByDateRange()` caller is migrated or explicitly documented as still using the swallowing wrapper;
- streak read failure does not trigger a default-derived streak write.

The lock transaction is a data-write change, so it should have a failing emulator test first under the repo’s own requirements. Pure and regex tests cannot prove the snapshot is overwrite-proof.

No files were changed and I did not run the suite.
