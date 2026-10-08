## Implementation review, round 2 (confirming) — PR Tinker-Art-Studio/my-clay-hub#13 (docs), now at ee1e5b3
Repo /Users/christiehubley/my-clay-hub. Read-only; don't switch branches or modify anything; no network.
Round-1 reviews: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/my-clay-hub-phase-e-pre-impl-round1-codex.md and -claude.md. Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html.
Confirm every round-1 finding on PR #13 is resolved by the diff below (Codex's 2 blocking: UTC vs Denver wording in SPEC/DATA-MODEL; #72's full counting rule — and the should-fixes from both), and that the docs now match the plan's contract and Christie's answers with nothing contradictory left anywhere in SPEC.md / DATA-MODEL.md / DECISIONS.md (read the whole files on branch phase-e-pre-docs via `git show phase-e-pre-docs:<path>`). Verdict (safe to merge / merge after fixes / not ready) and numbered findings blocking / should-fix / nit with file:line.

## Diff since round 1
diff --git a/docs/my-clay-hub/DATA-MODEL.md b/docs/my-clay-hub/DATA-MODEL.md
index c17362d..997d72f 100644
--- a/docs/my-clay-hub/DATA-MODEL.md
+++ b/docs/my-clay-hub/DATA-MODEL.md
@@ -49,14 +49,17 @@ Nothing in `my-clay-hub` can read or write `tinker-hq-apps`. Members never get a
   - If the read is incomplete, or a live member doc has no valid `memberId`, it sends nothing and alerts.
   - A `memberId` with more than one live doc is sent as **held**: neither updated nor removed.
   - A record newer than the batch (a trigger landed meanwhile) is never removed.
