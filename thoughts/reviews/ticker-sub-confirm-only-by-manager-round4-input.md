## Plan under review (ROUND 4)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html (v4)
Read it in full. Round 1 and 2 reviews are beside this file:
ticker-sub-confirm-only-by-manager-round{1,2,3}-{claude,codex}.md. The v4 Decisions Log says how each finding
was handled. Christie answered D1 (refuse a date change while a sub is confirmed), D2 (date checkboxes in the confirm
modal), D3 (display-only amber line for confirmed-but-no-shift subs).

The repo is /Users/christiehubley/tinker-timeclock and is READ-ONLY for you: no edits, no tests that write, no deploys.
Key code: js/app.js (form ~7020-7520 incl. handleSubmitTimeOff edit branches ~7415-7500, detail ~7540-7760, sub confirm
~7832-8200, updateCoverageStatus ~8250, carryCurrentSubs ~8720), js/schedule-helpers.js (getSubCoverageDates ~209,
reconcileEditedProposedSubs / carryConfirmedSubs ~964-1040), js/firebase-data.js (confirmTimeOffSub ~780), index.html
(confirm-sub modal ~1175-1210), tests schedule-helpers.test.js, schedule-editor-wiring.test.js.

## What I want reviewed
This is a focused round. Round 3 (both reviewers) found no architectural problem; v4 applies their fixes.
- For EACH round-3 finding (Claude B1, B2, M1-M8, L1-L10; Codex M1-M3, L1-L2): is it resolved correctly in v4? Verify
  against the code. List any that are not, with file:line.
- Did any v4 change introduce a new defect (especially: re-add restoring the confirmed entry, reversedNames = landed
  reversals only, normalized dates inside confirmTimeOffSub's transaction, the guarded Phase 3 write)?
- Only raise NEW issues outside that scope if they are BLOCKING (data loss, wrong schedule write, false confirmation).
- Rank BLOCKING / MEDIUM / LOW with file:line evidence. End with an explicit verdict: execution-ready yes/no.

## Constraints
- Firebase project tinker-hq-apps shared by all staff apps; rules only in /Users/christiehubley/studio-hub/firestore.rules
- Emulator tests, never mocks; jest source-shape ratchets exist
- Payroll / timeclock_entries unaffected
- Scope: going forward only; no data backfill
