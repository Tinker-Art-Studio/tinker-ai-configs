codex
## Verdict: request changes

V3 fixes several earlier objections, but the core safety claim still does not hold. There are records where the guard confidently chooses the wrong receipt and H1–H4 all remain silent. Phase 2 also contains an implementation contradiction and lacks a crash-safe, idempotent recovery protocol.

### Blocking findings

1. **Wrong — H2’s motivating example is mathematically inconsistent.**

At [PLAN-v3.txt:112](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:112>), A ships at 22:05, B at 22:15, and A is manually recovered at 22:54 using a “fresh date.” The plan claims both:

- A gets a later name stamp and therefore beats B.
- H2 observes 49 minutes of stamp-to-tag-date skew.

Those cannot both be true. If the operator uses 22:54 in A’s tag name, its tag date is also about 22:54, so skew is approximately zero and H2 does not fire. If A retains its original 22:05 name stamp, it has 49 minutes of skew—but B’s 22:15 stamp correctly wins.

A concrete silent-wrong record:

- A actually ships at 22:05.
- B ships last at 22:15.
- A is manually recorded at 22:16 with a fresh 22:16 name stamp, tag date, and matching `at=`.
- At 22:17, A has the unique maximum stamp and is selected, although B shipped last.
- H1: no tie.
- H2: near-zero skew.
- H3: not future.
- H4: valid annotated tag.
- `at=` agrees.

This remains reachable for historical receipts and whenever the proposed marker cannot be written. The record-health model therefore does not satisfy the goal at lines 8–10.

H2’s ten-minute threshold is also not justified by evidence. A legitimate Firebase invocation lasting eleven minutes produces a false warning. That is tolerable as a warning, but “the skew equals release duration” does not establish that ten minutes separates manual recovery from a legitimate release.

2. **Wrong — invalid calendar timestamps still pass the receipt predicate.**

[PLAN-v3.txt:56](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:56>) validates only the shape `^[0-9]{8}T[0-9]{6}Z$`. The prior Codex review explicitly identified impossible timestamps, but v3 does not address them.

For example, an annotated receipt named with `20260921T990000Z`:

- passes the stated predicate;
- can be the unique lexicographic maximum;
- is no longer “future” on September 22, so H3 need not fire;
- is not H4 because its shape matches;
- cannot be meaningfully evaluated by H2 unless parsing failure behavior is specified.

The reader can therefore select an invalid receipt with no defined finding. The predicate needs real UTC validation with a round-trip check; invalid calendar values should be classified as excluded/corrupt and fail the approval path.

3. **Wrong — H1 can permanently brick the only deploy path.**

[PLAN-v3.txt:97](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:97>) refuses every `--approved` run when the maximum stamp has multiple candidates. A realistic two-clone same-second collision therefore refuses forever:

- time passing does not change the maximum stamp;
- the refusal prevents writing a newer receipt that could supersede the tie;
- receipts are immutable;
- the H3 override does not apply to H1.

The plan explicitly recognizes this permanent-bricking problem for future stamps, but recreates it for same-stamp collisions. H1 needs an explicit break-glass path that shows all candidates, requires deliberate acknowledgement, and permits a newer receipt to supersede the ambiguous maximum. Alternatively, the plan must define a safe record-repair procedure.

4. **Wrong — H4 warns while permitting use of a knowingly incomplete record.**

At [PLAN-v3.txt:106](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:106>), H4 means a malformed or lightweight ref may be the record of a real newer deploy, yet `--approved` merely warns and continues diffing from an older receipt.

That directly contradicts lines 8–10. A recovery tag accidentally created without `-a` could describe the actual latest deploy; the guard would warn and then deploy using a base it knows may be wrong.

Similarly, the proposed `at=` cross-check at lines 120–123 has no specified finding, exit behavior, or test. “Nothing about it should be trusted” requires an explicit refusal, not an unimplemented observation.

Warnings are especially insufficient during `--approved`: the operator has already supplied the approved SHA, and the script does not pause for a fresh confirmation after printing the warning.

5. **Wrong — Phase 2 cannot write the promised marker “ahead of the shasum.”**

The marker supposedly contains `sha256` at [PLAN-v3.txt:220](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:220>), but lines 233–236 require it to be the first operation after Firebase, ahead of calculating that hash. Both cannot be implemented.

Compute the hash and complete marker contents before Firebase, without modifying `$TMP`; then atomically publish the marker with a temporary file plus rename immediately after Firebase returns success.

The recovery state machine also needs to cover crashes at every boundary:

