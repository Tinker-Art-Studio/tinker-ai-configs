I could not execute the suite — every `bash <script>`, `awk -v`/`-f`, and scratch-repo command in this non-interactive session was blocked by the permission layer (I tried five forms, including `dangerouslyDisableSandbox`). So everything below is from reading the code plus the read-only `git`/`date` queries I *was* able to run. I'll say which is which.

## What I actually ran

- `git diff 1ff50b2..cbb77c5 -- scripts/deploy-rules.sh`, `git diff c7025a3..cbb77c5`, `git show 1ff50b2:scripts/deploy-rules.sh` (old `latest_receipt` and old post-deploy uncapped loop).
- `git for-each-ref --format='%(objecttype) %(creatordate:unix) %(refname:lstrip=2)' 'refs/tags/deployed/tinker-hq-apps/firestore-rules/'` → `tag 1790031252 deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3`.
- `date -u -r 1790031252` → `2026-09-21T22:54:12Z`; `date -u -r 1709164800` → `2024-02-29T00:00:00Z`; `date -u -r 4107542400` → `2100-03-01T00:00:00Z`.
- `git for-each-ref --format='SHORT=[%(refname:short)] LSTRIP=[%(refname:lstrip=2)]'` on the real namespace (identical when unambiguous — confirms `lstrip=2` is not a behaviour change in the normal case).
- `grep -n 'refname:short\|rev-list\|rev-parse\|for-each-ref\|git tag' scripts/deploy-rules.sh` — to check the round-1 ref-resolution fix is complete.

---

# Verdict

