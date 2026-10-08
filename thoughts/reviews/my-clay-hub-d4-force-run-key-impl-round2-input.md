## Round 2 (confirming pass) — PR Tinker-Art-Studio/my-clay-hub#12, now at d93784e
Repo /Users/christiehubley/my-clay-hub, branch d4-force-run-key. Read-only: do not modify files, deploy, or use the network.

Your round-1 review (verdict "merge after fixes") is below, followed by the round-1 brief. Response: your one blocking finding (a Force-run retry crossing UTC midnight gets the new day's key) was traced and accepted as a documented limit rather than redesigned, because its worst outcome is O5's already-accepted duplicate: two exports, distinct prefixes, never a mixed folder; crossing into Sunday makes a genuinely-Sunday copy, so the 09:00 run's "already done" is correct; freshness uses metadata timeCreated. Commit d93784e adds a test proving exactly that, and corrects FUNCTIONS-ROLLBACK.md §10 and DECISIONS #64 (no overclaim; runbook: start Force runs before 20:00 UTC).

Please: (1) say whether that reasoning holds — any path where the midnight crossing loses a week's copy, corrupts a folder, or causes a false freshness alarm? (2) check the new test really exercises the crossing (tests/functions/vault/export-run.test.js, the "crosses UTC midnight" test) and the doc wording; (3) anything else. Verdict (safe to merge / merge after fixes / not ready) and numbered findings marked blocking / should-fix / nit with file:line.

## Your round-1 review
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

## Diff since round 1 (884d5f2..d93784e)
diff --git a/FUNCTIONS-ROLLBACK.md b/FUNCTIONS-ROLLBACK.md
index f6ec2d4..5e55d0f 100644
--- a/FUNCTIONS-ROLLBACK.md
+++ b/FUNCTIONS-ROLLBACK.md
@@ -215,6 +215,9 @@ while the newest complete copy is at most 7 days 18 hours old. Plan: `~/tinker-a
 - **A manual catch-up run:** Cloud Scheduler → the job → **Force run**. Google sends a Force run the job's *next*
   scheduled time (seen Oct 7 2026), so `vaultExport` keys a run whose scheduled time is still in the future by the day
   it actually runs. A weekday catch-up therefore never takes the coming Sunday's key, and Sunday still exports.
+  The header can't tell a Force run's retry from a new Force run, so a retry that crosses UTC midnight (6 PM MDT) is
+  keyed by the new day and starts its own export: at most one extra complete copy, in its own folder (O5). Best
+  started before 20:00 UTC (2 PM MDT), so the run and its retries (up to about 2¾ h) finish the same UTC day.
 - **A failure email** (log-based alert on `vaultexport` errors, V13): read the function's log. Its first line holds the
   run's scheduleTime and key (the date); the error names the operation and the prefix. Scheduler retries three times
   (about 10, 20, 40 minutes apart). A retry never starts a second export while the first is visible: it finds the
diff --git a/docs/my-clay-hub/DECISIONS.md b/docs/my-clay-hub/DECISIONS.md
index 67a1600..558257b 100644
--- a/docs/my-clay-hub/DECISIONS.md
+++ b/docs/my-clay-hub/DECISIONS.md
@@ -78,4 +78,4 @@ These come from the foundation plan (`~/tinker-ai-configs/thoughts/plans/clayhub
 | 61 | D2 | Oct 1 | **IAM readings only when needed** (replaces "after every deploy"). The functions guard records `attest_needed` and why: needed for an unverified deploy, the first deploy of a codebase, a changed function set, declarations, IAM expectations, `firebase.json` or `.firebaserc`, a Google API turned on during the deploy, or a reading still owed. Otherwise "not needed", naming the attestation it relies on. | Christie asked why each deploy needed so many Console screenshots. The automatic checks (hash, settings, the unauthenticated probe) still run every time. A role changed by hand in the Console isn't seen, so take a reading after one. |
 | 62 | D-4 | Oct 1 | **Scheduled functions in the functions guard** (F13 amended for schedules only; plan `my-clay-hub-d4-vault-export`, V2/V3). A function is declared `"trigger": "https"` or `"trigger": "schedule"`; a declaration's keys are exact. A schedule declares its schedule, `timeZone` `"UTC"` and all five retry values, and no invoker (the CLI makes the runtime account its only caller); the guard and the backstop refuse a manifest whose values differ or are unset. The CLI can't read a Cloud Scheduler job, so Christie reads it in the Console and `--attest` checks it (`scheduler_attested`; the complete job list = every DEPLOYED schedule, i.e. each codebase's newest attempt). **Exception to "every HTTP response sets `x-tinker-reached`":** scheduled functions, whose response firebase-functions writes itself; the unauthenticated probe must still be refused. | M6 required the guard to read the schedule back before D-4's function ships; the CLI never clears a retry setting removed from code, and can't see a job at all. Christie chose the header exception (O6). |
 | 63 | D-4 | Oct 2 | **The weekly vault export** (plan `my-clay-hub-d4-vault-export`, V1, V4–V12, O5). A second functions codebase, `vault`, separate from the canary: `vaultExport` (scheduled, Sundays 09:00 UTC, 3 retries about 10/20/40 min apart, 30-min timeout) copies the whole database to its own folder `weekly/<UTC date>-<6 chars>/` in bucket **`my-clay-hub-vault-exports`** in `tinker-hq-vault` (US multi-region, 56-day lifecycle, 7-day soft delete, no versioning, no retention lock), and waits for Google to finish, every call held to the run's 1,500 s budget; it succeeds only when the export is done, error-free, SUCCESSFUL, at the expected prefix, and its folder is complete. A retry finds a complete folder ("already done") or the running export ("resume") before it starts anything; a rare duplicate is a second complete copy in its own folder, never a mixed one (O5). `vaultFresh` answers a Monitoring uptime check: 200 while the newest complete copy is at most 7 d 18 h old (the email lands at about 8 days). Accounts: `vault-export@` (custom role `vaultExporter`: export + operations get/list; `vaultLister` on the bucket), `vault-watch@` (`vaultLister` on the bucket only), the Firestore service agent (`firestoreExportWriter` on the bucket only, granted in V-4). No deployed function or service account can import into production (only Christie, as Owner, by hand: DATA-RESTORE.md). Built on `@google-cloud/firestore-api` 0.2.0 (where Firestore 9.3.0's admin client and protos live) rather than `@google-cloud/firestore` as the plan first named. Restoring: DATA-RESTORE.md. | The project's own backups (PITR, daily backups) live inside the project that could fail; this is the off-project copy that gates real member data (Phase E). Christie chose US, the uptime check and the 7 d 18 h threshold (O2, O4), a rare duplicate over a lock (O5), and a restore rehearsal after Phase E (O3). |
-| 64 | D-4 | Oct 7 | **A Force run is keyed by the day it actually runs.** V-4's failure-first Force run (Wed Oct 7) showed Cloud Scheduler sends a Force run the job's *next* scheduled time (Sunday Oct 11 09:00 UTC), not "now" as the V7 tests assumed, so a weekday catch-up run would have taken the coming Sunday's key and that Sunday's real run would have skipped as "already done". `runKey` now keys a scheduled time still in the future by today's UTC date; a real run and its retries (J15) keep their scheduled date. Until this ships: no Force run at all (on any day, including a Sunday after 09:00 UTC, it would take a later Sunday's key), and V-4's first real export is Sunday Oct 11's scheduled run. | Christie chose it (fix next, before Phase E; don't hold V-4)
+| 64 | D-4 | Oct 7 | **A Force run is keyed by the day it actually runs.** V-4's failure-first Force run (Wed Oct 7) showed Cloud Scheduler sends a Force run the job's *next* scheduled time (Sunday Oct 11 09:00 UTC), not "now" as the V7 tests assumed, so a weekday catch-up run would have taken the coming Sunday's key and that Sunday's real run would have skipped as "already done". `runKey` now keys a scheduled time still in the future by today's UTC date; a real run and its retries (J15) keep their scheduled date. Accepted limit (impl review, Codex): the header can't tell a Force run's retry from a new Force run, so a retry crossing UTC midnight is keyed by the new day and makes at most one extra complete copy in its own folder (O5); if that day is Sunday, the copy is genuinely Sunday's and the 09:00 run's "already done" is correct. Runbook: start Force runs before 20:00 UTC. Until this ships: no Force run at all (on any day, including a Sunday after 09:00 UTC, it would take a later Sunday's key), and V-4's first real export is Sunday Oct 11's scheduled run. | Christie chose it (fix next, before Phase E; don't hold V-4)
diff --git a/tests/functions/vault/export-run.test.js b/tests/functions/vault/export-run.test.js
index 4199c71..daab793 100644
--- a/tests/functions/vault/export-run.test.js
+++ b/tests/functions/vault/export-run.test.js
@@ -365,3 +365,23 @@ test('a Force run carries the NEXT scheduled time (observed Oct 7 2026) and is k
   assert.equal(r.key, '2026-10-07');
   assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-07-aaaaaa'), "not Sunday's key, so Sunday's real run still exports");
 });
