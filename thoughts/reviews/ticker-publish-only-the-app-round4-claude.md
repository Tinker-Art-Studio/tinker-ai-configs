I have everything I need. Here's the review.

---

# Round 4 (Claude) — `ticker-publish-only-the-app` v4

Read-only throughout: no edits, no writes to the repo, nothing under `.claude/`, no `netlify` commands. Live probes were GETs. Everything below that says "verified" I ran today.

## Verification of the plan's load-bearing facts

**The live commit is `origin/main` = `4ac3d09`, not `6cc4732`** (round 1's identification was off — `index.html` happens to be 76,689 bytes at both). This matters because it gives a much stronger version of the premise the whole design rests on. Blob size at `4ac3d09` vs live download size, all eight:

| file | `4ac3d09` | live | |
|---|---|---|---|
| `index.html` | 76689 | 76689 | ✓ |
| `js/app.js` | 518196 | 518196 | ✓ |
| `css/styles.css` | 53621 | 53621 | ✓ |
| `css/auth-guard.css` | 1553 | 1553 | ✓ |
| `sw.js` | 4708 | 4708 | ✓ |
| `manifest.json` | 685 | 685 | ✓ |
| `assets/favicon.svg` | 114 | 114 | ✓ |
| `assets/icon-maskable-192.png` | 31769 | 31769 | ✓ |

**Netlify applies no transformation to any media type here** — HTML, JS, CSS, JSON, SVG, PNG all byte-identical. Asset optimization is off. The faithful byte check will not fail spuriously. Live `sw.js` is `v24`, `HEAD` is `v25`, so the cache bump ships fresh and the offline BDD (plan:157) holds. `HEAD:index.html` is 76,913 — **+224 bytes vs live**, which is what MEDIUM 1 below turns on.

**All nine functions, verified live just now** (GET, nothing sent): `preview-shift-reminders` 401 `application/json` 24 B · `send-shift-reminders` 403 `text/plain` 0 B · the other seven 405 `application/json` 30 B · and `does-not-exist-xyz` **200 `text/html` 76689** — B1's premise re-confirmed. `preview-shift-reminders.js:26` gates before the method check and `secretMatches` fails closed on an unset env var, so the 401 holds whether or not `REMINDER_PREVIEW_SECRET` is set.

**The cache-busting query does not mask a leak** — the one way `?v=<sha>` could have turned the private check into a no-op. `/CLAUDE.md?v=test123` → 7,588 real bytes; `/package.json?v=` → 1,404; `/user-import.html?v=` → **4,004 (the passwords page, live right now)**; `/netlify/functions/send-shift-reminders.js?v=` → 5,220. Static files win over the query. Safe to use everywhere.

**The partition is exact and there is no false refusal.** I computed the candidate set with the plan's own filter (`^(js|css|assets)/|^[^/]+\.(html|json)$|^sw\.js$` over `git ls-files`): 25 today, 21 after the four deletions = 18 manifest + 3 private (`firebase.json`, `package.json`, `package-lock.json`), no overlap, nothing left over. `.firebaserc` isn't `*.json` so it isn't a candidate; the 20 root `*.test.js` files aren't candidates (only `sw.js` by name) — necessary, or the build would refuse on all 20. The new `scripts/*` files aren't candidates either. ✓

**Completeness-check inputs are sufficient for today's tree:** no `url(` in either CSS or in `index.html`, no `srcset`/`poster`/`xlink:href`/`@import` anywhere, no `fetch()` of a local file (all 8 are `/.netlify/functions/*`), `sw.js` registered only at `js/app.js:106`. The only local-path string in `js/` is `js/auth-guard.js:15`'s comment `assets/logo.png` — still there, so M6's "don't grep js" is still load-bearing. **Zero references to the four doomed pages** anywhere in the repo (ripgrep, whole tree). `summer-camp-sync.html` is recoverable from `f53788d` (35,596 B) as claimed.

**Fallback shape for every private-path class:** `/nope.log`, `/NOPE.md`, `/netlify/functions/nope.js` all → 200 + 76,689 shell. `/netlify.toml` → 404 + Netlify's 3,449-byte page (the plan accepts 404). So step 3 will pass post-deploy.

**`main` is at `origin/main` with upstream set**, and the merge is a fast-forward — so the sha preflight prints stays stable through to the deploy, and `HEAD == @{u}` is satisfiable. `firebase emulators:exec` leaves only `firestore-debug.log`, which is gitignored, so test runs can't dirty the tree and trip `deploy.sh`'s clean-tree guard. The escapeHtml session works in a separate worktree, so it can't move this tree's HEAD; if it pushes to `origin/main`, round-2 M1's `HEAD == @{u}` catches it. ✓

## Prior-round disposition

**Every round-1, round-2 and round-3 BLOCKING and MEDIUM is resolved, and resolved correctly** — R1 Claude B1 (plan:131-134), B2 (plan:106-109), M1 (plan:47-51), M2 (plan:91-98 + 122-125), M3 (plan:84-85), M4 (plan:102-105), M5 (plan:136-139), M6 (plan:97-98); R1 Codex B1/B2/B3 (plan:81-85, 99-101, 33-34), M1, M2, M3; R2 Codex B1 (plan:78-80 — I verified the arithmetic), B2 (plan:110-112), M1, M2 (plan:113-117), M3 (plan:66-69), L1, L2; R3 Codex L1, L2, L3.

**One partial: R3 Codex M1.** The CDN-lag retry was given to check-live steps 1 and 2 and withheld from step 3 — see MEDIUM 1. That's the only prior finding not carried all the way.

---

## BLOCKING

None.

## MEDIUM

**M1 — plan:126-130. The private-path check has no retry and no cache-buster, so the plan's own CDN-lag premise makes the first run report `/user-import.html` as still public.**

plan:119-121 says a shell mismatch is *likely* on this deploy "(this deploy changes `index.html`, so CDN lag is likely)" and buys a retry; plan:125 extends the retry and `?v=<sha>` to the faithful files. Step 3 gets neither: each listed path "must return a body equal to `dist/index.html`, or a 404. Anything else FAILS."

Those ~25 private URLs are *different URLs* from `/index.html`, so step 1's retry doesn't warm them. Verified: `HEAD:index.html` is 76,913 and the currently-live one is 76,689. Any edge still holding the previous deploy's fallback returns 76,689 ≠ 76,913 → **`must not be public: /user-import.html`**. The loudest false alarm this script can produce, on its first run, naming exactly the thing Christie is afraid of — and it would be read as "the passwords are still exposed." The plan is internally inconsistent here: if lag is likely enough to protect steps 1 and 2, it's likely enough to protect step 3.

Fix: same single retry after 15 s and the same `?v=<sha>` (verified above that it cannot mask a leak). Then make the verdict two-sided rather than "≠ shell ⇒ leak": on a persistent 200 whose body is neither `dist/index.html` nor Netlify's 404 page, report whether it equals the **previous** deploy's `index.html` (CDN lag → inconclusive, re-run) before calling it a leak.

**M2 — plan:145-150 with package.json:4. The new tests can silently never run — and `npm test` is what both gates rest on.**

`package.json`'s `test` script passes jest an **explicit list of 27 files**. There is no `jest` key in `package.json` and no tracked `jest.config.*` — that list *is* the suite. The plan specifies eight new source-level assertions (manifest ⊇ APP_SHELL ∪ refs ∪ icons, the partition equality, `deploy.sh`'s guards, `netlify.toml` publishes `dist`, …) but never names the file they live in. If they go in a new file, jest never sees it, `npm test` passes, preflight passes, `deploy.sh`'s re-run passes — and not one invariant of this change is tested. Nothing else catches it: a new root-level `*.js` is outside the public-candidate set, so the build won't flag it, and plan:ses "check the printed count — it grows over time" wouldn't grow.

