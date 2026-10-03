## Review — `c3380be` (D-4 V-4 fix: the functions guard installs every codebase for the tests)

I read the commit, `scripts/deploy-functions.sh`, `scripts/predeploy-check.sh`, `scripts/functions-emulator.mjs`, the new/changed tests, and the pinned CLI's own packaging code. I did **not** run the suite (`npm run test:functions-guard` needed approval I didn't have), so the commit message's "without the call, 12 guard tests fail" is unverified by me.

The diagnosis is right and the fix is the right shape. `scripts/functions-emulator.mjs:40,99-100` maps **every** `firebase.json` codebase to `functions/<cb>/node_modules/.bin/firebase-functions` and exits 1 under `TINKER_FUNCTIONS_TESTS=required` when any is missing — so installing every entry from the same `firebase.json` is exactly the right closure, and it's what unblocks a `--codebase vault` deploy (that one needs `core` installed, because `functions-emulator.mjs:39` symlinks `functions/core/node_modules` into the probe fixtures).

---

### 1. Can the other codebases' installs change what is checked, sealed or uploaded for `$SRC`?

**No — on every path you asked about.**

- **F3 folder proof**: `predeploy-check.sh:143` (`git ls-tree -- "$src"`) and `:176` (`find "$src" …`) are scoped to `functions/$TINKER_DEPLOY_CODEBASE`. Another codebase's folder isn't in scope at all, so its untracked `node_modules` can't become an "extra" path.
- **Seal / manifest**: `predeploy-check.sh:263` writes only `${src}/functions.yaml`; `deploy-functions.sh:530` cleans only `${TMP}/${SRC}/functions.yaml`. No other codebase is ever sealed, so there's nothing stale to leave behind.
- **Source hash**: discovery runs inside `build_expected` (`deploy-functions.sh:614`, called at `:988`) — i.e. **before** `install_other_codebases` at `:991` — so `expectedHashes` is computed on a worktree with only `$SRC` installed. The CLI's own hash comes from `packageSource`, which reads `sourceDir` alone (`node_modules/firebase-tools/lib/deploy/functions/prepareFunctionsUpload.js:77-78`) with `additionalSources = []` (`scripts/lib/functions-hash.mjs:37`). Different times, same scope, same answer.
- **Packaging and the predeploy hook**: with `--only functions:core` (`deploy-functions.sh:1040`), `getReleventConfigs` (`node_modules/firebase-tools/lib/deploy/lifecycleHooks.js:120-137`) returns core's config only, so only core's hook runs — and if it ever ran for another codebase, `predeploy-check.sh:136` refuses on `RESOURCE_DIR`. The `ignore` list keeps `node_modules` out regardless.

The test suite already pins this empirically rather than by argument: the fake hash (`deploy-functions.test.sh:72-76`) prunes `node_modules` the way the real `ignore` list does, and `:316` asserts `expected_hash.canary == live_hash.canary` *across* the new install.

**Install scripts are the one real new surface** — see should-fix #2.

### 2. Placement and fail-closedness

**Placement is right**, and for a stronger reason than the comment gives: `--reconcile` and `--reverify` rebuild the expected hashes with `build_expected` and *without* `install_other_codebases` (`:1113`, `:1161`). Putting the install before `build_expected` would make the `--approved` worktree differ from the rebuild worktree at discovery time. Harmless today given `packageSource`'s scoping — but it would leave "the rebuilt expected hash must equal the recorded one" (`:1117-1120`, `:1167-1170`) depending on that. After `build_expected`, the two paths are identical by construction.

**Fail-closed: yes.** jq failure → `EX_CONFIG`; source ≠ `functions/<cb>` → `EX_CONFIG`; missing folder → `EX_CONFIG`; `npm ci` non-zero → `EX_INSTALL`. All of it precedes `reserve_stamp`, the in-flight file and the CLI, so nothing deploys and no record is written. Shell details check out: `set -e` does not trip on `[ "$cb" = "$CB" ] && continue` (`:572` — the command before the final `&&` is exempt from errexit), an empty `$entries` yields one empty line → `continue`, and `@tsv` escapes tab/newline/CR/backslash so a crafted `source` can't inject a loop iteration.

**Path escape: yes, there is one** — should-fix #1.

### 3. `--reconcile` / `--reverify` / `--clear-inflight` / `--attest`

**Unaffected, correctly.** `--reconcile` (`:1113`) and `--reverify` (`:1161`) call `build_expected` but never `install_other_codebases` and never `npm test`; `--clear-inflight` and `--attest` build no worktree at all. They re-derive the manifest and hashes, neither of which depends on another codebase's install, so leaving them out is right rather than an omission.

### 4. The tests

Meaningful, and they cover the right four things:

- `test.sh:332` — `"/tree/functions/vault cwd="` proves `npm ci` ran on the *other* codebase *inside the worktree* (path and all), not just that some npm ran.
- `:334` — `assert_lacks "functions:vault"` proves the install didn't widen the deploy target.
- `:481-484` — the `npm_ci_fail_vault` scenario is the strongest one: exit 29, no deploy, the message names the codebase, **and** `npm test` never ran, which pins the ordering (install before tests) as well as the refusal.
- `:485-496` — both config refusals are real refusals (18) with their own messages, on commits that are genuinely the tip.

The fake npm's new line (`:61`) is sound: `fake-npm.sh` has no `set -e`, so the `case` returning 1 when the flag file is absent doesn't abort it.

