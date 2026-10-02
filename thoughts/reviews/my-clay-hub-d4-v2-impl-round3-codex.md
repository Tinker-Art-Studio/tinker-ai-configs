Verdict: **merge after fixes**.

### Blocking

- [scripts/deploy-functions.sh:587](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:587), [scripts/deploy-functions.sh:970](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:970): `LEGACY_OK` is never initialized, so an inherited `LEGACY_OK=true` also enables legacy normalization during `--approved`. The backstop should prevent upload, but the guard can reach the CLI and create an unverified attempt instead of refusing immediately. Set the internal default explicitly to `false`, enabling it only for the calls at lines 1094 and 1142.

### Non-blocking

- [tests/functions/schedule-probe.test.js:7](/Users/christiehubley/my-clay-hub/tests/functions/schedule-probe.test.js:7): real discovery coverage remains deferred to V-3 rather than fixed. The new explanation is reasonable.

All other round-2 findings are fixed: repeated record fields fail closed, headers allow only none or one valid User-Agent, Scheduler `no` remains attestation debt, job-list merge failures refuse, and deployed-job semantics are documented.

`bash -n` and `git diff --check` passed. I did not run the guard harness because it creates Git commits/tags, respecting the read-only requirement.
