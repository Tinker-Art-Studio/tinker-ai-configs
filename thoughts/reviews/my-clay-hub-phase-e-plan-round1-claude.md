Verdict: ready after fixes

Reviewer: Claude (independent subagent), round 1, Oct 8 2026. Read-only review of my-clay-hub-phase-e-link.html against clayhub-members-foundation.html (Phase E, D4/D4a/D11/D21/D22/D23, IAM inventory), firebase-functions-deploy-guard.html, my-clay-hub-d4-vault-export.html, and the code at my-clay-hub 70ec0d1, studio-hub 36b4b63, clay-hub-membership f8d69d8.

The design is sound and follows D22 faithfully. Most facts check out (F1, F2's line refs, F5, F6, F7, F9 and the guard's https/schedule-only refusals at predeploy-check.sh:221-255 and deploy-functions.sh:155-215 are accurate). The three blocking items are: a member-data leak through nested fields; a way for E-3/E-4 to break studio-hub's rules guard, which is the rollback path for every staff app; and blast-radius stops that can't work as written and would block the initial fill.

## Findings

1. **blocking — E-1 / E-2 / E-4: the allowlist is top-level only, so free-text notes leak through the pause and cancellation objects.** The fields that deriveStatus needs are objects, and Membership Manager stores much more in them than dates:
   - `scheduledPause`: `{startDate, endDate, type, notes, scheduledAt, loggedAt, lastBilling, sawyerProcessedAt}` (clay-hub-membership js/app.js:3626-3634, 3761-3766).
   - each `pauseHistory[]` entry: `{type, startDate, endDate, notes, completedAt, lastBilling, sawyerProcessedAt, sawyerPending, autoStarted, priorTerm}` (app.js:3610-3618, 549-559).
   - `scheduledCancellation`: `{finalAccessDate, lastBillingDate, processDate, notes, loggedAt}` (app.js:3768-3774).

   F3's never-copy list and the E-2 test ("never-copy fields rejected if present") only name top-level keys. A builder that copies `scheduledPause` whole, plus a validator that only checks top-level keys, ships staff's free-text pause and cancellation notes to my-clay-hub. Those notes end up in the vault export and possibly in memberProfiles ("the current or next pause window").

   Fix: E-1 defines the allowlist down to the nested level:
   - pause entries: only `startDate`/`endDate`/`start`/`end` (and `priorTerm`, if finding 10 keeps it);
   - cancellation: only `finalAccessDate`.

   The sender's builder and ingest's strict check both enforce it, with a fixture that has every nested forbidden key. The "a source doc with every forbidden field" test in E-4 must include the nested ones.

2. **blocking — E-3 / E-4: adding functions to studio-hub can break `deploy-rules.sh`, the rules guard and rollback path for every staff app.**
   - `deploy-rules.sh` runs `npm test` in its worktree (studio-hub scripts/deploy-rules.sh:348).
   - It treats `firebase.json`, `package.json` and `scripts/predeploy-check.sh` as control files taken from origin/main's tip (:204-209).
   - `predeploy-check.sh` refuses any target except firestore and storage (:22-24).

   my-clay-hub's pattern puts the functions backstop in the same `predeploy-check.sh` and adds every functions suite to `npm test`. Port that as is, and the next rules deploy (or a RULES-ROLLBACK) needs Node 22 plus every codebase installed, and runs modified backstop code. This is exactly how V-4's first attempt was refused (vault plan, Oct 3), but this time in the project every staff app shares, on the path used to undo a bad rules change.

   Fix: E-3 acceptance should say concretely:
   - the rules guard's `npm test` stays rules-only, or the rules guard installs what it needs, tested;
   - the functions backstop lives in its own script, or the firestore/storage branch of `predeploy-check.sh` is byte-identical with a test that pins it;
   - `deploy-rules.test.sh` passes, plus a dry rehearsal of `deploy-rules.sh --status/--diff` on the merged tip.

   E-4's `package.json`/`firebase.json` changes are under the same constraint.

