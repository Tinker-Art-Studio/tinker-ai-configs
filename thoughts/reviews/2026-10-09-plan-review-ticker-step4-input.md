## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-step4-lock-and-checked-writes.html
(read it in full). Repo: /Users/christiehubley/tinker-timeclock at commit 01c1b86 (main). Downstream consumer: /Users/christiehubley/payroll-tool/index.html (pullFromTimeclock ~line 2980).

## What I want reviewed (design review, before any code exists — you are READ-ONLY, do not edit any file)
- Verify every factual claim about current code against the real source (js/app.js, js/firebase-data.js, js/schedule-helpers.js, the tests). Cite file:line.
- Phase 1 (A): is a single Firestore transaction (read lockedPeriods + the entry, then write) the right enforcement point? Any admin/manager write path that changes HOURS in a locked period that the plan misses (e.g. other writes to timeclock_entries, approve paths, anything that changes `date`, `timestamp`, `type`, or changeRequest.status/requestedTime*)? Does calculateDayHours/calcPeriodTotals read any field the plan treats as "doesn't change hours"? Is fail-closed correct and complete? Any compat-SDK transaction gotcha (offline, persistence enabled via enableOfflinePersistence, retries, tx.set of a new doc id)?
- Is the vm-sandbox emulator harness (see pay-period-lock.emulator.test.js) able to exercise runTransaction + tx.update/delete/set as planned?
- Phase 2 (B): is the call-site table complete and correct? Any ignored write result missed (search all writers in firebase-data.js and direct getDb()/db.collection writes in app.js outside the kiosk)? Are the proposed failure behaviours right?
- Are the BDD scenarios sufficient to catch a partial implementation? Are the accepted residuals honestly stated?
- What did I miss? Anything that could cause data loss or a wrong payroll number?

## Constraints
- Rules source: /Users/christiehubley/studio-hub/firestore.rules (no rules change in this plan); project tinker-hq-apps shared by 21 apps
- Kiosk write paths are deliberately out of scope (owner decision)
- Tests that touch Firestore must use the local emulator; never production; never read ~/.config/configstore/firebase-tools.json

## Output
A verdict (READY / READY WITH CHANGES / NOT READY), then numbered findings each with severity (HIGH/MEDIUM/LOW), evidence (file:line), and a concrete fix. Be concise; no praise.
