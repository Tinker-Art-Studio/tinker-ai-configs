## Implementation review — ticker-publish-only-the-app, commit 65e3c41
Plan (the spec, v5 — the round-4 entry in its Decisions Log OVERRIDES the phase text where they differ):
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html
Repo /Users/christiehubley/tinker-timeclock, branch fix/sub-confirm-manager-only. READ-ONLY for you: no edits, no `netlify`
commands, do not run deploy.sh. Do NOT read anything under /Users/christiehubley/tinker-timeclock/.claude/. You may read files,
run `bash scripts/candidate-set.sh`, and curl https://tinker-timeclock.netlify.app read-only.
Already done by the implementer: build-dist.sh refused a staged stray js/debug.js and a manifest missing js/app.js; check-live.sh
dry-run against TODAY's live site (dist built from the live commit 4ac3d09) passed shell/files/functions and named all 17 current
leaks; preflight passed (1943/1943 tests).

## What to check
- Does the code do exactly what the plan specifies? Every deviation or omission.
- build-dist.sh: can anything uncommitted, unlisted or a dot-file reach dist/? Can it pass while incomplete? Any false refusal?
- deploy.sh: every gate (approved sha, clean, main == origin/main, preflight re-run before upload, sha message). Any path to an
  upload that skips one? set -e / pipefail interactions? What happens if check-live exits 2?
- check-live.sh: the curl handling (transport vs HTTP status), the body-hash logic, the private verdict (ok / lag / leak), the
  retries, the function expectations. Bugs in bash (subshell variable scope, quoting, `$(…)` with functions)? False pass? False fail
  on the FIRST real deploy (index.html changes in this deploy)?
- Anything the first real `npm run deploy` will trip on.
- Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to deploy — yes/no.

## Diff (git show 65e3c41; deleted files listed by name only — their contents are not needed)
65e3c417fdae92d42cf4e5c94a4d862c01fe96ab fix: publish only the app — dist/ from a committed file allowlist; delete the one-time admin tools

 .gitignore                     |   6 +-
 .netlifyignore                 |  26 --
 AGENTS.md                      |   2 +-
 CLAUDE.md                      |  14 +-
 grant-timeclock-access.html    | 113 ------
 netlify.toml                   |   7 +-
 package.json                   |   4 +-
 schedule-editor-wiring.test.js |  88 +++++
 schedule-import.html           | 291 --------------
 scripts/build-dist.sh          |  51 +++
 scripts/candidate-set.sh       |   8 +
 scripts/check-live.sh          | 103 +++++
 scripts/deploy.sh              |  40 ++
 scripts/dist-manifest.txt      |  18 +
 scripts/dist-private.txt       |   3 +
 scripts/must-not-be-public.txt |  19 +
 scripts/preflight.sh           |  16 +
 summer-camp-sync.html          | 833 -----------------------------------------
 user-import.html               |  84 -----
 19 files changed, 372 insertions(+), 1354 deletions(-)
diff --git a/.gitignore b/.gitignore
index c07e802..3560e79 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,7 +5,9 @@ node_modules/
 .netlify/
 firestore-debug.log
 
-# Agent/tooling state, not source. Also listed in .netlifyignore — `publish = "."` would otherwise
-# upload and serve it (Sep 29 2026).
+# Agent/tooling state, not source. (netlify-cli never uploads dot-paths, and the site now publishes only dist/.)
 .claude/
 deno.lock
+
+# Built by scripts/build-dist.sh on every deploy; never committed.
+dist/
diff --git a/AGENTS.md b/AGENTS.md
index d0bd7be..218c190 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -9,7 +9,7 @@
   (`--status` prints the sentence). A raw `firebase … deploy` in any form is refused by the predeploy check in `firebase.json`
 
 ## Reminder bot (48-hour shift reminders)
