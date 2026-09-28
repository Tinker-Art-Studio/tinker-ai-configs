## Findings

1. **High — the roster corruption path is not actually closed.**  
   [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:6050) still calls the swallowing `loadEmployeeRoster()`. If that read fails, it receives `[]`, seeds it, and `saveEmployeeRoster()` fully overwrites the stored roster. A later “fresh” read in [handleLockPeriod](/Users/christiehubley/tinker-timeclock/js/app.js:2843) successfully reads that already-corrupted roster, so `rosterNow.ok` is true and the lock can still split `emp_` hours from the claimed user.

   There is a second hole: [loadEmployeeRosterResult](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:416) uses the same default cached `get()` behavior as the entries query but does not report `metadata.fromCache`. A network loss between the entries and roster reads can therefore lock against a stale roster.

   Fix both sides:

   - Make `handleSeedEmployees` use `loadEmployeeRosterResult()` and abort on `!ok` or a cache-served result before any overwrite.
   - Report `fromCache` for roster reads and refuse it in the lock path, or use a dedicated server-only roster read there.

2. **Medium — unlock does not fail closed on a missing or malformed key.**  
   [getPayPeriodByKey](/Users/christiehubley/tinker-timeclock/js/app.js:1879) performs no structural, calendar, or semi-month validation. More importantly, [handleUnlockPeriod](/Users/christiehubley/tinker-timeclock/js/app.js:2868) behaves as follows:

   - Missing or empty key: silently falls back to `adminTsPeriodOffset`, restoring the original wrong-period race.
   - Malformed truthy key: displays either the raw value or “Invalid Date,” then passes the raw key to deletion.
   - Extra segments: labels the first two components but deletes the complete raw key.

   Valid current UI keys cannot trigger this: `getPayPeriod()` produces only `YYYY-MM-DD_YYYY-MM-DD`. Consequently malformed input normally deletes the malformed field, not a different valid period. But an irreversible handler should require an exact canonical key rather than treating missing input as permission to choose another target. Validate in `unlockPayPeriod` as well as the UI boundary, and refuse absent keys entirely.

3. **Medium — “payroll-compatible” validation accepts payroll-incompatible records.**  
   [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:179) says the contract includes `totalHours`, `regular`, and `overtime`, but validates only `typeof totalHours === 'number'`. These pass:

   ```js
   { uidA: { totalHours: 8 } }
   { uidA: { totalHours: NaN, regular: "x", overtime: null } }
   ```

   The Payroll Tool directly consumes all three fields at [index.html](/Users/christiehubley/payroll-tool/index.html:2829). Validate all three with `Number.isFinite`, preferably also nonnegative and with `totalHours` consistent with `regular + overtime`.

   For normal data, `calcPeriodTotals` does emit numeric fields for `emp_` merges, zero-hour employees with entries, and ordinary employees. HFWA-only people are intentionally absent because HFWA is handled separately by Payroll. Malformed approved shift times can nevertheless propagate `NaN`, which the current check accepts.

4. **Low — the tests overstate what they prove.**  
   The concurrency test at [pay-period-lock.emulator.test.js](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:151) exercises concurrent calls, but it does not force both reads to observe the unlocked state. A non-transactional read-then-write implementation could occasionally pass if one call completes before the second read. A barrier-controlled fake or two explicitly synchronized clients would make this deterministic. The source test does independently assert `runTransaction`, so current coverage is useful, just not a mutation-proof concurrency test.

   The unlock wiring assertion at [schedule-editor-wiring.test.js](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:332) verifies source text only. There are no behavioral tests for valid/missing/malformed keys or rendered handler output. Likewise, `fromCache` is protected only by source matching, not a result-shaped test.

## Confirmed

- The generated button HTML is valid:

  ```html
  <button onclick="handleUnlockPeriod('2026-09-16_2026-09-30')" ...>
  ```

  Every key produced by `getPayPeriod()` is quote-safe, so the current producer cannot inject markup. The risk appears only if this helper is later fed an untrusted/raw key.

- `getPayPeriodByKey()` reproduces the fields unlock actually needs: `key` and `label`. Missing `start`/`end` `Date` objects do not affect the current unlock path.

- `snap.metadata.fromCache` exists on compat `QuerySnapshot`, and its meaning is correct here. Default `get()` tries for current server data and may fall back to cache; `fromCache` identifies results not guaranteed current. Refusing such a result for payroll locking is appropriate, even if it occasionally blocks during transient connectivity trouble. [Firebase v8 QuerySnapshot](https://firebase.google.com/docs/reference/js/v8/firebase.firestore.QuerySnapshot), [Firebase v8 GetOptions](https://firebase.google.com/docs/reference/js/v8/firebase.firestore.GetOptions)

- `employeeRosterLoaded` is now dead: it is declared and assigned but never read. Other callers still depend on `employeeRoster`, and `loadSchedulesData()` still assigns it. The new lock read adds a second, sequential roster read and does not refresh the global, so the displayed table can remain based on the older global even when the locked snapshot used the newer roster.

- The repaired slice has both lower and upper length guards; I found no newly widened slice elsewhere in this diff.

- Firebase invariants in this commit: writes remain awaited; lock uses transaction-guarded merge; unlock uses a merge with a delete sentinel; no blind overwrite, new collection, bulk delete/import, or rules change was introduced. The manager rule at `firestore.rules:443` permits the transaction read/write.

- All four changed JavaScript files pass syntax checking and `git diff --check`. I could not rerun Jest in this read-only environment because Jest attempted to create its haste-map cache in the system temporary directory.
