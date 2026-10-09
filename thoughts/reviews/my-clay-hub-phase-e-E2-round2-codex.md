codex
Blocking

- [contract.js](/Users/christiehubley/my-clay-hub/functions/members/lib/contract.js:201) and [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:102): rebuilding a missing profile derives its status for `today`, even though the unchanged member retains its stored status. Example: stored yesterday as `active`, pause begins today, profile missing. An unchanged trigger/reconcile leaves `members.status = active` but creates `memberProfiles.status = paused`. This performs an uncounted date-driven write outside recompute and could bypass a recompute stop. Rebuild using the stored member status, with a boundary test for both trigger and reconcile paths.

Should-fix

- [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:57): `d.scope in OVERRIDE_KEYS` accepts inherited property names such as `toString`, `constructor`, or `__proto__`. Such a malformed override is silently skipped by every scope instead of being reported. Use an own-property check and test one prototype-name scope.

- [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:115) and [batch.js](/Users/christiehubley/my-clay-hub/functions/members/lib/batch.js:142): unreadable `sourceReadTime` now correctly prevents removal, resolving the data-loss finding, but the affected ID disappears from counts and diagnostics. If reconciliation is the recovery path after a missed tombstone, that member or staff record can remain live indefinitely without an operator signal. Return/report those retained IDs.

Test gaps in the pure layer

- Missing-profile recovery on a date boundary, for both trigger and reconcile.
- Malformed override scopes matching `Object.prototype`.
- Staff reconciliation at the 249/250 touched-ID boundary.
- Worst-case 249-member transaction with an override, demonstrating the intended 499-write ceiling.
- An assertion that unreadable removal candidates are surfaced, not merely retained.

The remaining round-one findings are correctly addressed: removals require readable older times; the 2999 edge no longer throws; `staff_{uid}` IDs are used; timestamp precision is nanoseconds; missing profiles are rebuilt; ordinary malformed overrides are reported; rules correctly acknowledge OR semantics; and current rules deny all client access. Source-driven counting, held-ID denominator, additions/reappearance, override consumption, recompute limits, alert thresholds, and byte-identical shared copies otherwise match the plan.

The item-2 statement that unchanged triggers re-derive today’s status conflicts with the newer explicit decision at the top. I treated the newer “only sourceReadTime advances” decision as authoritative.

The worktree acquired uncommitted changes during review; I did not make them. Findings above are against commit `dd2852f`, not those later changes.

NOT SAFE TO MERGE
