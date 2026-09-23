I read all six inputs, inspected the real receipt object directly, and verified git's date-format behaviour on this machine.

# Verdict: request changes

The scope reduction is the right call and most of v4 is correct. Rule 3 is genuinely elegant **on the reader side** — it collapses the far-future-tag-wins-forever defect, the three-way split, the cap, the override flag and impossible stamps into one predicate, and I could not break it there beyond the cost the plan already states. But rule 3 is also silently applied to the **writer**, where it falsifies the plan's own monotonicity invariant; and there is a verified date-formatting trap in the tag-date key that a single-timezone harness cannot catch — the same "correct-looking, test-passing, modelled wrong" species that killed both previous attempts.

---

## What I actually verified (not asserted)

- **The real receipt.** `git for-each-ref refs/tags/deployed/` → exactly one ref, `objecttype=tag`, `creatordate` `2026-09-21T16:54:12-06:00` = **22:54:12Z**, name stamp `20260921T220500Z`, body `… at=20260921T220500Z by=seeded — this receipt was written by hand …`. Skew 49m12s. Stamp is in the past (now is `20260922T183951Z`). It is annotated, its stamp range-checks, it is not future, its `at=` matches its name → passes the predicate, passes R1, unique max. **Stays discoverable; does not block the first real deploy.** ✅
- **`for-each-ref` patterns.** `refs/tags/deployed/*` → **no output** here; the prefix form matches. Confirms the constraint. ✅
- **R1 cannot misfire on a script-written receipt.** `deploy-rules.sh:249–256`: `STAMP` is assigned, `TAG` built from it, and *both* recomputed together inside the dedup loop (`:254`); `MSG` at `:256` takes `at=${STAMP}` from the same variable. There is no path where the name stamp and `at=` diverge. ✅ (But see F5 — that guarantee is narrower than the plan's claim.)
- **Bytes.** `RECEIPT`/`RC` are consumed only at `:106–134` and `:218–231`. `:243` references `$TMP`, `$SHA`, `$TARGET`, `$PROJECT` and nothing else. Moving `HASH` from `:248` to pre-release does not change its relationship to the tests (both are after `:236`), so it does not change what is hashed. Receipt ordering cannot reach the payload. ✅
- **The creatordate trap** — see B2, this is empirical and it is the one that worries me most.

---

## BLOCKING

### B1 — Rule 3 must not be applied to the writer. It breaks the plan's own invariant, and the stated meaning of a non-terminating wait is backwards.

*(plan 71–83, 150–151, 166–167)*

Plan 150–151: "A new receipt must be strictly newer by stamp than **every receipt recorded for this target** … That is what makes the primary key monotonic." Rule 3 silently narrows that quantifier to *every currently-non-future receipt*. The consequence:

A tag stamped `T+1` exists (another clone's receipt, arriving via the fetch at `:169`/`:85`, written by a machine whose clock is one second fast). At time `T` it is future → **not a receipt** → excluded from `PREV_STAMP`. The writer reserves `T`, writes its receipt, and one second later the excluded tag becomes a receipt with a **higher** stamp than the one this run just wrote. The record is now permanently out of order, and F3 — the only thing that named the condition — has gone quiet, because the tag is no longer future.

This is not exotic. It needs two machines whose clocks differ by one second. Rule 3 has **no epsilon**, and the plan's Part 1 argument is precisely that the stamp is written by *some other* clock, not observed by the reader's.

Plan 79–81 also states the termination argument's corollary wrongly:

> "A wait that doesn't terminate now means a genuinely stopped or backwards clock."

A backwards clock **cannot** make the wait fail to terminate. Each iteration resamples `now`; `PREV = max{valid stamps ≤ now}` shrinks when `now` shrinks, so `PREV ≤ STAMP` always and the loop exits *faster*. Only an exactly-frozen clock (with a receipt at that same second) loops. So EX_CLOCK is reachable only for a stopped clock, and a backwards clock — the case the plan names — produces a silently mis-ordered record instead of the "real, reportable fault" the plan promises. Plan 166–167 inherits the same error.

**Required.** Keep rule 3 for the reader; the writer's monotonicity comparison must run over **all annotated tags with a well-formed stamp**, future included. To keep it from trapping (which is what rule 3 was protecting against): wait at most a few seconds for `now` to exceed the max; if it still doesn't, **print a fact** naming that tag and stating that this run's receipt will sort below it, and proceed. That terminates always, cannot brick, closes the realistic one-second case completely, and degrades a year-2999 tag to one printed line. It is strictly *smaller* than v3's three-way split — no cap semantics, no override flag, no refusal — so it does not reintroduce the deferred machinery.

### B2 — The tag-date key is specified in a way whose natural implementation is wrong, and untestable in this harness. Verified.

*(plan 50–59 key 2; plan 118's F1 example)*

Measured on the real receipt, this machine:

```
%(creatordate:format:%Y%m%dT%H%M%SZ)            → 20260921T165412Z   ← WRONG (tagger-local, wearing a Z)
TZ=UTC %(creatordate:format-local:%Y%m%dT%H%M%SZ) → 20260921T225412Z   ← correct
%(creatordate:unix)                              → 1790031252         ← correct, TZ-free
```

`format:` renders in **the tag author's** offset and appends your literal `Z`. Two consequences:

1. **F1 prints a false time to Christie on day one.** Plan 118's own example says `tag written 22:54:12Z`. The obvious spelling produces `16:54:12Z`. F1 exists to "turn an invisible model assumption into something a human can check" — a wrong timestamp labelled UTC defeats exactly that.
2. **The ordering key inverts across differently-offset clones.** A tag written at `2026-09-22T00:00:00 +0000` renders `20260922T000000Z`; a tag written one hour *later* at `2026-09-22T01:00:00 -0600` renders `20260921T190000Z` and sorts below it. Christie's machine is `-0600`; anything running in UTC is not.

And the vacuity: **a single-timezone harness cannot detect this.** Every fixture receipt gets the same offset, so the ordering stays correct and only the display is wrong — and the display is not currently asserted on. This is a fourth vacuous assertion waiting to happen, in the key that four reviewers endorsed.

**Required.** Pin `%(creatordate:unix)` (numeric, absolute) as the tie-break key, compared numerically in awk; render F1's display from `TZ=UTC` + `format-local` or from the unix value. Add a test with two receipts at the same name stamp whose tag objects carry **different UTC offsets** (`GIT_COMMITTER_DATE='2026-09-21T22:54:12 +0000'` vs `'2026-09-21T16:54:12 -0600'` is the same instant; construct a pair where the later instant has the westward offset) and assert both the order and the printed time.

### B3 — Phase 2 row 2 attaches a post-release remedy to what is now a pre-release write.

*(plan 208–212)*

Row 1 moves the marker's contents pre-release ("post-release is one `mv` of a pre-written temp file"). Row 2 then guards the write with `|| { print the full hand-write instructions; exit $EX_RECEIPT; }` — which is `:258–259`'s message, **"DEPLOY SUCCEEDED; RECEIPT NOT WRITTEN. Production is now …"**.

If the disk is full — the exact correlated failure row 2 is written for — that now fires *before* `firebase` is called, and tells a non-technical operator that production changed when nothing was deployed. Round 2's fix moved the defect rather than removing it.

**Required.** Two distinct guards. Pre-release: a plain refusal ("could not prepare the receipt marker; nothing was deployed") under a pre-release code, before step 8. Post-release: the `mv` failure keeps row 2's hand-write remedy and EX_RECEIPT.

### B4 — Phase 2 never clears the marker on the success path, and has no negative assertion for it.

*(plan 204–235, 281–283)*

The marker is published immediately after Firebase returns. Nothing in the plan removes it when the tag and push then succeed. Every ordinary deploy would therefore leave an "unrecorded deploy" marker, and the next run would hit the idempotent branch ("tag exists and matches → treat as recovered, clear the marker") and **announce a recovery that never happened**, on every other run. Not a deadlock — the idempotent branch saves it — but it is noise above the diff Christie reads, permanently.

The battery adds negative assertions for every Phase 1 check (plan 278–280) and none for Phase 2. **Required:** clear the marker at `:268`'s success point, and assert "a successful deploy leaves no marker" and "the following run reports no recovery".

### B5 — R1 is unmisfireable only for receipts that *have* an `at=`. The missing-`at=` case is unspecified, and the natural implementation bricks.

*(plan 131–139)*

R1 is defined as "the winner's `at=` field disagrees with its own name stamp." A hand-written receipt with **no** `at=` at all — `git tag -a NAME SHA` with a message the operator typed themselves, which is the same sloppy-human model R1 is built on — yields an empty `$AT`. The natural coding (`[ "$AT" != "$STAMP" ] && die $EX_RECORD_CORRUPT`) refuses. That permanently blocks `--approved` on a record containing such a tag, and the plan's only documented exit (`RULES-ROLLBACK.md`) is explicitly deferred at 302–304. That is H1's failure shape reappearing in the one refusal v4 kept.

Three required pins:
- **Missing `at=` is F3 territory, not R1.** Only a *present and contradicting* `at=` refuses.
- **R1's message must state that a tag failing R1 is, by R1's own logic, not a receipt**, and carry the literal `git tag -d …` / `git push origin --delete …` commands. Without this, R1 is a refusal with no exit — and note that a corrupt tag with a *future* stamp is excluded by rule 3, so it sits invisible until the moment it becomes past and bricks `--approved` at an arbitrary later time.
- **Parse `at=` as an anchored field**, not "the first `\d{8}T\d{6}Z` in the body" — Phase 2 adds `recovered=<stamp>` to the same message (plan 219).

Minor but related: R1 refuses on `--approved` and `--diff` but not `--status`, so the operator's next move after a refusal is the one mode that will cheerfully print the corrupt tag as "last receipt". Either `--status` reports it loudly or say why not.

### B6 — `--status` still prints conclusions the evidence doesn't support. This is the part of the deferral I think went too far.

*(plan 7–9 vs 122–130; script `:125–133`)*

You asked me to answer honestly rather than re-propose the refusal machinery, so: **deferring the refusals is defensible; continuing to print an unqualified conclusion is not, and fixing it costs wording only.**

Under F2 or F3, `--status` still prints one of `:126` `"state: origin/main is what shipped last — nothing to deploy"`, `:128` `"… nothing to deploy for firestore:rules"`, or `:130` `"… is AHEAD of the last receipt"`. These are the plan's Goal violation in miniature: a guess presented as a fact, with a qualifying line elsewhere in the output. And `"nothing to deploy"` is the single output whose correct reading is *stop* — the plan itself names it as the silent harm at 43–45.

For `--diff` and `--approved` I accept report-and-proceed: the diff is printed, the bytes are unaffected, and F2 names the other candidate so a human can ask for it. For `--status`, the conclusion line must be made conditional when F2 or F3 holds — e.g. *"depending on which of two equally recent receipts is right: either nothing to deploy, or 3 commits touching firestore.rules."* No refusal, no flag, no threshold.

### B7 — "every ref excluded" collapses into "no receipt yet", and `--diff` then prints the whole file.

*(plan 127–130; script `:108`, `:115–116`, `:223–224`)*

Rule 3 plus the lightweight/malformed exclusions can empty the receipt set while the namespace is non-empty. v4 routes that into the existing empty-record path, so `--diff` runs `git show "${MAIN_SHA}:${FILE}"` — roughly a thousand lines of rules — with one F3 line above it, and `--approved` prints "the whole file is new to the record". That is the exact output shape the revert commit condemns d43a171 for producing.

**Required.** "No refs at all" and "refs exist, none is usable" are different states and must print differently. The second should say so in the header line that replaces `replaces:`, not only in an F3 line further up.

### B8 — Two round-2 items are dropped rather than fixed.

- **Codex #6** (the Phase 2 scenario "deploy A with the tag failing, deploy B, recover A" is unreachable in one clone, because the marker is reconciled before any next deploy) is simply absent from v4. The battery at 281–283 avoids the impossible sequence by not testing it — which is not the same as resolving it.
- The plan's own Tests preamble (243–244) promises the fix Claude round 2 demanded: *"assert A's receipt exists with A's original stamp **and sorts before B's**."* The battery at 281–283 asserts only the original stamp. **The ordering half — the part that makes this a Phase 2 test rather than a marker test — is not in the battery, and it needs a constructed record/marker state to be reachable at all.**

---

## Vacuous or mislabelled assertions (you asked specifically)

Walking the battery at 258–283 against the current code:

| Case | Forced today? |
|---|---|
| Three back-to-back deploys, strictly increasing, three distinct shas (259–262) | **Yes.** Old writer: no name collision → no sleep → `C, C, C`. New writer: monotonicity fails → fake sleep → `C, C+1, C+2`. Correctly reasoned, including why distinct shas matter. ✅ |
| Delayed hand-recovery (263–265) | Labelled as F1, not ordering. ✅ Round-2 5b addressed. |
| R1 (266) | Yes. ✅ (but only `--approved` is listed; `--diff` refuses too per 133) |
| Predicate exclusions (267–269) | Yes — I checked the byte order: `not-a-stamp-…`, `20269999T999999Z` and `20260921T990000Z` all out-sort `20260921T220500Z` under `-refname`, so today's reader names each of them. ✅ |
| **Predicate parity — future lightweight tag, "the writer must not wait or refuse" (270–271)** | **No.** Today's writer's only wait is the exact-name collision at `:253`, and `…/29990101T000000Z-light` never collides with `<now>-<sha7>`. Today's writer doesn't wait either. This passes while the bug is present — it is a **regression pin against d43a171**, which is already reverted and not in the tree. Label it as such; it should not be counted among "every case forced, none hoped for". |
| F2 both directions (272–273) | Loud half yes; "deploy proceeds" half passes today. ✅ net |
| Failed ref read → EX_RECORD_READ (274) | Yes — today `RECEIPT="$(latest_receipt)"` at `:106` propagates git's own status under `set -e`, so the *code* and the *sentence* are both new. ✅ |
| **Synthesized real-receipt shape (275–277)** | **"Still named as what shipped last" passes today** (single receipt, trivially named), and "nothing warns" is trivially true because v4 has no skew detector. It is a worthwhile pin against an implementer who requires `by=deploy-rules.sh` — but it is a pin, not a forced case. Label it. |
| Negative assertions (278–280) | Good, and the `run()`-captures-stderr note is right. ✅ |
| Phase 2 (281–283) | See B4 and B8. |

Two more test-harness pins:

- **The fake `date`'s interception rule is stated by flag class, and `:149` defeats it.** Plan 250–252 says the fake intercepts "`date -u +%Y%m%dT%H%M%SZ` with no other flags" and delegates "-v/-j/-f/-r". `:149` is `date -u +%Y-%m-%dT%H:%M:%SZ` — also `-u`, also no `-v/-j/-f/-r`, different format. Pin **exact argv match**, and state that `date` is pure (only the fake `sleep` advances the counter), or the lock-owner line perturbs the controlled clock on every `--approved`.
- **"Strictly increasing" must be an ordered comparison**, not `sort -u | wc -l` — distinctness is not order, and `sort -u | wc -l` is exactly the shape d43a171 reached for in the assertion that had to be reverted.

---

## What v4 did fix (checked item by item)

Round-2 Claude blocking 1–3 and 6: H2 dropped entirely (correct — the anti-correlation table at plan 28–30 is right), `at=` promoted to R1, the undetectability statement made explicit at 140–145, H1 replaced by F2 with the same-commit narrowing, EX_RECORD split into `EX_RECORD_READ`/`EX_RECORD_CORRUPT`. Should-fix 7–17 all land: rule 3 subsumes 7/8; the SIGPIPE/`LC_ALL=C`/`local`-masking/errexit-inside-`||` traps are all restored at 96–109; the arithmetic range check at 86–90 is a **better** answer than my round-2 round-trip proposal (it avoids BSD strptime entirely, and admitting `20260229` is genuinely harmless for ordering); negative assertions added; reservation sequencing pinned including ":253's loop **moves**"; stdout not stderr; the `C, C, C+1` correction; the Goal narrowed. Codex 1, 2, 3, 7 land; Codex 5's hash-ordering contradiction is resolved. Round-2 Codex 4's "report vs refuse" is knowingly reversed by the scope decision, which is stated rather than hidden — that is the right way to defer.

Three smaller gaps worth fixing while you're in there:

- **S1** — pin the temp file for the atomic marker to the **same directory as the marker** (the git dir). `$TMPDIR` is a different filesystem, so `mv` becomes copy+unlink and Codex's "partially written marker" case comes back; with same-directory rename it is genuinely excluded and the plan can say so. Deterministic temp name, removed in `cleanup()`.
- **S2** — the shape check must run *before* the arithmetic range check (awk `substr` on a short string yields garbage), and an annotated tag with an empty `creatordate` needs a defined tie-break value rather than an empty awk field.
- **S3** — plan 154–155 says the reservation "must not `cd` into or touch `$TMP`" while 161–163 says to compute `HASH` there, which reads `$TMP/$FILE`. Say reading is permitted. Also pin whether the health pass sits before `:206` (worktree creation) — "before the tests" allows either.
- **S4** — observation, not a defect: F2's quiet branch is unreachable from script-written receipts. Same stamp + same commit ⇒ same sha7 ⇒ same tag name ⇒ one ref. So F2's loud branch is the *only* one the script can produce, and only across clones. That strengthens the "proceed" decision (no local action created the ambiguity) — say it — and the quiet-branch test must be built from hand-made tags whose sha7 doesn't match their target.

---

## On your question 4, plainly

The deferral of refusal is defensible. F2 and F3 cannot brick, they name the condition, and for `--diff`/`--approved` the operator gets the diff plus the names of what else it could have been — and the bytes are unaffected either way. I would ship that.

What is not defensible at any scope is `--status` continuing to state a conclusion the guard knows may be unfounded (B6), and `--diff` degrading to a full-file dump under F3 without saying that is what happened (B7). Both are wording-level; neither needs a flag, a threshold or a refusal. Fix those and "report, don't refuse" holds up.

## On question 1, summarised

Rule 3 survives on the reader: I could not find a case where excluding future-stamped refs names a *wrong* receipt durably — a small forward skew gives a transient wrong answer for the duration of the skew, with F3 visible, and it self-heals. There is no bootstrapping problem. "Valid stamp ≤ now" holds inside one awk pass with one sampled `now`; it does **not** hold across the health pass and the reservation, nor across a `--diff` run and a later `--approved` — so a tag that was future and F3-reported during `--diff` can be silently the winner during `--approved`. That seam is worth one sentence in the plan.

The failure is on the writer (B1), and the fix is narrow.
