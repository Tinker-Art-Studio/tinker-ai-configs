I do not consider v3 execution-ready yet. It resolves every Round-2 BLOCKING finding in substance, but three MEDIUM issues remain: one legitimate edit breaks the proposed two-read protocol, Phase 3 still has a read/write race, and the automated tests do not pin enough orchestration.

No repository files were edited and no tests were run.

## Findings

### BLOCKING

None.

The three Codex blockers and Claude’s normalization blocker all have viable designs in v3. I did not find another path that can silently resurrect or erase a confirmation after the final transaction guard.

### MEDIUM

1. Remove-then-re-add of the same confirmed sub disproves the step-2 claim and causes a partial save

This is a legitimate current UI sequence:

1. The form opens with Sam confirmed.
2. The user removes Sam and accepts the new warning.
3. The user adds Sam again from the picker; `addTimeOffSub` creates the row as `confirmed:false` ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7280)).
4. The first check passes because Sam is still in `formSubs`, and document `true` equals opened `true`; the helper does not consider the form flag ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:93)).
5. `reconcileEditedProposedSubs` treats the re-added false row as an un-tick and queues a reversal ([schedule-helpers.js](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:988)).
6. After the reversal, Sam is still present in the form, so he is not covered by the second check’s “removed subs” exclusion. Document `false` now differs from opened `true`, causing a step-2 refusal.

Coverage has already been removed transactionally, but the rest of the form is not saved. That contradicts the claim that a step-2 `subs-changed` refusal “can only” follow reversal of a sub absent from the form ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:110)) and exposes another current-page route to the supposedly old-cache-only un-tick branch ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:154)).

The result is data-consistent—schedule and request both become unconfirmed—but it is still a partially applied form action. “A step-2 refusal leaves nothing half-done” is therefore false as a user-level claim.

The plan should either:

- Define remove-then-re-add as preserving confirmation and prevent reversal; or
- Treat every successfully reversed `toReverse` name, including a re-added name, as an allowed second-check transition.

Add a BDD and helper/orchestration ratchet for this sequence.

2. Phase 3’s fresh read is followed by an unguarded write

The plan reads the request fresh, decides whether to warn, then retains the plain `updateTimeOffRequest` write ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:262); current write at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8250)).

A manager can Undo the last confirmed sub between those operations:

1. Phase 3 reads “all confirmed” and shows no warning.
2. Another tab unconfirms Sam.
3. The first tab writes `coverageStatus:'secured'`.

That violates “Picking Secured while any proposed sub is unconfirmed shows [the warning].” Use a conditional transaction expecting the `proposedSubs` snapshot, or re-evaluate the warning inside a transactional helper.

The not-found path also needs an explicit re-render or modal close. Since the dropdown’s DOM value has already changed at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7741), merely alerting and returning leaves “Secured” displayed for a deleted request. Cancel and failed-write re-rendering are otherwise correctly specified ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:253)).

3. The tests still allow a materially partial implementation

The helper coverage is much improved, but the wiring list at [plan lines 291–298](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:291) does not pin:

- `openedSubs` being reset and captured at form load from the fresh request—not reconstructed at submit.
- The precise first-check versus second-check arguments and exclusion set.
- The remove-then-re-add case above.
- A Phase 3 `proposedSubs` race.
- The missing-document dropdown restoration.
- The date-refusal path actually reaching the full, checked rollback branch.
- D3’s roster-status branches for matched/no-match/ambiguous/unclaimed.
- Unticked confirmation dates being absent from conflict detection, payload, email dates, and reminder dates. `confirmDatePreticks` tests only the initial selection.

The emulator date-guard test proves the mirrored transaction refuses; it does not prove `submitConfirmSub` rolls the schedule back. The existing source test already inspects rollback structure ([schedule-editor-wiring.test.js](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:1570)); it should be extended specifically for `field:'dates'`.

### LOW

1. `normalizeRequestDates` should say `type: d.type || 'full'`, not merely “missing → full”

The proposed normalization correctly round-trips all shapes the application itself writes:

- Full dates become `type:'full'`, with partial fields normalized to null.
- Partial dates retain their actual times.
- Legacy absent type and empty partial fields compare equal through load/save.
- Order and `flexible` do not affect equality.

That matches the load and save transformations at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7063) and [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7363).

However, load uses `d.type || 'full'`, which also treats stored `null` and `''` as full. The plan only says “missing type,” and the proposed tests only name missing type ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:282)). Specify and test undefined/null/empty type to make the round-trip claim exact.

2. Some pre-existing cross-document race/failure windows remain

The request-date transaction guard closes the stale-modal confirmation race. It does not make the schedule write and request confirmation atomic:

- A tab or network failure after `saveSchedule` but before `confirmTimeOffSub` can still leave an unconfirmed orphan shift ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8015), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8023)).
- Rollback checks the current shift before restoring it, but that check and its `saveSchedule` are not transactional; the source itself documents the touched-date race ([timeoff-schedule.js](/Users/christiehubley/tinker-timeclock/js/timeoff-schedule.js:180), [timeoff-schedule.js](/Users/christiehubley/tinker-timeclock/js/timeoff-schedule.js:190)).

These are existing architectural limits, not regressions introduced by v3, but the “nothing half-done” language should not imply they are closed.

## Round-2 disposition

Claude’s Round-2 findings:

- BLOCKING normalization: resolved for application-generated and named legacy shapes; tighten falsy `type` handling as above.
- Manager-check placement: resolved correctly at `:7856`, after owner Undo.
- Undefined `dates`: resolved correctly.
- Wrong test flip at `:629`: resolved.
- Emulator overclaim: resolved.
- Create branch forces false: resolved in the new code. It cannot literally protect a page still executing an old cached bundle; the trap box correctly admits that.
- Cancel re-render: resolved except the not-found path.
- D1 plus removal message: resolved.

Codex’s Round-2 findings:

- Stale-unconfirmed reversal: resolved for the reported concurrent-confirm race by the first check.
- Mid-save D1 bypass: resolved by the second snapshot plus transaction expectations.
- Stale confirmation modal: resolved by `expectRequest.dates` plus rollback.
- D3 predicate: resolved correctly.
- D2 matched-only scope: resolved explicitly.
- Modal context clearing: resolved.
- Test sufficiency: improved, but still open per MEDIUM 3.

## Specific checks

The `confirmTimeOffSub` date guard is correctly optional, so the other callers at [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:7865), [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8180), and [app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8241) remain unaffected.

For `field:'dates'`, the existing failure branch does attempt the full selected-date rollback: only `reason:'sub-changed'` enters the ownership-partition read; a date mismatch falls through with `rollBack: appliedOverrides`, awaits `removeTimeOffOverrides`, and reports failure/skipped dates ([app.js](/Users/christiehubley/tinker-timeclock/js/app.js:8029)). It is checked, but subject to the pre-existing non-atomic rollback window described above.

The D3 gate and roster branching are correct as specified. `confirmed && empty appliedOverrides` is the right “Ticker has no record” signal; it correctly excludes the partial-failure record-without-`subUid` state and includes `subUid`-with-empty-record legacy shapes.

## Verdict

Not execution-ready.

There are no remaining BLOCKING findings, but MEDIUM 1 needs a policy because the proposed helper currently rejects a legitimate edit after already applying its reversal. MEDIUM 2 needs a guarded Phase 3 write, and MEDIUM 3 needs stronger orchestration ratchets before implementation can be trusted against a partial build.
