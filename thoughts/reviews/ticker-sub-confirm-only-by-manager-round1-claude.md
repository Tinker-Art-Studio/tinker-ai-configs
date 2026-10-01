I read the plan in full and verified it against the code. **No files were edited and no tests were run.**

## Factual verification

Every line reference checks out except two:

| Claim | Verdict |
|---|---|
| `:7295` toggle, `:7318` checkbox, `:7372` save, `:7283` dates captured once, `:7068` edit-load map | ✅ exact |
| `:7608` `canToggle` includes `isOwner`, `:7615` amber note gated on match failure, `:7953` refusal, `:7988` overwrite prompt, `:8015` schedule write, `:8250` `updateCoverageStatus` | ✅ exact |
| `schedule-helpers.js:209` `getSubCoverageDates`, `index.html:722` coverage-notes placeholder | ✅ exact |
| Rules: staff may update **any field** of their own request (`firestore.rules:446-447`); `timeclock_schedules` manager-only write (`:421`) | ✅ exact — Phase 1 is honestly labelled a UI-only guarantee |
| "It stops before any write, so nothing is left half-done" | ✅ `js/app.js:7952` precedes the `loadSchedule` at `:7961` and `saveSchedule` at `:8015` |
| "`:7876` already uses this fallback" | ⚠️ the fallback is at the **call site** (`js/app.js:7885`, `coverageDates.length ? coverageDates : requestDates`), not in `getSubCoverageDates`. Phase 2 makes `:7885` dead code. |
| Phase 1 names `carryConfirmedSubs` | ⚠️ app.js calls `carryCurrentSubs` (`js/app.js:8720`), which wraps the helper at `js/schedule-helpers.js:1020`. Grep the wrapper or you'll miss the call site. |
| Defect #4: the requester's Mark Confirmed "can never succeed" | ⚠️ true only for a **matched** sub. For an unmatched/unclaimed name the confirm path at `js/app.js:7865` **succeeds** (no schedule write, owner may write their own timeoff doc) and produces defect #1's exact state by a second route. Put the Phase 1 guard right after the status check at `:7850`, before the `resolveSubRosterMatch` at `:7857`, so it covers both branches. |

---

## BLOCKING

**1. Phase 1's core premise is wrong: the save can still turn an unconfirmed sub into `confirmed: true`, with no shift and no email.**

The plan says *"With nothing able to flip it, the save carries it through, and `reconcileEditedProposedSubs` / `carryConfirmedSubs` behave as before."* They don't. `carryConfirmedSubs` treats a form entry with `confirmed: true` **and no link** as authoritative and keeps it, precisely because the form used to be allowed to tick:

- `js/schedule-helpers.js:1023-1026` — `hasLink(s)` requires `subUid`/`appliedOverrides`; a link-less `confirmed: true` is never stripped.
- `schedule-helpers.test.js:732-733` — *"but a newly ticked entry (no link) is the form's decision and stays"* → asserts `confirmed` stays `true` while the document says `false`.
- `schedule-helpers.test.js:736-737` — *"a sub the form newly ticked (confirmed, no write) stays ticked"*.
- `schedule-helpers.test.js:629-634` — *"confirmed via the form checkbox only, no subUid"* passes through unchanged.

Reachable today with no stale bundle, just two tabs:

1. Ivy opens Edit; `js/app.js:7068` loads `confirmed: true` for Sam.
2. A manager Undoes Sam in another tab (shift reversed, entry cleared).
3. Ivy saves. `existingData.proposedSubs[0].confirmed` is now `false`, so `reconcileEditedProposedSubs` hits `js/schedule-helpers.js:991` (`if (!prior || !prior.confirmed) return s;`) and returns the **stale `confirmed: true`**. `toReverse` is empty, so `reverseConfirmedTimeOffSubs` does nothing. `carryConfirmedSubs` leaves it (no link). The saveGuard compares against `carried.current`, which nobody changed between the fresh read and the save (`js/firebase-data.js:865-869`), so it **passes**.
4. Sam is back to green "Confirmed", no `subUid`, no shift, no email — and the manager sees Undo, never Mark Confirmed. The exact Ivy defect, restored by the save.

This violates the plan's own Phase 1 acceptance: *"one that wasn't stays unconfirmed."*

Tightest fix — drop the `hasLink(s)` condition at `js/schedule-helpers.js:1024` so the **document** is authoritative for `confirmed` in both directions:

```js
const out = (subs || []).map(s => (s.confirmed && !confirmedNow.has(s.name))
  ? { ...s, confirmed: false, subUid: null, appliedOverrides: {} }
  : s);
```

Leave `reconcileEditedProposedSubs` alone — its un-tick→`toReverse` branch stays as defence in depth for a stale bundle. Verified against every existing `carryConfirmedSubs` case: `:704`, `:720`, `:729`, `:738` all still pass; `:733` and `:737` flip, and should. Do **not** instead hardcode `confirmed: false` at `js/app.js:7372` — reconcile would then read every confirmed prior as un-ticked and reverse real coverage on an unrelated edit.

---

## MEDIUM

**2. The missing-write detector stays blind, so existing bad entries stay invisible forever.** The plan names this in defect #1 (*"only fires when the roster match FAILS, so with a good match there is no warning at all"*) and then no phase fixes it. `js/app.js:7615-7625` gates the amber note on `resolveSubRosterMatch(...).status !== 'matched'`. With no backfill, Ivy's request and any other record-less confirmed sub keep a bare green badge permanently — and that's also your only net against a stale service-worker copy still submitting `confirmed: true` on a *new* request, which Phase 1 cannot reach. Add a `matched` case to the `notes` map: *"Confirmed, but no shift was written to their schedule — add it by hand, or Undo and use Mark Confirmed."* This is a render-time change, not a backfill — the same reasoning the plan already accepts for the Phase 2 fallback.

