I read all six inputs, verified the real receipt tag object directly, and checked the `for-each-ref` pattern semantics on this machine.

# Verdict: request changes

v3 is a large genuine improvement over v1 — the ordering key is right, the phase split is correctly abandoned, the "self-clearing" withdrawal is honest, and the analysis killing the 4th-deploy `replaces:` assertion is correct and well-argued. But **H2's central justification is inverted**, H1 repeats the exact bricking failure the plan fixes for H3, and Phase 2 has an internal contradiction plus a vacuous assertion. These are model errors again, not shell errors.

---

## What I verified (not asserted)

- **The real receipt.** `git for-each-ref refs/tags/deployed/tinker-hq-apps/firestore-rules/` → `objecttype=tag`, `creatordate=2026-09-21T16:54:12-06:00` = 22:54:12Z, name stamp `20260921T220500Z`, body `at=20260921T220500Z by=seeded`. Skew **49m12s**, `at=` agrees with the name stamp. It passes the plan's predicate and is the unique max stamp → stays discoverable. Its stamp is in the past, so the writer's feasibility check proceeds immediately. **The first real deploy after this change is not blocked.** ✅
- **Bytes.** Traced independently: `RECEIPT`/`RC` are consumed only at `deploy-rules.sh:106–134` and `:218–231`. The payload is `$TMP` from `git worktree add --detach "$TMP" "$SHA"` (`:208`); the hook re-checks `TINKER_DEPLOY_SHA="$SHA"` (`:243`). `STAMP`/`TAG`/`MSG` are read only at `:250–263`. Nothing in `:241–245` references them. Receipt ordering cannot reach the payload. ✅ One condition v3 does **not** state: the reservation loop must not `cd` into or touch `$TMP`, and its `sleep` sits between `:236` and `:243` — harmless, but say so.
- **`for-each-ref` patterns.** Confirmed empirically here: `refs/tags/deployed/*` matches **nothing** (the `*` won't cross `/`), while the prefix form `refs/tags/deployed/tinker-hq-apps/firestore-rules/` matches. The existing prefix form is correct; `${TAG_PREFIX}*` also works at the leaf level but would miss a mistyped sub-path, so keep the prefix form for H4.
- **Exit codes.** `:45` defines 10–18. 19, 20 (and 21) are free. ✅
- **The flake mechanism** (plan 43–46) is exactly right: `:127` deploys SHA2 again, reads `:218` over `{r1(T,sha7(SHA2)), r2(T,sha7(SHA3))}`, and when `sha7(SHA2) > sha7(SHA3)` picks r1 → diff SHA2→SHA2 → empty → `assert_has "-// v3"` fails. ✅
- **`-refname` is stamp-major** (plan 259): constant prefix + fixed-width stamp. ✅

---

## 1. H1–H4: the blind spot moved, it did not close

### 1a. BLOCKING — H2's flagship claim is backwards (plan 110–119, 216–219, 284–285)

Plan 112–115:

> At 22:54 the operator hand-writes A's receipt but **improvises a fresh `date -u`** instead of copying the printed command. A now has a later stamp and a later tag date than B. It wins under both keys. **H2 catches it — A's own stamp-to-date skew is 49 minutes.**

It does not. If they improvise `date -u` at 22:54, the tag **name stamp is 22:54** and the tag object is written at 22:54. **Skew ≈ 0.** H2 is silent.

The 49 minutes belongs to the *other* construction — the **faithful** late recovery, which copies the original stamp (22:05) and tags at 22:54. That receipt is the real seeded one, and it orders **correctly** (22:05 < B's 22:15). So as specified:

| recovery style | skew | ordering | H2 |
|---|---|---|---|
| faithful (copies the printed command) | 49 min | **correct** | **warns** |
| improvised (`date -u` now) | ~0 | **wrong** | **silent** |

**H2 is anti-correlated with the harm.** It fires on the correct record and stays quiet on the corrupt one — which is the single failure both v1 reviewers named as most likely, and the one v3 says H2 "earns its place" by catching. Run the rest of the pass on the improvised receipt: H1 — unique max stamp, silent. H3 — 22:54 is in the past, silent. H4 — annotated and well-formed, silent. **Confident wrong answer, zero findings.** That is the priority-1 counterexample you asked for, in scope (single clone), and it is the plan's own headline scenario.

The error came from the Claude review (§2, "for a hand-written one it is 49 minutes"), which made the same conflation. v3 adopted it verbatim and promoted it to load-bearing.

What actually catches it: the **`at=` cross-check**, which v3 mentions only in passing at 120–123 as one of "two cheap additions" — no severity, no refuse/warn policy, no test. An operator editing the printed `git tag -a` command will change the stamp in the tag *name* and almost certainly leave `at=22:05` in `$MSG` → mismatch. That is the detector. Required:

1. Correct 112–119 and 216–219.
2. Promote `at=` ≠ name-stamp to a first-class finding (H5) with an explicit policy — I'd argue REFUSE on `--approved`, since a tag whose own body contradicts its name is by the plan's own words something "nothing about it should be trusted."
3. State plainly that a hand-written receipt carrying a *consistent* improvised timestamp is **undetectable from local git evidence**, and that Phase 2 is the only mitigation. That makes Phase 2 load-bearing rather than a bonus — which strengthens the case for the same session, and is a coherent story. It just isn't the story the plan currently tells.
4. Add the test: annotated receipt, name stamp now, `at=` an hour earlier, tag date now → must be flagged.

### 1b. BLOCKING — H2 fires on day one, on the only receipt that exists

The seeded receipt's skew is 49m > 10m, and it is currently the winner for `firestore:rules`. So the first thing this change does in production is print, on every `--status` and above every `--approved` diff until the next deploy:

> WARNING: … 49 minutes later. It was probably written by hand. Confirm it is really what shipped last before approving the diff below.

True, unactionable, and aimed at a non-technical operator. The plan itself argues at 179–181 that shipping a known-noisy gate "trains operators to re-run until green, which is the habit that gets a real failure waved through." That reasoning applies here and the plan does not apply it.

**Fix:** gate H2 on `by=`. A receipt whose body says `by=deploy-rules.sh` has an expected skew of exactly the release duration — that's where a threshold is meaningful. A receipt saying `by=seeded` (or anything else) was *not written by the script*; state that as a neutral one-line fact, not a warning. Provenance is evidence; skew on a receipt of unknown provenance is a guess. Note the predicate must still not *require* `by=deploy-rules.sh` (plan 61–62 is right about that).

### 1c. BLOCKING — H1 can brick the deploy path, by the plan's own argument (plan 96–99, 159–164, 358–360)

H3 gets `--accept-out-of-order-receipt` because (plan 159–162) one bad tag "would otherwise brick the only sanctioned deploy path for all 21 apps, permanently — and the guard is exactly what Christie must reach for during an emergency rules rollback," and "just delete it" is rejected because receipts are immutable.

**Every word of that applies to H1, and H1 gets no override.** Two receipts at the maximum stamp (two clones — anticipated at `deploy-rules.sh:171`; or a hand-made tag, which is documented practice) → `--approved` refuses EX_RECORD → the only way to add a newer receipt is a deploy → which refuses. The escapes are (a) delete a receipt, which the plan forbids, or (b) hand-write a fabricated newer receipt for a deploy that never happened. Both are strictly worse than the flag H3 gets. Plan 358–360 accepts that H1 "can refuse a deploy that would have been correct" but never notices the refusal has no way out.

Two fixes, and I'd take both:

- **Narrow H1 to the case that actually matters.** The guard's use of the winner is `receipt_commit` → the diff base (`:226–229`) and the "nothing to deploy" test (`:125`). If every tied max-stamp candidate resolves to the **same commit**, the answer *is* forced by the evidence for every purpose the guard has. Refuse only when the tied candidates disagree about the commit; otherwise name them all and proceed. This is a direct application of the plan's own framing ("is this answer forced by the evidence?") and it removes most of the brick risk for free.
- **Give the residual case an override**, on the same terms as H3: non-default flag, names both candidates, prints the diff from *each*, warns persistently.

Also: **EX_RECORD=19 is used for two unrelated faults** — "the record cannot be read" (plan 132, 203–204) and "cannot honestly name what shipped last" (plan 174–175, 195–196). Different causes, different remedies. This is the same conflation the plan correctly dismantles at 150–153 for the 10-second cap ("same path, same message, same remedy — and neither remedy fits both"). Split them.

### 1d. Is the 10-minute threshold defensible? Yes — with a stated failure mode

Given reserve-late, the expected skew is `firebase deploy` + `shasum` + tag write, with the rules suite excluded (it runs at `:234`, before the stamp). Seconds to tens of seconds. 10 minutes is ~20–120× headroom. **Defensible.** A legitimately slower release (auth hang, slow network, an indexes submit) produces a warning, never a refusal — but a **sticky** one: the tag is immutable, so it warns on every run while that receipt is the winner, clearing only on the next deploy. Say that in the plan; the proposed wording ("Confirm it is really what shipped last") survives it, an alarm-toned wording would not.

### 1e. H2's scope is contradictory (plan 100 vs 284–285)

Plan 100 says "**the winner's own** skew." The planned test at 284–285 has the skewed receipt (08:00/11:00) as the **loser** and still expects "H2 warns." Pick one, and price it: winner-only is quiet but blind to every non-winning receipt; all-receipts means the seeded receipt warns on every run forever.

### 1f. H3's refusal contradicts the three-way split (plan 103–105 vs 154–158)

H3: "*any* receipt's stamp is in the future → REFUSE (EX_CLOCK) unless overridden." The split: "`now < stamp <= now + 10 s` → wait it out, then proceed." A stamp 3 seconds out satisfies both rules with opposite outcomes. If the health pass runs on `--approved`, the middle band is dead code. One statement, please.

### 1g. After the override, the bogus tag still wins forever (plan 163–164)

`--accept-out-of-order-receipt` "writes a receipt at the current (older) stamp." That receipt can never be the max. So on the next run, `--status` names the year-2999 tag as what shipped last and `--diff` diffs from it — and if it happens to point at `origin/main`, you get exactly the silent "nothing to deploy" harm the plan itself calls out at 47–49. A loud warning plus a wrong authoritative diff is precisely what the Goal forbids. **The override must also exclude the offending tag from ordering**, not merely from blocking — otherwise it buys one deploy and permanently corrupts the reader.

### 1h. Impossible-but-well-shaped stamps: handled only by accident (Codex required this; v3 dropped it silently)

`20269999T999999Z-abc1234`, annotated, passes the shape-only predicate and out-sorts every real receipt. Whether it's caught depends entirely on an implementation choice the plan doesn't pin:

- **Lexical/numeric stamp comparison** (`${STAMP//[TZ]/}`, as `d43a171` did): `20269999999999` > now → H3 fires → refused. Handled.
- **Epoch parse** (the more "correct" implementation): `date -u -j -f '%Y%m%dT%H%M%SZ' 20269999T999999Z +%s` — BSD strptime/mktime may reject it, or may normalize it into some other date. Behavior unknown, and if it errors under `set -e` inside a health function you get an abort with no message.

**Pin the rule:** a stamp is a receipt only if it **round-trips** — parse to epoch, reformat, compare byte-for-byte to the original. Anything that doesn't round-trip is not a receipt and is reported by H4. That disposes of Codex's item properly instead of leaving it to luck.

Related and concrete: computing "`now + 10s` as a stamp" **cannot** be done with digit arithmetic (`115959` + 10 ≠ `115969`). You need a second `date` invocation — `date -u -v+10S` or `-j -f` — which collides head-on with the controlled-clock fake (see §5c).

---

## 2. The ordering key: still right, and now coherent — with one caveat

**(name stamp, tag date, refname) descending, tag date only inside an exact stamp tie — endorse.** The asymmetry argument at plan 65–68 is the correct one and is verified by the real receipt: `deploy-rules.sh:258` interpolates `$TAG` into the printed recovery command, so the stamp survives transcription and the tag date cannot. I enumerated the alternatives and found nothing better under the frozen name format.

**No, there is no inconsistency** between ordering by tag date and refusing to trust it — but the plan should say what the key is actually worth after H1: on `--approved`, H1 fires on every stamp tie, so **the tag-date key never decides anything on the deploy path**. Its entire job is making `--status` deterministic so two sessions comparing notes get the same string. That is a real but small value, and plan 72's "a deterministic guess, not evidence" is the honest framing. If you take the H1 narrowing from §1c, the key regains authority only in the same-commit case — where it cannot change the answer that matters. That is fully coherent; write it down that way.

---

## 3. Phase 2: right instinct, three defects and a deadlock

**Faithful auto-recovery is the right call** — the improvised timestamp is the corruptor, so removing the human from the timestamp is the fix. **A second marker file is also right**, and better than the Claude review's suggestion of reusing `$PENDING`: a `$PENDING` entry naming a tag that doesn't exist would fail `[ "$LOCAL_O" = "$PO" ]` at `:178` and produce a misleading refusal. Credit for improving on the review rather than obeying it.

### 3a. BLOCKING — the marker contradicts itself (plan 222 vs 233–236)

> 222: "record everything needed … sha, the reserved stamp, target, **sha256**"
> 236: "it is the very first thing after a successful release — **ahead of the shasum**, ahead of the tag"

It cannot contain the sha256 and be written before the sha256 is computed. **Resolution:** compute `HASH` *before* step 8 — `$TMP/$FILE` is immutable from `:208` onward, so hashing at step 7 is free — alongside the stamp reservation. Then the post-release path is one `printf > marker`, then tag, then push. That also shrinks the post-release window further, which is Part 3's whole thesis.

### 3b. BLOCKING — the marker write is unguarded, and fails in exactly the case it exists for

`printf … > "$UNRECORDED"` under `set -euo pipefail` aborts the script with **no output** if it fails. Plan 235–236 acknowledges the hazard ("A marker write that itself fails leaves the original bug") and does nothing about it. And the correlation is the point: the most-cited cause of `git tag -a` failing is a full or read-only disk — which is also what makes the marker write fail. **Phase 2's marker is most likely to fail precisely when it is needed.**

Required: guard the write and fall back to today's behaviour — `|| { print the full hand-write instructions; exit $EX_RECEIPT; }`. Never a bare redirect.

### 3c. BLOCKING — recovery deadlocks when the tag already exists

`git tag -a` fails *most commonly because the name already exists*. Two reachable routes:

1. **The operator does what the script told them to.** `:258` prints the hand-write command and Phase 2 doesn't say that stops. They write the tag by hand. The marker is still present. Next run rebuilds → name exists → `git tag -a` fails → "refuses if any step fails" (plan 232) → EX_UNPUBLISHED telling them to run the `git tag -a` that just failed. **Every subsequent run refuses.**
2. **Step 1's fetch imports it.** The recovery run fetches tags from `origin` (`:169`) *before* rebuilding, so it can newly acquire a colliding receipt from another clone between the failure and the recovery.

Required: the rebuild must handle "the tag already exists" the way `:177–186` already handles the remote — if it exists and points at the recorded sha with the recorded message, treat it as recovered and clear the marker; if it exists and differs, refuse with a message that says what a human does. And state explicitly whether `:258` keeps printing the hand-write instructions (it should, plus "or just re-run the guard").

### 3d. Phase 2's recovery deliberately manufactures an H2 warning

A faithfully rebuilt receipt has, by construction, its original name stamp and a tag date from whenever the recovery ran — the 49-minute-skew shape. **Every Phase 2 recovery permanently trips Phase 1's H2 on a receipt that is exactly right.** The plan doesn't notice the interaction. Fix: the rebuilt message carries a field (`recovered=<stamp of the rebuild>`), and H2 skips receipts that carry it — which also makes the record self-documenting about the window where production was unrecorded.

### 3e. Does auto-recovery ever fabricate a receipt for a deploy that didn't change production?

I traced it: no. The marker is written only after `firebase deploy` returns 0 (`:243`); a predeploy refusal exits non-zero and writes nothing. The marker lives in the local `GIT_DIR`, and `--approved` reconciles before deploying, so it can't outlive its context. The one honest caveat is the pre-existing one already in the header (`:25–27`): a receipt attests a *guarded deploy*, not production. No new fabrication risk. ✅

### 3f. Exit code (plan 250)

EX_UNPUBLISHED (12) is reused for "production is live and **completely unrecorded**, and the rebuild failed" — materially more severe than its current meaning, and `deploy-rules.test.sh:175` pins 12 for the old one. The plan mints 19 and 20 arguing "a pre-release refusal and a post-release one must never be confusable in a transcript" (171–175) and then reuses 12 here. Either take 21 or say why the reuse is right. *(Preference, but it contradicts a rule the plan just wrote.)*

Minor: state precedence if both markers somehow exist ($PENDING first).

---

## 4. "Check early, reserve late": sound, but the sequencing is underspecified

The intent is right and, done properly, it **narrows** the window rather than widening it — because `:253`'s dedup loop, which today can `sleep 1` *after* production changed, moves pre-release.

But plan 143–149 leaves three things ambiguous, and one reading defeats the whole argument:

1. **Which check runs where.** 143–144 says the feasibility check at ~`:200` and the stamp at ~`:242`; 147–149 then describes "two checks" without saying which point they belong to. The name-collision check *cannot* run at `:200` — the name doesn't exist yet, and a name derived from the early stamp will never be used. It must be: `:200` = clock feasibility only (refuse >10s gap in one second); `:242` = the real reservation loop (take stamp, test monotonicity **and** name collision, bounded wait), all pre-release.
2. **Is `:253`'s loop moved or duplicated?** If it stays, the post-release sleep stays and Part 3's central claim is false. Say "moved," explicitly.
3. **Is monotonicity re-asserted at `:242`?** The clock can move backwards during a multi-minute test run, so the `:200` check doesn't bind at `:242`. Either re-assert (a pre-release refusal after a full test run — safe, just costly) or say the guarantee is best-effort.

**What new things can fail between `:243` and `:260`:** only the Phase 2 marker write (§3b) — and unguarded, it fails silently. Everything else in that span is pre-existing, and moving `shasum` earlier (§3a) removes one. With §3b fixed, the answer is genuinely yes, the window narrows.

---

## 5. Tests: one planned assertion is vacuous, and there are two harness traps

I walked the whole battery against the current code. Most of it is sound and forced — the malformed-name, future-lightweight, predicate-parity, H1, H1-worst-case, H3, H3-override, and failed-ref-read cases all fail against today's code for the right reason. The "never assert that two orderings agree" standing rule (plan 262–265) is exactly right and belongs in the file header.

### 5a. BLOCKING — a Phase 2 assertion passes today (plan 305–307)

> "Order preserved end-to-end: deploy A with the tag write failing, deploy B normally, then recover A. Assert `--status` still names B as what shipped last. **This is the whole point of Phase 2 and it fails today.**"

It **passes** today. Today, A with a failing `git tag -a` leaves **no receipt at all**, so B is the only receipt and `--status` trivially names B. The assertion is satisfied by the bug. This is the third instance of the same defect — the shipped one, the one v1 proposed, and now this one.

Fix: assert (a) A's receipt **exists** with A's original stamp, (b) it sorts before B's, (c) `--status` names B. (a) is the part that fails today.

### 5b. The "delayed hand-recovery" case is an H2 test, not an ordering test (plan 284–285)

Stamp 08:00 vs 09:00: under today's `--sort=-refname`, `...T090000Z-...` already out-sorts `...T080000Z-...`. **The old reader picks the same winner.** The ordering half passes while the bug is present. Keep it for H2, but label it — otherwise it inflates the battery's apparent coverage, which is how the last one got through.

### 5c. Two controlled-clock traps

**The fake `date` will be asked for more than one thing in the stamp format.** Computing "now + 10s" needs a real date call (`-v+10S`, or `-j -f` to epoch). A fake specified as "answers the stamp format from a counter file" (plan 267–268) would return the bare counter for that call too, collapsing the +10s band to zero and making the three-way split untestable — while the suite stays green. Pin it: the fake intercepts **only** `date -u +%Y%m%dT%H%M%SZ` with no other flags, and delegates every `-v`/`-j`/`-f`/`-r` form to the real `date`.

**The counter must be real epoch seconds**, formatted through the real `date`, or the fake breaks at the 59→60 boundary and the guard's monotonicity comparison starts failing on a clock that "advanced."

### 5d. The plan's reason the three-deploy test fails under the old writer is wrong (plan 269–271)

> "under the old writer no sleep occurs, all stamps stay equal, and the test fails every run"

The third deploy re-deploys SHA2, so its candidate name collides with the happy-path receipt's and **`:253`'s dedup loop does sleep** — the plan establishes this itself at 255–259 and then forgets it four paragraphs later. The old writer produces `C, C, C+1`, not `C, C, C`. The test still fails every run (not strictly increasing) ✅ — but the implementer must verify against `C, C, C+1`, not the plan's stated rationale.

### 5e. Missing: negative assertions

Not one planned assertion checks that an H stays **silent** on a healthy record. An implementation that warns unconditionally passes the entire battery. Every H needs a paired "does not fire on the happy path" assertion — and note `run()` captures stderr into `$OUT`, so an over-eager warning is otherwise invisible.

### 5f. Two small ones

- "Regression pin: the existing real receipt's shape" (plan 292–293) — the harness builds a throwaway repo; the real receipt isn't there. Say "synthesize a receipt with that shape (annotated, `by=seeded`, 49-minute skew)" or an implementer will reach for the real repo. That test should also assert it's still named as what shipped last **and** what H2 does with it (see §1b).
- The transparent `git` wrapper's switch must be scoped to the guard invocation (`FAIL_GIT=… run --status`), not exported, or it corrupts the harness's own git calls during fixture setup.

---

## 6. What you missed

### 6a. `--diff` is not fail-closed — a stated required change, half-addressed (plan 96–99)

Codex's required change #2 was explicit: "`--status` can report candidates; **`--diff` should not present one as authoritative**." v3's table gives `--status/--diff` → "name every candidate" and only `--approved` → REFUSE, with no acknowledgement of the divergence.

This matters more than the table suggests, because of the actual workflow: Claude runs `--diff`, Christie reads **that** output and approves, then `--approved` runs. If H1 makes `--approved` refuse, she has already approved a diff taken from a coin-flip base. Either `--diff` refuses under H1 too, or it prints the diff **from each candidate**. A warning on stderr above a diff on stdout is not sufficient.

### 6b. Health findings must go to stdout, not stderr

`warn()` writes to `>&2` (`:73`); `git --no-pager diff` writes to stdout. "Above the diff" (plan 102, 119) is a stream-ordering claim, and in a captured or piped transcript a stderr warning is not reliably above anything. For `--approved` and `--diff`, emit health findings via `say()` so they land in the same stream Christie reads.

### 6c. Goal vs. narrowing (plan 8–10 vs 11–17)

The Goal — "that diff is either right or the guard refuses to present it as authoritative. It never converts incomplete evidence into a confident answer" — is falsified by §1a (in scope, single clone) and by the fast-clock cross-clone case (out of scope, but the Goal's phrasing is absolute). Narrow the Goal to match the narrowing paragraph, or the plan claims something it will not deliver and the next reviewer will find it.

### 6d. Two shell traps a reviewer required, dropped without comment

Claude's review §6 listed four; v3 kept two (the `local` masking — correctly verified — and the `while read` subshell) and silently dropped:

- **`… | sort -r | head -1` under `pipefail`**: `head` exits after one line, `sort` takes SIGPIPE, a correct read becomes a pipeline failure → `|| die EX_RECORD` → the guard refuses on a healthy record. Use `awk 'NR==1'`.
- **`LC_ALL=C`**: `git for-each-ref --sort` is bytewise internally, but the moment you sort in the shell you inherit BSD `sort` under `en_US.UTF-8`, whose collation does not give byte order for the `-` and `/` in refnames. Byte order is what fixed-width stamp comparison assumes.

These are the *exact class* that killed the first attempt. Dropping them is a regression in the plan.

And a third, not in either review: **`set -e` is disabled inside a function invoked in a `|| die` context.** `RECEIPT="$(latest_receipt)" || die …` means every fallible command *inside* `latest_receipt` runs with errexit suppressed and its failure ignored. The plan's rule (131–132) only covers the outer layer. Every fallible command inside these functions needs its own `|| return 1`.

### 6e. Sequencing of the health pass

Not stated: it must run **after** step 1's reconcile (which changes the record by publishing a pending receipt) and **before** the tests (it needs only the ref list, available at `:169`) — otherwise an H1 refusal costs a full rules suite, the same cost the "check early" argument exists to avoid.

### 6f. Small, correct, worth crediting

Deferring the `RULES-ROLLBACK.md` entry is forced by the scripts-only constraint and handled sensibly (recovery steps in the refusal message). Make it a hard requirement that the message prints the **literal flag string** and the **literal commands** — a non-technical operator under pressure will retype exactly what they see.

---

## The short list

**Blocking**
1. H2's detection claim is inverted (110–119) — it warns on the correct record and is silent on the corrupt one. Promote the `at=` cross-check to a real finding; state that a consistent improvised stamp is undetectable and Phase 2 is the mitigation.
2. H2 fires on day one on the only real receipt (49m skew). Gate on `by=`.
3. H1 has no override and repeats the bricking failure the plan fixes for H3 (96–99 vs 159–164). Narrow it to "tied candidates disagree about the commit," and give the residue a flag. Split EX_RECORD's two meanings.
4. Phase 2: marker content vs. marker ordering contradict (222 vs 236); the marker write is unguarded and fails in the correlated case (disk full); the rebuild deadlocks when the tag already exists — which is the likely path, since `:258` still tells the operator to write it by hand.
5. Vacuous assertion: "Order preserved end-to-end … fails today" (305–307) passes today. Third instance of this defect.
6. `--diff` must not print an authoritative diff under H1 — Codex required it; v3 half-addressed it without saying so.

**Should fix**
7. H3's "any future stamp refuses" vs the 0–10s wait band (103–105 vs 154–158).
8. After `--accept-out-of-order-receipt`, the bogus tag still wins the ordering forever (163–164).
9. Restore the `sort`/`LC_ALL=C`/SIGPIPE traps; add the errexit-inside-`||`-context rule.
10. Pin the stamp round-trip rule (disposes of impossible stamps properly) and pin the fake `date`'s interception surface.
11. H2's scope: winner-only or all receipts (100 vs 284–285).
12. Add negative assertions — no H currently has a "stays silent" test.
13. Reservation sequencing: which check at `:200` vs `:242`, and state that `:253`'s loop **moves**.
14. Health findings to stdout, not stderr.
15. Label the delayed-hand-recovery test as an H2 test (it passes under the current reader).
16. Correct the stated reason the 3-deploy test fails under the old writer (269–271): the record is `C, C, C+1`.
17. Narrow the Goal sentence to match the narrowing paragraph.
18. *(Preference)* Phase 2 should take a new exit code rather than reusing EX_UNPUBLISHED.

The ordering model is right and I'd ship it unchanged. What still needs work is everything built on top of it — and specifically, H2 is currently a detector pointed at the wrong case, which is the same species of error as the reverted attempt: correct-looking, test-passing, and modelled backwards.
