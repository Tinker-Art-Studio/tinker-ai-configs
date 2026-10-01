## Plan under review (ROUND 3)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html (v3)
Read it in full. Round 1 and 2 reviews are beside this file:
ticker-sub-confirm-only-by-manager-round{1,2}-{claude,codex}.md. The v3 Decisions Log says how each finding
was handled. Christie answered D1 (refuse a date change while a sub is confirmed), D2 (date checkboxes in the confirm
modal), D3 (display-only amber line for confirmed-but-no-shift subs).

The repo is /Users/christiehubley/tinker-timeclock and is READ-ONLY for you: no edits, no tests that write, no deploys.
Key code: js/app.js (form ~7020-7520 incl. handleSubmitTimeOff edit branches ~7415-7500, detail ~7540-7760, sub confirm
~7832-8200, updateCoverageStatus ~8250, carryCurrentSubs ~8720), js/schedule-helpers.js (getSubCoverageDates ~209,
reconcileEditedProposedSubs / carryConfirmedSubs ~964-1040), js/firebase-data.js (confirmTimeOffSub ~780), index.html
(confirm-sub modal ~1175-1210), tests schedule-helpers.test.js, schedule-editor-wiring.test.js.

## What I want reviewed
- Did v3 actually resolve each round-2 BLOCKING/MEDIUM finding (both reviewers)? Name any still open or answered wrongly.
- New in v3, check hard:
  * "The one rule": checkEditAgainstDocument at the first read and at the carryCurrentSubs read, openedSubs captured at
    form load, removed subs excluded at the second check. Is the claim "a step-2 refusal leaves nothing half-done" true?
    Any legitimate edit this wrongly refuses? Any race still open (including between the two reads and the transaction)?
  * normalizeRequestDates: does it make every real stored shape round-trip equal (check :7063 load and :7366 save)?
  * dates in confirmTimeOffSub's expectRequest + rollback on field 'dates': does the existing rollback branch really do a
    full, checked rollback for that reason (read :8025-8065)? Does any other confirmTimeOffSub caller break?
  * D3 gate change at :7615 and its roster-status branching.
  * Phase 3 re-render on Cancel/failure.
- Are the BDDs/tests now enough to catch a partial implementation?
- Rank findings BLOCKING / MEDIUM / LOW with file:line evidence. Say explicitly whether it is execution-ready.

## Constraints
- Firebase project tinker-hq-apps shared by all staff apps; rules only in /Users/christiehubley/studio-hub/firestore.rules
- Emulator tests, never mocks; jest source-shape ratchets exist
- Payroll / timeclock_entries unaffected
- Scope: going forward only; no data backfill
