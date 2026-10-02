## Verdict: **ready after fixes**

The research behind this plan is unusually good — I checked all thirteen J-facts against the pinned source and Google's current docs and only two are wrong, both in the safe direction. The structure (guard first, own PR, own review; Console steps as readings; before/after on the staff bucket) is sound, and nothing in it can reach `tinker-hq-apps` or `tinker-hq-vault-backups`. But five things would either not execute as written or would let a scheduled function ship with settings nobody checked. Fix those and it's ready.

---

## J-facts: verified against the pinned source

| # | Verdict | Evidence |
|---|---|---|
| J1 | ✔ | `lib/gcp/cloudfunctionsv2.js:299-305` — `labels["deployment-scheduled"]==="true"` → `trigger = {scheduleTrigger:{}}`. `labels`, `hash`, `state` are all copied through (`:417`, `:442-446`), so the label *is* readable by the guard. |
| J2 | ✔ with two additions | `backend.js:189-191` → `firebase-schedule-${id}-${region}`; `cloudscheduler.js:106-109`, `fabricator.js:693-697` passes `endpoint.region`, so the job's **location is `us-central1`**, not an App Engine location. The job id keeps the function's **camelCase** (`firebase-schedule-vaultExport-us-central1`) while the Cloud Run service is lowercased (`vaultexport`) — the attestation fixture must not lowercase it. OIDC SA = `endpoint.serviceAccount` (`cloudscheduler.js:128-131`); `DEFAULT_TIME_ZONE_V2 = "UTC"` (`:21`). |
| J3 | ✔ | `fabricator.js:382-389` (create) and `:484-492` (update): `invoker = endpoint.serviceAccount ? [endpoint.serviceAccount] : [default compute]`, unconditionally. Nothing in code can change it. |
| J4 | ✔ | `cloudscheduler.js:144-152` with `validate.js:28-29` (`DEFAULT…=180`, `MAX…=1800`); `validate.js:152` caps `timeoutSeconds` at 1800 for schedules and `:42-50` only warns. No `attemptDeadline` option in firebase-functions 7.4.0. |
| J5 | ✔ and stronger than stated | `needUpdate` (`cloudscheduler.js:82-106`) compares `retryConfig` with `_.isMatch` — a **partial** match, so live retry fields the new job doesn't mention are ignored as well as uncleared. Also worth recording: the job is created/patched **after** the function (`fabricator.js:161`, `:182`), so a failed `upsert schedule` leaves a live function with no job and a non-zero `cli_exit`. |
| J6 | ✘ two errors | See blocking #1 and #2 below. Handler behaviour is right: `scheduler.js:42-66` — `X-CloudScheduler-ScheduleTime` or `new Date()`, and a thrown error → `logger.error(err.message)` + HTTP 500. |
| J7 | ~ | The Firestore Native page names only roles ("Owner, Cloud Datastore Owner, or Cloud Datastore Import Export Admin"; "Owner or Storage Admin"), no individual permissions. `datastore.operations.get/list` are real permissions but the page doesn't name them — call it an inference, not a doc fact. |
| J8 | ✔ exactly | The Datastore page documents, verbatim, `storage.buckets.get`, `storage.objects.create`, `storage.objects.delete`, `storage.objects.list` for export, and `storage.buckets.get` + `storage.objects.get` for import — which also confirms V14's temporary read grant. |
| J9 | ~ (and V10/O2 is right) | The Datastore page says "**same location** as your database". `nam5` is a US multi-region (replicas us-central1 + us-central2, witness us-east1), so the matching GCS location is the `US` multi-region — `us-central1` would be *narrower* than the database, not equal. Strengthen V10's rationale from "either fits Google's wording" to "`US` is the same-location answer; `us-central1` is not." |
| J10 | ✔ except the PITR clause | "You cannot re-use the same prefix for another export operation" ✔; "listed for a few days after completion" ✔; `PARENT_FOLDER_NAME.overall_export_metadata` ✔. **Wrong:** `snapshotTime` does *not* need PITR — the PITR window is 1 hour when PITR is disabled, 7 days when enabled, and V8's "current minute minus one" is inside both. Good news for V8; see should-fix #7. |
| J11 | ✔ | Scheduler RetryConfig docs: `retryCount` 0–5, `maxRetryDuration` 0 = unlimited, `minBackoff` default 5 s, `maxBackoff` default 1 h, `maxDoublings` default 5; attempt deadline 15 s–30 min; "the next scheduled execution time might be skipped if the retries continue through that time". |
| J12 | ✔ | Max trigger-absence time is 23.5 h. Also relevant and in your favour: a metric-**threshold** condition may evaluate up to 25 h, so V9's 6-hour window is legal. |
| J13 | ✔ | — |