- marker written, tag absent;
- tag already exists locally, marker remains;
- tag already exists remotely, marker remains;
- push failed while the unrecorded marker still exists;
- malformed or partially written marker;
- marker fields do not match the commit’s target file and SHA-256.

Without these cases, a rerun may attempt to recreate an existing tag and refuse, or a corrupt/stale marker may fabricate a receipt. Faithful auto-recovery is reasonable if all fields are validated and recovery is idempotent. The second marker file is a sound design preference; overloading the legacy `$PENDING` format would be worse.

The marker still cannot completely remove the original loss window: the marker write itself may fail or the process may die immediately after Firebase succeeds. This is particularly important because disk or permission failure can break both `git tag` and a marker written in the same git directory. V3 must narrow its guarantee rather than claim Phase 2 “removes the cause.”

6. **Wrong — one Phase 2 test scenario is impossible in the stated single-clone flow.**

[PLAN-v3.txt:305](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:305>) proposes:

1. Deploy A; tag write fails.
2. Deploy B normally.
3. Recover A.

But the new marker is explicitly reconciled before any next deploy. In the same clone, the B run must recover A first; there is no later A recovery.

This test needs either:

- a real two-clone fixture, where B does not see A’s local marker; or
- a deliberately constructed record/marker state that models that sequence.

As written, an implementation could not follow both the recovery protocol and the test.

7. **Wrong — the cross-clone limitation is acknowledged but not “made visible.”**

V3 correctly withdraws cross-clone correctness, but line 15 still says ambiguity is made visible. Counterexample:

- A reserves 10:00:00, finishes last at 10:05.
- B reserves 10:00:01, finishes first at 10:02.
- Production contains A; stamp ordering selects B.
- Both are valid, unique-stamped annotated receipts with skew under ten minutes.

No H1–H4 finding fires. If cross-clone serialization remains out of scope, the header must say cross-clone misordering can be completely undetectable—not merely unknowable but visible.

### Ordering key

The `(name stamp, tag date, refname)` ordering is still the best available deterministic order, and it does not reintroduce `d43a171`’s date-primary defect.

There is no inconsistency in sorting tied records deterministically and then refusing to treat that tie winner as evidence. However, `--status` and especially `--diff` must not label the tag-date winner “what shipped last” or print an authoritative diff under H1. They should report the candidate set and refuse the diff operation.

### Check early, reserve late

The basic placement is correct: reserving immediately before Firebase removes the post-deploy sleep from current lines 247–255 and does not affect payload bytes.

The late reservation must re-read record state rather than relying solely on the earlier feasibility result. Post-deploy operations then need the durable marker protocol above. The marker must remain until tag creation and publication are conclusively reconciled, including failures from output or other commands between tag creation and push.

### Test assessment

The controlled clock is directionally sound, and “strictly increasing” will fail the old writer because its first two distinct-SHA deployments remain tied. But [PLAN-v3.txt:269](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:269>) incorrectly says the old writer never sleeps: its third SHA2 deployment does hit the existing duplicate-name sleep at current [deploy-rules.sh:253](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:253>). The assertion still detects the bug, but its stated model should be corrected or the fixture should use three distinct SHAs.

The delayed-recovery warning assertion is also weak: H2 is defined for the winner only, while [PLAN-v3.txt:193](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:193>) says it warns about losing receipt A. It cannot. Tests must name exactly which receipt caused each finding.

Add regression cases for:

- fresh-stamped manual recovery with near-zero skew;
- invalid calendar-shaped stamps;
- permanent H1 collision plus its recovery path;
- H4 on the actual newest deploy record;
- marker already accompanied by a local or remote tag;
- partial/corrupt marker;
- marker write failure.

### What v3 did successfully address

I verified that v3 genuinely:

- abandons the two-argmax detector;
- withdraws the self-clearing claim;
- makes reader and writer atomic in Phase 1;
- adds the three-way clock-gap policy and H3 override;
- drops the vacuous fourth-deploy assertion;
- warns about excluded namespace refs;
- specifies fail-closed `for-each-ref` handling;
- preserves the Firebase invocation, temp-worktree payload, tests, and byte-level predeploy check.

I also inspected the real receipt. It is annotated, points to `1da12e3…`, has `by=seeded`, and its name stamp/`at=` are `20260921T220500Z` while its tag date is `2026-09-21T22:54:12Z`. It remains discoverable under the proposed predicate and will trigger H2’s 49m12s warning. No proposed ordering or marker operation changes which bytes Firebase receives.
tokens used
72,339
## Verdict: request changes

