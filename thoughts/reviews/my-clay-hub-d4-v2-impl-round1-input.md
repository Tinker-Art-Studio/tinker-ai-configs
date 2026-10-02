## Change under review — My Clay Hub D-4, phase V-2: scheduled functions in the functions deploy guard

Repo: /Users/christiehubley/my-clay-hub, branch `d4-guard-schedules`. The change is uncommitted or in the newest commit on that branch; see `git diff origin/main`.
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html. Read choices V2 and V3, phase V-2, facts J1–J16, the "Christie's decisions" table (O5, O6), and the Decisions log.
Guard design it extends: /Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html (F1–F14, K1–K17).

### What changed
- `scripts/deploy-functions.sh`:
  - JQ_MANIFEST: exact declaration key sets per trigger kind; https or schedule only; the schedule, timeZone (UTC) and five retry values must be numbers/strings equal to the declaration; requiredAPIs is exactly `[{api: cloudscheduler…, reason}]` when a schedule exists, otherwise empty; timeout ≤ 1800.
  - JQ_F8: a live schedule must be `scheduleTrigger {}` with the `deployment-scheduled` label; an HTTP function must not carry that label.
  - JQ_ATTEST_SHAPE: adds the always-present `schedulerJobList` and `schedulerJobs` keys.
  - JQ_ATTEST: a schedule's expected invoker is its runtime account.
  - New JQ_SCHED: the Scheduler reading against the declarations, including the complete job list across every codebase.
  - read_back records `live_uri.<id>` and `expected_attempt_deadline.<id>`.
  - --attest writes `scheduler_attested`. Its exit is 0 only when IAM is yes and the scheduler reading is yes or n/a.
  - attest_need always needs a reading for a codebase with a schedule.
  - The reading template now includes the Scheduler block and the transcription format.
  - --status shows `scheduler_attested`.
- `scripts/lib/receipts.sh`: `scheduler_attested_of`. A record written before D-4 that lacks the line reads as "unknown". A malformed or repeated line fails closed.
- `scripts/predeploy-check.sh` (the backstop the CLI runs): the seal check branches on the declared trigger, with the same schedule rules as JQ_MANIFEST.
- `scripts/functions-emulator.mjs`: runs every codebase in firebase.json, and its skip names each missing install. Session 3 is a new schedule-probe fixture.
- `functions/declarations.json`: the canary gains `"trigger": "https"`.
- Tests:
  - `scripts/deploy-functions.test.sh`: ~200 new assertions; the fake CLI now lists scheduled functions as the real CLI does.
  - `tests/unit/predeploy-check-functions.test.js`: 16 new seal cases.
  - `tests/functions/schedule-probe.test.js` plus its fixture.
  - `tests/functions/manifest.test.js`: declarations filtered by codebase, plus a schema test.
  - `tests/unit/functions-emulator.test.js` and `tests/unit/firebase-config.test.js`.
  - `tests/fixtures/` holds a copy of the real Oct 1 attest record, for the old-record regression.
- Docs: FUNCTIONS-ROLLBACK.md (§7 and the new §9), CLAUDE.md and AGENTS.md (Christie's header exception O6), DECISIONS #62.

### Acceptance (plan V-2)
- The guard deploys and verifies a correct scheduled function in its fake-CLI tests.
- It refuses each wrong one by name, before upload.
- It records `scheduler_attested` only from a matching, complete Scheduler reading.
- Everything the canary relied on behaves as before, including `--status --codebase core` over its real Oct 1 record. The only differences are the two always-present reading keys and the deliberately updated tests.

### Test results so far
`npm run test:unit` 224/224, `test:guard` (rules) 196/196, `test:functions-guard` 836/836, `test:functions` (3 emulator sessions) 10 + 2 + 3, all passing. Mutation checks on 18 new refusals are being run separately.

### What to review
1. Correctness against the pinned sources: firebase-tools 15.22.3 in `node_modules/firebase-tools/lib`, and firebase-functions 7.4.0 in `functions/core/node_modules`.
   - Could a scheduled function ship with wrong or unset schedule/retry values, a public invoker, or an undeclared trigger?
   - Do the guard (JQ_MANIFEST) and the backstop truly agree?
2. Fail-closed reading: is `scheduler_attested_of` right? Does any path die on a pre-D-4 record, or accept a malformed one?
3. JQ_SCHED:
   - Are the job name (case kept), list semantics across codebases, audience/body/headers rules and attempt deadline right?
   - The deadline comes from the attempt record (`expected_attempt_deadline`), and the uri from `live_uri`. What happens for attempts made by `--reconcile` or `--clear-inflight` (no read_back for clear-inflight)?
4. Regressions for the HTTP-only canary path. Is anything subtly changed: message texts other tooling greps, exit codes, the record format?
5. Test quality:
   - Are the new tests asserting values, not just exit codes?
   - Are any of them vacuous?
   - Is there missing coverage, e.g. `--reconcile` of a scheduled codebase, or `--reverify`?
6. Docs: anything inaccurate in FUNCTIONS-ROLLBACK.md §9 or DECISIONS #62?

### Constraints
- This is a read-only review. Run no deploy, no command that changes cloud state, and no git command that writes. You may run the test suites; they're offline.
- Never read ~/.config/configstore/firebase-tools.json.

### Output
Give a verdict ("safe to merge", "merge after fixes", "not ready"). Then list findings as blocking / should-fix / nits, each with file:line and evidence. Be concise.
