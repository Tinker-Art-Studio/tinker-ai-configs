codex
Verdict: request changes. The normal same-second case is improved, but the implementation does not establish a genuinely monotonic deploy order and introduces a fail-open metadata-read path.

## Findings

1. **High — tag creation time is not deploy order.**

   [`latest_receipt()`](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:89) makes `creatordate` the primary key. A documented manual recovery can therefore reorder history:

   1. Deploy A succeeds, but its tag cannot be written.
   2. Deploy B succeeds and gets a normal receipt.
   3. The operator later follows the recovery instruction at [line 304](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:304) and creates A’s older-named receipt.
   4. A now has the newest tagger date, so the guard calls A “what shipped last,” although B shipped later.

   This is not theoretical. The repository’s sole receipt is named `20260921T220500Z-…`, but its tag object was created at `2026-09-21T22:54:12Z`, roughly 49 minutes later. Its message says it was seeded by hand.

   The comparator is deterministic and total as a ref ordering, but it is not monotonic with deployment order. A refname tiebreaker also cannot make equal tag dates chronologically meaningful; it only makes the arbitrary answer repeatable.

   Your concern (a) is correct and matters more than the original same-second flake because it can confidently print the wrong base.

2. **High — both new functions silently swallow `git for-each-ref` failures.**

   At [lines 91–95](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:91) and [102–106](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:102), `git for-each-ref` runs inside the expansion feeding a here-string. Its exit status is not the loop’s or function’s exit status; the final `printf` succeeds.

   Consequently:

   - `latest_receipt` can return empty and report “first guarded deploy.”
   - `newest_stamp` can return empty and skip the ordering protection.
   - `set -euo pipefail` does not catch either failure.

   This violates fail-closed behavior for receipt metadata. Capture the output in a separate assignment that must succeed before entering the loop.

3. **High — the capped path can make `latest_receipt` select the previous receipt.**

   The statement at [line 289](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:289)—“ours is genuinely the later one”—is not guaranteed.

   A direct counterexample is a machine whose clock is behind an existing receipt:

   - Previous receipt: later tagger timestamp and later name stamp.
   - New deploy: waits ten seconds, then creates an earlier name and earlier tagger timestamp.
   - `latest_receipt` continues selecting the previous receipt.

   The same can happen with a future-dated tag object or inherited `GIT_COMMITTER_DATE`.

   The new tag itself accurately records the deployed commit, but the guard’s interpretation of “what shipped last” becomes false. Therefore the escape hatch can misrepresent production through `replaces`, `--status`, and `--diff`.

4. **Medium — the post-deploy wait materially enlarges the unrecorded-deploy window.**

   The wait begins after Firebase succeeds at [line 290](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:290). Until `git tag` succeeds, there is neither a receipt nor a pending marker.

   If the process dies—or `date`/`sleep` fails under `set -e`—during this interval:

   - Production has changed.
   - No receipt records it.
   - No pending marker blocks the next deploy.
   - The next status/diff uses the older production base.

   A small version of this window existed before, but this change deliberately expands it to as much as ten seconds. The monotonic-stamp wait should happen before `firebase deploy`, or successful deployment should immediately create durable recovery state.

5. **Medium — the regression tests cover the happy clock, not the unsafe cases.**

   The new tests are not vacuous:

   - The three-receipt test genuinely exercises the writer’s normal same-second behavior.
   - The forced equal-name-stamp test genuinely distinguishes date ordering from the old refname ordering.
   - The lightweight-tag test genuinely exercises the new filter.

   But the read-side fixture’s `sleep 1` is still dependent on wall-clock tag dates. It can be deterministic without sleeping by assigning explicit, distinct `GIT_COMMITTER_DATE` values.

   More importantly, there are no tests for:

   - delayed manual recovery after a later receipt;
   - a future-dated previous tag object or clock rollback;
   - the capped path;
   - `git for-each-ref` failure;
   - failure/death during the post-deploy wait;
   - equal name stamps and equal tagger seconds, where refname remains arbitrary chronologically.

## Specific shell review