V3 fixes several earlier objections, but the core safety claim still does not hold. There are records where the guard confidently chooses the wrong receipt and H1–H4 all remain silent. Phase 2 also contains an implementation contradiction and lacks a crash-safe, idempotent recovery protocol.

### Blocking findings

1. **Wrong — H2’s motivating example is mathematically inconsistent.**

At [PLAN-v3.txt:112](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:112>), A ships at 22:05, B at 22:15, and A is manually recovered at 22:54 using a “fresh date.” The plan claims both:

- A gets a later name stamp and therefore beats B.
- H2 observes 49 minutes of stamp-to-tag-date skew.

Those cannot both be true. If the operator uses 22:54 in A’s tag name, its tag date is also about 22:54, so skew is approximately zero and H2 does not fire. If A retains its original 22:05 name stamp, it has 49 minutes of skew—but B’s 22:15 stamp correctly wins.

A concrete silent-wrong record:

- A actually ships at 22:05.
- B ships last at 22:15.
- A is manually recorded at 22:16 with a fresh 22:16 name stamp, tag date, and matching `at=`.
- At 22:17, A has the unique maximum stamp and is selected, although B shipped last.
- H1: no tie.
- H2: near-zero skew.
- H3: not future.
- H4: valid annotated tag.
- `at=` agrees.

This remains reachable for historical receipts and whenever the proposed marker cannot be written. The record-health model therefore does not satisfy the goal at lines 8–10.

H2’s ten-minute threshold is also not justified by evidence. A legitimate Firebase invocation lasting eleven minutes produces a false warning. That is tolerable as a warning, but “the skew equals release duration” does not establish that ten minutes separates manual recovery from a legitimate release.

2. **Wrong — invalid calendar timestamps still pass the receipt predicate.**

[PLAN-v3.txt:56](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:56>) validates only the shape `^[0-9]{8}T[0-9]{6}Z$`. The prior Codex review explicitly identified impossible timestamps, but v3 does not address them.

For example, an annotated receipt named with `20260921T990000Z`:

- passes the stated predicate;
- can be the unique lexicographic maximum;
- is no longer “future” on September 22, so H3 need not fire;
- is not H4 because its shape matches;
- cannot be meaningfully evaluated by H2 unless parsing failure behavior is specified.

The reader can therefore select an invalid receipt with no defined finding. The predicate needs real UTC validation with a round-trip check; invalid calendar values should be classified as excluded/corrupt and fail the approval path.

3. **Wrong — H1 can permanently brick the only deploy path.**

[PLAN-v3.txt:97](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:97>) refuses every `--approved` run when the maximum stamp has multiple candidates. A realistic two-clone same-second collision therefore refuses forever:

- time passing does not change the maximum stamp;
- the refusal prevents writing a newer receipt that could supersede the tie;
- receipts are immutable;
- the H3 override does not apply to H1.

The plan explicitly recognizes this permanent-bricking problem for future stamps, but recreates it for same-stamp collisions. H1 needs an explicit break-glass path that shows all candidates, requires deliberate acknowledgement, and permits a newer receipt to supersede the ambiguous maximum. Alternatively, the plan must define a safe record-repair procedure.

4. **Wrong — H4 warns while permitting use of a knowingly incomplete record.**

At [PLAN-v3.txt:106](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:106>), H4 means a malformed or lightweight ref may be the record of a real newer deploy, yet `--approved` merely warns and continues diffing from an older receipt.

That directly contradicts lines 8–10. A recovery tag accidentally created without `-a` could describe the actual latest deploy; the guard would warn and then deploy using a base it knows may be wrong.

Similarly, the proposed `at=` cross-check at lines 120–123 has no specified finding, exit behavior, or test. “Nothing about it should be trusted” requires an explicit refusal, not an unimplemented observation.

Warnings are especially insufficient during `--approved`: the operator has already supplied the approved SHA, and the script does not pause for a fresh confirmation after printing the warning.

5. **Wrong — Phase 2 cannot write the promised marker “ahead of the shasum.”**

The marker supposedly contains `sha256` at [PLAN-v3.txt:220](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:220>), but lines 233–236 require it to be the first operation after Firebase, ahead of calculating that hash. Both cannot be implemented.

Compute the hash and complete marker contents before Firebase, without modifying `$TMP`; then atomically publish the marker with a temporary file plus rename immediately after Firebase returns success.

The recovery state machine also needs to cover crashes at every boundary:

- marker written, tag absent;
- tag already exists locally, marker remains;
- tag already exists remotely, marker remains;
- push failed while the unrecorded marker still exists;
- malformed or partially written marker;
- marker fields do not match the commit’s target file and SHA-256.

