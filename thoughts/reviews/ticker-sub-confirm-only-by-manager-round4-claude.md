I read v4 in full, both round‑3 reviews, and verified every load-bearing claim against the code. **No files were edited, no tests run, nothing deployed.**

---

## Round‑3 resolution audit

| Round 3 | v4 | Verified against |
|---|---|---|
| **Claude B1** — "step‑2 refusal leaves nothing half-done" false | Carries `:7485`'s "stays removed" clause, both interleavings named, `giveBack()` on both, BDD added | `js/app.js:7473` sits after `:7459`'s reversals; `:7485` wording confirmed ✅ |
| **Claude B2** — dates guard must follow `confirmed` | "immediately **after** the `confirmed` check at `:803`" + ordered `indexOf` ratchet + emulator case | `js/firebase-data.js:800-803` — status, `reversalPending`, `subUid`, `confirmed`; a check after `:803` follows every `sub-changed` producer ✅ |
| Claude M1 / Codex M1 — remove-then-re-add | `addTimeOffSub` restores `confirmed:true` from `openedSubs`; reconcile then re-attaches the link from the fresh doc | `js/schedule-helpers.js:992-994` carries `subUid`/`appliedOverrides` when both sides say confirmed → nothing queued in `toReverse` ✅ |
| Claude M2 — confirm-box guard not normalized | `normalizeRequestDates` on both sides, inline in `confirmTimeOffSub` (not the generic `expect` loop, which is raw `sameStructure`) | correct choice — `js/firebase-data.js:865-868` would false-refuse legacy shapes ✅ |
| Claude M3 — three unexplained red ratchets | all three named | `schedule-editor-wiring.test.js:1625`, `:1645`, `:1562` confirmed; `:1560` (unmatched path, no `dates`), `:1614` (reset branch), `:1635`, `:1658-1665` all stay green ✅ |
| Claude M4 — `lead` never produces the promised sentence | `lead` becomes reason-aware + ratchet beside the existing two | `:1588`'s negative ratchet is on `result.field === 'confirmed'`, so a `'dates'` branch keeps it green ✅ |
| Claude M5 — `ctx.dates` derivation unratcheted | ratchet pinning assignment from checked inputs before the `:7968` loop | conflicts `:7976`, record `:8011`, email `:8079`, reminders `:8084` all derive from it ✅ |
| Claude M6 — create-branch order | "after `...formData` (`:7497`)" + order ratchet | `js/app.js:7493-7508` ✅ |
| Claude M7 — ticked date with nothing to copy | named after a successful confirm | `:7973` `continue` ✅ (but see L6) |
| Claude M8 — exclusion keyed on "removed" | `reversedNames` = `toReverse` minus `subsResult.failed` | correct: a failed reversal keeps the sub confirmed *and* `openedSubs` said confirmed, so the removal rule doesn't fire either ✅ |
| Claude L1–L10 | all folded in | `giveBack` `:7443`/`:7474`/`:7484`; `currentDates` idiom matches `:8727`/`:7414`; `firestore.rules:446`; `:7740`; `sw.js:64`; `AGENTS.md:41`; `firebase-data.js:805-807` (`not_needed`) ✅ |
| Codex M2 — Phase 3 unguarded write | `updateTimeOffRequestIfStatus` with `proposedSubs` expected; not-found re-renders | ✅ |
| Codex M3 — orchestration ratchets | list expanded to ~15 pins | mostly ✅; the `field:'dates'` → full-rollback pin is already implied by existing `:1576` + `:1583` |
| Codex L1 — `type: d.type \|\| 'full'` | exact, plus null/`''` tests | matches the load at `:7063` ✅ |
| Codex L2 — non-atomic windows | stated in Completeness | `:8015`/`timeoff-schedule.js:190` ✅ |

Every round‑3 finding is resolved. **No v4 change introduced a wrong schedule write or a false confirmation.** Specifically checked:

- **Re-add restoring the entry:** safe. The restore only sets `confirmed:true`; the *link* comes from `existingData` via reconcile `:992-994`. A stale restore is caught — `openedSubs.Sam=true` vs a document that now says false refuses at step 1, in both directions.
- **`reversedNames` = landed only:** correct. A failed reversal leaves the sub checked at step 2 and passes, then `carryConfirmedSubs` re-appends it — matching the `failedSubsNote` the user already saw.
- **Normalized dates inside the transaction:** `normalizeRequestDates` is a hoisted declaration in `js/schedule-helpers.js`, loaded *after* `js/firebase-data.js` (`index.html:1154`/`:1156`) but called at runtime — same as `sameStructure`. ✅
- **Dropping `hasLink`:** the side-effect note is accurate. `saveGuard.expect.proposedSubs` is `carried.current` (the document's list), not `carried.subs`, so the added `subUid:null, appliedOverrides:{}` keys can't cause a guard mismatch; both are valid Firestore values.
- **Guarded Phase 3 write:** both sides of `expect.proposedSubs` come from reads of the same document and `sameStructure` sorts keys, so no spurious refusal.

---

## BLOCKING

**None.**

## MEDIUM

**M1. The D1 refusal message assumes *this user* moved the dates. It can't know that, and the instruction it gives destroys real coverage.**

D1 compares `normalizeRequestDates(formDates)` against `normalizeRequestDates(docDates)`. But `existingData` is a **fresh read taken at save time** (`js/app.js:7411`), not the read the form opened on — and nothing records the dates the form *loaded* (`openedSubs` holds subs only; `timeoffFormDates` is live state). So the two diverge for either reason, indistinguishably:

- form opens Oct 3 with Sam confirmed → an admin (or the requester's other tab — `canAdminEdit`, `:7707`) moves the request to Oct 4 → the user saves a **reason-only** edit → step 1 fires `dates-while-confirmed` → *"Sam is confirmed to cover this request. Ask a manager to Undo Sam first, then change the dates."*

The user changed no dates. Acting on that sentence means asking a manager to Undo a confirmation that is correct, tearing a real shift off Sam's schedule — to fix something that closing and reopening the form resolves by itself (the reload picks up Oct 4 and the save succeeds). The `subs-changed` message is already worded correctly for both directions (*"…while you were editing… Close this form, reopen the request, and try again"*); only the D1 message presumes authorship.

v4 already recognises the mechanism — B1's second interleaving says exactly this for step 2 — and gives step 2 a reason-neutral sentence. Step 1 still gets the authored-by-you wording. Fix: either add `openedDates` beside `openedSubs` so `checkEditAgainstDocument` can return a distinct reason, or append one clause to the D1 message — *"If you didn't change the dates, someone else did: close this form and reopen the request."*

**M2. `saveGuard.expect` gains `dates`, but the only message that reports a refused field has no `dates` branch.**

`js/app.js:7485`:

```js
… saved.field === 'proposedSubs' ? 'its subs changed' : 'its schedule record changed'
```

`field` can now be `'dates'`, which falls into the else and tells the manager *"its schedule record changed"* — the phrase reserved for `appliedOverrides`. v4 accepted round‑3 Claude M4 for precisely this defect on Phase 2's `lead`; this is the same omission in Phase 1, and the ratchet at `schedule-editor-wiring.test.js:1632` only pins the tail, so it passes either way. One ternary arm, plus a word in the ratchet list.

**M3. `subMissingWriteNote(sub, rosterStatus)` can't carry the test claim the plan makes for it.**

The plan keeps the gate inline (*"change the gate at `:7615` from `s.confirmed && !s.subUid` to `s.confirmed && !Object.keys(s.appliedOverrides || {}).length`"*) and makes only the status→note mapping a helper — but then promises the **five shapes** as unit assertions on that helper. Two of the five (*a real record → none*; *a record without `subUid` → none*) are decided by the gate, not the mapping, so they aren't reachable through `subMissingWriteNote` as scoped. Say the helper owns the whole predicate and `:7615` becomes `const matchNote = subMissingWriteNote(s, resolveSubRosterMatch(s.name, employeeRoster).status)`, or drop the five-shapes test claim back to prose. The gate itself is sound — I re-walked all five shapes against `js/app.js:7615`, `js/schedule-helpers.js:197-201` and `js/app.js:8131`.

## LOW

**L1.** `closeConfirmSubModal()` is specified and ratcheted ("nulls the context"), but the two inline handlers that actually close the box — `index.html:1183` (×) and `:1201` (Cancel), both `classList.remove('open')` — aren't named as rewired. A helper nothing calls passes the ratchet. Low because `submitConfirmSub`'s new open-check makes a stale ctx harmless.

**L2.** *"removing then re-adding is an undo"* isn't universal: `addTimeOffSub` reads `picker.value` (`js/app.js:7272-7278`), so a confirmed sub whose roster entry is inactive or whose name is free-text — the legacy, requester-ticked population this plan exists for — **can't be re-added at all**. And a successful re-add rebuilds `dates` from `timeoffFormDates` (`:7283`) and `email` from the picker, not from the original entry, so a sub proposed for one of three dates silently becomes proposed for all three.

**L3.** The test list gives `checkEditAgainstDocument` a "remove-then-re-add case". That helper's inputs (`openedSubs`, `docSubs`) are byte-identical whether or not `addTimeOffSub` restored `confirmed` — the form flag isn't an input. The real protection is the `addTimeOffSub` ratchet plus the existing reconcile tests (`schedule-helpers.test.js:637-643`). Move the claim.

**L4.** Phase 3's guarded write can return `status-changed` (`approved` → `completed` by `autoCompletePassedTimeOff`, the case `:7448` already accommodates) or `not-found`, not only `changed`. The plan specifies only *"The subs changed while you were choosing"*.

**L5.** The emulator mirror copies `sameStructure` verbatim (`timeoff-sub-confirm.emulator.test.js:37`, *"verbatim from js/schedule-helpers.js"*). `normalizeRequestDates` now needs the same treatment, and the source ratchet needs to pin both. Not stated.

**L6.** M7's "No normal shift to copy on Oct 5" has a BDD and no ratchet or unit test — the same hole M5 was raised for. An implementation that keeps `:7973`'s bare `continue` passes everything but the click-through.

**L7.** `reversedNames` skips a name *entirely*, so: Ivy removes confirmed Sam → reversal lands → a manager re-confirms Sam between the reads → step 2 skips Sam, `carryConfirmedSubs` re-appends him whole, and the save reports "Request saved" with Sam back and Ivy's removal dropped. Data-consistent and arguably the right winner, but *"a form that is out of date can't decide anything, in either direction"* is slightly overstated.

**L8.** Pre-existing, unchanged by v4, same class as B2: `status-changed` (`js/firebase-data.js:800`) precedes the `subUid`/`confirmed` checks (`:802-803`), so a status change concurrent with another manager's confirm of the same sub still routes to the full-rollback path with a `null` `previousOverride`. `removeTimeOffOverrides`'s `stillHoldsWhatWeWrote` (`js/timeoff-schedule.js:194`) is the net. The new ordered ratchet covers only `confirmed` vs `dates` — worth one line saying so.

**L9.** The D1 message says *"Ask a manager"* to a manager (`canAdminEdit`, `:7707`, lets an admin edit anyone's request). Related to L2's known-limit note: a stored `date: ''` row, or a request with no `dates` at all, also can't round-trip — `validDates` (`:7331`) drops it, so D1 refuses every edit while a sub is confirmed. Both belong in the same "known limit" sentence.

**L10.** The unmatched-name confirm (`:7865`) still passes no `dates`, so it can mark Confirmed against dates that moved, and its email (`:7880-7890`) reads them from the pre-transaction snapshot. No schedule write, and D3's amber line catches the result — worth naming as deliberate rather than leaving it to the reader.

---

## Verdict

**Not execution-ready — but by three sentences, not another round.**

The architecture is settled and v4 resolves all 23 round‑3 findings correctly; I could not falsify a single safety claim in it this time, and the two things most likely to have broken under the new changes (re-add restoring the entry, and dropping `hasLink` in front of a guard that compares `carried.current`) are both right, with the plan's own reasoning about them accurate.

What still needs fixing before anyone edits the repo is all plan text: **M1** (the D1 message tells a user to destroy real coverage for a date change they didn't make — the only finding here with a user-harm path), **M2** (one ternary arm), **M3** (one sentence reconciling the helper's scope with its test claim). L1, L5 and L6 are worth folding in at the same time since each is a line in an existing list.

Want me to write this up as `~/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-round4-claude.md`? That path already exists and is outside the working directory, so it'll prompt — and I'd overwrite, so tell me if that file is someone else's.