+
+test('a Force-run retry that crosses UTC midnight takes the new day\'s key: at most one extra complete copy, each in its own folder (impl review, Codex)', async () => {
+  // Saturday 23:50Z: a Force run (header = Sunday 09:00) started an export that is still running when the attempt ended.
+  const { a, k, run } = setup({ start: '2026-10-11T00:10:00Z' });
+  const saturday = a.seed({ prefix: gs('weekly/2026-10-10-satrun'), pollsToFinish: 10_000 });
+  // Its retry, after midnight, carries the same header but is keyed Sunday, so it neither sees nor resumes Saturday's
+  // export and starts its own: a second complete copy (O5's accepted duplicate), never a shared or mixed folder.
+  const r = await run('2026-10-11T09:00:00Z');
+  assert.equal(r.key, '2026-10-11');
+  assert.equal(r.decision, 'exported');
+  assert.equal(a.exports.length, 1);
+  assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-11-aaaaaa'));
+  assert.notEqual(r.operation, saturday);
+  // Sunday's real 09:00 run then finds that genuinely-Sunday copy complete: "already done", no third export.
+  k.advance(Date.parse('2026-10-11T09:00:05Z') - k.now());
+  const sunday = await run('2026-10-11T09:00:00Z');
+  assert.equal(sunday.key, '2026-10-11');
+  assert.equal(sunday.decision, 'already done');
+  assert.equal(a.exports.length, 1);
+});

