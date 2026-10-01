I do not consider v2 execution-ready. It resolves most round-1 findings on paper, but three concurrency/data-authority holes can still produce or remove real coverage incorrectly.

## BLOCKING

1. The “document is authoritative in both directions” promise is contradicted by leaving `reconcileEditedProposedSubs` unchanged.

The plan explicitly preserves the form-unchecked → reversal behavior as an old-cache guard ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:122)). But a legitimate current-page race is:

1. Ivy opens Edit while Sam is unconfirmed; the form captures `confirmed:false` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7068)).
2. A manager confirms Sam in another tab.
3. Ivy saves only a reason change.
4. The fresh `existingData` now says confirmed, while the stale form says false.
5. `reconcileEditedProposedSubs` interprets that as an intentional untick and queues a reversal ([schedule-helpers.js](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:988)).
6. The non-reset branch runs that reversal before `carryCurrentSubs` can make the document authoritative ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7455)).

For a manager editing, the schedule removal can land silently. For a requester it creates the manager handoff. Either violates Phase 1’s acceptance that saved confirmation follows the document at save time ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:105)).

Removal has the same race: if Ivy removes Sam while her stale form still shows him unconfirmed, she receives no “confirmed sub” prompt, but the fresh document can cause the save path to reverse coverage.

Once the checkbox is removed, a same-name form entry’s false flag cannot be treated as an intentional Undo. The reconciliation policy needs to distinguish:

- Same-name entry still present: carry the fresh document state; do not reverse because of the form flag.
- Entry removed: apply an explicitly defined fresh-document removal policy, including the confirmation warning when it became confirmed after the form opened.

Dropping `hasLink` from `carryConfirmedSubs` is otherwise correct. I found no legitimate current-bundle path where an existing request should supply `confirmed:true` while the document lacks it:

- New requests are separate and initialize subs false.
- The reset branch deliberately feeds false and then carries the post-reversal document.
- Subs cannot be renamed inline; remove/re-add initializes false.
- A roster rename does not rename the request entry.

The dangerous direction is the inverse—stale form false versus freshly confirmed document—before carry runs.

2. D1 can be bypassed when confirmation occurs during the save.

The proposed D1 check compares against the initial fresh `existingData`, before reversals, which is the right basic placement ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:112)). It correctly covers managers and record-less confirmed subs, and correctly leaves the reset branch alone.

It misses this interleaving:

1. Ivy opens an unconfirmed Oct 3 request and edits it to Oct 4.
2. The save reads `existingData`; nobody is confirmed, so D1 allows the edit.
3. A manager confirms Sam for Oct 3.
4. `carryCurrentSubs` reads the new confirmation and carries its Oct 3 record.
5. The save guard expects those freshly carried subs, so it passes.
6. The wholesale request update saves Oct 4 while Sam remains confirmed for Oct 3.

`carryCurrentSubs` currently returns only fresh subs, not fresh request dates ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8720)), and the save guard checks `proposedSubs` and requester `appliedOverrides`, but not `dates` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7473)).

D1 needs a second decision at the post-reversal fresh read:

- Compare `formData.dates` with that read’s request dates.
- If that read contains any confirmed sub and the dates differ, refuse.
- Include the fresh request dates in the conditional-write expectation so a later date change cannot pass the transaction guard.

The D1 helper should normalize before comparing: order-independent; missing `type` means full; full-day partial times normalize to null; missing/null partial values compare consistently; `flexible` remains excluded.

3. The confirmation modal can confirm stale dates after the request changes.

`openConfirmSubModal` snapshots the dates into `_confirmSubCtx` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7902)). The eventual transaction guards status, confirmation, `subUid`, and the empty prior record, but not the request’s dates ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8021), [firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:799)).

Therefore:

1. A manager opens the Oct 3 confirmation modal.
2. Before submission, the requester changes the still-unconfirmed request to Oct 4.
3. The manager submits the stale modal.
4. Oct 3 is written to the schedule.
5. The confirmation transaction succeeds against the now-Oct 4 request.

This directly violates the “request’s real dates” goal. The transaction must expect the request-date snapshot used to build the checkbox list. On mismatch, the existing failed-confirm rollback path should reverse the just-written selected dates and tell the manager to reopen.

The emulator test should prove the date guard, including that the request is left unconfirmed and the schedule write is rolled back.

## MEDIUM

4. D3’s proposed implementation is ambiguous and can be wrong in both directions.

The prose requires `confirmed && no subUid && no appliedOverrides`, but the stated change says to add `matched` to the current notes map ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:135)). The existing outer condition checks only `confirmed && !subUid` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7615)).

Merely adding a `matched` map entry would falsely warn for a confirmed entry with:

```js
subUid: null,
appliedOverrides: { ... }
```

That is a recognized load-bearing state: the code deliberately preserves records lacking `subUid` because a partial failure can leave one ([schedule-helpers.js](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:975)).

Conversely, requiring both missing `subUid` and an empty record omits `confirmed:true, subUid:"...", appliedOverrides:{}`. Such shapes already appear in emulator fixtures and may exist in legacy documents; there is no recorded evidence of a schedule write.