-`reminders@tinkerartstudio.com` is a Firebase Auth user with NO users doc, pinned by uid in `firestore.rules` as `isReminderBot()`. It may read `timeclock_schedules`, GET one `users` doc, and create/resolve `timeclock_reminder_log` claims — nothing else. Its password lives only in Netlify env (`REMINDER_BOT_EMAIL` / `REMINDER_BOT_PASSWORD`, production context); never read or type it. The job is `netlify/functions/send-shift-reminders.js` — a Netlify SCHEDULED function (hourly; sends from 9 AM Denver for the window [today+1, today+2]; claim-before-send in `timeclock_reminder_log`, Resend idempotency key `ticker-shift-reminder/{docId}/{date}`, ≤ 3 failed attempts) — with its core in `_lib/shift-reminder.js` (pure, every adapter injected, a denied read ABORTS the run) and its Firestore side in `_lib/shift-reminder-firestore.js` (`firebase/firestore/lite` + `firebase/auth` as the bot, through the rules). `preview-shift-reminders.js` is a read-only dry run gated by `REMINDER_PREVIEW_SECRET` (header `x-preview-secret`, constant-time compare, fails closed). The Reminders view in the Schedule Builder tab uses the same helpers (`js/schedule-helpers.js`: `selectRemindersDue`, `reminderWindow`, `reminderRowStatus`, `planReminderToggles`) so the view and the job never disagree. Only `requireAuth()` refuses the bot in the browser; the kiosk mode and the standalone import pages have their own auth listeners and rely on the rules alone (accepted).
+`reminders@tinkerartstudio.com` is a Firebase Auth user with NO users doc, pinned by uid in `firestore.rules` as `isReminderBot()`. It may read `timeclock_schedules`, GET one `users` doc, and create/resolve `timeclock_reminder_log` claims — nothing else. Its password lives only in Netlify env (`REMINDER_BOT_EMAIL` / `REMINDER_BOT_PASSWORD`, production context); never read or type it. The job is `netlify/functions/send-shift-reminders.js` — a Netlify SCHEDULED function (hourly; sends from 9 AM Denver for the window [today+1, today+2]; claim-before-send in `timeclock_reminder_log`, Resend idempotency key `ticker-shift-reminder/{docId}/{date}`, ≤ 3 failed attempts) — with its core in `_lib/shift-reminder.js` (pure, every adapter injected, a denied read ABORTS the run) and its Firestore side in `_lib/shift-reminder-firestore.js` (`firebase/firestore/lite` + `firebase/auth` as the bot, through the rules). `preview-shift-reminders.js` is a read-only dry run gated by `REMINDER_PREVIEW_SECRET` (header `x-preview-secret`, constant-time compare, fails closed). The Reminders view in the Schedule Builder tab uses the same helpers (`js/schedule-helpers.js`: `selectRemindersDue`, `reminderWindow`, `reminderRowStatus`, `planReminderToggles`) so the view and the job never disagree. Only `requireAuth()` refuses the bot in the browser; the kiosk mode has its own auth listener and relies on the rules alone (accepted). (The standalone import pages were deleted Sep 30 2026; plan `ticker-publish-only-the-app`.)
 
 ## Shadowed reminder flags (Sep 22)
 A `remind` flag on the layer that does not serve its date never sends — a base override a temporary schedule covers, or a future override outside that schedule's dates. The job is right to skip it (it resolves through `getShiftForDate`); the bug was that nobody was told. `reminderRowStatus` now returns `hidden-flagged` (amber, counted on the Reminders badge) or `hidden-covered` (uncounted — the served shift is flagged **for the same person**; recipients must match). Clearing one sends `shadowed: true`, which `planReminderToggles` ASSERTS rather than treats as permission, and the map and write path follow `t.layer` — never the serving layer; that mistake reads one map and deletes from the other and still passes a test that only checks "the untick succeeded". Ticking a shadowed row is refused. `shadowedReminderDates` warns before a save creates the situation, in both directions.
diff --git a/CLAUDE.md b/CLAUDE.md
index 88ec955..d852d2d 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -59,6 +59,16 @@ If data appears missing or blank, check Firestore rules before assuming data los
 
 ## Deployment
 - Platform: Netlify
-- Deploy: `netlify deploy --prod` from `/Users/christiehubley/tinker-timeclock/`
+- Only `dist/` is published — built by `scripts/build-dist.sh` from the committed files listed in `scripts/dist-manifest.txt`
+  (plan `ticker-publish-only-the-app`). A new browser file in `js/`, `css/`, `assets/` or a root `*.html`/`*.json` makes the build
+  refuse until it is listed in `dist-manifest.txt` (public) or `dist-private.txt` (not). Never `netlify deploy` by hand.
+- Deploy, from `main` exactly equal to `origin/main`:
+  1. `npm run deploy:check` — build + full test suite; uploads nothing; prints the sentence to ask for
+  2. Ask Christie — each deploy costs credits — and wait for "okay to deploy tinker ticker <full sha>"
+  3. `npm run deploy -- --approved <full sha>` — re-runs the preflight, deploys `dist/` with the sha as the message, then
+     `scripts/check-live.sh`: every file byte-identical live, every path in `scripts/must-not-be-public.txt` serves only the app
+     shell, all nine functions answer as expected. Exit 2 = CDN lag, re-run `bash scripts/check-live.sh <sha>`.
+- This site answers every unknown path with 200 + index.html (the single-page fallback): a status code proves nothing — compare bodies.
+- `npx http-server . -p 8093` still serves the repo for local work; `netlify dev` serves `dist/`, so run `bash scripts/build-dist.sh`
+  first (it builds from HEAD — uncommitted edits are not included).
 - Live URL: https://tinker-timeclock.netlify.app
