No new blocking defect. V3 correctly resolves every round-1 and round-2 BLOCKING/MEDIUM finding. One remaining live-check sequencing issue can still make the first successful deploy report failure.

## BLOCKING

None.

## MEDIUM

1. The CDN-lag retry occurs too late to protect the shell-first gate.

   [Plan:117](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:117>) says an `/index.html` mismatch stops immediately, while the one retry is specified only in the subsequent faithful-file step at [Plan:119](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:119>). This is a concrete first-deploy risk: this branch changes `index.html`, so a stale edge response produces an immediate false failure before the retry is available.

   Apply the retry to the shell-first request too—preferably to every mismatch—and make it a real second attempt using a cache-busting query keyed by the approved SHA, with a short delay. The Classbook reference already uses a cache-busting query. After the retry, the shell must still pass before private-path results are trusted.

## LOW

1. Curl has no bounded timeout.

   The flags at [Plan:111](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:111>) correctly use `-sS --location` without `--fail`, capture curl’s exit code, use fresh files, and compare explicit statuses. Add `--connect-timeout` and `--max-time` so a stalled request cannot leave a post-deploy check hanging indefinitely.

2. The private-path test list is not fully literal.

   [Plan:122](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:122>) says “notes, tests” and references wildcard categories from the earlier table. The implementation should hold one explicit, checked-in list of concrete URLs, including the four deleted tools and at least representative notes, tests, logs, package files, and function source. This is defense-in-depth because the exact manifest/live comparison already proves what static bytes were published.

3. The completeness parser must exclude fragments.

   “Every local `src`/`href`” at [Plan:90](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:90>) should explicitly exclude fragment-only values such as the existing `href="#"`, as well as absolute external URLs. The Classbook regex already excludes `#`, so a faithful adaptation will behave correctly.

## Prior-review disposition

All earlier BLOCKING and MEDIUM findings are now correctly addressed:

- File-level allowlist and committed bytes: resolved by `git archive HEAD`, the exact manifest, and the `dist`/manifest comparison.
- Round-2 candidate-set blocker: resolved by `dist-private.txt`.
- Preflight-before-approval: resolved.
- Deploy enforcement of preflight: resolved by rerunning the complete preflight.
- Exact SHA approval gate: resolved.
- Password resets as completion criterion: resolved in “Done means.”
- Missing-upstream behavior: resolved.
- Ship only exact `origin/main`: resolved by branch, upstream, fetch, and exact equality guards.
- Positive signals for all nine functions: resolved. Source confirms the seven ordinary functions return 405 JSON to GET; preview returns 401 JSON after loading the shared helper; the scheduled endpoint’s verified 403 is the appropriate positive signal.
- Completeness before upload, explicit `sw.js`, APP_SHELL normalization, maskable icons, and media-type checks: resolved.
- Expected 4xx versus curl transport errors: resolved correctly by omitting `--fail`.
- `.claude`/`node_modules` publication record: corrected.
- Git-linked-site concern: resolved subject to the recorded Sep 30 Netlify API check.
- JS-comment false reference: resolved.
- Overbroad “any new file anywhere” promise: correctly narrowed to the public-candidate set.
- Path normalization and accepted JS/CSS media types: resolved.

The post-deletion public-candidate partition is exact:

- 18 manifest files
- 3 private candidates: `firebase.json`, `package.json`, `package-lock.json`
- No overlap or extra candidate

The current pre-change tree would additionally identify the four HTML tools, but that is intentional: they are deleted in the same phase. There is no false refusal after the planned deletions.

I could not independently repeat the live probes because DNS resolution is blocked in this environment. The expected statuses agree with the handlers and the round-1 verified live results.

execution-ready no
