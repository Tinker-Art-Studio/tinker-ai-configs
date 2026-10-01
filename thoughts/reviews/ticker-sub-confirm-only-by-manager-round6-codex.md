No BLOCKING findings. One MEDIUM contradiction remains; no v6 edit creates a wrong schedule write or false confirmation.

## MEDIUM

1. Phase 3’s new status tolerance contradicts the following refusal description.

The plan correctly specifies that a read of `approved` permits both `approved` and `completed`, expressly so auto-completion does not refuse the coverage-label write ([plan:359](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:359)). But the next sentence still identifies auto-completion as an example of `status-changed` refusal ([plan:363](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:363)).

Those outcomes are mutually exclusive. The tolerance itself is sound: auto-completion performs only the `approved → completed` transition ([app.js:6944](/Users/christiehubley/tinker-timeclock/js/app.js:6944)), and `proposedSubs` remains guarded. Change the refusal example to an actually disallowed transition, such as returned to review or withdrawn.

The tests/ratchets also do not pin this new tolerance: the BDDs cover a sub race but not `approved → completed`, and the wiring list only says that the conditional writer is used ([plan:382](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:382), [plan:432](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:432)). Add an acceptance assertion that this transition succeeds.

## LOW

1. The manager re-confirm notice has no implementation or test hook.

The new wording correctly resolves round-5 Claude L8 ([plan:93](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:93)), but neither the Changes section nor the test/ratchet list says how the re-confirmed names are derived or verifies that the special notice replaces ordinary success. This does not affect data correctness, but the UX fix could easily be omitted during execution.

2. “Empty-string partials” is imprecise.

The plan first correctly excludes `type: 'partial'` rows without times ([plan:126](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:126)); submission validation rejects those rows ([app.js:7337](/Users/christiehubley/tinker-timeclock/js/app.js:7337)). It then includes “empty-string partials” among round-trippable shapes ([plan:129](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:129)). Presumably this means empty `partialStart`/`partialEnd` fields on a full or missing-type row. Say that explicitly to avoid contradicting the preceding known limit.

## Correctly resolved v5 findings

- `openedSubs.entry`: correctly defined as a deep-copied form-shaped entry, with restoration using a new deep copy and excluding `hasRecord` ([plan:82](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:82), [plan:193](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:193)). This prevents aliasing across repeated remove/re-add cycles.
- `openedDates`: correctly sourced from `existingRequest.dates`, normalized into a fresh array, reset, and passed at both call sites ([plan:85](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:85), [plan:423](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:423)).
- Required argument: throwing when `openedDates` is omitted correctly prevents the blanket false-refusal failure ([plan:99](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:99)).
- Reason order: `subs-changed → dates-changed-elsewhere → dates-while-confirmed` is correct. It preserves sub-race classification and prevents D1 from attributing another editor’s date change to this user ([plan:102](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:102)).
- Step-2 wording: the generic “coverage removed above stays removed” message now applies to all three reasons, so it cannot falsely claim that nothing changed ([plan:145](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:145)).
- D3 helper: plain-text return plus caller-owned amber wrapping resolves the markup ambiguity ([plan:216](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:216)).
- Picker availability, scope widening, reset/raw-compare asymmetries, corrected test ranges, and the new emulator mirror ratchet are all adequately specified and introduce no new data defect.

No files edited and no tests run.

**execution-ready: no** — resolve the Phase 3 status contradiction and pin its intended tolerance.