## Round-1 brief
## Change under review
PR Tinker-Art-Studio/my-clay-hub#12, branch d4-force-run-key, commit 884d5f2 (base main 6c543ff). Repo: /Users/christiehubley/my-clay-hub (read any file you need; do NOT modify files, run deploys, or touch any network service).

My Clay Hub's weekly vault export (Cloud Function `vaultExport`, onSchedule "every sunday 09:00" UTC, retries 3 at ~10/20/40 min) keys each run by a date: folder `weekly/<YYYY-MM-DD>-<6 chars>/`. Before exporting it checks whether that date already has a complete folder ("already done") or a running export ("resume"); that's how retries never make a second copy (plan V7).

Finding (production, Oct 7 2026): a Cloud Scheduler **Force run** on a Wednesday arrived with `X-CloudScheduler-ScheduleTime` = the job's NEXT scheduled time (Sunday 2026-10-11T09:00Z), so `runKey` returned "2026-10-11". A weekday catch-up run would therefore take the coming Sunday's key and that Sunday's real run would skip as "already done". The old tests assumed a Force run arrives with no header.

Fix: `runKey(scheduleTime, nowMs)` — if the parsed scheduled time is later than now, key by now's UTC date; otherwise by the scheduled time's UTC date (unchanged). A real run and its retries carry a constant scheduled time at/before now (J15: the header "contains the original scheduled invocation time and remains constant across retry attempts").

