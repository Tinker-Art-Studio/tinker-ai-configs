Verdict: PR #13 — merge after fixes. PR #14 — safe to merge.

## PR #13 — docs

1. **Blocking — fixed-UTC scheduling is contradicted later in both source-of-truth documents.** `SPEC.md:381` and `DATA-MODEL.md:206` correctly say 09:30 UTC, but `SPEC.md:385` says “All times are America/Denver,” and `DATA-MODEL.md:220` says all scheduled jobs run in America/Denver. That conflicts directly with Decision #65 and the UTC-only guard. Clarify that business/calendar calculations use Denver time while scheduler declarations use UTC.

2. **Blocking — Decision #72 does not preserve the complete safety-stop counting contract.** `DECISIONS.md:89` omits that held/conflicted IDs are excluded from denominators, additions never count, and a removal counts only as a removal—not also as a status change. “Live members” is also less precise than the plan’s live, non-held denominator. `DATA-MODEL.md:52` merely refers back to #72, so the missing rules are not recorded anywhere in the repo’s source of truth.

3. **Should-fix — the in-repo envelope description is not yet the exact contract it claims to be.** `DATA-MODEL.md:55-59` omits several validation-relevant rules from the plan: the member-ID pattern; unknown envelope keys/noncanonical timestamps yielding 400; malformed `pauseHistory` container/entry markers; duplicate reconcile IDs yielding 400; held IDs being excluded from every denominator; content-only `updatedAt`; and the exact response bodies. Line 59 then points to a shared fixture set that E-1 has not created yet. Either record these rules here or explicitly call this a summary and describe the fixture set as forthcoming.

4. **Should-fix — recompute’s profile write is incompletely described.** `DATA-MODEL.md:110` says it rewrites member `status`/`statusDate` and profile `pause`, omitting profile `status`. Lines 119 and 206 correctly say profile `status` and `pause`.

Everything else checked out: Q7 is consistently updated to retain all last-known non-contact fields; #73 stays limited to the two event-trigger services; the copied/never-copied lists agree with the real Membership Manager shapes, including `scheduledAt`, nested notes, phone handling, billing/Sawyer fields, keypad fields and the catch-all exclusion.

## PR #14 — deriveStatus

No blocking or should-fix findings.

1. **Nit — test names still use the old rule numbers.** `tests/shared/derive-status.test.js:62`, `:72`, `:77`, `:82`, and `:195` call the old rules 7–10 even though DATA-MODEL now numbers them 8–11. The assertions are correct; only the labels/comments are stale.

The implementation matches rules 1–11 exactly:

- Non-object `scheduledPause` remains malformed.
- Only boolean `processed === true` counts.
- Malformed dates inside an unprocessed request are ignored with that request.
- Pause history is unaffected.
- A paused member with only an unprocessed request reaches rule 10 and returns `review`.
- Earlier precedence for removed, onboarding and cancellation remains unchanged.
- No other shared or current function code depends on the old scheduled-pause behavior.

Validation:

- PR #14 derive-status suite: **39/39 passed** under UTC, America/Denver and Pacific/Auckland.
- TZ matrix: **4/4 passed**.
- Running the PR #14 tests in memory against `main`’s implementation produced **3 failures**, specifically the unprocessed-pause, malformed-date-in-unprocessed-request and paused-stage/rule-10 cases. Thus the new tests do fail on main.
- `git diff --check` passed for both branches.
- The broader unit command was attempted but sandbox-denied tests that require temporary-directory writes; the relevant shared and TZ suites completed successfully.
- No branch was switched and no files were modified.
