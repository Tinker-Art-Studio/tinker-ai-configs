I could not run the suite — `npm run test:functions-guard` needed an approval I don't have — so "the tests pass" and the commit message's mutation counts are unverified by me. Everything below is static, plus two targeted reads of the installed packages.

## 1. Are the round-1 findings resolved?

**Codex blocking 1 (path escape) — yes, on all three axes.**

- Names: `scripts/deploy-functions.sh:553` requires `.codebase` to be a string matching `^[a-z][a-z0-9-]*$`; `:554` requires `.source == "functions/" + .codebase`; `:556` rejects duplicates — all read from `MAIN_SHA`, before anything runs. `scripts/deploy-functions.test.sh:496-499` covers `elsewhere/vault`, `../../x`, a missing `codebase` key (round-1 Claude nit 3), and a double listing.
- The jq anchors are belt-and-braces only: `OTHER_CBS` is word-split at `:588`, and `:589` re-checks each name with a bash ERE where `$` is a true end-of-string anchor. So even a jq/Oniguruma `$`-before-trailing-newline quirk can't carry a second path segment through.
- Containment: `:586-587` proves `functions/` itself resolves inside the worktree, then per codebase `:591` (`! -L`), `:592` (`-d`), `:593-594` (`pwd -P` equals `${tree_real}/functions/${cb}`). The symlink test at `:506-511` is real — it commits an absolute symlink to `$T/outside-vault`, which is outside `$TMPDIR`, and asserts npm never logged that path.

**Codex blocking 2 (lifecycle scripts + approval surface) — yes.**

- `:596` installs other codebases with `--ignore-scripts`. I checked the two `hasInstallScript` packages Codex named: `protobufjs`'s `scripts/postinstall.js` only prints a version-scheme warning, and `@firebase/util` ships `dist/` wholesale in its `files` list (`functions/vault/node_modules/@firebase/util/package.json:24-27`), so the default `dist/postinstall.js` the postinstall would overwrite is already in the tarball. `--ignore-scripts` is safe for both — the "tests pass without them" claim is plausible, not just asserted.
- `:561` appends `functions/<other>/package.json` and `package-lock.json` to `CONTROL_FILES`, which makes them both tip-pinned (`control_file_diff` at `:999`) and named by `show_machinery` (`:134-148`, since neither is a word in `SHOWN_PATHS`). Tested at `:513-519`.

**Round-1 Claude nits:** 4 (sha as a parameter) → `:584`; 5 (config checks before `build_expected`) → they now live in `codebase_on_tip` at `:989`, ahead of `:1007`; 7 (header) → `:16-17`. Nits 6 (availability) and 8 (`functions-emulator.mjs:39` hardcodes core) stand, both explicitly optional.

## 2. Can the new validation wrongly refuse, or break the other modes?

**No on both.** The real `firebase.json:15-35` has exactly two entries, each a plain lowercase name with `source: functions/<name>`, no duplicates — `bad` is empty and `OTHER_CBS` is the single other name.

The ordering is load-bearing and correct: `codebase_on_tip` runs at `:922` (status/diff, before `show_machinery` at `:937`) and at `:989` (every tag-writing mode, before `control_file_diff` at `:999`), so the grown `CONTROL_FILES` is in effect everywhere it's read. `OTHER_CBS` is derived from the tip while `install_other_codebases` walks the worktree of `$SHA` — sound, because `firebase.json` is itself a control file, so `:999-1000` has already proven the two are byte-identical before `:1010` runs.

`--reconcile`/`--reverify`/`--clear-inflight`/`--attest` still never call `install_other_codebases`. On `verifier_fields` → `control_file_diff` (`:790`), the growth is a no-op for the live canary attempt: `firebase.json` is first in the list and already differs, so the named file and the `--acknowledge-verifier-change` requirement are unchanged. See nit 4 below for the one new case.

## Findings