## Acceptance criteria
- Real Sunday runs and all their retries keep the Sunday key.
- Any Force run, on any day/time (incl. Sunday before or after 09:00 UTC, late Saturday UTC), keys by the UTC date it actually runs.
- No path where a Force run could get a key for a date that hasn't happened yet; no path where a real run changes key between retries.
- Tests prove it and the new test fails on the old code (checked: 1 failure on old code, 46/46 pass with the fix, Node 22).
- Docs (FUNCTIONS-ROLLBACK.md §10, DATA-RESTORE.md §1, DECISIONS #64) are accurate.

## Please check especially
1. Clock skew: could Scheduler deliver a real scheduled run slightly BEFORE its scheduleTime (so `t > now`)? If so the key would be "now"'s date — is that ever a different date than the scheduled date given the 09:00 UTC schedule? Is a tolerance needed?
2. `nowMs` source: runExport passes `start = now()` — confirm the key is computed once per run and never recomputed mid-run (export-run.js around line 93-110).
3. Interaction with the "already done" / "resume" logic and the freshness check (freshness.js) — any new way to get a duplicate, a skipped week, or a false alarm?
4. Interaction with DATA-RESTORE.md's pre-restore copy guidance (line ~42) — still correct?
5. Anything else wrong, missing or overstated in the diff, tests or docs.

Reply with: a verdict (safe to merge / merge after fixes / not ready), then findings numbered, each marked blocking / should-fix / nit, with file:line.

## Diff
diff --git a/FUNCTIONS-ROLLBACK.md b/FUNCTIONS-ROLLBACK.md
index b272525..f6ec2d4 100644
--- a/FUNCTIONS-ROLLBACK.md
+++ b/FUNCTIONS-ROLLBACK.md
@@ -212,6 +212,9 @@ while the newest complete copy is at most 7 days 18 hours old. Plan: `~/tinker-a
 
 - **To stop exports at once:** Cloud Scheduler → `firebase-schedule-vaultExport-us-central1` → **Pause** (§9). Never
   delete the function or the job by hand. Pausing means the freshness alert fires in about 8 days; that's expected.
+- **A manual catch-up run:** Cloud Scheduler → the job → **Force run**. Google sends a Force run the job's *next*
+  scheduled time (seen Oct 7 2026), so `vaultExport` keys a run whose scheduled time is still in the future by the day
+  it actually runs. A weekday catch-up therefore never takes the coming Sunday's key, and Sunday still exports.
 - **A failure email** (log-based alert on `vaultexport` errors, V13): read the function's log. Its first line holds the
   run's scheduleTime and key (the date); the error names the operation and the prefix. Scheduler retries three times
   (about 10, 20, 40 minutes apart). A retry never starts a second export while the first is visible: it finds the
diff --git a/docs/my-clay-hub/DATA-RESTORE.md b/docs/my-clay-hub/DATA-RESTORE.md
index 96f051e..3412654 100644
--- a/docs/my-clay-hub/DATA-RESTORE.md
+++ b/docs/my-clay-hub/DATA-RESTORE.md
@@ -20,7 +20,8 @@ The vault is the last resort, because it lives outside the project that could fa
 ## 1. Choose the folder
 
 In `tinker-hq-vault` → Cloud Storage → `my-clay-hub-vault-exports` → `weekly/`, each export is a folder named
-`<YYYY-MM-DD>-<6 characters>/`, the UTC date of the Sunday it was made (or of a manual "Force run").
+`<YYYY-MM-DD>-<6 characters>/`, the UTC date of the Sunday it was made (or, for a manual "Force run", the UTC date
+of the day it actually ran).
 
 **Use only a complete folder.** A folder is complete when it holds a file named after the folder itself:
 `weekly/2026-10-04-ab12cd/2026-10-04-ab12cd.overall_export_metadata`. The 56-day lifecycle deletes a folder's files
diff --git a/docs/my-clay-hub/DECISIONS.md b/docs/my-clay-hub/DECISIONS.md
index b2e376d..67a1600 100644
--- a/docs/my-clay-hub/DECISIONS.md
+++ b/docs/my-clay-hub/DECISIONS.md
@@ -78,3 +78,4 @@ These come from the foundation plan (`~/tinker-ai-configs/thoughts/plans/clayhub
 | 61 | D2 | Oct 1 | **IAM readings only when needed** (replaces "after every deploy"). The functions guard records `attest_needed` and why: needed for an unverified deploy, the first deploy of a codebase, a changed function set, declarations, IAM expectations, `firebase.json` or `.firebaserc`, a Google API turned on during the deploy, or a reading still owed. Otherwise "not needed", naming the attestation it relies on. | Christie asked why each deploy needed so many Console screenshots. The automatic checks (hash, settings, the unauthenticated probe) still run every time. A role changed by hand in the Console isn't seen, so take a reading after one. |
 | 62 | D-4 | Oct 1 | **Scheduled functions in the functions guard** (F13 amended for schedules only; plan `my-clay-hub-d4-vault-export`, V2/V3). A function is declared `"trigger": "https"` or `"trigger": "schedule"`; a declaration's keys are exact. A schedule declares its schedule, `timeZone` `"UTC"` and all five retry values, and no invoker (the CLI makes the runtime account its only caller); the guard and the backstop refuse a manifest whose values differ or are unset. The CLI can't read a Cloud Scheduler job, so Christie reads it in the Console and `--attest` checks it (`scheduler_attested`; the complete job list = every DEPLOYED schedule, i.e. each codebase's newest attempt). **Exception to "every HTTP response sets `x-tinker-reached`":** scheduled functions, whose response firebase-functions writes itself; the unauthenticated probe must still be refused. | M6 required the guard to read the schedule back before D-4's function ships; the CLI never clears a retry setting removed from code, and can't see a job at all. Christie chose the header exception (O6). |
 | 63 | D-4 | Oct 2 | **The weekly vault export** (plan `my-clay-hub-d4-vault-export`, V1, V4–V12, O5). A second functions codebase, `vault`, separate from the canary: `vaultExport` (scheduled, Sundays 09:00 UTC, 3 retries about 10/20/40 min apart, 30-min timeout) copies the whole database to its own folder `weekly/<UTC date>-<6 chars>/` in bucket **`my-clay-hub-vault-exports`** in `tinker-hq-vault` (US multi-region, 56-day lifecycle, 7-day soft delete, no versioning, no retention lock), and waits for Google to finish, every call held to the run's 1,500 s budget; it succeeds only when the export is done, error-free, SUCCESSFUL, at the expected prefix, and its folder is complete. A retry finds a complete folder ("already done") or the running export ("resume") before it starts anything; a rare duplicate is a second complete copy in its own folder, never a mixed one (O5). `vaultFresh` answers a Monitoring uptime check: 200 while the newest complete copy is at most 7 d 18 h old (the email lands at about 8 days). Accounts: `vault-export@` (custom role `vaultExporter`: export + operations get/list; `vaultLister` on the bucket), `vault-watch@` (`vaultLister` on the bucket only), the Firestore service agent (`firestoreExportWriter` on the bucket only, granted in V-4). No deployed function or service account can import into production (only Christie, as Owner, by hand: DATA-RESTORE.md). Built on `@google-cloud/firestore-api` 0.2.0 (where Firestore 9.3.0's admin client and protos live) rather than `@google-cloud/firestore` as the plan first named. Restoring: DATA-RESTORE.md. | The project's own backups (PITR, daily backups) live inside the project that could fail; this is the off-project copy that gates real member data (Phase E). Christie chose US, the uptime check and the 7 d 18 h threshold (O2, O4), a rare duplicate over a lock (O5), and a restore rehearsal after Phase E (O3). |
+| 64 | D-4 | Oct 7 | **A Force run is keyed by the day it actually runs.** V-4's failure-first Force run (Wed Oct 7) showed Cloud Scheduler sends a Force run the job's *next* scheduled time (Sunday Oct 11 09:00 UTC), not "now" as the V7 tests assumed, so a weekday catch-up run would have taken the coming Sunday's key and that Sunday's real run would have skipped as "already done". `runKey` now keys a scheduled time still in the future by today's UTC date; a real run and its retries (J15) keep their scheduled date. Until this ships: no Force run at all (on any day, including a Sunday after 09:00 UTC, it would take a later Sunday's key), and V-4's first real export is Sunday Oct 11's scheduled run. | Christie chose it (fix next, before Phase E; don't hold V-4)
diff --git a/functions/vault/export-run.js b/functions/vault/export-run.js
index 3a00016..23d86cb 100644
--- a/functions/vault/export-run.js
+++ b/functions/vault/export-run.js
@@ -44,10 +44,14 @@ function randomSuffix() {
 }
 
 // The run key: the UTC date of the scheduled time. The SDK passes "now" when the header is missing (J6); so does this.
+// A scheduled time still in the future is a manual "Force run": Cloud Scheduler sends the job's NEXT scheduled time
+// (observed in V-4, Oct 7 2026: a Wednesday Force run arrived with Sunday's 09:00), so it is keyed by today instead —
+// otherwise a weekday catch-up run would take Sunday's key and Sunday's real run would skip as "already done".
+// A real run and its retries always carry a time at or before now (J15), so they keep the scheduled date.
 function runKey(scheduleTime, nowMs) {
   const t = scheduleTime === undefined || scheduleTime === null || scheduleTime === '' ? new Date(nowMs) : new Date(scheduleTime);
   if (Number.isNaN(t.getTime())) throw new Error(`scheduleTime ${JSON.stringify(scheduleTime)} is not a time`);
-  return t.toISOString().slice(0, 10);
+  return (t.getTime() > nowMs ? new Date(nowMs) : t).toISOString().slice(0, 10);
 }
 
 // V8: the start of the current minute, minus one minute (in the past, on a whole minute, inside any retention window).
diff --git a/tests/functions/vault/export-run.test.js b/tests/functions/vault/export-run.test.js
index 972d4ec..4199c71 100644
--- a/tests/functions/vault/export-run.test.js
+++ b/tests/functions/vault/export-run.test.js
@@ -332,18 +332,36 @@ test('an export that finishes between the folder listing and the operation listi
 });
 
 test('the run key is the UTC date of the scheduled time — across a year end, and from "now" when the header is missing', () => {
-  assert.equal(runKey('2026-12-31T23:59:59.999Z', 0), '2026-12-31');
-  assert.equal(runKey('2027-01-01T00:00:00.000Z', 0), '2027-01-01');
-  assert.equal(runKey('2027-01-03T02:00:00-07:00', 0), '2027-01-03', 'a Denver-offset time is still its UTC date');
+  const LATER = Date.parse('2027-02-01T00:00:00Z');   // a real run and its retries arrive at or after their scheduled time
+  assert.equal(runKey('2026-12-31T23:59:59.999Z', LATER), '2026-12-31');
+  assert.equal(runKey('2027-01-01T00:00:00.000Z', LATER), '2027-01-01');
+  assert.equal(runKey('2027-01-03T02:00:00-07:00', LATER), '2027-01-03', 'a Denver-offset time is still its UTC date');
+  assert.equal(runKey(SUNDAY, Date.parse(SUNDAY)), KEY, 'exactly on time is the scheduled date');
+  assert.equal(runKey(SUNDAY, Date.parse('2026-10-04T09:40:00Z')), KEY, 'a retry 40 min later keeps Sunday');
   assert.equal(runKey(undefined, Date.parse('2027-01-01T00:00:01Z')), '2027-01-01');
   assert.equal(runKey('', Date.parse('2026-12-31T23:59:00Z')), '2026-12-31');
   assert.throws(() => runKey('not a time', 0), /is not a time/);
   assert.equal(snapshotTimeMs(Date.parse('2027-01-01T00:00:30.500Z')), Date.parse('2026-12-31T23:59:00Z'));
 });
 
