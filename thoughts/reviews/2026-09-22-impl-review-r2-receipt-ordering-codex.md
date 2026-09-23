codex
Verdict: **approve**. I found no correctness bug in the implementation. The round-one fixes are real and complete. I did find a test assertion that passes for the wrong reason.

### Test bug

- [deploy-rules.test.sh:292](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:292): the assertion claiming the receipt “resolves to the right commit” searches all of `--status` output for `$SHA2`. That SHA always appears on the `origin/main:` line, even if `receipt_commit()` resolves the colliding branch incorrectly. It therefore does not test the advertised behavior. The assertion needs to inspect the `shipped:` line specifically.

A second, less consequential test-label mismatch exists at [deploy-rules.test.sh:314](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:314): counting 181 refs proves cardinality, not contiguity. The subsequent 10-second refusal test exercises the relevant occupied interval, so this does not leave the production behavior materially untested.

Important missing coverage: the new `git rev-parse` operational-error branch at [deploy-rules.sh:365](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:365)–369 has no direct test. The implementation is correct, but the existing `FAIL_GIT` mechanism cannot target that occurrence without also breaking earlier `rev-parse` calls.

### Implementation trace

- The epoch calculation at [deploy-rules.sh:125](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:125) is correct:
  - Gregorian leap-year rule is correct, including century years.
  - Month lengths and zero-based day accumulation are correct.
  - Fixed-width stamps sort lexically in chronological order.
  - Values through year 9999 fit safely in both AWK’s exact integer range and macOS Bash’s integer arithmetic.
- Parsing at [deploy-rules.sh:138](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:138) behaves correctly:
  - No `-`, an empty remainder, or a namespace-only name is skipped.
  - Multiple `-` characters use the first as the stamp separator.
  - `lstrip=2` makes spelling independent of colliding branches.
  - Git refnames cannot contain whitespace, so the three-field AWK parsing is safe.
- `sort -k1,1r -k2,2nr -k3,3r` correctly implements descending stamp, numeric tag epoch, then deterministic refname. Stability is unnecessary because duplicate full refnames cannot exist.
- Failure propagation is intact:
  - `git for-each-ref` is explicitly guarded at line 123.
  - The AWK/sort pipeline is the function’s final command, and `pipefail` propagates failures.
  - The two consumer pipelines read their complete input and return their pipeline status.
  - Successful empty output occurs only for a readable record containing no qualifying receipt.
- The reservation loop terminates after at most ten sleeps plus its final evaluation. `STALE` and `TAKEN` are independently recomputed, and the exact current `TAG` is checked before either breaking or refusing.
- `${STAMP//[TZ]/}` starts with a nonzero year digit, so there is no octal interpretation issue; the resulting 14-digit value fits safely.
- A free stale name proceeds; an occupied name at the cap refuses before Firebase. Operational `rev-parse` failures also refuse.
- The seeded `20260921T220500Z-1da12e3` receipt qualifies because its stamp precedes its `22:54:12Z` tag date. An empty namespace still yields the normal first-deploy path.
- Strictly speaking, `EX_CLOCK=20` is another newly introduced refusal in addition to `EX_RECORD=19`, but it is the intentional pre-release refusal required by the round-one occupied-name fix.

### Bytes invariant

Nothing in this range can change the deployed payload bytes. Receipt discovery reads Git metadata only. Step 7b uses `date`, `git rev-parse`, and `sleep`; it neither enters nor writes `$TMP`. Firebase still runs from the detached approved-commit worktree, and the predeploy hook still verifies that worktree’s file against the approved SHA. The change can delay or refuse a deploy, but cannot select different bytes.

### What I ran

- Read the complete diff and both current files, plus both fix commits and the prior attempt/revert.
- `bash -n scripts/deploy-rules.sh` — passed.
- `bash -n scripts/deploy-rules.test.sh` — passed.
- `git diff --check 1ff50b2..cbb77c5` — passed.
- Attempted `bash scripts/deploy-rules.test.sh`, but this environment is read-only: its initial `mktemp` failed with `Operation not permitted`. The resulting exit was a sandbox failure, not a test result. No Firebase command ran.
tokens used
65,509
Verdict: **approve**. I found no correctness bug in the implementation. The round-one fixes are real and complete. I did find a test assertion that passes for the wrong reason.

