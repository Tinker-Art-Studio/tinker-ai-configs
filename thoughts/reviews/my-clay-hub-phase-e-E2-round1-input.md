## Change under review — My Clay Hub Phase E, E-2 steps 1, 1b, 2 (the receiver's logic and rules; no Firebase wiring yet)
Repo /Users/christiehubley/my-clay-hub, branch phase-e-e2-receiver (4 commits vs main: e88e7c1, bf0e515, 192be39 + the shared copy).
Plan: ~/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html — "The link contract", E-2 (text extract: /private/tmp/claude-501/-Users-christiehubley-my-clay-hub/b0a70fea-fa70-4d6d-9b90-7969133b14ed/scratchpad/phase-e.txt). DATA-MODEL.md; DECISIONS #53, #65–#75 (#72 = the safety stops). E-1 fixtures: tests/fixtures/link-contract/fixtures.json.

Files:
- functions/members/lib/contract.js — strict envelope check (400), readTime compare, members/memberProfiles/staffRoster docs, Q7 tombstones, applyEnvelope (the gate; 'unchanged' keeps updatedAt; statusDate/sourceReadTime/updatedAt are "volatile")
- functions/members/lib/batch.js — members/staff reconcile plans, the daily recompute plan, #72 limits, overrides (pickOverride/decide), 249 cap, alert from 200
- functions/members/shared/ — byte-identical copies of shared/derive-status.js and denver-time.js (a deploy uploads only the codebase folder; pinned by a test). The codebase will be ESM ("type": "module", step 3).
- firestore.rules — explicit deny-all blocks for members, memberProfiles, staffRoster, linkOverrides (+ tests in tests/rules/firestore.test.js)
- tests/unit/members-contract.test.js, tests/unit/members-batch.test.js (batch tests mutation-checked: 5 planted bugs each caught)
Tests: unit 270/270, rules 214/214, guard 199/199.

## What I want reviewed
1. Correctness against the plan's E-2 text and #72, line by line: the gate; source-driven counting (deriveStatus(stored, today) vs deriveStatus(incoming, today)); "a record whose whole snapshot is unchanged gets only its sourceReadTime advanced"; removals (live, not in items, not held, older than the batch); N = live held minus held ids; additions/reappearance; staff (>1 removal stops; never-held tombstone writes nothing); overrides (exact keys per scope, 0–249, expiresAt ≤ createTime+24h, >1 open → refuse all, used only when normal limits would stop and counts fit, omitted limit keeps normal, consumed); recompute ("explained" = pause start, end+1, last day+1 in (statusDate, today]; unexplained over the limit → nothing written; 249 cap; alert 200).
2. Things I decided that the plan doesn't state — say if any is wrong: statusDate counts as volatile (a same-day re-apply with the same content is 'unchanged'); an unchanged profile isn't rewritten; the recompute writes statusDate on every live member every day and moves updatedAt only when status changes; trigger path (applyEnvelope) re-derives status for today even when the snapshot is unchanged (only the reconcile is forbidden from date-driven writes); 'too many' counts distinct ids written; the members codebase carries a byte-identical copy of shared/.
3. Anything that would lose data, write when it should stop, count wrongly, or let a client read these collections.
4. Test gaps vs the plan's E-2 test list that the pure layer should already cover.
Read-only: no edits, no git state changes, no network, no deploys. Findings as blocking / should-fix / nit with file:line and a concrete scenario. End with exactly SAFE TO MERGE or NOT SAFE TO MERGE (merge itself waits for step 3 and Monday's gate; judge this logic).
