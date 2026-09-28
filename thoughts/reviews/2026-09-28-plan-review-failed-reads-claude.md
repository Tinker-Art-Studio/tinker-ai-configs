Verified against source; no files changed.

## 2. The `getLockedPeriods` claim — correct, but the more likely destructive path is not the one you named

Every link holds:

| Link | Verified at |
|---|---|
| failed read → `{}` | `js/firebase-data.js:176-180` (and `:173` when `!_ready`) |
| `isLocked` false | `js/app.js:2056` |
| Lock button re-enabled on a locked period | `js/app.js:2068` (the `else` branch) |
| `set(…, {merge:true})` overwrites the record | `js/firebase-data.js:145-151` ← `js/app.js:2818` |

Two refinements, both of which make it worse:

**The merge semantics are already measured in this repo.** `empty-map-guard.emulator.test.js:5` and its test at `:69`: merge recursively unions nested maps, *except* that an explicitly-written empty map **replaces** the target. So `lockedAt` / `lockedBy` are leaf overwrites (destroyed, as you say), but `employeeTotals` behaves two different ways — a non-empty one is deep-merged, so uids present now overwrite and uids **absent survive with stale values**: a hybrid snapshot that is internally inconsistent and looks entirely plausible. An empty one erases the stored snapshot outright. And `lockPayPeriod` writes `employeeTotals: employeeTotals || {}` raw — `omitEmptyMaps` (`schedule-helpers.js:1121`), this repo's own guard for precisely this hazard, is applied to schedule writes (`app.js:3865`) and not to the payroll snapshot.

**`handleLockPeriod` does its own second read, and a failure there needs no lock-read failure at all.** `app.js:2816` calls `calcPeriodTotals(allEntries, employeeRoster)`, and `calcPeriodTotals` returns `{}` for an empty `allEntries` (`app.js:2011-2031`). The entries read at `2815` is *separate* from the one that drew the screen at `2073`. So:

