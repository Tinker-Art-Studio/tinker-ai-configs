Read-only throughout: no edits, no tests, no `netlify` commands, nothing under `.claude/`. Live probes were GETs only.

## What I verified first (the plan's load-bearing assumptions)

Both hold:
- `/nonexistent-xyz-123.html` → 200, body **`cmp`-identical** to `/index.html` (76,689 B). The fallback is exact.
- Live `/index.html` is **byte-identical to `6cc4732:index.html`** → Netlify injects nothing, so byte comparison works.

Leaks re-confirmed by exact repo byte size: `user-import.html` 4004, `CLAUDE.md` 7588, `KIOSK-PLANNING.md` 6472, `package.json` 1404, `package-lock.json` 436852, `summer-camp-sync.html` 35969, `firestore-debug.log` 1260727, `schedule-helpers.test.js` 167595, and **`netlify/functions/send-shift-reminders.js` 5220** — function sources are public. Live is at `6cc4732`; the 11 branch commits are undeployed.

---

## BLOCKING

**B1 — plan:89-90. The "functions still deployed" check can never fail.** The plan says "a 404 is a failure." Verified: `curl /.netlify/functions/does-not-exist-xyz` → **200, 76689, text/html** — the SPA fallback swallows Netlify's function 404. "Not 404" is satisfied by a function that doesn't exist. This is the *same* trap the plan correctly named for the private check ("the fallback makes everything 200"), applied to one check and not the other.

Assert the positive signal instead:
- `preview-shift-reminders` → **401 + `content-type: application/json`** (verified: 401, 24 B). Because `preview-shift-reminders.js:11` does `require('../../js/schedule-helpers.js')` at module load, a 401 also proves `included_files` still resolved — currently the plan's only evidence for that.
- Add the job itself: `send-shift-reminders` → **403, 0 B, text/plain** (verified). Netlify blocks HTTP invocation of a *deployed* scheduled function; a missing one gives 200+shell. This is the only cheap proof the hourly reminder job survived — the preview endpoint does not prove it.

**B2 — deploy.sh:12 (Classbook). The guard dies on the branch you're shipping from.** `git branch -avv`: `fix/sub-confirm-manager-only` (ef30e9a) has **no upstream**; `main` = `origin/main` = 4ac3d09, 11 commits behind. `git rev-list @{u}..HEAD` fatals "no upstream configured" → `set -eu` exits 1. Safe, but the first `npm run deploy` dies on a cryptic git error, not the intended refusal.

```sh
UP=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null) || {
  echo "[deploy] refusing: branch has no upstream — push it first"; exit 1; }
```
Related (plan:126): prod would ship from a feature branch. The rules only require clean + pushed, so it's allowed — but then `origin/main` wouldn't contain what's live. Merge to main, push, deploy from main.

---

## MEDIUM

**M1 — plan:46. The `.claude/worktrees` row is a false positive, from the same status-code trap.** `netlify-cli/dist/commands/deploy/deploy.js:186` drops every dot-path from the upload (`base.startsWith('.') && base !== '.well-known'`). Verified: `/.claude/settings.json` → 200 **76689** (shell), `/.firebaserc` → 200 **76689**. `.claude/` has never been published; "381 MB in every deploy" is wrong. Same file, line 176: `node_modules` is skipped when `site.root === deployFolder`, which is today's case — `/node_modules/jest/package.json` → 76689 confirms it. The `.netlifyignore` epitaph says this was "Verified Sep 29 … still answered HTTP 200" — status codes under a 200 fallback. Every *other* row I re-checked by byte size is real. Correct the table so the next reader doesn't re-derive the false lesson, and don't expect the deploy to shrink by 381 MB.

**M2 — plan:105-106, sw.js:89. The offline BDD's reasoning is inverted.** "none 404, because the build is complete" — with `/* → /index.html 200`, **no APP_SHELL path can ever 404**. A missing `/js/app.js` would give `cache.addAll` a 200 and cache the HTML shell under that key: a silent poisoned cache on every installed device until the next `CACHE_NAME` bump. The service worker gives zero protection; it converts a loud failure into a quiet one. So the "Complete" check is the *only* guard — and it must run **before** the upload, not after (plan:80). Split it: local complete-check in `build-dist.sh`/`deploy.sh` (free, pre-deploy); faithful + private stay live. Also assert `content-type` on APP_SHELL JS/CSS live — one curl field, catches exactly this class.

**M3 — plan:71-72. `cp -R css js assets` is directory-level, and a `.DS_Store` will red-flag every deploy.** (a) "A file added to the repo root later is not published" is true; a file added to `js/` later **is**, automatically — and the test list (plan:96-99) only checks the allowlist ⊇ APP_SHELL, never the inverse. (b) Concrete: `.DS_Store` is gitignored (`.gitignore:4`) so it never dirties the tree, `cp -R` copies it into `dist/assets/`, `find dist -type f` sees it — but netlify-cli never uploads it (deploy.js:186), so the faithful loop compares it against the fallback → DIFF → red on a good deploy. One Finder visit is enough. Classbook has the same latent bug. Fix both:
```sh
git archive HEAD index.html manifest.json sw.js css js assets | tar -x -C dist
```
plus a checked-in `scripts/dist-manifest.txt` and a `diff` against `find dist -type f`. That makes "every deployed byte is a committed byte" literally true, excludes dot-files, and turns "nothing unexpected is in dist" into a test — the invariant you actually want, which a fixed private list can only approximate.

**M4 — plan:80-81. `deploy.sh` doesn't ask.** `~/.claude/CLAUDE.md` → NETLIFY: "ALWAYS ask for approval." The plan keeps the ask as a convention outside the script, while making the deploy one word. The whole design of `studio-hub/scripts/deploy-rules.sh` (`--approved <sha>` after a sha-specific sentence) exists because a convention failed exactly this way on Sep 21. Same shape here: refuse without `--approved`, so bare `npm run deploy` prints what it would ship and stops. Consider `npm test` before upload too.

