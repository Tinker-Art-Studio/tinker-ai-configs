Verdict: **merge after fixes**

1. **[blocking] Force-run retries can change keys across UTC midnight.** [functions/vault/export-run.js:51](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:51), [tests/functions/vault/export-run.test.js:354](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:354)

   A late-Saturday Force run demonstrates the gap:

   - Initial attempt at `2026-10-10T23:59:59Z`, header `2026-10-11T09:00:00Z` → key `2026-10-10`.
   - Retry after midnight with the same header at `2026-10-11T00:10:00Z` → key `2026-10-11`.

   Because “already done” and “resume” only search the computed date prefix ([export-run.js:118](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:118), [export-run.js:134](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:134)), the retry ignores the Saturday folder/operation and may start a second Sunday export. Sunday’s scheduled run can then skip as already done. A first attempt may run for 25 minutes, so midnight crossing is realistic even before retry backoff.

   The new test checks only a successful first attempt, not retry stability across midnight. Add a failure/resume test spanning midnight. More fundamentally, `scheduleTime` plus the current clock cannot distinguish “Saturday Force-run retry” from “new Sunday Force run”; a stable identifier/state or a different manual-run mechanism is needed. A clock-skew tolerance does not solve that ambiguity.

   The runbook’s unconditional retry claim is consequently overstated at [FUNCTIONS-ROLLBACK.md:220](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:220), as is Decision #64’s implication that the change fully handles Force runs at [docs/my-clay-hub/DECISIONS.md:81](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DECISIONS.md:81).

Other requested checks:

- Ordinary Scheduler clock skew needs no tolerance for this `09:00 UTC` schedule: even a slightly early delivery still falls on the same UTC Sunday. Only implausible skew of at least nine hours would change the date.
- The key is computed exactly once from `start = now()` and retained for the invocation: [export-run.js:100](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:100).
- Freshness uses metadata-object `timeCreated`, not the folder’s date key, so the change itself introduces no false freshness alarm: [freshness.js:20](/Users/christiehubley/my-clay-hub/functions/vault/freshness.js:20).
- The pre-restore guidance remains correct: a Force run cannot guarantee a new uniquely identifiable copy, whereas the explicit `manual/pre-restore-*` export does: [DATA-RESTORE.md:42](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:42).
