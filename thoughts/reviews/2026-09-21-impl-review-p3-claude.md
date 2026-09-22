## Implementation review — commit `614e515` (reminders, Phase 3)

**Caveats up front.** This session could not read outside the repo (the plan HTML and the `2026-09-21-impl-review-p1/p2-*.md` files were blocked at the tool level, and non-interactive means no approval prompt), and `npm test` / a direct `jest` run also needed approval I couldn't get. So: the plan rules I checked against are the ones restated in your brief plus the Phase 1/2 commit messages and the review citations already in the code comments; and "tests pass" is the commit's claim (735), not mine. Everything below was verified by reading the code paths, not by running them.

No blockers found. Three should-fixes, all small; the rest are nits.

---

### Findings

#### Should-fix 1 — CSV writer: overrides are "kept" but become unreachable when the new bounds exclude them, and the confirm doesn't say so
`js/app.js:5831-5835` (confirm), `js/app.js:5767-5770` (conflict note), `future-schedule-write.emulator.test.js:143-188`

**Input:** existing `futureSchedule` Jan 5 → Jun 15 2027 with flagged overrides on Feb 1 / Feb 8 / Mar 1; CSV for the same person Jul 1 → Aug 31 2027 (this is literally the emulator test's fixture).
**Output:** the write lands, the three overrides are still on the document — and `getShiftForDate(doc, '2027-02-01')` now returns `null`: `isInFutureWindow` is false for Feb, so the resolver reads the *base* maps and never looks at `futureSchedule.overrides`. The 🔔 vanishes from every view, `selectRemindersDue`/`activeOverridesFor` won't select them, and the confirm just told the manager "The 3 existing dated overrides … (and their reminder flags) are kept — this write never touches them." Same thing happens in the overlap/conflict case for any override outside the new range (existing Jan–Jun with a Feb 1 flag, CSV Mar–Aug).

This is strictly better than the old write (which deleted them), and it's not data *loss* — they're still visible in the Schedule Builder's override list when the block is active — but the message promises something the resolver doesn't deliver, and the emulator test encodes the orphaning scenario as success.

**Change:** in `countFutureOverrides` (or beside it) also count `Object.keys(overrides).filter(d => d < entry.validFrom || d > entry.validUntil)` and say it in both the row note and the confirm: "N of them fall outside the new date range and will no longer appear on any schedule view or send a reminder." Add one assertion to the emulator test that a kept override *inside* the new range still resolves via `getShiftForDate`, and one that documents the outside-range one does not. (Pre-existing, out of this phase: a non-overlapping existing block gets no conflict checkbox at all, so importing Spring 2027 while Fall 2026 is active silently replaces the active block's weekdays and bounds.)

#### Should-fix 2 — the 🔔 and the sub promise inherit the editor's/sub-confirm's lack of per-date routing, so the flag can land in a layer the resolver never reads
`js/app.js:7428` (sub write to base `overrides`), `js/app.js:7496-7497` (promise), `js/app.js:3027` + `3319` (editor writes whatever layer is active *today*), `js/schedule-helpers.js:267-292` (`getShiftForDate` never falls through from an active future window to base)

**Input A (sub promise):** sub Shelley has `futureSchedule` with `validFrom: '2026-09-01', validUntil: '2026-12-18'`; a requester's Oct 17 time off; manager confirms Shelley today (Sep 21).
**Output:** `saveSchedule(subUid, { overrides: { '2026-10-17': {…, remind: true, remindUid} } })` goes to the base map; on Oct 17 the future window is active, so `getShiftForDate` reads `futureSchedule.overrides`, finds nothing, and the coverage shift is invisible — and `selectRemindersDue` (via `activeOverridesFor`) never selects it. The email nevertheless says "Shelley will also get an automatic reminder email … before this shift." — a promise the job cannot keep.

**Input B (editor):** the plan's own BDD — today Sep 21, person has an *upcoming* block Oct 1 → Dec 18 (not active, so the editor is in base mode), manager adds One-Off Oct 17 with the box ticked.
**Output:** `overrides['2026-10-17'] = { …, remind: true, remindUid }` on the base map, row shows 🔔 "Reminder email 2 days before"; on Oct 17 the block is active and shadows it. No shift, no bell in My Schedule, no reminder. (The change email correctly says "no date changes to notify about", which is the only hint.)

The underlying routing gap is pre-existing (the AI tool was fixed for it on Sep 17 with `applyScheduleEdits` routing per date; the editor and the time-off/sub writers weren't). Phase 3 doesn't cause it, but it now stamps a promise on top of it. Whether it bites today depends on whether the Fall 2026 blocks the CSV tool wrote are active right now — worth checking against the data.

**Change (minimal, in-phase):** in `submitConfirmSub`, only promise for dates the resolver will actually read: `reminderDates = writtenDates.filter(d => overridesToWrite[d].remind === true && d >= reminderFrom && !isInFutureWindow((subSchedule || {}).futureSchedule, d))`. In `renderOverridesList`, append "(not shown — this date falls inside/outside the temporary schedule)" when `isInFutureWindow(base.futureSchedule, dateStr) !== !!window._editingFutureSchedule`. **Change (proper, follow-up):** route the editor's and sub/time-off writes by date the way `applyScheduleEdits` does.

#### Should-fix 3 — AI status line says "Reminders set for N dates" for a person with no linked account, where no email can ever go
`js/app.js:5320-5326`, `js/app.js:5357`

**Input:** AI box ticked; edit resolves to roster entry `{ id: 'emp_newhire', claimedBy: null }` with an `emp_`-keyed schedule; one valid date.
**Output:** `resolveReminderUid` → `null`; `applyScheduleEdits` SET mode writes `remind: true` alone (correct per Phase 1); `countFlaggedDates` counts it; status reads "Reminders set for 1 date." The editor row would have said "(no linked account)" for the same state; the AI path says nothing.

**Change:** collect `noAccount.push(g.name)` when `remind && !remindUid`, and append "— no linked account for X; no email will be sent until they sign in" to the status line (and count those dates separately or exclude them).

---

#### Nits

- **`countFlaggedDates` over-counts in SET mode** (`js/app.js:5326`). Input: edits `{ '2026-10-17': valid, '2026-10-18': { start: '25:00', … } }`, Oct 18 rejected but already flagged on the doc → "Reminders set for 2 dates" though this batch flagged one. Count only dates present in `r.fields`/not in `r.rejected`, or diff `r.after` against `r.before`.
- **Last-hour-of-day promise** (`js/app.js:7496`). A sub confirmed for *tomorrow* between the day's last hourly tick and midnight Denver gets a promise; the next tick runs after the date rolls, the window is now [D+2, D+3], and the shift is "today" → nothing sends. Depends on Phase 5's cadence; cheap guard: `reminderFrom = addCalendarDays(date, hour >= 23 ? 2 : 1)`. Also consider extracting the filter into a helper in `schedule-helpers.js` so the Denver/DST/midnight cases get real unit tests instead of a source regex (`schedule-editor-wiring.test.js:1436-1445` pins the text, not the behaviour).
- **UI text points at a section that doesn't exist yet** (`index.html:502`, `index.html:593`): "untick individual dates under 'Reminders' below" / "Every reminder is listed under 'Reminders' below". The only "Reminders" heading today is the push-notification help (`index.html:786`). Fine if Phase 4 ships in the same deploy; misleading otherwise. Also neither text says a shift flagged on its own day sends nothing.
- **`sw.js` not bumped** (`sw.js:64`, still `tinker-ticker-v19`), and `handleAddOverride` reads `document.getElementById('override-remind').checked` unguarded (`js/app.js:3237`). The shell is cache-first/stale-while-revalidate per file; the repo convention (`b44e281`: "sw.js v19 (app.js changed)") bumps on app.js changes so `addAll` refreshes the shell atomically. Without it, a load that revalidates `app.js` but not `index.html` throws `TypeError` on Add Override. Bump to v20 and use the AI path's null-safe form `!!(document.getElementById('override-remind') || {}).checked`.
- **Who's Working → Daily** shows no bell (`js/app.js:4798-4821`). In scope per the plan's list (week/month/popup), but it's the densest view and the one with the Extend button; one line to add.
- **CSV writer on a vanished document** (`js/app.js:5859-5862`): `set(…, {merge:true})` on a doc deleted between dry run and write (e.g. `emp_` doc migrated away on claim) creates a fresh doc holding only `futureSchedule` — no `uid`/`name`/base `recurring`, so My Schedule says "No schedule set up yet". Same as the old `mergeFields` write, so not a regression; `update()` with dotted `FieldPath`s (`futureSchedule.recurring.Mon`, `futureSchedule.validFrom`, …) would refuse on a missing doc *and* sidestep the empty-map exception entirely, matching the CLAUDE.md "updateDoc for partial edits" invariant.
- **Replace-onto-occupied-date drops a stored `remindUid`** (`js/app.js:3239-3242`): the `storedUid` fallback reads the *source* row (`editingOverrideDate`), so a fresh add onto a date that already held `{remind, remindUid}` — after the "will replace it" confirm — with nothing resolvable (roster + users both failed to load) yields `remind: true` alone. Only reachable in the doubly-degraded state; mention for completeness.
- **Standalone import pages** (`schedule-import.html`, `summer-camp-sync.html`) still write whole `overrides` maps and would drop flags if ever re-run. They're one-off tools for past seasons; note it in their headers.

---

### (e) What Phase 4 / Phase 5 will need that Phase 3 doesn't provide
1. **An enumerator** of flagged dates across both layers for the Reminders view — `activeOverridesFor` is per-date; nothing walks `Object.keys(overrides) ∪ Object.keys(futureSchedule.overrides)` and filters by `activeOverridesFor(s, d) === thatMap`. Easy to add; should live in `schedule-helpers.js`.
2. **A leaf-level unflag writer.** The view's "untick" needs `update(new FieldPath('overrides', date, 'remind'), FieldValue.delete(), …)` on the right layer. `applyScheduleEditsTransaction` replaces whole leaves and has no clear mode; the editor's `buildOverridesWrite` needs the whole map plus the open-time snapshot. Neither fits a one-date toggle.
3. **Flags with no `remindUid`.** `selectRemindersDue` exposes `docId` and `remindUid: null`. A flag stamped on an unclaimed `emp_` doc survives `migrateSchedule` (`js/firebase-data.js:412`) without gaining a uid. The bot "never lists users", so either Phase 2's rules let it read `timeclock_settings/employees` to walk `docId → claimedBy`, or Phase 4's view must surface these ("no linked account") with a re-save path that re-resolves.
4. **`remindUid` ≠ deliverable address.** Nothing at stamp time checks the users doc has `email`. The view should render `resolveReminderRecipient(remindUid, …)` next to each row so a 🔔 that will bounce is visible before the job runs.
5. **`name: schedule.name || ''`** in `selectRemindersDue` — docs with no stored name are repaired lazily by the app (`js/app.js:2855-2862`), so the job can see an empty name; fall back to the users doc.

---

### Checked and found sound

- **Editor flag ownership** (`js/app.js:3160-3256`): `clearOverrideForm` unticks; `editOverride` clears first, then pre-fills `checked = ov.remind === true` (day-off leaves it cleared and the group hidden); `handleAddOverride` emits `{}` or `{ remind: true[, remindUid] }` — never `false`/`null`/`""` — and the Phase 1 `...carried` is gone. `cleanOverrides` strips `_type` and `undefined` only, so flags reach `buildOverridesWrite` (`js/schedule-helpers.js:820-848`), whose `CLEARABLE_OVERRIDE_KEYS` turn an untick into two delete sentinels on a kept override; `reminder-flag.emulator.test.js` proves that shape in both layers.
- **`resolveReminderUid`** (`js/schedule-helpers.js:774-780`): uid-keyed doc in `allUsers` → itself; `emp_`-keyed or `allUsers = []` after a failed read → roster `claimedBy`; unclaimed/empty-string `claimedBy` → `null`. The `|| storedUid` fallback on edit keeps a stored account when nothing resolves. Stable across `migrateSchedule` because it already returned the `claimedBy` uid for `emp_` docs.
- **AI path**: box reset per parse (`renderAiEditResults`), passed as `{ remind, remindUid: remindUid || undefined }`; `applyScheduleEdits` SET stamps every non-null value and keeps an existing uid when the caller has none, PRESERVE keeps an existing flag; model output can't set the keys; the transaction is a varargs `update()` on leaf paths, no `set(`.
- **Change email ignores the flag**: `normaliseShift`/`sameShift` compare start/end/studio/note only; editor `touched` + `diffScheduleDates` → `no-changes` → "Schedule saved — no date changes to notify about". Sub/partial-day reversals compare via `sameOverrideValue` (flag-insensitive).
- **CSV writer shape** (`js/app.js:5851-5862`): seven weekdays through `buildRecurringWrite` diffed against the dry-run snapshot's `recurring` (a weekday added after the dry run is untouched — emulator test proves it); `recurring` can never be empty because `parseFutureScheduleCsv` only yields people with ≥1 day, and `omitEmptyMaps` guards anyway; both bounds are always regex-validated strings, so a bounds-less block can't be written; `overrides` is not in the payload at all; sentinels are class instances, so `isPlainMap` doesn't strip them; write is awaited, per-entry try/catch, failures counted and shown.
- **Sub promise** (`js/app.js:7496-7497`, `_lib/timeoff-confirmation.js:47-57`, endpoint `:40-41`): `denverNow()` is zone-named so it's correct in any browser zone; `d >= addCalendarDays(date, 1)` is a plain ISO-string compare; the sentence states no time of day; the endpoint validates shape, caps at 120, and only renders the line when `shiftsWritten` is non-empty. Same-day → no line; tomorrow → line (modulo the last-hour nit).
- **Views**: `getShiftForDate` returns the override object by reference, so `shift.remind` is readable in My Schedule / week / month; `buildShiftDetail.remind` is `=== true` only; no toggle outside the Builder. `REMIND_BELL_HTML` is a top-level `const` used only from functions called after script evaluation, and no new helper name collides across the classic scripts.
- **Invariants**: no new collection; no whole-object `set()` introduced (`migrateSchedule`'s is pre-existing and deliberate); `timeclock_overrides` (admin Extend) is a different collection and unaffected.

I can't write the review file into `tinker-ai-configs/thoughts/reviews/` from this session (outside the allowed paths); if you want it there, paste this in or re-run with that directory added.
