No blocking data-integrity defect found in the Phase 1 core, but the implementation is not exact enough to build on unchanged.

## MEDIUM

- [js/app.js:7462](/Users/christiehubley/tinker-timeclock/js/app.js:7462) — A request deleted before the first submit-time read bypasses the guarded `not-found` path. Because the entire edit branch is inside `if (existingDoc.exists)`, `saveGuard` remains null and line 7561 attempts an ordinary update. Firestore will not recreate the document, so this is data-safe, and the button is restored, but the user receives only “Failed to save. Please try again” instead of the planned “it no longer exists” refusal. The new tests do not cover this path.

- [js/app.js:7462](/Users/christiehubley/tinker-timeclock/js/app.js:7462) — The Save button can remain disabled when the initial Firestore read rejects. The button is disabled at line 7409, but there is no encompassing `try/finally`; the same applies if reversal orchestration unexpectedly throws. All expected Phase 1 refusal results call `giveBack()`, but actual rejected promises do not.

- [schedule-editor-wiring.test.js:1638](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:1638) — The comment says the test proves the button is returned “on every early return,” but the assertion merely proves that a `giveBack` function exists somewhere. It passes with the rejected-read bug above and would also pass if a newly added refusal omitted `giveBack()`. This portion is effectively vacuous relative to its stated guarantee.

## LOW

- [index.html:711](/Users/christiehubley/tinker-timeclock/index.html:711) — The added help copy says a manager “adds the shift to their schedule.” That is false for the intentionally unchanged no-match, ambiguous, and unclaimed branches at [js/app.js:7935](/Users/christiehubley/tinker-timeclock/js/app.js:7935), which confirm without a schedule write. This copy also goes beyond the Phase 1 changes listed in the plan.

- [js/app.js:7557](/Users/christiehubley/tinker-timeclock/js/app.js:7557) — The transaction-refusal message always says “Any sub coverage removed above stays removed,” including a reason-only edit where `toReverse` was empty. For example, a date change between step 2 and the transaction produces a false removal statement. The step-2 refusal correctly makes this clause conditional; the transaction refusal does not.

- [js/app.js:7596](/Users/christiehubley/tinker-timeclock/js/app.js:7596) — The successful re-confirmation notice does not match the planned wording. The plan says “so Sam stays on this request”; the implementation says “so they stay on this request,” and multiple names are comma-joined without a final “and.” The underlying result is accurate.

- [schedule-editor-wiring.test.js:2231](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2231) — The prompt test proves that a confirmation prompt and the cannot-re-add text exist, but does not prove `hasRecord` selects the correct prompt. Inverting the `hasRecord` branches would still pass.

## End-to-end trace

- Reason-only edit with confirmed sub: correct. Step 1 passes; `reconcileEditedProposedSubs` restores `subUid`/`appliedOverrides`; nothing reverses; `carryCurrentSubs` preserves the fresh confirmation; the guarded save includes fresh subs and dates.

- Remove confirmed sub, reversal lands: correct. Its schedule record is reversed first, the request entry is transactionally unconfirmed, the fresh read sees that result, and the final save removes the entry.

- Remove then re-add: correct. `addTimeOffSub` restores a deep copy of `openedSubs[name].entry`; reconciliation restores the schedule link, and no reversal is requested.

- Round-1 race: correct. A confirmation-state change before the first read is refused before any reversal.

- Round-2 races: correct. Changes between reads are refused by step 2, except for landed reversals explicitly listed in `reversedNames`. A later change between step 2 and the write is covered by the transaction guard.

- D1: correct. User-edited dates are refused while the fresh document has any confirmed sub. Removing the confirmed sub in the same edit adds the standalone-save instruction.

- Dates changed elsewhere: correct at step 1 and step 2, and dates are now included in the transaction guard. The plan-accepted raw-date guard can still spuriously refuse shape-only concurrent rewrites.

- Step-2 refusal after a landed removal: correct. It restores the button and only says coverage stays removed when `reversedNames` is nonempty.

- Brand-new request: correct. `openedSubs`/`openedDates` remain null but are never passed to the edit checker. The create literal forces every proposed sub to `confirmed: false` after `...formData`.

- Existing request deleted before submit: no accidental creation or success, but it takes the incomplete generic-failure path described above.

- Reset branch: operationally unchanged. It still reverses every confirmed sub from the fresh document, carries the post-reversal truth, and retains the existing reset guard asymmetry.

## Firebase invariants

The Phase 1 additions do not introduce an undefined Firestore value. Missing `subUid` becomes `null`, missing records become `{}`, and missing guarded dates remain `null`. Critical Phase 1 writes and reversal operations are awaited and guarded. Creation still intentionally uses `set`; updates use update/transaction semantics.

The pure-helper tests exercise production code and are meaningful. The wiring tests catch most required placement and ordering changes, but they are structural rather than behavioral and miss the deleted-document and rejected-read paths. I did not run tests, per the read-only/no-write-test instruction.

**Phase 1 OK to build on — no.** The confirmation, reversal, and stale-form logic is sound, but the missing-document/error handling and misleading coverage copy should be corrected first.