Fix: name the file, and if it's new add it to `package.json:4` in the same commit. (If the assertions are being appended to an existing listed file, say which — the risk is entirely in the ambiguity.)

## LOW

**L1 — plan:84-86.** `git archive HEAD -- … | tar -x -C dist` discards `git archive`'s exit status. In `#!/bin/sh` with `set -eu` (the Classbook convention, `build-dist.sh:8`) a failing left-hand side of a pipe does not abort — only `tar`'s status is seen, after `rm -rf dist` has already run. The promised "refuses (exit 1, naming the file)" isn't reachable for this step. The manifest-vs-`find dist` comparison does catch the outcome, so nothing unsafe publishes; what you get is git's `fatal: pathspec 'x' did not match any files` scrolled above a confusing "dist doesn't match the manifest." Specify `#!/bin/bash` + `set -o pipefail` (or `${PIPESTATUS[0]}`, or archive to a temp file then extract).

**L2 — plan:146-147.** "the tracked public-candidate set (**the same filter the build uses**)" has to be literally one implementation — a shared `scripts/candidate-set.sh` the test invokes — not a regex copied into the test. A copy drifts, and the day it drifts the test stops testing the build while still passing.

**L3 — plan:126-130.** `must-not-be-public.txt` is built from the old leak table and so omits the one thing *this change* adds to the repo: `scripts/`. Add `scripts/deploy.sh` and `scripts/dist-manifest.txt` — Classbook's list already carries `scripts/deploy.sh` (`check-live.sh:22`), and the whole point of a memorial list is to catch a future regression that re-broadens the publish set.

