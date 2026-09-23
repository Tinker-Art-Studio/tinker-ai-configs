codex
Verdict: request changes.

## Bugs

1. `%(refname:short)` can make a valid receipt disappear

At [deploy-rules.sh:119](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:119), `git for-each-ref` emits `%(refname:short)`, but [line 134](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:134) assumes that value begins exactly with `$TAG_PREFIX`.

Short refnames are ambiguity-dependent. If another ref—such as:

```text
refs/heads/deployed/tinker-hq-apps/firestore-rules/20260922T120000Z-abcdef0
```

—collides with the tag name, Git may render the tag as:

```text
tags/deployed/tinker-hq-apps/firestore-rules/20260922T120000Z-abcdef0
```

Then:

```awk
rest=substr(name, length(p)+1)
```

starts at the wrong position, and the real annotated receipt is silently skipped. The reader can consequently report an older receipt or “no receipt yet.”

This is worse than the old reader: the old `latest_receipt()` returned the ambiguity-qualified short name, which Git could still resolve; the new parser rejects it.

I confirmed that the colliding branch ref is a valid Git ref using `git check-ref-format`. The parser should consume a namespace-relative or full refname whose spelling does not depend on unrelated refs, such as `%(refname:lstrip=2)` or full `%(refname)` with explicit prefix removal.

2. The reservation cap can knowingly proceed with an already-taken tag name

At [deploy-rules.sh:354](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:354), `STALE` and `TAKEN` are correctly evaluated independently. But [lines 358–364](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:358) break at the cap regardless of which condition remains true.

Therefore, when `TAKEN=1` at ten seconds—frozen/backward clock, an exact lightweight-tag collision, or another persistent collision—the script:

1. Warns and breaks.
2. Deploys successfully.
3. Runs `git tag -a "$TAG"` with a name already known to exist.
4. Exits 17 after production changed and no receipt for this deploy was written.

The warning is also inaccurate in that case: it says the new tag “will sort BELOW” another receipt, even though the new tag cannot be created at all.

Proceeding at the cap is coherent for `STALE` alone. It is not safe for `TAKEN`; that condition needs a distinct pre-deploy outcome.

Also, [line 356](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:356) treats every nonzero `git rev-parse` result as “not taken,” including operational Git failures. That can produce the same post-deploy tag failure.

## Reader and arithmetic trace

Apart from the ambiguity bug, the `awk` arithmetic is correct:

- Gregorian leap-year rule is correct, including century and 400-year cases.
- Month lengths and preceding-month accumulation are correct.
- Day, hour, minute, and second bounds are correct.
- The fixed-width UTC spelling sorts chronologically under `LC_ALL=C`.
- Epoch values through four-digit years are safely within exact integer representation in awk’s usual double numeric model.
- A name with no `-` is skipped.
- A name with multiple `-` uses the first one, correctly isolating the stamp.
- A ref equal to the prefix is impossible because Git rejects refs ending in `/`; I confirmed that with `git check-ref-format`.
- `sort -k1,1r -k2,2nr -k3,3r` implements the documented descending tuple. Stability is irrelevant because the complete refname is unique.

The suffix is otherwise unconstrained, including nested or multiple-hyphen suffixes. That matches the stated predicate—“name carries a real UTC date-time”—rather than the narrower documented receipt naming convention.

## Failure propagation

The intended record-read failure propagation works:

- [Line 119](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:119) preserves `git for-each-ref` failure with a separately declared local and `|| return 1`.
- The `printf | awk | sort` pipeline is the function’s final command, and `pipefail` preserves failures from any stage.
- [Lines 147 and 152](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:147) propagate `receipt_rows` failure.
- Their final `printf | awk` pipelines also inherit `pipefail`; the awk programs consume all input rather than exiting early.
- The three decision call sites correctly convert failure to exit 19 at [lines 202, 314, and 349](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:202).

A successful empty result is legitimate only when no row satisfies the predicate. The refname ambiguity bug is the case where that successful empty result is incorrect.

## Step 7b

- The loop is count-capped and therefore terminates even if wall time stops advancing.
- Stale and taken are genuinely evaluated independently.
- `sleep` or `date` failure exits before Firebase under `set -e`; it does not silently deploy.
- Bash 3.2’s `[` integer comparison treats these operands safely; I directly checked values containing `08` and `09`. The four-digit valid year also prevents a leading-zero number.
- The cap’s handling of `TAKEN`, described above, is the unsafe fall-through.

