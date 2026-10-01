## Fix-for-the-fix review: commit 6ce9c3b (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies the findings in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-publish-only-the-app-impl-{claude,codex}.md.
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html.
READ-ONLY for you: no edits, no `netlify` commands, do not run deploy.sh; nothing under /Users/christiehubley/tinker-timeclock/.claude/.
You may read files and curl https://tinker-timeclock.netlify.app read-only.
Already done: preflight at 6ce9c3b passed (1943/1943); check-live dry-run against today's site (dist built from live 4ac3d09)
named all 56 current exposures among 65 checked paths and passed all 9 functions.

Review ONLY this diff. Does each change resolve the finding it cites, and does it introduce anything new? Focus:
- deploy.sh: `netlify deploy … --json` output parsing (does Netlify's prod JSON have `deploy_url`? what if the deploy fails —
  set -e, trap, partial upload?), `--functions netlify/functions` with netlify.toml's functions setting.
- check-live.sh: BASE = the deploy URL for files/private/functions; LIVE only for "is it live yet" (exit 2). Can it now FALSE-PASS
  (e.g. a deploy URL that 404s everything, the private check reading the wrong host, `exit` inside fetch from a process-substitution
  loop)? Bash pitfalls (while-read with `< <(…)`, variables, set -u)?
- build-dist.sh parsing changes (quotes, case, python icon parse, empty-parser refusals, dot/whitespace refusal).
- The tests: do they pin the new behaviour?
Rank BLOCKING / MEDIUM / LOW with file:line. End with: ready to deploy — yes/no.

