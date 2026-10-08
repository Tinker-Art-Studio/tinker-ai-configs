You are an independent implementation reviewer (round 1). Do NOT edit any files, do not run npm test (another run holds the emulator ports), do not run a second-model review yourself.

## Context
Repo: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase14 (git worktree of the Classbook app, branch claude/classbook-phase14-roster-slots, base origin/main 55ec89e). Diff: /private/tmp/claude-501/-Users-christiehubley-tinker-spring-curriculum/2c686b46-254d-4806-9de3-3a9a0aa388e0/scratchpad/phase14.diff (or git -C /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase14 diff).
Plan: Classbook Data Safety Plan Phase 14 — ~/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html (search "Phase 14 — Roster-driven lesson slot creation"). Designed Aug 2026 around replacing createLessonSlotsForRoster()'s whole-semester saveLessonData() bulk write with per-key forced-server existence checks + writes, plus validateRosterKeys() called from saveSettings() before anything is persisted, plus an identity-mismatch report.

## Claim 1 to VERIFY (not trust): most of Phase 14 already shipped
On Oct 1 2026, commit 7873077 (plan classbook-new-semesters-own-doc) replaced the bulk write with addMissingLessonSlots() in js/firebase-data.js: one Firestore transaction reads the semester's document, keeps only slots whose keys are ABSENT on the server, writes them in one update; existing lessons are never written; the cache is updated only with what was created. Tests: e2e/new-semester-own-doc.spec.js ("adding a class in Settings writes only the new slots"), e2e/data-safety.spec.js createLessonSlotsForRoster block. I claim this covers the plan's bulk-write removal, per-key existence check (stronger: transactional, no TOCTOU gap), load-failure gate, summer skip, and aggregate-error propagation (saveSettings reports "Settings saved, but … slots weren't created"). Verify against the code; say where it does NOT cover the plan.

## Claim 2 to VERIFY: the plan's identity-mismatch check is not worth building
The plan wanted: if a candidate key exists on the server under a DIFFERENT teacher/className (spelling drift, e.g. "AB"/"C" vs "A-B"/"C"), report a failure instead of silently skipping. My reasoning for skipping it: (1) candidates are only keys missing from the LOCAL cache, so in the normal case (real lesson already in the cache) the check never runs and the drift is silent anyway — it only catches the rare stale-cache variant; (2) an exact-string identity compare would flag a mere capitalization fix of a class name. Nothing is written in either case. Is that reasoning right? Is there a real data-loss path I'm missing?

## The change under review (the remaining piece)
- js/app.js: new pure validateRosterKeys(roster, numWeeks) (next to makeLessonKey) returning {valid, collisions:[{key, sources:[{teacher, className}]}]}; saveSettings() calls it for weekly semesters only (isWeeklySemester) BEFORE updateAppData, alerts naming each clashing pair of rows, and returns with nothing written.
- e2e/data-safety.spec.js: new describe "roster key collisions (Data Safety Plan Phase 14)" — 3 RED (confirmed failing on the old code) + 2 guards.

## Please check
- Correctness: placement in saveSettings (after the SDOC-year branch, before the config clone and updateAppData); numWeeks value used matches what is saved; isWeeklySemester for new/unknown semesters; makeLessonKey normalization edge cases (empty after normalization, e.g. className "!!!").
- Product risk: if a PRODUCTION roster already contains such a pair, every Settings save for that semester is now refused until renamed. Is the message clear enough for a non-technical admin to fix it? Anything that could make it fire falsely?
- Whether the tests prove the change and what's missing.
- Firebase invariants: no new writes, no new collections → no rules change.

## Output
Findings: severity (HIGH/MEDIUM/LOW), file:line, concrete scenario, fix. Then verdicts on Claim 1 and Claim 2. Then SAFE TO COMMIT or NEEDS FIXES.
