I read the full state machine in its current form (`js/app.js:7917-8278`), traced the open/close/submit interleavings, and hand-verified the new test regexes against the exact source text. I could not execute anything — `node` and `npm test` both need approval and this session is non-interactive — so the regex matching and mutation checks below are by hand, not run.

## MEDIUM

**1. `js/app.js:8239,8243` — the skipped detail refresh leaves a stale toggle whose label now means the opposite, and clicking it silently removes the coverage shift.**

The sub button is one toggle (`js/app.js:7704`: `${s.confirmed ? 'Undo' : 'Mark Confirmed'}`), and `handleSubConfirmToggle` re-reads the request fresh (`js/app.js:7932`) and branches on the *fresh* `sub.confirmed`. So a stale label doesn't cause a stale write — it causes the **inverse** write. `unconfirmTimeOffSub` on its happy path has no confirmation prompt; it goes straight to the reversal.

Concrete sequence (request R, subs Sam and Alex, both matched):
1. Confirm Sam → save hangs (offline).
2. After 60s the escape hatch closes box 1. R's detail is still on screen behind, Sam still reads "Mark Confirmed".
3. Manager opens box 2 for **Alex, same request R**.
4. Sam's save lands. `anotherBoxOpen` is true → `openTimeOffDetail(R)` is skipped. The toast is the only signal, and it auto-hides.
5. Manager closes box 2 (or Alex's submit hits an early return like "Tick at least one date"). R's detail is never refreshed.
6. Manager clicks "Mark Confirmed" next to Sam → fresh read says confirmed → `unconfirmTimeOffSub` → Sam's coverage shift is removed from their schedule and the entry cleared, no prompt.

This is a regression against 76122ad, which always refreshed. The refresh only needs suppressing when the other box is on a *different* request — the confirm box is a top-level element (`index.html:1179`), so re-rendering `timeoff-detail-body` under it doesn't disturb box 2 or its checkboxes. One line fixes it, and fixes finding L1 at the same time:

```js
// (compute here, after the await — not at 8239)
const otherRequestBoxOpen = !!_confirmSubCtx && _confirmSubCtx !== ctx && _confirmSubCtx.requestId !== ctx.requestId;
if (!otherRequestBoxOpen) openTimeOffDetail(ctx.requestId);
```

**2. `js/app.js:8114-8117` — on a save that never settles, confirming is dead for the rest of the session, and the new button reset makes that look like a live button.**

`_confirmSubBusy` is only cleared in `finally`, so a promise that never settles (the exact case the hatch exists for — `js/app.js:7921`) leaves it `true` forever. The hatch frees the *box*; it does not free the *gate*. Before this diff the reopened box's button stayed disabled on "Confirming…" — visibly stuck. Now `js/app.js:8052-8053` resets it, so the manager fills in a normal-looking box, clicks Confirm, and gets "Still saving the last confirmation — **try again in a moment**" — which will never become true. Nothing tells them to reload.

The direction of the reset is right; the refusal message just needs to stop lying once the save is over a minute old:

```js
alert(Date.now() - _confirmSubBusySince > 60000
  ? 'The last confirmation has been saving for over a minute and never finished. Reload the page before confirming anyone else — check first whether it went through.'
  : 'Still saving the last confirmation — try again in a moment.');
```
That would need the assertion at `schedule-editor-wiring.test.js:2377` updated with it.

## LOW

**L1. `js/app.js:8239` — `anotherBoxOpen` is computed one await too early.** It is read before `await getAllTimeOffRequests()` at 8241 but used at 8243. A box opened during that await (busy is still true, the modal is already closed, so `openConfirmSubModal`'s gate at 8002 lets it through) is invisible to the check, and the detail swaps under it anyway. Subsumed by M1's fix.

**L2. `schedule-editor-wiring.test.js:2380` — the button-reset assertion pins the `if (submitBtn)` line but not the `const submitBtn = …` that defines it.** Delete `js/app.js:8052` alone and the test stays green while `openConfirmSubModal` throws a ReferenceError and no box opens at all. Include both lines in the regex.

**L3. `js/schedule-helpers.js:218` — "a sub with no name" reads awkwardly in the sentence it feeds.** `js/app.js:8449` renders "a sub with no name isn't confirmed yet … Use Mark Confirmed next to **their name** to do that." The warning firing is the right fix; the trailing clause just doesn't fit the placeholder. Also note `' '` (whitespace name) still passes through as before — not a regression.

## Your questions, directly

- **Confirm after a cancel the manager believed worked?** No. The hatch's `confirm()` text says the write may still finish, and a box reopened afterwards cannot submit while `_confirmSubBusy` is true. A re-confirm of the same sub after busy clears is refused by `confirmTimeOffSub`'s `{confirmed:false, subUid:null}` guard and `partitionRollback` leaves the existing shift alone.
- **Close or clear a box/context that is not the saving one?** No. `js/app.js:8064` guards every forced close by identity (`onlyIfCtx`), and both forced closes (8232, 8240) pass their own `ctx`. While the saving box is on screen, `_confirmSubCtx === _confirmSubSavingCtx` always holds — the only way ctx changes is `openConfirmSubModal`, whose gate (8002) refuses while busy **and** the modal is open. Contexts are fresh object literals per open, so identity can never alias.
- **Permanently unclosable box?** No. `_confirmSubBusySince` is set in the same synchronous block as the flag (8119-8121), nothing between can throw, and past 60s the hatch always offers a way out.
- **`_confirmSubBusy` true forever on a settled path?** No — `finally` (8273-8277) runs on every settled path including every early `return` inside the try. On an *unsettled* path it is forever; see MEDIUM 2.
- **Two saves at once?** No. The check at 8114 and the set at 8119 are separated only by synchronous DOM work, and `alert`/`confirm` block rather than yield, so the check-and-set is atomic. Double-clicking is additionally covered by the synchronous disable at 8118.
- **Early returns before `_confirmSubBusy = true` (button state)?** All six are safe: 8086, 8090, 8099, 8103, 8110 and the busy refusal at 8116 all return before the disable at 8118, so the button keeps the enabled state `openConfirmSubModal` gave it. The busy check being placed after `const btn` but before `btn.disabled = true` is the correct ordering and is pinned at `schedule-editor-wiring.test.js:2377`.
- **Do the new tests pin the behaviour?** Mostly yes. Hand-matching against the source: the full-close regex (`:2355`) matches, and it is caught by each of — dropping the `<60s` return, flipping `!confirm` → `confirm`, dropping `&& _confirmSubCtx === _confirmSubSavingCtx`, dropping the `onlyIfCtx` guard, and dropping `_confirmSubCtx = null`. The `slice` helper (`:2303`) searches `to` from the `from` index, so both `open` (7999→8008) and `openAll` (7999→8063) resolve to the intended spans — worth noting because the bare first `const requestDates =` is at 7977, before the function. The `finally`, `savingCtx = ctx`, open-refusal-return and `anotherBoxOpen` assertions each fail on their obvious mutation. The one gap is L2. The behaviour is pinned as source text only, with no DOM-level test — consistent with how the rest of this suite treats `js/app.js`, so not a finding.

**ready to push for deploy review — no.** MEDIUM 1 is a new way for a manager's click to silently delete a coverage shift they just wrote, and it's a one-line change that also absorbs L1; MEDIUM 2 and L2 are a message and a regex. I'd land all four together and re-review just those hunks rather than ship and chase it.
