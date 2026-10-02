## Verdict: **safe to merge**

Tests I ran (offline, read-only): `bash scripts/deploy-functions.test.sh` → **863 passed, 0 failed** (exit 0); `node --test tests/unit/*.test.js` → **171 passed, 0 failed** (the reported 227 is `test:unit`, which also globs `tests/shared/*.test.js`). `git diff --check origin/main...d4-guard-schedules` is clean.

### 1. Round-1 findings — all fixed except one, with reasons

**Codex**
- **B1** attest record missing `scheduler_attested` → fixed differently but better than suggested: records are now `format=tinker-functions-attest-2` (`scripts/deploy-functions.sh:1211`) and `scripts/lib/receipts.sh:184-187` only returns `unknown` when the format line is literally `tinker-functions-attest-1`; anything else returns 1. Test `scripts/deploy-functions.test.sh:1027-1032` strips the line from a format-2 record → `--status` exit 19.
- **B2** job list from the attempt's stale declarations → fixed: `scripts/deploy-functions.sh:1173-1187` builds it from what is **deployed** (this attempt's own entries, plus each other codebase's newest attempt's). `FUNCTIONS-ROLLBACK.md:135-137` rewritten to match. Tests `deploy-functions.test.sh:1013-1025` walk never-deployed → deployed → job missing from the reading.
- **SF1** `--clear-inflight` can never reach `scheduler_attested=yes` → fixed by the per-key fallback (`:1188-1202`), with the asked-for tests: scheduled `--reconcile` (`:1039-1046`) and clear → reverify → attest (`:1047-1060`).
- **SF2** backstop didn't hold the nested `schedule` key set / non-empty schedule → fixed, `scripts/predeploy-check.sh:247-248`; tests `tests/unit/predeploy-check-functions.test.js:431-442`.
- **SF3** runbook's Pause / "refused before upload" claims → both corrected (`FUNCTIONS-ROLLBACK.md:186-189`, `:199-202`).
- **Nit** trailing whitespace in the fixture → fixed.

**Claude**
- **B1** pre-D-4 declaration kills `--reverify`/`--reconcile` → fixed: the three-key shape normalises to `trigger: "https"` in both the guard (`deploy-functions.sh:157-160`) and the backstop (`predeploy-check.sh:226-228`). Tests `deploy-functions.test.sh:1061-1071` and `predeploy-check-functions.test.js:444-455`.
- **B2** headers check vacuous-or-always-wrong → fixed: `deploy-functions.sh:407-410` allows exactly Cloud Scheduler's own `User-Agent: Google-Cloud-Scheduler`, or none; the template (`:847`) now asks for every header shown instead of pre-filling `{}`. Three tests pin it (`:941-944`), including `{}` → exit 0.
- **SF3/SF4/SF5/SF7** → all fixed (format-2 documented at `FUNCTIONS-ROLLBACK.md:180-183`; job-list doc; `|| die` on the codebase enumeration at `:1179`; per-key verify/attempt fallback).
- **SF6 real discovery over a scheduled codebase — NOT fixed.** `tests/functions/schedule-probe.test.js:17-27` still hand-rolls `wire()`. I now think that's the right call and should just be stated: `scripts/functions-discover.mjs:103-111` is pinned to the repo's own `firebase.json` and refuses any `--source` that isn't a declared codebase's, so it cannot be pointed at the scratch fixture without loosening it. V-3 step 4 closes the gap with the real `vault` codebase.
- Nits: `OLD2` gone; `functions-emulator.test.js:41-43` now asserts something real; CLAUDE.md/AGENTS.md updated; the `oidcServiceAccount` limit is now stated in the template (`:851`) and §9. Still open, as flagged: `schedulerJobList` is read for `us-central1` only.

### 2. New problems in the fixes

**Should-fix**

- `scripts/deploy-functions.sh:785-796` — **`attest_need` ignores `scheduler_attested`.** The loop breaks on the first attempt with `iam_attested=yes` and only treats an IAM `no`/owed reading as outstanding. So for a codebase with no schedule (i.e. `core` after `vault` ships), an attestation that recorded `scheduler_attested=no` — which can only mean an unaccounted-for job in the project — is forgotten: the next `core` deploy with no `ATTEST_FILES` change prints "IAM reading not needed", while the record still holds the unresolved `no`. It's visible in `--status` and `--attest` still exits 21, so nothing false is asserted, but it contradicts the stated intent of `owed` ("a reading that came back no … is owed"). `vault` is unaffected (a schedule always forces a reading). Natural to fold into V-3.

**Nits**

- `scripts/deploy-functions.sh:1186` — the `jq -s add` merge is the only read in that block without `|| die`. If it fails, `set -e` exits with jq's status and no `REFUSED:` line, breaking the block's own fail-closed convention.
- `scripts/deploy-functions.sh:157-160` / `scripts/predeploy-check.sh:226-228` — the legacy normalisation is unconditional, so a *newly written* declaration with exactly `{serviceAccount, invoker, ingress}` is now silently accepted as HTTP where `c8141f8` refused it by name. No safety is lost (invoker/public, account and ingress are still checked, and a scheduled endpoint under such a declaration is refused as "declared https but is not an HTTP function"), and `tests/functions/manifest.test.js:123-137` fails if the committed file ever regresses — which is why this is only a nit.
- `scripts/deploy-functions.sh:1182` — the deployed-job list uses each other codebase's newest **attempt**, verified or not. A failed `vault` attempt whose commit dropped the schedule would drop its job from the expected list while the job still exists, flipping every codebase to `scheduler_attested=no`. Fail-closed (it can never produce a false `yes`), but worth knowing before V-4.
- `docs/my-clay-hub/DECISIONS.md:79` (#62) still says "the complete job list for every codebase", which reads as *declared*. The runbook was corrected to *deployed*; the decision row wasn't.

Nothing blocking. O5/O6 untouched.
