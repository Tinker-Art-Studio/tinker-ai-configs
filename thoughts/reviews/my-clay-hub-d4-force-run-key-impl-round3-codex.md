Verdict: **safe to merge**.

1. **[nit] The 12-hour boundary assertions do not distinguish the two branches.**  
   [tests/functions/vault/export-run.test.js:401](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:401)  
   Both “exactly 12 h” and “just over” remain on `2026-10-04`, so those assertions would pass with either scheduled-time or manual-time behavior. The Wednesday assertion does prove stale times use today. A future cleanup could place the threshold across UTC midnight to prove `>` versus `>=`; this is not merge-blocking.

Confirmations:

- The threshold cannot affect an ordinarily delivered scheduled run or configured retry. Four attempts consume at most approximately 2 h 50 min using the code’s 1,500-second budget plus 10/20/40-minute backoffs; even using the 30-minute platform timeout gives about 3 h 10 min—well below 12 hours. `maxRetrySeconds: 0` does not add retries beyond `retryCount: 3`. This guarantee assumes normal Scheduler delivery; an extraordinary Google-side delay exceeding 12 hours would necessarily be classified as stale.
- The rewritten midnight test now exercises both attempts through `runExport`, genuinely crosses UTC midnight, produces two separately keyed complete folders, and verifies the scheduled Sunday run creates no third export.
- The Force-run and stale-header tests establish the intended keying behavior. The wiring test correctly avoids becoming stale relative to the real clock.
- The runbook and Decision #64 accurately describe the behavior, the possible duplicate/failure notification, the approximately three-hour retry envelope, and the MDT/MST conversions.
- `git diff --check` passed.
- The permitted test command passed: **31/31 tests**, 0 failures.
- No blocking or should-fix findings.
