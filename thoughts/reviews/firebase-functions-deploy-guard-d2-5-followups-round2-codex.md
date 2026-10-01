OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/my-clay-hub
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f7f1-d08a-78d3-9f1c-109c388b694e
--------
user
# Confirming pass: my-clay-hub branch d2-attest-followups, fix commit c562f69

You are an independent reviewer. Read-only: do not edit, commit, run any Firebase CLI command, or contact any network service. Repo: /Users/christiehubley/my-clay-hub. You may run `bash -n`. Do not run `npm test` or the guard suites (run separately: functions guard 634 passed).

Your previous review of 7efa0f0..3fefa4e (text: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/firebase-functions-deploy-guard-d2-5-followups-codex.md) said "not ready" with:
1. (blocking) the "Enabling now" transcript check was fail-open on grep errors;
2. (blocking) a known iam_attested=no between the last yes and now could be forgotten;
3. (blocking) --reconcile and --clear-inflight wrote attempt records without attest_needed or guidance;
4. (should-fix) --status didn't show attest_needed.

Review `git show c562f69` (and the whole `attest_need` / `attest_report` / `attest_help` in scripts/deploy-functions.sh as it now stands).
- Is each finding fixed? Any new bug introduced (set -euo pipefail interactions, the process substitution in attest_help, `record_word` usage in --status, the clear-inflight path setting DEPLOY_VERIFIED/TRANSCRIPT)?
- Do the new tests in scripts/deploy-functions.test.sh actually exercise each fix (including the fake grep for the unreadable transcript)?
- Are the FUNCTIONS-ROLLBACK.md §7 words accurate?

Output: verdict first ("ready", "ready after fixes", "not ready"), then blocking / should-fix / nit with file:line and a concrete failure scenario. Short.

codex
I’ll inspect the prior review, the fix commit, and the current guard/test/docs paths in read-only mode. I’ll limit execution to source inspection and `bash -n` as requested.
exec
/bin/zsh -lc "pwd && git status --short --branch && git show --stat --oneline --decorate --no-renames c562f69 && git show --no-ext-diff --unified=80 --no-renames c562f69 -- scripts/deploy-functions.sh scripts/deploy-functions.test.sh FUNCTIONS-ROLLBACK.md && sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/firebase-functions-deploy-guard-d2-5-followups-codex.md" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
/Users/christiehubley/my-clay-hub
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-W6OzFngi' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-5OtlyV3h' (errno=Operation not permitted)
## d2-attest-followups
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-7arYlRBi' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-04rcludw' (errno=Operation not permitted)
c562f69 (HEAD -> d2-attest-followups) D2-5 follow-up: Codex review fixes (Codex: "not ready"; 3 blocking, 1 should-fix)
 FUNCTIONS-ROLLBACK.md            | 15 +++++++-------
 scripts/deploy-functions.sh      | 45 +++++++++++++++++++++++++++-------------
 scripts/deploy-functions.test.sh | 31 +++++++++++++++++++++++++--
 3 files changed, 68 insertions(+), 23 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-EpdOA2q0' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-jwYPuTv4' (errno=Operation not permitted)
commit c562f695c2631ec6b5d8a63ab34737086f6998c6
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Thu Oct 1 08:50:02 2026 -0600

    D2-5 follow-up: Codex review fixes (Codex: "not ready"; 3 blocking, 1 should-fix)
    
    - the "Enabling now" check fails closed: grep 0 = found, 1 = absent, else needed
    - a reading that came back no (a known mismatch) stays owed, even for an
      attempt that didn't need one
    - --reconcile and --clear-inflight decide and record attest_needed too, and
      print the guidance (clear-inflight has no worktree: the shape comes from
      the tip's iam-expectations.json)
    - --status shows attest_needed and why
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/FUNCTIONS-ROLLBACK.md b/FUNCTIONS-ROLLBACK.md
index 4c69cdd..796296b 100644
--- a/FUNCTIONS-ROLLBACK.md
+++ b/FUNCTIONS-ROLLBACK.md
@@ -33,122 +33,123 @@ rollback is a **new commit** that restores the old code:
 1. Find the last good attempt: `git tag -l 'deployed/my-clay-hub/functions-core/*'` and `--status`.
 2. `git switch -c rollback-functions main`, then restore the codebase folder from that attempt's commit:
    `git checkout <tag>^{commit} -- functions/core` (the `functions/core` folder only — never `firebase.json`,
    `functions/declarations.json` or `scripts/`; if the old version needs different declarations, change them by hand
    and say so in the commit).
 3. Commit, push, open a PR, merge to `main`. `npm test` with `TINKER_FUNCTIONS_TESTS=required` must pass.
 4. `--status`, paste `--diff` verbatim, and deploy only after Christie's phrase for the new commit.
 
 A function that exists in production but is missing from the new commit makes the guard **refuse before uploading**
 (F6: it never deletes). Deleting a function has no guarded path yet — stop and ask Christie.
 
 ## 2. A deploy was interrupted (Ctrl-C, crash, laptop asleep)
 
 The guard writes `.git/tinker-deploy-inflight-functions` before it calls the CLI and removes it after the record is
 written. If it's still there, the next `--approved` refuses. Don't delete it.
 
 - **The operation finished** (Cloud Build → History → that build finished; Cloud Run → the service → latest revision
   ready): Christie reads, and Claude writes into a file, exactly this shape (one entry per function of the attempt):
 
   ```json
   {"confirmation": "<Christie's words, verbatim>",
    "functions": {"canary": {"buildId": "<Cloud Build id, a UUID>", "buildStatus": "SUCCESS",
                             "latestReadyRevision": "canary-00001-abc"}}}
   ```
 
   `buildStatus` must be a finished one (`SUCCESS`, `FAILURE`, `INTERNAL_ERROR`, `TIMEOUT`, `CANCELLED`, `EXPIRED`).
   Then `scripts/deploy-functions.sh --reconcile --codebase core --evidence <file>`. It rebuilds the expected state from
   the attempt's commit (worktree, Node 22, `npm ci`, discovery) and refuses unless the manifest, tree and expected hash
   match what the in-flight file recorded; it refuses while any function is still `DEPLOYING`; then it re-reads
   production, probes, and writes the attempt's tag with the **original** stamp. If the CLI had returned before the crash,
   the in-flight file holds its exit code and the attempt can verify; otherwise it records `cli_exit=unknown`
   (not verified). The CLI's transcript is kept in `.git/tinker-deploy-transcripts/`.
 - **The operation never settles:** `--clear-inflight <attempt> --codebase core --evidence <file>`, only with
   Christie's approval, naming the in-flight attempt exactly. The same shape, but any build status, and
   `latestReadyRevision` may be `null`. It writes the attempt's tag with `deploy_match=unknown`, `deploy_verified=no`,
   again with the original stamp.
 - A **truncated or edited** in-flight file is refused by both (fail-closed). Show it to Christie; don't delete it
   without her OK.
 
 ## 3. The first build failed (permissions)
 
 Google, not the CLI, chooses the build account (K12). Both candidates were stripped of broad roles in D2-1, and only
 the Compute account (`760301318440-compute@developer.gserviceaccount.com`) holds the three build roles. If the first
 build fails for permissions:
 
 1. Cloud Build → History → the failed build: note its **service account** and the **exact denied permission**.
 2. If the other candidate (`760301318440@cloudbuild.gserviceaccount.com`) built it: give that account the same three
    roles (Logs Writer; Storage Object Viewer with the "function source buckets only" condition; Artifact Registry
    Writer on `gcf-artifacts`), and remove them from the Compute account.
 3. Any other permission is a **widening**: Christie decides, and it's logged in the plan.
 4. Re-run the **same sha** under the same approval. The failed attempt stays in the record as unverified.
    The guard makes a **fresh worktree for every run**, retries included: a successful backstop leaves the sealed
    `functions/core/functions.yaml` in place for the CLI, and the backstop refuses to seal over an existing one. Never
    re-run the CLI by hand in an old worktree.
 
 ## 4. A stray future-stamped tag
 
 A tag under `deployed/my-clay-hub/functions-core/` stamped in the future (a machine with a fast clock, or a hand-made
 tag) would sort as "newest". Unlike the rules guard, the functions guard **refuses** to deploy when it can't stamp a
 newer attempt, so a stray tag blocks it rather than silently misordering the record. To clear it:
 
 1. Identify it: `git for-each-ref --format='%(refname:lstrip=2) %(creatordate:iso-strict) %(taggername)' 'refs/tags/deployed/my-clay-hub/functions-core/*'`.
    A stamp later than the tag's own creation date is fabricated.
 2. Show Christie the tag and its message. **Only with her approval**: `git tag -d <tag>` and
    `git push origin :refs/tags/<tag>`.
 3. `--status` again.
 
 ## 5. The deploy lock
 
 Both guards share `.git/tinker-deploy.lock`. A functions deploy holds it for minutes (install, tests, discovery,
 build). Before removing a lock: read `.git/tinker-deploy.lock/owner`, check that pid isn't running (`ps -p <pid>`),
 and that no functions deploy is in progress. Never remove it while a deploy runs.
 
 ## 6. The canary
 
 `core/canary` is permanent: it proves the deploy path end to end and does nothing. Its runtime account `canary@` holds
 no roles and must keep none (`functions/iam-expectations.json`). Don't delete it or grant it anything.
 
 ## 7. After a deploy: --attest, --reverify, and a changed guard
 
-- **When a reading is needed** (Christie, Oct 1 2026 — replaces "every deploy"): after each deploy the guard records
-  `attest_needed=yes|no` and says why. A reading is **needed** when the deploy isn't verified; when no attempt of the
-  codebase has `iam_attested=yes` yet; when the function set, `functions/declarations.json`,
-  `functions/iam-expectations.json`, `firebase.json` or `.firebaserc` changed since the newest attested attempt; when
-  the CLI turned on a Google API during the deploy (Google can add role grants then — D2-5's Editor grant came that
-  way); or when an unattested attempt since the last attested one owed a reading (one from before this rule counts as
-  owing). Otherwise the guard says "IAM reading not needed" and names the attested attempt it relies on. The automatic
+- **When a reading is needed** (Christie, Oct 1 2026 — replaces "every deploy"): every attempt record (`--approved`,
+  `--reconcile`, `--clear-inflight`) carries `attest_needed=yes|no` and why, and `--status` shows it. A reading is
+  **needed** when the deploy isn't verified; when no attempt of the codebase has `iam_attested=yes` yet; when the
+  function set, `functions/declarations.json`, `functions/iam-expectations.json`, `firebase.json` or `.firebaserc`
+  changed since the newest attested attempt; when the CLI turned on a Google API during the deploy (Google can add role
+  grants then — D2-5's Editor grant came that way), or the transcript can't be read to tell; or when an attempt since
+  the last attested one still owes a reading — it needed one and never got a yes, or its reading came back `no` (one
+  from before this rule counts as owing). Anything unreadable counts as needed. Otherwise the guard says "IAM reading not needed" and names the attested attempt it relies on. The automatic
   checks (hash, settings, the unauthenticated probe) run on every deploy either way. **Not seen:** a role someone
   changes by hand in the Console — after one, take a reading anyway.
 - **--attest** (when needed, M3 and F7): Christie reads each function's Security tab ("Require authentication") and
   Permissions (the full `run.invoker` list); IAM "View by roles" — the holders of every role in
   `functions/iam-expectations.json` (`run.invoker`, `cloudfunctions.invoker`, `owner`, `editor`,
   `cloudbuild.builds.builder`) and each runtime account's roles; every **binding row** of the build roles
   `logging.logWriter` and `storage.objectViewer` (member and condition — one row each, to the build account; a second,
   unconditional row would override the conditioned one); the holders of `artifactregistry.writer` at **project** level
   (expected none) and directly on Artifact Registry → `gcf-artifacts` → Permissions (the build account only); and
   Cloud Build → History (the build id, status and service account). The
   deploy prints the JSON shape, generated from `iam-expectations.json`; then
   `--attest <attempt> --codebase core --evidence <file>`. The script compares it with `functions/declarations.json` and
   `functions/iam-expectations.json` and records `iam_attested=yes` or `no` (with every difference). Only the newest
   attempt can be attested. **Not attested** (the record says so): folder- and organization-level grants, which
   Christie can't read, and grants on individual Cloud Storage buckets or managed folders, which don't appear on the
   IAM project page (Christie, Sep 30: a known limit, not read).
 - **--reverify <attempt>**: re-reads production and re-probes the **newest** attempt only (production can only speak
   for the attempt that put it there). It carries the attempt's `cli_exit`, backstop and skip-line results forward, so it
   can upgrade only the read-back and the probe. Its record goes under `…/functions-<cb>-verify/`.
 - **A changed guard.** Every tag-writing mode refuses unless the guard running is `origin/main`'s (not dirty, not
   unpushed). If the guard's machinery changed between the attempt and now, `--reconcile`, `--reverify`,
   `--clear-inflight` and `--attest` refuse until Christie OKs it; then re-run with `--acknowledge-verifier-change`, and
   the record says `verifier_changed=yes`. The verdicts are always the tip's code; rebuilding an attempt's expected
   state uses that attempt's own backstop, discovery and hash module (they made what it recorded), and the record names
   that commit as `rebuild_helpers_from`.
 
 ## 8. The pinned FIREBASE_CONFIG
 
 `functions/firebase-config.json` is the body the CLI puts in `FIREBASE_CONFIG` (Firebase's admin-SDK config: project
 id, bucket, location — not a secret). It's pinned rather than fetched, so no script uses the Firebase login (Christie,
 Sep 30), and the expected hash covers it, key order included. The first deploy (D2-5) showed that the live value has
 **no** `locationId` (the guessed `"nam5"` was wrong), so the pin is just `projectId` and `storageBucket`. With it, the
 expected hash equals the live canary's (`5dc5ef93…`).
 If a run reports `FIREBASE_CONFIG differs`, the guard prints the live value: commit it (same key order) in that file,
 get it reviewed, and run the guard again under a new approval.
diff --git a/scripts/deploy-functions.sh b/scripts/deploy-functions.sh
index d39b844..13cf548 100755
--- a/scripts/deploy-functions.sh
+++ b/scripts/deploy-functions.sh
@@ -585,461 +585,478 @@ read_back() {   # <msg file>
     reasons="$("$JQ" -r --argjson m "$("$JQ" -c .manifest "$DISC")" \
        --argjson dc "$("$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries' "${TMP}/functions/declarations.json")" \
        --argjson exp "$exp" --arg cfg "$cfg" --arg cb "$CB" --arg project "$PROJECT" --arg region "$REGION" \
        --argjson envkeys "$ENV_KEYS" "$JQ_F8" "$after" 2>&1)" || reasons="could not evaluate the read-back: ${reasons}"
     if [ -z "$reasons" ]; then DEPLOY_MATCH=yes; else DEPLOY_MATCH=no; fi
   else
     AFTER_DIGEST=unknown; DEPLOY_MATCH=unknown
     reasons="functions:list failed or returned malformed JSON: $(list_why "$after")"
   fi
   if [ "$BEFORE_DIGEST" = unknown ] || [ "$AFTER_DIGEST" = unknown ]; then FUNCTIONS_UNCHANGED=unknown
   elif [ "$BEFORE_DIGEST" = "$AFTER_DIGEST" ]; then FUNCTIONS_UNCHANGED=yes; else FUNCTIONS_UNCHANGED=no; fi
   {
     printf 'after_digest=%s\nfunctions_unchanged=%s\ndeploy_match=%s\n' "$AFTER_DIGEST" "$FUNCTIONS_UNCHANGED" "$DEPLOY_MATCH"
     if [ -n "$reasons" ]; then printf 'mismatch=%s\n' "$(printf '%s' "$reasons" | tr '\n' '|' )"; fi
   } >> "$msg"
   say "─── read-back ───"
   say "deploy_match: ${DEPLOY_MATCH}"
   [ -z "$reasons" ] || printf '%s\n' "$reasons" | sed 's/^/  - /'
   if [ "$AFTER_OK" = 1 ] && printf '%s' "$reasons" | grep -q 'FIREBASE_CONFIG differs'; then
     # The admin-SDK config (project id, bucket, location): public, and the same content as the pinned file, so shown.
     say "  live FIREBASE_CONFIG: $("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb)][0].environmentVariables.FIREBASE_CONFIG // "absent"' "$after")"
     say "  pinned (functions/firebase-config.json): ${cfg}"
   fi
   for id in $(printf '%s' "$IDS" | tr ',' ' '); do
     printf 'live_hash.%s=%s\n' "$id" "$( [ "$AFTER_OK" = 1 ] && "$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "absent"' "$after" || echo unknown)" >> "$msg"
   done
   say "─── unauthenticated probe (no credentials) ───"
   for id in $(printf '%s' "$IDS" | tr ',' ' '); do
     n=$((n + 1))
     uri=""
     [ "$AFTER_OK" = 1 ] && uri="$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].uri // ""' "$after")"
     if [ -z "$uri" ]; then res="inconclusive no-uri -"; else res="$(probe_one "$uri")"; fi
     cls="${res%% *}"
     case "$cls" in refused) n_ref=$((n_ref + 1)) ;; answered) n_ans=$((n_ans + 1)) ;; esac
     printf 'access.%s=%s\nprobe.%s=%s\n' "$id" "$cls" "$id" "${res#* }" >> "$msg"
     say "  ${id}: ${res}"
   done
   if [ "$n_ans" -gt 0 ]; then ACCESS=answered; elif [ "$n" -gt 0 ] && [ "$n_ref" = "$n" ]; then ACCESS=refused; else ACCESS=inconclusive; fi
   if [ "$CLI_EXIT" = 0 ] && [ "$BACKSTOP_SEEN" = yes ] && [ "$SKIP_SEEN" = no ] && [ "$DEPLOY_MATCH" = yes ] && [ "$ACCESS" = refused ]; then
     DEPLOY_VERIFIED=yes
   else
     DEPLOY_VERIFIED=no
   fi
   {
     printf 'access=%s\n' "$ACCESS"
     printf 'not_proven=refused does not prove the absence of grants to all Google accounts, to named principals, or at project, folder or organization level (--attest records those)\n'
     printf 'deploy_verified=%s\n' "$DEPLOY_VERIFIED"
   } >> "$msg"
   say "access: ${ACCESS}   deploy_verified: ${DEPLOY_VERIFIED}"
 }
 transcript_flags() {   # <transcript> <sha> — sets BACKSTOP_SEEN and SKIP_SEEN ("unknown" when there is no transcript)
   local line="predeploy-check: functions codebase ${CB} for ${PROJECT} matches commit ${2:0:12} (tree ${TREE}); sealed manifest ${MSHA} in place"
   if [ ! -f "$1" ]; then BACKSTOP_SEEN=unknown; SKIP_SEEN=unknown; return 0; fi
   if grep -qF -- "$line" "$1"; then BACKSTOP_SEEN=yes; else BACKSTOP_SEEN=no; fi
   if grep -qF -- "$SKIP_LINE" "$1"; then SKIP_SEEN=yes; else SKIP_SEEN=no; fi
 }
 verifier_fields() {   # <attempt commit> <msg> — F9: record the verifier and whether the guard's code changed since
   # The checks and verdicts (F8, the probe, the evidence) are this script's — the tip's, proven byte-equal above.
   # Rebuilding an attempt's expected state (--reconcile, --reverify) deliberately uses the ATTEMPT's own backstop,
   # discovery and hash module, because they are what produced the manifest and hash it recorded; their output must then
   # equal those recorded values. The record names both commits, so the provenance is never mixed silently.
   printf 'rebuild_helpers_from=%s\n' "$1" >> "$2"
   local changed
   changed="$(control_file_diff "$1" "$MAIN_SHA")"
   if [ -n "$changed" ]; then
     [ "$ACK" = 1 ] || die $EX_VERIFIER "the guard's machinery changed between the attempt (${1:0:12}) and ${REMOTE}/${BRANCH} (${MAIN_SHA:0:12}), first at ${changed}. The record would be judged by the tip's checks while the expected state is rebuilt with the attempt's own helpers. Once Christie has OK'd that, run again with --acknowledge-verifier-change."
     printf 'verifier=%s\nverifier_changed=yes (%s)\nverifier_change_acknowledged=yes\n' "$MAIN_SHA" "$changed" >> "$2"
   else
     printf 'verifier=%s\nverifier_changed=no\n' "$MAIN_SHA" >> "$2"
   fi
 }
 # Whether this deploy needs Christie's IAM reading (Christie, Oct 1 2026: re-read IAM only when something that shapes
 # it changed). FAIL-CLOSED: anything unreadable means "needed". Needed when the deploy isn't verified; when no attempt of
 # this codebase has iam_attested=yes yet; when the function set or a file that decides who may do what (ATTEST_FILES)
 # changed since the newest attested attempt; or when the CLI turned on a Google API during this deploy — Google can add
 # role grants when an API is enabled (D2-5: enabling Firebase Extensions gave the Google APIs Service Agent Editor).
 # Not seen either way: a role someone changes by hand in the Console. Sets ATTEST_NEEDED, ATTEST_WHY; appends to <msg>.
 ATTEST_FILES="functions/declarations.json functions/iam-expectations.json firebase.json .firebaserc"
 API_ENABLED_LINE="Enabling now"
 attest_need() {   # <msg>
-  local why="" rows r a last="" changed owed="" n
-  [ "$DEPLOY_VERIFIED" = yes ] || why="${why}the deploy is not verified; "
-  if [ ! -f "$TRANSCRIPT" ]; then why="${why}no transcript to check for a newly enabled Google API; "
-  elif grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT"; then why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); "
+  local why="" rows r a last="" changed owed="" n g=0
+  [ "${DEPLOY_VERIFIED:-no}" = yes ] || why="${why}the deploy is not verified; "
+  if [ ! -f "${TRANSCRIPT:-}" ]; then why="${why}no transcript to check for a newly enabled Google API; "
+  else
+    grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT" || g=$?
+    case "$g" in
+      0) why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); " ;;
+      1) ;;
+      *) why="${why}could not read the transcript to check for a newly enabled Google API; " ;;
+    esac
   fi
   if ! rows="$(receipt_rows "$ATTEMPT_PREFIX")"; then why="${why}could not read the record of earlier attempts; "
   else
     while read -r _ _ r; do
       [ -n "$r" ] || continue
       if ! a="$(iam_attested_of "$r" "$ATTEST_PREFIX")"; then why="${why}could not read whether ${r} was attested; "; last=""; break; fi
       [ "$a" = yes ] && { last="$r"; break; }
-      # A reading owed by a later, unattested attempt stays owed (one with no attest_needed predates this rule).
+      # Owed by a later attempt: a reading that came back no (a known mismatch), or one it needed and never got (an
+      # attempt with no attest_needed predates this rule and counts as needing one).
       n="$(record_field "$r" attest_needed 2>/dev/null || echo unknown)"
-      [ "$n" = no ] || owed="${owed:-$r}"
+      if [ "$a" != none ] || [ "$n" != no ]; then owed="${owed:-$r}"; fi
     done <<< "$rows"
-    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading that was never attested yes; "
+    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading, or its reading came back no, and nothing since was attested yes; "
     if [ -z "$last" ]; then
       case "$why" in *"could not read whether"*) ;; *) why="${why}no attempt of ${CB} has iam_attested=yes yet; " ;; esac
     else
       # shellcheck disable=SC2086 # ATTEST_FILES is a fixed word list
       if ! changed="$(git diff --name-only "$(commit_of "$last")" "$SHA" -- $ATTEST_FILES | tr '\n' ' ')"; then
         why="${why}could not compare with ${last}; "
       elif [ -n "$changed" ]; then why="${why}changed since ${last}: ${changed% }; "
       fi
       [ "$(record_field "$last" functions 2>/dev/null)" = "$IDS" ] || why="${why}the functions differ from ${last}'s; "
     fi
   fi
   if [ -n "$why" ]; then ATTEST_NEEDED=yes; ATTEST_WHY="${why%; }"
   else ATTEST_NEEDED=no; ATTEST_WHY="last attested ${last}; since then the same functions, no change to ${ATTEST_FILES// /, }, and the CLI enabled no Google API"
   fi
   printf 'attest_needed=%s\nattest_needed_why=%s\n' "$ATTEST_NEEDED" "$ATTEST_WHY" >> "$1"
 }
+attest_report() {   # after a record is written: say whether Christie's IAM reading is needed, and why
+  if [ "$ATTEST_NEEDED" = yes ]; then
+    say "─── IAM reading NEEDED: ${ATTEST_WHY} ───"
+    attest_help
+  else
+    say "─── IAM reading not needed: ${ATTEST_WHY}. (Christie can still --attest any time, and should after any role change made by hand.) ───"
+  fi
+}
 attest_help() {   # printed after a deploy: what --attest needs, generated from the IAM expectations it is checked against
   say "─── next: Christie's IAM reading, then --attest (F9, M3) ───"
   say "Christie reads, in the Console, and Claude writes into a JSON file exactly this shape (every holder as"
   say "\"user:…\" or \"serviceAccount:…\"; each list complete, as read):"
   "$JQ" --arg ids "$IDS" '{
       functions: ($ids | split(",") | map({key: ., value: {buildId: "<Cloud Build → History → the build id>", buildStatus: "<its status>",
         latestReadyRevision: "<Cloud Run → the service → latest ready revision>", requireAuthentication: "<true|false, Security tab>",
         runInvokerMembers: ["<every run.invoker member, Permissions tab>"]}}) | from_entries),
       projectRoles: (.projectRoles | map_values(["<every holder, IAM → View by roles>"])),
       buildRoleBindings: (.buildRoleBindings | map_values([{member: "<one entry per binding row, IAM → View by roles>",
         condition: "<its condition expression as the Console shows it, or null when the row has none>"}])),
       artifactRegistryWriters: {repository: ["<direct Artifact Registry Writer holders on \(.artifactRegistryWriterOn)>"],
         project: ["<project-level holders of roles/artifactregistry.writer, IAM → View by roles>"]},
       runtimeAccounts: (.runtimeAccounts | map_values(["<its project roles>"])),
-      buildAccount: "<Cloud Build → History → the build service account, the email only>" }' "${TMP}/functions/iam-expectations.json"
+      buildAccount: "<Cloud Build → History → the build service account, the email only>" }' \
+    <(if [ -n "${TMP:-}" ] && [ -f "${TMP}/functions/iam-expectations.json" ]; then cat "${TMP}/functions/iam-expectations.json"
+      else git show "${MAIN_SHA}:functions/iam-expectations.json"; fi)   # --clear-inflight has no worktree: the tip's file
   say "(Not read, and so not attested: folder- and organization-level grants, and grants on individual Cloud Storage buckets or managed folders.)"
   say "then:  $0 --attest ${TAG:-<attempt>} --codebase ${CB} --evidence <file>"
 }
 
 # ─── --status / --diff ─────────────────────────────────────────────────────────────────────────────────
 # Read-only. The newest attempt (by stamp, attempt tags only), and the newest attempt whose deploy_verified is yes.
 record_state() {   # sets NEWEST, NEWEST_VERIFIED, NEWEST_ATTESTED, LAST_VERIFIED
   local rows r v
   rows="$(receipt_rows "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB} — refusing to guess what shipped."
   NEWEST="$(printf '%s\n' "$rows" | awk 'NR==1{printf "%s", $3}')"
   NEWEST_VERIFIED=""; NEWEST_ATTESTED=""; LAST_VERIFIED=""
   [ -n "$NEWEST" ] || return 0
   NEWEST_VERIFIED="$(deploy_verified_of "$NEWEST" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${NEWEST} — refusing to guess."
   NEWEST_ATTESTED="$(iam_attested_of "$NEWEST" "$ATTEST_PREFIX")" || die $EX_RECORD "could not read iam_attested for ${NEWEST} — refusing to guess."
   while read -r _ _ r; do
     v="$(deploy_verified_of "$r" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${r} — refusing to guess."
     if [ "$v" = yes ]; then LAST_VERIFIED="$r"; break; fi
   done <<< "$rows"
 }
 commit_of() { local c; c="$(receipt_commit "$1")" || die $EX_RECORD "the record ${1} is in the record but its commit could not be resolved."; printf '%s' "$c"; }
 
 if [ "$MODE" = "status" ] || [ "$MODE" = "diff" ]; then
   if ! fetch_state >/dev/null; then warn "could not fetch ${REMOTE}/${BRANCH} and the records; showing the last-known state"; fi
   MAIN_SHA="$(git rev-parse --quiet --verify "${REMOTE}/${BRANCH}^{commit}" 2>/dev/null || true)"
   [ -n "$MAIN_SHA" ] || die $EX_FETCH "${REMOTE}/${BRANCH} has never been fetched here and ${REMOTE} is unreachable."
   codebase_on_tip
   record_state
   if [ "$MODE" = "diff" ]; then
     if [ -n "$NEWEST" ] && [ "$NEWEST" != "$LAST_VERIFIED" ]; then
       say "════ NOTE: the newest attempt ${NEWEST} is NOT verified — production may differ from both sides of this diff ════"
     fi
     if [ -z "$LAST_VERIFIED" ]; then
       say "(no verified attempt yet for ${CB} — showing everything that would ship, at ${REMOTE}/${BRANCH} ${MAIN_SHA:0:12})"
       BASE="$EMPTY_TREE"
     else
       BASE="$(commit_of "$LAST_VERIFIED")"
       say "(diff from the last verified attempt ${LAST_VERIFIED} (${BASE:0:12}) to ${REMOTE}/${BRANCH} ${MAIN_SHA:0:12})"
     fi
     say "─── firebase.json entry for ${CB} at ${MAIN_SHA:0:12} ───"
     git show "${MAIN_SHA}:firebase.json" | "$JQ" --arg cb "$CB" '.functions[] | select(.codebase == $cb)'
     show_machinery "$BASE" "$MAIN_SHA"
     # shellcheck disable=SC2086
     if git diff --quiet "$BASE" "$MAIN_SHA" -- $SHOWN_PATHS; then say "(no change to ${SHOWN_PATHS} since ${LAST_VERIFIED})"; exit 0; fi
     # shellcheck disable=SC2086
     git --no-pager diff "$BASE" "$MAIN_SHA" -- $SHOWN_PATHS
     exit 0
   fi
   say "project:         ${PROJECT}"
   say "codebase:        ${CB}  (${SRC})"
   if [ -f "$INFLIGHT" ]; then
     if inflight_valid; then
       say "IN FLIGHT:       $(inflight_get attempt) (commit $(inflight_get commit | cut -c1-12)) — a deploy was interrupted, or is running. The next --approved refuses; see FUNCTIONS-ROLLBACK.md §2."
     else
       say "IN FLIGHT:       ${INFLIGHT} exists but is MALFORMED — the next --approved refuses; see FUNCTIONS-ROLLBACK.md §2."
     fi
   fi
   [ -f "$PENDING" ] && say "pending record:  $(cut -d' ' -f1 "$PENDING") was not pushed — the next run publishes it first."
   if [ -z "$NEWEST" ]; then
     say "newest attempt:  none — no guarded deploy of ${CB} yet"
   else
     NC="$(commit_of "$NEWEST")"
     say "newest attempt:  ${NEWEST}$(receipt_note "$NEWEST")"
     say "  commit:        ${NC}  $(git log -1 --format='%s' "$NC")"
     say "  deploy_verified=${NEWEST_VERIFIED}  iam_attested=${NEWEST_ATTESTED}"
+    say "  attest_needed=$(record_word "$NEWEST" attest_needed "yes no" 2>/dev/null || echo "unknown (recorded before Oct 1 2026, so treated as needed)")$(w="$(record_field "$NEWEST" attest_needed_why 2>/dev/null)" && [ -n "$w" ] && printf ' — %s' "$w")"
     if [ "$NEWEST_VERIFIED" = yes ]; then
       say "state:           verified at ${NEWEST}"
     elif [ "$(record_word "$NEWEST" functions_unchanged "yes no unknown" 2>/dev/null || echo unknown)" = yes ]; then
       say "state:           functions unchanged by ${NEWEST} — production is still what $( [ -n "$LAST_VERIFIED" ] && echo "${LAST_VERIFIED} verified" || echo "was there before (no verified attempt yet)")"
     else
       say "state:           production may be mixed: last verified ${LAST_VERIFIED:-(none yet)}; unverified attempt ${NEWEST}"
     fi
   fi
   say "${REMOTE}/${BRANCH}:     ${MAIN_SHA}  $(git log -1 --format='%s' "$MAIN_SHA")"
   D="$(dirty_files)"; [ -n "$D" ] && warn "the shared tree has uncommitted changes (not what ships): $(echo "$D" | tr '\n' ' ')"
   say ""
   say "To deploy ${REMOTE}/${BRANCH}, run --diff and paste it; then Christie says exactly:"
   say "    approved to change firebase ${MAIN_SHA}"
   say "then run:  $0 --approved ${MAIN_SHA} --codebase ${CB}"
   exit 0
 fi
 
 # ─── Every tag-writing mode: preflight, lock, fetch, the pending record, the verifier ──────────────────
 preflight
 take_lock
 trap cleanup EXIT
 WORK="$(mktemp -d "${TMPDIR:-/tmp}/tinker-functions.XXXXXX")"   # private to this run; removed on exit
 chmod 700 "$WORK"
 fetch_or_die
 publish_pending
 verifier_is_tip
 codebase_on_tip
 mkdir -p "$TRANSCRIPTS"
 
 # ─── --approved ────────────────────────────────────────────────────────────────────────────────────────
 if [ "$MODE" = "approved" ]; then
   [ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an earlier deploy was interrupted (or is running). Nothing was deployed. Reconcile it first (FUNCTIONS-ROLLBACK.md §2)."
   SHA="$(printf '%s' "$SHA_ARG" | tr 'A-F' 'a-f')"
   [[ "$SHA" =~ ^[0-9a-f]{40}$ ]] || die $EX_USAGE "--approved needs the FULL 40-character sha Christie named (run --status to see it). Got '${SHA_ARG}'."
   [ "$(git rev-parse --verify --quiet "${SHA}^{commit}" 2>/dev/null || true)" = "$SHA" ] || die $EX_USAGE "${SHA} is not a commit in this repository."
   git merge-base --is-ancestor "$SHA" "$MAIN_SHA" || die $EX_NOT_ON_MAIN "${SHA:0:12} is not on ${REMOTE}/${BRANCH}. Land it on ${BRANCH} and push first."
   CF="$(control_file_diff "$SHA" "$MAIN_SHA")"
   [ -z "$CF" ] || die $EX_NOT_ON_MAIN "${SHA:0:12} carries a different ${CF} than ${REMOTE}/${BRANCH} — the deploy machinery must be the tip's. To roll back, restore ${SRC} onto a NEW commit on ${BRANCH} (FUNCTIONS-ROLLBACK.md §1)."
   D="$(dirty_files)"; [ -n "$D" ] && warn "the shared tree has uncommitted changes — they are NOT being deployed: $(echo "$D" | tr '\n' ' ')"
 
   say "═══ guarded functions deploy ═══"
   say "project:   ${PROJECT}"
   say "codebase:  ${CB}  (${SRC})"
   say "commit:    ${SHA}  $(git log -1 --format='%s' "$SHA")"
   build_expected "$SHA"
   say "manifest:  ${MSHA}  (functions: ${IDS})"
 
   say "─── npm test (in ${TMP}; the functions suites required) ───"
   (cd "$TMP" && TINKER_FUNCTIONS_TESTS=required npm22 test) || die $EX_TESTS "tests failed on ${SHA:0:12}; nothing was deployed."
 
   reserve_stamp "$ATTEMPT_PREFIX" "${SHA:0:7}"
   record_state
   if [ -z "$LAST_VERIFIED" ]; then
     say "replaces:  (no verified attempt yet for ${CB} — everything below is new to the record)"; BASE="$EMPTY_TREE"
   else
     BASE="$(commit_of "$LAST_VERIFIED")"; say "replaces:  ${LAST_VERIFIED} (${BASE:0:12})$(receipt_note "$LAST_VERIFIED")"
   fi
   [ -n "$NEWEST" ] && [ "$NEWEST" != "$LAST_VERIFIED" ] && say "NOTE:      the newest attempt ${NEWEST} is not verified; production may be mixed."
   show_machinery "$BASE" "$SHA"
   say "─── diff ${BASE:0:12} → ${SHA:0:12} ───"
   # shellcheck disable=SC2086
   git --no-pager diff "$BASE" "$SHA" -- $SHOWN_PATHS || true
   say "─── end diff ───"
 
   # Production before: the snapshot, F6 and the drift check — all before the in-flight file and the CLI.
   BEFORE="${WORK}/before.json"
   list_live "$TMP" "$BEFORE" || die $EX_FETCH "could not read production (functions:list): $(list_why "$BEFORE") — nothing was deployed."
   BEFORE_DIGEST="$(digest_of "$BEFORE")"
   DRIFT="$("$JQ" -r --arg cb "$CB" --argjson envkeys "$ENV_KEYS" --argjson ids "$IDS_JSON" "$JQ_DRIFT" "$BEFORE" 2>&1)" \
     || die $EX_DRIFT "could not check production for drift: ${DRIFT}"
   [ -z "$DRIFT" ] || die $EX_DRIFT "production has something this deploy would carry over or can't handle — NOTHING WAS DEPLOYED:
 $(printf '%s\n' "$DRIFT" | sed 's/^/  - /')"
 
   # The in-flight file (F9): written atomically BEFORE the CLI, so a crash from here on leaves an honest trace.
   TRANSCRIPT="${TRANSCRIPTS}/functions-${CB}-${STAMP}-${SHA:0:7}.log"
   {
     printf 'format=tinker-functions-inflight-1\ncodebase=%s\nattempt=%s\nstamp=%s\ncommit=%s\ntree=%s\n' "$CB" "$TAG" "$STAMP" "$SHA" "$TREE"
     printf 'manifest_sha256=%s\nbefore_digest=%s\nfunctions=%s\ntranscript=%s\nverifier=%s\n' "$MSHA" "$BEFORE_DIGEST" "$IDS" "$TRANSCRIPT" "$MAIN_SHA"
     for id in $(printf '%s' "$IDS" | tr ',' ' '); do
       printf 'expected_hash.%s=%s\n' "$id" "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")"
       printf 'before_hash.%s=%s\n' "$id" "$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "none"' "$BEFORE")"
     done
   } | atomic_write "$INFLIGHT" || die $EX_INFLIGHT "could not write ${INFLIGHT} — nothing was deployed."
   inflight_valid || die $EX_INFLIGHT "${INFLIGHT} did not read back as written — nothing was deployed; remove it by hand."
 
   # The CLI. TINKER_DEPLOY_* are exported, never inline (K15). Never --force.
   say "─── firebase deploy --only functions:${CB} --project ${PROJECT} (in ${TMP}) ───"
   set +e
   (
     export TINKER_DEPLOY_SHA="$SHA" TINKER_DEPLOY_CODEBASE="$CB" TINKER_DEPLOY_MANIFEST_PATH="$MPATH" TINKER_DEPLOY_MANIFEST_SHA256="$MSHA"
     cli "$TMP" deploy --only "functions:${CB}" --project "$PROJECT" --non-interactive
   ) 2>&1 | tee "$TRANSCRIPT"
   CLI_EXIT="${PIPESTATUS[0]}"
   set -e
   { cat "$INFLIGHT"; printf 'cli_exit=%s\n' "$CLI_EXIT"; } | atomic_write "$INFLIGHT" || warn "could not add cli_exit to ${INFLIGHT} (a --reconcile will record cli_exit=unknown)"
   transcript_flags "$TRANSCRIPT" "$SHA"
   say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
 
   MSG="${WORK}/record"
   {
     printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$TREE"
     printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
     for id in $(printf '%s' "$IDS" | tr ',' ' '); do
       printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
     done
     printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   } > "$MSG"
   read_back "$MSG"
   verifier_fields "$SHA" "$MSG"
   attest_need "$MSG"
   printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   rm -f "$INFLIGHT"
   [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
-  if [ "$ATTEST_NEEDED" = yes ]; then
-    say "─── IAM reading NEEDED: ${ATTEST_WHY} ───"
-    attest_help
-  else
-    say "─── IAM reading not needed: ${ATTEST_WHY}. (Christie can still --attest any time, and should after any role change made by hand.) ───"
-  fi
+  attest_report
   if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   exit $EX_UNVERIFIED
 fi
 
 # ─── --reconcile / --clear-inflight ────────────────────────────────────────────────────────────────────
 if [ "$MODE" = "reconcile" ] || [ "$MODE" = "clear-inflight" ]; then
   [ -f "$INFLIGHT" ] || die $EX_INFLIGHT "there is no in-flight file (${INFLIGHT}) — nothing to reconcile."
   inflight_valid || die $EX_INFLIGHT "${INFLIGHT} is malformed (truncated, or edited) — refusing to guess what it recorded. Show it to Christie; FUNCTIONS-ROLLBACK.md §2."
   [ "$(inflight_get codebase)" = "$CB" ] || die $EX_INFLIGHT "the in-flight attempt is for codebase $(inflight_get codebase), not ${CB}."
   TAG="$(inflight_get attempt)"; STAMP="$(inflight_get stamp)"; SHA="$(inflight_get commit)"; IDS="$(inflight_get functions)"
   if [ "$MODE" = "clear-inflight" ] && [ "$ATTEMPT_ARG" != "$TAG" ]; then
     die $EX_INFLIGHT "the in-flight attempt is ${TAG}, not ${ATTEMPT_ARG} — name it exactly."
   fi
   IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
   [ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
   "$JQ" -e --argjson ids "$IDS_JSON" --arg mode "$([ "$MODE" = reconcile ] && echo reconcile || echo clear)" "$JQ_EVIDENCE_OP" "$EVIDENCE" >/dev/null 2>&1 \
     || die $EX_EVIDENCE "the evidence is not in the fixed shape: {\"confirmation\": \"<Christie's words>\", \"functions\": {\"<id>\": {\"buildId\": \"<uuid>\", \"buildStatus\": \"<status>\", \"latestReadyRevision\": \"<id>-000NN-xxx\"$([ "$MODE" = clear-inflight ] && echo ' (or null)')}}} for exactly ${IDS}$([ "$MODE" = reconcile ] && echo ', with a finished build')."
   EVJSON="$("$JQ" -c . "$EVIDENCE")"
   if git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null 2>&1; then
     die $EX_INFLIGHT "the record ${TAG} already exists, so the attempt was recorded before the in-flight file could be removed. Check it (git show ${TAG}); if it names ${SHA:0:12}, remove ${INFLIGHT} by hand with Christie's OK."
   fi
   MSG="${WORK}/record"
   CLI_EXIT="$(inflight_get cli_exit 2>/dev/null || echo unknown)"
   {
     printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$(inflight_get tree)"
     printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$(inflight_get manifest_sha256)" "$IDS" "$(inflight_get before_digest)"
     for id in $(printf '%s' "$IDS" | tr ',' ' '); do
       printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
     done
   } > "$MSG"
 
   if [ "$MODE" = "clear-inflight" ]; then
     MSHA="$(inflight_get manifest_sha256)"; TREE="$(inflight_get tree)"
     transcript_flags "$(inflight_get transcript)" "$SHA"
     {
       printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
       printf 'after_digest=unknown\nfunctions_unchanged=unknown\ndeploy_match=unknown\naccess=not-probed\ndeploy_verified=no\n'
       printf 'evidence=%s\n' "$EVJSON"
     } >> "$MSG"
     verifier_fields "$SHA" "$MSG"
+    DEPLOY_VERIFIED=no; TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
     printf 'at=%s\nby=deploy-functions.sh --clear-inflight\n' "$STAMP" >> "$MSG"
     PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
     rm -f "$INFLIGHT"
     [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
+    attest_report
     say "✔ cleared: ${TAG} recorded with deploy_match=unknown (its original stamp). Production is NOT verified; the next --approved may run."
     exit 0
   fi
 
   # --reconcile: rebuild the expected state from the attempt's commit and prove it's the same manifest and hashes.
   verifier_fields "$SHA" "$MSG"   # refuses early (before the rebuild) if the machinery changed and Christie hasn't OK'd it
   build_expected "$SHA"
   [ "$MSHA" = "$(inflight_get manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the one the attempt sealed ($(inflight_get manifest_sha256)) — refusing to verify against a different manifest."
   [ "$TREE" = "$(inflight_get tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   [ "$IDS" = "$(inflight_get functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   for id in $(printf '%s' "$IDS" | tr ',' ' '); do
     [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(inflight_get "expected_hash.${id}")" ] \
       || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one recorded before the CLI call."
   done
   NOW="${WORK}/now.json"
   list_live "$TMP" "$NOW" || die $EX_FETCH "could not read production (functions:list): $(list_why "$NOW") — try again."
   DEPLOYING="$("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb and .state == "DEPLOYING") | .id] | join(",")' "$NOW")"
   [ -z "$DEPLOYING" ] || die $EX_INFLIGHT "${DEPLOYING} still DEPLOYING — the operation hasn't finished; wait, then reconcile."
   BEFORE_DIGEST="$(inflight_get before_digest)"
   transcript_flags "$(inflight_get transcript)" "$SHA"
   printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN" >> "$MSG"
   read_back "$MSG"
+  TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
   printf 'evidence=%s\nat=%s\nby=deploy-functions.sh --reconcile\n' "$EVJSON" "$STAMP" >> "$MSG"
   PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   rm -f "$INFLIGHT"
   [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
+  attest_report
   say "✔ reconciled: ${TAG} recorded with its original stamp; deploy_verified=${DEPLOY_VERIFIED}."
   [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   exit $EX_UNVERIFIED
 fi
 
 # ─── --reverify / --attest: only for the newest attempt ────────────────────────────────────────────────
 [ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an interrupted deploy comes first (FUNCTIONS-ROLLBACK.md §2)."
 NEWEST="$(latest_receipt "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB}."
 [ -n "$NEWEST" ] || die $EX_NOT_NEWEST "there is no attempt for ${CB} yet."
 [ "$ATTEMPT_ARG" = "$NEWEST" ] || die $EX_NOT_NEWEST "${ATTEMPT_ARG} is not the newest attempt (${NEWEST}). Today's production can only speak for the attempt that put it there."
 SHA="$(commit_of "$NEWEST")"
 for k in commit manifest_sha256 functions tree; do
   record_field "$NEWEST" "$k" >/dev/null || die $EX_RECORD "the attempt ${NEWEST} has no readable ${k} — refusing."
 done
 [ "$(record_field "$NEWEST" commit)" = "$SHA" ] || die $EX_RECORD "the attempt ${NEWEST} names a different commit than it points at."
 IDS="$(record_field "$NEWEST" functions)"
 IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
 MSG="${WORK}/record"
 
 if [ "$MODE" = "reverify" ]; then
   : > "$MSG"
   verifier_fields "$SHA" "$MSG"
   CLI_EXIT="$(record_field "$NEWEST" cli_exit)" || die $EX_RECORD "the attempt ${NEWEST} has no readable cli_exit."
   BACKSTOP_SEEN="$(record_word "$NEWEST" backstop_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable backstop_seen."
   SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
   BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
   build_expected "$SHA"
   [ "$MSHA" = "$(record_field "$NEWEST" manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the attempt's."
   [ "$TREE" = "$(record_field "$NEWEST" tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   [ "$IDS" = "$(record_field "$NEWEST" functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   for id in $(printf '%s' "$IDS" | tr ',' ' '); do
     [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
       || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
   done
   reserve_stamp "$VERIFY_PREFIX" "${SHA:0:7}"
   VMSG="${WORK}/verify"
   {
     printf 'format=tinker-functions-verify-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
     printf 'carried=cli_exit=%s backstop_seen=%s skip_line_seen=%s (from the attempt)\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   } > "$VMSG"
   read_back "$VMSG"
   cat "$MSG" >> "$VMSG"
   printf 'at=%s\nby=deploy-functions.sh --reverify\n' "$STAMP" >> "$VMSG"
   write_record "$TAG" "$SHA" "$VMSG" || exit $EX_RECEIPT
   say "✔ verify record ${TAG} for ${NEWEST}: deploy_verified=${DEPLOY_VERIFIED}."
   [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   exit $EX_UNVERIFIED
 fi
 
 # --attest
 [ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
 "$JQ" -e "$JQ_ATTEST_SHAPE" "$EVIDENCE" >/dev/null 2>&1 \
   || die $EX_EVIDENCE "the IAM reading is not in the fixed shape (see the --attest instructions a deploy prints, and FUNCTIONS-ROLLBACK.md)."
 : > "$MSG"
 verifier_fields "$SHA" "$MSG"
 DC="$(git show "${SHA}:functions/declarations.json" | "$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries')" \
   || die $EX_RECORD "could not read the attempt's declarations."
 IAM="$(git show "${SHA}:functions/iam-expectations.json" | "$JQ" -c .)" || die $EX_RECORD "could not read the attempt's functions/iam-expectations.json."
 [ "$(printf '%s' "$IAM" | "$JQ" -r .project)" = "$PROJECT" ] || die $EX_CONFIG "functions/iam-expectations.json is not for ${PROJECT}."
 REASONS="$("$JQ" -r --argjson ids "$IDS_JSON" --argjson dc "$DC" --argjson iam "$IAM" --arg pn "$PROJECT_NUMBER" "$JQ_ATTEST" "$EVIDENCE" 2>&1)" \
   || die $EX_EVIDENCE "could not compare the reading: ${REASONS}"
 if [ -z "$REASONS" ]; then IAM_ATTESTED=yes; else IAM_ATTESTED=no; fi
 reserve_stamp "$ATTEST_PREFIX" "${SHA:0:7}"
 AMSG="${WORK}/attest"
 {
   printf 'format=tinker-functions-attest-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
   printf 'iam_attested=%s\n' "$IAM_ATTESTED"
   if [ -n "$REASONS" ]; then printf 'mismatch=%s\n' "$(printf '%s' "$REASONS" | tr '\n' '|')"; fi
   printf 'evidence=%s\n' "$("$JQ" -c . "$EVIDENCE")"
   printf 'not_attested=folder- and organization-level grants (Christie cannot read them); grants on individual Cloud Storage buckets or managed folders (not on the IAM project page; outside what --attest reads, Christie Sep 30)\n'
 } > "$AMSG"
 cat "$MSG" >> "$AMSG"
 printf 'at=%s\nby=deploy-functions.sh --attest\n' "$STAMP" >> "$AMSG"
 say "─── IAM reading for ${NEWEST} ───"
 [ -z "$REASONS" ] || printf '%s\n' "$REASONS" | sed 's/^/  - /'
 write_record "$TAG" "$SHA" "$AMSG" || exit $EX_RECEIPT
 say "iam_attested=${IAM_ATTESTED} for ${NEWEST}."
 [ "$IAM_ATTESTED" = yes ] && exit 0
 exit $EX_UNVERIFIED
diff --git a/scripts/deploy-functions.test.sh b/scripts/deploy-functions.test.sh
index 03f7a36..798c65b 100644
--- a/scripts/deploy-functions.test.sh
+++ b/scripts/deploy-functions.test.sh
@@ -75,160 +75,167 @@ cat > "$T/fake-discover.sh" <<EOF
 #!/bin/bash
 SC="$SC"; . "$T/hash.sh"
 echo "discover HOME=\$HOME GAC=\${GOOGLE_APPLICATION_CREDENTIALS:-<unset>} \$*" >> "\$SC/log"
 while [ \$# -gt 0 ]; do case "\$1" in --source) S="\$2";; --out) O="\$2";; --firebase-config) F="\$2";; esac; shift 2; done
 [ -f "\$SC/discover_fail" ] && { echo "functions-discover: REFUSED — simulated" >&2; exit 2; }
 cp "\$SC/manifest.json" "\$O/functions.yaml"
 OUTREAL="\$(cd "\$O" && pwd -P)"
 cfg="\$(/usr/bin/jq -c . "\$F")"
 h="\$(fake_hash "\$S" "\$cfg")"
 /usr/bin/jq -c --arg path "\$OUTREAL/functions.yaml" --arg sha "\$(shasum -a 256 "\$O/functions.yaml" | cut -d' ' -f1)" \
    --arg cfg "\$cfg" --arg h "\$h" --arg rt "\$(cat "\$SC/runtime" 2>/dev/null || echo nodejs22)" \
    --argjson params "\$(cat "\$SC/params" 2>/dev/null || echo '[]')" '
   { firebaseFunctionsVersion: "7.4.0", manifestPath: \$path, manifestSha256: \$sha, manifest: .,
     build: { params: \$params, endpoints: (.endpoints | map_values({runtime: \$rt})) },
     firebaseConfigEnv: \$cfg, sourceHash: "x", expectedHashes: (.endpoints | map_values(\$h)) }' "\$SC/manifest.json"
 EOF
 cat > "$T/fake-cli.sh" <<EOF
 #!/bin/bash
 SC="$SC"; . "$T/hash.sh"
 echo "cli \$* cwd=\$PWD" >> "\$SC/log"
 case "\${1:-}" in
   --version) cat "\$SC/cli_version" 2>/dev/null || echo 15.22.3; exit 0 ;;
   functions:list)
     echo x >> "\$SC/list_calls"; n="\$(wc -l < "\$SC/list_calls" | tr -d ' ')"
     if [ -f "\$SC/list_block_\$n" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
     mode="\$(cat "\$SC/list_mode_\$n" 2>/dev/null || echo ok)"
     case "\$mode" in
       error) echo '{"status":"error","error":"simulated list failure"}'; exit 1 ;;
       malformed) printf '{"status":"success","result":'; exit 0 ;;
     esac
     /usr/bin/jq -c '{status: "success", result: .}' "\$SC/live.json"; exit 0 ;;
   deploy)
     echo "env GAC=\${GOOGLE_APPLICATION_CREDENTIALS:-<unset>} SHA=\${TINKER_DEPLOY_SHA:-} CB=\${TINKER_DEPLOY_CODEBASE:-} MSHA=\${TINKER_DEPLOY_MANIFEST_SHA256:-} QP=\${GOOGLE_CLOUD_QUOTA_PROJECT:-<unset>}" >> "\$SC/log"
     echo "workdir-mode=\$(stat -f %Lp "\$(dirname "\$PWD")")" >> "\$SC/log"
     only="\$(printf '%s\n' "\$@" | awk '/^--only\$/{getline; print}')"; cb="\${only#functions:}"
     hook="\$(/usr/bin/jq -r --arg cb "\$cb" '.functions[] | select(.codebase == \$cb) | .predeploy[0]' firebase.json)"
     # firebase-tools runs the hook with GCLOUD_PROJECT, PROJECT_DIR and RESOURCE_DIR (lib/deploy/lifecycleHooks.js).
     out="\$(GCLOUD_PROJECT=my-clay-hub PROJECT_DIR="\$PWD" RESOURCE_DIR="\$PWD/functions/\$cb" bash -c "\$hook" 2>&1)"; rc=\$?
     [ -f "\$SC/hide_backstop" ] || printf '%s\n' "\$out"
     if [ "\$rc" != 0 ]; then echo "predeploy=REFUSED" >> "\$SC/log"; echo "Error: predeploy error"; exit 2; fi
     [ -f "functions/\$cb/functions.yaml" ] && echo "seal=present" >> "\$SC/log"
     [ -f "\$SC/skip_line" ] && echo "i  functions: Skipping the deploy of unchanged functions."
     [ -f "\$SC/api_enabled" ] && echo "⚠  extensions: missing required API firebaseextensions.googleapis.com. Enabling now..."
     if [ ! -f "\$SC/deploy_noop" ]; then
       cfg="\$(/usr/bin/jq -c . functions/firebase-config.json)"; h="\$(fake_hash "\$PWD/functions/\$cb" "\$cfg")"
       /usr/bin/jq -c --arg cb "\$cb" --arg cfg "\$cfg" --arg h "\$h" --slurpfile man "functions/\$cb/functions.yaml" '
         (\$man[0].endpoints | to_entries | map(.key as \$id | .value as \$e | {
           platform: "gcfv2", id: \$id, project: "my-clay-hub", region: \$e.region[0], httpsTrigger: {}, entryPoint: \$e.entryPoint,
           runtime: "nodejs22", ingressSettings: \$e.ingressSettings,
           environmentVariables: { EVENTARC_CLOUD_EVENT_SOURCE: "projects/my-clay-hub/locations/\(\$e.region[0])/services/\(\$id)",
             FIREBASE_CONFIG: \$cfg, FUNCTION_TARGET: (\$e.entryPoint | gsub("-"; ".")), GCLOUD_PROJECT: "my-clay-hub", LOG_EXECUTION_ID: "true" },
           timeoutSeconds: \$e.timeoutSeconds, uri: "https://\(\$id)-fake-uc.a.run.app", serviceAccount: \$e.serviceAccountEmail,
           availableMemoryMb: \$e.availableMemoryMb, cpu: \$e.cpu, minInstances: (\$e.minInstances // 0), maxInstances: \$e.maxInstances,
           concurrency: \$e.concurrency, codebase: \$cb, hash: \$h, state: "ACTIVE",
           labels: {"deployment-tool": "cli-firebase", "firebase-functions-codebase": \$cb, "firebase-functions-hash": \$h} })) as \$new
         | map(select(.codebase != \$cb)) + \$new' "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"
     fi
     if [ -f "\$SC/after_filter" ]; then /usr/bin/jq -c "\$(cat "\$SC/after_filter")" "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"; fi
     if [ -f "\$SC/cli_block" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
     exit "\$(cat "\$SC/cli_exit" 2>/dev/null || echo 0)" ;;
 esac
 echo "fake cli: unexpected \$*" >&2; exit 99
 EOF
 cat > "$T/bin/curl" <<EOF
 #!/bin/bash
 SC="$SC"
 echo "curl \$*" >> "\$SC/log"; echo x >> "\$SC/curl_calls"
 while [ \$# -gt 0 ]; do case "\$1" in -D) D="\$2"; shift 2;; -o|-w|--max-time|--proto) shift 2;; *) U="\$1"; shift;; esac; done
 hdr() { printf 'HTTP/2 %s\r\n%s\r\n' "\$1" "\$2" > "\$D"; printf '%s' "\$1"; }
 case "\$(cat "\$SC/probe" 2>/dev/null || echo refused)" in
   refused)    hdr 403 'server: Google Frontend' ;;
   reached403) hdr 403 'x-tinker-reached: canary' ;;
   ok200)      hdr 200 'x-tinker-reached: canary' ;;
   plain200)   hdr 200 'server: Google Frontend' ;;
   timeout)    echo "curl: (28) Operation timed out" >&2; exit 28 ;;
   notfound)   hdr 404 'server: Google Frontend' ;;
   error500)   hdr 500 'server: Google Frontend' ;;
 esac
 exit 0
 EOF
+cat > "$T/bin/grep" <<EOF
+#!/bin/bash
+# Real grep, except that with \$SC/grep_fail present a search for the CLI's "Enabling now" line fails like an unreadable file.
+if [ -f "$SC/grep_fail" ]; then for a in "\$@"; do [ "\$a" = "Enabling now" ] && exit 2; done; fi
+exec /usr/bin/grep "\$@"
+EOF
+chmod +x "$T/bin/grep"
 cat > "$T/bin/sleep" <<EOF
 #!/bin/bash
 [ "\${1:-}" = 1 ] && exec /bin/sleep 1
 echo "sleep \$*" >> "$SC/log"; exit 0
 EOF
 # Transparent git wrapper, inert unless FAIL_GIT names a subcommand (and FAIL_GIT_ARG an argument) to fail.
 cat > "$T/bin/git" <<EOF
 #!/bin/bash
 if [ -n "\${FAIL_GIT:-}" ] && [ "\${1:-}" = "\$FAIL_GIT" ]; then
   for a in "\$@"; do case "\$a" in *"\${FAIL_GIT_ARG:-}"*) echo "fatal: simulated failure of git \$FAIL_GIT" >&2; exit 128 ;; esac; done
 fi
 exec "$REAL_GIT" "\$@"
 EOF
 chmod +x "$T/bin/"*
 export PATH="$T/bin:$PATH"
 
 # ─── the scenario ──────────────────────────────────────────────────────────────────────────────────────
 CANARY='{"specVersion":"v1alpha1","endpoints":{"canary":{"availableMemoryMb":256,"timeoutSeconds":10,"minInstances":0,"maxInstances":1,"ingressSettings":"ALLOW_ALL","concurrency":1,"serviceAccountEmail":"canary@my-clay-hub.iam.gserviceaccount.com","vpc":null,"platform":"gcfv2","cpu":1,"region":["us-central1"],"labels":{},"httpsTrigger":{"invoker":["private"]},"entryPoint":"canary"}},"extensions":{},"requiredAPIs":[]}'
 scenario_reset() {
   rm -rf "$SC"; mkdir -p "$SC"
   printf '%s\n' "$CANARY" > "$SC/manifest.json"; echo '[]' > "$SC/live.json"
   : > "$SC/log"; : > "$SC/list_calls"; : > "$SC/curl_calls"
 }
 manifest_edit() { "$JQ" -c "$1" "$SC/manifest.json" > "$SC/m.new" && mv "$SC/m.new" "$SC/manifest.json"; }
 
 # ─── a throwaway origin + clone that looks like my-clay-hub ────────────────────────────────────────────
 "$REAL_GIT" init --quiet --bare "$T/origin.git"
 "$REAL_GIT" clone --quiet "$T/origin.git" "$T/clone" 2>/dev/null
 REPO="$T/clone"
 cd "$REPO"
 git config user.email test@example.com; git config user.name test; git config commit.gpgsign false; git config tag.gpgSign false
 mkdir -p scripts/lib functions/core tests node_modules/firebase-tools/lib/bin
 cp "$HERE/deploy-functions.sh" "$HERE/deploy-rules.sh" "$HERE/predeploy-check.sh" scripts/
 cp "$HERE/lib/receipts.sh" scripts/lib/
 for f in scripts/deploy-functions.sh scripts/deploy-rules.sh scripts/predeploy-check.sh; do
   sed -i '' "s#^REPO=\"/Users/christiehubley/my-clay-hub\"#REPO=\"$REPO\"#" "$f"
   grep -q "^REPO=\"$REPO\"" "$f" || { echo "harness: could not pin $f to the clone"; exit 1; }
 done
 sed -i '' -e "s#^NODE22=.*#NODE22=\"$T/bin/node22\"#" -e "s#^NPM22_CLI=.*#NPM22_CLI=\"$T/npm/npm-cli.js\"#" -e "s#^CURL=.*#CURL=\"$T/bin/curl\"#" scripts/deploy-functions.sh
 for k in NODE22 NPM22_CLI CURL; do grep -q "^${k}=\"$T/" scripts/deploy-functions.sh || { echo "harness: could not pin ${k}"; exit 1; }; done
 GUARD="$REPO/scripts/deploy-functions.sh"
 : > node_modules/firebase-tools/lib/bin/firebase.js
 printf 'node_modules\n' > .gitignore
 cp "$ROOT/firebase.json" firebase.json
 echo '{"projects":{"default":"my-clay-hub"}}' > .firebaserc
 echo '{"name":"t","scripts":{"test":"echo tests"}}' > package.json
 echo '{"lockfileVersion":3,"packages":{}}' > package-lock.json
 printf 'rules_version = %s;\nservice cloud.firestore { match /databases/{db}/documents { match /x/{d} { allow read: if false; } } }\n' "'2'" > firestore.rules
 echo '{"indexes":[]}' > firestore.indexes.json
 echo 'rules_version = "2"; service firebase.storage { match /b/{b}/o { match /{p=**} { allow read: if false; } } }' > storage.rules
 cp "$ROOT/functions/declarations.json" "$ROOT/functions/iam-expectations.json" "$ROOT/functions/firebase-config.json" functions/
 printf "'use strict';\nexports.canary = 1;\n" > functions/core/index.js
 printf "'use strict';\nmodule.exports = {};\n" > functions/core/reached.js
 echo '{"name":"core","private":true,"engines":{"node":"22"},"dependencies":{"firebase-functions":"7.4.0"}}' > functions/core/package.json
 echo '{"name":"core","lockfileVersion":3,"packages":{}}' > functions/core/package-lock.json
 echo '# runbook' > FUNCTIONS-ROLLBACK.md
 echo "// a test" > tests/sample.test.js
 for f in scripts/emulator-safety.js scripts/functions-emulator.mjs scripts/functions-discover.mjs scripts/lib/functions-hash.mjs \
          scripts/deploy-rules.test.sh scripts/deploy-functions.test.sh; do echo "# stand-in" > "$f"; done
 git add -A; git commit --quiet -m "initial"; git branch -M main; git push --quiet -u origin main
 SHA1="$(git rev-parse HEAD)"
 
 GITDIR="$(git rev-parse --absolute-git-dir)"
 NS='deployed/my-clay-hub/functions-core'
 INFLIGHT="$GITDIR/tinker-deploy-inflight-functions"
 run() { : > "$SC/log"; : > "$SC/list_calls"; : > "$SC/curl_calls"; OUT="$(bash "$GUARD" "$@" 2>&1)"; CODE=$?; }
 fixture_reset() {
   git checkout --quiet main; git push --quiet --force origin "$SHA1:refs/heads/main"; git fetch --quiet origin; git reset --quiet --hard origin/main
   git tag -l 'deployed/*' | xargs -n1 git tag -d >/dev/null 2>&1 || true
   git ls-remote --tags origin 'refs/tags/deployed/*' | awk '{print $2}' | grep -v '\^{}' | xargs -n1 -I{} git push --quiet origin --delete {} 2>/dev/null || true
   rm -rf "$GITDIR/tinker-deploy.lock" "$GITDIR/tinker-deploy-pending-functions" "$INFLIGHT" "$GITDIR/tinker-deploy-transcripts"
   rm -f "$GITDIR"/tinker-deploy-message-functions-*
   git config --unset remote.origin.pushurl 2>/dev/null || true
   rm -rf "$TMPDIR"/*; git worktree prune
   scenario_reset
 }
 newest_tag() { git for-each-ref --format='%(refname:lstrip=2)' "refs/tags/${1:-$NS}/" | LC_ALL=C sort | tail -1; }
 field() { git for-each-ref --format='%(contents)' "refs/tags/$1" | awk -v k="$2=" 'index($0,k)==1{print substr($0,length(k)+1)}'; }
 commit_change() { printf '%s\n' "$2" >> "$1"; git add -A; git commit --quiet -m "change $1"; git push --quiet; git rev-parse HEAD; }
 no_deploy() { assert_lacks "$1" "$(cat "$SC/log")" "cli deploy"; }
@@ -518,328 +525,348 @@ after 'del(.[0].uri)' "no uri → the probe is inconclusive" access inconclusive
 fixture_reset; echo error > "$SC/list_mode_2"; run --approved "$SHA1" --codebase core; unverified "a list error after the deploy" deploy_match unknown
 assert_has "…and the record keeps the CLI's reason" "$(field "$(newest_tag)" mismatch)" "simulated list failure"
 assert_eq "…functions_unchanged=unknown" "$(field "$(newest_tag)" functions_unchanged)" "unknown"
 fixture_reset; echo malformed > "$SC/list_mode_2"; run --approved "$SHA1" --codebase core; unverified "malformed list JSON after the deploy" deploy_match unknown
 probe() { fixture_reset; echo "$1" > "$SC/probe"; run --approved "$SHA1" --codebase core; unverified "$2" access "$3"; }
 probe reached403 "a 403 WITH the x-tinker-reached header (our code ran)" answered
 assert_has "…recorded as such" "$(field "$(newest_tag)" probe.canary)" "http-403-with-x-tinker-reached"
 probe ok200 "a 200 (our code answered an unauthenticated caller)" answered
 probe plain200 "a 200 without the header" answered
 probe timeout "a timeout" inconclusive
 assert_eq "…after 5 tries" "$(wc -l < "$SC/curl_calls" | tr -d ' ')" "5"
 assert_eq "…4 waits between them" "$(grep -c '^sleep 10' "$SC/log")" "4"
 probe notfound "a 404" inconclusive
 probe error500 "a 5xx" inconclusive
 fixture_reset; echo 2 > "$SC/cli_exit"; : > "$SC/skip_line"; echo error500 > "$SC/probe"; echo '.[0].cpu = 4' > "$SC/after_filter"
 run --approved "$SHA1" --codebase core; R="$(newest_tag)"
 assert_eq "combined failures → exit 21" "$CODE" "21"
 assert_eq "…each recorded: cli_exit, skip line, match, access" "$(field "$R" cli_exit) $(field "$R" skip_line_seen) $(field "$R" deploy_match) $(field "$R" access)" "2 yes no inconclusive"
 
 # ═══ snapshot canonicalization ══════════════════════════════════════════════════════════════════════════
 fixture_reset
 printf '%s\n' "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.id = "zeta" | .codebase = "other" | .labels = {"b":"2","a":"1"}')]" > "$SC/live.json"
 run --approved "$SHA1" --codebase core
 : > "$SC/deploy_noop"; echo 'reverse | map(to_entries | reverse | from_entries | .labels = ((.labels // {}) | to_entries | reverse | from_entries) | .environmentVariables = ((.environmentVariables // {}) | to_entries | reverse | from_entries))' > "$SC/after_filter"
 run --approved "$SHA1" --codebase core; R="$(newest_tag)"
 assert_eq "a reordered but equivalent snapshot has the same digest" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
 assert_eq "…so functions_unchanged=yes" "$(field "$R" functions_unchanged)" "yes"
 echo 'map(.labels.touched = "1")' > "$SC/after_filter"
 run --approved "$SHA1" --codebase core; R="$(newest_tag)"
 assert_lacks "…and a real change (a label) changes it" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
 
 # ═══ interruption, --reconcile, --clear-inflight ═══════════════════════════════════════════════════════
 start_killable() {  # run the guard in its own process group; returns once $SC/blocked appears
   rm -f "$SC/blocked"; : > "$SC/log"; : > "$SC/list_calls"
   set -m; bash "$GUARD" "$@" > "$T/bg.out" 2>&1 & BG=$!; set +m
   for _ in $(seq 1 120); do [ -f "$SC/blocked" ] && break; /bin/sleep 0.5; done
   kill -KILL -- "-$BG" 2>/dev/null; wait "$BG" 2>/dev/null
   rm -rf "$GITDIR/tinker-deploy.lock"; rm -rf "$TMPDIR"/*; git worktree prune   # what a human does after checking the pid is gone
 }
 fixture_reset
 : > "$SC/cli_block"
 start_killable --approved "$SHA1" --codebase core
 assert_eq "killed after the CLI → the in-flight file remains" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "present"
 ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
 assert_has "…naming the reserved attempt" "$ATT" "${NS}/"
 assert_eq "…with no cli_exit (the CLI never returned)" "$(grep -c '^cli_exit=' "$INFLIGHT")" "0"
 assert_eq "…and no record yet" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "0"
 rm -f "$SC/cli_block"
 run --approved "$SHA1" --codebase core; assert_eq "--approved refuses while it exists (exit 22)" "$CODE" "22"; no_deploy "…and does not deploy"
 run --status --codebase core; assert_has "--status shows it" "$OUT" "IN FLIGHT:       ${ATT}"
 run --reconcile --codebase core --evidence /nonexistent; assert_eq "--reconcile without the Console evidence → exit 25" "$CODE" "25"
 evidence_op "$T/ev.json" WORKING; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…with a build that hasn't finished → exit 25" "$CODE" "25"
 printf '{"confirmation":"done"}\n' > "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…with free text instead of the fixed shape → exit 25" "$CODE" "25"
 evidence_op "$T/ev.json"
 "$JQ" -c '.[0].state = "DEPLOYING"' "$SC/live.json" > "$SC/l" && mv "$SC/l" "$SC/live.json"
 run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…while a function is DEPLOYING → exit 22" "$CODE" "22"; assert_has "…saying so" "$OUT" "still DEPLOYING"
 "$JQ" -c '.[0].state = "ACTIVE"' "$SC/live.json" > "$SC/l" && mv "$SC/l" "$SC/live.json"
 run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…once settled: recorded, not verified (cli_exit unknown) → exit 21" "$CODE" "21"
 assert_eq "…the record keeps the ORIGINAL stamp (its name is the reserved attempt id)" "$(newest_tag)" "$ATT"
 assert_eq "…cli_exit=unknown" "$(field "$ATT" cli_exit)" "unknown"
 assert_eq "…deploy_match=yes (production is what the attempt sealed)" "$(field "$ATT" deploy_match)" "yes"
 assert_has "…with Christie's evidence" "$(field "$ATT" evidence)" "0f1e2d3c-4b5a-6978-8a9b-0c1d2e3f4a5b"
 assert_eq "…by --reconcile" "$(field "$ATT" by)" "deploy-functions.sh --reconcile"
 assert_eq "…and the in-flight file is gone" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
 # killed during the read-back: the CLI returned 0, so the reconcile can verify
 fixture_reset
 : > "$SC/list_block_2"
 start_killable --approved "$SHA1" --codebase core
 assert_eq "killed during the read-back → the in-flight file has cli_exit=0" "$(awk -F= '$1=="cli_exit"{print $2}' "$INFLIGHT")" "0"
 ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
 rm -f "$SC/list_block_2"
 run --approved "$SHA1" --codebase core; assert_eq "…--approved refuses (exit 22)" "$CODE" "22"
 evidence_op "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…--reconcile verifies it (exit 0)" "$CODE" "0"
 assert_eq "…under its original stamp" "$(newest_tag)" "$ATT"
 assert_eq "…deploy_verified=yes" "$(field "$ATT" deploy_verified)" "yes"
+assert_eq "…and a reconciled FIRST deploy still needs Christie's IAM reading" "$(field "$ATT" attest_needed)" "yes"
+assert_has "…saying so" "$OUT" "IAM reading NEEDED"
 # --clear-inflight
 fixture_reset
 : > "$SC/cli_block"; start_killable --approved "$SHA1" --codebase core; rm -f "$SC/cli_block"
 ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
 evidence_op "$T/ev.json" WORKING null
 run --clear-inflight "${NS}/20990101T000000Z-${SHA1:0:7}" --codebase core --evidence "$T/ev.json"
 assert_eq "--clear-inflight naming another attempt → exit 22" "$CODE" "22"
 run --clear-inflight "$ATT" --codebase core --evidence "$T/ev.json"
 assert_eq "--clear-inflight with Christie's evidence → exit 0" "$CODE" "0"
 assert_eq "…keeps the original stamp" "$(newest_tag)" "$ATT"
 assert_eq "…deploy_match=unknown" "$(field "$ATT" deploy_match)" "unknown"
 assert_eq "…deploy_verified=no" "$(field "$ATT" deploy_verified)" "no"
+assert_eq "…attest_needed=yes (not verified)" "$(field "$ATT" attest_needed)" "yes"
+assert_has "…saying so" "$OUT" "IAM reading NEEDED"
 assert_eq "…the in-flight file is gone" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
 run --approved "$SHA1" --codebase core; assert_eq "…and the next --approved runs (verified)" "$CODE" "0"
 # a truncated in-flight file fails closed
 fixture_reset
 : > "$SC/cli_block"; start_killable --approved "$SHA1" --codebase core; rm -f "$SC/cli_block"
 head -3 "$INFLIGHT" > "$INFLIGHT.t" && mv "$INFLIGHT.t" "$INFLIGHT"
 evidence_op "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "a truncated in-flight file → --reconcile refuses (exit 22)" "$CODE" "22"; assert_has "…as malformed" "$OUT" "malformed"
 run --clear-inflight x --codebase core --evidence "$T/ev.json"; assert_eq "…--clear-inflight too" "$CODE" "22"
 run --status --codebase core; assert_has "…and --status says MALFORMED" "$OUT" "MALFORMED"
 run --approved "$SHA1" --codebase core; assert_eq "…and --approved refuses" "$CODE" "22"
 
 # ═══ ordering: newest attempt, --reverify ═══════════════════════════════════════════════════════════════
 fixture_reset
 echo timeout > "$SC/probe"; run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 rm -f "$SC/probe"; S2="$(commit_change functions/core/index.js "exports.b = 2;")"
 run --approved "$S2" --codebase core; RB="$(newest_tag)"
 assert_eq "attempt A unverified, attempt B verified" "$(field "$RA" deploy_verified) $(field "$RB" deploy_verified)" "no yes"
 run --reverify "$RA" --codebase core
 assert_eq "--reverify A is refused: not the newest attempt (exit 26)" "$CODE" "26"
 assert_eq "…and wrote no verify record" "$(git tag -l "${NS}-verify/*" | wc -l | tr -d ' ')" "0"
 run --status --codebase core; assert_has "--status names B" "$OUT" "verified at ${RB}"
 S3="$(commit_change functions/core/index.js "exports.c = 3;")"
 run --diff --codebase core; assert_has "--diff diffs from B" "$OUT" "last verified attempt ${RB}"; assert_has "…showing the new line" "$OUT" "+exports.c = 3;"
 assert_lacks "…not from A (A's change is already in B)" "$OUT" "+exports.b = 2;"
 echo timeout > "$SC/probe"; run --approved "$S3" --codebase core; RC="$(newest_tag)"
 assert_eq "attempt C: unverified only by its probe" "$(field "$RC" deploy_match) $(field "$RC" access) $(field "$RC" deploy_verified)" "yes inconclusive no"
 run --status --codebase core; assert_has "--status: production may be mixed, last verified B" "$OUT" "production may be mixed: last verified ${RB}; unverified attempt ${RC}"
 run --diff --codebase core; assert_has "--diff warns the newest attempt is unverified" "$OUT" "NOT verified"
 rm -f "$SC/probe"; run --reverify "$RC" --codebase core
 assert_eq "--reverify C (the newest) → verified (exit 0)" "$CODE" "0"
 RV="$(newest_tag "${NS}-verify")"
 assert_eq "…a verify record naming C" "$(field "$RV" attempt)" "$RC"
 assert_eq "…deploy_verified=yes" "$(field "$RV" deploy_verified)" "yes"
 assert_eq "…C's own record is unchanged" "$(field "$RC" deploy_verified)" "no"
 run --status --codebase core; assert_has "…and --status now says verified at C" "$OUT" "verified at ${RC}"
 assert_lacks "…a verify record never counts as an attempt" "$OUT" "newest attempt:  ${RV}"
 echo 2 > "$SC/cli_exit"; run --approved "$S3" --codebase core; RD="$(newest_tag)"; rm -f "$SC/cli_exit"
 run --reverify "$RD" --codebase core
 assert_eq "--reverify can't upgrade cli_exit (only the read-back and probe) → exit 21" "$CODE" "21"
 assert_eq "…its verify record says no" "$(field "$(newest_tag "${NS}-verify")" deploy_verified)" "no"
 
 # ═══ a stale clock / a stray future-stamped tag refuses; the documented escape clears it ═════════════
 fixture_reset
 FAR_E=$(( $(date -u +%s) + 3600 )); FAR="$(date -u -r "$FAR_E" +%Y%m%dT%H%M%SZ)"
 GIT_COMMITTER_DATE="$(date -u -r "$FAR_E" +%Y-%m-%dT%H:%M:%S) +0000" git tag -a "${NS}/${FAR}-stray00" "$SHA1" -m "attempt=${NS}/${FAR}-stray00
 deploy_verified=no"
 git push --quiet origin "refs/tags/${NS}/${FAR}-stray00"
 run --approved "$SHA1" --codebase core
 assert_eq "a future-stamped tag the clock can't pass → refused (exit 20)" "$CODE" "20"
 assert_has "…NOTHING WAS CHANGED" "$OUT" "NOTHING WAS CHANGED"
 assert_has "…pointing at the runbook's escape" "$OUT" "FUNCTIONS-ROLLBACK.md §4"
 no_deploy "…the CLI never deployed"
 assert_eq "…no in-flight file" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
 git tag -d "${NS}/${FAR}-stray00" >/dev/null; git push --quiet origin ":refs/tags/${NS}/${FAR}-stray00"
 run --approved "$SHA1" --codebase core; assert_eq "…after the escape (delete it, with Christie's OK) → deploys" "$CODE" "0"
 
 # ═══ --attest ══════════════════════════════════════════════════════════════════════════════════════════
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "--attest with a matching reading → iam_attested=yes (exit 0)" "$CODE" "0"
 RT="$(newest_tag "${NS}-attest")"
 assert_eq "…an attest record naming the attempt" "$(field "$RT" attempt)" "$RA"
 assert_eq "…iam_attested=yes" "$(field "$RT" iam_attested)" "yes"
 assert_has "…and it names what it does not attest (bucket-level grants among them)" "$(field "$RT" not_attested)" "individual Cloud Storage buckets"
 run --status --codebase core; assert_has "…and --status shows it" "$OUT" "iam_attested=yes"
 attest_no() { evidence_iam "$T/iam.json" "$1"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
   assert_eq "$2 → iam_attested=no (exit 21)" "$CODE" "21"; assert_eq "…recorded" "$(field "$(newest_tag "${NS}-attest")" iam_attested)" "no"; assert_has "…naming it" "$OUT" "$3"; }
 attest_no '.functions = {}' "a missing function" "canary: missing from the reading"
 attest_no '.functions.canary.runInvokerMembers = ["allUsers"]' "an extra run.invoker member" "run.invoker members"
 attest_no '.functions.canary.requireAuthentication = false' "Require authentication off, with no members" "Require authentication is OFF"
 attest_no '.projectRoles["roles/editor"] += ["serviceAccount:760301318440-compute@developer.gserviceaccount.com"]' "an extra Editor (a build candidate, next to the Google APIs Service Agent)" "roles/editor: holders"
 attest_no '.projectRoles["roles/editor"] = ["serviceAccount:other@my-clay-hub.iam.gserviceaccount.com"]' "Editor held by someone other than the Google APIs Service Agent" "roles/editor: holders"
 attest_no '.runtimeAccounts["canary@my-clay-hub.iam.gserviceaccount.com"] = ["roles/datastore.user"]' "a role on the canary's account" "canary@my-clay-hub.iam.gserviceaccount.com: roles"
 attest_no '.buildAccount = "someone@x.iam.gserviceaccount.com"' "a build account that is neither candidate" "neither build candidate"
 L='serviceAccount:760301318440@cloudbuild.gserviceaccount.com'
 attest_no '.buildAccount = "760301318440@cloudbuild.gserviceaccount.com"' "the legacy account built while the O3 roles stay on Compute (F7)" "expected only the build account ${L}"
 SV='.buildRoleBindings["roles/storage.objectViewer"]'
 attest_no "${SV}[0].condition = \"resource.name.startsWith(\\\"projects/_/buckets/\\\")\"" "a widened Storage Object Viewer condition" "its condition is not Appendix A5"
 attest_no "${SV}[0].condition = null" "the Storage Object Viewer binding with no condition" "its condition is not Appendix A5"
 attest_no "${SV} += [{\"member\": ${SV}[0].member, \"condition\": null}]" "a second, UNCONDITIONAL binding of the same account next to the A5 one" "2 project-level bindings, expected exactly one"
 attest_no '.buildRoleBindings["roles/logging.logWriter"][0].condition = "request.time < timestamp(\"2030-01-01T00:00:00Z\")"' "a Logs Writer binding with a condition" "its condition is not none"
 attest_no 'del(.buildRoleBindings["roles/logging.logWriter"])' "a build role not read" "build role bindings read for"
 attest_no '.artifactRegistryWriters.repository = []' "no Artifact Registry Writer on the repository" "Artifact Registry Writer on"
 attest_no '.artifactRegistryWriters.repository += ["user:someone@x.com"]' "an extra Artifact Registry Writer on the repository" "Artifact Registry Writer on"
 attest_no '.artifactRegistryWriters.project = ["serviceAccount:other@my-clay-hub.iam.gserviceaccount.com"]' "Artifact Registry Writer granted at project level" "granted at PROJECT level"
 # FUNCTIONS-ROLLBACK.md §3: Google built with the legacy account, and the O3 roles were moved to it → attests yes
 LG='serviceAccount:760301318440@cloudbuild.gserviceaccount.com'
 evidence_iam "$T/iam.json" ".buildAccount = \"760301318440@cloudbuild.gserviceaccount.com\"
   | .buildRoleBindings[\"roles/logging.logWriter\"][0].member = \"${LG}\"
   | .buildRoleBindings[\"roles/storage.objectViewer\"][0].member = \"${LG}\"
   | .artifactRegistryWriters.repository = [\"${LG}\"]"
 run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "the legacy account built AND holds the O3 roles alone (§3's move) → iam_attested=yes" "$CODE" "0"
 attest_no 'del(.projectRoles["roles/cloudbuild.builds.builder"])' "a reading that leaves out the Cloud Build builder role (F7)" "project roles read"
 attest_no '.projectRoles["roles/cloudbuild.builds.builder"] = ["serviceAccount:760301318440@cloudbuild.gserviceaccount.com"]' "the legacy build account holding builder again" "roles/cloudbuild.builds.builder: holders"
 run --status --codebase core; assert_has "--status shows the newest attestation (no)" "$OUT" "iam_attested=no"
 echo '{"functions":{}}' > "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "a reading not in the fixed shape → refused (exit 25)" "$CODE" "25"
 run --approved "$SHA1" --codebase core; evidence_iam "$T/iam.json"
 run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "attesting an attempt that is no longer the newest → refused (exit 26)" "$CODE" "26"
 # a runtime account the attempt declares but iam-expectations.json doesn't name: its roles were never read
 fixture_reset
 "$JQ" '.["core/canary"].serviceAccount = "reports@my-clay-hub.iam.gserviceaccount.com"' functions/declarations.json > d.new && mv d.new functions/declarations.json
 git commit --quiet -am "canary runs as reports@"; git push --quiet; SR="$(git rev-parse HEAD)"
 manifest_edit '.endpoints.canary.serviceAccountEmail = "reports@my-clay-hub.iam.gserviceaccount.com"'
 run --approved "$SR" --codebase core; RA="$(newest_tag)"
 evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "a declared runtime account missing from iam-expectations.json → iam_attested=no" "$CODE" "21"
 assert_has "…naming it" "$OUT" "reports@my-clay-hub.iam.gserviceaccount.com is declared but not in functions/iam-expectations.json"
 
 # ═══ whether a deploy needs Christie's IAM reading (Christie, Oct 1 2026) ══════════════════════════════════
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 assert_eq "a first deploy → attest_needed=yes" "$(field "$RA" attest_needed)" "yes"
 assert_has "…because nothing is attested yet" "$(field "$RA" attest_needed_why)" "no attempt of core has iam_attested=yes yet"
 assert_has "…and it prints the reading to take" "$OUT" "IAM reading NEEDED"; assert_has "…with the JSON shape" "$OUT" "next: Christie's IAM reading"
 evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"; assert_eq "…attested yes" "$CODE" "0"
 SA="$(commit_change functions/core/index.js "exports.a1 = 1;")"
 run --approved "$SA" --codebase core; RB="$(newest_tag)"
 assert_eq "a source-only change after an attested deploy → verified (exit 0)" "$CODE" "0"
 assert_eq "…attest_needed=no" "$(field "$RB" attest_needed)" "no"
 assert_has "…naming the attested attempt it relies on" "$(field "$RB" attest_needed_why)" "last attested ${RA}"
 assert_has "…and it says so" "$OUT" "IAM reading not needed"; assert_lacks "…without the reading's JSON shape" "$OUT" "next: Christie's IAM reading"
 : > "$SC/api_enabled"; SB="$(commit_change functions/core/index.js "exports.a2 = 2;")"
 run --approved "$SB" --codebase core; RC="$(newest_tag)"; rm -f "$SC/api_enabled"
 assert_eq "the CLI enabled a Google API during the deploy → attest_needed=yes" "$(field "$RC" attest_needed)" "yes"
 assert_has "…naming it" "$(field "$RC" attest_needed_why)" "the CLI enabled a Google API"
 assert_has "…and it prints the reading to take" "$OUT" "next: Christie's IAM reading"
 SC2="$(commit_change functions/core/index.js "exports.a3 = 3;")"
 run --approved "$SC2" --codebase core; RD="$(newest_tag)"
 assert_eq "a reading owed by the API deploy was never taken → the next source-only deploy still needs it" "$(field "$RD" attest_needed)" "yes"
-assert_has "…naming the attempt that owes it" "$(field "$RD" attest_needed_why)" "${RC} needed a reading that was never attested yes"
+assert_has "…naming the attempt that owes it" "$(field "$RD" attest_needed_why)" "${RC} needed a reading, or its reading came back no"
 evidence_iam "$T/iam.json"; run --attest "$RD" --codebase core --evidence "$T/iam.json"; assert_eq "…once the newest attempt is attested yes" "$CODE" "0"
 SD="$(commit_change functions/core/index.js "exports.a5 = 5;")"
 run --approved "$SD" --codebase core; RG="$(newest_tag)"
 assert_eq "…the next source-only deploy → no" "$(field "$RG" attest_needed)" "no"
 assert_has "…relying on that attestation" "$(field "$RG" attest_needed_why)" "last attested ${RD}"
 SE="$(commit_change functions/iam-expectations.json "")"   # any change to the file counts, even a blank line
 run --approved "$SE" --codebase core; RE="$(newest_tag)"
 assert_eq "functions/iam-expectations.json changed since the attested attempt → attest_needed=yes" "$(field "$RE" attest_needed)" "yes"
 assert_has "…naming the file" "$(field "$RE" attest_needed_why)" "changed since ${RD}: functions/iam-expectations.json"
 # an attempt from before this rule (no attest_needed field) between the attested one and now: the reading is owed
 git tag -d "$RE" >/dev/null; git push --quiet origin ":refs/tags/$RE"   # (drop the iam-file attempt so only the old-style one is in between)
 git for-each-ref --format='%(contents)' "refs/tags/$RG" | grep -v '^attest_needed' > "$T/old.msg"
 git tag -d "$RG" >/dev/null; git push --quiet origin ":refs/tags/$RG"; git tag -a -F "$T/old.msg" "$RG" "$SD"; git push --quiet origin "refs/tags/$RG"
 SH="$(commit_change functions/core/index.js "exports.a6 = 6;")"
 run --approved "$SH" --codebase core; RH="$(newest_tag)"
 assert_eq "an unattested attempt from before this rule in between → attest_needed=yes (fail-closed)" "$(field "$RH" attest_needed)" "yes"
-assert_has "…naming it" "$(field "$RH" attest_needed_why)" "${RG} needed a reading that was never attested yes"
+assert_has "…naming it" "$(field "$RH" attest_needed_why)" "${RG} needed a reading, or its reading came back no"
 : > "$SC/skip_line"; SF="$(commit_change functions/core/index.js "exports.a4 = 4;")"
 run --approved "$SF" --codebase core; RF="$(newest_tag)"; rm -f "$SC/skip_line"
 assert_eq "an unverified deploy → attest_needed=yes" "$(field "$RF" attest_needed)" "yes"
 assert_has "…saying so" "$(field "$RF" attest_needed_why)" "the deploy is not verified"
+run --status --codebase core; assert_has "--status shows attest_needed and why" "$OUT" "attest_needed=yes — the deploy is not verified"
+# a reading that came back no stays owed, even for an attempt that didn't need one
+fixture_reset
+run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
+evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
+SA="$(commit_change functions/core/index.js "exports.b1 = 1;")"; run --approved "$SA" --codebase core; RB="$(newest_tag)"
+assert_eq "…(a source-only deploy after an attested one needs none)" "$(field "$RB" attest_needed)" "no"
+evidence_iam "$T/iam.json" '.projectRoles["roles/editor"] += ["user:someone@x.com"]'; run --attest "$RB" --codebase core --evidence "$T/iam.json"
+assert_eq "…an optional reading finds a mismatch → iam_attested=no" "$CODE" "21"
+SB="$(commit_change functions/core/index.js "exports.b2 = 2;")"; run --approved "$SB" --codebase core; RC="$(newest_tag)"
+assert_eq "a known iam_attested=no since the last yes → the next deploy needs a reading" "$(field "$RC" attest_needed)" "yes"
+assert_has "…naming the attempt" "$(field "$RC" attest_needed_why)" "${RB} needed a reading, or its reading came back no"
+# the transcript exists but can't be read (grep exits 2): needed, never "no API enabled"
+: > "$SC/grep_fail"; SC3="$(commit_change functions/core/index.js "exports.b3 = 3;")"; run --approved "$SC3" --codebase core; RD="$(newest_tag)"; rm -f "$SC/grep_fail"
+assert_eq "an unreadable transcript → attest_needed=yes" "$(field "$RD" attest_needed)" "yes"
+assert_has "…saying so" "$(field "$RD" attest_needed_why)" "could not read the transcript"
 
 # ═══ the verifier: the pushed tip's guard, and a changed guard needs Christie's OK ═════════════════════
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 echo "# local edit" >> scripts/deploy-functions.sh
 run --reverify "$RA" --codebase core; assert_eq "a DIRTY guard refuses (exit 27)" "$CODE" "27"; assert_has "…saying why" "$OUT" "not origin/main's"
 git commit --quiet -am "unpushed guard edit"
 run --reverify "$RA" --codebase core; assert_eq "an UNPUSHED guard refuses (exit 27)" "$CODE" "27"
 run --approved "$SHA1" --codebase core; assert_eq "…--approved too" "$CODE" "27"; no_deploy "…never deployed"
 git push --quiet
 run --reverify "$RA" --codebase core
 assert_eq "once pushed, the guard changed since the attempt → refused without Christie's OK (exit 27)" "$CODE" "27"
 assert_has "…naming the change" "$OUT" "first at scripts/deploy-functions.sh"
 run --reverify "$RA" --codebase core --acknowledge-verifier-change
 assert_eq "…with --acknowledge-verifier-change → re-verified (exit 0)" "$CODE" "0"
 assert_has "…and the record says so" "$(field "$(newest_tag "${NS}-verify")" verifier_changed)" "yes (scripts/deploy-functions.sh)"
 assert_eq "…and names the commit whose helpers rebuilt the expected state" "$(field "$(newest_tag "${NS}-verify")" rebuild_helpers_from)" "$SHA1"
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 commit_change scripts/lib/functions-hash.mjs "// a changed hash module" >/dev/null
 run --reverify "$RA" --codebase core
 assert_eq "a changed HELPER (the hash module) since the attempt → refused without Christie's OK (exit 27)" "$CODE" "27"
 assert_has "…naming it" "$OUT" "first at scripts/lib/functions-hash.mjs"
 # control files: an older commit whose machinery differs from the tip is refused
 fixture_reset
 "$JQ" '.' functions/declarations.json > d.new && printf '\n' >> d.new && mv d.new functions/declarations.json; git commit --quiet -am "touch declarations"; git push --quiet
 run --approved "$SHA1" --codebase core
 assert_eq "an older commit whose declarations differ from the tip → exit 14" "$CODE" "14"; assert_has "…naming it" "$OUT" "carries a different functions/declarations.json"
 no_deploy "…never deployed"
 
 # ═══ the record can't be written or published ══════════════════════════════════════════════════════════
 fixture_reset
 git config remote.origin.pushurl /nonexistent/path
 run --approved "$SHA1" --codebase core
 assert_eq "the record's push fails → exit 17" "$CODE" "17"; assert_has "…RECORD NOT PUBLISHED" "$OUT" "RECORD NOT PUBLISHED"
 assert_eq "…the local record exists" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "1"
 assert_eq "…the in-flight file is gone (the record exists)" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
 run --approved "$SHA1" --codebase core
 assert_eq "still unpushable → the next run refuses first (exit 12)" "$CODE" "12"; no_deploy "…without deploying"
 git config --unset remote.origin.pushurl
 run --approved "$SHA1" --codebase core
 assert_eq "pushable again → the pending record is published, then the deploy runs" "$CODE" "0"
 assert_has "…said so" "$OUT" "publishing the record left behind"
 assert_eq "…both records on origin" "$(git ls-remote --tags origin "refs/tags/${NS}/*" | grep -vc '\^{}' | tr -d ' ')" "2"
 fixture_reset
 FAIL_GIT=tag FAIL_GIT_ARG=-a run --approved "$SHA1" --codebase core
 assert_eq "the record can't be written → exit 17" "$CODE" "17"; assert_has "…RECORD NOT WRITTEN, with the command" "$OUT" "git tag -a ${NS}/"
 assert_eq "…the in-flight file stays" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "present"
 run --approved "$SHA1" --codebase core; assert_eq "…so the next --approved refuses (exit 22)" "$CODE" "22"
 
 # ═══ shared code: both guards order an identical tag set identically ═══════════════════════════════════
 # Built so that a wrong ordering names a DIFFERENT tag (the standing rule): the stamp is the primary key even when tag
 # dates disagree, and an exact stamp tie is broken by the tag instant across UTC offsets, not by refname.
 fixture_reset
 RNS='deployed/my-clay-hub/firestore-rules'
 plant() {  # <ns> <stamp> <suffix> <tag date>
   GIT_COMMITTER_DATE="$4" git tag -a "$1/$2-$3" "$SHA1" -m "attempt=$1/$2-$3
 project=my-clay-hub commit=$SHA1 by=seeded
 deploy_verified=yes"
 }
 for ns in "$RNS" "$NS"; do
   plant "$ns" 20260101T000000Z aaaaaa1 "2026-06-01T00:00:00 +0000"   # shipped first, tagged late
   plant "$ns" 20260201T000000Z zzzzzzz "2026-02-01T12:00:05 +0000"   # same stamp as the next: the EARLIER instant, higher refname
   plant "$ns" 20260201T000000Z aaaaaa9 "2026-02-01T06:00:10 -0600"   # 12:00:10Z — the LATER instant, lower refname
 done
 OUT="$(bash scripts/deploy-rules.sh --status 2>&1)"
 assert_has "the rules guard names the later-instant tag of the newest stamp" "$OUT" "20260201T000000Z-aaaaaa9"
 run --status --codebase core
 assert_has "the functions guard names the same one" "$OUT" "newest attempt:  ${NS}/20260201T000000Z-aaaaaa9"
 assert_lacks "…not the higher refname" "$OUT" "20260201T000000Z-zzzzzzz"
 assert_lacks "…nor the later tag date" "$OUT" "20260101T000000Z-aaaaaa1"
 
 # ═══ real npm: npm ci --prefix leaves the symlinked root node_modules untouched (F5) ═══════════════════
 N22=/opt/homebrew/opt/node@22/bin/node; NPMC=/opt/homebrew/opt/node@22/lib/node_modules/npm/bin/npm-cli.js
 if [ -x "$N22" ] && [ -f "$NPMC" ]; then
   RN="$T/realnpm"; mkdir -p "$RN/shared/marker" "$RN/root/functions/core"
   echo keep > "$RN/shared/marker/file"; ln -s "$RN/shared" "$RN/root/node_modules"
   echo '{"name":"core","version":"1.0.0","private":true}' > "$RN/root/functions/core/package.json"
   echo '{"name":"core","version":"1.0.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"core","version":"1.0.0"}}}' > "$RN/root/functions/core/package-lock.json"
   BEFORE_LS="$(cd "$RN/shared" && find . | LC_ALL=C sort)"
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/my-clay-hub
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f7e3-6278-78b0-abcd-2262f195b201
--------
user
# Implementation review: my-clay-hub branch d2-attest-followups (commits b20c698, 3fefa4e on top of 7efa0f0)

You are an independent reviewer. Read-only: do not edit, commit, run any Firebase CLI command, or contact any network service. Repo: /Users/christiehubley/my-clay-hub. Run `git diff 7efa0f0..HEAD` and read files. You may run `bash -n`. Do not run `npm test` or the guard suites (they run separately; the functions guard suite passes, 623).

## Context
`scripts/deploy-functions.sh` is the only path for Cloud Functions deploys to the my-clay-hub project. After a deploy, Christie reads IAM in the Console and `--attest` compares her reading with `functions/iam-expectations.json`, recording iam_attested=yes|no (never blocking). The first real deploy (D2-5) verified, but its reading found `760301318440@cloudservices.gserviceaccount.com` (Google APIs Service Agent) holding Editor — granted by Google when the CLI enabled firebaseextensions.googleapis.com during the deploy. Christie decided (Oct 1):
1. Allow exactly that Google-managed agent as an Editor holder; Editor for anyone else is still a difference.
2. Stop requiring an IAM reading after every deploy; the guard should say when one is needed.

## The change
- functions/iam-expectations.json: roles/editor = [that agent]. tests/unit/firebase-config.test.js updated.
- scripts/deploy-functions.sh: new `attest_need` (records `attest_needed`, `attest_needed_why` in the attempt record before it's written; prints "IAM reading NEEDED: …" + the JSON shape, or "IAM reading not needed: …"). Needed when: deploy not verified; no transcript; transcript contains "Enabling now"; record unreadable; no attempt of the codebase has iam_attested=yes; ATTEST_FILES (declarations.json, iam-expectations.json, firebase.json, .firebaserc) changed between the newest attested-yes attempt's commit and this one; the function set differs from that attempt's; or an attempt between that one and now had attest_needed != no (owed; attempts before this rule have no field and count as owing).
- scripts/deploy-functions.test.sh: fixture reading includes the agent; new tests for each case; the fake CLI can print the "Enabling now" line.
- FUNCTIONS-ROLLBACK.md §7, CLAUDE.md, AGENTS.md, docs/my-clay-hub/DECISIONS.md #60–61.

## What I want reviewed
1. Is `attest_need` fail-closed everywhere (any read error, odd record, missing field → "needed")? Check `set -e`/pipefail interactions in the script (e.g. inside `$(…)`, `while read`, `||` chains), and `receipt_rows` / `iam_attested_of` / `record_field` / `commit_of` from scripts/lib/receipts.sh and the guard.
2. Can it ever say "not needed" when a reading should be needed? Think: the attested attempt's commit not present locally; renamed files; a function added/removed without a declarations change (is that possible given the backstop and read-back?); a change to functions/core/index.js that alters invoker/serviceAccount (the read-back F8 compares live config with declarations — confirm); the "Enabling now" string — confirm against the pinned firebase-tools 15.22.3 source (node_modules/firebase-tools/lib/ensureApiEnabled.js or similar) that every API enablement prints that exact text, and whether any other path can enable an API silently.
3. Is the "owed" logic right (newest-first iteration stops at the first attested-yes attempt; any attempt before it with attest_needed != no makes it owed)?
4. Is the Editor allowance exactly scoped (set equality in JQ_ATTEST)? Any way a build candidate holding Editor passes?
5. Docs accurate and consistent? Anything in --status, --reverify or --attest paths that should also know about attest_needed?

## Output
Verdict first: "ready", "ready after fixes", or "not ready". Then blocking / should-fix / nit, each with file:line and a concrete failure scenario. Keep it short.

codex
I’ll review the exact commit range and trace the deploy/receipt logic read-only. I’ll limit execution to inspection commands and `bash -n`, as requested.
exec
/bin/zsh -lc 'git status --short && git diff --stat 7efa0f0..HEAD && git diff --check 7efa0f0..HEAD && git log --oneline --decorate -5' in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-yhBwwCFs' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-C9R1ansO' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Jm6Ze702' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-tqNI6tUK' (errno=Operation not permitted)
 AGENTS.md                          |  2 +-
 CLAUDE.md                          |  3 ++-
 FUNCTIONS-ROLLBACK.md              | 14 +++++++++--
 docs/my-clay-hub/DECISIONS.md      |  2 ++
 functions/iam-expectations.json    |  4 ++-
 scripts/deploy-functions.sh        | 49 ++++++++++++++++++++++++++++++++++++-
 scripts/deploy-functions.test.sh   | 50 ++++++++++++++++++++++++++++++++++++--
 tests/unit/firebase-config.test.js |  7 ++++--
 8 files changed, 121 insertions(+), 10 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-13S7mArF' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-KRGNYlWJ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-IYPwd0qU' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-8ddwox6S' (errno=Operation not permitted)
3fefa4e (HEAD -> d2-attest-followups) D2-5 follow-up: the guard says when an IAM reading is needed (Christie, Oct 1)
b20c698 D2-5 follow-up: allow exactly the Google APIs Service Agent as Editor (Christie, Oct 1)
7efa0f0 (tag: deployed/my-clay-hub/functions-core/20261001T045900Z-7efa0f0, tag: deployed/my-clay-hub/functions-core-attest/20261001T141405Z-7efa0f0, origin/main, origin/HEAD, main) D2-5: pin FIREBASE_CONFIG to the live value (no locationId)
604844c (tag: deployed/my-clay-hub/functions-core/20261001T034143Z-604844c) D2-5 Codex review fixes (Codex: "ready after fixes"; 0 blocking, 2 should-fix)
f196bb2 D2-5: name test files, not folders, for node --test (Node 22 refused the suite)

exec
/bin/zsh -lc 'git diff --find-renames --find-copies 7efa0f0..HEAD -- scripts/deploy-functions.sh scripts/lib/receipts.sh scripts/deploy-functions.test.sh functions/iam-expectations.json tests/unit/firebase-config.test.js FUNCTIONS-ROLLBACK.md CLAUDE.md AGENTS.md docs/my-clay-hub/DECISIONS.md' in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ZVEQHz4W' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-GA72eekX' (errno=Operation not permitted)
diff --git a/AGENTS.md b/AGENTS.md
index ca49843..5a3915d 100644
--- a/AGENTS.md
+++ b/AGENTS.md
@@ -30,7 +30,7 @@
   prints SKIPPED). A raw `firebase … deploy` is denied.
 - Cloud Functions: HTTP functions only, for now, in `functions/<codebase>/`, deployed only through
   `scripts/deploy-functions.sh` (`--status` / `--diff` / `--approved <full sha>`, each with `--codebase <cb>`; then
-  `--attest`; recovery in `FUNCTIONS-ROLLBACK.md`) after the same phrase. Every function is declared in
+  `--attest` when the guard says an IAM reading is needed; recovery in `FUNCTIONS-ROLLBACK.md`) after the same phrase. Every function is declared in
   `functions/declarations.json` (runtime account and callers) and declares `invoker` in code — never grant `run.invoker`
   by hand; every HTTP response sets `x-tinker-reached`; no `.env*`, `functions.yaml`, symlinks or `node` dependency in a
   codebase; the canary (`core/canary`) is permanent. Deleting functions, secrets, runtime config and artifact settings
diff --git a/CLAUDE.md b/CLAUDE.md
index d66c24d..83c2fbb 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -55,7 +55,8 @@ It replaces the retired Clay Hub Booking app (`clay-hub-booking`). Never reuse t
   /Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh --diff   --codebase core   # paste verbatim when asking
   /Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh --approved <full sha> --codebase core
   ```
-  After a deploy: `--attest <attempt>` with Christie's IAM reading (the deploy prints its exact shape). Recovery modes
+  After a deploy: when the guard says an IAM reading is NEEDED, `--attest <attempt>` with Christie's reading (it prints
+  the exact shape and why; otherwise it says "not needed" and why — `FUNCTIONS-ROLLBACK.md` §7). Recovery modes
   (`--reconcile`, `--clear-inflight`, `--reverify`) are in `FUNCTIONS-ROLLBACK.md`, which is the runbook. Deleting a
   function, secrets, runtime config and artifact settings have no guarded path yet: the hook denies them; ask Christie.
   - Every function is declared in `functions/declarations.json` (its runtime account and callers) and sets `invoker`,
diff --git a/FUNCTIONS-ROLLBACK.md b/FUNCTIONS-ROLLBACK.md
index 9c4b9bc..4c69cdd 100644
--- a/FUNCTIONS-ROLLBACK.md
+++ b/FUNCTIONS-ROLLBACK.md
@@ -8,7 +8,8 @@ permanent canary). Rules have their own runbook: `RULES-ROLLBACK.md`. Plan and d
 > with the backstop, the canary, `functions/declarations.json`, `functions/iam-expectations.json` and the pinned
 > `functions/firebase-config.json`. **D2-5 (Sep 30):** the first guarded deploy created the canary (attempt
 > `deployed/my-clay-hub/functions-core/20261001T034143Z-604844c`, private: the unauthenticated probe was refused) but
-> recorded `deploy_verified=no`, because the pinned `locationId` was wrong (§8); the corrected pin needs a second deploy.
+> recorded `deploy_verified=no`, because the pinned `locationId` was wrong (§8). The second deploy (`7efa0f0`) verified;
+> its IAM reading found the Google APIs Service Agent holding Editor, now allowed in `iam-expectations.json` (Oct 1).
 
 **Never** run a raw `firebase … deploy`, `functions:delete`, or any function-changing CLI command by hand. A hook denies
 them, and the backstop refuses a deploy that didn't come through the guard. Every step below goes through
@@ -109,7 +110,16 @@ no roles and must keep none (`functions/iam-expectations.json`). Don't delete it
 
 ## 7. After a deploy: --attest, --reverify, and a changed guard
 
-- **--attest** (every deploy, M3 and F7): Christie reads each function's Security tab ("Require authentication") and
+- **When a reading is needed** (Christie, Oct 1 2026 — replaces "every deploy"): after each deploy the guard records
+  `attest_needed=yes|no` and says why. A reading is **needed** when the deploy isn't verified; when no attempt of the
+  codebase has `iam_attested=yes` yet; when the function set, `functions/declarations.json`,
+  `functions/iam-expectations.json`, `firebase.json` or `.firebaserc` changed since the newest attested attempt; when
+  the CLI turned on a Google API during the deploy (Google can add role grants then — D2-5's Editor grant came that
+  way); or when an unattested attempt since the last attested one owed a reading (one from before this rule counts as
+  owing). Otherwise the guard says "IAM reading not needed" and names the attested attempt it relies on. The automatic
+  checks (hash, settings, the unauthenticated probe) run on every deploy either way. **Not seen:** a role someone
+  changes by hand in the Console — after one, take a reading anyway.
+- **--attest** (when needed, M3 and F7): Christie reads each function's Security tab ("Require authentication") and
   Permissions (the full `run.invoker` list); IAM "View by roles" — the holders of every role in
   `functions/iam-expectations.json` (`run.invoker`, `cloudfunctions.invoker`, `owner`, `editor`,
   `cloudbuild.builds.builder`) and each runtime account's roles; every **binding row** of the build roles
diff --git a/docs/my-clay-hub/DECISIONS.md b/docs/my-clay-hub/DECISIONS.md
index 02a539d..7bda289 100644
--- a/docs/my-clay-hub/DECISIONS.md
+++ b/docs/my-clay-hub/DECISIONS.md
@@ -74,3 +74,5 @@ These come from the foundation plan (`~/tinker-ai-configs/thoughts/plans/clayhub
 | 57 | C7 | Sep 28 | `weekKey` is **ISO-8601**, with the ISO week-year and a two-digit week (`2026-W09`; 2027-01-01 → `2026-W53`). | At a year boundary, two readings of "week" give different keys. |
 | 58 | C8 | Sep 28 | A pause whose end is before its start is **malformed**, so `deriveStatus` gives `review` (rule 7). | Otherwise it would fall through to `active` silently; `review` is how #34 handles every other data gap. |
 | 59 | — | Sep 28 | A pause with a start date but **no end date** gives **`review`**, not "paused indefinitely" (rule 7 as written). The member can sign in and see the feed but can't book; staff see a flag and add the end date, and the pause's booking cancellation happens then. | Christie chose it over the alternatives. The D-5 implementation review found Membership Manager's Quick Log can save a pause with a blank end, so this is a reachable state, not a typo. |
+| 60 | D2 | Oct 1 | `functions/iam-expectations.json` allows **exactly one** Editor holder: `760301318440@cloudservices.gserviceaccount.com` (the Google APIs Service Agent). Editor held by anyone else, a build account above all, is still a difference. | Google granted it Editor during the first functions deploy (when the CLI turned on the Firebase Extensions API). It's Google-managed, nothing we deploy runs as it, and Google advises against removing its grant. Christie chose to allow it rather than remove it. |
+| 61 | D2 | Oct 1 | **IAM readings only when needed** (replaces "after every deploy"). The functions guard records `attest_needed` and why: needed for an unverified deploy, the first deploy of a codebase, a changed function set, declarations, IAM expectations, `firebase.json` or `.firebaserc`, a Google API turned on during the deploy, or a reading still owed. Otherwise "not needed", naming the attestation it relies on. | Christie asked why each deploy needed so many Console screenshots. The automatic checks (hash, settings, the unauthenticated probe) still run every time. A role changed by hand in the Console isn't seen, so take a reading after one. |
diff --git a/functions/iam-expectations.json b/functions/iam-expectations.json
index f0d0602..f77dd89 100644
--- a/functions/iam-expectations.json
+++ b/functions/iam-expectations.json
@@ -6,7 +6,9 @@
     "roles/owner": [
       "user:Christie@tinkerartstudio.com"
     ],
-    "roles/editor": [],
+    "roles/editor": [
+      "serviceAccount:760301318440@cloudservices.gserviceaccount.com"
+    ],
     "roles/cloudbuild.builds.builder": []
   },
   "buildCandidates": [
diff --git a/scripts/deploy-functions.sh b/scripts/deploy-functions.sh
index 5b3764d..d39b844 100755
--- a/scripts/deploy-functions.sh
+++ b/scripts/deploy-functions.sh
@@ -653,6 +653,47 @@ verifier_fields() {   # <attempt commit> <msg> — F9: record the verifier and w
     printf 'verifier=%s\nverifier_changed=no\n' "$MAIN_SHA" >> "$2"
   fi
 }
+# Whether this deploy needs Christie's IAM reading (Christie, Oct 1 2026: re-read IAM only when something that shapes
+# it changed). FAIL-CLOSED: anything unreadable means "needed". Needed when the deploy isn't verified; when no attempt of
+# this codebase has iam_attested=yes yet; when the function set or a file that decides who may do what (ATTEST_FILES)
+# changed since the newest attested attempt; or when the CLI turned on a Google API during this deploy — Google can add
+# role grants when an API is enabled (D2-5: enabling Firebase Extensions gave the Google APIs Service Agent Editor).
+# Not seen either way: a role someone changes by hand in the Console. Sets ATTEST_NEEDED, ATTEST_WHY; appends to <msg>.
+ATTEST_FILES="functions/declarations.json functions/iam-expectations.json firebase.json .firebaserc"
+API_ENABLED_LINE="Enabling now"
+attest_need() {   # <msg>
+  local why="" rows r a last="" changed owed="" n
+  [ "$DEPLOY_VERIFIED" = yes ] || why="${why}the deploy is not verified; "
+  if [ ! -f "$TRANSCRIPT" ]; then why="${why}no transcript to check for a newly enabled Google API; "
+  elif grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT"; then why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); "
+  fi
+  if ! rows="$(receipt_rows "$ATTEMPT_PREFIX")"; then why="${why}could not read the record of earlier attempts; "
+  else
+    while read -r _ _ r; do
+      [ -n "$r" ] || continue
+      if ! a="$(iam_attested_of "$r" "$ATTEST_PREFIX")"; then why="${why}could not read whether ${r} was attested; "; last=""; break; fi
+      [ "$a" = yes ] && { last="$r"; break; }
+      # A reading owed by a later, unattested attempt stays owed (one with no attest_needed predates this rule).
+      n="$(record_field "$r" attest_needed 2>/dev/null || echo unknown)"
+      [ "$n" = no ] || owed="${owed:-$r}"
+    done <<< "$rows"
+    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading that was never attested yes; "
+    if [ -z "$last" ]; then
+      case "$why" in *"could not read whether"*) ;; *) why="${why}no attempt of ${CB} has iam_attested=yes yet; " ;; esac
+    else
+      # shellcheck disable=SC2086 # ATTEST_FILES is a fixed word list
+      if ! changed="$(git diff --name-only "$(commit_of "$last")" "$SHA" -- $ATTEST_FILES | tr '\n' ' ')"; then
+        why="${why}could not compare with ${last}; "
+      elif [ -n "$changed" ]; then why="${why}changed since ${last}: ${changed% }; "
+      fi
+      [ "$(record_field "$last" functions 2>/dev/null)" = "$IDS" ] || why="${why}the functions differ from ${last}'s; "
+    fi
+  fi
+  if [ -n "$why" ]; then ATTEST_NEEDED=yes; ATTEST_WHY="${why%; }"
+  else ATTEST_NEEDED=no; ATTEST_WHY="last attested ${last}; since then the same functions, no change to ${ATTEST_FILES// /, }, and the CLI enabled no Google API"
+  fi
+  printf 'attest_needed=%s\nattest_needed_why=%s\n' "$ATTEST_NEEDED" "$ATTEST_WHY" >> "$1"
+}
 attest_help() {   # printed after a deploy: what --attest needs, generated from the IAM expectations it is checked against
   say "─── next: Christie's IAM reading, then --attest (F9, M3) ───"
   say "Christie reads, in the Console, and Claude writes into a JSON file exactly this shape (every holder as"
@@ -841,11 +882,17 @@ $(printf '%s\n' "$DRIFT" | sed 's/^/  - /')"
   } > "$MSG"
   read_back "$MSG"
   verifier_fields "$SHA" "$MSG"
+  attest_need "$MSG"
   printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   rm -f "$INFLIGHT"
   [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
-  attest_help
+  if [ "$ATTEST_NEEDED" = yes ]; then
+    say "─── IAM reading NEEDED: ${ATTEST_WHY} ───"
+    attest_help
+  else
+    say "─── IAM reading not needed: ${ATTEST_WHY}. (Christie can still --attest any time, and should after any role change made by hand.) ───"
+  fi
   if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   exit $EX_UNVERIFIED
diff --git a/scripts/deploy-functions.test.sh b/scripts/deploy-functions.test.sh
index e6bf130..03f7a36 100644
--- a/scripts/deploy-functions.test.sh
+++ b/scripts/deploy-functions.test.sh
@@ -114,6 +114,7 @@ case "\${1:-}" in

codex
The commit directly addresses all four prior findings. I’m now tracing the exact control flow and test fixtures for edge cases—especially nonzero `grep`, receipt parsing under `set -e`, and recovery records whose transcript/worktree state is synthetic.
exec
/bin/zsh -lc "nl -ba scripts/deploy-functions.sh | sed -n '640,790p'
nl -ba scripts/deploy-functions.sh | sed -n '790,1040p'
nl -ba scripts/deploy-functions.sh | sed -n '1040,1330p'
nl -ba scripts/deploy-functions.test.sh | sed -n '1,230p'
nl -ba scripts/deploy-functions.test.sh | sed -n '230,520p'
nl -ba scripts/deploy-functions.test.sh | sed -n '520,900p'
nl -ba FUNCTIONS-ROLLBACK.md | sed -n '105,150p'
bash -n scripts/deploy-functions.sh scripts/deploy-functions.test.sh" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
   640	}
   641	verifier_fields() {   # <attempt commit> <msg> — F9: record the verifier and whether the guard's code changed since
   642	  # The checks and verdicts (F8, the probe, the evidence) are this script's — the tip's, proven byte-equal above.
   643	  # Rebuilding an attempt's expected state (--reconcile, --reverify) deliberately uses the ATTEMPT's own backstop,
   644	  # discovery and hash module, because they are what produced the manifest and hash it recorded; their output must then
   645	  # equal those recorded values. The record names both commits, so the provenance is never mixed silently.
   646	  printf 'rebuild_helpers_from=%s\n' "$1" >> "$2"
   647	  local changed
   648	  changed="$(control_file_diff "$1" "$MAIN_SHA")"
   649	  if [ -n "$changed" ]; then
   650	    [ "$ACK" = 1 ] || die $EX_VERIFIER "the guard's machinery changed between the attempt (${1:0:12}) and ${REMOTE}/${BRANCH} (${MAIN_SHA:0:12}), first at ${changed}. The record would be judged by the tip's checks while the expected state is rebuilt with the attempt's own helpers. Once Christie has OK'd that, run again with --acknowledge-verifier-change."
   651	    printf 'verifier=%s\nverifier_changed=yes (%s)\nverifier_change_acknowledged=yes\n' "$MAIN_SHA" "$changed" >> "$2"
   652	  else
   653	    printf 'verifier=%s\nverifier_changed=no\n' "$MAIN_SHA" >> "$2"
   654	  fi
   655	}
   656	# Whether this deploy needs Christie's IAM reading (Christie, Oct 1 2026: re-read IAM only when something that shapes
   657	# it changed). FAIL-CLOSED: anything unreadable means "needed". Needed when the deploy isn't verified; when no attempt of
   658	# this codebase has iam_attested=yes yet; when the function set or a file that decides who may do what (ATTEST_FILES)
   659	# changed since the newest attested attempt; or when the CLI turned on a Google API during this deploy — Google can add
   660	# role grants when an API is enabled (D2-5: enabling Firebase Extensions gave the Google APIs Service Agent Editor).
   661	# Not seen either way: a role someone changes by hand in the Console. Sets ATTEST_NEEDED, ATTEST_WHY; appends to <msg>.
   662	ATTEST_FILES="functions/declarations.json functions/iam-expectations.json firebase.json .firebaserc"
   663	API_ENABLED_LINE="Enabling now"
   664	attest_need() {   # <msg>
   665	  local why="" rows r a last="" changed owed="" n g=0
   666	  [ "${DEPLOY_VERIFIED:-no}" = yes ] || why="${why}the deploy is not verified; "
   667	  if [ ! -f "${TRANSCRIPT:-}" ]; then why="${why}no transcript to check for a newly enabled Google API; "
   668	  else
   669	    grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT" || g=$?
   670	    case "$g" in
   671	      0) why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); " ;;
   672	      1) ;;
   673	      *) why="${why}could not read the transcript to check for a newly enabled Google API; " ;;
   674	    esac
   675	  fi
   676	  if ! rows="$(receipt_rows "$ATTEMPT_PREFIX")"; then why="${why}could not read the record of earlier attempts; "
   677	  else
   678	    while read -r _ _ r; do
   679	      [ -n "$r" ] || continue
   680	      if ! a="$(iam_attested_of "$r" "$ATTEST_PREFIX")"; then why="${why}could not read whether ${r} was attested; "; last=""; break; fi
   681	      [ "$a" = yes ] && { last="$r"; break; }
   682	      # Owed by a later attempt: a reading that came back no (a known mismatch), or one it needed and never got (an
   683	      # attempt with no attest_needed predates this rule and counts as needing one).
   684	      n="$(record_field "$r" attest_needed 2>/dev/null || echo unknown)"
   685	      if [ "$a" != none ] || [ "$n" != no ]; then owed="${owed:-$r}"; fi
   686	    done <<< "$rows"
   687	    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading, or its reading came back no, and nothing since was attested yes; "
   688	    if [ -z "$last" ]; then
   689	      case "$why" in *"could not read whether"*) ;; *) why="${why}no attempt of ${CB} has iam_attested=yes yet; " ;; esac
   690	    else
   691	      # shellcheck disable=SC2086 # ATTEST_FILES is a fixed word list
   692	      if ! changed="$(git diff --name-only "$(commit_of "$last")" "$SHA" -- $ATTEST_FILES | tr '\n' ' ')"; then
   693	        why="${why}could not compare with ${last}; "
   694	      elif [ -n "$changed" ]; then why="${why}changed since ${last}: ${changed% }; "
   695	      fi
   696	      [ "$(record_field "$last" functions 2>/dev/null)" = "$IDS" ] || why="${why}the functions differ from ${last}'s; "
   697	    fi
   698	  fi
   699	  if [ -n "$why" ]; then ATTEST_NEEDED=yes; ATTEST_WHY="${why%; }"
   700	  else ATTEST_NEEDED=no; ATTEST_WHY="last attested ${last}; since then the same functions, no change to ${ATTEST_FILES// /, }, and the CLI enabled no Google API"
   701	  fi
   702	  printf 'attest_needed=%s\nattest_needed_why=%s\n' "$ATTEST_NEEDED" "$ATTEST_WHY" >> "$1"
   703	}
   704	attest_report() {   # after a record is written: say whether Christie's IAM reading is needed, and why
   705	  if [ "$ATTEST_NEEDED" = yes ]; then
   706	    say "─── IAM reading NEEDED: ${ATTEST_WHY} ───"
   707	    attest_help
   708	  else
   709	    say "─── IAM reading not needed: ${ATTEST_WHY}. (Christie can still --attest any time, and should after any role change made by hand.) ───"
   710	  fi
   711	}
   712	attest_help() {   # printed after a deploy: what --attest needs, generated from the IAM expectations it is checked against
   713	  say "─── next: Christie's IAM reading, then --attest (F9, M3) ───"
   714	  say "Christie reads, in the Console, and Claude writes into a JSON file exactly this shape (every holder as"
   715	  say "\"user:…\" or \"serviceAccount:…\"; each list complete, as read):"
   716	  "$JQ" --arg ids "$IDS" '{
   717	      functions: ($ids | split(",") | map({key: ., value: {buildId: "<Cloud Build → History → the build id>", buildStatus: "<its status>",
   718	        latestReadyRevision: "<Cloud Run → the service → latest ready revision>", requireAuthentication: "<true|false, Security tab>",
   719	        runInvokerMembers: ["<every run.invoker member, Permissions tab>"]}}) | from_entries),
   720	      projectRoles: (.projectRoles | map_values(["<every holder, IAM → View by roles>"])),
   721	      buildRoleBindings: (.buildRoleBindings | map_values([{member: "<one entry per binding row, IAM → View by roles>",
   722	        condition: "<its condition expression as the Console shows it, or null when the row has none>"}])),
   723	      artifactRegistryWriters: {repository: ["<direct Artifact Registry Writer holders on \(.artifactRegistryWriterOn)>"],
   724	        project: ["<project-level holders of roles/artifactregistry.writer, IAM → View by roles>"]},
   725	      runtimeAccounts: (.runtimeAccounts | map_values(["<its project roles>"])),
   726	      buildAccount: "<Cloud Build → History → the build service account, the email only>" }' \
   727	    <(if [ -n "${TMP:-}" ] && [ -f "${TMP}/functions/iam-expectations.json" ]; then cat "${TMP}/functions/iam-expectations.json"
   728	      else git show "${MAIN_SHA}:functions/iam-expectations.json"; fi)   # --clear-inflight has no worktree: the tip's file
   729	  say "(Not read, and so not attested: folder- and organization-level grants, and grants on individual Cloud Storage buckets or managed folders.)"
   730	  say "then:  $0 --attest ${TAG:-<attempt>} --codebase ${CB} --evidence <file>"
   731	}
   732	
   733	# ─── --status / --diff ─────────────────────────────────────────────────────────────────────────────────
   734	# Read-only. The newest attempt (by stamp, attempt tags only), and the newest attempt whose deploy_verified is yes.
   735	record_state() {   # sets NEWEST, NEWEST_VERIFIED, NEWEST_ATTESTED, LAST_VERIFIED
   736	  local rows r v
   737	  rows="$(receipt_rows "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB} — refusing to guess what shipped."
   738	  NEWEST="$(printf '%s\n' "$rows" | awk 'NR==1{printf "%s", $3}')"
   739	  NEWEST_VERIFIED=""; NEWEST_ATTESTED=""; LAST_VERIFIED=""
   740	  [ -n "$NEWEST" ] || return 0
   741	  NEWEST_VERIFIED="$(deploy_verified_of "$NEWEST" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${NEWEST} — refusing to guess."
   742	  NEWEST_ATTESTED="$(iam_attested_of "$NEWEST" "$ATTEST_PREFIX")" || die $EX_RECORD "could not read iam_attested for ${NEWEST} — refusing to guess."
   743	  while read -r _ _ r; do
   744	    v="$(deploy_verified_of "$r" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${r} — refusing to guess."
   745	    if [ "$v" = yes ]; then LAST_VERIFIED="$r"; break; fi
   746	  done <<< "$rows"
   747	}
   748	commit_of() { local c; c="$(receipt_commit "$1")" || die $EX_RECORD "the record ${1} is in the record but its commit could not be resolved."; printf '%s' "$c"; }
   749	
   750	if [ "$MODE" = "status" ] || [ "$MODE" = "diff" ]; then
   751	  if ! fetch_state >/dev/null; then warn "could not fetch ${REMOTE}/${BRANCH} and the records; showing the last-known state"; fi
   752	  MAIN_SHA="$(git rev-parse --quiet --verify "${REMOTE}/${BRANCH}^{commit}" 2>/dev/null || true)"
   753	  [ -n "$MAIN_SHA" ] || die $EX_FETCH "${REMOTE}/${BRANCH} has never been fetched here and ${REMOTE} is unreachable."
   754	  codebase_on_tip
   755	  record_state
   756	  if [ "$MODE" = "diff" ]; then
   757	    if [ -n "$NEWEST" ] && [ "$NEWEST" != "$LAST_VERIFIED" ]; then
   758	      say "════ NOTE: the newest attempt ${NEWEST} is NOT verified — production may differ from both sides of this diff ════"
   759	    fi
   760	    if [ -z "$LAST_VERIFIED" ]; then
   761	      say "(no verified attempt yet for ${CB} — showing everything that would ship, at ${REMOTE}/${BRANCH} ${MAIN_SHA:0:12})"
   762	      BASE="$EMPTY_TREE"
   763	    else
   764	      BASE="$(commit_of "$LAST_VERIFIED")"
   765	      say "(diff from the last verified attempt ${LAST_VERIFIED} (${BASE:0:12}) to ${REMOTE}/${BRANCH} ${MAIN_SHA:0:12})"
   766	    fi
   767	    say "─── firebase.json entry for ${CB} at ${MAIN_SHA:0:12} ───"
   768	    git show "${MAIN_SHA}:firebase.json" | "$JQ" --arg cb "$CB" '.functions[] | select(.codebase == $cb)'
   769	    show_machinery "$BASE" "$MAIN_SHA"
   770	    # shellcheck disable=SC2086
   771	    if git diff --quiet "$BASE" "$MAIN_SHA" -- $SHOWN_PATHS; then say "(no change to ${SHOWN_PATHS} since ${LAST_VERIFIED})"; exit 0; fi
   772	    # shellcheck disable=SC2086
   773	    git --no-pager diff "$BASE" "$MAIN_SHA" -- $SHOWN_PATHS
   774	    exit 0
   775	  fi
   776	  say "project:         ${PROJECT}"
   777	  say "codebase:        ${CB}  (${SRC})"
   778	  if [ -f "$INFLIGHT" ]; then
   779	    if inflight_valid; then
   780	      say "IN FLIGHT:       $(inflight_get attempt) (commit $(inflight_get commit | cut -c1-12)) — a deploy was interrupted, or is running. The next --approved refuses; see FUNCTIONS-ROLLBACK.md §2."
   781	    else
   782	      say "IN FLIGHT:       ${INFLIGHT} exists but is MALFORMED — the next --approved refuses; see FUNCTIONS-ROLLBACK.md §2."
   783	    fi
   784	  fi
   785	  [ -f "$PENDING" ] && say "pending record:  $(cut -d' ' -f1 "$PENDING") was not pushed — the next run publishes it first."
   786	  if [ -z "$NEWEST" ]; then
   787	    say "newest attempt:  none — no guarded deploy of ${CB} yet"
   788	  else
   789	    NC="$(commit_of "$NEWEST")"
   790	    say "newest attempt:  ${NEWEST}$(receipt_note "$NEWEST")"
   790	    say "newest attempt:  ${NEWEST}$(receipt_note "$NEWEST")"
   791	    say "  commit:        ${NC}  $(git log -1 --format='%s' "$NC")"
   792	    say "  deploy_verified=${NEWEST_VERIFIED}  iam_attested=${NEWEST_ATTESTED}"
   793	    say "  attest_needed=$(record_word "$NEWEST" attest_needed "yes no" 2>/dev/null || echo "unknown (recorded before Oct 1 2026, so treated as needed)")$(w="$(record_field "$NEWEST" attest_needed_why 2>/dev/null)" && [ -n "$w" ] && printf ' — %s' "$w")"
   794	    if [ "$NEWEST_VERIFIED" = yes ]; then
   795	      say "state:           verified at ${NEWEST}"
   796	    elif [ "$(record_word "$NEWEST" functions_unchanged "yes no unknown" 2>/dev/null || echo unknown)" = yes ]; then
   797	      say "state:           functions unchanged by ${NEWEST} — production is still what $( [ -n "$LAST_VERIFIED" ] && echo "${LAST_VERIFIED} verified" || echo "was there before (no verified attempt yet)")"
   798	    else
   799	      say "state:           production may be mixed: last verified ${LAST_VERIFIED:-(none yet)}; unverified attempt ${NEWEST}"
   800	    fi
   801	  fi
   802	  say "${REMOTE}/${BRANCH}:     ${MAIN_SHA}  $(git log -1 --format='%s' "$MAIN_SHA")"
   803	  D="$(dirty_files)"; [ -n "$D" ] && warn "the shared tree has uncommitted changes (not what ships): $(echo "$D" | tr '\n' ' ')"
   804	  say ""
   805	  say "To deploy ${REMOTE}/${BRANCH}, run --diff and paste it; then Christie says exactly:"
   806	  say "    approved to change firebase ${MAIN_SHA}"
   807	  say "then run:  $0 --approved ${MAIN_SHA} --codebase ${CB}"
   808	  exit 0
   809	fi
   810	
   811	# ─── Every tag-writing mode: preflight, lock, fetch, the pending record, the verifier ──────────────────
   812	preflight
   813	take_lock
   814	trap cleanup EXIT
   815	WORK="$(mktemp -d "${TMPDIR:-/tmp}/tinker-functions.XXXXXX")"   # private to this run; removed on exit
   816	chmod 700 "$WORK"
   817	fetch_or_die
   818	publish_pending
   819	verifier_is_tip
   820	codebase_on_tip
   821	mkdir -p "$TRANSCRIPTS"
   822	
   823	# ─── --approved ────────────────────────────────────────────────────────────────────────────────────────
   824	if [ "$MODE" = "approved" ]; then
   825	  [ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an earlier deploy was interrupted (or is running). Nothing was deployed. Reconcile it first (FUNCTIONS-ROLLBACK.md §2)."
   826	  SHA="$(printf '%s' "$SHA_ARG" | tr 'A-F' 'a-f')"
   827	  [[ "$SHA" =~ ^[0-9a-f]{40}$ ]] || die $EX_USAGE "--approved needs the FULL 40-character sha Christie named (run --status to see it). Got '${SHA_ARG}'."
   828	  [ "$(git rev-parse --verify --quiet "${SHA}^{commit}" 2>/dev/null || true)" = "$SHA" ] || die $EX_USAGE "${SHA} is not a commit in this repository."
   829	  git merge-base --is-ancestor "$SHA" "$MAIN_SHA" || die $EX_NOT_ON_MAIN "${SHA:0:12} is not on ${REMOTE}/${BRANCH}. Land it on ${BRANCH} and push first."
   830	  CF="$(control_file_diff "$SHA" "$MAIN_SHA")"
   831	  [ -z "$CF" ] || die $EX_NOT_ON_MAIN "${SHA:0:12} carries a different ${CF} than ${REMOTE}/${BRANCH} — the deploy machinery must be the tip's. To roll back, restore ${SRC} onto a NEW commit on ${BRANCH} (FUNCTIONS-ROLLBACK.md §1)."
   832	  D="$(dirty_files)"; [ -n "$D" ] && warn "the shared tree has uncommitted changes — they are NOT being deployed: $(echo "$D" | tr '\n' ' ')"
   833	
   834	  say "═══ guarded functions deploy ═══"
   835	  say "project:   ${PROJECT}"
   836	  say "codebase:  ${CB}  (${SRC})"
   837	  say "commit:    ${SHA}  $(git log -1 --format='%s' "$SHA")"
   838	  build_expected "$SHA"
   839	  say "manifest:  ${MSHA}  (functions: ${IDS})"
   840	
   841	  say "─── npm test (in ${TMP}; the functions suites required) ───"
   842	  (cd "$TMP" && TINKER_FUNCTIONS_TESTS=required npm22 test) || die $EX_TESTS "tests failed on ${SHA:0:12}; nothing was deployed."
   843	
   844	  reserve_stamp "$ATTEMPT_PREFIX" "${SHA:0:7}"
   845	  record_state
   846	  if [ -z "$LAST_VERIFIED" ]; then
   847	    say "replaces:  (no verified attempt yet for ${CB} — everything below is new to the record)"; BASE="$EMPTY_TREE"
   848	  else
   849	    BASE="$(commit_of "$LAST_VERIFIED")"; say "replaces:  ${LAST_VERIFIED} (${BASE:0:12})$(receipt_note "$LAST_VERIFIED")"
   850	  fi
   851	  [ -n "$NEWEST" ] && [ "$NEWEST" != "$LAST_VERIFIED" ] && say "NOTE:      the newest attempt ${NEWEST} is not verified; production may be mixed."
   852	  show_machinery "$BASE" "$SHA"
   853	  say "─── diff ${BASE:0:12} → ${SHA:0:12} ───"
   854	  # shellcheck disable=SC2086
   855	  git --no-pager diff "$BASE" "$SHA" -- $SHOWN_PATHS || true
   856	  say "─── end diff ───"
   857	
   858	  # Production before: the snapshot, F6 and the drift check — all before the in-flight file and the CLI.
   859	  BEFORE="${WORK}/before.json"
   860	  list_live "$TMP" "$BEFORE" || die $EX_FETCH "could not read production (functions:list): $(list_why "$BEFORE") — nothing was deployed."
   861	  BEFORE_DIGEST="$(digest_of "$BEFORE")"
   862	  DRIFT="$("$JQ" -r --arg cb "$CB" --argjson envkeys "$ENV_KEYS" --argjson ids "$IDS_JSON" "$JQ_DRIFT" "$BEFORE" 2>&1)" \
   863	    || die $EX_DRIFT "could not check production for drift: ${DRIFT}"
   864	  [ -z "$DRIFT" ] || die $EX_DRIFT "production has something this deploy would carry over or can't handle — NOTHING WAS DEPLOYED:
   865	$(printf '%s\n' "$DRIFT" | sed 's/^/  - /')"
   866	
   867	  # The in-flight file (F9): written atomically BEFORE the CLI, so a crash from here on leaves an honest trace.
   868	  TRANSCRIPT="${TRANSCRIPTS}/functions-${CB}-${STAMP}-${SHA:0:7}.log"
   869	  {
   870	    printf 'format=tinker-functions-inflight-1\ncodebase=%s\nattempt=%s\nstamp=%s\ncommit=%s\ntree=%s\n' "$CB" "$TAG" "$STAMP" "$SHA" "$TREE"
   871	    printf 'manifest_sha256=%s\nbefore_digest=%s\nfunctions=%s\ntranscript=%s\nverifier=%s\n' "$MSHA" "$BEFORE_DIGEST" "$IDS" "$TRANSCRIPT" "$MAIN_SHA"
   872	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   873	      printf 'expected_hash.%s=%s\n' "$id" "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")"
   874	      printf 'before_hash.%s=%s\n' "$id" "$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "none"' "$BEFORE")"
   875	    done
   876	  } | atomic_write "$INFLIGHT" || die $EX_INFLIGHT "could not write ${INFLIGHT} — nothing was deployed."
   877	  inflight_valid || die $EX_INFLIGHT "${INFLIGHT} did not read back as written — nothing was deployed; remove it by hand."
   878	
   879	  # The CLI. TINKER_DEPLOY_* are exported, never inline (K15). Never --force.
   880	  say "─── firebase deploy --only functions:${CB} --project ${PROJECT} (in ${TMP}) ───"
   881	  set +e
   882	  (
   883	    export TINKER_DEPLOY_SHA="$SHA" TINKER_DEPLOY_CODEBASE="$CB" TINKER_DEPLOY_MANIFEST_PATH="$MPATH" TINKER_DEPLOY_MANIFEST_SHA256="$MSHA"
   884	    cli "$TMP" deploy --only "functions:${CB}" --project "$PROJECT" --non-interactive
   885	  ) 2>&1 | tee "$TRANSCRIPT"
   886	  CLI_EXIT="${PIPESTATUS[0]}"
   887	  set -e
   888	  { cat "$INFLIGHT"; printf 'cli_exit=%s\n' "$CLI_EXIT"; } | atomic_write "$INFLIGHT" || warn "could not add cli_exit to ${INFLIGHT} (a --reconcile will record cli_exit=unknown)"
   889	  transcript_flags "$TRANSCRIPT" "$SHA"
   890	  say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
   891	
   892	  MSG="${WORK}/record"
   893	  {
   894	    printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$TREE"
   895	    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
   896	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   897	      printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
   898	    done
   899	    printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   900	  } > "$MSG"
   901	  read_back "$MSG"
   902	  verifier_fields "$SHA" "$MSG"
   903	  attest_need "$MSG"
   904	  printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   905	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   906	  rm -f "$INFLIGHT"
   907	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   908	  attest_report
   909	  if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   910	  printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   911	  exit $EX_UNVERIFIED
   912	fi
   913	
   914	# ─── --reconcile / --clear-inflight ────────────────────────────────────────────────────────────────────
   915	if [ "$MODE" = "reconcile" ] || [ "$MODE" = "clear-inflight" ]; then
   916	  [ -f "$INFLIGHT" ] || die $EX_INFLIGHT "there is no in-flight file (${INFLIGHT}) — nothing to reconcile."
   917	  inflight_valid || die $EX_INFLIGHT "${INFLIGHT} is malformed (truncated, or edited) — refusing to guess what it recorded. Show it to Christie; FUNCTIONS-ROLLBACK.md §2."
   918	  [ "$(inflight_get codebase)" = "$CB" ] || die $EX_INFLIGHT "the in-flight attempt is for codebase $(inflight_get codebase), not ${CB}."
   919	  TAG="$(inflight_get attempt)"; STAMP="$(inflight_get stamp)"; SHA="$(inflight_get commit)"; IDS="$(inflight_get functions)"
   920	  if [ "$MODE" = "clear-inflight" ] && [ "$ATTEMPT_ARG" != "$TAG" ]; then
   921	    die $EX_INFLIGHT "the in-flight attempt is ${TAG}, not ${ATTEMPT_ARG} — name it exactly."
   922	  fi
   923	  IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
   924	  [ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
   925	  "$JQ" -e --argjson ids "$IDS_JSON" --arg mode "$([ "$MODE" = reconcile ] && echo reconcile || echo clear)" "$JQ_EVIDENCE_OP" "$EVIDENCE" >/dev/null 2>&1 \
   926	    || die $EX_EVIDENCE "the evidence is not in the fixed shape: {\"confirmation\": \"<Christie's words>\", \"functions\": {\"<id>\": {\"buildId\": \"<uuid>\", \"buildStatus\": \"<status>\", \"latestReadyRevision\": \"<id>-000NN-xxx\"$([ "$MODE" = clear-inflight ] && echo ' (or null)')}}} for exactly ${IDS}$([ "$MODE" = reconcile ] && echo ', with a finished build')."
   927	  EVJSON="$("$JQ" -c . "$EVIDENCE")"
   928	  if git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null 2>&1; then
   929	    die $EX_INFLIGHT "the record ${TAG} already exists, so the attempt was recorded before the in-flight file could be removed. Check it (git show ${TAG}); if it names ${SHA:0:12}, remove ${INFLIGHT} by hand with Christie's OK."
   930	  fi
   931	  MSG="${WORK}/record"
   932	  CLI_EXIT="$(inflight_get cli_exit 2>/dev/null || echo unknown)"
   933	  {
   934	    printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$(inflight_get tree)"
   935	    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$(inflight_get manifest_sha256)" "$IDS" "$(inflight_get before_digest)"
   936	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   937	      printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
   938	    done
   939	  } > "$MSG"
   940	
   941	  if [ "$MODE" = "clear-inflight" ]; then
   942	    MSHA="$(inflight_get manifest_sha256)"; TREE="$(inflight_get tree)"
   943	    transcript_flags "$(inflight_get transcript)" "$SHA"
   944	    {
   945	      printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   946	      printf 'after_digest=unknown\nfunctions_unchanged=unknown\ndeploy_match=unknown\naccess=not-probed\ndeploy_verified=no\n'
   947	      printf 'evidence=%s\n' "$EVJSON"
   948	    } >> "$MSG"
   949	    verifier_fields "$SHA" "$MSG"
   950	    DEPLOY_VERIFIED=no; TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
   951	    printf 'at=%s\nby=deploy-functions.sh --clear-inflight\n' "$STAMP" >> "$MSG"
   952	    PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   953	    rm -f "$INFLIGHT"
   954	    [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   955	    attest_report
   956	    say "✔ cleared: ${TAG} recorded with deploy_match=unknown (its original stamp). Production is NOT verified; the next --approved may run."
   957	    exit 0
   958	  fi
   959	
   960	  # --reconcile: rebuild the expected state from the attempt's commit and prove it's the same manifest and hashes.
   961	  verifier_fields "$SHA" "$MSG"   # refuses early (before the rebuild) if the machinery changed and Christie hasn't OK'd it
   962	  build_expected "$SHA"
   963	  [ "$MSHA" = "$(inflight_get manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the one the attempt sealed ($(inflight_get manifest_sha256)) — refusing to verify against a different manifest."
   964	  [ "$TREE" = "$(inflight_get tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   965	  [ "$IDS" = "$(inflight_get functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   966	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   967	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(inflight_get "expected_hash.${id}")" ] \
   968	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one recorded before the CLI call."
   969	  done
   970	  NOW="${WORK}/now.json"
   971	  list_live "$TMP" "$NOW" || die $EX_FETCH "could not read production (functions:list): $(list_why "$NOW") — try again."
   972	  DEPLOYING="$("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb and .state == "DEPLOYING") | .id] | join(",")' "$NOW")"
   973	  [ -z "$DEPLOYING" ] || die $EX_INFLIGHT "${DEPLOYING} still DEPLOYING — the operation hasn't finished; wait, then reconcile."
   974	  BEFORE_DIGEST="$(inflight_get before_digest)"
   975	  transcript_flags "$(inflight_get transcript)" "$SHA"
   976	  printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN" >> "$MSG"
   977	  read_back "$MSG"
   978	  TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
   979	  printf 'evidence=%s\nat=%s\nby=deploy-functions.sh --reconcile\n' "$EVJSON" "$STAMP" >> "$MSG"
   980	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   981	  rm -f "$INFLIGHT"
   982	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   983	  attest_report
   984	  say "✔ reconciled: ${TAG} recorded with its original stamp; deploy_verified=${DEPLOY_VERIFIED}."
   985	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   986	  exit $EX_UNVERIFIED
   987	fi
   988	
   989	# ─── --reverify / --attest: only for the newest attempt ────────────────────────────────────────────────
   990	[ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an interrupted deploy comes first (FUNCTIONS-ROLLBACK.md §2)."
   991	NEWEST="$(latest_receipt "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB}."
   992	[ -n "$NEWEST" ] || die $EX_NOT_NEWEST "there is no attempt for ${CB} yet."
   993	[ "$ATTEMPT_ARG" = "$NEWEST" ] || die $EX_NOT_NEWEST "${ATTEMPT_ARG} is not the newest attempt (${NEWEST}). Today's production can only speak for the attempt that put it there."
   994	SHA="$(commit_of "$NEWEST")"
   995	for k in commit manifest_sha256 functions tree; do
   996	  record_field "$NEWEST" "$k" >/dev/null || die $EX_RECORD "the attempt ${NEWEST} has no readable ${k} — refusing."
   997	done
   998	[ "$(record_field "$NEWEST" commit)" = "$SHA" ] || die $EX_RECORD "the attempt ${NEWEST} names a different commit than it points at."
   999	IDS="$(record_field "$NEWEST" functions)"
  1000	IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
  1001	MSG="${WORK}/record"
  1002	
  1003	if [ "$MODE" = "reverify" ]; then
  1004	  : > "$MSG"
  1005	  verifier_fields "$SHA" "$MSG"
  1006	  CLI_EXIT="$(record_field "$NEWEST" cli_exit)" || die $EX_RECORD "the attempt ${NEWEST} has no readable cli_exit."
  1007	  BACKSTOP_SEEN="$(record_word "$NEWEST" backstop_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable backstop_seen."
  1008	  SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
  1009	  BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
  1010	  build_expected "$SHA"
  1011	  [ "$MSHA" = "$(record_field "$NEWEST" manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the attempt's."
  1012	  [ "$TREE" = "$(record_field "$NEWEST" tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
  1013	  [ "$IDS" = "$(record_field "$NEWEST" functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
  1014	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
  1015	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
  1016	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
  1017	  done
  1018	  reserve_stamp "$VERIFY_PREFIX" "${SHA:0:7}"
  1019	  VMSG="${WORK}/verify"
  1020	  {
  1021	    printf 'format=tinker-functions-verify-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
  1022	    printf 'carried=cli_exit=%s backstop_seen=%s skip_line_seen=%s (from the attempt)\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
  1023	  } > "$VMSG"
  1024	  read_back "$VMSG"
  1025	  cat "$MSG" >> "$VMSG"
  1026	  printf 'at=%s\nby=deploy-functions.sh --reverify\n' "$STAMP" >> "$VMSG"
  1027	  write_record "$TAG" "$SHA" "$VMSG" || exit $EX_RECEIPT
  1028	  say "✔ verify record ${TAG} for ${NEWEST}: deploy_verified=${DEPLOY_VERIFIED}."
  1029	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
  1030	  exit $EX_UNVERIFIED
  1031	fi
  1032	
  1033	# --attest
  1034	[ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
  1035	"$JQ" -e "$JQ_ATTEST_SHAPE" "$EVIDENCE" >/dev/null 2>&1 \
  1036	  || die $EX_EVIDENCE "the IAM reading is not in the fixed shape (see the --attest instructions a deploy prints, and FUNCTIONS-ROLLBACK.md)."
  1037	: > "$MSG"
  1038	verifier_fields "$SHA" "$MSG"
  1039	DC="$(git show "${SHA}:functions/declarations.json" | "$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries')" \
  1040	  || die $EX_RECORD "could not read the attempt's declarations."
  1040	  || die $EX_RECORD "could not read the attempt's declarations."
  1041	IAM="$(git show "${SHA}:functions/iam-expectations.json" | "$JQ" -c .)" || die $EX_RECORD "could not read the attempt's functions/iam-expectations.json."
  1042	[ "$(printf '%s' "$IAM" | "$JQ" -r .project)" = "$PROJECT" ] || die $EX_CONFIG "functions/iam-expectations.json is not for ${PROJECT}."
  1043	REASONS="$("$JQ" -r --argjson ids "$IDS_JSON" --argjson dc "$DC" --argjson iam "$IAM" --arg pn "$PROJECT_NUMBER" "$JQ_ATTEST" "$EVIDENCE" 2>&1)" \
  1044	  || die $EX_EVIDENCE "could not compare the reading: ${REASONS}"
  1045	if [ -z "$REASONS" ]; then IAM_ATTESTED=yes; else IAM_ATTESTED=no; fi
  1046	reserve_stamp "$ATTEST_PREFIX" "${SHA:0:7}"
  1047	AMSG="${WORK}/attest"
  1048	{
  1049	  printf 'format=tinker-functions-attest-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
  1050	  printf 'iam_attested=%s\n' "$IAM_ATTESTED"
  1051	  if [ -n "$REASONS" ]; then printf 'mismatch=%s\n' "$(printf '%s' "$REASONS" | tr '\n' '|')"; fi
  1052	  printf 'evidence=%s\n' "$("$JQ" -c . "$EVIDENCE")"
  1053	  printf 'not_attested=folder- and organization-level grants (Christie cannot read them); grants on individual Cloud Storage buckets or managed folders (not on the IAM project page; outside what --attest reads, Christie Sep 30)\n'
  1054	} > "$AMSG"
  1055	cat "$MSG" >> "$AMSG"
  1056	printf 'at=%s\nby=deploy-functions.sh --attest\n' "$STAMP" >> "$AMSG"
  1057	say "─── IAM reading for ${NEWEST} ───"
  1058	[ -z "$REASONS" ] || printf '%s\n' "$REASONS" | sed 's/^/  - /'
  1059	write_record "$TAG" "$SHA" "$AMSG" || exit $EX_RECEIPT
  1060	say "iam_attested=${IAM_ATTESTED} for ${NEWEST}."
  1061	[ "$IAM_ATTESTED" = yes ] && exit 0
  1062	exit $EX_UNVERIFIED
     1	#!/bin/bash
     2	# Tests for scripts/deploy-functions.sh (D2-3) — every refusal and every deploy_verified=no path is a test.
     3	#
     4	# Builds a throwaway bare "origin" and a clone that looks like my-clay-hub, and copies the guard in with its pinned
     5	# REPO, NODE22, NPM22_CLI and CURL lines rewritten to fakes:
     6	#   - a fake Node 22 that answers --version, runs `-e` on the real node (the in-flight file's fsync), and dispatches
     7	#     the pinned npm, the pinned CLI and the discovery script to fakes;
     8	#   - a fake CLI: functions:list serves a scenario "production" ($SC/live.json); deploy runs the REAL backstop
     9	#     (scripts/predeploy-check.sh functions, pinned to the clone) exactly as firebase-tools' hook runner would, then
    10	#     "deploys" the sealed manifest it finds;
    11	#   - a fake discovery that writes the scenario manifest and a deterministic stand-in for the CLI's hash (bytes only,
    12	#     like the real one; the real hash is tested in tests/unit/functions-hash.test.js);
    13	#   - a fake curl for the probe, and a fake `sleep` that skips the probe's 10 s waits.
    14	# The real scripts/predeploy-check.sh, scripts/lib/receipts.sh and scripts/deploy-rules.sh run unmodified (REPO only).
    15	# Scenario switches are FILES under $SC, because discovery runs under `env -i`. Nothing here touches the real repo,
    16	# the real CLI, Google or the network. Run: npm run test:functions-guard   (also part of npm test)
    17	# The standing rules of scripts/deploy-rules.test.sh apply here: assert VALUES (names, fields, exit codes), never
    18	# that two orderings agree.
    19	set -uo pipefail
    20	
    21	HERE="$(cd "$(dirname "$0")" && pwd)"
    22	ROOT="$(cd "$HERE/.." && pwd)"
    23	T="$(mktemp -d "${TMPDIR:-/tmp}/functions-guard-test.XXXXXX")"
    24	T="$(cd "$T" && pwd -P)"
    25	trap 'rm -rf "$T"' EXIT
    26	SC="$T/sc"; mkdir -p "$SC" "$T/bin" "$T/tmpdir"
    27	export TMPDIR="$T/tmpdir"   # every worktree the guard makes lands in here
    28	
    29	PASS=0; FAIL=0
    30	ok()   { PASS=$((PASS+1)); printf '  ✓ %s\n' "$1"; }
    31	bad()  { FAIL=$((FAIL+1)); printf '  ✗ %s\n      %s\n' "$1" "$2"; }
    32	assert_eq()   { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "expected [$3] got [$2]"; fi; }
    33	assert_has()  { if printf '%s' "$2" | grep -qF -- "$3"; then ok "$1"; else bad "$1" "output lacks [$3]:"$'\n'"$(printf '%s' "$2" | tail -25)"; fi; }
    34	assert_lacks(){ if printf '%s' "$2" | grep -qF -- "$3"; then bad "$1" "output has [$3]"; else ok "$1"; fi; }
    35	
    36	REAL_NODE="$(command -v node)"
    37	REAL_GIT="$(command -v git)"
    38	JQ=/usr/bin/jq
    39	
    40	# ─── fakes ─────────────────────────────────────────────────────────────────────────────────────────────
    41	cat > "$T/bin/node22" <<EOF
    42	#!/bin/bash
    43	case "\${1:-}" in
    44	  --version) cat "$SC/node_version" 2>/dev/null || echo v22.23.3; exit 0 ;;
    45	  -e) exec "$REAL_NODE" "\$@" ;;
    46	esac
    47	case "\$(basename "\${1:-}")" in
    48	  npm-cli.js)             shift; exec bash "$T/fake-npm.sh" "\$@" ;;
    49	  firebase.js)            shift; exec bash "$T/fake-cli.sh" "\$@" ;;
    50	  functions-discover.mjs) shift; exec bash "$T/fake-discover.sh" "\$@" ;;
    51	esac
    52	exec "$REAL_NODE" "\$@"
    53	EOF
    54	cat > "$T/fake-npm.sh" <<EOF
    55	#!/bin/bash
    56	SC="$SC"
    57	echo "npm \$* cwd=\$PWD" >> "\$SC/log"
    58	case "\${1:-}" in
    59	  --version) cat "\$SC/npm_version" 2>/dev/null || echo 10.9.9 ;;
    60	  ci) [ -f "\$SC/npm_ci_fail" ] && exit 1
    61	      mkdir -p "\$3/node_modules/.bin" "\$3/node_modules/firebase-functions"; : > "\$3/node_modules/.bin/firebase-functions" ;;
    62	  test) [ -f "\$SC/npm_test_fail" ] && exit 1
    63	        echo "npm-test TINKER_FUNCTIONS_TESTS=\${TINKER_FUNCTIONS_TESTS:-<unset>}" >> "\$SC/log" ;;
    64	esac
    65	exit 0
    66	EOF
    67	# The stand-in hash: sha1 over the sorted per-file sha1s of the folder (node_modules and functions.yaml left out, as the
    68	# CLI's ignore list does), plus the FIREBASE_CONFIG string. Bytes only, like the real one: a rename or a chmod keeps it.
    69	cat > "$T/hash.sh" <<'EOF'
    70	src_hash() { (cd "$1" && find . -path ./node_modules -prune -o -type f ! -name functions.yaml -print | LC_ALL=C sort \
    71	              | while read -r f; do shasum -a 1 "$f" | cut -d' ' -f1; done | LC_ALL=C sort | tr -d '\n' | shasum -a 1 | cut -d' ' -f1); }
    72	fake_hash() { printf '%s%s' "$(src_hash "$1")" "$2" | shasum -a 1 | cut -d' ' -f1; }
    73	EOF
    74	cat > "$T/fake-discover.sh" <<EOF
    75	#!/bin/bash
    76	SC="$SC"; . "$T/hash.sh"
    77	echo "discover HOME=\$HOME GAC=\${GOOGLE_APPLICATION_CREDENTIALS:-<unset>} \$*" >> "\$SC/log"
    78	while [ \$# -gt 0 ]; do case "\$1" in --source) S="\$2";; --out) O="\$2";; --firebase-config) F="\$2";; esac; shift 2; done
    79	[ -f "\$SC/discover_fail" ] && { echo "functions-discover: REFUSED — simulated" >&2; exit 2; }
    80	cp "\$SC/manifest.json" "\$O/functions.yaml"
    81	OUTREAL="\$(cd "\$O" && pwd -P)"
    82	cfg="\$(/usr/bin/jq -c . "\$F")"
    83	h="\$(fake_hash "\$S" "\$cfg")"
    84	/usr/bin/jq -c --arg path "\$OUTREAL/functions.yaml" --arg sha "\$(shasum -a 256 "\$O/functions.yaml" | cut -d' ' -f1)" \
    85	   --arg cfg "\$cfg" --arg h "\$h" --arg rt "\$(cat "\$SC/runtime" 2>/dev/null || echo nodejs22)" \
    86	   --argjson params "\$(cat "\$SC/params" 2>/dev/null || echo '[]')" '
    87	  { firebaseFunctionsVersion: "7.4.0", manifestPath: \$path, manifestSha256: \$sha, manifest: .,
    88	    build: { params: \$params, endpoints: (.endpoints | map_values({runtime: \$rt})) },
    89	    firebaseConfigEnv: \$cfg, sourceHash: "x", expectedHashes: (.endpoints | map_values(\$h)) }' "\$SC/manifest.json"
    90	EOF
    91	cat > "$T/fake-cli.sh" <<EOF
    92	#!/bin/bash
    93	SC="$SC"; . "$T/hash.sh"
    94	echo "cli \$* cwd=\$PWD" >> "\$SC/log"
    95	case "\${1:-}" in
    96	  --version) cat "\$SC/cli_version" 2>/dev/null || echo 15.22.3; exit 0 ;;
    97	  functions:list)
    98	    echo x >> "\$SC/list_calls"; n="\$(wc -l < "\$SC/list_calls" | tr -d ' ')"
    99	    if [ -f "\$SC/list_block_\$n" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
   100	    mode="\$(cat "\$SC/list_mode_\$n" 2>/dev/null || echo ok)"
   101	    case "\$mode" in
   102	      error) echo '{"status":"error","error":"simulated list failure"}'; exit 1 ;;
   103	      malformed) printf '{"status":"success","result":'; exit 0 ;;
   104	    esac
   105	    /usr/bin/jq -c '{status: "success", result: .}' "\$SC/live.json"; exit 0 ;;
   106	  deploy)
   107	    echo "env GAC=\${GOOGLE_APPLICATION_CREDENTIALS:-<unset>} SHA=\${TINKER_DEPLOY_SHA:-} CB=\${TINKER_DEPLOY_CODEBASE:-} MSHA=\${TINKER_DEPLOY_MANIFEST_SHA256:-} QP=\${GOOGLE_CLOUD_QUOTA_PROJECT:-<unset>}" >> "\$SC/log"
   108	    echo "workdir-mode=\$(stat -f %Lp "\$(dirname "\$PWD")")" >> "\$SC/log"
   109	    only="\$(printf '%s\n' "\$@" | awk '/^--only\$/{getline; print}')"; cb="\${only#functions:}"
   110	    hook="\$(/usr/bin/jq -r --arg cb "\$cb" '.functions[] | select(.codebase == \$cb) | .predeploy[0]' firebase.json)"
   111	    # firebase-tools runs the hook with GCLOUD_PROJECT, PROJECT_DIR and RESOURCE_DIR (lib/deploy/lifecycleHooks.js).
   112	    out="\$(GCLOUD_PROJECT=my-clay-hub PROJECT_DIR="\$PWD" RESOURCE_DIR="\$PWD/functions/\$cb" bash -c "\$hook" 2>&1)"; rc=\$?
   113	    [ -f "\$SC/hide_backstop" ] || printf '%s\n' "\$out"
   114	    if [ "\$rc" != 0 ]; then echo "predeploy=REFUSED" >> "\$SC/log"; echo "Error: predeploy error"; exit 2; fi
   115	    [ -f "functions/\$cb/functions.yaml" ] && echo "seal=present" >> "\$SC/log"
   116	    [ -f "\$SC/skip_line" ] && echo "i  functions: Skipping the deploy of unchanged functions."
   117	    [ -f "\$SC/api_enabled" ] && echo "⚠  extensions: missing required API firebaseextensions.googleapis.com. Enabling now..."
   118	    if [ ! -f "\$SC/deploy_noop" ]; then
   119	      cfg="\$(/usr/bin/jq -c . functions/firebase-config.json)"; h="\$(fake_hash "\$PWD/functions/\$cb" "\$cfg")"
   120	      /usr/bin/jq -c --arg cb "\$cb" --arg cfg "\$cfg" --arg h "\$h" --slurpfile man "functions/\$cb/functions.yaml" '
   121	        (\$man[0].endpoints | to_entries | map(.key as \$id | .value as \$e | {
   122	          platform: "gcfv2", id: \$id, project: "my-clay-hub", region: \$e.region[0], httpsTrigger: {}, entryPoint: \$e.entryPoint,
   123	          runtime: "nodejs22", ingressSettings: \$e.ingressSettings,
   124	          environmentVariables: { EVENTARC_CLOUD_EVENT_SOURCE: "projects/my-clay-hub/locations/\(\$e.region[0])/services/\(\$id)",
   125	            FIREBASE_CONFIG: \$cfg, FUNCTION_TARGET: (\$e.entryPoint | gsub("-"; ".")), GCLOUD_PROJECT: "my-clay-hub", LOG_EXECUTION_ID: "true" },
   126	          timeoutSeconds: \$e.timeoutSeconds, uri: "https://\(\$id)-fake-uc.a.run.app", serviceAccount: \$e.serviceAccountEmail,
   127	          availableMemoryMb: \$e.availableMemoryMb, cpu: \$e.cpu, minInstances: (\$e.minInstances // 0), maxInstances: \$e.maxInstances,
   128	          concurrency: \$e.concurrency, codebase: \$cb, hash: \$h, state: "ACTIVE",
   129	          labels: {"deployment-tool": "cli-firebase", "firebase-functions-codebase": \$cb, "firebase-functions-hash": \$h} })) as \$new
   130	        | map(select(.codebase != \$cb)) + \$new' "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"
   131	    fi
   132	    if [ -f "\$SC/after_filter" ]; then /usr/bin/jq -c "\$(cat "\$SC/after_filter")" "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"; fi
   133	    if [ -f "\$SC/cli_block" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
   134	    exit "\$(cat "\$SC/cli_exit" 2>/dev/null || echo 0)" ;;
   135	esac
   136	echo "fake cli: unexpected \$*" >&2; exit 99
   137	EOF
   138	cat > "$T/bin/curl" <<EOF
   139	#!/bin/bash
   140	SC="$SC"
   141	echo "curl \$*" >> "\$SC/log"; echo x >> "\$SC/curl_calls"
   142	while [ \$# -gt 0 ]; do case "\$1" in -D) D="\$2"; shift 2;; -o|-w|--max-time|--proto) shift 2;; *) U="\$1"; shift;; esac; done
   143	hdr() { printf 'HTTP/2 %s\r\n%s\r\n' "\$1" "\$2" > "\$D"; printf '%s' "\$1"; }
   144	case "\$(cat "\$SC/probe" 2>/dev/null || echo refused)" in
   145	  refused)    hdr 403 'server: Google Frontend' ;;
   146	  reached403) hdr 403 'x-tinker-reached: canary' ;;
   147	  ok200)      hdr 200 'x-tinker-reached: canary' ;;
   148	  plain200)   hdr 200 'server: Google Frontend' ;;
   149	  timeout)    echo "curl: (28) Operation timed out" >&2; exit 28 ;;
   150	  notfound)   hdr 404 'server: Google Frontend' ;;
   151	  error500)   hdr 500 'server: Google Frontend' ;;
   152	esac
   153	exit 0
   154	EOF
   155	cat > "$T/bin/grep" <<EOF
   156	#!/bin/bash
   157	# Real grep, except that with \$SC/grep_fail present a search for the CLI's "Enabling now" line fails like an unreadable file.
   158	if [ -f "$SC/grep_fail" ]; then for a in "\$@"; do [ "\$a" = "Enabling now" ] && exit 2; done; fi
   159	exec /usr/bin/grep "\$@"
   160	EOF
   161	chmod +x "$T/bin/grep"
   162	cat > "$T/bin/sleep" <<EOF
   163	#!/bin/bash
   164	[ "\${1:-}" = 1 ] && exec /bin/sleep 1
   165	echo "sleep \$*" >> "$SC/log"; exit 0
   166	EOF
   167	# Transparent git wrapper, inert unless FAIL_GIT names a subcommand (and FAIL_GIT_ARG an argument) to fail.
   168	cat > "$T/bin/git" <<EOF
   169	#!/bin/bash
   170	if [ -n "\${FAIL_GIT:-}" ] && [ "\${1:-}" = "\$FAIL_GIT" ]; then
   171	  for a in "\$@"; do case "\$a" in *"\${FAIL_GIT_ARG:-}"*) echo "fatal: simulated failure of git \$FAIL_GIT" >&2; exit 128 ;; esac; done
   172	fi
   173	exec "$REAL_GIT" "\$@"
   174	EOF
   175	chmod +x "$T/bin/"*
   176	export PATH="$T/bin:$PATH"
   177	
   178	# ─── the scenario ──────────────────────────────────────────────────────────────────────────────────────
   179	CANARY='{"specVersion":"v1alpha1","endpoints":{"canary":{"availableMemoryMb":256,"timeoutSeconds":10,"minInstances":0,"maxInstances":1,"ingressSettings":"ALLOW_ALL","concurrency":1,"serviceAccountEmail":"canary@my-clay-hub.iam.gserviceaccount.com","vpc":null,"platform":"gcfv2","cpu":1,"region":["us-central1"],"labels":{},"httpsTrigger":{"invoker":["private"]},"entryPoint":"canary"}},"extensions":{},"requiredAPIs":[]}'
   180	scenario_reset() {
   181	  rm -rf "$SC"; mkdir -p "$SC"
   182	  printf '%s\n' "$CANARY" > "$SC/manifest.json"; echo '[]' > "$SC/live.json"
   183	  : > "$SC/log"; : > "$SC/list_calls"; : > "$SC/curl_calls"
   184	}
   185	manifest_edit() { "$JQ" -c "$1" "$SC/manifest.json" > "$SC/m.new" && mv "$SC/m.new" "$SC/manifest.json"; }
   186	
   187	# ─── a throwaway origin + clone that looks like my-clay-hub ────────────────────────────────────────────
   188	"$REAL_GIT" init --quiet --bare "$T/origin.git"
   189	"$REAL_GIT" clone --quiet "$T/origin.git" "$T/clone" 2>/dev/null
   190	REPO="$T/clone"
   191	cd "$REPO"
   192	git config user.email test@example.com; git config user.name test; git config commit.gpgsign false; git config tag.gpgSign false
   193	mkdir -p scripts/lib functions/core tests node_modules/firebase-tools/lib/bin
   194	cp "$HERE/deploy-functions.sh" "$HERE/deploy-rules.sh" "$HERE/predeploy-check.sh" scripts/
   195	cp "$HERE/lib/receipts.sh" scripts/lib/
   196	for f in scripts/deploy-functions.sh scripts/deploy-rules.sh scripts/predeploy-check.sh; do
   197	  sed -i '' "s#^REPO=\"/Users/christiehubley/my-clay-hub\"#REPO=\"$REPO\"#" "$f"
   198	  grep -q "^REPO=\"$REPO\"" "$f" || { echo "harness: could not pin $f to the clone"; exit 1; }
   199	done
   200	sed -i '' -e "s#^NODE22=.*#NODE22=\"$T/bin/node22\"#" -e "s#^NPM22_CLI=.*#NPM22_CLI=\"$T/npm/npm-cli.js\"#" -e "s#^CURL=.*#CURL=\"$T/bin/curl\"#" scripts/deploy-functions.sh
   201	for k in NODE22 NPM22_CLI CURL; do grep -q "^${k}=\"$T/" scripts/deploy-functions.sh || { echo "harness: could not pin ${k}"; exit 1; }; done
   202	GUARD="$REPO/scripts/deploy-functions.sh"
   203	: > node_modules/firebase-tools/lib/bin/firebase.js
   204	printf 'node_modules\n' > .gitignore
   205	cp "$ROOT/firebase.json" firebase.json
   206	echo '{"projects":{"default":"my-clay-hub"}}' > .firebaserc
   207	echo '{"name":"t","scripts":{"test":"echo tests"}}' > package.json
   208	echo '{"lockfileVersion":3,"packages":{}}' > package-lock.json
   209	printf 'rules_version = %s;\nservice cloud.firestore { match /databases/{db}/documents { match /x/{d} { allow read: if false; } } }\n' "'2'" > firestore.rules
   210	echo '{"indexes":[]}' > firestore.indexes.json
   211	echo 'rules_version = "2"; service firebase.storage { match /b/{b}/o { match /{p=**} { allow read: if false; } } }' > storage.rules
   212	cp "$ROOT/functions/declarations.json" "$ROOT/functions/iam-expectations.json" "$ROOT/functions/firebase-config.json" functions/
   213	printf "'use strict';\nexports.canary = 1;\n" > functions/core/index.js
   214	printf "'use strict';\nmodule.exports = {};\n" > functions/core/reached.js
   215	echo '{"name":"core","private":true,"engines":{"node":"22"},"dependencies":{"firebase-functions":"7.4.0"}}' > functions/core/package.json
   216	echo '{"name":"core","lockfileVersion":3,"packages":{}}' > functions/core/package-lock.json
   217	echo '# runbook' > FUNCTIONS-ROLLBACK.md
   218	echo "// a test" > tests/sample.test.js
   219	for f in scripts/emulator-safety.js scripts/functions-emulator.mjs scripts/functions-discover.mjs scripts/lib/functions-hash.mjs \
   220	         scripts/deploy-rules.test.sh scripts/deploy-functions.test.sh; do echo "# stand-in" > "$f"; done
   221	git add -A; git commit --quiet -m "initial"; git branch -M main; git push --quiet -u origin main
   222	SHA1="$(git rev-parse HEAD)"
   223	
   224	GITDIR="$(git rev-parse --absolute-git-dir)"
   225	NS='deployed/my-clay-hub/functions-core'
   226	INFLIGHT="$GITDIR/tinker-deploy-inflight-functions"
   227	run() { : > "$SC/log"; : > "$SC/list_calls"; : > "$SC/curl_calls"; OUT="$(bash "$GUARD" "$@" 2>&1)"; CODE=$?; }
   228	fixture_reset() {
   229	  git checkout --quiet main; git push --quiet --force origin "$SHA1:refs/heads/main"; git fetch --quiet origin; git reset --quiet --hard origin/main
   230	  git tag -l 'deployed/*' | xargs -n1 git tag -d >/dev/null 2>&1 || true
   230	  git tag -l 'deployed/*' | xargs -n1 git tag -d >/dev/null 2>&1 || true
   231	  git ls-remote --tags origin 'refs/tags/deployed/*' | awk '{print $2}' | grep -v '\^{}' | xargs -n1 -I{} git push --quiet origin --delete {} 2>/dev/null || true
   232	  rm -rf "$GITDIR/tinker-deploy.lock" "$GITDIR/tinker-deploy-pending-functions" "$INFLIGHT" "$GITDIR/tinker-deploy-transcripts"
   233	  rm -f "$GITDIR"/tinker-deploy-message-functions-*
   234	  git config --unset remote.origin.pushurl 2>/dev/null || true
   235	  rm -rf "$TMPDIR"/*; git worktree prune
   236	  scenario_reset
   237	}
   238	newest_tag() { git for-each-ref --format='%(refname:lstrip=2)' "refs/tags/${1:-$NS}/" | LC_ALL=C sort | tail -1; }
   239	field() { git for-each-ref --format='%(contents)' "refs/tags/$1" | awk -v k="$2=" 'index($0,k)==1{print substr($0,length(k)+1)}'; }
   240	commit_change() { printf '%s\n' "$2" >> "$1"; git add -A; git commit --quiet -m "change $1"; git push --quiet; git rev-parse HEAD; }
   241	no_deploy() { assert_lacks "$1" "$(cat "$SC/log")" "cli deploy"; }
   242	evidence_op() {  # <file> [status] [revision] — Christie's Console reading, in the fixed shape
   243	  printf '{"confirmation":"Cloud Build → History: the build finished; Cloud Run: canary latest revision ready","functions":{"canary":{"buildId":"0f1e2d3c-4b5a-6978-8a9b-0c1d2e3f4a5b","buildStatus":"%s","latestReadyRevision":%s}}}\n' \
   244	    "${2:-SUCCESS}" "${3:-\"canary-00001-abc\"}" > "$1"
   245	}
   246	evidence_iam() { # <file> [jq edit] — a reading that matches, with A5 read back with different whitespace
   247	  "$JQ" -c --slurpfile x "$ROOT/functions/iam-expectations.json" \
   248	    '.buildRoleBindings["roles/storage.objectViewer"][0].condition = ($x[0].buildRoleBindings["roles/storage.objectViewer"] | gsub(" \\|\\| "; "\n  || ")) | '"${2:-.}" > "$1" <<'EOF'
   249	{"functions":{"canary":{"buildId":"0f1e2d3c-4b5a-6978-8a9b-0c1d2e3f4a5b","buildStatus":"SUCCESS","latestReadyRevision":"canary-00001-abc","requireAuthentication":true,"runInvokerMembers":[]}},
   250	 "projectRoles":{"roles/run.invoker":[],"roles/cloudfunctions.invoker":[],"roles/owner":["user:Christie@tinkerartstudio.com"],"roles/editor":["serviceAccount:760301318440@cloudservices.gserviceaccount.com"],
   251	                  "roles/cloudbuild.builds.builder":[]},
   252	 "buildRoleBindings":{"roles/logging.logWriter":[{"member":"serviceAccount:760301318440-compute@developer.gserviceaccount.com","condition":null}],
   253	                      "roles/storage.objectViewer":[{"member":"serviceAccount:760301318440-compute@developer.gserviceaccount.com","condition":"x"}]},
   254	 "artifactRegistryWriters":{"repository":["serviceAccount:760301318440-compute@developer.gserviceaccount.com"],"project":[]},
   255	 "runtimeAccounts":{"canary@my-clay-hub.iam.gserviceaccount.com":[]},
   256	 "buildAccount":"760301318440-compute@developer.gserviceaccount.com"}
   257	EOF
   258	}
   259	
   260	echo "deploy-functions.sh"
   261	
   262	# ═══ usage ══════════════════════════════════════════════════════════════════════════════════════════════
   263	fixture_reset
   264	run; assert_eq "no mode → usage, exit 10" "$CODE" "10"
   265	run --status; assert_eq "no --codebase → exit 10" "$CODE" "10"; assert_has "…saying so" "$OUT" "--codebase <name> is required"
   266	run --status --codebase Core; assert_eq "a codebase name that isn't one → exit 10" "$CODE" "10"
   267	run --status --codebase canary; assert_eq "a function id is not a codebase (F1) → exit 10" "$CODE" "10"; assert_has "…naming it" "$OUT" "'canary' is not a codebase"
   268	run --approved "$SHA1" --codebase canary; assert_eq "…--approved refuses a function id too" "$CODE" "10"; no_deploy "…and the CLI never deployed"
   269	run --status --diff --codebase core; assert_eq "two modes → exit 10" "$CODE" "10"
   270	run --approved "$SHA1" --codebase core --evidence /x; assert_eq "--evidence with --approved → exit 10" "$CODE" "10"
   271	run --reconcile --codebase core; assert_eq "--reconcile without --evidence → exit 25" "$CODE" "25"
   272	run --approved "${SHA1:0:7}" --codebase core; assert_eq "a 7-char sha → exit 10" "$CODE" "10"; assert_has "…FULL sha" "$OUT" "FULL 40-character sha"
   273	run --approved "$(printf '%040d' 0)" --codebase core; assert_eq "not a commit → exit 10" "$CODE" "10"
   274	git checkout --quiet -b wip; commit_change functions/core/index.js "// wip" >/dev/null; WIP="$(git rev-parse HEAD)"; git push --quiet -u origin wip 2>/dev/null; git checkout --quiet main
   275	run --approved "$WIP" --codebase core; assert_eq "a sha not on origin/main → exit 14" "$CODE" "14"; no_deploy "…never deployed"
   276	mkdir "$GITDIR/tinker-deploy.lock"; run --approved "$SHA1" --codebase core; assert_eq "the shared lock held → exit 11" "$CODE" "11"; rmdir "$GITDIR/tinker-deploy.lock"
   277	run --status --codebase core-verify; assert_eq "a codebase name that would collide with a record namespace → exit 10" "$CODE" "10"
   278	# preflight: each pinned tool at the wrong version refuses before anything runs (exit 28)
   279	for pf in "node_version:v20.20.2:not Node 22" "npm_version:10.8.0:not the pinned 10.9.9" "cli_version:15.0.0:not the pinned 15.22.3"; do
   280	  f="${pf%%:*}"; rest="${pf#*:}"; printf '%s\n' "${rest%%:*}" > "$SC/$f"
   281	  run --approved "$SHA1" --codebase core; assert_eq "preflight: ${f} ${rest%%:*} → exit 28" "$CODE" "28"; assert_has "…saying so" "$OUT" "${rest#*:}"; no_deploy "…nothing ran"
   282	  rm -f "$SC/$f"
   283	done
   284	# A MODIFIED copy run from outside the repo (the repo's own guard and library are clean, so only $SELF differs).
   285	{ cat "$GUARD"; echo "# edited copy"; } > "$T/copy-of-guard.sh"
   286	: > "$SC/log"; OUT="$(bash "$T/copy-of-guard.sh" --approved "$SHA1" --codebase core 2>&1)"; CODE=$?
   287	assert_eq "a modified copy of the guard run from elsewhere → refused (exit 27)" "$CODE" "27"; assert_has "…saying so" "$OUT" "run the repo's own guard"
   288	no_deploy "…nothing deployed"
   289	
   290	# ═══ the happy path ═════════════════════════════════════════════════════════════════════════════════════
   291	fixture_reset
   292	: > "$SC/log"; OUT="$(GOOGLE_APPLICATION_CREDENTIALS=/decoy.json GOOGLE_CLOUD_QUOTA_PROJECT=decoy bash "$GUARD" --approved "$SHA1" --codebase core 2>&1)"; CODE=$?
   293	LOG="$(cat "$SC/log")"
   294	assert_eq "first deploy → exit 0" "$CODE" "0"
   295	R="$(newest_tag)"
   296	assert_has "an attempt record exists, named <stamp>-<sha7>" "$R" "${NS}/"
   297	assert_has "…with the sha7" "$R" "-${SHA1:0:7}"
   298	assert_eq "…pointing at the approved commit" "$(git rev-list -n1 "$R")" "$SHA1"
   299	assert_eq "…deploy_verified=yes" "$(field "$R" deploy_verified)" "yes"
   300	assert_eq "…cli_exit=0" "$(field "$R" cli_exit)" "0"
   301	assert_eq "…backstop_seen=yes" "$(field "$R" backstop_seen)" "yes"
   302	assert_eq "…skip_line_seen=no" "$(field "$R" skip_line_seen)" "no"
   303	assert_eq "…deploy_match=yes" "$(field "$R" deploy_match)" "yes"
   304	assert_eq "…access=refused" "$(field "$R" access)" "refused"
   305	assert_eq "…the tree id of functions/core" "$(field "$R" tree)" "$(git rev-parse "$SHA1:functions/core")"
   306	assert_eq "…the attempt id is the tag name" "$(field "$R" attempt)" "$R"
   307	assert_eq "…the expected hash equals the live hash" "$(field "$R" expected_hash.canary)" "$(field "$R" live_hash.canary)"
   308	assert_eq "…before_hash is none on a first deploy" "$(field "$R" before_hash.canary)" "none"
   309	assert_eq "…functions_unchanged=no (the canary was created)" "$(field "$R" functions_unchanged)" "no"
   310	assert_eq "…the verifier is origin/main" "$(field "$R" verifier)" "$SHA1"
   311	assert_has "…the probe saw Google's front end" "$(field "$R" probe.canary)" "Google_Frontend"
   312	assert_has "…and it says what refused does not prove" "$(field "$R" not_proven)" "all Google accounts"
   313	assert_has "…pushed to origin" "$(git ls-remote --tags origin)" "refs/tags/$R"
   314	assert_has "the CLI call was deploy --only functions:core --project my-clay-hub --non-interactive" "$LOG" "cli deploy --only functions:core --project my-clay-hub --non-interactive"
   315	assert_lacks "…never --force" "$LOG" "--force"
   316	assert_has "…with the approved sha and codebase exported" "$LOG" "SHA=${SHA1} CB=core"
   317	assert_has "…GOOGLE_APPLICATION_CREDENTIALS and GOOGLE_CLOUD_QUOTA_PROJECT unset for the CLI (F5)" "$LOG" "GAC=<unset> SHA="
   318	assert_has "…(quota project too)" "$LOG" "QP=<unset>"
   319	assert_has "the backstop ran and sealed the manifest in" "$LOG" "seal=present"
   320	assert_has "npm ci --prefix ran on the codebase in the worktree" "$LOG" "npm ci --prefix $TMPDIR/tinker-functions."
   321	assert_has "npm test ran with the functions suites required" "$LOG" "npm-test TINKER_FUNCTIONS_TESTS=required"
   322	assert_has "discovery ran with a scratch HOME" "$LOG" "discover HOME=$TMPDIR/tinker-functions."
   323	assert_has "…and without the credential variable" "$LOG" "GAC=<unset> --project"
   324	assert_has "the probe used curl -q (no .curlrc) and https only" "$LOG" "curl -q -sS"
   325	assert_lacks "…with no Authorization header" "$LOG" "Authorization"
   326	assert_eq "the run's private folder is mode 700" "$(grep -o 'workdir-mode=[0-9]*' "$SC/log" | head -1)" "workdir-mode=700"
   327	assert_has "a transcript was kept" "$(ls "$GITDIR/tinker-deploy-transcripts/")" "functions-core-"
   328	assert_eq "no in-flight file remains" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   329	assert_eq "the worktree is removed (and the seal with it)" "$(git worktree list | wc -l | tr -d ' ')" "1"
   330	assert_eq "…and nothing is left in the temp folder" "$(ls "$TMPDIR" | wc -l | tr -d ' ')" "0"
   331	assert_eq "the lock is released" "$([ -d "$GITDIR/tinker-deploy.lock" ] && echo held || echo free)" "free"
   332	assert_has "the --attest instructions were printed" "$OUT" "--attest ${R} --codebase core"
   333	TPL="$(printf '%s\n' "$OUT" | awk '/^─── next: Christie.s IAM reading/{f=1; next} /^then:/{f=0} f && NR>0' | sed '1,2d')"
   334	assert_eq "…its JSON template has exactly the project roles --attest checks" \
   335	  "$(printf '%s' "$TPL" | "$JQ" -c '.projectRoles | keys' 2>/dev/null)" \
   336	  "$("$JQ" -c '.projectRoles | keys' "$ROOT/functions/iam-expectations.json")"
   337	assert_eq "…and the build roles it reads as bindings" \
   338	  "$(printf '%s' "$TPL" | "$JQ" -c '.buildRoleBindings | keys' 2>/dev/null)" "$("$JQ" -c '.buildRoleBindings | keys' "$ROOT/functions/iam-expectations.json")"
   339	assert_eq "…and exactly the top-level keys the shape check requires" \
   340	  "$(printf '%s' "$TPL" | "$JQ" -c 'keys' 2>/dev/null)" '["artifactRegistryWriters","buildAccount","buildRoleBindings","functions","projectRoles","runtimeAccounts"]'
   341	assert_has "the first deploy's diff also lists the guard's machinery (all new to the record)" "$OUT" "the guard's MACHINERY at ${SHA1:0:12} — all new to the record"
   342	assert_has "…naming the backstop among it" "$OUT" "scripts/predeploy-check.sh"
   343	assert_has "the first deploy's diff shows the whole codebase" "$OUT" "+exports.canary = 1;"
   344	run --status --codebase core
   345	assert_has "--status: verified at the attempt" "$OUT" "verified at ${R}"
   346	assert_has "…iam_attested=none yet" "$OUT" "iam_attested=none"
   347	assert_has "…and the phrase for origin/main" "$OUT" "approved to change firebase ${SHA1}"
   348	run --diff --codebase core; assert_has "--diff with nothing new says so" "$OUT" "(no change to"
   349	# a second run of the same sha: a fresh worktree, and verified again (the hash rule doesn't need a change)
   350	FIRST_CWD="$(grep '^cli deploy' "$SC/log" | sed 's/.*cwd=//')"
   351	run --approved "$SHA1" --codebase core
   352	assert_eq "a same-sha retry after success → verified (exit 0)" "$CODE" "0"
   353	R2="$(newest_tag)"
   354	assert_eq "…a second record" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "2"
   355	assert_eq "…with the same expected hash as the first" "$(field "$R2" expected_hash.canary)" "$(field "$R" expected_hash.canary)"
   356	assert_eq "…and before_hash = the live hash it found" "$(field "$R2" before_hash.canary)" "$(field "$R" live_hash.canary)"
   357	assert_eq "…functions_unchanged=yes (same bytes, same hash)" "$(field "$R2" functions_unchanged)" "yes"
   358	
   359	echo 1 > "$SC/cli_exit"; run --approved "$SHA1" --codebase core; rm -f "$SC/cli_exit"
   360	run --status --codebase core
   361	assert_has "an unverified attempt that changed nothing → --status says functions unchanged by it" "$OUT" "functions unchanged by $(newest_tag) — production is still what ${R2} verified"
   362	M1="$(commit_change FUNCTIONS-ROLLBACK.md "a runbook edit")"
   363	run --diff --codebase core
   364	assert_has "--diff names a MACHINERY change even when the payload is unchanged" "$OUT" "the guard's MACHINERY changed since"
   365	assert_has "…naming the file" "$OUT" "FUNCTIONS-ROLLBACK.md"
   366	run --approved "$M1" --codebase core
   367	assert_has "…and so does --approved's diff" "$OUT" "the guard's MACHINERY changed since"
   368	
   369	# ═══ the hash rule ══════════════════════════════════════════════════════════════════════════════════════
   370	fixture_reset
   371	run --approved "$SHA1" --codebase core; H1="$(field "$(newest_tag)" expected_hash.canary)"
   372	S2="$(commit_change functions/core/index.js "exports.more = 2;")"
   373	run --approved "$S2" --codebase core
   374	assert_eq "a changed source → verified" "$CODE" "0"
   375	assert_eq "…deploy_verified=yes" "$(field "$(newest_tag)" deploy_verified)" "yes"
   376	assert_lacks "…and its expected hash differs from the first" "$(field "$(newest_tag)" expected_hash.canary)" "$H1"
   377	S3="$(commit_change README.md "# docs only")"
   378	run --approved "$S3" --codebase core
   379	assert_eq "identical codebase content, redeployed from a docs-only commit → verified" "$CODE" "0"
   380	assert_eq "…with the same expected hash as the commit before it" "$(field "$(newest_tag)" expected_hash.canary)" "$(field "$(git tag -l "${NS}/*" | LC_ALL=C sort | sed -n 2p)" expected_hash.canary)"
   381	git mv functions/core/reached.js functions/core/reached2.js; git commit --quiet -m rename; git push --quiet; S4="$(git rev-parse HEAD)"
   382	run --approved "$S4" --codebase core
   383	assert_eq "a rename → verified" "$CODE" "0"
   384	assert_eq "…the expected hash is unchanged (it covers bytes only)" "$(field "$(newest_tag)" expected_hash.canary)" "$(field "$(git tag -l "${NS}/*" | LC_ALL=C sort | sed -n 3p)" expected_hash.canary)"
   385	assert_eq "…but the recorded tree id is the new one (F3 covers renames)" "$(field "$(newest_tag)" tree)" "$(git rev-parse "$S4:functions/core")"
   386	chmod +x functions/core/index.js; git add -A; git commit --quiet -m "mode only"; git push --quiet; S5="$(git rev-parse HEAD)"
   387	run --approved "$S5" --codebase core
   388	assert_eq "a mode-only change → verified" "$CODE" "0"
   389	assert_eq "…the tree id records the mode change" "$(field "$(newest_tag)" tree)" "$(git rev-parse "$S5:functions/core")"
   390	assert_eq "…the hash does not" "$(field "$(newest_tag)" expected_hash.canary)" "$(field "$(git tag -l "${NS}/*" | LC_ALL=C sort | sed -n 4p)" expected_hash.canary)"
   391	echo '.[0].hash = "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef" | .[0].labels["firebase-functions-hash"] = .[0].hash' > "$SC/after_filter"
   392	run --approved "$S5" --codebase core
   393	assert_eq "an arbitrary wrong live hash → not verified (exit 21)" "$CODE" "21"
   394	assert_eq "…deploy_match=no" "$(field "$(newest_tag)" deploy_match)" "no"
   395	assert_has "…naming the hash" "$(field "$(newest_tag)" mismatch)" "live hash deadbeef"
   396	# the first build fails for permissions, then the same sha re-runs under the same approval → verified
   397	fixture_reset
   398	echo 2 > "$SC/cli_exit"; : > "$SC/deploy_noop"
   399	run --approved "$SHA1" --codebase core
   400	assert_eq "the first build fails (exit 2, nothing created) → not verified (exit 21)" "$CODE" "21"
   401	RA="$(newest_tag)"
   402	assert_eq "…recorded cli_exit=2" "$(field "$RA" cli_exit)" "2"
   403	assert_eq "…deploy_match=no (the function is missing)" "$(field "$RA" deploy_match)" "no"
   404	assert_eq "…access=inconclusive (no uri)" "$(field "$RA" access)" "inconclusive"
   405	rm -f "$SC/cli_exit" "$SC/deploy_noop"
   406	run --approved "$SHA1" --codebase core
   407	assert_eq "…the same sha re-runs → verified" "$CODE" "0"
   408	RB="$(newest_tag)"
   409	assert_eq "…the failed attempt and the retry carry the same tree id" "$(field "$RA" tree)" "$(field "$RB" tree)"
   410	assert_eq "…and the same expected hash" "$(field "$RA" expected_hash.canary)" "$(field "$RB" expected_hash.canary)"
   411	
   412	# ═══ refusals on the manifest (F2, F13, F14): exit 24, the CLI never deploys ═══════════════════════════
   413	refuse_manifest() {  # <jq edit> <what> <expected text>
   414	  fixture_reset; manifest_edit "$1"; run --approved "$SHA1" --codebase core
   415	  assert_eq "$2 → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "$3"; no_deploy "…the CLI never deployed"
   416	  assert_eq "…and no record" "$(git tag -l 'deployed/*' | wc -l | tr -d ' ')" "0"
   417	}
   418	refuse_manifest 'del(.endpoints.canary.httpsTrigger.invoker)' "a missing invoker" "no invoker (an absent invoker deploys PUBLIC"
   419	refuse_manifest '.endpoints.canary.httpsTrigger.invoker = ["public"]' "invoker: public" "invoker includes public"
   420	refuse_manifest '.endpoints.canary.httpsTrigger.invoker = ["canary@my-clay-hub.iam.gserviceaccount.com"]' "an invoker that differs from its declaration" "differs from its declaration"
   421	refuse_manifest 'del(.endpoints.canary.serviceAccountEmail)' "a missing service account" "no runtime service account"
   422	refuse_manifest '.endpoints.canary.serviceAccountEmail = "760301318440-compute@developer.gserviceaccount.com"' "the Compute account" "broad default account"
   423	refuse_manifest '.endpoints.canary.serviceAccountEmail = "760301318440@cloudbuild.gserviceaccount.com"' "the legacy Cloud Build account" "broad default account"
   424	refuse_manifest '.endpoints.canary.serviceAccountEmail = "firebase-adminsdk-fbsvc@my-clay-hub.iam.gserviceaccount.com"' "firebase-adminsdk-*" "broad default account"
   425	refuse_manifest '.endpoints.canary.serviceAccountEmail = "my-clay-hub@appspot.gserviceaccount.com"' "…@appspot" "broad default account"
   426	refuse_manifest '.endpoints.canary.serviceAccountEmail = "other@my-clay-hub.iam.gserviceaccount.com"' "an account that differs from its declaration" "differs from its declaration canary@"
   427	refuse_manifest '.endpoints.canary.ingressSettings = "ALLOW_INTERNAL_ONLY"' "ingress that differs from its declaration" "ingress ALLOW_INTERNAL_ONLY differs"
   428	refuse_manifest '.endpoints.canary.platform = "gcfv1"' "platform gcfv1" "platform gcfv1, not gcfv2"
   429	refuse_manifest '.endpoints.canary.region = ["us-east1"]' "another region" "not [\"us-central1\"]"
   430	refuse_manifest '.endpoints.canary.region = ["us-central1","us-east1"]' "two regions" "not [\"us-central1\"]"
   431	for k in maxInstances concurrency timeoutSeconds availableMemoryMb cpu; do
   432	  refuse_manifest "del(.endpoints.canary.${k})" "no ${k} (F14)" "${k} is not set"
   433	done
   434	refuse_manifest '.endpoints.canary.maxInstances = 11' "maxInstances 11" "outside 1..10"
   435	refuse_manifest '.endpoints.canary.minInstances = 1' "minInstances 1" "bills continuously"
   436	refuse_manifest '.endpoints.canary.vpc = {"connector":"c"}' "a VPC" "sets a VPC"
   437	refuse_manifest '.endpoints.canary.secretEnvironmentVariables = [{"key":"K","secret":"S"}]' "secrets" "uses secrets"
   438	refuse_manifest '.endpoints.canary.environmentVariables = {"K":"v"}' "environment variables" "sets environment variables"
   439	refuse_manifest '.endpoints.canary.scheduleTrigger = {"schedule":"every 5 minutes"} | del(.endpoints.canary.httpsTrigger)' "a schedule (HTTP only)" "not an HTTP function"
   440	refuse_manifest '.endpoints.canary.callableTrigger = {}' "a callable next to httpsTrigger" "trigger callableTrigger is refused"
   441	refuse_manifest '.endpoints.canary.omit = true' "an unexpected key" "unexpected manifest key(s) omit"
   442	refuse_manifest '.endpoints.extra = .endpoints.canary' "an undeclared function" "extra: not declared"
   443	refuse_manifest '.endpoints = {"renamed": .endpoints.canary}' "a declaration with no function (stale)" "declaration core/canary has no function (stale)"
   444	refuse_manifest '.requiredAPIs = [{"api":"x.googleapis.com","reason":"r"}]' "required APIs" "requires APIs"
   445	refuse_manifest '.params = [{"name":"P"}]' "params (F13)" "declares params"
   446	refuse_manifest '.specVersion = "v1beta1"' "another specVersion" "specVersion is v1beta1"
   447	refuse_manifest '.extensions = {"e": {}}' "extensions" "declares extensions"
   448	refuse_manifest '.endpoints = {}' "no functions at all" "has no functions"
   449	refuse_manifest '.endpoints.canary.httpsTrigger.extra = 1' "an extra httpsTrigger key" "httpsTrigger has keys beyond invoker"
   450	fixture_reset; echo nodejs20 > "$SC/runtime"; run --approved "$SHA1" --codebase core
   451	assert_eq "runtime nodejs20 → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "runtime nodejs20, not nodejs22"; no_deploy "…the CLI never deployed"
   452	fixture_reset
   453	"$JQ" '.["core/canary"].invoker = ["public"]' functions/declarations.json > d.new && mv d.new functions/declarations.json; git commit --quiet -am "declare public"; git push --quiet
   454	run --approved "$(git rev-parse HEAD)" --codebase core
   455	assert_eq "a declaration that says public → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "declares public"; no_deploy "…the CLI never deployed"
   456	
   457	for dk in serviceAccount invoker ingress; do
   458	  fixture_reset
   459	  "$JQ" --arg k "$dk" 'del(.["core/canary"][$k])' functions/declarations.json > d.new && mv d.new functions/declarations.json; git commit --quiet -am "declaration without $dk"; git push --quiet
   460	  run --approved "$(git rev-parse HEAD)" --codebase core
   461	  assert_eq "a declaration without ${dk} → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "lacks serviceAccount, invoker or ingress"; no_deploy "…the CLI never deployed"
   462	done
   463	
   464	# ═══ install, discovery and tests ══════════════════════════════════════════════════════════════════════
   465	fixture_reset; : > "$SC/npm_ci_fail"; run --approved "$SHA1" --codebase core
   466	assert_eq "npm ci fails → exit 29" "$CODE" "29"; no_deploy "…never deployed"
   467	fixture_reset; : > "$SC/discover_fail"; run --approved "$SHA1" --codebase core
   468	assert_eq "discovery fails → exit 30" "$CODE" "30"; assert_has "…with discovery's own words" "$OUT" "simulated"; no_deploy "…never deployed"
   469	fixture_reset; : > "$SC/npm_test_fail"; run --approved "$SHA1" --codebase core
   470	assert_eq "npm test fails → exit 15" "$CODE" "15"; no_deploy "…never deployed"
   471	assert_eq "…no in-flight file, no record" "$([ -e "$INFLIGHT" ] && echo present || echo gone) $(git tag -l 'deployed/*' | wc -l | tr -d ' ')" "gone 0"
   472	
   473	# ═══ production drift, and F6: refused before the in-flight file and the CLI (exit 23) ════════════════
   474	refuse_drift() {  # <live.json> <what> <expected text>
   475	  fixture_reset; printf '%s\n' "$1" > "$SC/live.json"; run --approved "$SHA1" --codebase core
   476	  assert_eq "$2 → refused (exit 23)" "$CODE" "23"; assert_has "…naming it" "$OUT" "$3"; no_deploy "…the CLI was never invoked"
   477	  assert_eq "…and no in-flight file was written" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   478	}
   479	LIVE_OK='{"id":"canary","codebase":"core","region":"us-central1","state":"ACTIVE","environmentVariables":{"FIREBASE_CONFIG":"x","GCLOUD_PROJECT":"my-clay-hub","EVENTARC_CLOUD_EVENT_SOURCE":"e","FUNCTION_TARGET":"canary","LOG_EXECUTION_ID":"true"}}'
   480	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.environmentVariables.HAND_ADDED = "v"')]" "a live env key outside F8's five" "HAND_ADDED"
   481	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.secretEnvironmentVariables = [{"key":"K"}]')]" "live secret env" "live secret environment variables"
   482	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.vpc = {"connector":"c"}')]" "a live VPC" "live VPC setting"
   483	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.state = "DEPLOYING"')]" "a function DEPLOYING" "is DEPLOYING"
   484	refuse_drift "[${LIVE_OK},$(printf '%s' "$LIVE_OK" | "$JQ" -c '.id = "gone"')]" "a live function missing from the manifest (F6)" "gone: is live but not in the manifest; the guard never deletes"
   485	fixture_reset; printf '%s\n' "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.codebase = "other" | .environmentVariables.X = 1')]" > "$SC/live.json"
   486	run --approved "$SHA1" --codebase core; assert_eq "drift in ANOTHER codebase is not this deploy's → verified" "$CODE" "0"
   487	fixture_reset; echo error > "$SC/list_mode_1"; run --approved "$SHA1" --codebase core
   488	assert_eq "production can't be read before the deploy → exit 13" "$CODE" "13"; no_deploy "…never deployed"
   489	assert_has "…with the CLI's own error (its --json body is on stdout)" "$OUT" "simulated list failure"
   490	
   491	# ═══ every deploy_verified=no path (exit 21, the record says why) ══════════════════════════════════════
   492	unverified() {  # <what> <record key> <expected value, or text contained in it>
   493	  local r; r="$(newest_tag)"
   494	  assert_eq "$1 → not verified (exit 21)" "$CODE" "21"
   495	  assert_eq "…deploy_verified=no" "$(field "$r" deploy_verified)" "no"
   496	  assert_has "…${2}: ${3}" "$(field "$r" "$2")" "$3"
   497	  assert_eq "…the in-flight file is gone (the record exists)" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   498	}
   499	fixture_reset; echo 1 > "$SC/cli_exit"; run --approved "$SHA1" --codebase core; unverified "the CLI exits 1 with a full match" cli_exit 1
   500	assert_eq "…while deploy_match=yes" "$(field "$(newest_tag)" deploy_match)" "yes"
   501	fixture_reset; echo 2 > "$SC/cli_exit"; run --approved "$SHA1" --codebase core; unverified "the CLI exits 2 (partial) with a full match" cli_exit 2
   502	fixture_reset; : > "$SC/skip_line"; run --approved "$SHA1" --codebase core; unverified "the 'Skipping unchanged' line (M5)" skip_line_seen yes
   503	fixture_reset; : > "$SC/hide_backstop"; run --approved "$SHA1" --codebase core; unverified "no backstop success line" backstop_seen no
   504	after() { fixture_reset; printf '%s\n' "$1" > "$SC/after_filter"; run --approved "$SHA1" --codebase core; unverified "$2" "$3" "$4"; }
   505	after '.[0].environmentVariables.EXTRA = "1"' "an extra live env key" mismatch "env keys"
   506	after '.[0].environmentVariables.EVENTARC_CLOUD_EVENT_SOURCE = "projects/my-clay-hub/locations/us-central1/services/other"' "a wrong EVENTARC_CLOUD_EVENT_SOURCE" mismatch "EVENTARC_CLOUD_EVENT_SOURCE is not"
   507	after '.[0].environmentVariables.FUNCTION_TARGET = "other"' "a wrong FUNCTION_TARGET" mismatch "FUNCTION_TARGET is not canary"
   508	after '.[0].environmentVariables.FIREBASE_CONFIG = "{\"projectId\":\"my-clay-hub\"}"' "a live FIREBASE_CONFIG unlike the pinned file" mismatch "FIREBASE_CONFIG differs"
   509	assert_has "…and the live admin-SDK config is shown, so the pin can be fixed" "$OUT" 'live FIREBASE_CONFIG: {"projectId":"my-clay-hub"}'
   510	after '.[0].environmentVariables.GCLOUD_PROJECT = "tinker-hq-apps"' "a wrong GCLOUD_PROJECT" mismatch "GCLOUD_PROJECT is not"
   511	for kv in "maxInstances=2" "concurrency=80" "timeoutSeconds=60" "availableMemoryMb=512" "cpu=2" "minInstances=1"; do
   512	  after ".[0].${kv%%=*} = ${kv#*=}" "a live ${kv%%=*} unlike the manifest" mismatch "${kv%%=*} ${kv#*=}"
   513	done
   514	after '.[0].serviceAccount = "760301318440-compute@developer.gserviceaccount.com"' "a live runtime account unlike the declaration" mismatch "runtime account 760301318440-compute"
   515	after '.[0].ingressSettings = "ALLOW_INTERNAL_ONLY"' "live ingress unlike the declaration" mismatch "ingress ALLOW_INTERNAL_ONLY"
   516	after '.[0].runtime = "nodejs20"' "a live runtime nodejs20" mismatch "runtime nodejs20"
   517	after '.[0].region = "us-east1"' "a live region" mismatch "region us-east1"
   518	after '.[0].state = "FAILED"' "a live state FAILED" mismatch "state FAILED"
   519	after '.[0].platform = "gcfv1"' "a live platform gcfv1" mismatch "platform gcfv1"
   520	after '.[0].vpc = {"connector":"c"}' "a live VPC" mismatch "VPC"
   520	after '.[0].vpc = {"connector":"c"}' "a live VPC" mismatch "VPC"
   521	after '.[0].secretEnvironmentVariables = [{"key":"K"}]' "live secrets" mismatch "secret environment variables"
   522	after '. + [.[0] | .id = "extra"]' "an extra live function" mismatch "function set"
   523	after '[]' "a missing live function" mismatch "function set"
   524	after 'del(.[0].uri)' "no uri → the probe is inconclusive" access inconclusive
   525	fixture_reset; echo error > "$SC/list_mode_2"; run --approved "$SHA1" --codebase core; unverified "a list error after the deploy" deploy_match unknown
   526	assert_has "…and the record keeps the CLI's reason" "$(field "$(newest_tag)" mismatch)" "simulated list failure"
   527	assert_eq "…functions_unchanged=unknown" "$(field "$(newest_tag)" functions_unchanged)" "unknown"
   528	fixture_reset; echo malformed > "$SC/list_mode_2"; run --approved "$SHA1" --codebase core; unverified "malformed list JSON after the deploy" deploy_match unknown
   529	probe() { fixture_reset; echo "$1" > "$SC/probe"; run --approved "$SHA1" --codebase core; unverified "$2" access "$3"; }
   530	probe reached403 "a 403 WITH the x-tinker-reached header (our code ran)" answered
   531	assert_has "…recorded as such" "$(field "$(newest_tag)" probe.canary)" "http-403-with-x-tinker-reached"
   532	probe ok200 "a 200 (our code answered an unauthenticated caller)" answered
   533	probe plain200 "a 200 without the header" answered
   534	probe timeout "a timeout" inconclusive
   535	assert_eq "…after 5 tries" "$(wc -l < "$SC/curl_calls" | tr -d ' ')" "5"
   536	assert_eq "…4 waits between them" "$(grep -c '^sleep 10' "$SC/log")" "4"
   537	probe notfound "a 404" inconclusive
   538	probe error500 "a 5xx" inconclusive
   539	fixture_reset; echo 2 > "$SC/cli_exit"; : > "$SC/skip_line"; echo error500 > "$SC/probe"; echo '.[0].cpu = 4' > "$SC/after_filter"
   540	run --approved "$SHA1" --codebase core; R="$(newest_tag)"
   541	assert_eq "combined failures → exit 21" "$CODE" "21"
   542	assert_eq "…each recorded: cli_exit, skip line, match, access" "$(field "$R" cli_exit) $(field "$R" skip_line_seen) $(field "$R" deploy_match) $(field "$R" access)" "2 yes no inconclusive"
   543	
   544	# ═══ snapshot canonicalization ══════════════════════════════════════════════════════════════════════════
   545	fixture_reset
   546	printf '%s\n' "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.id = "zeta" | .codebase = "other" | .labels = {"b":"2","a":"1"}')]" > "$SC/live.json"
   547	run --approved "$SHA1" --codebase core
   548	: > "$SC/deploy_noop"; echo 'reverse | map(to_entries | reverse | from_entries | .labels = ((.labels // {}) | to_entries | reverse | from_entries) | .environmentVariables = ((.environmentVariables // {}) | to_entries | reverse | from_entries))' > "$SC/after_filter"
   549	run --approved "$SHA1" --codebase core; R="$(newest_tag)"
   550	assert_eq "a reordered but equivalent snapshot has the same digest" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
   551	assert_eq "…so functions_unchanged=yes" "$(field "$R" functions_unchanged)" "yes"
   552	echo 'map(.labels.touched = "1")' > "$SC/after_filter"
   553	run --approved "$SHA1" --codebase core; R="$(newest_tag)"
   554	assert_lacks "…and a real change (a label) changes it" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
   555	
   556	# ═══ interruption, --reconcile, --clear-inflight ═══════════════════════════════════════════════════════
   557	start_killable() {  # run the guard in its own process group; returns once $SC/blocked appears
   558	  rm -f "$SC/blocked"; : > "$SC/log"; : > "$SC/list_calls"
   559	  set -m; bash "$GUARD" "$@" > "$T/bg.out" 2>&1 & BG=$!; set +m
   560	  for _ in $(seq 1 120); do [ -f "$SC/blocked" ] && break; /bin/sleep 0.5; done
   561	  kill -KILL -- "-$BG" 2>/dev/null; wait "$BG" 2>/dev/null
   562	  rm -rf "$GITDIR/tinker-deploy.lock"; rm -rf "$TMPDIR"/*; git worktree prune   # what a human does after checking the pid is gone
   563	}
   564	fixture_reset
   565	: > "$SC/cli_block"
   566	start_killable --approved "$SHA1" --codebase core
   567	assert_eq "killed after the CLI → the in-flight file remains" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "present"
   568	ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
   569	assert_has "…naming the reserved attempt" "$ATT" "${NS}/"
   570	assert_eq "…with no cli_exit (the CLI never returned)" "$(grep -c '^cli_exit=' "$INFLIGHT")" "0"
   571	assert_eq "…and no record yet" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "0"
   572	rm -f "$SC/cli_block"
   573	run --approved "$SHA1" --codebase core; assert_eq "--approved refuses while it exists (exit 22)" "$CODE" "22"; no_deploy "…and does not deploy"
   574	run --status --codebase core; assert_has "--status shows it" "$OUT" "IN FLIGHT:       ${ATT}"
   575	run --reconcile --codebase core --evidence /nonexistent; assert_eq "--reconcile without the Console evidence → exit 25" "$CODE" "25"
   576	evidence_op "$T/ev.json" WORKING; run --reconcile --codebase core --evidence "$T/ev.json"
   577	assert_eq "…with a build that hasn't finished → exit 25" "$CODE" "25"
   578	printf '{"confirmation":"done"}\n' > "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
   579	assert_eq "…with free text instead of the fixed shape → exit 25" "$CODE" "25"
   580	evidence_op "$T/ev.json"
   581	"$JQ" -c '.[0].state = "DEPLOYING"' "$SC/live.json" > "$SC/l" && mv "$SC/l" "$SC/live.json"
   582	run --reconcile --codebase core --evidence "$T/ev.json"
   583	assert_eq "…while a function is DEPLOYING → exit 22" "$CODE" "22"; assert_has "…saying so" "$OUT" "still DEPLOYING"
   584	"$JQ" -c '.[0].state = "ACTIVE"' "$SC/live.json" > "$SC/l" && mv "$SC/l" "$SC/live.json"
   585	run --reconcile --codebase core --evidence "$T/ev.json"
   586	assert_eq "…once settled: recorded, not verified (cli_exit unknown) → exit 21" "$CODE" "21"
   587	assert_eq "…the record keeps the ORIGINAL stamp (its name is the reserved attempt id)" "$(newest_tag)" "$ATT"
   588	assert_eq "…cli_exit=unknown" "$(field "$ATT" cli_exit)" "unknown"
   589	assert_eq "…deploy_match=yes (production is what the attempt sealed)" "$(field "$ATT" deploy_match)" "yes"
   590	assert_has "…with Christie's evidence" "$(field "$ATT" evidence)" "0f1e2d3c-4b5a-6978-8a9b-0c1d2e3f4a5b"
   591	assert_eq "…by --reconcile" "$(field "$ATT" by)" "deploy-functions.sh --reconcile"
   592	assert_eq "…and the in-flight file is gone" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   593	# killed during the read-back: the CLI returned 0, so the reconcile can verify
   594	fixture_reset
   595	: > "$SC/list_block_2"
   596	start_killable --approved "$SHA1" --codebase core
   597	assert_eq "killed during the read-back → the in-flight file has cli_exit=0" "$(awk -F= '$1=="cli_exit"{print $2}' "$INFLIGHT")" "0"
   598	ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
   599	rm -f "$SC/list_block_2"
   600	run --approved "$SHA1" --codebase core; assert_eq "…--approved refuses (exit 22)" "$CODE" "22"
   601	evidence_op "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
   602	assert_eq "…--reconcile verifies it (exit 0)" "$CODE" "0"
   603	assert_eq "…under its original stamp" "$(newest_tag)" "$ATT"
   604	assert_eq "…deploy_verified=yes" "$(field "$ATT" deploy_verified)" "yes"
   605	assert_eq "…and a reconciled FIRST deploy still needs Christie's IAM reading" "$(field "$ATT" attest_needed)" "yes"
   606	assert_has "…saying so" "$OUT" "IAM reading NEEDED"
   607	# --clear-inflight
   608	fixture_reset
   609	: > "$SC/cli_block"; start_killable --approved "$SHA1" --codebase core; rm -f "$SC/cli_block"
   610	ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
   611	evidence_op "$T/ev.json" WORKING null
   612	run --clear-inflight "${NS}/20990101T000000Z-${SHA1:0:7}" --codebase core --evidence "$T/ev.json"
   613	assert_eq "--clear-inflight naming another attempt → exit 22" "$CODE" "22"
   614	run --clear-inflight "$ATT" --codebase core --evidence "$T/ev.json"
   615	assert_eq "--clear-inflight with Christie's evidence → exit 0" "$CODE" "0"
   616	assert_eq "…keeps the original stamp" "$(newest_tag)" "$ATT"
   617	assert_eq "…deploy_match=unknown" "$(field "$ATT" deploy_match)" "unknown"
   618	assert_eq "…deploy_verified=no" "$(field "$ATT" deploy_verified)" "no"
   619	assert_eq "…attest_needed=yes (not verified)" "$(field "$ATT" attest_needed)" "yes"
   620	assert_has "…saying so" "$OUT" "IAM reading NEEDED"
   621	assert_eq "…the in-flight file is gone" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   622	run --approved "$SHA1" --codebase core; assert_eq "…and the next --approved runs (verified)" "$CODE" "0"
   623	# a truncated in-flight file fails closed
   624	fixture_reset
   625	: > "$SC/cli_block"; start_killable --approved "$SHA1" --codebase core; rm -f "$SC/cli_block"
   626	head -3 "$INFLIGHT" > "$INFLIGHT.t" && mv "$INFLIGHT.t" "$INFLIGHT"
   627	evidence_op "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
   628	assert_eq "a truncated in-flight file → --reconcile refuses (exit 22)" "$CODE" "22"; assert_has "…as malformed" "$OUT" "malformed"
   629	run --clear-inflight x --codebase core --evidence "$T/ev.json"; assert_eq "…--clear-inflight too" "$CODE" "22"
   630	run --status --codebase core; assert_has "…and --status says MALFORMED" "$OUT" "MALFORMED"
   631	run --approved "$SHA1" --codebase core; assert_eq "…and --approved refuses" "$CODE" "22"
   632	
   633	# ═══ ordering: newest attempt, --reverify ═══════════════════════════════════════════════════════════════
   634	fixture_reset
   635	echo timeout > "$SC/probe"; run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
   636	rm -f "$SC/probe"; S2="$(commit_change functions/core/index.js "exports.b = 2;")"
   637	run --approved "$S2" --codebase core; RB="$(newest_tag)"
   638	assert_eq "attempt A unverified, attempt B verified" "$(field "$RA" deploy_verified) $(field "$RB" deploy_verified)" "no yes"
   639	run --reverify "$RA" --codebase core
   640	assert_eq "--reverify A is refused: not the newest attempt (exit 26)" "$CODE" "26"
   641	assert_eq "…and wrote no verify record" "$(git tag -l "${NS}-verify/*" | wc -l | tr -d ' ')" "0"
   642	run --status --codebase core; assert_has "--status names B" "$OUT" "verified at ${RB}"
   643	S3="$(commit_change functions/core/index.js "exports.c = 3;")"
   644	run --diff --codebase core; assert_has "--diff diffs from B" "$OUT" "last verified attempt ${RB}"; assert_has "…showing the new line" "$OUT" "+exports.c = 3;"
   645	assert_lacks "…not from A (A's change is already in B)" "$OUT" "+exports.b = 2;"
   646	echo timeout > "$SC/probe"; run --approved "$S3" --codebase core; RC="$(newest_tag)"
   647	assert_eq "attempt C: unverified only by its probe" "$(field "$RC" deploy_match) $(field "$RC" access) $(field "$RC" deploy_verified)" "yes inconclusive no"
   648	run --status --codebase core; assert_has "--status: production may be mixed, last verified B" "$OUT" "production may be mixed: last verified ${RB}; unverified attempt ${RC}"
   649	run --diff --codebase core; assert_has "--diff warns the newest attempt is unverified" "$OUT" "NOT verified"
   650	rm -f "$SC/probe"; run --reverify "$RC" --codebase core
   651	assert_eq "--reverify C (the newest) → verified (exit 0)" "$CODE" "0"
   652	RV="$(newest_tag "${NS}-verify")"
   653	assert_eq "…a verify record naming C" "$(field "$RV" attempt)" "$RC"
   654	assert_eq "…deploy_verified=yes" "$(field "$RV" deploy_verified)" "yes"
   655	assert_eq "…C's own record is unchanged" "$(field "$RC" deploy_verified)" "no"
   656	run --status --codebase core; assert_has "…and --status now says verified at C" "$OUT" "verified at ${RC}"
   657	assert_lacks "…a verify record never counts as an attempt" "$OUT" "newest attempt:  ${RV}"
   658	echo 2 > "$SC/cli_exit"; run --approved "$S3" --codebase core; RD="$(newest_tag)"; rm -f "$SC/cli_exit"
   659	run --reverify "$RD" --codebase core
   660	assert_eq "--reverify can't upgrade cli_exit (only the read-back and probe) → exit 21" "$CODE" "21"
   661	assert_eq "…its verify record says no" "$(field "$(newest_tag "${NS}-verify")" deploy_verified)" "no"
   662	
   663	# ═══ a stale clock / a stray future-stamped tag refuses; the documented escape clears it ═════════════
   664	fixture_reset
   665	FAR_E=$(( $(date -u +%s) + 3600 )); FAR="$(date -u -r "$FAR_E" +%Y%m%dT%H%M%SZ)"
   666	GIT_COMMITTER_DATE="$(date -u -r "$FAR_E" +%Y-%m-%dT%H:%M:%S) +0000" git tag -a "${NS}/${FAR}-stray00" "$SHA1" -m "attempt=${NS}/${FAR}-stray00
   667	deploy_verified=no"
   668	git push --quiet origin "refs/tags/${NS}/${FAR}-stray00"
   669	run --approved "$SHA1" --codebase core
   670	assert_eq "a future-stamped tag the clock can't pass → refused (exit 20)" "$CODE" "20"
   671	assert_has "…NOTHING WAS CHANGED" "$OUT" "NOTHING WAS CHANGED"
   672	assert_has "…pointing at the runbook's escape" "$OUT" "FUNCTIONS-ROLLBACK.md §4"
   673	no_deploy "…the CLI never deployed"
   674	assert_eq "…no in-flight file" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   675	git tag -d "${NS}/${FAR}-stray00" >/dev/null; git push --quiet origin ":refs/tags/${NS}/${FAR}-stray00"
   676	run --approved "$SHA1" --codebase core; assert_eq "…after the escape (delete it, with Christie's OK) → deploys" "$CODE" "0"
   677	
   678	# ═══ --attest ══════════════════════════════════════════════════════════════════════════════════════════
   679	fixture_reset
   680	run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
   681	evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
   682	assert_eq "--attest with a matching reading → iam_attested=yes (exit 0)" "$CODE" "0"
   683	RT="$(newest_tag "${NS}-attest")"
   684	assert_eq "…an attest record naming the attempt" "$(field "$RT" attempt)" "$RA"
   685	assert_eq "…iam_attested=yes" "$(field "$RT" iam_attested)" "yes"
   686	assert_has "…and it names what it does not attest (bucket-level grants among them)" "$(field "$RT" not_attested)" "individual Cloud Storage buckets"
   687	run --status --codebase core; assert_has "…and --status shows it" "$OUT" "iam_attested=yes"
   688	attest_no() { evidence_iam "$T/iam.json" "$1"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
   689	  assert_eq "$2 → iam_attested=no (exit 21)" "$CODE" "21"; assert_eq "…recorded" "$(field "$(newest_tag "${NS}-attest")" iam_attested)" "no"; assert_has "…naming it" "$OUT" "$3"; }
   690	attest_no '.functions = {}' "a missing function" "canary: missing from the reading"
   691	attest_no '.functions.canary.runInvokerMembers = ["allUsers"]' "an extra run.invoker member" "run.invoker members"
   692	attest_no '.functions.canary.requireAuthentication = false' "Require authentication off, with no members" "Require authentication is OFF"
   693	attest_no '.projectRoles["roles/editor"] += ["serviceAccount:760301318440-compute@developer.gserviceaccount.com"]' "an extra Editor (a build candidate, next to the Google APIs Service Agent)" "roles/editor: holders"
   694	attest_no '.projectRoles["roles/editor"] = ["serviceAccount:other@my-clay-hub.iam.gserviceaccount.com"]' "Editor held by someone other than the Google APIs Service Agent" "roles/editor: holders"
   695	attest_no '.runtimeAccounts["canary@my-clay-hub.iam.gserviceaccount.com"] = ["roles/datastore.user"]' "a role on the canary's account" "canary@my-clay-hub.iam.gserviceaccount.com: roles"
   696	attest_no '.buildAccount = "someone@x.iam.gserviceaccount.com"' "a build account that is neither candidate" "neither build candidate"
   697	L='serviceAccount:760301318440@cloudbuild.gserviceaccount.com'
   698	attest_no '.buildAccount = "760301318440@cloudbuild.gserviceaccount.com"' "the legacy account built while the O3 roles stay on Compute (F7)" "expected only the build account ${L}"
   699	SV='.buildRoleBindings["roles/storage.objectViewer"]'
   700	attest_no "${SV}[0].condition = \"resource.name.startsWith(\\\"projects/_/buckets/\\\")\"" "a widened Storage Object Viewer condition" "its condition is not Appendix A5"
   701	attest_no "${SV}[0].condition = null" "the Storage Object Viewer binding with no condition" "its condition is not Appendix A5"
   702	attest_no "${SV} += [{\"member\": ${SV}[0].member, \"condition\": null}]" "a second, UNCONDITIONAL binding of the same account next to the A5 one" "2 project-level bindings, expected exactly one"
   703	attest_no '.buildRoleBindings["roles/logging.logWriter"][0].condition = "request.time < timestamp(\"2030-01-01T00:00:00Z\")"' "a Logs Writer binding with a condition" "its condition is not none"
   704	attest_no 'del(.buildRoleBindings["roles/logging.logWriter"])' "a build role not read" "build role bindings read for"
   705	attest_no '.artifactRegistryWriters.repository = []' "no Artifact Registry Writer on the repository" "Artifact Registry Writer on"
   706	attest_no '.artifactRegistryWriters.repository += ["user:someone@x.com"]' "an extra Artifact Registry Writer on the repository" "Artifact Registry Writer on"
   707	attest_no '.artifactRegistryWriters.project = ["serviceAccount:other@my-clay-hub.iam.gserviceaccount.com"]' "Artifact Registry Writer granted at project level" "granted at PROJECT level"
   708	# FUNCTIONS-ROLLBACK.md §3: Google built with the legacy account, and the O3 roles were moved to it → attests yes
   709	LG='serviceAccount:760301318440@cloudbuild.gserviceaccount.com'
   710	evidence_iam "$T/iam.json" ".buildAccount = \"760301318440@cloudbuild.gserviceaccount.com\"
   711	  | .buildRoleBindings[\"roles/logging.logWriter\"][0].member = \"${LG}\"
   712	  | .buildRoleBindings[\"roles/storage.objectViewer\"][0].member = \"${LG}\"
   713	  | .artifactRegistryWriters.repository = [\"${LG}\"]"
   714	run --attest "$RA" --codebase core --evidence "$T/iam.json"
   715	assert_eq "the legacy account built AND holds the O3 roles alone (§3's move) → iam_attested=yes" "$CODE" "0"
   716	attest_no 'del(.projectRoles["roles/cloudbuild.builds.builder"])' "a reading that leaves out the Cloud Build builder role (F7)" "project roles read"
   717	attest_no '.projectRoles["roles/cloudbuild.builds.builder"] = ["serviceAccount:760301318440@cloudbuild.gserviceaccount.com"]' "the legacy build account holding builder again" "roles/cloudbuild.builds.builder: holders"
   718	run --status --codebase core; assert_has "--status shows the newest attestation (no)" "$OUT" "iam_attested=no"
   719	echo '{"functions":{}}' > "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
   720	assert_eq "a reading not in the fixed shape → refused (exit 25)" "$CODE" "25"
   721	run --approved "$SHA1" --codebase core; evidence_iam "$T/iam.json"
   722	run --attest "$RA" --codebase core --evidence "$T/iam.json"
   723	assert_eq "attesting an attempt that is no longer the newest → refused (exit 26)" "$CODE" "26"
   724	# a runtime account the attempt declares but iam-expectations.json doesn't name: its roles were never read
   725	fixture_reset
   726	"$JQ" '.["core/canary"].serviceAccount = "reports@my-clay-hub.iam.gserviceaccount.com"' functions/declarations.json > d.new && mv d.new functions/declarations.json
   727	git commit --quiet -am "canary runs as reports@"; git push --quiet; SR="$(git rev-parse HEAD)"
   728	manifest_edit '.endpoints.canary.serviceAccountEmail = "reports@my-clay-hub.iam.gserviceaccount.com"'
   729	run --approved "$SR" --codebase core; RA="$(newest_tag)"
   730	evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
   731	assert_eq "a declared runtime account missing from iam-expectations.json → iam_attested=no" "$CODE" "21"
   732	assert_has "…naming it" "$OUT" "reports@my-clay-hub.iam.gserviceaccount.com is declared but not in functions/iam-expectations.json"
   733	
   734	# ═══ whether a deploy needs Christie's IAM reading (Christie, Oct 1 2026) ══════════════════════════════════
   735	fixture_reset
   736	run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
   737	assert_eq "a first deploy → attest_needed=yes" "$(field "$RA" attest_needed)" "yes"
   738	assert_has "…because nothing is attested yet" "$(field "$RA" attest_needed_why)" "no attempt of core has iam_attested=yes yet"
   739	assert_has "…and it prints the reading to take" "$OUT" "IAM reading NEEDED"; assert_has "…with the JSON shape" "$OUT" "next: Christie's IAM reading"
   740	evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"; assert_eq "…attested yes" "$CODE" "0"
   741	SA="$(commit_change functions/core/index.js "exports.a1 = 1;")"
   742	run --approved "$SA" --codebase core; RB="$(newest_tag)"
   743	assert_eq "a source-only change after an attested deploy → verified (exit 0)" "$CODE" "0"
   744	assert_eq "…attest_needed=no" "$(field "$RB" attest_needed)" "no"
   745	assert_has "…naming the attested attempt it relies on" "$(field "$RB" attest_needed_why)" "last attested ${RA}"
   746	assert_has "…and it says so" "$OUT" "IAM reading not needed"; assert_lacks "…without the reading's JSON shape" "$OUT" "next: Christie's IAM reading"
   747	: > "$SC/api_enabled"; SB="$(commit_change functions/core/index.js "exports.a2 = 2;")"
   748	run --approved "$SB" --codebase core; RC="$(newest_tag)"; rm -f "$SC/api_enabled"
   749	assert_eq "the CLI enabled a Google API during the deploy → attest_needed=yes" "$(field "$RC" attest_needed)" "yes"
   750	assert_has "…naming it" "$(field "$RC" attest_needed_why)" "the CLI enabled a Google API"
   751	assert_has "…and it prints the reading to take" "$OUT" "next: Christie's IAM reading"
   752	SC2="$(commit_change functions/core/index.js "exports.a3 = 3;")"
   753	run --approved "$SC2" --codebase core; RD="$(newest_tag)"
   754	assert_eq "a reading owed by the API deploy was never taken → the next source-only deploy still needs it" "$(field "$RD" attest_needed)" "yes"
   755	assert_has "…naming the attempt that owes it" "$(field "$RD" attest_needed_why)" "${RC} needed a reading, or its reading came back no"
   756	evidence_iam "$T/iam.json"; run --attest "$RD" --codebase core --evidence "$T/iam.json"; assert_eq "…once the newest attempt is attested yes" "$CODE" "0"
   757	SD="$(commit_change functions/core/index.js "exports.a5 = 5;")"
   758	run --approved "$SD" --codebase core; RG="$(newest_tag)"
   759	assert_eq "…the next source-only deploy → no" "$(field "$RG" attest_needed)" "no"
   760	assert_has "…relying on that attestation" "$(field "$RG" attest_needed_why)" "last attested ${RD}"
   761	SE="$(commit_change functions/iam-expectations.json "")"   # any change to the file counts, even a blank line
   762	run --approved "$SE" --codebase core; RE="$(newest_tag)"
   763	assert_eq "functions/iam-expectations.json changed since the attested attempt → attest_needed=yes" "$(field "$RE" attest_needed)" "yes"
   764	assert_has "…naming the file" "$(field "$RE" attest_needed_why)" "changed since ${RD}: functions/iam-expectations.json"
   765	# an attempt from before this rule (no attest_needed field) between the attested one and now: the reading is owed
   766	git tag -d "$RE" >/dev/null; git push --quiet origin ":refs/tags/$RE"   # (drop the iam-file attempt so only the old-style one is in between)
   767	git for-each-ref --format='%(contents)' "refs/tags/$RG" | grep -v '^attest_needed' > "$T/old.msg"
   768	git tag -d "$RG" >/dev/null; git push --quiet origin ":refs/tags/$RG"; git tag -a -F "$T/old.msg" "$RG" "$SD"; git push --quiet origin "refs/tags/$RG"
   769	SH="$(commit_change functions/core/index.js "exports.a6 = 6;")"
   770	run --approved "$SH" --codebase core; RH="$(newest_tag)"
   771	assert_eq "an unattested attempt from before this rule in between → attest_needed=yes (fail-closed)" "$(field "$RH" attest_needed)" "yes"
   772	assert_has "…naming it" "$(field "$RH" attest_needed_why)" "${RG} needed a reading, or its reading came back no"
   773	: > "$SC/skip_line"; SF="$(commit_change functions/core/index.js "exports.a4 = 4;")"
   774	run --approved "$SF" --codebase core; RF="$(newest_tag)"; rm -f "$SC/skip_line"
   775	assert_eq "an unverified deploy → attest_needed=yes" "$(field "$RF" attest_needed)" "yes"
   776	assert_has "…saying so" "$(field "$RF" attest_needed_why)" "the deploy is not verified"
   777	run --status --codebase core; assert_has "--status shows attest_needed and why" "$OUT" "attest_needed=yes — the deploy is not verified"
   778	# a reading that came back no stays owed, even for an attempt that didn't need one
   779	fixture_reset
   780	run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
   781	evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
   782	SA="$(commit_change functions/core/index.js "exports.b1 = 1;")"; run --approved "$SA" --codebase core; RB="$(newest_tag)"
   783	assert_eq "…(a source-only deploy after an attested one needs none)" "$(field "$RB" attest_needed)" "no"
   784	evidence_iam "$T/iam.json" '.projectRoles["roles/editor"] += ["user:someone@x.com"]'; run --attest "$RB" --codebase core --evidence "$T/iam.json"
   785	assert_eq "…an optional reading finds a mismatch → iam_attested=no" "$CODE" "21"
   786	SB="$(commit_change functions/core/index.js "exports.b2 = 2;")"; run --approved "$SB" --codebase core; RC="$(newest_tag)"
   787	assert_eq "a known iam_attested=no since the last yes → the next deploy needs a reading" "$(field "$RC" attest_needed)" "yes"
   788	assert_has "…naming the attempt" "$(field "$RC" attest_needed_why)" "${RB} needed a reading, or its reading came back no"
   789	# the transcript exists but can't be read (grep exits 2): needed, never "no API enabled"
   790	: > "$SC/grep_fail"; SC3="$(commit_change functions/core/index.js "exports.b3 = 3;")"; run --approved "$SC3" --codebase core; RD="$(newest_tag)"; rm -f "$SC/grep_fail"
   791	assert_eq "an unreadable transcript → attest_needed=yes" "$(field "$RD" attest_needed)" "yes"
   792	assert_has "…saying so" "$(field "$RD" attest_needed_why)" "could not read the transcript"
   793	
   794	# ═══ the verifier: the pushed tip's guard, and a changed guard needs Christie's OK ═════════════════════
   795	fixture_reset
   796	run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
   797	echo "# local edit" >> scripts/deploy-functions.sh
   798	run --reverify "$RA" --codebase core; assert_eq "a DIRTY guard refuses (exit 27)" "$CODE" "27"; assert_has "…saying why" "$OUT" "not origin/main's"
   799	git commit --quiet -am "unpushed guard edit"
   800	run --reverify "$RA" --codebase core; assert_eq "an UNPUSHED guard refuses (exit 27)" "$CODE" "27"
   801	run --approved "$SHA1" --codebase core; assert_eq "…--approved too" "$CODE" "27"; no_deploy "…never deployed"
   802	git push --quiet
   803	run --reverify "$RA" --codebase core
   804	assert_eq "once pushed, the guard changed since the attempt → refused without Christie's OK (exit 27)" "$CODE" "27"
   805	assert_has "…naming the change" "$OUT" "first at scripts/deploy-functions.sh"
   806	run --reverify "$RA" --codebase core --acknowledge-verifier-change
   807	assert_eq "…with --acknowledge-verifier-change → re-verified (exit 0)" "$CODE" "0"
   808	assert_has "…and the record says so" "$(field "$(newest_tag "${NS}-verify")" verifier_changed)" "yes (scripts/deploy-functions.sh)"
   809	assert_eq "…and names the commit whose helpers rebuilt the expected state" "$(field "$(newest_tag "${NS}-verify")" rebuild_helpers_from)" "$SHA1"
   810	fixture_reset
   811	run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
   812	commit_change scripts/lib/functions-hash.mjs "// a changed hash module" >/dev/null
   813	run --reverify "$RA" --codebase core
   814	assert_eq "a changed HELPER (the hash module) since the attempt → refused without Christie's OK (exit 27)" "$CODE" "27"
   815	assert_has "…naming it" "$OUT" "first at scripts/lib/functions-hash.mjs"
   816	# control files: an older commit whose machinery differs from the tip is refused
   817	fixture_reset
   818	"$JQ" '.' functions/declarations.json > d.new && printf '\n' >> d.new && mv d.new functions/declarations.json; git commit --quiet -am "touch declarations"; git push --quiet
   819	run --approved "$SHA1" --codebase core
   820	assert_eq "an older commit whose declarations differ from the tip → exit 14" "$CODE" "14"; assert_has "…naming it" "$OUT" "carries a different functions/declarations.json"
   821	no_deploy "…never deployed"
   822	
   823	# ═══ the record can't be written or published ══════════════════════════════════════════════════════════
   824	fixture_reset
   825	git config remote.origin.pushurl /nonexistent/path
   826	run --approved "$SHA1" --codebase core
   827	assert_eq "the record's push fails → exit 17" "$CODE" "17"; assert_has "…RECORD NOT PUBLISHED" "$OUT" "RECORD NOT PUBLISHED"
   828	assert_eq "…the local record exists" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "1"
   829	assert_eq "…the in-flight file is gone (the record exists)" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   830	run --approved "$SHA1" --codebase core
   831	assert_eq "still unpushable → the next run refuses first (exit 12)" "$CODE" "12"; no_deploy "…without deploying"
   832	git config --unset remote.origin.pushurl
   833	run --approved "$SHA1" --codebase core
   834	assert_eq "pushable again → the pending record is published, then the deploy runs" "$CODE" "0"
   835	assert_has "…said so" "$OUT" "publishing the record left behind"
   836	assert_eq "…both records on origin" "$(git ls-remote --tags origin "refs/tags/${NS}/*" | grep -vc '\^{}' | tr -d ' ')" "2"
   837	fixture_reset
   838	FAIL_GIT=tag FAIL_GIT_ARG=-a run --approved "$SHA1" --codebase core
   839	assert_eq "the record can't be written → exit 17" "$CODE" "17"; assert_has "…RECORD NOT WRITTEN, with the command" "$OUT" "git tag -a ${NS}/"
   840	assert_eq "…the in-flight file stays" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "present"
   841	run --approved "$SHA1" --codebase core; assert_eq "…so the next --approved refuses (exit 22)" "$CODE" "22"
   842	
   843	# ═══ shared code: both guards order an identical tag set identically ═══════════════════════════════════
   844	# Built so that a wrong ordering names a DIFFERENT tag (the standing rule): the stamp is the primary key even when tag
   845	# dates disagree, and an exact stamp tie is broken by the tag instant across UTC offsets, not by refname.
   846	fixture_reset
   847	RNS='deployed/my-clay-hub/firestore-rules'
   848	plant() {  # <ns> <stamp> <suffix> <tag date>
   849	  GIT_COMMITTER_DATE="$4" git tag -a "$1/$2-$3" "$SHA1" -m "attempt=$1/$2-$3
   850	project=my-clay-hub commit=$SHA1 by=seeded
   851	deploy_verified=yes"
   852	}
   853	for ns in "$RNS" "$NS"; do
   854	  plant "$ns" 20260101T000000Z aaaaaa1 "2026-06-01T00:00:00 +0000"   # shipped first, tagged late
   855	  plant "$ns" 20260201T000000Z zzzzzzz "2026-02-01T12:00:05 +0000"   # same stamp as the next: the EARLIER instant, higher refname
   856	  plant "$ns" 20260201T000000Z aaaaaa9 "2026-02-01T06:00:10 -0600"   # 12:00:10Z — the LATER instant, lower refname
   857	done
   858	OUT="$(bash scripts/deploy-rules.sh --status 2>&1)"
   859	assert_has "the rules guard names the later-instant tag of the newest stamp" "$OUT" "20260201T000000Z-aaaaaa9"
   860	run --status --codebase core
   861	assert_has "the functions guard names the same one" "$OUT" "newest attempt:  ${NS}/20260201T000000Z-aaaaaa9"
   862	assert_lacks "…not the higher refname" "$OUT" "20260201T000000Z-zzzzzzz"
   863	assert_lacks "…nor the later tag date" "$OUT" "20260101T000000Z-aaaaaa1"
   864	
   865	# ═══ real npm: npm ci --prefix leaves the symlinked root node_modules untouched (F5) ═══════════════════
   866	N22=/opt/homebrew/opt/node@22/bin/node; NPMC=/opt/homebrew/opt/node@22/lib/node_modules/npm/bin/npm-cli.js
   867	if [ -x "$N22" ] && [ -f "$NPMC" ]; then
   868	  RN="$T/realnpm"; mkdir -p "$RN/shared/marker" "$RN/root/functions/core"
   869	  echo keep > "$RN/shared/marker/file"; ln -s "$RN/shared" "$RN/root/node_modules"
   870	  echo '{"name":"core","version":"1.0.0","private":true}' > "$RN/root/functions/core/package.json"
   871	  echo '{"name":"core","version":"1.0.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"core","version":"1.0.0"}}}' > "$RN/root/functions/core/package-lock.json"
   872	  BEFORE_LS="$(cd "$RN/shared" && find . | LC_ALL=C sort)"
   873	  (cd "$RN/root" && PATH="$(dirname "$N22"):$PATH" HOME="$RN" npm_config_cache="$RN/cache" "$N22" "$NPMC" ci --prefix "$RN/root/functions/core" --offline --no-audit --no-fund >/dev/null 2>&1)
   874	  assert_eq "real npm ci --prefix under Node 22 succeeds" "$?" "0"
   875	  assert_eq "…the root node_modules is still a symlink" "$([ -L "$RN/root/node_modules" ] && echo symlink || echo replaced)" "symlink"
   876	  assert_eq "…and what it points at is untouched" "$(cd "$RN/shared" && find . | LC_ALL=C sort)" "$BEFORE_LS"
   877	else
   878	  echo "  - SKIPPED: real npm ci --prefix (no Node 22 at $N22)"
   879	fi
   880	
   881	echo
   882	echo "functions guard tests: $PASS passed, $FAIL failed"
   883	[ "$FAIL" -eq 0 ]
   105	
   106	## 6. The canary
   107	
   108	`core/canary` is permanent: it proves the deploy path end to end and does nothing. Its runtime account `canary@` holds
   109	no roles and must keep none (`functions/iam-expectations.json`). Don't delete it or grant it anything.
   110	
   111	## 7. After a deploy: --attest, --reverify, and a changed guard
   112	
   113	- **When a reading is needed** (Christie, Oct 1 2026 — replaces "every deploy"): every attempt record (`--approved`,
   114	  `--reconcile`, `--clear-inflight`) carries `attest_needed=yes|no` and why, and `--status` shows it. A reading is
   115	  **needed** when the deploy isn't verified; when no attempt of the codebase has `iam_attested=yes` yet; when the
   116	  function set, `functions/declarations.json`, `functions/iam-expectations.json`, `firebase.json` or `.firebaserc`
   117	  changed since the newest attested attempt; when the CLI turned on a Google API during the deploy (Google can add role
   118	  grants then — D2-5's Editor grant came that way), or the transcript can't be read to tell; or when an attempt since
   119	  the last attested one still owes a reading — it needed one and never got a yes, or its reading came back `no` (one
   120	  from before this rule counts as owing). Anything unreadable counts as needed. Otherwise the guard says "IAM reading not needed" and names the attested attempt it relies on. The automatic
   121	  checks (hash, settings, the unauthenticated probe) run on every deploy either way. **Not seen:** a role someone
   122	  changes by hand in the Console — after one, take a reading anyway.
   123	- **--attest** (when needed, M3 and F7): Christie reads each function's Security tab ("Require authentication") and
   124	  Permissions (the full `run.invoker` list); IAM "View by roles" — the holders of every role in
   125	  `functions/iam-expectations.json` (`run.invoker`, `cloudfunctions.invoker`, `owner`, `editor`,
   126	  `cloudbuild.builds.builder`) and each runtime account's roles; every **binding row** of the build roles
   127	  `logging.logWriter` and `storage.objectViewer` (member and condition — one row each, to the build account; a second,
   128	  unconditional row would override the conditioned one); the holders of `artifactregistry.writer` at **project** level
   129	  (expected none) and directly on Artifact Registry → `gcf-artifacts` → Permissions (the build account only); and
   130	  Cloud Build → History (the build id, status and service account). The
   131	  deploy prints the JSON shape, generated from `iam-expectations.json`; then
   132	  `--attest <attempt> --codebase core --evidence <file>`. The script compares it with `functions/declarations.json` and
   133	  `functions/iam-expectations.json` and records `iam_attested=yes` or `no` (with every difference). Only the newest
   134	  attempt can be attested. **Not attested** (the record says so): folder- and organization-level grants, which
   135	  Christie can't read, and grants on individual Cloud Storage buckets or managed folders, which don't appear on the
   136	  IAM project page (Christie, Sep 30: a known limit, not read).
   137	- **--reverify <attempt>**: re-reads production and re-probes the **newest** attempt only (production can only speak
   138	  for the attempt that put it there). It carries the attempt's `cli_exit`, backstop and skip-line results forward, so it
   139	  can upgrade only the read-back and the probe. Its record goes under `…/functions-<cb>-verify/`.
   140	- **A changed guard.** Every tag-writing mode refuses unless the guard running is `origin/main`'s (not dirty, not
   141	  unpushed). If the guard's machinery changed between the attempt and now, `--reconcile`, `--reverify`,
   142	  `--clear-inflight` and `--attest` refuse until Christie OKs it; then re-run with `--acknowledge-verifier-change`, and
   143	  the record says `verifier_changed=yes`. The verdicts are always the tip's code; rebuilding an attempt's expected
   144	  state uses that attempt's own backstop, discovery and hash module (they made what it recorded), and the record names
   145	  that commit as `rebuild_helpers_from`.
   146	
   147	## 8. The pinned FIREBASE_CONFIG
   148	
   149	`functions/firebase-config.json` is the body the CLI puts in `FIREBASE_CONFIG` (Firebase's admin-SDK config: project
   150	id, bucket, location — not a secret). It's pinned rather than fetched, so no script uses the Firebase login (Christie,

exec
/bin/zsh -lc "nl -ba scripts/deploy-functions.sh | sed -n '888,1135p'
nl -ba scripts/deploy-functions.test.sh | sed -n '80,180p'
nl -ba scripts/deploy-functions.test.sh | sed -n '400,575p'
git diff c562f69"'^ c562f69 --unified=35 -- scripts/deploy-functions.test.sh scripts/deploy-functions.sh' in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
   888	  { cat "$INFLIGHT"; printf 'cli_exit=%s\n' "$CLI_EXIT"; } | atomic_write "$INFLIGHT" || warn "could not add cli_exit to ${INFLIGHT} (a --reconcile will record cli_exit=unknown)"
   889	  transcript_flags "$TRANSCRIPT" "$SHA"
   890	  say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
   891	
   892	  MSG="${WORK}/record"
   893	  {
   894	    printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$TREE"
   895	    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
   896	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   897	      printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
   898	    done
   899	    printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   900	  } > "$MSG"
   901	  read_back "$MSG"
   902	  verifier_fields "$SHA" "$MSG"
   903	  attest_need "$MSG"
   904	  printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   905	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   906	  rm -f "$INFLIGHT"
   907	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   908	  attest_report
   909	  if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   910	  printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   911	  exit $EX_UNVERIFIED
   912	fi
   913	
   914	# ─── --reconcile / --clear-inflight ────────────────────────────────────────────────────────────────────
   915	if [ "$MODE" = "reconcile" ] || [ "$MODE" = "clear-inflight" ]; then
   916	  [ -f "$INFLIGHT" ] || die $EX_INFLIGHT "there is no in-flight file (${INFLIGHT}) — nothing to reconcile."
   917	  inflight_valid || die $EX_INFLIGHT "${INFLIGHT} is malformed (truncated, or edited) — refusing to guess what it recorded. Show it to Christie; FUNCTIONS-ROLLBACK.md §2."
   918	  [ "$(inflight_get codebase)" = "$CB" ] || die $EX_INFLIGHT "the in-flight attempt is for codebase $(inflight_get codebase), not ${CB}."
   919	  TAG="$(inflight_get attempt)"; STAMP="$(inflight_get stamp)"; SHA="$(inflight_get commit)"; IDS="$(inflight_get functions)"
   920	  if [ "$MODE" = "clear-inflight" ] && [ "$ATTEMPT_ARG" != "$TAG" ]; then
   921	    die $EX_INFLIGHT "the in-flight attempt is ${TAG}, not ${ATTEMPT_ARG} — name it exactly."
   922	  fi
   923	  IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
   924	  [ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
   925	  "$JQ" -e --argjson ids "$IDS_JSON" --arg mode "$([ "$MODE" = reconcile ] && echo reconcile || echo clear)" "$JQ_EVIDENCE_OP" "$EVIDENCE" >/dev/null 2>&1 \
   926	    || die $EX_EVIDENCE "the evidence is not in the fixed shape: {\"confirmation\": \"<Christie's words>\", \"functions\": {\"<id>\": {\"buildId\": \"<uuid>\", \"buildStatus\": \"<status>\", \"latestReadyRevision\": \"<id>-000NN-xxx\"$([ "$MODE" = clear-inflight ] && echo ' (or null)')}}} for exactly ${IDS}$([ "$MODE" = reconcile ] && echo ', with a finished build')."
   927	  EVJSON="$("$JQ" -c . "$EVIDENCE")"
   928	  if git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null 2>&1; then
   929	    die $EX_INFLIGHT "the record ${TAG} already exists, so the attempt was recorded before the in-flight file could be removed. Check it (git show ${TAG}); if it names ${SHA:0:12}, remove ${INFLIGHT} by hand with Christie's OK."
   930	  fi
   931	  MSG="${WORK}/record"
   932	  CLI_EXIT="$(inflight_get cli_exit 2>/dev/null || echo unknown)"
   933	  {
   934	    printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$(inflight_get tree)"
   935	    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$(inflight_get manifest_sha256)" "$IDS" "$(inflight_get before_digest)"
   936	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   937	      printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
   938	    done
   939	  } > "$MSG"
   940	
   941	  if [ "$MODE" = "clear-inflight" ]; then
   942	    MSHA="$(inflight_get manifest_sha256)"; TREE="$(inflight_get tree)"
   943	    transcript_flags "$(inflight_get transcript)" "$SHA"
   944	    {
   945	      printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   946	      printf 'after_digest=unknown\nfunctions_unchanged=unknown\ndeploy_match=unknown\naccess=not-probed\ndeploy_verified=no\n'
   947	      printf 'evidence=%s\n' "$EVJSON"
   948	    } >> "$MSG"
   949	    verifier_fields "$SHA" "$MSG"
   950	    DEPLOY_VERIFIED=no; TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
   951	    printf 'at=%s\nby=deploy-functions.sh --clear-inflight\n' "$STAMP" >> "$MSG"
   952	    PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   953	    rm -f "$INFLIGHT"
   954	    [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   955	    attest_report
   956	    say "✔ cleared: ${TAG} recorded with deploy_match=unknown (its original stamp). Production is NOT verified; the next --approved may run."
   957	    exit 0
   958	  fi
   959	
   960	  # --reconcile: rebuild the expected state from the attempt's commit and prove it's the same manifest and hashes.
   961	  verifier_fields "$SHA" "$MSG"   # refuses early (before the rebuild) if the machinery changed and Christie hasn't OK'd it
   962	  build_expected "$SHA"
   963	  [ "$MSHA" = "$(inflight_get manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the one the attempt sealed ($(inflight_get manifest_sha256)) — refusing to verify against a different manifest."
   964	  [ "$TREE" = "$(inflight_get tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   965	  [ "$IDS" = "$(inflight_get functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   966	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   967	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(inflight_get "expected_hash.${id}")" ] \
   968	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one recorded before the CLI call."
   969	  done
   970	  NOW="${WORK}/now.json"
   971	  list_live "$TMP" "$NOW" || die $EX_FETCH "could not read production (functions:list): $(list_why "$NOW") — try again."
   972	  DEPLOYING="$("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb and .state == "DEPLOYING") | .id] | join(",")' "$NOW")"
   973	  [ -z "$DEPLOYING" ] || die $EX_INFLIGHT "${DEPLOYING} still DEPLOYING — the operation hasn't finished; wait, then reconcile."
   974	  BEFORE_DIGEST="$(inflight_get before_digest)"
   975	  transcript_flags "$(inflight_get transcript)" "$SHA"
   976	  printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN" >> "$MSG"
   977	  read_back "$MSG"
   978	  TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
   979	  printf 'evidence=%s\nat=%s\nby=deploy-functions.sh --reconcile\n' "$EVJSON" "$STAMP" >> "$MSG"
   980	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   981	  rm -f "$INFLIGHT"
   982	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   983	  attest_report
   984	  say "✔ reconciled: ${TAG} recorded with its original stamp; deploy_verified=${DEPLOY_VERIFIED}."
   985	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   986	  exit $EX_UNVERIFIED
   987	fi
   988	
   989	# ─── --reverify / --attest: only for the newest attempt ────────────────────────────────────────────────
   990	[ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an interrupted deploy comes first (FUNCTIONS-ROLLBACK.md §2)."
   991	NEWEST="$(latest_receipt "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB}."
   992	[ -n "$NEWEST" ] || die $EX_NOT_NEWEST "there is no attempt for ${CB} yet."
   993	[ "$ATTEMPT_ARG" = "$NEWEST" ] || die $EX_NOT_NEWEST "${ATTEMPT_ARG} is not the newest attempt (${NEWEST}). Today's production can only speak for the attempt that put it there."
   994	SHA="$(commit_of "$NEWEST")"
   995	for k in commit manifest_sha256 functions tree; do
   996	  record_field "$NEWEST" "$k" >/dev/null || die $EX_RECORD "the attempt ${NEWEST} has no readable ${k} — refusing."
   997	done
   998	[ "$(record_field "$NEWEST" commit)" = "$SHA" ] || die $EX_RECORD "the attempt ${NEWEST} names a different commit than it points at."
   999	IDS="$(record_field "$NEWEST" functions)"
  1000	IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
  1001	MSG="${WORK}/record"
  1002	
  1003	if [ "$MODE" = "reverify" ]; then
  1004	  : > "$MSG"
  1005	  verifier_fields "$SHA" "$MSG"
  1006	  CLI_EXIT="$(record_field "$NEWEST" cli_exit)" || die $EX_RECORD "the attempt ${NEWEST} has no readable cli_exit."
  1007	  BACKSTOP_SEEN="$(record_word "$NEWEST" backstop_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable backstop_seen."
  1008	  SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
  1009	  BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
  1010	  build_expected "$SHA"
  1011	  [ "$MSHA" = "$(record_field "$NEWEST" manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the attempt's."
  1012	  [ "$TREE" = "$(record_field "$NEWEST" tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
  1013	  [ "$IDS" = "$(record_field "$NEWEST" functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
  1014	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
  1015	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
  1016	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
  1017	  done
  1018	  reserve_stamp "$VERIFY_PREFIX" "${SHA:0:7}"
  1019	  VMSG="${WORK}/verify"
  1020	  {
  1021	    printf 'format=tinker-functions-verify-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
  1022	    printf 'carried=cli_exit=%s backstop_seen=%s skip_line_seen=%s (from the attempt)\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
  1023	  } > "$VMSG"
  1024	  read_back "$VMSG"
  1025	  cat "$MSG" >> "$VMSG"
  1026	  printf 'at=%s\nby=deploy-functions.sh --reverify\n' "$STAMP" >> "$VMSG"
  1027	  write_record "$TAG" "$SHA" "$VMSG" || exit $EX_RECEIPT
  1028	  say "✔ verify record ${TAG} for ${NEWEST}: deploy_verified=${DEPLOY_VERIFIED}."
  1029	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
  1030	  exit $EX_UNVERIFIED
  1031	fi
  1032	
  1033	# --attest
  1034	[ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
  1035	"$JQ" -e "$JQ_ATTEST_SHAPE" "$EVIDENCE" >/dev/null 2>&1 \
  1036	  || die $EX_EVIDENCE "the IAM reading is not in the fixed shape (see the --attest instructions a deploy prints, and FUNCTIONS-ROLLBACK.md)."
  1037	: > "$MSG"
  1038	verifier_fields "$SHA" "$MSG"
  1039	DC="$(git show "${SHA}:functions/declarations.json" | "$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries')" \
  1040	  || die $EX_RECORD "could not read the attempt's declarations."
  1041	IAM="$(git show "${SHA}:functions/iam-expectations.json" | "$JQ" -c .)" || die $EX_RECORD "could not read the attempt's functions/iam-expectations.json."
  1042	[ "$(printf '%s' "$IAM" | "$JQ" -r .project)" = "$PROJECT" ] || die $EX_CONFIG "functions/iam-expectations.json is not for ${PROJECT}."
  1043	REASONS="$("$JQ" -r --argjson ids "$IDS_JSON" --argjson dc "$DC" --argjson iam "$IAM" --arg pn "$PROJECT_NUMBER" "$JQ_ATTEST" "$EVIDENCE" 2>&1)" \
  1044	  || die $EX_EVIDENCE "could not compare the reading: ${REASONS}"
  1045	if [ -z "$REASONS" ]; then IAM_ATTESTED=yes; else IAM_ATTESTED=no; fi
  1046	reserve_stamp "$ATTEST_PREFIX" "${SHA:0:7}"
  1047	AMSG="${WORK}/attest"
  1048	{
  1049	  printf 'format=tinker-functions-attest-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
  1050	  printf 'iam_attested=%s\n' "$IAM_ATTESTED"
  1051	  if [ -n "$REASONS" ]; then printf 'mismatch=%s\n' "$(printf '%s' "$REASONS" | tr '\n' '|')"; fi
  1052	  printf 'evidence=%s\n' "$("$JQ" -c . "$EVIDENCE")"
  1053	  printf 'not_attested=folder- and organization-level grants (Christie cannot read them); grants on individual Cloud Storage buckets or managed folders (not on the IAM project page; outside what --attest reads, Christie Sep 30)\n'
  1054	} > "$AMSG"
  1055	cat "$MSG" >> "$AMSG"
  1056	printf 'at=%s\nby=deploy-functions.sh --attest\n' "$STAMP" >> "$AMSG"
  1057	say "─── IAM reading for ${NEWEST} ───"
  1058	[ -z "$REASONS" ] || printf '%s\n' "$REASONS" | sed 's/^/  - /'
  1059	write_record "$TAG" "$SHA" "$AMSG" || exit $EX_RECEIPT
  1060	say "iam_attested=${IAM_ATTESTED} for ${NEWEST}."
  1061	[ "$IAM_ATTESTED" = yes ] && exit 0
  1062	exit $EX_UNVERIFIED
    80	cp "\$SC/manifest.json" "\$O/functions.yaml"
    81	OUTREAL="\$(cd "\$O" && pwd -P)"
    82	cfg="\$(/usr/bin/jq -c . "\$F")"
    83	h="\$(fake_hash "\$S" "\$cfg")"
    84	/usr/bin/jq -c --arg path "\$OUTREAL/functions.yaml" --arg sha "\$(shasum -a 256 "\$O/functions.yaml" | cut -d' ' -f1)" \
    85	   --arg cfg "\$cfg" --arg h "\$h" --arg rt "\$(cat "\$SC/runtime" 2>/dev/null || echo nodejs22)" \
    86	   --argjson params "\$(cat "\$SC/params" 2>/dev/null || echo '[]')" '
    87	  { firebaseFunctionsVersion: "7.4.0", manifestPath: \$path, manifestSha256: \$sha, manifest: .,
    88	    build: { params: \$params, endpoints: (.endpoints | map_values({runtime: \$rt})) },
    89	    firebaseConfigEnv: \$cfg, sourceHash: "x", expectedHashes: (.endpoints | map_values(\$h)) }' "\$SC/manifest.json"
    90	EOF
    91	cat > "$T/fake-cli.sh" <<EOF
    92	#!/bin/bash
    93	SC="$SC"; . "$T/hash.sh"
    94	echo "cli \$* cwd=\$PWD" >> "\$SC/log"
    95	case "\${1:-}" in
    96	  --version) cat "\$SC/cli_version" 2>/dev/null || echo 15.22.3; exit 0 ;;
    97	  functions:list)
    98	    echo x >> "\$SC/list_calls"; n="\$(wc -l < "\$SC/list_calls" | tr -d ' ')"
    99	    if [ -f "\$SC/list_block_\$n" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
   100	    mode="\$(cat "\$SC/list_mode_\$n" 2>/dev/null || echo ok)"
   101	    case "\$mode" in
   102	      error) echo '{"status":"error","error":"simulated list failure"}'; exit 1 ;;
   103	      malformed) printf '{"status":"success","result":'; exit 0 ;;
   104	    esac
   105	    /usr/bin/jq -c '{status: "success", result: .}' "\$SC/live.json"; exit 0 ;;
   106	  deploy)
   107	    echo "env GAC=\${GOOGLE_APPLICATION_CREDENTIALS:-<unset>} SHA=\${TINKER_DEPLOY_SHA:-} CB=\${TINKER_DEPLOY_CODEBASE:-} MSHA=\${TINKER_DEPLOY_MANIFEST_SHA256:-} QP=\${GOOGLE_CLOUD_QUOTA_PROJECT:-<unset>}" >> "\$SC/log"
   108	    echo "workdir-mode=\$(stat -f %Lp "\$(dirname "\$PWD")")" >> "\$SC/log"
   109	    only="\$(printf '%s\n' "\$@" | awk '/^--only\$/{getline; print}')"; cb="\${only#functions:}"
   110	    hook="\$(/usr/bin/jq -r --arg cb "\$cb" '.functions[] | select(.codebase == \$cb) | .predeploy[0]' firebase.json)"
   111	    # firebase-tools runs the hook with GCLOUD_PROJECT, PROJECT_DIR and RESOURCE_DIR (lib/deploy/lifecycleHooks.js).
   112	    out="\$(GCLOUD_PROJECT=my-clay-hub PROJECT_DIR="\$PWD" RESOURCE_DIR="\$PWD/functions/\$cb" bash -c "\$hook" 2>&1)"; rc=\$?
   113	    [ -f "\$SC/hide_backstop" ] || printf '%s\n' "\$out"
   114	    if [ "\$rc" != 0 ]; then echo "predeploy=REFUSED" >> "\$SC/log"; echo "Error: predeploy error"; exit 2; fi
   115	    [ -f "functions/\$cb/functions.yaml" ] && echo "seal=present" >> "\$SC/log"
   116	    [ -f "\$SC/skip_line" ] && echo "i  functions: Skipping the deploy of unchanged functions."
   117	    [ -f "\$SC/api_enabled" ] && echo "⚠  extensions: missing required API firebaseextensions.googleapis.com. Enabling now..."
   118	    if [ ! -f "\$SC/deploy_noop" ]; then
   119	      cfg="\$(/usr/bin/jq -c . functions/firebase-config.json)"; h="\$(fake_hash "\$PWD/functions/\$cb" "\$cfg")"
   120	      /usr/bin/jq -c --arg cb "\$cb" --arg cfg "\$cfg" --arg h "\$h" --slurpfile man "functions/\$cb/functions.yaml" '
   121	        (\$man[0].endpoints | to_entries | map(.key as \$id | .value as \$e | {
   122	          platform: "gcfv2", id: \$id, project: "my-clay-hub", region: \$e.region[0], httpsTrigger: {}, entryPoint: \$e.entryPoint,
   123	          runtime: "nodejs22", ingressSettings: \$e.ingressSettings,
   124	          environmentVariables: { EVENTARC_CLOUD_EVENT_SOURCE: "projects/my-clay-hub/locations/\(\$e.region[0])/services/\(\$id)",
   125	            FIREBASE_CONFIG: \$cfg, FUNCTION_TARGET: (\$e.entryPoint | gsub("-"; ".")), GCLOUD_PROJECT: "my-clay-hub", LOG_EXECUTION_ID: "true" },
   126	          timeoutSeconds: \$e.timeoutSeconds, uri: "https://\(\$id)-fake-uc.a.run.app", serviceAccount: \$e.serviceAccountEmail,
   127	          availableMemoryMb: \$e.availableMemoryMb, cpu: \$e.cpu, minInstances: (\$e.minInstances // 0), maxInstances: \$e.maxInstances,
   128	          concurrency: \$e.concurrency, codebase: \$cb, hash: \$h, state: "ACTIVE",
   129	          labels: {"deployment-tool": "cli-firebase", "firebase-functions-codebase": \$cb, "firebase-functions-hash": \$h} })) as \$new
   130	        | map(select(.codebase != \$cb)) + \$new' "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"
   131	    fi
   132	    if [ -f "\$SC/after_filter" ]; then /usr/bin/jq -c "\$(cat "\$SC/after_filter")" "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"; fi
   133	    if [ -f "\$SC/cli_block" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
   134	    exit "\$(cat "\$SC/cli_exit" 2>/dev/null || echo 0)" ;;
   135	esac
   136	echo "fake cli: unexpected \$*" >&2; exit 99
   137	EOF
   138	cat > "$T/bin/curl" <<EOF
   139	#!/bin/bash
   140	SC="$SC"
   141	echo "curl \$*" >> "\$SC/log"; echo x >> "\$SC/curl_calls"
   142	while [ \$# -gt 0 ]; do case "\$1" in -D) D="\$2"; shift 2;; -o|-w|--max-time|--proto) shift 2;; *) U="\$1"; shift;; esac; done
   143	hdr() { printf 'HTTP/2 %s\r\n%s\r\n' "\$1" "\$2" > "\$D"; printf '%s' "\$1"; }
   144	case "\$(cat "\$SC/probe" 2>/dev/null || echo refused)" in
   145	  refused)    hdr 403 'server: Google Frontend' ;;
   146	  reached403) hdr 403 'x-tinker-reached: canary' ;;
   147	  ok200)      hdr 200 'x-tinker-reached: canary' ;;
   148	  plain200)   hdr 200 'server: Google Frontend' ;;
   149	  timeout)    echo "curl: (28) Operation timed out" >&2; exit 28 ;;
   150	  notfound)   hdr 404 'server: Google Frontend' ;;
   151	  error500)   hdr 500 'server: Google Frontend' ;;
   152	esac
   153	exit 0
   154	EOF
   155	cat > "$T/bin/grep" <<EOF
   156	#!/bin/bash
   157	# Real grep, except that with \$SC/grep_fail present a search for the CLI's "Enabling now" line fails like an unreadable file.
   158	if [ -f "$SC/grep_fail" ]; then for a in "\$@"; do [ "\$a" = "Enabling now" ] && exit 2; done; fi
   159	exec /usr/bin/grep "\$@"
   160	EOF
   161	chmod +x "$T/bin/grep"
   162	cat > "$T/bin/sleep" <<EOF
   163	#!/bin/bash
   164	[ "\${1:-}" = 1 ] && exec /bin/sleep 1
   165	echo "sleep \$*" >> "$SC/log"; exit 0
   166	EOF
   167	# Transparent git wrapper, inert unless FAIL_GIT names a subcommand (and FAIL_GIT_ARG an argument) to fail.
   168	cat > "$T/bin/git" <<EOF
   169	#!/bin/bash
   170	if [ -n "\${FAIL_GIT:-}" ] && [ "\${1:-}" = "\$FAIL_GIT" ]; then
   171	  for a in "\$@"; do case "\$a" in *"\${FAIL_GIT_ARG:-}"*) echo "fatal: simulated failure of git \$FAIL_GIT" >&2; exit 128 ;; esac; done
   172	fi
   173	exec "$REAL_GIT" "\$@"
   174	EOF
   175	chmod +x "$T/bin/"*
   176	export PATH="$T/bin:$PATH"
   177	
   178	# ─── the scenario ──────────────────────────────────────────────────────────────────────────────────────
   179	CANARY='{"specVersion":"v1alpha1","endpoints":{"canary":{"availableMemoryMb":256,"timeoutSeconds":10,"minInstances":0,"maxInstances":1,"ingressSettings":"ALLOW_ALL","concurrency":1,"serviceAccountEmail":"canary@my-clay-hub.iam.gserviceaccount.com","vpc":null,"platform":"gcfv2","cpu":1,"region":["us-central1"],"labels":{},"httpsTrigger":{"invoker":["private"]},"entryPoint":"canary"}},"extensions":{},"requiredAPIs":[]}'
   180	scenario_reset() {
   400	assert_eq "the first build fails (exit 2, nothing created) → not verified (exit 21)" "$CODE" "21"
   401	RA="$(newest_tag)"
   402	assert_eq "…recorded cli_exit=2" "$(field "$RA" cli_exit)" "2"
   403	assert_eq "…deploy_match=no (the function is missing)" "$(field "$RA" deploy_match)" "no"
   404	assert_eq "…access=inconclusive (no uri)" "$(field "$RA" access)" "inconclusive"
   405	rm -f "$SC/cli_exit" "$SC/deploy_noop"
   406	run --approved "$SHA1" --codebase core
   407	assert_eq "…the same sha re-runs → verified" "$CODE" "0"
   408	RB="$(newest_tag)"
   409	assert_eq "…the failed attempt and the retry carry the same tree id" "$(field "$RA" tree)" "$(field "$RB" tree)"
   410	assert_eq "…and the same expected hash" "$(field "$RA" expected_hash.canary)" "$(field "$RB" expected_hash.canary)"
   411	
   412	# ═══ refusals on the manifest (F2, F13, F14): exit 24, the CLI never deploys ═══════════════════════════
   413	refuse_manifest() {  # <jq edit> <what> <expected text>
   414	  fixture_reset; manifest_edit "$1"; run --approved "$SHA1" --codebase core
   415	  assert_eq "$2 → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "$3"; no_deploy "…the CLI never deployed"
   416	  assert_eq "…and no record" "$(git tag -l 'deployed/*' | wc -l | tr -d ' ')" "0"
   417	}
   418	refuse_manifest 'del(.endpoints.canary.httpsTrigger.invoker)' "a missing invoker" "no invoker (an absent invoker deploys PUBLIC"
   419	refuse_manifest '.endpoints.canary.httpsTrigger.invoker = ["public"]' "invoker: public" "invoker includes public"
   420	refuse_manifest '.endpoints.canary.httpsTrigger.invoker = ["canary@my-clay-hub.iam.gserviceaccount.com"]' "an invoker that differs from its declaration" "differs from its declaration"
   421	refuse_manifest 'del(.endpoints.canary.serviceAccountEmail)' "a missing service account" "no runtime service account"
   422	refuse_manifest '.endpoints.canary.serviceAccountEmail = "760301318440-compute@developer.gserviceaccount.com"' "the Compute account" "broad default account"
   423	refuse_manifest '.endpoints.canary.serviceAccountEmail = "760301318440@cloudbuild.gserviceaccount.com"' "the legacy Cloud Build account" "broad default account"
   424	refuse_manifest '.endpoints.canary.serviceAccountEmail = "firebase-adminsdk-fbsvc@my-clay-hub.iam.gserviceaccount.com"' "firebase-adminsdk-*" "broad default account"
   425	refuse_manifest '.endpoints.canary.serviceAccountEmail = "my-clay-hub@appspot.gserviceaccount.com"' "…@appspot" "broad default account"
   426	refuse_manifest '.endpoints.canary.serviceAccountEmail = "other@my-clay-hub.iam.gserviceaccount.com"' "an account that differs from its declaration" "differs from its declaration canary@"
   427	refuse_manifest '.endpoints.canary.ingressSettings = "ALLOW_INTERNAL_ONLY"' "ingress that differs from its declaration" "ingress ALLOW_INTERNAL_ONLY differs"
   428	refuse_manifest '.endpoints.canary.platform = "gcfv1"' "platform gcfv1" "platform gcfv1, not gcfv2"
   429	refuse_manifest '.endpoints.canary.region = ["us-east1"]' "another region" "not [\"us-central1\"]"
   430	refuse_manifest '.endpoints.canary.region = ["us-central1","us-east1"]' "two regions" "not [\"us-central1\"]"
   431	for k in maxInstances concurrency timeoutSeconds availableMemoryMb cpu; do
   432	  refuse_manifest "del(.endpoints.canary.${k})" "no ${k} (F14)" "${k} is not set"
   433	done
   434	refuse_manifest '.endpoints.canary.maxInstances = 11' "maxInstances 11" "outside 1..10"
   435	refuse_manifest '.endpoints.canary.minInstances = 1' "minInstances 1" "bills continuously"
   436	refuse_manifest '.endpoints.canary.vpc = {"connector":"c"}' "a VPC" "sets a VPC"
   437	refuse_manifest '.endpoints.canary.secretEnvironmentVariables = [{"key":"K","secret":"S"}]' "secrets" "uses secrets"
   438	refuse_manifest '.endpoints.canary.environmentVariables = {"K":"v"}' "environment variables" "sets environment variables"
   439	refuse_manifest '.endpoints.canary.scheduleTrigger = {"schedule":"every 5 minutes"} | del(.endpoints.canary.httpsTrigger)' "a schedule (HTTP only)" "not an HTTP function"
   440	refuse_manifest '.endpoints.canary.callableTrigger = {}' "a callable next to httpsTrigger" "trigger callableTrigger is refused"
   441	refuse_manifest '.endpoints.canary.omit = true' "an unexpected key" "unexpected manifest key(s) omit"
   442	refuse_manifest '.endpoints.extra = .endpoints.canary' "an undeclared function" "extra: not declared"
   443	refuse_manifest '.endpoints = {"renamed": .endpoints.canary}' "a declaration with no function (stale)" "declaration core/canary has no function (stale)"
   444	refuse_manifest '.requiredAPIs = [{"api":"x.googleapis.com","reason":"r"}]' "required APIs" "requires APIs"
   445	refuse_manifest '.params = [{"name":"P"}]' "params (F13)" "declares params"
   446	refuse_manifest '.specVersion = "v1beta1"' "another specVersion" "specVersion is v1beta1"
   447	refuse_manifest '.extensions = {"e": {}}' "extensions" "declares extensions"
   448	refuse_manifest '.endpoints = {}' "no functions at all" "has no functions"
   449	refuse_manifest '.endpoints.canary.httpsTrigger.extra = 1' "an extra httpsTrigger key" "httpsTrigger has keys beyond invoker"
   450	fixture_reset; echo nodejs20 > "$SC/runtime"; run --approved "$SHA1" --codebase core
   451	assert_eq "runtime nodejs20 → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "runtime nodejs20, not nodejs22"; no_deploy "…the CLI never deployed"
   452	fixture_reset
   453	"$JQ" '.["core/canary"].invoker = ["public"]' functions/declarations.json > d.new && mv d.new functions/declarations.json; git commit --quiet -am "declare public"; git push --quiet
   454	run --approved "$(git rev-parse HEAD)" --codebase core
   455	assert_eq "a declaration that says public → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "declares public"; no_deploy "…the CLI never deployed"
   456	
   457	for dk in serviceAccount invoker ingress; do
   458	  fixture_reset
   459	  "$JQ" --arg k "$dk" 'del(.["core/canary"][$k])' functions/declarations.json > d.new && mv d.new functions/declarations.json; git commit --quiet -am "declaration without $dk"; git push --quiet
   460	  run --approved "$(git rev-parse HEAD)" --codebase core
   461	  assert_eq "a declaration without ${dk} → refused (exit 24)" "$CODE" "24"; assert_has "…naming it" "$OUT" "lacks serviceAccount, invoker or ingress"; no_deploy "…the CLI never deployed"
   462	done
   463	
   464	# ═══ install, discovery and tests ══════════════════════════════════════════════════════════════════════
   465	fixture_reset; : > "$SC/npm_ci_fail"; run --approved "$SHA1" --codebase core
   466	assert_eq "npm ci fails → exit 29" "$CODE" "29"; no_deploy "…never deployed"
   467	fixture_reset; : > "$SC/discover_fail"; run --approved "$SHA1" --codebase core
   468	assert_eq "discovery fails → exit 30" "$CODE" "30"; assert_has "…with discovery's own words" "$OUT" "simulated"; no_deploy "…never deployed"
   469	fixture_reset; : > "$SC/npm_test_fail"; run --approved "$SHA1" --codebase core
   470	assert_eq "npm test fails → exit 15" "$CODE" "15"; no_deploy "…never deployed"
   471	assert_eq "…no in-flight file, no record" "$([ -e "$INFLIGHT" ] && echo present || echo gone) $(git tag -l 'deployed/*' | wc -l | tr -d ' ')" "gone 0"
   472	
   473	# ═══ production drift, and F6: refused before the in-flight file and the CLI (exit 23) ════════════════
   474	refuse_drift() {  # <live.json> <what> <expected text>
   475	  fixture_reset; printf '%s\n' "$1" > "$SC/live.json"; run --approved "$SHA1" --codebase core
   476	  assert_eq "$2 → refused (exit 23)" "$CODE" "23"; assert_has "…naming it" "$OUT" "$3"; no_deploy "…the CLI was never invoked"
   477	  assert_eq "…and no in-flight file was written" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   478	}
   479	LIVE_OK='{"id":"canary","codebase":"core","region":"us-central1","state":"ACTIVE","environmentVariables":{"FIREBASE_CONFIG":"x","GCLOUD_PROJECT":"my-clay-hub","EVENTARC_CLOUD_EVENT_SOURCE":"e","FUNCTION_TARGET":"canary","LOG_EXECUTION_ID":"true"}}'
   480	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.environmentVariables.HAND_ADDED = "v"')]" "a live env key outside F8's five" "HAND_ADDED"
   481	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.secretEnvironmentVariables = [{"key":"K"}]')]" "live secret env" "live secret environment variables"
   482	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.vpc = {"connector":"c"}')]" "a live VPC" "live VPC setting"
   483	refuse_drift "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.state = "DEPLOYING"')]" "a function DEPLOYING" "is DEPLOYING"
   484	refuse_drift "[${LIVE_OK},$(printf '%s' "$LIVE_OK" | "$JQ" -c '.id = "gone"')]" "a live function missing from the manifest (F6)" "gone: is live but not in the manifest; the guard never deletes"
   485	fixture_reset; printf '%s\n' "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.codebase = "other" | .environmentVariables.X = 1')]" > "$SC/live.json"
   486	run --approved "$SHA1" --codebase core; assert_eq "drift in ANOTHER codebase is not this deploy's → verified" "$CODE" "0"
   487	fixture_reset; echo error > "$SC/list_mode_1"; run --approved "$SHA1" --codebase core
   488	assert_eq "production can't be read before the deploy → exit 13" "$CODE" "13"; no_deploy "…never deployed"
   489	assert_has "…with the CLI's own error (its --json body is on stdout)" "$OUT" "simulated list failure"
   490	
   491	# ═══ every deploy_verified=no path (exit 21, the record says why) ══════════════════════════════════════
   492	unverified() {  # <what> <record key> <expected value, or text contained in it>
   493	  local r; r="$(newest_tag)"
   494	  assert_eq "$1 → not verified (exit 21)" "$CODE" "21"
   495	  assert_eq "…deploy_verified=no" "$(field "$r" deploy_verified)" "no"
   496	  assert_has "…${2}: ${3}" "$(field "$r" "$2")" "$3"
   497	  assert_eq "…the in-flight file is gone (the record exists)" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
   498	}
   499	fixture_reset; echo 1 > "$SC/cli_exit"; run --approved "$SHA1" --codebase core; unverified "the CLI exits 1 with a full match" cli_exit 1
   500	assert_eq "…while deploy_match=yes" "$(field "$(newest_tag)" deploy_match)" "yes"
   501	fixture_reset; echo 2 > "$SC/cli_exit"; run --approved "$SHA1" --codebase core; unverified "the CLI exits 2 (partial) with a full match" cli_exit 2
   502	fixture_reset; : > "$SC/skip_line"; run --approved "$SHA1" --codebase core; unverified "the 'Skipping unchanged' line (M5)" skip_line_seen yes
   503	fixture_reset; : > "$SC/hide_backstop"; run --approved "$SHA1" --codebase core; unverified "no backstop success line" backstop_seen no
   504	after() { fixture_reset; printf '%s\n' "$1" > "$SC/after_filter"; run --approved "$SHA1" --codebase core; unverified "$2" "$3" "$4"; }
   505	after '.[0].environmentVariables.EXTRA = "1"' "an extra live env key" mismatch "env keys"
   506	after '.[0].environmentVariables.EVENTARC_CLOUD_EVENT_SOURCE = "projects/my-clay-hub/locations/us-central1/services/other"' "a wrong EVENTARC_CLOUD_EVENT_SOURCE" mismatch "EVENTARC_CLOUD_EVENT_SOURCE is not"
   507	after '.[0].environmentVariables.FUNCTION_TARGET = "other"' "a wrong FUNCTION_TARGET" mismatch "FUNCTION_TARGET is not canary"
   508	after '.[0].environmentVariables.FIREBASE_CONFIG = "{\"projectId\":\"my-clay-hub\"}"' "a live FIREBASE_CONFIG unlike the pinned file" mismatch "FIREBASE_CONFIG differs"
   509	assert_has "…and the live admin-SDK config is shown, so the pin can be fixed" "$OUT" 'live FIREBASE_CONFIG: {"projectId":"my-clay-hub"}'
   510	after '.[0].environmentVariables.GCLOUD_PROJECT = "tinker-hq-apps"' "a wrong GCLOUD_PROJECT" mismatch "GCLOUD_PROJECT is not"
   511	for kv in "maxInstances=2" "concurrency=80" "timeoutSeconds=60" "availableMemoryMb=512" "cpu=2" "minInstances=1"; do
   512	  after ".[0].${kv%%=*} = ${kv#*=}" "a live ${kv%%=*} unlike the manifest" mismatch "${kv%%=*} ${kv#*=}"
   513	done
   514	after '.[0].serviceAccount = "760301318440-compute@developer.gserviceaccount.com"' "a live runtime account unlike the declaration" mismatch "runtime account 760301318440-compute"
   515	after '.[0].ingressSettings = "ALLOW_INTERNAL_ONLY"' "live ingress unlike the declaration" mismatch "ingress ALLOW_INTERNAL_ONLY"
   516	after '.[0].runtime = "nodejs20"' "a live runtime nodejs20" mismatch "runtime nodejs20"
   517	after '.[0].region = "us-east1"' "a live region" mismatch "region us-east1"
   518	after '.[0].state = "FAILED"' "a live state FAILED" mismatch "state FAILED"
   519	after '.[0].platform = "gcfv1"' "a live platform gcfv1" mismatch "platform gcfv1"
   520	after '.[0].vpc = {"connector":"c"}' "a live VPC" mismatch "VPC"
   521	after '.[0].secretEnvironmentVariables = [{"key":"K"}]' "live secrets" mismatch "secret environment variables"
   522	after '. + [.[0] | .id = "extra"]' "an extra live function" mismatch "function set"
   523	after '[]' "a missing live function" mismatch "function set"
   524	after 'del(.[0].uri)' "no uri → the probe is inconclusive" access inconclusive
   525	fixture_reset; echo error > "$SC/list_mode_2"; run --approved "$SHA1" --codebase core; unverified "a list error after the deploy" deploy_match unknown
   526	assert_has "…and the record keeps the CLI's reason" "$(field "$(newest_tag)" mismatch)" "simulated list failure"
   527	assert_eq "…functions_unchanged=unknown" "$(field "$(newest_tag)" functions_unchanged)" "unknown"
   528	fixture_reset; echo malformed > "$SC/list_mode_2"; run --approved "$SHA1" --codebase core; unverified "malformed list JSON after the deploy" deploy_match unknown
   529	probe() { fixture_reset; echo "$1" > "$SC/probe"; run --approved "$SHA1" --codebase core; unverified "$2" access "$3"; }
   530	probe reached403 "a 403 WITH the x-tinker-reached header (our code ran)" answered
   531	assert_has "…recorded as such" "$(field "$(newest_tag)" probe.canary)" "http-403-with-x-tinker-reached"
   532	probe ok200 "a 200 (our code answered an unauthenticated caller)" answered
   533	probe plain200 "a 200 without the header" answered
   534	probe timeout "a timeout" inconclusive
   535	assert_eq "…after 5 tries" "$(wc -l < "$SC/curl_calls" | tr -d ' ')" "5"
   536	assert_eq "…4 waits between them" "$(grep -c '^sleep 10' "$SC/log")" "4"
   537	probe notfound "a 404" inconclusive
   538	probe error500 "a 5xx" inconclusive
   539	fixture_reset; echo 2 > "$SC/cli_exit"; : > "$SC/skip_line"; echo error500 > "$SC/probe"; echo '.[0].cpu = 4' > "$SC/after_filter"
   540	run --approved "$SHA1" --codebase core; R="$(newest_tag)"
   541	assert_eq "combined failures → exit 21" "$CODE" "21"
   542	assert_eq "…each recorded: cli_exit, skip line, match, access" "$(field "$R" cli_exit) $(field "$R" skip_line_seen) $(field "$R" deploy_match) $(field "$R" access)" "2 yes no inconclusive"
   543	
   544	# ═══ snapshot canonicalization ══════════════════════════════════════════════════════════════════════════
   545	fixture_reset
   546	printf '%s\n' "[$(printf '%s' "$LIVE_OK" | "$JQ" -c '.id = "zeta" | .codebase = "other" | .labels = {"b":"2","a":"1"}')]" > "$SC/live.json"
   547	run --approved "$SHA1" --codebase core
   548	: > "$SC/deploy_noop"; echo 'reverse | map(to_entries | reverse | from_entries | .labels = ((.labels // {}) | to_entries | reverse | from_entries) | .environmentVariables = ((.environmentVariables // {}) | to_entries | reverse | from_entries))' > "$SC/after_filter"
   549	run --approved "$SHA1" --codebase core; R="$(newest_tag)"
   550	assert_eq "a reordered but equivalent snapshot has the same digest" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
   551	assert_eq "…so functions_unchanged=yes" "$(field "$R" functions_unchanged)" "yes"
   552	echo 'map(.labels.touched = "1")' > "$SC/after_filter"
   553	run --approved "$SHA1" --codebase core; R="$(newest_tag)"
   554	assert_lacks "…and a real change (a label) changes it" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
   555	
   556	# ═══ interruption, --reconcile, --clear-inflight ═══════════════════════════════════════════════════════
   557	start_killable() {  # run the guard in its own process group; returns once $SC/blocked appears
   558	  rm -f "$SC/blocked"; : > "$SC/log"; : > "$SC/list_calls"
   559	  set -m; bash "$GUARD" "$@" > "$T/bg.out" 2>&1 & BG=$!; set +m
   560	  for _ in $(seq 1 120); do [ -f "$SC/blocked" ] && break; /bin/sleep 0.5; done
   561	  kill -KILL -- "-$BG" 2>/dev/null; wait "$BG" 2>/dev/null
   562	  rm -rf "$GITDIR/tinker-deploy.lock"; rm -rf "$TMPDIR"/*; git worktree prune   # what a human does after checking the pid is gone
   563	}
   564	fixture_reset
   565	: > "$SC/cli_block"
   566	start_killable --approved "$SHA1" --codebase core
   567	assert_eq "killed after the CLI → the in-flight file remains" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "present"
   568	ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
   569	assert_has "…naming the reserved attempt" "$ATT" "${NS}/"
   570	assert_eq "…with no cli_exit (the CLI never returned)" "$(grep -c '^cli_exit=' "$INFLIGHT")" "0"
   571	assert_eq "…and no record yet" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "0"
   572	rm -f "$SC/cli_block"
   573	run --approved "$SHA1" --codebase core; assert_eq "--approved refuses while it exists (exit 22)" "$CODE" "22"; no_deploy "…and does not deploy"
   574	run --status --codebase core; assert_has "--status shows it" "$OUT" "IN FLIGHT:       ${ATT}"
   575	run --reconcile --codebase core --evidence /nonexistent; assert_eq "--reconcile without the Console evidence → exit 25" "$CODE" "25"
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-9LJ1Mf48' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-TJKyDneF' (errno=Operation not permitted)
diff --git a/scripts/deploy-functions.sh b/scripts/deploy-functions.sh
index d39b844..13cf548 100755
--- a/scripts/deploy-functions.sh
+++ b/scripts/deploy-functions.sh
@@ -630,181 +630,199 @@ read_back() {   # <msg file>
     printf 'not_proven=refused does not prove the absence of grants to all Google accounts, to named principals, or at project, folder or organization level (--attest records those)\n'
     printf 'deploy_verified=%s\n' "$DEPLOY_VERIFIED"
   } >> "$msg"
   say "access: ${ACCESS}   deploy_verified: ${DEPLOY_VERIFIED}"
 }
 transcript_flags() {   # <transcript> <sha> — sets BACKSTOP_SEEN and SKIP_SEEN ("unknown" when there is no transcript)
   local line="predeploy-check: functions codebase ${CB} for ${PROJECT} matches commit ${2:0:12} (tree ${TREE}); sealed manifest ${MSHA} in place"
   if [ ! -f "$1" ]; then BACKSTOP_SEEN=unknown; SKIP_SEEN=unknown; return 0; fi
   if grep -qF -- "$line" "$1"; then BACKSTOP_SEEN=yes; else BACKSTOP_SEEN=no; fi
   if grep -qF -- "$SKIP_LINE" "$1"; then SKIP_SEEN=yes; else SKIP_SEEN=no; fi
 }
 verifier_fields() {   # <attempt commit> <msg> — F9: record the verifier and whether the guard's code changed since
   # The checks and verdicts (F8, the probe, the evidence) are this script's — the tip's, proven byte-equal above.
   # Rebuilding an attempt's expected state (--reconcile, --reverify) deliberately uses the ATTEMPT's own backstop,
   # discovery and hash module, because they are what produced the manifest and hash it recorded; their output must then
   # equal those recorded values. The record names both commits, so the provenance is never mixed silently.
   printf 'rebuild_helpers_from=%s\n' "$1" >> "$2"
   local changed
   changed="$(control_file_diff "$1" "$MAIN_SHA")"
   if [ -n "$changed" ]; then
     [ "$ACK" = 1 ] || die $EX_VERIFIER "the guard's machinery changed between the attempt (${1:0:12}) and ${REMOTE}/${BRANCH} (${MAIN_SHA:0:12}), first at ${changed}. The record would be judged by the tip's checks while the expected state is rebuilt with the attempt's own helpers. Once Christie has OK'd that, run again with --acknowledge-verifier-change."
     printf 'verifier=%s\nverifier_changed=yes (%s)\nverifier_change_acknowledged=yes\n' "$MAIN_SHA" "$changed" >> "$2"
   else
     printf 'verifier=%s\nverifier_changed=no\n' "$MAIN_SHA" >> "$2"
   fi
 }
 # Whether this deploy needs Christie's IAM reading (Christie, Oct 1 2026: re-read IAM only when something that shapes
 # it changed). FAIL-CLOSED: anything unreadable means "needed". Needed when the deploy isn't verified; when no attempt of
 # this codebase has iam_attested=yes yet; when the function set or a file that decides who may do what (ATTEST_FILES)
 # changed since the newest attested attempt; or when the CLI turned on a Google API during this deploy — Google can add
 # role grants when an API is enabled (D2-5: enabling Firebase Extensions gave the Google APIs Service Agent Editor).
 # Not seen either way: a role someone changes by hand in the Console. Sets ATTEST_NEEDED, ATTEST_WHY; appends to <msg>.
 ATTEST_FILES="functions/declarations.json functions/iam-expectations.json firebase.json .firebaserc"
 API_ENABLED_LINE="Enabling now"
 attest_need() {   # <msg>
-  local why="" rows r a last="" changed owed="" n
-  [ "$DEPLOY_VERIFIED" = yes ] || why="${why}the deploy is not verified; "
-  if [ ! -f "$TRANSCRIPT" ]; then why="${why}no transcript to check for a newly enabled Google API; "
-  elif grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT"; then why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); "
+  local why="" rows r a last="" changed owed="" n g=0
+  [ "${DEPLOY_VERIFIED:-no}" = yes ] || why="${why}the deploy is not verified; "
+  if [ ! -f "${TRANSCRIPT:-}" ]; then why="${why}no transcript to check for a newly enabled Google API; "
+  else
+    grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT" || g=$?
+    case "$g" in
+      0) why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); " ;;
+      1) ;;
+      *) why="${why}could not read the transcript to check for a newly enabled Google API; " ;;
+    esac
   fi
   if ! rows="$(receipt_rows "$ATTEMPT_PREFIX")"; then why="${why}could not read the record of earlier attempts; "
   else
     while read -r _ _ r; do
       [ -n "$r" ] || continue
       if ! a="$(iam_attested_of "$r" "$ATTEST_PREFIX")"; then why="${why}could not read whether ${r} was attested; "; last=""; break; fi
       [ "$a" = yes ] && { last="$r"; break; }
-      # A reading owed by a later, unattested attempt stays owed (one with no attest_needed predates this rule).
+      # Owed by a later attempt: a reading that came back no (a known mismatch), or one it needed and never got (an
+      # attempt with no attest_needed predates this rule and counts as needing one).
       n="$(record_field "$r" attest_needed 2>/dev/null || echo unknown)"
-      [ "$n" = no ] || owed="${owed:-$r}"
+      if [ "$a" != none ] || [ "$n" != no ]; then owed="${owed:-$r}"; fi
     done <<< "$rows"
-    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading that was never attested yes; "
+    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading, or its reading came back no, and nothing since was attested yes; "
     if [ -z "$last" ]; then
       case "$why" in *"could not read whether"*) ;; *) why="${why}no attempt of ${CB} has iam_attested=yes yet; " ;; esac
     else
       # shellcheck disable=SC2086 # ATTEST_FILES is a fixed word list
       if ! changed="$(git diff --name-only "$(commit_of "$last")" "$SHA" -- $ATTEST_FILES | tr '\n' ' ')"; then
         why="${why}could not compare with ${last}; "
       elif [ -n "$changed" ]; then why="${why}changed since ${last}: ${changed% }; "
       fi
       [ "$(record_field "$last" functions 2>/dev/null)" = "$IDS" ] || why="${why}the functions differ from ${last}'s; "
     fi
   fi
   if [ -n "$why" ]; then ATTEST_NEEDED=yes; ATTEST_WHY="${why%; }"
   else ATTEST_NEEDED=no; ATTEST_WHY="last attested ${last}; since then the same functions, no change to ${ATTEST_FILES// /, }, and the CLI enabled no Google API"
   fi
   printf 'attest_needed=%s\nattest_needed_why=%s\n' "$ATTEST_NEEDED" "$ATTEST_WHY" >> "$1"
 }
+attest_report() {   # after a record is written: say whether Christie's IAM reading is needed, and why
+  if [ "$ATTEST_NEEDED" = yes ]; then
+    say "─── IAM reading NEEDED: ${ATTEST_WHY} ───"
+    attest_help
+  else
+    say "─── IAM reading not needed: ${ATTEST_WHY}. (Christie can still --attest any time, and should after any role change made by hand.) ───"
+  fi
+}
 attest_help() {   # printed after a deploy: what --attest needs, generated from the IAM expectations it is checked against
   say "─── next: Christie's IAM reading, then --attest (F9, M3) ───"
   say "Christie reads, in the Console, and Claude writes into a JSON file exactly this shape (every holder as"
   say "\"user:…\" or \"serviceAccount:…\"; each list complete, as read):"
   "$JQ" --arg ids "$IDS" '{
       functions: ($ids | split(",") | map({key: ., value: {buildId: "<Cloud Build → History → the build id>", buildStatus: "<its status>",
         latestReadyRevision: "<Cloud Run → the service → latest ready revision>", requireAuthentication: "<true|false, Security tab>",
         runInvokerMembers: ["<every run.invoker member, Permissions tab>"]}}) | from_entries),
       projectRoles: (.projectRoles | map_values(["<every holder, IAM → View by roles>"])),
       buildRoleBindings: (.buildRoleBindings | map_values([{member: "<one entry per binding row, IAM → View by roles>",
         condition: "<its condition expression as the Console shows it, or null when the row has none>"}])),
       artifactRegistryWriters: {repository: ["<direct Artifact Registry Writer holders on \(.artifactRegistryWriterOn)>"],
         project: ["<project-level holders of roles/artifactregistry.writer, IAM → View by roles>"]},
       runtimeAccounts: (.runtimeAccounts | map_values(["<its project roles>"])),
-      buildAccount: "<Cloud Build → History → the build service account, the email only>" }' "${TMP}/functions/iam-expectations.json"
+      buildAccount: "<Cloud Build → History → the build service account, the email only>" }' \
+    <(if [ -n "${TMP:-}" ] && [ -f "${TMP}/functions/iam-expectations.json" ]; then cat "${TMP}/functions/iam-expectations.json"
+      else git show "${MAIN_SHA}:functions/iam-expectations.json"; fi)   # --clear-inflight has no worktree: the tip's file
   say "(Not read, and so not attested: folder- and organization-level grants, and grants on individual Cloud Storage buckets or managed folders.)"
   say "then:  $0 --attest ${TAG:-<attempt>} --codebase ${CB} --evidence <file>"
 }
 
 # ─── --status / --diff ─────────────────────────────────────────────────────────────────────────────────
 # Read-only. The newest attempt (by stamp, attempt tags only), and the newest attempt whose deploy_verified is yes.
 record_state() {   # sets NEWEST, NEWEST_VERIFIED, NEWEST_ATTESTED, LAST_VERIFIED
   local rows r v
   rows="$(receipt_rows "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB} — refusing to guess what shipped."
   NEWEST="$(printf '%s\n' "$rows" | awk 'NR==1{printf "%s", $3}')"
   NEWEST_VERIFIED=""; NEWEST_ATTESTED=""; LAST_VERIFIED=""
   [ -n "$NEWEST" ] || return 0
   NEWEST_VERIFIED="$(deploy_verified_of "$NEWEST" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${NEWEST} — refusing to guess."
   NEWEST_ATTESTED="$(iam_attested_of "$NEWEST" "$ATTEST_PREFIX")" || die $EX_RECORD "could not read iam_attested for ${NEWEST} — refusing to guess."
   while read -r _ _ r; do
     v="$(deploy_verified_of "$r" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${r} — refusing to guess."
     if [ "$v" = yes ]; then LAST_VERIFIED="$r"; break; fi
   done <<< "$rows"
 }
 commit_of() { local c; c="$(receipt_commit "$1")" || die $EX_RECORD "the record ${1} is in the record but its commit could not be resolved."; printf '%s' "$c"; }
 
 if [ "$MODE" = "status" ] || [ "$MODE" = "diff" ]; then
   if ! fetch_state >/dev/null; then warn "could not fetch ${REMOTE}/${BRANCH} and the records; showing the last-known state"; fi
   MAIN_SHA="$(git rev-parse --quiet --verify "${REMOTE}/${BRANCH}^{commit}" 2>/dev/null || true)"
   [ -n "$MAIN_SHA" ] || die $EX_FETCH "${REMOTE}/${BRANCH} has never been fetched here and ${REMOTE} is unreachable."
   codebase_on_tip
   record_state
   if [ "$MODE" = "diff" ]; then
     if [ -n "$NEWEST" ] && [ "$NEWEST" != "$LAST_VERIFIED" ]; then
       say "════ NOTE: the newest attempt ${NEWEST} is NOT verified — production may differ from both sides of this diff ════"
     fi
     if [ -z "$LAST_VERIFIED" ]; then
       say "(no verified attempt yet for ${CB} — showing everything that would ship, at ${REMOTE}/${BRANCH} ${MAIN_SHA:0:12})"
       BASE="$EMPTY_TREE"
     else
       BASE="$(commit_of "$LAST_VERIFIED")"
       say "(diff from the last verified attempt ${LAST_VERIFIED} (${BASE:0:12}) to ${REMOTE}/${BRANCH} ${MAIN_SHA:0:12})"
     fi
     say "─── firebase.json entry for ${CB} at ${MAIN_SHA:0:12} ───"
     git show "${MAIN_SHA}:firebase.json" | "$JQ" --arg cb "$CB" '.functions[] | select(.codebase == $cb)'
     show_machinery "$BASE" "$MAIN_SHA"
     # shellcheck disable=SC2086
     if git diff --quiet "$BASE" "$MAIN_SHA" -- $SHOWN_PATHS; then say "(no change to ${SHOWN_PATHS} since ${LAST_VERIFIED})"; exit 0; fi
     # shellcheck disable=SC2086
     git --no-pager diff "$BASE" "$MAIN_SHA" -- $SHOWN_PATHS
     exit 0
   fi
   say "project:         ${PROJECT}"
   say "codebase:        ${CB}  (${SRC})"
   if [ -f "$INFLIGHT" ]; then
     if inflight_valid; then
       say "IN FLIGHT:       $(inflight_get attempt) (commit $(inflight_get commit | cut -c1-12)) — a deploy was interrupted, or is running. The next --approved refuses; see FUNCTIONS-ROLLBACK.md §2."
     else
       say "IN FLIGHT:       ${INFLIGHT} exists but is MALFORMED — the next --approved refuses; see FUNCTIONS-ROLLBACK.md §2."
     fi
   fi
   [ -f "$PENDING" ] && say "pending record:  $(cut -d' ' -f1 "$PENDING") was not pushed — the next run publishes it first."
   if [ -z "$NEWEST" ]; then
     say "newest attempt:  none — no guarded deploy of ${CB} yet"
   else
     NC="$(commit_of "$NEWEST")"
     say "newest attempt:  ${NEWEST}$(receipt_note "$NEWEST")"
     say "  commit:        ${NC}  $(git log -1 --format='%s' "$NC")"
     say "  deploy_verified=${NEWEST_VERIFIED}  iam_attested=${NEWEST_ATTESTED}"
+    say "  attest_needed=$(record_word "$NEWEST" attest_needed "yes no" 2>/dev/null || echo "unknown (recorded before Oct 1 2026, so treated as needed)")$(w="$(record_field "$NEWEST" attest_needed_why 2>/dev/null)" && [ -n "$w" ] && printf ' — %s' "$w")"
     if [ "$NEWEST_VERIFIED" = yes ]; then
       say "state:           verified at ${NEWEST}"
     elif [ "$(record_word "$NEWEST" functions_unchanged "yes no unknown" 2>/dev/null || echo unknown)" = yes ]; then
       say "state:           functions unchanged by ${NEWEST} — production is still what $( [ -n "$LAST_VERIFIED" ] && echo "${LAST_VERIFIED} verified" || echo "was there before (no verified attempt yet)")"
     else
       say "state:           production may be mixed: last verified ${LAST_VERIFIED:-(none yet)}; unverified attempt ${NEWEST}"
     fi
   fi
   say "${REMOTE}/${BRANCH}:     ${MAIN_SHA}  $(git log -1 --format='%s' "$MAIN_SHA")"
   D="$(dirty_files)"; [ -n "$D" ] && warn "the shared tree has uncommitted changes (not what ships): $(echo "$D" | tr '\n' ' ')"
   say ""
   say "To deploy ${REMOTE}/${BRANCH}, run --diff and paste it; then Christie says exactly:"
   say "    approved to change firebase ${MAIN_SHA}"
   say "then run:  $0 --approved ${MAIN_SHA} --codebase ${CB}"
   exit 0
 fi
 
 # ─── Every tag-writing mode: preflight, lock, fetch, the pending record, the verifier ──────────────────
 preflight
 take_lock
 trap cleanup EXIT
 WORK="$(mktemp -d "${TMPDIR:-/tmp}/tinker-functions.XXXXXX")"   # private to this run; removed on exit
 chmod 700 "$WORK"
 fetch_or_die
 publish_pending
 verifier_is_tip
 codebase_on_tip
 mkdir -p "$TRANSCRIPTS"
 
 # ─── --approved ────────────────────────────────────────────────────────────────────────────────────────
 if [ "$MODE" = "approved" ]; then
   [ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an earlier deploy was interrupted (or is running). Nothing was deployed. Reconcile it first (FUNCTIONS-ROLLBACK.md §2)."
   SHA="$(printf '%s' "$SHA_ARG" | tr 'A-F' 'a-f')"
   [[ "$SHA" =~ ^[0-9a-f]{40}$ ]] || die $EX_USAGE "--approved needs the FULL 40-character sha Christie named (run --status to see it). Got '${SHA_ARG}'."
   [ "$(git rev-parse --verify --quiet "${SHA}^{commit}" 2>/dev/null || true)" = "$SHA" ] || die $EX_USAGE "${SHA} is not a commit in this repository."
@@ -855,147 +873,146 @@ $(printf '%s\n' "$DRIFT" | sed 's/^/  - /')"
       printf 'expected_hash.%s=%s\n' "$id" "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")"
       printf 'before_hash.%s=%s\n' "$id" "$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "none"' "$BEFORE")"
     done
   } | atomic_write "$INFLIGHT" || die $EX_INFLIGHT "could not write ${INFLIGHT} — nothing was deployed."
   inflight_valid || die $EX_INFLIGHT "${INFLIGHT} did not read back as written — nothing was deployed; remove it by hand."
 
   # The CLI. TINKER_DEPLOY_* are exported, never inline (K15). Never --force.
   say "─── firebase deploy --only functions:${CB} --project ${PROJECT} (in ${TMP}) ───"
   set +e
   (
     export TINKER_DEPLOY_SHA="$SHA" TINKER_DEPLOY_CODEBASE="$CB" TINKER_DEPLOY_MANIFEST_PATH="$MPATH" TINKER_DEPLOY_MANIFEST_SHA256="$MSHA"
     cli "$TMP" deploy --only "functions:${CB}" --project "$PROJECT" --non-interactive
   ) 2>&1 | tee "$TRANSCRIPT"
   CLI_EXIT="${PIPESTATUS[0]}"
   set -e
   { cat "$INFLIGHT"; printf 'cli_exit=%s\n' "$CLI_EXIT"; } | atomic_write "$INFLIGHT" || warn "could not add cli_exit to ${INFLIGHT} (a --reconcile will record cli_exit=unknown)"
   transcript_flags "$TRANSCRIPT" "$SHA"
   say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
 
   MSG="${WORK}/record"
   {
     printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$TREE"
     printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
     for id in $(printf '%s' "$IDS" | tr ',' ' '); do
       printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
     done
     printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   } > "$MSG"
   read_back "$MSG"
   verifier_fields "$SHA" "$MSG"
   attest_need "$MSG"
   printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   rm -f "$INFLIGHT"
   [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
-  if [ "$ATTEST_NEEDED" = yes ]; then
-    say "─── IAM reading NEEDED: ${ATTEST_WHY} ───"
-    attest_help
-  else
-    say "─── IAM reading not needed: ${ATTEST_WHY}. (Christie can still --attest any time, and should after any role change made by hand.) ───"
-  fi
+  attest_report
   if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   exit $EX_UNVERIFIED
 fi
 
 # ─── --reconcile / --clear-inflight ────────────────────────────────────────────────────────────────────
 if [ "$MODE" = "reconcile" ] || [ "$MODE" = "clear-inflight" ]; then
   [ -f "$INFLIGHT" ] || die $EX_INFLIGHT "there is no in-flight file (${INFLIGHT}) — nothing to reconcile."
   inflight_valid || die $EX_INFLIGHT "${INFLIGHT} is malformed (truncated, or edited) — refusing to guess what it recorded. Show it to Christie; FUNCTIONS-ROLLBACK.md §2."
   [ "$(inflight_get codebase)" = "$CB" ] || die $EX_INFLIGHT "the in-flight attempt is for codebase $(inflight_get codebase), not ${CB}."
   TAG="$(inflight_get attempt)"; STAMP="$(inflight_get stamp)"; SHA="$(inflight_get commit)"; IDS="$(inflight_get functions)"
   if [ "$MODE" = "clear-inflight" ] && [ "$ATTEMPT_ARG" != "$TAG" ]; then
     die $EX_INFLIGHT "the in-flight attempt is ${TAG}, not ${ATTEMPT_ARG} — name it exactly."
   fi
   IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
   [ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
   "$JQ" -e --argjson ids "$IDS_JSON" --arg mode "$([ "$MODE" = reconcile ] && echo reconcile || echo clear)" "$JQ_EVIDENCE_OP" "$EVIDENCE" >/dev/null 2>&1 \
     || die $EX_EVIDENCE "the evidence is not in the fixed shape: {\"confirmation\": \"<Christie's words>\", \"functions\": {\"<id>\": {\"buildId\": \"<uuid>\", \"buildStatus\": \"<status>\", \"latestReadyRevision\": \"<id>-000NN-xxx\"$([ "$MODE" = clear-inflight ] && echo ' (or null)')}}} for exactly ${IDS}$([ "$MODE" = reconcile ] && echo ', with a finished build')."
   EVJSON="$("$JQ" -c . "$EVIDENCE")"
   if git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null 2>&1; then
     die $EX_INFLIGHT "the record ${TAG} already exists, so the attempt was recorded before the in-flight file could be removed. Check it (git show ${TAG}); if it names ${SHA:0:12}, remove ${INFLIGHT} by hand with Christie's OK."
   fi
   MSG="${WORK}/record"
   CLI_EXIT="$(inflight_get cli_exit 2>/dev/null || echo unknown)"
   {
     printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$(inflight_get tree)"
     printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$(inflight_get manifest_sha256)" "$IDS" "$(inflight_get before_digest)"
     for id in $(printf '%s' "$IDS" | tr ',' ' '); do
       printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
     done
   } > "$MSG"
 
   if [ "$MODE" = "clear-inflight" ]; then
     MSHA="$(inflight_get manifest_sha256)"; TREE="$(inflight_get tree)"
     transcript_flags "$(inflight_get transcript)" "$SHA"
     {
       printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
       printf 'after_digest=unknown\nfunctions_unchanged=unknown\ndeploy_match=unknown\naccess=not-probed\ndeploy_verified=no\n'
       printf 'evidence=%s\n' "$EVJSON"
     } >> "$MSG"
     verifier_fields "$SHA" "$MSG"
+    DEPLOY_VERIFIED=no; TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
     printf 'at=%s\nby=deploy-functions.sh --clear-inflight\n' "$STAMP" >> "$MSG"
     PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
     rm -f "$INFLIGHT"
     [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
+    attest_report
     say "✔ cleared: ${TAG} recorded with deploy_match=unknown (its original stamp). Production is NOT verified; the next --approved may run."
     exit 0
   fi
 
   # --reconcile: rebuild the expected state from the attempt's commit and prove it's the same manifest and hashes.
   verifier_fields "$SHA" "$MSG"   # refuses early (before the rebuild) if the machinery changed and Christie hasn't OK'd it
   build_expected "$SHA"
   [ "$MSHA" = "$(inflight_get manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the one the attempt sealed ($(inflight_get manifest_sha256)) — refusing to verify against a different manifest."
   [ "$TREE" = "$(inflight_get tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   [ "$IDS" = "$(inflight_get functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   for id in $(printf '%s' "$IDS" | tr ',' ' '); do
     [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(inflight_get "expected_hash.${id}")" ] \
       || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one recorded before the CLI call."
   done
   NOW="${WORK}/now.json"
   list_live "$TMP" "$NOW" || die $EX_FETCH "could not read production (functions:list): $(list_why "$NOW") — try again."
   DEPLOYING="$("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb and .state == "DEPLOYING") | .id] | join(",")' "$NOW")"
   [ -z "$DEPLOYING" ] || die $EX_INFLIGHT "${DEPLOYING} still DEPLOYING — the operation hasn't finished; wait, then reconcile."
   BEFORE_DIGEST="$(inflight_get before_digest)"
   transcript_flags "$(inflight_get transcript)" "$SHA"
   printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN" >> "$MSG"
   read_back "$MSG"
+  TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
   printf 'evidence=%s\nat=%s\nby=deploy-functions.sh --reconcile\n' "$EVJSON" "$STAMP" >> "$MSG"
   PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   rm -f "$INFLIGHT"
   [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
+  attest_report
   say "✔ reconciled: ${TAG} recorded with its original stamp; deploy_verified=${DEPLOY_VERIFIED}."
   [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   exit $EX_UNVERIFIED
 fi
 
 # ─── --reverify / --attest: only for the newest attempt ────────────────────────────────────────────────
 [ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an interrupted deploy comes first (FUNCTIONS-ROLLBACK.md §2)."
 NEWEST="$(latest_receipt "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB}."
 [ -n "$NEWEST" ] || die $EX_NOT_NEWEST "there is no attempt for ${CB} yet."
 [ "$ATTEMPT_ARG" = "$NEWEST" ] || die $EX_NOT_NEWEST "${ATTEMPT_ARG} is not the newest attempt (${NEWEST}). Today's production can only speak for the attempt that put it there."
 SHA="$(commit_of "$NEWEST")"
 for k in commit manifest_sha256 functions tree; do
   record_field "$NEWEST" "$k" >/dev/null || die $EX_RECORD "the attempt ${NEWEST} has no readable ${k} — refusing."
 done
 [ "$(record_field "$NEWEST" commit)" = "$SHA" ] || die $EX_RECORD "the attempt ${NEWEST} names a different commit than it points at."
 IDS="$(record_field "$NEWEST" functions)"
 IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
 MSG="${WORK}/record"
 
 if [ "$MODE" = "reverify" ]; then
   : > "$MSG"
   verifier_fields "$SHA" "$MSG"
   CLI_EXIT="$(record_field "$NEWEST" cli_exit)" || die $EX_RECORD "the attempt ${NEWEST} has no readable cli_exit."
   BACKSTOP_SEEN="$(record_word "$NEWEST" backstop_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable backstop_seen."
   SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
   BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
   build_expected "$SHA"
   [ "$MSHA" = "$(record_field "$NEWEST" manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the attempt's."
   [ "$TREE" = "$(record_field "$NEWEST" tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   [ "$IDS" = "$(record_field "$NEWEST" functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   for id in $(printf '%s' "$IDS" | tr ',' ' '); do
     [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
       || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
   done
   reserve_stamp "$VERIFY_PREFIX" "${SHA:0:7}"
diff --git a/scripts/deploy-functions.test.sh b/scripts/deploy-functions.test.sh
index 03f7a36..798c65b 100644
--- a/scripts/deploy-functions.test.sh
+++ b/scripts/deploy-functions.test.sh
@@ -120,70 +120,77 @@ case "\${1:-}" in
       /usr/bin/jq -c --arg cb "\$cb" --arg cfg "\$cfg" --arg h "\$h" --slurpfile man "functions/\$cb/functions.yaml" '
         (\$man[0].endpoints | to_entries | map(.key as \$id | .value as \$e | {
           platform: "gcfv2", id: \$id, project: "my-clay-hub", region: \$e.region[0], httpsTrigger: {}, entryPoint: \$e.entryPoint,
           runtime: "nodejs22", ingressSettings: \$e.ingressSettings,
           environmentVariables: { EVENTARC_CLOUD_EVENT_SOURCE: "projects/my-clay-hub/locations/\(\$e.region[0])/services/\(\$id)",
             FIREBASE_CONFIG: \$cfg, FUNCTION_TARGET: (\$e.entryPoint | gsub("-"; ".")), GCLOUD_PROJECT: "my-clay-hub", LOG_EXECUTION_ID: "true" },
           timeoutSeconds: \$e.timeoutSeconds, uri: "https://\(\$id)-fake-uc.a.run.app", serviceAccount: \$e.serviceAccountEmail,
           availableMemoryMb: \$e.availableMemoryMb, cpu: \$e.cpu, minInstances: (\$e.minInstances // 0), maxInstances: \$e.maxInstances,
           concurrency: \$e.concurrency, codebase: \$cb, hash: \$h, state: "ACTIVE",
           labels: {"deployment-tool": "cli-firebase", "firebase-functions-codebase": \$cb, "firebase-functions-hash": \$h} })) as \$new
         | map(select(.codebase != \$cb)) + \$new' "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"
     fi
     if [ -f "\$SC/after_filter" ]; then /usr/bin/jq -c "\$(cat "\$SC/after_filter")" "\$SC/live.json" > "\$SC/live.new" && mv "\$SC/live.new" "\$SC/live.json"; fi
     if [ -f "\$SC/cli_block" ]; then : > "\$SC/blocked"; /bin/sleep 60; fi
     exit "\$(cat "\$SC/cli_exit" 2>/dev/null || echo 0)" ;;
 esac
 echo "fake cli: unexpected \$*" >&2; exit 99
 EOF
 cat > "$T/bin/curl" <<EOF
 #!/bin/bash
 SC="$SC"
 echo "curl \$*" >> "\$SC/log"; echo x >> "\$SC/curl_calls"
 while [ \$# -gt 0 ]; do case "\$1" in -D) D="\$2"; shift 2;; -o|-w|--max-time|--proto) shift 2;; *) U="\$1"; shift;; esac; done
 hdr() { printf 'HTTP/2 %s\r\n%s\r\n' "\$1" "\$2" > "\$D"; printf '%s' "\$1"; }
 case "\$(cat "\$SC/probe" 2>/dev/null || echo refused)" in
   refused)    hdr 403 'server: Google Frontend' ;;
   reached403) hdr 403 'x-tinker-reached: canary' ;;
   ok200)      hdr 200 'x-tinker-reached: canary' ;;
   plain200)   hdr 200 'server: Google Frontend' ;;
   timeout)    echo "curl: (28) Operation timed out" >&2; exit 28 ;;
   notfound)   hdr 404 'server: Google Frontend' ;;
   error500)   hdr 500 'server: Google Frontend' ;;
 esac
 exit 0
 EOF
+cat > "$T/bin/grep" <<EOF
+#!/bin/bash
+# Real grep, except that with \$SC/grep_fail present a search for the CLI's "Enabling now" line fails like an unreadable file.
+if [ -f "$SC/grep_fail" ]; then for a in "\$@"; do [ "\$a" = "Enabling now" ] && exit 2; done; fi
+exec /usr/bin/grep "\$@"
+EOF
+chmod +x "$T/bin/grep"
 cat > "$T/bin/sleep" <<EOF
 #!/bin/bash
 [ "\${1:-}" = 1 ] && exec /bin/sleep 1
 echo "sleep \$*" >> "$SC/log"; exit 0
 EOF
 # Transparent git wrapper, inert unless FAIL_GIT names a subcommand (and FAIL_GIT_ARG an argument) to fail.
 cat > "$T/bin/git" <<EOF
 #!/bin/bash
 if [ -n "\${FAIL_GIT:-}" ] && [ "\${1:-}" = "\$FAIL_GIT" ]; then
   for a in "\$@"; do case "\$a" in *"\${FAIL_GIT_ARG:-}"*) echo "fatal: simulated failure of git \$FAIL_GIT" >&2; exit 128 ;; esac; done
 fi
 exec "$REAL_GIT" "\$@"
 EOF
 chmod +x "$T/bin/"*
 export PATH="$T/bin:$PATH"
 
 # ─── the scenario ──────────────────────────────────────────────────────────────────────────────────────
 CANARY='{"specVersion":"v1alpha1","endpoints":{"canary":{"availableMemoryMb":256,"timeoutSeconds":10,"minInstances":0,"maxInstances":1,"ingressSettings":"ALLOW_ALL","concurrency":1,"serviceAccountEmail":"canary@my-clay-hub.iam.gserviceaccount.com","vpc":null,"platform":"gcfv2","cpu":1,"region":["us-central1"],"labels":{},"httpsTrigger":{"invoker":["private"]},"entryPoint":"canary"}},"extensions":{},"requiredAPIs":[]}'
 scenario_reset() {
   rm -rf "$SC"; mkdir -p "$SC"
   printf '%s\n' "$CANARY" > "$SC/manifest.json"; echo '[]' > "$SC/live.json"
   : > "$SC/log"; : > "$SC/list_calls"; : > "$SC/curl_calls"
 }
 manifest_edit() { "$JQ" -c "$1" "$SC/manifest.json" > "$SC/m.new" && mv "$SC/m.new" "$SC/manifest.json"; }
 
 # ─── a throwaway origin + clone that looks like my-clay-hub ────────────────────────────────────────────
 "$REAL_GIT" init --quiet --bare "$T/origin.git"
 "$REAL_GIT" clone --quiet "$T/origin.git" "$T/clone" 2>/dev/null
 REPO="$T/clone"
 cd "$REPO"
 git config user.email test@example.com; git config user.name test; git config commit.gpgsign false; git config tag.gpgSign false
 mkdir -p scripts/lib functions/core tests node_modules/firebase-tools/lib/bin
 cp "$HERE/deploy-functions.sh" "$HERE/deploy-rules.sh" "$HERE/predeploy-check.sh" scripts/
 cp "$HERE/lib/receipts.sh" scripts/lib/
 for f in scripts/deploy-functions.sh scripts/deploy-rules.sh scripts/predeploy-check.sh; do
@@ -563,82 +570,86 @@ assert_has "…naming the reserved attempt" "$ATT" "${NS}/"
 assert_eq "…with no cli_exit (the CLI never returned)" "$(grep -c '^cli_exit=' "$INFLIGHT")" "0"
 assert_eq "…and no record yet" "$(git tag -l "${NS}/*" | wc -l | tr -d ' ')" "0"
 rm -f "$SC/cli_block"
 run --approved "$SHA1" --codebase core; assert_eq "--approved refuses while it exists (exit 22)" "$CODE" "22"; no_deploy "…and does not deploy"
 run --status --codebase core; assert_has "--status shows it" "$OUT" "IN FLIGHT:       ${ATT}"
 run --reconcile --codebase core --evidence /nonexistent; assert_eq "--reconcile without the Console evidence → exit 25" "$CODE" "25"
 evidence_op "$T/ev.json" WORKING; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…with a build that hasn't finished → exit 25" "$CODE" "25"
 printf '{"confirmation":"done"}\n' > "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…with free text instead of the fixed shape → exit 25" "$CODE" "25"
 evidence_op "$T/ev.json"
 "$JQ" -c '.[0].state = "DEPLOYING"' "$SC/live.json" > "$SC/l" && mv "$SC/l" "$SC/live.json"
 run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…while a function is DEPLOYING → exit 22" "$CODE" "22"; assert_has "…saying so" "$OUT" "still DEPLOYING"
 "$JQ" -c '.[0].state = "ACTIVE"' "$SC/live.json" > "$SC/l" && mv "$SC/l" "$SC/live.json"
 run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…once settled: recorded, not verified (cli_exit unknown) → exit 21" "$CODE" "21"
 assert_eq "…the record keeps the ORIGINAL stamp (its name is the reserved attempt id)" "$(newest_tag)" "$ATT"
 assert_eq "…cli_exit=unknown" "$(field "$ATT" cli_exit)" "unknown"
 assert_eq "…deploy_match=yes (production is what the attempt sealed)" "$(field "$ATT" deploy_match)" "yes"
 assert_has "…with Christie's evidence" "$(field "$ATT" evidence)" "0f1e2d3c-4b5a-6978-8a9b-0c1d2e3f4a5b"
 assert_eq "…by --reconcile" "$(field "$ATT" by)" "deploy-functions.sh --reconcile"
 assert_eq "…and the in-flight file is gone" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
 # killed during the read-back: the CLI returned 0, so the reconcile can verify
 fixture_reset
 : > "$SC/list_block_2"
 start_killable --approved "$SHA1" --codebase core
 assert_eq "killed during the read-back → the in-flight file has cli_exit=0" "$(awk -F= '$1=="cli_exit"{print $2}' "$INFLIGHT")" "0"
 ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
 rm -f "$SC/list_block_2"
 run --approved "$SHA1" --codebase core; assert_eq "…--approved refuses (exit 22)" "$CODE" "22"
 evidence_op "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "…--reconcile verifies it (exit 0)" "$CODE" "0"
 assert_eq "…under its original stamp" "$(newest_tag)" "$ATT"
 assert_eq "…deploy_verified=yes" "$(field "$ATT" deploy_verified)" "yes"
+assert_eq "…and a reconciled FIRST deploy still needs Christie's IAM reading" "$(field "$ATT" attest_needed)" "yes"
+assert_has "…saying so" "$OUT" "IAM reading NEEDED"
 # --clear-inflight
 fixture_reset
 : > "$SC/cli_block"; start_killable --approved "$SHA1" --codebase core; rm -f "$SC/cli_block"
 ATT="$(awk -F= '$1=="attempt"{print $2}' "$INFLIGHT")"
 evidence_op "$T/ev.json" WORKING null
 run --clear-inflight "${NS}/20990101T000000Z-${SHA1:0:7}" --codebase core --evidence "$T/ev.json"
 assert_eq "--clear-inflight naming another attempt → exit 22" "$CODE" "22"
 run --clear-inflight "$ATT" --codebase core --evidence "$T/ev.json"
 assert_eq "--clear-inflight with Christie's evidence → exit 0" "$CODE" "0"
 assert_eq "…keeps the original stamp" "$(newest_tag)" "$ATT"
 assert_eq "…deploy_match=unknown" "$(field "$ATT" deploy_match)" "unknown"
 assert_eq "…deploy_verified=no" "$(field "$ATT" deploy_verified)" "no"
+assert_eq "…attest_needed=yes (not verified)" "$(field "$ATT" attest_needed)" "yes"
+assert_has "…saying so" "$OUT" "IAM reading NEEDED"
 assert_eq "…the in-flight file is gone" "$([ -e "$INFLIGHT" ] && echo present || echo gone)" "gone"
 run --approved "$SHA1" --codebase core; assert_eq "…and the next --approved runs (verified)" "$CODE" "0"
 # a truncated in-flight file fails closed
 fixture_reset
 : > "$SC/cli_block"; start_killable --approved "$SHA1" --codebase core; rm -f "$SC/cli_block"
 head -3 "$INFLIGHT" > "$INFLIGHT.t" && mv "$INFLIGHT.t" "$INFLIGHT"
 evidence_op "$T/ev.json"; run --reconcile --codebase core --evidence "$T/ev.json"
 assert_eq "a truncated in-flight file → --reconcile refuses (exit 22)" "$CODE" "22"; assert_has "…as malformed" "$OUT" "malformed"
 run --clear-inflight x --codebase core --evidence "$T/ev.json"; assert_eq "…--clear-inflight too" "$CODE" "22"
 run --status --codebase core; assert_has "…and --status says MALFORMED" "$OUT" "MALFORMED"
 run --approved "$SHA1" --codebase core; assert_eq "…and --approved refuses" "$CODE" "22"
 
 # ═══ ordering: newest attempt, --reverify ═══════════════════════════════════════════════════════════════
 fixture_reset
 echo timeout > "$SC/probe"; run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 rm -f "$SC/probe"; S2="$(commit_change functions/core/index.js "exports.b = 2;")"
 run --approved "$S2" --codebase core; RB="$(newest_tag)"
 assert_eq "attempt A unverified, attempt B verified" "$(field "$RA" deploy_verified) $(field "$RB" deploy_verified)" "no yes"
 run --reverify "$RA" --codebase core
 assert_eq "--reverify A is refused: not the newest attempt (exit 26)" "$CODE" "26"
 assert_eq "…and wrote no verify record" "$(git tag -l "${NS}-verify/*" | wc -l | tr -d ' ')" "0"
 run --status --codebase core; assert_has "--status names B" "$OUT" "verified at ${RB}"
 S3="$(commit_change functions/core/index.js "exports.c = 3;")"
 run --diff --codebase core; assert_has "--diff diffs from B" "$OUT" "last verified attempt ${RB}"; assert_has "…showing the new line" "$OUT" "+exports.c = 3;"
 assert_lacks "…not from A (A's change is already in B)" "$OUT" "+exports.b = 2;"
 echo timeout > "$SC/probe"; run --approved "$S3" --codebase core; RC="$(newest_tag)"
 assert_eq "attempt C: unverified only by its probe" "$(field "$RC" deploy_match) $(field "$RC" access) $(field "$RC" deploy_verified)" "yes inconclusive no"
 run --status --codebase core; assert_has "--status: production may be mixed, last verified B" "$OUT" "production may be mixed: last verified ${RB}; unverified attempt ${RC}"
 run --diff --codebase core; assert_has "--diff warns the newest attempt is unverified" "$OUT" "NOT verified"
 rm -f "$SC/probe"; run --reverify "$RC" --codebase core
 assert_eq "--reverify C (the newest) → verified (exit 0)" "$CODE" "0"
 RV="$(newest_tag "${NS}-verify")"
 assert_eq "…a verify record naming C" "$(field "$RV" attempt)" "$RC"
 assert_eq "…deploy_verified=yes" "$(field "$RV" deploy_verified)" "yes"
 assert_eq "…C's own record is unchanged" "$(field "$RC" deploy_verified)" "no"
@@ -709,92 +720,108 @@ echo '{"functions":{}}' > "$T/iam.json"; run --attest "$RA" --codebase core --ev
 assert_eq "a reading not in the fixed shape → refused (exit 25)" "$CODE" "25"
 run --approved "$SHA1" --codebase core; evidence_iam "$T/iam.json"
 run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "attesting an attempt that is no longer the newest → refused (exit 26)" "$CODE" "26"
 # a runtime account the attempt declares but iam-expectations.json doesn't name: its roles were never read
 fixture_reset
 "$JQ" '.["core/canary"].serviceAccount = "reports@my-clay-hub.iam.gserviceaccount.com"' functions/declarations.json > d.new && mv d.new functions/declarations.json
 git commit --quiet -am "canary runs as reports@"; git push --quiet; SR="$(git rev-parse HEAD)"
 manifest_edit '.endpoints.canary.serviceAccountEmail = "reports@my-clay-hub.iam.gserviceaccount.com"'
 run --approved "$SR" --codebase core; RA="$(newest_tag)"
 evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
 assert_eq "a declared runtime account missing from iam-expectations.json → iam_attested=no" "$CODE" "21"
 assert_has "…naming it" "$OUT" "reports@my-clay-hub.iam.gserviceaccount.com is declared but not in functions/iam-expectations.json"
 
 # ═══ whether a deploy needs Christie's IAM reading (Christie, Oct 1 2026) ══════════════════════════════════
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 assert_eq "a first deploy → attest_needed=yes" "$(field "$RA" attest_needed)" "yes"
 assert_has "…because nothing is attested yet" "$(field "$RA" attest_needed_why)" "no attempt of core has iam_attested=yes yet"
 assert_has "…and it prints the reading to take" "$OUT" "IAM reading NEEDED"; assert_has "…with the JSON shape" "$OUT" "next: Christie's IAM reading"
 evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"; assert_eq "…attested yes" "$CODE" "0"
 SA="$(commit_change functions/core/index.js "exports.a1 = 1;")"
 run --approved "$SA" --codebase core; RB="$(newest_tag)"
 assert_eq "a source-only change after an attested deploy → verified (exit 0)" "$CODE" "0"
 assert_eq "…attest_needed=no" "$(field "$RB" attest_needed)" "no"
 assert_has "…naming the attested attempt it relies on" "$(field "$RB" attest_needed_why)" "last attested ${RA}"
 assert_has "…and it says so" "$OUT" "IAM reading not needed"; assert_lacks "…without the reading's JSON shape" "$OUT" "next: Christie's IAM reading"
 : > "$SC/api_enabled"; SB="$(commit_change functions/core/index.js "exports.a2 = 2;")"
 run --approved "$SB" --codebase core; RC="$(newest_tag)"; rm -f "$SC/api_enabled"
 assert_eq "the CLI enabled a Google API during the deploy → attest_needed=yes" "$(field "$RC" attest_needed)" "yes"
 assert_has "…naming it" "$(field "$RC" attest_needed_why)" "the CLI enabled a Google API"
 assert_has "…and it prints the reading to take" "$OUT" "next: Christie's IAM reading"
 SC2="$(commit_change functions/core/index.js "exports.a3 = 3;")"
 run --approved "$SC2" --codebase core; RD="$(newest_tag)"
 assert_eq "a reading owed by the API deploy was never taken → the next source-only deploy still needs it" "$(field "$RD" attest_needed)" "yes"
-assert_has "…naming the attempt that owes it" "$(field "$RD" attest_needed_why)" "${RC} needed a reading that was never attested yes"
+assert_has "…naming the attempt that owes it" "$(field "$RD" attest_needed_why)" "${RC} needed a reading, or its reading came back no"
 evidence_iam "$T/iam.json"; run --attest "$RD" --codebase core --evidence "$T/iam.json"; assert_eq "…once the newest attempt is attested yes" "$CODE" "0"
 SD="$(commit_change functions/core/index.js "exports.a5 = 5;")"
 run --approved "$SD" --codebase core; RG="$(newest_tag)"
 assert_eq "…the next source-only deploy → no" "$(field "$RG" attest_needed)" "no"
 assert_has "…relying on that attestation" "$(field "$RG" attest_needed_why)" "last attested ${RD}"
 SE="$(commit_change functions/iam-expectations.json "")"   # any change to the file counts, even a blank line
 run --approved "$SE" --codebase core; RE="$(newest_tag)"
 assert_eq "functions/iam-expectations.json changed since the attested attempt → attest_needed=yes" "$(field "$RE" attest_needed)" "yes"
 assert_has "…naming the file" "$(field "$RE" attest_needed_why)" "changed since ${RD}: functions/iam-expectations.json"
 # an attempt from before this rule (no attest_needed field) between the attested one and now: the reading is owed
 git tag -d "$RE" >/dev/null; git push --quiet origin ":refs/tags/$RE"   # (drop the iam-file attempt so only the old-style one is in between)
 git for-each-ref --format='%(contents)' "refs/tags/$RG" | grep -v '^attest_needed' > "$T/old.msg"
 git tag -d "$RG" >/dev/null; git push --quiet origin ":refs/tags/$RG"; git tag -a -F "$T/old.msg" "$RG" "$SD"; git push --quiet origin "refs/tags/$RG"
 SH="$(commit_change functions/core/index.js "exports.a6 = 6;")"
 run --approved "$SH" --codebase core; RH="$(newest_tag)"
 assert_eq "an unattested attempt from before this rule in between → attest_needed=yes (fail-closed)" "$(field "$RH" attest_needed)" "yes"
-assert_has "…naming it" "$(field "$RH" attest_needed_why)" "${RG} needed a reading that was never attested yes"
+assert_has "…naming it" "$(field "$RH" attest_needed_why)" "${RG} needed a reading, or its reading came back no"
 : > "$SC/skip_line"; SF="$(commit_change functions/core/index.js "exports.a4 = 4;")"
 run --approved "$SF" --codebase core; RF="$(newest_tag)"; rm -f "$SC/skip_line"
 assert_eq "an unverified deploy → attest_needed=yes" "$(field "$RF" attest_needed)" "yes"
 assert_has "…saying so" "$(field "$RF" attest_needed_why)" "the deploy is not verified"
+run --status --codebase core; assert_has "--status shows attest_needed and why" "$OUT" "attest_needed=yes — the deploy is not verified"
+# a reading that came back no stays owed, even for an attempt that didn't need one
+fixture_reset
+run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
+evidence_iam "$T/iam.json"; run --attest "$RA" --codebase core --evidence "$T/iam.json"
+SA="$(commit_change functions/core/index.js "exports.b1 = 1;")"; run --approved "$SA" --codebase core; RB="$(newest_tag)"
+assert_eq "…(a source-only deploy after an attested one needs none)" "$(field "$RB" attest_needed)" "no"
+evidence_iam "$T/iam.json" '.projectRoles["roles/editor"] += ["user:someone@x.com"]'; run --attest "$RB" --codebase core --evidence "$T/iam.json"
+assert_eq "…an optional reading finds a mismatch → iam_attested=no" "$CODE" "21"
+SB="$(commit_change functions/core/index.js "exports.b2 = 2;")"; run --approved "$SB" --codebase core; RC="$(newest_tag)"
+assert_eq "a known iam_attested=no since the last yes → the next deploy needs a reading" "$(field "$RC" attest_needed)" "yes"
+assert_has "…naming the attempt" "$(field "$RC" attest_needed_why)" "${RB} needed a reading, or its reading came back no"
+# the transcript exists but can't be read (grep exits 2): needed, never "no API enabled"
+: > "$SC/grep_fail"; SC3="$(commit_change functions/core/index.js "exports.b3 = 3;")"; run --approved "$SC3" --codebase core; RD="$(newest_tag)"; rm -f "$SC/grep_fail"
+assert_eq "an unreadable transcript → attest_needed=yes" "$(field "$RD" attest_needed)" "yes"
+assert_has "…saying so" "$(field "$RD" attest_needed_why)" "could not read the transcript"
 
 # ═══ the verifier: the pushed tip's guard, and a changed guard needs Christie's OK ═════════════════════
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 echo "# local edit" >> scripts/deploy-functions.sh
 run --reverify "$RA" --codebase core; assert_eq "a DIRTY guard refuses (exit 27)" "$CODE" "27"; assert_has "…saying why" "$OUT" "not origin/main's"
 git commit --quiet -am "unpushed guard edit"
 run --reverify "$RA" --codebase core; assert_eq "an UNPUSHED guard refuses (exit 27)" "$CODE" "27"
 run --approved "$SHA1" --codebase core; assert_eq "…--approved too" "$CODE" "27"; no_deploy "…never deployed"
 git push --quiet
 run --reverify "$RA" --codebase core
 assert_eq "once pushed, the guard changed since the attempt → refused without Christie's OK (exit 27)" "$CODE" "27"
 assert_has "…naming the change" "$OUT" "first at scripts/deploy-functions.sh"
 run --reverify "$RA" --codebase core --acknowledge-verifier-change
 assert_eq "…with --acknowledge-verifier-change → re-verified (exit 0)" "$CODE" "0"
 assert_has "…and the record says so" "$(field "$(newest_tag "${NS}-verify")" verifier_changed)" "yes (scripts/deploy-functions.sh)"
 assert_eq "…and names the commit whose helpers rebuilt the expected state" "$(field "$(newest_tag "${NS}-verify")" rebuild_helpers_from)" "$SHA1"
 fixture_reset
 run --approved "$SHA1" --codebase core; RA="$(newest_tag)"
 commit_change scripts/lib/functions-hash.mjs "// a changed hash module" >/dev/null
 run --reverify "$RA" --codebase core
 assert_eq "a changed HELPER (the hash module) since the attempt → refused without Christie's OK (exit 27)" "$CODE" "27"
 assert_has "…naming it" "$OUT" "first at scripts/lib/functions-hash.mjs"
 # control files: an older commit whose machinery differs from the tip is refused
 fixture_reset
 "$JQ" '.' functions/declarations.json > d.new && printf '\n' >> d.new && mv d.new functions/declarations.json; git commit --quiet -am "touch declarations"; git push --quiet
 run --approved "$SHA1" --codebase core
 assert_eq "an older commit whose declarations differ from the tip → exit 14" "$CODE" "14"; assert_has "…naming it" "$OUT" "carries a different functions/declarations.json"
 no_deploy "…never deployed"
 
 # ═══ the record can't be written or published ══════════════════════════════════════════════════════════
 fixture_reset
 git config remote.origin.pushurl /nonexistent/path
 run --approved "$SHA1" --codebase core
 assert_eq "the record's push fails → exit 17" "$CODE" "17"; assert_has "…RECORD NOT PUBLISHED" "$OUT" "RECORD NOT PUBLISHED"

exec
/bin/zsh -lc "nl -ba scripts/lib/receipts.sh | sed -n '1,240p'
rg -n \""'^(codebase_on_tip|inflight_valid|record_word|record_field|iam_attested_of|receipt_rows)'"\\(|iam-expectations|TRANSCRIPT=|DEPLOY_VERIFIED=\" scripts/deploy-functions.sh scripts/lib/receipts.sh
sed -n '145,170p' scripts/deploy-functions.test.sh
git diff --check c562f69"'^ c562f69
git show c562f69''^:scripts/deploy-functions.sh | nl -ba | sed -n '"'650,725p'" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
     1	#!/bin/bash
     2	# The receipt record, shared by both of this repo's guards: scripts/deploy-rules.sh (rules, storage, indexes) and
     3	# scripts/deploy-functions.sh (functions). SOURCED, never run; each guard sources it after `cd "$REPO"`, so it reads
     4	# the pinned repo's copy, and each guard lists it in its CONTROL_FILES. One copy of the ordering code means a receipt
     5	# is ordered the same way by both guards (tested in scripts/deploy-functions.test.sh).
     6	#
     7	# The caller sets REMOTE, BRANCH, TAG_ROOT and TAG_PREFIX (the namespace receipt_rows, latest_receipt and newest_stamp
     8	# read when not given one). Extracted from deploy-rules.sh in D2-3 WITHOUT changing its behaviour (F1); its whole
     9	# suite runs unchanged.
    10	#
    11	# Two kinds of reader, labelled on each:
    12	#   FAIL-CLOSED — anything that orders the record or decides deploy_verified / iam_attested. A read that fails, or a
    13	#                 value that isn't one of the expected words, returns 1; callers refuse (`X="$(f)" || die …`).
    14	#   FAIL-SOFT   — display only (receipt_written, receipt_by, receipt_note). Missing evidence prints nothing.
    15	# Plan: ~/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html (F1, F9).
    16	
    17	# ─── The record: which tags are receipts, and which one shipped last ───────────────────────────────────
    18	# "What shipped last" is the base of the diff Christie reads before approving, so naming the wrong receipt
    19	# is the whole risk this file exists to manage. Receipt NAMES carry only second resolution, so two deploys
    20	# landing in one second tie on the name; the old `--sort=-refname` then broke that tie on the trailing
    21	# sha7, which carries no order at all. The guard could diff against the wrong base — EMPTY, when that base
    22	# was the commit being deployed — and, worse, print "nothing to deploy" for a change that never shipped.
    23	# Measured Sep 22 2026 before the fix: 3 of 9 runs of the guard suite failed on exactly that.
    24	#
    25	# ORDER: (name stamp, tag date, refname), all descending.
    26	#   - The name stamp IS deploy time. It is not a time this script OBSERVES; it is one the script WRITES,
    27	#     and that hand-recovery TRANSCRIBES — step 9's failure path prints the tag name for the operator to
    28	#     copy. A receipt written 49 minutes late therefore still carries deploy time, while the tag object's
    29	#     own date does not survive that transcription at all. Ordering by tag date was tried, reviewed and
    30	#     REVERTED (d43a171); the repo's only real receipt was hand-written 49m12s after the deploy it
    31	#     records. Do not reintroduce it as the primary key.
    32	#   - The tag date breaks EXACT stamp ties only, where it is the only evidence available.
    33	#   - refname is last, for determinism alone.
    34	#
    35	# A RECEIPT is a ref under this target's namespace that is:
    36	#   1. an ANNOTATED tag — step 9 writes nothing else, and a lightweight tag has no date of its own (git
    37	#      reports the pointed-to commit's date, which for a rollback deploy is not deploy time at all);
    38	#   2. named with a stamp that is a REAL UTC date-time (full calendar check, leap years included); and
    39	#   3. stamped NO LATER THAN its own tag object was written. Step 9 reserves the stamp BEFORE the release
    40	#      and tags AFTER it, so a genuine receipt always satisfies this — including one from a clone whose
    41	#      clock is wrong, because both values come from that same clock. A tag naming a time after it was
    42	#      itself written was fabricated. Note this compares two values FROZEN IN THE TAG OBJECT, never
    43	#      against "now": a tag can therefore never age into or out of being a receipt. Two narrow cases
    44	#      where clause 3 drops a GENUINE receipt, both accepted and neither reachable by normal use: the
    45	#      clock stepping BACKWARDS between the reservation at step 7b and `git tag -a` after the release
    46	#      (an NTP correction, a laptop waking) — the window is the release duration, where before this
    47	#      change it was near zero; and the printed hand-recovery command being run on a DIFFERENT machine
    48	#      whose clock is behind the deploying one's by more than the recovery took. In both the receipt is
    49	#      invisible rather than misleading, so the next deploy diffs from an older base — except when it
    50	#      was the only receipt, where the guard says "first guarded deploy" and prints no diff at all.
    51	#      (An earlier draft compared the stamp to now; a receipt from a two-seconds-fast clone was then excluded, a later
    52	#      deploy wrote a LOWER stamp, and the excluded receipt aged back in and won permanently.)
    53	# The SAME predicate serves the reader and the writer's newest-stamp lookup — d43a171 filtered lightweight
    54	# tags when reading but counted them when ordering, so a stray tag was "not a receipt" for --status yet
    55	# could still stall every deploy.
    56	#
    57	# %(creatordate:unix) is deliberate: `%(creatordate:format:%Y%m%dT%H%M%SZ)` renders in the TAG AUTHOR's
    58	# timezone and then appends the literal Z, so on this machine the real receipt reads 20260921T165412Z when
    59	# the truth is 22:54:12Z. That would misorder receipts written in different offsets AND print a false time
    60	# to the person approving the diff — and no single-timezone test fixture can tell the two spellings apart.
    61	receipt_rows() {   # FAIL-CLOSED. One row per receipt under $1 (default $TAG_PREFIX), newest first: "<stamp> <tagdate-unix> <refname>"; '' if none
    62	  local rows p="${1:-$TAG_PREFIX}"
    63	  # lstrip=2 strips exactly "refs/tags/", always. NOT %(refname:short), whose spelling depends on OTHER
    64	  # refs: create a BRANCH named like a receipt and git renders the tag as "tags/deployed/…" instead of
    65	  # "deployed/…", the prefix no longer matches where this parser expects it, and a perfectly good receipt
    66	  # silently vanishes from the record. Verified here. (A branch name like that is a legal git ref.)
    67	  rows="$(git for-each-ref --format='%(objecttype) %(creatordate:unix) %(refname:lstrip=2)' "refs/tags/${p}")" || return 1
    68	  printf '%s\n' "$rows" | LC_ALL=C awk -v p="$p" '
    69	    function epoch(s,   y,mo,d,h,mi,se,dm,i,n) {          # -1 unless s is a real UTC date-time
    70	      y=substr(s,1,4)+0; mo=substr(s,5,2)+0; d=substr(s,7,2)+0
    71	      h=substr(s,10,2)+0; mi=substr(s,12,2)+0; se=substr(s,14,2)+0
    72	      if (y<1970 || mo<1 || mo>12 || d<1 || h>23 || mi>59 || se>59) return -1
    73	      split("31 28 31 30 31 30 31 31 30 31 30 31", dm, " ")
    74	      if (y%4==0 && (y%100!=0 || y%400==0)) dm[2]=29
    75	      if (d>dm[mo]+0) return -1
    76	      n=0
    77	      for (i=1970; i<y; i++) n += (i%4==0 && (i%100!=0 || i%400==0)) ? 366 : 365
    78	      for (i=1; i<mo; i++) n += dm[i]+0
    79	      return (((n+d-1)*24+h)*60+mi)*60+se
    80	    }
    81	    $1 != "tag" { next }                                  # (1) annotated only
    82	    { name=$3; rest=substr(name, length(p)+1); i=index(rest, "-"); if (i < 2) next
    83	      s=substr(rest, 1, i-1)
    84	      if (s !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]T[0-9][0-9][0-9][0-9][0-9][0-9]Z$/) next
    85	      e=epoch(s); if (e < 0) next                         # (2) a real UTC date-time
    86	      if (e > $2+0) next                                  # (3) not stamped after it was written
    87	      print s, $2, name }' | LC_ALL=C sort -k1,1r -k2,2nr -k3,3r
    88	}
    89	# NOTE on every function below that reads the record: `local` is declared on its own line, because
    90	# `local x="$(cmd)"` returns local's status and MASKS the command's (verified on bash 3.2.57 here). And
    91	# each is called as `X="$(f)" || die …`, which SUPPRESSES errexit inside f — so every fallible command
    92	# inside these functions carries its own `|| return 1`. A read that fails must never read as "no receipt".
    93	latest_receipt() {   # FAIL-CLOSED. The newest receipt under $1 (default $TAG_PREFIX); '' if there is none
    94	  local rows
    95	  rows="$(receipt_rows "${1:-}")" || return 1
    96	  printf '%s\n' "$rows" | awk 'NR==1{printf "%s", $3}'   # not `head -1`: under pipefail its early exit
    97	}                                                        # can SIGPIPE the sort and fail a healthy read
    98	newest_stamp() {     # FAIL-CLOSED. The newest recorded stamp under $1 (default $TAG_PREFIX); '' if there is none
    99	  local rows
   100	  rows="$(receipt_rows "${1:-}")" || return 1
   101	  printf '%s\n' "$rows" | awk 'NR==1{printf "%s", $1}'
   102	}
   103	# The two below are DISPLAY only — nothing is ordered or decided from them — so unlike the functions
   104	# above they deliberately fail SOFT: a receipt whose annotation cannot be read still gets named, just
   105	# without its provenance. Missing evidence must never block a deploy that is otherwise fine.
   106	receipt_written() {  # when $1's tag object was actually written, in TRUE UTC (see the note above)
   107	  TZ=UTC git for-each-ref --format='%(creatordate:format-local:%Y-%m-%dT%H:%M:%SZ)' "refs/tags/$1" 2>/dev/null || true
   108	}
   109	receipt_by() {       # the by= field from $1's own message ('' if it has none)
   110	  local body
   111	  body="$(git tag -l --format='%(contents)' "$1" 2>/dev/null)" || return 0
   112	  printf '%s\n' "$body" | awk '{ if (!d) for (i=1;i<=NF;i++) if (substr($i,1,3)=="by=") { printf "%s", substr($i,4); d=1; break } }'
   113	}
   114	receipt_note() {     # "…, tag written <utc>, by=<who>" — the evidence behind the answer, as plain fact
   115	  local when who out=""
   116	  when="$(receipt_written "$1")"; who="$(receipt_by "$1")"
   117	  [ -n "$when" ] && out="${out}, tag written ${when}"
   118	  [ -n "$who" ]  && out="${out}, by=${who}"
   119	  printf '%s' "$out"
   120	}
   121	# Always resolved through the full refs/tags/ path, for the same reason as lstrip=2 above: a branch
   122	# sharing a receipt's name would otherwise make this bare name ambiguous and resolve to the wrong object.
   123	receipt_commit() { git rev-list -n 1 "refs/tags/$1"; }
   124	
   125	# Fetch the branch AND the receipt namespace (a receipt from another clone, or one deleted here, must be
   126	# seen; `git fetch <branch>` alone does not reliably bring tags). A receipt name that exists on both sides
   127	# pointing at DIFFERENT tag objects is a corrupted record and refuses the fetch (no --force).
   128	fetch_state() {   # prints git's own words on failure (--quiet would swallow the "would clobber existing tag" line)
   129	  git fetch "$REMOTE" "$BRANCH" "refs/tags/${TAG_ROOT}/*:refs/tags/${TAG_ROOT}/*" 2>&1 >/dev/null || return 1
   130	}
   131	
   132	# ─── Record fields (the functions guard's records) ─────────────────────────────────────────────────────
   133	# A functions record's message is one `key=value` per line (scripts/deploy-functions.sh writes them). Every reader here
   134	# is FAIL-CLOSED: a tag that isn't annotated, a message that can't be read, or a key that is missing or appears twice
   135	# returns 1 — never an empty value that a caller could read as "no".
   136	record_field() {     # FAIL-CLOSED. <tag> <key> → the value of the ONE line "<key>=…" in that annotated tag's message
   137	  local kind body n
   138	  kind="$(git cat-file -t "refs/tags/$1" 2>/dev/null)" || return 1
   139	  [ "$kind" = tag ] || return 1
   140	  body="$(git for-each-ref --format='%(contents)' "refs/tags/$1")" || return 1
   141	  n="$(printf '%s\n' "$body" | awk -v k="$2=" 'index($0, k) == 1 { n++ } END { print n + 0 }')" || return 1
   142	  [ "$n" = 1 ] || return 1
   143	  printf '%s\n' "$body" | awk -v k="$2=" 'index($0, k) == 1 { printf "%s", substr($0, length(k) + 1) }'
   144	}
   145	record_word() {      # FAIL-CLOSED. <tag> <key> <allowed words, space-separated> → the value, only if it is one of them
   146	  local v w
   147	  v="$(record_field "$1" "$2")" || return 1
   148	  for w in $3; do [ "$v" = "$w" ] && { printf '%s' "$v"; return 0; }; done
   149	  return 1
   150	}
   151	records_for() {      # FAIL-CLOSED. <prefix> <attempt_id> → the records under <prefix> naming attempt=<attempt_id>, newest first
   152	  local rows r a
   153	  rows="$(receipt_rows "$1")" || return 1
   154	  [ -n "$rows" ] || return 0
   155	  while read -r _ _ r; do
   156	    a="$(record_field "$r" attempt)" || return 1
   157	    [ "$a" = "$2" ] && printf '%s\n' "$r"
   158	  done <<< "$rows"
   159	  return 0
   160	}
   161	deploy_verified_of() {  # FAIL-CLOSED. <attempt_id> <verify prefix> → yes|no: the newest verify record's, else the attempt's own
   162	  local v newest
   163	  v="$(records_for "$2" "$1")" || return 1
   164	  newest="$(printf '%s\n' "$v" | awk 'NR==1{printf "%s", $0}')"
   165	  if [ -n "$newest" ]; then record_word "$newest" deploy_verified "yes no"; else record_word "$1" deploy_verified "yes no"; fi
   166	}
   167	iam_attested_of() {     # FAIL-CLOSED. <attempt_id> <attest prefix> → yes|no from the newest attest record, or "none"
   168	  local v newest
   169	  v="$(records_for "$2" "$1")" || return 1
   170	  newest="$(printf '%s\n' "$v" | awk 'NR==1{printf "%s", $0}')"
   171	  if [ -n "$newest" ]; then record_word "$newest" iam_attested "yes no"; else printf 'none'; fi
   172	}
scripts/lib/receipts.sh:61:receipt_rows() {   # FAIL-CLOSED. One row per receipt under $1 (default $TAG_PREFIX), newest first: "<stamp> <tagdate-unix> <refname>"; '' if none
scripts/lib/receipts.sh:136:record_field() {     # FAIL-CLOSED. <tag> <key> → the value of the ONE line "<key>=…" in that annotated tag's message
scripts/lib/receipts.sh:145:record_word() {      # FAIL-CLOSED. <tag> <key> <allowed words, space-separated> → the value, only if it is one of them
scripts/lib/receipts.sh:167:iam_attested_of() {     # FAIL-CLOSED. <attempt_id> <attest prefix> → yes|no from the newest attest record, or "none"
scripts/deploy-functions.sh:113:SHOWN_PATHS="${SRC} firebase.json functions/declarations.json functions/iam-expectations.json functions/firebase-config.json"
scripts/deploy-functions.sh:119:CONTROL_FILES="firebase.json .firebaserc package.json package-lock.json scripts/deploy-rules.sh scripts/deploy-rules.test.sh scripts/predeploy-check.sh scripts/emulator-safety.js scripts/functions-emulator.mjs scripts/functions-discover.mjs tests scripts/deploy-functions.sh scripts/deploy-functions.test.sh scripts/lib/receipts.sh scripts/lib/functions-hash.mjs FUNCTIONS-ROLLBACK.md functions/declarations.json functions/iam-expectations.json functions/firebase-config.json ${SRC}/package.json ${SRC}/package-lock.json"
scripts/deploy-functions.sh:280:# … then the content, against the declarations and functions/iam-expectations.json: every difference is a reason, and
scripts/deploy-functions.sh:311:      | "runtime account \(.) is declared but not in functions/iam-expectations.json, so its roles were never read" ),
scripts/deploy-functions.sh:357:inflight_valid() {   # 0 when the in-flight file is complete and well-formed
scripts/deploy-functions.sh:442:codebase_on_tip() {
scripts/deploy-functions.sh:624:    DEPLOY_VERIFIED=yes
scripts/deploy-functions.sh:626:    DEPLOY_VERIFIED=no
scripts/deploy-functions.sh:662:ATTEST_FILES="functions/declarations.json functions/iam-expectations.json firebase.json .firebaserc"
scripts/deploy-functions.sh:727:    <(if [ -n "${TMP:-}" ] && [ -f "${TMP}/functions/iam-expectations.json" ]; then cat "${TMP}/functions/iam-expectations.json"
scripts/deploy-functions.sh:728:      else git show "${MAIN_SHA}:functions/iam-expectations.json"; fi)   # --clear-inflight has no worktree: the tip's file
scripts/deploy-functions.sh:868:  TRANSCRIPT="${TRANSCRIPTS}/functions-${CB}-${STAMP}-${SHA:0:7}.log"
scripts/deploy-functions.sh:950:    DEPLOY_VERIFIED=no; TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
scripts/deploy-functions.sh:978:  TRANSCRIPT="$(inflight_get transcript 2>/dev/null || true)"; attest_need "$MSG"
scripts/deploy-functions.sh:1041:IAM="$(git show "${SHA}:functions/iam-expectations.json" | "$JQ" -c .)" || die $EX_RECORD "could not read the attempt's functions/iam-expectations.json."
scripts/deploy-functions.sh:1042:[ "$(printf '%s' "$IAM" | "$JQ" -r .project)" = "$PROJECT" ] || die $EX_CONFIG "functions/iam-expectations.json is not for ${PROJECT}."
  refused)    hdr 403 'server: Google Frontend' ;;
  reached403) hdr 403 'x-tinker-reached: canary' ;;
  ok200)      hdr 200 'x-tinker-reached: canary' ;;
  plain200)   hdr 200 'server: Google Frontend' ;;
  timeout)    echo "curl: (28) Operation timed out" >&2; exit 28 ;;
  notfound)   hdr 404 'server: Google Frontend' ;;
  error500)   hdr 500 'server: Google Frontend' ;;
esac
exit 0
EOF
cat > "$T/bin/grep" <<EOF
#!/bin/bash
# Real grep, except that with \$SC/grep_fail present a search for the CLI's "Enabling now" line fails like an unreadable file.
if [ -f "$SC/grep_fail" ]; then for a in "\$@"; do [ "\$a" = "Enabling now" ] && exit 2; done; fi
exec /usr/bin/grep "\$@"
EOF
chmod +x "$T/bin/grep"
cat > "$T/bin/sleep" <<EOF
#!/bin/bash
[ "\${1:-}" = 1 ] && exec /bin/sleep 1
echo "sleep \$*" >> "$SC/log"; exit 0
EOF
# Transparent git wrapper, inert unless FAIL_GIT names a subcommand (and FAIL_GIT_ARG an argument) to fail.
cat > "$T/bin/git" <<EOF
#!/bin/bash
if [ -n "\${FAIL_GIT:-}" ] && [ "\${1:-}" = "\$FAIL_GIT" ]; then
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-QrcgTUGF' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-UphhdNTP' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Y01ZT7mB' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-K7fvcUwP' (errno=Operation not permitted)
   650	    [ "$ACK" = 1 ] || die $EX_VERIFIER "the guard's machinery changed between the attempt (${1:0:12}) and ${REMOTE}/${BRANCH} (${MAIN_SHA:0:12}), first at ${changed}. The record would be judged by the tip's checks while the expected state is rebuilt with the attempt's own helpers. Once Christie has OK'd that, run again with --acknowledge-verifier-change."
   651	    printf 'verifier=%s\nverifier_changed=yes (%s)\nverifier_change_acknowledged=yes\n' "$MAIN_SHA" "$changed" >> "$2"
   652	  else
   653	    printf 'verifier=%s\nverifier_changed=no\n' "$MAIN_SHA" >> "$2"
   654	  fi
   655	}
   656	# Whether this deploy needs Christie's IAM reading (Christie, Oct 1 2026: re-read IAM only when something that shapes
   657	# it changed). FAIL-CLOSED: anything unreadable means "needed". Needed when the deploy isn't verified; when no attempt of
   658	# this codebase has iam_attested=yes yet; when the function set or a file that decides who may do what (ATTEST_FILES)
   659	# changed since the newest attested attempt; or when the CLI turned on a Google API during this deploy — Google can add
   660	# role grants when an API is enabled (D2-5: enabling Firebase Extensions gave the Google APIs Service Agent Editor).
   661	# Not seen either way: a role someone changes by hand in the Console. Sets ATTEST_NEEDED, ATTEST_WHY; appends to <msg>.
   662	ATTEST_FILES="functions/declarations.json functions/iam-expectations.json firebase.json .firebaserc"
   663	API_ENABLED_LINE="Enabling now"
   664	attest_need() {   # <msg>
   665	  local why="" rows r a last="" changed owed="" n
   666	  [ "$DEPLOY_VERIFIED" = yes ] || why="${why}the deploy is not verified; "
   667	  if [ ! -f "$TRANSCRIPT" ]; then why="${why}no transcript to check for a newly enabled Google API; "
   668	  elif grep -qF -- "$API_ENABLED_LINE" "$TRANSCRIPT"; then why="${why}the CLI enabled a Google API during this deploy (Google can add role grants then); "
   669	  fi
   670	  if ! rows="$(receipt_rows "$ATTEMPT_PREFIX")"; then why="${why}could not read the record of earlier attempts; "
   671	  else
   672	    while read -r _ _ r; do
   673	      [ -n "$r" ] || continue
   674	      if ! a="$(iam_attested_of "$r" "$ATTEST_PREFIX")"; then why="${why}could not read whether ${r} was attested; "; last=""; break; fi
   675	      [ "$a" = yes ] && { last="$r"; break; }
   676	      # A reading owed by a later, unattested attempt stays owed (one with no attest_needed predates this rule).
   677	      n="$(record_field "$r" attest_needed 2>/dev/null || echo unknown)"
   678	      [ "$n" = no ] || owed="${owed:-$r}"
   679	    done <<< "$rows"
   680	    [ -z "$last" ] || [ -z "$owed" ] || why="${why}${owed} needed a reading that was never attested yes; "
   681	    if [ -z "$last" ]; then
   682	      case "$why" in *"could not read whether"*) ;; *) why="${why}no attempt of ${CB} has iam_attested=yes yet; " ;; esac
   683	    else
   684	      # shellcheck disable=SC2086 # ATTEST_FILES is a fixed word list
   685	      if ! changed="$(git diff --name-only "$(commit_of "$last")" "$SHA" -- $ATTEST_FILES | tr '\n' ' ')"; then
   686	        why="${why}could not compare with ${last}; "
   687	      elif [ -n "$changed" ]; then why="${why}changed since ${last}: ${changed% }; "
   688	      fi
   689	      [ "$(record_field "$last" functions 2>/dev/null)" = "$IDS" ] || why="${why}the functions differ from ${last}'s; "
   690	    fi
   691	  fi
   692	  if [ -n "$why" ]; then ATTEST_NEEDED=yes; ATTEST_WHY="${why%; }"
   693	  else ATTEST_NEEDED=no; ATTEST_WHY="last attested ${last}; since then the same functions, no change to ${ATTEST_FILES// /, }, and the CLI enabled no Google API"
   694	  fi
   695	  printf 'attest_needed=%s\nattest_needed_why=%s\n' "$ATTEST_NEEDED" "$ATTEST_WHY" >> "$1"
   696	}
   697	attest_help() {   # printed after a deploy: what --attest needs, generated from the IAM expectations it is checked against
   698	  say "─── next: Christie's IAM reading, then --attest (F9, M3) ───"
   699	  say "Christie reads, in the Console, and Claude writes into a JSON file exactly this shape (every holder as"
   700	  say "\"user:…\" or \"serviceAccount:…\"; each list complete, as read):"
   701	  "$JQ" --arg ids "$IDS" '{
   702	      functions: ($ids | split(",") | map({key: ., value: {buildId: "<Cloud Build → History → the build id>", buildStatus: "<its status>",
   703	        latestReadyRevision: "<Cloud Run → the service → latest ready revision>", requireAuthentication: "<true|false, Security tab>",
   704	        runInvokerMembers: ["<every run.invoker member, Permissions tab>"]}}) | from_entries),
   705	      projectRoles: (.projectRoles | map_values(["<every holder, IAM → View by roles>"])),
   706	      buildRoleBindings: (.buildRoleBindings | map_values([{member: "<one entry per binding row, IAM → View by roles>",
   707	        condition: "<its condition expression as the Console shows it, or null when the row has none>"}])),
   708	      artifactRegistryWriters: {repository: ["<direct Artifact Registry Writer holders on \(.artifactRegistryWriterOn)>"],
   709	        project: ["<project-level holders of roles/artifactregistry.writer, IAM → View by roles>"]},
   710	      runtimeAccounts: (.runtimeAccounts | map_values(["<its project roles>"])),
   711	      buildAccount: "<Cloud Build → History → the build service account, the email only>" }' "${TMP}/functions/iam-expectations.json"
   712	  say "(Not read, and so not attested: folder- and organization-level grants, and grants on individual Cloud Storage buckets or managed folders.)"
   713	  say "then:  $0 --attest ${TAG:-<attempt>} --codebase ${CB} --evidence <file>"
   714	}
   715	
   716	# ─── --status / --diff ─────────────────────────────────────────────────────────────────────────────────
   717	# Read-only. The newest attempt (by stamp, attempt tags only), and the newest attempt whose deploy_verified is yes.
   718	record_state() {   # sets NEWEST, NEWEST_VERIFIED, NEWEST_ATTESTED, LAST_VERIFIED
   719	  local rows r v
   720	  rows="$(receipt_rows "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB} — refusing to guess what shipped."
   721	  NEWEST="$(printf '%s\n' "$rows" | awk 'NR==1{printf "%s", $3}')"
   722	  NEWEST_VERIFIED=""; NEWEST_ATTESTED=""; LAST_VERIFIED=""
   723	  [ -n "$NEWEST" ] || return 0
   724	  NEWEST_VERIFIED="$(deploy_verified_of "$NEWEST" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${NEWEST} — refusing to guess."
   725	  NEWEST_ATTESTED="$(iam_attested_of "$NEWEST" "$ATTEST_PREFIX")" || die $EX_RECORD "could not read iam_attested for ${NEWEST} — refusing to guess."

exec
/bin/zsh -lc "nl -ba scripts/deploy-functions.sh | sed -n '330,475p'
nl -ba scripts/deploy-functions.sh | sed -n '250,330p'
rg -n \"clear-inflight|reconcile.*attest|attest_needed|grep_fail|next: Christie's\" scripts/deploy-functions.test.sh" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
   330	  "$JQ" -e '.status == "success" and (.result | type == "array") and (.result | all(type == "object" and (.id | type == "string")))' "$2" >/dev/null 2>&1 || return 1
   331	}
   332	list_error() {   # <out> — why functions:list failed: its --json error body (stdout) and stderr, in one line
   333	  { "$JQ" -r '.error // empty' "$1" 2>/dev/null || head -c 300 "$1"; head -c 300 "${1}.err"; } 2>/dev/null | tr '\n' ' ' | head -c 500 > "${1}.why" || true
   334	}
   335	list_why() { cat "${1}.why" 2>/dev/null || echo "malformed JSON"; }
   336	digest_of() { "$JQ" -S -c "$JQ_CANON" "$1" | shasum -a 256 | awk '{print $1}'; }
   337	sha256_of() { shasum -a 256 "$1" | awk '{print $1}'; }
   338	# Write <dest> atomically and durably: a temp file in the same directory, fsync, rename, fsync of the directory (F9).
   339	atomic_write() {   # <dest> < content
   340	  local dest="$1" tmp="$1.tmp.$$"
   341	  cat > "$tmp" || { rm -f "$tmp"; return 1; }
   342	  "$NODE22" -e '
   343	    const fs = require("fs"); const [dest, tmp] = process.argv.slice(1);
   344	    const fd = fs.openSync(tmp, "r+"); fs.fsyncSync(fd); fs.closeSync(fd);
   345	    fs.renameSync(tmp, dest);
   346	    const dd = fs.openSync(require("path").dirname(dest), "r"); fs.fsyncSync(dd); fs.closeSync(dd);' "$dest" "$tmp" || { rm -f "$tmp"; return 1; }
   347	}
   348	# The one in-flight file, read FAIL-CLOSED: every required key exactly once and well-formed, or it is malformed.
   349	INFLIGHT_KEYS="format codebase attempt stamp commit tree manifest_sha256 before_digest functions transcript verifier"
   350	inflight_get() {   # <key> → the value; 1 if missing, repeated or the file unreadable
   351	  local n
   352	  [ -f "$INFLIGHT" ] || return 1
   353	  n="$(awk -v k="$1=" 'index($0, k) == 1 { n++ } END { print n + 0 }' "$INFLIGHT")" || return 1
   354	  [ "$n" = 1 ] || return 1
   355	  awk -v k="$1=" 'index($0, k) == 1 { printf "%s", substr($0, length(k) + 1) }' "$INFLIGHT"
   356	}
   357	inflight_valid() {   # 0 when the in-flight file is complete and well-formed
   358	  local k v id
   359	  for k in $INFLIGHT_KEYS; do v="$(inflight_get "$k")" || return 1; [ -n "$v" ] || return 1; done
   360	  [ "$(inflight_get format)" = "tinker-functions-inflight-1" ] || return 1
   361	  [[ "$(inflight_get commit)" =~ ^[0-9a-f]{40}$ ]] && [[ "$(inflight_get tree)" =~ ^[0-9a-f]{40}$ ]] || return 1
   362	  [[ "$(inflight_get manifest_sha256)" =~ ^[0-9a-f]{64}$ ]] || return 1
   363	  [[ "$(inflight_get stamp)" =~ ^[0-9]{8}T[0-9]{6}Z$ ]] || return 1
   364	  [[ "$(inflight_get before_digest)" =~ ^([0-9a-f]{64}|unknown)$ ]] || return 1
   365	  case "$(inflight_get attempt)" in "${ATTEMPT_PREFIX}$(inflight_get stamp)-"*) ;; *) return 1 ;; esac
   366	  for id in $(inflight_get functions | tr ',' ' '); do
   367	    [[ "$(inflight_get "expected_hash.${id}")" =~ ^[0-9a-f]{40}$ ]] || return 1
   368	    v="$(inflight_get "before_hash.${id}")" || return 1; [ -n "$v" ] || return 1
   369	  done
   370	  if grep -q '^cli_exit=' "$INFLIGHT"; then [[ "$(inflight_get cli_exit)" =~ ^[0-9]+$ ]] || return 1; fi
   371	  return 0
   372	}
   373	
   374	# ─── The shared preamble of every tag-writing mode ─────────────────────────────────────────────────────
   375	TMP=""; WORK=""; HOLD_LOCK=0
   376	cleanup() {
   377	  local code=$?
   378	  if [ -n "$TMP" ] && [ -d "$TMP" ]; then
   379	    rm -f "${TMP}/${SRC}/functions.yaml" 2>/dev/null || true   # the seal is deleted on cleanup, always (D2-2's requirement)
   380	    git worktree remove --force "$TMP" >/dev/null 2>&1 || rm -rf "$TMP"
   381	  fi
   382	  if [ -n "$WORK" ] && [ -d "$WORK" ]; then rm -rf "$WORK" 2>/dev/null || true; fi
   383	  if [ "$HOLD_LOCK" = 1 ]; then rm -rf "$LOCK" 2>/dev/null || true; fi
   384	  exit "$code"
   385	}
   386	preflight() {
   387	  local t v
   388	  for t in git shasum awk sed; do command -v "$t" >/dev/null 2>&1 || die $EX_PREFLIGHT "'${t}' is not on PATH — nothing was run."; done
   389	  [ -x "$CURL" ] || die $EX_PREFLIGHT "${CURL} is missing — nothing was run."
   390	  [ -x "$JQ" ]   || die $EX_PREFLIGHT "${JQ} is missing — nothing was run."
   391	  [ -x "$NODE22" ] || die $EX_PREFLIGHT "Node 22 is not at ${NODE22} (brew install node@22) — nothing was run."
   392	  v="$("$NODE22" --version 2>/dev/null || true)"
   393	  [[ "$v" =~ ^v22\. ]] || die $EX_PREFLIGHT "${NODE22} is '${v:-unreadable}', not Node 22 — nothing was run."
   394	  v="$("$NODE22" "$NPM22_CLI" --version 2>/dev/null || true)"
   395	  [ "$v" = "$NPM22_VERSION" ] || die $EX_PREFLIGHT "Node 22's npm is '${v:-unreadable}', not the pinned ${NPM22_VERSION} (if brew upgraded it, pin the new version in this script, reviewed) — nothing was run."
   396	  [ -f "${REPO}/${CLI_REL}" ] || die $EX_PREFLIGHT "the pinned CLI is missing at ${REPO}/${CLI_REL} (npm ci in ${REPO}) — nothing was run."
   397	  v="$(cd "$REPO" && "$NODE22" "${REPO}/${CLI_REL}" --version 2>/dev/null || true)"
   398	  [ "$v" = "$CLI_VERSION" ] || die $EX_PREFLIGHT "the CLI is '${v:-unreadable}', not the pinned ${CLI_VERSION} — nothing was run."
   399	}
   400	take_lock() {
   401	  mkdir "$LOCK" 2>/dev/null || die $EX_LOCKED "another guarded deploy (or its tests) is in flight — lock ${LOCK} exists ($(cat "$LOCK/owner" 2>/dev/null || echo 'no owner recorded')). A functions deploy holds it for minutes; see FUNCTIONS-ROLLBACK.md §5 before removing it."
   402	  HOLD_LOCK=1
   403	  printf 'pid=%s started=%s by=deploy-functions.sh --%s\n' "$$" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$MODE" > "$LOCK/owner"
   404	  git worktree prune >/dev/null 2>&1 || true
   405	}
   406	fetch_or_die() {
   407	  local err
   408	  if ! err="$(fetch_state)"; then
   409	    case "$err" in
   410	      *clobber*|*"already exists"*) die $EX_UNPUBLISHED "${REMOTE} has a record with the same name as a local one but a DIFFERENT tag object — a corrupted record. Sort it out by hand first: ${err}" ;;
   411	      *) die $EX_FETCH "could not fetch ${REMOTE}/${BRANCH} and the records (${err}) — fix the connection first." ;;
   412	    esac
   413	  fi
   414	  MAIN_SHA="$(git rev-parse --verify "${REMOTE}/${BRANCH}^{commit}")"
   415	}
   416	# The record whose push failed last time is published before anything else, or this run refuses (as deploy-rules.sh).
   417	publish_pending() {
   418	  local pt po local_o ls remote_o
   419	  [ -f "$PENDING" ] || return 0
   420	  read -r pt po < "$PENDING" || die $EX_UNPUBLISHED "${PENDING} is unreadable — sort out the record by hand."
   421	  local_o="$(git rev-parse --quiet --verify "refs/tags/${pt}" 2>/dev/null || true)"
   422	  [ -n "$pt" ] && [ "$local_o" = "$po" ] || die $EX_UNPUBLISHED "the pending record ${pt} no longer matches what was recorded (${po:0:12}) — sort it out by hand, then remove ${PENDING}."
   423	  ls="$(git ls-remote --tags "$REMOTE" "refs/tags/${pt}" 2>&1)" || die $EX_FETCH "could not query ${REMOTE} for the pending record: ${ls}"
   424	  remote_o="$(printf '%s\n' "$ls" | awk -v r="refs/tags/${pt}" '$2 == r {print $1}')"
   425	  if [ -z "$remote_o" ]; then
   426	    say "publishing the record left behind by the previous run: ${pt}"
   427	    git push --quiet "$REMOTE" "refs/tags/${pt}" || die $EX_UNPUBLISHED "the previous run's record ${pt} still could not be pushed. Publish it (git push ${REMOTE} refs/tags/${pt}) before running this again."
   428	  elif [ "$remote_o" != "$po" ]; then
   429	    die $EX_UNPUBLISHED "${REMOTE} already has a DIFFERENT ${pt} (${remote_o:0:12} vs local ${po:0:12}) — sort out the record by hand, then remove ${PENDING}."
   430	  fi
   431	  rm -f "$PENDING"
   432	}
   433	# Every tag-writing mode runs origin/main's own guard (F9: the verifier is the pushed tip, never a dirty or unpushed copy).
   434	verifier_is_tip() {
   435	  local f
   436	  for f in scripts/deploy-functions.sh scripts/lib/receipts.sh; do
   437	    git show "${MAIN_SHA}:${f}" 2>/dev/null | cmp -s - "${REPO}/${f}" \
   438	      || die $EX_VERIFIER "${f} here is not ${REMOTE}/${BRANCH}'s (uncommitted or unpushed changes) — the verifier must be the pushed tip. Commit and push, or discard, then run again."
   439	  done
   440	  cmp -s "${REPO}/scripts/deploy-functions.sh" "$SELF" || die $EX_VERIFIER "this is not ${REPO}/scripts/deploy-functions.sh — run the repo's own guard."
   441	}
   442	codebase_on_tip() {
   443	  local n
   444	  n="$(git show "${MAIN_SHA}:firebase.json" 2>/dev/null | "$JQ" --arg cb "$CB" '[(.functions // [])[] | select(.codebase == $cb)] | length' 2>/dev/null || echo 0)"
   445	  [ "$n" = 1 ] || die $EX_USAGE "'${CB}' is not a codebase in ${REMOTE}/${BRANCH}'s firebase.json (a function id is not a codebase) — nothing was run."
   446	}
   447	# A fresh, private worktree for every run, retries included (D2-2's requirement): nothing else can write into it
   448	# between the backstop's checks and the CLI's packaging, and no seal from an earlier run can be in it.
   449	make_worktree() {   # <sha> — inside this run's private WORK folder (made in the preamble, mode 700)
   450	  mkdir "${WORK}/manifest" "${WORK}/home" "${WORK}/tmp"
   451	  TMP="${WORK}/tree"
   452	  git worktree add --quiet --detach "$TMP" "$1" || die $EX_CONFIG "could not check out ${1:0:12} into a worktree."
   453	  [ -d "${REPO}/node_modules" ] || die $EX_PREFLIGHT "${REPO}/node_modules is missing (npm ci in ${REPO}) — the pinned CLI lives there."
   454	  ln -s "${REPO}/node_modules" "${TMP}/node_modules"
   455	  [ -d "${TMP}/${SRC}" ] || die $EX_CONFIG "${1:0:12} has no ${SRC}."
   456	}
   457	install_codebase() {
   458	  say "─── npm ci --prefix ${SRC} (Node 22) ───"
   459	  npm22 ci --prefix "${TMP}/${SRC}" || die $EX_INSTALL "npm ci failed for ${SRC} — nothing was deployed."
   460	  [ -e "${TMP}/${SRC}/node_modules/.bin/firebase-functions" ] || die $EX_INSTALL "${SRC}/node_modules/.bin/firebase-functions is missing after npm ci — the CLI would use an SDK from elsewhere; nothing was deployed."
   461	}
   462	folder_check() {   # <sha> <when> — F3, through the backstop's own check-only target
   463	  local out
   464	  out="$(cd "$TMP" && GCLOUD_PROJECT="$PROJECT" TINKER_DEPLOY_SHA="$1" TINKER_DEPLOY_CODEBASE="$CB" RESOURCE_DIR="${TMP}/${SRC}" \
   465	         bash scripts/predeploy-check.sh functions-folder 2>&1)" || die $EX_FOLDER "the folder check (${2}) refused: ${out}"
   466	  say "${out}"
   467	}
   468	discover() {   # runs discovery once, with a scratch HOME and a minimal env (F5); sets DISC, MPATH, MSHA
   469	  DISC="${WORK}/discovery.json"
   470	  if ! env -i HOME="${WORK}/home" TMPDIR="${WORK}/tmp" LANG=C PATH="$(dirname "$NODE22"):/usr/bin:/bin" \
   471	       "$NODE22" "${TMP}/scripts/functions-discover.mjs" --project "$PROJECT" --codebase "$CB" --source "${TMP}/${SRC}" \
   472	       --out "${WORK}/manifest" --firebase-config "${TMP}/functions/firebase-config.json" > "$DISC" 2> "${WORK}/discovery.err"; then
   473	    die $EX_DISCOVERY "discovery failed — nothing was deployed: $(cat "${WORK}/discovery.err")"
   474	  fi
   475	  "$JQ" -e '(.manifestSha256 | type == "string" and test("^[0-9a-f]{64}$")) and (.manifestPath | type == "string")
   250	JQ_EVIDENCE_OP='
   251	  def uuid: type == "string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
   252	  def rev($id): type == "string" and test("^" + ($id | ascii_downcase) + "-[0-9]{5}-[a-z0-9]{3}$");
   253	  (type == "object") and (keys == ["confirmation","functions"])
   254	  and (.confirmation | type == "string" and (gsub("\\s"; "") | length) > 0)
   255	  and (.functions | type == "object") and ((.functions | keys) == $ids)
   256	  and (.functions | to_entries | all(
   257	        .key as $id | .value as $v
   258	        | ($v | type == "object") and (($v | keys) == ["buildId","buildStatus","latestReadyRevision"])
   259	          and ($v.buildId | uuid)
   260	          and (if $mode == "reconcile"
   261	               then ($v.buildStatus | IN("SUCCESS","FAILURE","INTERNAL_ERROR","TIMEOUT","CANCELLED","EXPIRED")) and ($v.latestReadyRevision | rev($id))
   262	               else ($v.buildStatus | IN("SUCCESS","FAILURE","INTERNAL_ERROR","TIMEOUT","CANCELLED","EXPIRED","QUEUED","PENDING","WORKING","STATUS_UNKNOWN"))
   263	                    and (($v.latestReadyRevision == null) or ($v.latestReadyRevision | rev($id))) end)))'
   264	
   265	# --attest (F9, M3): the shape, strictly (a malformed reading refuses) …
   266	JQ_ATTEST_SHAPE='
   267	  def strs: type == "array" and all(type == "string");
   268	  (type == "object") and (keys == ["artifactRegistryWriters","buildAccount","buildRoleBindings","functions","projectRoles","runtimeAccounts"])
   269	  and (.buildAccount | type == "string")
   270	  and (.artifactRegistryWriters | type == "object") and ((.artifactRegistryWriters | keys) == ["project","repository"])
   271	  and (.artifactRegistryWriters.project | strs) and (.artifactRegistryWriters.repository | strs)
   272	  and (.buildRoleBindings | type == "object") and (.buildRoleBindings | to_entries | all(.value | type == "array"
   273	        and all(type == "object" and (keys == ["condition","member"]) and (.member | type == "string")
   274	                and (.condition == null or (.condition | type == "string")))))
   275	  and (.functions | type == "object") and (.functions | to_entries | all(.value | type == "object"
   276	        and (keys == ["buildId","buildStatus","latestReadyRevision","requireAuthentication","runInvokerMembers"])
   277	        and (.requireAuthentication | type == "boolean") and (.runInvokerMembers | strs)))
   278	  and (.projectRoles | type == "object") and (.projectRoles | to_entries | all(.value | strs))
   279	  and (.runtimeAccounts | type == "object") and (.runtimeAccounts | to_entries | all(.value | strs))'
   280	# … then the content, against the declarations and functions/iam-expectations.json: every difference is a reason, and
   281	# any reason means iam_attested=no (recorded, not refused).
   282	JQ_ATTEST='
   283	  def set: map(ascii_downcase) | unique;
   284	  def member: if test("^[a-zA-Z]+:") then . elif test("\\.gserviceaccount\\.com$") then "serviceAccount:" + . else "user:" + . end;
   285	  def rev($id): type == "string" and test("^" + ($id | ascii_downcase) + "-[0-9]{5}-[a-z0-9]{3}$");
   286	  . as $ev
   287	  | ( ($ids - ($ev.functions | keys))[] | "function \(.): missing from the reading" ),
   288	    ( (($ev.functions | keys) - $ids)[] | "function \(.): in the reading but not in this attempt" ),
   289	    ( $ids[] as $id | ($ev.functions[$id] // null) as $f | select($f != null)
   290	      | ( if $f.requireAuthentication != true then "\($id): Require authentication is OFF" else empty end ),
   291	        ( ($dc[$id].invoker | if . == ["private"] then [] else map(member) end | set) as $want
   292	          | ($f.runInvokerMembers | set) as $have
   293	          | if $have != $want then "\($id): run.invoker members \($have | tostring), expected \($want | tostring)" else empty end ),
   294	        ( if $f.buildStatus != "SUCCESS" then "\($id): build \($f.buildStatus | tostring), not SUCCESS" else empty end ),
   295	        ( if ($f.latestReadyRevision | rev($id)) | not then "\($id): no latest ready revision" else empty end ),
   296	        ( if ($f.buildId | type) != "string" or ($f.buildId | test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$") | not) then "\($id): build id is not a Cloud Build id" else empty end ) ),
   297	    ( if ($ev.projectRoles | keys) != ($iam.projectRoles | keys) then "project roles read \($ev.projectRoles | keys | tostring), expected \($iam.projectRoles | keys | tostring)" else empty end ),
   298	    ( def cond: if . == null then null else gsub("\\s"; "") end;
   299	      ("serviceAccount:" + $ev.buildAccount) as $b
   300	      | ( if ($ev.buildRoleBindings | keys) != ($iam.buildRoleBindings | keys) then "build role bindings read for \($ev.buildRoleBindings | keys | tostring), expected \($iam.buildRoleBindings | keys | tostring)" else empty end ),
   301	        ( $iam.buildRoleBindings | to_entries[] | .key as $r | .value as $c | ($ev.buildRoleBindings[$r] // null) as $got | select($got != null)
   302	          | if ($got | length) != 1 then "\($r): \($got | length) project-level bindings, expected exactly one (to the build account; an extra unconditional binding would override a conditioned one) (F7)"
   303	            elif ($got[0].member | ascii_downcase) != ($b | ascii_downcase) then "\($r): bound to \($got[0].member), expected only the build account \($b) (F7)"
   304	            elif ($got[0].condition | cond) != ($c | cond) then "\($r): its condition is not \(if $c == null then "none" else "Appendix A5" end) (F7)"
   305	            else empty end ),
   306	        ( if ($ev.artifactRegistryWriters.repository | set) != ([$b] | set) then "Artifact Registry Writer on \($iam.artifactRegistryWriterOn): direct holders \($ev.artifactRegistryWriters.repository | set | tostring), expected only the build account \($b) (F7)" else empty end ),
   307	        ( if ($ev.artifactRegistryWriters.project | length) > 0 then "Artifact Registry Writer granted at PROJECT level to \($ev.artifactRegistryWriters.project | set | tostring) — it applies to every repository; expected none (F7)" else empty end ) ),
   308	    ( $iam.projectRoles | keys[] as $r | select($ev.projectRoles[$r] != null)
   309	      | if ($ev.projectRoles[$r] | set) != ($iam.projectRoles[$r] | set) then "\($r): holders \($ev.projectRoles[$r] | set | tostring), expected \($iam.projectRoles[$r] | set | tostring)" else empty end ),
   310	    ( ([$dc[] | .serviceAccount] | unique) - ($iam.runtimeAccounts | keys) | .[]
   311	      | "runtime account \(.) is declared but not in functions/iam-expectations.json, so its roles were never read" ),
   312	    ( if ($ev.runtimeAccounts | keys) != ($iam.runtimeAccounts | keys) then "runtime accounts read \($ev.runtimeAccounts | keys | tostring), expected \($iam.runtimeAccounts | keys | tostring)" else empty end ),
   313	    ( $iam.runtimeAccounts | keys[] as $a | select($ev.runtimeAccounts[$a] != null)
   314	      | if ($ev.runtimeAccounts[$a] | set) != ($iam.runtimeAccounts[$a] | set) then "\($a): roles \($ev.runtimeAccounts[$a] | set | tostring), expected \($iam.runtimeAccounts[$a] | set | tostring)" else empty end ),
   315	    ( if (("serviceAccount:" + $ev.buildAccount) | IN($iam.buildCandidates[])) | not
   316	      then "build account \($ev.buildAccount) is neither build candidate (F7)" else empty end )'
   317	
   318	# ─── Helpers ───────────────────────────────────────────────────────────────────────────────────────────
   319	node22_path() { printf '%s' "$(dirname "$NODE22"):${PATH}"; }
   320	npm22() { PATH="$(node22_path)" "$NODE22" "$NPM22_CLI" "$@"; }
   321	# The pinned CLI, with the variables that would change its identity or discovery removed (F5).
   322	cli() {   # <dir> <args…>
   323	  local dir="$1"; shift
   324	  (cd "$dir" && exec env -u GOOGLE_APPLICATION_CREDENTIALS -u GOOGLE_CLOUD_QUOTA_PROJECT -u FUNCTIONS_DISCOVERY_TIMEOUT \
   325	      -u FIREBASE_FUNCTIONS_DISCOVERY_OUTPUT_PATH PATH="$(node22_path)" "$NODE22" "${REPO}/${CLI_REL}" "$@")
   326	}
   327	# functions:list → <out>. Returns 1 for a list error or JSON that isn't the expected shape (F8: "unknown").
   328	list_live() {   # <dir> <out>
   329	  cli "$1" functions:list --json --project "$PROJECT" > "$2" 2> "$2.err" || { list_error "$2"; return 1; }
   330	  "$JQ" -e '.status == "success" and (.result | type == "array") and (.result | all(type == "object" and (.id | type == "string")))' "$2" >/dev/null 2>&1 || return 1
157:# Real grep, except that with \$SC/grep_fail present a search for the CLI's "Enabling now" line fails like an unreadable file.
158:if [ -f "$SC/grep_fail" ]; then for a in "\$@"; do [ "\$a" = "Enabling now" ] && exit 2; done; fi
556:# ═══ interruption, --reconcile, --clear-inflight ═══════════════════════════════════════════════════════
605:assert_eq "…and a reconciled FIRST deploy still needs Christie's IAM reading" "$(field "$ATT" attest_needed)" "yes"
607:# --clear-inflight
612:run --clear-inflight "${NS}/20990101T000000Z-${SHA1:0:7}" --codebase core --evidence "$T/ev.json"
613:assert_eq "--clear-inflight naming another attempt → exit 22" "$CODE" "22"
614:run --clear-inflight "$ATT" --codebase core --evidence "$T/ev.json"
615:assert_eq "--clear-inflight with Christie's evidence → exit 0" "$CODE" "0"
619:assert_eq "…attest_needed=yes (not verified)" "$(field "$ATT" attest_needed)" "yes"
629:run --clear-inflight x --codebase core --evidence "$T/ev.json"; assert_eq "…--clear-inflight too" "$CODE" "22"
737:assert_eq "a first deploy → attest_needed=yes" "$(field "$RA" attest_needed)" "yes"
738:assert_has "…because nothing is attested yet" "$(field "$RA" attest_needed_why)" "no attempt of core has iam_attested=yes yet"
739:assert_has "…and it prints the reading to take" "$OUT" "IAM reading NEEDED"; assert_has "…with the JSON shape" "$OUT" "next: Christie's IAM reading"
744:assert_eq "…attest_needed=no" "$(field "$RB" attest_needed)" "no"
745:assert_has "…naming the attested attempt it relies on" "$(field "$RB" attest_needed_why)" "last attested ${RA}"
746:assert_has "…and it says so" "$OUT" "IAM reading not needed"; assert_lacks "…without the reading's JSON shape" "$OUT" "next: Christie's IAM reading"
749:assert_eq "the CLI enabled a Google API during the deploy → attest_needed=yes" "$(field "$RC" attest_needed)" "yes"
750:assert_has "…naming it" "$(field "$RC" attest_needed_why)" "the CLI enabled a Google API"
751:assert_has "…and it prints the reading to take" "$OUT" "next: Christie's IAM reading"
754:assert_eq "a reading owed by the API deploy was never taken → the next source-only deploy still needs it" "$(field "$RD" attest_needed)" "yes"
755:assert_has "…naming the attempt that owes it" "$(field "$RD" attest_needed_why)" "${RC} needed a reading, or its reading came back no"
759:assert_eq "…the next source-only deploy → no" "$(field "$RG" attest_needed)" "no"
760:assert_has "…relying on that attestation" "$(field "$RG" attest_needed_why)" "last attested ${RD}"
763:assert_eq "functions/iam-expectations.json changed since the attested attempt → attest_needed=yes" "$(field "$RE" attest_needed)" "yes"
764:assert_has "…naming the file" "$(field "$RE" attest_needed_why)" "changed since ${RD}: functions/iam-expectations.json"
765:# an attempt from before this rule (no attest_needed field) between the attested one and now: the reading is owed
767:git for-each-ref --format='%(contents)' "refs/tags/$RG" | grep -v '^attest_needed' > "$T/old.msg"
771:assert_eq "an unattested attempt from before this rule in between → attest_needed=yes (fail-closed)" "$(field "$RH" attest_needed)" "yes"
772:assert_has "…naming it" "$(field "$RH" attest_needed_why)" "${RG} needed a reading, or its reading came back no"
775:assert_eq "an unverified deploy → attest_needed=yes" "$(field "$RF" attest_needed)" "yes"
776:assert_has "…saying so" "$(field "$RF" attest_needed_why)" "the deploy is not verified"
777:run --status --codebase core; assert_has "--status shows attest_needed and why" "$OUT" "attest_needed=yes — the deploy is not verified"
783:assert_eq "…(a source-only deploy after an attested one needs none)" "$(field "$RB" attest_needed)" "no"
787:assert_eq "a known iam_attested=no since the last yes → the next deploy needs a reading" "$(field "$RC" attest_needed)" "yes"
788:assert_has "…naming the attempt" "$(field "$RC" attest_needed_why)" "${RB} needed a reading, or its reading came back no"
790:: > "$SC/grep_fail"; SC3="$(commit_change functions/core/index.js "exports.b3 = 3;")"; run --approved "$SC3" --codebase core; RD="$(newest_tag)"; rm -f "$SC/grep_fail"
791:assert_eq "an unreadable transcript → attest_needed=yes" "$(field "$RD" attest_needed)" "yes"
792:assert_has "…saying so" "$(field "$RD" attest_needed_why)" "could not read the transcript"

codex
ready after fixes

No blocking findings. All four prior findings are fixed:

- `grep` errors now fail closed.
- Any later `iam_attested=no` remains owed.
- `--reconcile` and `--clear-inflight` record and report `attest_needed`.
- `--status` displays `attest_needed` and its reason.

Should-fix:

- [scripts/deploy-functions.sh:727](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:727) — `--clear-inflight` generates guidance from `MAIN_SHA`, but later `--attest` compares against the attempt’s expectations at line 1041. After an acknowledged verifier/expectations change, following the printed “exact” shape can produce a guaranteed `iam_attested=no`. Use the attempt’s `$SHA` here.
- [scripts/deploy-functions.sh:727](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:727) — failure inside the process substitution is invisible to `jq`; empty input can make `jq` exit successfully while printing no JSON shape. Materialize/validate the expectations input before calling `attest_help`.

Test gap:

- [scripts/deploy-functions.test.sh:605](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:605) and [scripts/deploy-functions.test.sh:619](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:619) verify recovery fields and the “NEEDED” heading, but not the JSON guidance or changed-verifier source selection.
- The fake-`grep` test is valid: it intercepts the exact `Enabling now` search, returns 2, and verifies the fail-closed reason.

`FUNCTIONS-ROLLBACK.md` §7 is accurate. `bash -n` passes.
tokens used
61,088
ready after fixes

No blocking findings. All four prior findings are fixed:

- `grep` errors now fail closed.
- Any later `iam_attested=no` remains owed.
- `--reconcile` and `--clear-inflight` record and report `attest_needed`.
- `--status` displays `attest_needed` and its reason.

Should-fix:

- [scripts/deploy-functions.sh:727](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:727) — `--clear-inflight` generates guidance from `MAIN_SHA`, but later `--attest` compares against the attempt’s expectations at line 1041. After an acknowledged verifier/expectations change, following the printed “exact” shape can produce a guaranteed `iam_attested=no`. Use the attempt’s `$SHA` here.
- [scripts/deploy-functions.sh:727](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:727) — failure inside the process substitution is invisible to `jq`; empty input can make `jq` exit successfully while printing no JSON shape. Materialize/validate the expectations input before calling `attest_help`.

Test gap:

- [scripts/deploy-functions.test.sh:605](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:605) and [scripts/deploy-functions.test.sh:619](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:619) verify recovery fields and the “NEEDED” heading, but not the JSON guidance or changed-verifier source selection.
- The fake-`grep` test is valid: it intercepts the exact `Enabling now` search, returns 2, and verifies the fail-closed reason.

`FUNCTIONS-ROLLBACK.md` §7 is accurate. `bash -n` passes.
