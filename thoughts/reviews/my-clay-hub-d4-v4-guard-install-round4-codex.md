## Findings

### Should-fix

1. The functions-guard fixture does not exercise the new `shared` control path.

`shared` is correctly added to `CONTROL_FILES` ([deploy-functions.sh:123](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:123)), so production behavior is correct. However, the fixture creates `tests/` and both function codebases but no `shared/` directory ([deploy-functions.test.sh:203](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:203), [deploy-functions.test.sh:233](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:233)). Consequently, `control_file_diff` compares `missing` with `missing` ([deploy-functions.sh:124](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:124)), and the suite would remain green if `shared` were removed from `CONTROL_FILES`.

Add a fixture `shared/` file and assertions equivalent to the other-codebase source tests: an older approved commit with different `shared/` should refuse with exit 14, and `--diff` should name `shared`.

### Nits

1. The scratch validation rejects—and leaves behind—a valid directory directly under `/`.

Both patterns require another slash between the root slash and basename ([deploy-functions.test.sh:29](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:29), [deploy-rules.test.sh:34](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:34)). Thus `TMPDIR=/` could create `/functions-guard-test.abcdef` successfully, but the case check refuses it before the cleanup trap is installed. This is an unusual configuration and cannot delete an unrelated path, but it is a valid-scratch false refusal plus a temporary-directory leak.

2. The rules-suite safety comment overstates its former hazard.

Unlike the functions harness, the rules harness never canonicalized `T` with `cd "$T"` before this change. A failed `mktemp` left `T` empty, and quoted `rm -rf "$T"` would target an empty operand—not the repository. The new protection is still safe, but [deploy-rules.test.sh:28](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:28) describes behavior that applied only to the functions harness.

## Requested checks

- The dangerous functions-harness failure is resolved: successful creation, directory/non-symlink validation, canonicalization, basename validation, and guarded cleanup are all present ([deploy-functions.test.sh:26](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:26)).
- The rules harness now also fails closed on `mktemp` failure and constrains cleanup ([deploy-rules.test.sh:31](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:31)).
- The trap cannot remove an unrelated ordinary path during normal execution: `T` is assigned only during initialization, is quoted during removal, and must retain the expected absolute basename ([deploy-functions.test.sh:30](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:30), [deploy-rules.test.sh:35](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:35)).
- `shared/` is now tip-pinned by `control_file_diff` and named by `show_machinery` when changed ([deploy-functions.sh:123](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:123), [deploy-functions.sh:135](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:135)).
- Adding `shared` does not break the existing core attempt: `7efa0f0:shared` and `HEAD:shared` resolve to the same tree, `2ae4a8994e37ae8cc413f33ad9cbf503bf62dd06`. Reverify already requires acknowledgement for earlier machinery changes; `shared` introduces no additional mismatch. Missing-on-both-sides fixtures also continue to compare equal.
- Both stale order comments are corrected ([deploy-functions.sh:15](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:15), [deploy-functions.sh:647](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:647)).
- Both weak assertions now check the exact vault npm prefix and therefore prove npm did not run on that folder ([deploy-functions.test.sh:522](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:522), [deploy-functions.test.sh:551](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:551)).

`bash -n` and `git diff --check` passed. I did not run either guard suite because this sandbox cannot create its temporary directory. No files were modified, and no deployment or Google call occurred.

**merge after fixes**
