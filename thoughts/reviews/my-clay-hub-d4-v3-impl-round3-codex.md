No findings.

- **Blocking:** none.
- **Should-fix:** none.
- **Nit:** none.

Both round-2 should-fixes are resolved:

- Pre-restore exports now require a never-used timestamped folder, confirmation of that specific operation’s success, and verification of its own metadata file: [DATA-RESTORE.md:41](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:41).
- The production deadline primitive now has real-timer, late-rejection, zero-budget, and bucket-label coverage: [deadline.test.js:11](/Users/christiehubley/my-clay-hub/tests/functions/vault/deadline.test.js:11). `listOperationsAsync` is included in the timeout-option assertion: [export-run.test.js:290](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:290). The pagination wording was also corrected: [export-run.test.js:208](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:208).

Removing `unref()` is safe. The timer is cleared whenever the raced call settles, and when the timer wins it has already fired; it cannot extend the request beyond its deadline: [deadline.js:10](/Users/christiehubley/my-clay-hub/functions/vault/deadline.js:10). A still-pending promise alone does not keep Node alive. Any underlying client handles are independent of this timer.

The timeout layers interact correctly:

- Firestore calls receive `min(timeLeft, 90s)`: [export-run.js:102](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:102), [vault-config.js:20](/Users/christiehubley/my-clay-hub/functions/vault/vault-config.js:20).
- Every call remains enclosed by the global wall-clock limiter.
- Polling sleeps 15 seconds only when more than 15 seconds remain; the following read is limited to the remaining budget: [export-run.js:181](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:181).
- Operation-list pagination reuses its initial gax settings, but each `next()` is still wall-clock bounded: [export-run.js:123](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:123).

Verification: 50/50 focused non-emulator vault tests passed under Node 22; `git diff --check HEAD^ HEAD` passed; worktree remained clean. No regression found in commit `99aed003691d759d8d93a18f7343b6753eee4c21`.

safe to merge