-  - The safety stops (#72) apply; a stop writes nothing, answers 409 and logs the counts and ids.
+  - The safety stops (#72) apply — denominators exclude held ids, additions never count, a removal counts only as a removal — and a stop writes nothing, answers 409 and logs the counts and ids.
 - `sourceReadTime` is a `tinker-hq-apps` timestamp. It's only ever compared with other `tinker-hq-apps` read times.
 
-**Copied fields only** — rebuilt from allowed keys at every level, never copied and trimmed: `name`, `email` (strings, else `null`), `emailLower`, `memberSince` (a valid date, else `null`), `stage` (a known stage, else `"!malformed"`), `retired` (only `true`), `scheduledPause` (`null`, `{startDate, endDate, processed}`, or `"!malformed"`), `pauseHistory` (entries `{startDate, endDate, priorTerm?}`, legacy `start`/`end` mapped), `scheduledCancellation` (`null`, `{finalAccessDate}`, or `"!malformed"`), and **`phoneLast4`**, worked out in `tinker-hq-apps` with Membership Manager's own phone rule (10 digits, or 11 starting with 1; else `null`). Every date is a valid `YYYY-MM-DD`, absent, or `"!malformed"` — never raw text. `firstName` and `lastInitial` are worked out on receipt. The full phone number never leaves that project (#24).
+**Copied fields only** — rebuilt from allowed keys at every level, never copied and trimmed: `name`, `email` (strings, else `null`), `emailLower` (`email` lowercased, or `null`), `memberSince` (a valid date, else `null`), `stage` (a known stage, else `"!malformed"`), `retired` (only `true`), `scheduledPause` (`null`, `{startDate, endDate, processed}`, or `"!malformed"` if not an object; `processed` is `true` only when the source `scheduledAt` is present and non-empty), `pauseHistory` (`[]`, a list of `{startDate, endDate, priorTerm?}` entries — legacy `start`/`end` mapped, the modern value winning — with `"!malformed"` for an entry that isn't an object, or `"!malformed"` if it isn't a list), `scheduledCancellation` (`null`, `{finalAccessDate}`, or `"!malformed"`), and **`phoneLast4`**, worked out in `tinker-hq-apps` with Membership Manager's own phone rule (10 digits, or 11 starting with 1; else `null`). Every date is a valid `YYYY-MM-DD`, absent, or `"!malformed"` — never raw text. `firstName` and `lastInitial` are worked out on receipt. The full phone number never leaves that project (#24).
 
 **Never copied, at any nesting level:** `keypadCode`, `keypadUserId`, `staffNotes`, `notes` (including the notes inside pause and cancellation entries), `application`, `actions`, the full phone, the shelf fields, billing and Sawyer fields (`lastBilling`, `processDate`, `sawyerProcessedAt`, …), audit timestamps (`scheduledAt` is reduced to the `processed` flag), and anything not listed above.
 
-**The envelope:** `{v:1, kind: 'member'|'staff'|'reconcile', readTime: {seconds: "<decimal string>", nanos: <int>}, …}` — the exact contract, fixtures and tests are in the Phase E plan (`my-clay-hub-phase-e-link`, "The link contract") and in the shared fixture set both repos test against. Logs never contain names, emails, phone digits, notes or source documents.
+**The envelope (summary; the exact contract is the Phase E plan's "The link contract", and E-1 adds a fixture set both repos test against):** `{v:1, kind: 'member'|'staff'|'reconcile', readTime: {seconds: "<decimal string>", nanos: <int 0..999999999>}, …}`.
+- Any unknown key, version or kind, a non-canonical `readTime`, a `memberId` not matching Membership Manager's `m_` + version-4 UUID pattern, or duplicate ids in a reconcile → **400**, nothing written.
+- Answers: 200 `{result: applied|unchanged|stale}`, 400, or 409 (a stopped reconcile). `updatedAt` moves only when content changes; `sourceReadTime` advances on every accepted envelope.
+- Logs never contain names, emails, phone digits, notes or source documents.
 
 ## `deriveStatus(source, todayDenver)` (#34, #35)
 
@@ -91,8 +94,9 @@ How the code reads the edges of these rules (D-5):
 - A source that isn't a record at all gives `review`. `deriveStatus` never throws on member data; it throws only if `todayDenver`
   itself isn't a valid date (a caller bug). Supported dates are 1900–2999.
 - **Input shape:** `deriveStatus` reads the `clayHub_members` field shape (`stage`, `scheduledPause`, `pauseHistory`,
-  `scheduledCancellation.finalAccessDate`). Whatever `members/*` stores, `ingestMemberUpdate` and the daily recompute must
-  hand it that shape. A flattened record would silently read as "no pause, no last day". Phase E tests that round trip.
+  `scheduledCancellation.finalAccessDate`, plus `tombstone`/`retired`). Whatever `members/*` stores, `ingestMemberUpdate` and the daily recompute must
+  hand it that shape — **including `tombstone: true` for a removed record**, which keeps its stage and dates (#71) and would
+  otherwise read as active or paused. A flattened record would silently read as "no pause, no last day". Phase E tests that round trip.
 - **Deliberate differences from Membership Manager**, where it reads the same fields differently:
   - A missing `stage` is `review` here (rule 3). Membership Manager treats it as active.
   - Waitlisted and deferred people are stored as `stage: 'cancelled'`, so they derive to `offboarded`, not `not_yet`. Neither
@@ -107,20 +111,20 @@ How the code reads the edges of these rules (D-5):
 | `review` | yes | no | "We're checking your membership details — you can still see the feed." Staff see a flag. |
 | `offboarded`, `not_yet`, `removed` | no | no | `enforceMemberStatus` removes the claim, revokes sessions, and disables offboarded accounts (never deletes them). |
 
-It runs inside `ingestMemberUpdate` on every write, and again for everyone daily at **09:30 UTC** (#65), for that day's Denver date. The recompute is one transaction; it rewrites `status`, `statusDate` and the profile's `pause`, and stops on more unexplained changes than #72 allows.
+It runs inside `ingestMemberUpdate` on every write, and again for everyone daily at **09:30 UTC** (#65), for that day's Denver date. The recompute is one transaction; it rewrites `status`, `statusDate` and the profile's `status`/`pause` (and `updatedAt` only when content changes), and stops on more unexplained changes than #72 allows. Since #70 (Oct 8) inserted rule 7, rules 8–11 were numbered 7–10 before; older DECISIONS rows use the old numbers.
 
 ## Collections in `my-clay-hub`
 
 `members/{memberId}`: the projection. It's written **only** by `ingestMemberUpdate` and, for `status`/`statusDate` only, the daily recompute (both as `ingest@`, never deleting).
 - The copied fields above, plus `memberId`, `firstName`, `lastInitial`, `status`, `statusDate` (the Denver date it was derived for), `sourceReadTime`, `tombstone`, `updatedAt`.
-- **A removed member (#71)** keeps the last stored fields **minus `email`, `emailLower` and `phoneLast4`**, with `tombstone: true` and `status: 'removed'`.
+- **A removed member (#71)** keeps the last stored snapshot fields **minus `email`, `emailLower` and `phoneLast4`**, plus `{memberId, firstName, lastInitial, tombstone: true, status: 'removed', statusDate, sourceReadTime, updatedAt}`; if nothing was ever stored for that `memberId`, only those last fields. A later live record replaces it with the full allowlist again.
 - **No client can read it**, not even the member themselves: Firestore rules can't hide single fields, and it holds `phoneLast4` (#24). Functions and rules read it on the server.
 
 `memberProfiles/{memberId}`: the **member-readable view**, written by `ingestMemberUpdate` alongside `members` (and its `status`/`pause` by the daily recompute). Exactly `memberId`, `firstName`, `name`, `email`, `status`, `memberSince`, `pause` (the valid, processed window containing today, else the earliest one starting after today, else `null`), `finalAccessDate` (only if valid), `updatedAt`. **Never `phoneLast4`, never a malformed marker.** A removed member's profile is just `{memberId, tombstone: true, status: 'removed', updatedAt}`. A member can read only their own (from Phase F; deny-all until then).
 
 `staffRoster/staff_{uid}`: `{ uid, name, role, sourceReadTime, updatedAt, tombstone }` for granted staff only (#68), written only by `ingestMemberUpdate`; a removal leaves `{ uid, tombstone: true, sourceReadTime, updatedAt }`. **No client can read it**; rules and functions check it.
 
-`linkOverrides/{id}`: single-use, scoped, expiring overrides for the safety stops (#72), created only by Christie in the Console. Exact keys per scope (`members`: `maxStatusChanges?`, `maxRemovals?`; `staff`: `maxRemovals`; `recompute`: `maxStatusChanges`), plus `scope`, `expiresAt` (≤ 24 h after the doc's creation) and `usedAt` (set when used). **Deny-all for every client, permanently.**
+`linkOverrides/{id}`: single-use, scoped, expiring overrides for the safety stops (#72), created only by Christie in the Console. Exact keys per scope (`members`: `maxStatusChanges?`, `maxRemovals?`; `staff`: `maxRemovals`; `recompute`: `maxStatusChanges`), plus `scope`, `expiresAt` (no more than 24 h after the doc's Firestore `createTime`) and `usedAt` (`null`; a server timestamp once used). Limits are integers 0–249; `members` needs at least one, and an omitted one keeps its normal value. An override is used only when the normal limit would stop the run, and is consumed in the same transaction; two eligible overrides for one scope → both refused. The exact rules are in the Phase E plan (E-2). **Deny-all for every client, permanently.**
 
 `settings/app`: a single doc, editable by managers and admins (#50).
 - `areas`: `[{ id: 'glaze', name: 'Glaze station', capacity: 4 }, { id: 'wheels', name: 'Wheels', capacity: 10 }, { id: 'handbuilding', name: 'Handbuilding table', capacity: 6 }]`. The 10 wheels include the 2 standing wheels, which aren't a separate area (#8).
@@ -199,7 +203,7 @@ It runs inside `ingestMemberUpdate` on every write, and again for everyone daily
 **In `tinker-hq-apps`** (codebase `clayhub-link`: read-only there, and it can only invoke `ingestMemberUpdate`):
 - `onClayHubMemberWritten`, `onStaffUserWritten`: re-read the source and send a snapshot.
 - `reconcileLink`: every 6 hours, as above.
-- Their two Cloud Run services' only invoker is `clayhub-link@` itself (#73).
+- The two **trigger** services (`onclayhubmemberwritten`, `onstaffuserwritten`) get `run.invoker` for `clayhub-link@` from Christie's recorded grant on exactly those two services, never project-wide; the guard declares and attests that list (#73). (Project Owners can always invoke; Google's project-wide grant to the default Compute account is removed after the first release and its removal proven, #67.)
 
 **In `my-clay-hub`:**
 - `ingestMemberUpdate`: private HTTPS; its only invoker is `clayhub-link@tinker-hq-apps`. The writer of `members`, `memberProfiles` and `staffRoster`. Runs `deriveStatus`. Can't delete.
@@ -217,4 +221,4 @@ It runs inside `ingestMemberUpdate` on every write, and again for everyone daily
 - `kioskNowList`: kiosk role only. The "Here now / Arriving soon" first-name list (#45).
 - `exportCsv(type, filters)`: staff with reports access only (#50).
 
-All scheduled jobs are 2nd gen, with explicit retries, run in America/Denver, and are tested for DST changes and week boundaries.
+All scheduled jobs are 2nd gen, with explicit retries, **declared in UTC** (the guard allows only UTC; #65) at times that land in the right Denver window all year; what they compute uses Denver calendar days, and is tested for DST changes and week boundaries.
diff --git a/docs/my-clay-hub/DECISIONS.md b/docs/my-clay-hub/DECISIONS.md
index b4435c3..3fbd6f3 100644
--- a/docs/my-clay-hub/DECISIONS.md
+++ b/docs/my-clay-hub/DECISIONS.md
@@ -86,5 +86,5 @@ These come from the foundation plan (`~/tinker-ai-configs/thoughts/plans/clayhub
 | 69 | Phase E | Oct 8 | **A delete + re-create in Membership Manager is a new identity**: the old `memberId` becomes a removed record, the new one starts fresh. "Change email" (B4) stays its own plan. (Q5) | Authorized writers can create docs without a rules-level memberId check, so a new memberId can appear. Christie chose it. |
 | 70 | Phase E | Oct 8 | **An unprocessed pause request doesn't block booking.** A `scheduledPause` counts only once Membership Manager has processed it (`scheduledAt` present — its own test, `member-status.js:127-131`); the link sends a `processed` flag, never the timestamp. A non-object `scheduledPause` is still malformed (`review`), checked first. Pause history entries are processed by definition. (Q6, option B) | A Quick Log request isn't started by Membership Manager and the member is still billed; blocking a paying member is the worse error. Christie chose it (both reviewers recommended B). |
 | 71 | Phase E | Oct 8 | **A removed member keeps everything last known except their contact details**: name, member-since, stage, pause history, scheduled pause and last-day date stay in `members/{memberId}`; `email`, `emailLower` and `phoneLast4` are dropped. Their member-facing profile reduces to `removed`. Membership Manager keeps the full record. (Q7) | History (bookings, check-ins, reports) stays readable; the dates are useful and not sensitive; only contact details carry privacy weight. Christie's change to the recommendation. |
-| 72 | Phase E | Oct 8 | **Safety stops on bulk changes.** A reconcile stops (writes nothing, emails Christie) when source-driven status changes exceed max(⌈10% of live members⌉, 10) or removals exceed max(⌈5%⌉, 4); the daily recompute stops on more than that many changes *no pause or last-day date explains*; the staff roster stops at more than 1 removal. A real large change goes through a single-use, scoped, 24-hour override (`linkOverrides`) Christie creates in the Console after checking the listed ids; every use emails her. (Q8) | A sudden mass change almost always means a bug or bad data; a busy 1st of the month must not trip it. Christie agreed. |
+| 72 | Phase E | Oct 8 | **Safety stops on bulk changes.** A reconcile stops (writes nothing, emails Christie) when source-driven status changes exceed max(⌈10% × N⌉, 10) or removals exceed max(⌈5% × N⌉, 4), where N = the live members it holds minus any held (conflicted) ids; additions never count; a removal counts only as a removal, never also as a status change; a status change is source-driven when the edit itself changes today's status; the daily recompute stops on more than max(⌈10% × N⌉, 10) changes *no pause or last-day date explains*; the staff roster stops at more than 1 removal. A real large change goes through a single-use, scoped, 24-hour override (`linkOverrides`) Christie creates in the Console after checking the listed ids; every use emails her. (Q8) | A sudden mass change almost always means a bug or bad data; a busy 1st of the month must not trip it. Christie agreed. |
 | 73 | Phase E | Oct 8 | **One recorded exception to "never grant run.invoker by hand"**: after the link's first release, Christie grants `run.invoker` to `clayhub-link@` on exactly its two trigger services (never project-wide); the guard declares and attests that list. (Q9) | The pinned CLI sends trigger events as the trigger's own account but never grants it invoke rights on its service (firebase-tools 15.22.3 source). Christie chose it. |
diff --git a/docs/my-clay-hub/SPEC.md b/docs/my-clay-hub/SPEC.md
index 623070a..2fc76c9 100644
--- a/docs/my-clay-hub/SPEC.md
+++ b/docs/my-clay-hub/SPEC.md
@@ -382,7 +382,7 @@ All of these run on the server (2nd-gen Cloud Functions, or Cloud Tasks), with *
 - the link's reconcile: every 6 hours
 - inbox TTL cleanup (a Firestore TTL policy)
 
-All times are **America/Denver**. The tests must cover **DST changes** and **week boundaries**, for example a Sunday booking ending at 12:00 AM counts in that Sunday's week. No booking can cross midnight (DATA-MODEL.md, C6).
+All member-facing times and calendar days are **America/Denver**. Scheduled jobs are *declared* in UTC (the functions guard allows only UTC), at times chosen to land in the right Denver window all year (#65). The tests must cover **DST changes** and **week boundaries**, for example a Sunday booking ending at 12:00 AM counts in that Sunday's week. No booking can cross midnight (DATA-MODEL.md, C6).
 
 `tinker-hq-apps` is on the **Blaze** plan. `my-clay-hub` will be created on Blaze in plan Phase D. Each project records its Firestore location, trigger location and function region (#54).
 
