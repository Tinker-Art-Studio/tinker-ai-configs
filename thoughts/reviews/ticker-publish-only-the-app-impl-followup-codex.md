No BLOCKING findings. Two MEDIUM issues remain, including one new false-pass path.

## MEDIUM

1. [scripts/check-live.sh:36](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:36) — `LIVE` can false-pass when `index.html` is unchanged between deploys.

   Only live `/index.html` is compared at lines 37–43. Suppose a future deploy changes `js/app.js` but not `index.html`:

   - `LIVE/index.html` from the previous deploy matches `dist/index.html`.
   - Every new file/function passes against the deploy-specific `BASE`.
   - The script exits 0 even if the main address still serves the previous `js/app.js`.

   This does not affect the imminent deploy if its `index.html` differs from live, but it makes the reusable verification claim—“the live site is serving this deploy”—unsound. This false-pass was introduced by moving all manifest verification from `LIVE` to `BASE`.

2. [scripts/check-live.sh:85](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:85) — the cited “require JSON” finding is only partially resolved.

   `check_fn` validates `Content-Type: application/json`, but never parses the response body or compares its expected JSON shape. A generic proxy/platform response such as a 405 labeled `application/json`, or an invalid body with that header, still passes. The seven handlers consistently return `{"error":"Method not allowed"}` and preview returns `{"error":"Unauthorized"}`, so the check can verify valid JSON—and preferably those exact fields—without invoking privileged behavior.

## LOW

1. [schedule-editor-wiring.test.js:2460](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2460), [schedule-editor-wiring.test.js:2518](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2518) — the tests do not behaviorally pin most fixes.

   They inspect source text and parse today’s files, but:

   - Today’s HTML/`APP_SHELL` data does not exercise both quote styles or mixed-case attributes.
   - No test runs the build against empty parser results, dot paths, or whitespace paths.
   - Nothing simulates an unchanged live index with a changed asset.
   - Function tests assert only that `application/json` appears in the call.
   - Deploy JSON parsing, missing `deploy_url`, Netlify failure, cleanup, and `check-live` exit propagation are not exercised.

   These assertions pin wiring, not the new behavior’s failure modes.

2. [scripts/build-dist.sh:46](/Users/christiehubley/tinker-timeclock/scripts/build-dist.sh:46) — the “empty parser refuses” fix omits manifest icons.

   Empty HTML and `APP_SHELL` results refuse explicitly, but `.get("icons", [])` may produce no icon references and still pass. The test likewise permits an empty `icons` array as long as the existing 18-entry manifest remains unchanged.

## Confirmed sound

- Netlify’s current CLI defines `deploy_url` as a required JSON result field and populates it with the unique deploy URL, including production deployments. [`--json` is documented](https://github.com/netlify/cli/blob/main/docs/commands/deploy.md), and the [CLI implementation emits `deploy_url`](https://github.com/netlify/cli/blob/main/src/commands/deploy/deploy.ts).
- On deployment failure, `set -e` stops before parsing/checking, while the EXIT trap removes `OUT`. Current CLI code also cancels the created deploy when upload/deployment throws; there is no script-level partial-upload false-pass.
- `--functions netlify/functions` intentionally overrides only directory selection. The remaining `[functions]` configuration, including `node_bundler` and `included_files`, is still passed to function bundling.
- A `BASE` that 404s everything cannot pass: every manifest file fails, and all nine function probes fail. Private-path 404s alone are insufficient.
- Files, private paths, and functions consistently use `BASE`; only the propagation probe uses `LIVE`.
- `while … done < <(...)` runs the loop in the main shell, so `fail` and `priv_count` survive. `exit` inside `fetch` exits the main script, including when called from that loop. No process-substitution bug there.
- The dynamic private list now covers every non-dot tracked file outside the manifest, plus the memorial list.
- Dot-path and whitespace entries are refused before the word-splitting archive/reference operations.
- HTML quote/case parsing, dual-quote `APP_SHELL` parsing, JSON icon parsing, and the clearer stale-list message work as intended on the current files.

The all-unpublished-path and previous-snapshot findings are resolved; the function-JSON finding is not fully resolved, and the new live-index-only check creates a future false-pass.

**ready to deploy — no.**
