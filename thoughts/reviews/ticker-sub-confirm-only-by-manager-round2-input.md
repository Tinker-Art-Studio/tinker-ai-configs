## Plan under review (ROUND 2)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html (v2)
Read it in full. Round 1 reviews are beside this file:
ticker-sub-confirm-only-by-manager-round1-claude.md and ...-round1-codex.md. The v2 Decisions Log says how each finding
was handled. Christie answered D1 (refuse a date change while a sub is confirmed), D2 (date checkboxes in the confirm
modal), D3 (display-only amber line for confirmed-but-no-shift subs).

The repo is /Users/christiehubley/tinker-timeclock and is READ-ONLY for you: no edits, no tests that write, no deploys.
Key code: js/app.js (form ~7020-7520 incl. handleSubmitTimeOff edit branches ~7415-7500, detail ~7540-7760, sub confirm
~7832-8200, updateCoverageStatus ~8250, carryCurrentSubs ~8720), js/schedule-helpers.js (getSubCoverageDates ~209,
reconcileEditedProposedSubs / carryConfirmedSubs ~964-1040), js/firebase-data.js (confirmTimeOffSub ~780), index.html
(confirm-sub modal ~1175-1210), tests schedule-helpers.test.js, schedule-editor-wiring.test.js.

## What I want reviewed
- Did v2 actually resolve each round-1 BLOCKING/MEDIUM finding? Name any that are still open or were answered wrongly.
- New in v2, check hard:
  * Dropping hasLink from carryConfirmedSubs (document authoritative for `confirmed`). Any path where the form
    legitimately supplies confirmed:true that the document lacks (e.g. brand-new request, reset path which forces false,
    a sub renamed)? Any path where this now un-confirms real coverage?
  * D1 refusal: placement before reversals in the non-reset branch; is comparing against existingData correct given
    reconcile/carry run after; manager edits; record-less confirmed subs; interaction with the saveGuard.
  * D2 date checkboxes: ctx.dates from ticked boxes; interaction with the overwrite prompt, rollback/partitionRollback,
    reminderPromiseDates, the email's written dates, the "no covered dates" check, stale modal state (_confirmSubCtx).
  * D3 amber line condition (confirmed && no subUid && no appliedOverrides): false positives? e.g. a legitimately
    confirmed matched sub whose write skipped every date, dismissedOverrides entries, legacy docs.
  * Phase 3 fresh read + failed-write handling.
- Are the BDDs/tests now enough to catch a partial implementation?
- Rank findings BLOCKING / MEDIUM / LOW with file:line evidence. Say explicitly if you consider it execution-ready.

## Constraints
- Firebase project tinker-hq-apps shared by all staff apps; rules only in /Users/christiehubley/studio-hub/firestore.rules
- Emulator tests, never mocks; jest source-shape ratchets exist
- Payroll / timeclock_entries unaffected
- Scope: going forward only; no data backfill
