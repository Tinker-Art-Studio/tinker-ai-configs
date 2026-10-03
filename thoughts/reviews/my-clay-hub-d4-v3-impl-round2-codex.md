No blocking findings. Two should-fixes remain.

## Findings

1. **Should-fix — the pre-restore export destination is not unique, so the round-1 “fresh copy” finding is only partially resolved.**  
   [DATA-RESTORE.md:41](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:41) correctly replaces the unreliable Force run with a manual export, but [line 44](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:44) always uses `manual/pre-restore-<YYYY-MM-DD>`. Export prefixes cannot be reused, so a second restore attempt on the same UTC date either fails or risks someone mistaking the existing metadata file for verification of a new export. Use a unique timestamp/random suffix and require the newly started operation itself to finish successfully before checking its metadata file.

2. **Should-fix — the production deadline primitive and complete gax-option wiring are not actually tested.**  
   The hung-call tests inject `fakeTimeLimit`, so they never execute `realTimeLimit` in [deadline.js:8](/Users/christiehubley/my-clay-hub/functions/vault/deadline.js:8). The `{timeout}` assertion covers `exportDocuments` and `getOperation`, but not `listOperationsAsync` ([export-run.test.js:290](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:290)). The implementation is correct by inspection, but this is the central round-1 safety fix. Add small real-timer tests covering:

   - `realTimeLimit` rejecting a hung promise;
   - a late rejection after losing the race producing no `unhandledRejection`;
   - `listOperationsAsync` receiving a positive remaining `{timeout}`.

3. **Nit — one pre-existing test still overstates its fake’s pagination fidelity.**  
   The operation-cap test says it reads “across pages,” but `fakeAdmin.listOperationsAsync` yields one decoded in-memory list rather than modeling page requests. It meaningfully proves iteration to the end and the 1,000/1,001 cap; it does not prove page-boundary behavior.

## Round-1 findings

Everything else is resolved:

- Every Google call is bounded by the shared deadline through [export-run.js:100-102](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:100), including bucket listings, operation iteration, export start and polling ([lines 111-122](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:111), [162-169](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:162), [176-188](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:176)). Starting an export with less than five minutes left is refused at [lines 148-151](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:148).
- `vaultFresh` has one 20-second deadline across all listings, leaving ten seconds before its function timeout ([freshness.js:30-39](/Users/christiehubley/my-clay-hub/functions/vault/freshness.js:30)).
- Restore permission failure now stops for Christie’s approval ([DATA-RESTORE.md:84-88](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:84)).
- Scratch databases must be deny-all before import ([DATA-RESTORE.md:37-40](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-RESTORE.md:37)).
- DECISIONS now accurately limits importing to Christie by hand ([DECISIONS.md:80](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DECISIONS.md:80)).
- The metadata-completeness assumption gets an explicit live V-4 check in the plan.
- Unknown states are evaluated only after identifying the operation as this run’s ([export-run.js:126-128](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:126)).
- Suffixes exclude both observed folders and operation prefixes ([export-run.js:148-159](/Users/christiehubley/my-clay-hub/functions/vault/export-run.js:148)).
- Folder listings now have a page cap ([vault-bucket.js:17-38](/Users/christiehubley/my-clay-hub/functions/vault/vault-bucket.js:17)).
- The formerly untested race and defensive bucket branches are covered ([export-run.test.js:318](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:318), [vault-bucket.test.js:11](/Users/christiehubley/my-clay-hub/tests/functions/vault/vault-bucket.test.js:11)).
- The deployed handler wiring is exercised with only client construction replaced ([wiring.test.js:7](/Users/christiehubley/my-clay-hub/tests/functions/vault/wiring.test.js:7)).
- Keeping `firebase-admin` is consistent with its peer-dependency role and documented V1 choice.

## Deadline and lost-race assessment

The gax `{timeout}` usage is correct and is measured in milliseconds. Gax applies it to the RPC and retry total ([gax.js:168-179](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/google-gax/build/src/gax.js:168)); `getOperation` forwards it directly, while `listOperationsAsync` builds call settings from it and reuses them for page requests ([operationsClient.js:191-202](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/google-gax/build/src/operationsClient.js:191), [364-368](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/google-gax/build/src/operationsClient.js:364)). `exportDocuments` likewise forwards the options unchanged ([firestore_admin_client.js:1393-1424](/Users/christiehubley/my-clay-hub/functions/vault/node_modules/@google-cloud/firestore-api/build/src/v1/firestore_admin_client.js:1393)).

A timeout can report `exportDocuments` as failed after Google accepted it. That does not create a false success:

- the retry first detects a completed folder;
- otherwise it detects and resumes the operation;
- if operation listing visibility lags, it can start a second export under O5, but with a distinct prefix;
- success still requires a successful operation and exact metadata file.

That visibility-lag outcome is explicitly tested at [export-run.test.js:119-137](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:119).

No unhandled rejection is left by a lost race: `Promise.race` installs fulfillment and rejection handlers on the underlying promise, and the already-expired path explicitly consumes a later rejection at [deadline.js:18-25](/Users/christiehubley/my-clay-hub/functions/vault/deadline.js:18). Storage calls are not actively cancelled, but their eventual settlement is consumed and cannot change the returned result.

I found no normal asynchronous path that can consume the remaining five-minute margin and reach Cloud Run’s 1,800-second timeout. As with all JavaScript timers, absolute wall-clock guarantees cannot survive several minutes of event-loop suspension, but that is not an application path.

The fixes did not regress behavior that was correct in round 1. Focused vault tests passed under Node 22: **41/41**. `git diff --check` also passed. I did not run the entire repository suite.

merge after fixes
