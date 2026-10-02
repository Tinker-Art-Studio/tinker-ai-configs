Verdict: **merge after fixes**.

### Blocking

- [scripts/lib/receipts.sh:175](/Users/christiehubley/my-clay-hub/scripts/lib/receipts.sh:175) treats every attest record lacking `scheduler_attested` as pre-D-4. A newly written/corrupted D-4 record with the field missing therefore returns `unknown` instead of failing closed. The test at [scripts/deploy-functions.test.sh:1016](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:1016) covers an old record and an invalid value, but not a missing field in a post-D-4 record. Distinguish legacy records using their recorded verifier/version/cutover commit.

- [scripts/deploy-functions.sh:1166](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1166) builds the complete Scheduler job list from the attempt’s historical declarations. After `vault` is added, attesting an older-but-newest `core` attempt will expect no vault job: it rejects the correct complete list and can accept an incomplete one. This contradicts [FUNCTIONS-ROLLBACK.md:134](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:134) and V2’s project-wide current list requirement. The complete list must come from the verifier/current declarations; this codebase’s per-job expectations may remain tied to the attempt.

### Should-fix

- [scripts/deploy-functions.sh:1059](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1059) gives `--clear-inflight` records no `live_uri.*` or `expected_attempt_deadline.*`. Although `--reverify` later records both at [scripts/deploy-functions.sh:1142](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1142), `--attest` reads only the attempt at [scripts/deploy-functions.sh:1169](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1169). Thus a cleared scheduled attempt can never receive `scheduler_attested=yes`, even after successful reverify. Reconcile is fine because it calls `read_back`. Add scheduled reconcile, clear→reverify→attest, and ordinary scheduled reverify tests.

- [scripts/predeploy-check.sh:241](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:241) does not fully enforce the declaration rules from `JQ_MANIFEST`: the nested `schedule` key set is not exact and the schedule string need not be non-empty. An extra nested declaration key or matching empty schedule passes the backstop but is refused by the guard. Current tests at [tests/unit/predeploy-check-functions.test.js:442](/Users/christiehubley/my-clay-hub/tests/unit/predeploy-check-functions.test.js:442) omit both cases.

- [FUNCTIONS-ROLLBACK.md:179](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:179) says pausing “changes nothing the guard reads,” but `JQ_SCHED` explicitly requires `state == ENABLED`. [FUNCTIONS-ROLLBACK.md:191](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:191) also overstates that a public scheduled function is refused before upload: the guard relies on the pinned CLI to set the binding, then verifies it through the post-deploy probe and attestation.

### Nits

- [tests/fixtures/functions-core-attest-20261001T141405Z-7efa0f0.txt:15](/Users/christiehubley/my-clay-hub/tests/fixtures/functions-core-attest-20261001T141405Z-7efa0f0.txt:15) has whitespace flagged by `git diff --check`.

The core manifest checks correctly reject wrong/unset schedule and retry values, trigger mismatches, public HTTP invokers, and scheduled timeouts over 1800. The pinned CLI sources support the job name, UTC default, POST/OIDC target, deadline calculation, and forced scheduled-function invoker. Existing HTTP status behavior appears preserved apart from the documented Scheduler status line and record additions. Syntax checks passed.
