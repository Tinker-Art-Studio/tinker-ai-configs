I could not open three of the five required inputs. Everything under `/Users/christiehubley/tinker-ai-configs/` is outside this worktree and reads are blocked by the sandbox:

- the plan itself (`thoughts/plans/deploy-guard-receipt-ordering.html`)
- both reviews (`thoughts/reviews/2026-09-22-...-claude.md`, `...-codex.md`)

I tried `Read`, `cat`/`ls` via Bash, `git show` from that repo, and the artifact gallery (it isn't published). All refused. **To get the full pass, grant read access to `/Users/christiehubley/tinker-ai-configs/thoughts/` and I'll re-run against the actual document.**

What I did read in full: the revert message (`1ff50b2`), the reverted attempt (`d43a171`, diff and rationale), `scripts/deploy-rules.sh`, `scripts/deploy-rules.test.sh`, and the real receipt tag object itself. Your prompt states the plan's five decisions precisely enough to attack the *model*, which is priority 1 — so below is a review of the design as you described it, plus what the code and the real receipt actually show. Anything that depends on the plan's prose (exact wording, exact placement, the rest of the Open Questions) I have not seen.

# Verdict: request changes

Four of the six areas have concrete defects. The ordering model is right. The detector, Q1, the phase split, and one of the two replacement assertions are not.

---

## First, evidence: the real receipt

I inspected it rather than trusting the revert message:

```
refs/tags/deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3
type=tag   creatordate=2026-09-21T16:54:12-06:00  (= 22:54:12Z)
contents:  … at=20260921T220500Z by=seeded — written by hand for the last pre-guard deploy …
```

Annotated ✅, stamp parses ✅, `at=` agrees with the name stamp ✅, and the name-stamp→tag-date skew is **49m12s**. So the revert's central claim is verified, and the one existing receipt survives the plan's predicate (annotated + well-formed stamp). Constraint met.

---

## 1. The ordering model: correct. Ship it.

**(name stamp, tag date, refname) descending is right**, for a reason worth writing into the code comment: the stamp is not a timestamp the script observes, it is a value the script *writes* and that hand-recovery *transcribes*. Line 258 prints the recovery command with `$TAG` already interpolated — the original stamp — so a receipt written 49 minutes late still carries deploy time. The tag date is the only field that cannot survive that transcription. That asymmetry is the whole argument, and it is sound.

I enumerated the alternatives; none beats it. Commit committer-date is meaningless for a rollback (it deploys an old commit). Tag reflogs are local-only and never fetched, so they don't exist for a second clone. `ls-remote` exposes no ordering. The genuinely better key — a monotonic sequence number in the name — is excluded by the frozen name format.

**Tag-date-as-tiebreaker does not smuggle the reverted approach back in.** It is consulted only when two stamps are byte-identical. The case that killed `d43a171` (hand-recovery) produces *different* stamps, so the date key is never reached there. The smuggle would require a hand-written receipt that happens to land in the same second as another receipt. Fine.

But be honest in the plan about what it is worth: after Phase 2's monotonic reservation, the same-clone same-second tie **cannot be produced by the script at all**, so the tiebreaker only ever fires for (a) two clones in the same second and (b) hand-made tags. In case (a) the tag dates come from two different clocks and are exactly as untrustworthy as the stamps. The tiebreaker is near-decorative. The thing actually carrying the safety load in the cross-clone case is the warning — which is finding 2, and it doesn't work.

### 1a. The model has one hole, and it is the likely one

Sequence, entirely reachable from the script as written:

1. Deploy A ships at 22:05. `git tag -a` at line 257 **fails** (disk full, signing config, gpg prompt under `GIT_TERMINAL_PROMPT=0`). Script exits 17. **Note line 257's failure path does not write `$PENDING`** — only the *push* failure at line 262 does. So there is no marker and the next deploy does not refuse.
2. Deploy B ships at 22:15, writes its own receipt normally.
3. At 22:54 the operator gets back to A and hand-writes its receipt — but improvises with a fresh `date -u` instead of copying the printed command.

Now A's receipt has a later stamp *and* a later tag date than B's. It wins under both keys. The guard says "replaces: A" and diffs from A. Wrong base, and the two-key detector is structurally blind to it because both proxies share the failure mode.

This is not a reason to change the key. It is a reason the detector must not be a comparison of two proxies (finding 2), and a reason the plan should state that line 257's failure path must also write `$PENDING` so the next run refuses until it's sorted — the same treatment the push failure already gets at line 263.

---

## 2. The ambiguity warning: the self-clearing claim is false, and the detector points the wrong way

**Your claim is false in two constructible cases.**

*Warns forever.* Phase 2 reserves a strictly newer **stamp**. Nothing makes the new tag's **date** the newest date. Plant an annotated tag whose tag object date is in the future (`GIT_COMMITTER_DATE`, `git tag --date=`, or a machine whose clock ran fast, wrote a tag, and was then corrected backwards). Every subsequent ordinary deploy is newest by stamp and *not* newest by date. The argmaxes differ on every run until real time passes the bogus date. If it's a year out, it warns for a year. "The next ordinary deploy writes a receipt that is newest under both keys" is only true when no existing tag has a future date, and the plan does not establish that — clock rollback is on the revert's own list of untested paths.

*Fails to warn.* Finding 1a above: the improvised hand-written receipt is newest under both keys. Agreement, no warning, wrong answer. The detector measures *disagreement between two proxies*, but the dominant real-world error mode (a receipt written late) moves both proxies the same direction by the same amount. It is blind precisely where you need it.

**Also: in Phase 1 the warning is dead code for the case it exists to cover.** Same clone, two deploys in one second: stamps tie *and* tag dates tie (git timestamps are whole seconds), so both orderings collapse to refname and produce the identical argmax. It never fires. It only becomes live once Phase 2 makes stamps distinct — another argument for finding 4.

**What to use instead.** The signal you actually want is already sitting in every receipt: **the skew between a receipt's own name stamp and its own tag date.** For a script-written receipt that is the length of the release (seconds to a couple of minutes, and if Phase 2 reserves the stamp pre-release, it is *exactly* the release duration). For a hand-written one it is 49 minutes. Warn when the winning receipt's `tag_date − name_stamp` exceeds a threshold, and say so in words Christie can act on:

```
WARNING: this receipt's stamp says 22:05:00Z but its tag object was written at
22:54:12Z — 49 minutes later. It was probably written by hand. Confirm it is
really what shipped last before approving the diff below.
```

That catches 1a, catches the seeded receipt today, and needs no second sort. Pick the threshold with room for a slow release — 10 minutes, stated in the plan, not derived silently.

Keep the two-way comparison as well if you like — it is the only thing that sees cross-clone skew — but demote it: it is not the primary detector, and the "self-clearing" sentence must come out or be qualified to "self-clearing provided no receipt carries a future tag date."

Two more things while you're here, both cheap and both converting an invisible model assumption into something a human can check:

- Print the winning receipt's tag date next to its stamp in `--status` and in the `replaces:` line (line 227).
- Cross-check the `at=` field in `%(contents)` against the name stamp. They agree on the real receipt. If they ever disagree, the tag was edited and nothing about it should be trusted.

---

## 3. Q1: refusing is right in principle, wrong as specified

Your framing — "free, because nothing has shipped" — is wrong in one direction and right in another, and the plan has picked the wrong lever.

**Where refusing is genuinely dangerous.** A single annotated tag with a far-future well-formed stamp under `deployed/tinker-hq-apps/firestore-rules/` bricks the *only sanctioned deploy path* for every one of the 21 apps, permanently, until someone deletes it. That is not hypothetical shape-wise: your own test suite plants exactly that name at `deploy-rules.test.sh:182` (`29990101T000000Z-handmade`). And the guard is what Christie has to reach for during an emergency rules rollback, when production is already denying reads. Receipts are documented as immutable and never deleted, and `RULES-ROLLBACK.md` has no "a bogus receipt is blocking deploys" section. So the escape hatch is an undocumented `git tag -d` performed by a non-technical operator under pressure. Blocking a rollback is not free.

**Where refusing is genuinely right.** The alternative — "just take max(prev, now) + 1s" — is a Lamport clock, and under a stray `2999` tag it poisons every future receipt name with a year-2999 stamp forever. That is worse. So you cannot simply never refuse.

**The real defect is that the 10-second cap conflates two unrelated faults.** "This machine's clock will not advance one second in ten" is broken hardware. "There is a tag stamped three years from now" is corrupt data. Same code path, same message, same remedy — and neither remedy fits both.

**What I'd do — split it three ways, and decide it from the size of the gap, not from a wall-clock cap:**

| newest recorded stamp | action |
|---|---|
| ≤ now | proceed immediately (the normal case — no wait at all) |
| now < stamp ≤ now + cap | wait it out, then proceed. Pre-release, costs seconds, correct. |
| > now + cap | **refuse immediately** — do not sleep 10s first — with a *new* exit code, naming the offending tag, whether it is annotated, its `by=` field, and the runbook step. Offer one explicit, non-default escape: `--accept-out-of-order-receipt`, which proceeds and writes a receipt at the current (older) stamp with a loud warning that persists in `--status` until the record is repaired. |

Three specifics the plan must nail down:

- **New exit code, not a reused one.** Lines 45 defines 10–18; 19 is free. Do **not** reuse `EX_RECEIPT` (17): it currently means "production changed, the receipt did not publish," and `deploy-rules.test.sh:172` pins that meaning. A pre-release refusal and a post-release one must never be confusable in a transcript.
- **Check early, reserve late.** If the feasibility check sits just before line 243, the operator sits through the full rules suite (line 236) to be told no. Do the *check* right after step 3 (~line 200) so a refusal costs one second, and do the *reservation* immediately before the deploy so the stamp stays close to the release.
- **`at=` is no longer "when it shipped."** Once the stamp is reserved pre-release, `at=${STAMP}` (line 256) is "when the receipt was reserved." Either relabel it or add a second field. This also sets the threshold for the skew detector in finding 2 — the expected skew becomes exactly the release duration, which is what makes 10 minutes a defensible threshold.

---

## 4. The phase split: do not ship Phase 1 alone

Correctness-wise Phase 1 is a strict improvement and never picks a *worse* receipt than line 76 does today — the primary key is unchanged (refname sort is already stamp-major, since stamps are fixed-width UTC), and the annotated + well-formed filter strictly removes bad candidates. Today a lightweight `29990101T000000Z-handmade` **wins**; after Phase 1 it cannot. Real gain.

But "the same-second flake is only reduced" understates it. For the same-clone case — which is every case in the test suite — Phase 1 reduces it by **zero**. Both keys have one-second resolution, so a same-second pair ties on stamp *and* on tag date and falls through to refname, i.e. the arbitrary sha7, exactly as today. The rollback assertion at `deploy-rules.test.sh:127` stays flaky (the revert message records 89/1 then 90/0 with no code change).

That matters more than it looks: per the global rules, `npm test` is the gate on every rules deploy. Shipping a phase whose known effect is "the gate stays flaky for a while" trains operators to re-run until green, which is the habit that gets a real failure waved through.

Ship them together, or fold the stamp reservation into Phase 1 and leave the refusal policy and the warning for Phase 2. If you do split it anyway, the plan must say in writing that `:127` remains flaky in the interim and that **it must not be "fixed" with a `sleep` in the test** — the sleep would mask Phase 2's absence and then silently mask Phase 2's regression later.

---

## 5. Test strategy: one assertion is good, the other is vacuous in the same way as last time

**"Three distinct seconds" — keep it.** Not vacuous. Under the buggy writer the happy-path receipt and the `rules v3` receipt share a second (2 distinct, not 3), so it fails. Two strengthenings: assert the stamps are **strictly increasing in deploy order**, not merely distinct (distinctness passes for T+1, T, T+2 under a clock rollback), and capture each stamp from that run's own `receipt:` line (line 261) rather than re-deriving it from the tag list.

**"A fourth deploy's `replaces:` names the third deploy's receipt" — this passes while the bug is present.** Trace it against the current code:

The third deploy in the existing sequence (`:127`) re-deploys `SHA2`, so its candidate tag name is `<stamp>-<sha7(SHA2)>` — byte-identical to the happy-path receipt's name if they share a second. The dedup loop at **lines 253–255 fires and sleeps a second**. So even with no Phase 2 at all, the record ends up `r1=T, r2=T, r3=T+1`. `r3` already has the strictly greatest stamp, `latest_receipt` is computed before the fourth deploy writes anything (line 218), and the assertion passes. It only catches the bug in the arrangement where a second boundary happens to fall between `r1` and `r2` — i.e. **its bug-detection is itself a coin flip**, which is the worst possible property for a regression test and is precisely the defect the last attempt shipped.

**Replace it with assertions that force the condition instead of hoping for it.** All deterministic:

- *Reader, malformed name:* plant an **annotated** tag `deployed/…/firestore-rules/not-a-stamp-abc1234` (sorts above every real receipt under refname) → must be ignored.
- *Reader, future lightweight:* plant a **lightweight** `29990101T000000Z-handmade` → must be ignored. Note `:177`'s existing hand-made tag is `19990101T…`, which sorts *below* everything and therefore proves nothing about ordering; only a future-stamped one tests it.
- *Predicate parity (revert item 3):* plant that same future **lightweight** tag and assert the writer **does not wait or refuse** on it, then plant a future **annotated** one and assert it **does**. `d43a171`'s `newest_stamp` did not filter on `objecttype` while `latest_receipt` did — one test, both directions, exactly the bug.
- *Writer, monotonic:* plant an annotated receipt stamped `now + 3s`, deploy, assert the new stamp is strictly greater. Deterministic, no sleep-and-pray.
- *Writer, refusal (Q1):* plant one stamped `now + 1h`, assert the new exit code, assert the message names the tag, and assert **firebase was never called** (the `assert_lacks … "argv="` idiom, as at `:101`).
- *Skew warning:* write an annotated receipt whose tag date is an hour past its stamp (`GIT_COMMITTER_DATE`), assert `--status` warns.
- *End-to-end `replaces:`:* capture each deploy's receipt from its own `receipt:` line and assert the next run's `replaces:` equals that exact string — not "the third one" by position.

**And a standing rule for this file, from the last failure:** never assert that two orderings agree. Under any tie both `git for-each-ref` sorts degenerate to refname and return identical output, so the assertion passes while the bug is present — that is exactly what `d43a171`'s "name order and date order agree" did. Assert on **values**: stamps, receipt names, the text of `replaces:`, the content of the printed diff.

---

## 6. What you missed

**Bytes: safe, with two conditions.** I traced it. `RECEIPT`/`RC` are consumed only at lines 218–231 (the `replaces:` line and the printed diff). The release at line 243 takes `$TMP` and `$SHA`; the predeploy hook re-checks against `TINKER_DEPLOY_SHA="$SHA"`. Receipt ordering cannot reach the payload. The two conditions:

- **Nothing new may be able to fail between line 243 and line 260.** `set -euo pipefail` is on (line 33); an unguarded failing command there aborts *after production changed*, with no receipt, no `$PENDING`, and no printed hand-write instructions. Phase 2 moving the wait pre-release is what makes this safe — the plan should say so explicitly as a constraint, not leave it as a happy consequence.
- **The new reservation must not touch `$TMP`** or anything the predeploy hook hashes.

**A harm the plan may have understated.** A wrong receipt doesn't only produce a wrong diff — it produces a wrong *decision not to deploy*. Line 125–126: if the mis-picked receipt happens to point at `MAIN_SHA`, `--status` prints "nothing to deploy" and the operator walks away from a change that never shipped. Silent, and no diff is displayed to contradict it.

**The existing receipt stays discoverable** — verified above. One caveat for the predicate: do **not** tighten it to require `by=deploy-rules.sh` in `%(contents)`. The real receipt says `by=seeded` and would vanish from the record.

**Two implementation traps that are the same *class* of bug as `d43a171`'s swallowed exit status** (revert item 2), worth pinning in the plan since the reader can no longer use `--count=1` once it has to filter:

- `local out="$(git for-each-ref …)"` swallows git's exit status — `local`/`declare` returns its own. It must be two statements: `local out` then `out="$(…)" || return 1`. And `git … | while read` puts the loop in a subshell, so the result never escapes; capture first, then iterate over a here-string (the here-string's own status no longer matters once the failure is already caught).
- `… | sort -r | head -1` under `pipefail`: `head` exits after one line and `sort` can take SIGPIPE, turning a correct read into a pipeline failure. Use `awk 'NR==1'`. Also set `LC_ALL=C` for the sort — BSD `sort` under a UTF-8 locale does not give you byte order, and byte order is what fixed-width stamp comparison assumes.