## Diff (git show 6ce9c3b)
commit 6ce9c3b21b75796b7f9d28ff439cdda075401e92
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 20:23:08 2026 -0600

    fix: publish-only-the-app review follow-ups — check the deploy at its own address, every unpublished file
    
    From the implementation review of 65e3c41 (Claude: ready, two MEDIUM about misreporting CDN lag; Codex: four MEDIUM):
    - check-live verifies files, private paths and functions against the deploy's OWN address (from
      `netlify deploy --json`), which has no CDN lag; the main address is only asked whether it serves the new
      deploy yet, and "not yet" is INCONCLUSIVE (exit 2, re-run), never a failure. A network failure is
      inconclusive too. This replaces the previous-index snapshot, which could not tell lag from a leak.
    - The private check covers EVERY tracked file outside dist/ (dot-paths aside), plus the memorial list —
      not a sample. Dry-run against today's site: 65 paths checked, all 56 current exposures named.
    - Function probes require JSON where the handler sends JSON (401/405), not just the status.
    - build-dist: src/href in either quote style and any case; APP_SHELL in either quote style; manifest icons
      parsed as JSON; a parser that finds nothing refuses with a message; dot-file or whitespace paths in the
      lists are refused; a clearer message for a listed file outside the candidate set.
    - deploy.sh passes --functions netlify/functions explicitly and cleans up its temp file.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index 81d83e4..0d1c160 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2458,8 +2458,8 @@ describe('the site publishes only the app', () => {
   const privateList = lines('scripts/dist-private.txt');
 
   test('the allowlist holds everything the app loads: APP_SHELL, index.html refs, manifest icons, sw.js', () => {
-    const shell = read('sw.js').match(/const APP_SHELL = \[([\s\S]*?)\];/)[1].match(/'[^']+'/g).map(s => s.slice(1, -1));
-    const html = [...read('index.html').matchAll(/(?:src|href)="([^"]+)"/g)].map(m => m[1]);
+    const shell = read('sw.js').match(/const APP_SHELL = \[([\s\S]*?)\];/)[1].match(/'[^']+'|"[^"]+"/g).map(s => s.slice(1, -1));
+    const html = [...read('index.html').matchAll(/(?:src|href)\s*=\s*(?:"([^"]*)"|'([^']*)')/gi)].map(m => m[1] ?? m[2]);
     const icons = JSON.parse(read('manifest.json')).icons.map(i => i.src);
     const needed = [...shell, ...html, ...icons, 'sw.js']
       .filter(r => !/^(#|https?:|\/\/|data:|mailto:)/.test(r))
@@ -2505,10 +2505,10 @@ describe('the site publishes only the app', () => {
     expect(deploy).toMatch(/\[ "\$UP" = origin\/main \] \|\| refuse/);
     expect(deploy).toMatch(/\[ "\$\(git rev-parse HEAD\)" = "\$\(git rev-parse '@\{u\}'\)" \] \|\| refuse/);
     const pre = deploy.indexOf('bash scripts/preflight.sh');
-    const up = deploy.indexOf('netlify deploy --prod --dir dist --message "$SHA"');
+    const up = deploy.indexOf('netlify deploy --prod --dir dist --functions netlify/functions --message "$SHA" --json');
     expect(pre).toBeGreaterThan(-1);
     expect(up).toBeGreaterThan(pre);
-    expect(deploy.indexOf('bash scripts/check-live.sh "$SHA" "$PREV"')).toBeGreaterThan(up);
+    expect(deploy.indexOf('bash scripts/check-live.sh "$SHA" "$DEPLOY_URL"')).toBeGreaterThan(up);
     // bare `npm run deploy` only says what it would ship
     expect(deploy).toMatch(/if \[ -z "\$APPROVED" \]; then[\s\S]*?nothing done[\s\S]*?exit 1\s*fi/);
     expect(read('scripts/preflight.sh')).toMatch(/npm test/);
@@ -2519,10 +2519,19 @@ describe('the site publishes only the app', () => {
     const check = read('scripts/check-live.sh');
     expect(check).not.toMatch(/--fail/);   // an expected 401/403/404/405 must not become a curl error
     expect(check).toMatch(/--connect-timeout 10 --max-time 30/);
-    expect(check).toMatch(/if \[ "\$CODE" = 200 \] && \[ "\$\(hash "\$BODY"\)" = "\$SHELL_HASH" \]; then echo ok; return; fi/);
-    expect(check).toMatch(/\[ "\$\(hash "\$BODY"\)" = "\$PREV_HASH" \]; then echo lag; return; fi/);   // CDN lag is not a leak
-    expect(check).toMatch(/check_fn preview-shift-reminders 401/);
-    expect(check).toMatch(/check_fn send-shift-reminders 403/);
+    // private: the shell or a 404, judged by BODY; and EVERY tracked file outside dist/ is checked, not a sample
+    expect(check).toMatch(/if \[ "\$CODE" = 404 \] \|\| \{ \[ "\$CODE" = 200 \] && \[ "\$\(hash "\$BODY"\)" = "\$SHELL_HASH" \]; \}; then/);
+    expect(check).toMatch(/git ls-files \| grep -vE '\(\^\|\/\)\\\.' \| LC_ALL=C sort \| LC_ALL=C comm -23 - <\(LC_ALL=C sort scripts\/dist-manifest\.txt\)/);
+    // files/private/functions are checked on the deploy's OWN address (no CDN lag); propagation is inconclusive (exit 2), not a failure
+    expect(check).toMatch(/BASE=\$\{2:-\$LIVE\}/);
+    expect(check).toMatch(/is not serving this deploy's index\.html yet[\s\S]*?exit 2/);
+    // functions: status AND JSON where the handler sends JSON
+    expect(check).toMatch(/check_fn preview-shift-reminders 401 application\/json/);
+    expect(check).toMatch(/check_fn send-shift-reminders 403 ""/);
+    expect(check).toMatch(/check_fn "\$f" 405 application\/json/);
+    const deploy = read('scripts/deploy.sh');
+    expect(deploy).toMatch(/netlify deploy --prod --dir dist --functions netlify\/functions --message "\$SHA" --json/);
+    expect(deploy).toMatch(/bash scripts\/check-live\.sh "\$SHA" "\$DEPLOY_URL"/);
     const fns = fs.readdirSync(`${__dirname}/netlify/functions`).filter(f => f.endsWith('.js')).map(f => f.replace(/\.js$/, ''));
     fns.forEach(fn => expect(check).toContain(fn));
     expect(fns.length).toBe(9);
diff --git a/scripts/build-dist.sh b/scripts/build-dist.sh
index 205aabf..430e7b5 100755
--- a/scripts/build-dist.sh
+++ b/scripts/build-dist.sh
@@ -20,13 +20,17 @@ fail() { echo "[build-dist] REFUSING: $*" >&2; exit 1; }
 MANIFEST=scripts/dist-manifest.txt
 PRIVATE=scripts/dist-private.txt
 
+# 0. Manifest entries are plain relative paths: no dot-file segment (the CLI would silently drop it), no whitespace.
+bad=$(grep -nE '(^|/)\.|[[:space:]]' "$MANIFEST" "$PRIVATE" || true)
+[ -z "$bad" ] || fail "a listed path has a dot-file segment or whitespace: $bad"
+
 # 1. Every public candidate is listed exactly once, as public or private.
 both=$(LC_ALL=C comm -12 <(LC_ALL=C sort "$MANIFEST") <(LC_ALL=C sort "$PRIVATE"))
 [ -z "$both" ] || fail "listed as both public and private: $both"
 unlisted=$(LC_ALL=C comm -23 <(bash scripts/candidate-set.sh) <(LC_ALL=C sort "$MANIFEST" "$PRIVATE"))
 [ -z "$unlisted" ] || fail "not listed in $MANIFEST or $PRIVATE — add each on purpose: $(echo $unlisted)"
 stale=$(LC_ALL=C comm -13 <(bash scripts/candidate-set.sh) <(LC_ALL=C sort "$MANIFEST" "$PRIVATE"))
-[ -z "$stale" ] || fail "listed but not a tracked file: $(echo $stale)"
+[ -z "$stale" ] || fail "listed but not a tracked public-candidate file (not committed, or outside js/ css/ assets/ and root *.html *.json sw.js — widen scripts/candidate-set.sh on purpose): $(echo $stale)"
 
 # 2. Committed bytes only.
 rm -rf dist
@@ -37,12 +41,13 @@ got=$(cd dist && find . -type f | sed 's#^\./##' | LC_ALL=C sort)
 [ "$got" = "$(LC_ALL=C sort "$MANIFEST")" ] || fail "dist/ does not match $MANIFEST: $(diff <(echo "$got") <(LC_ALL=C sort "$MANIFEST") | tr '\n' ' ')"
 
 # 3. Complete: everything the app asks for is in dist/. Fragment-only, absolute, data: and mailto: values are not files.
-refs=$( {
-  grep -oE '(src|href)="[^"]+"' dist/index.html | sed -E 's/^(src|href)="//; s/"$//'
-  sed -n '/const APP_SHELL = \[/,/\];/p' dist/sw.js | grep -oE "'[^']+'" | tr -d "'"
-  grep -oE '"src"[[:space:]]*:[[:space:]]*"[^"]+"' dist/manifest.json | sed -E 's/.*"([^"]+)"$/\1/'
-  echo sw.js
-} | grep -vE '^(#|https?:|//|data:|mailto:)' | sed -E 's/[?#].*$//; s#^/##; s#^$#index.html#' | LC_ALL=C sort -u )
+html_refs=$(grep -oiE "(src|href)[[:space:]]*=[[:space:]]*(\"[^\"]*\"|'[^']*')" dist/index.html | sed -E "s/^[^=]*=[[:space:]]*[\"']//; s/[\"']\$//" || true)
+shell_refs=$(sed -n '/const APP_SHELL = \[/,/\];/p' dist/sw.js | grep -oE "'[^']+'|\"[^\"]+\"" | tr -d "'\"" || true)
+icon_refs=$(python3 -c 'import json; print("\n".join(i["src"] for i in json.load(open("dist/manifest.json")).get("icons", [])))')
+[ -n "$html_refs" ] || fail "found no src/href in dist/index.html — has its format changed?"
+[ -n "$shell_refs" ] || fail "found no APP_SHELL entries in dist/sw.js — has 'const APP_SHELL = [' been renamed?"
+refs=$(printf '%s\n%s\n%s\nsw.js\n' "$html_refs" "$shell_refs" "$icon_refs" \
+  | grep -vE '^(#|https?:|//|data:|mailto:|$)' | sed -E 's/[?#].*$//; s#^/##; s#^$#index.html#' | LC_ALL=C sort -u)
 missing=""
 for r in $refs; do [ -f "dist/$r" ] || missing="$missing $r"; done
 [ -z "$missing" ] || fail "referenced by the app but not in dist/:$missing"
diff --git a/scripts/check-live.sh b/scripts/check-live.sh
index 8ebc593..ce659f1 100755
--- a/scripts/check-live.sh
+++ b/scripts/check-live.sh
@@ -1,103 +1,100 @@
 #!/bin/bash
-# After a deploy: prove the live site is exactly dist/, that nothing private is served, and that all nine functions
-# survived (plan: ticker-publish-only-the-app). Exit 1 on any failure; exit 2 when CDN lag makes a result inconclusive.
+# After a deploy: prove the deploy is exactly dist/, that nothing else is served, that all nine functions survived,
+# and that the live site is serving it (plan: ticker-publish-only-the-app).
+#   exit 0 ok · exit 1 FAILED (a real problem) · exit 2 INCONCLUSIVE (network or CDN propagation — just re-run)
+#
+#   usage: check-live.sh <sha> [deploy-url]
+# <deploy-url> is the deploy's own address (https://<id>--tinker-timeclock.netlify.app, printed by deploy.sh). It serves
+# exactly that deploy with no CDN lag, so the file, private-path and function checks run against it; the main address is
+# only asked "has the new deploy gone live yet?". Without it, everything is checked on the main address.
 #
 # THIS SITE ANSWERS EVERY UNKNOWN PATH WITH 200 + index.html (the single-page fallback in netlify.toml). A status code
 # alone proves nothing here — on Sep 29 that misread a fallback as "the worktree is still published". Bodies are compared.
-#
-#   usage: check-live.sh <sha> [previous-live-index.html]
-# The previous deploy's index.html (fetched by deploy.sh before uploading) tells "CDN still serving the old fallback"
-# apart from a real leak.
 set -uo pipefail
 cd "$(dirname "$0")/.."
-BASE=https://tinker-timeclock.netlify.app
-SHA=${1:?usage: check-live.sh <sha> [previous-live-index.html]}
-PREV=${2:-}
+LIVE=https://tinker-timeclock.netlify.app
+SHA=${1:?usage: check-live.sh <sha> [deploy-url]}
+BASE=${2:-$LIVE}
 TMP=$(mktemp -d)
 trap 'rm -rf "$TMP"' EXIT
-fail=0; inconclusive=0
+fail=0
 hash() { shasum < "$1" | cut -c1-40; }
+[ -s dist/index.html ] || { echo "[check-live] dist/ is missing — run bash scripts/build-dist.sh first"; exit 1; }
 SHELL_HASH=$(hash dist/index.html)
-PREV_HASH=""; [ -n "$PREV" ] && [ -s "$PREV" ] && PREV_HASH=$(hash "$PREV")
 
-# fetch <path> → sets CODE, TYPE, BODY (a fresh file). Transport failures are fatal; any HTTP status is returned to the caller.
+# fetch <base> <path> → CODE, TYPE, BODY (a fresh file). A transport failure is inconclusive, never a verdict.
 n=0
 fetch() {
   n=$((n + 1)); BODY="$TMP/body.$n"
-  local sep='?'; case "$1" in *\?*) sep='&';; esac
-  local out rc
-  out=$(curl -sS --location --connect-timeout 10 --max-time 30 -o "$BODY" -w '%{http_code} %{content_type}' "$BASE/$1${sep}v=$SHA")
-  rc=$?
-  if [ $rc -ne 0 ]; then echo "  NETWORK  $1   ← curl exit $rc; cannot check" >&2; exit 1; fi
-  CODE=${out%% *}; TYPE=${out#* }; TYPE=${TYPE%%;*}
+  local out
+  if ! out=$(curl -sS --location --connect-timeout 10 --max-time 30 -o "$BODY" -w '%{http_code} %{content_type}' "$1/$2?v=$SHA"); then
+    echo "  NETWORK  $2   ← could not reach $1"; echo "[check-live] INCONCLUSIVE (network) — re-run: bash scripts/check-live.sh $SHA $BASE"; exit 2
+  fi
+  CODE=${out%% *}; TYPE=${out#* }; TYPE=${TYPE%%;*}; TYPE=${TYPE// /}
 }
 
-# 1. The shell itself first: if live index.html is not ours, every private-path verdict below would be noise.
-fetch index.html
+# 1. Has the main address picked up this deploy? Propagation lag is INCONCLUSIVE, not a failure.
+fetch "$LIVE" index.html
+if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then sleep 15; fetch "$LIVE" index.html; fi
 if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then
-  sleep 15; fetch index.html
+  echo "  LIVE     $LIVE is not serving this deploy's index.html yet (HTTP $CODE) — propagation"
+  echo "[check-live] INCONCLUSIVE — wait a minute and re-run: bash scripts/check-live.sh $SHA $BASE"; exit 2
 fi
-if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then
-  echo "  SHELL    index.html is not the deployed one (HTTP $CODE) — private results would be unreliable; stopping"
-  echo "[check-live] FAILED"; exit 1
-fi
-echo "  SHELL    index.html matches"
+echo "  LIVE     $LIVE serves this deploy"
 
-# 2. Faithful: every published file byte-identical, with its real media type (never the HTML fallback).
-want_type() {
+# 2. Faithful: every published file byte-identical, with its real media type (never the HTML fallback, never empty).
+type_ok() {
+  [ -n "$2" ] || return 1
   case "$1" in
-    *.js) echo 'application/javascript text/javascript' ;;
-    *.css) echo 'text/css' ;;
-    *.html) echo 'text/html' ;;
-    *) echo '' ;;   # images/json: anything but text/html
+    *.js)   [ "$2" = application/javascript ] || [ "$2" = text/javascript ] ;;
+    *.css)  [ "$2" = text/css ] ;;
+    *.html) [ "$2" = text/html ] ;;
+    *)      [ "$2" != text/html ] ;;
   esac
 }
-type_ok() {
-  local allowed; allowed=$(want_type "$1")
-  if [ -z "$allowed" ]; then [ "$2" != text/html ]; else case " $allowed " in *" $2 "*) return 0;; *) return 1;; esac; fi
-}
-for f in $(cat scripts/dist-manifest.txt); do
-  fetch "$f"
-  if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$(hash "dist/$f")" ] || ! type_ok "$f" "$TYPE"; then sleep 15; fetch "$f"; fi
+while IFS= read -r f; do
+  [ -n "$f" ] || continue
+  fetch "$BASE" "$f"
   if [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$(hash "dist/$f")" ] && type_ok "$f" "$TYPE"; then
     echo "  MATCH    $f"
   else
-    echo "  DIFF     $f   ← HTTP $CODE, $TYPE"; fail=1
+    echo "  DIFF     $f   ← HTTP $CODE, ${TYPE:-no type}"; fail=1
   fi
-done
+done < scripts/dist-manifest.txt
 
-# 3. Private: each listed path must serve the app shell (the fallback) or a 404 — never its own content.
-private_verdict() {
-  if [ "$CODE" = 404 ]; then echo ok; return; fi
-  if [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; then echo ok; return; fi
-  if [ "$CODE" = 200 ] && [ -n "$PREV_HASH" ] && [ "$(hash "$BODY")" = "$PREV_HASH" ]; then echo lag; return; fi
-  echo leak
+# 3. Private: EVERY tracked file that is not published (dot-paths aside — the CLI never uploads them), plus the
+#    memorial list of files that once leaked, must serve the app shell or a 404 — never its own bytes.
+private_paths() {
+  { git ls-files | grep -vE '(^|/)\.' | LC_ALL=C sort | LC_ALL=C comm -23 - <(LC_ALL=C sort scripts/dist-manifest.txt)
+    cat scripts/must-not-be-public.txt; } | LC_ALL=C sort -u
 }
-for p in $(cat scripts/must-not-be-public.txt); do
-  fetch "$p"; v=$(private_verdict)
-  if [ "$v" != ok ]; then sleep 15; fetch "$p"; v=$(private_verdict); fi
-  case "$v" in
-    ok)   echo "  PRIVATE  $p" ;;
-    lag)  echo "  LAG      $p   ← still the PREVIOUS deploy's fallback page (CDN lag): inconclusive, re-run check-live"; inconclusive=1 ;;
-    leak) echo "  PUBLIC   $p   ← HTTP $CODE, $(wc -c < "$BODY" | tr -d ' ') bytes: must not be public"; fail=1 ;;
-  esac
-done
+priv_count=0
+while IFS= read -r p; do
+  [ -n "$p" ] || continue
+  priv_count=$((priv_count + 1))
+  fetch "$BASE" "$p"
+  if [ "$CODE" = 404 ] || { [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; }; then
+    :
+  else
+    echo "  PUBLIC   $p   ← HTTP $CODE, $(wc -c < "$BODY" | tr -d ' ') bytes: must not be public"; fail=1
+  fi
+done < <(private_paths)
+echo "  PRIVATE  $priv_count unpublished paths checked (every tracked file outside dist/, plus the memorial list)"
 
 # 4. Functions: a POSITIVE signal per function (a missing one would get 200 + the shell). GET only — nothing is sent.
-check_fn() {   # name expected-status note
-  fetch ".netlify/functions/$1"
-  if [ "$CODE" = "$2" ]; then echo "  FUNC     $1 → $CODE"
+check_fn() {   # name expected-status expected-type note
+  fetch "$BASE" ".netlify/functions/$1"
+  if [ "$CODE" = "$2" ] && { [ -z "$3" ] || [ "$TYPE" = "$3" ]; }; then echo "  FUNC     $1 → $CODE ${TYPE}"
   elif [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; then echo "  MISSING  $1   ← got the app shell: the function is NOT deployed"; fail=1
-  else echo "  FUNC?    $1 → $CODE (expected $2) — $3"; fail=1
+  else echo "  FUNC?    $1 → $CODE ${TYPE:-no type} (expected $2 ${3:-}) — $4"; fail=1
   fi
 }
-check_fn preview-shift-reminders 401 "401 without the secret also proves the shared helper reached the function"
-check_fn send-shift-reminders 403 "403 is Netlify refusing HTTP for a deployed SCHEDULED function; another status may be a platform change, the shell means the reminder job is gone"
+check_fn preview-shift-reminders 401 application/json "401 JSON without the secret also proves the shared helper reached the function"
+check_fn send-shift-reminders 403 "" "403 is Netlify refusing HTTP for a deployed SCHEDULED function; another status may be a platform change — the shell would mean the reminder job is gone"
 for f in schedule-builder send-notification send-schedule-change-email send-timeoff-comment-email \
          send-timeoff-confirmation-email send-timeoff-status-email send-timeoff-submission-email; do
-  check_fn "$f" 405 "POST-only; a GET should be refused with 405"
+  check_fn "$f" 405 application/json "POST-only; a GET should be refused with 405 JSON"
 done
 
 if [ $fail -ne 0 ]; then echo "[check-live] FAILED"; exit 1; fi
-if [ $inconclusive -ne 0 ]; then echo "[check-live] INCONCLUSIVE (CDN lag) — wait a minute and run: bash scripts/check-live.sh $SHA"; exit 2; fi
 echo "[check-live] ok"
diff --git a/scripts/deploy.sh b/scripts/deploy.sh
index 7b52dd4..7fe662a 100755
--- a/scripts/deploy.sh
+++ b/scripts/deploy.sh
@@ -5,7 +5,8 @@
 #   2. Christie: "okay to deploy tinker ticker <full sha>"
 #   3. npm run deploy -- --approved <full sha>
 # It refuses unless HEAD is that sha, the tree is clean, and HEAD is exactly origin/main (so what is live is what
-# origin/main holds). It re-runs the preflight itself, deploys dist/ with the sha as the message, then checks the live site.
+# origin/main holds). It re-runs the preflight itself, deploys dist/ with the sha as the message, then checks the deploy at
+# its own address (no CDN lag) and that the main address is serving it. check-live exit 2 = inconclusive: just re-run it.
 set -euo pipefail
 cd "$(dirname "$0")/.."
 refuse() { echo "[deploy] REFUSING: $*" >&2; exit 1; }
@@ -30,11 +31,11 @@ git fetch -q origin
 echo "[deploy] re-running the preflight (build + full tests) before anything is uploaded…"
 bash scripts/preflight.sh
 
-PREV=$(mktemp)
-curl -sS --location --connect-timeout 10 --max-time 30 -o "$PREV" "https://tinker-timeclock.netlify.app/index.html?v=prev-$SHA" || : > "$PREV"
-netlify deploy --prod --dir dist --message "$SHA"
+OUT=$(mktemp)
+trap 'rm -f "$OUT"' EXIT
+netlify deploy --prod --dir dist --functions netlify/functions --message "$SHA" --json > "$OUT"
+DEPLOY_URL=$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("deploy_url") or "")' "$OUT")
+echo "[deploy] deployed $SHA — this deploy's own address: ${DEPLOY_URL:-unknown}"
+[ -n "$DEPLOY_URL" ] || refuse "deployed, but netlify did not report the deploy URL — check by hand: bash scripts/check-live.sh $SHA"
 set +e
-bash scripts/check-live.sh "$SHA" "$PREV"
-rc=$?
-rm -f "$PREV"
-exit $rc
+bash scripts/check-live.sh "$SHA" "$DEPLOY_URL"
