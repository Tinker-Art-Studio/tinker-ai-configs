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
