## Findings

**1. BLOCKER — Phase 4 toggle writes: a bare leaf `update()` can create a phantom shift or a bare `futureSchedule`**

Plan: Phase 4 "Writes: one `update()` per toggle with a FieldPath … value `true` or `FieldValue.delete()`". Firestore's `update()` with a nested path creates the intermediate maps. Between the view rendering a row and the click, the override can be removed (editor Remove, time-off Undo, AI day-off) or the future block deleted — the view holds a stale list. Then:
- `overrides.<date>.remind = true` on a date that no longer exists → `overrides[date] = { remind: true }`. `getShiftForDate` returns that object as-is (`js/schedule-helpers.js:276`), so the person now has a "shift" with no start/end on every view, and `selectRemindersDue` would email them for it.
- `futureSchedule.overrides.<date>.remind = true` after the future block was removed → recreates a bare `futureSchedule` with no bounds, which masks the base schedule on every date. This exact hazard is already documented and measured in this repo — `js/firebase-data.js:236-240` is why the AI save became a transaction.
- The null-parent case (date became a Day Off) needs a probe; I left one at `scratchpad/leaf-update-probe.js` (couldn't run it — the emulator command needs approval in this session).

Change: toggles go through a transaction modelled on `applyScheduleEditsTransaction` (`js/firebase-data.js:248`): read → route the date with `isInFutureWindow` on the document *as it is now* → require the value at that path to be a non-null plain map with `start` and `end` → then `tx.update` the leaf, stamping `updatedAt/updatedBy` like the AI save does. Anything else refuses and re-renders the row ("this shift changed — reload"). Bulk = one transaction per document. Add this as the failing-first emulator test in Phase 1/4, both maps.

**2. BLOCKER — Phase 5 dedupe: log-after-send does not survive a duplicate invocation, and the stated failure direction is wrong**

Plan: "The log is written AFTER a successful send; a failed log write … the person may get a second email tomorrow … that is the safe failure direction." Two problems:
- Tomorrow's run computes `reminderDateFor` = today+3's shift, so it never looks at today's date again — the plan's own Phase 5 BDD says so ("tomorrow does not retry — the date will have passed"). Nothing sends twice tomorrow; nothing sends at all if today failed.
- The only real duplicate exposure is *same-day*: two invocations for the same hour. Netlify has a "Run now" button on scheduled functions (a manual invocation at any time), and a run cut off at the 30 s scheduled-function limit (confirmed in Netlify's docs) may be re-run. Two runs that both read "no log", both send, is exactly the "email blasting" outcome. With log-after-send the read-then-send window is the whole run.

Change: claim before send, atomically. In a transaction: `get` the log doc → if it exists, skip (`already-sent`/`claimed`) → else `set { uid, date, to, claimedAt, sentAt: null }`. Then send. Then `update { sentAt }` (on failure `update { error, attempts }`). Rules: bot `update` allowed only while `resource.data.sentAt == null` and only on keys `sentAt, error, attempts, lastAttemptAt` (`diff().affectedKeys().hasOnly`). Bounded retry on later hourly ticks: `sentAt == null && attempts < 3 && claimedAt older than 10 min`. The view shows three states: claimed-unconfirmed, sent ✓, failed ✗. A crash between claim and send costs at most one late/missed reminder, never a blast; a crash between send and mark costs at most one duplicate, bounded by `attempts`. BDD to add: two concurrent runs → one email; a run killed after the send → next tick does not re-send past the attempt cap.

**3. SHOULD-FIX (high) — `hour == 9` plus an exact today+2 window means a missed run is unrecoverable, and the sub-coverage promise is false**

- A missed 15:00/16:00 UTC tick (deploy in progress, Netlify hiccup, timeout mid-run) sends nothing that day, and by finding 2 nothing tomorrow either. With claim-based dedupe the gate can be `Denver hour >= 9` at no duplicate cost: every hourly tick from 9 AM onward sends whatever is due and unclaimed. This is also what makes "Run now" useful for the first production check.
- Widen the selection to dates in `[today+1, today+2]` (dedupe makes it free). Today's failure then becomes a 1-day-before reminder tomorrow instead of silence.
- Sub coverage defaults ON and Phase 3 adds "You'll get a reminder two days before" to the sub's confirmation email — but subs are routinely confirmed within a day or two of the shift, when today+2 has already passed. Under the plan that sentence is a lie for the most common case. Either make it conditional on `date >= today+2` (or `>= today+1` with the window), or drop it.
- The Reminders view's "sends `<date>` 9 AM" must compute from the same rule and say "too late — no reminder" when the send day has passed, instead of promising a send the job will never make.
- Also a time guard: stop starting new sends at ~20 s elapsed; the rest are picked up next tick.

**4. SHOULD-FIX — a denied bot read must not read as "nothing due"**

The bot's queries are the only reads in this system that no test exercises under the real rules: Ticker's emulator tests use `firebase-admin` (bypasses rules), and `rules.test.js` tests rules, not the adapters. A rules regression or a wrong uid in Phase 0 → `getDocs` throws or returns nothing → "0 sent" → silent. That is the `loadConfig()`-fallback pattern CLAUDE.md warns about, in a job nobody watches.
Change: every adapter returns `{ ok, … }` like `loadScheduleResult` (`js/firebase-data.js:190`); any `ok:false` aborts the run with a visible error (and the preview reports it distinctly). In `rules.test.js`, run the exact query shapes as the bot uid: `getDocs(collection('timeclock_schedules'))`, `getDoc(users/<x>)`, `getDoc(timeclock_settings/employees)`, and the log get → set → update sequence. BDD: "Given the schedules read is denied, Then the run reports `read-failed`, sends nothing, writes nothing, and the function log is an error, not `0 due`."

**5. SHOULD-FIX — Phase 2 rule shape and test gaps**

- `allow read: if isManagerOrAbove() || isReminderBot();` breaks the file's own convention: every `isKiosk()` allow in `firestore.rules` is its own statement, and a `getUserData()`-dependent helper is never OR'd with a pinned-uid helper (the bot has no `users` doc, so `isManagerOrAbove()` errors for it). Whether `||` absorbs that error or not, the Phase 2 test list has **no "bot reads the log" case**, so a deny would ship unseen and surface as the dedupe silently failing. Write it as two `allow read` lines and add the test.
- Tighten create: `keys().hasOnly([...])`, `uid is string`, `date.matches('^\\d{4}-\\d{2}-\\d{2}$')`, `claimedAt == request.time`, `sentAt == null` on create. Add negative tests: bot denied on `timeclock_entries`, `timeclock_hfwa`, `timeclock_timeoff`, `timeclock_overrides`, `timeclock_streaks`, any other `timeclock_settings` doc; kiosk denied on the log. "Anonymous cannot do anything" is there; "hasAppAccess staff cannot create/update/delete a log" should be explicit.

**6. SHOULD-FIX — the bot is over-privileged on `users`, and the blast-radius line understates what it can read**

`users` docs carry `pushSubscription` (Web Push endpoint + keys, `js/push-notifications.js:93`), role, email; `timeclock_settings/employees` entries carry plaintext kiosk PINs (`js/app.js:5806-5812`). The plan says "read staff schedules/emails". Change: for the bot use `allow get` on `users` (not `read`), and have the adapter `getDoc` only the uids it is about to email (plus the roster `claimedBy` fallback `resolveReminderRecipient` needs) — it never needs the list. The roster read is unavoidable; say plainly in the checklist that the credential reads every PIN and every push key, so a leak means rotating the password and treating PINs as exposed.

**7. SHOULD-FIX — the flag is silently dropped by two paths the plan calls "handled"**

- AI tool, box unticked (the default): `applyScheduleEdits` emits leaf **replacement** (`js/schedule-helpers.js:373-377`). An AI edit that changes the time of a flagged shift replaces the whole map and unflags it — while the editor path (pre-filled checkbox) preserves it. Decide, and I'd carry it forward: `remind = opts.remind || (existing value is a map && existing.remind === true)`, so a manager's tick survives a time change from any tool. BDD: "Given a flagged Oct 17, When the AI tool changes its time with the box unticked, Then it is still flagged."
- "The reversal compare IGNORES `remind`" must live in `sameOverride` (`js/timeoff-schedule.js:259`), the one compare both the sub path and the **partial-day** path use — otherwise a manager flagging a reduced partial-day shift makes `stillHoldsWhatWeWrote` treat it as a hand edit and the withdrawal leaves them on reduced hours. Name that scenario in Phase 1's BDD.

**8. SHOULD-FIX — selection and identity gaps in `selectRemindersDue`**

- Roster `active` is never consulted; an archived person with a stale flagged date gets emailed. Use `partitionSchedulesByRosterActive` and skip `archived`.
- Log key: the plan says `{uid}_{date}` but the schedule doc id can be an `emp_` id (`resolveScheduleTarget`, `js/schedule-helpers.js:593`). Pin it: the key is the **schedule document id**, and the view looks it up the same way, or "sent ✓" never appears for those people. BDD with an `emp_`-keyed doc.
- A person with both an `emp_` doc and a uid doc (the migrateSchedule-failure case `reverseUnderEitherId` exists for) resolves to the same email twice → two reminders. Dedupe by recipient email + date within a run.

**9. SHOULD-FIX — Netlify function mechanics that will bite on the first deploy**

- Use `firebase/firestore/lite` (REST, supports `runTransaction`/`getDocs`/`setDoc`/`updateDoc`) instead of `firebase/firestore`. The full SDK holds a WebChannel open, which keeps the Lambda alive to the 30 s limit after the work is done and reports every run as a timeout; if you keep the full SDK, `terminate()` + `deleteApp()` in `finally`.
- Preview endpoint: if `REMINDER_PREVIEW_SECRET` is unset, `undefined == undefined` is **true** — fail closed when the env var is missing, and compare with `crypto.timingSafeEqual`.
- `js/firebase-config.js` is a browser global, not a module; the function needs its own copy of the (public) web config.
- `Intl` hour: use `hourCycle: 'h23'` and `formatToParts` — `hour12: false` yields "24" at midnight on some ICU builds. Add a spring-forward case beside the fall-back one.
- Scheduled functions only run on the published deploy (docs); the first-run plan is right to go through preview, but "Run now" + the `>= 9` gate is the cleaner first real send.

**10. NIT — statements that contradict the code**

- Phase 0: "auth-guard already refuses accounts without a users doc" — it does the opposite: `js/auth-guard.js:67-69` **creates** one with `appAccess: ['timeclock']`. What refuses it is the `users` self-create rule (`appAccess` must be absent/empty, `firestore.rules:106-110`). State the real mechanism; note another app's guard writing an empty `appAccess` would succeed (harmless: role staff, no access, but then `isActiveUser()` is true for the bot).
- Research/Phase 3: the Summer importer does **not** replace the future block — `schedule-import.html:270-272` is `set({ futureSchedule }, { merge: true })`, so flags on unchanged dates survive a re-import (a date re-imported as `null` loses it). Conclusion stands; justification doesn't.
- Phase 2 "in this same commit": `firestore.rules` and Ticker's CLAUDE.md/AGENTS.md are different repos — "same phase".
- `buildSubScheduleOverride` emitting `remind: true` changes the shape pinned by `schedule-helpers.test.js`, `timeoff-schedule.test.js` and the sub-confirm emulator suite; budget for updating them, and for `sameStructure` in `partitionRollback` seeing a pre-/post-deploy shape mismatch during the deploy window (harmless — it leaves and names).
- `handleSaveSchedule`'s destructive-save confirm counts `note` sentinels (`js/app.js:3457-3460`); a `remind` sentinel is correctly not "destructive" but the comment "what will ACTUALLY be deleted" should say so.

**11. NIT — open-question answers**

- Hourly cron: yes, and with finding 3 it stops being a cost and becomes the recovery mechanism.
- Re-send on time change: no; the log's `shift` snapshot lets the view say "sent — shift changed since".
- Past dates in the view: 7 days of "sent ✓ / failed ✗" is the only audit trail a manager will ever have; cheap.
- "hidden": keep it. It is not theoretical — sub coverage is always written to **base** `overrides` (`js/app.js:7353`) regardless of the sub's future window, so a sub on a temporary schedule is the realistic hidden case, and with subs defaulting ON it will happen.

## Checked and found sound

- `remind` flows through `getShiftForDate` for overrides only; recurring days return a spread copy without it (`js/schedule-helpers.js:269,282`).
- `normaliseShift`/`sameShift` ignore it, so a flag flip alone is not a change email — both editor and AI paths (`js/app.js:3527`, `5278`).
- `buildOverridesWrite` generalisation to `['note','remind']` is the right shape; untouched overrides pass the stored object through unchanged, and a Day-Off ← → shift transition replaces the whole value, so no stale flag survives either way. Works one level deeper in future mode via set-merge.
- Time-off apply/reverse round-trips the flag: `applyTimeOffOverrides` captures `previousOverride` as-is and `withStaleKeysDeleted` deletes the surplus key on both the write and the restore (modern path). The legacy-predicate note is correct but will almost never fire (legacy records predate the flag).
- `editOverride`/`handleAddOverride`/`clearOverrideForm` are the right three touch points; `_type` handling is the precedent to copy.
- Rules for the log: staff cannot read or write it; `isManagerOrAbove()` read is correct; pinning by uid only (no email clause) is right for an email/password account.
- Denver-hour gate vs DST: transitions are at 2 AM, so 9 AM Denver is never ambiguous; the fall-back BDD date is correct.
- Manager toggles in the Reminders view are permitted by the existing `timeclock_schedules` rule; a concurrent toggle makes the editor's whole-future-delete signature check refuse (safe direction, not a bug).
- The `emp_`/`claimedBy` fallback in `resolveReminderRecipient` matches the plan's description; the roster's `claimedBy` being staff-writable is a pre-existing exposure shared with the change email, not new here.
