Verdict: ready after fixes

Reviewer: Claude (independent subagent), round 4 (confirming pass), Oct 8 2026. Read-only review of my-clay-hub-phase-e-link.html v4. I checked it against:
- my-clay-hub 70ec0d1 (shared/derive-status.js, scripts/deploy-functions.sh);
- clay-hub-membership js/member-status.js;
- firebase-tools 15.22.3 as installed (checkIam.js, services/index.js).

"plan:N" means a line in the HTML file.

## Round-3 resolution check

Every round-3 finding is addressed, and most are genuinely resolved:

- **Counterfactual source-driven rule (plan:147):** resolved. Both derivations use today's Denver date, inside the transaction, and are redone on retry. There are tests for both coincidences. The stored canonical shape works as deriveStatus input: `"!malformed"` stages, containers and dates all fall through to `review` (derive-status.js:44-58, 63-68, 89). One wording problem remains; see finding 1.
- **linkOverrides (plan:148, 150):**
  - It is its own deny-all collection, with a test that Phase F can't widen it.
  - It has an exact key set, scope, bounds of 0–249 and a 24 h expiry. It is consumed in the same transaction, and every use logs an error line.
  - The 249 cap is right: 2 writes per member plus 1 for consumption fits in 500.
  - Two semantic gaps remain; see finding 3.
- **Q6 (plan:77, 91, 121-122):**
  - "Present" matches `isProcessedScheduledPause(sp) = !!(sp && sp.scheduledAt)` (member-status.js:129-131), and ISO strings count.
  - The order is right: a non-object pause is malformed, then an object with `processed !== true` is ignored. That fits pauseWindows (derive-status.js:44-55), where a non-object `scheduledPause` is already malformed.
  - The test list includes "malformed date with processed:true".
- **E-7/E-8 order (plan:223-237):** resolved. The order is release → pause → K13 → Token Creator → first fill → Q9 → proof → resume + attest. I confirmed in the CLI source that it adds the Compute run.invoker and eventReceiver bindings and the Pub/Sub Token Creator binding together, only when the codebase has no live event services (checkIam.js:139-155). The Firestore service adds no project bindings of its own (services/index.js:92-100). So step 5's reading and step 4's note about recreation are accurate.
- **Two stop kinds (plan:252-256):** resolved. The resume order is release → resume → Force run → attest, and attestation is red during an integrity stop by design.
- **E-2 merge timing (plan:116):** resolved. deploy-functions.sh:392-397 requires the scheduler list to match exactly, so merging after #64's attestation is the right condition.
- **Resolved as written:** reconcile-in-transaction, the trigger-service request-log alert, the staff race test, the recompute cap, null → absent, the end of updatedAt churn, the paused-job Force run, and a bad doc blocking catch-up.

## Findings

1. **should-fix — "Source shape is unchanged" would drop name, email, phone and memberSince edits from the reconcile (E-2 reconcile, plan:147; F6, plan:59).**
   - F6 defines the *source shape* as deriveStatus's inputs only: stage, scheduledPause, pauseHistory, finalAccessDate, tombstone and retired. The reconcile bullet says "a record whose source shape is unchanged gets only its sourceReadTime advanced".
   - Read with F6's meaning, a missed trigger for a name, email, phone or memberSince change would never be repaired by the reconcile. Its sourceReadTime would still advance past the edit, so a later trigger's stale check wouldn't save it either.
   - The reconcile is the catch-up path, so this would silently break D22's "matches within a minute (or at the next reconcile)" promise for exactly the non-status fields.
   - **Fix:**
     - say "a record whose whole canonical snapshot is unchanged (every allowlisted field) gets only sourceReadTime";
     - keep "source shape" only for the counterfactual status comparison;
     - add a reconcile test: the stored record differs only in name, and the reconcile applies it with a status-change count of 0.

2. **should-fix — The recompute's own stop will fire on the busy 1sts that Q8 says are legitimate (Q8, plan:79; recompute, plan:149).**
   - Q8's rationale is that "the 1st of a month can legitimately move" more than 7 people. v4 handles this by excluding date-driven changes from the reconcile's count. The recompute still stops at `max(ceil(10%), 10)` changes, and every one of its changes is date-driven.
   - On a 1st with more than 10 pause starts and ends at 66 members, the recompute writes nothing. Members whose pause began today stay `active` and can book until Christie checks the ids and creates a `recompute` override.
   - This is not unsafe in the data sense, but it is a predictable monthly failure that the plan itself predicts.
   - **Fix (either one):**
     - count only *unexplained* recompute changes. A change is explained when a valid processed pause window starts or ends, or finalAccessDate passes, between the date the status was last derived and today. Stop on unexplained changes over the limit, or on any change to or from `review`/`removed`.
     - or state plainly in Q8 and the runbook that a busy 1st will need an override, and add a fixture showing the stop.

3. **should-fix — Two override semantics are undefined (plan:148).**
   - (a) `maxStatusChanges?` and `maxRemovals?` are optional, but the plan doesn't say what an absent one means. It must mean "Q8's default limit applies", never "unlimited". State that, and test an override that has only `maxRemovals` against a run that is over the default status limit.
   - (b) "A run in that scope whose counts fit an unused, unexpired override consumes it" also matches a run that would have passed anyway. An ordinary scheduled run, or a staff run under the default limit, would silently spend the override, which then isn't there for the Force run Christie made it for. It would also email a misleading "override used" line.
     - Consume an override only when the default limits would stop the run.
     - If several valid overrides exist for one scope, refuse (or pick a defined one) rather than leaving it unspecified.

4. **nit — The claim that retried events are "dropped as stale" is wrong, though harmless (E-8 step 2, plan:234).**
   - Before Q9, the trigger code never runs: the 403 is at its own Cloud Run service. When a retry is finally accepted, the trigger re-reads the source then (D22), so its readTime is after the first fill. The result is `unchanged` (sourceReadTime advanced) or `applied` with current data, not `stale`.
   - Reword it, because an implementer or reviewer checking E-8's logs for "stale" won't find any.
   - Also say that the new trigger-service 4xx alert (plan:222) will fire from the release until Q9, so the email is expected.

5. **nit — Stale cross-references after the reorder.**
   - plan:223 says "Until step 6", but Q9 is now E-8 step 2.
   - plan:272 says "E-8 step 2 is the gate", but the delivery proof is now E-8 step 3.

6. **nit — A test is duplicated (plan:153).** "a removal racing a newer trigger" appears twice: once alone and once as "(members and staff)". Keep the second.

7. **nit — Say how a tombstoned record that reappears is counted (plan:147, Q8 plan:79).** The counterfactual gives `removed` → `active`, which is a status change. Q8 says "additions never count". Say which applies to a reappearance, for example "a reappearing tombstoned id counts as an addition". Then a delete + re-create burst (Q5) can't trip, or fail to trip, the stop unexpectedly.

No other new problems found in v4. Nothing in v4 adds a write path to tinker-hq-apps or a new personal-data path.

No files other than this review were modified. No deploys, git changes or network calls were made, and the Firebase CLI credential file was not read.
