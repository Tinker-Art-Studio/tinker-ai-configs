Most round-3 fixes are real, but the plan still has three blocking defects. No files or project state were changed.

K1–K14 are substantially correct for firebase-tools 15.22.3, except for K6’s overly broad “before any change” wording. The build-identity order is sound, and Google documents Logs Writer, repository-scoped Artifact Registry Writer, and source-bucket-scoped Storage Object Viewer as the granular build-role set. [Google Cloud build-process documentation](https://docs.cloud.google.com/functions/docs/building).

1. **Blocking — F8: the hash rule still does not prove the expected approved content and rejects valid source changes.**

   Evidence: firebase-tools hashes each file’s bytes, sorts those hashes, and hashes the concatenation; paths and modes are excluded ([prepareFunctionsUpload.js:48](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepareFunctionsUpload.js:48), [line 124](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepareFunctionsUpload.js:124)). Therefore, a rename or mode-only change changes the Git tree but can leave the Firebase hash unchanged. Conversely, F8 accepts any different hash for a new tree, not the exact expected hash. This means the round-1 hash finding is not genuinely resolved, despite the Reviews section claiming an independent computation.

   Concrete fix: use the pinned 15.22.3 packaging and `applyBackendHashToBackends` algorithm to compute and store each endpoint’s exact expected `firebase-functions-hash`, then require equality with live. Add tests for a rename, mode-only change, arbitrary wrong-but-different hash, same-SHA retry, and failed-build retry.

2. **Blocking — F8/F13/F14: live environment, VPC, and secret drift can survive into the new revision without being rejected before deployment.**

   Evidence: when no dotenv file is used, the CLI merges every existing live environment variable into the desired endpoint ([prepare.js:260](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:260)). F8 checks the five-key set only after the CLI call, so an injected live variable is carried into the deployed revision before the guard reports failure.

   `functions:list` also exposes `secretEnvironmentVariables` and VPC settings ([cloudfunctionsv2.js:393](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudfunctionsv2.js:393), [line 417](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/gcp/cloudfunctionsv2.js:417)), but F8’s live comparison omits both. F14 constrains only the sealed manifest, not surviving live state.

   Concrete fix: validate the before-snapshot before creating the in-flight record or invoking deploy. Refuse unexpected environment keys, any live secret environment variable, and any live VPC configuration unless the sealed manifest explicitly and verifiably clears it. Add those fields to the post-deploy equality check. Tests must assert that the CLI is never invoked for each pre-existing drift case.

3. **Blocking — F2/F14: the proposed canary does not satisfy the plan’s own manifest requirements.**

   Evidence: the canary specifies `serviceAccount: 'canary@'`, while the declaration expects the full service-account email. It declares `ingress: ALLOW_ALL` only in `declarations.json`, not in the function options, so the manifest comparison fails. It also omits `cpu`, although F14 requires CPU to be explicitly present; CLI defaulting happens after manifest parsing ([prepare.js:331](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:331)). The manifest schema permits nullable defaults, including `minInstances` and VPC ([v1alpha1.js:58](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/runtimes/discovery/v1alpha1.js:58)), while F14’s allowed null/absent semantics are underspecified.

   Concrete fix: define the canary with the full service-account email, explicit `ingressSettings`, explicit CPU, and preferably explicit `minInstances: 0`. Precisely define absent/null/empty semantics for VPC and secret fields. Make O1 assert the entire normalized canary manifest, not selected fields.

4. **Should-fix — F9/D2-5: receipt-writing verification modes are not pinned to trusted verifier code.**

   Evidence: `--reverify` can write a record after the guard’s F8 logic is changed in a later commit; D2-5 explicitly proposes this. The plan does not require `--reverify`, `--reconcile`, `--attest`, or `--clear-inflight` to run from a clean origin commit or record the verifier commit.

   Concrete fix: every tag-writing mode should require a clean worktree at a fetched origin commit, verify its control files, and record the verifier commit. If verification semantics changed since the attempt, record that fact and require explicit reviewed-owner acknowledgement. Add dirty/unpushed verifier refusal tests.

5. **Should-fix — F7: the fallback path leaves unnecessary O3 grants on the provisional build candidate.**

   Evidence: if Google uses the other candidate, F7 grants O3 to it but never revokes O3 from the unused provisional account. The three roles themselves are sufficient and appropriately scoped, but retaining them on both candidates is not minimal. Google also recommends identifying the actual default through the Cloud Build API/CLI; under the fixed no-gcloud decision, Build History after a safely failed build is a reasonable substitute. [Cloud Build default-account documentation](https://docs.cloud.google.com/build/docs/cloud-build-service-account-updates).

   Concrete fix: after Build History identifies the actual account, grant O3 there, remove O3 from the unused candidate, and re-attest that neither account holds Editor or `roles/cloudbuild.builds.builder` and only the actual account holds O3.

6. **Should-fix — F10: scratch `HOME` does not remove credentials inherited through environment variables.**

   Evidence: the scratch home prevents firebase-tools from copying Christie’s stored refresh token, but an inherited `GOOGLE_APPLICATION_CREDENTIALS`, `FIREBASE_TOKEN`, or related credential variable can still reach the emulator and function process.

   Concrete fix: launch the emulator under scratch `HOME` with credential-bearing variables explicitly unset. Test both an intentionally populated parent environment and absence inside the function.

7. **Nit — K6: “before any change” is inaccurate.**

   The deletion refusal is after preparation and upload. Preparation may enable APIs or create service agents ([prepare.js:211](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:211)); the source archive has also been uploaded. It is before function release, not before every production-side effect.

   Concrete fix: change K6 to “after upload, before any function create/update/delete is released.” F9 already honestly records that APIs and service agents may change.

8. **Nit — F12: the description of `functions:config:export` is wrong for 15.22.3.**

   Evidence: this version exports Runtime Config into a Secret Manager secret and may create a new secret version; it does not write `.env.<alias>` locally ([functions-config-export.js:42](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/commands/functions-config-export.js:42)).

   Concrete fix: keep denying it, but state the actual reason: it creates or updates production Secret Manager state.

Round-1 audit: symlink/mode control, generated `.env` prevention, sealed discovery, codebase validation, Node 22, pinned CLI, deletion preflight, emulator coverage, durable in-flight state, three-way probing, IAM attestation, command inventory, and receipt ordering are genuinely addressed. The remaining unresolved round-1 item is the exact expected-hash proof in finding 1.

The receipt design is now coherent: independent dimensions replace `complete|partial|unsafe`; attempt timestamps alone determine newest attempt; verify/attest records join by `attempt_id`; status names newer unverified attempts rather than falsely calling an older verified attempt “what shipped.” Findings 2 and 4 are the remaining trust gaps.

The anonymous probe is valid evidence only that an unauthenticated request was refused. It does not detect `allAuthenticatedUsers`, named callers, inherited grants, or a disabled Invoker IAM check. The fixed-shape Console attestation covers the first three project/service-level cases and the disabled-check case, while folder/org inheritance remains an explicitly accepted residual.

M7 also still requires Christie’s approval before execution, as the plan already records.

ready after fixes
