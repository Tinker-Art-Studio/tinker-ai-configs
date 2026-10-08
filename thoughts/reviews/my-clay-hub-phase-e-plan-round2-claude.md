Verdict: ready after fixes

Reviewer: Claude (independent subagent), round 2, Oct 8 2026. Read-only review of my-clay-hub-phase-e-link.html v2 against the code at my-clay-hub 70ec0d1, studio-hub 36b4b63, clay-hub-membership f8d69d8, and the installed firebase-tools 15.22.3 (/opt/homebrew/lib/node_modules/firebase-tools).

## Round-1 resolution check

Most round-1 findings are really resolved, not just mentioned:
- **The "!malformed" marker works against the real code.** `isValidYMD("!malformed")` is false, `"!malformed"` isn't in STAGES, and a string where an object or list belongs is malformed (shared/derive-status.js:44-56, 67-71, 87). Mapping legacy to modern "modern wins when not null/undefined" matches `pauseDates` (:30-35).
- **The rules-guard isolation is correct.** studio-hub's `CONTROL_FILES` are firebase.json, package.json, deploy-rules.sh and predeploy-check.sh (deploy-rules.sh:204). The guard runs `npm test` (:348), deploys with `--only $TARGET` (:406), and the backstop accepts only firestore/storage (predeploy-check.sh:22-24). With a separate functions backstop and the functions suites outside `npm test`, rules deploys keep working (with finding 11 added).
- **`["private"]` is right.** It becomes an empty binding in the attestation (deploy-functions.sh:358), an empty invoker list is refused (:184), and schedules need all five retry values and UTC (predeploy-check.sh:242-253).

Still open from round 1:
- Claude #15, staff tombstones and non-granted users: finding 9.
- Codex #3, the exact memberProfiles shape: finding 8.
- Claude #12, the per-service invoker on event triggers: finding 3. Round 1 assumed "the CLI sets it", and that is wrong.
- Codex #13, the sender's attempted-write check: finding 19.

v2 also adds three new holes:
- the reconcile's handling of conflicts;
- "unchanged" not advancing `sourceReadTime`;
- the stop runbook versus the guard's scheduler attestation.

## Findings

1. **blocking — Contract "reconcile" row / E-2 reconcile / E-4 reconcileLink: a memberId in conflict is removed by the reconcile.** D22 says a conflict (more than one live doc) sends nothing, so the held projection stays as it is. But the reconcile sends only "every live source record", and the receiver treats "held live records absent from the batch" as removals. A member in conflict therefore gets a tombstone at the next 6-hourly run, and loses access, which the trigger path deliberately avoids. It also counts toward the 5% stop and can hide real removals. Fix: the reconcile envelope carries an explicit `held: [memberId]` list (conflicts; memberIds only). The receiver neither updates nor removes those, and they're excluded from the denominator. Add a fixture and BDD for it in E-1.

2. **blocking — Contract "Responses" / E-2: "unchanged" must still advance `sourceReadTime`, or out-of-order delivery stays wrong.** Here is the sequence:
   - stored A at T1;
   - the source changes to B (a read at T2), then back to A (a read at T3);
   - T3 arrives first, finds A equal to the stored A, and answers "unchanged" with nothing written, so `sourceReadTime` stays T1;
   - T2 arrives next, is later than T1, and is applied, so the projection shows B while the source is A.

   The same thing happens with a reconcile item that finds no change, followed by a late trigger envelope. That breaks the Goal's claim of being "safe against late, duplicate or out-of-order deliveries" until the next event or reconcile (up to 6 h). Fix: any envelope newer than the stored readTime writes at least `sourceReadTime` (and `updatedAt`). "Unchanged" can remain a result label, but it is not a no-op. Add an A→B→A delivery-order test, both single and reconcile.

3. **blocking — E-3 / E-5 / IAM inventory (D11) / Q3: the event triggers' delivery identity has no run.invoker in the design.** In the pinned CLI:
   - firebase-tools sets `eventTrigger.serviceAccountEmail` to the function's runtime account (lib/gcp/cloudfunctionsv2.js:214-216), so Eventarc delivers as `clayhub-link@`, not as the Compute account;
   - it sets a Cloud Run invoker only for https, task-queue, blocking and schedule functions, never for event triggers (lib/deploy/functions/release/fabricator.js:221-253, 345-389, 475-489).

   D11 gives clayhub-link@ only the read role plus eventReceiver. So unless the Cloud Functions API grants the trigger account run.invoker on its own service (I could not verify that offline), every delivery gets 403 from the very first event, whether or not the K13 grants were removed. The K13 Compute grants wouldn't be what makes delivery work.

   Settle this in E-3 before code:
   - the expected run.invoker list on each trigger service (probably exactly [clayhub-link@]);
   - who sets it: declared and set by the guard, never by hand;
   - D11 updated to match;
   - the attestation checking it.

   E-8 step 2 should confirm the declared design, not discover it. If it is discovered at E-8, the only remedies are a hand grant (forbidden) or a re-plan in the middle of go-live.

