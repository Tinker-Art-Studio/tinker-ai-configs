## Implementation review — `686ea3b` (Phase 4 + the Phase 3 review applied)

**Caveats.** This session could not run `npm test` or `jest` (every execution needed an approval that a non-interactive session can't grant), and `studio-hub/firestore.rules` is outside the readable paths. So "786 pass" is your claim, and the log-read rule is checked against the Phase 2 text in the plan's Decisions log, not the live file. Everything else below was verified by reading the code paths end to end.

**No blockers.** Five should-fixes; the rest are nits. The transaction/guard core (a) is sound.

---

### Findings

#### Should-fix 1 — "archived" means two different things to the view and to the job (b)
`js/schedule-helpers.js:554-556`, `js/app.js:3090`, plan Phase 4 vs Phase 5

**Input:** roster entry `{ id: 'emp_kay', claimedBy: 'kay', active: false }`; `users/kay` has `email` and `active: true` (or no `active` at all); Kay's Oct 17 override flagged with `remindUid: 'kay'`.
**Output:** the view says **"archived — the job skips them. Untick to clear."** The job (Phase 5, least-privilege decision (6)) never reads the roster; its rule is "skip archived if `users.active === false`". So on Oct 15 it lists every `timeclock_schedules` doc (archived ones included), `get users/kay`, sees an active account with an email, and **sends**. The manager who trusted the status left the flag on. The plan is internally inconsistent here (Phase 4 says "roster inactive — the job skips"; Phase 5 says users.active); the view implemented Phase 4's wording.
**Change:** split the code: `archived` only when `c.user && c.user.active === false` (what the job can see); roster-only inactive becomes `archived-roster` with text "archived in the roster — the job cannot see the roster and WILL still email this account; untick to be sure" (or auto-include such rows in "Clear all shown"'s nudge). Fix the Phase 4 line in the plan to match. If Studio Hub's archive flow flips both flags together this rarely bites — I couldn't read studio-hub to confirm — but the view must not promise a skip the job doesn't perform.

#### Should-fix 2 — after the day's last tick, the view still says "sends today" (b)
`js/schedule-helpers.js:558-561` vs `:432-440` (`reminderPromiseDates` already knows this)

**Input:** Denver Oct 16 at 23:20; a manager ticks Kay's Oct 17 shift. `ctx.denverToday = '2026-10-16'`, `twoBefore = '2026-10-15'` → `{ code: 'sends', on: '2026-10-16' }` → **"sends Fri, Oct 16 from 9 AM"**.
**Output:** the 23:00 tick already ran; the next is 00:00 Oct 17, whose window is [Oct 18, Oct 19]. Nothing ever sends. The sub-promise helper handles exactly this (`hour >= 23 ? 2 : 1`), the status helper doesn't take the hour.
**Change:** pass `denverNow()` (date + hour) in `ctx`; `const lastReachable = addCalendarDays(today, hour >= 23 ? 1 : 0); if (row.date <= lastReachable) return { code: 'too-late' }`. While there: when `on === today` and `hour >= SEND_FROM_HOUR`, say "sends within the hour" instead of "from 9 AM" (it's 2 PM and the text reads as already-missed). `remindersState.today` should carry the hour too so `reminderRowToggleable` agrees.

#### Should-fix 3 — `reassignSchedule` carries the OLD account's `remindUid` onto the new person's document
`js/app.js:3928-3941` (the sibling of the `migrateSchedule` copy this commit fixed, `js/firebase-data.js:463-464`)

**Input:** an "Unknown" doc `abc` (a departed account) holds `overrides['2026-10-17'] = { …, remind: true, remindUid: 'abc' }`; admin reassigns it to Kayleigh (`kay`).
**Output:** `timeclock_schedules/kay.overrides['2026-10-17'].remindUid === 'abc'`. The view resolves `user = allUsers.find(u => u.uid === 'abc')` → **"sends Oct 15 … To abc@…"**; the job would `get users/abc` and email the wrong person (or "no email" if that doc is gone). Not created by this commit, but this commit is the one that made `remindUid` load-bearing and touched the other whole-document copy.
**Change:** give `stampReminderUids` a `replace` option (or add `restampReminderUids(data, uid)`) that overwrites every flagged override's `remindUid` in both maps, and call it in `reassignSchedule` with `resolveReminderUid(newUid, allUsers, employeeRoster) || null` — deleting the key when nothing resolves, so the row says "no linked account" and "Remind all shown" re-links it. Unit test like the existing `stampReminderUids` block.

#### Should-fix 4 — "no linked account" for a uid-keyed document disagrees with Phase 5's `users/{remindUid || docId}` (b, f)
`js/schedule-helpers.js:553`, plan Phase 5 bullet 3

**Input:** doc `kay` (an auth uid) with `overrides['2026-10-17'] = { …, remind: true }` and no `remindUid` (a writer whose users AND roster reads had failed).
**Output:** view: **"no linked account — this person has not claimed an account — no email will be sent"** (false: the doc id *is* the account). Job as planned: `get users/kay` → sends. Benign direction, but the plan says "the view and the job must agree".
**Change:** decide once, in one helper — `reminderRecipientUid(value, docId)` in schedule-helpers — used by `reminderRowStatus`, `selectRemindersDue` and the job. My recommendation: `remindUid` only, no `docId` fallback (the view's bulk re-link already repairs these rows), and delete the `|| docId` from the plan's Phase 5 text.

#### Should-fix 5 (deploy gate, not this commit's code) — sw.js and the function bundle
`sw.js:64` still `tinker-ticker-v19` while index.html / app.js / styles.css changed; `netlify/functions/send-timeoff-confirmation-email.js:14` is the **first** function to `require('../../js/schedule-helpers.js')` (outside `netlify/functions`; `netlify.toml` has no `included_files`). The Phase 3 review's sw.js nit was not applied and the commit doesn't claim it. Before the Phases 3–5 deploy: bump to v20, and run `netlify build` locally to confirm the bundler traces that relative require (the plan's own Phase 5 note) — otherwise the confirmation email endpoint 500s in production while every test passes.

---

#### Nits

- **Audit trail has holes** (`js/schedule-helpers.js:492-535`): rows come only from overrides that still exist, so a sent log for a shift that was later removed, or claimed under a docId that since migrated (`emp_x_2026-10-17` → doc now `kay`), is invisible. The card promises "the last 7 days stay listed as the record of what was sent". Consider appending orphan log docs as rows ("sent ✓ — shift since removed").
- **Stale unresolved claim on a past date** (`:549`): log `{ sentAt: null, attempts: 0 }` for a date now in the past renders "claimed, sending…" forever; the job will never look at that date again. Say "not sent — claim never resolved" when `row.date < today`.
- **Same-date rows in both layers share one log** (`js/app.js:3068`): a base row (hidden) and a future row for the same docId+date both show the future layer's "sent ✓".
- **Live checkbox on rows that can never toggle**: `listReminderRows` admits `2026-02-31` (YMD_RE, not `isRealDate`) and start-less maps (`{ note: 'only' }`); each renders a checkbox whose every click ends in "this shift changed — reload". Mark them non-toggleable in the row (`!shift.start || !shift.end || !isRealDate(date)`).
- **`scheduleSignature` depends on nested key order** (`js/schedule-helpers.js:1090-1100`, now a transaction guard at `js/app.js:6114`): `JSON.stringify` of `[k, obj[k]]` keeps the inner `{start,end,studio}` order. In production both sides are server reads (canonical order), so no misfire — but canonicalise the nested keys so the guard doesn't rest on serialization order. Note the emulator tests compare a JS literal against an emulator read; they pass only because the emulator preserves insertion order, which production Firestore (sorted keys) would not — a difference the test can't see.
- **Bulk confirm count** (`js/app.js:3198-3203`): includes re-link rows (already flagged) and today's rows (will read "too late"). Say "N shifts (M already flagged, re-linked to an account; K are today and will not send)".
- **Copy vs default**: "The last 7 days stay listed" (`index.html:630`) but From defaults to today; the history only appears when From is moved back. Say so, or default From to today−7. Plan asked for a collapsible section; it's a plain card (fine).
- **AI status over-warns** (`js/app.js:5556`): "No linked account for X" fires on `!remindUid` even when SET mode kept a stored uid on every date (roster + users both failed to load). Rare.
- **`reminderPromiseDates` on a failed sub read** (`js/app.js:7631, 7753`): `loadSchedule` returns null for absent AND failed; a failed read promises through the sub's future window. Pre-existing pattern.
- **`loadAllSchedules` lets a stored `uid` field override `d.id`** (`js/firebase-data.js:211`): the view's `docId` — the log key and the transaction target — follows the stored field. Phase 5's adapter should key by the same thing, or an anomalous doc gets two log keys.

---

### (e) Phase 3 findings — each verified against the code, not the commit message

| Finding | Status | Where |
|---|---|---|
| Codex 1 — CSV merge write resurrects a deleted doc | **Fixed.** Transaction; `entry.existingData && !snap.exists` throws; signature compare refuses a changed block; `tx.set(merge)` only after both. Row failure logged, nothing written. Emulator: deleted-since, changed-since (weekday), changed-since (flag on override), brand-new creation. | `js/app.js:6109-6118`, `future-schedule-write.emulator.test.js` |
| Codex 2 — endpoint trusts `reminderDates` | **Fixed.** `reachableReminderDates(claimed, shiftsWritten, cutoff)`: intersected with written dates, server Denver cutoff, dedup/sort/cap 120; template intersects again with `null` cutoff. Tests: unrelated, same-day, mixed, duplicates, non-array. | `send-timeoff-confirmation-email.js:40`, `_lib/timeoff-confirmation.js:51-63` |
| Codex 3 — rejected dates counted as "set" | **Fixed** via `rejectedDates` filter. Codex's "return accepted dates from `applyScheduleEdits`" not taken; behaviour still pinned only by a source regex. | `js/app.js:5554-5555` |
| Claude SF1 — "kept" overrides outside the new range | **Fixed.** `countFutureOverridesOutside`; both the row note and the confirm say how many; emulator asserts inside resolves / outside doesn't via `getShiftForDate`. | `js/app.js:6002, 6076-6078` |
| Claude SF2 — sub promise / editor layer routing | **Minimal fix applied as proposed.** `reminderPromiseDates` (flag ∧ reachable incl. 23:xx ∧ base map read); `renderOverridesList` "(not shown — inside/outside…)" uses `isInFutureWindow` on the original doc vs `_editingFutureSchedule` — correct even for a bounds-only block the editor treats as inactive. Per-date routing of editor/sub writes remains the acknowledged follow-up. | `js/schedule-helpers.js:432-440`, `js/app.js:3335-3338` |
| Claude SF3 — AI status silent on no account | **Fixed** (`noAccount`). | `js/app.js:5556, 5590` |
| Nits: count over-count · 23:xx promise · "Reminders below" text · null-safe checkbox read · Daily bell · vanished-doc write · replace-onto-date uid · importer headers | All applied and correct. Daily's `s = { …shift }` carries `remind`; `uidOf(editingOverrides[dateStr])` is the same person's map. | as cited in the diff |
| Nit: **sw.js bump** | **Not applied** (see should-fix 5). | `sw.js:64` |

No regressions found in the touched paths. The one deliberate behaviour change: a weekday added by someone else after the dry run now **refuses the row** instead of surviving beside the write (test rewritten to match) — correct per the review.

### (f) What Phase 5 needs from this and doesn't yet have

1. **One recipient rule** (should-fix 4) and **one archived rule** (should-fix 1) — both currently live only inside `reminderRowStatus`.
2. **The log shape the view expects** is exactly the plan's: it reads `sentAt` (truthy → sent; Timestamp or string both render), `to`, `shift` (normalised `{start,end,studio,note}` — `note` must be `''` not absent, as the rules' typed shape already requires), `attempts` (int), `error` (any truthy string → "failed"), `lastAttemptAt ?? claimedAt`, and queries `date` (shift date) as a string. `markSent` deleting a stale `error` is nice-to-have; the view checks `sentAt` first anyway.
3. **`attempts` semantics**: the view says exhausted at `attempts >= REMINDER_MAX_ATTEMPTS`; the job must skip with the same `>=` on the same constant, whether it bumps at re-claim or at markFailed.
4. **A claim-staleness constant** (the plan's 10 min) isn't exported; put it in schedule-helpers so the view can later say "stale claim — retries at the next tick".
5. **Cross-migration dedupe**: the log key is the docId; a reminder sent under `emp_x_…` followed by a `reassignSchedule` to `uid` would be sent again under `uid_…`. Rare (needs a prior failed migration); the job could also check the log under `migratedFrom`/`migratedFromChain` ids.
6. **Within-run dedupe by `(remindUid, date)`** means the second document of a person with both an `emp_` and a uid doc is never claimed — its row shows "sends …" until it flips to "too late". The view could look the log up under any docId sharing the `remindUid`.

---

### Checked and found sound

- **(a) The toggle can't write where the resolver doesn't read, and can't create a phantom or a bare map.** `planReminderToggles` (`js/schedule-helpers.js:575-604`) runs on `tx.get`'s version; routes by `isInFutureWindow` on *that* document; requires `t.layer` to equal the route (a future block appearing/disappearing/shrinking under a shown row → `'moved'`); requires a non-array object with truthy `start` and `end` *present* at that path (`hasOwnProperty`) — removed, day-off, junk → `'changed'`; emits only `…remind` / `…remindUid` leaf FieldPaths, so the intermediate map is one the transaction just proved exists; no write at all when nothing changes (no stamp). Transaction optimistic concurrency covers the read→write gap. Missing document → `{ ok:false, reason:'missing' }`, never created. `remind` is only ever `true` or `DEL`; `remindUid` only a non-empty string or `DEL`. No `set(` anywhere in the view path (wiring test pins it).
- **Hidden rule = the job's rule.** `(layer === 'future') !== isInFutureWindow(...)` is the same predicate `activeOverridesFor`/`getShiftForDate` use, including the bounds-less-block case (open window → base hidden), and recurring days never appear.
- **Status precedence** matches the BDDs: log wins over hidden/too-late/unflagged (unticked-after-sent stays "sent ✓"); `changed` via `sameShift` on normalised shapes; `sends on = max(S−2, today)` is exactly the first day whose `reminderWindow` contains S; `date <= today` → too-late (modulo should-fix 2).
- **(c) Bulk.** Grouped per docId, one transaction each, sequential; partial failure isolates the document (`failed` named, others proceed); skipped rows named with person + date + reason; count confirmed before, results toasted after, fresh `loadSchedulesData` + `loadRemindersView` after every outcome; re-link of no-uid rows only adds `remindUid`; `busy` guards re-entry and re-renders boxes disabled. A bulk toggle of an already-flagged row with a *different* stored uid is never issued (filter), so nothing silently re-points a flag.
- **(d) The vm test does exercise the production function**: `firebase-data.js` source is evaluated verbatim; `_db`, `firebase.firestore.FieldValue/FieldPath`, `getAuthUser` and the real planner are the only injections; the Admin SDK's `runTransaction`/`tx.get`/`tx.update(ref, FieldPath, value, …)`/`FieldValue.delete()` is the same surface the compat SDK exposes (and `applyScheduleEditsTransaction` has used that exact varargs shape in production since Sep 17). What it can't see: security rules (Admin bypasses — the manager's `timeclock_schedules` write and the log list are pre-existing/plan-text grants), offline transactions (caught → "Could not save"), and the future-layer untick (planner test covers it).
- **`loadReminderLogResult`**: `where('date', '>=', fromDate)` is a single-field range → automatic index, no composite needed; under `allow read: if isManagerOrAbove()` (Phase 2 text) a list is permitted; a failed read is `{ ok:false }` and the view says so rather than showing everything unsent; log id = `${docId}_${date}` = the rules' `logId == uid + '_' + date`.
- **`stampReminderUids`** is pure, touches only flagged overrides in the two override maps that lack a non-empty `remindUid`, never `recurring`, never the rest of the document; all three `migrateSchedule` callers pass the claimed auth uid. Nothing it shouldn't change is changed.
- **No new collection; no rules change needed.** Agreed — the view only reads the log and writes `timeclock_schedules` leaves under the existing manager grant.
- No top-level name introduced in `schedule-helpers.js` collides with any other classic script; script order loads helpers before `app.js`; every new CSS variable exists; `escapeHtml`'d attributes hold only `emp_`-slug or auth-uid doc ids.
