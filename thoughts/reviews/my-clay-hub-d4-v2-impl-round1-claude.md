I could not run the suites — every `npm` / `node` / `bash` invocation needed interactive approval in this session, so the "all passing" numbers are unverified by me. Also note the **working tree changed under me mid-review** (files at 20:29 vs. commit c8141f8 at 20:22); I reviewed the current working tree, which already fixes several things that were wrong in the commit (`live_uri` now read from the newest verify record, `ALL_DECL` from each codebase's newest *attempt*, attest format bumped to `-2`, predeploy checking the declaration's schedule key set).

## Verdict: merge after fixes

The pre-upload half is sound. I checked it against firebase-tools 15.22.3 and firebase-functions 7.4.0 and could not construct a scheduled function that ships with a wrong/unset schedule or retry value, a public invoker, or an undeclared trigger. The weaknesses are in the post-deploy reading and in one recovery path.

Verified against the pinned sources: job name `firebase-schedule-${id}-${region}`, case kept (`backend.js:189`); `attemptDeadline = max(min(timeout,1800),180)` (`cloudscheduler.js:148`, `validate.js:28-29`); invoker forced to the runtime account for schedules (`fabricator.js:382`, `:484`) — so `JQ_ATTEST`'s `$want` is right; `deployment-scheduled: "true"` + `scheduleTrigger: {}` on read-back (`cloudfunctionsv2.js:254`, `:302`); `uri` is copied for scheduled v2 endpoints, so `live_uri` works; unset timeZone/retries serialise as `null` via `RESET_VALUE` (`manifest.js:116-137`), which both checkers refuse. Guard and backstop agree on every rule that matters (`timeoutSeconds` presence comes from F14 at `deploy-functions.sh:234-235`, matching predeploy's explicit `type == "number"`).

### Blocking

