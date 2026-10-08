## Round 3 (confirming pass) — PR Tinker-Art-Studio/my-clay-hub#12, now at f1dc275
Repo /Users/christiehubley/my-clay-hub, branch d4-force-run-key (checked out). Read-only: do not modify files, deploy, or use the network. You may run `/opt/homebrew/opt/node@22/bin/node --test tests/functions/vault/export-run.test.js tests/functions/vault/wiring.test.js`.

Round 2: Codex "safe to merge" (one nit: the midnight test didn't literally cross midnight). Claude "merge after fixes": (1) a Force run on a paused job might carry a stale PAST time → old key; (2) the midnight test passed on the old code too; (3) MDT times wrong after Nov 1 and "2¾ h" low → ~3 h; (4) mention the possible extra failure email; nits: DECISIONS row's closing pipe, export-run.js header comment.
Commit f1dc275 addresses all of them: runKey also treats a scheduled time >12 h in the past as manual (keyed by today); the midnight test now drives both attempts through runExport across midnight and asserts two complete folders then "already done" (it, the Force-run test and the new stale test all FAIL on main's code — checked: 3 failures — and 48/48 vault tests pass with the fix); wiring.test.js now uses the real clock's time as its scheduled time (a fixed 2026-10-04 would now be "stale"); runbook and DECISIONS #64 updated.

Please confirm: (1) the 12 h threshold can never re-key a real scheduled run or any of its retries (schedule weekly 09:00 UTC; retries at ~10/20/40 min after each attempt ends, each attempt ≤ 30 min; maxRetrySeconds 0); (2) the rewritten tests prove what they claim; (3) the docs are accurate; (4) anything else. Verdict (safe to merge / merge after fixes / not ready) and numbered findings marked blocking / should-fix / nit with file:line.

## Diff since round 2 (d93784e..f1dc275)
diff --git a/FUNCTIONS-ROLLBACK.md b/FUNCTIONS-ROLLBACK.md
index 5e55d0f..723b512 100644
--- a/FUNCTIONS-ROLLBACK.md
+++ b/FUNCTIONS-ROLLBACK.md
@@ -212,12 +212,14 @@ while the newest complete copy is at most 7 days 18 hours old. Plan: `~/tinker-a
 
 - **To stop exports at once:** Cloud Scheduler → `firebase-schedule-vaultExport-us-central1` → **Pause** (§9). Never
   delete the function or the job by hand. Pausing means the freshness alert fires in about 8 days; that's expected.
-- **A manual catch-up run:** Cloud Scheduler → the job → **Force run**. Google sends a Force run the job's *next*
-  scheduled time (seen Oct 7 2026), so `vaultExport` keys a run whose scheduled time is still in the future by the day
-  it actually runs. A weekday catch-up therefore never takes the coming Sunday's key, and Sunday still exports.
-  The header can't tell a Force run's retry from a new Force run, so a retry that crosses UTC midnight (6 PM MDT) is
-  keyed by the new day and starts its own export: at most one extra complete copy, in its own folder (O5). Best
-  started before 20:00 UTC (2 PM MDT), so the run and its retries (up to about 2¾ h) finish the same UTC day.
+- **A manual catch-up run:** Cloud Scheduler → the job → **Force run** (resume the job first if it's paused). Google
+  sends a Force run the job's *next* scheduled time (seen Oct 7 2026), so `vaultExport` keys a run whose scheduled time
+  is in the future, or more than 12 h in the past, by the UTC day it actually runs (DECISIONS #64). A weekday catch-up
+  therefore never takes the coming Sunday's key, and Sunday still exports. Check the run's first log line: its `key`
+  must be today's UTC date. The header can't tell a Force run's retry from a new Force run, so a retry that crosses
+  UTC midnight is keyed by the new day and starts its own export: at most one extra complete copy, in its own folder
+  (O5), and possibly one extra failure email if Google refuses the second export while the first is still running.
+  So start a Force run before 20:00 UTC (2 PM MDT / 1 PM MST): the run and its retries take up to about 3 h.
 - **A failure email** (log-based alert on `vaultexport` errors, V13): read the function's log. Its first line holds the
   run's scheduleTime and key (the date); the error names the operation and the prefix. Scheduler retries three times
   (about 10, 20, 40 minutes apart). A retry never starts a second export while the first is visible: it finds the
diff --git a/docs/my-clay-hub/DECISIONS.md b/docs/my-clay-hub/DECISIONS.md
index 558257b..1faf5f2 100644
--- a/docs/my-clay-hub/DECISIONS.md
+++ b/docs/my-clay-hub/DECISIONS.md
@@ -78,4 +78,4 @@ These come from the foundation plan (`~/tinker-ai-configs/thoughts/plans/clayhub
 | 61 | D2 | Oct 1 | **IAM readings only when needed** (replaces "after every deploy"). The functions guard records `attest_needed` and why: needed for an unverified deploy, the first deploy of a codebase, a changed function set, declarations, IAM expectations, `firebase.json` or `.firebaserc`, a Google API turned on during the deploy, or a reading still owed. Otherwise "not needed", naming the attestation it relies on. | Christie asked why each deploy needed so many Console screenshots. The automatic checks (hash, settings, the unauthenticated probe) still run every time. A role changed by hand in the Console isn't seen, so take a reading after one. |
 | 62 | D-4 | Oct 1 | **Scheduled functions in the functions guard** (F13 amended for schedules only; plan `my-clay-hub-d4-vault-export`, V2/V3). A function is declared `"trigger": "https"` or `"trigger": "schedule"`; a declaration's keys are exact. A schedule declares its schedule, `timeZone` `"UTC"` and all five retry values, and no invoker (the CLI makes the runtime account its only caller); the guard and the backstop refuse a manifest whose values differ or are unset. The CLI can't read a Cloud Scheduler job, so Christie reads it in the Console and `--attest` checks it (`scheduler_attested`; the complete job list = every DEPLOYED schedule, i.e. each codebase's newest attempt). **Exception to "every HTTP response sets `x-tinker-reached`":** scheduled functions, whose response firebase-functions writes itself; the unauthenticated probe must still be refused. | M6 required the guard to read the schedule back before D-4's function ships; the CLI never clears a retry setting removed from code, and can't see a job at all. Christie chose the header exception (O6). |
 | 63 | D-4 | Oct 2 | **The weekly vault export** (plan `my-clay-hub-d4-vault-export`, V1, V4–V12, O5). A second functions codebase, `vault`, separate from the canary: `vaultExport` (scheduled, Sundays 09:00 UTC, 3 retries about 10/20/40 min apart, 30-min timeout) copies the whole database to its own folder `weekly/<UTC date>-<6 chars>/` in bucket **`my-clay-hub-vault-exports`** in `tinker-hq-vault` (US multi-region, 56-day lifecycle, 7-day soft delete, no versioning, no retention lock), and waits for Google to finish, every call held to the run's 1,500 s budget; it succeeds only when the export is done, error-free, SUCCESSFUL, at the expected prefix, and its folder is complete. A retry finds a complete folder ("already done") or the running export ("resume") before it starts anything; a rare duplicate is a second complete copy in its own folder, never a mixed one (O5). `vaultFresh` answers a Monitoring uptime check: 200 while the newest complete copy is at most 7 d 18 h old (the email lands at about 8 days). Accounts: `vault-export@` (custom role `vaultExporter`: export + operations get/list; `vaultLister` on the bucket), `vault-watch@` (`vaultLister` on the bucket only), the Firestore service agent (`firestoreExportWriter` on the bucket only, granted in V-4). No deployed function or service account can import into production (only Christie, as Owner, by hand: DATA-RESTORE.md). Built on `@google-cloud/firestore-api` 0.2.0 (where Firestore 9.3.0's admin client and protos live) rather than `@google-cloud/firestore` as the plan first named. Restoring: DATA-RESTORE.md. | The project's own backups (PITR, daily backups) live inside the project that could fail; this is the off-project copy that gates real member data (Phase E). Christie chose US, the uptime check and the 7 d 18 h threshold (O2, O4), a rare duplicate over a lock (O5), and a restore rehearsal after Phase E (O3). |
-| 64 | D-4 | Oct 7 | **A Force run is keyed by the day it actually runs.** V-4's failure-first Force run (Wed Oct 7) showed Cloud Scheduler sends a Force run the job's *next* scheduled time (Sunday Oct 11 09:00 UTC), not "now" as the V7 tests assumed, so a weekday catch-up run would have taken the coming Sunday's key and that Sunday's real run would have skipped as "already done". `runKey` now keys a scheduled time still in the future by today's UTC date; a real run and its retries (J15) keep their scheduled date. Accepted limit (impl review, Codex): the header can't tell a Force run's retry from a new Force run, so a retry crossing UTC midnight is keyed by the new day and makes at most one extra complete copy in its own folder (O5); if that day is Sunday, the copy is genuinely Sunday's and the 09:00 run's "already done" is correct. Runbook: start Force runs before 20:00 UTC. Until this ships: no Force run at all (on any day, including a Sunday after 09:00 UTC, it would take a later Sunday's key), and V-4's first real export is Sunday Oct 11's scheduled run. | Christie chose it (fix next, before Phase E; don't hold V-4)
+| 64 | D-4 | Oct 7 | **A Force run is keyed by the day it actually runs.** V-4's failure-first Force run (Wed Oct 7) showed Cloud Scheduler sends a Force run the job's *next* scheduled time (Sunday Oct 11 09:00 UTC), not "now" as the V7 tests assumed, so a weekday catch-up run would have taken the coming Sunday's key and that Sunday's real run would have skipped as "already done". `runKey` now keys a scheduled time still in the future, or more than 12 h in the past (a Force run on a paused job might carry an old stored time; impl review, Claude), by today's UTC date; a real run and its retries (J15; all within about 3 h of the scheduled time) keep their scheduled date. Accepted limit (impl review, Codex): the header can't tell a Force run's retry from a new Force run, so a retry crossing UTC midnight is keyed by the new day and makes at most one extra complete copy in its own folder (O5), and possibly one extra failure email; if that day is Sunday, the copy is genuinely Sunday's and the 09:00 run's "already done" is correct. Runbook: start Force runs before 20:00 UTC. Until this ships: no Force run at all (on any day, including a Sunday after 09:00 UTC, it would take a later Sunday's key), and V-4's first real export is Sunday Oct 11's scheduled run. | Christie chose it (fix next, before Phase E; don't hold V-4) |
diff --git a/functions/vault/export-run.js b/functions/vault/export-run.js
index 23d86cb..8bbb98b 100644
--- a/functions/vault/export-run.js
+++ b/functions/vault/export-run.js
@@ -2,7 +2,8 @@
 // the sleep, the time limit, the random suffix and the log are all passed in, so tests/functions/vault/ drives every
 // branch with fakes.
 //
-// The run key is the UTC date of the scheduled time (J15: Cloud Scheduler's retries carry the same scheduled time).
+// The run key is the UTC date of the scheduled time (J15: Cloud Scheduler's retries carry the same scheduled time),
+// except a manual Force run, keyed by the day it actually runs (see runKey; DECISIONS #64).
 // Then, in order:
 //   1. Done already? Any COMPLETE folder weekly/<key>-*/ → "already done"; nothing is started.
 //   2. Running already? This database's operations, filtered to exports whose prefix is gs://<bucket>/weekly/<key>-:
@@ -47,11 +48,15 @@ function randomSuffix() {
 // A scheduled time still in the future is a manual "Force run": Cloud Scheduler sends the job's NEXT scheduled time
 // (observed in V-4, Oct 7 2026: a Wednesday Force run arrived with Sunday's 09:00), so it is keyed by today instead —
 // otherwise a weekday catch-up run would take Sunday's key and Sunday's real run would skip as "already done".
-// A real run and its retries always carry a time at or before now (J15), so they keep the scheduled date.
+// A real run and its retries carry a time at or before now (J15) and arrive within about 3 hours of it (the retries
+// end ~2 h 50 min after the first attempt), so they keep the scheduled date. A time more than STALE_MS in the past is
+// also treated as a manual run (impl review, Claude: a Force run on a paused job might carry an old stored time).
+const STALE_MS = 12 * 3600 * 1000;
 function runKey(scheduleTime, nowMs) {
   const t = scheduleTime === undefined || scheduleTime === null || scheduleTime === '' ? new Date(nowMs) : new Date(scheduleTime);
   if (Number.isNaN(t.getTime())) throw new Error(`scheduleTime ${JSON.stringify(scheduleTime)} is not a time`);
-  return (t.getTime() > nowMs ? new Date(nowMs) : t).toISOString().slice(0, 10);
+  const manual = t.getTime() > nowMs || nowMs - t.getTime() > STALE_MS;
+  return (manual ? new Date(nowMs) : t).toISOString().slice(0, 10);
 }
 
 // V8: the start of the current minute, minus one minute (in the past, on a whole minute, inside any retention window).
diff --git a/tests/functions/vault/export-run.test.js b/tests/functions/vault/export-run.test.js
index daab793..d944a0a 100644
--- a/tests/functions/vault/export-run.test.js
+++ b/tests/functions/vault/export-run.test.js
@@ -332,10 +332,12 @@ test('an export that finishes between the folder listing and the operation listi
 });
 
 test('the run key is the UTC date of the scheduled time — across a year end, and from "now" when the header is missing', () => {
-  const LATER = Date.parse('2027-02-01T00:00:00Z');   // a real run and its retries arrive at or after their scheduled time
-  assert.equal(runKey('2026-12-31T23:59:59.999Z', LATER), '2026-12-31');
-  assert.equal(runKey('2027-01-01T00:00:00.000Z', LATER), '2027-01-01');
-  assert.equal(runKey('2027-01-03T02:00:00-07:00', LATER), '2027-01-03', 'a Denver-offset time is still its UTC date');
+  // A real run and its retries arrive at or after their scheduled time, and within a few hours of it.
+  const after = (iso, ms) => Date.parse(iso) + ms;
+  assert.equal(runKey('2026-12-31T23:59:59.999Z', after('2026-12-31T23:59:59.999Z', 0)), '2026-12-31');
+  assert.equal(runKey('2026-12-31T23:59:59.999Z', after('2026-12-31T23:59:59.999Z', 3 * 3600_000)), '2026-12-31', 'a retry 3 h later, past midnight, keeps its date');
+  assert.equal(runKey('2027-01-01T00:00:00.000Z', after('2027-01-01T00:00:00.000Z', 1000)), '2027-01-01');
+  assert.equal(runKey('2027-01-03T02:00:00-07:00', after('2027-01-03T09:00:00Z', 60_000)), '2027-01-03', 'a Denver-offset time is still its UTC date');
   assert.equal(runKey(SUNDAY, Date.parse(SUNDAY)), KEY, 'exactly on time is the scheduled date');
   assert.equal(runKey(SUNDAY, Date.parse('2026-10-04T09:40:00Z')), KEY, 'a retry 40 min later keeps Sunday');
   assert.equal(runKey(undefined, Date.parse('2027-01-01T00:00:01Z')), '2027-01-01');
@@ -366,22 +368,37 @@ test('a Force run carries the NEXT scheduled time (observed Oct 7 2026) and is k
   assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-07-aaaaaa'), "not Sunday's key, so Sunday's real run still exports");
 });
 
-test('a Force-run retry that crosses UTC midnight takes the new day\'s key: at most one extra complete copy, each in its own folder (impl review, Codex)', async () => {
-  // Saturday 23:50Z: a Force run (header = Sunday 09:00) started an export that is still running when the attempt ended.
-  const { a, k, run } = setup({ start: '2026-10-11T00:10:00Z' });
-  const saturday = a.seed({ prefix: gs('weekly/2026-10-10-satrun'), pollsToFinish: 10_000 });
-  // Its retry, after midnight, carries the same header but is keyed Sunday, so it neither sees nor resumes Saturday's
-  // export and starts its own: a second complete copy (O5's accepted duplicate), never a shared or mixed folder.
-  const r = await run('2026-10-11T09:00:00Z');
-  assert.equal(r.key, '2026-10-11');
-  assert.equal(r.decision, 'exported');
+test('a Force-run retry that crosses UTC midnight takes the new day\'s key: one extra complete copy at most, each in its own folder (impl review, Codex + Claude)', async () => {
+  // Attempt 1: a Force run late on Saturday (header = Sunday 09:00) starts an export that outlives the 1,500 s budget.
+  const HEADER = '2026-10-11T09:00:00Z';
+  const { a, b, k, run } = setup({ start: '2026-10-10T23:50:00Z', admin: { pollsToFinish: 10_000 } });
+  await assert.rejects(run(HEADER), /still running .* the next retry resumes/);
   assert.equal(a.exports.length, 1);
-  assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-11-aaaaaa'));
-  assert.notEqual(r.operation, saturday);
-  // Sunday's real 09:00 run then finds that genuinely-Sunday copy complete: "already done", no third export.
+  assert.equal(a.exports[0].outputUriPrefix, gs('weekly/2026-10-10-aaaaaa'));
+  // Its retry ~10 min after that attempt ended — now past UTC midnight — carries the same header, so it is keyed Sunday:
+  // it can't see Saturday's export and starts its own (with the old code both were keyed 2026-10-11 and it resumed).
+  k.advance(10 * 60_000);
+  assert.ok(k.now() > Date.parse('2026-10-11T00:00:00Z'));
+  a.defaults.pollsToFinish = 2;
+  const retry = await run(HEADER);
+  assert.deepEqual([retry.key, retry.decision], ['2026-10-11', 'exported']);
+  assert.equal(a.exports.length, 2);
+  assert.equal(a.exports[1].outputUriPrefix, gs('weekly/2026-10-11-bbbbbb'));
+  // Saturday's export then finishes too: two complete copies, each in its own folder, never a mixed one.
+  const sat = a.ops.get(`${DB}/operations/AXBkx1`);
+  sat.pollsToFinish = sat.polls + 1;
+  await a.getOperation({ name: sat.name });
+  const folders = b.objects.filter((o) => o.name.endsWith('.overall_export_metadata')).map((o) => o.name.split('/')[1]).sort();
+  assert.deepEqual(folders, ['2026-10-10-aaaaaa', '2026-10-11-bbbbbb']);
+  // Sunday's real 09:00 run finds the genuinely-Sunday copy complete: "already done", no third export.
   k.advance(Date.parse('2026-10-11T09:00:05Z') - k.now());
-  const sunday = await run('2026-10-11T09:00:00Z');
-  assert.equal(sunday.key, '2026-10-11');
-  assert.equal(sunday.decision, 'already done');
-  assert.equal(a.exports.length, 1);
+  const sunday = await run(HEADER);
+  assert.deepEqual([sunday.key, sunday.decision], ['2026-10-11', 'already done']);
+  assert.equal(a.exports.length, 2);
+});
+
+test('a scheduled time more than 12 h in the past is treated as a manual run and keyed by today (impl review, Claude)', () => {
+  assert.equal(runKey('2026-10-04T09:00:00Z', Date.parse('2026-10-04T21:00:00Z')), '2026-10-04', 'exactly 12 h: still the scheduled date');
+  assert.equal(runKey('2026-10-04T09:00:00Z', Date.parse('2026-10-04T21:00:01Z')), '2026-10-04', 'just over, same day anyway');
+  assert.equal(runKey('2026-10-04T09:00:00Z', Date.parse('2026-10-07T18:00:00Z')), '2026-10-07', 'a stale stored time on Wednesday → Wednesday');
 });
diff --git a/tests/functions/vault/wiring.test.js b/tests/functions/vault/wiring.test.js
index 9544895..b99186c 100644
--- a/tests/functions/vault/wiring.test.js
+++ b/tests/functions/vault/wiring.test.js
@@ -15,9 +15,11 @@ test('vaultExport.run passes the admin client, the vault bucket and the schedule
     exports: { firestoreAdmin: () => a, vaultBucket: () => Object.assign(b, { name: 'my-clay-hub-vault-exports' }) } };
   try {
     const { vaultExport } = requireVault('./index.js');
-    await vaultExport.run({ scheduleTime: '2026-10-04T09:00:00Z' });
+    // The real clock runs here, so the scheduled time is "now" (a fixed past date would be keyed by today: DECISIONS #64).
+    const scheduleTime = new Date().toISOString();
+    await vaultExport.run({ scheduleTime });
     assert.equal(a.exports.length, 1);
-    assert.match(a.exports[0].outputUriPrefix, /^gs:\/\/my-clay-hub-vault-exports\/weekly\/2026-10-04-[a-z0-9]{6}$/);
+    assert.match(a.exports[0].outputUriPrefix, new RegExp(`^gs://my-clay-hub-vault-exports/weekly/${scheduleTime.slice(0, 10)}-[a-z0-9]{6}$`));
     assert.equal(a.exports[0].name, 'projects/my-clay-hub/databases/(default)');
     assert.ok(b.objects.some((o) => o.name.endsWith('.overall_export_metadata')), 'it waited for the complete folder');
   } finally {
