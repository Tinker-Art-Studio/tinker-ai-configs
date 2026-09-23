This is an IMPLEMENTATION review of real, committed code. Be adversarial and concrete. The plan for this change was reviewed three times; what matters now is whether the CODE is correct.

## What to read

1. `git show c7025a3` — the change under review (both files). Its message states the reasoning.
2. `scripts/deploy-rules.sh` — the full file as it now stands.
3. `scripts/deploy-rules.test.sh` — the full test suite as it now stands.
4. `git show 1ff50b2` and `git show d43a171` — a previous attempt at this same fix and its revert. **Ordering receipts by `--sort=-creatordate` (tag creation date) is permanently off the table.**

## What the change does

`scripts/deploy-rules.sh` is the only sanctioned way to deploy Firestore rules for `tinker-hq-apps` (21 apps share ONE rules file). Each successful deploy leaves an annotated git tag ("receipt") named `deployed/<project>/<slug>/<UTC yyyymmddTHHMMSSZ>-<sha7>`. The guard reads "what shipped last" from those receipts and prints a diff from it; a non-technical operator reads that diff and approves the deploy.

The bug: `latest_receipt()` used `--sort=-refname`. The stamp has second resolution, so two same-second deploys tied and the tie broke on the trailing sha7 — arbitrary. Measured before the fix: 3 of 9 guard-suite runs failed.

The change:
- **Ordering** is now (name stamp, tag date, refname) descending, computed in one `awk` pass in `receipt_rows()`.
- **The receipt predicate** (one definition, used by reader and writer): an ANNOTATED tag whose name carries a real UTC date-time that is no later than its own tag object was written.
- **Reads fail closed** with `EX_RECORD=19`.
- **The monotonic stamp wait moved ahead of the release** (step 7b); at the cap it warns and proceeds rather than refusing.
- **`--status` and `replaces:`** now print the receipt's true-UTC tag date and `by=` provenance.

Deliberately NOT in scope (deferred to a follow-up plan, do not ask for them here): refusing on a self-contradicting `at=` field; reporting same-stamp ties and excluded refs; a marker for the unrecorded-deploy case where `git tag -a` fails after a successful release.

## What I want reviewed — priority order

1. **The `awk` in `receipt_rows()`.** Walk it. Is the epoch/calendar arithmetic correct (leap years, month lengths, day-of-year accumulation)? Does `substr`/`index` parsing handle every refname shape that can appear under the namespace, including a name with no `-`, a name that IS the prefix, and multiple `-`? Can it produce a wrong row rather than skipping? Is the `sort -k1,1r -k2,2nr -k3,3r` correct and stable enough for the intent?

2. **Failure propagation, concretely.** The claim is that a failed `git for-each-ref` cannot read as "no receipt yet". Trace it: `receipt_rows` → `latest_receipt`/`newest_stamp` → `RECEIPT="$(...)" || die`. Note `set -euo pipefail` is on and errexit is SUPPRESSED inside a function invoked in a `|| die` context. Is every fallible command covered? Does the `printf | awk` pipeline mask anything? Can any of these return 0 with empty output when they should fail?

3. **Step 7b, the reservation loop.** Does it always terminate? Are the two conditions (stale stamp, name taken) genuinely evaluated independently? Is there any way it can loop forever, exit silently, or fall through with a `TAG` that already exists? Is `${STAMP//[TZ]/}` arithmetic comparison safe for all valid stamps (leading zeros → octal?)? Does anything in it touch `$TMP` or affect which bytes ship?

4. **Did anything get WORSE?** Specifically: is there any input on which the new reader names a worse receipt than `--sort=-refname` did? Is there any deploy that succeeds today and would now be refused? (`EX_RECORD` is the only new refusal.) Does the real receipt `deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3` (annotated, `by=seeded`, name stamp `20260921T220500Z`, tag date 49m12s later) still pass, and does the first real deploy still work?

5. **The tests.** I verified all 17 new assertions FAIL against the pre-change guard (`git stash` the change, or check out `1ff50b2:scripts/deploy-rules.sh`, and run the new test file against it). Check my work, and hunt for any assertion that passes for the wrong reason. Two were already caught and fixed: the cross-offset pair needed the later instant to carry the LOWER sha7, and two impossible-calendar stamps had to be future-dated to out-sort the real receipt. **Find a third.** Also: are there important behaviours with NO test?

6. **Bytes.** Confirm independently that nothing in this change can alter which bytes reach Firebase. This is the invariant that matters most.

## Constraints

- Read-only review. Do not edit files. Do not run `firebase` at all. Do not deploy. You MAY run `bash scripts/deploy-rules.test.sh` (it is fully self-contained — throwaway repos in a temp dir, fake `firebase`/`npm`/`git` on PATH, no network).
- macOS: bash 3.2.57 (no associative arrays), git 2.50.1, BSD userland, BWK awk, BSD `sort`.
- Do not propose reintroducing the deferred scope; judge the code as scoped.

Give a verdict (approve / request changes) and concrete findings with line numbers. Separate "this is a bug" from "this is a preference". If you approve, say what you actually ran or traced rather than asserting it.