4. **should-fix — E-2 reconcile: removals must go through the readTime gate too.** Here is the race:
   - the reconcile reads at T;
   - a member is created at T+1, and that trigger's envelope is ingested before the reconcile POST lands;
   - the member isn't in the batch, so they're tombstoned.

   v2 says the change set is computed "after the readTime gate", but it only spells that out for items. State that a held record whose `sourceReadTime` ≥ the batch readTime is never removed (staff too). Add this case to the test list next to "a stale item inside a batch".

5. **should-fix — Contract "Responses" / "Stopping the link": 401/403/404 are silently swallowed.** "The sender throws only on 5xx, 429 and timeouts", so anything else is treated as done:
   - At go-live, a cross-project invoker binding that doesn't work (F10) drops every trigger event with no retry and no alert. The alert list has ingest 5xx only.
   - The runbook's "Trigger deliveries then fail and Eventarc retries them" is false. With the invoker removed, ingest answers 403, the sender returns normally, and the event is gone.

   Fix: only 200, 400 and 409 are terminal; every other status throws. Add alerts for ingest 400 (contract drift between the two repos) and for the sender seeing any non-2xx. Correct the runbook text (resume already relies on the catch-up reconcile, which is right).

6. **should-fix — "Stopping the link" vs the guard: the "record it" step can't be attested.** The runbook pauses recomputeStatuses, then does a guarded redeploy of the whole `members` codebase. The guard's scheduler attestation refuses any job whose state isn't ENABLED (deploy-functions.sh:402). So either the attest fails, or the redeploy changes the paused job, which defeats the stop. Verify what a deploy does to a paused job. Simplest fix: don't pause recompute in a link stop, since it only re-derives already-stored data; or put it in its own codebase. If it must be paused, give the runbook a defined attestation exception.

7. **should-fix — E-2 / Q8: a legitimate large change has no way through, and a stop cascades.**
   - The recompute's changes are date-driven by construction. After a stop, they stay pending and pile up daily, so it stops again every day until the pauses end. Paused members can book in the meantime.
   - The reconcile re-derives status too, so it sees the same changes and answers 409. Catching up missed trigger events then also stalls, every 6 h.

   Fix:
   - count only source-driven changes toward the reconcile's status threshold (status changes on records whose stored source shape is unchanged come from the date, not from the link);
   - write a resume path for a legitimate large change (e.g., a one-time raised limit shipped as a guarded, reviewed commit) into the runbook;
   - say what Christie does when a 409 or recompute-stop email arrives.

8. **should-fix — Contract / E-2 recompute: memberProfiles is undefined, and its date-dependent field goes stale.** DATA-MODEL.md:111 puts "the current or next pause window" in memberProfiles. That changes with the date, but the recompute rewrites only `status`. The contract's "Computed on receipt" row doesn't define the profile at all. Define every memberProfiles field in the contract and fixtures. The recompute (and its dry run) must recompute every date-dependent profile field, not just status. Also correct DATA-MODEL:107/111 ("written only by ingestMemberUpdate") in E-pre.

9. **should-fix — Contract "staff" row / reconcile: every staff member is copied, not only granted ones.** `{uid, staff:{name, role, active, grant}}` together with "items for every live source record" sends every users doc, grant:false included. That puts the names and roles of all Tinker staff in my-clay-hub (and its vault), against DATA-MODEL.md:47 ("Only people with an explicit grant are projected"). A tombstone for a uid that was never held would also create a roster doc. Fix:
   - grant false → tombstone envelope;
   - the receiver doesn't act on a tombstone for a uid it doesn't hold;
   - staff reconcile items contain only granted users.

   Also, a persistently malformed users doc re-alerts every 6 h: deduplicate, or accept that and say so.

10. **should-fix — Contract "Malformed values": "a string goes as-is" lets free text cross.** Any string in a date or stage slot is carried raw. deriveStatus treats every non-`YYYY-MM-DD` value as malformed, and every unknown stage as review, so canonicalizing loses nothing:
    - a valid YMD goes as-is, anything else becomes "!malformed";
    - a known stage goes as-is, anything else becomes "!malformed".

    Also define non-string `name`, `email` and `memberSince`, and `priorTerm` (carry only `true`). And `scheduledAt` isn't in the contract, so Q6 option B can't be implemented without changing it. Make the contract row depend on the Q6 answer, and settle it in E-pre before E-1's fixtures are frozen.