The following pieces are otherwise sound under Bash:

- The `local type ref out=""` declarations do not mask command failures.
- Removing `T` and `Z` produces a 14-digit value that fits a 64-bit integer.
- `[` performs the intended integer comparison for these values.
- The `{ ...; } || git ... || break` construct does not unexpectedly trigger `set -e`; its placement in an OR-list suppresses errexit as intended.
- Empty `PREV_STAMP` correctly falls through to the duplicate-tag check.

The critical shell defect is specifically the lost exit status inside both here-string command substitutions.

## Annotated-only filtering

Your concern (b) is valid as a compatibility change, but lower severity than (a):

- The one known real receipt is annotated, so current repository history remains discoverable.
- The documented contract says receipts are annotated, so excluding lightweight namespace debris is defensible.
- It nevertheless changes existing behavior and should be treated as an explicit format rule, not merely part of an ordering fix.
- `newest_stamp` currently still counts lightweight tags, while `latest_receipt` ignores them. A future-named lightweight tag can therefore force every real deploy through the ten-second cap even though status says it is not a receipt. Both functions should use the same receipt predicate.

## Recommended ordering model

Use the encoded receipt stamp as the primary order, because it represents deployment time; use tagger date only to resolve legacy same-stamp receipts, then refname for deterministic final ordering:

```text
(name stamp, tagger date, refname)
```

Alternatively, refuse on ambiguous legacy same-stamp receipts instead of guessing.

Then:

- select/wait for a strictly greater stamp before deploying;
- count the same class of tags in both reader and writer;
- propagate all ref-read failures;
- test recovery, future-clock, cap, and metadata-read failures explicitly.

The approved-commit worktree and predeploy byte check were not changed, so I found no new path that causes Firebase to receive bytes other than the approved commit. The regression is in whether the printed approval diff accurately describes what production currently replaces.

I could not validate repeated green runs in this read-only environment: `npm run test:guard` was attempted but stopped at `mktemp` with `Operation not permitted`. Both scripts pass `bash -n`, and `git diff --check` passes.
tokens used
48,442
Verdict: request changes. The normal same-second case is improved, but the implementation does not establish a genuinely monotonic deploy order and introduces a fail-open metadata-read path.

## Findings

1. **High — tag creation time is not deploy order.**

   [`latest_receipt()`](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:89) makes `creatordate` the primary key. A documented manual recovery can therefore reorder history:

   1. Deploy A succeeds, but its tag cannot be written.
   2. Deploy B succeeds and gets a normal receipt.
   3. The operator later follows the recovery instruction at [line 304](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:304) and creates A’s older-named receipt.
   4. A now has the newest tagger date, so the guard calls A “what shipped last,” although B shipped later.

   This is not theoretical. The repository’s sole receipt is named `20260921T220500Z-…`, but its tag object was created at `2026-09-21T22:54:12Z`, roughly 49 minutes later. Its message says it was seeded by hand.

   The comparator is deterministic and total as a ref ordering, but it is not monotonic with deployment order. A refname tiebreaker also cannot make equal tag dates chronologically meaningful; it only makes the arbitrary answer repeatable.

   Your concern (a) is correct and matters more than the original same-second flake because it can confidently print the wrong base.

2. **High — both new functions silently swallow `git for-each-ref` failures.**

   At [lines 91–95](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:91) and [102–106](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:102), `git for-each-ref` runs inside the expansion feeding a here-string. Its exit status is not the loop’s or function’s exit status; the final `printf` succeeds.

   Consequently:

   - `latest_receipt` can return empty and report “first guarded deploy.”
   - `newest_stamp` can return empty and skip the ordering protection.
   - `set -euo pipefail` does not catch either failure.

   This violates fail-closed behavior for receipt metadata. Capture the output in a separate assignment that must succeed before entering the loop.

