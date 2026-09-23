You are re-reviewing a PLAN DOCUMENT (v3), before any code has been written. Be adversarial. Say "request changes" if the model is wrong. This plan's previous version was reviewed by two models and BOTH said request changes; v2/v3 are the response.

## Read these, in this order — all inside the current worktree

1. `.review-tmp/PLAN-v3.txt` — the plan under review (HTML stripped to text).
2. `.review-tmp/v2-review-claude.md` and `.review-tmp/v2-review-codex.md` — the two reviews of v1 that forced this rewrite. **Your job includes checking whether v3 actually ADDRESSES these, or merely appears to.**
3. `scripts/deploy-rules.sh` — the current (reverted, still-buggy) script. `latest_receipt()` at line 76 is the defect being fixed.
4. `scripts/deploy-rules.test.sh` — the test suite.
5. `git log -1 --format=%B 1ff50b2` — the revert of the FIRST attempt; its message carries the originally-agreed fix list.
6. `git show d43a171` — the reverted first attempt. **Its approach (ordering by `--sort=-creatordate`, the tag object's creation date) is PERMANENTLY off the table. Do not re-propose it in any form.**

## Background

`scripts/deploy-rules.sh` is the only sanctioned way to deploy Firestore rules for `tinker-hq-apps` (21 apps, ONE shared rules file, many concurrent AI sessions editing one working tree). Every successful deploy leaves an immutable annotated git tag ("receipt") named `deployed/<project>/<slug>/<UTC yyyymmddTHHMMSSZ>-<sha7>`.

The guard reads "what shipped last" from those receipts and prints a diff from it. Christie — non-technical — reads that diff and approves it. If the guard picks the wrong receipt she approves a diff that does not describe the change, or (worse, and silently) `--status` says "nothing to deploy" and she walks away from a change that never shipped.

**This fix has already failed once.** The first attempt passed 15 consecutive green test runs plus a full `npm test` and was still wrong, because the defect was in the ORDERING MODEL, not the shell. Tests cannot catch a wrong model.

Measured baseline on this branch, before any change: 9 runs of `npm run test:guard` → 3 failed (87/3, 89/1, 89/1).

## What v2/v3 changed in response to the last review — verify each actually holds

- The "two argmax comparison" ambiguity detector was **replaced** by four explicit record-health checks (H1–H4). I reproduced all three of the counterexamples the reviewers gave against the old detector.
- The "self-clearing warning" claim was **withdrawn as false** (verified: a future *tag date* makes it warn forever).
- The phase split (reader alone, then writer) was **abandoned** — they land atomically.
- The 10s cap became a **three-way split by the size of the gap**, plus a `--accept-out-of-order-receipt` override, because one far-future tag would otherwise brick the only deploy path for all 21 apps.
- A proposed assertion ("a 4th deploy's `replaces:` names the 3rd receipt") was **dropped** — it passes while the bug is present, because the existing dedup loop at `deploy-rules.sh:253` already sleeps when tag names collide.
- v3 adds **Phase 2**: the pre-existing bug where a failed `git tag -a` writes no marker at all.

## What I want reviewed — priority order

1. **Do H1–H4 actually cover what the old detector missed, or did I just move the blind spot?** Attack each. Construct a record where the guard still confidently names the wrong receipt and NO finding fires. Specifically: is H2's "stamp-to-tag-date skew" threshold of 10 minutes defensible, and what happens when a legitimate release takes longer? Is H1 (refuse on a same-stamp collision) too aggressive — can you construct a realistic record that refuses forever with no way forward?

2. **Is the ordering key still right?** (name stamp, tag date, refname), descending — where tag date is consulted ONLY within an exact stamp tie. Both previous reviewers endorsed this. Does v3's demotion of the tag-date tiebreak to "a deterministic guess, not evidence" (and H1 refusing instead of silently using it) make it coherent, or is there now an inconsistency between using it to order and refusing to trust it?

3. **Phase 2's design — this is the newest and least-reviewed material.** On a failed `git tag -a` after a successful deploy, the plan writes a marker recording sha/stamp/target/sha256, and the NEXT run rebuilds the receipt *with its original stamp* and publishes it. Is faithful auto-recovery right, or should it refuse and make a human do it? Is a second marker file (rather than overloading `$PENDING`'s format) the right call? Is there a failure mode where auto-recovery fabricates a receipt for a deploy that did not actually change production?

4. **The write side's "check early, reserve late".** Feasibility checked right after step 3 (~line 200); the actual stamp taken immediately before step 8; the tag written after step 8. Does that genuinely avoid widening the window between "production changed" and "a receipt exists"? Is there anything new that can fail between line 243 and line 260?

5. **Test strategy.** The previous attempt shipped a VACUOUS assertion, and v1 of this plan proposed a second one. Go through v3's planned assertions and find any that would pass while the bug is present. Pay particular attention to the fake-`date`/fake-`sleep` controlled clock and to whether "stamps strictly increasing" can be satisfied by the OLD writer.

6. **What did I miss?** Especially: any way this affects WHICH BYTES SHIP (it must not), and any interaction with the one existing real receipt `deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3` (annotated, `by=seeded`, name stamp 49 minutes before its tag date), which must stay discoverable.

## Constraints

- Read-only review. Do not edit any file. Do not run `firebase` at all. Do not deploy.
- macOS: bash 3.2.57 (no associative arrays), git 2.50.1, BSD userland, BWK awk.
- `git for-each-ref` cannot sort on a substring of a refname; patterns containing `*` do not match across `/`.
- The tag NAME format cannot change.
- The guard's deploy path (temp worktree, tests, byte-level predeploy re-check) must not be touched.
- Only `scripts/deploy-rules.sh` and `scripts/deploy-rules.test.sh` may change. `firestore.rules` must NOT.

Give a verdict (approve / request changes) and concrete findings with line numbers. Distinguish clearly between "this is wrong" and "this is a preference". If you approve, say what you verified rather than just asserting it.
