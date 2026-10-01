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
