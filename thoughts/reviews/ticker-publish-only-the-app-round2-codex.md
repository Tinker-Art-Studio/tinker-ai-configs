Execution-ready: no. V2 fixes most round-1 findings, but one build rule will reject the current tree, and the deploy command still does not prove that preflight passed for the approved SHA.

## BLOCKING

1. The “no unlisted tracked file” set rejects three intentionally private files.

   [Plan:83](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:83>) includes every root `*.json`, while the 18-file manifest excludes:

   - `firebase.json`
   - `package.json`
   - `package-lock.json`

   After the four HTML tools are deleted, those three files remain tracked and outside the manifest. A literal implementation therefore aborts the first `build-dist.sh`.

   Define the set precisely. For example:

   - Public candidates: tracked `js/**`, `css/**`, `assets/**`, root `*.html`, root `*.json`, and root `sw.js`.
   - Explicit private exceptions: the three JSON files above.
   - Require `candidates − private_exceptions == dist-manifest.txt`.

   Alternatively, use separate public/private manifests that partition the intended tracked universe. The test at [Plan:129](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:129>) must exercise the same exact set; currently it tests only `js/css/assets`, not the root-file rule.

2. Passing preflight remains a convention, not a deploy prerequisite.

   [Plan:68](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:68>) says nothing uploads until preflight passes, but [Plan:95-103](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:95>) allows anyone holding an approved SHA to invoke `deploy.sh` without ever running `npm test`.

   This only partially resolves round-1 Codex B2. Make `deploy.sh` either:

   - rerun the complete preflight before upload, or
   - verify a tamper-resistant preflight receipt tied to the exact HEAD SHA.

   Rerunning preflight is simpler and ensures the deploy script itself enforces the stated invariant.

## MEDIUM

1. “Ship from main” is documented but not enforced, and the pushed guard allows a behind branch.

   [Plan:99-103](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:99>) checks only that `@{u}..HEAD` is empty. That rejects commits ahead of the upstream, but passes when the upstream is ahead of HEAD. It also permits deployment from any pushed feature branch.

   Require:

   - current branch exactly `main`;
   - upstream exactly `origin/main`;
   - after `git fetch`, `git rev-parse HEAD == git rev-parse @{u}`.

   The resume sequence would probably succeed as written, but the script does not preserve the claimed “origin/main is what’s live” invariant.

2. `curl --fail-with-body` needs explicit handling for expected 4xx responses.

   [Plan:104-118](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:104>) expects 404, 401, 403, and 405, but `curl --fail-with-body` exits 22 for all of them. A straightforward `set -e` implementation will abort on the first valid private 404 or function 401.

   Specify that the script captures both curl’s exit code and `%{http_code}`:

   - exit 22 is acceptable only when an expected HTTP 4xx status was actually received;
   - DNS, TLS, timeout, and connection failures remain fatal;
   - response files are newly created/truncated per request;
   - hashing occurs only for expected 200 responses;
   - add `--location` so the checked status/body are the final response.

   Without this detail, the first post-deploy check is likely to fail spuriously despite a correct deployment.

3. The literal “new file anywhere makes the build refuse” promise exceeds the proposed set.

   [Plan:65-66](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:65>) says any new file anywhere causes refusal, while [Plan:83-84](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:83>) watches only three directories and selected root extensions. A new tracked root `debug.txt`, `secret.csv`, or nested file elsewhere is silently ignored.

   Ignoring it is safe—it cannot enter `dist` through `git archive`—but it contradicts the stated refusal behavior. Either narrow acceptance to “new files in the public-candidate set” or define a complete public/private tracked-file partition.

## LOW

1. [Plan:82](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:82>) should say how paths are normalized before comparison. `find dist -type f` emits `dist/...`; the manifest contains paths relative to `dist`. Use `(cd dist && find . -type f | sed 's#^./##' | sort)` and compare against a sorted, validated manifest.

2. [Plan:109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:109>) should define accepted media types rather than merely “a JS/CSS content-type”: accept `text/css` for CSS and the expected Netlify JavaScript forms such as `application/javascript` or `text/javascript`, ignoring parameters like `charset`.

## Round-1 disposition

- Claude B1, positive function signals: correctly resolved. Source confirms preview returns 401 JSON before doing work; the seven POST-only functions return 405 JSON to GET. The scheduled function’s 403 was independently verified live in round 1.
- Claude B2, no-upstream and ship-from-main: no-upstream message resolved; ship-from-main only partially resolved because it is not enforced and the equality check is one-sided.
- Codex B1 / Claude M3, file-level allowlist and committed bytes: the `git archive` design is correct, but the candidate-set rule is wrong for the current tree.
- Codex B2, preflight before approval: workflow order is documented correctly, but deploy does not enforce that preflight passed.
- Codex B3, password reset completion gate: correctly resolved in “Done means.”
- Claude M1, `.claude`/`node_modules` record: correctly resolved.
- Claude M2 / Codex M2, completeness before upload and explicit `sw.js`: correctly resolved.
- Claude M4, `--approved <full sha>`: correctly resolved.
- Claude M5, git-linked Netlify builds: correctly resolved, assuming the stated Sep 30 API check remains authoritative.
- Claude M6, JS-comment false reference: correctly resolved by not scanning JS comments.
- Codex M1, all nine functions: correctly resolved.
- Codex M3, transport/status checking: directionally resolved, but the expected-4xx handling needs specification to avoid false failure.

The shell-first ordering is correct, the 18-file count is correct, `APP_SHELL` plus `sw.js` and both maskable icons is complete, and the proposed per-function statuses agree with the handlers. My attempted live probes could not resolve the hostname from this sandbox, so current live status confirmation relies on the round-1 verified probes rather than a new network observation.

**execution-ready: no**
