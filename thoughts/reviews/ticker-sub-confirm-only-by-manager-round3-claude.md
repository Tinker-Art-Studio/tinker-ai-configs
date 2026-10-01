I read v3 in full, both round‑2 reviews, and verified every load-bearing claim against the code. **No files were edited, no tests were run, nothing was deployed.**

---

## Round‑2 resolution audit

| Round 2 | v3 | Verdict |
|---|---|---|
| **Codex B1** — stale-"unconfirmed" form reverses a new confirmation via reconcile | "the one rule" / `checkEditAgainstDocument` | ⚠️ **closes the tab race, but not remove+re-add** (M1) |
| **Codex B2** — D1 bypassed by a confirm mid-save | second check at the carry read + `expect.dates` | ✅ mechanism correct; **the "nothing half-done" justification is false** (B1) |
| **Codex B3** — stale confirm box confirms old dates | `dates` in `expectRequest` + rollback | ⚠️ rollback verified; **guard placement is a data-loss hazard** (B2), comparison not normalized (M2), message unspecified (M4) |
| **Claude B1** — D1 false-refuses legacy date shapes | `normalizeRequestDates` | ✅ round-trips correctly (one edge, L2) |
| Claude M1 — manager-check placement | pinned to `:7856` + owner-Undo BDD | ✅ verified: `js/app.js:7855` closes the un-confirm branch, `:7857` is the roster match |
| Claude M2 — `${dates}` undefined | `Object.keys(appliedOverrides).sort().join(', ')` | ✅ |
| Claude M3 — `:629` wrongly listed as flipping | removed, stated as staying green | ✅ |
| Claude M4 — emulator can't test orchestration | promise withdrawn, exported helpers instead | ✅ |
| Claude M5 — create branch never enforced | `:7493` literal | ⚠️ **order vs `...formData` (`:7497`) unpinned** (M6) |
| Claude M6 — Cancel leaves the dropdown lying | `openTimeOffDetail(requestId); return;` | ✅ |
| Claude M7 — D1 + removal | message + BDD | ✅ |
| Codex M4 — D3 predicate ambiguous | gate at `:7615` + "no record" wording | ✅ verified sound in all five shapes |
| Codex M5 — D2 and the unmatched branch | D2 scoped to matched subs, stated in goal + acceptance | ✅ |
| Codex M6 — `_confirmSubCtx` after Cancel | `closeConfirmSubModal()` + open-check | ✅ |
| Codex M7 / Claude "BDDs enough?" — test sufficiency | expanded | ⚠️ **three gaps** (M3, M5, M7) |
| Codex L8 — absent document in Phase 3 | specified | ✅ |
| Claude L1 / Codex L9 — commit convention | corrected | ✅ `AGENTS.md:41` is exactly `Format: \`type: what changed and why\`` |
| Claude L2/L3/L4/L5/L6 | all folded in | ✅ (L5 wording, L5 below) |

---

## Your v3-specific questions, answered

**"A step-2 refusal leaves nothing half-done" — false, in both branches.** See B1. This is the one claim in v3 I could falsify outright.

**`normalizeRequestDates` — yes, it round-trips.** I checked the load (`js/app.js:7063`: `d.type || 'full'`, `d.partialStart || ''`) against the save (`:7366`: `d.type === 'partial' ? d.partialStart : null`). A legacy `{date, partialStart: ''}` normalizes to `{date, type:'full'}` on both sides; a current-shape `{date, type:'full', partialStart:null, partialEnd:null, flexible:false}` likewise. Partials with real times are stable. One edge in L2.

**The rollback on `field: 'dates'` — yes, it is a full, checked rollback.** `js/app.js:8039` computes `theirs` **only** for `reason === 'sub-changed'`; anything else falls to `:8053` `{ rollBack: appliedOverrides, mismatch: [] }` and `:8054` `removeTimeOffOverrides`, whose result gates the "was rolled back" vs "could NOT be rolled back" wording (`:8060-8061`). So the claim holds. But the *message* doesn't (M4), and the *ordering* of the new guard decides whether you ever land in that branch safely (B2).

