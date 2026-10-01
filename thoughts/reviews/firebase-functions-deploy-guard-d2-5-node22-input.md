# Implementation review: my-clay-hub commit fa76d36 (branch fix/node22-test-paths)

You are an independent reviewer. Read-only: do not edit, commit, run any Firebase CLI command, or contact any network service. Inspect the repo at /Users/christiehubley/my-clay-hub (run `git show fa76d36`, read files). You may run `node --test` on individual unit test files with either Node (`node` is 20; `/opt/homebrew/opt/node@22/bin/node` is 22). Do not run `npm test` (it starts emulators and takes 10 minutes; it is being run separately).

## Background
- `scripts/deploy-functions.sh` (the functions deploy guard) runs the repo's full `npm test` in a fresh worktree of the approved commit, with Node 22 first on PATH, before deploying. Red tests = refuse.
- The first approved run (on 6d58838) was refused: under Node 22, `node --test tests/unit/ tests/shared/` fails with "Cannot find module …/tests/shared" (Node 22 treats positional args as files/globs; Node 20 searched folders). Nothing was deployed.
- Every earlier full-suite run used the host's Node 20, and the guard's own suite (`scripts/deploy-functions.test.sh`) fakes npm, so this was never exercised.

## The change (git show fa76d36)
- package.json: `test:unit` → `node --test --test-timeout=120000 tests/unit/*.test.js tests/shared/*.test.js`; `test:rules` → `… tests/rules/*.test.js` inside the `firebase emulators:exec "…"` string.
- tests/unit/tz-matrix.test.js: spawns `process.execPath --test <each tests/shared/*.test.js>` instead of the folder.
- tests/unit/test-scripts.test.js (new): asserts no npm script passes a folder (arg ending in `/`) to `node --test`.

## What I want reviewed
1. Does each changed command run EXACTLY the same set of test files under Node 20 and Node 22 as Node 20's folder search did before? Node 20's folder search matched patterns like `*.test.js`, `*-test.js`, `*_test.js`, `test-*.js`, `test.js`, and anything under a `test/` dir, plus `.cjs`/`.mjs` variants. Check every file in tests/unit, tests/shared and tests/rules: is any test file now silently dropped, or a non-test helper (functions-fixture.js, run-lifecycle-hook.cjs, fingerprint.js, env.js) now run?
2. The `test:rules` glob is inside a string that `firebase emulators:exec` runs. Is it expanded by a shell there (firebase-tools 15.22.3 — check `node_modules/firebase-tools` source for how emulators:exec spawns the script), and then passed through `scripts/emulator-safety.js -- node --test …` correctly? If the glob reached node unexpanded, would Node 22 still work and would Node 20 fail?
3. Any other place that runs `node --test <folder>` or otherwise behaves differently under Node 22 that the guard's `npm test` would hit (scripts/, tests/, scripts/functions-emulator.mjs, the functions tests)?
4. Is test-scripts.test.js a sound regression check (false negatives? e.g. a folder without trailing slash, quoting)? Is the tz-matrix MIN_SHARED_TESTS guard still meaningful?
5. Anything in this change that affects what the guard ships or how it verifies (control files: package.json and tests/ are in CONTROL_FILES)?

## Output
Verdict first: "ready", "ready after fixes", or "not ready". Then findings as blocking / should-fix / nit, each with file:line and a concrete failure scenario. Keep it short.
