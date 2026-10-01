## Implementation review — Phase 1, `ticker-sub-confirm-only-by-manager` @ e7e11d6

**What I could verify:** I read the plan in full, the whole diff, and the surrounding production code (`js/app.js` 6789–7620, 7660–7710, 7905–8030, 8280–8330, 8790–8815; `js/schedule-helpers.js` 964–1140; `js/firebase-data.js` 751–880). **What I could not:** the sandbox refused `npx jest` and `node --check`, so I did **not** execute the suite or a syntax check. Every test claim below is from reading the ratchet regexes against the actual source text.

---

## 1. Conformance to Phase 1

Every Acceptance bullet and every "Changes" bullet in Phase 1 is implemented, at the places the plan names:

| Plan item | Where | OK |
|---|---|---|
| checkbox + `toggleFormSubConfirmed` deleted, read-only chip | `js/app.js:7351` | ✓ |
| × prompt, both wordings, picker-options `canReAdd` | `js/app.js:7316–7332` | ✓ |
| re-add restores a deep copy of `openedSubs[name].entry` | `js/app.js:7295–7301` | ✓ |
| `openedSubs`/`openedDates` reset at open, filled from the **document** | `7026–7027`, `7076–7084` | ✓ |
| create literal forces `confirmed:false` **after** `...formData` | `7569` → `7572` | ✓ |
| step 1 before reconcile and before any reversal, `giveBack()` first | `7508–7513` | ✓ |
| step 2 on the carry read, landed `reversedNames` only, `giveBack()` | `7537–7544` | ✓ |
| `carryCurrentSubs` returns `currentDates` with the absence idiom | `8811–8812` | ✓ |
| `saveGuard.expect.dates` | `7548` | ✓ |
| `'dates'` arm in the transaction refusal | `7557` | ✓ |
| re-confirm notice from `reversedNames ∩ confirmed(carried.current)` | `7546`, `7595–7596` | ✓ |
| `carryConfirmedSubs` loses `hasLink` | `schedule-helpers.js:1025` | ✓ |
| `canToggle` — Mark Confirmed admin-only, Undo `isOwner \|\| isAdmin` | `7688` | ✓ |
| manager check after the Undo `return`, before `resolveSubRosterMatch`; and at the top of `submitConfirmSub` | `7930–7933`, `8018–8021` | ✓ |
| D3 via `subMissingWriteNote`, amber wrap in the caller | `7695–7696`, `schedule-helpers.js:1101` | ✓ |
| reset branch untouched | diff hunks stop at `7500` | ✓ |

`isAdmin` (`7636`) and `isManagerUser()` (`8185`) are the same predicate, so the render gate and the runtime gate cannot disagree.

**Beyond the plan:** one item — the added sentence in `index.html:711` ("If someone has said yes, note it in Coverage Notes…"). Not in the Changes list, but it's the user-facing half of the decision and is consistent with it. No behavioural reach beyond Phase 1 anywhere else; nothing from Phase 2 or 3 leaked in (`confirm-sub-dates` is still the old `<span>`, `updateCoverageStatus` still has its duplicate `renderAdminAllTimeOff()`).

---

## 2. End-to-end traces

All ten trace cleanly. The ones worth spelling out:

- **Reason-only edit, confirmed sub.** Step 1: `wasConfirmed(Sam)===docConfirmed(Sam)`; `docNorm≡openedDates`; D1 needs `normalize(formDates)≠docNorm` — the form's load (`7069`: `type||'full'`, `||''`) and save (`7416`: `null` unless partial) round-trip through `normalizeRequestDates` to the same value, including the legacy `{date, partialStart:''}` shape. `toReverse` is empty, `reverseConfirmedTimeOffSubs` is called with an **empty** `Set`, and both loops do `if (onlyIndexes && !onlyIndexes.has(i)) continue` (`8295`, `8317`) — an empty set is truthy, so nothing is reversed. `carryConfirmedSubs` re-attaches the live record. Link kept. ✓
- **Remove a confirmed sub → reversal lands.** Reversal keyed on `existingData`'s indexes; `reversedNames=['Sam']`; step 2 sees `s.confirmed===false` so no flag either way; `carryConfirmedSubs` does not re-append. ✓
- **Remove + re-add.** The restored entry carries `confirmed:true`, so `reconcileEditedProposedSubs` takes the `s.confirmed` branch (`schedule-helpers.js:992`) and **never** pushes to `toReverse`. Nothing is reversed. (Cosmetic only: the re-added row moves to the end of the list.)
- **Round-2 removal race.** Kayleigh unconfirmed at open, confirmed meanwhile, removed from the form → the `docSubs` loop (`1080–1083`) fires `s.confirmed && !wasConfirmed` → refused **before** reconcile could queue her. This is the hole the plan was built for and it is closed.
- **The inverse, which I checked specifically because it is the obvious false-refusal risk:** sub confirmed at open, a manager Undoes them, the user *removes* them. Not in `formNames`; `s.confirmed` is now false → **not** flagged, save proceeds, nothing reversed. Correct, and exactly what the plan's spec says.
- **Brand-new request.** `editingTimeOffId` null → the whole guarded block is skipped, `checkEditAgainstDocument` is never reached, `openedSubs && openedSubs[name]` short-circuits in `addTimeOffSub`, `sub.confirmed` is false in `removeTimeOffSub`. No throw. Create path forces `confirmed:false`. ✓
- **`existingDoc.exists === false`.** Falls to the plain `updateTimeOffRequest` (`7561`), whose `.update()` rejects on a missing doc, is caught, returns false → "Failed to save." The form's `confirmed` never reaches Firestore. Unchanged, and safe.
- **Reset branch.** No diff lines inside it; `reconfirmedNames` stays `[]` so the toast is unchanged; the extra `currentDates` key is ignored there, as the plan specifies.

---

## 3. Firebase invariants

Clean. No new writes. No `undefined`: `dates` (`7413–7419`) uses explicit `null`; `proposedSubs` (`7422`) uses `s.email || ''` and `s.dates` (always an array from `7074`/`7309`/the deep copy); `carryConfirmedSubs`' strip branch writes `subUid: null, appliedOverrides: {}`. `expect.dates` is read-only and `null` compares equal to an absent field via the guard's own normalisation (`firebase-data.js:866–868`). Every write still awaited. Both new refusal paths call `giveBack()` before returning, so no refusal leaves Save disabled.

---

## 4. Findings

### MEDIUM

**M1 — No test distinguishes `reversedNames` from its absence; both tests that name it pass vacuously.**
`schedule-helpers.test.js:2971` and `:2979`. Delete the `skip` set from `checkEditAgainstDocument` (`schedule-helpers.js:1068,1075,1081`) and both still pass:
- `:2971` first assertion — Sam is absent from `formSubs` and `confirmed:false` on the doc, so the `docSubs` loop's `s.confirmed &&` guard already returns `ok:true` without `skip`.
- `:2979` — Sam is `confirmed:false` on the doc, so he is never a candidate; `names:['Kayleigh']` comes out identically.

Tracing it through, `skip` is in fact **inert** in production too: step 1 guarantees that every `toReverse` name was confirmed when the form opened, so at step 2 `wasConfirmed(name)` is `true` and the `docSubs` predicate `s.confirmed && !wasConfirmed` can never fire for it; and the `formNames` branch needs the un-tick path, which no longer exists. It is harmless defence-in-depth — but it is the plan's most intricate mechanism and it currently has zero real coverage, so nobody should read those two test names as protection. A test that actually bites would need `formSubs` containing a `reversedNames` name (i.e. the old-cached-page un-tick shape).

### LOW