3. **High — the capped path can make `latest_receipt` select the previous receipt.**

   The statement at [line 289](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:289)—“ours is genuinely the later one”—is not guaranteed.

   A direct counterexample is a machine whose clock is behind an existing receipt:

   - Previous receipt: later tagger timestamp and later name stamp.
   - New deploy: waits ten seconds, then creates an earlier name and earlier tagger timestamp.
   - `latest_receipt` continues selecting the previous receipt.

   The same can happen with a future-dated tag object or inherited `GIT_COMMITTER_DATE`.

   The new tag itself accurately records the deployed commit, but the guard’s interpretation of “what shipped last” becomes false. Therefore the escape hatch can misrepresent production through `replaces`, `--status`, and `--diff`.

4. **Medium — the post-deploy wait materially enlarges the unrecorded-deploy window.**

   The wait begins after Firebase succeeds at [line 290](/Users/christiehubley/studio-hub/scripts/deploy-rules.sh:290). Until `git tag` succeeds, there is neither a receipt nor a pending marker.

   If the process dies—or `date`/`sleep` fails under `set -e`—during this interval:

   - Production has changed.
   - No receipt records it.
   - No pending marker blocks the next deploy.
   - The next status/diff uses the older production base.

   A small version of this window existed before, but this change deliberately expands it to as much as ten seconds. The monotonic-stamp wait should happen before `firebase deploy`, or successful deployment should immediately create durable recovery state.

5. **Medium — the regression tests cover the happy clock, not the unsafe cases.**

   The new tests are not vacuous:

   - The three-receipt test genuinely exercises the writer’s normal same-second behavior.
   - The forced equal-name-stamp test genuinely distinguishes date ordering from the old refname ordering.
   - The lightweight-tag test genuinely exercises the new filter.

   But the read-side fixture’s `sleep 1` is still dependent on wall-clock tag dates. It can be deterministic without sleeping by assigning explicit, distinct `GIT_COMMITTER_DATE` values.

   More importantly, there are no tests for:

   - delayed manual recovery after a later receipt;
   - a future-dated previous tag object or clock rollback;
   - the capped path;
   - `git for-each-ref` failure;
   - failure/death during the post-deploy wait;
   - equal name stamps and equal tagger seconds, where refname remains arbitrary chronologically.

## Specific shell review

The following pieces are otherwise sound under Bash:

- The `local type ref out=""` declarations do not mask command failures.
- Removing `T` and `Z` produces a 14-digit value that fits a 64-bit integer.
- `[` performs the intended integer comparison for these values.
- The `{ ...; } || git ... || break` construct does not unexpectedly trigger `set -e`; its placement in an OR-list suppresses errexit as intended.
- Empty `PREV_STAMP` correctly falls through to the duplicate-tag check.

The critical shell defect is specifically the lost exit status inside both here-string command substitutions.

## Annotated-only filtering

Your concern (b) is valid as a compatibility change, but lower severity than (a):

- The one known real receipt is annotated, so current repository history remains discoverable.
- The documented contract says receipts are annotated, so excluding lightweight namespace debris is defensible.
- It nevertheless changes existing behavior and should be treated as an explicit format rule, not merely part of an ordering fix.
- `newest_stamp` currently still counts lightweight tags, while `latest_receipt` ignores them. A future-named lightweight tag can therefore force every real deploy through the ten-second cap even though status says it is not a receipt. Both functions should use the same receipt predicate.

## Recommended ordering model

Use the encoded receipt stamp as the primary order, because it represents deployment time; use tagger date only to resolve legacy same-stamp receipts, then refname for deterministic final ordering:

```text
(name stamp, tagger date, refname)
```

Alternatively, refuse on ambiguous legacy same-stamp receipts instead of guessing.

Then:

- select/wait for a strictly greater stamp before deploying;
- count the same class of tags in both reader and writer;
- propagate all ref-read failures;
- test recovery, future-clock, cap, and metadata-read failures explicitly.

The approved-commit worktree and predeploy byte check were not changed, so I found no new path that causes Firebase to receive bytes other than the approved commit. The regression is in whether the printed approval diff accurately describes what production currently replaces.

I could not validate repeated green runs in this read-only environment: `npm run test:guard` was attempted but stopped at `mktemp` with `Operation not permitted`. Both scripts pass `bash -n`, and `git diff --check` passes.
