## Fix-for-the-fix review: commit bdf49ec (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies the findings in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-publish-only-the-app-impl-followup-{claude,codex}.md.
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

## Diff (git show bdf49ec)
commit bdf49ecb9159f116387d9ac7d21cfaab76379e9b
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 20:43:13 2026 -0600

    fix: check-live verifies the deploy first and the main address last, retries once, parses function JSON
    
    From the review of 6ce9c3b (Claude: ready; Codex: no BLOCKING, one future false-pass):
    - Order: the deploy's own address is verified first (files, every unpublished path, nine functions); only
      then is the main address asked whether it serves ALL 18 files yet (index.html alone can be unchanged
      between deploys — Codex's false-pass). Not yet = exit 2 with the deploy already proven.
    - One retry per path (5 s) before a verdict, so a single 503 can't read as a leak or a missing file.
    - Function probes parse the JSON body: {"error":"Unauthorized"} / {"error":"Method not allowed"}.
    - A network drop after a failure was found reports FAILED, not "inconclusive".
    - Fewer than 40 private paths (git ls-files gave too little) is a failure, not a quiet pass.
    - deploy.sh: a missing deploy_url falls back to checking the main address instead of stopping after a paid
      upload; the Netlify log URL is printed; exit-code meanings are printed.
    - build-dist: no icons, or invalid manifest.json, refuses by name. Tests and CLAUDE.md updated.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/CLAUDE.md b/CLAUDE.md
index d852d2d..c2f0bed 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -66,8 +66,11 @@ If data appears missing or blank, check Firestore rules before assuming data los
   1. `npm run deploy:check` — build + full test suite; uploads nothing; prints the sentence to ask for
   2. Ask Christie — each deploy costs credits — and wait for "okay to deploy tinker ticker <full sha>"
   3. `npm run deploy -- --approved <full sha>` — re-runs the preflight, deploys `dist/` with the sha as the message, then
-     `scripts/check-live.sh`: every file byte-identical live, every path in `scripts/must-not-be-public.txt` serves only the app
-     shell, all nine functions answer as expected. Exit 2 = CDN lag, re-run `bash scripts/check-live.sh <sha>`.
+     `scripts/check-live.sh <sha> <deploy-url>` against the deploy's own address (no CDN lag): every file byte-identical, every
+     tracked file outside `dist/` (plus `scripts/must-not-be-public.txt`) serving only the app shell, all nine functions answering
+     as expected — then, last, whether the main address serves all of it yet.
+     Exit 0 ok · exit 1 a real problem (re-run once before acting) · exit 2 not fully proven yet (propagation or network): re-run
+     with the same two arguments it prints. A bad deploy is undone by republishing the previous deploy in Netlify's UI (free).
 - This site answers every unknown path with 200 + index.html (the single-page fallback): a status code proves nothing — compare bodies.
 - `npx http-server . -p 8093` still serves the repo for local work; `netlify dev` serves `dist/`, so run `bash scripts/build-dist.sh`
   first (it builds from HEAD — uncommitted edits are not included).
diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index 0d1c160..9c7bf12 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2494,6 +2494,9 @@ describe('the site publishes only the app', () => {
     expect(build).toMatch(/git archive HEAD -- \$\(cat "\$MANIFEST"\) \| tar -x -C dist/);
     expect(build).toMatch(/bash scripts\/candidate-set\.sh/);
     expect(build).toMatch(/referenced by the app but not in dist\//);
+    // each parser that finds nothing refuses by name; lists can't smuggle dot-files or whitespace
+    ['found no src/href in dist/index.html', 'found no APP_SHELL entries in dist/sw.js', 'found no icons in dist/manifest.json',
+     'dist/manifest.json is not valid JSON', 'a listed path has a dot-file segment or whitespace'].forEach(m => expect(build).toContain(m));
     expect(build).not.toMatch(/cp -R/);   // never a folder copy
   });
 
@@ -2520,15 +2523,28 @@ describe('the site publishes only the app', () => {
     expect(check).not.toMatch(/--fail/);   // an expected 401/403/404/405 must not become a curl error
     expect(check).toMatch(/--connect-timeout 10 --max-time 30/);
     // private: the shell or a 404, judged by BODY; and EVERY tracked file outside dist/ is checked, not a sample
-    expect(check).toMatch(/if \[ "\$CODE" = 404 \] \|\| \{ \[ "\$CODE" = 200 \] && \[ "\$\(hash "\$BODY"\)" = "\$SHELL_HASH" \]; \}; then/);
+    expect(check).toMatch(/shell_or_404\(\) \{ \[ "\$CODE" = 404 \] \|\| \{ \[ "\$CODE" = 200 \] && \[ "\$\(hash "\$BODY"\)" = "\$SHELL_HASH" \]; \}; \}/);
     expect(check).toMatch(/git ls-files \| grep -vE '\(\^\|\/\)\\\.' \| LC_ALL=C sort \| LC_ALL=C comm -23 - <\(LC_ALL=C sort scripts\/dist-manifest\.txt\)/);
     // files/private/functions are checked on the deploy's OWN address (no CDN lag); propagation is inconclusive (exit 2), not a failure
     expect(check).toMatch(/BASE=\$\{2:-\$LIVE\}/);
-    expect(check).toMatch(/is not serving this deploy's index\.html yet[\s\S]*?exit 2/);
+    // the deploy itself (files, private, functions) is verified FIRST; the main address catching up is checked LAST, on all
+    // published files, and "not yet" is inconclusive (exit 2) — never a pass on index.html alone
+    const fnAt = check.indexOf('check_fn preview-shift-reminders');
+    const liveAt = check.indexOf('# 5. LAST: is the main address serving this deploy yet?');
+    expect(fnAt).toBeGreaterThan(-1);
+    expect(liveAt).toBeGreaterThan(fnAt);
+    expect(check.slice(liveAt)).toMatch(/fetch "\$LIVE" "\$f"[\s\S]*?done < scripts\/dist-manifest\.txt[\s\S]*?exit 2/);
+    // an inconclusive network drop never hides a failure already found
+    expect(check).toMatch(/if \[ \$fail -ne 0 \]; then echo "\[check-live\] FAILED \(a failure above was found before the network dropped\)"; exit 1; fi/);
+    // one retry per path before a verdict
+    expect(check).toMatch(/same \|\| \{ sleep 5; fetch "\$BASE" "\$f"; \}/);
+    expect(check).toMatch(/shell_or_404 \|\| \{ sleep 5; fetch "\$BASE" "\$p"; \}/);
+    expect(check).toMatch(/\[ "\$priv_count" -gt 40 \]/);
     // functions: status AND JSON where the handler sends JSON
-    expect(check).toMatch(/check_fn preview-shift-reminders 401 application\/json/);
-    expect(check).toMatch(/check_fn send-shift-reminders 403 ""/);
-    expect(check).toMatch(/check_fn "\$f" 405 application\/json/);
+    expect(check).toMatch(/check_fn preview-shift-reminders 401 application\/json "Unauthorized"/);
+    expect(check).toMatch(/check_fn send-shift-reminders 403 "" ""/);
+    expect(check).toMatch(/check_fn "\$f" 405 application\/json "Method not allowed"/);
+    expect(check).toMatch(/d\.get\("error"\) == sys\.argv\[2\]/);   // the JSON body is parsed, not just the header
     const deploy = read('scripts/deploy.sh');
     expect(deploy).toMatch(/netlify deploy --prod --dir dist --functions netlify\/functions --message "\$SHA" --json/);
     expect(deploy).toMatch(/bash scripts\/check-live\.sh "\$SHA" "\$DEPLOY_URL"/);
diff --git a/scripts/build-dist.sh b/scripts/build-dist.sh
index 430e7b5..e2220d1 100755
--- a/scripts/build-dist.sh
+++ b/scripts/build-dist.sh
@@ -43,9 +43,10 @@ got=$(cd dist && find . -type f | sed 's#^\./##' | LC_ALL=C sort)
 # 3. Complete: everything the app asks for is in dist/. Fragment-only, absolute, data: and mailto: values are not files.
 html_refs=$(grep -oiE "(src|href)[[:space:]]*=[[:space:]]*(\"[^\"]*\"|'[^']*')" dist/index.html | sed -E "s/^[^=]*=[[:space:]]*[\"']//; s/[\"']\$//" || true)
 shell_refs=$(sed -n '/const APP_SHELL = \[/,/\];/p' dist/sw.js | grep -oE "'[^']+'|\"[^\"]+\"" | tr -d "'\"" || true)
-icon_refs=$(python3 -c 'import json; print("\n".join(i["src"] for i in json.load(open("dist/manifest.json")).get("icons", [])))')
+icon_refs=$(python3 -c 'import json; print("\n".join(i["src"] for i in json.load(open("dist/manifest.json")).get("icons", [])))' 2>/dev/null) || fail "dist/manifest.json is not valid JSON"
 [ -n "$html_refs" ] || fail "found no src/href in dist/index.html — has its format changed?"
 [ -n "$shell_refs" ] || fail "found no APP_SHELL entries in dist/sw.js — has 'const APP_SHELL = [' been renamed?"
+[ -n "$icon_refs" ] || fail "found no icons in dist/manifest.json — the maskable icons are referenced only there"
 refs=$(printf '%s\n%s\n%s\nsw.js\n' "$html_refs" "$shell_refs" "$icon_refs" \
   | grep -vE '^(#|https?:|//|data:|mailto:|$)' | sed -E 's/[?#].*$//; s#^/##; s#^$#index.html#' | LC_ALL=C sort -u)
 missing=""
diff --git a/scripts/check-live.sh b/scripts/check-live.sh
index ce659f1..b246205 100755
--- a/scripts/check-live.sh
+++ b/scripts/check-live.sh
@@ -28,20 +28,13 @@ fetch() {
   n=$((n + 1)); BODY="$TMP/body.$n"
   local out
   if ! out=$(curl -sS --location --connect-timeout 10 --max-time 30 -o "$BODY" -w '%{http_code} %{content_type}' "$1/$2?v=$SHA"); then
-    echo "  NETWORK  $2   ← could not reach $1"; echo "[check-live] INCONCLUSIVE (network) — re-run: bash scripts/check-live.sh $SHA $BASE"; exit 2
+    echo "  NETWORK  $2   ← could not reach $1"
+    if [ $fail -ne 0 ]; then echo "[check-live] FAILED (a failure above was found before the network dropped)"; exit 1; fi
+    echo "[check-live] INCONCLUSIVE (network) — nothing is proven yet; re-run: bash scripts/check-live.sh $SHA $BASE"; exit 2
   fi
   CODE=${out%% *}; TYPE=${out#* }; TYPE=${TYPE%%;*}; TYPE=${TYPE// /}
 }
 
-# 1. Has the main address picked up this deploy? Propagation lag is INCONCLUSIVE, not a failure.
-fetch "$LIVE" index.html
-if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then sleep 15; fetch "$LIVE" index.html; fi
-if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$SHELL_HASH" ]; then
-  echo "  LIVE     $LIVE is not serving this deploy's index.html yet (HTTP $CODE) — propagation"
-  echo "[check-live] INCONCLUSIVE — wait a minute and re-run: bash scripts/check-live.sh $SHA $BASE"; exit 2
-fi
-echo "  LIVE     $LIVE serves this deploy"
-
 # 2. Faithful: every published file byte-identical, with its real media type (never the HTML fallback, never empty).
 type_ok() {
   [ -n "$2" ] || return 1
@@ -55,7 +48,9 @@ type_ok() {
 while IFS= read -r f; do
   [ -n "$f" ] || continue
   fetch "$BASE" "$f"
-  if [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$(hash "dist/$f")" ] && type_ok "$f" "$TYPE"; then
+  same() { [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$(hash "dist/$f")" ] && type_ok "$f" "$TYPE"; }
+  same || { sleep 5; fetch "$BASE" "$f"; }   # one retry: a single 503 is not a verdict
+  if same; then
     echo "  MATCH    $f"
   else
     echo "  DIFF     $f   ← HTTP $CODE, ${TYPE:-no type}"; fail=1
@@ -73,28 +68,50 @@ while IFS= read -r p; do
   [ -n "$p" ] || continue
   priv_count=$((priv_count + 1))
   fetch "$BASE" "$p"
-  if [ "$CODE" = 404 ] || { [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; }; then
+  shell_or_404() { [ "$CODE" = 404 ] || { [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; }; }
+  shell_or_404 || { sleep 5; fetch "$BASE" "$p"; }
+  if shell_or_404; then
     :
   else
     echo "  PUBLIC   $p   ← HTTP $CODE, $(wc -c < "$BODY" | tr -d ' ') bytes: must not be public"; fail=1
   fi
 done < <(private_paths)
+[ "$priv_count" -gt 40 ] || { echo "  PRIVATE  only $priv_count paths — git ls-files gave too little to check"; fail=1; }
 echo "  PRIVATE  $priv_count unpublished paths checked (every tracked file outside dist/, plus the memorial list)"
 
 # 4. Functions: a POSITIVE signal per function (a missing one would get 200 + the shell). GET only — nothing is sent.
-check_fn() {   # name expected-status expected-type note
+json_error_is() { python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if isinstance(d, dict) and d.get("error") == sys.argv[2] else 1)' "$BODY" "$1" 2>/dev/null; }
+check_fn() {   # name expected-status expected-type expected-json-error note
   fetch "$BASE" ".netlify/functions/$1"
-  if [ "$CODE" = "$2" ] && { [ -z "$3" ] || [ "$TYPE" = "$3" ]; }; then echo "  FUNC     $1 → $CODE ${TYPE}"
+  if [ "$CODE" = "$2" ] && { [ -z "$3" ] || { [ "$TYPE" = "$3" ] && json_error_is "$4"; }; }; then echo "  FUNC     $1 → $CODE ${TYPE}"
   elif [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; then echo "  MISSING  $1   ← got the app shell: the function is NOT deployed"; fail=1
-  else echo "  FUNC?    $1 → $CODE ${TYPE:-no type} (expected $2 ${3:-}) — $4"; fail=1
+  else echo "  FUNC?    $1 → $CODE ${TYPE:-no type} (expected $2 ${3:-} ${4:-}) — ${5:-}"; fail=1
   fi
 }
-check_fn preview-shift-reminders 401 application/json "401 JSON without the secret also proves the shared helper reached the function"
-check_fn send-shift-reminders 403 "" "403 is Netlify refusing HTTP for a deployed SCHEDULED function; another status may be a platform change — the shell would mean the reminder job is gone"
+check_fn preview-shift-reminders 401 application/json "Unauthorized" "401 JSON without the secret also proves the shared helper reached the function"
+check_fn send-shift-reminders 403 "" "" "403 is Netlify refusing HTTP for a deployed SCHEDULED function; another status may be a platform change — the shell would mean the reminder job is gone"
 for f in schedule-builder send-notification send-schedule-change-email send-timeoff-comment-email \
          send-timeoff-confirmation-email send-timeoff-status-email send-timeoff-submission-email; do
-  check_fn "$f" 405 application/json "POST-only; a GET should be refused with 405 JSON"
+  check_fn "$f" 405 application/json "Method not allowed" "POST-only; a GET should be refused with 405 JSON"
 done
 
 if [ $fail -ne 0 ]; then echo "[check-live] FAILED"; exit 1; fi
+
+# 5. LAST: is the main address serving this deploy yet? Every published file must match there too (index.html alone
+#    could be unchanged between deploys). Not yet = propagation: INCONCLUSIVE, but everything above is already proven.
+if [ "$BASE" != "$LIVE" ]; then
+  stale=""
+  while IFS= read -r f; do
+    [ -n "$f" ] || continue
+    fetch "$LIVE" "$f"
+    if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$(hash "dist/$f")" ]; then sleep 15; fetch "$LIVE" "$f"; fi
+    if [ "$CODE" != 200 ] || [ "$(hash "$BODY")" != "$(hash "dist/$f")" ]; then stale="$stale $f"; fi
+  done < scripts/dist-manifest.txt
+  if [ -n "$stale" ]; then
+    echo "  LIVE     $LIVE is not serving this deploy yet for:$stale"
+    echo "[check-live] the deploy itself is VERIFIED; the main address is still catching up — re-run in a minute: bash scripts/check-live.sh $SHA $BASE"
+    exit 2
+  fi
+  echo "  LIVE     $LIVE serves all $(grep -c . scripts/dist-manifest.txt) files of this deploy"
+fi
 echo "[check-live] ok"
diff --git a/scripts/deploy.sh b/scripts/deploy.sh
index 7fe662a..d51b244 100755
--- a/scripts/deploy.sh
+++ b/scripts/deploy.sh
@@ -34,8 +34,10 @@ bash scripts/preflight.sh
 OUT=$(mktemp)
 trap 'rm -f "$OUT"' EXIT
 netlify deploy --prod --dir dist --functions netlify/functions --message "$SHA" --json > "$OUT"
-DEPLOY_URL=$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("deploy_url") or "")' "$OUT")
-echo "[deploy] deployed $SHA — this deploy's own address: ${DEPLOY_URL:-unknown}"
-[ -n "$DEPLOY_URL" ] || refuse "deployed, but netlify did not report the deploy URL — check by hand: bash scripts/check-live.sh $SHA"
+DEPLOY_URL=$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("deploy_url") or "")' "$OUT" || true)
+LOGS=$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("logs") or "")' "$OUT" || true)
+echo "[deploy] deployed $SHA — this deploy's own address: ${DEPLOY_URL:-not reported (checking the main address instead)}"
+[ -z "$LOGS" ] || echo "[deploy] Netlify logs: $LOGS"
+echo "[deploy] check-live: exit 0 = ok; exit 1 = a real problem (re-run once before acting); exit 2 = not fully proven yet, re-run"
 set +e
 bash scripts/check-live.sh "$SHA" "$DEPLOY_URL"