Without these cases, a rerun may attempt to recreate an existing tag and refuse, or a corrupt/stale marker may fabricate a receipt. Faithful auto-recovery is reasonable if all fields are validated and recovery is idempotent. The second marker file is a sound design preference; overloading the legacy `$PENDING` format would be worse.

The marker still cannot completely remove the original loss window: the marker write itself may fail or the process may die immediately after Firebase succeeds. This is particularly important because disk or permission failure can break both `git tag` and a marker written in the same git directory. V3 must narrow its guarantee rather than claim Phase 2 “removes the cause.”

6. **Wrong — one Phase 2 test scenario is impossible in the stated single-clone flow.**

[PLAN-v3.txt:305](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:305>) proposes:

1. Deploy A; tag write fails.
2. Deploy B normally.
3. Recover A.

But the new marker is explicitly reconciled before any next deploy. In the same clone, the B run must recover A first; there is no later A recovery.

This test needs either:

- a real two-clone fixture, where B does not see A’s local marker; or
- a deliberately constructed record/marker state that models that sequence.

As written, an implementation could not follow both the recovery protocol and the test.

7. **Wrong — the cross-clone limitation is acknowledged but not “made visible.”**

V3 correctly withdraws cross-clone correctness, but line 15 still says ambiguity is made visible. Counterexample:

- A reserves 10:00:00, finishes last at 10:05.
- B reserves 10:00:01, finishes first at 10:02.
- Production contains A; stamp ordering selects B.
- Both are valid, unique-stamped annotated receipts with skew under ten minutes.

No H1–H4 finding fires. If cross-clone serialization remains out of scope, the header must say cross-clone misordering can be completely undetectable—not merely unknowable but visible.

### Ordering key

The `(name stamp, tag date, refname)` ordering is still the best available deterministic order, and it does not reintroduce `d43a171`’s date-primary defect.

There is no inconsistency in sorting tied records deterministically and then refusing to treat that tie winner as evidence. However, `--status` and especially `--diff` must not label the tag-date winner “what shipped last” or print an authoritative diff under H1. They should report the candidate set and refuse the diff operation.

### Check early, reserve late

The basic placement is correct: reserving immediately before Firebase removes the post-deploy sleep from current lines 247–255 and does not affect payload bytes.

The late reservation must re-read record state rather than relying solely on the earlier feasibility result. Post-deploy operations then need the durable marker protocol above. The marker must remain until tag creation and publication are conclusively reconciled, including failures from output or other commands between tag creation and push.

### Test assessment

The controlled clock is directionally sound, and “strictly increasing” will fail the old writer because its first two distinct-SHA deployments remain tied. But [PLAN-v3.txt:269](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:269>) incorrectly says the old writer never sleeps: its third SHA2 deployment does hit the existing duplicate-name sleep at current [deploy-rules.sh:253](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/scripts/deploy-rules.sh:253>). The assertion still detects the bug, but its stated model should be corrected or the fixture should use three distinct SHAs.

The delayed-recovery warning assertion is also weak: H2 is defined for the winner only, while [PLAN-v3.txt:193](</Users/christiehubley/studio-hub/.claude/worktrees/exciting-archimedes-d7d491/.review-tmp/PLAN-v3.txt:193>) says it warns about losing receipt A. It cannot. Tests must name exactly which receipt caused each finding.

Add regression cases for:

- fresh-stamped manual recovery with near-zero skew;
- invalid calendar-shaped stamps;
- permanent H1 collision plus its recovery path;
- H4 on the actual newest deploy record;
- marker already accompanied by a local or remote tag;
- partial/corrupt marker;
- marker write failure.

### What v3 did successfully address

I verified that v3 genuinely:

- abandons the two-argmax detector;
- withdraws the self-clearing claim;
- makes reader and writer atomic in Phase 1;
- adds the three-way clock-gap policy and H3 override;
- drops the vacuous fourth-deploy assertion;
- warns about excluded namespace refs;
- specifies fail-closed `for-each-ref` handling;
- preserves the Firebase invocation, temp-worktree payload, tests, and byte-level predeploy check.

I also inspected the real receipt. It is annotated, points to `1da12e3…`, has `by=seeded`, and its name stamp/`at=` are `20260921T220500Z` while its tag date is `2026-09-21T22:54:12Z`. It remains discoverable under the proposed predicate and will trigger H2’s 49m12s warning. No proposed ordering or marker operation changes which bytes Firebase receives.
