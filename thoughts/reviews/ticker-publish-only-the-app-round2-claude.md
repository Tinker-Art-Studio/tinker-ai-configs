Read the plan, both round-1 reviews, the Classbook reference scripts, and re-verified every load-bearing claim against the repo and the live site (GETs only; no edits, no `netlify`, nothing under `.claude/`).

---

## Round-1 findings: what v2 did with them

| Round 1 | v2 | Verdict |
|---|---|---|
| Claude B1 — function check can't fail | plan:115-118, positive status per function | **Resolved.** All nine verified live today, exactly as written: `preview-shift-reminders` 401 `application/json` (24 B) · `send-shift-reminders` 403 `text/plain` (0 B) · the other seven 405 `application/json` (30 B) · a nonexistent function 200 + 76,689 B shell |
| Claude B2 — no-upstream git fatal | plan:99 | **Resolved.** Branch still has no upstream (confirmed) |
| Claude M1 — `.claude/` false positive | plan:46-50 | **Resolved** |
| Claude M2 — completeness after upload | plan:85-89 ("before any upload") + content-type | **Resolved** |
| Claude M3 — directory copy / `.DS_Store` | plan:75-84, `git archive` + manifest | **Resolved in principle, broken in the refusal set — BLOCKING 1** |
| Claude M4 — deploy doesn't ask | plan:95-97 `--approved` == HEAD | **Resolved**, with a binding gap (M3 below) |
| Claude M5 — git-linked + `publish=dist` | plan:120-122 "not git-linked, checked Sep 30" | Resolved as stated; the one claim I could not re-verify (no `netlify` commands) |
| Claude M6 — don't grep js comments | plan:90-91 | **Resolved** |
| Claude L1/L2/L4/L5/L6/L7 | plan:107-114, 124-128, 78, 110 | All folded in. AGENTS.md:12 is exactly the line v2 cites ("the standalone import pages…") |
| Codex B1 — folder allowlist | file-level manifest | **Resolved** |
| Codex B2 — approve before build/test | plan:92-94 preflight | **Resolved** |
| Codex B3 — reset not a gate | plan:32-33 "(a) … AND (b)" | **Resolved** |
| Codex M1 — one of nine functions | plan:115-118 | **Resolved** |
| Codex M2 — completeness misses `sw.js` | `sw.js` in the manifest + completeness inputs | **Resolved** |
| Codex M3 — transport failure handling | plan:104-105 `--fail-with-body` on *every* request | **Resolved wrongly — BLOCKING 2** |

---

## BLOCKING

**B1 — plan:83-84. The "no unlisted tracked file" refusal fires on today's tree. The first `npm run deploy:check` exits 1.**

The refusal set is "js/, css/, assets/ **or the root `*.html`/`*.json`/`sw.js`** set". Tracked root `*.json` is:

```
firebase.json   manifest.json   package-lock.json   package.json
```

`manifest.json` is in the dist manifest; the other three are leaks the plan exists to remove, so they can never be. `build-dist.sh` therefore refuses unconditionally, and its own remedy text — *"add it to dist-manifest.txt on purpose, or move it out"* — has no valid resolution for `package.json` or `firebase.json`. You cannot publish them and you cannot move them.

It's also internally inconsistent: the Tests bullet (plan:131-132) scopes the inverse check to "every tracked file under js/css/assets" only, so the test suite passes while the build refuses.

Everything else in the set is clean — `js/` 7, `css/` 2, `assets/` 6, all 15 in the manifest; root `*.html` after the four deletions is just `index.html`. So drop root `*.json` from the refusal and replace it with a checked-in deny list (`package.json`, `package-lock.json`, `firebase.json`) so a *new* root json still trips it. `manifest.json` is already covered by the manifest and by index.html's refs.

**B2 — plan:104-105. `--fail-with-body` on every request breaks three of the four check groups, after the upload.**

"Every request uses `curl --fail-with-body -sS` with an explicit status check." But the expected status is ≥ 400 in three groups:

- private paths: "or a 404" (plan:113) — `/netlify.toml` is live proof: 404 + a 3,449-byte error page
- all nine functions: 401 / 403 / 405 (plan:115-118)

`--fail*` exits 22 on any 4xx. Under `set -eu` check-live dies on the first expected 405; a status captured via `code=$(curl …)` fails the assignment and `set -e` fires with no message. And `--fail-with-body` gives you a body, not a status — the function checks need `-w '%{http_code}'`, which it doesn't provide.

This is round-1 Codex M3 taken literally. Codex's advice was written for the faithful group and doesn't survive contact with the other three. Split it: `--fail-with-body` only where 2xx is required (shell-first, the 18 faithful files); elsewhere `-o body -w '%{http_code}'`, tolerate curl's exit status, and compare status and body explicitly.

Why this is blocking rather than medium: it fires *after* `netlify deploy --prod`, on a correct deploy, and sends you to the rollback in B/M4 below.

---

## MEDIUM

