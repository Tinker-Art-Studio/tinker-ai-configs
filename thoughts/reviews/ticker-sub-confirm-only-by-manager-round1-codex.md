I would not mark this plan execution-ready yet. The core diagnosis is correct, but four issues materially conflict with the stated acceptance criteria.

## BLOCKING

1. A confirmed sub can still have no schedule entry and no sub-side email

Phase 1 leaves the unmatched/ambiguous/unclaimed branch intact. That branch directly writes `confirmed: true`, performs no schedule write, and emails only the requester/coordinators—not the sub ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7857), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7865), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7874)).

That directly contradicts the plan’s headline invariant that a sub is never shown Confirmed unless their shift is on their schedule and they have been emailed ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:27)).

The plan must decide one of these:

- Do not allow Mark Confirmed without a matched, claimed roster account and a successful schedule write; or
- Retain the manual fallback, but use a state other than `confirmed`, and rewrite the goal accordingly.

The old behavior was intentional, but it is incompatible with the new definition of Confirmed.

2. Email delivery is not part of the confirmation success condition

Even on the matched path, the request document is marked confirmed before the email call, and the email call is fire-and-forget from its caller ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8023), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8085)). The helper catches and logs all email failures without returning a result ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:9274)).

Additionally, a matched sub with no email is deliberately omitted from the recipient list while the endpoint can still return success for other recipients ([send-timeoff-confirmation-email.js](/Users/christiehubley/tinker-timeclock/netlify/functions/send-timeoff-confirmation-email.js:45), [send-timeoff-confirmation-email.js](/Users/christiehubley/tinker-timeclock/netlify/functions/send-timeoff-confirmation-email.js:59)).

Therefore “Confirmed means … they have been emailed” cannot be guaranteed by this plan. Also, the Happy BDD’s “both emails send” is factually outdated: the current implementation sends one combined email to multiple recipients, not two emails.

Either make confirmed mean “schedule written and email attempted,” or redesign the transaction/state flow around a checked email result. The latter has failure/rollback implications and is larger than this plan suggests.

3. Editing dates on an already-confirmed sub creates exactly the false Confirmed state the plan aims to eliminate

The Phase 2 BDD explicitly says that changing Oct 3 to Oct 4 will:

- Change `sub.dates` to Oct 4.
- Keep `confirmed: true`.
- Keep `appliedOverrides` for Oct 3.

That leaves the sub displayed Confirmed for the current Oct 4 request even though their schedule entry and confirmation email concern Oct 3 ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:145)).

The current non-reset edit path deliberately carries the confirmed flag and schedule record across an edit ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7455), [schedule-helpers.js](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:1020)). It is safe for reason/notes edits, but not for coverage-date changes.

The plan needs a defined policy for confirmed subs when request dates change. Safe possibilities are:

- Refuse the date change until a manager uses Undo.
- Reverse and unconfirm affected subs, with the existing manager handoff when staff cannot perform the reversal.
- Have a manager explicitly migrate the coverage schedule and send an updated email.

Merely changing `sub.dates` is not sufficient.

4. “Editing never changes confirmed state” is false on the status-reset path

Editing an `approved`, `completed`, or `denied` request intentionally reverses every confirmed sub and forces landed reversals to `confirmed: false` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7415), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7440), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7442)). Record-less confirmed subs are also cleared transactionally because there is nothing to reverse ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8230)).

Therefore these plan statements are incorrect:

- “Editing an existing request never changes a sub’s confirmed state.”
- “Now only removal can cause” a confirmed-to-unconfirmed transition.
- The old record-less confirmed sub always survives an edit unchanged.

Those statements are true only for the non-reset `submitted`/`under_review` path. The plan and BDDs need to distinguish the two paths.

## MEDIUM

5. Hiding the button plus guarding `handleSubConfirmToggle` is only an ordinary-UI restriction

For current code loaded in the browser, that is sufficient to stop the normal requester flow. It is not sufficient to enforce “only a manager can confirm”:

- Rules let staff update every field of their own time-off document ([firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:439)).
- `confirmTimeOffSub` accepts an arbitrary patch and contains no role check ([firebase-data.js](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:783)).
- `submitConfirmSub` is another globally callable confirmation entry point and has no manager check ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7939)).
- An actually stale service-worker page runs its cached old `app.js`, so the new handler guard is not present. The service worker cache includes `app.js` and is cache-first ([sw.js](/Users/christiehubley/tinker-timeclock/sw.js:64), [sw.js](/Users/christiehubley/tinker-timeclock/sw.js:103)).

At minimum, guard both `handleSubConfirmToggle`’s confirm branch and `submitConfirmSub`. But the plan must describe this honestly as UI workflow enforcement. A true authorization invariant requires a rules change and the guarded Firebase approval/deploy process.

Un-confirm remains safely reachable:

- Owners still have Undo on toggleable statuses.
- Record-less entries clear through the transaction.
- Recorded entries hand off to a manager.
- Removing a sub in the non-reset edit path still invokes reversal.
- No data becomes stranded merely because the checkbox untick path disappears.

6. Overwriting every sub’s dates may erase meaningful partial coverage on existing documents

The code and tests currently treat a partial overlap as meaningful, not merely accidental:

- `getSubCoverageDates` returns the sub’s own intersected subset ([schedule-helpers.js](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:204)).
- The existing unit test explicitly asserts that behavior ([schedule-helpers.test.js](/Users/christiehubley/tinker-timeclock/schedule-helpers.test.js:484)).
- Existing emulator fixtures model different dates for different subs.

The current form has no explicit per-sub date picker, so new entries normally receive all dates existing at add time. But existing arrays can still encode date-specific coverage. Overwriting them on any edit changes those existing documents and may turn “Sam covers Monday” into “Sam covers Monday through Wednesday.”

This needs a product decision. A safer narrow fix would synchronize dates for new/unconfirmed entries created under the current form, while separately handling confirmed and historical subset entries.

There is also an implementation trap: normalizing at the initial `formData` mapping is not enough. `carryConfirmedSubs` can reappend a removed-but-still-confirmed entry wholesale, including its old dates ([schedule-helpers.js](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:1027)). Any claimed “every saved sub” invariant would need normalization after the carry—subject to resolving the confirmed-date problem above.

7. Phase 3’s `allTimeoffRequests` source is stale and the factual explanation is wrong

The detail view is not drawn from `allTimeoffRequests`; it reads the request fresh from Firestore ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7545)). `allTimeoffRequests` is a separate admin cache populated when the tab renders ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:6810)).

Consequences include:

- A fresh detail modal can show current confirmation state while the warning consults older state.
- The warning can be omitted when an unconfirmed sub was added in another tab.
- It can warn unnecessarily after another tab confirmed the final sub.

The missing-request BDD intentionally accepting an unwarned save also weakens the acceptance statement “when any proposed sub is not confirmed, they see” the warning.

Use a fresh request read in `updateCoverageStatus`, or pass/store the fresh detail request with suitable revalidation. Because the warning is advisory, a concurrent change after the read is acceptable, but silently relying on a known-stale cache is not reliable.

Also, `updateCoverageStatus` ignores the boolean result of the awaited update and always shows “Coverage updated” ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8250)). The Phase 3 tests should cover write failure rather than ratcheting this behavior in.

8. Existing test suites do not prove the claim attributed to them

The plan says the unchanged `timeoff-sub-confirm` and `timeoff-schedule` emulator suites show that the edit path still carries confirmed subs. They do not exercise `handleSubmitTimeOff`’s edit orchestration. The relevant coverage is presently in helper unit tests and source-shape ratchets, especially [schedule-helpers.test.js](/Users/christiehubley/tinker-timeclock/schedule-helpers.test.js:696) and [schedule-editor-wiring.test.js](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:1608).

Also, the current wiring ratchet explicitly requires `(isOwner || isAdmin)` for `canToggle`, so it must be deliberately updated rather than merely supplemented ([schedule-editor-wiring.test.js](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:1564)).

## LOW

- “Mark Confirmed is always there for the manager and always works” is too broad. It remains status-gated and can legitimately refuse for no valid dates, no resolvable full-shift time, conflicts canceled by the manager, or failed writes.
- The no-roster caller already has its own explicit empty-result fallback at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7880). Changing `getSubCoverageDates` affects only the matched modal caller materially. There are only those two callers; reversal, reminders, and the overlapping-request guard do not read `sub.dates`. Reversals use `appliedOverrides`; reminders use written overrides; overlap uses request dates against other requests’ recorded override keys ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8273)).
- The proposed commit names `sub-confirm phase N: …` do not follow the repository’s required `type: what changed and why` convention. Use names beginning with `fix:`, `feat:`, etc.
- Phase 2 is not merely a UI change: it changes persisted request data and shared helper semantics. “Each phase is UI-only” should be corrected.
- `updateCoverageStatus` currently calls `renderAdminAllTimeOff()` twice ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8252)); unrelated, but worth cleaning up if that function is being changed.

## Missing BDD/test coverage

Before execution, I would add scenarios for:

- A matched sub already confirmed for Oct 3 when the requester changes the request to Oct 4: assert the chosen policy—block, reverse/unconfirm, or migrate—not `confirmed: true` with an Oct 3 record.
- Editing an approved/completed/denied request: explicitly assert that successful reversals unconfirm subs and failed reversals preserve the confirmation and record.
- A record-less historical confirmed sub on both non-reset and reset edits.
- Unmatched, ambiguous, and unclaimed subs under the new definition of Confirmed.
- A matched sub with no email address and a failed confirmation-email endpoint.
- Non-manager invocation of both `handleSubConfirmToggle` and `submitConfirmSub`; assert no modal, schedule write, transaction, or email.
- Removal of a confirmed sub whose reversal fails, including the reappended entry’s date semantics.
- Historical partial per-sub dates on a multi-date request.
- Phase 3 with a stale cached list but a fresh request containing an unconfirmed sub.
- Phase 3 no-subs, all-confirmed, mixed-confirmation, non-secured status, Cancel, OK, and failed update.
- A behavioral orchestration test for edit save, not only source regexes.
- The combined-email behavior rather than “both emails.”

The original defect claims and cited current behavior are otherwise substantially accurate. The changes remain isolated from `timeclock_entries` and payroll, and the existing schedule-reversal code correctly uses `appliedOverrides` rather than `sub.dates`. I did not edit files, run tests, or deploy anything.