**L1 — `editRefusalMessage` reads the module global `openedSubs` instead of taking it as a parameter.** `js/app.js:7374`. Correct today (it runs synchronously in the same flow), but it makes the D1 "To remove X, save that change on its own first" derivation the only part of the rule that can't be unit-tested the way `checkEditAgainstDocument` is; it has a wording ratchet only.

**L2 — The `subs-changed` message asserts a cause it can't know.** `js/app.js:7365` says "A manager confirmed or un-confirmed X". It also fires when the **owner** used Undo in another tab (the owner keeps Undo by design, `7688`), and when another editor deleted a confirmed sub from `proposedSubs` outright. The refusal is right; the attribution isn't. Nothing is written either way.

**L3 — `failedSubsNote`'s "The request will be saved, BUT …" can now be contradicted one step earlier.** `js/app.js:7529` alerts that the request *will* be saved, then step 2 (`7542`) can refuse it. Pre-existing in shape — the transaction refusal at `7557` always had this property — and the second alert does say plainly "your edits were NOT saved", so the user isn't left believing the first. Worth knowing it's now reachable via one more path.

**L4 — `normalizeRequestDates` has no test for a *partial* row with `''`/`undefined` times → `null`.** The plan's test list asks for "`''`/null/undefined partials"; `schedule-helpers.test.js:2926–2940` covers full-day rows dropping partials, `type` null/`''`/undefined, and the legacy full-day round-trip, but never `{type:'partial', partialStart:''}`. Small gap, and the plan separately documents that such a row can't round-trip anyway.

**L5 — The D3 gate is duplicated.** `js/app.js:7695` re-tests `s.confirmed ?` before calling `subMissingWriteNote`, which already returns `''` for an unconfirmed sub (`schedule-helpers.js:1102`). The plan said the helper owns "the whole predicate (gate included)". Harmless; it just means the caller's gate is untested dead logic.

**L6 — The edit form's "Confirmed" chip carries no D3-style note.** `js/app.js:7351`. A legacy requester-ticked confirmation shows a green chip in the edit form with nothing saying no shift was written; the amber line exists only in the detail view (`7696`). Not required by Phase 1, but it's the one surface where the old false "Confirmed" still reads clean.

**L7 — `checkEditAgainstDocument` throws on a missing `openedDates`, and `handleSubmitTimeOff` has no `try`.** `schedule-helpers.js:1066`. If it ever threw, the unhandled rejection would leave Save disabled at "Saving…". I traced every assignment: `openedSubs`/`openedDates`/`editingTimeOffId` are set and cleared together at `7023–7027` and `7076–7084`, and `editingTimeOffId` is only otherwise cleared at `7591`, so it is unreachable today. The plan predicted this and accepted it; noting only that the failure mode is a stuck button, not an alert.

**L8 — Operational, before anyone uses `npm test` as the deploy gate.** A stale worktree exists at `.claude/worktrees/loving-brahmagupta-576572` (commit `62db9a2`, an ancestor of this one, with no `checkEditAgainstDocument` in it). There is no jest config, so the bare filename patterns in `package.json`'s test script also match that copy's test files, and the run will include a full second, pre-Phase-1 suite reading its own `js/`. It'll be green on its own terms — so the risk is a misleading test count rather than a false red, but the plan's resume step 4 calls this out and it should be removed before the run that gates the deploy.

---

## Verdict

No BLOCKING findings. I could not find a wrong schedule write, a false confirmation, a legitimate save wrongly refused, a stale form that still decides anything, a refusal that leaves Save disabled, or a `undefined`/unguarded/unawaited write. The two races the plan was built for (round 1 and round 2, including the removal variant), D1, dates-changed-elsewhere, and the step-2-after-a-landed-removal case all resolve the way the plan specifies, and the deliberate manager-re-confirm exception is implemented and announced. The one substantive finding is a coverage gap (M1), not a defect.

**Phase 1 OK to build on — yes.**
