## BLOCKING

1. [scripts/check-live.sh:70](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:70) — the private-path retry can erase direct evidence of a leak.

   `shell_or_404 || { sleep 5; fetch ...; }` retries every mismatch, not just a transient 5xx. If the first response is `200` containing a private file and the second response is the shell or a 404, the check exits successfully. A successfully fetched private body is conclusive evidence and must not be retried away. This is a new false-pass introduced by the fix; it conflicts with the stated goal of preventing a single 503 from becoming a verdict.

## MEDIUM

1. [scripts/check-live.sh:100](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:100) — checking all 18 public files still does not always prove that `LIVE` reached this deploy.

   If a future deployment changes only functions, redirects, packaging, or private-path exposure while the public manifest bytes remain unchanged:

   - The deploy-specific `BASE` passes.
   - The old deployment at `LIVE` matches all 18 public files.
   - Private paths and functions are never checked on `LIVE`.
   - The script exits 0 while the main address may still expose the old deployment.

   This commit improves the index-only check but does not fully resolve its cited false-pass. It does not affect this imminent rollout: compared with live `4ac3d09`, five manifest files changed (`index.html`, three JS files, and `sw.js`).

   The missing-`deploy_url` fallback at [scripts/deploy.sh:37](/Users/christiehubley/tinker-timeclock/scripts/deploy.sh:37) inherits the same weakness because it verifies only the main address and cannot distinguish the just-created deploy from an older byte-identical one.

2. [scripts/check-live.sh:84](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:84) — “one retry per path” was not applied to functions.

   All nine function probes still make one request. A single HTTP 503 therefore becomes a hard failure, despite the cited review finding covering the function probes as well. The tests assert retries only for files and private paths.

3. [scripts/check-live.sh:52](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:52), [scripts/check-live.sh:72](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:72) — a network failure during the retry can hide the first failed response behind exit 2.

   `fail` is not set until after the retry. Thus a first `DIFF`, leaked private response, or 503 followed by a curl transport failure enters `fetch` with `fail=0` and exits “INCONCLUSIVE.” The new guard correctly preserves failures from earlier paths, but not the failure that triggered the current retry.

## LOW

1. [schedule-editor-wiring.test.js:2490](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2490), [schedule-editor-wiring.test.js:2521](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2521) — the tests pin source strings, not the new behavior.

   They do not execute mocked scenarios for:

   - first private response leaks, second passes;
   - unchanged public files with stale `LIVE`;
   - transient function 503;
   - failed retry followed by a network drop;
   - malformed/missing `deploy_url`;
   - invalid JSON or empty parser results.

   The build parser assertions prove that refusal messages exist, but not that the corresponding inputs actually refuse.

## Confirmed sound

- Netlify’s production JSON does contain `deploy_url`; the CLI defines it as required and emits the unique deploy URL separately from production `url`. It also emits `logs`. [Netlify CLI deploy source](https://github.com/netlify/cli/blob/main/src/commands/deploy/deploy.ts), [deploy documentation](https://github.com/netlify/cli/blob/main/docs/commands/deploy.md).
- On CLI failure, `set -e` stops before parsing or verification and the EXIT trap removes the temporary output. Current Netlify CLI code also attempts to cancel a created deploy when upload/deployment throws.
- `--functions netlify/functions` overrides the function directory only. The CLI separately normalizes `config.functions`, so `node_bundler` and `included_files` from `netlify.toml` remain effective.
- A `BASE` returning 404 for everything cannot pass: published files and all function probes fail.
- `done < <(private_paths)` keeps the loop in the main shell; `fail` and `priv_count` survive. `exit` inside `fetch` exits the script. There is no process-substitution scoping bug.
- Function JSON parsing now correctly verifies the expected `error` value.
- The `build-dist.sh` changes correctly handle both HTML quote styles and case, both `APP_SHELL` quote styles, invalid manifest JSON, empty icon lists, and dot/whitespace list entries. I found no new build-parser defect in this diff.

**ready to deploy — no.**
