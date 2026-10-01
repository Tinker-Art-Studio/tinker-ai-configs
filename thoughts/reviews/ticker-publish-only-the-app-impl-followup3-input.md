## Fix-for-the-fix review: commit 4781a8f (Tinker Ticker, branch fix/sub-confirm-manager-only)
It applies the findings in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-publish-only-the-app-impl-followup2-codex.md.
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

## Diff (git show 4781a8f)
commit 4781a8f3831b54c718e4a42360b523f3a8179861
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 20:47:58 2026 -0600

    fix: check-live retries only a server hiccup (5xx/429), never a real answer — a leaked body is evidence
    
    From the Codex check of bdf49ec: the per-path retry could replace a 200 carrying a private file's bytes with
    a later shell response and pass. A retry now happens only for 5xx/429, for files, private paths and all nine
    function probes alike; a real answer is a verdict. Documents the known limit of the main-address check for a
    deploy that changes no published file.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/schedule-editor-wiring.test.js b/schedule-editor-wiring.test.js
index 9c7bf12..805ebf9 100644
--- a/schedule-editor-wiring.test.js
+++ b/schedule-editor-wiring.test.js
@@ -2536,9 +2536,12 @@ describe('the site publishes only the app', () => {
     expect(check.slice(liveAt)).toMatch(/fetch "\$LIVE" "\$f"[\s\S]*?done < scripts\/dist-manifest\.txt[\s\S]*?exit 2/);
     // an inconclusive network drop never hides a failure already found
     expect(check).toMatch(/if \[ \$fail -ne 0 \]; then echo "\[check-live\] FAILED \(a failure above was found before the network dropped\)"; exit 1; fi/);
-    // one retry per path before a verdict
-    expect(check).toMatch(/same \|\| \{ sleep 5; fetch "\$BASE" "\$f"; \}/);
-    expect(check).toMatch(/shell_or_404 \|\| \{ sleep 5; fetch "\$BASE" "\$p"; \}/);
+    // a retry ONLY for a server hiccup (5xx/429) — never for a real answer, which is evidence (a 200 with a private file's bytes)
+    expect(check).toMatch(/fetch_once_more_if_transient\(\) \{\s*case "\$CODE" in 5\?\?\|429\) sleep 5; fetch "\$1" "\$2" ;; esac\s*\}/);
+    expect(check).toMatch(/same \|\| fetch_once_more_if_transient "\$BASE" "\$f"/);
+    expect(check).toMatch(/shell_or_404 \|\| fetch_once_more_if_transient "\$BASE" "\$p"/);
+    expect(check).toMatch(/fetch "\$BASE" "\.netlify\/functions\/\$1"\s*fetch_once_more_if_transient "\$BASE" "\.netlify\/functions\/\$1"/);
+    expect(check).not.toMatch(/\|\| \{ sleep 5; fetch/);
     expect(check).toMatch(/\[ "\$priv_count" -gt 40 \]/);
     // functions: status AND JSON where the handler sends JSON
     expect(check).toMatch(/check_fn preview-shift-reminders 401 application\/json "Unauthorized"/);
diff --git a/scripts/check-live.sh b/scripts/check-live.sh
index b246205..f058f34 100755
--- a/scripts/check-live.sh
+++ b/scripts/check-live.sh
@@ -34,6 +34,11 @@ fetch() {
   fi
   CODE=${out%% *}; TYPE=${out#* }; TYPE=${TYPE%%;*}; TYPE=${TYPE// /}
 }
+# fetch_once_more_if_transient <base> <path>: retry ONLY a server-side hiccup (5xx / 429). A real answer — even a wrong
+# one, e.g. a 200 carrying a private file's bytes — is evidence and is never retried away.
+fetch_once_more_if_transient() {
+  case "$CODE" in 5??|429) sleep 5; fetch "$1" "$2" ;; esac
+}
 
 # 2. Faithful: every published file byte-identical, with its real media type (never the HTML fallback, never empty).
 type_ok() {
@@ -49,7 +54,7 @@ while IFS= read -r f; do
   [ -n "$f" ] || continue
   fetch "$BASE" "$f"
   same() { [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$(hash "dist/$f")" ] && type_ok "$f" "$TYPE"; }
-  same || { sleep 5; fetch "$BASE" "$f"; }   # one retry: a single 503 is not a verdict
+  same || fetch_once_more_if_transient "$BASE" "$f"
   if same; then
     echo "  MATCH    $f"
   else
@@ -69,7 +74,7 @@ while IFS= read -r p; do
   priv_count=$((priv_count + 1))
   fetch "$BASE" "$p"
   shell_or_404() { [ "$CODE" = 404 ] || { [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; }; }
-  shell_or_404 || { sleep 5; fetch "$BASE" "$p"; }
+  shell_or_404 || fetch_once_more_if_transient "$BASE" "$p"
   if shell_or_404; then
     :
   else
@@ -83,6 +88,7 @@ echo "  PRIVATE  $priv_count unpublished paths checked (every tracked file outsi
 json_error_is() { python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if isinstance(d, dict) and d.get("error") == sys.argv[2] else 1)' "$BODY" "$1" 2>/dev/null; }
 check_fn() {   # name expected-status expected-type expected-json-error note
   fetch "$BASE" ".netlify/functions/$1"
+  fetch_once_more_if_transient "$BASE" ".netlify/functions/$1"
   if [ "$CODE" = "$2" ] && { [ -z "$3" ] || { [ "$TYPE" = "$3" ] && json_error_is "$4"; }; }; then echo "  FUNC     $1 → $CODE ${TYPE}"
   elif [ "$CODE" = 200 ] && [ "$(hash "$BODY")" = "$SHELL_HASH" ]; then echo "  MISSING  $1   ← got the app shell: the function is NOT deployed"; fail=1
   else echo "  FUNC?    $1 → $CODE ${TYPE:-no type} (expected $2 ${3:-} ${4:-}) — ${5:-}"; fail=1
@@ -99,6 +105,8 @@ if [ $fail -ne 0 ]; then echo "[check-live] FAILED"; exit 1; fi
 
 # 5. LAST: is the main address serving this deploy yet? Every published file must match there too (index.html alone
 #    could be unchanged between deploys). Not yet = propagation: INCONCLUSIVE, but everything above is already proven.
+#    Known limit: a deploy that changes NO published file (functions or redirects only) can't be told apart from the
+#    previous deploy here; for that, the deploy's own address above is the proof.
 if [ "$BASE" != "$LIVE" ]; then
   stale=""
   while IFS= read -r f; do
