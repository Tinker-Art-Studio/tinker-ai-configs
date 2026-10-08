## Implementation review, round 1 — Phase E "E-pre": PRs Tinker-Art-Studio/my-clay-hub#13 (docs) and #14 (deriveStatus)
Repo /Users/christiehubley/my-clay-hub. Read-only: don't modify files, switch branches, release anything or use the network; never read ~/.config/configstore/firebase-tools.json. You may run `node --test tests/shared/derive-status.test.js` against a file you read via `git show <branch>:path` only by reasoning — do not check out branches.

Plan (execution-ready, Oct 8): /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html — read "Questions for Christie — answered", "The link contract", E-pre, and the Decisions log. Christie's answers: Q1–Q6 (Q6 = option B), Q8, Q9 as recommended; **Q7 changed by Christie**: a removed member keeps everything last known except email, emailLower and phoneLast4 (the plan's contract "Tombstones" row was updated to match).

PR #13 (branch phase-e-pre-docs): DECISIONS #65–#73, SPEC.md (schedule line, §3 sentence), DATA-MODEL.md (the link section, copied/never-copied fields, envelope, reconcile, deriveStatus rule 7 for Q6, collections, server functions).
PR #14 (branch phase-e-pre-derive-status): shared/derive-status.js — pauseWindows counts a scheduledPause only when processed === true, after the not-an-object check; tests.

