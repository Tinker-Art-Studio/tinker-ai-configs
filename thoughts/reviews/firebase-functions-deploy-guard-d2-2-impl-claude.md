## Verdict: **merge after fixes**

The byte/mode closure holds. I could not find a way for a folder that differs from the approved commit's `functions/<cb>` to pass: `want` (from `ls-tree`) and `have` (from `git hash-object` + the `-x` bit) are compared as sorted `mode obj path` triples with `cmp`, `want` is guaranteed non-empty (the tree check plus the `package.json`/lockfile greps), and the only paths F3 skips — inside the top-level `node_modules` — are exactly the ones `readdirRecursive`'s minimatch `{matchBase, dot}` filter also drops from the upload (`fsAsync.js:64`), so F3's coverage is a superset of what ships. I verified against the pinned CLI: `lifecycleHooks.js:44-63` passes `{...process.env, GCLOUD_PROJECT, PROJECT_DIR, RESOURCE_DIR}` with `cwd = projectDir`; `runtimes/node/index.js:186` reads `<sourceDir>/functions.yaml` first, so the seal really does replace discovery; `emulator/env.js:47-60` mints the refresh token only when an account is found, which a scratch `HOME` with `XDG_CONFIG_HOME` dropped prevents. `node --test tests/unit/ tests/shared/` → 173 pass, 0 fail. Bash is 3.2.57 on `/bin/bash` *and* on `PATH`, and I confirmed `[ -x f ] && mode=…` survives `set -e` and `sort -o f f` is safe here.

The fixes below are failure-path and coverage problems, not fail-opens.

---

## Blocking

None.

---

## Should-fix