The plan should specify the exact signal and wording. The most defensible detector is “confirmed with no `appliedOverrides` record,” with wording such as “Ticker has no record that a shift was added,” rather than asserting that no manually added shift exists. `dismissedOverrides` does not create a false positive because the dismissal path also sets `confirmed:false` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8175)).

5. D2 does not cover the unmatched/unclaimed confirmation branch.

The plan says a manager chooses dates when confirming, but explicitly leaves the no-roster-match branch unchanged ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:176)). That branch immediately confirms without opening the modal and emails the requester using its fallback date set ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7857)).

If D2 is intended only for schedule-writing, matched subs, the goal and acceptance should say so. Otherwise unmatched confirmations also need date selection.

For the matched path, the proposed downstream flow is sound:

- Unticked dates never enter `overridesToWrite`.
- The conflict prompt naturally sees only selected, writable dates.
- `appliedOverrides` and rollback are derived from those writes.
- Email `writtenDates` and `shiftsWritten` use `overridesToWrite`.
- `reminderPromiseDates` uses the same written map.

6. `_confirmSubCtx` remains live after Cancel or ×.

Today it is cleared only after successful confirmation ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8068)); both modal-close controls merely remove the CSS class ([index.html](/Users/christiehubley/tinker-timeclock/index.html:1183), [index.html](/Users/christiehubley/tinker-timeclock/index.html:1201)).

Normal clicking cannot submit a hidden modal, and reopening replaces the context, so this is not presently a common user-facing failure. Still, Phase 2 should use one close helper that closes the modal and nulls `_confirmSubCtx`, and `submitConfirmSub` should refuse unless the modal is open. This also makes stale-state tests meaningful.

7. The planned tests are not sufficient to catch a partial implementation.

The plan adds good coverage for the round-1 stale-true race, helper pre-ticks, manager gates, and D1 placement. It still needs:

- Edit form opened unconfirmed → another tab confirms → unrelated save must not reverse or unconfirm.
- Same race with the sub removed from the stale form, asserting the chosen removal/prompt policy.
- Dates edited while initially unconfirmed → another tab confirms before `carryCurrentSubs` → edit refused.
- Confirmation modal opened → request dates changed → transaction refused and selected schedule writes rolled back.
- Transaction-level assertion that request dates are part of the confirmation expectation.
- Automated D2 tests proving unticked dates are absent from conflict detection, payload, `appliedOverrides`, email dates, and reminder dates.
- Cancel/× clears `_confirmSubCtx`; reopening has no dates from the prior request.
- D3 rendering cases: matched link-less; matched with a real record; record without `subUid`; `subUid` without a record; unconfirmed with `dismissedOverrides`.
- Phase 3 behavioral cases for failed read Cancel/OK, no subs, all confirmed, mixed subs, failed write, no success toast, and dropdown restoration.
- A behavioral non-manager test proving neither entry point reaches a modal, transaction, schedule write, or email. A source-order regex alone is weaker than the BDD.

The new edit-save emulator test must exercise the actual orchestration or an extracted production helper—not a second handwritten copy of the intended algorithm. The existing confirmation emulator test currently mirrors the transaction locally ([timeoff-sub-confirm.emulator.test.js](/Users/christiehubley/tinker-timeclock/timeoff-sub-confirm.emulator.test.js:46)), so its source ratchet must also pin any new dates guard.

## LOW

8. Phase 3’s fresh-read and failed-write design is correct, but the absent-document case is unspecified.

Using `getTimeOffRequestResult` is the correct round-1 fix, and checking the boolean from `updateTimeOffRequest` resolves the false “Coverage updated” toast. The implementation should also distinguish:

- Read failed: ask whether to save anyway.
- Request absent: report that it no longer exists; do not attempt the update.
- Write failed: show an error, do not toast success, and reopen/refresh the detail so the changed dropdown does not remain visually selected.

9. The commit-format decision is wrong under the current repository instructions.

The plan says the round-1 commit-prefix finding was wrong ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:254)). The current repository instruction explicitly requires `type: what changed and why` ([AGENTS.md](/Users/christiehubley/tinker-timeclock/AGENTS.md:39)). Execution should use `fix:`, `feat:`, and similar prefixes.

## Round-1 disposition

Resolved correctly:

- The goal now distinguishes email attempt from delivery.
- The intentional unmatched-name manual fallback is documented.
- Reset versus non-reset edit behavior is corrected.
- D2 replaces wholesale date overwriting with per-date selection.
- Phase 3 uses a fresh read and checks failed writes.
- Both confirmation entry points receive manager checks.
- The form retains a confirmed-state cue and removal warning.
- Flipped existing tests and missing orchestration coverage are acknowledged.

Still open or only partially resolved:

- Claude’s document-authority blocker: the stale-true direction is fixed by dropping `hasLink`, but the stale-false direction can reverse a newly confirmed sub.
- Codex’s confirmed-date blocker: D1 handles the ordinary case, but not confirmation during an edit save or dates changing while the modal is open.
- Claude’s missing-write warning: accepted, but its precise predicate is under-specified.
- Test sufficiency: improved, but not enough to catch the concurrency failures above.
- The commit-prefix LOW finding was answered incorrectly.

No files were edited and no tests were run, per the read-only constraint.