If you build a composite key rather than relying on `for-each-ref`'s multi-`--sort` (last key primary), emit `%(objecttype) %(creatordate:unix) %(refname:short)`, zero-pad the epoch to a fixed width, and sort the composite — that keeps the stamp unambiguously primary without depending on sort stability in BWK awk.

---

## Summary of requested changes

1. Keep the ordering key. Add: line 257's tag-creation failure must write `$PENDING`, like line 263 already does for push failure.
2. Replace the two-sort argmax comparison as the primary detector with the **stamp-vs-own-tag-date skew** check; drop or qualify the "self-clearing" claim (false under a future-dated tag); note the warning is inert in Phase 1.
3. Split Q1 three ways by the size of the gap; refuse **immediately** on a far-future stamp with a **new** exit code (19), an explicit override flag, and a `RULES-ROLLBACK.md` entry; check early, reserve late; relabel `at=`.
4. Ship Phase 1 and the stamp reservation together, or state in writing that `:127` stays flaky and must not be papered over with a `sleep`.
5. Drop the fourth-deploy `replaces:` assertion as specified (it passes with the bug present, via the line 253 dedup loop) and replace it with the planted-tag battery above; add the "never assert that two orderings agree" rule to the file.
6. Add the two conditions on the post-release window and the two bash/sort traps.

Grant read access to `~/tinker-ai-configs/thoughts/` and I'll do the full pass against the actual document — in particular the rest of the Open Questions, which I have not seen.