**1. `scripts/predeploy-check.sh:170,172,175` — a large mismatch aborts the backstop at exit 141 with no `REFUSED` line at all.**
`extra="$(… comm -13 … | head -1)"` under `set -o pipefail`: `head` exits after one line, `comm` takes SIGPIPE, the pipeline returns 141, the command substitution fails, and `set -e` kills the script *before* `refuse` runs. Verified: with 80 000 differing lines the subshell exits 141 and prints nothing (under ~64 KB of `comm` output it works, which is why the tests pass).
Failure scenario: a stray nested install or build output under `functions/core` (the suite's own "node_modules below the top level" case, but with a real install — thousands of untracked paths). The deploy still fails closed, but the operator gets no reason, and D2-3's transcript check sees neither the success line nor a refusal.
Fix: `extra="$(LC_ALL=C comm -13 … | head -1 || true)"` on all three substitutions.

**2. `scripts/predeploy-check.sh:193-195` — a failure between `cp` and the sha check leaves `functions/<cb>/functions.yaml` behind.**
Only the `got != msha` branch does `rm -f`. If `cp` fails part-way (disk full), or `chmod`/`shasum` fails, `set -e` exits and the trap only removes `$work`. That contradicts the property `refused()` asserts (`tests/unit/predeploy-check-functions.test.js:28`, "a refused run leaves no functions.yaml behind"), and it leaves unverified bytes at the exact path the CLI would read.
Fix: extend the trap once the copy starts, e.g. `sealed=0; trap 'rm -rf "$work"; [ "$sealed" = 1 ] || rm -f "${src}/functions.yaml"' EXIT`, setting `sealed=1` after the sha matches.

**3. `scripts/predeploy-check.sh:48` + `184-199` — `functions/declarations.json` is byte-verified but never read, and the sealed manifest is trusted entirely on the caller's sha.**
The backstop is described as "the last line of defence", but the one thing that decides what functions get created — the manifest — is only checked against `TINKER_DEPLOY_MANIFEST_SHA256`, which the same caller supplies. So the backstop gives zero independent protection against K11's worst case (an absent or `public` invoker → `allUsers` on create); that lives only in the guard. Meanwhile `declarations.json` is in `files` for no functional reason, which reads as if it were being honoured.
Fix: after the sha matches, parse the sealed manifest and refuse unless every endpoint's `httpsTrigger.invoker`, `serviceAccountEmail` and `ingressSettings` equal `functions/declarations.json`'s (and refuse any endpoint without `httpsTrigger`). Both inputs are already byte-pinned to the approved commit, so this is a closed check that does not depend on the guard. If you'd rather keep the plan's split (F2 assigns it to the guard), at minimum say in the header comment why `declarations.json` is in `files` but unused, and log the deviation.

**4. `scripts/deploy-rules.sh:207` — `npm test` now depends on two scripts that aren't control files.**
`CONTROL_FILES` is documented as "the files that DECIDE … which tests" and lists `package.json`, `scripts/emulator-safety.js` and the `tests` tree — but not `scripts/functions-emulator.mjs` (which decides whether the functions suite runs or skips) or `scripts/functions-discover.mjs` (spawned by `tests/functions/manifest.test.js`). An approved sha carrying a different launcher would run *its* version while the guard reports the tip's machinery. Impact today is near zero (the suite skips in the rules worktree), but the invariant is stated and D2-3's control-file list (F1) inherits the same gap.
Fix: add both to `CONTROL_FILES` here, and to D2-3's list.

**5. `scripts/functions-discover.mjs:92` — nothing asserts the SDK came from the codebase's own install.**
`findFunctionsBinary` (`runtimes/node/index.js:100-115`) tries `functions/<cb>/node_modules/.bin/firebase-functions`, then the **repo-root** `node_modules`, then the resolved SDK path. The script that produces the bytes that get sealed and deployed refuses a stale `functions.yaml`, a non-empty `--out`, a wrong Node and a wrong CLI version — but not "a different `firebase-functions` ran". (Today the root has no `firebase-functions`, so it would throw rather than silently substitute; that's luck, not a check.) F5 puts the `.bin` assertion in the guard, but it belongs in the script that does the discovery.
Fix: refuse unless `join(sourceDir, 'node_modules/.bin/firebase-functions')` exists, and print its resolved `firebase-functions` version alongside `manifestSha256`.

**6. `scripts/functions-emulator.mjs:33,42` + `tests/functions/fixtures/env-probe/index.js:6` — the probe's watch list is the launcher's own denylist, so it can only confirm what the launcher already strips.**
`CREDENTIAL_VARS` ∪ `CLOUDSDK_*` ∪ `XDG_CONFIG_HOME` is exactly `WATCHED`. The test proves the mechanism works, but it cannot catch a credential-bearing variable nobody thought of, and the launcher currently forwards every other parent variable (`GITHUB_TOKEN`, `NETLIFY_AUTH_TOKEN`, `ANTHROPIC_API_KEY`, …) straight into the emulated function.
Fix: make `sanitizedEnv` an allowlist (`PATH`, `HOME`, `LANG`, `TZ`, `TMPDIR`, `NODE_OPTIONS`, plus what the test needs) and have the probe assert the function's env is a subset of that allowlist plus the emulator's own keys. Then the test fails when a new variable class appears.

**7. `tests/unit/predeploy-cli-path.test.js:56-70` — the test titled "the RESOURCE_DIR the CLI passes is the codebase folder" doesn't test that.**
It edits `firebase.json` on disk only, so the run refuses at `firebase.json differs from commit` — which the assertion at line 65 admits. M5's central claim (a hook run for another codebase refuses on `RESOURCE_DIR`) is exercised only by injecting `RESOURCE_DIR` by hand in `predeploy-check-functions.test.js:52-53`, never through the CLI's own `config.path(config.source)`.
Fix: commit a two-codebase variant `firebase.json` in the fixture (`core` + `other`, both folders present and tracked), run the hook with `only = 'functions'` so both predeploys fire, and assert the `other` one refuses with "the CLI is packaging …, not functions/core". That also pins the K5 fan-out behaviour for Phase E.

**8. D2-3 hazard — the seal survives a successful run, so a same-worktree retry refuses.**
On success `functions/<cb>/functions.yaml` is left in place by design (the CLI needs it), and after fix #2 it will still be left by a mid-seal crash of the CLI itself. `scripts/predeploy-check.sh:192` then refuses `"${src}/functions.yaml already exists."` on the next attempt. F7/D2-5's "the same sha re-runs under the same approval" path must therefore create a fresh worktree, or `deploy-functions.sh` must delete the seal in its cleanup (F5 says "deleted on cleanup" but doesn't say by whom). Worth stating in `FUNCTIONS-ROLLBACK.md` §3 now, since that's the runbook someone will read mid-incident.

---

## Nits

- **`scripts/predeploy-check.sh:192`** — `[ ! -e … ]` follows symlinks, so a symlink planted after the F3 walk slips past it. macOS `cp` refuses a *dangling* destination symlink (I checked), so there's no arbitrary-write primitive; the result is a bare exit 1 with no message. Add `&& [ ! -L "${src}/functions.yaml" ]` for a clear refusal.
- **`scripts/predeploy-check.sh:164`** — a *symlinked* top-level `functions/<cb>/node_modules` is silently pruned rather than refused (confirmed with `find`). Harmless, because `ignore`'s `node_modules` matches the basename and excludes it from the upload — but it's the one exception to "only regular files and folders" and isn't noted.
- **`functions/core/package.json:10-11`** — F2 specifies "an exact-pinned `firebase-functions`"; the codebase also pins `firebase-admin@14.5.0`, which the canary never requires. It's defensible (it's a non-optional peer of `firebase-functions@7.4.0`, whose range does include `^14`, so npm would install *something* anyway) and `firebase-config.test.js` locks it in — but it's an undocumented deviation. Log it in the plan's decisions log.
- **`package.json:5`** — the description's em dash became `\u2014`. Unrelated churn in a file that's in the rules guard's `CONTROL_FILES`; revert it.
- **`scripts/predeploy-check.sh:41`** — `$JQ` is pinned to `/usr/bin/jq`, but `git`, `shasum`, `find`, `sort`, `comm`, `cut`, `awk`, `grep`, `cmp` and `mktemp` all come from `$PATH`. Either pin the rest or drop the pin; the asymmetry implies a guarantee that isn't there.
- **`scripts/emulator-safety.js:54-55`** — functions mode requires `ports.functions !== 5001` but not `ports.hub !== 4400`, so the cross-repo check it relies on isn't itself pinned away from the default; and a missing `emulators.hub` yields "not this repo's pinned port undefined".
- **No test for two backstop refusals**: a quoted/unusual path in the commit (`predeploy-check.sh:136`) and "the sealed manifest is inside `${src}`" (`:191`). The test at `predeploy-check-functions.test.js:232-239` documents that F3 pre-empts the second, which leaves that branch effectively unreachable in the suite.
- **`tests/unit/functions-emulator.test.js:36`** pins the exact `npm test` string; F10's list has five suites, so D2-3 will have to edit this assertion when it adds the functions-guard suite. Fine, just flagging the coupling.
- **`AGENTS.md:27`** still says `npm test` is "(emulators only, project `demo-my-clay-hub`)". A3/D2-4 rewrites this file, but F10's "stale `npm test` descriptions" pass caught `CLAUDE.md` and `deploy-rules.sh` and skipped this one.
- **Plan fidelity — `my-clay-hub-phase-d-project.html:94`**: D-1's checklist step 11 still says "create **`functions-build@`** … Grant it nothing (C5)" with no M7 annotation, while the acceptance bullet at line 78 and C5 at line 60 are both correctly marked superseded. Everything else checks out: M1–M5 inline at `clayhub-members-foundation.html:571-575`, M6 at `:553`, M7 at `:280`/`:527`/`:530`, and M6/M7 in the Phase D plan at `:245`/`:34`/`:60`/`:78` — and no remaining `actAs`/`functions-build@` statement is false.

---

One thing I did not verify myself, being read-only: the rules-worktree `npm test` run (it needs `git worktree add`). The reasoning holds — `functions-emulator.mjs` derives `ROOT` from its own module URL, so `CODEBASE_MODULES` points into the worktree, where `functions/core/node_modules` doesn't exist (`deploy-rules.sh:324` symlinks only the root), so it skips and exits 0 — and `deploy-rules.test.sh` fakes `npm`, so the guard suite never runs the functions suite at all.