**M1 — plan:92-103. Nothing binds the preflight to the deploy.** `deploy.sh` re-runs `build-dist.sh` but not `npm test`, and keeps no receipt. A session can get a sha approved and run `npm run deploy -- --approved <sha>` having never run `deploy:check` — the tests are a convention again, which is the exact failure mode plan:95-97 was written to close. (studio-hub's guard re-runs its suite in the worktree.) Cheapest fix that keeps Codex B2's "no mutable step in the deploy": preflight writes a gitignored receipt naming the sha it tested; `deploy.sh` refuses unless the receipt matches HEAD.

**M2 — plan:103. "Ship from `main`" is prose, not a guard.** `deploy.sh` enforces clean + upstream + pushed + `--approved` == HEAD, and would happily ship `fix/sub-confirm-manager-only`. Add `[ "$(git rev-parse --abbrev-ref HEAD)" = main ] || exit 1`. (The merge is a clean fast-forward — `main` is an ancestor of the branch, 11 commits behind — so this costs nothing.)

**M3 — plan:92, 129-133. `package.json` is never listed as a changed file, and its test script enumerates every test file by name.** `package.json:5` lists 27 files explicitly inside one `firebase emulators:exec`. A new `publish-allowlist.test.js` that isn't appended there never runs — so preflight's `npm test` would green without covering any of the new invariants. The plan also needs `scripts.deploy` and `scripts.deploy:check` added. Name `package.json` in the Changes list with both edits.

**M4 — plan:144-145. The stated rollback re-exposes the passwords on the primary URL.** "Republish the previous deploy in Netlify's UI (instant)" republishes the repo-root deploy — `user-import.html` (4,004 B, verified live) and its 8 temporary passwords go back to `tinker-timeclock.netlify.app`, not just an old hash URL. Since the reset (plan:32-33) is independent of the deploy, do it **first**: then rollback is harmless and "done" has one open item instead of two. Otherwise say explicitly that fix-forward is the default and rollback is only acceptable after the reset.

---

## LOW

- **plan:73-74.** `f53788d:summer-camp-sync.html` is 35,596 B; `HEAD`'s is 35,969 B (last touched `686ea3b`, Sep 21). Name the deletion commit's parent as the Summer-2027 recovery point, not `f53788d`.
- **plan:82.** `find dist -type f` prints `dist/index.html`; the manifest holds `index.html`. Normalize (`cd dist && find . -type f | sed 's#^\./##' | LC_ALL=C sort`). Related: `sh` has no `pipefail`, so a `git archive` pathspec failure is swallowed by `tar` and `set -e` never fires — this manifest diff is the only thing that catches it, which is worth saying in the plan since it looks redundant.
- **plan:92-94.** Preflight has no upstream/pushed guard, so per the Resume order it can print an approval sentence for a sha `deploy.sh` will then refuse. And the "exact approval sentence" is never written down anywhere in the plan — specify it (e.g. `approved to deploy ticker <full sha>`), the way the Firebase guard does.
- **plan:92.** `npm test` is `firebase emulators:exec` on port 8080 (`firebase.json:7`). Another session is live in `.claude/worktrees/loving-brahmagupta-576572`; a held 8080 fails preflight for reasons unrelated to this change (the `ticker-local-testing-gotchas` memory). Worth one line in Resume.
- **plan:129-130.** "the manifest equals the set the build would archive" is circular — the build archives exactly the manifest. The load-bearing test is the `⊇` one on the next line.
- **plan:115-118.** The nine-function list is hardcoded; a tenth function added later is never probed. Derive it from `netlify/functions/*.js` minus `_lib/` and assert the count is 9.
- **plan:109.** Content-type is asserted for JS/CSS. Add `manifest.json` → `application/json` (verified live) — a wrong type there breaks install, and it's the one manifest file the JS/CSS rule misses.
- **Record correction (not a plan defect).** Live is **`4ac3d09` (= `origin/main`)**, not `6cc4732`. Live `js/app.js` is 518,196 B = `4ac3d09:js/app.js`; `6cc4732`'s is 502,541 B. Round-1 inferred `6cc4732` from `index.html`, which is byte-identical (76,689 B) at both commits. This is good news for plan:103 — `origin/main` is already what's live, so this deploy's delta is exactly the 11 branch commits plus this one.

---

## Re-verified clean

`publish = "dist"` + `--dir dist` does not relocate the function base — all nine functions answer today and `preview-shift-reminders`' 401 proves `included_files` resolves `js/schedule-helpers.js`. Completeness inputs are sufficient: index.html's 12 local `src`/`href`, `manifest.json`'s 4 icons (both maskables), `sw.js`'s 16 `APP_SHELL` entries (15 distinct files) and `sw.js` itself all fall inside the 18-file manifest — nothing missing, nothing extra. No `.gitattributes`, so no `export-ignore` surprise in `git archive`. `deno.lock` (963 B) and `firestore-debug.log` are gitignored, so they cannot reach `dist/`. Zero references to the four deleted pages anywhere in the repo. No CSS/JS minification or pretty-URL rewriting on this site: every asset I compared is byte-exact against its commit (`styles.css` 53,621 · `auth-guard.css` 1,553 · `auth-guard.js` 6,057 · `manifest.json` 685 · `sw.js` 4,708 · `favicon.svg` 114 · `icon-192.png` 31,769), and `/index.html` returns 200 with no redirect — so the faithful byte check is sound. curl is 8.7.1, so `--fail-with-body` exists; that's the problem, not the fix.

---

**execution-ready: no.** B1 fails the preflight before anything is built; B2 fails the live check after the upload is already live. Both are a few lines, and both are in the parts v2 newly added — the `git archive` refusal set and the curl spec. The design is right and everything it rests on verifies; fix B1, B2, bind the preflight (M1), enforce the branch (M2), add `package.json` to the Changes list (M3), and move the password reset ahead of the deploy (M4).
