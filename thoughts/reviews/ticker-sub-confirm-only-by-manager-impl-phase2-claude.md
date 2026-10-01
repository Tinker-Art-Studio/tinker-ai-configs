I've read the plan (Phase 1 + Phase 2 in full), both Phase 1 reviews, the whole diff, and the surrounding production code. **What I could not do:** `npx jest` and `node -e` were both denied in this sandbox, so I did **not** execute the suite. Every test claim below comes from tracing the ratchet regexes and slice boundaries against the actual file text by hand.

---

## Conformance

**2f0d2b6 — all six claimed fixes land, and nothing behavioural rides along.**

| Claim | Where | Verified |
|---|---|---|
| failed read refuses plainly, button back | `js/app.js:7463–7470` | ✓ before any write, `giveBack()` first |
| deleted request refuses plainly | `:7471–7475` | ✓ closes Codex's `:7462` MEDIUM |
| neutral "someone else" wording | `:7365` | ✓ and "removed" is reachable (a form sub absent from `docSubs` reads as unconfirmed) |
| `editRefusalMessage` takes `opened` | `:7362`, `:7524` | ✓ sole caller; no global read left |
| re-confirm notice names + grammar | `:7609–7610` | ✓ matches the plan's "so Sam stays on this request" |
| help text no longer promises a write | `index.html:711` | ✓ (see L8) |
| the vacuous tests now bite | see below | ✓ both traced |

**7e7ebba vs the Phase 2 spec: every acceptance bullet and every "Changes" item is implemented at the places the plan names.** One deviation, in the right direction: the plan said replace the `<span>` *inside* the `<p>` (`index.html:1186`); the implementation makes the checkbox `<div>` a **sibling** of the `<p>` (`index.html:1186–1187`) — valid HTML, where a `<div>` inside a `<p>` is not. No omissions, no overreach.

**End-to-end traces** — all twelve resolve as specified. The ones worth stating:

- **one unticked / none ticked** — `ctx.dates` (`:8068`) is the only source for the loop, so `overridesToWrite`, `conflictDates`, `appliedOverrides`, `writtenDates`, `reminderDates` and the email all narrow with it; `getSubCoverageDates` is genuinely gone from the function. `!ctx.requestDates.length` (`:8062`) precedes `!ctx.dates.length` (`:8069`), so the two refusals can't be confused.
- **ticked date with no normal shift + one that works** — `noShiftDates` (`:8091`), named at `:8216` after success. All ticked dates unwritable → falls to the pre-existing `:8100` (see L5).
- **overwrite prompt cancelled** — `return` at `:8107`, nothing written, and the `finally` at `:8221` restores the button. **No refusal in this function can leave Confirm disabled**: every early return before `:8075` predates the disable, and everything after is inside the try.
- **dates moved (full rollback + new lead)** — `theirs` is only computed on `reason === 'sub-changed'`, so a `{reason:'changed', field:'dates'}` result takes `rollBack = appliedOverrides` whole, which is what the plan wants; `lead` (`:8176`) is reached only when `theirs` is null, so the three leads can't collide.
- **dates moved AND a colleague confirmed** → `sub-changed` → `partitionRollback`. Checked the colleague's-shift question directly: their record is keyed on the *new* dates, ours on the old, so `theirs[ourDate]` is undefined → `rollBack` takes only our own write and their shift is untouched. If the colleague used the *unmatched-name* path (`:7957`, `confirmed:true` with no record), `entry.subUid !== ctx.subUid` → `theirs` null → full rollback, which is correct there because their confirm wrote no schedule.
- **re-read failure in the sub-changed branch** — `Object.keys(appliedOverrides).sort().join(', ')` (`:8162`). The `${dates}` ReferenceError is gone and `not.toMatch(/\$\{dates\}/)` pins it.
- **Cancel/× then reopen / stale call with the box closed** — `closeConfirmSubModal` is the *only* thing that removes `.open` from this modal (I grepped: no backdrop-click or Escape handler covers `confirm-sub-modal`, unlike help/settings/unscheduled at `:215/:228/:382`), and ctx + `innerHTML` are always written together synchronously, so they can never disagree. A stale submit hits `!ctx` and returns silently.

**`confirmTimeOffSub`** — the `dates` guard sits at `firebase-data.js:808`: after `appliedOverrides` (795), `statuses` (800), `subUid` (802) and `confirmed` (803), before the patch (809). The other five callers (`app.js:7957`, `8303`, `8364`, and `8941`/`9037` via `guard()` at `8918`/`8992`) pass no `dates`, so `want.dates === undefined` and the line is inert for them. `normalizeRequestDates` is a global from `schedule-helpers.js` (loaded at `index.html:1156`, after `firebase-data.js` at `:1154`) called only at runtime — the same arrangement `sameStructure` already relies on. `firebase-data.failure.test.js`'s vm sandbox never reaches this function (its fake db has no `runTransaction`), so no ReferenceError there.

