not ready

## Findings

### Blocking — IAM evidence still cannot prove the complete O3 bindings

[scripts/deploy-functions.sh:289](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:289) reduces project-role bindings to holder sets, while [deploy-functions.sh:295](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:295) accepts only one condition string per role. This loses binding-level information.

Concrete failure: the actual build account has both the correct A5-conditioned `storage.objectViewer` binding and a second unconditional binding. Evidence can report the same sole holder plus the expected A5 expression, producing `iam_attested=yes`. The unconditional binding remains effective; Google explicitly states that a conditional binding does not restrict an additional unconditional binding for the same principal and role. [Google IAM documentation](https://docs.cloud.google.com/iam/docs/managing-conditional-role-bindings)

Artifact Registry has a parallel scope gap. The generated instructions and runbook request only **direct** repository holders at [deploy-functions.sh:656](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:656) and [FUNCTIONS-ROLLBACK.md:114](/Users/christiehubley/my-clay-hub/FUNCTIONS-ROLLBACK.md:114). Another principal can hold project-level `roles/artifactregistry.writer`, which applies to `gcf-artifacts`, while the submitted direct-holder list still contains only the build account. The comparison at [deploy-functions.sh:294](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:294) then passes. Artifact Registry roles can be granted at either project or repository scope. [Artifact Registry access-control documentation](https://docs.cloud.google.com/artifact-registry/docs/access-control)

The tests at [deploy-functions.test.sh:681](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:681) and [deploy-functions.test.sh:684](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:684) mutate the flat evidence fields, so they cannot expose either omitted-binding scenario.

The dynamic binding to the account that actually built is fixed, and a single reported condition differing from A5 is caught. But the earlier blocking finding is not completely resolved because `iam_attested=yes` can still overclaim F7.

### Should-fix — machinery remains invisible on the first guarded deploy

Both `--diff` and `--approved` call `show_machinery` only when a verified base already exists: [deploy-functions.sh:698](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:698) and [deploy-functions.sh:780](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:780).

Concrete failure: before the first functions deployment, `BASE` is the empty tree. Christie is told the guard is showing everything that would ship, but none of the backstop, guard, helper, test, or runbook machinery is displayed. This is precisely the upcoming D2-5 first-deploy state. The prior “machinery can be invisible in the approval diff” finding is therefore only partially fixed.

## Confirmed

The `rebuild_helpers_from` approach for `--reconcile` and `--reverify` is sound:

- The attempt’s backstop, discovery helper, and hash module rebuild the state.
- Manifest SHA, tree, function set, and every expected hash must equal the recorded values at [deploy-functions.sh:885](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:885) and [deploy-functions.sh:933](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:933).
- Verdict logic comes from the verified tip.
- Any changed control file, including a helper, still requires `--acknowledge-verifier-change` at [deploy-functions.sh:638](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:638).
- The deviation is explicitly logged in the plan and documented in the rollback guide.

The other earlier findings are fixed or explicitly deferred with reasons: runtime-account closure, `functions:list` diagnostics, generated attestation help, usage text, atomic cleanup, rollback timing, and the pinned `FIREBASE_CONFIG` re-deploy requirement.

I found no new Bash 3.2 syntax, jq quoting, or shell parse regression. `bash -n` and `git diff --check` passed; I relied on the reported green 580-check suite rather than rerunning it.