One fact to **add**: Firestore allows **up to 50 concurrent exports/imports** per project. Google will not stop a duplicate export for you — which matters for V7 (should-fix #4).

---

## Blocking

**1. V3's `retryConfig` rule is satisfied by a manifest with nothing set.**
`initScheduleTrigger` pre-fills *all five* retry keys **and** `timeZone` with `RESET_VALUE` before `copyIfPresent` overwrites the ones you actually set (`functions/core/node_modules/firebase-functions/lib/runtime/manifest.js:113-135`), and `stackToWire` serialises `ResetValue` to `null` (`:32-45`). The repo already proves this shape: the committed canary fixture carries `vpc: null` for an option nobody set (`tests/functions/manifest.test.js:28`). So an `onSchedule` that omits `maxDoublings` produces `maxDoublings: null` — **present**, which is all V3 requires — and the V-2 BDD scenario as written ("refuses: retryConfig.maxDoublings missing") is testing for a state that never occurs.
Fix: each of the five must be **a number equal to its value in `declarations.json`**, and `timeZone` must be the **string `"UTC"`** (a `null` timeZone is the reset marker, which the CLI then silently turns into UTC at `cloudscheduler.js:127` — functionally fine, but it means nothing in the repo declared it).

**2. The cron expression isn't pinned to `declarations.json`, so a schedule change can ship unchecked and unattested.** (V3, V2)
V3 says `retryConfig`'s five fields must equal "the function's `schedule` block in `declarations.json`" but is silent on the `schedule` string itself and `timeZone`. If the cron lives only in `index.js`, then changing `every sunday 09:00` to `every 5 minutes` passes JQ_MANIFEST, passes the seal, changes the source hash (so F8 is happy) — and because `ATTEST_FILES` is only `declarations.json iam-expectations.json firebase.json .firebaserc` (`scripts/deploy-functions.sh:662`), `attest_needed` can come back **no**. The deploy then exits 0, "verified", with a schedule nobody read.
Fix: put `schedule` and `timeZone` in the declaration's `schedule` block, compare them, and make the scheduler reading's need derive from that block changing (not from `attest_needed` alone). Done this way, the property you want falls out for free: *any* effective schedule change must touch `declarations.json`, which is both diffed for Christie and an `ATTEST_FILES` member.

**3. V-2 step 1 cannot run.** `scripts/functions-discover.mjs` refuses any `--source` that is not the single `firebase.json` entry for that codebase (`:100-111`: `firebase.json has no single functions entry…`, then `entrySource !== sourceDir`). A fixture codebase under `tests/functions/fixtures/` is not in `firebase.json`, and adding it there would make it deployable. (The existing `env-probe` fixture works only because `emulators:exec` runs in a scratch project dir with its *own* `firebase.json`; `functions-discover.mjs` reads `ROOT`'s.)
Fix: prove the shapes with a plain Node 22 unit test that requires the already-installed `firebase-functions`, calls `onSchedule({…V5/V6…}, …)` and asserts `__endpoint.scheduleTrigger` and `__requiredAPIs` whole. No CLI, no `firebase.json`, offline — and it's exactly the fact you need. Keep the full discovered-manifest assertion for `vault` itself in V-3 step 4 (where `functions-discover.mjs` *will* work).

**4. `requiredAPIs` is a list of objects, not of strings.**
`scheduler.js` sets `func.__requiredAPIs = [{api: "cloudscheduler.googleapis.com", reason: "Needed for scheduled functions."}]`, and `mergeRequiredAPIs` (`lib/esm/runtime/loader.mjs:96-111`) keeps that `{api, reason}` shape. V3's "`requiredAPIs` is exactly `[cloudscheduler.googleapis.com]`" will not match anything.
Fix: require `[.requiredAPIs[].api] == ["cloudscheduler.googleapis.com"]`, each entry's key set exactly `{api, reason}`, and keep the existing "empty otherwise" rule for `core`.

**5. Two existing attestation checks will refuse a scheduled function, and the new block will break `core`'s.** (V2, V3)
- `JQ_MANIFEST`'s declaration-shape check (`deploy-functions.sh:161-164`) emits "declaration … lacks serviceAccount, invoker or ingress" for **any** declaration without an `invoker` — which V3 deliberately removes from scheduled declarations. Must be branched on `trigger`.
- `JQ_ATTEST` derives the expected `run.invoker` set from `$dc[$id].invoker` (`:291-293`). With that field gone it must derive `["serviceAccount:" + $dc[$id].serviceAccount]` instead (J3). V-2's step list names JQ_MANIFEST/JQ_DRIFT/JQ_F8 and the *new* scheduler block, but not these two.
- `JQ_ATTEST_SHAPE` requires `keys == [` exactly six names `]` (`:268`). Adding a `schedulerJobs` key changes the required reading shape for **every** codebase, including `core`, which has no schedule. Say whether the key is always present (`{}` when none) or conditional, and add a `core` regression test for it.
- `predeploy-check.sh:221-234` hard-requires `($e.httpsTrigger | type) == "object"` and `invoker == $x.invoker` per endpoint. V3 says the backstop gets the same rules — good — but this is the specific code, and it must agree with the guard's branch exactly or the seal fails after every check has passed.
- Also add: a declaration's **key set must be exact**. Nothing today refuses an unknown key, so `"triger": "schedule"` would be read as an HTTP function with a missing invoker — a confusing refusal at best.

---

## Should-fix

**6. V7's idempotency rests on the weaker half of the evidence, and the authoritative half is one grant away.**
Asked directly: listing export operations by `outputUriPrefix` is *mostly* reliable, and here is what breaks.
- **Retention is fine for your retry window** ("a few days" vs retries inside 6 h) but not for anything longer, so the mechanism is only ever an intra-week check. That's all V7 needs — state it, so nobody later assumes it answers "did last week's export succeed?"
- **No documented filter.** `listOperationsAsync`'s `filter` is "the standard list filter" (`@google-cloud/firestore/types/v1/firestore_admin_client.d.ts:2010`); nothing documents filtering on `metadata.outputUriPrefix`. You must page and filter client-side, over a list that also contains index builds. Use `listOperationsAsync` (it pages for you) **with an explicit bound** — a cap on operations examined, and a loud throw when the cap is hit rather than falling through to "none → start attempt 1", which is the one wrong answer.
- **A dead run before the operation appears:** safe. `exportDocuments` creates the LRO server-side before it returns, and the first retry is ~10 min later.
- **Concurrent instances:** `maxInstances: 1` is not a mutual exclusion (Cloud Run may briefly exceed it, and a Force run during an in-flight run is a second request). Two runs that both see "none" both start `weekly/<week>-a1` — and Google allows up to 50 concurrent exports, so nothing stops them, into a prefix the docs say cannot be reused. Undefined contents in a backup folder is the worst outcome in this plan.
- **A prefix that can't be reused:** handled correctly by the `-aN` suffix.

The fix is small and removes all of it: give `vault-export@` the same `vaultLister` role on the vault bucket (`storage.objects.list`, names and times only — it still cannot read a document or a byte of an export) and make the idempotency key the **bucket**: `weekly/<key>-a*` folders containing `*.overall_export_metadata` are the durable, 56-day-retained record of "this week succeeded", and the operations list is then used only for "is one still running". That is also the same signal `vaultFresh` already trusts, so the two identities stop seeing different halves of the truth.

**7. The week key makes a mid-week manual run cancel that week's scheduled backup.** (V7, V5, V-4 step 5–6, V-5)
ISO weeks run Mon–Sun, so a Force run on Monday and the scheduled run the following Sunday share a key — the Sunday run would log "already done" and export nothing. V-4's two Force runs and V-5's restore-and-force-run all land mid-week, so the first *scheduled* export may silently be a week later than the plan assumes, and the 8-day alert won't notice (the mid-week copy is fresh). V-5's "a new attempt suffix this week" is also wrong whenever the test crosses into a different ISO week from the last run.
Fix: key on the **scheduled occurrence**, not the calendar week — `weekly/<YYYY-MM-DD of event.scheduleTime>-a<n>`. Retries of one execution carry the same `X-CloudScheduler-ScheduleTime`, so idempotency is preserved exactly where you want it; a forced run gets its own key, which is the honest answer. It also retires the whole ISO-week/DST argument and the "use `shared/denver-time.js` only if it's UTC-correct" hedge in V-3 step 3. (If you keep the week key: note that it only works because 09:00 UTC is comfortably inside the Denver Sunday, and pin that next to V5.)

**8. No wait budget, so a timeout can be silent and can block its own retry.** (V6, V7, V13)
`timeoutSeconds: 1800` = the attempt deadline. If the function is still waiting at 1800 s, Cloud Run kills the request — `onSchedule`'s catch never runs, so there is **no `logger.error`**, so V13's log-based alert may not fire (you'd be relying on a Cloud Run request log). And with `concurrency: 1` + `maxInstances: 1`, an orphaned request (Scheduler's `DEADLINE_EXCEEDED` doesn't stop the Cloud Run request — J11 correctly says this is undocumented) can queue the retry until *it* times out too.
Fix: give the wait loop an explicit budget well under the deadline (≈1500 s), throw on expiry so the handler's error path runs, and say so in V7.

**9. `vaultFresh`'s ingress and target URL aren't stated, and both are required for V9 to work.**
Cloud Monitoring's public checkers come from public IPs, so `vaultFresh` must be `ingressSettings: ALLOW_ALL` — internal-only would fail every check forever, and the alternative (a private check via Service Directory) is out of scope. The service-agent token's `aud` is **the URL configured in the check**, so the check must target exactly the function's live `uri` that the guard reads back; otherwise Cloud Run rejects it. State both, and name `vaultFresh`'s `timeoutSeconds`, `memory` and `cpu` — F14 (`deploy-functions.sh:187-188`) refuses any of them left unset, so V-3 has no expectation to be reviewed against today.

**10. V-0's "the only difference is `vaultExporter` on `vault-export@`" is probably wrong, for the exact D2-5 reason.**
Opening the uptime-check wizard to read the Monitoring agent's address (V-0 step 6) is what *provisions* that agent, and enabling the Monitoring or Scheduler API (step 5) can add Google-managed project-level grants — which is precisely how the Google APIs Service Agent got Editor in D2-5 (decision #60). Step 8's acceptance will then fail on a change that is expected.
Fix: list the service agents V-0 may create and the grants they may arrive with, re-read the `editor` holder list specifically, and only then assert "nothing else". Also confirm the Monitoring agent **exists** before V-4, or the deploy fails at "set invoker" binding `run.invoker` to a principal that isn't there yet.

**11. `iam-expectations.json` is shared, so the vault accounts change `core`'s attestation too.**
The plan notices this for `declarations.json` ("the canary's next deploy needs an IAM reading") but not for `iam-expectations.json`. `JQ_ATTEST` requires `($ev.runtimeAccounts | keys) == ($iam.runtimeAccounts | keys)` (`:312`), so from V-3 onward **every `core` reading must also list `vault-export@`'s and `vault-watch@`'s roles**. And pin the exact string form Christie will transcribe for a custom role — `projects/my-clay-hub/roles/vaultExporter` (the id) versus the Console's display title "Vault exporter" — or the first `--attest` comes back `no` for a purely cosmetic reason. `canary@: []` meant this never came up before.

**12. `vault`'s dependencies and the real client surface.**
V-3 step 1 pins only `firebase-functions` and `firebase-admin`. The exporter needs `@google-cloud/firestore` (for `v1.FirestoreAdminClient`) and the watcher needs `@google-cloud/storage` — as **direct, pinned** dependencies, not transitives of `firebase-admin`. I did confirm the surface exists in the installed copy: `exportDocuments`, `checkExportDocumentsProgress`, `operationsClient` and `listOperationsAsync` are all on `FirestoreAdminClient` (`types/v1/firestore_admin_client.d.ts:82, 1025, 1072, 2032`). But every V-3 test uses an injected fake, so the first proof that the *real* calls have the shapes you assumed is V-4 — the Phase E gate. Add a cheap offline guard: assert the methods exist with the expected arity on the real client, and that `listOperationsAsync` is driven with `{name: client.databasePath(project, '(default)')}`.

**13. `scripts/functions-emulator.mjs` is hardcoded to one codebase.** `CODEBASE_MODULES = functions/core/node_modules` (`:35`), and `skipReason` names only that path (`:50-52`). V-3 step 4's emulator tests for `vault` need it extended to install and run both — and it's a `CONTROL_FILE`, so the change shows in `--diff`. Not mentioned anywhere in V-2 or V-3. While you're there: prove that `emulators:exec --only functions` tolerates an `onSchedule` endpoint in the codebase at all, in V-2, before V-3 depends on it.

**14. `vaultExport` cannot set `x-tinker-reached`.** `onSchedule` owns the response object (`scheduler.js:42-66`); the handler only receives `event`, so `withReached()` cannot wrap it. That quietly breaks CLAUDE.md's "every HTTP response sets `x-tinker-reached`" invariant. State the exception, and note the consequence for the probe: a scheduled function that *were* public would answer 2xx (so F8 still catches it as `answered`) — but the probe would also **start a real export**. Worth one line in V3.

**15. Nothing blocks on `scheduler_attested`, and a wrong schedule's only backstop is the 8-day alert.**
`deploy_verified` deliberately excludes it (mirroring `iam_attested`), so `--approved` can print "✔ verified" with a paused or 09:00-every-day job. That's a defensible choice given no gcloud — the CLI genuinely cannot read the job (J1), and I agree Christie's reading is the only option. But say it out loud in V2: *the guard never proves the schedule; the 8-day freshness alert is what catches a job that doesn't run*, and V-4 cannot close without `scheduler_attested=yes`. Also decide what `--status` prints for `core`, which has no schedule — "n/a", never a fail-closed "no".

**16. Interruption and partial-state scenarios that are missing.** The BDD set is good on the happy and the obvious-failure paths; these are the gaps:
- deploy created the function but `upsert schedule` failed (`fabricator.js:161` ordering) → function live, **no job**, `cli_exit≠0`. The in-flight/`--reconcile` path knows nothing about jobs; the new runbook § covers only the reverse (a job without a verified function).
- an **update** where the function patched but the job patch failed → live job keeps the *old* schedule while the code has the new one; only `--attest` catches it.
- a schedule **removed** from code: `setTrigger` isn't called for an HTTP endpoint, so the Cloud Scheduler job is orphaned and keeps POSTing. The runbook should say it must be paused by hand (with approval), and V3 can detect it (the declaration's `trigger` changed from `schedule`).
- the operations list aged out / exceeded the page bound → a duplicate export (fix #6).
- two runs start the same prefix (fix #6).
- the uptime check fails for an **auth/audience** reason rather than staleness — same email, different cause; say that `vaultFresh`'s body is the triage.
- lifecycle deletion is **not atomic**: all objects in a folder share an age but are deleted asynchronously over up to 24 h, so a folder can briefly hold data with no `.overall_export_metadata` (or the reverse). V14 should have the reader check a folder is complete, not just present.

---

## Nits

- **V13's filter isn't pinned.** Write the log filter out (`resource.type="cloud_run_revision" AND resource.labels.service_name="vaultexport" AND severity>=ERROR`), and decide deliberately whether `run.googleapis.com/requests` is included — it's what would catch the 1800 s kill in #8, and it's also what a 4xx from the guard's probe lands in.
- **V9's request arithmetic.** A public uptime check needs at least three checker regions ("Identify at least three checkers"), and Global issues from all six — so a 15-minute period is 288–576 requests/day, not "~300", all arriving near-simultaneously against `maxInstances: 1`. Fine with `concurrency: 10`, but the default request timeout is **10 s** and most checks will be cold starts (instances scale to zero between 15-minute probes). Consider raising the check's timeout to 30 s so a cold start never reads as an outage.
- **256 MiB for the exporter** is tight for `firebase-admin` + the gRPC Firestore admin client. 1 CPU with 256 MiB is legal on Cloud Run; 512 MiB would be cheap insurance on a function that runs weekly.
- **Verify PITR in V-0.** Decision #44 plans it; nothing in the repo records it as on, and the safety checklist leans on it. Per J10's correction, V8 works either way — a one-minute-old snapshot is inside the 1-hour default window — so this is about the plan's own claim, not a risk to V8. Record `earliestVersionTime` while you're there.
- **`vault-watch@` must only list.** `bucket.getFiles()` needs just `storage.objects.list`, and the listing already returns `timeCreated`; a stray `bucket.exists()` or `getMetadata()` would need `storage.buckets.get` and fail. Say "list only, read `timeCreated` from the listing" in V-3.
- **Nothing attests the cross-project grants.** `--attest` explicitly doesn't read bucket-level or cross-project IAM (`deploy-functions.sh:1057`), so `vault-watch@ → []` in `iam-expectations.json` is honest but means its only real grant is unverified by the record. V-6 should say that V-1's screenshots plus V-4/V-5's behaviour *are* the record for those two bindings.
- **Consider an IAM condition** on the two `tinker-hq-vault` bindings restricting `resource.name` to the vault bucket, as `iam-expectations.json:20` already does for the build account's `storage.objectViewer`. Bucket-level bindings are already scoped, so this only helps if a binding ever migrates up — but it's one line and it's the pattern the repo already uses.
- **Cost attribution.** The export's document reads bill to `my-clay-hub` (inside the $20 budget), not to `tinker-hq-vault`; only storage lands on the vault's bill. Also, soft-deleted objects are billed for their 7 days. Both are cents at this size — just make the checklist say which bill.
- **Soft delete is the only recovery from `objects.delete`** (V12's residual). That's stated; add that it is 7 days, so a deletion unnoticed for a week is unrecoverable.

---

**Touching `tinker-hq-apps` or the staff bucket:** no path I can find. Nothing in V-2/V-3 writes outside this repo; `.firebaserc` pins `my-clay-hub` as the only project; `predeploy-check.sh:63-67` refuses any other `GCLOUD_PROJECT`; the two new roles are defined in `tinker-hq-vault` but bound only on the new bucket. The one residual is a *project-level* grant in `tinker-hq-vault` by mistake, which would reach `tinker-hq-vault-backups` — V-1 steps 1 and 6 catch exactly that, and the acceptance wording ("exactly two non-inherited grants") is the right test.

Want me to write this up into the plan's **Reviews** section and open the fixes as a checklist there?
