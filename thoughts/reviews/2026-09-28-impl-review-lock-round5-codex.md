Not ready to deploy yet. The payroll write itself is now safe, but the revised diagnostic is still not reliably true, the write path does not satisfy the empty-field invariant, and several comments/tests describe behavior that no longer exists.

## Findings

1. Medium — the `NaNh total` alert can point to a symptom that is not currently on screen.

   The rendering claim is mechanically correct: `NaN.toFixed(2)` produces `"NaN"`, so the header renders `NaNh total` at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2272). The day’s hours cell renders `-`.

   However, `handleLockPeriod` calculates from newly read entries and a newly read roster, while the visible card may have been rendered from earlier entries and the old global roster. On malformed refusal, it neither installs the fresh roster nor re-renders. Therefore [the alert](/Users/christiehubley/tinker-timeclock/js/app.js:2892) can say “their card shows `NaNh total`” when the current card does not.

   “The only visible tell” is also too strong. An invalid clock-out can additionally display an apparent missing clock-out (`...`), for example.

   The alert should describe the calculation directly, not assert current UI state: e.g. “Anika’s calculated total is invalid…” Optionally suggest refreshing and inspecting that person’s entries.

2. Medium — malformed totals are confirmed before they are validated.

   At [app.js:2869](/Users/christiehubley/tinker-timeclock/js/app.js:2869), `Number(NaN) || 0` silently counts a malformed employee as zero. The manager can therefore confirm “2 people, 8 hours… These are the numbers payroll will use,” after which `lockPayPeriod` refuses the malformed snapshot.

   Nothing incorrect is stored, but the confirmation itself is false. Validation should happen immediately after `calcPeriodTotals`, before building the confirmation.

3. Medium — the lock payload does not satisfy “empty fields stripped.”

   `calcPeriodTotals` intentionally produces `name: ''` when the entry name is absent at [app.js:2051](/Users/christiehubley/tinker-timeclock/js/app.js:2051), and `lockPayPeriod` writes that unchanged at [firebase-data.js:209](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:209).

   It also accepts otherwise-valid direct payloads with a missing/undefined `name`; an undefined value would make Firestore reject the transaction rather than being stripped. The critical write is awaited and failure is reported, but the stated non-negotiable stripping invariant is not met.

4. Low — `find` correctly identifies one malformed key, but the returned identity is only partially robust.

   Nulls and numbers are safe because access is short-circuited. Arrays are safe from an exception, though the expression still reads an array’s `name` property despite arrays being rejected.

   The UID is the correct first malformed key in JavaScript property order. The name is the malformed record’s own name and matches the same fresh calculation/render grouping. But:

   - `name` is not validated as a non-empty string.
   - The caller ignores the returned UID.
   - With several malformed employees, only the first is reported, with no “at least” or “there may be more” qualification.
   - The order is entry/insertion order, not the alphabetic order of cards.

   Returning all malformed identities—or at least saying “The first invalid total found is…”—would avoid a second diagnostic loop.

5. Low — stale assertions remain.

   These are now false or materially incomplete:

   - [firebase-data.js:156](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:156) says the fix is “in the WRITE rather than in a read-gate” and that failed reads should not block locking. The current caller explicitly refuses failed and cached reads.
   - [pay-period-lock.emulator.test.js:18](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:18) repeats that a manager is never blocked by a failed read.
   - [firebase-data.js:432](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:432) says the lock path must distinguish a missing roster document from an empty one. The rewrite deliberately treats both as a valid empty roster.
   - [app.js:2937](/Users/christiehubley/tinker-timeclock/js/app.js:2937) says a failed roster read must not become “no staff,” but `loadSchedulesData` assigns the returned empty roster on failure. Removing the unused flag did not make that comment true.
   - [firebase-data.js:170](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:170) omits the new `uid` and `name` result fields.
   - The new wiring test only searches for the strings `result.name` and `NaNh total`; it does not prove that the visible card is based on the same snapshot.

## Direct answers

- `employeeRosterLoaded`: deletion is complete and behaviorally safe. There are no tracked JS, HTML, inline-handler, or production-code readers. The sole occurrence is the negative test. Removing the assignment leaves no dangling syntax and does not change `loadSchedulesData` behavior because both assignments were write-only.
- Successful lock flow: read entries → freshness check → read roster → freshness check → compute → confirm → transaction is sound. The transaction writes the exact `employeeTotals` object that supplied the confirmed aggregate, or refuses because another lock won. I found no successful path where different totals are stored.
- The fresh roster is assigned globally only after successful persistence. The already-locked branch also re-renders, but does not assign the fresh roster; that is safe.
- The transaction uses an awaited, guarded merge and refuses an existing period atomically. It is not a blind overwrite.
- No new collection, rules change, bulk delete, or import exists in this commit.
- Critical persistence is awaited.
- Undefined/empty stripping is the invariant that currently fails.

I could not independently rerun Jest in this read-only environment: Jest attempted to write its haste map under the system temporary directory and was denied; it also detected the untracked `.claude/worktrees` duplicate package. I did verify the committed tree and `git diff --check`. The reported 1800-test pass does not cover the snapshot/UI mismatch or multiple malformed employees.

So: the payroll corruption holes appear converged, but this commit is not yet deployment-ready because the second alert wording is still unreliable and the locked payload violates the stated empty-field rule.
