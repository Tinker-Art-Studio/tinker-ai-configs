OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/my-clay-hub
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f592-1a8e-7131-9f4a-8a8dd0ffe701
--------
user
# Implementation review: my-clay-hub branch fix/firebase-config-pin (HEAD commit)

You are an independent reviewer. Read-only: do not edit, commit, run any Firebase CLI command, or contact any network service. Repo: /Users/christiehubley/my-clay-hub. Run `git show HEAD`, read files, and read the pinned CLI source under node_modules/firebase-tools/lib. You may run single unit test files (`/opt/homebrew/opt/node@22/bin/node --test tests/unit/functions-hash.test.js`). Do not run `npm test` (run separately).

## Background
- `scripts/deploy-functions.sh` (the functions guard) deployed the canary to production on attempt `deployed/my-clay-hub/functions-core/20261001T034143Z-604844c`. CLI exit 0, backstop seen, skip line not seen, unauthenticated probe refused (http-403 Google_Frontend). But `deploy_match: no`:
  - `canary: FIREBASE_CONFIG differs from functions/firebase-config.json`
  - `canary: live hash 5dc5ef9345d6bdc235abf23407c4815ce8405a3a, expected ef4fe1770b1e6f0c37909f03c34fbd02ee738d10`
  - live FIREBASE_CONFIG: `{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app"}`
  - old pin: `{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app","locationId":"nam5"}`
- FUNCTIONS-ROLLBACK.md §8 says: commit the live value (same key order), get it reviewed, run the guard again under a new approval. `--reverify` can't fix it (it rebuilds from the attempt's commit, pin included).
- With the new pin, running the guard's own discovery locally (`scripts/functions-discover.mjs … --firebase-config functions/firebase-config.json`) gives expectedHashes.canary = `5dc5ef9345d6bdc235abf23407c4815ce8405a3a`, equal to the live hash.

## The change
- functions/firebase-config.json → the live value, byte for byte (plus trailing newline, as before).
- tests/unit/functions-hash.test.js: new test pinning that exact file content.
- FUNCTIONS-ROLLBACK.md: status block and §8 updated.

## What I want reviewed
1. Is the new pin exactly what the CLI puts in FIREBASE_CONFIG for this project (read `functions/env.js` loadFirebaseEnvs and how the adminSdkConfig is fetched in the pinned 15.22.3), including key order? Is there any chance the CLI's value differs between runs (e.g. locationId appearing once a default resource location is set, or depending on the logged-in account)?
2. The second deploy: the live function's hash already equals the new expected hash. The guard deploys with `--only functions:core`. Confirm from `deploy/functions/prepare.js` (`updateEndpointTargetedStatus`, `functionsDeployHelper.endpointMatchesFilter`) and `release/planner.js` (`toSkipPredicate`) that a codebase filter sets `targetedByOnly = true`, so the CLI will NOT print "Skipping the deploy of unchanged functions" and will update the function. If it would skip, the guard would record skip_line_seen=yes → deploy_verified=no forever; say so.
3. Does `shouldUploadBeSkipped` in deploy/functions/deploy.js interact with this (filters present → false)?
4. Anything in the guard's flow (scripts/deploy-functions.sh: read-back, expected hash, before/after digest, functions_unchanged) that would mis-handle a second deploy whose hash equals the live one before the deploy (e.g. an "unchanged" check that treats an identical before/after digest as a failure)?
5. Is the new test sound? Are the doc edits accurate?

## Output
Verdict first: "ready", "ready after fixes", or "not ready". Then blocking / should-fix / nit, each with file:line and a concrete failure scenario. Keep it short.

codex
I’ll review the HEAD diff, the guard and pinned Firebase CLI paths you named, then run only the permitted unit test. I’ll keep everything read-only and offline.
exec
/bin/zsh -lc "git show --stat --oneline HEAD && git show --format=fuller --no-ext-diff HEAD && rg -n \"loadFirebaseEnvs|adminSdkConfig|targetedByOnly|updateEndpointTargetedStatus|endpointMatchesFilter|toSkipPredicate|shouldUploadBeSkipped|skip_line_seen|deploy_verified|functions_unchanged|expected hash|expectedHashes|before.*digest|after.*digest\" scripts functions tests FUNCTIONS-ROLLBACK.md node_modules/firebase-tools/lib/deploy/functions node_modules/firebase-tools/lib/deploy node_modules/firebase-tools/lib -g '*.js' -g '*.mjs' -g '*.sh' -g '*.md' -g '*.json'" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ryyAxftz' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-4mabnoW0' (errno=Operation not permitted)
3ece046 D2-5: pin FIREBASE_CONFIG to the live value (no locationId)
 FUNCTIONS-ROLLBACK.md             | 8 ++++++--
 functions/firebase-config.json    | 2 +-
 tests/unit/functions-hash.test.js | 7 +++++++
 3 files changed, 14 insertions(+), 3 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-JrNCdyLQ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ttM1k9fC' (errno=Operation not permitted)
commit 3ece04635586e48e68805e04a85dfd5c4ff84b48
Author:     Christie Hubley <christie@tinkerartstudio.com>
AuthorDate: Wed Sep 30 21:46:20 2026 -0600
Commit:     Christie Hubley <christie@tinkerartstudio.com>
CommitDate: Wed Sep 30 21:46:20 2026 -0600

    D2-5: pin FIREBASE_CONFIG to the live value (no locationId)
    
    The first guarded deploy (attempt 20261001T034143Z-604844c) created the canary,
    private (probe refused), but recorded deploy_verified=no: the live
    FIREBASE_CONFIG has no locationId, so the guessed "nam5" made the expected
    hash differ. With the live value pinned, the guard's discovery computes
    5dc5ef9345d6bdc235abf23407c4815ce8405a3a, the live canary's hash.
    
    - functions/firebase-config.json: the live value, byte for byte
    - a unit test pins that exact content
    - FUNCTIONS-ROLLBACK.md: status and §8 updated
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/FUNCTIONS-ROLLBACK.md b/FUNCTIONS-ROLLBACK.md
index 8cdd6ea..9c4b9bc 100644
--- a/FUNCTIONS-ROLLBACK.md
+++ b/FUNCTIONS-ROLLBACK.md
@@ -6,7 +6,9 @@ permanent canary). Rules have their own runbook: `RULES-ROLLBACK.md`. Plan and d
 
 > **Status (D2-3):** the guard, `scripts/deploy-functions.sh`, and its suite (`npm run test:functions-guard`) exist,
 > with the backstop, the canary, `functions/declarations.json`, `functions/iam-expectations.json` and the pinned
-> `functions/firebase-config.json`. Nothing here has been run against production yet (the first deploy is D2-5).
+> `functions/firebase-config.json`. **D2-5 (Sep 30):** the first guarded deploy created the canary (attempt
+> `deployed/my-clay-hub/functions-core/20261001T034143Z-604844c`, private: the unauthenticated probe was refused) but
+> recorded `deploy_verified=no`, because the pinned `locationId` was wrong (§8); the corrected pin needs a second deploy.
 
 **Never** run a raw `firebase … deploy`, `functions:delete`, or any function-changing CLI command by hand. A hook denies
 them, and the backstop refuses a deploy that didn't come through the guard. Every step below goes through
@@ -135,6 +137,8 @@ no roles and must keep none (`functions/iam-expectations.json`). Don't delete it
 
 `functions/firebase-config.json` is the body the CLI puts in `FIREBASE_CONFIG` (Firebase's admin-SDK config: project
 id, bucket, location — not a secret). It's pinned rather than fetched, so no script uses the Firebase login (Christie,
-Sep 30), and the expected hash covers it, key order included. Its `locationId` is unconfirmed until the first deploy.
+Sep 30), and the expected hash covers it, key order included. The first deploy (D2-5) showed that the live value has
+**no** `locationId` (the guessed `"nam5"` was wrong), so the pin is just `projectId` and `storageBucket`. With it, the
+expected hash equals the live canary's (`5dc5ef93…`).
 If a run reports `FIREBASE_CONFIG differs`, the guard prints the live value: commit it (same key order) in that file,
 get it reviewed, and run the guard again under a new approval.
diff --git a/functions/firebase-config.json b/functions/firebase-config.json
index e4e361c..c3468fc 100644
--- a/functions/firebase-config.json
+++ b/functions/firebase-config.json
@@ -1 +1 @@
-{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app","locationId":"nam5"}
+{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app"}
diff --git a/tests/unit/functions-hash.test.js b/tests/unit/functions-hash.test.js
index d81d177..0cfc7d5 100644
--- a/tests/unit/functions-hash.test.js
+++ b/tests/unit/functions-hash.test.js
@@ -91,3 +91,10 @@ test('the pinned FIREBASE_CONFIG file is this project, in the adminSdkConfig sha
     assert.equal(typeof v, 'string');
   }
 });
