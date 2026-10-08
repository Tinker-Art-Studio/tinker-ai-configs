Verdict: ready after fixes

Reviewer: Claude (independent subagent), round 3, Oct 8 2026. This is a read-only review of my-clay-hub-phase-e-link.html v3. I checked it against:
- my-clay-hub 70ec0d1;
- studio-hub 36b4b63;
- clay-hub-membership (working tree);
- firebase-tools 15.22.3, as installed.

Line numbers like "plan:147" refer to the HTML file.

## Round-2 resolution check

Most round-2 findings are genuinely resolved:
- **Held conflicts, duplicate-id rejection and race-safe removals** are resolved (plan:93-94, 147).
- **The advance of `sourceReadTime` and the A→B→A tests** are resolved (plan:88, 152).
- **The staff rule** is resolved: only granted users are sent, a tombstone for a uid never held is ignored, and the stop is at more than 1 removal.
- **Exact schemas and tombstones** are resolved.
- **The full settings table**, using the guard's key names, is resolved.
- **The status-code rule** is resolved: only 200, 400 and 409 are terminal, and 401/403 now throw. This matches the stop runbook.
- **Recompute is left running during a stop**, so the scheduler attestation still passes.
- **E-7/E-8 now run pause → Q9 → K13 → fill → proof → resume → attest.**
- **The proof of delivery is now evidence-based.**
- **The E-3 isolation test and the E-0 ordering** are resolved.

**F13 / Q9 is confirmed against the CLI.** cloudfunctionsv2.js:209-216 sets `eventTrigger.serviceAccountEmail` to the runtime account. fabricator.js:221-253, 345-389 and 464-492 set an invoker only for https, task-queue, blocking and schedule functions, on both create and update. So nothing grants the trigger account `run.invoker`. A hand grant on the service survives later updates, because the CLI never touches an event trigger's IAM.

**The K13 grants are added only on the first event release of a codebase.** checkIam.js:139-160 adds the Compute and Pub/Sub bindings only when `haveServices.length === 0` (have = the existing endpoints of the codebase being deployed; prepare.js:196-221). Ordinary later releases of clayhub-link won't bring them back. See nit 12 for the one case that does.

What remains is a set of new problems in the v3 additions. None of them blocks, but four are worth fixing before E-pre is frozen.

## Findings

1. **should-fix — The Q6 `processed` definition doesn't match Membership Manager (contract row "snapshot", plan:91; Q6, plan:77). As written, it would ignore every real pause.**
   - The contract says `processed` is true "only when the source scheduledAt is a valid timestamp". In the source, `scheduledAt` is always an ISO string, never a Firestore Timestamp (clay-hub-membership js/app.js:505, 3631). Membership Manager's own test is plain truthiness: `isProcessedScheduledPause(sp) = !!(sp && sp.scheduledAt)` (js/member-status.js:127-131).
   - If someone implements "valid timestamp" literally as a Timestamp check, every processed scheduled pause becomes unprocessed. deriveStatus would then ignore all of them, and paused members could book.
   - **Fix:** define `processed` as exactly Membership Manager's rule (`scheduledAt` present and truthy). If any stricter check is wanted, it must accept an ISO string. Add a fixture using the real ISO-string shape.

2. **should-fix — Q6's change to deriveStatus must check "malformed" before "unprocessed" (E-pre, plan:121-122).**
   - "deriveStatus ignores a scheduledPause whose processed isn't true" is ambiguous for `scheduledPause: "!malformed"`. A string has no `processed` field, so a straightforward implementation would skip it. pauseWindows (shared/derive-status.js:44-48) would then never see it, and the member reads `active` instead of `review`.
   - **Fix:** state the order. A `scheduledPause` that isn't an object is still malformed and gives `review`. Only an object with `processed !== true` is skipped. Also say whether an unprocessed object with bad dates is skipped or counts as review (I'd skip it, matching Membership Manager, which ignores Quick Log requests). Add both cases to the E-pre tests.