**Firebase invariants:** clean. The only new field is `expectRequest.dates`, read-only and always an array. No `undefined` (`previousOverride` is `had ? before[d] : null`; `patch.subUid` is a truthy `claimedBy`). The schedule write narrows to ticked dates. `saveSchedule`, `confirmTimeOffSub` and `removeTimeOffOverrides` are all awaited. No new collection, no rules change.

---

## Findings

### MEDIUM

**M1 — `escapeHtml` is not attribute-safe, and the checkbox `value` is an attribute.** `js/app.js:8021`, root cause at `js/app.js:4502`.
`escapeHtml` is `div.textContent = str; return div.innerHTML` — HTML *text* serialization, which escapes `&`, `<`, `>` and U+00A0 and **never `"`**. So `value="${escapeHtml(d)}"` does not contain `d`. `d` is `timeclock_timeoff/{id}.dates[].date`, and `firestore.rules:446` is an unrestricted `allow update` for the requester, so a signed-in staff member can put `" autofocus onfocus=… x="` there from the browser console on the live app — no tooling needed — and a manager opening the confirm box for that request executes it in a manager session.
The **label** side is fine: `label` is `toLocaleDateString` output ("Invalid Date" for garbage), never attacker text, and it sits in text context.
Ranked MEDIUM, not BLOCKING, because Phase 2 does not change the posture: the same exposure already exists on the same document at `js/app.js:7342` (`mailto:${escapeHtml(s.email)}`), and `:5106–5112` are worse (`escapeHtml` inside a single-quoted JS string in `onclick`, where `'` also survives). The fix is one line — have `escapeHtml` also replace `"`→`&quot;` and `'`→`&#39;` — and it closes all of them at once. Worth saying out loud because the spec listed "labels escaped" as the security measure here, and for the value it isn't one.

**M2 — the emulator case named for the guard order is satisfied by an earlier guard.** `timeoff-sub-confirm.emulator.test.js:317–325`.
The seed gives the colleague's entry `appliedOverrides: {'2026-10-04': …}` while the call passes `expectApplied = {}`, so the transaction returns at the `appliedOverrides` guard (`firebase-data.js:795–798`) — `sub-changed`, field `appliedOverrides` — as the test's own comment concedes. Moving the `dates` check *above* `confirmed` (but still below `appliedOverrides`) leaves this test green, so the round-3 BLOCKING it was written for is pinned only by the `indexOf` text ratchet at `schedule-editor-wiring.test.js:2341–2345`, which reads `firebase-data.js` only — the mirror's own order is unpinned.
It would bite with the shape where the order actually decides anything in production: the **unmatched-name** confirm (`js/app.js:7957`) writes `confirmed: true` with *no* `appliedOverrides` and *no* `subUid`, so seeding `{confirmed: true}` alone walks past `appliedOverrides` and `subUid` and lands on the `confirmed`-vs-`dates` choice.

**M3 — the new mirror comparison catches drift in the two helpers, not in the transaction it exists to mirror.** `schedule-editor-wiring.test.js:2357–2366`.
The verbatim claim itself holds: I compared `timeoff-sub-confirm.emulator.test.js:37–44` / `46–57` against `js/schedule-helpers.js:1127–1134` / `1052–1063` line by line — byte-identical after the one comment strip — and checked the `body()` slicer terminates on the right brace in all four cases (no column-0 `}` appears earlier in any body). Editing either side now fails the test. But the mirror's `confirmTimeOffSub` (`:62–89`) is still a hand copy of `firebase-data.js:783–819` tied to the real thing by a single presence regex, so the guard *sequence* the emulator tests claim to exercise can drift silently. Comparing the ordered list of `field: '…'` strings between the two files would close it. (The plan only promised the two helpers, so this is a completeness gap against the plan's stated *reason*, not against its text.)

### LOW

**L1 — after a `dates` refusal the box stays open with checkboxes describing dates the request no longer has.** `js/app.js:8176–8185`. The snapshot only changes in `openConfirmSubModal`, so the guard can never pass; each retry writes the shift and rolls it back again, and the sentence's "Please refresh" is the only way out. No wrong write — but closing or re-rendering the box on `result.field === 'dates'` would say in the UI what the sentence says in words.

**L2 — the schedule write precedes the guard that refuses it.** `js/app.js:8133` → `:8145`. For a sub-second window the sub's schedule holds a `remind: true` coverage shift for a date the request no longer covers. Pre-existing for every refusal reason; Phase 2 adds a new and more likely trigger. If the hourly reminder tick landed inside that window, the `timeclock_reminder_log` claim is not removed by the rollback (the rules forbid the app deleting it). Nothing to change; worth knowing it exists.

