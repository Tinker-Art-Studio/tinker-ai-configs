I could not run the suite or a Node probe: `npm test` and `node <script>` both hit permission approval, and this session is non-interactive. Everything below is from reading the real files at `aea3a54`; the **1800-passing claim is unverified by me**. Everything else I state, I checked in the source.

## Findings, ranked

### 1. The new `malformed-totals` message points at a thing the UI never draws — `js/app.js:2871` (MEDIUM)

The message is: *"Check this period's entries for a **red row**, fix it, then lock again."*

There is no red row for this condition. Grepping every red indicator in the timesheet view, there are exactly two:

- `app.js:2158` — a red "⚠️ Open punch" pill (clock-in with no clock-out on a past date)
- `app.js:2227`/`2229` — a red-bordered "Duplicate clock-in detected" row (`hasConsecutiveClockIn`)

Neither is produced by the NaN case. Trace it: a day whose totals go NaN renders its day row with `hours.totalHours > 0` false → hours cell shows `-` (`app.js:2233`), no delta, no flag, and no open-punch badge (there *is* a clock-out, it just doesn't parse). The **only** on-screen tell is the card header at `app.js:2263`: `${total.toFixed(2)}h` with `total = NaN` renders literally **`NaNh total`**.

So the branch that exists specifically to stop sending a manager into a loop at a deadline replaces "Please try again" with an instruction to look for something that isn't on the screen. Compounding it: `lockPayPeriod` uses `keys.some(...)` (`firebase-data.js:185`) and returns `{ ok: false, reason: 'malformed-totals' }` with **no key** — so one employee blocks locking the whole period and the manager is not told which one.

Both halves are cheap: `keys.find(...)` instead of `.some(...)`, return the offending key, and have the alert say *"<Name>'s hours show as NaNh — open their card and look for a day with a time that reads 'Invalid Date'."* That is the actual symptom, and `formatTime(new Date(bad))` does render `Invalid Date` in the day row, so the instruction would be true.

### 2. The rationale's central claim about `employeeRosterLoaded` is false (MEDIUM-LOW)

The commit message says *"employeeRosterLoaded stops being write-only."* It does not. `\bemployeeRosterLoaded\b` across the repo (js, html, tests) has exactly three hits:

- `app.js:5590` — the `let` declaration
- `app.js:2855` — the new write in `handleLockPeriod`
- `app.js:2921` — the write in `loadSchedulesData`

**Zero reads.** `employeeRosterLoaded = true` at `app.js:2855` is a no-op assignment to a dead variable, and the declaration's comment (*"an empty one is not the same as none"*) still promises a guard that does not exist anywhere. Worth fixing the commit message before this ships — the next round will read it as ground truth, and this lineage has already spent a round on a reviewer claim that turned out to be wrong.

### 3. Convergence is real on 2 of 5 exit paths — `js/app.js:2854` (MEDIUM-LOW)

Answering your own doubt: no, it isn't fully convergent. After `employeeRoster = rosterNow.roster`:

| path | re-renders? |
|---|---|
| `result.ok` | yes (`2864`) |
| `already-locked` | yes (`2867`) |
| `isEmpty` + manager cancels (`2860`) | **no** |
| `malformed-totals` (`2868`) | **no** |
| generic error (`2872`) | **no** |

On those three the global moved and the screen didn't. Nothing was locked, so there's no snapshot/screen divergence — but the divergence is *relocated*, not removed: `exportTimesheetsXlsx` (`app.js:2288`) does its own inline `emp_` merge off the global, so the next xlsx export uses the new roster while the cards still on screen used the old one. Adding `renderAdminTimesheets()` to the three refusal paths closes it, and is consistent with what the other two already do.

### 4. The test's name now contradicts its own assertion — `schedule-editor-wiring.test.js:325` (LOW)

```js
test('the roster is read HERE, not taken from the global eleven call sites write', () => {
  ...
  expect(block).toMatch(/calcPeriodTotals\(read\.entries, employeeRoster\)/);
```

The test is titled "not taken from the global" and now pins the line that *does* take it from the global. The inline comment explains why that's fine, but the title is the part that gets read. Also "eleven" is now twelve (`grep -c` on the assignment form gives 12: `2854, 2920, 5997, 6017, 6089, 6426, 6676, 6721, 8087, 8237, 8846, 8904`), and the code comment that "eleven" mirrored was deleted by this very commit. This is the same shape as the three stale assertions you already caught — it just didn't fail, so nothing surfaced it.

### 5. `!exists` fails closed correctly but says something untrue — `js/app.js:2850` (LOW)

Taking your question 2 in order: **refusing is correct, and the merge would indeed be a harmless no-op.** `emp_` ids originate *only* from the roster (`handleAddEmployee`, `app.js:6131`; `handleSeedEmployees`, `app.js:6081`), so no roster document ⇒ no `emp_` ids in `timeclock_entries` ⇒ `calcPeriodTotals`'s merge loop (`app.js:2017`) has nothing to do. Locking a never-seeded studio would be safe. So you have not broken correctness.

What you have broken is the exit. `saveEmployeeRoster` is a bare `.set()` (`firebase-data.js:507`), so the document is created by adding any employee — but the alert says *"could not be read from the server… try again"*, and retrying never works. Three distinct causes (`!ok`, `fromCache`, `!exists`) share one message, and for the only case `!exists` uniquely catches, that message is false. Split it: `!exists` → *"No employee roster has been set up yet. Add your staff under Roster first, then lock."* Note also that the entries-read message one branch up (`2842`) correctly says "reconnect", and the roster one doesn't, for the same `fromCache` cause.

### 6. `handleLockPeriod` is now the 12th site that can swap the array identity under a positional rollback (LOW, pre-existing class)

Two handlers roll back by *position* across an `await`, holding the array by the global name:

- `removeEmployee` (`app.js:6596-6603`): `idx = findIndex(...)` → `splice(idx, 1)` → `await saveEmployeeRoster(...)` → on failure `employeeRoster.splice(idx, 0, entry)`
- `handleAddEmployee` (`app.js:6131-6139`): `push(...)` → `await saveEmployeeRoster(...)` → on failure `employeeRoster.pop()`

If a `handleLockPeriod` reaches line 2854 while one of those awaits is pending, the rollback lands on a *different array* — `pop()` removes an unrelated real employee, `splice(idx, 0, entry)` re-inserts a duplicate (the failed save means the server copy still has them). Any of the seven `saveEmployeeRoster` writers then persists it.

I'm calling this LOW and not raising it as new: four assignment sites (`2920`, `8087`, `8237`, `8846`, `8904`) already have this property, it needs cross-tab interleaving during a slow save, and the duplicate case doesn't double-count in `calcPeriodTotals` (the `delete byUid[emp.id]` at `2024` makes the second pass a no-op). It's the honest answer to "does that break anything that holds a stale reference": yes, this exact pattern, and you've added one more way to trigger it.

## Direct answers

**Q3 — `getPayPeriodByKey` is sound.** The regex covers every key `getPayPeriod()` can produce: `formatDateStr` (`app.js:4428`) zero-pads month and day via `padStart(2,'0')` and `getFullYear()` is 4 digits for any realistic year, so year boundaries and February are fine — the key is purely mechanical, it never depends on the calendar. `startStr > endStr` is correct: zero-padded `YYYY-MM-DD` compares lexicographically exactly as it compares chronologically. And `getPayPeriodByKey` has exactly **one** caller (`handleUnlockPeriod`, `app.js:2883`), which null-checks — nothing dereferences it. One note: the regex admits impossible calendar dates like `2026-02-30`, which the `Number.isNaN(getTime())` check should reject under ISO parsing — but even if an engine rolled one over, `period.key` is the verbatim input string, so the worst case is a mislabelled confirm dialog, never a wrong delete target.

**Q4 — the tightening cannot break a legitimate lock from this app's own data.** I enumerated your four cases plus the paths that actually produce NaN:

- *zero-hours employee with entries*: `totalMs = 0` → `{regular: 0, overtime: 0, totalHours: 0}`. All finite. Locks.
- *only an open clock-in*: `clockInTime` set, never consumed, `totalMs = 0` → same. Locks.
- *only a missed-shift record*: unapproved, or approved with an empty time, both fail the `requestedTimeIn && requestedTimeOut` guard at `app.js:1949` → `0`. Locks.
- *`emp_` merged person*: merge only concatenates entry arrays (`2020`), arithmetic is identical. Locks.
- `calcPeriodTotals` (`2041-2046`) **always** emits all three fields, so the "missing `regular`" fixture you added is defensive-only.
- `calculateOvertimeForPeriod`'s threshold can't poison anything: it's `parseInt(...) || 40` at `app.js:5561`, and `Math.round()` coerces regardless.

And the NaN you're defending against is narrower than the commit message says. `Math.max(0, NaN)` → NaN is right, but the *write* paths can't store a bad timestamp: every one goes through `.toISOString()` (`app.js:668, 1274, 2520, 2610, …`), which throws `RangeError` on an Invalid Date rather than storing garbage. Missed-shift times come from `<input type="time">` (`app.js:2667`), so they're `HH:MM` or `''`. NaN is reachable only from legacy or console-edited documents. The guard is still correct insurance — but the rationale overstates its reach.

**The adjacent case the guard does *not* cover:** a bad **clock-in** timestamp sets `clockInTime = NaN`, which is **falsy**, so `else if (e.type === 'clock-out' && clockInTime)` at `app.js:1960` never fires. That day silently totals **0** — finite, passes the new check, locks cleanly, and the person is paid zero for a day they worked. The loud failure (bad clock-out → NaN) is now caught; the quiet one (bad clock-in → 0) isn't, and it's the one that reaches payroll. Same legacy-data reachability, so I'd fix it in the same place rather than urgently — but the commit message's "an entry whose timestamp does not parse" currently claims coverage it doesn't have.

**Q6 — yes, it's accumulating.** `handleLockPeriod` is now ~48 lines doing four jobs: capture the period, validate two reads against three predicates each, mutate two module globals, compute, then dispatch four outcomes. The seam that wants to exist is `async function readLockInputs(period) → {ok, reason, entries, roster}` holding all six guard conditions, leaving the handler as confirm → read → compute → dispatch. The global write is the genuinely misplaced part — it wants to be a two-line `setEmployeeRoster(roster)` that assigns *and* re-renders, which would also fix finding 3 everywhere at once instead of per-branch.

## Firebase invariants

All hold in this diff. `lockPayPeriod` writes `tx.set(ref, {...}, { merge: true })` inside a transaction that refuses an existing key (`firebase-data.js:193-208`) — guarded merge, no blind `setDoc`, and the write is awaited via the returned transaction. No new collection and no rules change is needed: `timeclock_settings` is already covered for managers. No bulk delete or import. One pre-existing nit, not introduced here: `calcPeriodTotals` emits `name: emp.name || ''` (`app.js:2042`), so an empty string reaches the snapshot despite the "strip empty-string fields" invariant — it's a full snapshot rather than a partial update, so it clobbers nothing, but it's the one place the diff's data touches that rule.

**Nothing here corrupts payroll or blocks a legitimate lock.** The refusals all fail closed in the right direction; what's wrong is what happens *after* a refusal — a message naming a UI element that doesn't exist, a period-wide block that won't say whose numbers are bad, and a global that moves without the screen following. Plus one claim in the commit message that isn't true.
