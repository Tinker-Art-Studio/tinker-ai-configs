Verdict: **merge after fixes**.

### Blocking

- [scripts/deploy-functions.sh:156](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:156) and [scripts/predeploy-check.sh:224](/Users/christiehubley/my-clay-hub/scripts/predeploy-check.sh:224) normalize the three-key legacy declaration unconditionally. Consequently, a newly approved post-D-4 commit can omit `trigger` and still deploy as HTTPS, contrary to V3’s exact declaration schema. The added test at [scripts/deploy-functions.test.sh:1063](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:1063) actually codifies that weakening because it creates the “legacy” declaration with the current guard. Limit normalization to genuinely pre-D-4 attempts.

### Should-fix

- [scripts/deploy-functions.sh:1196](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:1196): the per-key fallback uses `record_field … || true`, so a repeated/corrupt field in the newest verify record is indistinguishable from an absent/`unknown` value and can silently fall back to the attempt. Preserve fallback for a unique unusable value, but fail closed on malformed/repeated record fields.

- [scripts/deploy-functions.sh:409](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:409): the header rule accepts multiple case variants simultaneously, such as both `User-Agent` and `user-agent`. Enforce either `{}` or exactly one case-insensitive `User-Agent` entry with the expected value.

- [tests/functions/schedule-probe.test.js:17](/Users/christiehubley/my-clay-hub/tests/functions/schedule-probe.test.js:17): Claude round-1 finding #6 remains unfixed. `wire()` still reconstructs discovery output manually rather than exercising `scripts/functions-discover.mjs`.

### Nits

None new.

### Round-1 closure

- Codex findings: receipt format/cutover, deployed-job construction, clear→reverify→attest, backstop declaration checks, runbook wording, and fixture whitespace are fixed.
- Claude findings: headers’ normal case, attest-format documentation, deployed-list documentation, codebase enumeration failure handling, per-codebase installation docs, unused/vacuous tests, and OIDC documentation are fixed.
- Claude’s legacy-declaration finding is only partly fixed and introduced the blocking regression above.
- Claude’s real-discovery coverage finding is not fixed.
- The deployed-job list now correctly uses this codebase’s attempt plus each other current codebase’s newest attempt; undeployed codebases contribute nothing.

I could not independently reproduce the reported suite totals because this review environment denies the temporary directories and Git writes the test fixtures require. `bash -n`, `git diff --check`, and the final worktree cleanliness check passed; no repository files changed.