-- ⚠️ Always ask Christie before running `netlify deploy` — each build costs credits
diff --git a/netlify.toml b/netlify.toml
index b23682f..2c9bcdc 100644
--- a/netlify.toml
+++ b/netlify.toml
@@ -1,5 +1,10 @@
+# Only dist/ is published (plan: ticker-publish-only-the-app). It is built by scripts/build-dist.sh from a file-level
+# allowlist of COMMITTED files; `npm run deploy` passes --dir dist. This site is not git-linked (no build command;
+# checked Sep 30 2026), so `publish` documents the CLI's --dir. If it is ever git-linked, add
+# command = "bash scripts/build-dist.sh" or every git build will fail on a missing dist/.
+# Functions and included_files resolve against the repo root, not the publish folder.
 [build]
-  publish = "."
+  publish = "dist"
   functions = "netlify/functions"
 
 # The functions bundle their relative requires (js/schedule-helpers.js is shared with the browser); esbuild
diff --git a/package.json b/package.json
index 5b30659..49c3ea2 100644
--- a/package.json
+++ b/package.json
@@ -2,7 +2,9 @@
   "name": "tinker-timeclock",
   "private": true,
   "scripts": {
-    "test": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest --runInBand schedule-helpers.test.js timeoff-schedule.test.js timeoff-schedule.characterization.test.js schedule-editor-wiring.test.js firebase-data.failure.test.js schedule-dates-update.emulator.test.js schedule-partition.emulator.test.js future-schedule-write.emulator.test.js timeoff-sub-confirm.emulator.test.js timeoff-status-guard.emulator.test.js timeoff-schedule.emulator.test.js remove-timeoff-overrides.emulator.test.js empty-map-guard.emulator.test.js pay-period-lock.emulator.test.js removals.emulator.test.js reminder-flag.emulator.test.js reminder-toggle.emulator.test.js shift-reminder.emulator.test.js netlify/functions/_lib/email.test.js netlify/functions/_lib/shift-reminder.test.js netlify/functions/_lib/shift-reminder-functions.test.js netlify/functions/_lib/timeoff-routing.test.js netlify/functions/_lib/timeoff-confirmation.test.js netlify/functions/_lib/timeoff-comment.test.js netlify/functions/_lib/timeoff-status.test.js netlify/functions/_lib/schedule-change.test.js\""
+    "test": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest --runInBand schedule-helpers.test.js timeoff-schedule.test.js timeoff-schedule.characterization.test.js schedule-editor-wiring.test.js firebase-data.failure.test.js schedule-dates-update.emulator.test.js schedule-partition.emulator.test.js future-schedule-write.emulator.test.js timeoff-sub-confirm.emulator.test.js timeoff-status-guard.emulator.test.js timeoff-schedule.emulator.test.js remove-timeoff-overrides.emulator.test.js empty-map-guard.emulator.test.js pay-period-lock.emulator.test.js removals.emulator.test.js reminder-flag.emulator.test.js reminder-toggle.emulator.test.js shift-reminder.emulator.test.js netlify/functions/_lib/email.test.js netlify/functions/_lib/shift-reminder.test.js netlify/functions/_lib/shift-reminder-functions.test.js netlify/functions/_lib/timeoff-routing.test.js netlify/functions/_lib/timeoff-confirmation.test.js netlify/functions/_lib/timeoff-comment.test.js netlify/functions/_lib/timeoff-status.test.js netlify/functions/_lib/schedule-change.test.js\"",
+    "deploy:check": "bash scripts/preflight.sh",
+    "deploy": "bash scripts/deploy.sh"
   },
   "dependencies": {
     "@netlify/functions": "^4.3.0",
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index b5fbe2d..81d83e4 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2444,3 +2444,91 @@ describe('the request detail: the last call wins', () => {
     expect(fn).not.toMatch(/viewingRequestId !== requestId/);
   });
 });
