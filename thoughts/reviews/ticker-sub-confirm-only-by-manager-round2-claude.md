I read v2 in full, both round-1 reviews, and verified every claim against the code. **No files were edited, no tests were run, nothing was deployed.**

## Round-1 resolution audit

| Round 1 | v2 | Verdict |
|---|---|---|
| **Claude BLOCKING 1** — `carryConfirmedSubs` keeps a link-less form `confirmed` | drop `hasLink` | ✅ **correct, and I verified it's safe** (below) |
| **Claude MED 2** — missing-write detector blind | D3 | ✅ |
| **Claude MED 3** — Phase 2 widened dates, no way to narrow | D2 | ✅ |
| **Claude MED 4 / Codex MED 7** — Phase 3 stale list | fresh read | ✅ (one gap, M6) |
| **Claude MED 5** — tests that go red | named | ⚠️ one named wrongly (M3); `:497-500` correctly kept green |
| **Claude MED 6** — form loses the confirmed cue | chip + × prompt | ✅ |
| **Claude LOW 12** — `updateCoverageStatus` has no role check | — | ❌ **the only round-1 item with no answer in the Decisions Log** (L5) |
| **Codex BLOCKING 1/2** — goal over-promised schedule+email | reworded | ✅ |
| **Codex BLOCKING 3** — date change on confirmed sub | D1 | ⚠️ decision right, spec incomplete (**B1**) |
| **Codex BLOCKING 4** — reset path does change `confirmed` | corrected + BDD | ✅ |
| **Codex MED 5** — UI-only enforcement | trap box + both guards | ✅ (placement bug, M1) |
| **Codex MED 6** — overwriting dates erases subsets | D2, no stored change | ✅ |
| **Codex MED 8** — suites don't prove the claim | corrected | ✅ (replacement can't either, M4) |
| **Codex LOW** — commit prefix | "Codex was wrong" | ❌ **answered wrongly** (L1) |

---

## Your three v2-specific questions, answered first

**Dropping `hasLink` — safe. I traced every path that reaches it.** `carryConfirmedSubs` is called only from `carryCurrentSubs` (`js/app.js:8720`), from the two edit branches (`:7442`, `:7473`) — never on create. In the four ways a form entry can arrive with `confirmed: true`:

- prior confirmed **and** linked → `reconcileEditedProposedSubs` attaches the link (`js/schedule-helpers.js:994`); if the doc still confirms, the re-append loop (`:1027-1033`) overwrites it from `current` anyway — unchanged. If the doc doesn't, it strips — unchanged (that's today's `hasLink` branch).
- prior confirmed, **link-less** (Ivy's legacy shape) → today survives a doc that says unconfirmed; after the change it's stripped. **This is the whole point and it's the only behaviour that changes.**
- prior absent or unconfirmed → `js/schedule-helpers.js:991` returns `s` untouched; doc says unconfirmed → now stripped. Correct: nothing on the schedule.
- reset path → `js/app.js:7442` already forces `confirmed: false`, so the first map is a no-op there.

**No path un-confirms real coverage.** A rename can't produce a false negative: names come from the document (`:7068`), and a re-added sub is born `confirmed: false` (`:7284`), so `confirmedNow`'s name key can't drift. Brand-new requests never call the carry. Existing unit cases `:703`, `:709`, `:714`, `:719`, `:728`, `:731`, `:738`, `:743` all still pass; only `:733` and `:737`-first flip, exactly as v2 says. One unstated side effect worth a line in the plan: a stripped link-less entry now gains `subUid: null, appliedOverrides: {}` keys it never had. Firestore-safe (null, not undefined), and it doesn't touch the saveGuard, which compares `carried.current`, not `carried.subs`.

**D3's condition — no false positives found.** `submitConfirmSub` returns at `js/app.js:7981` when `overridesToWrite` is empty, so a matched confirm can never land with an empty `appliedOverrides`. `dismissedOverrides` entries are `confirmed: false` (`:8131`). The `{confirmed, subUid: null, appliedOverrides: REC}` state that partial failures leave — modelled at `js/schedule-helpers.js:975-977` — is excluded by the `appliedOverrides` clause. The condition is sound.

**D1 placement is right.** `existingData` is read fresh at `js/app.js:7411`, before the branch, and the check sits before `reconcileEditedProposedSubs` at `:7455`, so it precedes every reversal. It also lands outside both wiring-ratchet slices (`schedule-editor-wiring.test.js` slices from `const { subs, toReverse } = …`), so no existing regex breaks.

---

## BLOCKING

**B1. D1's `requestDatesChanged` has no normalization rule, and will falsely refuse *every* save on the legacy documents D1 gates on.**

The plan defines "differ" as *"the set of `{date, type, partialStart, partialEnd}` changes"*. That comparison is not round-trip stable:

- `js/app.js:7063` loads a doc's dates as `type: d.type || 'full'`, `partialStart: d.partialStart || ''`
- `js/app.js:7366-7367` saves them as `partialStart: d.type === 'partial' ? d.partialStart : null`

So a legacy or migrated doc storing `partialStart: ''` or omitting `type` compares **unequal to itself** after one load/save round-trip. D1 fires on any doc with a confirmed sub — which is precisely the population of old requester-ticked requests D3 exists to surface. Ivy edits only her reason and is refused with *"Sam is confirmed to cover this request. Ask a manager to Undo Sam first, then change the dates"* — a message that is false, about a change she didn't make, with no way to satisfy it except un-confirming a sub she wanted to keep.

Fix is small: normalize with the repo's own `sameStructure` (`js/schedule-helpers.js:1042`, already exported at `:1520` — "undefined and null are the same absence"), extend it to treat `''` as absent, and add a BDD: *"a legacy request whose dates lack `type`/`partialStart`, edited for reason only, saves normally."* None of the current BDDs would catch this.

---

## MEDIUM

**M1. The manager-check placement instruction contradicts Phase 1's own acceptance, and the proposed ratchet cannot catch the wrong reading.** The plan says *"at the top of the confirm branch of `handleSubConfirmToggle`, right after the status check (`:7850`)"*. Those are two different places: `js/app.js:7852-7855` is the **un-confirm** branch, sitting between them. A check at `:7851` kills the owner's Undo, contradicting *"Undo on a confirmed sub is unchanged"* two bullets earlier — and for a record-less legacy confirmed sub the requester could have cleared it themselves (`:8132` `has` is false → no hand-off). With D1 also refusing their date edits, that's a deadlock needing a manager for something no manager step exists for. The ratchet as specified (*"the manager check precedes the roster match"*) passes at `:7851` and at `:7856` alike. Say `:7856`, and add a BDD for the owner's Undo.

**M2. `dates` is an undefined identifier at `js/app.js:8044`.** Inside the branch that exists to *avoid* a dangerous blind rollback: `` `Your shift write for ${dates} may still be on…` ``. `submitConfirmSub` spans `:7939-8101` and declares no `dates` (the one at `:7903` is block-scoped inside `openConfirmSubModal`); there is no global — I grepped every declaration in `js/`. It throws a ReferenceError caught at `:8095`, so the careful message is replaced by *"Something went wrong confirming this sub."* Pre-existing, no data loss, but it's in the exact function Phase 2 rewrites and the plan claims Phase 2 "only narrows which dates go into the existing payload". `Object.keys(appliedOverrides).sort().join(', ')` fixes it.

**M3. The Tests section gives licence to weaken a test that should stay green.** `schedule-helpers.test.js:629-635` is a **`reconcileEditedProposedSubs`** test (*"a sub never confirmed with a real write passes through unchanged"*), inside `describe('reconcileEditedProposedSubs')`. v2 explicitly leaves reconcile alone — so this test does not flip. It is listed under *"Updated on purpose (each is a decision this plan reverses)"*, next to two `carryConfirmedSubs` cases that genuinely do. Round-1 Claude cited it as evidence of the bug, not as a test to change. Drop it from that list; only `:733` and `:737` flip.

**M4. The promised new emulator test cannot test what it promises.** Codex's finding was *"the existing suites do not exercise `handleSubmitTimeOff`'s edit orchestration"*. In this repo, emulator tests **re-implement** the logic: `timeoff-sub-confirm.emulator.test.js:8-12` says so outright (*"can't be `require()`'d outside a browser… exercises the real write SHAPE directly"*), and re-declares `sameStructure` and `confirmTimeOffSub` verbatim at `:36` and `:50`. A new one would re-implement the edit orchestration too — proving the shape, not that `app.js` does it. The real coverage here is (a) the unit tests on `carryConfirmedSubs`, which **is** the real exported function, and (b) a source-shape ratchet. Say that instead of promising behavioural coverage the harness can't give.

**M5. Phase 1's "every sub on a new request is saved unconfirmed" is never enforced, and cheaply could be.** The plan is right that hard-coding at `js/app.js:7372` would break reconcile — but `formData` is shared, and the **create** branch (`:7493-7509`) has its own literal. `proposedSubs: formData.proposedSubs.map(s => ({ ...s, confirmed: false }))` there closes the stale-service-worker hole on new requests (`sw.js:64`, `CACHE_NAME = 'tinker-ticker-v24'` is a manual bump) with no effect on the edit paths. Right now that acceptance line is a description of the UI, not a guarantee.

**M6. Phase 3's "the dropdown snaps back" has nothing behind it.** `updateCoverageStatus` is fired from the select's inline `onchange` (`js/app.js:7741`); the DOM value has already changed by then. A bare `return` on Cancel leaves the dropdown reading "Secured" while the document says "Pending" — the lying label this phase exists to fix. Round-1 Claude's suggested ratchet was `if (!confirm(…)) { openTimeOffDetail(requestId); return; }`; v2's ratchet kept only *"returns before `updateTimeOffRequest`"*, which a lying-dropdown implementation passes. Related: Phase 3 is the only phase with no **Changes** section, and no test is listed for the failed-write message or for "names only the unconfirmed subs" (both are BDDs).

**M7. D1 refuses a save that *removes* the confirmed sub, with a message about dates.** The × prompt promises *"Removing Sam takes it off and tells a manager"*, but if the manager also changed a date in the same edit, D1 fires first (correctly — nothing half-done) and refuses the whole save telling them to Undo Sam. Two saves are required. Worth one acceptance line and a BDD; otherwise the first person to hit it reports the × prompt as broken.

---

## LOW

**L1. The commit-prefix answer is wrong, and wrong by a citation I can check.** Resume step 2: *"there is no `type:` prefix convention (checked against AGENTS.md; Codex's LOW was wrong here)."* `AGENTS.md:41` reads: `Format: type: what changed and why (fix, feat, refactor, docs, chore)`. The recent log is plain prose, so *practice* diverges — but the plan asserts the document says something it does not. Either follow AGENTS.md or say the convention is documented and not followed, and why.

**L2.** `#confirm-sub-dates` is a `<span>` inside a `<p>` (`index.html:1186`) written via `textContent` (`js/app.js:7920`). D2 needs a real container and `innerHTML` with escaped labels; the plan says "renders checkboxes into `#confirm-sub-dates`" as if it were a drop-in.

**L3.** After D2, `submitConfirmSub` has two refusals for "nothing to write" — the new "Tick at least one date" and the existing *"This sub has no covered dates to write a shift for"* (`:7953`), which now only fires when the request itself has zero dates. Say which is which.

**L4.** D3 needs the **gate** at `js/app.js:7615` changed (`s.confirmed && !s.subUid` → also `&& !Object.keys(s.appliedOverrides || {}).length`), not just a `matched` key in the notes map. The Phase 1 Changes bullet states the full condition; the D3 decision text doesn't, and the map-only reading produces a false amber line on the partial-failure state.

**L5.** Round-1 LOW 12 is unanswered: `updateCoverageStatus` is a global with no role check; the select is only *rendered* under `isAdmin` (`:7740`). Same UI-only posture as Phase 1 — one sentence in the trap box.

**L6.** `_confirmSubCtx.dates` and the checkboxes are built from the modal-open read (`:7842`); `confirmTimeOffSub`'s guard (`js/firebase-data.js:799-803`) checks status/confirmed/subUid but never the request's dates. A date removed in another tab while the box is open still gets written. Pre-existing, but D2 turns an intersection into a manager's explicit choice, so it's now a choice made against stale options.

---

## Are the BDDs/tests enough to catch a partial implementation?

Not yet — close on Phases 1–2, thin on 3. Missing, in priority order: a legacy date-shape case for D1 (B1); an owner-still-has-Undo case (M1); a Phase 3 Cancel case asserting the dropdown's rendered value, not just the absence of a write (M6); a Phase 3 failed-write case; a "warning names only the unconfirmed subs" test; and a D3 case for the `{confirmed, subUid: null, appliedOverrides: REC}` state (L4). The `carryConfirmedSubs` unit tests as specified — "document authoritative in both directions" — are genuinely sufficient for the BLOCKING-1 fix, because that helper is real and directly exported.

## Verdict

**Not execution-ready — but much closer than v1.** The architecture is right: dropping `hasLink` closes defect 1 properly, D2 is a strictly better answer than v1's date overwrite, and D3 is well-conditioned. One BLOCKING (B1) will ship a user-facing false refusal as specified. M1, M3, M5 and M6 are each one or two sentences of plan text; M4 is a promise to withdraw. Fix those and I'd call it ready.

Want me to write this up as `ticker-sub-confirm-only-by-manager-round2-claude.md` beside the round-1 reviews? That's outside the working directory, so it'll prompt for approval.