**L4 — plan:131-133.** "this also proves `included_files` resolved `js/schedule-helpers.js`" overstates the mechanism. With `node_bundler = "esbuild"` (netlify.toml:9) the `require` at `preview-shift-reminders.js:11` is *bundled*, so the 401 proves the require resolved at build time — it doesn't isolate `included_files`, which is belt-and-braces. Right check, right conclusion ("the shared helper reached the function"), wrong attribution.

**L5 — plan:134.** `send-shift-reminders` → 403 is Netlify *platform* behaviour for a deployed scheduled function, not this app's code. Make that probe's failure message say so: a 200 + shell means the job is **gone**; a different 4xx may just be a platform change. Otherwise a future Netlify tweak reads as "the reminder job vanished."

**L6 — plan:84 with plan:99 and plan:142.** `build-dist.sh` archives `HEAD`, but plan:142 also makes it the local `netlify dev` build step. Someone editing `js/app.js` and rebuilding gets the committed bytes and will debug a change that isn't there. One line of output — `built from HEAD <short sha>; uncommitted edits are not included` — removes it. (Same root: the partition check reads the **index** via `git ls-files` while the archive reads **HEAD**; identical under preflight/deploy's clean-tree guard, divergent when run standalone.)

**L7 — plan:99-101 and plan:111.** The emulator suite runs twice per deploy, both times on port 8080 (`firebase.json:7`). The `ticker-local-testing-gotchas` memory records 8080 colliding with another project's emulator — so an **already-approved** deploy can refuse for a reason unrelated to the change, against a house rule of "deploy ONCE when she confirms." Re-running is still the right choice over a receipt; just have `deploy.sh` announce the re-run up front and turn a bind failure into `port 8080 is in use — another project's emulator is running` rather than firebase's raw error.

**L8 — plan:100.** Make the Netlify approval sentence preflight prints visibly *unlike* the Firebase one ("approved to change firebase <sha>"), so a reader scanning a transcript can never credit one gate's approval to the other.

**L9 — plan:81-83.** "(all 16 APP_SHELL paths, `sw.js` itself, and both maskable icons; 18 files)" doesn't add up — 16 + 1 + 2 = 19. It's 18 because `/` and `/index.html` are the same file. The manifest is checked in and must be exactly 18 lines; an implementer who does the arithmetic writes 19. (Loud if wrong — `git archive` fatals or the dist diff refuses — but worth one word.)

**L10 — plan:119, 125.** The *first* shell request should carry `?v=<sha>` too, not just the retry; verified harmless above.

---

## Checked and clean

`publish = "dist"` + `--dir dist` doesn't relocate the function base (both prior reviewers read `deploy.js`; the nine live statuses above are the empirical half). The `[[redirects]]` block comes from the root `netlify.toml`, not the publish dir, and there's no `_redirects` file to conflict. `dist/` in `.gitignore` (plan:140) is what keeps the clean-tree guard satisfiable after a build — don't lose it. No `.gitattributes` tracked or on disk, so `git archive` can't apply an `export-ignore` or eol filter. No Firestore rules, collections or index changes. Deleting the four pages is reference-free. The Resume order (commit → merge → push → preflight → ask → deploy) is what makes the sha gate work; it must not be reordered.

**execution-ready: no** — but only just. There is no BLOCKING finding, the design verifies end to end against the live site, and both MEDIUMs are a line of plan text each. M2 is the one I'd insist on: it's the difference between shipping guardrails and shipping guardrails that have never been run. v5 should be the last round.