## Tests

I found more than a third weak assertion:

- [deploy-rules.test.sh:183](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:183) claims to prove the last deploy diffed from the immediately preceding receipt, but only checks that `replaces:` exists. Every non-first deploy prints that label, including one using the wrong receipt. It passes for the wrong reason.
- [Line 181](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:181) is still timing-dependent against the old writer. Three independently fast deploys usually share seconds, but can naturally cross two second boundaries and produce strictly increasing stamps without the fix.
- [Line 274](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:274) passes against the immediate pre-change implementation because errexit stops on the failed assignment before Firebase, even though it does not produce exit 19. The preceding exit-code assertion catches the overall regression, but this individual assertion does not establish the new propagation mechanism.

Important missing coverage:

- Short-ref ambiguity caused by a same-named branch or other ref.
- The ten-second cap with `TAKEN=1`.
- A failing `git rev-parse` during reservation.
- Cap behavior distinguishing `STALE`-only from `TAKEN`.
- No-hyphen and multiple-hyphen namespace entries, despite those shapes being explicitly important to the parser review.

## Real receipt, first deploy, and bytes

The seeded receipt `20260921T220500Z-1da12e3` passes the calendar predicate, and its name epoch is before its `2026-09-21T22:54:12Z` tag date. With no ambiguity-inducing ref, it remains the selected receipt. A first deploy with no receipt produces an empty row set normally and proceeds.

Nothing in this commit changes the bytes supplied to Firebase. The Firebase invocation remains in the immutable worktree at [lines 370–373](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:370), checked out from the approved SHA. Step 7b only reads the main repository’s refs, obtains time, and sleeps; it neither touches `$TMP` nor changes the Firebase command. The reservation bug affects whether the deploy is recorded, not which bytes ship.

I attempted `bash scripts/deploy-rules.test.sh`, but the review environment is filesystem-read-only and `mktemp` was denied, so the suite could not construct its throwaway repository. I did not run Firebase. My conclusions come from tracing both committed files and commits `1ff50b2`/`d43a171`, plus read-only Git/ref-format and Bash 3.2 numeric probes.
tokens used
57,098
Verdict: request changes.

## Bugs

1. `%(refname:short)` can make a valid receipt disappear

At [deploy-rules.sh:119](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:119), `git for-each-ref` emits `%(refname:short)`, but [line 134](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:134) assumes that value begins exactly with `$TAG_PREFIX`.

Short refnames are ambiguity-dependent. If another ref—such as:

```text
refs/heads/deployed/tinker-hq-apps/firestore-rules/20260922T120000Z-abcdef0
```

—collides with the tag name, Git may render the tag as:

```text
tags/deployed/tinker-hq-apps/firestore-rules/20260922T120000Z-abcdef0
```

Then:

```awk
rest=substr(name, length(p)+1)
```

starts at the wrong position, and the real annotated receipt is silently skipped. The reader can consequently report an older receipt or “no receipt yet.”

This is worse than the old reader: the old `latest_receipt()` returned the ambiguity-qualified short name, which Git could still resolve; the new parser rejects it.

I confirmed that the colliding branch ref is a valid Git ref using `git check-ref-format`. The parser should consume a namespace-relative or full refname whose spelling does not depend on unrelated refs, such as `%(refname:lstrip=2)` or full `%(refname)` with explicit prefix removal.

2. The reservation cap can knowingly proceed with an already-taken tag name

At [deploy-rules.sh:354](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:354), `STALE` and `TAKEN` are correctly evaluated independently. But [lines 358–364](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:358) break at the cap regardless of which condition remains true.

Therefore, when `TAKEN=1` at ten seconds—frozen/backward clock, an exact lightweight-tag collision, or another persistent collision—the script:

1. Warns and breaks.
2. Deploys successfully.
3. Runs `git tag -a "$TAG"` with a name already known to exist.
4. Exits 17 after production changed and no receipt for this deploy was written.

The warning is also inaccurate in that case: it says the new tag “will sort BELOW” another receipt, even though the new tag cannot be created at all.

Proceeding at the cap is coherent for `STALE` alone. It is not safe for `TAKEN`; that condition needs a distinct pre-deploy outcome.