**No other `confirmTimeOffSub` caller breaks.** All six call sites: `js/app.js:7865` (`{confirmed,subUid,statuses}`), `:8180` (`{subUid,confirmed}`), `:8241` (no `expectRequest`), `:8816`/`:8912` (via `guard()` at `:8793-8795`, which returns only `subUid`/`statuses`/`reversalPending`). None passes `dates`, so `want.dates === undefined` short-circuits. ✅

**D3's gate change is sound.** I walked all five shapes against `js/app.js:7615`: link-less form-ticked → amber (the point); real record → excluded; `{confirmed, subUid:null, appliedOverrides:REC}` partial-failure (`js/schedule-helpers.js:975-977`) → excluded; `{confirmed, subUid:'x', appliedOverrides:{}}` legacy → amber, correctly; `dismissedOverrides` → `confirmed:false` at `js/app.js:8131`, excluded. Roster branching is right: `resolveSubRosterMatch` returns `no-match`/`ambiguous`/`unclaimed`/`matched` (`js/schedule-helpers.js:195-201`) and only `matched` falls through to the new line today (`notes[match.status]` is undefined for it).

**Phase 3 re-render is correct.** `openTimeOffDetail` rebuilds the `<select>` with `selected` from the stored value (`js/app.js:7741-7746`), so Cancel and a failed write both snap it back. Only caller of `updateCoverageStatus` is that select. The duplicate `renderAdminAllTimeOff()` at `:8253-8254` is real.

---

## BLOCKING

**B1. "A step-2 refusal leaves nothing half-done" is false, and the refusal message it specifies ("so nothing was saved") lies about schedule state.**

Step 2 sits at `js/app.js:7473`, i.e. **after** `reverseConfirmedTimeOffSubs` at `:7459` has already done real schedule writes *and* transactional `confirmed:false` writes to the request document — and possibly a hand-off comment write (`:7466`). Two reachable interleavings:

- *subs-changed:* Ivy removes Sam (confirmed at open, × prompt shown) **and** a manager confirms/un-confirms Kayleigh (still in the form) between the `:7411` read and the `:7473` read. Step 1 passes; Sam's reversal lands; step 2 refuses on Kayleigh.
- *dates:* same removal of Sam, and another tab changes the request's **dates** between the two reads while some sub is confirmed. v3's argument — *"a confirmed sub plus a date change is refused at step 1, so when step 2 refuses on dates, no sub was confirmed at step 1 and no reversal ran"* — only covers the case where **the form** changed the dates. If the **document's** dates moved, `normalizeRequestDates(formDates) ≠ normalizeRequestDates(docDates)` becomes true at step 2 with no date edit by this user, after reversals landed.

The plan's message is *"…so nothing was saved. Close this form, reopen the request, and try again."* The existing transaction refusal at `js/app.js:7485` is carefully worded for exactly this — *"Any sub coverage removed above stays removed"* — and v3 asserts that wording "already covers that". It doesn't: `:7485` belongs to the transaction path, not to the new check.

Fix: the step-2 refusal must carry the `:7485` clause (and the `reset` variant is not needed, since this is the non-reset branch). One sentence of plan text, plus a BDD: *"a removal whose reversal landed, then a step-2 refusal → the message says the coverage stays removed."*

**B2. The new `dates` guard in `confirmTimeOffSub` must go *after* the `confirmed`/`subUid` checks, or it opens the blind-rollback path the code was rewritten to prevent.**

v3 says the guard is added at `js/firebase-data.js:799–803`. `:799` is `const want = expectRequest || {};` and `:803` is the `confirmed` check. Grouping it with the other request-level guards (right after `want.statuses`, the natural reading) is wrong:

If a second manager confirms the same sub **and** the dates changed, the transaction would return `reason:'changed', field:'dates'` instead of `sub-changed`. `js/app.js:8039` then never computes `theirs`, `:8053` takes `rollBack = appliedOverrides` whole, and `:8054` deletes the dates off the sub's schedule. When this tab's `subSchedule` read at `:7961` predates the other manager's write, the captured `previousOverride` is `null` (`:8005-8011`) — so the rollback **deletes the other manager's confirmed coverage shift**. That is verbatim the trap `partitionRollback` exists for (`js/schedule-helpers.js:1051-1059`, the comment at `js/app.js:8030-8037`).

The proposed ratchet (*"`expectRequest` includes `dates`"*) passes either way, as does the wiring slice at `schedule-editor-wiring.test.js:1406` (individual `toMatch`es, not ordered). Fix: state "after the `confirmed` check at `:803`" and add an ordered assertion (`guards.indexOf("field: 'confirmed'") < guards.indexOf("field: 'dates'")`), plus an emulator case: dates changed **and** the entry confirmed by someone else → `sub-changed`, not `changed`.

---

## MEDIUM

**M1. `reconcileEditedProposedSubs`'s un-tick branch is still reachable from a current page: remove a confirmed sub with ×, then re-add them.** `addTimeOffSub` (`js/app.js:7280-7285`) pushes `confirmed: false`, and the duplicate guard at `:7275` no longer applies once the entry was spliced out. So: form has Sam `confirmed:false`; `openedSubs` says Sam `true`; the document says Sam `true` → v3's subs-changed test compares **document vs `openedSubs`**, which agree, so step 1 passes; `js/schedule-helpers.js:991-997` then queues Sam in `toReverse` and his shift is reversed. v3's claim that *"its 'un-ticked' branch is only reachable from an old cached page"* is wrong, and *"the edit form has no say over `confirmed`"* is wrong with it. The × prompt did warn, but a user who re-adds the person reasonably believes they undid it. Cheapest fix, given `openedSubs` already exists: when re-adding a name that `openedSubs` says was confirmed, restore `confirmed: true` on the form entry (then reconcile carries the link and nothing reverses). Needs a BDD either way.

**M2. Phase 2's `dates` guard uses raw `sameStructure`, not `normalizeRequestDates` — so it false-refuses on exactly the legacy population B1 (round 2) was about.** `sameStructure` (`js/schedule-helpers.js:1042-1048`) maps `undefined → null` but treats `'' ≠ null` and `undefined ≠ 'full'`. A manager opens the confirm box on a legacy request (`{date, partialStart:''}`, no `type`); the requester saves an unrelated reason edit, which rewrites `dates` through `:7363-7369` into the normalized shape; the manager clicks Confirm → schedule written, transaction refused, rollback, generic error. The dates never changed. Same for a `flexible` toggle on any request, which D1 deliberately permits (`flexible` is dropped from `normalizeRequestDates`) but this guard would refuse. It self-heals on retry and loses no data, but the two comparisons should use one rule: pass `normalizeRequestDates(req.dates)` as `expectRequest.dates` and compare the normalized document value inside the transaction.

**M3. Three existing wiring ratchets go red and are not in the "Updated on purpose" list.** The plan names only `schedule-helpers.test.js:733`/`:737` and `schedule-editor-wiring.test.js:1564`. Also breaking:
- `schedule-editor-wiring.test.js:1625` — one contiguous `\s*`-joined regex covering `carryCurrentSubs(editingTimeOffId, subs)` … `saveGuard = { statuses: [existingData.status], expect: { proposedSubs: carried.current, appliedOverrides: requesterRecord } };`. Both the step-2 insertion and `dates: carried.currentDates` land inside it.
- `schedule-editor-wiring.test.js:1645` — pins `return { subs: carryConfirmedSubs(subs, current.data.proposedSubs), current: currentSubs };` verbatim; adding `currentDates` breaks it.
- `schedule-editor-wiring.test.js:1562` — pins `}, {}, { confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES });` in the `submitConfirmSub` slice; adding `dates:` breaks it.

