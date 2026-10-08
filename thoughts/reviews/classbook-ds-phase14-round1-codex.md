## Findings

No HIGH or MEDIUM findings.

- **LOW — [js/app.js:11779](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase14/js/app.js:11779)**  
  A visible-but-normalization-empty name such as class `"!!!"` or teacher `"—"` is accepted and produces keys such as `teacher--1` or `-class-1`. Multiple such rows are correctly detected as collisions, so this is not a bypass, but a single malformed identity can still be persisted and is vulnerable to future spelling drift.  
  **Fix:** Either explicitly permit/document this, or reject roster rows whose teacher or class component becomes empty after `makeLessonKey` normalization. Add a focused test.

- **LOW — [e2e/data-safety.spec.js:3923](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase14/e2e/data-safety.spec.js:3923)**  
  The clean-save guard proves both downstream functions are called, but does not capture their arguments. It therefore does not directly prove that the validated `numWeeks` is the value passed to slot creation or written in `settingsPaths`. The implementation does use the same expression, so this is a coverage gap rather than a defect.  
  **Fix:** Capture the `updateAppData` payload and `createLessonSlotsForRoster` arguments, then assert both receive the form’s week count.

- **LOW — [e2e/data-safety.spec.js:3937](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase14/e2e/data-safety.spec.js:3937)**  
  The non-weekly guard covers a camp season but not the third known type, `day-off-camps`, nor an unstamped/unknown semester defaulting to weekly. The code is correct because `isWeeklySemester()` centralizes this behavior, but those requested boundaries are not directly demonstrated here.  
  **Fix:** Add small guards showing day-off skips validation and an absent `semesterType` is validated as weekly.

The alert is actionable for a non-technical admin: it names both teacher/class rows, explains why they conflict, tells the admin to rename one, and states that nothing was saved. Capitalization-only pairs are not false positives: they genuinely generate the same lesson keys. Existing production collisions will block all Settings saves for that weekly semester until corrected, but that is the intended fail-closed behavior.

## Claim 1

**Mostly verified, with qualifications.**

Commit `7873077` covers:

- Removal of the whole-semester `saveLessonData()` write.
- Server-authoritative existence checks inside one transaction.
- No TOCTOU gap between the read and write.
- Existing lesson keys are never written.
- Only successfully created slots enter the cache.
- Non-weekly/camp skipping through `isWeeklySemester()`.
- Load-failure refusal.
- Error propagation to `saveSettings()`, which accurately reports that settings saved but slot creation failed.

It does **not** implement these exact plan details:

- Identity-mismatch reporting.
- Hydrating a locally missing, server-existing lesson into the cache immediately; it remains absent until the listener delivers it.
- Per-key continuation and aggregated failed-key reporting. The transaction replaces that design with atomic all-or-nothing behavior, which is safer here, but an error does not identify individual keys.

Those deviations do not reintroduce the bulk-overwrite risk.

## Claim 2

**The reasoning is substantially right.**

A candidate-only identity check would behave inconsistently:

- With a fresh cache, the existing key never becomes a candidate, so drift remains silent.
- With a stale cache, it would run and could flag the same condition.
- Exact raw-string comparison would treat harmless capitalization or punctuation correction as a mismatch.

There is no automatic lesson-content loss in the current path: the transaction skips the existing key without writing it. However, “nothing is written” applies only to lesson slots—the changed roster configuration has already been saved. That can leave roster identity and stored lesson identity out of sync, potentially affecting visibility, mappings, reporting, and later user edits. This is an integrity/usability risk, not a direct overwrite by slot creation.

A worthwhile future solution would need to validate **all** proposed roster identities against the server and define a deliberate rename/migration policy. Adding the plan’s narrow stale-candidate exact-string check would not solve the general problem cleanly.

No new collection or write surface was introduced, so no Firestore rules change is required. Syntax checks passed; I did not run `npm test`.

**SAFE TO COMMIT** — the LOW items are follow-up hardening/test coverage, not blockers.