No BLOCKING findings. Two MEDIUM plan-contract gaps remain, so v5 is not execution-ready yet.

## MEDIUM

1. `openedDates` is conceptually correct, but its executable contract is incomplete.

The precedence is sound:

- At step 1, `docDates !== openedDates` produces `dates-changed-elsewhere` before D1, preventing harmful Undo advice.
- At step 2, the same comparison correctly detects a date move between reads; the generic “coverage removed above stays removed” message remains accurate.
- After step 2, `saveGuard.expect.dates = carried.currentDates` correctly closes the final transaction window.
- When `docDates === openedDates`, a form/document difference is genuinely the user’s edit, so D1 is appropriate.

However, the literal helper signature still omits `openedDates` and only adds afterward that it “also takes” it ([plan:94](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:94)). More importantly, the wiring ratchets require only `openedSubs` to be reset/filled and do not pin:

- resetting `openedDates`;
- taking an immutable edit-load snapshot;
- passing it at both helper calls.

If omitted at either call, normalization of `undefined` becomes `[]`, causing every normal dated request to look like `dates-changed-elsewhere`—a blanket false refusal.

Specify the complete signature and add wiring pins for the snapshot and both arguments.

2. “Restore the original entry verbatim” contradicts the declared `openedSubs` shape.

Twice, `openedSubs` is defined as:

```text
name → { confirmed, hasRecord }
```

([plan:82](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:82), [plan:178](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:178))

But v5 then says the original `dates` and `email` are kept there and restored verbatim ([plan:180](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:180)). The stated shape cannot perform that restoration. An implementation following the earlier definition may rebuild the entry and recreate Claude L2’s defect; naively expanding and pushing the snapshot object could instead persist the synthetic `hasRecord` property.

Define an unambiguous shape, such as:

```js
openedSubs[name] = {
  entry: { ...originalSub, dates: clonedDates },
  confirmed,
  hasRecord
};
```

Then explicitly restore only `openedSubs[name].entry`, cloned rather than referenced.

## LOW

- `subMissingWriteNote` now correctly owns the full D3 predicate and resolves round-4 M3. One output detail remains ambiguous: the proposed call assigns its return directly to `matchNote`, which is interpolated as HTML at current [app.js:7629](/Users/christiehubley/tinker-timeclock/js/app.js:7629). State whether the helper returns the complete amber `<div>` or returns plain text that `app.js` wraps. Otherwise the behavior can lose the promised amber-line presentation.

- The newly expanded legacy-limit paragraph first says empty-date/no-dates documents cannot round-trip, then concludes broadly that “a legacy document compares equal to itself after the form’s load→save round-trip” ([plan:116](/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html:116)). Qualify that conclusion as applying only to the supported legacy shapes.

The other v5 edits correctly resolve their cited findings: the `:7485` dates arm, modal close rewiring, Phase 3 refusal distinctions, emulator mirror/source ratchet, null-override ratchet, re-confirm exception documentation, status-before-confirm note, manager-safe D1 wording, and deliberate unmatched-name exception.

**Execution-ready: no.**