**L3 — the `noShiftDates` advice can't be followed as written.** `js/app.js:8216`. "Use custom times" arrives *after* the confirm landed and the box closed; getting custom times onto those dates now needs Undo → Mark Confirmed again. The second half ("add it to Sam's schedule by hand") is actionable. Plan-text carry-over.

**L4 — `if (existingDoc.exists) {` at `js/app.js:7476` can no longer be false**, since `:7471` returns. Dead condition kept to hold the diff down; the block could lose a nesting level.

**L5 — the "every ticked date is unwritable" case isn't named the way single misses are.** `js/app.js:8099–8102` falls to the pre-existing "Could not determine a shift time to write for any covered date… Add the sub's shift manually" — which tells the manager to add a shift while the sub stays **unconfirmed**, producing the inverse of D3's amber line (a shift with no confirmation). Unchanged line; Phase 2 makes it reachable by ticking.

**L6 — `confirmDatePreticks`' all-dates fallback scales with the request.** `js/schedule-helpers.js:219`. On a two-week request whose sub dates no longer line up, that is 14 pre-ticked shifts behind one click, where today's code refuses with "no covered dates". Christie's D2 decision, and the visible boxes plus "untick any day they aren't covering" mitigate it — noted so the consequence is on the record.

**L7 — Codex's Phase-1 stuck-Save-button MEDIUM is closed only for the first read.** `js/app.js:7460–7475` catches that one; a rejection from `removeTimeOffOverrides`, `reverseConfirmedTimeOffSubs` or `loadSchedule` in the same branch still skips `giveBack()` (there's no try/finally around the edit branch). Out of Phase 2's scope; it lives in the reset branch.

**L8 — the reworked help copy is still slightly over-broad.** `index.html:711` — "(and, for anyone signed in to Ticker, adds the shift to their schedule)" is false for the `ambiguous` roster status (two active claimed roster rows with one name), which confirms with no schedule write (`js/app.js:7950–7957`).

---

## Are the new tests real?

Traced by hand, both directions:

- **`confirmDatePreticks`** (`schedule-helpers.test.js:3061–3083`) — the two "none line up" cases fail if the helper is just `getSubCoverageDates`; the `out.push('x')` case fails if the fallback returns `requestDates` without `.slice()`. Real.
- **`normalizeRequestDates` partial-with-empty-times** — fails if `partial ? (d.partialStart || null)` loses the `|| null` (which would put `undefined` in a compare). Real; closes Phase-1 Claude L4.
- **`reversedNames`** (`:2986–2992`) — I ran both branches by hand against `schedule-helpers.js:1083–1092`: without `reversedNames` the `formNames` loop fires (`wasConfirmed` true, doc false) → refused; with it, `skip` short-circuits → `ok`. Deleting `skip` at `:1084` now fails the first assertion. Real; closes Phase-1 Claude M1 for the reachable half (the `:1090` `skip` stays uncovered, and is still unreachable in production).
- **the `hasRecord` lead ratchet** (`schedule-editor-wiring.test.js:2236–2237`) — pins which wording each branch gets, so inverting them fails. Real; closes Codex's `:2231`.
- **Phase 2 ratchets** — `assign < loop`, `not.toMatch(/getSubCoverageDates/)`, `not.toMatch(/\$\{dates\}/)`, the `noShiftDates` pair, the lead regex (its `\\'` correctly matches the source's literal `\'`), the ordered `confirmed`/`dates` `indexOf`, and the mirror comparison all bite on a reverted implementation.
- **the close-handler test** (`:2348–2355`) — I checked the slice: `html.indexOf('</div>\n</div>', …)` needs the second `</div>` at column 0, which only `index.html:1206` is, so `box` spans exactly lines 1179–1205 and picks up both handlers. `deny-timeoff-modal`'s inline `classList.remove('open')` at `:1172` and `admin-extend-modal`'s at `:1236` fall outside. The assertion is doing what it says.
- **the three emulator cases** — 1 and 2 bite (drop the guard → success; swap `normalizeRequestDates` for a raw compare → the legacy-shape case refuses). Case 3 is M2.

---

**Phase 2 OK to build on — yes.** I could not find a wrong schedule write, a date the manager unticked reaching Firestore, a colleague's shift deleted by any rollback path, a false confirmation, a refusal that leaves Confirm disabled, a message that states something false, or an unguarded/unawaited/`undefined` write. M1 is the one finding I'd act on before the deploy, and it's a one-line change to `escapeHtml` that also closes several older instances; M2 and M3 are test-strength gaps rather than defects. Note the `sw.js` `CACHE_NAME` bump is still outstanding — per the plan it belongs to the single deploy after Phase 3.
