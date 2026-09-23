You are reviewing PLAN v4, before any code has been written. Be adversarial. This plan has now failed TWO rounds of two-model review; v4 is the response to round 2.

## Read these, in this order — all inside the current worktree

1. `.review-tmp/PLAN-v4.txt` — the plan under review.
2. `.review-tmp/v3-review-claude.md` and `.review-tmp/v3-review-codex.md` — the round-2 reviews that forced this rewrite. **A core part of your job: check whether v4 actually FIXES these or merely appears to.**
3. `scripts/deploy-rules.sh` — the current (reverted, still-buggy) script. `latest_receipt()` at line 76 is the defect.
4. `scripts/deploy-rules.test.sh` — the test suite.
5. `git log -1 --format=%B 1ff50b2` — the revert of the first attempt.
6. `git show d43a171` — the reverted first attempt. **Ordering by `--sort=-creatordate` (tag creation date) is PERMANENTLY off the table. Do not re-propose it in any form.**

## Background

`scripts/deploy-rules.sh` is the only sanctioned way to deploy Firestore rules for `tinker-hq-apps` (21 apps, ONE shared rules file, many concurrent AI sessions editing one working tree). Each successful deploy leaves an immutable annotated git tag ("receipt") named `deployed/<project>/<slug>/<UTC yyyymmddTHHMMSSZ>-<sha7>`.

The guard reads "what shipped last" from those receipts and prints a diff from it. Christie — non-technical — reads that diff and approves. A wrong receipt means she approves a diff that doesn't describe the change, or `--status` silently says "nothing to deploy" when there is.

Measured baseline on this branch, before any change: 9 runs of `npm run test:guard` → 3 failed (87/3, 89/1, 89/1).

**This fix failed once in code** (15 green runs, still wrong — the ordering MODEL was wrong) **and twice in plan review.** Both previous rounds found defects only in the DETECTION layer, never in the ordering key itself.

## What v4 changed, and why it is deliberately SMALLER

The repo owner made an explicit scope decision after round 2: keep what four reviewers have endorsed, add only checks that are provably sound, and defer the rest.

- **Dropped entirely: the H2 skew detector.** Round 2 showed (both reviewers, independently) that it is anti-correlated with the harm — it warns on the *faithful* recovery (which orders correctly) and is silent on the *improvised* one (which orders wrongly). It would also have fired permanently, on day one, on the only real receipt.
- **Dropped: H1's refusal and H3/H4's refusal-with-override machinery.** Both reviewers showed H1 deadlocks the only deploy path. These conditions are now REPORTED as facts (F2, F3) and the deploy proceeds.
- **Added R1:** refuse when a tag's `at=` field contradicts its own name stamp. Argued to be unmisfireable because the script writes both from the same variable.
- **Added a new structural rule (rule 3): a future-stamped ref is NOT a receipt.** This is claimed to collapse the three-way clock split, its 10s cap, its override flag, the "bogus tag wins the ordering forever" defect, and impossible-stamp handling into one rule.
- **Phase 2 reworked** per all six round-2 defects (hash computed pre-release, atomic marker via temp+rename, guarded write, idempotent rebuild, new exit code, narrowed claim).

## What I want reviewed — priority order

1. **ATTACK RULE 3 FIRST.** "A future-stamped ref is not a receipt." It is the newest idea in this plan and therefore the likeliest to be wrong — the plan says so itself. Specifically: does excluding future-stamped refs create a NEW way for the guard to name the wrong receipt? What happens when a legitimately-written receipt is momentarily future by 1-2 seconds (clock skew between clones, or NTP adjustment)? Does the writer's monotonicity check still terminate in all cases? Does "valid stamp <= now" hold at every point it is relied on, given `now` is sampled at a different instant than the comparison? Is there a bootstrapping problem?

2. **Did v4 actually fix round 2's blocking findings, or move them?** Go through each round-2 blocking item and verify. Be specific about any that are only cosmetically addressed.

3. **Is R1 really unmisfireable?** The claim is that the script writes the tag name stamp and `at=` from the same shell variable, so a script-written receipt can never trip it. Verify against the actual code at `deploy-rules.sh:249-257`. Can a legitimate receipt ever trip R1? Consider Phase 2's rebuilt receipts and the `recovered=` field.

4. **Is "report, don't refuse" (F2/F3) defensible, or does it reintroduce the original harm?** The original bug is "the guard confidently names the wrong receipt." F2/F3 name the condition and proceed. Is a printed fact sufficient when the consumer is a non-technical operator reading a diff, or did the scope reduction go too far? Answer honestly — do NOT simply re-propose the refusal machinery that was deliberately deferred, but DO say clearly if you believe the deferral is unsafe.

5. **Vacuous assertions.** Three have now been caught (one shipped, two proposed). Go through v4's test battery and find any assertion that would pass while the bug is present. Pay attention to the "strictly increasing stamps with three distinct shas" case and the Phase 2 assertions.

6. **What did I miss?** Especially anything that could affect WHICH BYTES SHIP (it must not), and the one existing real receipt `deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3` (annotated, `by=seeded`, name stamp and `at=` both `20260921T220500Z`, tag date 49m12s later) — which must stay discoverable and must not block the first real deploy.

## Constraints

- Read-only review. Do not edit any file. Do not run `firebase`. Do not deploy.
- macOS: bash 3.2.57 (no associative arrays), git 2.50.1, BSD userland, BWK awk.
- `git for-each-ref` cannot sort on a substring of a refname; patterns containing `*` do not match across `/`.
- The tag NAME format cannot change.
- The guard's deploy path (temp worktree, tests, byte-level predeploy re-check) must not be touched.
- Only `scripts/deploy-rules.sh` and `scripts/deploy-rules.test.sh` may change. `firestore.rules` must NOT.
- The scope reduction is a deliberate decision by the repo owner. Judge v4 on whether it is CORRECT and SAFE at its chosen scope, not on whether it is maximal.

Give a verdict (approve / request changes) and concrete findings with line numbers. Distinguish "this is wrong" from "this is a preference". If you approve, say what you actually verified rather than asserting it.
