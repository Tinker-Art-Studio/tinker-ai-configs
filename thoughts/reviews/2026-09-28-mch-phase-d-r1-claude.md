I could read the plan, the approved wording, the parent plan (including D4's full status table and the IAM inventory), the deploy-guard plans, and the live hook script. **I could not read** `~/studio-hub/scripts/*` or `~/my-clay-hub/docs/**` — this session is sandboxed to `~/tinker-ai-configs`, so findings 8–13 (guard adaptation) and 22–26 (D‑5) are reasoned from `firebase-deploy-guard.html` + `deploy-guard-receipt-ordering.html` and from the parent plan's D4/D4a table rather than from the scripts and `DATA-MODEL.md:55–79` themselves. Treat those as "verify against the file" rather than "confirmed in the file."

---

## 1. Console / IAM / backups (Q1)

**1. BLOCKING — the org-policy constraint is applied *after* the APIs, so it does nothing, and the "no Editor" acceptance is then false.** (D‑1 steps 8–9)

`constraints/iam.automaticIamGrantsForDefaultServiceAccounts` only suppresses the Editor grant *at the moment the default service account is created*. D‑1 enables the eight APIs in step 8 (which is what creates the default Compute SA **with Editor**), then in step 9 says "if an organization exists, enforce the constraint; **otherwise** remove the Editor role". In the org case the constraint is a no-op on an account that already exists, Editor silently stays, and D‑1's acceptance bullet ("the default service accounts have no Editor") would be signed off while false.

Suggested replacement for steps 8–9:

> 8. **If an organization exists:** Cloud Console → IAM & Admin → Organization policies → set `constraints/iam.automaticIamGrantsForDefaultServiceAccounts` to *Enforced* **on this project, before any API below is enabled**. Record whether it was enforceable.
> 9. APIs & Services → enable: Cloud Run, Eventarc, Cloud Functions, Cloud Build, Artifact Registry, Pub/Sub, Cloud Scheduler, IAM Service Account Credentials.
> 10. IAM → **regardless of step 8**, list every principal and confirm no `*-compute@developer.gserviceaccount.com` or `*@appspot.gserviceaccount.com` holds `roles/editor`. Remove it if present. Claude records the principal list as the read-back for this step — the constraint is not evidence on its own, the principal list is.

**2. SHOULD-FIX — consider not enabling the six functions APIs at all in Phase D.** Everything D‑1/D‑4 actually needs is Cloud Scheduler + IAM Service Account Credentials (plus Firestore/Storage, enabled by creating them). Run, Eventarc, Cloud Functions, Cloud Build, Artifact Registry and Pub/Sub exist only for D2/E/F, and enabling them now is precisely what creates the default SA that finding 1 is about. Suggested note in D‑1:

> If the constraint could not be enforced (no organization), enable only `cloudscheduler` and `iamcredentials` now and leave the six functions APIs to D2, which enables them and re-checks the default-SA Editor grant in the same step. Record which path was taken.

**3. SHOULD-FIX — "delete and recreate the project" is not reversible in the way the scenario implies.** (D‑1 BDD "the wrong database location was picked") A deleted Google Cloud project ID is **permanently reserved and can never be reused**. If `my-clay-hub` is created in the wrong location and deleted, the ID is gone and every downstream artifact pinned to it (`.firebaserc`, guard `PROJECT`/`TAG_ROOT`, `settings.json`, the hook message, CLAUDE.md, the vault bucket name) changes. Suggested replacement for the last line:

> And Christie decides whether to delete and recreate the project — knowing that **the project ID is permanently retired on deletion**, so the rebuild uses the next fallback ID and every `<PROJECT_ID>` in D‑2/D‑3/D‑4 and Appendix A is re-filled. This is why D‑1 completes and is read back before D‑2 starts.

**4. SHOULD-FIX — the Firestore service agent probably does not exist yet when D‑4 step 2 tries to grant it a role.** `service-<number>@gcp-sa-firestore.iam.gserviceaccount.com` is created lazily; granting a role to a not-yet-existing principal in the Console either fails or lands as a dangling binding that is silently dropped. Add before D‑4 step 2:

> 1b. In `<PROJECT_ID>`, force the Firestore service agent to exist and read its exact address: `gcloud beta services identity create --service=firestore.googleapis.com --project=<PROJECT_ID>`. Use the address it prints verbatim in step 2 — do not hand-assemble it from the project number.

**5. SHOULD-FIX — the single most destructive action in the plan has no guard rail: a mis-targeted lifecycle rule on `tinker-hq-vault-backups`.** D‑4 steps 1–2 are Console work in the project that holds every staff-app backup, and step 1 sets a "delete objects older than 56 days" rule. One wrong bucket and the staff backups are on a 56-day timer. Add as D‑4 step 0 and step 7:

> 0. **Before touching `tinker-hq-vault`:** record the current state of the existing bucket — `gcloud storage buckets describe gs://tinker-hq-vault-backups --format="yaml(lifecycle,iamConfiguration,softDeletePolicy)"` — and paste the output into the Decisions log.
> 7. **After every change:** re-run that same command and confirm it is byte-identical to step 0. Then run it for `gs://my-clay-hub-vault-exports` and confirm the 56-day rule is on the new bucket only. Phase D does not complete until both read-backs are in the log.

**6. SHOULD-FIX — "if the weekly job fails, Christie gets an email" is not delivered by a Cloud Scheduler failure alert.** `exportDocuments` is a long-running operation: the HTTP call returns `200` with an operation name within a second, and the export runs for minutes afterwards. Scheduler reports **success** as soon as the operation is *accepted*. Every real failure mode after that point (bucket permission revoked mid-flight, quota, operation error) shows a green Scheduler run and no email. Suggested replacement for D‑4 acceptance bullet 3 and step 5:

> - If the weekly export fails to **start** *or* fails to **finish**, Christie gets an email.
>
> 5. Two alert policies, both emailing Christie:
>    a. Cloud Monitoring → alert on failed runs of the Scheduler job (catches "did not start");
>    b. a **log-based** alert in `<PROJECT_ID>` on `resource.type="audited_resource" AND protoPayload.methodName="google.firestore.admin.v1.FirestoreAdmin.ExportDocuments" AND severity>=ERROR`, **or** — simpler and stronger — a Monitoring alert on the vault bucket's object count staying flat: "no new object in `my-clay-hub-vault-exports` for 8 days". Prefer (b)-as-absence: it is the only check that proves a *usable* backup landed, and it survives redesigns of the job.

Also add to step 4: **set a `retryConfig`** on the Scheduler job (parent plan D23: "retries set explicitly … both are off by default") — e.g. 3 attempts, 60s min backoff.

**7. SHOULD-FIX — the D‑4 acceptance conflates two identities, and one of them *will* hold a Storage role.** The bullet "The export identity can start exports and nothing else; it cannot read or delete anything in the vault" and the BDD "it holds no Storage role at all" are true for `vault-export@` but **false for the Firestore service agent**, which must hold write (Google documents `roles/storage.admin` on the destination bucket for cross-project export) and therefore *can* overwrite and delete inside `my-clay-hub-vault-exports`. Stating it the current way means the residual risk never gets recorded. Suggested replacement:

> - Two identities, deliberately separate: **`vault-export@`** (Scheduler's caller) holds `roles/datastore.importExportAdmin` on `<PROJECT_ID>` and **no Storage role anywhere** — it can start an export and nothing else. **The `<PROJECT_ID>` Firestore service agent** holds the minimum role Google's cross-project export docs require, **on `gs://my-clay-hub-vault-exports` only**. If that role turns out to be `roles/storage.admin`, record the residual explicitly: the agent can overwrite or delete objects **inside that one bucket**. Nothing in `my-clay-hub` holds any role on `tinker-hq-vault-backups`.
> - Mitigate the residual: leave **soft delete** on the new bucket at its default (7 days) so an erroneous delete is recoverable, and confirm it is compatible with the 56-day lifecycle rule.

**8. SHOULD-FIX — confirm the bucket-location rule *before* creating the bucket, and say what happens if you get it wrong.** D‑4 step 1 correctly defers "us-central1 or multi-region US" to execution time, but the step order has Christie creating the bucket in the same breath. Bucket location is permanent, and after a delete the **name** is unavailable for the soft-delete window. Suggested insert at the top of step 1:

> Confirm Google's current "export bucket must be compatible with a `nam5` database" rule **and write the answer in the Decisions log before creating anything**. Then create the bucket. If the wrong location is chosen, the bucket must be deleted and the name is unavailable for the soft-delete retention period (7 days by default) — so this is a read-the-doc-first step, not a try-it step.

**9. NIT — the backup has no documented restore path.** D‑4 proves exports land; nothing says how to get one back. A backup nobody has written down how to restore is half a backup, and Phase E is gated on D‑4 succeeding. Suggested addition to D‑4's deliverables:

> `~/my-clay-hub/DATA-RESTORE.md` (one page): which export folder to pick; that restoring grants the Firestore service agent **read** on the vault bucket (a second, temporary grant — the export grant is not enough); the `gcloud firestore import --project <PROJECT_ID> gs://my-clay-hub-vault-exports/weekly/<folder>` command; and the warning that import **overwrites documents with matching IDs and does not delete anything else**, so a restore into a non-empty database is a merge, not a rollback.

**10. NIT — three small D‑4/D‑1 gaps.** (a) The Scheduler job needs an explicit body — say it: `POST https://firestore.googleapis.com/v1/projects/<PROJECT_ID>/databases/(default):exportDocuments`, header `Content-Type: application/json`, body `{"outputUriPrefix":"gs://my-clay-hub-vault-exports/weekly"}`, Auth header type **OAuth token**, scope `https://www.googleapis.com/auth/cloud-platform`. (b) The vault bucket's storage cost lands in `tinker-hq-vault`, so the $20 budget on `<PROJECT_ID>` will never see it — add one line saying so. (c) The bucket name must be derived from the ID Google actually accepted (`myclayhub-vault-exports` if the fallback is used) and checked for global availability.

---

## 2. Guard adaptation completeness (Q2)

**11. SHOULD-FIX — `predeploy-check.sh`'s own pinned repo is missing from the adaptation table.** The table lists `scripts/predeploy-check.sh` only as a *member of `CONTROL_FILES`*; D‑2's acceptance only says the message "names this repo's guard". But per `firebase-deploy-guard.html`, the check does `git -C <repo> show "$TINKER_DEPLOY_SHA:<file>"` — so it carries its own repo path and its own per-target file list. A copy that still says `/Users/christiehubley/studio-hub` fails closed rather than open, but it fails *confusingly* and would be debugged under time pressure during the first deploy. Add a row:

> | `predeploy-check.sh`: the pinned repo path, the per-target file list, and the guard named in the refusal sentence | This repo's path and files; names `/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh` |

and add to D‑2's BDD:

> Scenario: a sha from the other repo
>   Given TINKER_DEPLOY_SHA is a sha that exists on studio-hub's origin/main but not here
>   When my-clay-hub's predeploy check runs
>   Then it refuses, naming this repo's guard
>
> Scenario: one changed byte
>   Given firestore.rules in cwd differs from the commit by one byte
>   Then the check refuses; identical → exit 0

**12. SHOULD-FIX — under a straight copy, the `storage` target runs no tests — and the first guarded deploy in D‑3 *is* a storage deploy.** studio-hub runs `npm test` for `firestore:rules` only ("storage/indexes have no suite"). my-clay-hub *does* have a storage suite (D‑2: "can't read or write any Storage path"). Add a row:

> | `npm test` runs for `firestore:rules` only | Runs for **`firestore:rules` and `storage`** (this repo has a Storage rules suite); `firestore:indexes` still has none and `--status` says so |

**13. SHOULD-FIX — the zero-receipt case is new and untested.** studio-hub seeded its first receipt by hand, so `--diff`, the receipt-ordering comparison (`receipt_rows` / `EX_RECORD` / the blocking-receipt notice) and `--status` have never run against an empty tag namespace — and my-clay-hub's first deploy is exactly that case. Add to D‑3's acceptance:

> - With **no receipt tags at all**: `--status` prints "no receipt yet" and still prints the project, the sentence and the command; `--diff` prints the **whole target file** (diff against the empty tree) rather than nothing or an error; the receipt-ordering checks print no spurious blocking-receipt or exclusion notice. All three are assertions in the adapted test suite.

**14. SHOULD-FIX — the emulator lock and emulator ports are not in the adaptation list, and there is a false-pass path.** Two things:

- studio-hub's lock is documented as refusing when "another guard, **or an emulator run**, is in flight" — so something on the test side also takes `$GIT_DIR/tinker-deploy.lock`. D‑2 builds the test harness *before* D‑3 builds the lock, so D‑3 has to go back and wire it. Say so explicitly in D‑3's order.
- More important: if my-clay-hub's `firebase.json` uses the **default emulator ports** and a studio-hub emulator is already listening, a my-clay-hub rules test can connect to **studio-hub's emulator, loaded with studio-hub's rules**. Deny-all tests would pass against the wrong ruleset — a silent false pass on the one thing D‑2 exists to prove.

Suggested addition to D‑2's acceptance:

> - `firebase.json` pins **non-default emulator ports** for this repo (e.g. firestore 8180, storage 9299, ui 4100) so a studio-hub emulator can never be the one answering, and `npm test` starts them with `firebase emulators:exec --project demo-my-clay-hub` so an occupied port is a hard failure rather than a silent reuse.

and a row in D‑3's table:

> | Lock is taken by the guard and by the emulator/test run | Same, in this repo's `.git` — **D‑3 adds the lock call to D‑2's test script** |

**15. NIT — three smaller adaptation items not in the table.** (a) The guard symlinks `$repo/node_modules` into the worktree, so `npm ci` must have been run in `~/my-clay-hub` before the first guarded deploy — add it to D‑3 step 4. (b) `.firebaserc`'s default project is asserted by the guard/test, not only by the test file — the table mentions `.firebaserc` only under "test file". (c) `.gitignore` for `node_modules/`, `.firebase/`, `*-debug.log` — without it the guard's dirty-tree warning fires on emulator logs every run and stops being read.

---

## 3. D‑3 ordering (Q3)

**16. SHOULD-FIX — the hook verification step cannot be run from Bash; it blocks itself.** D‑3 step 2 says "feed it a sample raw-deploy command (expect deny…)". The hook matches the **Bash tool's own command string**, so any Bash invocation whose text contains the gated phrase followed by whitespace is denied before it runs — the global CLAUDE.md warns about exactly this. The test as written will be denied, and the obvious "fix" (rewording until it slips past the regex) tests nothing. Suggested replacement:

> - **Hook first** (it fails closed). Edit the message only; then `bash -n`. Then test it against two fixtures **written with the Write tool** (never typed into a Bash command, which the hook would deny): `/tmp/hook-deny.json` containing a raw-deploy command string, and `/tmp/hook-allow.json` containing `{"tool_input":{"command":"ls"}}`. Run `bash ~/tinker-ai-configs/scripts/firebase-deploy-hook.sh < /tmp/hook-deny.json` — expect the deny JSON, naming both guards — and `… < /tmp/hook-allow.json` — expect empty output, exit 0. If either is wrong, restore from the `.bak` with the Edit tool (no Bash needed) before anything else.

**17. SHOULD-FIX — the first guarded deploy must run in a session started *after* the wording lands.** `~/.claude/CLAUDE.md` and `settings.json` are loaded at session start. The session that performs D‑3 step 2 is still running under the **old** text — "All Firestore security rules live in ONE file: studio-hub/firestore.rules", "Every Firebase deploy for `tinker-hq-apps` goes through one script" — which does not authorise what step 4 then does. Suggested addition between steps 3 and 4:

> 3b. **Start a fresh Claude session.** The edits in step 2 only bind a session that starts after them. In the new session, confirm three things before step 4: (i) the loaded CLAUDE.md shows the "exactly TWO" table; (ii) `/Users/christiehubley/studio-hub/scripts/deploy-rules.sh --status` still works unchanged (the tinker-hq-apps path is not collateral damage); (iii) a Bash command containing the gated phrase is denied with the **new** message naming both guards — the denial is the proof the hook is still wired after the `settings.json` edit.

**18. SHOULD-FIX — a `settings.json` that parses is not a `settings.json` that works, and the failure mode here is fail-*open*.** If the edit lands in the wrong key, or the file becomes invalid, the `PreToolUse` hook is no longer registered and raw deploys stop being blocked at that layer (only the predeploy byte-check remains). `python3 -m json.tool` catches neither. Suggested replacement for that sub-bullet:

> - `settings.json`: the four entries; then `python3 -m json.tool` must succeed; then print the four `autoMode` values back and diff them against Appendix A §2 word for word; then confirm `hooks.PreToolUse` still contains the `firebase-deploy-hook.sh` entry with its `|| exit 2`. The end-to-end proof is 3b(iii) above — an invalid or mis-keyed settings file fails **open** on the hook, so JSON validity alone is not the check.

**19. NIT — housekeeping around the backups.** `save-skills.sh` (the Stop hook) stages only `skills/ CLAUDE.md docs/ thoughts/plans/`, so `scripts/firebase-deploy-hook.sh` will **not** be auto-committed — D‑3's "commit the hook change" must be an explicit `git add scripts/firebase-deploy-hook.sh`. Say so, and say that the `.bak` in `scripts/` is deleted once 3b passes, so a stale copy of the security hook does not sit untracked next to the live one.

**20. NIT — make the two-target approval explicit in the ask.** Step 4 runs the guard twice from one approval sentence. Suggested wording for the ask: "This ships **firestore:rules and storage** from sha S — two guard runs, two receipts, one approval." One sentence, and the approval is informed.

**21. NIT — name the *mechanical* cross-project defense, not just the classifier.** The BDD "an approval for the other project → the soft_deny entry requires a fresh phrase" is a statement about how an LLM classifier should behave; it cannot be tested. The real defense is already in the design and is worth stating: **each guard refuses any sha that is not an ancestor of its own `origin/main`**, so a tinker-hq-apps sha simply does not resolve in my-clay-hub's repo. Add a mirror scenario to the pair you already have:

> Scenario: the other project's sha
>   Given a sha that is on tinker-hq-apps' origin/main
>   When the my-clay-hub guard runs --approved with it
>   Then it refuses at the rev-parse/ancestor check — this is mechanical, not a matter of the session's judgement

---

## 4. Do the BDD scenarios catch a partial implementation? (Q4)

Close, but three gaps let a half-built D‑2 pass.

**22. SHOULD-FIX — the deny-all suite does not prove the rules are recursive, and does not test collection-group reads.** A `firestore.rules` with per-collection blocks but no `match /{document=**}` passes every scenario as written, then leaks the moment Phase F adds a subcollection. Add to D‑2's acceptance:

> - The suite loads `firestore.rules` and `storage.rules` **from disk** (never an inline rules string), so the file that gets deployed is the file under test.
> - The stranger is also denied on: a deep subcollection path (`members/x/anything/y`), a `collectionGroup('bookings')` query, and a document at the root of an unused top-level collection. A signed-in user carrying fabricated custom claims (`{admin:true}`, `{staff:true}`) is denied identically — proving the deny-all is unconditional, not claim-keyed.

**23. SHOULD-FIX — the "tests can't hit production" scenario needs to be a test, not a property.** As written it describes behaviour but nothing asserts the check exists. Suggested addition:

> Scenario: the production guard has its own test
>   Given the harness is invoked with FIRESTORE_EMULATOR_HOST unset, then with projectId "my-clay-hub"
>   When each runs
>   Then each exits non-zero with a one-line reason, before any Firebase SDK is initialised
>   And the assertion is part of npm test, not a manual check

The `demo-` prefix + both emulator host variables is the right mechanism, and combined with finding 14 (non-default ports, `emulators:exec`) this fully answers "can't hit production" *and* "can't hit the wrong emulator". Without 14 it answers only the first.

**24. NIT — say why there is no live probe after the first deploy.** "The Console shows `allow read, write: if false`" is the only available proof because no sign-in provider and no web app exist by design. Say that in D‑3, otherwise a later session will "helpfully" register a web app to test it and breach the Phase F gate.

---

## 5. D‑5 acceptance vs the status table (Q5)

Checked against the parent plan's D4/D4a table (lines 191–205), which I take to be what `DATA-MODEL.md:55–79` mirrors — please confirm against the file itself. The acceptance list is **not complete**; five things are missing, and two of them are the classic ways this function gets built wrong.

**25. SHOULD-FIX — the date-parsing rule is missing entirely.** D4 says: "*parses `YYYY-MM-DD` strings as dates, **never through `new Date()`***", and the parent plan records a confirmed live bug (finding 3: Membership Manager's dates are a day early in Denver) that is precisely this. The D‑5 acceptance never mentions it. Add:

> - `YYYY-MM-DD` strings are parsed as **Denver calendar dates by explicit field extraction**, never via `new Date(string)` (which parses a bare date as UTC midnight and reads a day early west of Greenwich). A test asserts that `'2026-03-08'` compared against a Denver "today" of `2026-03-08` is *equal*, not *before*, when the process runs at `TZ=UTC`.

**26. SHOULD-FIX — "one test per rule" does not catch the commonest failure, which is right rules in the wrong order.** D4 is explicitly "applied in order; the first match wins". Add conflict cases:

> - Ordering is proved by conflicts, not just by one case per rule:
>   - past `finalAccessDate` **and** inside a valid pause window → `offboarded` (rule 2 before rule 6);
>   - `stage:'somethingNew'` **and** a valid current pause → `review` (rule 1 before rule 6);
>   - malformed `finalAccessDate` **and** `stage:'cancelled'` → `review` (rule 2 before rule 3);
>   - a malformed date in **one** `pauseHistory` entry while another entry is a valid current window → `review` (rule 5 before rule 6).

**27. SHOULD-FIX — three specifics from D4 that the list omits.**

> - The output vocabulary is exactly `active | paused | review | offboarded` (four values — distinct from the six `stage` values). A totality test walks the cross-product of {six known stages, missing, unknown} × {`finalAccessDate` absent/valid-past/valid-future/malformed} × {no pause, past pause, current pause, malformed pause} and asserts the result is always one of the four and **never throws**.
> - Pause windows are read from `scheduledPause` **and every `pauseHistory` entry**, in **both field spellings** (D4: "either spelling") — one test per spelling, and one where the two spellings disagree.
> - The signature is `deriveStatus(source, todayDenver)` with the day **injected**, never read from the clock inside the function. That is what makes the three-time-zone run meaningful.

**28. NIT — pin the week-key convention, or two implementations both "pass" the year-boundary test.** `2026-W39` implies ISO‑8601, where the year in the key is the **ISO week-year**, not the calendar year. Name it and give the cases:

> - `weekKey` uses ISO‑8601 week-numbering with a zero-padded week and the **ISO week-year**: `2026-12-28` (Mon) → `2026-W53`; `2027-01-01` (Fri) → `2026-W53`; `2027-01-04` (Mon) → `2027-W01`; a single-digit week is `2026-W09`, never `2026-W9`. Confirm each against DATA-MODEL §weekKey before writing the test.
> - A week containing a DST change is still seven calendar days (the March 2026 Denver week is 167 hours) — the test that catches a millisecond-arithmetic implementation.

**29. NIT — one line for Phase E.** Add: "Phase E's `ingestMemberUpdate` and the 3:30 AM recompute **import this module**; neither re-derives status. Any disagreement with Membership Manager's own `stage` is expected — D4 says `deriveStatus` wins — and is reconciled in Phase E, not here."

---

## 6. Scope vs the parent plan (Q6)

**30. SHOULD-FIX — the global CLAUDE.md keeps two single-project instructions that are now wrong, and they are not among the six approved edits.** This is about *applying* the approved wording safely, not about the wording itself:

- "**Every new Firestore collection requires a rule — NO EXCEPTIONS**" says "a matching rule block must be added to `firestore.rules`" — with no project qualifier, in a world where a My Clay Hub collection could be added to studio-hub's file. This is the exact mistake the whole two-project split exists to prevent. Suggested minimal edit: "…must be added to **that project's** `firestore.rules` (see PROJECT STRUCTURE for which file) and deployed through **that project's** guard."
- "**What 'data disappeared' usually means**" points only at `/Users/christiehubley/studio-hub/RULES-ROLLBACK.md`, while D‑3 creates a second one. Suggested edit: "Follow that project's rollback runbook: `studio-hub/RULES-ROLLBACK.md` or `my-clay-hub/RULES-ROLLBACK.md`."

Both are additions beyond the approved six, so they need Christie's OK — flag them when she reviews, rather than slipping them in.

**31. SHOULD-FIX — the 1f whole-section replacement silently drops two still-valid lines.** The current "PROJECT STRUCTURE — KEY FACTS" section ends with "**`studio-hub/` is the Firebase project root** — run `firebase` CLI commands (emulators etc.) from `/Users/christiehubley/studio-hub/`; the deploy guard works from any cwd" and the pointer "See `~/.claude/projects/-Users-christiehubley/memory/MEMORY.md`…". Appendix A §1f replaces "the whole section" and carries neither forward. Add to D‑3's checklist:

> Before applying 1f, list the current section's lines and confirm each is either carried into the new table/bullets or deliberately dropped with Christie's agreement. At minimum re-add: "Run `firebase` CLI commands (emulators etc.) from the project's own folder — `/Users/christiehubley/studio-hub/` or `/Users/christiehubley/my-clay-hub/`; each guard works from any cwd." and the MEMORY.md pointer.

**32. NIT — the table column says "Firestore rules source" but D‑3 deploys `storage.rules` too.** After D‑3, nothing in the global CLAUDE.md says where Storage rules live for either project. One word fixes it: make the column "Firestore + Storage rules source" or add "(+ `storage.rules` alongside it)" to each cell.

**33. NIT — the managed daily backup schedule moved from D‑4 (parent) to D‑1 (this plan) without being flagged.** The parent's D‑4 is "the managed backup schedule and vault export (D13)". This plan puts the schedule in D‑1 step 6 and leaves D‑4 as the vault export only. The move is an improvement — but a session resuming from the parent will look for it in D‑4. Add one line to the Decisions log and update the parent's D‑4 bullet.

**34. NIT — record what is deliberately *not* done, so D2 does not assume D‑1 did it.** The parent's IAM inventory has "the deployer holds `iam.serviceAccounts.actAs` on each runtime and build service account". D‑1 creates `build@` but grants no `actAs`. Add to the "Not in this plan" box: "`actAs` on `build@` (D2, at the first functions deploy)". Also worth one line that removing Editor from the default Compute SA is what makes D2's explicit build-SA roles mandatory rather than optional.

**35. NIT — Phase D's deliverables do not include updating the resilience record.** The parent plan says of the IAM inventory: "Christie makes the Console/IAM changes; **each one is recorded in the resilience plan**". This plan records only in its own Decisions log. A second production Firebase project, a second guard, and a new cross-project backup path are exactly the facts that belong in `firebase-backend-resilience-report.html` and in the `firebase-backend-resilience-plan` memory that the global CLAUDE.md cites by name. Add to D‑3 and D‑4 as a closing step.

**36. NIT — D‑2 wires a `firebase.json` predeploy that names a guard which does not exist until D‑3.** Harmless (it fails closed either way) but it contradicts D‑3's "nothing points at a missing script" note. Either have D‑2's refusal sentence say "…this repo's guard, `scripts/deploy-rules.sh` (arrives in D‑3)", or note it in D‑2's "If interrupted".

---

## Verdict

**Ready after fixes.**

Everything here is text-level — no phase needs redesigning, and the shape of the plan (Console-first, guard before wording, wording before first use, backups before Phase E's real data) is right. But #1 is blocking: as sequenced, the IAM baseline that D‑1 signs off on would not actually be in place in the org case, and nobody would know. Fix #1 and the seven other should-fixes with real consequence — #5 (lifecycle read-back on the vault), #6 (the export alert does not catch a failed export), #12 (the first deploy's target runs no tests), #14 (tests can silently hit studio-hub's emulator), #16 (the hook test blocks itself), #17 (deploying from a session loaded with the old rules), #25/#26 (the parsing rule and rule-ordering conflicts) — and this is execution-ready.

One caveat to weigh: findings 11–15 and 25–29 are inferred from the design documents and the parent plan's D4 table, because this session could not open `~/studio-hub/scripts/*` or `~/my-clay-hub/docs/**`. Before executing D‑3, a session that *can* read the guard should re-check the adaptation table against `deploy-rules.sh` and `deploy-rules.test.sh` line by line — particularly the `npm test`-per-target condition, the receipt-ordering code paths on an empty tag set, and whatever takes the lock on the emulator side.