3. **should-fix — `settings/linkLimits` lives in the collection Phase F opens to managers (E-2 reconcile, plan:147; firestore.rules, plan:149; runbook, plan:250).**
   - DATA-MODEL.md:115 says `settings/app` is "editable by managers and admins (#50)", and SPEC.md:45 confirms it. Phase F will write a `match /settings/...` rule. A wildcard there, or a later loosening, would let any manager account raise or disable the link's safety stops from a browser.
   - The override also needs more definition:
     - "raises the stop once": who records that it was used?
     - which job it applies to (member reconcile, staff reconcile, recompute);
     - an upper bound;
     - an audit trail. Firestore Data Access audit logs are off by default, so a Console write leaves no record.
   - **Fix:**
     - put it in its own collection (e.g. `linkControl/limits`), with a deny-all rule and a rules test that Phase F can't silently widen;
     - give it the shape `{scope: 'members'|'staff'|'recompute', maxStatusChanges, maxRemovals, expiresAt, reason}`;
     - the function refuses it when `expiresAt` is more than 24 h ahead or in the past;
     - "once" means the function marks it used (`usedAt`, plus the run's counts) in the same transaction that applies it;
     - every use logs an error-level line ("override used: scope, limits, counts"), which the alerts email. That email is the audit record.
   - Keeping it Console-only is fine, given the 24 h expiry and the alert.

4. **should-fix — The reconcile writes the date-driven status changes that the recompute's stop refused, so the recompute stop does nothing (E-2 reconcile and recompute, plan:147-148; Q8, plan:79).**
   - Every reconcile item newer than the stored record is applied, and the status is re-derived with today's date. Date-driven changes aren't counted (correctly), but they are still written.
   - So if the recompute stops on a suspicious batch (say, a Denver-date bug or a bad E-pre deriveStatus change), the next reconcile, at most 6 h later, writes every one of those changes with no check.
   - **Fix:** for an item whose stored source shape equals the incoming one, the reconcile writes only `sourceReadTime` and `updatedAt`, and leaves `status` and the profile to the recompute. Alternatively, keep the current behaviour and say plainly that the recompute stop is advisory only. Also define "source-driven" precisely: counted iff `deriveStatus(new, today) ≠ deriveStatus(storedShape, today)`.

5. **should-fix — The reconcile's reads and threshold count must be inside its transaction (E-2 reconcile, plan:147).**
   - The recompute now says it is one transaction that recomputes everything on retry (plan:148). The reconcile only says "read every target; work out the change set; apply Q8; pass → one transaction".
   - If the reads or the count happen before the transaction, an ingest that lands in between can be overwritten by an older batch value, or a removal can miss the race rule.
   - **Fix:** say that the read of every target, the gate, the race rule and the threshold count all happen inside the one transaction, and are redone on retry. Add a test where an ingest lands during the reconcile.

6. **should-fix — A shared `declarations.json` means E-2's merge breaks the my-clay-hub scheduler attestation for `vault` and `core` until E-6 releases `members` (Order note, plan:116; E-7 gates, plan:219).**
   - In deploy-functions.sh, the scheduler reading must list exactly the jobs of every scheduled function declared across all codebases (the JQ_SCHED comment above line 402).
   - Once E-2 declares `members/recomputeStatuses` on main, a `vault` attestation will fail with "Cloud Scheduler jobs listed […], expected exactly […recompute…]" until that job exists. That includes #64's Monday release, which E-7 lists as a gate. A change to declarations.json also forces a new reading (ATTEST_FILES, deploy-functions.sh:824).
   - **Fix:** in the Order note, either merge E-2 only after #64 is released and attested (and release E-6 promptly after), or note that any vault/core attestation between E-2's merge and E-6 is expected to fail and must be redone after E-6.

7. **should-fix — No alert fires when Eventarc can't deliver to a trigger (alerts, plan:221; Q9, plan:80; interrupted state, plan:268).**
   - Every listed alert depends on the trigger's code running ("any non-2xx the sender sees"). A 403 at the trigger's own Cloud Run service never runs the code. That happens before Q9's grant, or if the per-service grant is lost because the function is deleted and recreated (fabricator's resource-exhausted path, or a future rename). Events then retry silently and are dropped after 24 h.
   - **Fix:** add a log-based alert on Cloud Run request logs for the two trigger services with status ≥ 400. The Eventarc subscription's oldest-unacked-message age is another option. Create it in E-7 step 1 with the others, and expect it to fire between the release and the Q9 grant.