`:1614` (reset branch) and `:1635` (`giveBack`) stay green, and round 2's "outside both ratchet slices" observation is still true for **step 1** only (the slice at `:1620` starts *at* the reconcile line). Given the repo's own resume note — *"rule out a stray worktree before trusting a red run"* — an executor hitting three unexplained reds is the most likely way this derails.

**M4. Phase 2 promises the manager a specific sentence the Changes section never produces.** Acceptance: *"This request's dates changed while the box was open. Nothing was confirmed; close and reopen it."* But `lead` at `js/app.js:8056-8058` is a two-way ternary on `theirs`, so a `field:'dates'` refusal yields *"Could not confirm — this request may have changed."* The Changes list doesn't touch `lead`. Either drop the promised wording or say `lead` becomes reason-aware, and pin it (`schedule-editor-wiring.test.js:1589-1593` already pins the other two leads, so the new one belongs beside them).

**M5. Phase 2's key derivation claim has no ratchet, and a partial implementation passes everything but the click-through.** The acceptance rests on `overridesToWrite` being built from the ticked dates — `js/app.js:7968` `for (const dateStr of ctx.dates)`, from which conflicts (`:7976`), `appliedOverrides` (`:8011`), `writtenDates` (`:8079`) and `reminderDates` (`:8084`) all derive. The only listed test is the pure `confirmDatePreticks`. An implementation that renders checkboxes but keeps feeding `getSubCoverageDates(...)` into `ctx.dates` passes every unit test and every listed ratchet. Add a ratchet pinning that `ctx.dates` is assigned from the checked inputs inside `submitConfirmSub`, before the `overridesToWrite` loop.

**M6. The create-branch guarantee depends on an ordering the ratchet can't see.** `proposedSubs: formData.proposedSubs.map(s => ({ ...s, confirmed: false }))` must sit **after** `...formData` at `js/app.js:7497`. Placed before it, the spread silently wins and the acceptance line is false again — and *"the create branch forces `confirmed: false`"* matches the source either way. Pin the order.

**M7. A ticked date that produces no override is still dropped silently.** `js/app.js:7973` `if (!override) continue;` — when the requester has no recurring shift that day. Today that date was never explicitly chosen; after D2 the manager ticked it, and nothing is written, `appliedOverrides` omits it, and the email omits it (`:8079`). D2 turns an inference into a promise, so a ticked-but-unwritable date now needs naming ("no shift to copy for Oct 5 — nothing was written for it"). One acceptance line + one BDD.

**M8. The step-2 exclusion is keyed on "removed", which is broader than the reason for it.** v3 excludes subs the form removed *"because their reversal legitimately un-confirmed them"* — but only subs in `toReverse` were reversed. A sub the form removed who was **unconfirmed** at step 1 and gets confirmed by a manager between the two reads is never reversed, is excluded from the check anyway, and is then re-appended whole by `carryConfirmedSubs` (`js/schedule-helpers.js:1027-1032`) and saved, with a "Request saved" toast and the removal silently dropped. That's the mid-save variant of the plan's own *"Edge (round-2 race, removal) → refused"* BDD. Key the exclusion on `new Set(toReverse.map(t => t.name))`, not on absence from `formSubs`.

---

## LOW

**L1.** The step-1 and step-2 refusals need `giveBack()` before returning, or the Save button stays `disabled` reading "Saving…" — the D1 BDD says *"the form stays open"*, which invites exactly that. Every other early return does it (`js/app.js:7443`, `:7474`, `:7484`); `:7635` pins the helper.

**L2.** `normalizeRequestDates` does not rescue one legacy shape: a stored `type: 'partial'` with empty/missing times. The form's own validation at `js/app.js:7338-7342` forces times in, which *is* a date change, so D1 refuses — and the only way to edit that request's reason is to Undo a sub you wanted to keep. Rare (needs a hand-edited/migrated partial), worth one sentence in the D1 refusal path or an explicit "known limit".

**L3.** `currentDates` must use the repo's existing absence idiom — `current.data.dates === undefined ? null : current.data.dates`, mirroring `currentSubs` at `js/app.js:8727` and `requesterRecord` at `:7414`. `current.data.dates || []` would make `sameStructure(null, [])` refuse every save on a dates-less document (`js/firebase-data.js:866-868`).

