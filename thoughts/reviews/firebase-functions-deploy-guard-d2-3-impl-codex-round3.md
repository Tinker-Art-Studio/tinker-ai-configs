423c004
codex exit 0
not ready

## Blocking

- [scripts/deploy-functions.sh:301](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:301), [scripts/deploy-functions.sh:665](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:665), [FUNCTIONS-ROLLBACK.md:113](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:113) — F7 still is not fully proven because the evidence records only project-level `storage.objectViewer` bindings.

  Concrete scenario: the expected project-level A5-conditioned binding exists, while another principal has an unconditional `roles/storage.objectViewer` grant directly on one source bucket—or the build account has that role directly on an unrelated bucket. Christie submits the exact expected project binding, and every jq comparison passes, producing `iam_attested=yes`; nevertheless, the role is not limited to the build account and source buckets as required.

  Storage Object Viewer can be granted at project, bucket, or managed-folder level, and Google states that a project IAM-policy view does not show policies on individual buckets. Those bucket policies are readable in the Cloud Storage Console, so they are not part of the acknowledged folder/organization limitation. [Google Cloud Storage IAM documentation](https://docs.cloud.google.com/storage/docs/access-control/iam)

  The evidence model needs resource-level Storage Object Viewer readings—or an explicit, documented decision that bucket/managed-folder grants are outside what F7 attests.

## Confirmed fixed

- The Artifact Registry gap is fixed: project-level and direct repository writers are separately collected and checked.
- The original duplicate/unconditional project-level Storage Object Viewer scenario is fixed: binding rows, members, and conditions are preserved, and exactly one binding is required.
- First-deploy machinery visibility is fixed. `show_machinery` now runs with the empty-tree base in both `--diff` and `--approved`, naming the machinery files and their change sizes.
- I found no new shell/jq logic regression in this patch. `bash -n` and `git diff --check` passed.

[exited with code 0]