8. **nit — A null date must stay absent (contract, plan:91).** "Every date: … missing → absent, anything else → "!malformed"". deriveStatus treats `null` as absent for `finalAccessDate`, `scheduledPause` and the pause-date fallback (derive-status.js:28-35, 62-68). Say "missing or null → absent", or a member whose `scheduledCancellation.finalAccessDate` is null would read `review` instead of `offboarded`. The legacy mapping should also be "the modern value winning when not null/undefined", as in pauseDates.

9. **nit — Stop runbook "To resume" (plan:249).**
   - If the fix is in the sender, the clayhub-link release happens while `reconcileLink` is still paused. A deploy doesn't change a job's state: createOrReplaceJob only PATCHes the schedule fields (firebase-tools lib/gcp/cloudscheduler.js:55-83). So the ported scheduler check ("not ENABLED") fails that release's attestation.
   - **Fix:** write the order as release → resume `reconcileLink` → Force run → attest.

10. **nit — E-8 step 1 assumes Cloud Scheduler lets you Force run a paused job (plan:232).** I believe it does (the job runs once and stays paused), but I couldn't verify it offline. Confirm this once in the Console before E-7's pause, or resume the job, Force run it, and then pause it again.

11. **nit — Writing `updatedAt` every 6 hours (gate row, plan:88).** Advancing `sourceReadTime` is required. Bumping `updatedAt` on every "unchanged" reconcile item rewrites all ~66 members four times a day, which makes `updatedAt` useless as "last real change" for Phase F. Advance only `sourceReadTime`, or add `checkedAt`.

12. **nit — K13 comes back if the codebase ever has no event triggers.** checkIam re-adds the Compute account's project-wide `run.invoker` and `eventReceiver` whenever a release adds event triggers to a codebase that has none live (checkIam.js:149-152). E-3's attestation catches it. Add a line to FUNCTIONS-ROLLBACK: after any release where the triggers were (re)created, expect the K13 rows and remove them again.

13. **nit — One bad source doc stops removals indefinitely (plan:93, 147).** A live doc without a valid memberId aborts the whole member reconcile. F4 says authorized writers can create one. Single triggers still work, and the alert fires every 6 h. State that removals and catch-up stay stopped until it's fixed, and add it to "what to do when a stop email arrives".

## On the brief's specific questions

- **Source-driven counting:** sound for thresholds. The gap is that date-driven changes still get written (finding 4).
- **held:** correct, and the receiver-side race rule closes round 2's removal race.
- **One-transaction recompute:** correct. Make the reconcile match it (finding 5).
- **linkLimits as a Console override:** acceptable only if it's scoped, consumed, bounded, audited by the alert, and kept out of Phase F's `settings` (finding 3).
- **Q9:** the per-service grant is the right minimum, and the attestation covers drift. Add a delivery-failure alert (finding 7).
- **E-7/E-8 order:** correct. Nothing uses the Compute grants, because delivery runs as clayhub-link@ (F13).
- **Stop runbook:** correct for a receiver-side stop. Fix the resume order (nit 9).
- **Writes to tinker-hq-apps:** none in the design. It holds only a read role, the code uses no write API (tested), and the IAM grants are per-service.
- **Member-data leaks:** none found in the contract. Only allowlisted fields are rebuilt, and `processed` is carried as a boolean, not the timestamp.

No files other than this review were modified. No deploys or network calls were made, and the Firebase CLI credential file was not read.
