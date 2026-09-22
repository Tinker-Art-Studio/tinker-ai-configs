## Findings

### Blocker — a denied user read can still allow other reminders to send

[shift-reminder.js:139](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:139), [shift-reminder.test.js:157](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.test.js:157)

Concrete input: two due reminders are processed with the production concurrency of 4. `getUser('a')` succeeds after 20 ms; `getUser('b')` immediately returns `{ok:false, error:'permission-denied'}`.

Wrong output: worker B sets `aborted`, but worker A is already inside `processOne()` and never checks it again. A proceeds through `claim → send → markSent`. The run returns `aborted:'read-failed'` after sending and writing, contrary to the plan’s “a denied read aborts the run; sends nothing, writes nothing.”

The existing test hides this by forcing `concurrency: 1`.

Exact change: split the run into two stages:

1. Resolve/cache every distinct `remindUid` with bounded concurrency.
2. If any read returns `ok:false`, return `read-failed` before any claim.
3. Only then start concurrent claim/send work using the cached users.

Add a concurrency-4 test with delayed successful reads plus one denied read and assert zero `claim`, `send`, `markSent`, and `markFailed` calls.

### Blocker — stored `uid` data can redirect toggles and claims to a different document

[firebase-data.js:207](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:207), [app.js:3187](/Users/christiehubley/tinker-timeclock/js/app.js:3187), [shift-reminder-firestore.js:64](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder-firestore.js:64)

Concrete input:

```js
timeclock_schedules/alice = {
  uid: "bob",
  overrides: {
    "2026-10-17": { start: "10:00", end: "14:00" }
  }
}
```

and a real `timeclock_schedules/bob` document also exists.

Wrong output: both loaders construct `{uid: d.id, ...d.data()}`, so stored `"bob"` overwrites path identity `"alice"`. The view renders Alice’s override with `docId:"bob"`; clicking its checkbox starts a transaction against `/timeclock_schedules/bob`, not the document whose row was displayed. The job likewise claims/logs Alice’s shift under `bob_2026-10-17`.

This violates the explicit invariant that the transaction operates on the document as read. Mirroring the bug in the view and job does not make it safe.

Exact change: make path identity authoritative everywhere:

```js
{ ...d.data(), uid: d.id }
{ ...doc.data(), uid }
```

Apply this to `loadAllSchedules`, `loadScheduleResult`, the job adapter, and preferably equivalent users-document readers. Add an emulator test with a mismatched stored `uid` proving the toggle updates the path document only and the job uses the path ID.

### Should-fix — 23:xx status still disagrees with the hourly job for shifts two days away

[schedule-helpers.js:632](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:632)

Concrete input: Denver Oct 15 at 23:20, with a flagged Oct 17 shift.

Wrong output: `twoBefore` is Oct 15, so the view returns `on: Oct 15, soon:true` and displays “sends within the hour.” The 23:00 tick already ran. The next eligible tick is 9 AM Oct 16, when Oct 17 is one day away.

The applied review fixed “tomorrow is too late at 23:xx,” but its new test incorrectly enshrines this two-days-out result.

Exact change: base both reachability and display date on the next possible run date:

```js
const nextRunDate = hour >= 23 ? addCalendarDays(today, 1) : today;
if (row.date <= nextRunDate) return { code: 'too-late' };
const on = twoBefore > nextRunDate ? twoBefore : nextRunDate;
```

`soon` should only be true when `on === today`, `hour >= 9`, and `hour < 23`. Add cases for tomorrow, +2 days, and +3 days at 22:xx and 23:xx.

### Should-fix — a changed shift can be flagged from a stale row

[schedule-helpers.js:650](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:650), [app.js:3180](/Users/christiehubley/tinker-timeclock/js/app.js:3180)

Concrete input: the table shows Oct 17 as `10:00–14:00, SDOC`. Another manager changes the same override to `18:00–21:00, Staff Meeting`, without moving its layer. The first manager clicks the stale SDOC row.

