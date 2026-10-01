I've read the plan (v5 + its round‑4 overrides), all five scripts, the manifest/list files, the test additions, `netlify.toml`, `.gitignore`, and probed the live site read‑only. Here's the review.

## Plan conformance

Every item in Phase 1 is implemented, including all ten round‑4 overrides (M1 lag-vs-leak, M2 assertions in `schedule-editor-wiring.test.js`, L1–L10). I found no omissions and only two intentional-looking deviations, both benign:

- Round 4 L7 asked `deploy.sh` to turn a busy port 8080 into a plain message; it lives in `preflight.sh:8-11` instead — which `deploy.sh:31` calls, so the behaviour is identical. Port 8080 is the right port (`firebase.json` pins the firestore emulator to it).
- `must-not-be-public.txt:17` adds `netlify/functions/_lib/shift-reminder.js` beyond the plan's list, and `netlify.toml`'s comment says `bash scripts/build-dist.sh` where the plan said `sh` — correct, since the scripts use process substitution.

Verified independently: the candidate set is exactly 21 files = 18 manifest + 3 private, no overlap (`bash scripts/candidate-set.sh`); the 16 `APP_SHELL` entries + 4 manifest icons + `sw.js` + the 12 local `index.html` refs reduce to exactly the 18 manifest paths; nothing in the repo references the four deleted pages or `.netlifyignore`; there is no `_redirects`/`_headers`/`robots.txt` to lose (the SPA fallback is in `netlify.toml:17-20`, which CLI deploys honour — that's how it works live today).

Live probes (read-only, today): unknown path → `200` + the 76,689-byte shell; `KIOSK-PLANNING.md` → `200 text/markdown` 6,472 bytes **with `?v=probe` appended**, which re-confirms the cache-buster can't mask a leak; `preview-shift-reminders` → `401`; `send-timeoff-submission-email` → `405`; `/netlify.toml` → `404` (Netlify refuses to serve its own config, so the "every unknown path is 200" premise isn't universal — `private_verdict` accepts 404, so that's fine).

## BLOCKING

None.

I specifically looked for a false-pass route and did not find one:

- **Nothing uncommitted, unlisted or dotted can reach `dist/`.** `build-dist.sh:35` is pure `git archive HEAD` of the manifest; `:36-37` then asserts `find . -type f` == the sorted manifest (so an `export-ignore`, a symlink, or a stray extra file all fail); `:24-29` asserts the tracked candidate set partitions exactly into public/private. If `candidate-set.sh` itself fails inside the process substitution, the `stale` check at `:28-29` fires loudly rather than passing empty.
- **`build-dist.sh` cannot pass while incomplete.** If one of the three extractors at `:41-43` matches nothing, `set -e` aborts the brace group, `pipefail` makes the whole pipeline non-zero, and the assignment at `:40` aborts the script. (See L1 — the failure is loud but has no message.)
- **No gate in `deploy.sh` can be skipped.** `:22-28` are all `[ … ] || refuse` under `set -euo pipefail`, the preflight re-run at `:31` precedes the upload at `:35`, and `set +e` is turned off only at `:36`, after the upload.
- **`check-live.sh` can't false-pass on a stale CDN**: if the CDN still served the old deploy, the 17 private paths that leak today would still return their own bytes → `leak` → exit 1. And an empty `SHELL_HASH` (missing `dist/`) fails the shell check rather than matching everything.
- The classic bash trap is avoided: `fail=1`/`inconclusive=1` are set in plain `for` loops and functions, never in a piped loop, so they survive.

## MEDIUM

**1. `scripts/check-live.sh:40-43` — a CDN that hasn't flipped yet is reported as a hard failure, with no "re-run" advice.** This deploy *does* change `index.html` (9 lines vs the live commit `4ac3d09`, plus `js/app.js`, `js/schedule-helpers.js`, `js/firebase-data.js`, `sw.js`), so the shell check genuinely depends on propagation. After one 15 s retry it prints "private results would be unreliable; stopping" and exits **1** — the same code as a real leak — while the equivalent private-path condition exits 2 with "wait a minute and re-run". Worse, the plan's own failure BDD says a check-live failure means "republish the previous deploy in Netlify's UI", which would be exactly the wrong move here. This path should exit 2 and say "re-run `bash scripts/check-live.sh <sha>`".

**2. `scripts/check-live.sh:73` with `scripts/deploy.sh:33,39` — the lag/leak discrimination is single-use, and can't cover the paths that actually leak today.** Two compounding gaps: (a) `PREV` is a `mktemp` file deleted at `deploy.sh:39`, and the re-run documented in `CLAUDE.md` passes no second argument, so `PREV_HASH` is empty and "200, not the new shell" collapses to `leak` → exit 1. (b) More fundamentally, all 17 currently-leaking paths serve *their own bytes*, not the previous `index.html`; a lagging edge therefore returns `user-import.html`'s real content, which hits `echo leak` at `:74`, never the `lag` branch. The lag branch can only fire for a path that already served the fallback. So the realistic lag outcome on this one deploy is a false `PUBLIC user-import.html … must not be public` — the most alarming possible wrong verdict. Probability is low (the shell-first check at `:36-43` means the edge is already on the new deploy), but the fix is cheap: keep the previous `index.html` at a stable path instead of `mktemp`+`rm`, and print that path in the INCONCLUSIVE line so the re-run can use it.

## LOW

- **`scripts/build-dist.sh:40-45`** — if `sw.js`'s `const APP_SHELL = [` line or `manifest.json`'s `"src"` entries are ever reformatted (e.g. `Object.freeze([`), the grep matches nothing, the group aborts, and the script exits 1 with **no** `[build-dist] REFUSING:` message — the one place the design doesn't name the problem. `|| true` per extractor plus an explicit "refs must include sw.js and index.html" assertion would keep it loud *and* legible. (The jest test at `schedule-editor-wiring.test.js:2456` catches an `APP_SHELL` rename independently, via `.match(…)[1]` throwing.)
- **`scripts/build-dist.sh:29`** — "listed but not a tracked file" also fires when a listed file simply isn't in the candidate set, which is the more likely future cause (a `_headers`, `robots.txt`, or a new top-level `fonts/`). It also means the allowlist can only ever publish candidate-set paths; publishing anything else requires editing `candidate-set.sh:8`. Loud, but the message points at the wrong cause.
- **`scripts/build-dist.sh:40-48`** — completeness parses `index.html` src/href, `APP_SHELL` and manifest icons only. I confirmed there are no `url()` references in `css/` and no `import`/`importScripts` in `js/` today, so the coverage is complete *now*; a future CSS `url(../fonts/x.woff2)` would be caught only if it lands under `js|css|assets`.
- **`scripts/check-live.sh:57`** — `type_ok` returns true for an *empty* content type on a `.js`/`.css`/`.html` file, because `case "  " in *" "*` matches. Unreachable in practice (a 200 with a byte-identical body is also required), but the type gate is weaker than it reads.
- **`scripts/check-live.sh:31`** — one transport blip in ~47 requests aborts with exit 1 and without the `[check-live] FAILED` line: same signal as a leak, after a successful upload. Exit 2 fits the plan's own "inconclusive" semantics.
- **`scripts/check-live.sh:94-95`** — the `401`/`403` expectations are platform behaviour; a Netlify change turns a good deploy into exit 1. I re-verified `401` and the `405`s live today; the `403` rests on the plan's Sep 30 check and your dry run.
- **`scripts/deploy.sh:23` and `scripts/preflight.sh:6`** — if `git status --porcelain` itself fails, `[ -z "$(…)" ]` reads as "clean" (the substitution's failure is swallowed inside the test, and `set -e` doesn't fire inside an `||` list). Harmless here: the upload is `git archive HEAD` bytes either way.
- **`scripts/deploy.sh:33-40`** — no `trap`: a failed `netlify deploy` (aborted by `set -e`) leaves the mktemp file behind.
- **`scripts/build-dist.sh:35`, `scripts/check-live.sh:59,76`** — `$(cat …)` is word-split *and* glob-expanded; a path with a space or `*?[` would misbehave. None exists; `while read -r` would be exact.
- **`scripts/check-live.sh:20`** — the standalone re-run compares live bytes against whatever `dist/` currently holds, and never checks that `dist/` was built from the `<sha>` argument. Fine inside `deploy.sh`; a loose end for the documented manual re-run.
- **`scripts/must-not-be-public.txt`** — samples 3 of ~20 test files and 2 of 26 function sources where the plan's acceptance says "every path in the table"; `netlify.toml` isn't listed (it answers 404 anyway, so it would pass). Structurally redundant once only `dist/` is uploaded, so I'd leave it.
- **`package.json:6-7`** — `npm test` runs twice per deploy (deploy:check, then `deploy.sh`'s re-run): two full emulator suites, by design (round 2 B2), but budget the time. Also bare `npm run deploy` exits 1 around a purely informational message, so npm wraps it in an ELIFECYCLE error.

## What the first real `npm run deploy` will trip on

1. **Order matters**: merge to `main`, push, *then* `npm run deploy:check` — `deploy.sh:22` requires `--approved` to equal `main`'s HEAD, so a sha from a preflight run on `fix/sub-confirm-manager-only` will be refused if the merge isn't a fast-forward.
2. Port 8080 must be free, twice.
3. **The one unverified assumption**: that `netlify deploy --prod --dir dist` still bundles functions from `netlify/functions` with `included_files`. `--dir` sets only the deploy folder; the functions dir comes from `netlify.toml` resolved at the repo root — two design reviewers checked this and `check_fn` will tell you immediately. If you want belt-and-braces, `--functions netlify/functions` on `deploy.sh:35` costs nothing. If it ever did go wrong, the recovery is the free instant republish of the previous deploy in Netlify's UI, not a second paid deploy.
4. If check-live reports a shell mismatch or a single `PUBLIC` immediately after the upload, **re-run check-live first** (and glance at the deploy's file list in Netlify) — do not follow the plan's "republish the previous deploy" on that signal alone. See MEDIUM 1 and 2.

One upside worth recording: because `netlify.toml:7` now says `publish = "dist"`, even a careless hand-run `netlify deploy --prod` can no longer republish the repo root — it publishes `dist/` or errors out.

And the exposure itself still isn't closed by this commit: old deploy URLs keep serving `user-import.html`, so the 8 password resets in `tinker-hq-apps` → Authentication remain the step that actually ends it.

Any of the fixes above would be an edit inside `~/tinker-timeclock`, which needs your written approval first — say the word and I'll put up the ones you want.

**ready to deploy — yes.** No blocking defects: nothing private can be published, nothing uncommitted can ship, and no gate can be bypassed. Both MEDIUMs are about how an inconclusive result is *reported* after a successful upload, not about safety; they're worth fixing before the deploy if you'd rather not read a false "PUBLIC user-import.html", but they don't make shipping unsafe.