3. **blocking — E-2 / E-4 / Firebase checklist: the 10% / 5% stops can't be enforced as designed, and they block the initial fill.**
   - Statuses are derived in my-clay-hub, yet `reconcileMembers` (tinker-hq-apps) is told to stop if it "would change more than 10% of statuses". It can't know that without reading statuses back across projects.
   - Ingest applies each POST in its own transaction, so after N POSTs the change is already committed. A stop after the fact isn't a stop.
   - E-8's first reconcile creates 100% of members, and "the next 6-hourly reconcile fills it anyway" (Completeness check) would trip the stop forever.

   Fix: give the reconcile its own envelope, `kind: 'reconcile'`, carrying the complete live set pinned to one readTime. Ingest then works out the whole diff (status changes, and tombstones for stored memberIds missing from the set), checks the thresholds, and writes only if they pass, still per member under the readTime gate. This also solves finding 6. Then:
   - define "change" so a first-ever projection doesn't count, or add an explicit guarded initial-fill mode;
   - add BDD for the stop, the initial fill, and a "stopped" run that writes nothing.

4. **should-fix — Recompute's 10% stop with 66 members is about 7 changes.** Pauses tend to start or end on the 1st of the month. A normal day can trip the stop, which leaves members stuck in the wrong status (a paused member able to book, or a returning one locked out) until a person intervenes. Put to Christie: an absolute floor (e.g. max(10%, 10)), or alert and continue for date-driven transitions, which are legitimate by construction since the source didn't change.

5. **should-fix — E-4 retry semantics are undefined.** With `retry: true`, any thrown error is redelivered for up to about 24 h. The plan must say which outcomes return normally:
   - ingest's 400 (strict reject);
   - "stale";
   - conflict;
   - no-memberId skip.

   Only 5xx, 429 and timeouts should throw. Otherwise one malformed legacy doc retries for a day, and the per-member `retry` noise hides real failures. Define ingest's status codes in E-1 (e.g. 200 written, 200/409 stale, 400 invalid) and test the trigger's handling of each.

6. **should-fix — E-4: the reconcile's tombstone source needs data to flow back from my-clay-hub, and the plan leaves that unspecified.** "The list comes back from ingest" is a new response channel from my-clay-hub to tinker-hq-apps (memberIds, possibly statuses for the 10% check). It isn't in E-1's contract, its tests, or the D11 inventory. Either adopt finding 3's design, where ingest computes absentees itself and nothing comes back, or put the response shape (memberIds only) in E-1 with tests that it carries nothing else.

