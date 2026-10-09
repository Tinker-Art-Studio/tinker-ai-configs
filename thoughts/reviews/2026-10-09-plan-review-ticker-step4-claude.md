## Verdict: READY WITH CHANGES

Findings 1 and 3 have to be fixed in the plan before any code is written. Each one leaves a way for a locked period's hours to change.

**Claims I checked and found correct:** every line number cited (1869, 2512, 2581, 2600, 2711, and rows B1–B10). Delete has no in-flight guard. The rules let managers read and write both entries and settings (`firestore.rules:463,506`). `calculateDayHours` (`app.js:1945`) only reads `timestamp`, `type`, `date` and `changeRequest.status/requestedTimeIn/Out`. So excusing a late punch and the streak fields can't change hours, and the same is true in the Payroll Tool's copy (`payroll-tool/index.html:3249`). The Payroll Tool reads `lockedPeriods[periodKey].employeeTotals` (3036–3037). A missing lock doc already reads as `{}`. Doing the check and the write in one transaction is the right place to enforce the lock: offline it can't commit, and a lock saved in between makes it retry.

### Findings

**1. HIGH: staff "missing punch" reports change locked hours today, and the plan says they can't.**
The plan says missing punches are "pending, which counts for nothing until approved; the staff screens already block locked dates." Both parts are wrong for a single missing punch:
- `submitMissingPunch` (`app.js:1235–1316`) never checks the lock. It only shows a "previous pay period" confirm (1245–1249).
- The entry is saved as a normal `clock-in`/`clock-out`. Neither `calculateDayHours` (`app.js:1964–1972`) nor the Payroll Tool's `calcDayPaidHours` (`index.html:3268–3276`) looks at `changeRequest.status`, so the punch counts the moment it's saved.

Only a whole missed shift waits for approval. So any staff member can add hours to a locked period right now.
*Fix:* send `submitMissingPunch` through `writeClockEntryIfUnlocked({op:'add'})`. The current rules already allow it: staff can read `timeclock_settings` (rules:508) and create their own entries (rules:467). Add a BDD for it, and ask Christie to confirm this falls under "A".

**2. HIGH (already in the code, affects payroll): a denied missing punch is still paid.**
Denying only sets `changeRequest.status` (2727). The punch keeps counting in both apps for good. The plan's line "denial doesn't change hours" is accurate, but only because of this bug.
*Fix:* not in this plan's scope. Record it in the plan and give it its own fix (or fold it into C). Both apps' hour calculations need to change together.

**3. HIGH: approving or denying doesn't check that the request is still pending.**
- **Deny on an already-approved request:** if the list is stale (another tab or manager already approved it), pressing Deny turns approved into denied. For a missed shift that removes its hours (1959) inside a locked period, and the plan leaves denial unchecked.
- **Approving twice:** this overwrites `originalTimestamp` with the already-corrected time (2753), so the audit trail loses the original.
- The Approve button has no in-flight guard.
- The changes are built from `entryDoc`, read before the transaction (2717), and that read can come from the offline cache.

*Fix:* run both approve and deny in a transaction that requires `changeRequest.status === 'pending'` (else return `already-reviewed`). Lock-check every approve. Build the changes from the copy read inside the transaction, not the earlier read. Add an in-flight guard to Approve.

**4. MEDIUM: an edit with a stale date can save the wrong time.**
`adminEditSaveEntry` builds the new timestamp from the screen's `entry.date` (2523). In the plan's "stale date" scenario, if neither date is locked, a timestamp built for the screen's date gets written onto an entry stored under a different date.
*Fix:* pass `expectDate` and refuse with `changed` when the stored date differs.

**5. MEDIUM: the Phase 2 sweep test won't catch everything.**
The proposed list leaves out `addClockEntry`, `deleteClockEntry`, `saveSchedule`, `deleteSchedule`, `saveSettings` and `appendTimeOffComment`. Matching only `await x(` also misses calls without `await` and `.then` chains.
Separately for B4, `addTimeOffComment` reads the whole comments array and writes it back (7882–7895), so two comments saved at once can lose one. Switch it to the existing `appendTimeOffComment`, which adds with `arrayUnion` and already returns its result.
Small wording fix for B1/B2: they do reload real state (`getAllTimeOffRequests`). The bug is that a failure shows no message.

**6. MEDIUM: offline, a normal save hangs instead of failing.**
Offline persistence is on (`firebase-config.js:30`). Offline, a normal write is queued and its promise doesn't resolve until the device reconnects, and the local cache shows the change as already done. So Phase 2's failure path only covers rejected writes (rules, not ready). An offline manager sees a hang, not a message.
Transactions offline do fail, but only after a few seconds of retrying.
*Fix:* say this in the plan, and write the acceptance criteria as "rejected" rather than "didn't reach the database". In Phase 1, disable Save, Delete, Add and Approve while the transaction runs. Add and Approve have no guard today.

**7. LOW: the test harness can run the plan's tests, with two limits.**
The existing `dbForSandbox` wrapper passes `tx.get/update/delete/set`, `.doc()` auto-ids and Admin `FieldValue` through correctly. But:
- The sandbox only gets globals it's given explicitly (`pay-period-lock.emulator.test.js:52–63`). `lockedPeriodForDate` must be injected there and in `firebase-data.failure.test.js`.
- The Admin SDK skips the rules and, in the emulator, waits on locks instead of retrying. So "locked after opening" can only be tested by saving the lock before the call, which doesn't prove the web SDK's retry. A denied read can only be tested with the fake db. Say both in the plan.

**8. LOW: the editor's read-only courtesy checks the wrong date for Add.**
It's keyed on the day the editor opened, so it blocks adding to an unlocked date picked in `aee-new-date` (`index.html:1267`). It also doesn't react if the picker is moved onto a locked date.
*Fix:* disable only Save and Delete for the opening day. Check Add against the picker's value, or don't disable it at all.

**9. LOW: three gaps missing from the accepted-residuals list.**
- (a) Staff can create HFWA sick-leave records on locked dates, and the Payroll Tool reads those fresh on every pull. The lock snapshot doesn't cover them.
- (b) Changing the roster (claim, merge or assign: B5, B7, B8) changes whose hours are whose for locked periods in both `calcPeriodTotals` (2036–2045) and the Payroll Tool (3048–3053). No entry changes, yet the Payroll Tool's recalculated totals can stop matching the locked ones.
- (c) Kiosk clock-out timestamps can be backdated (see the `writtenAt` comment around 10346). `date` is still today, so the kiosk residual still holds, but "always now" is wrong.

**10. LOW: older problems in the approval code being rewritten.**
- Approved times are read in the browser's local time zone (2748, 2755), not with `hhmmDateToMTDate` (2489).
- An empty time box makes `new Date('…T:00').toISOString()` throw before any write, and the manager gets no message.
- An empty missed-shift time is saved as `''`.

Fix these while rewriting that code, or list them.

I haven't changed any files. The findings are also saved at `/Users/christiehubley/.claude/plans/plan-under-review-memoized-emerson.md`.
