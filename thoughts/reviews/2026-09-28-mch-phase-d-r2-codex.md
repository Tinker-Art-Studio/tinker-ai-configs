codex
Most round-1 findings are resolved correctly. The remaining gaps are narrow but important, especially the parent-plan gates, D-4 retry semantics, and the build-account permissions.

1. **Should-fix — the parent plan was not updated to reflect C3, C5, or C6.**

   The revised plan says the Phase E gate was updated, but the parent still says Phase E merely needs “B, D, D2”; it does not require the first successful vault export. It also still requires the build service account and all server-side backups inside Phase D, and still tests a booking crossing into Monday. See [parent Phase D](/Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html:525) and [parent Phase E](/Users/christiehubley/tinker-ai-configs/thoughts/plans/clayhub-members-foundation.html:580).

   Moving these pieces is operationally sound: the database remains empty and protected by PITR plus managed backups, while Phase E already depends on D2. But the stale parent acceptance could let a later session declare Phase D complete incorrectly or begin loading real data before the export exists.

   Suggested parent text:

   > Phase D creates `build@` with no roles; Phase D2 grants and verifies its build permissions and the deployer’s `actAs` before the first function deployment.
   >
   > The managed daily backup remains in Phase D. The cross-project vault export runs immediately after Phase D2 and must complete successfully once before Phase E may load any real member data.
   >
   > Phase E status: `needs B, D, D2, and the post-D2 vault-export gate`.
   >
   > Replace “a Sunday-night booking crossing into Monday” with “a Sunday booking whose exclusive end is Monday 00:00 and whose booked minutes all belong to Sunday’s ISO week.”