**Should-fix 1 — `npm test` still loads and runs the other codebase's source, which is neither tip-pinned nor in `--diff`.** `--ignore-scripts` closed the npm half; the test half is now wide open by design. `scripts/deploy-functions.sh:1012` runs `npm test`, and `scripts/functions-emulator.mjs:99,113-114` starts session 1 over the worktree's whole `firebase.json`, so during a `--codebase core` deploy the emulator requires `functions/vault/index.js` and everything under it, as the deploying user, with `${REPO}/node_modules` reachable through the symlink at `:570`. That folder's source is in neither `SHOWN_PATHS` (`:116`) nor `CONTROL_FILES` (only its two package files, `:561`) — so a change to it is invisible in the `--diff` Christie approves and need not match the tip, which is the exact promise `:132-133` states. It also gets no F3-equivalent: `scripts/predeploy-check.sh:110` scopes every check to `functions/$TINKER_DEPLOY_CODEBASE`, so vault's folder is never checked for symlinks (`:151`, `:168`), `.env*` files (`:156`), a committed `functions.yaml`, or a `node` dependency (`:162`). Before this branch the question didn't arise — the install was missing, so the emulator exited 1. Cheapest fix: add each `functions/<other>` to `SHOWN_PATHS`. Stronger and probably better: call the existing check-only backstop target (`folder_check`, `:599-604`) for each other codebase before installing it — it gives all of the above for free and subsumes the ad-hoc checks at `:591-594`. Not blocking: the code has to be on `origin/main` at an ancestor commit, and nothing wrong can *ship* this way.

**Should-fix 2 — the "core's own install still allows scripts" test can never fail.** `scripts/deploy-functions.test.sh:335` passes `…tinker-functions.*/tree/functions/core` to `assert_lacks`, which greps with `-F` (`:34`), so `.*` is matched as two literal characters. The log holds `tinker-functions.AbC123/tree/functions/core`, which never contains `.` followed by `*` — the assertion is vacuous and would still pass if core *were* installed with `--ignore-scripts`. The commit message's "scripts allowed → 1 fails" mutation is caught by `:333`, not this line. Something like `assert_lacks … "$(grep 'functions/core' "$SC/log")" "--ignore-scripts"` would say what's meant.

**Nit 3 — `--status` and `--diff` now refuse on a malformed `firebase.json`.** `codebase_on_tip` runs for the read-only modes too (`:922`), so a bad entry at the tip makes exit 18 come out of the two commands that exist to show it. Fail-closed, and the refusal names the entry, so it's survivable — just worth knowing before it happens under time pressure.

**Nit 4 — the grown `CONTROL_FILES` can newly demand `--acknowledge-verifier-change` for a change the mode doesn't use.** A commit on main that only bumps `functions/vault/package-lock.json` now makes `control_file_diff` (`:790`) report a change for a *core* attempt, so `--reverify`/`--attest`/`--reconcile` refuse until acknowledged — even though no mode but `--approved` ever installs vault. Over-strict rather than wrong, and the message names the file.

**Nit 5 — `real="$(cd "$dir" && pwd -P)"` (`:593`) is the one line in the function with no `|| die`.** Under `set -e` a directory that passes `-d` but can't be entered exits 1 with no `REFUSED:` line. Unreachable from a git checkout (git stores no directory modes), but inconsistent with its neighbours.

**Nit 6 — `:519`'s `--diff` assertion is weaker than its name.** No verified attempt exists at that point, so `BASE` is the empty tree and `show_machinery` lists *every* control file; it would pass whether or not vault's `package.json` had changed. It does prove membership in `CONTROL_FILES` and that `--diff` reaches it, which is the useful half.

**Nit 7 — still no scenario deploys `--codebase vault` with `core` as the other codebase** (round-1 Claude raised this; it's the case that actually failed on Oct 3). The guard is symmetric by construction, but `SHOWN_PATHS` and the `CONTROL_FILES` growth are only exercised in the core→vault direction.

## Verdict

**merge after fixes** — both should-fixes are one-liners. Fix 2 before merging regardless: it's a test the commit message leans on that cannot fail. Fix 1 restores the stated `--diff` promise that round 1 made the blocking point of; the `folder_check`-for-every-codebase version is the better shape if you're touching it anyway. Then please run `npm run test:functions-guard` (and ideally full `npm test`) — I was not able to.