Also, [line 356](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:356) treats every nonzero `git rev-parse` result as “not taken,” including operational Git failures. That can produce the same post-deploy tag failure.

## Reader and arithmetic trace

Apart from the ambiguity bug, the `awk` arithmetic is correct:

- Gregorian leap-year rule is correct, including century and 400-year cases.
- Month lengths and preceding-month accumulation are correct.
- Day, hour, minute, and second bounds are correct.
- The fixed-width UTC spelling sorts chronologically under `LC_ALL=C`.
- Epoch values through four-digit years are safely within exact integer representation in awk’s usual double numeric model.
- A name with no `-` is skipped.
- A name with multiple `-` uses the first one, correctly isolating the stamp.
- A ref equal to the prefix is impossible because Git rejects refs ending in `/`; I confirmed that with `git check-ref-format`.
- `sort -k1,1r -k2,2nr -k3,3r` implements the documented descending tuple. Stability is irrelevant because the complete refname is unique.

The suffix is otherwise unconstrained, including nested or multiple-hyphen suffixes. That matches the stated predicate—“name carries a real UTC date-time”—rather than the narrower documented receipt naming convention.

## Failure propagation

The intended record-read failure propagation works:

- [Line 119](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:119) preserves `git for-each-ref` failure with a separately declared local and `|| return 1`.
- The `printf | awk | sort` pipeline is the function’s final command, and `pipefail` preserves failures from any stage.
- [Lines 147 and 152](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:147) propagate `receipt_rows` failure.
- Their final `printf | awk` pipelines also inherit `pipefail`; the awk programs consume all input rather than exiting early.
- The three decision call sites correctly convert failure to exit 19 at [lines 202, 314, and 349](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:202).

A successful empty result is legitimate only when no row satisfies the predicate. The refname ambiguity bug is the case where that successful empty result is incorrect.

## Step 7b

- The loop is count-capped and therefore terminates even if wall time stops advancing.
- Stale and taken are genuinely evaluated independently.
- `sleep` or `date` failure exits before Firebase under `set -e`; it does not silently deploy.
- Bash 3.2’s `[` integer comparison treats these operands safely; I directly checked values containing `08` and `09`. The four-digit valid year also prevents a leading-zero number.
- The cap’s handling of `TAKEN`, described above, is the unsafe fall-through.

## Tests

I found more than a third weak assertion:

- [deploy-rules.test.sh:183](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:183) claims to prove the last deploy diffed from the immediately preceding receipt, but only checks that `replaces:` exists. Every non-first deploy prints that label, including one using the wrong receipt. It passes for the wrong reason.
- [Line 181](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:181) is still timing-dependent against the old writer. Three independently fast deploys usually share seconds, but can naturally cross two second boundaries and produce strictly increasing stamps without the fix.
- [Line 274](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.test.sh:274) passes against the immediate pre-change implementation because errexit stops on the failed assignment before Firebase, even though it does not produce exit 19. The preceding exit-code assertion catches the overall regression, but this individual assertion does not establish the new propagation mechanism.

Important missing coverage:

- Short-ref ambiguity caused by a same-named branch or other ref.
- The ten-second cap with `TAKEN=1`.
- A failing `git rev-parse` during reservation.
- Cap behavior distinguishing `STALE`-only from `TAKEN`.
- No-hyphen and multiple-hyphen namespace entries, despite those shapes being explicitly important to the parser review.

## Real receipt, first deploy, and bytes

The seeded receipt `20260921T220500Z-1da12e3` passes the calendar predicate, and its name epoch is before its `2026-09-21T22:54:12Z` tag date. With no ambiguity-inducing ref, it remains the selected receipt. A first deploy with no receipt produces an empty row set normally and proceeds.

Nothing in this commit changes the bytes supplied to Firebase. The Firebase invocation remains in the immutable worktree at [lines 370–373](/Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:370), checked out from the approved SHA. Step 7b only reads the main repository’s refs, obtains time, and sleeps; it neither touches `$TMP` nor changes the Firebase command. The reservation bug affects whether the deploy is recorded, not which bytes ship.

I attempted `bash scripts/deploy-rules.test.sh`, but the review environment is filesystem-read-only and `mktemp` was denied, so the suite could not construct its throwaway repository. I did not run Firebase. My conclusions come from tracing both committed files and commits `1ff50b2`/`d43a171`, plus read-only Git/ref-format and Bash 3.2 numeric probes.
