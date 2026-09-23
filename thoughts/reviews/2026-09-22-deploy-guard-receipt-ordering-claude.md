## Verdict

The bug is real, the diagnosis is right, and the write-side half is the load-bearing fix. But the read-side half keys the record on a property the write side doesn't guarantee — and the one receipt in your repo today already violates it. Your suspicion (a) is correct and matters more than you framed it. There's also one shell change that flipped a fail-closed path to fail-open.

First, what I verified rather than assumed:

- `--sort=-refname --sort=-creatordate` → **creatordate is primary**, refname the tiebreaker. The comment is accurate. Reversing the pair makes refname primary (confirmed both directions on your real tags).
- A lightweight tag really does report the pointed-to commit's date as `creatordate` (`rules-2026-08-12`: `objecttype=commit`, date = the commit's). The rationale for the annotated filter is factually right.
- AC#2 holds: the existing receipt is annotated and still found. The script's pattern (`refs/tags/<prefix>` with a trailing slash) matches on the slash boundary — a sibling prefix like `firestore-rule` matches nothing. Name format untouched.
- **AC#4 holds, cleanly.** Nothing in this diff touches steps 5–8. The worktree, the byte-level predeploy re-check and the control-file pinning are unchanged. This change can only affect the *record* and the printed diff, never which bytes ship. Worth stating plainly before the rest.
- **AC#5 I could not check.** `npm run test:guard` and plain `bash` are both denied in this non-interactive session. Everything below about the tests is read, not run.

---

## 1. The guard can still name the wrong receipt — and your suspicion (a) is the live case

`deploy-rules.sh:87` claims: *"Step 9 keeps every new receipt strictly newer than the last in BOTH keys, so name order and date order cannot disagree."*

That is false as stated. Step 9's guarantee is on **names** — `newest_stamp` (`:100`) compares name stamps and nothing else. The read side sorts on **tag dates**. The two keys are only linked when a receipt's tag date is its deploy time. Your one receipt breaks that by 49 minutes:

```
name=…/20260921T220500Z-1da12e3      → stamp says 22:05:00Z
creatordate=2026-09-21T16:54:12-06:00 → tag written 22:54:12Z
contents: … at=20260921T220500Z by=seeded — this receipt was written by hand …
```

So the class isn't just "someone hand-writes a receipt after a later deploy." It includes **seeding**, which this repo has already done once and documents in the tag body. Any future seeded or reconstructed receipt lands the two orderings in conflict, and date-primary resolves it the wrong way where name-primary would have been right. (The specific 49-minute shadow has passed — with one receipt, order is moot — so the record is not wrong *today*. The mechanism is what's live.)

Two more ways guard-written receipts can invert by date while names stay right:

