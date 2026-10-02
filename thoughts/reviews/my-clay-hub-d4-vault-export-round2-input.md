## Plan under review (round 2)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-d4-vault-export.html

Round 1 reviews (read these first):
- /Users/christiehubley/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-vault-export-round1-codex.md ("not ready")
- /Users/christiehubley/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-vault-export-round1-claude.md ("ready after fixes")

An independent Claude round-2 review (/Users/christiehubley/tinker-ai-configs/thoughts/reviews/my-clay-hub-d4-vault-export-round2-claude.md) also ran. Its fixes are already applied; see the plan's "Round 2" table. Verify those fixes too.

The plan was rewritten against both round-1 reviews. Its "Reviews" section maps each finding to a resolution. Christie made these decisions, which are not to be reopened unless unsafe:
- O5: allow a rare second complete export copy instead of building a strict lock.
- O6: a narrow exception to the x-tinker-reached header rule, for scheduled functions only.
- Freshness threshold 7 days 18 hours.
- Bucket location US.

## What I want reviewed
1. Is each round-1 finding actually resolved by the plan text? Name any that are not, or only partly.
2. Did the rewrite introduce new problems? Look especially at:
   - V7's new algorithm (bucket as record, operation list for "still running", fresh prefix per export, capped paging, 1500 s wait budget, key = UTC date of scheduleTime). Check the claim that Scheduler retries carry the same X-CloudScheduler-ScheduleTime.
   - V-4's failure-first bootstrap (the Firestore agent is granted only after the first failing export).
   - V2's always-present attestation keys and scheduler_attested n/a.
   - V3's exact declaration key sets and their effect on the existing core codebase and tests.
3. Anything still blocking execution?

Verify against the repo (/Users/christiehubley/my-clay-hub) and the pinned sources: node_modules/firebase-tools 15.22.3, and functions/core/node_modules/firebase-functions 7.4.0 plus its @google-cloud/* deps.

## Constraints
- This is a read-only review. Run no deploy and no command that changes cloud state.
- Never read ~/.config/configstore/firebase-tools.json.
- No gcloud is available; Christie does the Console steps.

## Output
Give a verdict ("ready", "ready after fixes", "not ready"). Then list findings as blocking / should-fix / nits, each with the plan section and the evidence. Keep it concise. Don't re-raise round-1 items that are resolved.