-test('a run with the header missing uses the clock for its key, and a Force run on another day is its own key', async () => {
+test('a run with the header missing uses the clock for its key', async () => {
   const { a, run } = setup({ start: '2026-10-07T15:30:00Z' });
   const r = await run(undefined);
   assert.equal(r.key, '2026-10-07');
   assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-07-aaaaaa'));
 });
+
+test('a Force run carries the NEXT scheduled time (observed Oct 7 2026) and is keyed by the day it actually runs', async () => {
+  // A Wednesday Force run arrived with scheduleTime = the coming Sunday 09:00 UTC.
+  assert.equal(runKey('2026-10-11T02:00:00-07:00', Date.parse('2026-10-07T18:54:31Z')), '2026-10-07');
+  // On Sunday before 09:00 the next scheduled time is the same day; after 09:00 it is next Sunday. Both key to today.
+  assert.equal(runKey('2026-10-11T09:00:00Z', Date.parse('2026-10-11T06:00:00Z')), '2026-10-11');
+  assert.equal(runKey('2026-10-18T09:00:00Z', Date.parse('2026-10-11T15:00:00Z')), '2026-10-11');
+  // Late on a Saturday (UTC), still Saturday's key — never the coming Sunday's.
+  assert.equal(runKey('2026-10-11T09:00:00Z', Date.parse('2026-10-10T23:59:59Z')), '2026-10-10');
+
+  const { a, run } = setup({ start: '2026-10-07T18:54:31Z' });
+  const r = await run('2026-10-11T09:00:00Z');
+  assert.equal(r.key, '2026-10-07');
+  assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-07-aaaaaa'), "not Sunday's key, so Sunday's real run still exports");
+});