### Test bug

- [deploy-rules.test.sh:292](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:292): the assertion claiming the receipt “resolves to the right commit” searches all of `--status` output for `$SHA2`. That SHA always appears on the `origin/main:` line, even if `receipt_commit()` resolves the colliding branch incorrectly. It therefore does not test the advertised behavior. The assertion needs to inspect the `shipped:` line specifically.

A second, less consequential test-label mismatch exists at [deploy-rules.test.sh:314](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:314): counting 181 refs proves cardinality, not contiguity. The subsequent 10-second refusal test exercises the relevant occupied interval, so this does not leave the production behavior materially untested.

Important missing coverage: the new `git rev-parse` operational-error branch at [deploy-rules.sh:365](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:365)–369 has no direct test. The implementation is correct, but the existing `FAIL_GIT` mechanism cannot target that occurrence without also breaking earlier `rev-parse` calls.

### Implementation trace

- The epoch calculation at [deploy-rules.sh:125](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:125) is correct:
  - Gregorian leap-year rule is correct, including century years.
  - Month lengths and zero-based day accumulation are correct.
  - Fixed-width stamps sort lexically in chronological order.
  - Values through year 9999 fit safely in both AWK’s exact integer range and macOS Bash’s integer arithmetic.
- Parsing at [deploy-rules.sh:138](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:138) behaves correctly:
  - No `-`, an empty remainder, or a namespace-only name is skipped.
  - Multiple `-` characters use the first as the stamp separator.
  - `lstrip=2` makes spelling independent of colliding branches.
  - Git refnames cannot contain whitespace, so the three-field AWK parsing is safe.
- `sort -k1,1r -k2,2nr -k3,3r` correctly implements descending stamp, numeric tag epoch, then deterministic refname. Stability is unnecessary because duplicate full refnames cannot exist.
- Failure propagation is intact:
  - `git for-each-ref` is explicitly guarded at line 123.
  - The AWK/sort pipeline is the function’s final command, and `pipefail` propagates failures.
  - The two consumer pipelines read their complete input and return their pipeline status.
  - Successful empty output occurs only for a readable record containing no qualifying receipt.
- The reservation loop terminates after at most ten sleeps plus its final evaluation. `STALE` and `TAKEN` are independently recomputed, and the exact current `TAG` is checked before either breaking or refusing.
- `${STAMP//[TZ]/}` starts with a nonzero year digit, so there is no octal interpretation issue; the resulting 14-digit value fits safely.
- A free stale name proceeds; an occupied name at the cap refuses before Firebase. Operational `rev-parse` failures also refuse.
- The seeded `20260921T220500Z-1da12e3` receipt qualifies because its stamp precedes its `22:54:12Z` tag date. An empty namespace still yields the normal first-deploy path.
- Strictly speaking, `EX_CLOCK=20` is another newly introduced refusal in addition to `EX_RECORD=19`, but it is the intentional pre-release refusal required by the round-one occupied-name fix.

### Bytes invariant

Nothing in this range can change the deployed payload bytes. Receipt discovery reads Git metadata only. Step 7b uses `date`, `git rev-parse`, and `sleep`; it neither enters nor writes `$TMP`. Firebase still runs from the detached approved-commit worktree, and the predeploy hook still verifies that worktree’s file against the approved SHA. The change can delay or refuse a deploy, but cannot select different bytes.

### What I ran

- Read the complete diff and both current files, plus both fix commits and the prior attempt/revert.
- `bash -n scripts/deploy-rules.sh` — passed.
- `bash -n scripts/deploy-rules.test.sh` — passed.
- `git diff --check 1ff50b2..cbb77c5` — passed.
- Attempted `bash scripts/deploy-rules.test.sh`, but this environment is read-only: its initial `mktemp` failed with `Operation not permitted`. The resulting exit was a sandbox failure, not a test result. No Firebase command ran.
