Verdict: safe to merge

Reviewer: Claude (independent, confirming pass) on branch d4-force-run-key at f1dc275. Read-only. `node --test tests/functions/vault/export-run.test.js tests/functions/vault/wiring.test.js` (Node 22): 31/31 pass.

All four round-2 should-fix items and both nits are resolved. Nothing blocks the merge, and nothing needs fixing first. The two items below are optional nits.

Answers to the brief:

(1) The 12 h threshold can't re-key a real scheduled run or any of its retries. The worst case for a full retry chain is 4 attempts × the 1,800 s attempt deadline, plus backoffs of 10, 20 and 40 min: 190 min ≈ 3 h 10 min. The 1,500 s run budget makes it ~2 h 50 min in practice. Both are far inside 12 h. maxRetrySeconds 0 adds no time window, and retryCount 3 is the bound. There's also a second margin. Every real header is 09:00 UTC, so a "stale" re-key can only change the key once now has passed the next UTC midnight, which is more than 15 h after the header. From 12 h to 15 h the stale branch returns the same date as the header anyway. So even a real delivery that Scheduler delayed by up to 15 h keeps its date. A delay longer than that would be keyed by the day it ran, which still exports and loses nothing. Each invocation computes the key once from `start` (export-run.js:110-111), so a key can't change partway through a run. The future branch and its boundaries are as in round 2: exactly-on-time is the scheduled date, and a few seconds of early-delivery skew is the same UTC date.

(2) The rewritten tests prove what they claim.
- Midnight test (export-run.test.js:371-397). Both attempts now run through `runExport`. Attempt 1 starts at Sat 23:50Z, exports to `weekly/2026-10-10-aaaaaa`, and throws at the 1,500 s budget. The retry at ~00:25Z, with the same header, is keyed 2026-10-11 and doesn't see Saturday's operation, because the prefix filter is per key. It exports `2026-10-11-bbbbbb`. Then both folders are asserted complete (the fake writes `.overall_export_metadata` when an operation finishes), and the 09:00 run reports "already done" with exports still at 2. On the old code, attempt 1 would be keyed 2026-10-11, so the assertion at :120 fails. This is now a real regression test.
- Stale test (:400-404). The Wednesday assertion fails on the old code, which would return 2026-10-04.
- Year-end and Denver-offset cases (:335-340). They now use realistic "now" values. One is a retry 3 h past the scheduled time that crosses UTC midnight and keeps its date, which pins the "past but within 12 h" branch across a date change.
- wiring.test.js:18-22. It uses the real clock, so `start` is a few ms after the header and the key is the header's date. This also holds at the UTC midnight edge, because a past header under 12 h old keeps its own date. The regex is built from the same string. No flake.

(3) The docs are accurate. FUNCTIONS-ROLLBACK.md §10 (:215-222) now covers these points:
- resume a paused job before a Force run
- the future-or-stale rule
- the log-line check, "key = today's UTC date", which holds for every Force run and for a retry that crossed midnight
- the possible extra failure email
- 20:00 UTC given as 2 PM MDT / 1 PM MST
- "up to about 3 h"

The DECISIONS.md #64 row has its closing pipe and states the 12 h rule and its reason. The export-run.js header (:5-6) and the runKey comment (:48-54) agree with the code.

(4) Other findings: two nits, both optional.

1. nit — tests/functions/vault/export-run.test.js:402. The "just over, same day anyway" assertion is vacuous, because both branches return 2026-10-04 (as its message admits). So the 12 h boundary itself isn't pinned. A mutation from `>` to `>=`, or a 13 h constant, would still pass. If wanted, a header that sits 12 h before a UTC midnight would pin it: `runKey('2026-10-03T12:00:00Z', Date.parse('2026-10-04T00:00:00Z'))` should give '2026-10-03', and the same header with now at `2026-10-04T00:00:01Z` should give '2026-10-04'. Optional. The behaviour that matters (a stale header gets today's key) is already covered by :403.

2. nit — docs/my-clay-hub/DECISIONS.md:81 ("all within about 3 h of the scheduled time") and export-run.js:52 ("~2 h 50 min"). Strictly, the worst case is ~3 h 10 min (with the 1,800 s attempt deadline rather than the 1,500 s budget). "About 3 h" is fair, and the 12 h margin makes the difference irrelevant. No change needed.