+
+test('the pin is the live FIREBASE_CONFIG the first deploy read back (D2-5), byte for byte', () => {
+  // The guessed "locationId":"nam5" was wrong: the live value has no locationId. Change this only from a guard
+  // read-back that prints a different live value (FUNCTIONS-ROLLBACK.md §8).
+  assert.equal(readFileSync(join(ROOT, 'functions/firebase-config.json'), 'utf8'),
+    '{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app"}\n');
+});
FUNCTIONS-ROLLBACK.md:11:> recorded `deploy_verified=no`, because the pinned `locationId` was wrong (§8); the corrected pin needs a second deploy.
FUNCTIONS-ROLLBACK.md:59:  the attempt's commit (worktree, Node 22, `npm ci`, discovery) and refuses unless the manifest, tree and expected hash
FUNCTIONS-ROLLBACK.md:66:  `latestReadyRevision` may be `null`. It writes the attempt's tag with `deploy_match=unknown`, `deploy_verified=no`,
FUNCTIONS-ROLLBACK.md:140:Sep 30), and the expected hash covers it, key order included. The first deploy (D2-5) showed that the live value has
FUNCTIONS-ROLLBACK.md:142:expected hash equals the live canary's (`5dc5ef93…`).
scripts/lib/functions-hash.mjs:10://   - the backend env: userEnvs (none: F4 forbids .env*) then loadFirebaseEnvs() → { FIREBASE_CONFIG, GCLOUD_PROJECT };
scripts/lib/functions-hash.mjs:24:export async function expectedHashes({ root, sourceDir, codebase, entry, project, firebaseConfig, build }) {
scripts/lib/functions-hash.mjs:35:  backend.environmentVariables = { ...functionsEnv.loadFirebaseEnvs(firebaseConfig, project) };
scripts/lib/receipts.sh:12:#   FAIL-CLOSED — anything that orders the record or decides deploy_verified / iam_attested. A read that fails, or a
scripts/lib/receipts.sh:161:deploy_verified_of() {  # FAIL-CLOSED. <attempt_id> <verify prefix> → yes|no: the newest verify record's, else the attempt's own
scripts/lib/receipts.sh:165:  if [ -n "$newest" ]; then record_word "$newest" deploy_verified "yes no"; else record_word "$1" deploy_verified "yes no"; fi
tests/functions/manifest.test.js:75:  assert.deepEqual(Object.keys(r.expectedHashes), ['canary']);
tests/functions/manifest.test.js:76:  assert.match(r.expectedHashes.canary, /^[0-9a-f]{40}$/);
tests/functions/manifest.test.js:77:  assert.equal(discover().expectedHashes.canary, r.expectedHashes.canary, 'deterministic');
scripts/functions-discover.mjs:11://   - passes the same Firebase env the CLI builds: FIREBASE_CONFIG and GCLOUD_PROJECT (loadFirebaseEnvs), plus
scripts/functions-discover.mjs:14://     sourceHash, expectedHashes } — manifest is the YAML as parsed by the CLI's own yaml module, build is the CLI's own
scripts/functions-discover.mjs:15://     yamlToBuild() of it, firebaseConfigEnv the exact FIREBASE_CONFIG string the CLI will set, and expectedHashes the
scripts/functions-discover.mjs:34:import { expectedHashes } from './lib/functions-hash.mjs';
scripts/functions-discover.mjs:94:// The adminSdkConfig body: these keys only, each a string. Its key ORDER is part of the pin (FIREBASE_CONFIG is
scripts/functions-discover.mjs:131:  const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, args.project);
scripts/functions-discover.mjs:145:  hashes = await expectedHashes({ root: ROOT, sourceDir, codebase: args.codebase, entry, project: args.project, firebaseConfig,
scripts/functions-discover.mjs:148:  refuse(`could not compute the expected hash: ${e.message}`);
scripts/functions-discover.mjs:156:  firebaseConfigEnv: functionsEnv.loadFirebaseEnvs(firebaseConfig, args.project).FIREBASE_CONFIG,
scripts/functions-discover.mjs:158:  expectedHashes: hashes.hashes,
scripts/deploy-functions.test.sh:2:# Tests for scripts/deploy-functions.sh (D2-3) — every refusal and every deploy_verified=no path is a test.
scripts/deploy-functions.test.sh:89:    firebaseConfigEnv: \$cfg, sourceHash: "x", expectedHashes: (.endpoints | map_values(\$h)) }' "\$SC/manifest.json"
scripts/deploy-functions.test.sh:291:assert_eq "…deploy_verified=yes" "$(field "$R" deploy_verified)" "yes"
scripts/deploy-functions.test.sh:294:assert_eq "…skip_line_seen=no" "$(field "$R" skip_line_seen)" "no"
scripts/deploy-functions.test.sh:299:assert_eq "…the expected hash equals the live hash" "$(field "$R" expected_hash.canary)" "$(field "$R" live_hash.canary)"
scripts/deploy-functions.test.sh:301:assert_eq "…functions_unchanged=no (the canary was created)" "$(field "$R" functions_unchanged)" "no"
scripts/deploy-functions.test.sh:347:assert_eq "…with the same expected hash as the first" "$(field "$R2" expected_hash.canary)" "$(field "$R" expected_hash.canary)"
scripts/deploy-functions.test.sh:349:assert_eq "…functions_unchanged=yes (same bytes, same hash)" "$(field "$R2" functions_unchanged)" "yes"
scripts/deploy-functions.test.sh:367:assert_eq "…deploy_verified=yes" "$(field "$(newest_tag)" deploy_verified)" "yes"
scripts/deploy-functions.test.sh:368:assert_lacks "…and its expected hash differs from the first" "$(field "$(newest_tag)" expected_hash.canary)" "$H1"
scripts/deploy-functions.test.sh:372:assert_eq "…with the same expected hash as the commit before it" "$(field "$(newest_tag)" expected_hash.canary)" "$(field "$(git tag -l "${NS}/*" | LC_ALL=C sort | sed -n 2p)" expected_hash.canary)"
scripts/deploy-functions.test.sh:376:assert_eq "…the expected hash is unchanged (it covers bytes only)" "$(field "$(newest_tag)" expected_hash.canary)" "$(field "$(git tag -l "${NS}/*" | LC_ALL=C sort | sed -n 3p)" expected_hash.canary)"
scripts/deploy-functions.test.sh:402:assert_eq "…and the same expected hash" "$(field "$RA" expected_hash.canary)" "$(field "$RB" expected_hash.canary)"
scripts/deploy-functions.test.sh:483:# ═══ every deploy_verified=no path (exit 21, the record says why) ══════════════════════════════════════
scripts/deploy-functions.test.sh:487:  assert_eq "…deploy_verified=no" "$(field "$r" deploy_verified)" "no"
scripts/deploy-functions.test.sh:494:fixture_reset; : > "$SC/skip_line"; run --approved "$SHA1" --codebase core; unverified "the 'Skipping unchanged' line (M5)" skip_line_seen yes
scripts/deploy-functions.test.sh:519:assert_eq "…functions_unchanged=unknown" "$(field "$(newest_tag)" functions_unchanged)" "unknown"
scripts/deploy-functions.test.sh:534:assert_eq "…each recorded: cli_exit, skip line, match, access" "$(field "$R" cli_exit) $(field "$R" skip_line_seen) $(field "$R" deploy_match) $(field "$R" access)" "2 yes no inconclusive"
scripts/deploy-functions.test.sh:542:assert_eq "a reordered but equivalent snapshot has the same digest" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
scripts/deploy-functions.test.sh:543:assert_eq "…so functions_unchanged=yes" "$(field "$R" functions_unchanged)" "yes"
scripts/deploy-functions.test.sh:546:assert_lacks "…and a real change (a label) changes it" "$(field "$R" after_digest)" "$(field "$R" before_digest)"
scripts/deploy-functions.test.sh:596:assert_eq "…deploy_verified=yes" "$(field "$ATT" deploy_verified)" "yes"
scripts/deploy-functions.test.sh:608:assert_eq "…deploy_verified=no" "$(field "$ATT" deploy_verified)" "no"
scripts/deploy-functions.test.sh:626:assert_eq "attempt A unverified, attempt B verified" "$(field "$RA" deploy_verified) $(field "$RB" deploy_verified)" "no yes"
scripts/deploy-functions.test.sh:635:assert_eq "attempt C: unverified only by its probe" "$(field "$RC" deploy_match) $(field "$RC" access) $(field "$RC" deploy_verified)" "yes inconclusive no"
scripts/deploy-functions.test.sh:642:assert_eq "…deploy_verified=yes" "$(field "$RV" deploy_verified)" "yes"
scripts/deploy-functions.test.sh:643:assert_eq "…C's own record is unchanged" "$(field "$RC" deploy_verified)" "no"
scripts/deploy-functions.test.sh:649:assert_eq "…its verify record says no" "$(field "$(newest_tag "${NS}-verify")" deploy_verified)" "no"
scripts/deploy-functions.test.sh:655:deploy_verified=no"
scripts/deploy-functions.test.sh:778:deploy_verified=yes"
scripts/deploy-functions.sh:21:# annotated tag deployed/my-clay-hub/functions-<cb>/<stamp>-<sha7>. It exits 0 only when deploy_verified=yes.
scripts/deploy-functions.sh:223:# F8: production against the manifest, the declarations and the expected hash. One reason per line; none = deploy_match.
scripts/deploy-functions.sh:349:INFLIGHT_KEYS="format codebase attempt stamp commit tree manifest_sha256 before_digest functions transcript verifier"
scripts/deploy-functions.sh:364:  [[ "$(inflight_get before_digest)" =~ ^([0-9a-f]{64}|unknown)$ ]] || return 1
scripts/deploy-functions.sh:476:            and (.firebaseConfigEnv | type == "string") and (.expectedHashes | type == "object")
scripts/deploy-functions.sh:477:            and ((.expectedHashes | keys) == (.manifest.endpoints // {} | keys))
scripts/deploy-functions.sh:478:            and (.expectedHashes | to_entries | all(.value | type == "string" and test("^[0-9a-f]{40}$")))' "$DISC" >/dev/null 2>&1 \
scripts/deploy-functions.sh:580:  exp="$("$JQ" -c .expectedHashes "$DISC")"
scripts/deploy-functions.sh:597:    printf 'after_digest=%s\nfunctions_unchanged=%s\ndeploy_match=%s\n' "$AFTER_DIGEST" "$FUNCTIONS_UNCHANGED" "$DEPLOY_MATCH"
scripts/deploy-functions.sh:631:    printf 'deploy_verified=%s\n' "$DEPLOY_VERIFIED"
scripts/deploy-functions.sh:633:  say "access: ${ACCESS}   deploy_verified: ${DEPLOY_VERIFIED}"
scripts/deploy-functions.sh:676:# Read-only. The newest attempt (by stamp, attempt tags only), and the newest attempt whose deploy_verified is yes.
scripts/deploy-functions.sh:683:  NEWEST_VERIFIED="$(deploy_verified_of "$NEWEST" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${NEWEST} — refusing to guess."
scripts/deploy-functions.sh:686:    v="$(deploy_verified_of "$r" "$VERIFY_PREFIX")" || die $EX_RECORD "could not read deploy_verified for ${r} — refusing to guess."
scripts/deploy-functions.sh:734:    say "  deploy_verified=${NEWEST_VERIFIED}  iam_attested=${NEWEST_ATTESTED}"
scripts/deploy-functions.sh:737:    elif [ "$(record_word "$NEWEST" functions_unchanged "yes no unknown" 2>/dev/null || echo unknown)" = yes ]; then
scripts/deploy-functions.sh:812:    printf 'manifest_sha256=%s\nbefore_digest=%s\nfunctions=%s\ntranscript=%s\nverifier=%s\n' "$MSHA" "$BEFORE_DIGEST" "$IDS" "$TRANSCRIPT" "$MAIN_SHA"
scripts/deploy-functions.sh:814:      printf 'expected_hash.%s=%s\n' "$id" "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")"
scripts/deploy-functions.sh:831:  say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
scripts/deploy-functions.sh:836:    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
scripts/deploy-functions.sh:840:    printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
scripts/deploy-functions.sh:850:  printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
scripts/deploy-functions.sh:875:    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$(inflight_get manifest_sha256)" "$IDS" "$(inflight_get before_digest)"
scripts/deploy-functions.sh:885:      printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
scripts/deploy-functions.sh:886:      printf 'after_digest=unknown\nfunctions_unchanged=unknown\ndeploy_match=unknown\naccess=not-probed\ndeploy_verified=no\n'
scripts/deploy-functions.sh:905:    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(inflight_get "expected_hash.${id}")" ] \
scripts/deploy-functions.sh:906:      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one recorded before the CLI call."
scripts/deploy-functions.sh:912:  BEFORE_DIGEST="$(inflight_get before_digest)"
scripts/deploy-functions.sh:914:  printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN" >> "$MSG"
scripts/deploy-functions.sh:920:  say "✔ reconciled: ${TAG} recorded with its original stamp; deploy_verified=${DEPLOY_VERIFIED}."
scripts/deploy-functions.sh:944:  SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
scripts/deploy-functions.sh:945:  BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
scripts/deploy-functions.sh:951:    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
scripts/deploy-functions.sh:952:      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
scripts/deploy-functions.sh:958:    printf 'carried=cli_exit=%s backstop_seen=%s skip_line_seen=%s (from the attempt)\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
scripts/deploy-functions.sh:964:  say "✔ verify record ${TAG} for ${NEWEST}: deploy_verified=${DEPLOY_VERIFIED}."
tests/unit/functions-hash.test.js:12:import { expectedHashes } from '../../scripts/lib/functions-hash.mjs';
tests/unit/functions-hash.test.js:41:const hashOf = (dir, cfg = CONFIG, endpoints = { canary: CANARY }) => expectedHashes({
tests/unit/functions-hash.test.js:87:test('the pinned FIREBASE_CONFIG file is this project, in the adminSdkConfig shape', () => {
node_modules/firebase-tools/lib/deploy/functions/validate.js:274:            if (backend.someEndpoint(b, (e) => (0, functionsDeployHelper_1.endpointMatchesFilter)(e, filter))) {
node_modules/firebase-tools/lib/deploy/functions/validate.js:274:            if (backend.someEndpoint(b, (e) => (0, functionsDeployHelper_1.endpointMatchesFilter)(e, filter))) {
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:4:exports.endpointMatchesFilter = endpointMatchesFilter;
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:20:    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:22:function endpointMatchesFilter(endpoint, filter) {
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:140:    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:4:exports.endpointMatchesFilter = endpointMatchesFilter;
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:20:    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:22:function endpointMatchesFilter(endpoint, filter) {
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:140:    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
node_modules/firebase-tools/lib/deploy/functions/prepare.js:7:exports.updateEndpointTargetedStatus = updateEndpointTargetedStatus;
node_modules/firebase-tools/lib/deploy/functions/prepare.js:87:        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:224:    updateEndpointTargetedStatus(wantBackends, context.filters || []);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:299:function updateEndpointTargetedStatus(wantBackends, endpointFilters) {
node_modules/firebase-tools/lib/deploy/functions/prepare.js:302:            endpoint.targetedByOnly = (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, endpointFilters);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:388:        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:7:exports.updateEndpointTargetedStatus = updateEndpointTargetedStatus;
node_modules/firebase-tools/lib/deploy/functions/prepare.js:87:        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:224:    updateEndpointTargetedStatus(wantBackends, context.filters || []);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:299:function updateEndpointTargetedStatus(wantBackends, endpointFilters) {
node_modules/firebase-tools/lib/deploy/functions/prepare.js:302:            endpoint.targetedByOnly = (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, endpointFilters);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:388:        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/deploy/functions/deploy.js:6:exports.shouldUploadBeSkipped = shouldUploadBeSkipped;
node_modules/firebase-tools/lib/deploy/functions/deploy.js:130:            if (shouldUploadBeSkipped(context, wantBackend, haveBackend)) {
node_modules/firebase-tools/lib/deploy/functions/deploy.js:139:function shouldUploadBeSkipped(context, wantBackend, haveBackend) {
node_modules/firebase-tools/lib/deploy/functions/deploy.js:6:exports.shouldUploadBeSkipped = shouldUploadBeSkipped;
node_modules/firebase-tools/lib/deploy/functions/deploy.js:130:            if (shouldUploadBeSkipped(context, wantBackend, haveBackend)) {
node_modules/firebase-tools/lib/deploy/functions/deploy.js:139:function shouldUploadBeSkipped(context, wantBackend, haveBackend) {
node_modules/firebase-tools/lib/deploy/functions/validate.js:274:            if (backend.someEndpoint(b, (e) => (0, functionsDeployHelper_1.endpointMatchesFilter)(e, filter))) {
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:4:exports.endpointMatchesFilter = endpointMatchesFilter;
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:20:    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:22:function endpointMatchesFilter(endpoint, filter) {
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:140:    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
node_modules/firebase-tools/lib/deploy/functions/prepare.js:7:exports.updateEndpointTargetedStatus = updateEndpointTargetedStatus;
node_modules/firebase-tools/lib/deploy/functions/prepare.js:87:        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:224:    updateEndpointTargetedStatus(wantBackends, context.filters || []);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:299:function updateEndpointTargetedStatus(wantBackends, endpointFilters) {
node_modules/firebase-tools/lib/deploy/functions/prepare.js:302:            endpoint.targetedByOnly = (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, endpointFilters);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:388:        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/emulator/adminSdkConfig.js:41:        logger_1.logger.debug(`Detected demo- project: ${projectId}. Using default adminSdkConfig instead of calling firebase API.`);
node_modules/firebase-tools/lib/emulator/adminSdkConfig.js:49:        const res = await apiClient.get(`projects/${projectId}/adminSdkConfig`);
node_modules/firebase-tools/lib/extensions/extensionsHelper.js:46:const adminSdkConfig_1 = require("../emulator/adminSdkConfig");
node_modules/firebase-tools/lib/extensions/extensionsHelper.js:116:        ? await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(projectId)
node_modules/firebase-tools/lib/deploy/functions/deploy.js:6:exports.shouldUploadBeSkipped = shouldUploadBeSkipped;
node_modules/firebase-tools/lib/deploy/functions/deploy.js:130:            if (shouldUploadBeSkipped(context, wantBackend, haveBackend)) {
node_modules/firebase-tools/lib/deploy/functions/deploy.js:139:function shouldUploadBeSkipped(context, wantBackend, haveBackend) {
node_modules/firebase-tools/lib/deploy/functions/release/planner.js:27:    const toSkipPredicate = (id) => !!(!want[id].targetedByOnly &&
node_modules/firebase-tools/lib/deploy/functions/release/planner.js:34:        .filter((id) => toSkipPredicate(id))
node_modules/firebase-tools/lib/deploy/functions/release/planner.js:27:    const toSkipPredicate = (id) => !!(!want[id].targetedByOnly &&
node_modules/firebase-tools/lib/deploy/functions/release/planner.js:34:        .filter((id) => toSkipPredicate(id))
node_modules/firebase-tools/lib/deploy/functions/release/planner.js:27:    const toSkipPredicate = (id) => !!(!want[id].targetedByOnly &&
node_modules/firebase-tools/lib/deploy/functions/release/planner.js:34:        .filter((id) => toSkipPredicate(id))
node_modules/firebase-tools/lib/emulator/storage/files.js:10:const adminSdkConfig_1 = require("../adminSdkConfig");
node_modules/firebase-tools/lib/emulator/storage/files.js:45:            let adminSdkConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(this._projectId);
node_modules/firebase-tools/lib/emulator/storage/files.js:46:            if (!adminSdkConfig) {
node_modules/firebase-tools/lib/emulator/storage/files.js:47:                adminSdkConfig = (0, adminSdkConfig_1.constructDefaultAdminSdkConfig)(this._projectId);
node_modules/firebase-tools/lib/emulator/storage/files.js:49:            this.createBucket(adminSdkConfig.storageBucket);
node_modules/firebase-tools/lib/functionsConfig.js:104:    const response = await apiClient.get(`/v1beta1/projects/${projectId}/adminSdkConfig`);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:27:const adminSdkConfig_1 = require("./adminSdkConfig");
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:103:        this.adminSdkConfig = { ...this.args.adminSdkConfig, projectId: this.args.projectId };
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:255:        if (Object.keys(this.adminSdkConfig || {}).length <= 1) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:256:            const adminSdkConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(this.args.projectId);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:257:            if (adminSdkConfig) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:258:                this.adminSdkConfig = adminSdkConfig;
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:262:                this.adminSdkConfig = (0, adminSdkConfig_1.constructDefaultAdminSdkConfig)(this.args.projectId);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1009:            if (this.adminSdkConfig.databaseURL) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1010:                const asUrl = new url_1.URL(this.adminSdkConfig.databaseURL);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1016:            storageBucket: this.adminSdkConfig.storageBucket,
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1017:            databaseURL: emulatedDatabaseURL || this.adminSdkConfig.databaseURL,
node_modules/firebase-tools/lib/functions/env.js:11:exports.loadFirebaseEnvs = loadFirebaseEnvs;
node_modules/firebase-tools/lib/functions/env.js:247:function loadFirebaseEnvs(firebaseConfig, projectId) {
node_modules/firebase-tools/lib/functions/iac/export.js:18:    const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
node_modules/firebase-tools/lib/commands/internaltesting-functions-discover.js:8:const adminSdkConfig_1 = require("../emulator/adminSdkConfig");
node_modules/firebase-tools/lib/commands/internaltesting-functions-discover.js:19:    const firebaseConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(projectId);

exec
/bin/zsh -lc "sed -n '230,275p' node_modules/firebase-tools/lib/functions/env.js
sed -n '80,120p' node_modules/firebase-tools/lib/functionsConfig.js
sed -n '60,110p' node_modules/firebase-tools/lib/deploy/functions/prepare.js
sed -n '210,235p' node_modules/firebase-tools/lib/deploy/functions/prepare.js
sed -n '290,310p' node_modules/firebase-tools/lib/deploy/functions/prepare.js
sed -n '1,55p' node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js
sed -n '1,60p' node_modules/firebase-tools/lib/deploy/functions/release/planner.js
sed -n '110,165p' node_modules/firebase-tools/lib/deploy/functions/deploy.js
node -p \"require('./node_modules/firebase-tools/package.json').version\"
sed -n '70,115p' tests/unit/functions-hash.test.js
sed -n '1,180p' scripts/functions-discover.mjs
sed -n '1,100p' scripts/lib/functions-hash.mjs" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
    }
    let envs = {};
    for (const f of envFiles) {
        try {
            const data = fs.readFileSync(path.join(configDir, f), "utf8");
            envs = { ...envs, ...parseStrict(data) };
        }
        catch (err) {
            throw new error_1.FirebaseError(`Failed to load environment variables from ${f}.`, {
                exit: 2,
                children: err.children?.length > 0 ? err.children : [err],
            });
        }
    }
    (0, utils_1.logBullet)(clc.cyan(clc.bold("functions: ")) + `Loaded environment variables from ${envFiles.join(", ")}.`);
    return envs;
}
function loadFirebaseEnvs(firebaseConfig, projectId) {
    return {
        FIREBASE_CONFIG: JSON.stringify(firebaseConfig),
        GCLOUD_PROJECT: projectId,
    };
}
function writeResolvedParams(resolvedEnvs, userEnvs, userEnvOpt) {
    const toWrite = {};
    for (const paramName of Object.keys(resolvedEnvs)) {
        const paramValue = resolvedEnvs[paramName];
        if (!paramValue.internal && !Object.prototype.hasOwnProperty.call(userEnvs, paramName)) {
            toWrite[paramName] = paramValue.toString();
        }
    }
    writeUserEnvs(toWrite, userEnvOpt);
}
    });
}
async function ensureApi(options) {
    const projectId = (0, projectUtils_1.needProjectId)(options);
    return (0, ensureApiEnabled_1.ensure)(projectId, "runtimeconfig.googleapis.com", "runtimeconfig", true);
}
function varNameToIds(varName) {
    return {
        config: varName.match(new RegExp("/configs/(.+)/variables/"))[1],
        variable: varName.match(new RegExp("/variables/(.+)"))[1],
    };
}
function idsToVarName(projectId, configId, varId) {
    return ["projects", projectId, "configs", configId, "variables", varId].join("/");
}
function getAppEngineLocation(config) {
    let appEngineLocation = config.locationId;
    if (appEngineLocation && appEngineLocation.match(/[^\d]$/)) {
        appEngineLocation = appEngineLocation + "1";
    }
    return appEngineLocation || "us-central1";
}
async function getFirebaseConfig(options) {
    const projectId = (0, projectUtils_1.needProjectId)(options);
    const response = await apiClient.get(`/v1beta1/projects/${projectId}/adminSdkConfig`);
    return response.body;
}
async function setVariablesRecursive(projectId, configId, varPath, val) {
    let parsed = val;
    if (typeof val === "string") {
        try {
            parsed = JSON.parse(val);
        }
        catch (e) {
        }
    }
    if (typeof parsed === "object" && parsed !== null) {
        return Promise.all(Object.entries(parsed).map(([key, item]) => {
            const newVarPath = varPath ? [varPath, key].join("/") : key;
            return setVariablesRecursive(projectId, configId, newVarPath, item);
        }));
        ensureApiEnabled.ensure(projectId, (0, api_1.functionsOrigin)(), "functions"),
        ensureApiEnabled.check(projectId, (0, api_1.runtimeconfigOrigin)(), "runtimeconfig", true),
        ensure.cloudBuildEnabled(projectId),
        ensureApiEnabled.ensure(projectId, (0, api_1.artifactRegistryDomain)(), "artifactregistry"),
    ]);
    const firebaseConfig = await functionsConfig.getFirebaseConfig(options);
    context.firebaseConfig = firebaseConfig;
    context.codebaseDeployEvents = {};
    let runtimeConfig = { firebase: firebaseConfig };
    const targetedCodebaseConfigs = context.config.filter((cfg) => codebases.includes(cfg.codebase));
    if (checkAPIsEnabled[1] && targetedCodebaseConfigs.some(projectConfig_1.shouldUseRuntimeConfig)) {
        runtimeConfig = { ...runtimeConfig, ...(await (0, prepareFunctionsUpload_1.getFunctionsConfig)(projectId)) };
    }
    context.hasRuntimeConfig = Object.keys(runtimeConfig).some((k) => k !== "firebase");
    const wantBuilds = await loadCodebases(context.config, options, firebaseConfig, runtimeConfig, context.filters);
    const existingBackend = await backend.existingBackend(context);
    if (Object.values(wantBuilds).some((b) => b.extensions)) {
        const extContext = {};
        const extPayload = {};
        await (0, prepare_1.prepareDynamicExtensions)(extContext, options, extPayload, wantBuilds);
        context.extensions = extContext;
        payload.extensions = extPayload;
    }
    const codebaseUsesEnvs = [];
    const wantBackends = {};
    for (const [codebase, wantBuild] of Object.entries(wantBuilds)) {
        const config = (0, projectConfig_1.configForCodebase)(context.config, codebase);
        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
        const localCfg = (0, projectConfig_1.requireLocal)(config, "Remote sources are not supported.");
        const userEnvOpt = {
            functionsSource: options.config.path(localCfg.source),
            projectId: projectId,
            projectAlias: options.projectAlias,
        };
        proto.convertIfPresent(userEnvOpt, localCfg, "configDir", (cd) => options.config.path(cd));
        const userEnvs = functionsEnv.loadUserEnvs(userEnvOpt);
        const envs = { ...userEnvs, ...firebaseEnvs };
        const relevantEndpoints = backend
            .allEndpoints(existingBackend)
            .filter((e) => e.codebase === codebase || e.codebase === undefined);
        await resolveDefaultRegionsForBuild(wantBuild, backend.of(...relevantEndpoints));
        const { backend: wantBackend, envs: resolvedEnvs } = await build.resolveBackend({
            build: wantBuild,
            firebaseConfig,
            userEnvs,
            nonInteractive: options.nonInteractive,
            isEmulator: false,
        });
        functionsEnv.writeResolvedParams(resolvedEnvs, userEnvs, userEnvOpt);
        let hasEnvsFromParams = false;
        wantBackend.environmentVariables = envs;
    const haveBackend = backend.merge(...Object.values(haveBackends));
    await ensureAllRequiredAPIsEnabled(projectNumber, wantBackend, options);
    await warnIfNewGenkitFunctionIsMissingSecrets(wantBackend, haveBackend, options);
    warnIfDartBackendHasUnsupportedTriggers(wantBackend);
    const matchingBackend = backend.matchingBackend(wantBackend, (endpoint) => {
        return (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, context.filters);
    });
    await (0, prompts_1.promptForFailurePolicies)(options, matchingBackend, haveBackend);
    await (0, prompts_1.promptForMinInstances)(options, matchingBackend, haveBackend);
    await backend.checkAvailability(context, matchingBackend);
    await validate.secretsAreValid(projectId, matchingBackend);
    await (0, checkIam_1.ensureServiceAgentRoles)(projectId, projectNumber, matchingBackend, haveBackend, options.dryRun);
    await (0, checkIam_1.ensureGenkitMonitoringRoles)(projectId, projectNumber, matchingBackend, haveBackend, options.dryRun);
    await ensure.secretAccess(projectId, matchingBackend, haveBackend, options.dryRun);
    updateEndpointTargetedStatus(wantBackends, context.filters || []);
    validate.checkFiltersIntegrity(wantBackends, context.filters);
    (0, applyHash_1.applyBackendHashToBackends)(wantBackends, context);
}
async function resolveDefaultRegionsForBuild(buildObj, have) {
    for (const [id, endpoint] of Object.entries(buildObj.endpoints)) {
        if (!endpoint.region?.length || endpoint.region.includes(build.REGION_TBD)) {
            let resolvedRegion = services_1.FALLBACK_DEPLOYMENT_REGION;
            let matching;
            for (const region of Object.keys(have.endpoints)) {
                if (have.endpoints[region][id]) {
                    if (matching) {
    if (wantE.eventTrigger.region || !haveE.eventTrigger.region) {
        return;
    }
    if (JSON.stringify(haveE.eventTrigger.eventFilters) !==
        JSON.stringify(wantE.eventTrigger.eventFilters)) {
        return;
    }
    wantE.eventTrigger.region = haveE.eventTrigger.region;
}
function updateEndpointTargetedStatus(wantBackends, endpointFilters) {
    for (const wantBackend of Object.values(wantBackends)) {
        for (const endpoint of (0, backend_1.allEndpoints)(wantBackend)) {
            endpoint.targetedByOnly = (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, endpointFilters);
        }
    }
}
function inferBlockingDetails(want) {
    const authBlockingEndpoints = backend
        .allEndpoints(want)
        .filter((ep) => backend.isBlockingTriggered(ep) &&
        v1_1.AUTH_BLOCKING_EVENTS.includes(ep.blockingTrigger.eventType));
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.endpointMatchesAnyFilter = endpointMatchesAnyFilter;
exports.endpointMatchesFilter = endpointMatchesFilter;
exports.parseFunctionSelector = parseFunctionSelector;
exports.getEndpointFilters = getEndpointFilters;
exports.getHumanFriendlyPlatformName = getHumanFriendlyPlatformName;
exports.getFunctionLabel = getFunctionLabel;
exports.targetCodebases = targetCodebases;
exports.groupEndpointsByCodebase = groupEndpointsByCodebase;
exports.isCodebaseFiltered = isCodebaseFiltered;
exports.isEndpointFiltered = isEndpointFiltered;
const backend = require("./backend");
const projectConfig_1 = require("../../functions/projectConfig");
const functional_1 = require("../../functional");
function endpointMatchesAnyFilter(endpoint, filters) {
    if (!filters) {
        return true;
    }
    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
}
function endpointMatchesFilter(endpoint, filter) {
    if (endpoint.codebase && filter.codebase) {
        if (endpoint.codebase !== filter.codebase) {
            return false;
        }
    }
    if (!filter.idChunks) {
        return true;
    }
    const idChunks = endpoint.id.split("-");
    if (idChunks.length < filter.idChunks.length) {
        return false;
    }
    for (let i = 0; i < filter.idChunks.length; i += 1) {
        if (idChunks[i] !== filter.idChunks[i]) {
            return false;
        }
    }
    return true;
}
function parseFunctionSelector(selector, config) {
    const fragments = selector.split(":");
    if (fragments.length < 2) {
        const codebaseNames = config.map((c) => c.codebase);
        if (codebaseNames.includes(fragments[0])) {
            return [{ codebase: fragments[0] }];
        }
        return [{ codebase: projectConfig_1.DEFAULT_CODEBASE, idChunks: fragments[0].split(/[-.]/) }];
    }
    return [
        {
            codebase: fragments[0],
            idChunks: fragments[1].split(/[-.]/),
        },
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateChangesets = calculateChangesets;
exports.calculateUpdate = calculateUpdate;
exports.createDeploymentPlan = createDeploymentPlan;
exports.upgradedToGCFv2WithoutSettingConcurrency = upgradedToGCFv2WithoutSettingConcurrency;
exports.changedTriggerRegion = changedTriggerRegion;
exports.changedV2PubSubTopic = changedV2PubSubTopic;
exports.upgradedScheduleFromV1ToV2 = upgradedScheduleFromV1ToV2;
exports.checkForUnsafeUpdate = checkForUnsafeUpdate;
exports.checkForIllegalUpdate = checkForIllegalUpdate;
exports.checkForV2Upgrade = checkForV2Upgrade;
const functionsDeployHelper_1 = require("../functionsDeployHelper");
const deploymentTool_1 = require("../../../deploymentTool");
const error_1 = require("../../../error");
const utils = require("../../../utils");
const backend = require("../backend");
const v2events = require("../../../functions/events/v2");
function calculateChangesets(want, have, keyFn, deleteAll) {
    const toCreate = utils.groupBy(Object.keys(want)
        .filter((id) => !have[id])
        .map((id) => want[id]), keyFn);
    const toDelete = utils.groupBy(Object.keys(have)
        .filter((id) => !want[id])
        .filter((id) => deleteAll || (0, deploymentTool_1.isFirebaseManaged)(have[id].labels || {}))
        .map((id) => have[id]), keyFn);
    const toSkipPredicate = (id) => !!(!want[id].targetedByOnly &&
        have[id].state === "ACTIVE" &&
        have[id].hash &&
        want[id].hash &&
        want[id].hash === have[id].hash);
    const toSkipEndpointsMap = Object.keys(want)
        .filter((id) => have[id])
        .filter((id) => toSkipPredicate(id))
        .reduce((memo, id) => {
        memo[id] = want[id];
        return memo;
    }, {});
    const toSkip = utils.groupBy(Object.values(toSkipEndpointsMap), keyFn);
    if (Object.keys(toSkip).length) {
        utils.logLabeledBullet("functions", "Skipping the deploy of unchanged functions.");
    }
    const toUpdate = utils.groupBy(Object.keys(want)
        .filter((id) => have[id])
        .filter((id) => !toSkipEndpointsMap[id])
        .map((id) => calculateUpdate(want[id], have[id])), (eu) => keyFn(eu.endpoint));
    const result = {};
    const keys = new Set([
        ...Object.keys(toCreate),
        ...Object.keys(toDelete),
        ...Object.keys(toUpdate),
        ...Object.keys(toSkip),
    ]);
    for (const key of keys) {
        result[key] = {
            endpointsToCreate: toCreate[key] || [],
            endpointsToUpdate: toUpdate[key] || [],
            endpointsToDelete: toDelete[key] || [],
            endpointsToSkip: toSkip[key] || [],
        };
        }
        const cfg = (0, projectConfig_1.configForCodebase)(context.config, codebase);
        const label = cfg.source ?? cfg.remoteSource?.dir ?? "remote";
        if (uploads.length) {
            (0, utils_1.logLabeledSuccess)("functions", `${clc.bold(label)} source uploaded successfully`);
        }
    }
    catch (err) {
        (0, utils_1.logWarning)(clc.yellow("functions:") + " Upload Error: " + err.message);
        throw err;
    }
}
async function deploy(context, options, payload) {
    if (payload.extensions && context.extensions) {
        await (0, extensions_1.deploy)(context.extensions, options, payload.extensions);
    }
    if (payload.functions && context.config) {
        await (0, checkIam_1.checkHttpIam)(context, options, payload);
        const uploads = [];
        for (const [codebase, { wantBackend, haveBackend }] of Object.entries(payload.functions)) {
            if (shouldUploadBeSkipped(context, wantBackend, haveBackend)) {
                continue;
            }
            const projectNumber = options.projectNumber || (await (0, getProjectNumber_1.getProjectNumber)(context.projectId));
            uploads.push(uploadCodebase(context, projectNumber, codebase, wantBackend));
        }
        await Promise.all(uploads);
    }
}
function shouldUploadBeSkipped(context, wantBackend, haveBackend) {
    if (context.filters && context.filters.length > 0) {
        return false;
    }
    const wantEndpoints = backend.allEndpoints(wantBackend);
    const haveEndpoints = backend.allEndpoints(haveBackend);
    if (wantEndpoints.length !== haveEndpoints.length) {
        return false;
    }
    return wantEndpoints.every((wantEndpoint) => {
        const haveEndpoint = (0, backend_1.findEndpoint)(haveBackend, (endpoint) => endpoint.id === wantEndpoint.id);
        if (!haveEndpoint) {
            return false;
        }
        return (haveEndpoint.hash &&
            wantEndpoint.hash &&
            haveEndpoint.hash === wantEndpoint.hash &&
            haveEndpoint.state === "ACTIVE");
    });
}
15.22.3
  assert.equal((await hashOf(e)).hashes.canary, h.canary, 'node_modules and functions.yaml are ignored');
});

test('FIREBASE_CONFIG is part of it, key order included (so the pinned file must match the live body exactly)', async () => {
  const dir = folder();
  const { hashes: h } = await hashOf(dir);
  assert.notEqual((await hashOf(dir, { ...CONFIG, locationId: 'us-central' })).hashes.canary, h.canary);
  const reordered = Object.fromEntries(Object.entries(CONFIG).reverse());
  assert.notEqual((await hashOf(dir, reordered)).hashes.canary, h.canary);
});

test('every function of a codebase gets the same hash (no secrets; one source; one env)', async () => {
  const { hashes } = await hashOf(folder(), CONFIG, { canary: CANARY, other: { ...CANARY, entryPoint: 'other' } });
  assert.deepEqual(Object.keys(hashes).sort(), ['canary', 'other']);
  assert.equal(hashes.canary, hashes.other);
});

test('the pinned FIREBASE_CONFIG file is this project, in the adminSdkConfig shape', () => {
  assert.equal(CONFIG.projectId, 'my-clay-hub');
  for (const [k, v] of Object.entries(CONFIG)) {
    assert.ok(['projectId', 'databaseURL', 'storageBucket', 'locationId'].includes(k), k);
    assert.equal(typeof v, 'string');
  }
});

test('the pin is the live FIREBASE_CONFIG the first deploy read back (D2-5), byte for byte', () => {
  // The guessed "locationId":"nam5" was wrong: the live value has no locationId. Change this only from a guard
  // read-back that prints a different live value (FUNCTIONS-ROLLBACK.md §8).
  assert.equal(readFileSync(join(ROOT, 'functions/firebase-config.json'), 'utf8'),
    '{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app"}\n');
});
// Discover one functions codebase's manifest exactly once, through the pinned Firebase CLI's own node delegate,
// and print it with the sha256 the deploy will be sealed to.
//
//   "$NODE22" scripts/functions-discover.mjs --project <id> --codebase <cb> --source <dir> --out <dir> \
//       --firebase-config <file>
//
// What it does, mirroring deploy/functions/prepare.js loadCodebases() in firebase-tools 15.22.3:
//   - builds the node delegate for <source> with the CLI's getRuntimeDelegate, validates the package, and calls
//     discoverBuild with FIREBASE_FUNCTIONS_DISCOVERY_OUTPUT_PATH=<out>, so the delegate writes <out>/functions.yaml
//     (the CLI's execAdmin branch) instead of serving it on a random port;
//   - passes the same Firebase env the CLI builds: FIREBASE_CONFIG and GCLOUD_PROJECT (loadFirebaseEnvs), plus
//     GOOGLE_CLOUD_QUOTA_PROJECT, and runtime config { firebase: <config> } (disallowLegacyRuntimeConfig is set);
//   - prints JSON: { firebaseFunctionsVersion, manifestPath, manifestSha256, manifest, build, firebaseConfigEnv,
//     sourceHash, expectedHashes } — manifest is the YAML as parsed by the CLI's own yaml module, build is the CLI's own
//     yamlToBuild() of it, firebaseConfigEnv the exact FIREBASE_CONFIG string the CLI will set, and expectedHashes the
//     hash the CLI will stamp on each function (scripts/lib/functions-hash.mjs, with <project-dir>/firebase.json's
//     entry for <cb>).
// The seal, not the fidelity of this discovery, decides what deploys: predeploy-check.sh copies this exact file in
// as functions.yaml after matching its sha256, and the CLI then deploys that file (discovery never runs again).
//
// <firebase-config> is a JSON file holding the body the CLI puts in FIREBASE_CONFIG: the guard passes the committed
// functions/firebase-config.json (Christie, Sep 30: pinned, not fetched, so no script uses the Firebase login; the
// guard checks the live value against it after each deploy). This script never talks to Google.
//
// Refuses (exit 2, one line on stderr): a Node major other than 22; a firebase-tools other than 15.22.3; a
// functions.yaml already in <source> (it would replace discovery entirely); no firebase-functions installed in
// <source>/node_modules (the CLI would silently use one from elsewhere); an <out> inside <source>, missing, or
// not empty. Plan: ~/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html (F5, O1).
import { createRequire } from 'node:module';
import { createHash } from 'node:crypto';
import { existsSync, readFileSync, readdirSync, realpathSync, statSync } from 'node:fs';
import { dirname, join, relative, isAbsolute } from 'node:path';
import { fileURLToPath } from 'node:url';
import { expectedHashes } from './lib/functions-hash.mjs';

const CLI_VERSION = '15.22.3';
const ROOT = dirname(dirname(fileURLToPath(import.meta.url)));

function refuse(msg) {
  process.stderr.write(`functions-discover: REFUSED — ${msg}\n`);
  process.exit(2);
}

function parseArgs(argv) {
  const want = ['--project', '--codebase', '--source', '--out', '--firebase-config'];
  const args = {};
  for (let i = 0; i < argv.length; i += 2) {
    if (!want.includes(argv[i]) || argv[i + 1] === undefined) refuse(`bad argument ${JSON.stringify(argv[i])}`);
    args[argv[i].slice(2)] = argv[i + 1];
  }
  for (const w of want) if (!args[w.slice(2)]) refuse(`${w} is required`);
  return args;
}

const args = parseArgs(process.argv.slice(2));

if (process.versions.node.split('.')[0] !== '22') refuse(`Node ${process.versions.node}, not 22 — run it with $NODE22`);

const require = createRequire(join(ROOT, 'package.json'));
const cliPkg = require('firebase-tools/package.json');
if (cliPkg.version !== CLI_VERSION) refuse(`firebase-tools is ${cliPkg.version}, not the pinned ${CLI_VERSION}`);
const lib = (p) => require(`firebase-tools/lib/${p}`);

if (!/^[a-z][a-z0-9-]*$/.test(args.codebase)) refuse(`codebase ${JSON.stringify(args.codebase)} is not a codebase name`);
if (!isAbsolute(args.source) || !existsSync(args.source)) refuse(`--source ${args.source} is not an existing absolute path`);
const sourceDir = realpathSync(args.source);
if (existsSync(join(sourceDir, 'functions.yaml'))) refuse(`${sourceDir}/functions.yaml exists — it would replace discovery; remove it`);
// The CLI would fall back to a firebase-functions found elsewhere (the repo root, the SDK's own folder); the manifest
// that gets sealed must come from this codebase's own install, so refuse unless that is where the binary is.
// The binary must resolve INTO that install's own firebase-functions package (npm makes .bin/ a relative symlink to
// ../firebase-functions/lib/bin/…), so a stale or redirected binary can't produce the manifest while the version
// printed below describes a different package.
const sdkBin = join(sourceDir, 'node_modules/.bin/firebase-functions');
if (!existsSync(sdkBin)) refuse(`${sdkBin} is missing — install the codebase first (npm ci --prefix ${sourceDir}, with Node 22)`);
const sdkDir = realpathSync(join(sourceDir, 'node_modules/firebase-functions'));
const binReal = realpathSync(sdkBin);
if (!binReal.startsWith(`${sdkDir}/`)) refuse(`${sdkBin} resolves to ${binReal}, outside this codebase's firebase-functions (${sdkDir})`);
const sdkVersion = JSON.parse(readFileSync(join(sdkDir, 'package.json'), 'utf8')).version;
if (!isAbsolute(args.out) || !existsSync(args.out) || !statSync(args.out).isDirectory()) refuse(`--out ${args.out} is not an existing absolute directory`);
const outDir = realpathSync(args.out);
const rel = relative(sourceDir, outDir);
if (rel === '' || (!rel.startsWith('..') && !isAbsolute(rel))) refuse(`--out ${outDir} is inside the source folder`);
if (readdirSync(outDir).length !== 0) refuse(`--out ${outDir} is not empty`);

let firebaseConfig;
try {
  firebaseConfig = JSON.parse(readFileSync(args['firebase-config'], 'utf8'));
} catch (e) {
  refuse(`--firebase-config is not readable JSON (${e.message})`);
}
if (!firebaseConfig || typeof firebaseConfig !== 'object' || Array.isArray(firebaseConfig) || firebaseConfig.projectId !== args.project) {
  refuse(`--firebase-config is not a Firebase config for ${args.project}`);
}
// The adminSdkConfig body: these keys only, each a string. Its key ORDER is part of the pin (FIREBASE_CONFIG is
// JSON.stringify of it, and the hash covers that string).
for (const [k, v] of Object.entries(firebaseConfig)) {
  if (!['projectId', 'databaseURL', 'storageBucket', 'locationId'].includes(k) || typeof v !== 'string') {
    refuse(`--firebase-config has ${JSON.stringify(k)}, not only string projectId, databaseURL, storageBucket, locationId`);
  }
}
let entry;
try {
  const entries = JSON.parse(readFileSync(join(ROOT, 'firebase.json'), 'utf8')).functions.filter((f) => f.codebase === args.codebase);
  if (entries.length !== 1) throw new Error(`${entries.length} entries for ${args.codebase}`);
  [entry] = entries;
} catch (e) {
  refuse(`firebase.json has no single functions entry for ${args.codebase} (${e.message})`);
}
let entrySource = null;
try { entrySource = realpathSync(join(ROOT, entry.source)); } catch { /* refused below */ }
if (entrySource !== sourceDir) refuse(`--source ${sourceDir} is not ${args.codebase}'s source (${entry.source})`);

// The delegate spawns node_modules/.bin/firebase-functions, whose `#!/usr/bin/env node` shebang takes whichever
// node is first on PATH — Node 20 on this laptop. Put this Node 22 first so discovery runs on it.
process.env.PATH = `${dirname(process.execPath)}:${process.env.PATH || ''}`;
process.env.FIREBASE_FUNCTIONS_DISCOVERY_OUTPUT_PATH = outDir;
process.env.FUNCTIONS_DISCOVERY_TIMEOUT = '60';

const runtimes = lib('deploy/functions/runtimes/index.js');
const supported = lib('deploy/functions/runtimes/supported/index.js');
const functionsEnv = lib('functions/env.js');
const discovery = lib('deploy/functions/runtimes/discovery/index.js');
const api = lib('api.js');
const yaml = require('yaml');

try {
  const delegate = await runtimes.getRuntimeDelegate({ projectId: args.project, sourceDir, projectDir: ROOT, runtime: 'nodejs22' });
  supported.guardVersionSupport(delegate.runtime);
  await delegate.validate();
  await delegate.build();
  const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, args.project);
  await delegate.discoverBuild({ firebase: firebaseConfig }, { ...firebaseEnvs, GOOGLE_CLOUD_QUOTA_PROJECT: args.project });
} catch (e) {
  refuse(`discovery failed: ${e.message}`);
}

const manifestPath = join(outDir, 'functions.yaml');
if (!existsSync(manifestPath)) refuse(`discovery wrote no ${manifestPath}`);
const bytes = readFileSync(manifestPath);
const manifest = yaml.parse(bytes.toString('utf8'));
const build = discovery.yamlToBuild(manifest, args.project, api.functionsDefaultRegion(), 'nodejs22');
let hashes;
try {
  // yamlToBuild's own object, re-parsed: resolveBackend fills in fields, and the printed build must stay as discovered.
  hashes = await expectedHashes({ root: ROOT, sourceDir, codebase: args.codebase, entry, project: args.project, firebaseConfig,
    build: discovery.yamlToBuild(yaml.parse(bytes.toString('utf8')), args.project, api.functionsDefaultRegion(), 'nodejs22') });
} catch (e) {
  refuse(`could not compute the expected hash: ${e.message}`);
}
process.stdout.write(`${JSON.stringify({
  firebaseFunctionsVersion: sdkVersion,
  manifestPath,
  manifestSha256: createHash('sha256').update(bytes).digest('hex'),
  manifest,
  build,
  firebaseConfigEnv: functionsEnv.loadFirebaseEnvs(firebaseConfig, args.project).FIREBASE_CONFIG,
  sourceHash: hashes.sourceHash,
  expectedHashes: hashes.hashes,
})}\n`);
// The hash the pinned Firebase CLI (15.22.3) will stamp on each function of one codebase, computed BEFORE the deploy
// with the CLI's own functions. The guard records it before the CLI call and requires the live `hash` to equal it
// afterwards (F8), so one rule covers a first deploy, a changed source, a same-sha retry and a retry after a failed
// build — and a wrong-but-different hash still fails.
//
// What the CLI does (deploy/functions/prepare.js, 15.22.3), and so what this does, step for step:
//   - the source hash: prepareFunctionsUpload() over the codebase folder with the firebase.json entry's `ignore`
//     (sha1 of the sorted per-file sha1s — bytes only; a rename or a mode-only change leaves it unchanged, which is
//     why the guard also records the tree id and F3 checks modes);
//   - the backend env: userEnvs (none: F4 forbids .env*) then loadFirebaseEnvs() → { FIREBASE_CONFIG, GCLOUD_PROJECT };
//     no params (F13 refuses them), so nothing is added from resolved params;
//   - resolveBackend() over the discovered build, then applyBackendHashToBackends() with that source hash.
// The live env the CLI merges into each endpoint later (inferDetailsFromExisting) is per-endpoint and not part of the
// hash, which reads only the backend-level env.
//
// Pure local work: no network and no login. FIREBASE_CONFIG's body is the committed functions/firebase-config.json
// (Christie, Sep 30: pinned rather than fetched, so no script uses the Firebase login); after a deploy the guard also
// checks the live FIREBASE_CONFIG equals it.
// Plan: ~/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html (F8, K17).
import { createRequire } from 'node:module';
import { rmSync } from 'node:fs';
import { join } from 'node:path';

export async function expectedHashes({ root, sourceDir, codebase, entry, project, firebaseConfig, build }) {
  const require = createRequire(join(root, 'package.json'));
  const lib = (p) => require(`firebase-tools/lib/${p}`);
  const upload = lib('deploy/functions/prepareFunctionsUpload.js');
  const buildLib = lib('deploy/functions/build.js');
  const applyHash = lib('deploy/functions/cache/applyHash.js');
  const functionsEnv = lib('functions/env.js');
  const backendLib = lib('deploy/functions/backend.js');

  if (!Array.isArray(entry?.ignore)) throw new Error('the firebase.json entry has no ignore list');
  const { backend } = await buildLib.resolveBackend({ build, firebaseConfig, userEnvs: {}, nonInteractive: true, isEmulator: false });
  backend.environmentVariables = { ...functionsEnv.loadFirebaseEnvs(firebaseConfig, project) };
  // packageSource() pushes the debug globs onto config.ignore, so it gets a copy.
  const packaged = await upload.prepareFunctionsUpload(root, sourceDir, { ...entry, ignore: [...entry.ignore] }, [], undefined,
    { exportType: 'zip', executablePaths: [] });
  try {
    applyHash.applyBackendHashToBackends({ [codebase]: backend }, { sources: { [codebase]: { functionsSourceV2Hash: packaged.hash } } });
  } finally {
    rmSync(packaged.pathToSource, { force: true });
  }
  const hashes = {};
  for (const e of backendLib.allEndpoints(backend)) hashes[e.id] = e.hash;
  return { sourceHash: packaged.hash, hashes };
}

codex
The core CLI behavior matches the intended retry path so far: version 15.22.3 stringifies the API response directly, and an explicit codebase filter marks the endpoint as targeted, bypassing both unchanged-function skipping and upload skipping. I’m now checking the guard’s exact verification predicates and whether the documentation overstates what is stable about the API response.
exec
/bin/zsh -lc "nl -ba scripts/deploy-functions.sh | sed -n '190,330p'
nl -ba scripts/deploy-functions.sh | sed -n '540,650p'
nl -ba scripts/deploy-functions.sh | sed -n '780,860p'
nl -ba scripts/deploy-functions.sh | sed -n '890,975p'
nl -ba FUNCTIONS-ROLLBACK.md | sed -n '1,160p'
nl -ba node_modules/firebase-tools/lib/functions/env.js | sed -n '240,258p'
nl -ba node_modules/firebase-tools/lib/functionsConfig.js | sed -n '95,110p'
nl -ba node_modules/firebase-tools/lib/deploy/functions/prepare.js | sed -n '78,100p;216,230p;296,306p'
nl -ba node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js | sed -n '10,45p'
nl -ba node_modules/firebase-tools/lib/deploy/functions/release/planner.js | sed -n '18,48p'
nl -ba node_modules/firebase-tools/lib/deploy/functions/deploy.js | sed -n '124,160p'
rg -n 'firebase-tools|15\\.22\\.3' package.json package-lock.json firebase.json .firebaserc" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
   190	        ( if ($e.minInstances // 0) != 0 then "\($id): minInstances \($e.minInstances) (it bills continuously; must be 0)" else empty end ),
   191	        ( if ($e.vpc // null) != null then "\($id): sets a VPC" else empty end ),
   192	        ( if ($e.secretEnvironmentVariables // null) != null then "\($id): uses secrets" else empty end ),
   193	        ( if (($e.environmentVariables // {}) | length) > 0 then "\($id): sets environment variables" else empty end ),
   194	        ( if ($e.entryPoint | type) != "string" or $e.entryPoint == "" then "\($id): no entryPoint" else empty end ) ),
   195	    ( $dc | keys[] as $id | if (($m.endpoints // {})[$id] // null) == null then "declaration \($cb)/\($id) has no function (stale)" else empty end )'
   196	
   197	# One canonical snapshot of functions:list (F8 step 1): functions sorted by (codebase, region, id); keys and labels
   198	# sorted (jq -S); env reduced to its sorted key NAMES plus the values of EVENTARC_CLOUD_EVENT_SOURCE and FUNCTION_TARGET;
   199	# absent defaults filled in. Its sha256 is the snapshot digest.
   200	JQ_CANON='
   201	  .result | map({
   202	      codebase: (.codebase // "default"), region, id, platform, runtime, state, entryPoint, uri, hash,
   203	      triggers: ([keys[] | select(endswith("Trigger"))] | sort), httpsTrigger,
   204	      serviceAccount, ingressSettings: (.ingressSettings // "ALLOW_ALL"),
   205	      maxInstances, minInstances: (.minInstances // 0), concurrency, timeoutSeconds, availableMemoryMb, cpu,
   206	      labels: (.labels // {}), vpc: (.vpc // null), secretEnvironmentVariables: (.secretEnvironmentVariables // null),
   207	      envKeys: ((.environmentVariables // {}) | keys | sort),
   208	      envEventarcSource: (.environmentVariables.EVENTARC_CLOUD_EVENT_SOURCE // null),
   209	      envFunctionTarget: (.environmentVariables.FUNCTION_TARGET // null) })
   210	  | sort_by(.codebase, .region, .id)'
   211	
   212	# Before the CLI (D2-3): refuse drift the CLI would carry into the new revision — it merges live env when there is no
   213	# .env (prepare.js) — and a live function the manifest lacks (F6: the guard never deletes).
   214	JQ_DRIFT='
   215	  [.result[] | select((.codebase // "default") == $cb)] as $live
   216	  | ($live[] | .id as $id
   217	      | ( ((.environmentVariables // {}) | keys) - $envkeys | if length > 0 then "\($id): live env key(s) outside F8 five: \(join(", "))" else empty end ),
   218	        ( if (.secretEnvironmentVariables // null) != null then "\($id): live secret environment variables" else empty end ),
   219	        ( if (.vpc // null) != null then "\($id): live VPC setting" else empty end ),
   220	        ( if .state == "DEPLOYING" then "\($id): is DEPLOYING (an operation is in progress)" else empty end ),
   221	        ( if ($ids | index($id)) == null then "\($id): is live but not in the manifest; the guard never deletes (F6, FUNCTIONS-ROLLBACK.md)" else empty end ) )'
   222	
   223	# F8: production against the manifest, the declarations and the expected hash. One reason per line; none = deploy_match.
   224	JQ_F8='
   225	  [.result[] | select((.codebase // "default") == $cb)] as $live
   226	  | ($m.endpoints | keys | sort) as $want
   227	  | ( ($live | map(.id) | sort) as $have | if $have != $want then "function set: live \($have | tostring), manifest \($want | tostring)" else empty end ),
   228	    ( $live[] | . as $f | .id as $id | $m.endpoints[$id] as $e | $dc[$id] as $x | select($e != null)
   229	      | ( if .state != "ACTIVE" then "\($id): state \(.state // "absent"), not ACTIVE" else empty end ),
   230	        ( if .platform != "gcfv2" then "\($id): platform \(.platform // "absent"), not gcfv2" else empty end ),
   231	        ( if .runtime != "nodejs22" then "\($id): runtime \(.runtime // "absent"), not nodejs22" else empty end ),
   232	        ( if .region != $region then "\($id): region \(.region // "absent"), not \($region)" else empty end ),
   233	        ( if (.httpsTrigger | type) != "object" or ([keys[] | select(endswith("Trigger") and . != "httpsTrigger")] | length) > 0 then "\($id): live trigger is not HTTPS only" else empty end ),
   234	        ( if .serviceAccount != $x.serviceAccount then "\($id): runtime account \(.serviceAccount // "absent"), declared \($x.serviceAccount)" else empty end ),
   235	        ( if .ingressSettings != $x.ingress then "\($id): ingress \(.ingressSettings // "absent"), declared \($x.ingress)" else empty end ),
   236	        ( ["maxInstances","concurrency","timeoutSeconds","availableMemoryMb","cpu"][] as $k
   237	          | if $f[$k] != $e[$k] then "\($id): \($k) \($f[$k] // "absent"), manifest \($e[$k])" else empty end ),
   238	        ( if (.minInstances // 0) != ($e.minInstances // 0) then "\($id): minInstances \(.minInstances), manifest \($e.minInstances // 0)" else empty end ),
   239	        ( ((.environmentVariables // {}) | keys | sort) as $ek | if $ek != $envkeys then "\($id): env keys \($ek | tostring), not exactly \($envkeys | tostring)" else empty end ),
   240	        ( if .environmentVariables.EVENTARC_CLOUD_EVENT_SOURCE? != "projects/\($project)/locations/\($region)/services/\($id)" then "\($id): EVENTARC_CLOUD_EVENT_SOURCE is not projects/\($project)/locations/\($region)/services/\($id)" else empty end ),
   241	        ( ($e.entryPoint | gsub("-"; ".")) as $t | if .environmentVariables.FUNCTION_TARGET? != $t then "\($id): FUNCTION_TARGET is not \($t)" else empty end ),
   242	        ( if .environmentVariables.FIREBASE_CONFIG? != $cfg then "\($id): FIREBASE_CONFIG differs from functions/firebase-config.json" else empty end ),
   243	        ( if .environmentVariables.GCLOUD_PROJECT? != $project then "\($id): GCLOUD_PROJECT is not \($project)" else empty end ),
   244	        ( if .hash != $exp[$id] then "\($id): live hash \(.hash // "absent"), expected \($exp[$id])" else empty end ),
   245	        ( if (.vpc // null) != null then "\($id): has a VPC setting" else empty end ),
   246	        ( if (.secretEnvironmentVariables // null) != null then "\($id): has secret environment variables" else empty end ) )'
   247	
   248	# Christie's Console evidence for --reconcile and --clear-inflight (F9): exactly these keys, per function the Cloud
   249	# Build id and status, and the Cloud Run latest ready revision.
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
   540	    printf '%s %s\n' "$1" "$(git rev-parse "refs/tags/${1}")" > "$PENDING"
   541	    printf 'RECORD NOT PUBLISHED. It exists locally as %s; publish it with:\n    git push %s refs/tags/%s\nThe next run of this guard will refuse until it is published.\n' "$1" "$REMOTE" "$1" >&2
   542	    return 1
   543	  fi
   544	  return 0
   545	}
   546	
   547	# ─── Read-back: F8, the transcript, the probe ──────────────────────────────────────────────────────────
   548	# Probe one function's URL with NO credentials (curl -q ignores any .curlrc). Classes (F8): answered = our code ran for
   549	# an unauthenticated caller (the x-tinker-reached header, or any 2xx/3xx); refused = 401/403 without the header;
   550	# inconclusive = anything else, after PROBE_TRIES tries PROBE_WAIT seconds apart. Prints "<class> <detail> <server>".
   551	probe_one() {   # <uri>
   552	  local uri="$1" i code rc hdr server="" detail="" reached
   553	  hdr="${WORK}/probe.headers"
   554	  case "$uri" in https://*) ;; *) printf 'inconclusive no-https-uri -'; return 0 ;; esac
   555	  for i in $(seq 1 "$PROBE_TRIES"); do
   556	    : > "$hdr"; rc=0
   557	    code="$("$CURL" -q -sS -o /dev/null -D "$hdr" -w '%{http_code}' --proto '=https' --max-time 15 "$uri" 2>/dev/null)" || rc=$?
   558	    reached=0; grep -qi "^${REACHED_HEADER}:" "$hdr" && reached=1
   559	    server="$(awk 'tolower($0) ~ /^server:/ { sub(/^[^:]*:[ \t]*/, ""); sub(/\r$/, ""); gsub(/ /, "_"); print; exit }' "$hdr")"
   560	    if [ "$rc" = 0 ]; then
   561	      detail="http-${code}"
   562	      if [ "$reached" = 1 ]; then printf 'answered %s-with-%s %s' "$detail" "$REACHED_HEADER" "${server:--}"; return 0; fi
   563	      case "$code" in
   564	        2??|3??) printf 'answered %s %s' "$detail" "${server:--}"; return 0 ;;
   565	        401|403) printf 'refused %s %s' "$detail" "${server:--}"; return 0 ;;
   566	      esac
   567	    else
   568	      detail="curl-exit-${rc}"
   569	    fi
   570	    [ "$i" -lt "$PROBE_TRIES" ] && sleep "$PROBE_WAIT"
   571	  done
   572	  printf 'inconclusive %s %s' "${detail:-none}" "${server:--}"
   573	}
   574	# Everything after the CLI call, for --approved, --reconcile and --reverify. Appends the read-back's fields to <msg> and
   575	# sets DEPLOY_MATCH, ACCESS and DEPLOY_VERIFIED. Uses DISC, TMP, WORK, IDS, and the carried CLI_EXIT, BACKSTOP_SEEN,
   576	# SKIP_SEEN, BEFORE_DIGEST.
   577	read_back() {   # <msg file>
   578	  local msg="$1" after="${WORK}/after.json" reasons id uri res cls n_ref=0 n_ans=0 n=0 cfg exp
   579	  cfg="$("$JQ" -r .firebaseConfigEnv "$DISC")"
   580	  exp="$("$JQ" -c .expectedHashes "$DISC")"
   581	  AFTER_OK=0
   582	  if list_live "$TMP" "$after"; then
   583	    AFTER_OK=1
   584	    AFTER_DIGEST="$(digest_of "$after")"
   585	    reasons="$("$JQ" -r --argjson m "$("$JQ" -c .manifest "$DISC")" \
   586	       --argjson dc "$("$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries' "${TMP}/functions/declarations.json")" \
   587	       --argjson exp "$exp" --arg cfg "$cfg" --arg cb "$CB" --arg project "$PROJECT" --arg region "$REGION" \
   588	       --argjson envkeys "$ENV_KEYS" "$JQ_F8" "$after" 2>&1)" || reasons="could not evaluate the read-back: ${reasons}"
   589	    if [ -z "$reasons" ]; then DEPLOY_MATCH=yes; else DEPLOY_MATCH=no; fi
   590	  else
   591	    AFTER_DIGEST=unknown; DEPLOY_MATCH=unknown
   592	    reasons="functions:list failed or returned malformed JSON: $(list_why "$after")"
   593	  fi
   594	  if [ "$BEFORE_DIGEST" = unknown ] || [ "$AFTER_DIGEST" = unknown ]; then FUNCTIONS_UNCHANGED=unknown
   595	  elif [ "$BEFORE_DIGEST" = "$AFTER_DIGEST" ]; then FUNCTIONS_UNCHANGED=yes; else FUNCTIONS_UNCHANGED=no; fi
   596	  {
   597	    printf 'after_digest=%s\nfunctions_unchanged=%s\ndeploy_match=%s\n' "$AFTER_DIGEST" "$FUNCTIONS_UNCHANGED" "$DEPLOY_MATCH"
   598	    if [ -n "$reasons" ]; then printf 'mismatch=%s\n' "$(printf '%s' "$reasons" | tr '\n' '|' )"; fi
   599	  } >> "$msg"
   600	  say "─── read-back ───"
   601	  say "deploy_match: ${DEPLOY_MATCH}"
   602	  [ -z "$reasons" ] || printf '%s\n' "$reasons" | sed 's/^/  - /'
   603	  if [ "$AFTER_OK" = 1 ] && printf '%s' "$reasons" | grep -q 'FIREBASE_CONFIG differs'; then
   604	    # The admin-SDK config (project id, bucket, location): public, and the same content as the pinned file, so shown.
   605	    say "  live FIREBASE_CONFIG: $("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb)][0].environmentVariables.FIREBASE_CONFIG // "absent"' "$after")"
   606	    say "  pinned (functions/firebase-config.json): ${cfg}"
   607	  fi
   608	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   609	    printf 'live_hash.%s=%s\n' "$id" "$( [ "$AFTER_OK" = 1 ] && "$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "absent"' "$after" || echo unknown)" >> "$msg"
   610	  done
   611	  say "─── unauthenticated probe (no credentials) ───"
   612	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   613	    n=$((n + 1))
   614	    uri=""
   615	    [ "$AFTER_OK" = 1 ] && uri="$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].uri // ""' "$after")"
   616	    if [ -z "$uri" ]; then res="inconclusive no-uri -"; else res="$(probe_one "$uri")"; fi
   617	    cls="${res%% *}"
   618	    case "$cls" in refused) n_ref=$((n_ref + 1)) ;; answered) n_ans=$((n_ans + 1)) ;; esac
   619	    printf 'access.%s=%s\nprobe.%s=%s\n' "$id" "$cls" "$id" "${res#* }" >> "$msg"
   620	    say "  ${id}: ${res}"
   621	  done
   622	  if [ "$n_ans" -gt 0 ]; then ACCESS=answered; elif [ "$n" -gt 0 ] && [ "$n_ref" = "$n" ]; then ACCESS=refused; else ACCESS=inconclusive; fi
   623	  if [ "$CLI_EXIT" = 0 ] && [ "$BACKSTOP_SEEN" = yes ] && [ "$SKIP_SEEN" = no ] && [ "$DEPLOY_MATCH" = yes ] && [ "$ACCESS" = refused ]; then
   624	    DEPLOY_VERIFIED=yes
   625	  else
   626	    DEPLOY_VERIFIED=no
   627	  fi
   628	  {
   629	    printf 'access=%s\n' "$ACCESS"
   630	    printf 'not_proven=refused does not prove the absence of grants to all Google accounts, to named principals, or at project, folder or organization level (--attest records those)\n'
   631	    printf 'deploy_verified=%s\n' "$DEPLOY_VERIFIED"
   632	  } >> "$msg"
   633	  say "access: ${ACCESS}   deploy_verified: ${DEPLOY_VERIFIED}"
   634	}
   635	transcript_flags() {   # <transcript> <sha> — sets BACKSTOP_SEEN and SKIP_SEEN ("unknown" when there is no transcript)
   636	  local line="predeploy-check: functions codebase ${CB} for ${PROJECT} matches commit ${2:0:12} (tree ${TREE}); sealed manifest ${MSHA} in place"
   637	  if [ ! -f "$1" ]; then BACKSTOP_SEEN=unknown; SKIP_SEEN=unknown; return 0; fi
   638	  if grep -qF -- "$line" "$1"; then BACKSTOP_SEEN=yes; else BACKSTOP_SEEN=no; fi
   639	  if grep -qF -- "$SKIP_LINE" "$1"; then SKIP_SEEN=yes; else SKIP_SEEN=no; fi
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
   780	  say "manifest:  ${MSHA}  (functions: ${IDS})"
   781	
   782	  say "─── npm test (in ${TMP}; the functions suites required) ───"
   783	  (cd "$TMP" && TINKER_FUNCTIONS_TESTS=required npm22 test) || die $EX_TESTS "tests failed on ${SHA:0:12}; nothing was deployed."
   784	
   785	  reserve_stamp "$ATTEMPT_PREFIX" "${SHA:0:7}"
   786	  record_state
   787	  if [ -z "$LAST_VERIFIED" ]; then
   788	    say "replaces:  (no verified attempt yet for ${CB} — everything below is new to the record)"; BASE="$EMPTY_TREE"
   789	  else
   790	    BASE="$(commit_of "$LAST_VERIFIED")"; say "replaces:  ${LAST_VERIFIED} (${BASE:0:12})$(receipt_note "$LAST_VERIFIED")"
   791	  fi
   792	  [ -n "$NEWEST" ] && [ "$NEWEST" != "$LAST_VERIFIED" ] && say "NOTE:      the newest attempt ${NEWEST} is not verified; production may be mixed."
   793	  show_machinery "$BASE" "$SHA"
   794	  say "─── diff ${BASE:0:12} → ${SHA:0:12} ───"
   795	  # shellcheck disable=SC2086
   796	  git --no-pager diff "$BASE" "$SHA" -- $SHOWN_PATHS || true
   797	  say "─── end diff ───"
   798	
   799	  # Production before: the snapshot, F6 and the drift check — all before the in-flight file and the CLI.
   800	  BEFORE="${WORK}/before.json"
   801	  list_live "$TMP" "$BEFORE" || die $EX_FETCH "could not read production (functions:list): $(list_why "$BEFORE") — nothing was deployed."
   802	  BEFORE_DIGEST="$(digest_of "$BEFORE")"
   803	  DRIFT="$("$JQ" -r --arg cb "$CB" --argjson envkeys "$ENV_KEYS" --argjson ids "$IDS_JSON" "$JQ_DRIFT" "$BEFORE" 2>&1)" \
   804	    || die $EX_DRIFT "could not check production for drift: ${DRIFT}"
   805	  [ -z "$DRIFT" ] || die $EX_DRIFT "production has something this deploy would carry over or can't handle — NOTHING WAS DEPLOYED:
   806	$(printf '%s\n' "$DRIFT" | sed 's/^/  - /')"
   807	
   808	  # The in-flight file (F9): written atomically BEFORE the CLI, so a crash from here on leaves an honest trace.
   809	  TRANSCRIPT="${TRANSCRIPTS}/functions-${CB}-${STAMP}-${SHA:0:7}.log"
   810	  {
   811	    printf 'format=tinker-functions-inflight-1\ncodebase=%s\nattempt=%s\nstamp=%s\ncommit=%s\ntree=%s\n' "$CB" "$TAG" "$STAMP" "$SHA" "$TREE"
   812	    printf 'manifest_sha256=%s\nbefore_digest=%s\nfunctions=%s\ntranscript=%s\nverifier=%s\n' "$MSHA" "$BEFORE_DIGEST" "$IDS" "$TRANSCRIPT" "$MAIN_SHA"
   813	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   814	      printf 'expected_hash.%s=%s\n' "$id" "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")"
   815	      printf 'before_hash.%s=%s\n' "$id" "$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "none"' "$BEFORE")"
   816	    done
   817	  } | atomic_write "$INFLIGHT" || die $EX_INFLIGHT "could not write ${INFLIGHT} — nothing was deployed."
   818	  inflight_valid || die $EX_INFLIGHT "${INFLIGHT} did not read back as written — nothing was deployed; remove it by hand."
   819	
   820	  # The CLI. TINKER_DEPLOY_* are exported, never inline (K15). Never --force.
   821	  say "─── firebase deploy --only functions:${CB} --project ${PROJECT} (in ${TMP}) ───"
   822	  set +e
   823	  (
   824	    export TINKER_DEPLOY_SHA="$SHA" TINKER_DEPLOY_CODEBASE="$CB" TINKER_DEPLOY_MANIFEST_PATH="$MPATH" TINKER_DEPLOY_MANIFEST_SHA256="$MSHA"
   825	    cli "$TMP" deploy --only "functions:${CB}" --project "$PROJECT" --non-interactive
   826	  ) 2>&1 | tee "$TRANSCRIPT"
   827	  CLI_EXIT="${PIPESTATUS[0]}"
   828	  set -e
   829	  { cat "$INFLIGHT"; printf 'cli_exit=%s\n' "$CLI_EXIT"; } | atomic_write "$INFLIGHT" || warn "could not add cli_exit to ${INFLIGHT} (a --reconcile will record cli_exit=unknown)"
   830	  transcript_flags "$TRANSCRIPT" "$SHA"
   831	  say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
   832	
   833	  MSG="${WORK}/record"
   834	  {
   835	    printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$TREE"
   836	    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
   837	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   838	      printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
   839	    done
   840	    printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   841	  } > "$MSG"
   842	  read_back "$MSG"
   843	  verifier_fields "$SHA" "$MSG"
   844	  printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   845	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   846	  rm -f "$INFLIGHT"
   847	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   848	  attest_help
   849	  if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   850	  printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   851	  exit $EX_UNVERIFIED
   852	fi
   853	
   854	# ─── --reconcile / --clear-inflight ────────────────────────────────────────────────────────────────────
   855	if [ "$MODE" = "reconcile" ] || [ "$MODE" = "clear-inflight" ]; then
   856	  [ -f "$INFLIGHT" ] || die $EX_INFLIGHT "there is no in-flight file (${INFLIGHT}) — nothing to reconcile."
   857	  inflight_valid || die $EX_INFLIGHT "${INFLIGHT} is malformed (truncated, or edited) — refusing to guess what it recorded. Show it to Christie; FUNCTIONS-ROLLBACK.md §2."
   858	  [ "$(inflight_get codebase)" = "$CB" ] || die $EX_INFLIGHT "the in-flight attempt is for codebase $(inflight_get codebase), not ${CB}."
   859	  TAG="$(inflight_get attempt)"; STAMP="$(inflight_get stamp)"; SHA="$(inflight_get commit)"; IDS="$(inflight_get functions)"
   860	  if [ "$MODE" = "clear-inflight" ] && [ "$ATTEMPT_ARG" != "$TAG" ]; then
   890	    printf 'at=%s\nby=deploy-functions.sh --clear-inflight\n' "$STAMP" >> "$MSG"
   891	    PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   892	    rm -f "$INFLIGHT"
   893	    [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   894	    say "✔ cleared: ${TAG} recorded with deploy_match=unknown (its original stamp). Production is NOT verified; the next --approved may run."
   895	    exit 0
   896	  fi
   897	
   898	  # --reconcile: rebuild the expected state from the attempt's commit and prove it's the same manifest and hashes.
   899	  verifier_fields "$SHA" "$MSG"   # refuses early (before the rebuild) if the machinery changed and Christie hasn't OK'd it
   900	  build_expected "$SHA"
   901	  [ "$MSHA" = "$(inflight_get manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the one the attempt sealed ($(inflight_get manifest_sha256)) — refusing to verify against a different manifest."
   902	  [ "$TREE" = "$(inflight_get tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   903	  [ "$IDS" = "$(inflight_get functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   904	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   905	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(inflight_get "expected_hash.${id}")" ] \
   906	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one recorded before the CLI call."
   907	  done
   908	  NOW="${WORK}/now.json"
   909	  list_live "$TMP" "$NOW" || die $EX_FETCH "could not read production (functions:list): $(list_why "$NOW") — try again."
   910	  DEPLOYING="$("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb and .state == "DEPLOYING") | .id] | join(",")' "$NOW")"
   911	  [ -z "$DEPLOYING" ] || die $EX_INFLIGHT "${DEPLOYING} still DEPLOYING — the operation hasn't finished; wait, then reconcile."
   912	  BEFORE_DIGEST="$(inflight_get before_digest)"
   913	  transcript_flags "$(inflight_get transcript)" "$SHA"
   914	  printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN" >> "$MSG"
   915	  read_back "$MSG"
   916	  printf 'evidence=%s\nat=%s\nby=deploy-functions.sh --reconcile\n' "$EVJSON" "$STAMP" >> "$MSG"
   917	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   918	  rm -f "$INFLIGHT"
   919	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   920	  say "✔ reconciled: ${TAG} recorded with its original stamp; deploy_verified=${DEPLOY_VERIFIED}."
   921	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   922	  exit $EX_UNVERIFIED
   923	fi
   924	
   925	# ─── --reverify / --attest: only for the newest attempt ────────────────────────────────────────────────
   926	[ ! -e "$INFLIGHT" ] || die $EX_INFLIGHT "${INFLIGHT} exists — an interrupted deploy comes first (FUNCTIONS-ROLLBACK.md §2)."
   927	NEWEST="$(latest_receipt "$ATTEMPT_PREFIX")" || die $EX_RECORD "could not read the functions record for ${CB}."
   928	[ -n "$NEWEST" ] || die $EX_NOT_NEWEST "there is no attempt for ${CB} yet."
   929	[ "$ATTEMPT_ARG" = "$NEWEST" ] || die $EX_NOT_NEWEST "${ATTEMPT_ARG} is not the newest attempt (${NEWEST}). Today's production can only speak for the attempt that put it there."
   930	SHA="$(commit_of "$NEWEST")"
   931	for k in commit manifest_sha256 functions tree; do
   932	  record_field "$NEWEST" "$k" >/dev/null || die $EX_RECORD "the attempt ${NEWEST} has no readable ${k} — refusing."
   933	done
   934	[ "$(record_field "$NEWEST" commit)" = "$SHA" ] || die $EX_RECORD "the attempt ${NEWEST} names a different commit than it points at."
   935	IDS="$(record_field "$NEWEST" functions)"
   936	IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
   937	MSG="${WORK}/record"
   938	
   939	if [ "$MODE" = "reverify" ]; then
   940	  : > "$MSG"
   941	  verifier_fields "$SHA" "$MSG"
   942	  CLI_EXIT="$(record_field "$NEWEST" cli_exit)" || die $EX_RECORD "the attempt ${NEWEST} has no readable cli_exit."
   943	  BACKSTOP_SEEN="$(record_word "$NEWEST" backstop_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable backstop_seen."
   944	  SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
   945	  BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
   946	  build_expected "$SHA"
   947	  [ "$MSHA" = "$(record_field "$NEWEST" manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the attempt's."
   948	  [ "$TREE" = "$(record_field "$NEWEST" tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   949	  [ "$IDS" = "$(record_field "$NEWEST" functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   950	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   951	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
   952	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
   953	  done
   954	  reserve_stamp "$VERIFY_PREFIX" "${SHA:0:7}"
   955	  VMSG="${WORK}/verify"
   956	  {
   957	    printf 'format=tinker-functions-verify-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
   958	    printf 'carried=cli_exit=%s backstop_seen=%s skip_line_seen=%s (from the attempt)\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   959	  } > "$VMSG"
   960	  read_back "$VMSG"
   961	  cat "$MSG" >> "$VMSG"
   962	  printf 'at=%s\nby=deploy-functions.sh --reverify\n' "$STAMP" >> "$VMSG"
   963	  write_record "$TAG" "$SHA" "$VMSG" || exit $EX_RECEIPT
   964	  say "✔ verify record ${TAG} for ${NEWEST}: deploy_verified=${DEPLOY_VERIFIED}."
   965	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   966	  exit $EX_UNVERIFIED
   967	fi
   968	
   969	# --attest
   970	[ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
   971	"$JQ" -e "$JQ_ATTEST_SHAPE" "$EVIDENCE" >/dev/null 2>&1 \
   972	  || die $EX_EVIDENCE "the IAM reading is not in the fixed shape (see the --attest instructions a deploy prints, and FUNCTIONS-ROLLBACK.md)."
   973	: > "$MSG"
   974	verifier_fields "$SHA" "$MSG"
   975	DC="$(git show "${SHA}:functions/declarations.json" | "$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries')" \
     1	# My Clay Hub — functions rollback and recovery runbook (`my-clay-hub` project)
     2	
     3	For HTTP Cloud Functions in `functions/<codebase>/` (Phase D2: one codebase, `core`, whose only function is the
     4	permanent canary). Rules have their own runbook: `RULES-ROLLBACK.md`. Plan and design:
     5	`~/tinker-ai-configs/thoughts/plans/firebase-functions-deploy-guard.html` (F1, F6, F7, F9).
     6	
     7	> **Status (D2-3):** the guard, `scripts/deploy-functions.sh`, and its suite (`npm run test:functions-guard`) exist,
     8	> with the backstop, the canary, `functions/declarations.json`, `functions/iam-expectations.json` and the pinned
     9	> `functions/firebase-config.json`. **D2-5 (Sep 30):** the first guarded deploy created the canary (attempt
    10	> `deployed/my-clay-hub/functions-core/20261001T034143Z-604844c`, private: the unauthenticated probe was refused) but
    11	> recorded `deploy_verified=no`, because the pinned `locationId` was wrong (§8); the corrected pin needs a second deploy.
    12	
    13	**Never** run a raw `firebase … deploy`, `functions:delete`, or any function-changing CLI command by hand. A hook denies
    14	them, and the backstop refuses a deploy that didn't come through the guard. Every step below goes through
    15	`scripts/deploy-functions.sh`, after Christie says **"approved to change firebase <full sha>"** for that exact commit.
    16	
    17	## The record
    18	
    19	Each guarded deploy attempt leaves an annotated tag — `deployed/my-clay-hub/functions-<cb>/<UTC stamp>-<sha7>` — whose
    20	name is the attempt's id. Verify records live under `…/functions-<cb>-verify/`, Christie's IAM readings under
    21	`…/functions-<cb>-attest/`; each names the attempt it belongs to. Only attempt tags decide "newest attempt".
    22	
    23	`scripts/deploy-functions.sh --status --codebase core` says either "verified at X", "functions unchanged by Y", or
    24	"production may be mixed: last verified X (or none yet); unverified attempt Y". Start there.
    25	
    26	## 1. Roll back to an earlier version
    27	
    28	The guard deploys only a commit on `origin/main` whose machinery — the backstop, the guard, the declarations, the
    29	tests, the codebase's `package.json` and lockfile (its `CONTROL_FILES`) — is the tip's. An old commit fails that, so a
    30	rollback is a **new commit** that restores the old code:
    31	
    32	1. Find the last good attempt: `git tag -l 'deployed/my-clay-hub/functions-core/*'` and `--status`.
    33	2. `git switch -c rollback-functions main`, then restore the codebase folder from that attempt's commit:
    34	   `git checkout <tag>^{commit} -- functions/core` (the `functions/core` folder only — never `firebase.json`,
    35	   `functions/declarations.json` or `scripts/`; if the old version needs different declarations, change them by hand
    36	   and say so in the commit).
    37	3. Commit, push, open a PR, merge to `main`. `npm test` with `TINKER_FUNCTIONS_TESTS=required` must pass.
    38	4. `--status`, paste `--diff` verbatim, and deploy only after Christie's phrase for the new commit.
    39	
    40	A function that exists in production but is missing from the new commit makes the guard **refuse before uploading**
    41	(F6: it never deletes). Deleting a function has no guarded path yet — stop and ask Christie.
    42	
    43	## 2. A deploy was interrupted (Ctrl-C, crash, laptop asleep)
    44	
    45	The guard writes `.git/tinker-deploy-inflight-functions` before it calls the CLI and removes it after the record is
    46	written. If it's still there, the next `--approved` refuses. Don't delete it.
    47	
    48	- **The operation finished** (Cloud Build → History → that build finished; Cloud Run → the service → latest revision
    49	  ready): Christie reads, and Claude writes into a file, exactly this shape (one entry per function of the attempt):
    50	
    51	  ```json
    52	  {"confirmation": "<Christie's words, verbatim>",
    53	   "functions": {"canary": {"buildId": "<Cloud Build id, a UUID>", "buildStatus": "SUCCESS",
    54	                            "latestReadyRevision": "canary-00001-abc"}}}
    55	  ```
    56	
    57	  `buildStatus` must be a finished one (`SUCCESS`, `FAILURE`, `INTERNAL_ERROR`, `TIMEOUT`, `CANCELLED`, `EXPIRED`).
    58	  Then `scripts/deploy-functions.sh --reconcile --codebase core --evidence <file>`. It rebuilds the expected state from
    59	  the attempt's commit (worktree, Node 22, `npm ci`, discovery) and refuses unless the manifest, tree and expected hash
    60	  match what the in-flight file recorded; it refuses while any function is still `DEPLOYING`; then it re-reads
    61	  production, probes, and writes the attempt's tag with the **original** stamp. If the CLI had returned before the crash,
    62	  the in-flight file holds its exit code and the attempt can verify; otherwise it records `cli_exit=unknown`
    63	  (not verified). The CLI's transcript is kept in `.git/tinker-deploy-transcripts/`.
    64	- **The operation never settles:** `--clear-inflight <attempt> --codebase core --evidence <file>`, only with
    65	  Christie's approval, naming the in-flight attempt exactly. The same shape, but any build status, and
    66	  `latestReadyRevision` may be `null`. It writes the attempt's tag with `deploy_match=unknown`, `deploy_verified=no`,
    67	  again with the original stamp.
    68	- A **truncated or edited** in-flight file is refused by both (fail-closed). Show it to Christie; don't delete it
    69	  without her OK.
    70	
    71	## 3. The first build failed (permissions)
    72	
    73	Google, not the CLI, chooses the build account (K12). Both candidates were stripped of broad roles in D2-1, and only
    74	the Compute account (`760301318440-compute@developer.gserviceaccount.com`) holds the three build roles. If the first
    75	build fails for permissions:
    76	
    77	1. Cloud Build → History → the failed build: note its **service account** and the **exact denied permission**.
    78	2. If the other candidate (`760301318440@cloudbuild.gserviceaccount.com`) built it: give that account the same three
    79	   roles (Logs Writer; Storage Object Viewer with the "function source buckets only" condition; Artifact Registry
    80	   Writer on `gcf-artifacts`), and remove them from the Compute account.
    81	3. Any other permission is a **widening**: Christie decides, and it's logged in the plan.
    82	4. Re-run the **same sha** under the same approval. The failed attempt stays in the record as unverified.
    83	   The guard makes a **fresh worktree for every run**, retries included: a successful backstop leaves the sealed
    84	   `functions/core/functions.yaml` in place for the CLI, and the backstop refuses to seal over an existing one. Never
    85	   re-run the CLI by hand in an old worktree.
    86	
    87	## 4. A stray future-stamped tag
    88	
    89	A tag under `deployed/my-clay-hub/functions-core/` stamped in the future (a machine with a fast clock, or a hand-made
    90	tag) would sort as "newest". Unlike the rules guard, the functions guard **refuses** to deploy when it can't stamp a
    91	newer attempt, so a stray tag blocks it rather than silently misordering the record. To clear it:
    92	
    93	1. Identify it: `git for-each-ref --format='%(refname:lstrip=2) %(creatordate:iso-strict) %(taggername)' 'refs/tags/deployed/my-clay-hub/functions-core/*'`.
    94	   A stamp later than the tag's own creation date is fabricated.
    95	2. Show Christie the tag and its message. **Only with her approval**: `git tag -d <tag>` and
    96	   `git push origin :refs/tags/<tag>`.
    97	3. `--status` again.
    98	
    99	## 5. The deploy lock
   100	
   101	Both guards share `.git/tinker-deploy.lock`. A functions deploy holds it for minutes (install, tests, discovery,
   102	build). Before removing a lock: read `.git/tinker-deploy.lock/owner`, check that pid isn't running (`ps -p <pid>`),
   103	and that no functions deploy is in progress. Never remove it while a deploy runs.
   104	
   105	## 6. The canary
   106	
   107	`core/canary` is permanent: it proves the deploy path end to end and does nothing. Its runtime account `canary@` holds
   108	no roles and must keep none (`functions/iam-expectations.json`). Don't delete it or grant it anything.
   109	
   110	## 7. After a deploy: --attest, --reverify, and a changed guard
   111	
   112	- **--attest** (every deploy, M3 and F7): Christie reads each function's Security tab ("Require authentication") and
   113	  Permissions (the full `run.invoker` list); IAM "View by roles" — the holders of every role in
   114	  `functions/iam-expectations.json` (`run.invoker`, `cloudfunctions.invoker`, `owner`, `editor`,
   115	  `cloudbuild.builds.builder`) and each runtime account's roles; every **binding row** of the build roles
   116	  `logging.logWriter` and `storage.objectViewer` (member and condition — one row each, to the build account; a second,
   117	  unconditional row would override the conditioned one); the holders of `artifactregistry.writer` at **project** level
   118	  (expected none) and directly on Artifact Registry → `gcf-artifacts` → Permissions (the build account only); and
   119	  Cloud Build → History (the build id, status and service account). The
   120	  deploy prints the JSON shape, generated from `iam-expectations.json`; then
   121	  `--attest <attempt> --codebase core --evidence <file>`. The script compares it with `functions/declarations.json` and
   122	  `functions/iam-expectations.json` and records `iam_attested=yes` or `no` (with every difference). Only the newest
   123	  attempt can be attested. **Not attested** (the record says so): folder- and organization-level grants, which
   124	  Christie can't read, and grants on individual Cloud Storage buckets or managed folders, which don't appear on the
   125	  IAM project page (Christie, Sep 30: a known limit, not read).
   126	- **--reverify <attempt>**: re-reads production and re-probes the **newest** attempt only (production can only speak
   127	  for the attempt that put it there). It carries the attempt's `cli_exit`, backstop and skip-line results forward, so it
   128	  can upgrade only the read-back and the probe. Its record goes under `…/functions-<cb>-verify/`.
   129	- **A changed guard.** Every tag-writing mode refuses unless the guard running is `origin/main`'s (not dirty, not
   130	  unpushed). If the guard's machinery changed between the attempt and now, `--reconcile`, `--reverify`,
   131	  `--clear-inflight` and `--attest` refuse until Christie OKs it; then re-run with `--acknowledge-verifier-change`, and
   132	  the record says `verifier_changed=yes`. The verdicts are always the tip's code; rebuilding an attempt's expected
   133	  state uses that attempt's own backstop, discovery and hash module (they made what it recorded), and the record names
   134	  that commit as `rebuild_helpers_from`.
   135	
   136	## 8. The pinned FIREBASE_CONFIG
   137	
   138	`functions/firebase-config.json` is the body the CLI puts in `FIREBASE_CONFIG` (Firebase's admin-SDK config: project
   139	id, bucket, location — not a secret). It's pinned rather than fetched, so no script uses the Firebase login (Christie,
   140	Sep 30), and the expected hash covers it, key order included. The first deploy (D2-5) showed that the live value has
   141	**no** `locationId` (the guessed `"nam5"` was wrong), so the pin is just `projectId` and `storageBucket`. With it, the
   142	expected hash equals the live canary's (`5dc5ef93…`).
   143	If a run reports `FIREBASE_CONFIG differs`, the guard prints the live value: commit it (same key order) in that file,
   144	get it reviewed, and run the guard again under a new approval.
   240	                children: err.children?.length > 0 ? err.children : [err],
   241	            });
   242	        }
   243	    }
   244	    (0, utils_1.logBullet)(clc.cyan(clc.bold("functions: ")) + `Loaded environment variables from ${envFiles.join(", ")}.`);
   245	    return envs;
   246	}
   247	function loadFirebaseEnvs(firebaseConfig, projectId) {
   248	    return {
   249	        FIREBASE_CONFIG: JSON.stringify(firebaseConfig),
   250	        GCLOUD_PROJECT: projectId,
   251	    };
   252	}
   253	function writeResolvedParams(resolvedEnvs, userEnvs, userEnvOpt) {
   254	    const toWrite = {};
   255	    for (const paramName of Object.keys(resolvedEnvs)) {
   256	        const paramValue = resolvedEnvs[paramName];
   257	        if (!paramValue.internal && !Object.prototype.hasOwnProperty.call(userEnvs, paramName)) {
   258	            toWrite[paramName] = paramValue.toString();
    95	function getAppEngineLocation(config) {
    96	    let appEngineLocation = config.locationId;
    97	    if (appEngineLocation && appEngineLocation.match(/[^\d]$/)) {
    98	        appEngineLocation = appEngineLocation + "1";
    99	    }
   100	    return appEngineLocation || "us-central1";
   101	}
   102	async function getFirebaseConfig(options) {
   103	    const projectId = (0, projectUtils_1.needProjectId)(options);
   104	    const response = await apiClient.get(`/v1beta1/projects/${projectId}/adminSdkConfig`);
   105	    return response.body;
   106	}
   107	async function setVariablesRecursive(projectId, configId, varPath, val) {
   108	    let parsed = val;
   109	    if (typeof val === "string") {
   110	        try {
    78	        const extPayload = {};
    79	        await (0, prepare_1.prepareDynamicExtensions)(extContext, options, extPayload, wantBuilds);
    80	        context.extensions = extContext;
    81	        payload.extensions = extPayload;
    82	    }
    83	    const codebaseUsesEnvs = [];
    84	    const wantBackends = {};
    85	    for (const [codebase, wantBuild] of Object.entries(wantBuilds)) {
    86	        const config = (0, projectConfig_1.configForCodebase)(context.config, codebase);
    87	        const firebaseEnvs = functionsEnv.loadFirebaseEnvs(firebaseConfig, projectId);
    88	        const localCfg = (0, projectConfig_1.requireLocal)(config, "Remote sources are not supported.");
    89	        const userEnvOpt = {
    90	            functionsSource: options.config.path(localCfg.source),
    91	            projectId: projectId,
    92	            projectAlias: options.projectAlias,
    93	        };
    94	        proto.convertIfPresent(userEnvOpt, localCfg, "configDir", (cd) => options.config.path(cd));
    95	        const userEnvs = functionsEnv.loadUserEnvs(userEnvOpt);
    96	        const envs = { ...userEnvs, ...firebaseEnvs };
    97	        const relevantEndpoints = backend
    98	            .allEndpoints(existingBackend)
    99	            .filter((e) => e.codebase === codebase || e.codebase === undefined);
   100	        await resolveDefaultRegionsForBuild(wantBuild, backend.of(...relevantEndpoints));
   216	    });
   217	    await (0, prompts_1.promptForFailurePolicies)(options, matchingBackend, haveBackend);
   218	    await (0, prompts_1.promptForMinInstances)(options, matchingBackend, haveBackend);
   219	    await backend.checkAvailability(context, matchingBackend);
   220	    await validate.secretsAreValid(projectId, matchingBackend);
   221	    await (0, checkIam_1.ensureServiceAgentRoles)(projectId, projectNumber, matchingBackend, haveBackend, options.dryRun);
   222	    await (0, checkIam_1.ensureGenkitMonitoringRoles)(projectId, projectNumber, matchingBackend, haveBackend, options.dryRun);
   223	    await ensure.secretAccess(projectId, matchingBackend, haveBackend, options.dryRun);
   224	    updateEndpointTargetedStatus(wantBackends, context.filters || []);
   225	    validate.checkFiltersIntegrity(wantBackends, context.filters);
   226	    (0, applyHash_1.applyBackendHashToBackends)(wantBackends, context);
   227	}
   228	async function resolveDefaultRegionsForBuild(buildObj, have) {
   229	    for (const [id, endpoint] of Object.entries(buildObj.endpoints)) {
   230	        if (!endpoint.region?.length || endpoint.region.includes(build.REGION_TBD)) {
   296	    }
   297	    wantE.eventTrigger.region = haveE.eventTrigger.region;
   298	}
   299	function updateEndpointTargetedStatus(wantBackends, endpointFilters) {
   300	    for (const wantBackend of Object.values(wantBackends)) {
   301	        for (const endpoint of (0, backend_1.allEndpoints)(wantBackend)) {
   302	            endpoint.targetedByOnly = (0, functionsDeployHelper_1.endpointMatchesAnyFilter)(endpoint, endpointFilters);
   303	        }
   304	    }
   305	}
   306	function inferBlockingDetails(want) {
    10	exports.groupEndpointsByCodebase = groupEndpointsByCodebase;
    11	exports.isCodebaseFiltered = isCodebaseFiltered;
    12	exports.isEndpointFiltered = isEndpointFiltered;
    13	const backend = require("./backend");
    14	const projectConfig_1 = require("../../functions/projectConfig");
    15	const functional_1 = require("../../functional");
    16	function endpointMatchesAnyFilter(endpoint, filters) {
    17	    if (!filters) {
    18	        return true;
    19	    }
    20	    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
    21	}
    22	function endpointMatchesFilter(endpoint, filter) {
    23	    if (endpoint.codebase && filter.codebase) {
    24	        if (endpoint.codebase !== filter.codebase) {
    25	            return false;
    26	        }
    27	    }
    28	    if (!filter.idChunks) {
    29	        return true;
    30	    }
    31	    const idChunks = endpoint.id.split("-");
    32	    if (idChunks.length < filter.idChunks.length) {
    33	        return false;
    34	    }
    35	    for (let i = 0; i < filter.idChunks.length; i += 1) {
    36	        if (idChunks[i] !== filter.idChunks[i]) {
    37	            return false;
    38	        }
    39	    }
    40	    return true;
    41	}
    42	function parseFunctionSelector(selector, config) {
    43	    const fragments = selector.split(":");
    44	    if (fragments.length < 2) {
    45	        const codebaseNames = config.map((c) => c.codebase);
    18	const v2events = require("../../../functions/events/v2");
    19	function calculateChangesets(want, have, keyFn, deleteAll) {
    20	    const toCreate = utils.groupBy(Object.keys(want)
    21	        .filter((id) => !have[id])
    22	        .map((id) => want[id]), keyFn);
    23	    const toDelete = utils.groupBy(Object.keys(have)
    24	        .filter((id) => !want[id])
    25	        .filter((id) => deleteAll || (0, deploymentTool_1.isFirebaseManaged)(have[id].labels || {}))
    26	        .map((id) => have[id]), keyFn);
    27	    const toSkipPredicate = (id) => !!(!want[id].targetedByOnly &&
    28	        have[id].state === "ACTIVE" &&
    29	        have[id].hash &&
    30	        want[id].hash &&
    31	        want[id].hash === have[id].hash);
    32	    const toSkipEndpointsMap = Object.keys(want)
    33	        .filter((id) => have[id])
    34	        .filter((id) => toSkipPredicate(id))
    35	        .reduce((memo, id) => {
    36	        memo[id] = want[id];
    37	        return memo;
    38	    }, {});
    39	    const toSkip = utils.groupBy(Object.values(toSkipEndpointsMap), keyFn);
    40	    if (Object.keys(toSkip).length) {
    41	        utils.logLabeledBullet("functions", "Skipping the deploy of unchanged functions.");
    42	    }
    43	    const toUpdate = utils.groupBy(Object.keys(want)
    44	        .filter((id) => have[id])
    45	        .filter((id) => !toSkipEndpointsMap[id])
    46	        .map((id) => calculateUpdate(want[id], have[id])), (eu) => keyFn(eu.endpoint));
    47	    const result = {};
    48	    const keys = new Set([
   124	        await (0, extensions_1.deploy)(context.extensions, options, payload.extensions);
   125	    }
   126	    if (payload.functions && context.config) {
   127	        await (0, checkIam_1.checkHttpIam)(context, options, payload);
   128	        const uploads = [];
   129	        for (const [codebase, { wantBackend, haveBackend }] of Object.entries(payload.functions)) {
   130	            if (shouldUploadBeSkipped(context, wantBackend, haveBackend)) {
   131	                continue;
   132	            }
   133	            const projectNumber = options.projectNumber || (await (0, getProjectNumber_1.getProjectNumber)(context.projectId));
   134	            uploads.push(uploadCodebase(context, projectNumber, codebase, wantBackend));
   135	        }
   136	        await Promise.all(uploads);
   137	    }
   138	}
   139	function shouldUploadBeSkipped(context, wantBackend, haveBackend) {
   140	    if (context.filters && context.filters.length > 0) {
   141	        return false;
   142	    }
   143	    const wantEndpoints = backend.allEndpoints(wantBackend);
   144	    const haveEndpoints = backend.allEndpoints(haveBackend);
   145	    if (wantEndpoints.length !== haveEndpoints.length) {
   146	        return false;
   147	    }
   148	    return wantEndpoints.every((wantEndpoint) => {
   149	        const haveEndpoint = (0, backend_1.findEndpoint)(haveBackend, (endpoint) => endpoint.id === wantEndpoint.id);
   150	        if (!haveEndpoint) {
   151	            return false;
   152	        }
   153	        return (haveEndpoint.hash &&
   154	            wantEndpoint.hash &&
   155	            haveEndpoint.hash === wantEndpoint.hash &&
   156	            haveEndpoint.state === "ACTIVE");
   157	    });
   158	}
package.json:20:    "firebase-tools": "15.22.3"
package-lock.json:11:        "firebase-tools": "15.22.3"
package-lock.json:4423:    "node_modules/firebase-tools": {
package-lock.json:4424:      "version": "15.22.3",
package-lock.json:4425:      "resolved": "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.22.3.tgz",

exec
/bin/zsh -lc "nl -ba scripts/deploy-functions.sh | sed -n '577,645p'
nl -ba scripts/deploy-functions.sh | sed -n '800,855p'
nl -ba scripts/deploy-functions.sh | sed -n '930,970p'
rg -n -- '--only|functions:\\"'$|functions:'"' scripts/deploy-functions.sh | tail -30
rg -n \"getFirebaseConfig\\(\" node_modules/firebase-tools/lib/deploy/functions node_modules/firebase-tools/lib -g '*.js' | head -30
rg -n \"adminSdkConfig|locationId\" node_modules/firebase-tools/lib -g '*.d.ts' -g '*.js' | head -80" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
   577	read_back() {   # <msg file>
   578	  local msg="$1" after="${WORK}/after.json" reasons id uri res cls n_ref=0 n_ans=0 n=0 cfg exp
   579	  cfg="$("$JQ" -r .firebaseConfigEnv "$DISC")"
   580	  exp="$("$JQ" -c .expectedHashes "$DISC")"
   581	  AFTER_OK=0
   582	  if list_live "$TMP" "$after"; then
   583	    AFTER_OK=1
   584	    AFTER_DIGEST="$(digest_of "$after")"
   585	    reasons="$("$JQ" -r --argjson m "$("$JQ" -c .manifest "$DISC")" \
   586	       --argjson dc "$("$JQ" -c --arg cb "$CB" 'to_entries | map(select(.key | startswith($cb + "/")) | {key: (.key | ltrimstr($cb + "/")), value: .value}) | from_entries' "${TMP}/functions/declarations.json")" \
   587	       --argjson exp "$exp" --arg cfg "$cfg" --arg cb "$CB" --arg project "$PROJECT" --arg region "$REGION" \
   588	       --argjson envkeys "$ENV_KEYS" "$JQ_F8" "$after" 2>&1)" || reasons="could not evaluate the read-back: ${reasons}"
   589	    if [ -z "$reasons" ]; then DEPLOY_MATCH=yes; else DEPLOY_MATCH=no; fi
   590	  else
   591	    AFTER_DIGEST=unknown; DEPLOY_MATCH=unknown
   592	    reasons="functions:list failed or returned malformed JSON: $(list_why "$after")"
   593	  fi
   594	  if [ "$BEFORE_DIGEST" = unknown ] || [ "$AFTER_DIGEST" = unknown ]; then FUNCTIONS_UNCHANGED=unknown
   595	  elif [ "$BEFORE_DIGEST" = "$AFTER_DIGEST" ]; then FUNCTIONS_UNCHANGED=yes; else FUNCTIONS_UNCHANGED=no; fi
   596	  {
   597	    printf 'after_digest=%s\nfunctions_unchanged=%s\ndeploy_match=%s\n' "$AFTER_DIGEST" "$FUNCTIONS_UNCHANGED" "$DEPLOY_MATCH"
   598	    if [ -n "$reasons" ]; then printf 'mismatch=%s\n' "$(printf '%s' "$reasons" | tr '\n' '|' )"; fi
   599	  } >> "$msg"
   600	  say "─── read-back ───"
   601	  say "deploy_match: ${DEPLOY_MATCH}"
   602	  [ -z "$reasons" ] || printf '%s\n' "$reasons" | sed 's/^/  - /'
   603	  if [ "$AFTER_OK" = 1 ] && printf '%s' "$reasons" | grep -q 'FIREBASE_CONFIG differs'; then
   604	    # The admin-SDK config (project id, bucket, location): public, and the same content as the pinned file, so shown.
   605	    say "  live FIREBASE_CONFIG: $("$JQ" -r --arg cb "$CB" '[.result[] | select((.codebase // "default") == $cb)][0].environmentVariables.FIREBASE_CONFIG // "absent"' "$after")"
   606	    say "  pinned (functions/firebase-config.json): ${cfg}"
   607	  fi
   608	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   609	    printf 'live_hash.%s=%s\n' "$id" "$( [ "$AFTER_OK" = 1 ] && "$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "absent"' "$after" || echo unknown)" >> "$msg"
   610	  done
   611	  say "─── unauthenticated probe (no credentials) ───"
   612	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   613	    n=$((n + 1))
   614	    uri=""
   615	    [ "$AFTER_OK" = 1 ] && uri="$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].uri // ""' "$after")"
   616	    if [ -z "$uri" ]; then res="inconclusive no-uri -"; else res="$(probe_one "$uri")"; fi
   617	    cls="${res%% *}"
   618	    case "$cls" in refused) n_ref=$((n_ref + 1)) ;; answered) n_ans=$((n_ans + 1)) ;; esac
   619	    printf 'access.%s=%s\nprobe.%s=%s\n' "$id" "$cls" "$id" "${res#* }" >> "$msg"
   620	    say "  ${id}: ${res}"
   621	  done
   622	  if [ "$n_ans" -gt 0 ]; then ACCESS=answered; elif [ "$n" -gt 0 ] && [ "$n_ref" = "$n" ]; then ACCESS=refused; else ACCESS=inconclusive; fi
   623	  if [ "$CLI_EXIT" = 0 ] && [ "$BACKSTOP_SEEN" = yes ] && [ "$SKIP_SEEN" = no ] && [ "$DEPLOY_MATCH" = yes ] && [ "$ACCESS" = refused ]; then
   624	    DEPLOY_VERIFIED=yes
   625	  else
   626	    DEPLOY_VERIFIED=no
   627	  fi
   628	  {
   629	    printf 'access=%s\n' "$ACCESS"
   630	    printf 'not_proven=refused does not prove the absence of grants to all Google accounts, to named principals, or at project, folder or organization level (--attest records those)\n'
   631	    printf 'deploy_verified=%s\n' "$DEPLOY_VERIFIED"
   632	  } >> "$msg"
   633	  say "access: ${ACCESS}   deploy_verified: ${DEPLOY_VERIFIED}"
   634	}
   635	transcript_flags() {   # <transcript> <sha> — sets BACKSTOP_SEEN and SKIP_SEEN ("unknown" when there is no transcript)
   636	  local line="predeploy-check: functions codebase ${CB} for ${PROJECT} matches commit ${2:0:12} (tree ${TREE}); sealed manifest ${MSHA} in place"
   637	  if [ ! -f "$1" ]; then BACKSTOP_SEEN=unknown; SKIP_SEEN=unknown; return 0; fi
   638	  if grep -qF -- "$line" "$1"; then BACKSTOP_SEEN=yes; else BACKSTOP_SEEN=no; fi
   639	  if grep -qF -- "$SKIP_LINE" "$1"; then SKIP_SEEN=yes; else SKIP_SEEN=no; fi
   640	}
   641	verifier_fields() {   # <attempt commit> <msg> — F9: record the verifier and whether the guard's code changed since
   642	  # The checks and verdicts (F8, the probe, the evidence) are this script's — the tip's, proven byte-equal above.
   643	  # Rebuilding an attempt's expected state (--reconcile, --reverify) deliberately uses the ATTEMPT's own backstop,
   644	  # discovery and hash module, because they are what produced the manifest and hash it recorded; their output must then
   645	  # equal those recorded values. The record names both commits, so the provenance is never mixed silently.
   800	  BEFORE="${WORK}/before.json"
   801	  list_live "$TMP" "$BEFORE" || die $EX_FETCH "could not read production (functions:list): $(list_why "$BEFORE") — nothing was deployed."
   802	  BEFORE_DIGEST="$(digest_of "$BEFORE")"
   803	  DRIFT="$("$JQ" -r --arg cb "$CB" --argjson envkeys "$ENV_KEYS" --argjson ids "$IDS_JSON" "$JQ_DRIFT" "$BEFORE" 2>&1)" \
   804	    || die $EX_DRIFT "could not check production for drift: ${DRIFT}"
   805	  [ -z "$DRIFT" ] || die $EX_DRIFT "production has something this deploy would carry over or can't handle — NOTHING WAS DEPLOYED:
   806	$(printf '%s\n' "$DRIFT" | sed 's/^/  - /')"
   807	
   808	  # The in-flight file (F9): written atomically BEFORE the CLI, so a crash from here on leaves an honest trace.
   809	  TRANSCRIPT="${TRANSCRIPTS}/functions-${CB}-${STAMP}-${SHA:0:7}.log"
   810	  {
   811	    printf 'format=tinker-functions-inflight-1\ncodebase=%s\nattempt=%s\nstamp=%s\ncommit=%s\ntree=%s\n' "$CB" "$TAG" "$STAMP" "$SHA" "$TREE"
   812	    printf 'manifest_sha256=%s\nbefore_digest=%s\nfunctions=%s\ntranscript=%s\nverifier=%s\n' "$MSHA" "$BEFORE_DIGEST" "$IDS" "$TRANSCRIPT" "$MAIN_SHA"
   813	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   814	      printf 'expected_hash.%s=%s\n' "$id" "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")"
   815	      printf 'before_hash.%s=%s\n' "$id" "$("$JQ" -r --arg cb "$CB" --arg id "$id" '[.result[] | select((.codebase // "default") == $cb and .id == $id)][0].hash // "none"' "$BEFORE")"
   816	    done
   817	  } | atomic_write "$INFLIGHT" || die $EX_INFLIGHT "could not write ${INFLIGHT} — nothing was deployed."
   818	  inflight_valid || die $EX_INFLIGHT "${INFLIGHT} did not read back as written — nothing was deployed; remove it by hand."
   819	
   820	  # The CLI. TINKER_DEPLOY_* are exported, never inline (K15). Never --force.
   821	  say "─── firebase deploy --only functions:${CB} --project ${PROJECT} (in ${TMP}) ───"
   822	  set +e
   823	  (
   824	    export TINKER_DEPLOY_SHA="$SHA" TINKER_DEPLOY_CODEBASE="$CB" TINKER_DEPLOY_MANIFEST_PATH="$MPATH" TINKER_DEPLOY_MANIFEST_SHA256="$MSHA"
   825	    cli "$TMP" deploy --only "functions:${CB}" --project "$PROJECT" --non-interactive
   826	  ) 2>&1 | tee "$TRANSCRIPT"
   827	  CLI_EXIT="${PIPESTATUS[0]}"
   828	  set -e
   829	  { cat "$INFLIGHT"; printf 'cli_exit=%s\n' "$CLI_EXIT"; } | atomic_write "$INFLIGHT" || warn "could not add cli_exit to ${INFLIGHT} (a --reconcile will record cli_exit=unknown)"
   830	  transcript_flags "$TRANSCRIPT" "$SHA"
   831	  say "cli_exit=${CLI_EXIT}  backstop_seen=${BACKSTOP_SEEN}  skip_line_seen=${SKIP_SEEN}"
   832	
   833	  MSG="${WORK}/record"
   834	  {
   835	    printf 'format=tinker-functions-attempt-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\ntree=%s\n' "$PROJECT" "$CB" "$TAG" "$SHA" "$TREE"
   836	    printf 'manifest_sha256=%s\nfunctions=%s\nbefore_digest=%s\n' "$MSHA" "$IDS" "$BEFORE_DIGEST"
   837	    for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   838	      printf 'expected_hash.%s=%s\nbefore_hash.%s=%s\n' "$id" "$(inflight_get "expected_hash.${id}")" "$id" "$(inflight_get "before_hash.${id}")"
   839	    done
   840	    printf 'cli_exit=%s\nbackstop_seen=%s\nskip_line_seen=%s\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   841	  } > "$MSG"
   842	  read_back "$MSG"
   843	  verifier_fields "$SHA" "$MSG"
   844	  printf 'at=%s\nby=deploy-functions.sh --approved\n' "$STAMP" >> "$MSG"
   845	  PUSHED=0; write_record "$TAG" "$SHA" "$MSG" && PUSHED=1
   846	  rm -f "$INFLIGHT"
   847	  [ "$PUSHED" = 1 ] || exit $EX_RECEIPT
   848	  attest_help
   849	  if [ "$DEPLOY_VERIFIED" = yes ]; then say "✔ deployed ${CB} at ${SHA:0:12}; verified; record ${TAG} published."; exit 0; fi
   850	  printf 'NOT VERIFIED: attempt %s is recorded with deploy_verified=no (see above). Production may have changed; nothing more is deployed.\nAfter the cause is fixed and committed: --reverify %s (FUNCTIONS-ROLLBACK.md).\n' "$TAG" "$TAG" >&2
   851	  exit $EX_UNVERIFIED
   852	fi
   853	
   854	# ─── --reconcile / --clear-inflight ────────────────────────────────────────────────────────────────────
   855	if [ "$MODE" = "reconcile" ] || [ "$MODE" = "clear-inflight" ]; then
   930	SHA="$(commit_of "$NEWEST")"
   931	for k in commit manifest_sha256 functions tree; do
   932	  record_field "$NEWEST" "$k" >/dev/null || die $EX_RECORD "the attempt ${NEWEST} has no readable ${k} — refusing."
   933	done
   934	[ "$(record_field "$NEWEST" commit)" = "$SHA" ] || die $EX_RECORD "the attempt ${NEWEST} names a different commit than it points at."
   935	IDS="$(record_field "$NEWEST" functions)"
   936	IDS_JSON="$(printf '%s' "$IDS" | "$JQ" -R -c 'split(",") | sort')"
   937	MSG="${WORK}/record"
   938	
   939	if [ "$MODE" = "reverify" ]; then
   940	  : > "$MSG"
   941	  verifier_fields "$SHA" "$MSG"
   942	  CLI_EXIT="$(record_field "$NEWEST" cli_exit)" || die $EX_RECORD "the attempt ${NEWEST} has no readable cli_exit."
   943	  BACKSTOP_SEEN="$(record_word "$NEWEST" backstop_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable backstop_seen."
   944	  SKIP_SEEN="$(record_word "$NEWEST" skip_line_seen "yes no unknown")" || die $EX_RECORD "the attempt ${NEWEST} has no readable skip_line_seen."
   945	  BEFORE_DIGEST="$(record_field "$NEWEST" before_digest)" || die $EX_RECORD "the attempt ${NEWEST} has no readable before_digest."
   946	  build_expected "$SHA"
   947	  [ "$MSHA" = "$(record_field "$NEWEST" manifest_sha256)" ] || die $EX_MANIFEST "the rebuilt manifest (${MSHA}) is not the attempt's."
   948	  [ "$TREE" = "$(record_field "$NEWEST" tree)" ] || die $EX_MANIFEST "the rebuilt tree is not the attempt's."
   949	  [ "$IDS" = "$(record_field "$NEWEST" functions)" ] || die $EX_MANIFEST "the rebuilt function set is not the attempt's."
   950	  for id in $(printf '%s' "$IDS" | tr ',' ' '); do
   951	    [ "$("$JQ" -r --arg id "$id" '.expectedHashes[$id]' "$DISC")" = "$(record_field "$NEWEST" "expected_hash.${id}" || echo missing)" ] \
   952	      || die $EX_MANIFEST "the rebuilt expected hash for ${id} is not the one the attempt recorded."
   953	  done
   954	  reserve_stamp "$VERIFY_PREFIX" "${SHA:0:7}"
   955	  VMSG="${WORK}/verify"
   956	  {
   957	    printf 'format=tinker-functions-verify-1\nproject=%s\ncodebase=%s\nattempt=%s\ncommit=%s\n' "$PROJECT" "$CB" "$NEWEST" "$SHA"
   958	    printf 'carried=cli_exit=%s backstop_seen=%s skip_line_seen=%s (from the attempt)\n' "$CLI_EXIT" "$BACKSTOP_SEEN" "$SKIP_SEEN"
   959	  } > "$VMSG"
   960	  read_back "$VMSG"
   961	  cat "$MSG" >> "$VMSG"
   962	  printf 'at=%s\nby=deploy-functions.sh --reverify\n' "$STAMP" >> "$VMSG"
   963	  write_record "$TAG" "$SHA" "$VMSG" || exit $EX_RECEIPT
   964	  say "✔ verify record ${TAG} for ${NEWEST}: deploy_verified=${DEPLOY_VERIFIED}."
   965	  [ "$DEPLOY_VERIFIED" = yes ] && exit 0
   966	  exit $EX_UNVERIFIED
   967	fi
   968	
   969	# --attest
   970	[ -f "$EVIDENCE" ] || die $EX_EVIDENCE "--evidence ${EVIDENCE} is not a file."
98:cd "$REPO" || { echo "deploy-functions: repo not found at $REPO" >&2; exit $EX_USAGE; }
99:git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "deploy-functions: $REPO is not a git repository" >&2; exit $EX_USAGE; }
197:# One canonical snapshot of functions:list (F8 step 1): functions sorted by (codebase, region, id); keys and labels
327:# functions:list → <out>. Returns 1 for a list error or JSON that isn't the expected shape (F8: "unknown").
329:  cli "$1" functions:list --json --project "$PROJECT" > "$2" 2> "$2.err" || { list_error "$2"; return 1; }
332:list_error() {   # <out> — why functions:list failed: its --json error body (stdout) and stderr, in one line
592:    reasons="functions:list failed or returned malformed JSON: $(list_why "$after")"
661:      functions: ($ids | split(",") | map({key: ., value: {buildId: "<Cloud Build → History → the build id>", buildStatus: "<its status>",
780:  say "manifest:  ${MSHA}  (functions: ${IDS})"
801:  list_live "$TMP" "$BEFORE" || die $EX_FETCH "could not read production (functions:list): $(list_why "$BEFORE") — nothing was deployed."
821:  say "─── firebase deploy --only functions:${CB} --project ${PROJECT} (in ${TMP}) ───"
825:    cli "$TMP" deploy --only "functions:${CB}" --project "$PROJECT" --non-interactive
909:  list_live "$TMP" "$NOW" || die $EX_FETCH "could not read production (functions:list): $(list_why "$NOW") — try again."
node_modules/firebase-tools/lib/deploy/functions/prepare.js:65:    const firebaseConfig = await functionsConfig.getFirebaseConfig(options);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:65:    const firebaseConfig = await functionsConfig.getFirebaseConfig(options);
node_modules/firebase-tools/lib/functions/iac/export.js:17:    const firebaseConfig = await functionsConfig.getFirebaseConfig(options);
node_modules/firebase-tools/lib/functionsConfig.js:102:async function getFirebaseConfig(options) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:357:            const firebaseConfig = this.getFirebaseConfig();
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1004:    getFirebaseConfig() {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1026:            FIREBASE_CONFIG: this.getFirebaseConfig(),
node_modules/firebase-tools/lib/commands/functions-delete.js:35:        functionsConfig.getFirebaseConfig(options),
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:115:            const locationId = req.params.location_id;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:124:            const key = `queue:${projectId}-${locationId}-${queueName}`;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:157:            const locationId = req.params.location_id;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:159:            const queueKey = `queue:${projectId}-${locationId}-${queueName}`;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:167:                    `/projects/${projectId}/locations/${locationId}/queues/${queueName}/tasks/${Math.floor(Math.random() * Number.MAX_SAFE_INTEGER)}`;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:182:            const locationId = req.params.location_id;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:185:            const queueKey = `queue:${projectId}-${locationId}-${queueName}`;
node_modules/firebase-tools/lib/emulator/tasksEmulator.js:192:                const taskName = `projects/${projectId}/locations/${locationId}/queues/${queueName}/tasks/${taskId}`;
node_modules/firebase-tools/lib/emulator/adminSdkConfig.js:41:        logger_1.logger.debug(`Detected demo- project: ${projectId}. Using default adminSdkConfig instead of calling firebase API.`);
node_modules/firebase-tools/lib/emulator/adminSdkConfig.js:49:        const res = await apiClient.get(`projects/${projectId}/adminSdkConfig`);
node_modules/firebase-tools/lib/emulator/storage/files.js:10:const adminSdkConfig_1 = require("../adminSdkConfig");
node_modules/firebase-tools/lib/emulator/storage/files.js:45:            let adminSdkConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(this._projectId);
node_modules/firebase-tools/lib/emulator/storage/files.js:46:            if (!adminSdkConfig) {
node_modules/firebase-tools/lib/emulator/storage/files.js:47:                adminSdkConfig = (0, adminSdkConfig_1.constructDefaultAdminSdkConfig)(this._projectId);
node_modules/firebase-tools/lib/emulator/storage/files.js:49:            this.createBucket(adminSdkConfig.storageBucket);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:27:const adminSdkConfig_1 = require("./adminSdkConfig");
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:103:        this.adminSdkConfig = { ...this.args.adminSdkConfig, projectId: this.args.projectId };
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:255:        if (Object.keys(this.adminSdkConfig || {}).length <= 1) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:256:            const adminSdkConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(this.args.projectId);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:257:            if (adminSdkConfig) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:258:                this.adminSdkConfig = adminSdkConfig;
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:262:                this.adminSdkConfig = (0, adminSdkConfig_1.constructDefaultAdminSdkConfig)(this.args.projectId);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1009:            if (this.adminSdkConfig.databaseURL) {
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1010:                const asUrl = new url_1.URL(this.adminSdkConfig.databaseURL);
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1016:            storageBucket: this.adminSdkConfig.storageBucket,
node_modules/firebase-tools/lib/emulator/functionsEmulator.js:1017:            databaseURL: emulatedDatabaseURL || this.adminSdkConfig.databaseURL,
node_modules/firebase-tools/lib/functionsConfig.js:96:    let appEngineLocation = config.locationId;
node_modules/firebase-tools/lib/functionsConfig.js:104:    const response = await apiClient.get(`/v1beta1/projects/${projectId}/adminSdkConfig`);
node_modules/firebase-tools/lib/apphosting/backend.js:182:    const allowedLocations = (await apphosting.listLocations(projectId)).map((loc) => loc.locationId);
node_modules/firebase-tools/lib/apphosting/backend.js:309:    const allowedLocations = (await apphosting.listLocations(projectId)).map((loc) => loc.locationId);
node_modules/firebase-tools/lib/firestore/api-sort.js:91:    return a.locationId > b.locationId ? 1 : -1;
node_modules/firebase-tools/lib/firestore/pretty-print.js:63:        table.push(["Name", clc.yellow(database.name)], ["Create Time", clc.yellow(database.createTime)], ["Last Update Time", clc.yellow(database.updateTime)], ["Type", clc.yellow(apiType)], ["Edition", clc.yellow(edition)], ["Location", clc.yellow(database.locationId)], ["Delete Protection State", clc.yellow(database.deleteProtectionState)], ["Point In Time Recovery", clc.yellow(database.pointInTimeRecoveryEnablement)], ["Earliest Version Time", clc.yellow(database.earliestVersionTime)], ["Version Retention Period", clc.yellow(database.versionRetentionPeriod)]);
node_modules/firebase-tools/lib/firestore/pretty-print.js:172:            .map((location) => [location.displayName, location.locationId]));
node_modules/firebase-tools/lib/firestore/api.js:554:            locationId: req.locationId,
node_modules/firebase-tools/lib/extensions/extensionsHelper.js:46:const adminSdkConfig_1 = require("../emulator/adminSdkConfig");
node_modules/firebase-tools/lib/extensions/extensionsHelper.js:116:        ? await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(projectId)
node_modules/firebase-tools/lib/gcp/ailogic.js:92:            locationId: endpoint.region,
node_modules/firebase-tools/lib/deploy/functions/services/storage.js:68:    const locationId = bucket.location.toLowerCase();
node_modules/firebase-tools/lib/deploy/functions/services/storage.js:69:    return location_1.STORAGE_MULTI_REGION_TO_REGION_MAPPING[locationId] || locationId;
node_modules/firebase-tools/lib/dataconnect/types.js:14:function toDatasource(projectId, locationId, ds) {
node_modules/firebase-tools/lib/dataconnect/types.js:21:                    instance: `projects/${projectId}/locations/${locationId}/instances/${ds.postgresql.cloudSql.instanceId}`,
node_modules/firebase-tools/lib/deploy/functions/services/firestore.js:41:    const dbRegion = db.locationId;
node_modules/firebase-tools/lib/deploy/functions/services/firestore.js:55:    const locationId = db.locationId.toLowerCase();
node_modules/firebase-tools/lib/deploy/functions/services/firestore.js:56:    return location_1.FIRESTORE_DUAL_REGION_TO_REGION_MAPPING[locationId] || locationId;
node_modules/firebase-tools/lib/commands/firestore-databases-create.js:16:    .option("--location <locationId>", "region to create database, for example 'nam5'. Run 'firebase firestore:locations' to get a list of eligible locations (required)")
node_modules/firebase-tools/lib/commands/firestore-databases-create.js:99:        locationId: options.location,
node_modules/firebase-tools/lib/commands/projects-list.js:31:            (resources && resources.locationId) || NOT_SPECIFIED,
node_modules/firebase-tools/lib/dataconnect/client.js:29:    return res.body?.locations?.map((l) => l.locationId) ?? [];
node_modules/firebase-tools/lib/dataconnect/client.js:39:async function createService(projectId, locationId, serviceId) {
node_modules/firebase-tools/lib/dataconnect/client.js:41:        const op = await dataconnectClient().post(`/projects/${projectId}/locations/${locationId}/services`, {
node_modules/firebase-tools/lib/dataconnect/client.js:42:            name: `projects/${projectId}/locations/${locationId}/services/${serviceId}`,
node_modules/firebase-tools/lib/commands/firestore-backups-list.js:13:    .option("-l, --location <locationId>", "location to search for backups, for example 'nam5'. Run 'firebase firestore:locations' to get a list of eligible locations. Defaults to all locations")
node_modules/firebase-tools/lib/commands/internaltesting-functions-discover.js:8:const adminSdkConfig_1 = require("../emulator/adminSdkConfig");
node_modules/firebase-tools/lib/commands/internaltesting-functions-discover.js:19:    const firebaseConfig = await (0, adminSdkConfig_1.getProjectAdminSdkConfigOrCached)(projectId);
node_modules/firebase-tools/lib/mcp/tools/core/init.js:182:            locationId: features.firestore.location_id,
node_modules/firebase-tools/lib/mcp/tools/core/init.js:198:            locationId: features.dataconnect.location_id || "",
node_modules/firebase-tools/lib/init/features/project.js:90:    setup.projectLocation = pm.resources?.locationId;
node_modules/firebase-tools/lib/commands/dataconnect-execute.js:28:    .option("--location <locationId>", "The location ID to execute against (optional if there's only one service). Ignored by the emulator.")
node_modules/firebase-tools/lib/commands/dataconnect-execute.js:42:    const locationId = options.location;
node_modules/firebase-tools/lib/commands/dataconnect-execute.js:93:        if (serviceId && (locationId || emulatorHost)) {
node_modules/firebase-tools/lib/commands/dataconnect-execute.js:94:            serviceName = `projects/${projectId}/locations/${locationId || "unused"}/services/${serviceId}`;
node_modules/firebase-tools/lib/commands/dataconnect-execute.js:170:        return (0, load_1.pickOneService)(projectId, options.config, serviceId || undefined, locationId || undefined).catch((e) => {
node_modules/firebase-tools/lib/deploy/dataconnect/deploy.js:34:        const { projectId, locationId, serviceId } = splitName(s.serviceName);
node_modules/firebase-tools/lib/deploy/dataconnect/deploy.js:35:        await client.createService(projectId, locationId, serviceId);
node_modules/firebase-tools/lib/deploy/dataconnect/deploy.js:71:        locationId: parts[3],
node_modules/firebase-tools/lib/deploy/functions/triggerRegionHelper.js:38:                    triggerRegionMap.set(backend.functionName(ep), db.locationId.toLowerCase());
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:63:        locationId: "",
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:110:    info.locationId = info.locationId || exports.FDC_DEFAULT_REGION;
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:136:    https://console.firebase.google.com/project/${setup.projectId}/dataconnect/locations/${info.locationId}/services/${info.serviceId}/schema`);
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:150:            location: info.locationId,
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:157:    const serviceName = `projects/${projectId}/locations/${info.locationId}/services/${info.serviceId}`;
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:169:    const serviceAlreadyExists = !(await (0, client_1.createService)(projectId, info.locationId, info.serviceId));
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:170:    const schemaGql = await (0, utils_1.promiseWithSpinner)(() => (0, fdcExperience_1.generateSchema)(info.appDescription, projectId, info.locationId), "Generating the SQL Connect Schema...");
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:247:    const serviceName = `projects/${projectId}/locations/${info.locationId}/services/${info.serviceId}`;
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:267:                            instance: `projects/${projectId}/locations/${info.locationId}/instances/${info.cloudSqlInstanceId}`,
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:284:                            instance: `projects/${projectId}/locations/${info.locationId}/instances/${info.cloudSqlInstanceId}`,
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:337:        locationId: "__location__",
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:394:    info.locationId = serviceName.location;
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:522:        choices = choices.filter((c) => info.locationId === "" || info.locationId === c.location);
node_modules/firebase-tools/lib/init/features/dataconnect/index.js:542:                info.locationId = choices.find((c) => c.value === info.cloudSqlInstanceId).location;

exec
/bin/zsh -lc '/opt/homebrew/opt/node@22/bin/node --test tests/unit/functions-hash.test.js' in /Users/christiehubley/my-clay-hub
 exited 1 in 169ms:
# node:fs:3054
#   return binding.mkdtemp(prefix, options.encoding);
#                  ^
# Error: EPERM: operation not permitted, mkdtemp '/var/folders/yh/8pxrmctj49v_42cbtp6v6zh40000gn/T/mch-fn-hash-XXXXXX'
#     at mkdtempSync (node:fs:3054:18)
#     at file:///Users/christiehubley/my-clay-hub/tests/unit/functions-hash.test.js:25:27
#     at ModuleJob.run (node:internal/modules/esm/module_job:343:25)
#     at async onImport.tracePromise.__proto__ (node:internal/modules/esm/loader:681:26)
#     at async asyncRunEntryPointWithESMLoader (node:internal/modules/run_main:117:5) {
#   errno: -1,
#   code: 'EPERM',
#   syscall: 'mkdtemp',
#   path: '/var/folders/yh/8pxrmctj49v_42cbtp6v6zh40000gn/T/mch-fn-hash-XXXXXX'
# }
# Node.js v22.23.3
# Subtest: tests/unit/functions-hash.test.js
not ok 1 - tests/unit/functions-hash.test.js
  ---
  duration_ms: 251.657958
  type: 'test'
  location: '/Users/christiehubley/my-clay-hub/tests/unit/functions-hash.test.js:1:1'
  failureType: 'testCodeFailure'
  exitCode: 1
  signal: ~
  error: 'test failed'
  code: 'ERR_TEST_FAILURE'
  ...
1..1
# tests 1
# suites 0
# pass 0
# fail 1
# cancelled 0
# skipped 0
# todo 0
# duration_ms 256.030625

exec
/bin/zsh -lc "rg -n \"codebase =|codebase:\" node_modules/firebase-tools/lib/deploy/functions/prepare.js node_modules/firebase-tools/lib/deploy/functions/backend.js node_modules/firebase-tools/lib/deploy/functions -g '*.js' | head -80
nl -ba node_modules/firebase-tools/lib/deploy/functions/prepare.js | sed -n '100,180p'
nl -ba node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js | sed -n '42,75p;120,155p'
nl -ba tests/unit/functions-hash.test.js | sed -n '1,110p'
git status --short" in /Users/christiehubley/my-clay-hub
 succeeded in 0ms:
node_modules/firebase-tools/lib/deploy/functions/prepare.js:99:            .filter((e) => e.codebase === codebase || e.codebase === undefined);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:134:            endpoint.codebase = codebase;
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:47:            return [{ codebase: fragments[0] }];
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:49:        return [{ codebase: projectConfig_1.DEFAULT_CODEBASE, idChunks: fragments[0].split(/[-.]/) }];
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:53:            codebase: fragments[0],
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:124:        const matchedEndpoints = endpointsToAssign.filter((e) => e.codebase === codebase);
node_modules/firebase-tools/lib/deploy/functions/functionsDeployHelper.js:136:        return noIdChunks && filter.codebase === codebase;
node_modules/firebase-tools/lib/deploy/functions/prepare.js:99:            .filter((e) => e.codebase === codebase || e.codebase === undefined);
node_modules/firebase-tools/lib/deploy/functions/prepare.js:134:            endpoint.codebase = codebase;
   100	        await resolveDefaultRegionsForBuild(wantBuild, backend.of(...relevantEndpoints));
   101	        const { backend: wantBackend, envs: resolvedEnvs } = await build.resolveBackend({
   102	            build: wantBuild,
   103	            firebaseConfig,
   104	            userEnvs,
   105	            nonInteractive: options.nonInteractive,
   106	            isEmulator: false,
   107	        });
   108	        functionsEnv.writeResolvedParams(resolvedEnvs, userEnvs, userEnvOpt);
   109	        let hasEnvsFromParams = false;
   110	        wantBackend.environmentVariables = envs;
   111	        for (const envName of Object.keys(resolvedEnvs)) {
   112	            const isList = resolvedEnvs[envName]?.legalList;
   113	            const envValue = resolvedEnvs[envName]?.toSDK();
   114	            if (envValue &&
   115	                !resolvedEnvs[envName].internal &&
   116	                (!Object.prototype.hasOwnProperty.call(wantBackend.environmentVariables, envName) || isList)) {
   117	                wantBackend.environmentVariables[envName] = envValue;
   118	                hasEnvsFromParams = true;
   119	            }
   120	        }
   121	        for (const endpoint of backend.allEndpoints(wantBackend)) {
   122	            endpoint.environmentVariables = { ...(wantBackend.environmentVariables || {}) };
   123	            let resource;
   124	            if (endpoint.platform === "gcfv1") {
   125	                resource = `projects/${endpoint.project}/locations/${endpoint.region}/functions/${endpoint.id}`;
   126	            }
   127	            else if (endpoint.platform === "gcfv2" || endpoint.platform === "run") {
   128	                resource = `projects/${endpoint.project}/locations/${endpoint.region}/services/${endpoint.id}`;
   129	            }
   130	            else {
   131	                (0, functional_1.assertExhaustive)(endpoint.platform);
   132	            }
   133	            endpoint.environmentVariables[exports.EVENTARC_SOURCE_ENV] = resource;
   134	            endpoint.codebase = codebase;
   135	        }
   136	        wantBackends[codebase] = wantBackend;
   137	        if (functionsEnv.hasUserEnvs(userEnvOpt) || hasEnvsFromParams) {
   138	            codebaseUsesEnvs.push(codebase);
   139	        }
   140	        context.codebaseDeployEvents[codebase] = {
   141	            fn_deploy_num_successes: 0,
   142	            fn_deploy_num_failures: 0,
   143	            fn_deploy_num_canceled: 0,
   144	            fn_deploy_num_skipped: 0,
   145	        };
   146	        if (wantBuild.params.length > 0) {
   147	            if (wantBuild.params.every((p) => p.type !== "secret")) {
   148	                context.codebaseDeployEvents[codebase].params = "env_only";
   149	            }
   150	            else {
   151	                context.codebaseDeployEvents[codebase].params = "with_secrets";
   152	            }
   153	        }
   154	        else {
   155	            context.codebaseDeployEvents[codebase].params = "none";
   156	        }
   157	        context.codebaseDeployEvents[codebase].runtime = wantBuild.runtime;
   158	    }
   159	    validate.endpointsAreUnique(wantBackends);
   160	    context.sources = {};
   161	    for (const [codebase, wantBackend] of Object.entries(wantBackends)) {
   162	        const cfg = (0, projectConfig_1.configForCodebase)(context.config, codebase);
   163	        const localCfg = (0, projectConfig_1.requireLocal)(cfg, "Remote sources are not supported.");
   164	        const sourceDirName = localCfg.source;
   165	        const sourceDir = options.config.path(sourceDirName);
   166	        const source = {};
   167	        if (backend.someEndpoint(wantBackend, () => true)) {
   168	            (0, utils_1.logLabeledBullet)("functions", `preparing ${clc.bold(sourceDirName)} directory for uploading...`);
   169	        }
   170	        if (backend.someEndpoint(wantBackend, (e) => e.platform === "gcfv2" || e.platform === "run")) {
   171	            const schPathSet = new Set();
   172	            for (const e of backend.allEndpoints(wantBackend)) {
   173	                if (backend.isDataConnectGraphqlTriggered(e) &&
   174	                    e.dataConnectGraphqlTrigger.schemaFilePath) {
   175	                    schPathSet.add(e.dataConnectGraphqlTrigger.schemaFilePath);
   176	                }
   177	            }
   178	            const exportType = backend.someEndpoint(wantBackend, (e) => e.platform === "run")
   179	                ? "tar.gz"
   180	                : "zip";
    42	function parseFunctionSelector(selector, config) {
    43	    const fragments = selector.split(":");
    44	    if (fragments.length < 2) {
    45	        const codebaseNames = config.map((c) => c.codebase);
    46	        if (codebaseNames.includes(fragments[0])) {
    47	            return [{ codebase: fragments[0] }];
    48	        }
    49	        return [{ codebase: projectConfig_1.DEFAULT_CODEBASE, idChunks: fragments[0].split(/[-.]/) }];
    50	    }
    51	    return [
    52	        {
    53	            codebase: fragments[0],
    54	            idChunks: fragments[1].split(/[-.]/),
    55	        },
    56	    ];
    57	}
    58	function getEndpointFilters(options, config) {
    59	    if (!options.only) {
    60	        return undefined;
    61	    }
    62	    const selectors = options.only.split(",");
    63	    const filters = [];
    64	    for (let selector of selectors) {
    65	        if (selector.startsWith("functions:")) {
    66	            selector = selector.replace("functions:", "");
    67	            if (selector.length > 0) {
    68	                filters.push(...parseFunctionSelector(selector, config));
    69	            }
    70	        }
    71	    }
    72	    if (filters.length === 0) {
    73	        return undefined;
    74	    }
    75	    return filters;
   120	        grouped[codebase] = backend.of(...endpointsToAssign.filter((e) => names.includes(backend.functionName(e))));
   121	        endpointsToAssign = endpointsToAssign.filter((e) => !names.includes(backend.functionName(e)));
   122	    }
   123	    for (const codebase of Object.keys(wantBackends)) {
   124	        const matchedEndpoints = endpointsToAssign.filter((e) => e.codebase === codebase);
   125	        grouped[codebase] = backend.merge(grouped[codebase], backend.of(...matchedEndpoints));
   126	        const matchedNames = matchedEndpoints.map((e) => backend.functionName(e));
   127	        endpointsToAssign = endpointsToAssign.filter((e) => {
   128	            return !matchedNames.includes(backend.functionName(e));
   129	        });
   130	    }
   131	    return grouped;
   132	}
   133	function isCodebaseFiltered(codebase, filters) {
   134	    return filters.some((filter) => {
   135	        const noIdChunks = (filter.idChunks || []).length === 0;
   136	        return noIdChunks && filter.codebase === codebase;
   137	    });
   138	}
   139	function isEndpointFiltered(endpoint, filters) {
   140	    return filters.some((filter) => endpointMatchesFilter(endpoint, filter));
   141	}
     1	// scripts/lib/functions-hash.mjs: the hash the pinned CLI (15.22.3) will stamp on each function, computed with the
     2	// CLI's own functions over a throwaway folder (plan firebase-functions-deploy-guard, F8 and K17). Runs on the host
     3	// Node; it needs only the root firebase-tools install, no codebase install and no network.
     4	import { test, after } from 'node:test';
     5	import assert from 'node:assert/strict';
     6	import { createHash } from 'node:crypto';
     7	import { chmodSync, mkdirSync, mkdtempSync, readFileSync, realpathSync, renameSync, rmSync, writeFileSync } from 'node:fs';
     8	import { createRequire } from 'node:module';
     9	import { tmpdir } from 'node:os';
    10	import { join } from 'node:path';
    11	import { fileURLToPath } from 'node:url';
    12	import { expectedHashes } from '../../scripts/lib/functions-hash.mjs';
    13	
    14	const ROOT = fileURLToPath(new URL('../../', import.meta.url));
    15	const require = createRequire(join(ROOT, 'package.json'));
    16	const { yamlToBuild } = require('firebase-tools/lib/deploy/functions/runtimes/discovery/index.js');
    17	const ENTRY = JSON.parse(readFileSync(join(ROOT, 'firebase.json'), 'utf8')).functions.find((f) => f.codebase === 'core');
    18	const CONFIG = JSON.parse(readFileSync(join(ROOT, 'functions/firebase-config.json'), 'utf8'));
    19	const CANARY = {
    20	  availableMemoryMb: 256, timeoutSeconds: 10, minInstances: 0, maxInstances: 1, ingressSettings: 'ALLOW_ALL', concurrency: 1,
    21	  serviceAccountEmail: 'canary@my-clay-hub.iam.gserviceaccount.com', vpc: null, platform: 'gcfv2', cpu: 1,
    22	  region: ['us-central1'], labels: {}, httpsTrigger: { invoker: ['private'] }, entryPoint: 'canary',
    23	};
    24	const sha1 = (x) => createHash('sha1').update(x).digest('hex');
    25	const base = realpathSync(mkdtempSync(join(tmpdir(), 'mch-fn-hash-')));
    26	after(() => rmSync(base, { recursive: true, force: true }));
    27	
    28	let n = 0;
    29	function folder() {
    30	  const dir = join(base, `src${n++}`);
    31	  mkdirSync(join(dir, 'lib'), { recursive: true });
    32	  writeFileSync(join(dir, 'index.js'), "exports.canary = 1;\n");
    33	  writeFileSync(join(dir, 'lib/util.js'), "module.exports = 2;\n");
    34	  writeFileSync(join(dir, 'package.json'), '{"name":"core"}\n');
    35	  // What the ignore list leaves out: installed dependencies and the sealed manifest.
    36	  mkdirSync(join(dir, 'node_modules/x'), { recursive: true });
    37	  writeFileSync(join(dir, 'node_modules/x/index.js'), 'ignored\n');
    38	  writeFileSync(join(dir, 'functions.yaml'), 'ignored\n');
    39	  return dir;
    40	}
    41	const hashOf = (dir, cfg = CONFIG, endpoints = { canary: CANARY }) => expectedHashes({
    42	  root: ROOT, sourceDir: dir, codebase: 'core', entry: ENTRY, project: 'my-clay-hub', firebaseConfig: cfg,
    43	  build: yamlToBuild({ specVersion: 'v1alpha1', endpoints, requiredAPIs: [] }, 'my-clay-hub', 'us-central1', 'nodejs22'),
    44	});
    45	
    46	test('equals K17 recomputed independently: sha1(sourceHash + envHash + secretsHash)', async () => {
    47	  const dir = folder();
    48	  const { sourceHash, hashes } = await hashOf(dir);
    49	  const files = ['index.js', 'lib/util.js', 'package.json'].map((f) => sha1(readFileSync(join(dir, f))));
    50	  assert.equal(sourceHash, sha1(files.sort().join('')), 'the source hash covers exactly the files the ignore list keeps');
    51	  const envHash = sha1(JSON.stringify({ FIREBASE_CONFIG: JSON.stringify(CONFIG), GCLOUD_PROJECT: 'my-clay-hub' }));
    52	  assert.deepEqual(hashes, { canary: sha1(sourceHash + envHash + sha1('{}')) });
    53	});
    54	
    55	test('does not change the entry it was given (packageSource pushes onto ignore)', async () => {
    56	  const before = JSON.stringify(ENTRY);
    57	  await hashOf(folder());
    58	  assert.equal(JSON.stringify(ENTRY), before);
    59	});
    60	
    61	test('a changed byte changes it; a rename or a mode-only change does not (bytes only — F3 covers those)', async () => {
    62	  const a = folder(); const { hashes: h } = await hashOf(a);
    63	  const b = folder(); writeFileSync(join(b, 'lib/util.js'), "module.exports = 3;\n");
    64	  assert.notEqual((await hashOf(b)).hashes.canary, h.canary);
    65	  const c = folder(); renameSync(join(c, 'lib/util.js'), join(c, 'lib/renamed.js'));
    66	  assert.equal((await hashOf(c)).hashes.canary, h.canary);
    67	  const d = folder(); chmodSync(join(d, 'index.js'), 0o755);
    68	  assert.equal((await hashOf(d)).hashes.canary, h.canary);
    69	  const e = folder(); writeFileSync(join(e, 'node_modules/x/index.js'), 'changed, still ignored\n'); writeFileSync(join(e, 'functions.yaml'), 'x\n');
    70	  assert.equal((await hashOf(e)).hashes.canary, h.canary, 'node_modules and functions.yaml are ignored');
    71	});
    72	
    73	test('FIREBASE_CONFIG is part of it, key order included (so the pinned file must match the live body exactly)', async () => {
    74	  const dir = folder();
    75	  const { hashes: h } = await hashOf(dir);
    76	  assert.notEqual((await hashOf(dir, { ...CONFIG, locationId: 'us-central' })).hashes.canary, h.canary);
    77	  const reordered = Object.fromEntries(Object.entries(CONFIG).reverse());
    78	  assert.notEqual((await hashOf(dir, reordered)).hashes.canary, h.canary);
    79	});
    80	
    81	test('every function of a codebase gets the same hash (no secrets; one source; one env)', async () => {
    82	  const { hashes } = await hashOf(folder(), CONFIG, { canary: CANARY, other: { ...CANARY, entryPoint: 'other' } });
    83	  assert.deepEqual(Object.keys(hashes).sort(), ['canary', 'other']);
    84	  assert.equal(hashes.canary, hashes.other);
    85	});
    86	
    87	test('the pinned FIREBASE_CONFIG file is this project, in the adminSdkConfig shape', () => {
    88	  assert.equal(CONFIG.projectId, 'my-clay-hub');
    89	  for (const [k, v] of Object.entries(CONFIG)) {
    90	    assert.ok(['projectId', 'databaseURL', 'storageBucket', 'locationId'].includes(k), k);
    91	    assert.equal(typeof v, 'string');
    92	  }
    93	});
    94	
    95	test('the pin is the live FIREBASE_CONFIG the first deploy read back (D2-5), byte for byte', () => {
    96	  // The guessed "locationId":"nam5" was wrong: the live value has no locationId. Change this only from a guard
    97	  // read-back that prints a different live value (FUNCTIONS-ROLLBACK.md §8).
    98	  assert.equal(readFileSync(join(ROOT, 'functions/firebase-config.json'), 'utf8'),
    99	    '{"projectId":"my-clay-hub","storageBucket":"my-clay-hub.firebasestorage.app"}\n');
   100	});
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-pPbUUMiz' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-XYOpsv9S' (errno=Operation not permitted)

codex
ready

Blocking: none.

Should-fix: none.

Nit: none.

Key confirmations:

- Firebase CLI 15.22.3 fetches `/v1beta1/projects/my-clay-hub/adminSdkConfig` and directly applies `JSON.stringify(response.body)` ([functionsConfig.js:102](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/functionsConfig.js:102), [env.js:247](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/functions/env.js:247)). The new pin matches the observed live value and key order.
- The value is project-dependent, not account-dependent. It could legitimately change later—for example, by gaining `databaseURL` or `locationId`; JSON key order is also not an API guarantee. The guard correctly fails closed and §8 explains re-pinning.
- `--only functions:core` produces a `{codebase:"core"}` filter. The canary receives `targetedByOnly=true`, so `toSkipPredicate` is false and no unchanged-functions line is printed ([prepare.js:299](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:299), [planner.js:27](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/release/planner.js:27)).
- `shouldUploadBeSkipped` returns false whenever filters are present ([deploy.js:139](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/deploy.js:139)).
- An identical before/after digest merely records `functions_unchanged=yes`; verification does not require it to be `no` ([deploy-functions.sh:594](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:594), [deploy-functions.sh:623](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:623)).
- The literal-content regression test and documentation changes are sound.

The permitted test could not execute in this read-only environment: its module-level `mkdtempSync` failed with `EPERM`. This was a sandbox filesystem failure, not a test assertion failure.
tokens used
49,383
ready

Blocking: none.

Should-fix: none.

Nit: none.

Key confirmations:

- Firebase CLI 15.22.3 fetches `/v1beta1/projects/my-clay-hub/adminSdkConfig` and directly applies `JSON.stringify(response.body)` ([functionsConfig.js:102](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/functionsConfig.js:102), [env.js:247](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/functions/env.js:247)). The new pin matches the observed live value and key order.
- The value is project-dependent, not account-dependent. It could legitimately change later—for example, by gaining `databaseURL` or `locationId`; JSON key order is also not an API guarantee. The guard correctly fails closed and §8 explains re-pinning.
- `--only functions:core` produces a `{codebase:"core"}` filter. The canary receives `targetedByOnly=true`, so `toSkipPredicate` is false and no unchanged-functions line is printed ([prepare.js:299](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/prepare.js:299), [planner.js:27](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/release/planner.js:27)).
- `shouldUploadBeSkipped` returns false whenever filters are present ([deploy.js:139](/Users/christiehubley/my-clay-hub/node_modules/firebase-tools/lib/deploy/functions/deploy.js:139)).
- An identical before/after digest merely records `functions_unchanged=yes`; verification does not require it to be `no` ([deploy-functions.sh:594](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:594), [deploy-functions.sh:623](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:623)).
- The literal-content regression test and documentation changes are sound.

The permitted test could not execute in this read-only environment: its module-level `mkdtempSync` failed with `EPERM`. This was a sandbox filesystem failure, not a test assertion failure.