- **Delay between stamping and tagging.** `STAMP` is read at `:292`, the tag is written at `:303`. Anything slow in between (`tag.gpgsign=true` and a GPG prompt is the obvious one — it's unset here, and the harness only pins `commit.gpgsign`) pushes `D_N` far past `T_N`. The next deploy then has a larger name and a smaller date.
- **Two clones.** The lock is per-`$GIT_DIR` and `newest_stamp` runs at step 9, long after the step-1 fetch — so a receipt pushed by another clone in between is invisible. Same-second receipts are still creatable, and name monotonicity doesn't hold across clones either.

Note the consequence for the choice you made: **neither key is total once external tags exist.** And I'd push back on the obvious "just make refname primary" — it doesn't work. Refnames never tie, because the sha7 differs, so the date tiebreaker would never fire and the forced same-second case would go back to being decided by `zzzzzzz` vs `aaaaaaa`. Getting "stamp primary, date tiebreak" requires parsing the stamp out, which `for-each-ref` can't sort on.

So, concretely, two things worth doing:

**(i) Detect the disagreement instead of silently resolving it.** Cheap, and it's the property you actually want: an ambiguous record should *read* as ambiguous, because the printed diff is the deliverable.

```bash
by_date="$(… --sort=-refname --sort=-creatordate …)"   # today's answer
by_name="$(… --sort=-refname …)"                        # the key step 9 guarantees
[ "$by_date" = "$by_name" ] || warn "the receipt record is ambiguous: by tag date the last deploy is ${by_date}, by name it is ${by_name}. One of them has a tag date that is not its deploy time (a seeded or hand-written receipt, or a bad clock). The diff below is against ${by_date} — check by hand before approving."
```

**(ii) If you want one total order that matches the guarantee**, sort on the parsed stamp with the date as a true tiebreaker — annotated only, `%(creatordate:unix)` is available:

```bash
git for-each-ref --format='%(objecttype) %(refname:short) %(creatordate:unix)' "refs/tags/${TAG_PREFIX}" \
  | awk -v p="$TAG_PREFIX" '$1=="tag"{n=$2; sub("^"p,"",n); split(n,a,"-");
      if (a[1] ~ /^[0-9]{8}T[0-9]{6}Z$/) print a[1], $3, $2}' \
  | sort -k1,1r -k2,2nr | head -1 | awk '{print $3}'
```

Either way, fix the comment at `:87` — as written it asserts an invariant the code doesn't hold, which is the kind of comment that stops the next reader from looking.

## 2. `latest_receipt` now fails OPEN where it used to fail closed

This is the direct answer to "can any new line silently return the wrong value." `:94`:

```bash
done <<< "$(git for-each-ref … "refs/tags/${TAG_PREFIX}")"
```

A command substitution inside a herestring word discards git's exit status, and the function now ends in `printf` — so status 0, `out=""`. Before, the function *was* the git call, so its status was git's, and `RECEIPT="$(latest_receipt)"` (`:249`, `:137`) aborted under `set -e` (an assignment's status is that of its last command substitution).

`''` is not a neutral value here. It routes to `:254`:

```
replaces:  (no receipt yet — first guarded deploy of firestore:rules; the whole file is new to the record)
```

…no diff printed, and the deploy proceeds. A git failure now reads to the operator as *"the record is new"* instead of *"I could not read the record."* That's the one item in this change I'd call a straight regression against AC#4's spirit, and it's the mechanism by which the printed diff becomes less trustworthy than before. `newest_stamp` has the same shape at `:105` — there it silently drops the monotonicity guard.

Fix: capture first, propagate. Declare `local` **separately** from the assignment — `local x="$(cmd)"` masking the substitution's status is shell/version-dependent, so don't rely on either behaviour:

```bash
latest_receipt() {
  local rows type ref out=""
  rows="$(git for-each-ref … )" || return 1
  while read -r type ref; do …; done <<< "$rows"
  printf '%s' "$out"
}
```

On the rest of the shell, which I went through line by line: the herestring loops are correct (`<<<` always appends a newline, so the final line is never dropped; empty output yields one empty iteration that the `[ "$type" = tag ]` / regex guard discards). `${ref#"$TAG_PREFIX"}` is properly quoted against pattern interpretation. The `-le` comparison is safe — 14 digits is nowhere near 64-bit, and bash's `test` parses base 10, so no octal trap. `${STAMP//[TZ]/}` and `[[ =~ ]]` with `{8}` intervals are fine on macOS bash 3.2. `{ …; } || git … || break` is correct: it breaks exactly when the stamp isn't stale and the name isn't taken, and every branch of the list ends 0 or breaks, so `set -e` never fires from it. `WAITED=$((…))` is an assignment, not `(( ))`, so a 0 result can't abort. The cap trace is right: 10 sleeps, then warn and break on the 11th pass, with a fresh `STAMP` that matches both `TAG` and `at=` in the message.

## 3. The annotated-only filter is applied on the read side only — your suspicion (b), and it's the asymmetry that bites

You're right that the filter changes the receipt set, and on the read side the direction is safe: your only receipt is annotated, step 9 only ever writes annotated tags, and nothing legitimate is excluded.

The problem is that `newest_stamp` (`:100`) **doesn't** apply it. So a lightweight tag is *not* a receipt when the guard reads the record, but *is* one when the guard orders it. A stray lightweight tag with a future-looking name — exactly the shape your own test creates at `deploy-rules.test.sh:161` — makes every later deploy sleep the full 10 s, print that whole warning paragraph, and write a receipt that is out of name order against a tag the guard doesn't even consider a receipt. Add the same `objecttype` filter to `newest_stamp`.

Your test file is one edit away from demonstrating this: the `29990101T000000Z-handmade` tag at `:161` survives to `:165` (`git reset --hard` doesn't remove tags) and is only cleaned by the next `fixture_reset` at `:168`. Insert or reorder a deploy case in between and you've bought a silent 10-second stall.

Second-order effect of the filter worth a warn: a receipt that exists *only* as a lightweight tag (someone recovers with `git tag` instead of `git tag -a`) now vanishes from the record entirely — "no receipt yet, the whole file is new," no diff. Warning when the namespace is non-empty but holds no annotated tag closes that.

## 4. The escape hatch's reassurance is false in its own motivating case

The receipt itself doesn't misrepresent *what* shipped: it points at `$SHA`, and `at=` is the real current time. What can misrepresent is order — and the warning at `:297` says:

> The guard itself reads them by tag date, which is still right.

The most plausible source of a future-**named** receipt is the guard running under a fast clock. The guard writes the name and the tag date in the same breath, so such a receipt's **date is future too** — and date ordering is equally wrong. The warning is confidently wrong in precisely the scenario that triggers it. It should say the record is now ambiguous and name both tags for a human to resolve (which pairs with the cross-check in §1).

## 5. The post-deploy wait: not worse in normal operation, materially worse in the pathological one — and it doesn't need to be there

Normal case is fine, and worth saying so: `PREV_STAMP` is minutes or days old, so the condition is false on the first pass, `git rev-parse` misses, and it breaks with **zero sleeps**. No widening.

The pathological case is the problem. With a future-stamped tag in the namespace (bad clock, seeded tag, or the lightweight tag from §3), *every* deploy now spends a guaranteed 10 seconds between "production has changed" and "the receipt exists" — and there is no crash-safe marker anywhere in that window. Ctrl-C, a closed terminal, or SIGKILL leaves production changed with no receipt and no `PENDING` file. The next `--status` then confidently reports the *older* receipt as what shipped last. That is the guard's worst outcome short of shipping wrong bytes: a false statement about production, stated without hedging.

Two fixes, and I'd take the first:

1. **Move the wait before step 8.** Reserve the stamp, *then* deploy, then tag. Monotonicity is unaffected — nothing else writes receipts under the lock, and the next deploy's stamp is still read later in wall-clock time. The post-release critical section goes back to what it was. The only change is that `at=` becomes deploy-*start*, which is arguably the more honest number anyway; document it.
2. **An in-flight marker** written before step 8 and cleared after the tag, with step 1 refusing (or loudly reporting) when it finds one. That also closes the pre-existing windows around `git tag -a` and the push, which this change inherits rather than creates.

## 6. The cap path skips the duplicate-name check (low)

`{A} || B || break` short-circuits: when A is true (stamp stale), B never runs. At the cap it breaks with a `TAG` whose existence was never checked. Reachable only after a backwards clock jump plus a same-second redeploy of the same commit — and it lands in `EX_RECEIPT` printing a hand-write instruction whose `git tag -a` will fail the same way. Evaluate the two conditions independently rather than chaining them, since the duplicate check was the old loop's entire job.

## 7. The tests: two genuine, one vacuous, two gaps

**Genuine.** `:136` (three distinct seconds) fails under the old code — three fake-firebase deploys land in one second — and is deterministic under the fix, so it can't false-fail. The forced same-second block (`:148`–`:156`) is the strongest of the new tests and fails the old code two independent ways: `-refname` picks `zzzzzzz`, so both the `aaaaaaa`/`zzzzzzz` asserts *and* `"nothing to deploy"` break (`zzzzzzz`→SHA1 reads as "AHEAD"). The lightweight sub-test at `:157`–`:164` also genuinely discriminates: the empty commit's date puts that tag first by date, and if it ties, `2999…` wins the refname tiebreak — so the type filter is exercised on either path. The `sleep 1` at `:151` is correctly load-bearing and correctly explained.

**Vacuous.** `:138`–`:140` — "ordering them by name and by tag date give the same answer" — is not the regression guard it reads as. Under the old code all three tags are written inside one second, so their `creatordate`s are **equal**; `--sort=refname --sort=creatordate` then degenerates to refname ascending and equals the first command exactly. It passes precisely when the bug is present, and can only fail by luck if the writes happen to straddle a second boundary. Assert something that can't degenerate — that the three `creatordate`s are also distinct, or better, that the guard's own `replaces:` line on a fourth deploy names the third deploy's receipt (that exercises the read path end to end instead of re-implementing the sort in the test).

**Gaps.**
- The cap-escape path has **zero** coverage — the one path that knowingly writes an out-of-order receipt and prints a paragraph to the operator. Worth a test: an annotated tag with a future name stamp, then a deploy; assert exit 0, the warning, and that the receipt exists and points at `$SHA`. It costs 10 s of suite time unless you make the cap a named constant the test can lower (weighed against the script's deliberate un-overridability, I'd just pay the 10 s).
- Every new test exercises the case where creatordate-primary is **right**. Nothing exercises the case where it's wrong — a receipt whose tag date isn't its deploy time, which is the shape of the one receipt you actually have. The suite currently locks in the choice without probing its cost.

---

## If you fix four things, these

1. `newest_stamp` gets the same annotated-only filter as `latest_receipt` (§3) — smallest change, removes the read/write split.
2. `latest_receipt`/`newest_stamp` propagate a `for-each-ref` failure instead of returning `''` (§2) — restores fail-closed.
3. Move the monotonicity wait ahead of `firebase deploy` (§5) — removes the new post-release window entirely.
4. Cross-check date order against name order and warn on disagreement (§1), and rewrite the cap warning to match (§4) — this is what actually keeps the operator's diff trustworthy, and it's the only fix that handles the two-clone case, where neither key is total.

Then the comment at `:87` should say what's true: the write side guarantees name order, the read side prefers date order, and the guard tells you when they disagree.
