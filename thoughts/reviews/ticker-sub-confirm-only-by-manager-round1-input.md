## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-sub-confirm-only-by-manager.html
Read it in full first. The repo is /Users/christiehubley/tinker-timeclock (READ-ONLY for you: do not edit any file,
do not run tests that write, do not run any deploy). Key code: js/app.js (time-off form ~7020-7520, detail view
~7540-7760, sub confirm ~7832-8200, updateCoverageStatus ~8250, edit/reversal helpers ~8700-9110),
js/schedule-helpers.js (getSubCoverageDates ~209, reconcileEditedProposedSubs / carryConfirmedSubs ~964-1040),
js/firebase-data.js (confirmTimeOffSub ~780). Rules: /Users/christiehubley/studio-hub/firestore.rules
(timeclock_timeoff ~439, timeclock_schedules ~420).

## Background
A requester ticked "They agreed to cover" on the request form, which saved proposedSubs[i].confirmed = true with no
schedule write, no email, no subUid. The manager then saw "Confirmed" + an Undo button, never Mark Confirmed, and set
the label-only "Coverage: Secured" dropdown. After Undo, Mark Confirmed failed with "This sub has no covered dates to
write a shift for" because the sub's dates were captured when the sub was added and never re-synced with the request's dates.
Christie's scope: going forward only, no backfill of existing documents.

## What I want reviewed
- Verify every factual claim in the plan against the code (line refs, behaviours). Flag any that are wrong.
- Phase 1: once the form can no longer flip `confirmed`, do the edit paths (reset path ~7440 and non-reset path
  ~7455: reconcileEditedProposedSubs, carryConfirmedSubs, reverseConfirmedTimeOffSubs, the saveGuard) still behave
  correctly? Is any path that currently relies on the form checkbox (e.g. un-confirming a sub by un-ticking on edit)
  now unreachable in a way that strands data?
- Phase 1: is hiding Mark Confirmed from the owner + guarding handleSubConfirmToggle sufficient? Are there other
  places a non-manager can set confirmed?
- Phase 2: is overwriting each sub's `dates` with the request's dates on every save safe? Anything that reads
  sub.dates (emails, reminders, overlap checks ~8274, getSubCoverageDates callers) whose meaning changes? Is the
  empty-overlap fallback in getSubCoverageDates safe on every caller (including the no-roster-match path and any
  reversal/overlap logic)?
- Phase 3: is the warning placed correctly, and is reading from allTimeoffRequests reliable there?
- Are the BDD scenarios enough to catch a partial implementation? What tests are missing?
- What did I miss? Rank findings BLOCKING / MEDIUM / LOW with file:line evidence.

## Constraints
- Firebase project tinker-hq-apps shared by all staff apps; rules source only /Users/christiehubley/studio-hub/firestore.rules
- Tests use the Firestore emulator, never mocks; jest also has source-shape "wiring" ratchet tests
- Timeclock_entries / payroll must not be affected
- updateDoc for partial edits, strip undefined/empty, await critical writes