Wrong output: the transaction only verifies that the current value remains an object with truthy `start` and `end`; it flags the new staff meeting. The manager’s action silently applies to a materially different shift.

The guard correctly handles removal, day off, and layer movement, but it is only a shape guard—not a stale-row guard.

Exact change: include the displayed normalized shift in every toggle, then inside the transaction require `sameShift(currentValue, toggle.expectedShift)`. Ignore reminder metadata in that comparison. Otherwise skip as `changed`. Add individual and 6-of-8 bulk tests where start/end/note changed after render.

### Should-fix — the Phase 3 server-side promise fix remains incomplete at 23:xx

[send-timeoff-confirmation-email.js:39](/Users/christiehubley/tinker-timeclock/netlify/functions/send-timeoff-confirmation-email.js:39)

Concrete input: at Denver Oct 16 23:20, a caller submits `reminderDates:['2026-10-17']` and a matching `shiftsWritten` entry.

Wrong output: the endpoint’s cutoff is always Denver today + 1, so it accepts Oct 17 and emails that the sub will receive a reminder. No remaining job tick can send it. The browser helper rejects this case, but the Codex Phase 3 finding specifically required the endpoint not to trust the client.

Exact change:

```js
const now = denverNow();
const cutoff = addCalendarDays(now.date, now.hour >= 23 ? 2 : 1);
```

Pass that cutoff to `reachableReminderDates`, and add an endpoint-level 23:xx test. This is a partial—not complete—fix of the Phase 3 review finding.

## Checked and found sound

- The normal toggle path uses one Firestore transaction per schedule document, reads before writing, refuses a missing document, routes using the current future window, rejects missing/day-off/incomplete values, and emits only leaf `FieldPath` updates. No `set()` or map write occurs in this path.
- `remind` is written only as `true` or deleted; `remindUid` is a non-empty string or deleted. Unchanged documents are not timestamp-stamped.
- Bulk actions use exactly the filtered, toggleable rows; group by schedule document; isolate transaction failures per person; report stale dates and failed people; reload afterward; and re-link already-flagged/no-account rows when an account now resolves.
- The VM emulator test evaluates the real `firebase-data.js` function and uses the real planner. It meaningfully verifies Firestore leaf-write/delete behavior. It does not exercise security rules, browser compat loading, authoritative document identity, changed shift contents, or the concurrency failure above.
- `where('date', '>=', fromDate)` is allowed by the live unconditional manager read rule at [firestore.rules:446](/Users/christiehubley/studio-hub/firestore.rules:446) and uses a normal single-field index; no composite index is needed.
- Phase 4 introduces no additional collection. The log collection and its rules already exist, so no Phase 4 rules change is needed.
- `stampReminderUids` only copies flagged overrides lacking a UID in the two override maps. It does not touch recurring schedules, unflagged overrides, or unrelated document fields.
- Claude’s archived-account split, recipient-only rule, reassignment restamping, orphan audit rows, invalid-row disabling, nested signature canonicalization, bulk confirmation detail, stale/unresolved claim display, service-worker bump, and bundle inclusion are present.
- The other Phase 3 findings are applied: deleted/changed CSV targets are refused transactionally; rejected AI dates are excluded from the count; unreachable retained overrides are disclosed; hidden sub reminders are not promised; and missing-account AI results are reported.
- The job writes the log shape the view expects: `uid`, `date`, `to`, normalized four-field `shift`, `claimedAt`, nullable `sentAt`, integer `attempts`, and optional `lastAttemptAt`/`error`. Retry and stale-claim constants are shared.

I could not verify the claimed 843 passing tests. `npm test` failed because the sandbox cannot bind the emulator ports (`EPERM` on 4400/4500/8080/9150). Direct Jest also failed because this read-only sandbox prevents creation of Jest’s haste-map cache. No files were edited.