The changed older scenario (`:1034-1038`) **still tests what it tested** — that a *second codebase's* declared schedule doesn't trip core's manifest check (`JQ_MANIFEST` filters on `startswith($cb + "/")`). Adding `functions/other/` only satisfies the new folder requirement; the assertion (`:1041`, exit 0) and the declarations/`firebase.json` edits are unchanged. `cp functions/vault/*` carrying `"name":"vault"` into `functions/other/package.json` is harmless — nothing reads that field.

Gaps, both minor: no scenario deploys `--codebase vault` (the case that actually failed on Oct 3) with `core` as the other codebase; and `:484`'s `assert_lacks … "npm-test"` is indirect — the fake logs `npm test cwd=` for the invocation and `npm-test …` only after passing its fail gate, so asserting the absence of `npm test cwd=` would say what you mean.

---

## Findings

**Should-fix 1 — `functions/<cb>` doesn't actually confine the `npm ci` path to the worktree.** `scripts/deploy-functions.sh:569-578`. `$CB` (from `--codebase`) is validated against `^[a-z][a-z0-9-]*$` at `:90`; `$cb`, read out of the commit's `firebase.json`, is not. `[ "$src" = "functions/${cb}" ]` is trivially satisfied by `{"codebase": "../../x", "source": "functions/../../x"}`, `[ -d "${TMP}/functions/../../x" ]` then resolves *outside* the worktree, and `npm ci --prefix` installs there. A committed symlink at `functions/<cb>` escapes the same way (`-d` follows it; `predeploy-check.sh:168`'s symlink refusal covers only the deployed codebase's folder). Mitigated — `firebase.json` is in `SHOWN_PATHS` (`:115`) and `CONTROL_FILES` (`:121`), so such an entry is in the diff Christie approves and must match the tip — which is why this isn't blocking. But the function's own comment claims the constraint, so it should hold: add `[[ "$cb" =~ ^[a-z][a-z0-9-]*$ ]] || die $EX_CONFIG …` and `[ ! -L "${TMP}/${src}" ]`.

**Should-fix 2 — the other codebases' `package.json`/`package-lock.json` are neither diff-shown nor tip-pinned, yet their npm lifecycle scripts now run.** `npm ci` runs install/postinstall scripts. For `$SRC` that was already true, but `${SRC}/package.json` and `${SRC}/package-lock.json` are in `CONTROL_FILES` (`:121` — must equal `origin/main`'s) and `${SRC}` is in `SHOWN_PATHS` (`:115`, printed at `:1006`). `functions/<other>/package.json` and `…/package-lock.json` are in neither, and `show_machinery` (`:131-146`) only walks `CONTROL_FILES`. So a dependency added to vault's lockfile executes during a **core** deploy, as the deploying user with the real `HOME` (neither install uses the `env -i HOME=…` isolation discovery gets at `:587`), with nothing in the approval showing it — and a postinstall could reach `${REPO}/node_modules` through the symlink at `:556`, i.e. the pinned CLI, after `preflight` (`:962`) has version-checked it and before it is invoked at `:1040`. That's a departure from the principle stated at `:131-132` ("a change to it must never be invisible in the diff Christie approves"). F3's re-check in the predeploy hook still catches tampering with `functions/core` itself, which is why this is should-fix rather than blocking. Fix: add every `firebase.json` codebase's `package.json`/`package-lock.json` to `CONTROL_FILES` and `show_machinery` — or, lighter, just to `show_machinery` so `--diff` names them.

**Nit 3 — an entry with no `codebase` key is silently skipped.** `:571`. `[ -n "$cb" ] || continue` conflates the here-string's empty line with `@tsv`'s empty field for a missing `.codebase`. Still fail-closed downstream (`functions-emulator.mjs:99-100` maps the same entries and the tests would fail; `predeploy-check.sh:114` refuses) — but the refusal lands far from the cause.

**Nit 4 — reads the global `$SHA` instead of taking it as a parameter**, unlike `folder_check` (`:580`) and `build_expected` (`:610`). Only reachable from `--approved` today; a future caller without `SHA` gets `set -u`'s "unbound variable" instead of a refusal.

**Nit 5 — the two config refusals could run before `build_expected`.** As written, a typo'd `firebase.json` costs a full discovery plus two folder checks before refusing. The *install* must stay where it is; the checks needn't.

**Nit 6 — availability.** Every codebase's `npm ci` now runs under the shared lock, and vault pulls `@google-cloud/storage` + `firebase-admin` + `@google-cloud/firestore-api`. A registry hiccup on an unrelated codebase now refuses a core deploy. Fail-closed, just slower and more fragile; the runbook's "holds it for minutes" note (`FUNCTIONS-ROLLBACK.md:102`) is still accurate.

**Nit 7 — the file header doesn't mention the new step.** `:15-16` still reads "installs the codebase with Node 22 … runs npm test". The guard now runs `npm ci` on folders it does not deploy; that belongs in the header, which is the design record.

**Nit 8 — a coupling worth knowing (not introduced here).** `functions-emulator.mjs:39` hardcodes `CODEBASE_MODULES = functions/core/node_modules` for the probe fixtures, so this fix is sufficient only while `core` is in `firebase.json`.

**Verdict: safe to merge** — the two should-fixes are hardening of a path that an approved, tip-pinned, diff-shown `firebase.json` already gates, and both are one-liners that can land on top.