**1. `--reverify` / `--reconcile` of the one real attempt is now dead.** `scripts/deploy-functions.sh:191`
`build_expected` → `manifest_check` (`:577-589`) runs the **tip's** `JQ_MANIFEST` against the **attempt's** `functions/declarations.json`. The live attempt `deployed/my-clay-hub/functions-core/20261001T045900Z-7efa0f0` points at a commit whose declarations have no `trigger` key:
```
$ git show 7efa0f0:functions/declarations.json
{ "core/canary": { "serviceAccount": "...", "invoker": ["private"], "ingress": "ALLOW_ALL" } }
```
→ `declaration core/canary: trigger null is not https or schedule` → `die EX_MANIFEST (24)`. `--attest` of it still works (JQ_ATTEST's `$dc[$id].trigger` is null and falls to the invoker branch), but the documented read-back recovery for the function that is actually in production does not. This contradicts the acceptance criterion "everything the canary relied on behaves as before". No test covers reverifying a pre-D-4 attempt. Fix: treat a missing `trigger` as `https` for a declaration older than D-4, or add an explicit, tested, documented refusal with a recovery instruction.

**2. The Cloud Scheduler `headers` check is either vacuous or always wrong.** `scripts/deploy-functions.sh:404` and `:840`
`JQ_SCHED` refuses any job with headers (`($j.headers | length) > 0`), but the reading template at `:840` hands Christie the literal passing value: `headers: {}` — unlike every neighbouring field, which is a `<placeholder>`. So the one field she is told not to read is the one the check depends on. Worse, Cloud Scheduler sets `User-Agent: Google-Cloud-Scheduler` on every HTTP-target job and returns it in the job resource (`gcloud scheduler jobs describe` shows it under `httpTarget.headers`); firebase-tools sets no headers of its own (`cloudscheduler.js:132-138`). So a *faithful* transcription of a correct job yields `scheduler_attested=no` permanently on the first real scheduled deploy. Decide which it is: allow exactly `{"User-Agent": "Google-Cloud-Scheduler"}` (and make the template a placeholder), or document that the Console's header table is to be read as empty. The test at `deploy-functions.test.sh:890` bakes in `headers: {}`, so it cannot catch this.

### Should-fix

**3. `scheduler_attested_of` is right, but the attest-format bump isn't documented.** `scripts/lib/receipts.sh:175-189`
The logic is correct and fail-closed: missing line + `format=tinker-functions-attest-1` → `unknown`; missing line on any other format → `return 1`; duplicated line → `record_field` returns 1; bad word → `record_word` returns 1. But `FUNCTIONS-ROLLBACK.md` never mentions `tinker-functions-attest-2` or that a format-2 record lacking the line is treated as corrupted — that is exactly the sort of thing §4's hand-recovery needs.

**4. `FUNCTIONS-ROLLBACK.md:135` is now inaccurate.** It says the job list "holds every job the project's **declarations** expect (e.g. `vault`'s, once it exists)". The working-tree code (`deploy-functions.sh:1166-1179`) deliberately uses each other codebase's **newest deployed attempt**, precisely so a declared-but-undeployed schedule expects no job. The doc still describes the behaviour the code just moved away from, and "once it exists" reads as "once the declaration exists".

**5. The codebase enumeration fails silently.** `scripts/deploy-functions.sh:1172`
```bash
for ocb in $(git show "${MAIN_SHA}:firebase.json" | "$JQ" -r '.functions[].codebase'); do
```
Every other read in the block carries `|| die`, and the comment two lines above claims "FAIL-CLOSED: an unreadable record refuses" — but a failing `git show`/`jq` here just yields an empty list and the loop is skipped. The direction happens to be conservative (other codebases' real jobs then show up as *extra*, giving `no`), so it is not exploitable, but the comment overstates it and the failure is invisible. Capture the list into a variable with `|| die`.

**6. Real discovery is never run over a scheduled codebase.** `tests/functions/schedule-probe.test.js:18-28`
`wire()` reconstructs the manifest by hand (`{...fn.__endpoint, entryPoint: id}` plus a hand-rolled `requiredAPIs` dedupe) instead of running `scripts/functions-discover.mjs`, which is what the guard actually consumes. Everything the guard checks beyond `.manifest` — `.build.endpoints[id].runtime` (asserted at `deploy-functions.sh:233`), `.expectedHashes`, `.firebaseConfigEnv` — is therefore modelled only by the fake CLI in `deploy-functions.test.sh`. Session 3 already has a scratch codebase and core's install; running the real discovery against it would close the last modelling gap cheaply. (I read `discovery/v1alpha1.js:159-166` and `cache/hash.js` and expect it to pass — which is the point of asserting it.)

**7. `--reverify` that failed to read production shadows a good attempt record.** `scripts/deploy-functions.sh:1182-1189`
`VSRC` is the newest verify record unconditionally. A `--reverify` whose `functions:list` failed writes `live_uri.*=unknown`, and `--attest` then reports "the attempt recorded no live uri" even though the attempt itself holds a good one. Falling back per-key (verify record, else attempt) would match the intent of the comment.

### Nits

- `scripts/deploy-functions.test.sh:1025` — `OLD2` is assigned and never used.
- `tests/unit/functions-emulator.test.js:42` — `assert.deepEqual(codebases(fj), fj.functions.map((f) => f.codebase))` restates `codebases`' body; it asserts nothing.
- `CLAUDE.md` / `AGENTS.md` still say the functions suite needs `functions/core` installed; `functions-emulator.mjs` now requires every codebase in `firebase.json`. True today (one codebase), stale the moment `vault` lands.
- `JQ_ATTEST_SHAPE:327` requires `oidcServiceAccount` to be a string, so a job with an OAuth token or no auth can't be expressed — Christie would have to invent a value. Fail-closed, but worth a word in §9.
- `schedulerJobList` is read for `us-central1` only (`attest_help:836`); a stray job in another region is invisible. `REGION` is pinned, so this is only a note.
- The acceptance claim "the only differences are the two always-present reading keys" undersells it: the attest record format changed to `-2` and `--status` gained a line.

### On the rest of the brief

- **Test quality** is good: `sched_no` asserts the exit code, the recorded value, that `iam_attested` is still judged independently, *and* the message text; `refuse_sched`/`refuse_decl` also assert that nothing deployed and no record exists. `--reconcile` and `--clear-inflight → --reverify → --attest` of a scheduled codebase are both covered (added in the working tree). The pre-D-4 `--status` regression test uses a real copy of the Oct 1 record. I found no vacuous assertions beyond nit 2 and the `headers: {}` issue in finding 2.
- **HTTP-only canary regressions**: the predeploy success line, `API_ENABLED_LINE` and `SKIP_LINE` are untouched; exit codes are unchanged; the record gains lines but no existing key changes meaning. The one real regression is finding 1.
- Worth recording as a design strength, not a defect: `cloudscheduler.js:84-109` (`needUpdate`) compares only schedule, timeZone, attemptDeadline and retryConfig — a changed target URI or OIDC account does **not** patch the job, and nothing the CLI can read would show it. The always-needed reading (`attest_need` at `:764-769`) plus the `targetUri`/`oidcServiceAccount` checks are the only thing that catches that. `--approved` still exits 0 before any of it, so the "IAM reading NEEDED" line is load-bearing.
