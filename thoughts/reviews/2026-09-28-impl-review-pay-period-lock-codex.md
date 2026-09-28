## Review verdict

I would not deploy `af15db0` yet. The transaction itself is valid, and Path B is substantially closed, but the implementation does not establish the larger invariant that payroll receives exactly the totals the manager reviewed.

### Findings

1. **[P1] An empty lock is not authoritative in the Payroll Tool.**

   Ticker now intentionally permits `employeeTotals: {}` after confirmation at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2829). But Payroll iterates employees found in the live entries/HFWA data, then falls back to raw hours whenever that UID is absent from the locked map:

   - Employee population: [index.html](/Users/christiehubley/payroll-tool/index.html:2751)
   - Fallback: [index.html](/Users/christiehubley/payroll-tool/index.html:2828)

   Therefore:

   1. Manager locks a genuinely empty period.
   2. `{}` is stored.
   3. A missing punch or admin entry is added afterward—both are allowed by current UI/rules.
   4. Payroll finds that live UID, finds no locked entry, and pays raw hours.

   This also affects any nonempty lock when a new UID appears later. Absence in the authoritative snapshot currently means “use live hours,” not zero.

2. **[P1] Path A is closed only for a failed lock-time read, not for “what the manager reviewed.”**

   The screen still renders through the swallowing wrapper at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2073), while locking performs a separate query at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2817).

   Concrete remaining routes:

   - The render query fails and displays an empty period; the lock query succeeds and stores hours the manager never saw.
   - Entries change between rendering and pressing Lock; the fresh query stores different totals.
   - Concurrent/out-of-order `renderAdminTimesheets()` calls can render one period’s asynchronous result while `adminTsPeriodOffset` points at another; navigation calls are not awaited or generation-guarded at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:2038).
   - The entries query succeeds from offline cache. Offline persistence is enabled at [firebase-config.js](/Users/christiehubley/tinker-timeclock/js/firebase-config.js:28), but `getEntriesByDateRangeResult` ignores `snap.metadata.fromCache` at [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:110). Firebase explicitly says cached results may be stale or incomplete and offline collection queries can return empty cached results. [Firebase offline documentation](https://firebase.google.com/docs/firestore/manage-data/enable-offline)

   The transaction guards the lock document only; it does not make the earlier entries/roster reads part of the transaction.

3. **[P2] “Malformed totals are refused” is not true.**

   The validator at [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:168) only requires a non-array object with at least one key. It accepts:

   ```js
   { uidA: 1 }
   { uidA: { name: "A" } }
   { uidA: { regular: NaN, overtime: NaN, totalHours: NaN } }
   ```

   The new happy-path test itself uses `{ name, hours }`, which is incompatible with the Payroll Tool’s required `regular`, `overtime`, and `totalHours` fields at [pay-period-lock.emulator.test.js](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:35).

   A malformed but nonempty result therefore bypasses the guard and can store payroll-incompatible data.

4. **[P2] The tests do not prove the end-to-end claims.**

   - The “Path A” emulator test passes `{}` directly to `lockPayPeriod`; it does not execute a failed entries query or `handleLockPeriod`.
   - Caller tests are source-text regex assertions, not behavioral tests.
   - The hybrid test at [pay-period-lock.emulator.test.js](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:105) passes because the period is already locked. That meaningfully proves “no partial merge over an existing lock,” but it does not detect a partial first snapshot. It should at least assert `reason === 'already-locked'`.
   - There is no concurrent-lock/retry test.
   - The data test substitutes an Admin SDK transaction adapter at [pay-period-lock.emulator.test.js](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:42), so it does not execute Firebase 10.8 compat code or security rules.
   - There is no Payroll consumer contract test, particularly for empty locks and missing UIDs.

### Requested checks

1. **Transaction compatibility:** Sound. Firebase v8/compat defines `runTransaction<T>(callback): Promise<T>`, returns the callback’s value, retries the whole callback when the read document changes, and supports `transaction.set(ref, data, {merge:true})`. [v8 `runTransaction`](https://firebase.google.com/docs/reference/js/v8/firebase.firestore.Firestore#runtransaction), [v8 `Transaction.set`](https://firebase.google.com/docs/reference/js/v8/firebase.firestore.Transaction#set)

   A competing lock causes a retry; the retry sees the stored period and returns `already-locked`. The superseded attempt’s queued write is not committed. There is no double write. A later unlock can naturally make the returned status stale after the transaction completes.

2. **Path A:** The exact failed lock-time read is closed. The reviewed-snapshot invariant is not; see P1 finding 2.

3. **`allowEmpty`:** `isEmpty` accurately reflects whether `calcPeriodTotals` produced keys, but not whether the underlying read was authoritative. Cache/incomplete data and render-versus-lock mismatches remain. The confirmation can indeed become the only protection.

4. **Boolean migration:** No missed production caller. `handleLockPeriod` is the sole production caller.

5. **Wrapper compatibility:** The existing callers retain the previous `entries-or-[]` contract. I found seven production calls, not five; none depend on the inner result object.

6. **Roster guard:** Initial startup awaits `loadSchedulesData`; a premature click sees the initial `false` and is refused. However, the flag means “the last roster read succeeded,” not “this roster is current or matches the reviewed screen.” It does not solve snapshot consistency.

7. **Unlock:** A failed lock-status read hides Unlock; it does not directly cause an unintended unlock. The leaf delete is awaited and appropriately scoped. A transactional/CAS unlock would improve concurrency auditability, but it is not the main remaining payroll risk. Post-lock entry mutation and Payroll’s missing-UID fallback are more serious.

8. **Tests:** The existing-record/hybrid protection is real, but the test proves it through `already-locked`, not partial-snapshot detection. Compat, retry, failed-render, cache, and downstream Payroll behavior are untested.

9. **Firebase invariants:** No new collection, rules change, bulk operation, or unawaited critical lock write. The guarded merge targets one period key and is reasonable here. No persisted `undefined` path was found; invalid values would reject the transaction. The existing unlock is an awaited leaf delete via merge.

I could not independently rerun the suite because this review environment forbids Jest from creating its temporary haste-map file (`EPERM`); that is an environment restriction, not a test failure. No files or external state were changed.