- **Path A (not in the plan):** read #1 succeeds, the manager sees real hours, read #2 fails → `employeeTotals = {}` → `lockPayPeriod` writes an empty map, returns **`true`**, the UI re-renders as "Locked". What you see is not what you lock.
- **Path B (the plan's):** re-lock after a failed lock read destroys the record — and if the entries read also failed, `{}` triggers the measured empty-map exception and erases `employeeTotals` completely.

Path A is the more reachable of the two: Path B needs read-fail-plus-write-succeed on the *same* document (`timeclock_settings/lockedPeriods`), while Path A needs a failure on `timeclock_entries` — a range query with a double `orderBy`, i.e. exactly the missing-index shape that caused the HFWA bug — with an unrelated settings write staying healthy.

**One more mechanism, unlisted:** `lockedPeriods` (`app.js:1866`) is a shared global assigned unconditionally in two places — `loadRecentEntries:1074` (staff) and `renderAdminTimesheets:2055`. A failed read *after* a good one replaces a correct value with `{}`, so a manager who opens Timesheets (good) then My Hours (failed) has `isDateInLockedPeriod` default-open for the rest of the session. That fix belongs at the assignment — keep last known, mark stale — not only at the render site.

## 1. The inventory — contents right, scope wrong

I derived the same 11 functions independently, with the same tiers. The gaps are all at the edges:

1. **`getAllTodayEntries` has no callers.** The only hits anywhere are its own definition and a `.claude/worktrees` copy. Its row's "What the manager sees" is wrong: "No one is clocked in" is `app.js:1350`, in `renderAdminDashboard`, fed by `listenTodayEntries` (`app.js:391`). Delete the function; drop the row.
2. **`listenTodayEntries` is missing and belongs.** `firebase-data.js:92-94` — the `onSnapshot` error handler only logs; the callback is never told. `!_ready` returns a no-op unsubscribe and never calls back at all. Its failure mode is *stale or never-rendered* rather than empty, so Who's Working and the clocked-in list silently freeze. Same family, different shape — it needs an error *callback*, not an `{ok}` return.
3. **`!_ready` is a second entry into all 11**, before the `try` (e.g. `:173`). If `initAppFirestore` fails (`:20-23`) the entire app reads as empty with no error surfaced anywhere. Conversions must cover that branch; the existing Result functions already get this right (`:191`, `:315`, `:342`).
4. **The scope boundary is real and should be stated.** ~40 direct `getDb()` accesses live in `app.js`. Three swallow silently — `2080` (all streaks, inside `renderAdminTimesheets`), `8330`, `10292` — and two warn-and-continue so dashboard alerts silently under-report (`4924`, `4934`), including a *second* `appConfig` read at `4920` that converting `loadSettings` will not touch.
5. **The 9 "already correct" functions are correct in the data layer only.** `loadSchedulesData:2856` calls `loadEmployeeRoster()`, not `loadEmployeeRosterResult()`. A failed roster read → `employeeRoster = []` → `calcPeriodTotals:2000-2010` skips the `emp_`→`claimedBy` merge → the locked snapshot splits one person into two rows. That is a **third read feeding `employeeTotals`**, invisible to an inventory organised by function rather than by call site. (Also `partitionSchedulesByRosterActive` fail-opens on an empty roster — `schedule-helpers.js:15-26` — so archived staff reappear. Cosmetic; one line.)
6. **The writes exclusion is right, and it is what hid Path A.** `false` is honest, so keep the rule — but add "a write whose payload comes from a read in this inventory" to scope, because the plan's own headline damage happens at a write. Two inverse-polarity defects also deserve a line each: `findFlaggedTimeOffFor` returns `{ok:false}` for an *empty input list* (`:430`), so "nothing to check" reads as a failed read; `loadStreakData` returns `DEFAULT_STREAK` when there is no `currentUser` (`:826`), conflating not-signed-in with zero.

## 3. Tiering

Tier 1's three are right. Two changes: re-describe `getEntriesByDateRange` as the **write-input** read (Path A), which promotes it from "confusing screen" to "wrong payroll record" and arguably makes it the most urgent of the three; and add `loadEmployeeRoster()`'s call site at `2856`.

Nothing in Tiers 2–3 is clearly misplaced. The closest call is `getTodayEntries` → `updateStatusFromEntries([])` (`app.js:857`) → "Not Clocked In" to someone who is clocked in. A second clock-in is *not* a payroll error — `calculateDayHours:1939` keeps the first and flags `hasConsecutiveClockIn`, rendered as a red row at `2209`. The residual harm is the person who sees "Not Clocked In" and leaves without clocking out: an unpaired clock-in scores 0 hours with only the broken-streak alert as a signal. Tier 2 is defensible; put that reasoning in the plan so it isn't re-litigated.

## 7. `loadSettings` — Tier 1 for a different reason, and one fact decides it

Consumers: `defaultEarlyClockInMinutes` (`452` — a clock-in *permission* gate, not paid hours), `breakAutoEndMinutes` (`746` — the auto-end timer, so it does move recorded times), `extensionAlertThreshold` (`4877`), `timeoffMinNoticeDays`/`timeoffCategories` (`6907`, `7037`), and the one that matters: **`overtimeWeeklyThreshold` / `overtimeMultiplier` in `calculateOvertimeForPeriod:1965-1966`, which feeds `calcPeriodTotals` → the locked `employeeTotals`.** So it is payroll-critical, but via the OT split written into the snapshot, not via "grace rules". Rewrite the row.

The catch cuts the other way: **every consumer already reads `(appSettings && appSettings.X) || <the same default>`**, so a failed read is byte-identical to a successful read of a config holding the defaults. Tier 1 holds *only if* the stored `timeclock_settings/appConfig` actually differs from `DEFAULT_SETTINGS` (`:482-491`) on those three fields. One look in the console decides it — and if they match, Tier 1 shrinks to two, as you suspected.

Unrelated one-liner found nearby: `app.js:452` reads `appSettings.defaultEarlyClockInMinutes` with no null guard, and `appSettings` is null until `135` resolves while listeners are wired at `131` — a narrow TypeError window on a clock-in during load.

## 5. Phase 1's write-path removal — wrong primitive, and there is a strictly better fix

Gating the write on a successful read buys less than it costs. It makes the manager's ability to lock depend on a read that can fail, and it doesn't make the write safe — Path A still writes an empty snapshot with the lock read perfectly healthy.

Make **the write** non-destructive instead: a transaction that reads `lockedPeriods` inside itself and refuses when `periodKey` already exists, returning `already-locked`. Then a failed lock read never blocks a lock (the manager clicks; the transaction either locks or says "already locked by X on Y — unlock first"), and a re-lock can never silently overwrite whatever the read did. Re-locking stays possible because Unlock already exists and its confirm already warns about invalidating payroll (`app.js:2827`). Add the empty-payload guard alongside it — refuse `employeeTotals: {}` unless the manager confirms a genuinely empty period — because that is the only thing that closes Path A.

This is the idiom the repo already uses for exactly this class of race: `updateTimeOffRequestIfStatus`, `confirmTimeOffSub`, `applyScheduleEditsTransaction`, `toggleShiftRemindersTransaction` — all read-inside-transaction with an `expect`. Be honest in the plan that it means Phase 1 *does* change a write path, so it needs the write-shape review and an emulator test. Still no rules change: same collection, same operations.

On the flaky-deadline worry specifically: persistence is on (`firebase-config.js:28-37`), so a `get()` with a cached copy returns cache rather than throwing — the common flaky case doesn't produce `ok:false` at all, it produces *stale*, which is its own quiet lie and worth a sentence. And when a read does fail for network reasons the matching `set()` won't be acknowledged either — but it is still queued locally and lands on reconnect, so "the promise never resolved" is not "nothing was written". Another reason to put the safety in the transaction rather than in a UI gate.

## 6. BDDs — the biggest gap is `handleLockPeriod`'s own read

Missing, in priority order:

1. Given the timesheet rendered real hours but the lock-time entries read fails, when the manager clicks Lock Period, then no lock is written and the failure is reported — never a lock whose `employeeTotals` is `{}`.
2. Given a period already locked with totals for 9 people, when a second lock is attempted, then `lockedAt` / `lockedBy` / `employeeTotals` are unchanged. Assert the stored document, not the UI.
3. The empty-map erasure specifically, as an emulator test shaped like `empty-map-guard.emulator.test.js`.
4. Given the roster read fails, no lock is written (or the snapshot still merges `emp_` entries).
5. Given a good lock read then a failed one, `isDateInLockedPeriod` still reports the known locks.
6. Given `!_ready`, every converted read reports `ok:false` rather than empty.
7. A genuinely-empty period still locks — the negative control, so the guard isn't a blanket refusal.

**On the branch-order point: don't test it with a regex.** Extract the decision into a pure function — `readState({ok, items})` → `'failed' | 'empty' | 'loaded'` — unit-test that, and have every render site call it. Order then cannot be reversed, because there is one branch site instead of eleven. That is the idiom the repo already uses for exactly this kind of three-way status (`reminderRowStatus`, `schedule-helpers.js:641`). Source-level assertions are legitimate here — `schedule-editor-wiring.test.js` explains why `app.js` can't be required — but they are right for *presence* ("it calls the resolver"), not ordering.

For the data-layer half, `firebase-data.failure.test.js` is already the right harness: it boots the real `firebase-data.js` in a vm against a fake Firestore whose operations reject. It currently fakes only `update`/`set`/`delete`; add `get` (~20 lines) and every converted read can be tested behaviourally instead of structurally.

## 4. The shape

`xxxResult()` + thin wrapper is right — it's the settled idiom and it's what makes the "no intermediate state is worse than today" claim true. Two adjustments:

- **A single app-level banner would be worse.** These failures are per-surface and per-person, and a global banner can't disable the Lock button or refuse a save.
- **A shared helper is worth it as the *decider*** (`readState` above) plus one builder for the standard message — not as a generic renderer. Note the precedent is thinner than the plan implies: 9 Result *functions* exist, but only about three render sites distinguish three states today (`app.js:4502-4505` the HFWA card, `3206` the reminder-log warning, `2859-2860` `allUsersLoaded`). "The repo already does this in ~9 places" conflates the two layers — which strengthens the case for the shared decider, since most render sites are being written for the first time.

## 8. What I couldn't verify

I don't have read access to `~/studio-hub/firestore.rules` in this session, which leaves two things open. First, whether a rules shape exists that denies *reading* `timeclock_settings/lockedPeriods` while allowing the *write* — that decides how reachable Path B is outside the offline case. Second, whether the rules enforce the pay-period lock on `timeclock_entries` updates. If they do, the staff-side BDD ("change requests refused") is UX rather than correctness; if they don't, that client-side gate is the only thing between a failed read and an edit to locked payroll data, and it deserves its own line in the plan.

## Recommendation

Tier 1 now, as you proposed, but reshaped: make `lockPayPeriod` a refusing transaction and guard the empty snapshot first — that is the money fix, and unlike a read-gate it doesn't depend on any read succeeding. Then add the roster call site, then convert the three reads. Check the stored `appConfig` against `DEFAULT_SETTINGS` before deciding whether `loadSettings` is in Tier 1 at all.

Want me to write this up as an HTML review doc alongside the plan?