11. **should-fix — E-3 / E-4: studio-hub firebase.json is a control file, and the rules tests hard-code port 8080.**
    - `rules.test.js:76` uses port 8080, and studio-hub's firebase.json has no emulators block. If E-3/E-4 add or alter `emulators`, or the firestore/storage keys, the rules guard's `npm test` breaks; my-clay-hub pins non-default ports, which is the pattern someone will copy.
    - The isolation test should pin that firebase.json's only change is the added `functions` key. Functions tests should use their own config or ports.
    - Any rules commit made before E-3/E-4 merge (including E-0's) becomes undeployable afterwards, because the control files must match the tip. Sequence E-0 first, or rebase it.

12. **should-fix — E-7 order vs E-3's attestation.** E-3's attestation refuses any undeclared project-wide run.invoker or eventReceiver holder. But E-7 attests before the K13 grants are removed, so the first `--attest` has to fail. Reorder to: deploy → readings → remove the K13 grants → attest. Also define "holder" as role bindings, and say how basic roles are handled: Owner and Editor include the run invoke permission, and the App Engine default account often holds Editor.

13. **should-fix — E-8 step 2 can pass without proving delivery.** "Change one harmless field" (a field that isn't copied) produces "unchanged". The projection then "matches" whether or not the event was delivered after the K13 removal. Require evidence instead:
    - the trigger's execution log, timestamped after the removal;
    - ingest's 200 for that memberId;
    - a stored `sourceReadTime` later than the removal (true once finding 2 is fixed), or change a copied field.

14. **should-fix — Settings table vs the guard.**
    - The guard requires all five limits on every function (deploy-functions.sh:241-242). The triggers have no `concurrency` or `cpu`, and recompute and reconcileLink have no `cpu`.
    - "The guard refuses anything that differs from the declaration" overstates it. Limits aren't in declarations.json; the guard checks only that they're set, maxInstances is 1..10, and live equals the manifest (:241-243, 296). Pin the values in a unit test, and say that in the plan.

15. **nit — phoneLast4.** "Every digit, then the last 4" turns "303-555-1234 x12" into "3412". Use Membership Manager's own rule, `formatPhone` (clay-hub-membership js/member-status.js:293-298): 10 digits, or 11 starting with 1, otherwise null. That matters if Phase F's kiosk matches on these digits.

16. **nit — studio-hub's Netlify deploy publishes the repo root** (netlify.toml `publish = "."`). `functions/clayhub-link/` would then be served publicly on Tinker HQ's site: its code, fixtures, declarations, the ingest URL, and node_modules if uploaded. Rules and scripts are already exposed the same way, so this follows an existing pattern, but add an ignore or accept it explicitly.

17. **nit — E-7 "the existing email channel" in both projects.** tinker-hq-apps may not have one. If not, create it in E-5 with the other Console steps, and include it in the before/after readings.

18. **nit — The 500-write cap is 250 members** (members + memberProfiles, two writes each). Say so, and alert well before it.

19. **nit — No reading that clayhub-link@ holds nothing in my-clay-hub** except run.invoker on ingestmemberupdate. Round 1's live write-refusal check was dropped. Add that line to E-6's IAM after-reading as the cheap substitute.

20. **nit — "First fill exempt" is redundant** with "additions don't count" (an empty collection has nothing to remove or change). Drop it, or define it narrowly, so it can't become a way to bypass the stops later.

## Q6–Q8

**Q6:** I recommend B. A Quick Log request is unprocessed: Membership Manager never starts it and the member is still being billed (member-status.js:129-131, 157-158). It may also be declined. Blocking a paying member's booking is the worse error, compared with a short delay until staff process the request. Scope B to `scheduledPause` only: entries in `pauseHistory` are processed by definition (app.js:3608-3620). Carry a boolean (`processed`) rather than the `scheduledAt` timestamp. This changes deriveStatus and the contract, so it is decided in E-pre with its own review (finding 10).

**Q7:** Agree: minimal tombstones, and replace the profile the same way. Note that vault copies taken before removal keep the old personal fields until vault retention ages them out. Say so in DATA-RESTORE/E-9.

**Q8:** The floors are reasonable for 66 members (10 status changes, 4 removals), but they aren't enough on their own. The thresholds need:
- to count only source-driven changes for the reconcile;
- a recompute stop that doesn't block the reconcile;
- a documented, reviewed path through a legitimate large change.

Without these, one legitimate busy day stops the reconcile and the recompute indefinitely (finding 7). Keep "a stop writes nothing and emails". Add a test where a member with one source change plus a date-driven status change counts once.
