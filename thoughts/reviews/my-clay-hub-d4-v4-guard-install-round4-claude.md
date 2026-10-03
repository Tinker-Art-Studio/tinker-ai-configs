Reviewed `bbfe95b` on top of the whole branch (`main...d4-guard-install-all`), against both round‑3 reviews. **I did not run the suites** — my sandbox needs approval to create a temp folder, and you told me not to run the harnesses in that case. `bash -n` also needed approval, so everything below is static analysis plus reads of the real tags, trees and lockfiles.

## 1. Each round‑3 finding

**Codex blocking (mktemp / `rm -rf` targeting the repo) — resolved, in both harnesses.**
`scripts/deploy-functions.test.sh:26-30` and `scripts/deploy-rules.test.sh:31-35`: a failed `mktemp` now exits 1 before any `cd`; `T` must be non-empty, a real directory and not a symlink; `pwd -P` must succeed; the name must match `functions-guard-test.??????` / `deploy-guard-test.??????`; and the EXIT trap removes only a path matching that same pattern. The repo path can never match it, so the exact failure Codex hit is closed. It also closes the *second* instance of the hazard, which nobody named: `rm -rf "$TMPDIR"/*` at `deploy-functions.test.sh:250` and `:658` — `TMPDIR` is `"$T/tmpdir"` (`:32`), so it is now derived from a validated `T`. I verified `T` is never reassigned after `:28` / `:33`.

**`shared/` pinned and shown — resolved for this guard.** `deploy-functions.sh:123` adds `shared`; it is absent from `SHOWN_PATHS` (`:117`), so `show_machinery:137-148` lists it whenever it changes. "Named in `--diff`" is accurate (a `--stat` line, like all other machinery).

**Stale order comments — resolved and accurate.** `:15-18` and `:647` now read F3 + lockfile → install → F3 → discovery + checks → F3 → other codebases → `npm test`, which is exactly `build_expected:648-655` plus `install_other_codebases` at `:1030`.

**The two weak assertions — both now real.**
- `:522` greps for `/tree/functions/vault cwd=`, which is the string the fake npm actually writes (`:62` logs `npm $* cwd=$PWD`, and `TMP="${WORK}/tree"` at `deploy-functions.sh:569`, `--prefix "$dir"` last at `:601`). Crucially `:339` is a positive control asserting that string *is* present on the happy path, so `:522`, `:542`, `:548` and `:556` are non-vacuous. That is a better fix than Codex asked for.
- The `.env` test gained `:547` (message) and `:548` (npm stayed away). `predeploy-check.sh:156` emits exactly `has a committed functions/vault/.env.local`, so `:547` matches the real text.

## 2. Can the new harness guard or trap misfire?

No, on every axis I could check. `mktemp -d` with an `XXXXXX` template always substitutes exactly 6 characters, so `??????` cannot reject a genuine scratch folder; `pwd -P` guarantees the leading `/`; a symlinked TMPDIR spelling (`/tmp`→`/private/tmp`, `/var`→`/private/var`) is resolved before the `case` and leaves the basename alone; `[ ! -L "$T" ]` is correctly applied to the pre-resolution path. The only path on the machine that can match the pattern is the one `mktemp` just created, so the trap cannot remove anything else. The guard itself already had this shape (`deploy-functions.sh:478` `TMP=""; WORK=""` + the `[ -n ] && [ -d ]` guards in `cleanup:479-488`), so the harnesses now match it.

Two theoretical refusals, both fail-safe: `TMPDIR=/` yields `/functions-guard-test.abcdef`, one slash, which `/*/…` won't match → the harness refuses rather than deletes; a relative `TMPDIR` lands the scratch inside the repo, and the trap removes only that folder (the repo survives, an empty `tmp/` is left behind).

## Findings

**Should-fix**

1. **`shared` is a control file with no fixture coverage** — `deploy-functions.sh:123`, fixture at `deploy-functions.test.sh:203-235`. `deploy-rules.test.sh:138` states the invariant this breaks: *"Every CONTROL_FILES entry exists in the fixture: a file missing on both sides compares equal ('missing'), so a control file absent here could be dropped from the guard with the suite still green."* The functions fixture never creates `shared/`, so this round's own addition is untestable — delete `shared` from `:123` and the suite stays green. ~4 lines: create `shared/denver-time.js` in the fixture, then a refusal test mirroring `:525-528` (approved sha whose `shared/` differs from the tip → exit 14) and a `--diff` naming assert mirroring `:534`.