7. **should-fix — E-1: strict validation vs. malformed values.** D4 sends malformed dates, missing stage and similar to `review` (DATA-MODEL:86-88; #58, #59). If "strict" rejects bad date strings, those members are never projected (and retried, per finding 5), when they should show `review`. Specify that strictness is about structure (only allowlisted keys, right container types), and that allowlisted date fields pass through any string or null for deriveStatus to judge. Add fixtures that prove a malformed date gives `review` end to end, not a 400.

8. **should-fix — E-1: readTime serialization.** Firestore read times have microsecond or finer precision. Serialized through `toDate().toISOString()`, two reads in the same millisecond compare equal, and the gate drops the newer one ("not later"). Specify `{seconds, nanos}` (or an RFC 3339 string with nanos) and a comparison on both parts, with a same-millisecond fixture.

9. **should-fix — DATA-MODEL vs E-2 on the stored shape.** DATA-MODEL.md:53 says the pause windows are stored "both spellings normalized". The recompute must rerun deriveStatus on what's stored, and must still see malformed windows, both containers, and `finalAccessDate`'s malformed state. A normalizer that drops a bad window turns `review` into `active`. E-1 should state the stored shape exactly: the raw allowlisted sub-objects, with no normalization before deriveStatus. The round-trip test should use the recompute's real read path.

10. **should-fix — D4 vs Membership Manager on unprocessed pause requests (product question; add to Q-list).** Quick Log writes a `scheduledPause` with no `scheduledAt` (app.js:3761-3766). Membership Manager treats that as "Pause request not yet processed" and never starts it (member-status.js:129-131, 152-158; app.js:546). deriveStatus treats any `scheduledPause` window as a pause (derive-status.js:46-62), so My Clay Hub would show the member `paused` and block booking while Membership Manager still says active. Ask Christie: does an unprocessed request pause access? Add a fixture either way.

    The same question applies to `priorTerm` entries. MM ignores them (member-status.js:40-65), but a malformed old-term entry makes a rejoined member `review` here (F6). Confirm this is wanted.

11. **should-fix — E-6: the probe's identity and the write test are unspecified.**
    - "A one-off, logged invocation in tinker-hq-apps" as clayhub-link@ needs one of two things. One is a deployed function in tinker-hq-apps, which would be the first function deploy there and isn't E-7. The other is Cloud Shell impersonation, which needs a Token Creator grant on clayhub-link@ for Christie. Owner doesn't include `getOpenIdToken`, and a standing grant would let a person act as an identity that can read all of tinker-hq-apps.
    - Name the mechanism. If it's impersonation, grant on that one account, remove it right after, and add before/after IAM readings.
    - The safety checklist says "tested in E-6 (a write attempt is refused)", and the parent E-2 requires "can't write to either database", but E-6's steps and acceptance leave out the write attempt. Add it, against both databases.

12. **should-fix — E-3 / E-5: event delivery identity and the per-service invoker.**
    - With the trigger running as clayhub-link@, the CLI sets the trigger service's run.invoker to that account. The guard's invoker read-back (deploy-functions.sh:360) is HTTP-only, so E-3 must extend the expected-invoker reading to event-triggered services: exactly [clayhub-link@].
    - E-5 should check the Pub/Sub service agent's `iam.serviceAccountTokenCreator`. Google requires it for projects whose Pub/Sub agent predates Apr 2021, and tinker-hq-apps is likely old enough. Without it, triggers never deliver and nothing errors visibly.
    - E-5's build-candidate inventory should also list the App Engine default account (`tinker-hq-apps@appspot.gserviceaccount.com`). Older Firebase projects often hold Editor there.
    - F11's grep only covers local repos. E-5's "confirm in IAM" should also list Cloud Run, Cloud Functions, App Engine, Extensions and Scheduler in the Console before removing anything from a default account.

13. **should-fix — Completeness check: "Stop the link at once" isn't immediate and doesn't match the guard.**
    - The guard refuses an empty invoker list. Only `["private"]` is allowed, and by K11 it empties the binding on update.
    - A guarded redeploy needs a commit, a push, `--diff` and the sha phrase, which takes hours, not "at once".
    - Write the real kill switch:
      - Christie pauses the reconcile's Scheduler job.
      - She removes clayhub-link@'s run.invoker on ingestmemberupdate in the Cloud Run Permissions tab. Revoking is safe even though granting by hand is forbidden.
      - A guarded `["private"]` redeploy follows, so the attested state matches.
    - Note that trigger retries then stop after about 24 h, and the next reconcile catches up.

14. **should-fix — E-8 → E-7: alerts must exist before the link goes live.** Log-based alerts can be created before any log line exists. As written, the first conflicts, no-memberId skips or ingest 400s after E-7 go unseen until E-8. Move the alert creation into E-7's preconditions.

15. **should-fix — E-1 / E-4: the staff roster has no field allowlist, and tombstones leak the staff list.**
    - E-1 defines the member allowlist only. DATA-MODEL:113 says `staffRoster` is `{name, role, active, grant}`; put the staff envelope's allowlist and its fixtures in E-1 too.
    - "Otherwise a tombstone" on every `users` write sends a tombstone for every never-granted staff uid (including kiosk accounts), creating roster docs for people who never had access. Send a tombstone only when the before-image was granted, or have ingest no-op a tombstone for a uid it doesn't hold.
    - Note that `users.name`/`email` are self-editable (studio-hub firestore.rules:147-153 pins only role, appAccess, studios and active). Phase F must never authorize on a roster `email`.
    - Add the parent's "unticking takes effect within a minute" and demotion/archive BDD to E-4.

16. **should-fix — Privacy of tombstones.** "Never deletes" plus "a tombstone sets `tombstone:true`, `status:'removed'`" leaves a deleted member's name, email and phoneLast4 in my-clay-hub (and every vault copy) indefinitely, even after staff deleted them at the source. Ask Christie whether a tombstone should clear the copied personal fields, keeping memberId, `sourceReadTime`, and perhaps `emailLower` for refusing claims. Do the same for memberProfiles.

17. **nit — E-0 fact is slightly off.**
    - "Active on self-update" is already partly covered: "archived staff CANNOT self-write active:true", rules.test.js around line 940.
    - What's missing: an active staff member self-writing `active:false`, and self-create with role 'manager' or 'admin'.
    - The plan cites 790-845, but the users block starts at 810 and the archive block at 912.
    - E-0 ships through the rules guard. studio-hub has other sessions' rules worktrees open (`.claude/worktrees/new-semesters-rules`), so stop if `--diff` shows other hunks (per CLAUDE.md).

18. **nit — phoneLast4 from free text.** Use Membership Manager's own rule (formatPhone: 10 digits, or 11 with a leading 1; member-status.js:293-298). Omit phoneLast4 when the number isn't valid, rather than taking the last 4 digits of "x12"-style legacy text.

19. **nit — E-4 / E-6: the ingest URL is a source constant.** The guard forbids params and `.env` (F13), so the URL must be hard-coded. Use the deterministic `https://ingestmemberupdate-<project number>.us-central1.run.app`, verify it in E-6, and pin it in a test.

20. **nit — E-2: the recompute's runtime account isn't named.** Declarations need one. The recompute should also:
    - use per-member transactions;
    - never touch `sourceReadTime`;
    - update memberProfiles' status too;
    - include a test where it races an ingest.

21. **nit — E-3: the retry prompt.** firebase-tools asks only when a function newly gains retry (its first create, or a change). Say so, and say how the guard answers it (a pty, tested with the fake CLI). In non-interactive mode the CLI otherwise fails without `--force`.

22. **nit — Residual worth one line in the plan.** clayhub-link@'s get/list role covers the whole tinker-hq-apps database, payroll included. IAM can't scope Firestore by collection, so containment is code plus no keys. State this, and add a static test that the link code never calls a write API.

23. **nit — The gate's first export is of an empty my-clay-hub.** It proves the mechanism, not a member-data copy. That's acceptable because the source of truth is tinker-hq-apps and reconcile can rebuild the data, but say so in the Gate line. The first export holding member data is Oct 18 at the earliest.

## Q1–Q5

**Q1:** Agree with UTC, since the guard's UTC-only rule should stand. 09:30 UTC works. 07:15 UTC is closer to Denver midnight in both seasons (00:15 MST / 01:15 MDT), so it shortens the stale window for pause starts and ends and last days. Either is fine; whichever is chosen, finding 4's threshold matters more than the hour.

**Q2:** Agree that it stays inside, as its own branch and PR. Given finding 2, treat E-3 as the highest-risk PR, and make the rules guard's continued health part of its acceptance.

**Q3:** Agree with "neutralize first, then remove the auto-grants, and make attestation fail on them", with finding 12's additions: the Pub/Sub agent check, the App Engine account, a Console inventory, and the event services' invoker read-back. The CLI adds the Compute grants only when the project has no v2 event functions yet. A later teardown and redeploy would re-add them, which the attestation will catch.

**Q4:** Agree to build it now, with finding 15's fixes: a staff allowlist, no tombstones for never-granted users, and unticking/demotion tests.

**Q5:** Agree: handle both, accept the residual, and keep B4 separate. Pair it with finding 16, so that a tombstoned old memberId doesn't keep personal fields indefinitely.