+
+// ─── Publish only the app (plan: ticker-publish-only-the-app, Sep 30 2026) ──────────────────────────────────
+// netlify.toml published the repo root, so a one-time tool listing 8 staff emails with temporary passwords, the notes,
+// the tests, the debug log and the function sources were all public. Only dist/ is published now, built from a
+// file-level allowlist of committed files. These pin that, and the deploy's gates. (The scripts themselves run in
+// `npm run deploy:check`; these assertions are source-level and write nothing.)
+describe('the site publishes only the app', () => {
+  const { execFileSync } = require('child_process');
+  const read = (p) => fs.readFileSync(`${__dirname}/${p}`, 'utf8');
+  const lines = (p) => read(p).split('\n').map(l => l.trim()).filter(Boolean);
+  const manifest = lines('scripts/dist-manifest.txt');
+  const privateList = lines('scripts/dist-private.txt');
+
+  test('the allowlist holds everything the app loads: APP_SHELL, index.html refs, manifest icons, sw.js', () => {
+    const shell = read('sw.js').match(/const APP_SHELL = \[([\s\S]*?)\];/)[1].match(/'[^']+'/g).map(s => s.slice(1, -1));
+    const html = [...read('index.html').matchAll(/(?:src|href)="([^"]+)"/g)].map(m => m[1]);
+    const icons = JSON.parse(read('manifest.json')).icons.map(i => i.src);
+    const needed = [...shell, ...html, ...icons, 'sw.js']
+      .filter(r => !/^(#|https?:|\/\/|data:|mailto:)/.test(r))
+      .map(r => r.replace(/[?#].*$/, '').replace(/^\//, '') || 'index.html');
+    needed.forEach(r => expect(manifest).toContain(r));
+    expect(manifest.length).toBe(18);   // "/" and "/index.html" are one file
+  });
+
+  test('every public candidate is listed exactly once — published or deliberately private (the same script the build uses)', () => {
+    const candidates = execFileSync('bash', [`${__dirname}/scripts/candidate-set.sh`], { encoding: 'utf8' }).split('\n').filter(Boolean);
+    expect([...candidates].sort()).toEqual([...manifest, ...privateList].sort());
+    expect(manifest.filter(m => privateList.includes(m))).toEqual([]);
+    expect(privateList.sort()).toEqual(['firebase.json', 'package-lock.json', 'package.json']);
+  });
+
+  test('the one-time admin tools and the .netlifyignore that never worked are gone', () => {
+    ['user-import.html', 'grant-timeclock-access.html', 'schedule-import.html', 'summer-camp-sync.html', '.netlifyignore']
+      .forEach(f => expect(fs.existsSync(`${__dirname}/${f}`)).toBe(false));
+  });
+
+  test('netlify.toml publishes dist/; functions still come from the repo', () => {
+    const toml = read('netlify.toml');
+    expect(toml).toMatch(/\[build\]\s*\n\s*publish = "dist"/);
+    expect(toml).toMatch(/functions = "netlify\/functions"/);
+    expect(read('.gitignore')).toMatch(/^dist\/$/m);
+  });
+
+  test('build-dist archives COMMITTED files on the file allowlist, and refuses before upload when incomplete', () => {
+    const build = read('scripts/build-dist.sh');
+    expect(build.startsWith('#!/bin/bash\n')).toBe(true);
+    expect(build).toMatch(/^set -euo pipefail$/m);   // a failing `git archive` in the pipe aborts
+    expect(build).toMatch(/git archive HEAD -- \$\(cat "\$MANIFEST"\) \| tar -x -C dist/);
+    expect(build).toMatch(/bash scripts\/candidate-set\.sh/);
+    expect(build).toMatch(/referenced by the app but not in dist\//);
+    expect(build).not.toMatch(/cp -R/);   // never a folder copy
+  });
+
+  test('deploy.sh: exact approved sha, clean, main == origin/main, preflight re-run BEFORE the upload, sha as the message', () => {
+    const deploy = read('scripts/deploy.sh');
+    expect(deploy).toMatch(/\[ "\$APPROVED" = "\$SHA" \] \|\| refuse/);
+    expect(deploy).toMatch(/\[ -z "\$\(git status --porcelain\)" \] \|\| refuse/);
+    expect(deploy).toMatch(/\[ "\$\(git rev-parse --abbrev-ref HEAD\)" = main \] \|\| refuse/);
+    expect(deploy).toMatch(/\[ "\$UP" = origin\/main \] \|\| refuse/);
+    expect(deploy).toMatch(/\[ "\$\(git rev-parse HEAD\)" = "\$\(git rev-parse '@\{u\}'\)" \] \|\| refuse/);
+    const pre = deploy.indexOf('bash scripts/preflight.sh');
+    const up = deploy.indexOf('netlify deploy --prod --dir dist --message "$SHA"');
+    expect(pre).toBeGreaterThan(-1);
+    expect(up).toBeGreaterThan(pre);
+    expect(deploy.indexOf('bash scripts/check-live.sh "$SHA" "$PREV"')).toBeGreaterThan(up);
+    // bare `npm run deploy` only says what it would ship
+    expect(deploy).toMatch(/if \[ -z "\$APPROVED" \]; then[\s\S]*?nothing done[\s\S]*?exit 1\s*fi/);
+    expect(read('scripts/preflight.sh')).toMatch(/npm test/);
+    expect(JSON.parse(read('package.json')).scripts).toMatchObject({ 'deploy:check': 'bash scripts/preflight.sh', deploy: 'bash scripts/deploy.sh' });
+  });
+
+  test('check-live compares BODIES (the fallback makes every path 200), never trusts a bare status, and probes all nine functions', () => {
+    const check = read('scripts/check-live.sh');
+    expect(check).not.toMatch(/--fail/);   // an expected 401/403/404/405 must not become a curl error
+    expect(check).toMatch(/--connect-timeout 10 --max-time 30/);
+    expect(check).toMatch(/if \[ "\$CODE" = 200 \] && \[ "\$\(hash "\$BODY"\)" = "\$SHELL_HASH" \]; then echo ok; return; fi/);
+    expect(check).toMatch(/\[ "\$\(hash "\$BODY"\)" = "\$PREV_HASH" \]; then echo lag; return; fi/);   // CDN lag is not a leak
+    expect(check).toMatch(/check_fn preview-shift-reminders 401/);
+    expect(check).toMatch(/check_fn send-shift-reminders 403/);
+    const fns = fs.readdirSync(`${__dirname}/netlify/functions`).filter(f => f.endsWith('.js')).map(f => f.replace(/\.js$/, ''));
+    fns.forEach(fn => expect(check).toContain(fn));
+    expect(fns.length).toBe(9);
+    const priv = lines('scripts/must-not-be-public.txt');
+    ['user-import.html', 'CLAUDE.md', 'package.json', 'firestore-debug.log', 'netlify/functions/send-shift-reminders.js', 'scripts/deploy.sh']
+      .forEach(p => expect(priv).toContain(p));
+    expect(priv.filter(p => p.startsWith('.'))).toEqual([]);   // the CLI never uploads dot-paths; listing them tests nothing
+  });
+});
diff --git a/scripts/build-dist.sh b/scripts/build-dist.sh
new file mode 100755
index 0000000..205aabf
--- /dev/null
+++ b/scripts/build-dist.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+# Builds dist/ — the ONLY thing Netlify publishes (plan: ticker-publish-only-the-app).
+#
+# netlify.toml used to publish the repo root, so a one-time account tool listing 8 staff emails with temporary
+# passwords, the internal notes, the test suite, the debug log and the function sources were all public. This is
+# a pure copy of an explicit FILE-level allowlist (scripts/dist-manifest.txt), taken from the COMMITTED tree with
+# `git archive`: no untracked or ignored file (.DS_Store), no transformation, every deployed byte a committed byte.
+#
+# It refuses — before anything is uploaded — if:
+#   - a tracked public-candidate file (scripts/candidate-set.sh) is in neither dist-manifest.txt nor dist-private.txt,
+#     or one is in both (a new browser-ish file is published only on purpose);
+#   - dist/ does not hold exactly the manifest;
+#   - anything the app loads is missing: a local src/href in index.html, an APP_SHELL entry in sw.js, a manifest.json
+#     icon, or sw.js itself. With the single-page fallback a missing file would be served as the app's HTML, and the
+#     service worker would cache that HTML under the file's name on every installed device.
+set -euo pipefail
+cd "$(dirname "$0")/.."
+fail() { echo "[build-dist] REFUSING: $*" >&2; exit 1; }
+
+MANIFEST=scripts/dist-manifest.txt
+PRIVATE=scripts/dist-private.txt
+
+# 1. Every public candidate is listed exactly once, as public or private.
+both=$(LC_ALL=C comm -12 <(LC_ALL=C sort "$MANIFEST") <(LC_ALL=C sort "$PRIVATE"))
+[ -z "$both" ] || fail "listed as both public and private: $both"
+unlisted=$(LC_ALL=C comm -23 <(bash scripts/candidate-set.sh) <(LC_ALL=C sort "$MANIFEST" "$PRIVATE"))
+[ -z "$unlisted" ] || fail "not listed in $MANIFEST or $PRIVATE — add each on purpose: $(echo $unlisted)"
+stale=$(LC_ALL=C comm -13 <(bash scripts/candidate-set.sh) <(LC_ALL=C sort "$MANIFEST" "$PRIVATE"))
+[ -z "$stale" ] || fail "listed but not a tracked file: $(echo $stale)"
+
+# 2. Committed bytes only.
+rm -rf dist
+mkdir -p dist
+# shellcheck disable=SC2046
+git archive HEAD -- $(cat "$MANIFEST") | tar -x -C dist
+got=$(cd dist && find . -type f | sed 's#^\./##' | LC_ALL=C sort)
+[ "$got" = "$(LC_ALL=C sort "$MANIFEST")" ] || fail "dist/ does not match $MANIFEST: $(diff <(echo "$got") <(LC_ALL=C sort "$MANIFEST") | tr '\n' ' ')"
+
+# 3. Complete: everything the app asks for is in dist/. Fragment-only, absolute, data: and mailto: values are not files.
+refs=$( {
+  grep -oE '(src|href)="[^"]+"' dist/index.html | sed -E 's/^(src|href)="//; s/"$//'
+  sed -n '/const APP_SHELL = \[/,/\];/p' dist/sw.js | grep -oE "'[^']+'" | tr -d "'"
+  grep -oE '"src"[[:space:]]*:[[:space:]]*"[^"]+"' dist/manifest.json | sed -E 's/.*"([^"]+)"$/\1/'
+  echo sw.js
+} | grep -vE '^(#|https?:|//|data:|mailto:)' | sed -E 's/[?#].*$//; s#^/##; s#^$#index.html#' | LC_ALL=C sort -u )
+missing=""
+for r in $refs; do [ -f "dist/$r" ] || missing="$missing $r"; done
+[ -z "$missing" ] || fail "referenced by the app but not in dist/:$missing"
+
+echo "[build-dist] dist/: $(echo "$got" | wc -l | tr -d ' ') files, all $(echo "$refs" | wc -l | tr -d ' ') app references present"
+echo "[build-dist] built from HEAD $(git rev-parse --short HEAD); uncommitted edits are NOT included"
diff --git a/scripts/candidate-set.sh b/scripts/candidate-set.sh
new file mode 100755
index 0000000..84b68c6
--- /dev/null
+++ b/scripts/candidate-set.sh
@@ -0,0 +1,8 @@
+#!/bin/bash
+# The PUBLIC-CANDIDATE set: tracked files that are the kind of thing a browser could be served — anything under
+# js/, css/ or assets/, and root *.html, *.json and sw.js. Every one must be listed in dist-manifest.txt (published)
+# or dist-private.txt (deliberately not). One implementation, used by build-dist.sh and by the wiring test, so the
+# test can never drift from what the build enforces (plan: ticker-publish-only-the-app).
+set -euo pipefail
+cd "$(dirname "$0")/.."
+git ls-files | grep -E '^(js|css|assets)/|^[^/]+\.(html|json)$|^sw\.js$' | LC_ALL=C sort
diff --git a/scripts/check-live.sh b/scripts/check-live.sh
new file mode 100755
index 0000000..8ebc593
--- /dev/null
+++ b/scripts/check-live.sh
@@ -0,0 +1,103 @@
+#!/bin/bash
+# After a deploy: prove the live site is exactly dist/, that nothing private is served, and that all nine functions
+# survived (plan: ticker-publish-only-the-app). Exit 1 on any failure; exit 2 when CDN lag makes a result inconclusive.
+#
+# THIS SITE ANSWERS EVERY UNKNOWN PATH WITH 200 + index.html (the single-page fallback in netlify.toml). A status code
+# alone proves nothing here — on Sep 29 that misread a fallback as "the worktree is still published". Bodies are compared.
+#
+#   usage: check-live.sh <sha> [previous-live-index.html]
+# The previous deploy's index.html (fetched by deploy.sh before uploading) tells "CDN still serving the old fallback"
+# apart from a real leak.
+set -uo pipefail
+cd "$(dirname "$0")/.."
+BASE=https://tinker-timeclock.netlify.app
+SHA=${1:?usage: check-live.sh <sha> [previous-live-index.html]}
+PREV=${2:-}
+TMP=$(mktemp -d)
+trap 'rm -rf "$TMP"' EXIT
+fail=0; inconclusive=0
+hash() { shasum < "$1" | cut -c1-40; }
+SHELL_HASH=$(hash dist/index.html)
+PREV_HASH=""; [ -n "$PREV" ] && [ -s "$PREV" ] && PREV_HASH=$(hash "$PREV")
+
+# fetch <path> → sets CODE, TYPE, BODY (a fresh file). Transport failures are fatal; any HTTP status is returned to the caller.
+n=0
+fetch() {
+  n=$((n + 1)); BODY="$TMP/body.$n"
+  local sep='?'; case "$1" in *\?*) sep='&';; esac
+  local out rc
+  out=$(curl -sS --location --connect-timeout 10 --max-time 30 -o "$BODY" -w '%{http_code} %{content_type}' "$BASE/$1${sep}v=$SHA")
+  rc=$?
+  if [ $rc -ne 0 ]; then echo "  NETWORK  $1   ← curl exit $rc; cannot check" >&2; exit 1; fi
+  CODE=${out%% *}; TYPE=${out#* }; TYPE=${TYPE%%;*}
+}
+
+# 1. The shell itself first: if live index.html is not ours, every private-path verdict below would be noise.
+fetch index.html
+if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then
+  sleep 15; fetch index.html
+fi
+if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then
+  echo "  SHELL    index.html is not the deployed one (HTTP $CODE) — private results would be unreliable; stopping"
+  echo "[check-live] FAILED"; exit 1
+fi
+echo "  SHELL    index.html matches"
+
+# 2. Faithful: every published file byte-identical, with its real media type (never the HTML fallback).
+want_type() {
+  case "$1" in
+    *.js) echo 'application/javascript text/javascript' ;;
+    *.css) echo 'text/css' ;;
+    *.html) echo 'text/html' ;;
+    *) echo '' ;;   # images/json: anything but text/html
+  esac
+}
+type_ok() {
+  local allowed; allowed=$(want_type "$1")
+  if [ -z "$allowed" ]; then [ "$2" != text/html ]; else case " $allowed " in *" $2 "*) return 0;; *) return 1;; esac; fi
+}
+for f in $(cat scripts/dist-manifest.txt); do
+  fetch "$f"
+  if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$(hash "dist/$f")" ] || ! type_ok "$f" "$TYPE"; then sleep 15; fetch "$f"; fi
+  if [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$(hash "dist/$f")" ] && type_ok "$f" "$TYPE"; then
+    echo "  MATCH    $f"
+  else
+    echo "  DIFF     $f   ← HTTP $CODE, $TYPE"; fail=1
+  fi
+done
+
+# 3. Private: each listed path must serve the app shell (the fallback) or a 404 — never its own content.
+private_verdict() {
+  if [ "$CODE" = 404 ]; then echo ok; return; fi
+  if [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; then echo ok; return; fi
+  if [ "$CODE" = 200 ] && [ -n "$PREV_HASH" ] && [ "$(hash "$BODY")" = "$PREV_HASH" ]; then echo lag; return; fi
+  echo leak
+}
+for p in $(cat scripts/must-not-be-public.txt); do
+  fetch "$p"; v=$(private_verdict)
+  if [ "$v" != ok ]; then sleep 15; fetch "$p"; v=$(private_verdict); fi
+  case "$v" in
+    ok)   echo "  PRIVATE  $p" ;;
+    lag)  echo "  LAG      $p   ← still the PREVIOUS deploy's fallback page (CDN lag): inconclusive, re-run check-live"; inconclusive=1 ;;
+    leak) echo "  PUBLIC   $p   ← HTTP $CODE, $(wc -c < "$BODY" | tr -d ' ') bytes: must not be public"; fail=1 ;;
+  esac
+done
+
+# 4. Functions: a POSITIVE signal per function (a missing one would get 200 + the shell). GET only — nothing is sent.
+check_fn() {   # name expected-status note
+  fetch ".netlify/functions/$1"
+  if [ "$CODE" = "$2" ]; then echo "  FUNC     $1 → $CODE"
+  elif [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; then echo "  MISSING  $1   ← got the app shell: the function is NOT deployed"; fail=1
+  else echo "  FUNC?    $1 → $CODE (expected $2) — $3"; fail=1
+  fi
+}
+check_fn preview-shift-reminders 401 "401 without the secret also proves the shared helper reached the function"
+check_fn send-shift-reminders 403 "403 is Netlify refusing HTTP for a deployed SCHEDULED function; another status may be a platform change, the shell means the reminder job is gone"
+for f in schedule-builder send-notification send-schedule-change-email send-timeoff-comment-email \
+         send-timeoff-confirmation-email send-timeoff-status-email send-timeoff-submission-email; do
+  check_fn "$f" 405 "POST-only; a GET should be refused with 405"
+done
+
+if [ $fail -ne 0 ]; then echo "[check-live] FAILED"; exit 1; fi
+if [ $inconclusive -ne 0 ]; then echo "[check-live] INCONCLUSIVE (CDN lag) — wait a minute and run: bash scripts/check-live.sh $SHA"; exit 2; fi
+echo "[check-live] ok"
diff --git a/scripts/deploy.sh b/scripts/deploy.sh
new file mode 100755
index 0000000..7b52dd4
--- /dev/null
+++ b/scripts/deploy.sh
@@ -0,0 +1,40 @@
+#!/bin/bash
+# The Tinker Ticker deploy, in one place (plan: ticker-publish-only-the-app; ~/.claude/CLAUDE.md → NETLIFY).
+# Every Netlify deploy costs credits and needs Christie's OK for the exact commit:
+#   1. bash scripts/preflight.sh                      (build + full tests; uploads nothing)
+#   2. Christie: "okay to deploy tinker ticker <full sha>"
+#   3. npm run deploy -- --approved <full sha>
+# It refuses unless HEAD is that sha, the tree is clean, and HEAD is exactly origin/main (so what is live is what
+# origin/main holds). It re-runs the preflight itself, deploys dist/ with the sha as the message, then checks the live site.
+set -euo pipefail
+cd "$(dirname "$0")/.."
+refuse() { echo "[deploy] REFUSING: $*" >&2; exit 1; }
+
+APPROVED=""
+if [ "${1:-}" = "--approved" ]; then APPROVED=${2:-}; fi
+SHA=$(git rev-parse HEAD)
+if [ -z "$APPROVED" ]; then
+  echo "[deploy] would deploy $SHA ($(git log -1 --format=%s))"
+  echo "[deploy] nothing done. After preflight and Christie's \"okay to deploy tinker ticker $SHA\":"
+  echo "         npm run deploy -- --approved $SHA"
+  exit 1
+fi
+[ "$APPROVED" = "$SHA" ] || refuse "approved $APPROVED but HEAD is $SHA"
+[ -z "$(git status --porcelain)" ] || refuse "the working tree is not clean"
+[ "$(git rev-parse --abbrev-ref HEAD)" = main ] || refuse "not on main — merge into main and push first"
+UP=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null) || refuse "main has no upstream — push it first"
+[ "$UP" = origin/main ] || refuse "main tracks $UP, not origin/main"
+git fetch -q origin
+[ "$(git rev-parse HEAD)" = "$(git rev-parse '@{u}')" ] || refuse "HEAD is not exactly origin/main (ahead or behind) — push or pull first"
+
+echo "[deploy] re-running the preflight (build + full tests) before anything is uploaded…"
+bash scripts/preflight.sh
+
+PREV=$(mktemp)
+curl -sS --location --connect-timeout 10 --max-time 30 -o "$PREV" "https://tinker-timeclock.netlify.app/index.html?v=prev-$SHA" || : > "$PREV"
+netlify deploy --prod --dir dist --message "$SHA"
+set +e
+bash scripts/check-live.sh "$SHA" "$PREV"
+rc=$?
+rm -f "$PREV"
+exit $rc
diff --git a/scripts/dist-manifest.txt b/scripts/dist-manifest.txt
new file mode 100644
index 0000000..26d10de
--- /dev/null
+++ b/scripts/dist-manifest.txt
@@ -0,0 +1,18 @@
+assets/apple-touch-icon.png
+assets/favicon.svg
+assets/icon-192.png
+assets/icon-512.png
+assets/icon-maskable-192.png
+assets/icon-maskable-512.png
+css/auth-guard.css
+css/styles.css
+index.html
+js/app.js
+js/auth-guard.js
+js/firebase-config.js
+js/firebase-data.js
+js/push-notifications.js
+js/schedule-helpers.js
+js/timeoff-schedule.js
+manifest.json
+sw.js
diff --git a/scripts/dist-private.txt b/scripts/dist-private.txt
new file mode 100644
index 0000000..a31d74c
--- /dev/null
+++ b/scripts/dist-private.txt
@@ -0,0 +1,3 @@
+firebase.json
+package-lock.json
+package.json
diff --git a/scripts/must-not-be-public.txt b/scripts/must-not-be-public.txt
new file mode 100644
index 0000000..45a105c
--- /dev/null
+++ b/scripts/must-not-be-public.txt
@@ -0,0 +1,19 @@
+user-import.html
+grant-timeclock-access.html
+schedule-import.html
+summer-camp-sync.html
+CLAUDE.md
+AGENTS.md
+KIOSK-PLANNING.md
+schedule-helpers.test.js
+schedule-editor-wiring.test.js
+timeoff-sub-confirm.emulator.test.js
+firestore-debug.log
+package.json
+package-lock.json
+firebase.json
+deno.lock
+netlify/functions/send-shift-reminders.js
+netlify/functions/_lib/shift-reminder.js
+scripts/deploy.sh
+scripts/dist-manifest.txt
diff --git a/scripts/preflight.sh b/scripts/preflight.sh
new file mode 100755
index 0000000..920e2b6
--- /dev/null
+++ b/scripts/preflight.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+# Everything a deploy needs, done locally and uploading NOTHING (plan: ticker-publish-only-the-app).
+# Run it before asking Christie "okay to deploy?"; deploy.sh runs it again itself.
+set -euo pipefail
+cd "$(dirname "$0")/.."
+if [ -n "$(git status --porcelain)" ]; then echo "[preflight] REFUSING: the working tree is not clean"; git status --short; exit 1; fi
+bash scripts/build-dist.sh
+if lsof -iTCP:8080 -sTCP:LISTEN >/dev/null 2>&1; then
+  echo "[preflight] REFUSING: port 8080 is in use — another Firestore emulator (maybe another project's) is running. Stop it, then re-run."
+  exit 1
+fi
+echo "[preflight] running the full test suite (Firestore emulator)…"
+npm test
+SHA=$(git rev-parse HEAD)
+echo "[preflight] ok — $SHA"
+echo "[preflight] to deploy, Christie says:  okay to deploy tinker ticker $SHA"