2. **The identical `shared/` gap is still open in the rules guard.** `scripts/deploy-rules.sh:247` runs the full `npm test` in the worktree, and its `CONTROL_FILES` (`:101`) has no `shared` — so `shared/denver-time.js` and `shared/derive-status.js` still execute from the approved (possibly older) commit, neither tip-pinned nor named in that guard's diff, on every firestore / storage / indexes deploy. Round 3 raised the gap against the functions guard only; this fixed half of it. It also makes `deploy-functions.sh:119-120`'s "the rules guard's list, plus…" no longer literally true. The rules fixture already creates every control file (`deploy-rules.test.sh:140-147`), so this is one word plus one fixture line — or record it as a tracked follow-up.

3. **No scenario deploys `--codebase vault` with `core` as the other codebase** (Claude round‑3 nit 5, still open). This matters more than it did: `deploy-functions.sh:580` says the whole change was "found by vault's first deploy, Oct 3", and there is no `deployed/my-clay-hub/functions-vault/…` tag — only the two `functions-core` ones. So the next real use of this guard is the one path with zero coverage: `OTHER_CBS=core`, `SRC=functions/vault`, and vault's own `install_codebase` requiring `node_modules/.bin/firebase-functions` (`:578`). One extra happy-path run with `--codebase vault` would close it.

**Nits**

4. The header's new sentence (`:15-18`) is accurate but the break at `:18` ("runs npm test with") is now awkward — cosmetic.
5. `??????` in both harnesses is coupled to the `XXXXXX` two lines above it; changing one without the other refuses loudly. Fail-closed, but worth a word in the comment.
6. If `:27`, `:28` or `:29` refuses after `mktemp` succeeded, the scratch folder leaks (the trap isn't installed yet). Practically unreachable.
7. Round‑3 Claude's nits 4, 6, 7, 8 (`control_file_diff` widening, `inBundle` lockfile entries, F4 running against every codebase) stand as recorded — all fail-closed.

## 3. Does adding `shared` break anything?

**No.**
- `verifier_is_tip:537-543` uses its own fixed two-file list, not `CONTROL_FILES`, so a tree path can never reach its `cmp` (that would have been the breakage).
- `control_file_diff:124-131` and `show_machinery:135-148` both already handle tree paths (`tests` is one). For a commit with no `shared/`, both sides read `missing` → equal, and `git diff --quiet -- shared` is quiet — so a fixture without `shared/` does not refuse.
- **`--reverify` of the live core attempt is unaffected:** `shared/` is byte-identical between `7efa0f0` and `origin/main` (`af5a87d`), and `firebase.json` — first in the list — already differs, so `control_file_diff` still returns `firebase.json` and the `--acknowledge-verifier-change` requirement is exactly what it was. `codebase_on_tip` runs for every tag-writing mode (`:1009`), so `OTHER_CBS` / the `functions/<other>` entries are consistent across modes too.
- The one behavioural change is intended: `--approved <older sha>` now also refuses when `shared/` has moved on, the same rule `tests` already carries.

## 4. Anything else

Nothing new in the guard. I re-checked the ordering interaction nobody has raised: `install_other_codebases` runs after `folder_check "after discovery"`, so `functions/vault/node_modules` appears in the worktree before the CLI's predeploy hook re-proves `functions/core` — but `predeploy-check.sh:176` prunes only `${src}/node_modules`, and vault's tree is outside `functions/core`, so neither F3 nor the manifest hash is disturbed. Also confirmed `firebase.json` being first in `CONTROL_FILES` means the approved commit's `OTHER_CBS` (read from `MAIN_SHA`) always matches the worktree's.

**Please run `npm test` (or at minimum `npm run test:functions-guard` and `npm run test:guard`) before merging** — the commit message's "tests pass" is unverified by me, and the three new assertions at `:522`, `:547-548` have never been executed in a review.

**merge after fixes** — nothing blocking survives, and the three round‑3 findings are genuinely closed. The one item I'd land in this branch is should-fix 1 (fixture coverage for `shared`, this round's own change, against the suite's own documented invariant); should-fix 2 and 3 are defensible as recorded follow-ups if you'd rather keep the scope tight.