**M5 — netlify.toml:1-3. If the site is git-linked, `publish = "dist"` with no `command` breaks git builds.** No `command` in `[build]`. A push to the production branch would run nothing and publish `dist/` — gitignored and absent → "Deploy directory 'dist' does not exist" on every push. Today `publish = "."` makes that path succeed silently. I can't read the build settings from here (they're in `siteData.build_settings`, deploy.js:69-70 — API only). **Check the Netlify UI before merging.** If git builds are on: disable them, or add `command = "sh scripts/build-dist.sh"`. If off, say in the toml that `publish` is documentation and `--dir dist` does the work.

**M6 — js/auth-guard.js:15. A verbatim port of Classbook's complete-grep fails on the first run.** `check-live.sh:11` greps `dist/js/*.js` for `['"](assets|css|js)/…['"]`; auth-guard.js:15 has `<img src="assets/logo.png">` **inside a usage comment**, and that file doesn't exist here → `MISSING assets/logo.png`, exit 1. The plan's own spec (:84-85) avoids this by only grepping index.html + APP_SHELL + manifest — so follow the plan, not the reference script. If you want the js grep anyway, strip comments or allowlist that path with a note.

---

## LOW

- **L1** — plan:86-88. If live index.html ever diverges from `dist/index.html`, *every* private path reports "leak." Run the index.html faithful check first and bail with "private results unreliable" instead of N false alarms. (No injection today — verified — so this is future-proofing.)
- **L2** — The private list should keep the four deleted pages forever (they're the memorial) and gain `netlify/functions/send-shift-reminders.js`, `package-lock.json`, `firestore-debug.log`, `deno.lock`, `KIOSK-PLANNING.md`, `firebase.json` — all verified live today. Skip dot-paths; the CLI can't upload them, so those assertions test nothing.
- **L3** — plan:48-50. The trap box is right. One addition: the function sources, `summer-camp-sync.html`, `CLAUDE.md` and the test suite also stay at old `<hash>--tinker-timeclock.netlify.app` URLs forever. Individual deploys can be deleted from the UI/API — but the password reset remains the only thing that closes the real exposure, exactly as written.
- **L4** — plan:94-95. AGENTS.md has **no** Deployment section (its only deploy line is :8, Firebase rules). What it does have is AGENTS.md:12 — "the kiosk mode and **the standalone import pages** have their own auth listeners and rely on the rules alone" — which is about the four pages being deleted. `CLAUDE.md:62,64` is the Netlify section. Also `.gitignore:8-9` points at `.netlifyignore`, a dangling reference once that file goes.
- **L5** — `CLAUDE.md:11`'s `npx http-server . -p 8093` is unaffected, but `netlify dev` would now serve `dist/` and needs a build first. One line in CLAUDE.md saves someone an hour.
- **L6** — plan:71 says "`rm -rf dist`, then a pure copy"; don't lose Classbook's `mkdir -p dist` (build-dist.sh:11) in the port.
- **L7** — check-live runs immediately post-upload; a single retry on DIFF removes the last flake. Optional.

---

## Checked and clean

**Allowlist is complete.** All 16 `sw.js:66-83` APP_SHELL paths, all 4 `manifest.json:9-32` icons (both maskables included), and all 12 local `src`/`href` in index.html fall inside `index.html / manifest.json / sw.js / css/ / js/ / assets/`. No runtime `fetch()` of a local file anywhere in `js/` — only `/.netlify/functions/*` (8 sites). No `url()` in either CSS. External deps are absolute URLs.

**Nothing in js/ css/ assets/ should be withheld.** All 15 files are already-public browser code; `js/firebase-config.js:8` is a Firebase web API key, public by design with rules as the control. Tracked == on-disk today, no strays.

**Functions bundle and deploy unchanged.** `getFunctionsFolder` (deploy.js:120-133) resolves against `site.root`, never the deploy folder; `--dir` only overrides publish (deploy.js:61-67); toml redirects merge from `config.redirects` independently (deploy.js:440-445); `siteRoot: site.root` is what the bundler resolves `included_files` against (deploy.js:474). `.netlify/netlify.toml:26-30` confirms it lands on `[functions."*"]`. **Nothing here resolves relative to the publish dir.**

**The private test is sound — no leaked file can pass it.** A static file beats a non-forced redirect, so a leak serves its own bytes; anything unpublished serves the shell byte-for-byte. The only third outcome is Netlify's own deny-list 404 (`/netlify.toml` → 404 + 3,449-byte error page), which the plan already accepts. **And the fallback cannot hide a missing app file from the faithful check** — the shell's hash never matches a JS/CSS/PNG's. It can hide one from users and from the service worker; that's M2.

**sw.js at dist root is right** — scope `/` for `js/app.js:106`'s `register('/sw.js')`, and it's allowlisted so it serves as real JS (verified `application/javascript`). **Deleting the four pages is safe** — zero references from index.html, js/, tests, functions or the toml. **deploy.sh's other guards match the rules** — clean tree, fetch-then-ahead-check, full sha as `--message`.

---

**execution-ready: no** — B1 and B2 are a few lines each, but B1 ships a check that passes silently when the reminder job has vanished, which is the one regression this change could plausibly cause and the exact thing the check exists to catch.

Fix B1 and B2, fold in M2 (complete-check before upload) and M3 (build from git + manifest diff), settle M5 with one look at the Netlify UI, correct the `.claude/` row. The design is right and both assumptions it rests on verify.

Want this as a published review page alongside the plan?
