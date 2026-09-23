You are reviewing a PLAN DOCUMENT, before any code has been written. Be adversarial. Say "request changes" if the model is wrong.

## Plan under review

/Users/christiehubley/tinker-ai-configs/thoughts/plans/deploy-guard-receipt-ordering.html

Read it in full. Also read, in this order:

1. `git -C /Users/christiehubley/studio-hub log -1 --format=%B 1ff50b2` — the revert of the FIRST attempt at this
   fix. Its message carries the agreed fix list from two independent reviews.
2. `git -C /Users/christiehubley/studio-hub show d43a171` — the reverted first attempt itself. Its approach
   (ordering receipts by `--sort=-creatordate`, the tag object's creation date) is OFF THE TABLE and must not be
   re-proposed.
3. `/Users/christiehubley/studio-hub/scripts/deploy-rules.sh` — the current (reverted, still-buggy) script.
   `latest_receipt()` at line 76 is the defect.
4. `/Users/christiehubley/studio-hub/scripts/deploy-rules.test.sh` — the test suite.
5. `~/tinker-ai-configs/thoughts/reviews/2026-09-22-deploy-guard-receipt-ordering-claude.md` and
   `...-codex.md` — the two reviews that caused the revert.

## Background

`scripts/deploy-rules.sh` is the only sanctioned way to deploy Firestore rules for the shared Firebase project
`tinker-hq-apps` (21 apps, ONE rules file, many concurrent AI sessions editing one working tree). Every successful
deploy leaves an immutable annotated git tag ("receipt") named
`deployed/<project>/<slug>/<UTC yyyymmddTHHMMSSZ>-<sha7>`.

The guard reads "what shipped last" from those receipts and prints a diff from it to the commit being deployed.
A human (Christie, non-technical) reads that diff and approves it. **If the guard picks the wrong receipt, she
approves a diff that does not describe the change — in the worst case an empty diff.**

The bug: the stamp in the name has only SECOND resolution, so two deploys in one second tie, and the current
`--sort=-refname` breaks the tie on the trailing sha7, which is arbitrary.

**Critical context:** the first attempt at this fix passed 15 consecutive green test runs and a full `npm test`,
and was STILL WRONG — because the defect was in the ORDERING MODEL (it keyed on tag creation date, which is not
deploy time in this repo: the one real receipt was hand-written 49 minutes after the deploy it records, and the
script's own error path *instructs* operators to hand-write receipts). Tests cannot catch a wrong model. That is
why this is a plan review and not a code review.

## What I want reviewed — in priority order

1. **Is the ordering model correct?** The plan proposes: a receipt is an ANNOTATED tag under the target's
   namespace whose name carries a well-formed `yyyymmddTHHMMSSZ` stamp; order by (name stamp, tag date, refname),
   all descending. Attack this. Under what realistic sequence of events does it name the wrong receipt as "what
   shipped last"? Is the name stamp really the best available proxy for deploy time? Is using tag date ONLY as a
   same-stamp tiebreaker sound, or does it smuggle the reverted approach back in through the side door?

2. **The ambiguity warning.** The reader computes the winner twice — by (stamp, date, refname) and by
   (date, stamp, refname) — and warns when they differ. I claim this is "self-clearing": it fires only while the
   disagreement is at the TOP of the record, and the next ordinary deploy writes a receipt that is newest under
   both keys, so it stops. Is that claim actually true? Can you construct a record where it warns forever, or
   where it FAILS to warn on a genuinely ambiguous record? Is a two-way comparison even the right detector, or
   should it compare more than the argmax (e.g. the whole order)?

3. **Q1, the decision I least trust (it's in the plan's "Open questions").** The write side reserves a strictly
   newer stamp BEFORE the release (so no window is opened between "production changed" and "receipt written").
   If the clock can't produce a newer stamp within a 10s cap, the plan says REFUSE — arguing this is now free
   because nothing has shipped yet. Is refusing right, or does it hand an operator a guard that blocks an
   emergency rules rollback because of a stray tag? What would you do?

4. **Does the phase split leave a bad intermediate state?** Phase 1 is the reader, Phase 2 the writer. The plan
   admits the same-second flake is only *reduced* after Phase 1. Is shipping Phase 1 alone safe?

5. **The test strategy.** The previous attempt shipped a VACUOUS assertion ("name order and date order agree") that
   passed while the bug was present, because under the old writer all tags share a second, both sorts degenerate
   to refname, and the two commands returned identical output. Are the replacement assertions in this plan
   ("three distinct seconds", "a fourth deploy's `replaces:` line names the third deploy's receipt") free of that
   defect? What else could pass while the bug is present?

6. **What did I miss?** Especially: any way this change could affect WHICH BYTES SHIP (it must not — it should only
   affect the record and the printed diff), and any interaction with the existing real receipt
   `deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3`, which must stay discoverable.

## Constraints

- Read-only review. Do not edit any file, do not run any deploy, do not run `firebase` at all.
- macOS: bash 3.2.57 (no associative arrays, no `${var,,}`), git 2.50.1, BSD userland, BWK awk.
- `git for-each-ref` cannot sort on a substring of a refname; patterns with `*` do not match across `/`.
- The tag NAME format cannot change — the existing real receipt must stay discoverable.
- The guard's deploy path (temp worktree, tests, byte-level predeploy re-check) must not be touched.
- Only `scripts/deploy-rules.sh` and `scripts/deploy-rules.test.sh` may change. `firestore.rules` must NOT.

Give a verdict (approve / request changes) and concrete, specific findings. Quote line numbers. If you think the
ordering model is wrong, say what the right one is and why.
