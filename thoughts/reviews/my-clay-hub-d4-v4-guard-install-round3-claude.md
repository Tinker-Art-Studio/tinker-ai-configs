I could not run `deploy-functions.test.sh` (it needs an approval I don't have), so the commit message's "tests pass" and its mutation counts (1, 7, 8, 5 failures) are **unverified by me**. Everything below is static analysis plus direct reads of the real lockfiles, `firebase.json` and the tracked file modes.

## 1. Each round-2 finding

**Codex blocking 1 — package files escaping via symlinks or local dependencies: resolved, on both halves.**

- Symlinked package file: `scripts/deploy-functions.sh:597` now runs `folder_check` for each other codebase *before* its `npm ci`. That is the real F3, so the commit side refuses mode `120000` anywhere under the folder (`scripts/predeploy-check.sh:151`) and the disk side refuses any symlink, FIFO, socket or non-regular file (`:168-172`) and requires every path to hash to the commit's blob (`:174-195`). A symlinked `functions/vault/package-lock.json` can no longer reach npm. Tested end-to-end at `scripts/deploy-functions.test.sh:531-537`, including that `/tree/functions/vault cwd=` never appears in the fake npm's log.
- Local dependencies: `lockfile_check` (`scripts/deploy-functions.sh:611-621`) refuses any `packages` entry with `link: true`, a `resolved` that isn't `https://registry.npmjs.org/…`, or an `integrity` that isn't `sha512-`. A `file:`/`link:`/`git` dependency is caught on both of its lockfile entries (the `link: true` stub and the path-keyed target, which carries no `resolved`). Tested for *both* codebases at `:542-550`.

**Codex blocking 2 — the deployed codebase's `npm ci` running before its folder was proven: resolved.** `build_expected` now does `folder_check` + `lockfile_check` at `scripts/deploy-functions.sh:648-649`, ahead of `install_codebase` at `:650`. The committed-`functions/core`-symlink case is covered too: `git rev-parse "${sha}:functions/core"` resolves to a blob, and `predeploy-check.sh:140` refuses "commit … has no functions/core" — before any lifecycle script runs.

**Claude should-fix 1 — `npm test` loading the other codebase's unpinned, unshown source: resolved for `functions/<other>`.** `:562` now adds the whole folder to `CONTROL_FILES`, not just its two package files, so it is tip-pinned (`control_file_diff:123-130`, which already handles tree paths — `tests` is one) and listed by `show_machinery:134-148`. Tested at `:524-529` (a change to `functions/vault/index.js` → exit 14). See should-fix 1 below for what this *didn't* cover.

**Claude should-fix 2 — the vacuous assertion: resolved.** `:335` now greps the core install line out of the log and asserts `--ignore-scripts` is absent from it, and `:336` asserts that line exists at all. Under the mutation "install core with `--ignore-scripts`", both fail.

## 2. Can the new rules wrongly refuse, or break `--reconcile` / `--reverify`?

**No, on every axis I could check.**

- Real lockfiles: both are `lockfileVersion: 3` with 266 packages and **0** entries that violate the new rule (no `link: true`, every `resolved` on `registry.npmjs.org`, every `integrity` `sha512-`). Same for every historical version on main (`35f8f49`, `1053127`) and for the live newest attempt's commit `7efa0f0` — so `--reverify` on `deployed/my-clay-hub/functions-core/20261001T045900Z-7efa0f0` is unaffected.
- Real folders: all 14 tracked files in `functions/core` and `functions/vault` are mode `100644`, no `.env*`, no `functions.yaml`, both lockfiles and package.jsons committed, neither package.json depends on a `node` package — so F3 on vault during a core deploy passes.
- `firebase.json`: both entries match `predeploy-check.sh:124-130`'s pinned shape exactly, which F3-per-codebase now requires of the *other* codebase too.
- Pre- vs post-install F3 differ only by `functions/<cb>/node_modules`, which `predeploy-check.sh:176` prunes — so the new `folder_check "before install"` cannot refuse where the existing `"before discovery"` one passes.
- `--reconcile`/`--reverify` never call `install_other_codebases`; they reach the new checks only through `build_expected`, covered above. The `CONTROL_FILES` growth does widen `verifier_fields`→`control_file_diff` (nit 4), but `firebase.json` is first in the list and already differs for the live attempt, so nothing changes there in practice.

## 3. Still executing content Christie didn't approve

**Should-fix 1 — `shared/` is the same gap, still open.** `scripts/deploy-functions.sh:1031` runs `npm test`, whose `test:unit` script runs `tests/shared/*.test.js`, which import `../../shared/denver-time.js` and `../../shared/derive-status.js` (`tests/shared/denver-time.test.js:6`, `tests/shared/derive-status.test.js:5`). `tests` is a control file (`:122`) so the test files are pinned — but `shared/` is in neither `CONTROL_FILES` (`:122`, `:562`) nor `SHOWN_PATHS` (`:116`). So two modules execute as the deploying user, from the worktree, with their content neither tip-pinned nor visible in the `--diff` Christie approves. That is precisely the promise `:132-133` makes and that round 2 made blocking for `functions/<other>`. Risk profile is identical to the one just fixed: the code must be on `origin/main` at an ancestor commit, and nothing wrong can *ship* this way. Fix: add `shared` to `CONTROL_FILES` at `:122` — one word. Pre-existing and outside this branch's stated scope, so landing it separately is defensible; leaving it unrecorded is not.

Two things I checked and cleared: `npm ci` for the deployed codebase still runs lifecycle scripts, but now only from registry tarballs pinned by sha512 in an F3-proven lockfile, so those bytes are the approved commit's; and `functions/*/`'s source contains no reference to `shared/`, so nothing ships from it.

## 4. Are the new tests meaningful?

Yes — this is the strongest test round of the three. `:531-537` (symlinked lockfile) and `:542-550` (`file:` dependency, run against *both* codebases) each reproduce the exact blocker scenario and assert the refusal *and* that npm never touched the folder. `:337-341` pins the ordering itself by line number in the output, so moving either proof back behind its install fails the suite. `:538-541` proves `folder_check` really is F3 rather than an ad-hoc check, by catching a committed `.env.local`. And `:551-555` is a positive control — a registry dependency with a `sha512` integrity still exits 0 — which is what stops the new rule from regressing into a blanket refusal. There's no direct test for a symlinked package file in the *deployed* codebase, but `:340` plus the `who=core` leg of `:542-550` cover that path between them.

## Findings

**Should-fix**

1. `shared/denver-time.js` and `shared/derive-status.js` execute under the guard's `npm test` but are in neither `CONTROL_FILES` nor `SHOWN_PATHS` — detailed above (`scripts/deploy-functions.sh:116`, `:122`, `:1031`).

2. **The two comments that document the order this commit changed are now wrong.** The script header still reads "installs the codebase with Node 22 (npm ci --prefix), proves the folder is the commit (F3), discovers…" (`scripts/deploy-functions.sh:15-16`), and `build_expected`'s one-line contract still reads "worktree, install, F3, discovery, checks, F3 again" (`:646`) — both describe the pre-fix order, which is exactly what Codex's blocker 2 was about. In a guard where the header is read as the spec, this is the one thing I'd fix before merging.

**Nits**

3. The `.env` test (`scripts/deploy-functions.test.sh:538-541`) asserts only exit 31 — not the message, not that npm stayed away — unlike its three neighbours. Any other exit-31 cause passes it.

4. Round-2 Claude's nit 4, widened: `control_file_diff` now reports `functions/<other>` for a change to the other codebase's *source*, so `--reverify`/`--attest`/`--reconcile` demand `--acknowledge-verifier-change` for a change no mode but `--approved` ever uses. Over-strict, not wrong, and the message names it.

5. Round-2 Claude's nits 6 and 7 stand: `:529`'s `--diff` assertion runs with `BASE=EMPTY_TREE`, so it would pass whether or not vault changed (it does prove membership in the machinery list); and still no scenario deploys `--codebase vault` with `core` as the other codebase.

6. `--diff` names the other codebase as a `git diff --stat` line only (`show_machinery:147`), not a full diff — consistent with all other machinery, but read the commit message's "named in `--diff`" as *named*, not *shown*.

7. A lockfile entry with `inBundle: true` usually carries no `resolved` and would be refused by `:616-617`. Neither real lockfile has one; fail-closed with a clear message, so a future papercut rather than a defect.

8. F4 now runs against every codebase on a single codebase's deploy, so a misconfigured `vault` entry blocks a `core` deploy. Fail-closed and arguably the point, but it widens the blast radius of one bad entry.

## Verdict

**merge after fixes** — nothing blocking survives, and both remaining items are one-liners: correct the two stale order comments (`:15-16`, `:646`), which this commit itself invalidated, and either add `shared` to `CONTROL_FILES` or record it as a tracked follow-up. If you'd rather keep `shared/` out of this branch's scope, the comment fix alone is enough to merge.

Please run `npm run test:functions-guard` (ideally full `npm test`) before merging — like round 2's Claude, I was not able to.