Check: (1) the docs say exactly what the plan's contract and Christie's answers say — no contradictions, omissions or overclaims (especially Q7's removed-record fields, the stops in #72, #73's scope, the never-copy list vs clay-hub-membership's real fields in js/app.js and js/member-status.js); (2) DATA-MODEL's deriveStatus rules 1–11 match the code in PR #14 exactly, including order and the D-5 edge notes; (3) the code change is correct and complete (malformed-first order; processed must be the boolean true; history unaffected; rule 10 with only an unprocessed request; nothing else in shared/ or the functions depends on the old behaviour); (4) the tests prove it (do the new ones fail on main?); (5) anything else.

Verdict (safe to merge / merge after fixes / not ready), numbered findings blocking / should-fix / nit with file:line, per PR.

## PR #13 diff
diff --git a/docs/my-clay-hub/DATA-MODEL.md b/docs/my-clay-hub/DATA-MODEL.md
index 085b907..c17362d 100644
--- a/docs/my-clay-hub/DATA-MODEL.md
+++ b/docs/my-clay-hub/DATA-MODEL.md
@@ -37,25 +37,31 @@ Nothing in `my-clay-hub` can read or write `tinker-hq-apps`. Members never get a
    - exactly one live doc → a snapshot of that doc's allowed fields;
    - no live doc → a tombstone;
    - **more than one live doc → a conflict:** nothing is sent, and it alerts.
-3. It POSTs `{memberId, snapshot, readTime}` to the private HTTPS function `ingestMemberUpdate` in `my-clay-hub`, using its own service account's identity token.
+3. It POSTs the envelope (below) to the private HTTPS function `ingestMemberUpdate` in `my-clay-hub`, using its own service account's identity token. Only 200, 400 and 409 answers are final; anything else throws, so the trigger is retried.
 4. `ingestMemberUpdate`, in a transaction:
    - rejects the payload unless it's strictly valid;
-   - **ignores it unless `readTime` is later than the stored `sourceReadTime`** (a member with no stored time accepts anything);
-   - runs `deriveStatus`, and writes `members/{memberId}`;
-   - **never deletes**; a tombstone is a flag.
-
-- **Staff roster:** `users/{uid}` changes flow the same way into `staffRoster/staff_{uid}`, using that document read's `readTime`. Only people with an explicit grant are projected: active, and a manager or admin role, or `appAccess` containing `my-clay-hub`.
-- **Reconcile:** every 6 hours. It reads the whole source in **one read-only transaction pinned to a single `readTime`**, then sends every member (and tombstone) through the same `ingestMemberUpdate` gate.
-  - If the read is incomplete, it changes nothing and alerts.
-  - If a run would change more than 10% of statuses, or tombstone more than 5% of members, it stops and alerts.
+   - **ignores it unless `readTime` is later than the stored `sourceReadTime`** (a member with no stored time accepts anything), comparing seconds *and* nanoseconds; an accepted envelope always advances `sourceReadTime`, even when nothing else changed;
+   - runs `deriveStatus`, and writes `members/{memberId}` and `memberProfiles/{memberId}` together;
+   - **never deletes**; a removal replaces the doc with a removed record (#71).
+
+- **Staff roster:** `users/{uid}` changes flow the same way into `staffRoster/staff_{uid}`, using that document read's `readTime`. Only people with an explicit grant are sent: `role` exactly `admin`|`manager`|`staff`, `active` absent or `true`, `appAccess` absent or a list of strings, and a manager or admin role or `appAccess` containing `my-clay-hub` (#68). Anything else, including a malformed doc, becomes a removal (malformed also alerts, naming the uid only); a removal for someone never held writes nothing.
+- **Reconcile:** every 6 hours (01:15, 07:15, 13:15, 19:15 UTC). It reads the whole source in **one read-only transaction pinned to a single `readTime`**, then sends the complete set in one `reconcile` envelope per scope; `ingestMemberUpdate` works out every change and applies it in **one transaction**, or nothing.
+  - If the read is incomplete, or a live member doc has no valid `memberId`, it sends nothing and alerts.
+  - A `memberId` with more than one live doc is sent as **held**: neither updated nor removed.
+  - A record newer than the batch (a trigger landed meanwhile) is never removed.
+  - The safety stops (#72) apply; a stop writes nothing, answers 409 and logs the counts and ids.
 - `sourceReadTime` is a `tinker-hq-apps` timestamp. It's only ever compared with other `tinker-hq-apps` read times.
 
-**Copied fields only:** `name`, `firstName`, `lastInitial` (worked out from `name`), `email` (original case, for display), `emailLower` (for matching), `stage`, the pause windows (both spellings normalized), `finalAccessDate`, `memberSince`, and **`phoneLast4`**, worked out in `tinker-hq-apps`. The full phone number never leaves that project (#24).
+**Copied fields only** — rebuilt from allowed keys at every level, never copied and trimmed: `name`, `email` (strings, else `null`), `emailLower`, `memberSince` (a valid date, else `null`), `stage` (a known stage, else `"!malformed"`), `retired` (only `true`), `scheduledPause` (`null`, `{startDate, endDate, processed}`, or `"!malformed"`), `pauseHistory` (entries `{startDate, endDate, priorTerm?}`, legacy `start`/`end` mapped), `scheduledCancellation` (`null`, `{finalAccessDate}`, or `"!malformed"`), and **`phoneLast4`**, worked out in `tinker-hq-apps` with Membership Manager's own phone rule (10 digits, or 11 starting with 1; else `null`). Every date is a valid `YYYY-MM-DD`, absent, or `"!malformed"` — never raw text. `firstName` and `lastInitial` are worked out on receipt. The full phone number never leaves that project (#24).
+
+**Never copied, at any nesting level:** `keypadCode`, `keypadUserId`, `staffNotes`, `notes` (including the notes inside pause and cancellation entries), `application`, `actions`, the full phone, the shelf fields, billing and Sawyer fields (`lastBilling`, `processDate`, `sawyerProcessedAt`, …), audit timestamps (`scheduledAt` is reduced to the `processed` flag), and anything not listed above.
+
+**The envelope:** `{v:1, kind: 'member'|'staff'|'reconcile', readTime: {seconds: "<decimal string>", nanos: <int>}, …}` — the exact contract, fixtures and tests are in the Phase E plan (`my-clay-hub-phase-e-link`, "The link contract") and in the shared fixture set both repos test against. Logs never contain names, emails, phone digits, notes or source documents.
 
 ## `deriveStatus(source, todayDenver)` (#34, #35)
 
 Code: `shared/derive-status.js`, using `shared/denver-time.js`. These are the only status and date code: `ingestMemberUpdate` and
-the 3:30 AM recompute import them, and nothing re-derives status elsewhere. `todayDenver` is passed in, never read from the clock inside.
+the daily recompute (09:30 UTC, #65) import them, and nothing re-derives status elsewhere. `todayDenver` is passed in, never read from the clock inside.
 
 Denver calendar dates only. `YYYY-MM-DD` strings are compared as dates, never through `new Date()`. A date must be strictly
 `YYYY-MM-DD` and a real day (no `2026-02-30`, no other shapes); anything else is **malformed**. The rules below run in order; the first match wins.
@@ -68,12 +74,13 @@ Denver calendar dates only. `YYYY-MM-DD` strings are compared as dates, never th
    - valid, and today is **after** it → **`offboarded`**. The last day itself still has access.
 5. `stage: 'cancelled'` with no `finalAccessDate` → **`offboarded`**
 6. `stage: 'offboarding'` with no `finalAccessDate` → **`review`**
-7. Any pause window (in `scheduledPause` or any `pauseHistory` entry, either spelling) that is **missing, malformed, or reversed** (its end is before its start) → **`review`** (C8). A one-day pause (start = end) is valid. A pause with a start but **no end
+7. A `scheduledPause` that isn't an object is malformed → **`review`**. A `scheduledPause` object Membership Manager hasn't processed (`processed` isn't `true`) is **ignored** (#70; pause history entries are always processed).
+8. Any pause window (in a processed `scheduledPause` or any `pauseHistory` entry, either spelling) that is **missing, malformed, or reversed** (its end is before its start) → **`review`** (C8). A one-day pause (start = end) is valid. A pause with a start but **no end
    date** is `review` too, never "paused indefinitely" (#59): staff see the flag and add the end date, and the pause's booking
    cancellation happens then (a window with no end gives nothing to cancel against).
-8. Any valid pause window with **start ≤ today ≤ end** (both days included) → **`paused`**
-9. `stage: 'paused'` with no pause windows at all → **`review`**
-10. Otherwise → **`active`**. That covers `active`, a paused stage whose window has ended, `offboarding` before the last day, and `cancelled` with a future last day.
+9. Any valid pause window with **start ≤ today ≤ end** (both days included) → **`paused`**
+10. `stage: 'paused'` with no pause windows at all → **`review`**
+11. Otherwise → **`active`**. That covers `active`, a paused stage whose window has ended, `offboarding` before the last day, and `cancelled` with a future last day.
 
 How the code reads the edges of these rules (D-5):
 - Rule 1 also treats a record with `retired: true` as no live record, since live means `retired !== true`.
@@ -84,7 +91,7 @@ How the code reads the edges of these rules (D-5):
 - A source that isn't a record at all gives `review`. `deriveStatus` never throws on member data; it throws only if `todayDenver`
   itself isn't a valid date (a caller bug). Supported dates are 1900–2999.
 - **Input shape:** `deriveStatus` reads the `clayHub_members` field shape (`stage`, `scheduledPause`, `pauseHistory`,
-  `scheduledCancellation.finalAccessDate`). Whatever `members/*` stores, `ingestMemberUpdate` and the 3:30 AM recompute must
+  `scheduledCancellation.finalAccessDate`). Whatever `members/*` stores, `ingestMemberUpdate` and the daily recompute must
   hand it that shape. A flattened record would silently read as "no pause, no last day". Phase E tests that round trip.
 - **Deliberate differences from Membership Manager**, where it reads the same fields differently:
   - A missing `stage` is `review` here (rule 3). Membership Manager treats it as active.
@@ -100,17 +107,20 @@ How the code reads the edges of these rules (D-5):
 | `review` | yes | no | "We're checking your membership details — you can still see the feed." Staff see a flag. |
 | `offboarded`, `not_yet`, `removed` | no | no | `enforceMemberStatus` removes the claim, revokes sessions, and disables offboarded accounts (never deletes them). |
 
-It runs inside `ingestMemberUpdate` on every write, and again for everyone at **3:30 AM Denver** daily.
+It runs inside `ingestMemberUpdate` on every write, and again for everyone daily at **09:30 UTC** (#65), for that day's Denver date. The recompute is one transaction; it rewrites `status`, `statusDate` and the profile's `pause`, and stops on more unexplained changes than #72 allows.
 
 ## Collections in `my-clay-hub`
 
-`members/{memberId}`: the projection. It's written **only** by `ingestMemberUpdate`.
-- The copied fields above, plus `status`, `sourceReadTime`, `tombstone`, `updatedAt`.
+`members/{memberId}`: the projection. It's written **only** by `ingestMemberUpdate` and, for `status`/`statusDate` only, the daily recompute (both as `ingest@`, never deleting).
+- The copied fields above, plus `memberId`, `firstName`, `lastInitial`, `status`, `statusDate` (the Denver date it was derived for), `sourceReadTime`, `tombstone`, `updatedAt`.
+- **A removed member (#71)** keeps the last stored fields **minus `email`, `emailLower` and `phoneLast4`**, with `tombstone: true` and `status: 'removed'`.
 - **No client can read it**, not even the member themselves: Firestore rules can't hide single fields, and it holds `phoneLast4` (#24). Functions and rules read it on the server.
 
-`memberProfiles/{memberId}`: the **member-readable view**, written only by `ingestMemberUpdate` alongside `members`. It holds an allowlist only: `firstName`, `name`, `email`, `status`, `memberSince`, the current or next pause window (for the paused message), and `finalAccessDate`. **Never `phoneLast4`.** A member can read only their own.
+`memberProfiles/{memberId}`: the **member-readable view**, written by `ingestMemberUpdate` alongside `members` (and its `status`/`pause` by the daily recompute). Exactly `memberId`, `firstName`, `name`, `email`, `status`, `memberSince`, `pause` (the valid, processed window containing today, else the earliest one starting after today, else `null`), `finalAccessDate` (only if valid), `updatedAt`. **Never `phoneLast4`, never a malformed marker.** A removed member's profile is just `{memberId, tombstone: true, status: 'removed', updatedAt}`. A member can read only their own (from Phase F; deny-all until then).
+
+`staffRoster/staff_{uid}`: `{ uid, name, role, sourceReadTime, updatedAt, tombstone }` for granted staff only (#68), written only by `ingestMemberUpdate`; a removal leaves `{ uid, tombstone: true, sourceReadTime, updatedAt }`. **No client can read it**; rules and functions check it.
 
-`staffRoster/staff_{uid}`: `{ name, role, active, grant }`, written only by `ingestMemberUpdate`. **No client can read it**; rules and functions check it.
+`linkOverrides/{id}`: single-use, scoped, expiring overrides for the safety stops (#72), created only by Christie in the Console. Exact keys per scope (`members`: `maxStatusChanges?`, `maxRemovals?`; `staff`: `maxRemovals`; `recompute`: `maxStatusChanges`), plus `scope`, `expiresAt` (≤ 24 h after the doc's creation) and `usedAt` (set when used). **Deny-all for every client, permanently.**
 
 `settings/app`: a single doc, editable by managers and admins (#50).
 - `areas`: `[{ id: 'glaze', name: 'Glaze station', capacity: 4 }, { id: 'wheels', name: 'Wheels', capacity: 10 }, { id: 'handbuilding', name: 'Handbuilding table', capacity: 6 }]`. The 10 wheels include the 2 standing wheels, which aren't a separate area (#8).
@@ -187,12 +197,13 @@ It runs inside `ingestMemberUpdate` on every write, and again for everyone at **
 ## Server functions
 
 **In `tinker-hq-apps`** (codebase `clayhub-link`: read-only there, and it can only invoke `ingestMemberUpdate`):
-- `onClayMemberWrite`, `onStaffUserWrite`: re-read the source and send a snapshot.
+- `onClayHubMemberWritten`, `onStaffUserWritten`: re-read the source and send a snapshot.
 - `reconcileLink`: every 6 hours, as above.
+- Their two Cloud Run services' only invoker is `clayhub-link@` itself (#73).
 
 **In `my-clay-hub`:**
-- `ingestMemberUpdate`: private HTTPS (`invoker: 'private'`). The only writer of `members` and `staffRoster`. Runs `deriveStatus`. Can't delete.
-- `recomputeStatuses`: 3:30 AM Denver daily.
+- `ingestMemberUpdate`: private HTTPS; its only invoker is `clayhub-link@tinker-hq-apps`. The writer of `members`, `memberProfiles` and `staffRoster`. Runs `deriveStatus`. Can't delete.
+- `recomputeStatuses`: daily at 09:30 UTC (#65); one transaction; writes only `status`, `statusDate` and the profile's `status`/`pause`.
 - `claimMembership`: callable after sign-in. Uses the verified email only; exactly one live, sign-in-eligible member; sets `member: {memberId}` (#33).
 - `exchangeStaffSession`: verifies the Tinker HQ ID token, checks `staffRoster/staff_{uid}`, then getUser/createUser → claims → custom token (#31).
 - `enforceMemberStatus`: removes claims, revokes sessions, and disables accounts for `offboarded`, `not_yet` and `removed`.
diff --git a/docs/my-clay-hub/DECISIONS.md b/docs/my-clay-hub/DECISIONS.md
index 1faf5f2..b4435c3 100644
--- a/docs/my-clay-hub/DECISIONS.md
+++ b/docs/my-clay-hub/DECISIONS.md
@@ -79,3 +79,12 @@ These come from the foundation plan (`~/tinker-ai-configs/thoughts/plans/clayhub
 | 62 | D-4 | Oct 1 | **Scheduled functions in the functions guard** (F13 amended for schedules only; plan `my-clay-hub-d4-vault-export`, V2/V3). A function is declared `"trigger": "https"` or `"trigger": "schedule"`; a declaration's keys are exact. A schedule declares its schedule, `timeZone` `"UTC"` and all five retry values, and no invoker (the CLI makes the runtime account its only caller); the guard and the backstop refuse a manifest whose values differ or are unset. The CLI can't read a Cloud Scheduler job, so Christie reads it in the Console and `--attest` checks it (`scheduler_attested`; the complete job list = every DEPLOYED schedule, i.e. each codebase's newest attempt). **Exception to "every HTTP response sets `x-tinker-reached`":** scheduled functions, whose response firebase-functions writes itself; the unauthenticated probe must still be refused. | M6 required the guard to read the schedule back before D-4's function ships; the CLI never clears a retry setting removed from code, and can't see a job at all. Christie chose the header exception (O6). |
 | 63 | D-4 | Oct 2 | **The weekly vault export** (plan `my-clay-hub-d4-vault-export`, V1, V4–V12, O5). A second functions codebase, `vault`, separate from the canary: `vaultExport` (scheduled, Sundays 09:00 UTC, 3 retries about 10/20/40 min apart, 30-min timeout) copies the whole database to its own folder `weekly/<UTC date>-<6 chars>/` in bucket **`my-clay-hub-vault-exports`** in `tinker-hq-vault` (US multi-region, 56-day lifecycle, 7-day soft delete, no versioning, no retention lock), and waits for Google to finish, every call held to the run's 1,500 s budget; it succeeds only when the export is done, error-free, SUCCESSFUL, at the expected prefix, and its folder is complete. A retry finds a complete folder ("already done") or the running export ("resume") before it starts anything; a rare duplicate is a second complete copy in its own folder, never a mixed one (O5). `vaultFresh` answers a Monitoring uptime check: 200 while the newest complete copy is at most 7 d 18 h old (the email lands at about 8 days). Accounts: `vault-export@` (custom role `vaultExporter`: export + operations get/list; `vaultLister` on the bucket), `vault-watch@` (`vaultLister` on the bucket only), the Firestore service agent (`firestoreExportWriter` on the bucket only, granted in V-4). No deployed function or service account can import into production (only Christie, as Owner, by hand: DATA-RESTORE.md). Built on `@google-cloud/firestore-api` 0.2.0 (where Firestore 9.3.0's admin client and protos live) rather than `@google-cloud/firestore` as the plan first named. Restoring: DATA-RESTORE.md. | The project's own backups (PITR, daily backups) live inside the project that could fail; this is the off-project copy that gates real member data (Phase E). Christie chose US, the uptime check and the 7 d 18 h threshold (O2, O4), a rare duplicate over a lock (O5), and a restore rehearsal after Phase E (O3). |
 | 64 | D-4 | Oct 7 | **A Force run is keyed by the day it actually runs.** V-4's failure-first Force run (Wed Oct 7) showed Cloud Scheduler sends a Force run the job's *next* scheduled time (Sunday Oct 11 09:00 UTC), not "now" as the V7 tests assumed, so a weekday catch-up run would have taken the coming Sunday's key and that Sunday's real run would have skipped as "already done". `runKey` now keys a scheduled time still in the future, or more than 12 h in the past (a Force run on a paused job might carry an old stored time; impl review, Claude), by today's UTC date; a real run and its retries (J15; all within about 3 h of the scheduled time) keep their scheduled date. Accepted limit (impl review, Codex): the header can't tell a Force run's retry from a new Force run, so a retry crossing UTC midnight is keyed by the new day and makes at most one extra complete copy in its own folder (O5), and possibly one extra failure email; if that day is Sunday, the copy is genuinely Sunday's and the 09:00 run's "already done" is correct. Runbook: start Force runs before 20:00 UTC. Until this ships: no Force run at all (on any day, including a Sunday after 09:00 UTC, it would take a later Sunday's key), and V-4's first real export is Sunday Oct 11's scheduled run. | Christie chose it (fix next, before Phase E; don't hold V-4) |
+| 65 | Phase E | Oct 8 | **The daily status recompute runs at 09:30 UTC** (3:30 AM MDT / 2:30 AM MST): after Denver midnight and before the 5 AM opening all year. "Today" is still the Denver date inside the code. (plan `my-clay-hub-phase-e-link`, Q1) | The functions guard allows only UTC schedules; "3:30 AM Denver" isn't a fixed UTC time. Christie chose it. |
+| 66 | Phase E | Oct 8 | **`tinker-hq-apps` gets its own functions guard inside Phase E** (E-3: its own PR and review rounds), next to — and never touching — studio-hub's rules guard. (Q2) | It has no purpose outside the link; it's the highest-risk piece, so it's reviewed on its own. Christie chose it. |
+| 67 | Phase E | Oct 8 | **Google's automatic project-wide grants from the first database-trigger release** (the default Compute account's `run.invoker` and `eventarc.eventReceiver`) are removed after an audit of every workload in `tinker-hq-apps`, and only counted done once a real event is delivered after the removal; the guard's attestation then refuses if they return. (Q3) | They'd give the default account invoke rights across the project every staff app shares. Christie chose it. |
+| 68 | Phase E | Oct 8 | **The staff roster is built in Phase E, without any Tinker HQ change**: it mirrors managers/admins now and honours the `my-clay-hub` Manage Team key when Phase F adds the box. Only granted staff are sent; malformed `users` docs fail closed. (Q4) | Same machinery as members; small. Christie chose it. |
+| 69 | Phase E | Oct 8 | **A delete + re-create in Membership Manager is a new identity**: the old `memberId` becomes a removed record, the new one starts fresh. "Change email" (B4) stays its own plan. (Q5) | Authorized writers can create docs without a rules-level memberId check, so a new memberId can appear. Christie chose it. |
+| 70 | Phase E | Oct 8 | **An unprocessed pause request doesn't block booking.** A `scheduledPause` counts only once Membership Manager has processed it (`scheduledAt` present — its own test, `member-status.js:127-131`); the link sends a `processed` flag, never the timestamp. A non-object `scheduledPause` is still malformed (`review`), checked first. Pause history entries are processed by definition. (Q6, option B) | A Quick Log request isn't started by Membership Manager and the member is still billed; blocking a paying member is the worse error. Christie chose it (both reviewers recommended B). |
+| 71 | Phase E | Oct 8 | **A removed member keeps everything last known except their contact details**: name, member-since, stage, pause history, scheduled pause and last-day date stay in `members/{memberId}`; `email`, `emailLower` and `phoneLast4` are dropped. Their member-facing profile reduces to `removed`. Membership Manager keeps the full record. (Q7) | History (bookings, check-ins, reports) stays readable; the dates are useful and not sensitive; only contact details carry privacy weight. Christie's change to the recommendation. |
+| 72 | Phase E | Oct 8 | **Safety stops on bulk changes.** A reconcile stops (writes nothing, emails Christie) when source-driven status changes exceed max(⌈10% of live members⌉, 10) or removals exceed max(⌈5%⌉, 4); the daily recompute stops on more than that many changes *no pause or last-day date explains*; the staff roster stops at more than 1 removal. A real large change goes through a single-use, scoped, 24-hour override (`linkOverrides`) Christie creates in the Console after checking the listed ids; every use emails her. (Q8) | A sudden mass change almost always means a bug or bad data; a busy 1st of the month must not trip it. Christie agreed. |
+| 73 | Phase E | Oct 8 | **One recorded exception to "never grant run.invoker by hand"**: after the link's first release, Christie grants `run.invoker` to `clayhub-link@` on exactly its two trigger services (never project-wide); the guard declares and attests that list. (Q9) | The pinned CLI sends trigger events as the trigger's own account but never grants it invoke rights on its service (firebase-tools 15.22.3 source). Christie chose it. |
diff --git a/docs/my-clay-hub/SPEC.md b/docs/my-clay-hub/SPEC.md
index d2d2dbe..623070a 100644
--- a/docs/my-clay-hub/SPEC.md
+++ b/docs/my-clay-hub/SPEC.md
@@ -67,7 +67,7 @@ My Clay Hub doesn't read Membership Manager's collection directly: it's in a dif
 | **Offboarded** | From the day **after** their last day (the last day itself still has access): sign-in is turned off (the account is disabled, **not deleted**) and future bookings are cancelled. All history stays in reports. If they're reactivated later, access and history come back. |
 | **Not yet / Removed** | Onboarding or touring members, and records no longer live in Membership Manager, can't sign in. |
 
-Status changes made in Membership Manager take effect automatically. Staff never update two systems. When a member's email changes, Membership Manager keeps their permanent member ID, so their bookings and history carry over (#52).
+Status changes made in Membership Manager take effect automatically. Staff never update two systems. A **pause request that Membership Manager hasn't processed yet** (a Quick Log request) doesn't lock booking until it's processed (#70). When a member is **removed**, My Clay Hub keeps their name and dates for history but drops their email and phone digits (#71). When a member's email changes, Membership Manager keeps their permanent member ID, so their bookings and history carry over (#52).
 
 ---
 
@@ -378,7 +378,7 @@ All of these run on the server (2nd-gen Cloud Functions, or Cloud Tasks), with *
 - event-day reminder
 - pause set → cancel bookings in the pause window
 - offboarding: disable sign-in and cancel future bookings, from the day after the last day
-- member-status recompute: daily at 3:30 AM Denver (it avoids the DST gap)
+- member-status recompute: daily at **09:30 UTC** — 3:30 AM MDT / 2:30 AM MST, always after Denver midnight and before opening (#65)
 - the link's reconcile: every 6 hours
 - inbox TTL cleanup (a Firestore TTL policy)
 

## PR #14 diff
diff --git a/shared/derive-status.js b/shared/derive-status.js
index acef5a2..e259549 100644
--- a/shared/derive-status.js
+++ b/shared/derive-status.js
@@ -1,16 +1,18 @@
 // My Clay Hub — a member's status from their Membership Manager record (DATA-MODEL.md, #34, #35, C8).
 //
-// Plain ES module: no Firebase, no clock. ingestMemberUpdate and the 3:30 AM recompute both call
+// Plain ES module: no Firebase, no clock. ingestMemberUpdate and the daily recompute (#65) both call
 // deriveStatus; nothing else in My Clay Hub works out a member's status on its own.
 //
 // deriveStatus(source, todayDenver)
 //   source       null/undefined for a tombstone (no live record), else an object in the
-//                clayHub_members field shape: stage, scheduledPause {startDate, endDate},
+//                clayHub_members field shape: stage, scheduledPause {startDate, endDate, processed},
 //                pauseHistory [{startDate, endDate} | {start, end}], scheduledCancellation
 //                {finalAccessDate}, plus tombstone/retired. Only these fields are read. Whatever the
-//                members/* projection stores, anything calling this (ingestMemberUpdate, the 3:30 AM
+//                members/* projection stores, anything calling this (ingestMemberUpdate, the daily
 //                recompute) must hand it this shape; a flattened shape would silently read as "no
 //                pause, no last day". Phase E tests that round trip.
+//                scheduledPause.processed (#70): the link sets it true when Membership Manager has
+//                processed the pause (its scheduledAt is present); an unprocessed request is ignored.
 //   todayDenver  today's Denver calendar day, 'YYYY-MM-DD', passed in (see denverYMD in
 //                denver-time.js). Never read from the clock here.
 // Returns one of STATUSES. It never throws for any shape of source; it throws a TypeError only when
@@ -38,13 +40,17 @@ function pauseDates(entry) {
 // { windows: [{ start, end }] (all valid), malformed: boolean }.
 // Malformed (rule 7, C8): a window that isn't an object, has a missing or invalid date, or ends before
 // it starts; or a pauseHistory that is present but isn't a list. A one-day pause (start = end) is valid.
+// A scheduledPause that is an object but not processed (processed !== true) is a request Membership
+// Manager hasn't started: it is skipped, after the not-an-object check (#70). History entries are
+// processed by definition.
 // No source (a tombstone) has no windows; a source that isn't a record is malformed.
 export function pauseWindows(source) {
   if (isAbsent(source)) return { windows: [], malformed: false };
   if (!isObject(source)) return { windows: [], malformed: true };
   const entries = [];
   let malformed = false;
-  if (!isAbsent(source.scheduledPause)) entries.push(source.scheduledPause);
+  const scheduled = source.scheduledPause;
+  if (!isAbsent(scheduled) && (!isObject(scheduled) || scheduled.processed === true)) entries.push(scheduled);
   if (!isAbsent(source.pauseHistory)) {
     if (Array.isArray(source.pauseHistory)) entries.push(...source.pauseHistory);
     else malformed = true;
@@ -95,18 +101,19 @@ export function deriveStatus(source, todayDenver) {
   if (stage === 'cancelled' && last.state === 'absent') return 'offboarded';
   if (stage === 'offboarding' && last.state === 'absent') return 'review';
 
-  // 7. Any malformed pause window (missing, invalid or reversed dates).
+  // 7. and 8. A scheduledPause that isn't an object, or any counted pause window with missing,
+  // invalid or reversed dates. (An unprocessed scheduledPause isn't counted, #70.)
   const pauses = pauseWindows(source);
   if (pauses.malformed) return 'review';
 
-  // 8. Inside a pause window, both ends included.
+  // 9. Inside a pause window, both ends included.
   if (pauses.windows.some(w => compareYMD(w.start, todayDenver) <= 0 && compareYMD(todayDenver, w.end) <= 0)) {
     return 'paused';
   }
 
-  // 9. Paused stage with no pause windows at all.
+  // 10. Paused stage with no pause windows at all.
   if (stage === 'paused' && pauses.windows.length === 0) return 'review';
 
-  // 10. Everything else.
+  // 11. Everything else.
   return 'active';
 }
diff --git a/tests/shared/derive-status.test.js b/tests/shared/derive-status.test.js
index 2fa6bcc..97c3c39 100644
--- a/tests/shared/derive-status.test.js
+++ b/tests/shared/derive-status.test.js
@@ -1,4 +1,5 @@
-// shared/derive-status.js — rules 1–10 of DATA-MODEL.md, in order, plus C8 (a reversed pause is review).
+// shared/derive-status.js — rules 1–11 of DATA-MODEL.md, in order, plus C8 (a reversed pause is review) and #70
+// (an unprocessed scheduledPause is ignored).
 // Run under three machine time zones by tests/unit/tz-matrix.test.js; results must not depend on TZ.
 import { test } from 'node:test';
 import assert from 'node:assert/strict';
@@ -8,11 +9,13 @@ const TODAY = '2026-09-28';
 const member = (fields = {}) => ({ memberId: 'm1', name: 'Test Member', stage: 'active', ...fields });
 const status = (fields, today = TODAY) => deriveStatus(member(fields), today);
 
-const CURRENT_PAUSE = { startDate: '2026-09-01', endDate: '2026-10-31' };
-const PAST_PAUSE = { startDate: '2026-01-01', endDate: '2026-03-31' };
-const FUTURE_PAUSE = { startDate: '2026-11-01', endDate: '2027-01-31' };
-const MALFORMED_PAUSE = { startDate: '2026-09-01', endDate: '2026-09-31' };
-const REVERSED_PAUSE = { startDate: '2026-10-31', endDate: '2026-09-01' };
+// Processed pauses (#70: the link sets processed:true once Membership Manager has started the pause). The extra key is
+// ignored where these are used as pauseHistory entries.
+const CURRENT_PAUSE = { startDate: '2026-09-01', endDate: '2026-10-31', processed: true };
+const PAST_PAUSE = { startDate: '2026-01-01', endDate: '2026-03-31', processed: true };
+const FUTURE_PAUSE = { startDate: '2026-11-01', endDate: '2027-01-31', processed: true };
+const MALFORMED_PAUSE = { startDate: '2026-09-01', endDate: '2026-09-31', processed: true };
+const REVERSED_PAUSE = { startDate: '2026-10-31', endDate: '2026-09-01', processed: true };
 const cancelOn = finalAccessDate => ({ scheduledCancellation: { finalAccessDate, processDate: '2026-09-01' } });
 
 // --- One case per rule --------------------------------------------------------------------------
@@ -57,7 +60,7 @@ test('rule 6: offboarding with no last day → review', () => {
 });
 
 test('rule 7: a pause window with a missing or malformed date → review', () => {
-  assert.equal(status({ scheduledPause: { startDate: '2026-09-01' } }), 'review');
+  assert.equal(status({ scheduledPause: { startDate: '2026-09-01', processed: true } }), 'review');
   assert.equal(status({ scheduledPause: MALFORMED_PAUSE }), 'review');
   assert.equal(status({ pauseHistory: [{ startDate: '2026-01-01', endDate: '' }] }), 'review');
   assert.equal(status({ pauseHistory: [{ start: '2026-01-01' }] }), 'review');
@@ -125,7 +128,7 @@ test('scenario: a pause\'s last day is paused, the next day active (#35)', () =>
 });
 
 test('a pause\'s first and last days are paused; the days either side are not', () => {
-  const m = { stage: 'active', scheduledPause: { startDate: '2026-01-02', endDate: '2026-02-01' } };
+  const m = { stage: 'active', scheduledPause: { startDate: '2026-01-02', endDate: '2026-02-01', processed: true } };
   assert.equal(status(m, '2026-01-01'), 'active');
   assert.equal(status(m, '2026-01-02'), 'paused');
   assert.equal(status(m, '2026-02-01'), 'paused');
@@ -133,7 +136,7 @@ test('a pause\'s first and last days are paused; the days either side are not',
 });
 
 test('a one-day pause (start = end) is valid and paused on that day only', () => {
-  const m = { scheduledPause: { startDate: '2026-09-28', endDate: '2026-09-28' } };
+  const m = { scheduledPause: { startDate: '2026-09-28', endDate: '2026-09-28', processed: true } };
   assert.equal(status(m, '2026-09-27'), 'active');
   assert.equal(status(m, '2026-09-28'), 'paused');
   assert.equal(status(m, '2026-09-29'), 'active');
@@ -148,7 +151,7 @@ test('the last access day still has access; the next day is offboarded', () => {
 test('scenario: a bare date is a Denver day, not UTC midnight', () => {
   // With TZ=UTC, new Date('2026-03-08') would sort the end before a Denver "today" of the 8th
   // for part of the day. Plain strings compare as calendar days, so the member is still paused.
-  assert.equal(status({ scheduledPause: { startDate: '2026-03-01', endDate: '2026-03-08' } }, '2026-03-08'), 'paused');
+  assert.equal(status({ scheduledPause: { startDate: '2026-03-01', endDate: '2026-03-08', processed: true } }, '2026-03-08'), 'paused');
 });
 
 // --- Pause windows: both sources, both spellings, several windows ------------------------------
@@ -241,3 +244,45 @@ test('totality: every stage × last day × pause combination gives one of the si
   }
   assert.equal(cases, 8 * 4 * 5);
 });
+
+// --- #70: an unprocessed scheduledPause (a Quick Log request) doesn't pause anyone ---------------
+
+test('#70: a processed scheduledPause pauses; the same dates unprocessed are ignored', () => {
+  const dates = { startDate: '2026-09-01', endDate: '2026-10-31' };
+  assert.equal(status({ scheduledPause: { ...dates, processed: true } }), 'paused');
+  assert.equal(status({ scheduledPause: { ...dates, processed: false } }), 'active');
+  assert.equal(status({ scheduledPause: { ...dates } }), 'active', 'no processed flag = not processed');
+  assert.equal(status({ scheduledPause: { ...dates, processed: 'true' } }), 'active', 'only the boolean true counts');
+  assert.deepEqual(pauseWindows(member({ scheduledPause: { ...dates, processed: false } })), { windows: [], malformed: false });
+});
+
+test('#70: malformed is checked before processed — a non-object scheduledPause is still review', () => {
+  assert.equal(status({ scheduledPause: '!malformed' }), 'review');
+  assert.equal(status({ scheduledPause: ['2026-09-01', '2026-10-31'] }), 'review');
+  assert.equal(status({ scheduledPause: 20260901 }), 'review');
+  // A malformed date inside a processed pause is review; inside an unprocessed request it is ignored with the request.
+  assert.equal(status({ scheduledPause: { startDate: '2026-09-01', endDate: '!malformed', processed: true } }), 'review');
+  assert.equal(status({ scheduledPause: { startDate: '2026-09-01', endDate: '!malformed', processed: false } }), 'active');
+});
+
+test('#70: pause history counts whatever its flags; an unprocessed request beside a real history pause', () => {
+  assert.equal(status({ pauseHistory: [{ startDate: '2026-09-01', endDate: '2026-10-31' }] }), 'paused');
+  assert.equal(status({ pauseHistory: [{ startDate: '2026-09-01', endDate: '2026-10-31', processed: false }] }), 'paused');
+  assert.equal(status({ scheduledPause: { ...FUTURE_PAUSE, processed: false }, pauseHistory: [CURRENT_PAUSE] }), 'paused');
+});
+
+test('#70: a paused stage whose only pause is an unprocessed request is review (rule 10)', () => {
+  assert.equal(status({ stage: 'paused', scheduledPause: { ...CURRENT_PAUSE, processed: false } }), 'review');
+});
+
+test('#70: the "!malformed" marker the link sends is malformed in every slot', () => {
+  assert.equal(status({ stage: '!malformed' }), 'review');
+  assert.equal(status({ pauseHistory: '!malformed' }), 'review');
+  assert.equal(status({ pauseHistory: ['!malformed'] }), 'review');
+  assert.equal(status({ pauseHistory: [{ startDate: '!malformed', endDate: '2026-10-31' }] }), 'review');
+  assert.equal(status({ scheduledCancellation: '!malformed' }), 'review');
+  assert.equal(status({ ...cancelOn('!malformed') }), 'review');
+  // Precedence is unchanged: removed and not_yet come before any pause data.
+  assert.equal(status({ retired: true, scheduledPause: '!malformed' }), 'removed');
+  assert.equal(status({ stage: 'onboarding', scheduledPause: '!malformed' }), 'not_yet');
+});
