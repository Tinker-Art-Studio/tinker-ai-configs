## Findings

### BLOCKING

None.

### MEDIUM

None.

### LOW

None.

I found no Phase 3 deviation, omission, or overreach that warrants a finding. The Phase 2 follow-ups also close the reviewed defects without introducing a new correctness issue.

## Phase 2 follow-up review

- The busy flag is set synchronously before the first `await`, so once submission begins, neither × nor Cancel can clear the captured context. Both dismissal controls go through the guarded close helper. [js/app.js:8053](/Users/christiehubley/tinker-timeclock/js/app.js:8053), [js/app.js:8098](/Users/christiehubley/tinker-timeclock/js/app.js:8098)
- Another confirmation box cannot replace the context while the save is running. `_confirmSubCtx` is assigned only by `openConfirmSubModal()` and cleared only by `closeConfirmSubModal()`; there is no backdrop or Escape handler for this modal. [js/app.js:7997](/Users/christiehubley/tinker-timeclock/js/app.js:7997), [index.html:1179](/Users/christiehubley/tinker-timeclock/index.html:1179)
- Every settled path after `_confirmSubBusy = true` passes through `finally`, including early returns and exceptions, so no control-flow path leaves it true. A genuinely never-settling Firestore/network promise could naturally leave the operation pending, but that is not a missing reset branch. [js/app.js:8100](/Users/christiehubley/tinker-timeclock/js/app.js:8100), [js/app.js:8246](/Users/christiehubley/tinker-timeclock/js/app.js:8246)
- Success force-closes the dialog, clears the global context, and continues using only the captured local context. That is correct. [js/app.js:8216](/Users/christiehubley/tinker-timeclock/js/app.js:8216)
- A dates refusal closes only after the checked rollback and explanatory alert. Retrying a permanently stale date snapshot is therefore prevented. Other recoverable failures leave the box open after the busy flag clears. [js/app.js:8173](/Users/christiehubley/tinker-timeclock/js/app.js:8173), [js/app.js:8210](/Users/christiehubley/tinker-timeclock/js/app.js:8210)
- The checkbox construction is injection-safe: attacker-controlled dates go through `.value` and `createTextNode()`, never HTML or an attribute string. The sub name uses `textContent`. [js/app.js:8021](/Users/christiehubley/tinker-timeclock/js/app.js:8021)
- The new all-unwritable and partial-miss messages accurately describe whether confirmation landed and give an actionable retry path. [js/app.js:8124](/Users/christiehubley/tinker-timeclock/js/app.js:8124), [js/app.js:8242](/Users/christiehubley/tinker-timeclock/js/app.js:8242)
- The new emulator guard-order case is now genuine: its link-less confirmed entry passes the applied-record and `subUid` guards, so moving the dates check above `confirmed` would make it fail. [timeoff-sub-confirm.emulator.test.js:328](/Users/christiehubley/tinker-timeclock/timeoff-sub-confirm.emulator.test.js:328)

## `updateCoverageStatus` trace

| Scenario | Write/result | Manager sees | Dropdown afterward |
|---|---|---|---|
| Secured, no subs | Guarded write against the fresh empty/missing sub snapshot and status | Success toast | Secured |
| Secured, all confirmed | Same guarded write; no warning | Success toast | Secured |
| One unconfirmed → Cancel | No write | Warning names that sub; then fresh detail reload | Stored prior value |
| One unconfirmed → OK | Guarded Secured write | Warning, then success toast | Secured |
| Two unconfirmed | Warning names both with plural wording; OK/Cancel behaves as above | Both names, only unconfirmed names | Secured on success; stored value on Cancel |
| Fresh read fails → Cancel | No write | “Couldn’t check…” prompt; detail reloads | Stored value if reload recovers; otherwise “Failed to load request” and no dropdown |
| Fresh read fails → OK | Plain awaited update, intentionally unguarded per spec | Success toast, or generic failure alert | Secured on success; actual stored value on failure |
| Request already deleted | No write | “This request no longer exists”; detail says “Request not found” | No dropdown |
| Deleted after read | Transaction returns `not-found`; no write | Same not-found alert and detail | No dropdown |
| Sub confirmed between read/write | Exact `proposedSubs` comparison refuses | “The subs … changed”; fresh detail shows the confirmation | Usually Secured if now all confirmed, otherwise Partial |
| Sub undone between read/write | Exact comparison refuses | Same changed alert; fresh detail shows the Undo | Pending or Partial, according to remaining confirmations |
| Approved → completed auto-complete | Allowed by `['approved', 'completed']`; Secured is written | Success toast; completed detail | No dropdown because completed requests do not render it |
| Any other status change | Status guard refuses | “This request’s status changed”; fresh detail | Stored value if the new status still exposes the dropdown; otherwise no dropdown |
| Guarded or plain write fails | No success toast | Specific changed/status/not-found message where available, otherwise generic failure | Actual stored value after reload |
| Pending / Partial / Not Needed | Plain awaited update, unchanged from prior behavior; no fresh-read warning | Success toast or generic failure | Chosen value on success; stored value on failure |

The implementation matches the Phase 3 guard requirements at [js/app.js:8407](/Users/christiehubley/tinker-timeclock/js/app.js:8407), backed by the transaction’s exact-field and status comparisons at [js/firebase-data.js:858](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:858).

## Firebase invariants

- Secured after a successful read is guarded on the exact `proposedSubs` snapshot and allowed current status.
- Only the explicitly specified failed-read fallback and non-Secured choices use the plain partial update.
- All request and schedule writes are awaited.
- These commits introduce no `undefined` Firestore value. Missing `proposedSubs` is deliberately represented as `null` in the comparison only.
- Request mutations use partial `update()`/transactional `tx.update()` operations; there is no new full overwrite, collection, bulk operation, or rules change.

## Tests

The new tests are meaningful for their stated regressions:

- `unconfirmedSubNames` is exercised as real exported production code, including mixed, empty, all-confirmed, and absent lists. [schedule-helpers.test.js:3086](/Users/christiehubley/tinker-timeclock/schedule-helpers.test.js:3086)
- Phase 3’s wiring tests would fail if the fresh read, Cancel re-render, exact-sub guard, approved→completed tolerance, failure return, or single list render were removed. [schedule-editor-wiring.test.js:2387](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2387)
- The modal safety tests are source-level ratchets rather than browser interaction tests, but they pin the busy lifecycle, guarded closing, forced success/date-refusal closes, and refusal to open a replacement box.
- The corrected emulator case genuinely distinguishes the required `confirmed`-before-`dates` guard order.

I did not run tests or make changes, as requested.

**Ready to push for deploy review — yes.** The service-worker cache bump remains the plan’s later deploy step, not an omission from these Phase 3 commits.
