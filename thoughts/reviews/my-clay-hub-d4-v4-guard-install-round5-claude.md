I did not run either guard suite — this sandbox refuses `mktemp -d` and `bash -n` without approval, so everything below is static analysis plus reads of the real trees, tags and lockfiles. No files were modified; nothing deployed; no Google call.

## 1. Each round-4 should-fix

**Codex SF1 / Claude SF1 — `shared/` fixture coverage in the functions suite: resolved, minus the `--diff` half.**
`deploy-functions.test.sh:225` creates `shared/denver-time.js` in the fixture, and `:537-542` is the refusal (older sha whose `shared/` differs → exit 14, `no_deploy`, "carries a different shared"). The invariant both reviews quoted is now satisfied: dropping `shared` from `deploy-functions.sh:123` fails 3 asserts, so the entry is no longer untestable. `shared` is absent from `SHOWN_PATHS:117`, so `show_machinery:135-148` does list it — but that is the one assert from the ask that didn't land (see should-fix 2).

**Claude SF2 — `shared` in the RULES guard: resolved.**
`deploy-rules.sh:102` adds it with the comment at `:97`; fixture at `deploy-rules.test.sh:148`; the drift loop at `:432-434` now includes `shared/denver-time.js` and `:439` expects `carries a different shared`. The guard's text at `deploy-rules.sh:209` produces exactly that.

**Claude SF3 — a `--codebase vault` run with `core` as the other codebase: present, under-asserted.**
`deploy-functions.test.sh:543-563`: vault installed as the deployed codebase with its scripts (`:557-558`), core installed `--ignore-scripts` for the tests only (`:559-560`), core's F3 proof ordered before its install (`:561-562`), and no `functions:core` deploy (`:563`). The `npm-test … =required` assert at `:556` proves the run reached `npm test`, so none of these is vacuous. It just never checks the exit code — see should-fix 1.

## 2. Does pinning `shared/` in the rules guard change a rules deploy that should keep working?

**No.**

- **Today's tip:** by construction `sha:shared == origin/main:shared`. On this branch both are `2ae4a8994e37…`, and the branch doesn't touch `shared/`, so merging changes nothing.
- **The last released rules commit** (`deployed/my-clay-hub/firestore-rules/20260929T033845Z-2ad11ad` → `2ad11ad`) has no `shared/` at all, so it now differs — but it was **already refused** before this change, and with the same message: `control_files_match` (`deploy-rules.sh:103-107`) returns on the *first* mismatch, and `firebase.json` is first — `e68bbb43…` at 2ad11ad vs `f559beb4…` at origin/main (`tests` differs too: `1aa5433…` vs `cc82031…`). So the refusal text is unchanged. And a rollback never approves an old sha anyway: RULES-ROLLBACK.md restores the FILE onto a new commit on main, which is the tip.
- **Missing on both sides still compares equal** (`missing` = `missing`), so a tree with no `shared/` doesn't refuse.
- The rules guard has no `--reverify`-style path that re-judges a past receipt against `CONTROL_FILES`, so no existing record is affected.
- The only newly-refused case is a commit on `origin/main` that is tip-identical in every other control file but differs in `shared/` — the intent.

Same question for the functions guard, since it matters Monday: **`--reverify` of the live core attempt is unaffected** — `7efa0f0:shared` == `origin/main:shared` (`2ae4a899…`), and `firebase.json` already differs (`14ab120…` vs `f559beb4…`), so `control_file_diff` still returns `firebase.json` and the `--acknowledge-verifier-change` requirement is exactly what it was.

## Findings

### Blocking
None.

### Should-fix

1. **The `--codebase vault` scenario never asserts the exit code** — `deploy-functions.test.sh:554`. Round-4's ask was a happy-path run in the direction Monday's deploy takes; what's asserted is the install/test log only. If vault broke anywhere *after* `npm test` — `reserve_stamp`, the drift read, the CLI call, the F8 read-back of a schedule, the probe — every assertion at `:556-563` still passes, and the commit message's "the vault-direction deploy tested" would be wrong. I traced the path and it should be 0: the declarations at `functions/declarations.json` match the scenario manifest exactly (schedule block, five retry values, both runtime accounts, the monitoring invoker); the fake CLI emits `scheduleTrigger: {}` plus the `deployment-scheduled` label as `JQ_F8` (`deploy-functions.sh:287-293`) requires; and both probes return 403 → `ACCESS=refused` → `deploy_verified=yes` (`:785`). So one line — `assert_eq "…→ exit 0" "$CODE" "0"` after `:554` — should pass and is what actually proves Monday's path.

