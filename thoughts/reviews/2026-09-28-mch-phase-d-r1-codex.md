codex
I found three blocking design issues and several test/IAM gaps. No files were edited.

1. **Blocking — the vault caller has permission to import into production, contrary to “start exports and nothing else.”**

   D-4 gives `vault-export@` **Cloud Datastore Import Export Admin** ([plan line 221](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:221)). That role includes `datastore.databases.import`, operation cancellation, and operation listing—not merely export. [Google’s role definition](https://docs.cloud.google.com/iam/docs/roles-permissions/firestore) confirms this.

   Suggested text:

   > Create a custom project role for `vault-export@` containing `datastore.databases.export` and only the metadata/operation-read permissions required by the tested workflow. If the workflow polls the long-running operation, include `datastore.operations.get`; explicitly exclude `datastore.databases.import`, `datastore.operations.cancel`, all entity permissions, and all Storage permissions. Do not grant `roles/datastore.importExportAdmin`.

2. **Blocking — Scheduler success does not prove the export succeeded.**

   `exportDocuments` immediately returns a long-running `Operation`; the export then runs in the background. A direct Scheduler HTTP call can receive 2xx and report success even if the operation later fails. Therefore an alert on “Scheduler failed runs” does not satisfy “if the weekly export fails, Christie gets an email,” and the first-run BDD does not cover asynchronous failure. [The Firestore API documents the background operation](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases/exportDocuments); Scheduler considers an HTTP target acknowledged on a 2xx response [per its API](https://docs.cloud.google.com/scheduler/docs/reference/rest/v1beta1/projects.locations.jobs).

   Suggested replacement for C3/D-4:

   > Cloud Scheduler starts a Google-side workflow that calls `exportDocuments`, records the returned operation name, polls it to `done`, and fails unless the operation completes without an error and returns an `outputUriPrefix`. Cloud Monitoring alerts on failed workflow executions. The first-run acceptance test waits for operation completion and verifies the returned export prefix and metadata file, not merely Scheduler success.

   If a Workflow is not desired, move D-4 after D2 and use the guarded Cloud Run function pattern Google recommends for scheduled exports. Either way, initiation-only monitoring is insufficient.

3. **Blocking — the weekly schedule and output path are unsafe or underspecified.**

   The job is scheduled for Sunday 2:00 AM Denver ([line 222](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:222)), exactly inside the spring-forward gap. Google recommends UTC where cadence matters because wall-clock schedules can skip or duplicate around DST. [Cloud Scheduler DST guidance](https://docs.cloud.google.com/scheduler/docs/configuring/cron-job-schedules).

   Also, `outputUriPrefix: gs://…/weekly` is a fixed namespace path. Firestore only auto-generates a timestamped prefix when the URI is the bucket itself; a namespace path is used as supplied. [API definition](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases/exportDocuments).

   Suggested text:

   > Schedule weekly in UTC, for example Sunday 09:00 UTC, with explicit retry settings. Use either the bucket-only URI `gs://<VAULT_BUCKET>` so Firestore generates a unique start-time prefix, or have the workflow construct `gs://<VAULT_BUCKET>/weekly/<scheduled-time>`. Every retry for one scheduled occurrence must reuse the same idempotency decision and must not create an uncontrolled duplicate export.

4. **Should-fix — bucket IAM and the vault acceptance wording conflate two identities.**

   `vault-export@` initiates the export, but the Firestore service agent writes the objects. The predefined Firestore Service Agent role includes object read, list, and delete permissions. [Google’s permission list](https://docs.cloud.google.com/iam/docs/roles-permissions/firestore) confirms this. The plan’s “minimum role” placeholder is not execution-ready, and the overreach BDD tests only `vault-export@`, not the actual bucket writer.

   Suggested text:

   > On the new vault bucket only, grant the `my-clay-hub` Firestore service agent a custom write-only bucket role validated against current export documentation: `storage.buckets.get`, `storage.objects.create`, and only any additional permission proven necessary by the first export. Exclude `storage.objects.get`, `storage.objects.delete`, and access to every other bucket. Verify both identities separately: `vault-export@` has no Storage role; the Firestore service agent can create an export but cannot read or delete an existing object.

   Google explicitly allows a custom role when only write access is needed. [Export/import guidance](https://firebase.google.com/docs/firestore/manage-data/export-import).

   Add a preflight for organization/domain-sharing policy on `tinker-hq-vault`, not just `tinker-hq-apps`.

5. **Should-fix — the guard adaptation would retain Studio Hub’s “Storage has no tests” behavior.**

   The source guard sets `RUN_TESTS=0` for Storage ([source line 67](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:67)), and its test explicitly asserts Storage skips `npm test` ([test line 457](/Users/christiehubley/studio-hub/scripts/deploy-rules.test.sh:457)). My Clay Hub does have Storage emulator tests. Copying the guard “with the same rules-suite behavior” would allow future Storage rules to deploy without those tests.

   Its control-file list also excludes the test runner, test files, and lockfile ([source line 204](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:204)). Thus an older approved commit could supply stale tests while the guard claims its machinery matches `origin/main`.

   Suggested additions to the adaptation table:

   > `storage` sets `RUN_TESTS=1` (or invokes a storage-specific test command); the adapted guard test must assert that a failing Storage rules suite prevents the Firebase CLI call.

   > Expand protected deploy machinery to include `package-lock.json`, `scripts/deploy-rules.test.sh`, the emulator-safety launcher, and every rules-test entrypoint/fixture. An approved commit whose test machinery differs from `origin/main` is refused; rollback remains “restore the payload onto a new main commit.”

   Also explicitly enumerate and rename/test all `tinker-hq-apps` fixture strings, namespaces, `.firebaserc`, fake CLI assertions, receipt messages, predeploy diagnostics, and Storage hash assertions. The current high-level “all renamed” statement is too easy to satisfy partially.

6. **Should-fix — the D-2 production-isolation and stranger scenarios need executable matrices.**

   The prose acceptance is stronger than the displayed BDD. The BDD checks only three representative Firestore operations and says nothing explicit about Storage list, overwrite, or delete. Requiring an emulator host to exist also does not prove that it is the local emulator.

   An admin-context success proves that the emulator is reachable, but not that the authenticated client harness could ever succeed; a broken harness that always uses the wrong context can still pass.

   Suggested text:

   > Parameterize Firestore tests across signed-in and signed-out contexts; `get`, collection `list/query`, create, update, and delete; and `members`, `bookings`, `settings`, plus an arbitrary collection. Parameterize Storage tests across object read/metadata, list, create, overwrite, and delete at root and nested arbitrary paths.

   > `npm test` invokes `firebase emulators:exec --project demo-my-clay-hub --only firestore,storage` explicitly. A launcher validates before loading any Firebase SDK that the project starts with `demo-` and both emulator hosts are loopback host:port values. Test the launcher directly with each host absent, each host non-loopback, and a production project ID.

   > In addition to admin seeding, run the same authenticated client operation against an inline allow fixture and prove it succeeds; then run it against the committed deny-all rules and prove it fails.

7. **Blocking — the Sunday-to-Monday booking behavior is not defined by the data model.**

   D-5 says a crossing booking “counts toward the right weeks” ([line 253](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:253)), but the data model gives each booking one singular `weekKey` and one `minutesCounted` ([DATA-MODEL line 111](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:111)). It never says whether all minutes belong to the start week, the end week, are split, or whether crossing is forbidden. The required test has no unique correct answer.

   Suggested gate text:

   > Before D-5 implementation, record one decision in DATA-MODEL.md: either (a) bookings may not cross a Monday 00:00 Denver boundary; (b) all minutes belong to the start week; or (c) minutes are split across both weeks, with a corresponding multi-week allocation representation. D-5 must not invent this behavior. Its crossing-boundary test must assert the chosen allocation exactly.

8. **Should-fix — “one test per deriveStatus rule” does not prove the ordered table.**

   The crucial property is “first match wins” ([DATA-MODEL line 57](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:57)). Clean isolated cases can all pass while precedence is implemented incorrectly.

   Suggested text:

   > For every rule except the final default, include a conflict case that also matches a later rule and assert that the earlier result wins. Cover tombstone over all fields; onboarding/touring over malformed cancellation and pauses; unknown stage over later fields; expired cancellation over active pause; cancelled-without-date over malformed pause; offboarding-without-date over pause; malformed pause over a different currently active valid pause.

   > Date validation covers strict `YYYY-MM-DD`, impossible dates, leap day, missing endpoints, both pause-history spellings, scheduled pause, multiple windows, future/ended windows, and reversed ranges once their meaning is specified. Cover all four “otherwise active” examples explicitly and ISO week-year boundaries such as Jan 1 belonging to the previous ISO week-year.

9. **Should-fix — D-1’s default-SA and build-SA instructions are not quite the parent IAM baseline.**

   Enforcing `iam.automaticIamGrantsForDefaultServiceAccounts` prevents automatic future grants; it does not substitute for checking and removing any existing Editor binding. The plan currently makes those alternatives ([D-1 step 9](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:80)).

   The build roles are correct in kind, but assigning Storage Object Viewer and Artifact Registry Writer project-wide through the service-account creation screen is broader than the parent’s “source bucket and Artifact Registry access only.” Google documents conditional/bucket- and repository-scoped access for the custom build identity. [Cloud Run functions build guidance](https://docs.cloud.google.com/functions/docs/building). The parent inventory’s deployer `actAs` grant is also absent.

   Suggested text:

   > Enforce `iam.automaticIamGrantsForDefaultServiceAccounts` where available. Independently inventory the Compute and App Engine default service accounts and remove `roles/editor` wherever present. Do not remove or replace Google-managed service-agent roles.

   > Create `build@` now, but scope Artifact Registry Writer to the function repositories and Storage Object Viewer to `gcf-v2-sources-*`, `gcf-v2-uploads-*`, and `run-sources-*` using resource-level grants or documented IAM conditions. Grant Christie `roles/iam.serviceAccountUser` on `build@` only. D2 verifies these bindings and the deployed build-account setting before any function deployment.

10. **Should-fix — the destructive alert test lacks restoration.**

    D-4’s BDD removes the service agent’s bucket permission ([line 237](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:237)) but never restores it. If executed literally, Phase D finishes with backups broken.

    Suggested text:

    > After the failure notification is observed, restore the exact bucket binding, force-run again, wait for the export operation to complete successfully, and record the new output prefix. D-4 is incomplete while the permission remains removed or the final green run has not succeeded.

11. **Nit — record a vault bucket fallback name.**

    Bucket names are globally unique independently of the Firebase project ID. `my-clay-hub-vault-exports` may be unavailable even if the project ID is accepted.

    Suggested text:

    > Bucket name preference: `my-clay-hub-vault-exports`, then `<PROJECT_ID>-vault-exports`, then `<PROJECT_ID>-vault-exports-<short-account-suffix>`. Record the accepted bucket name and substitute it everywhere before creating IAM or Scheduler resources.

D-3’s fundamental ordering is safe: the new guard is merged before global wording points to it, and the hook edit has a non-Bash recovery path. I would strengthen the hook check by specifying actual JSON stdin and asserting “raw deploy → explicit deny JSON” and “ordinary command → exit 0 with no output.” I would also update the repo’s `CLAUDE.md`/`AGENTS.md` immediately after the guard merge, before the global wording, to minimize a temporarily contradictory state. This is not a blocker.

The phase boundary is otherwise sound: provider setup, function runtime identities, cross-project invocation, function deployment, and Artifact Registry cleanup correctly remain in D2/E/F. The Denver/status module and server-side backup work are explicitly part of parent Phase D.

**Verdict: not ready.** The vault workflow/permissions and the cross-week data-model ambiguity need resolution before execution; the remaining items should be incorporated into the acceptance criteria and guard adaptation checklist.
tokens used
166,620
I found three blocking design issues and several test/IAM gaps. No files were edited.

1. **Blocking — the vault caller has permission to import into production, contrary to “start exports and nothing else.”**

   D-4 gives `vault-export@` **Cloud Datastore Import Export Admin** ([plan line 221](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:221)). That role includes `datastore.databases.import`, operation cancellation, and operation listing—not merely export. [Google’s role definition](https://docs.cloud.google.com/iam/docs/roles-permissions/firestore) confirms this.

   Suggested text:

   > Create a custom project role for `vault-export@` containing `datastore.databases.export` and only the metadata/operation-read permissions required by the tested workflow. If the workflow polls the long-running operation, include `datastore.operations.get`; explicitly exclude `datastore.databases.import`, `datastore.operations.cancel`, all entity permissions, and all Storage permissions. Do not grant `roles/datastore.importExportAdmin`.

2. **Blocking — Scheduler success does not prove the export succeeded.**

   `exportDocuments` immediately returns a long-running `Operation`; the export then runs in the background. A direct Scheduler HTTP call can receive 2xx and report success even if the operation later fails. Therefore an alert on “Scheduler failed runs” does not satisfy “if the weekly export fails, Christie gets an email,” and the first-run BDD does not cover asynchronous failure. [The Firestore API documents the background operation](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases/exportDocuments); Scheduler considers an HTTP target acknowledged on a 2xx response [per its API](https://docs.cloud.google.com/scheduler/docs/reference/rest/v1beta1/projects.locations.jobs).

   Suggested replacement for C3/D-4:

   > Cloud Scheduler starts a Google-side workflow that calls `exportDocuments`, records the returned operation name, polls it to `done`, and fails unless the operation completes without an error and returns an `outputUriPrefix`. Cloud Monitoring alerts on failed workflow executions. The first-run acceptance test waits for operation completion and verifies the returned export prefix and metadata file, not merely Scheduler success.

   If a Workflow is not desired, move D-4 after D2 and use the guarded Cloud Run function pattern Google recommends for scheduled exports. Either way, initiation-only monitoring is insufficient.

3. **Blocking — the weekly schedule and output path are unsafe or underspecified.**

   The job is scheduled for Sunday 2:00 AM Denver ([line 222](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:222)), exactly inside the spring-forward gap. Google recommends UTC where cadence matters because wall-clock schedules can skip or duplicate around DST. [Cloud Scheduler DST guidance](https://docs.cloud.google.com/scheduler/docs/configuring/cron-job-schedules).

   Also, `outputUriPrefix: gs://…/weekly` is a fixed namespace path. Firestore only auto-generates a timestamped prefix when the URI is the bucket itself; a namespace path is used as supplied. [API definition](https://docs.cloud.google.com/firestore/docs/reference/rest/v1/projects.databases/exportDocuments).

   Suggested text:

   > Schedule weekly in UTC, for example Sunday 09:00 UTC, with explicit retry settings. Use either the bucket-only URI `gs://<VAULT_BUCKET>` so Firestore generates a unique start-time prefix, or have the workflow construct `gs://<VAULT_BUCKET>/weekly/<scheduled-time>`. Every retry for one scheduled occurrence must reuse the same idempotency decision and must not create an uncontrolled duplicate export.

4. **Should-fix — bucket IAM and the vault acceptance wording conflate two identities.**

   `vault-export@` initiates the export, but the Firestore service agent writes the objects. The predefined Firestore Service Agent role includes object read, list, and delete permissions. [Google’s permission list](https://docs.cloud.google.com/iam/docs/roles-permissions/firestore) confirms this. The plan’s “minimum role” placeholder is not execution-ready, and the overreach BDD tests only `vault-export@`, not the actual bucket writer.

   Suggested text:

   > On the new vault bucket only, grant the `my-clay-hub` Firestore service agent a custom write-only bucket role validated against current export documentation: `storage.buckets.get`, `storage.objects.create`, and only any additional permission proven necessary by the first export. Exclude `storage.objects.get`, `storage.objects.delete`, and access to every other bucket. Verify both identities separately: `vault-export@` has no Storage role; the Firestore service agent can create an export but cannot read or delete an existing object.

   Google explicitly allows a custom role when only write access is needed. [Export/import guidance](https://firebase.google.com/docs/firestore/manage-data/export-import).

   Add a preflight for organization/domain-sharing policy on `tinker-hq-vault`, not just `tinker-hq-apps`.

5. **Should-fix — the guard adaptation would retain Studio Hub’s “Storage has no tests” behavior.**

   The source guard sets `RUN_TESTS=0` for Storage ([source line 67](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:67)), and its test explicitly asserts Storage skips `npm test` ([test line 457](/Users/christiehubley/studio-hub/scripts/deploy-rules.test.sh:457)). My Clay Hub does have Storage emulator tests. Copying the guard “with the same rules-suite behavior” would allow future Storage rules to deploy without those tests.

   Its control-file list also excludes the test runner, test files, and lockfile ([source line 204](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:204)). Thus an older approved commit could supply stale tests while the guard claims its machinery matches `origin/main`.

   Suggested additions to the adaptation table:

   > `storage` sets `RUN_TESTS=1` (or invokes a storage-specific test command); the adapted guard test must assert that a failing Storage rules suite prevents the Firebase CLI call.

   > Expand protected deploy machinery to include `package-lock.json`, `scripts/deploy-rules.test.sh`, the emulator-safety launcher, and every rules-test entrypoint/fixture. An approved commit whose test machinery differs from `origin/main` is refused; rollback remains “restore the payload onto a new main commit.”

   Also explicitly enumerate and rename/test all `tinker-hq-apps` fixture strings, namespaces, `.firebaserc`, fake CLI assertions, receipt messages, predeploy diagnostics, and Storage hash assertions. The current high-level “all renamed” statement is too easy to satisfy partially.

6. **Should-fix — the D-2 production-isolation and stranger scenarios need executable matrices.**

   The prose acceptance is stronger than the displayed BDD. The BDD checks only three representative Firestore operations and says nothing explicit about Storage list, overwrite, or delete. Requiring an emulator host to exist also does not prove that it is the local emulator.

   An admin-context success proves that the emulator is reachable, but not that the authenticated client harness could ever succeed; a broken harness that always uses the wrong context can still pass.

   Suggested text:

   > Parameterize Firestore tests across signed-in and signed-out contexts; `get`, collection `list/query`, create, update, and delete; and `members`, `bookings`, `settings`, plus an arbitrary collection. Parameterize Storage tests across object read/metadata, list, create, overwrite, and delete at root and nested arbitrary paths.

   > `npm test` invokes `firebase emulators:exec --project demo-my-clay-hub --only firestore,storage` explicitly. A launcher validates before loading any Firebase SDK that the project starts with `demo-` and both emulator hosts are loopback host:port values. Test the launcher directly with each host absent, each host non-loopback, and a production project ID.

   > In addition to admin seeding, run the same authenticated client operation against an inline allow fixture and prove it succeeds; then run it against the committed deny-all rules and prove it fails.

7. **Blocking — the Sunday-to-Monday booking behavior is not defined by the data model.**

   D-5 says a crossing booking “counts toward the right weeks” ([line 253](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:253)), but the data model gives each booking one singular `weekKey` and one `minutesCounted` ([DATA-MODEL line 111](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:111)). It never says whether all minutes belong to the start week, the end week, are split, or whether crossing is forbidden. The required test has no unique correct answer.

   Suggested gate text:

   > Before D-5 implementation, record one decision in DATA-MODEL.md: either (a) bookings may not cross a Monday 00:00 Denver boundary; (b) all minutes belong to the start week; or (c) minutes are split across both weeks, with a corresponding multi-week allocation representation. D-5 must not invent this behavior. Its crossing-boundary test must assert the chosen allocation exactly.

8. **Should-fix — “one test per deriveStatus rule” does not prove the ordered table.**

   The crucial property is “first match wins” ([DATA-MODEL line 57](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:57)). Clean isolated cases can all pass while precedence is implemented incorrectly.

   Suggested text:

   > For every rule except the final default, include a conflict case that also matches a later rule and assert that the earlier result wins. Cover tombstone over all fields; onboarding/touring over malformed cancellation and pauses; unknown stage over later fields; expired cancellation over active pause; cancelled-without-date over malformed pause; offboarding-without-date over pause; malformed pause over a different currently active valid pause.

   > Date validation covers strict `YYYY-MM-DD`, impossible dates, leap day, missing endpoints, both pause-history spellings, scheduled pause, multiple windows, future/ended windows, and reversed ranges once their meaning is specified. Cover all four “otherwise active” examples explicitly and ISO week-year boundaries such as Jan 1 belonging to the previous ISO week-year.

9. **Should-fix — D-1’s default-SA and build-SA instructions are not quite the parent IAM baseline.**

   Enforcing `iam.automaticIamGrantsForDefaultServiceAccounts` prevents automatic future grants; it does not substitute for checking and removing any existing Editor binding. The plan currently makes those alternatives ([D-1 step 9](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:80)).

   The build roles are correct in kind, but assigning Storage Object Viewer and Artifact Registry Writer project-wide through the service-account creation screen is broader than the parent’s “source bucket and Artifact Registry access only.” Google documents conditional/bucket- and repository-scoped access for the custom build identity. [Cloud Run functions build guidance](https://docs.cloud.google.com/functions/docs/building). The parent inventory’s deployer `actAs` grant is also absent.

   Suggested text:

   > Enforce `iam.automaticIamGrantsForDefaultServiceAccounts` where available. Independently inventory the Compute and App Engine default service accounts and remove `roles/editor` wherever present. Do not remove or replace Google-managed service-agent roles.

   > Create `build@` now, but scope Artifact Registry Writer to the function repositories and Storage Object Viewer to `gcf-v2-sources-*`, `gcf-v2-uploads-*`, and `run-sources-*` using resource-level grants or documented IAM conditions. Grant Christie `roles/iam.serviceAccountUser` on `build@` only. D2 verifies these bindings and the deployed build-account setting before any function deployment.

10. **Should-fix — the destructive alert test lacks restoration.**

    D-4’s BDD removes the service agent’s bucket permission ([line 237](/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html:237)) but never restores it. If executed literally, Phase D finishes with backups broken.

    Suggested text:

    > After the failure notification is observed, restore the exact bucket binding, force-run again, wait for the export operation to complete successfully, and record the new output prefix. D-4 is incomplete while the permission remains removed or the final green run has not succeeded.

11. **Nit — record a vault bucket fallback name.**

    Bucket names are globally unique independently of the Firebase project ID. `my-clay-hub-vault-exports` may be unavailable even if the project ID is accepted.

    Suggested text:

    > Bucket name preference: `my-clay-hub-vault-exports`, then `<PROJECT_ID>-vault-exports`, then `<PROJECT_ID>-vault-exports-<short-account-suffix>`. Record the accepted bucket name and substitute it everywhere before creating IAM or Scheduler resources.

D-3’s fundamental ordering is safe: the new guard is merged before global wording points to it, and the hook edit has a non-Bash recovery path. I would strengthen the hook check by specifying actual JSON stdin and asserting “raw deploy → explicit deny JSON” and “ordinary command → exit 0 with no output.” I would also update the repo’s `CLAUDE.md`/`AGENTS.md` immediately after the guard merge, before the global wording, to minimize a temporarily contradictory state. This is not a blocker.

The phase boundary is otherwise sound: provider setup, function runtime identities, cross-project invocation, function deployment, and Artifact Registry cleanup correctly remain in D2/E/F. The Denver/status module and server-side backup work are explicitly part of parent Phase D.

**Verdict: not ready.** The vault workflow/permissions and the cross-week data-model ambiguity need resolution before execution; the remaining items should be incorporated into the acceptance criteria and guard adaptation checklist.