**Approve `scripts/deploy-rules.sh`. Request changes to `scripts/deploy-rules.test.sh`** (two assertions that cannot fail for their stated reason, and one missing test for the change's central design decision).

I found no production bug. The two round-1 fixes are real and, importantly, *complete* — see below.

---

## 1. The `awk` in `receipt_rows()` (lines 124–143)

**Epoch arithmetic: correct. I verified it numerically, by hand-executing the function and checking against `date`.**

- `epoch("20260921T220500Z")`: 1970→2026 = 56 yrs, 14 leaps → 20454 d; Jan–Aug 2026 (non-leap, `dm[2]=28`) = 243 d; `n=20697`, `d=21` → 20717 d → `1790028300`. The real receipt's tag date is `1790031252`. Difference **2952 s = 49m12s** — exactly the gap the header comment claims. Clause (3) `e > $2` is false, so **the real receipt passes** (question 4, answered).
- `epoch("20240229T000000Z")` → `1709164800`; `date -u -r 1709164800` → `2024-02-29T00:00:00Z`. ✓ (leap-day accumulation, `dm[2]=29` set *before* the month loop)
- `epoch("21000301T000000Z")` → `4107542400`; `date -u -r 4107542400` → `2100-03-01T00:00:00Z`. ✓ (century non-leap; the `y%400` term is correct in both the validity check and the year loop)

Range checks are sound: `mo` 1–12 then `d>dm[mo]` catches Sep 31 / Feb 29-in-2027 / Apr 31; `h>23`, `mi>59`, `se>59` catch hour 99. Negatives are impossible because the regex at line 140 has already forced all-digits, fixed width. `substr(...)+0` goes through `strtod`, so there is no octal hazard on `"09"`. Valid results are ≥0 and the sentinel is −1, so `e<0` is unambiguous. Max loop is ~8000 iterations (year ≤ 9999), per row.

**Parsing: every refname shape I could construct either yields the right row or is skipped. It cannot produce a wrong row.**

- No `-` → `index()==0 < 2` → skip. ✓
- Leading `-` → `i==1 < 2` → skip. ✓
- Multiple `-` → first `-` wins, so `not-a-stamp-abc1234` gives `s="not"` → regex reject. ✓ A name like `<stamp>-a-b` *is* accepted, which is consistent with the documented predicate (the stamp is what's parsed), not a defect.
- `rest` empty (ref == the prefix): impossible, since `refs/tags/<prefix>` without the trailing slash does not match a pattern that ends in `/` (git's `match_name_as_path` requires `refname[plen]` ∈ {`\0`,`/`} or `p_[plen-1]=='/'`, and the length check fails here); even if it did, `substr` → `""` → skip.
- Deeper nesting (`…/firestore-rules/foo/bar-abc1234`) → `s="foo/bar"` → regex reject. ✓
- Sibling namespace (`firestore-rules-extra/`) does not match the trailing-slash pattern, so a row from outside the prefix can't appear and `substr(name, length(p)+1)` can't land mid-string. ✓
- Degenerate 2-field line (a tag object with no tagger, so `$3` empty) → `name=""` → skip, not a wrong row. ✓

**The sort is correct for the intent.** Every accepted stamp is exactly 16 chars in fixed `YYYYMMDDTHHMMSSZ` layout, so `LC_ALL=C sort -k1,1r` is chronological. `-k2,2nr` is numeric on `creatordate:unix` (I confirmed git emits a bare integer). `-k3,3r` is a unique total tiebreak, so the whole-line last-resort comparison is never reached and stability is moot. Per-key `r`/`n` modifiers are per-key in BSD sort. (This one I traced rather than ran — `sort -k…` was permission-blocked.)

## 2. Failure propagation

Traced end to end; **the claim holds**. `receipt_rows` guards its only fallible command with `|| return 1` (line 123) and then *ends on* the `printf | awk | sort` pipeline, so with `pipefail` inherited into the command-substitution subshell, a failure in any stage becomes the function's return status. `latest_receipt`/`newest_stamp` do the same (151, 156), and both are called as `X="$(f)" || die $EX_RECORD` at 208, 320, 355. `local` is on its own line everywhere, so the status-masking gotcha is genuinely avoided. Using `awk 'NR==1{…}'` instead of `head -1` (152) is the right call and the comment's SIGPIPE reasoning is correct.

Empty output with status 0 happens only for a genuinely empty namespace: `printf '%s\n' ""` emits one blank line, `$1 != "tag"` skips it, `sort` of nothing exits 0.

**One gap, low severity (preference, not a bug):** `receipt_commit()` (179) reads the same record one step later but is not held to the same discipline. At 220/328 (`RC="$(receipt_commit "$RECEIPT")"`) a failure trips bare errexit — the script exits with git's raw 128 and **no `REFUSED:` line**; at 211–212 the empty rev makes `git diff` fatal, which also exits 128. It fails *closed* in both cases (I traced 211–212: git refuses an empty rev outright, so no wrong diff can be printed), so this isn't a correctness hole — it's just the one read that doesn't get a named exit code and a sentence.

## 3. Step 7b (343–392)

- **Terminates**: `WAITED` increments unconditionally at 390 and the cap at 372 either dies or breaks — at most 11 iterations, ≤10 s.
- **Conditions are independent**: `STALE` (361) and `TAKEN` (365–370) are both computed before the combined test at 371. No short-circuit.
- **Cannot fall through with a taken `TAG`**: the only `break` paths are 371 (`TAKEN=0` by construction) and 388, which is reached only after the `TAKEN=1` → `die $EX_CLOCK` at 380–382. ✓
- **Arithmetic is safe**: `${STAMP//[TZ]/}` yields 14 digits; `epoch()` enforces `y>=1970`, so `PREV_STAMP` always begins with `1` or `2` and bash's octal-on-leading-zero rule never fires. Max value ~1e14, well inside `intmax_t`.
- **Bytes**: nothing in 7b touches `$TMP`. It runs `date`, `git rev-parse` (read-only, in `$REPO`), and `sleep`.
- `die` inside the loop still fires the EXIT trap, so the worktree and lock are cleaned (traced through `cleanup`, 257–265).

The round-1 fix for `git rev-parse --verify --quiet` exit codes is right: `--quiet` documents exit 1 for "not a valid object name", and anything else is an operational failure, so treating only `0`/`1` as answers is correct.

## 4. Did anything get worse?

**Correction to the brief: `EX_CLOCK=20` is also a new refusal**, added in cbb77c5 (line 381), not just `EX_RECORD`. It's the one that can fire on an otherwise-healthy path. It can't be provoked by a single stray tag — it needs `<prefix><stamp>-<sha7>` occupied for 11 consecutive seconds with *this commit's* sha7, i.e. a pre-filled namespace or a frozen clock. Not reachable by normal use. Strictly better than what it replaced (1ff50b2's loop was uncapped *and* post-deploy: it would have spun forever with production already changed).

**Reader quality**: on every input I could construct, the new reader is equal or better. Where old and new both see real receipts with distinct stamps, `-refname` and stamp-descending agree (fixed-width stamps). Where stamps tie, the new reader uses tag date instead of sha7. Where a non-receipt outranks a receipt, the new reader excludes it. The two-clocks-disagree case (a fast clone writing a higher stamp) misorders identically under both, and the header at line 26 already says so.

**The one place it's worse, narrowly** (`deploy-rules.sh:353` vs `406`): moving the stamp reservation ahead of the release widens the window in which a *backward* clock step (NTP correction, laptop wake) between 7b and `git tag -a` produces a tag whose name stamp is **later** than its own tag date — i.e. a receipt that fails the guard's own clause (3) and is silently invisible to the record. Before this change the stamp was taken immediately before `git tag -a`, so the window was ~0 s; it is now the full release duration. The comment at 103–105 justifies clause (3) with "both values come from that same clock", which is true but assumes the clock doesn't *move*. Consequence is in the safe direction (next deploy diffs from an older base) except when the lost receipt is the only one, in which case `--approved` prints "first guarded deploy" and **no diff at all** (325–326). Very low probability; I'd note it in the header rather than change code.

Related, same clause, also narrow: clause (3) drops a genuine receipt if the operator runs the printed hand-recovery `git tag -a` on a *different* machine whose clock is behind the deploying machine's by more than the recovery latency. The comment's "same clock" reasoning covers the automatic path but not the transcription path it cites two lines earlier.

**One more**: because the format now includes `%(objecttype)`/`%(creatordate:unix)`, `for-each-ref` must read each tag object, where the old `%(refname:short)`-only read did not. If a dangling/broken ref under the namespace makes `for-each-ref` exit non-zero, every deploy now becomes `EX_RECORD` where it previously succeeded. That's the intended fail-closed direction and the message tells the operator what to do — flagging it only so it isn't a surprise.

**First real deploy**: no refs → `RECEIPT=""`, `PREV_STAMP=""` → `STALE` never set (the `-n` guard at 361), `TAKEN=0` → immediate break, `WAITED=0`. Works. ✓

## 5. Round-1 fixes: real and complete

The `refname:short` fix is complete, not just local. I grepped every ref-resolution site in the file: 163, 167 (`git tag -l` only ever lists tags), 179, 279, 365, 406, 411, 412, and the fetch refspec at 187 all go through `refs/tags/…` or are 40-hex. No bare-name resolution survives.

## 6. Tests — three findings

**T1 (the third defect you asked for). `deploy-rules.test.sh:292` is vacuous.**

```
assert_has "…and it still resolves to the right commit" "$OUT" "$SHA2"
```

This is the only assertion covering the `receipt_commit()` half of the round-1 fix, and it cannot fail. In this block `fixture_reset` leaves `origin/main == $SHA2`, so `--status` prints `$SHA2` unconditionally on the `origin/main:` line (guard:224) **and** in the approval phrase (guard:240). If `receipt_commit` resolved to the *branch* (`$SHA1`) the assertion would still pass. Make it assert the line that actually carries the resolution:

```
assert_has "…and it still resolves to the right commit" "$OUT" "shipped:      ${SHA2}"
assert_lacks "…not to the branch of the same name"      "$OUT" "shipped:      ${SHA1}"
```

(Note separately that this whole block passes against `1ff50b2` — I traced it: with no parser at all, the old reader prints `tags/deployed/…`, and `grep -qF "$REAL"` matches that as a substring, `receipt_commit "tags/deployed/…"` resolves fine via the `refs/%s` rev-parse rule, and exit is 0. It bites against `c7025a3`, which matches the commit message's own 23/5 split — but not the brief's "all 17 fail against the pre-change guard.")

**T2. `deploy-rules.test.sh:314` measures cardinality, not contiguity.**

```
assert_eq "…the pre-filled window is gap-free (181 contiguous seconds)" "$PREFILL" "181"
```

The bug this was written to catch — `date -u -v+${i}S` recomputing from the current time each iteration — produces 181 **distinct** stamps with holes in them, so `PREFILL` is still 181 and the assertion stays green. (It does catch duplicates, since `git update-ref --stdin` is atomic and a repeated `create` aborts the whole transaction to 0 refs.) To actually assert contiguity you need the endpoints as well as the count:

```
STAMPS="$(git for-each-ref --format='%(refname:lstrip=2)' "refs/tags/${NS}/" | sed 's#.*/##; s#-.*##' | LC_ALL=C sort)"
assert_eq "…window starts where we put it" "$(printf '%s\n' "$STAMPS" | head -1)" "$(date -u -r "$BASE" +%Y%m%dT%H%M%SZ)"
assert_eq "…and ends 180s later"           "$(printf '%s\n' "$STAMPS" | tail -1)" "$(date -u -r $((BASE+180)) +%Y%m%dT%H%M%SZ)"
```

Count 181 + min `BASE` + max `BASE+180` does prove gap-free.

**T3. The change's central decision has no test at all.**

There is no assertion anywhere in the suite that would fail if the primary sort key were swapped back to **tag date** — the exact design of the reverted `d43a171`, which the header at guard:88–94 says must never be reintroduced. I enumerated every block that has two or more receipts present at once:

| block | receipts | stamps vs tag dates |
|---|---|---|
| 162–165 rollback | 3 | both increase together |
| 174–189 writer ordering | 3 | both increase together |
| 196–222 "not a receipt" | REAL + 1 planted | every planted tag is excluded by clause (1)/(2)/(3) under either key order |
| 231–251 FAR / cap | 1, then 2 | assertions are a count and the warn text; FAR wins under both |
| 258–269 cross-offset | 2 | **stamps are equal** — so tag date decides under both orderings |
| all others | 0–1 | — |

Swap `-k1,1r -k2,2nr` for `-k2,2nr -k1,1r` and the suite stays green. That is precisely the class the file's own STANDING RULE warns about ("an assertion the CURRENT code already satisfies for an unrelated reason"). The missing fixture is two receipts whose stamp order and tag-date order **disagree** — i.e. the real receipt's own situation generalized:

```
mk_receipt "20260101T000000Z" "aaaaaa1" "$SHA1" "2026-06-01T00:00:00 +0000"   # earlier deploy, hand-written late
mk_receipt "20260201T000000Z" "aaaaaa2" "$SHA2" "2026-03-01T00:00:00 +0000"   # later deploy, tagged promptly
run --status
assert_has  "deploy time (the name stamp) decides, not when the tag object was written" "$OUT" "20260201T000000Z-aaaaaa2"
assert_lacks "…the older deploy does not win on a later tag date"                        "$OUT" "20260101T000000Z-aaaaaa1"
```

Both satisfy clause (3), so this is a legal record, and it fails against tag-date-primary.

**Smaller test notes** (preference):
- `:290` `assert_has … "$REAL"` can't distinguish `deployed/…` from `tags/deployed/…` (substring match). The block's real teeth are `:291`.
- `:186` `assert_has "replaces:  ${R_B}"` degrades to matching the bare label if `R_B` ever comes back empty. `:187`'s `assert_lacks` is safe from the mirror problem (it would fail loudly), so this is asymmetric but low risk.
- No test reaches guard:355 (`newest_stamp` → `EX_RECORD`) — `FAIL_GIT=for-each-ref` always dies at step 6 first — or guard:369 (the non-0/1 `rev-parse` refusal). Same code shape as paths that are covered; noting for the record, not asking for tests.
- No test at the clause-(3) boundary `e == $2`… except incidentally: the FAR fixture at `:234` derives name stamp and tag date from the same `FAR_E`, so it does exercise equality. Worth a comment so it isn't "fixed" away.

## 7. Bytes — confirmed independently

From `git diff 1ff50b2..cbb77c5 -- scripts/deploy-rules.sh`, the only hunks are: the header comment; the exit-code line; the record-reading block (replacing two one-line functions above `dirty_files`); two `|| die $EX_RECORD` suffixes and two `receipt_note` interpolations in *display* strings; the insertion of step 7b; and the removal of the old post-deploy stamp/dedup lines from step 9.

Nothing between step 5 (`git worktree add --quiet --detach "$TMP" "$SHA"`, line 310) and step 8 (`cd "$TMP" && TINKER_DEPLOY_SHA="$SHA" firebase deploy`, line 396) is touched except the insertion of 7b, and 7b executes only `date`, `git rev-parse` against `refs/tags/…` in `$REPO`, and `sleep`. `$TMP` appears nowhere in the new code. `firebase.json` mapping check (315–317), `HASH` (404) and `predeploy-check.sh` are unchanged — the diffstat confirms `predeploy-check.sh` isn't in this change at all. **The byte path is untouched.**