**L4.** The × prompt's *"Sam is confirmed and has this shift on their schedule"* is false for a record-less legacy confirmation — the Ivy population. The form's entries carry no `appliedOverrides` (`js/app.js:7068`), so the prompt can't tell; extend `openedSubs` to `name → { confirmed, hasRecord }` and word it conditionally. Same for the chip: *"Confirmed by a manager"* is a lie on a legacy form-ticked sub. Related: `js/app.js:8214` correctly skips record-less subs in the reversal, so the outcome is fine — only the wording overstates.

**L5.** The trap box says `updateCoverageStatus` is a page global *"whose role check runs in the browser"*. There is no role check in it at all (`js/app.js:8250`); only the `<select>` is gated (`:7740`). Say that.

**L6.** `openedSubs` should be reset at the top of `openTimeOffForm` alongside `timeoffFormDates`/`timeoffFormSubs` (`js/app.js:7020-7021`), not only in the edit branch.

**L7.** `openedSubs` is name-keyed, so two proposed subs with the same name collapse. Consistent with `reconcileEditedProposedSubs`'s `findIndex` (`js/schedule-helpers.js:989`) and `carryConfirmedSubs`'s (`:1030`), so it introduces nothing new — worth one line as a known shared assumption.

**L8.** `schedule-helpers.test.js:736`'s title (*"a sub the form newly ticked … stays ticked"*) and `:733`'s comment (*"but a newly ticked entry (no link) is the form's decision and stays"*) both become false statements once `hasLink` is dropped. The plan flips the assertions; say the titles/comments are rewritten too.

**L9.** Phase 3's "request no longer exists" branch writes nothing but leaves the lying dropdown on screen. Call `openTimeOffDetail(requestId)` there too (it renders "Request not found", `js/app.js:7549`).

**L10.** The Phase 3 warn box lists Secured/Partial/Pending; `confirmTimeOffSub` (`js/firebase-data.js:805-807`) also clobbers a manual `not_needed`. One word.

---

## Are the BDDs/tests enough to catch a partial implementation?

Phase 1: close, once B1's message and M1/M8's cases are added. The move to real exported helpers (`checkEditAgainstDocument`, `normalizeRequestDates`) is the right answer to round-2 M4 and does give genuine coverage, because those are the production functions.

Phase 2: **not yet** — M5 is the hole. `confirmDatePreticks` proves the pre-ticks and nothing downstream, and the ratchet list has no assertion tying `ctx.dates` to the checkboxes. Also no ordered assertion for B2, and nothing pins M4's message.

Phase 3: adequate. `unconfirmedSubNames` + the Cancel/re-render ratchet + the BDDs cover it.

D3: the only coverage is one source ratchet plus the click-through. Every other new predicate in this plan became an exported pure helper; the roster-status → note mapping should too (`subMissingWriteNote(sub, roster)`), and then the five shapes in the Phase 1 Changes bullet become five unit assertions instead of prose.

---

## Verdict

**Not execution-ready.** Two BLOCKING: B1 is a false safety invariant that the plan uses as its justification *and* specifies a message that misstates schedule state; B2 is a one-line ordering detail whose wrong reading deletes a colleague's confirmed shift. Both are cheap — a clause borrowed from `js/app.js:7485`, and a sentence naming the position after `js/firebase-data.js:803`.

The architecture is right and better than v2: "the one rule" genuinely collapses three races into one check, `normalizeRequestDates` round-trips, the `field:'dates'` rollback really is full and checked, and D3's gate is sound in all five shapes. M1–M3 are the three I'd want fixed before anyone touches the repo — M1 because it falsifies the plan's headline claim, M2 because it repeats round 2's own BLOCKING in the other phase, M3 because three unexplained red ratchets is how this goes wrong in practice.

Want me to write this up as `~/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-round3-claude.md`? That's outside the working directory, so it'll prompt for approval.