2. **The `--diff` naming assert for `shared` is missing** — `deploy-functions.test.sh:537-542`, compare the `functions/vault` pair at `:532-536`. Both round-4 reviews asked for the refusal *and* the `--diff` assert; only the refusal landed. Narrow gap (dropping `shared` from `CONTROL_FILES` already fails 3 asserts), but `show_machinery` listing `shared` is never exercised. One line mirroring `:536`.

### Nits

3. `deploy-rules.test.sh:439` — `"carries a different ${cf%%/denver-time.js}"` hard-codes this one file's basename to map a fixture path back to its control entry; a second `shared/…` file in the loop would silently need another clause. A small `cf → expected` table would age better.
4. `deploy-rules.test.sh:431` — the loop's comment still says "'#' is a comment in every one of these". `shared/denver-time.js` joins `emulator-safety.js`, `functions-discover.mjs` and `lib/functions-hash.mjs`, for which that was already untrue. Harmless (the refusal happens at `deploy-rules.sh:208`, before step 7 runs anything), but the comment now misdescribes four of the ten entries.
5. **Round-4 Codex nit 2 stands** — `deploy-rules.test.sh:28-30`'s comment describes the *functions* harness's hazard. The rules harness never did `cd "$T"` before this change, so an empty `T` would have made `rm -rf ""` a no-op, not a repo delete.
6. **Round-4 Codex nit 1 stands** — `TMPDIR=/` is refused (and leaks the folder, the trap not yet installed) by `/*/functions-guard-test.??????` / `/*/deploy-guard-test.??????` at `deploy-functions.test.sh:29` / `deploy-rules.test.sh:34`. Fail-safe.
7. `first_line()` is defined mid-suite at `deploy-functions.test.sh:344`, inside the happy-path block, and reused at `:561`. Works (shell functions are global); moving it up with the other assert helpers would stop a future reordering from emptying `PV`/`NV` — which fails loudly, so cosmetic.
8. **Round-4 Claude nit 4 stands** — `deploy-functions.sh:18`'s line break ("npm ci --ignore-scripts; D-4), runs npm test with") is awkward.

## 3. Anything else blocking in the branch

No. Two things I checked rather than assumed, because they only bite on the real Monday run and no test covers them:

- **`lockfile_check` against the REAL lockfiles** (`deploy-functions.sh:612-622`; the fixtures use stubs). `functions/core/package-lock.json` and `functions/vault/package-lock.json` are both `lockfileVersion: 3` with 265 non-root entries each; all 265 have a `registry.npmjs.org` `resolved` and a `sha512-` `integrity`, and neither has a `link: true` or bundled entry. Both pass.
- **`--ignore-scripts` on the other codebase** (`:600-601`) — the only packages with install scripts in either lockfile are `@firebase/util@1.15.3` and `protobufjs@7.6.6`. protobufjs's postinstall only writes a stderr warning. `@firebase/util`'s rewrites `dist/postinstall.js`, but that file is a shipped build artifact (`dist/src/postinstall.d.ts` ships beside it) and its current content is the no-config default, so skipping the script leaves identical behaviour. `npm test` won't fail because the other codebase skipped scripts.

Also confirmed: `--reconcile`/`--reverify` correctly do *not* call `install_other_codebases` (`:1152`, `:1200`) — only `--approved` runs `npm test` (`:1030-1032`); `codebase_on_tip` extends `CONTROL_FILES` at `:1009`, before the approved-sha check at `:1020`, which is what makes the other-codebase refusals work; and `OTHER_CBS=""` at `:73` keeps `set -u` safe for modes that never reach it.

**Please run `npm run test:functions-guard` and `npm run test:guard` (or full `npm test`) before merging** — the commit message's counts are unverified by me, and the new asserts at `:537-542`, `:543-563` and the rules loop's three have never been executed in a review.

**merge after fixes** — nothing blocking, and both should-fixes are one line each in test files; no guard behaviour needs changing.
