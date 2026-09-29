The rewrite resolves most round-1 findings, but four security/recording blockers remain and two round-2 blockers are only partially resolved. No files or project state were changed.

Fact-check result: K1, K4–K6, K8, K11, and K14 are correct in substance for firebase-tools 15.22.3. K12’s conclusion is right, but its explanation is imprecise. The sealed-manifest approach, `npm ci --prefix`, offline lifecycle-hook test, Node 22 pinning, and proposed hook-command inventory are technically workable.

1. **Blocking — F7 / D2-1: the build identity can retain a broad role, and the first build can still run under the wrong unsecured candidate.**

   Evidence: D2-1 removes only `Editor` from the selected account, then grants O3. But this project already has a legacy Cloud Build principal with `roles/cloudbuild.builds.builder` ([Phase D log](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:409)). Google says the legacy account normally has that broad role, while the Compute account does not ([Cloud Build default service account](https://docs.cloud.google.com/build/docs/cloud-build-service-account)). Therefore, if the legacy account is selected, “that account holds exactly O3 roles” cannot follow from the written steps.

   Treating Build History as authoritative only after the first build is also too late: that build may already have executed under the broad legacy account. Cloud Build Settings lets a user select accounts for permission management, but Google documents the API/CLI as the authoritative way to get the current default; the plan correctly calls its Console reading provisional ([default-account documentation](https://docs.cloud.google.com/build/docs/cloud-build-service-account-updates)).

   Concrete fix: before the first build, neutralize both possible defaults: remove `Editor` from Compute if present and remove `roles/cloudbuild.builds.builder` from the legacy principal. Grant O3 only to the provisional candidate. If the wrong candidate is used, the build then fails safely; grant that actual identity O3 and retry. Acceptance must assert neither candidate retains Editor or Cloud Build Service Account afterward.

   The O3 role set itself—Logs Writer, repository-scoped Artifact Registry Writer, and condition-scoped Storage Object Viewer—is Google’s documented granular minimum and is preferable to `roles/cloudbuild.builds.builder` ([Cloud Run functions build process](https://docs.cloud.google.com/functions/docs/building)).

2. **Blocking — F9: reconciliation receipts break “newest attempt always.”**

   Evidence: the copied rules logic orders receipts primarily by the timestamp in the tag name ([deploy-rules.sh](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:62)). F9 lets an unverified receipt remain non-blocking, then says a later `--reconcile` writes a receipt with a new stamp ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:176)).

   A valid sequence is:

   1. Attempt A is unverified.
   2. Attempt B deploys and verifies.
   3. A is reconciled later and receives the newest tag stamp.

   The copied ordering now calls A the newest attempt even though B was the later production attempt. The old `outcome=complete|partial|unsafe` model has correctly been replaced by independent dimensions, but the new reconciliation record violates the ordering invariant those dimensions depend on.

   Concrete fix: give every deployment a permanent `attempt_id` based on its original reserved stamp. Put reconciliation observations in a separate namespace, or mark them `record_kind=reconcile` and associate them with the original attempt without allowing their tag timestamp to participate in deployment ordering. `--status`, `--diff`, and `--attest` must join records by `attempt_id`. Add the A → B → reconcile-A scenario.

3. **Blocking — F9: the fixed 15-minute delay does not resolve the running-operation race from round 2.**

   Evidence: F9 admits Google’s operation may still be running, but permits reconciliation after 15 minutes whenever `functions:list` no longer says `DEPLOYING` ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:185)). During an update, the list can still expose an older `ACTIVE` function while a long-running operation is outstanding. A later deploy can then begin before the first operation completes.

   Concrete fix: retain the in-flight marker until the actual Cloud Functions long-running operation is terminal. Under the no-gcloud constraint, either:

   - use a read-only helper built on firebase-tools’ authenticated Cloud Functions operations client, without reading the credential file; or
   - require Christie to confirm terminal state in the Console before reconciliation can clear the marker.

   A timeout may be an additional safeguard, but cannot substitute for terminal-state evidence. Add a test where the old endpoint remains `ACTIVE` while the operation is still running.

4. **Blocking — F8: requiring the hash to change makes approved same-SHA retries unverifiable and is not revision read-back.**

   Evidence: `firebase-functions-hash` is deterministic from source, environment, and secrets ([hash.js](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/cache/hash.js:21)). Targeting a codebase prevents skip-unchanged planning, but does not change the computed label. Consequently:

   - F7’s required same-SHA retry after securing a different build identity can deploy successfully but fail F8.
   - D2-5’s same-SHA retry after a setup failure can fail verification.
   - A forced new revision of identical bytes retains the same label.

   The hash is a content label, not a function revision identifier, so the foundation’s “revision read-back” remains amended away rather than implemented.

   Concrete fix: do not require `hash_after != hash_before` unconditionally. Either read an actual revision/update identifier from the raw Cloud Functions/Cloud Run resource, or explicitly obtain Christie’s approval to replace revision read-back with: successful CLI operation, sealed manifest, full configuration match, present content hash, no skip line, and source-byte controls. Add first deploy, changed-source deploy, same-SHA retry, and identical-content redeploy cases.

5. **Blocking — F8 / F9 / D2-5: the combined probe and attestation still do not prove that a service is non-public.**

   Evidence:

   - An anonymous probe misses `allAuthenticatedUsers` and grants to stray named principals.
   - Cloud Run can now be public either through `allUsers` or by disabling the Invoker IAM check. A Permissions page showing no principals does not detect the latter ([Cloud Run IAM access control](https://docs.cloud.google.com/run/docs/securing/managing-access)).
   - A `server: Google Frontend` header is not a trustworthy discriminator by itself; an application response also traverses Google’s frontend.
   - `--attest` accepts a verbatim reading plus an unexplained match result, so a partial implementation could accept a caller-supplied `iam_attested=yes` without validating every function.

   The canary’s anonymous probe is useful because its known reachable response is 204, but it remains an access test, not an IAM-policy read-back.

   Concrete fix: require the attestation for every function to record:

   - Cloud Run Invoker IAM check enabled / “Require authentication”;
   - the complete normalized `roles/run.invoker` member list;
   - the expected list derived from the sealed manifest;
   - a script-computed match result, refusing missing or extra functions and members.

   Store it against the deployment’s `attempt_id`. Keep the anonymous probe as an independent defense-in-depth signal, not proof of “not public.”

6. **Should-fix — K12 / Appendix A5: two build-IAM facts are inaccurate.**

   K12 says selection depends on “project age”; Google describes it in terms of when the first build/default-account transition occurred and organization policy, not simply project creation date ([default-account change](https://docs.cloud.google.com/build/docs/cloud-build-service-account-updates)).

   Appendix A5 also uses `run-sources-760301318440-us-central1`, but Google documents Run source buckets as `run-sources-PROJECT_ID-REGION`; for this project that would use `my-clay-hub`, not the project number. The documented upload-bucket name also has a `.cloudfunctions.appspot.com` suffix, though the current prefix expression happens to match it ([build process](https://docs.cloud.google.com/functions/docs/building)).

   Concrete fix: correct K12 and use documented, boundary-safe resource expressions. Prefer `resource.type == "storage.googleapis.com/Object"` and exact bucket prefixes including the `/objects/` boundary. For this HTTP-only Cloud Functions-v2 phase, omit `run-sources-*` unless a real build proves it is needed.

7. **Should-fix — K1 / F3: executable-mode changes are not covered by the approved-byte check.**

   Evidence: packaging preserves the filesystem mode in the archive, while `getSourceHash` hashes only file bytes ([prepareFunctionsUpload.js](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepareFunctionsUpload.js:42), [hash.js](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/cache/hash.js:13)). F3 requires byte equality but does not require the checked-out mode to match the Git tree.

   Concrete fix: compare regular-file modes against the approved tree, at least distinguishing `100644` and `100755`, both after discovery and in predeploy. Add a positive twin and a `chmod +x` refusal test.

8. **Should-fix — F8: snapshot equality needs canonical normalization.**

   Evidence: the plan says environment values are dropped and the snapshot digest is stored, but does not require sorting functions, object keys, labels, or environment-key lists. Equivalent `functions:list` output in a different order could falsely become “production may be mixed.”

   Concrete fix: define one canonical projection: sort functions by `(codebase, region, id)`, sort all key sets and labels, normalize Firebase defaults such as 256 MiB / concurrency 80 / timeout 60, then hash compact canonical JSON. Add reordered-but-equivalent and genuinely changed fixtures.

9. **Should-fix — F1 contradicts the plan’s declared scope.**

   Evidence: the meta says `scripts/deploy-rules.sh` “is not changed” ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:32)), while F1 moves its receipt-reading block into a shared library and makes both guards source it ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:107)).

   Concrete fix: state explicitly that D2-3 performs a behavior-preserving receipt-library extraction from the rules guard, or keep the rules guard untouched and duplicate the code with a drift test. The proposed extraction plus the untouched rules test suite is the stronger option.

10. **Should-fix — D2-2 / D2-3: several critical acceptance paths can still pass through partial implementations.**

   Missing explicit scenarios include:

   - same-SHA retry after a successful or partially successful deployment;
   - reconcile an older attempt after a newer verified attempt;
   - actual build identity differs from the provisional identity;
   - legacy build identity retains `roles/cloudbuild.builds.builder`;
   - Cloud Run IAM check disabled with no `allUsers` binding;
   - attestation missing one function or one principal;
   - executable-mode mutation;
   - a terminal-looking endpoint while the underlying operation is still active.

   Also, D2-2’s `npm test` can be green with the Functions emulator suite loudly skipped. Although the eventual functions guard sets `TINKER_FUNCTIONS_TESTS=required`, D2-2’s own emulator acceptance should do so explicitly.

   Concrete fix: add these scenarios and require a non-skipped emulator result in D2-2.

11. **Blocking — Amendments / foundation plan: required owner approvals are still outstanding.**

   Evidence: the plan says Christie must approve the direct-CLI-test and invoker/revision-read-back substitutions before D2-2 records them in the foundation plan ([plan](/Users/christiehubley/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html:67)). The supplied owner decisions cover HTTP-only scope and Node 22, but not these two remaining amendments.

   Concrete fix: after correcting the technical issues above, obtain explicit approval for the exact revised substitutions and append them to the foundation plan before marking D2 execution-ready.

Round-1 audit: symlink rejection, generated params, trigger allowlisting, exact `firebase.json`, wrong-codebase detection, independent package installation, CLI pinning, Node 22, emulator coverage, rollback, three-way access results, durable in-flight state, and command inventory are genuinely resolved. Build-identity least privilege, receipt truthfulness, revision evidence, and invoker proof remain incomplete.

not ready
