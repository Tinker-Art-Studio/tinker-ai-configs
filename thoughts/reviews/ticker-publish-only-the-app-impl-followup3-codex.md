## Findings

**BLOCKING:** None.

**MEDIUM**

- [scripts/check-live.sh:110](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:110) — the previously identified `LIVE` false-pass remains, though it is now accurately documented. If only functions, redirects, or private exposure change while all published files remain byte-identical, the old production deployment can pass the `LIVE` check. This does not affect this rollout because multiple published files differ from live `4ac3d09`.

**LOW**

- [schedule-editor-wiring.test.js:2539](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2539) — the new tests pin source structure, not runtime behavior. They establish that the transient-only helper exists and is called for files, private paths, and functions, but do not execute cases such as `200 leak → no retry`, `503 → retry`, or retry transport failure. This is the same testing limitation noted previously, not a new production defect.

## Review result

The blocking private-leak finding is resolved. At [scripts/check-live.sh:39](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:39), only `5xx` and `429` cause a retry. A successfully fetched `200` private body is preserved and fails; it can no longer be replaced by a later shell response or 404.

The function-retry finding is resolved at [scripts/check-live.sh:90](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:90). All nine probes now get the same transient-only retry.

The retry/network-drop finding is resolved in substance. Conclusive wrong responses are no longer retried. A transport failure following a 5xx/429 returns exit 2, which is appropriate because the only HTTP response obtained was explicitly classified as transient.

No Bash scoping issue was introduced:

- Both manifest loops run in the main shell.
- `done < <(private_paths)` preserves `fail` and `priv_count`.
- `exit` inside `fetch` terminates the script.
- `CODE` is always assigned by a successful `fetch` before the helper reads it, so `set -u` is safe.
- A deploy URL returning 404 for everything cannot pass: every published-file check and all function probes fail.

The unchanged deployment handling remains sound:

- Current Netlify CLI JSON defines and emits `deploy_url` and `logs`, including for production deploys. [Netlify CLI source](https://github.com/netlify/cli/blob/main/src/commands/deploy/deploy.ts)
- A nonzero `netlify deploy` stops `deploy.sh` under `set -e` before JSON parsing or verification; the EXIT trap removes the temporary output. The CLI also attempts to cancel an already-created deploy when upload/deployment throws.
- `--functions netlify/functions` selects the function directory; the remaining `[functions]` configuration, including `node_bundler` and `included_files`, is separately passed into bundling. Netlify documents command-line flags as taking precedence for directory selection. [Netlify manual-deploy documentation](https://docs.netlify.com/api-and-cli-guides/cli-guides/get-started-with-cli/)

The unchanged `build-dist.sh` parsing remains sound for both HTML quote styles and case-insensitive attributes, both service-worker quote styles, invalid manifest JSON, empty icon lists, and dot/whitespace entries. I found no new parser defect.

`bash -n` passed for all three scripts. I could not rerun Jest in the read-only environment because Jest attempted to create its temporary haste-map file; no repository files were changed.

ready to deploy — yes.