**3. Phase 2 widens what gets written to another person's schedule, with no way to narrow it.** Two things:
- *"so no choice is lost"* is inaccurate. `js/app.js:7283` captures the dates present **when the sub was added**, so adding Kayleigh, then adding Oct 4, then adding Shelley already produces per-sub subsets today. `index.html:722`'s own placeholder describes exactly that case (*"she can cover Tuesday but not Wednesday"*).
- The confirm modal (`index.html:1179-1205`) offers only full/custom **times** — no date selection. After Phase 2 the manager confirms all request dates or nothing. Worse, if a date trips the overwrite prompt at `js/app.js:7986-7991` and they decline, the `return` abandons the **whole** `saveSchedule` payload (`:8015`), including the dates that were fine. And declining is now more common, because `existingShift` at `:7975` matches the sub's *own* normal shift — so a careless OK replaces Shelley's real Tuesday with a coverage shift.

  Recommend per-date checkboxes in the confirm modal (defaulting to all of the request's dates) as part of Phase 2. That makes Phase 2 strictly better than today instead of a trade.

**4. Phase 3 reading `allTimeoffRequests` is unreliable, and this repo already decided that.** `openTimeOffDetail` reads the request **fresh** (`js/app.js:7548`) into a local `req` and discards it; `allTimeoffRequests` is only refreshed on this tab's own actions — never on modal open, never on a timer. So the view shows fresh data while the warning would be computed from a possibly hours-old copy. The precedent is explicit at `js/app.js:8274`: *"Read FRESH (review finding: the in-memory list can be hours old…)"*, and `overlappingFlaggedRequest` (`:8280-8294`) does exactly that. Two further traps: `getAllTimeOffRequests` orders by `submittedAt` (`js/firebase-data.js:719-721`), so any document lacking that field is **silently absent** — disproportionately the legacy docs most likely to hold a record-less confirmed sub — and it returns `[]` on any read error (`:723-726`). Use `getTimeOffRequestResult(requestId)`; it's one doc read and already three-state, which also makes the Failure BDD honest ("could not be read" ≠ "not in the list").

**5. Two existing jest assertions will go red, and the plan doesn't say so.**
- `schedule-editor-wiring.test.js:1564` pins the exact text `const canToggle = (isOwner || isAdmin) && [...]` — Phase 1 changes that line.
- `schedule-helpers.test.js:497-500` asserts `dates: []` → `[]`, named *"an empty array dates field means zero coverage dates, **distinct from the legacy-string fallback**"*. Phase 2 deliberately reverses an invariant this test was written to protect. Record that reversal in the Decisions Log the way you recorded the Aug 29 one, and say why the distinction no longer earns its keep — otherwise the next session reads the flip as a regression.
- Plus the three from finding 1: `schedule-helpers.test.js:629-634`, `:732-733`, `:736-737`.

**6. Phase 1 removes the requester's only cue that coverage exists, while leaving `×` armed.** The checkbox label at `js/app.js:7317-7320` is the *only* place the form shows a sub's confirmed state. Delete it and a requester editing their request sees Sam as an ordinary row with an `×` — and removing Sam triggers a real schedule reversal and a manager hand-off (`js/app.js:7459-7472`). The plan's acceptance says *"Removing a sub with × still reverses its coverage as today"*, which is exactly why the cue has to survive: render a read-only "Confirmed — arranged by a manager" chip, and a `confirm()` on removing a confirmed sub.

---

## LOW

**7.** Phase 2's acceptance (*"a saved sub's dates are the request's dates at the moment of saving"*) won't hold for a re-appended sub: `js/schedule-helpers.js:1031` pushes `{ ...cur, ...carried }`, carrying the **document's** stale `dates`. Apply the dates rewrite after `carryCurrentSubs` (`js/app.js:7444` / `:7475`) rather than at `:7372`, or narrow the wording.

**8.** `js/app.js:7885`'s `coverageDates.length ? coverageDates : requestDates` becomes dead once the fallback moves into the helper. Collapse it, or the next reader will think two fallbacks are needed.

**9.** `coverageStatus` is auto-derived inside the confirm transaction (`js/firebase-data.js:805-807`: all → `secured`, some → `partial`, none → `pending`). A manager's manual "Secured" is silently recomputed by the next Mark Confirmed or Undo. Phase 3's warning is still right, but say in the plan that the label isn't sticky — otherwise Christie will report "Secured reverted by itself" as a new bug.

**10.** `js/app.js:8253-8254` calls `renderAdminAllTimeOff()` twice. Phase 3 edits this function; drop the duplicate.

**11.** Phase 2's Failure BDD (*"a request with no valid dates at all"*) is unreachable for new saves — `js/app.js:7332` refuses. It describes legacy/hand-edited docs only. Keep the unit case, fix the wording.

**12.** `updateCoverageStatus` is a global with no role check; the select is only *rendered* under `isAdmin` (`js/app.js:7740`). Same UI-only posture as Phase 1, worth one sentence next to the existing rules note.

---

## Answers to your specific questions

**Do the edit paths still behave correctly?** The reset path (`:7440-7448`) does — it forces `confirmed: false` itself and never consults the checkbox. The non-reset path (`:7455-7476`) does **not**, per finding 1. Nothing is *stranded* by the un-tick becoming unreachable: removal still queues `toReverse` (`js/schedule-helpers.js:1000-1002`), and owner Undo on a record-less sub works (`has` is false at `js/app.js:8132`, so it skips the hand-off and clears). The `saveGuard` is unaffected.

**Is hiding Mark Confirmed + guarding `handleSubConfirmToggle` sufficient?** Those are the only two places that set `confirmed: true` directly (`js/app.js:7865`, `:8024`) — I checked every write of the flag. But it's not sufficient, because the **save path** (`:7372` → reconcile → carry) is a third route. Fix finding 1 and the set is closed.

**Is overwriting `dates` on every save safe?** `sub.dates` has exactly four readers: `:7068`, `:7372`, and `getSubCoverageDates` at `:7881` and `:7903`. No email, reminder, reversal or overlap logic reads it — `overlappingFlaggedRequest` (`:8285-8293`) and every reversal path key off `appliedOverrides`, as their comments claim. So the fallback's blast radius is (a) the no-match confirmation email's date list and (b) `ctx.dates` in the confirm modal, which decides **what gets written to another person's schedule**. (b) is the one that needs the per-date control in finding 3; otherwise the fallback is safe on both callers.

**Are the BDDs enough to catch a partial implementation?** No. Missing, in priority order: an emulator test for finding 1 (open the form, un-confirm the sub out from under it, save, assert the document still says unconfirmed); unit tests replacing `schedule-helpers.test.js:733`/`:737` with document-authoritative assertions; a wiring ratchet that the save cannot carry a form-supplied `confirmed`; a test that the owner sees "a manager confirms coverage" **and** still sees Undo on a confirmed sub (the BDD asserts both, no test covers either); a Phase 3 test that Cancel performs **no write** (ratchet the `if (!confirm(...)) { openTimeOffDetail(requestId); return; }` sitting before `updateTimeOffRequest`); and a Phase 3 test that the warning names only the unconfirmed subs.

**Is the Phase 3 warning placed correctly?** Yes — `updateCoverageStatus` is the single entry point and `openTimeOffDetail` rebuilds the select from stored state, so Cancel snaps back for free. Just take the request from a fresh read, not the in-memory list.

Fix findings 1 and 2 before this is execution-ready; 1 is the difference between the plan closing the Ivy defect and re-opening it through a different door.