2. **Should-fix — C5 omits a required build role and gives the wrong sequencing rationale.**

   C5 says D2 grants roles “scoped to the build buckets and function repository,” but a custom function build account also needs `roles/logging.logWriter`. Google’s current guidance requires Log Writer, Artifact Registry Writer, and Storage Object Viewer, and permits the Storage grant to be conditioned on the known bucket-name prefixes. Therefore the fact that the buckets do not exist yet does not require waiting until after the first deployment. The Artifact Registry repository can also be created before that deployment. [Google’s custom build-account guidance](https://docs.cloud.google.com/functions/docs/building#secure_your_build_with_private_pools).

   Suggested replacement:

   > **Before any function deployment**, Phase D2 configures `build@` with: `roles/logging.logWriter` on the project; `roles/artifactregistry.writer` on the explicitly selected/pre-created function repositories; and `roles/storage.objectViewer` under an IAM condition limited to `gcf-v2-sources-*`, `gcf-v2-uploads-*`, and `run-sources-*`. Christie receives `roles/iam.serviceAccountUser` on `build@` only. The functions guard requires and read-backs the selected build service account. No bootstrap deployment may run under a default service account.

3. **Should-fix — D-4 still overstates that the Firestore service agent can use a write-only custom role.**

   Current Google documentation says the Firestore service agent needs bucket-level `roles/storage.admin` for export/import. The plan may test whether a smaller custom role works, but it should not promise that create plus bucket-get is sufficient before that is proven. [Firestore export/import documentation](https://docs.cloud.google.com/firestore/native/docs/manage-data/export-import#service_agent_permissions).

   Suggested text:

   > In the D-4 implementation plan, verify the currently documented bucket permissions before creating IAM bindings. Attempt the reviewed custom create-only role only if current Google documentation supports it and an end-to-end export proves it sufficient. Otherwise grant the documented `roles/storage.admin` on the new export bucket only, record explicitly that the Firestore service agent can read, overwrite, and delete objects inside that bucket, and rely on bucket isolation plus soft delete to contain that residual risk. It receives no access to `tinker-hq-vault-backups`.

4. **Should-fix — D-4’s retry behavior is not idempotent and drops part of round-1 Codex finding 3.**

   “Each run writes to its own dated folder” does not make retries safe. A function timeout after the export succeeds can cause the retry to start a second export under a new timestamp. Conversely, reusing an already-populated prefix may fail.

   Suggested replacement:

   > Each scheduled occurrence has one stable occurrence ID and persisted state: output prefix, Firestore operation name, and terminal result. A retry first resumes polling the recorded operation; it never starts a second export for that occurrence. Only a genuinely new scheduled occurrence receives a new prefix. Acceptance includes “operation succeeded but the function failed before recording success”; the retry discovers the existing operation/export and does not create a duplicate.

5. **Should-fix — C6 is sound, but its wording and section reference need correction.**

   SPEC §5 establishes opening at 5:00 AM, closing no later than midnight, and disables bookings or extensions past closing. Thus no booked minute can fall after midnight. However, a Sunday booking ending at midnight has an `end` timestamp on Monday, so saying it “never crosses midnight” may lead an implementer to reject it because its date differs from the start date.

   Also, the crossing example is currently in SPEC **§14**, not §15. See [SPEC scheduling language](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/SPEC.md:100) and [the example](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/SPEC.md:372).

   Suggested text:

   > Booking intervals are half-open `[start, end)`. No booking may contain a minute at or after the day’s closing time. An end equal to `24:00` is represented as the following day’s `00:00`, but contributes no minutes to that following day; therefore the booking belongs wholly to its start date’s ISO week.
   >
   > Correct SPEC §14’s example, not §15.

6. **Should-fix — reversed pause ranges remain undefined.**

   Round-1 Codex finding 8 explicitly requested a decision for `end < start`. D-5 tests malformed dates but does not state whether a syntactically valid reversed range is malformed. Neither the current [DATA-MODEL status table](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DATA-MODEL.md:55) nor the rewrite settles it.

   Suggested text:

   > A pause window whose start or end is missing, malformed, **or whose end is earlier than its start**, is malformed and produces `review` under rule 7. Test this for `scheduledPause`, both `pauseHistory` spellings, and alongside a different valid current window to prove rule 7 wins.

7. **Should-fix — the `.firebaserc` guard adaptation remains only partially resolved.**

   Round-1 Claude finding 15(b) asked for the default project to be asserted by the guard/test, not merely renamed in the copied fixture. The revised control-file list still omits `.firebaserc`. The guard’s explicit `--project` protects guarded deploys, but the predeploy backstop is specifically meant to constrain direct Firebase CLI invocations too.

   Suggested text:

   > Add `.firebaserc` to `CONTROL_FILES`. Before testing or deploying, the guard asserts that `.projects.default == PROJECT`; the adapted suite proves a mismatched default project is refused. The predeploy test also exercises a direct Firebase CLI invocation with the wrong/default project and proves it cannot pass merely because the rule bytes match.

8. **Nit — two round-1 dispositions are absent or incomplete.**

   Claude finding 2, retaining all eight APIs in D-1, is not mentioned in Reviews. Keeping them is reasonable because the parent IAM baseline requires them and the reordered policy plus explicit principal read-back removes the original Editor risk, but that should be recorded.

   Codex finding 11 requested a third globally unique bucket fallback. The current two-name sequence can still exhaust both names.

   Suggested Reviews text:

   > Claude #2 — not adopted: the parent Phase D baseline intentionally enables all eight APIs. The organization policy precedes enablement and the principal list is independently checked afterward, so the default-SA risk is controlled.
   >
   > Vault bucket names are tried in order: `my-clay-hub-vault-exports`, `<PROJECT_ID>-vault-exports`, then `<PROJECT_ID>-vault-exports-<short-account-suffix>`. Record the accepted name and substitute it everywhere before IAM or scheduling is configured.

9. **Nit — Appendix B is correct and sufficient for the round-1 global-CLAUDE.md findings.**

   The three additions correctly:

   - qualify collection rules and guards by project;
   - select the project-specific rollback runbook;
   - preserve the two dropped PROJECT STRUCTURE lines and identify both Storage rule files.

   I would make only one small clarity edit to its first item:

   > Add the rule in the same phase/commit as the code that first reads or writes the collection, and deploy it through that project’s guard.

C7 is sound: the ISO week-year and zero-padded week resolve the year-boundary ambiguity correctly. The remaining round-1 findings—org-policy order and independent Editor verification, project-ID retirement, emulator isolation, recursive deny-all matrices, allow fixtures, Storage testing, protected test machinery, empty receipt handling, hook fixtures, fresh-session ordering, settings verification, resilience recording, status precedence, injected dates, and time-zone-independent tests—are resolved correctly or reasonably deferred into D-4’s required standalone implementation plan.

**Verdict: ready after fixes.**
