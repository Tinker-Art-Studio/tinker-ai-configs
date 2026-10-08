You are an independent implementation reviewer (round 1). Do NOT edit any files, do not run npm test (another run holds the emulator ports), do not run a second-model review yourself.

## Context
Repo: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase15 (git worktree of the Classbook app, branch claude/classbook-phase15-semester-delete, base origin/main c3738d8). Diff: /private/tmp/claude-501/-Users-christiehubley-tinker-spring-curriculum/2c686b46-254d-4806-9de3-3a9a0aa388e0/scratchpad/phase15.diff (or git -C /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase15 diff).
Plan: Classbook Data Safety Plan Phase 15 (~/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html, "Phase 15 — Semester delete"). The plan's design (Aug 2026) was to make deleteSemester() surface lesson-delete failures, not remove config before the lesson delete confirms, roll back config on failure, correct the confirm wording, and a summer content-clearing path.

## What changed and why
State before this change (main c3738d8): config rollback on failure already shipped; the summer half was superseded by the camp-seasons plan (removing a camp season only removes the Classbook's appData entry); weekly semesters stored in their own document were refused ("can't be deleted yet"). The one weekly semester still stored inside curriculum/lessonData — fall-2026 — was still deletable once not active: two confirms, then appData entry removed, then deleteLessonData() with failures only console.warn'd, and a confirm text claiming cut bank/change history removal that never happened.

Product decision (Christie, Oct 8 2026): regular semesters are only ever ARCHIVED, never deleted. So instead of making the weekly delete safer, it is removed:
- js/app.js renderSemesterSelector(): the 🗑 Delete button is shown only for non-weekly semesters (camp seasons, SDOC years) — isWeeklySemester(currentKey) hides it.
- js/app.js deleteSemester(): any weekly semester (own-doc or legacy) is refused first with an alert, nothing written; the weekly confirm texts, the second confirm and the deleteLessonData() call are removed; camp/SDOC paths unchanged.
- js/firebase-data.js: deleteLessonData() removed (no callers left); a comment updated.
- Tests: e2e/data-safety.spec.js — the camp-seasons "RED (1.7): a weekly semester stored the old way still deletes its own lesson data" test is replaced by two RED tests (fall-2026 refused with no confirm/no write; the bar shows no Delete for weekly, still shows it for a camp season), both confirmed failing on the old code. e2e/spring-own-doc.spec.js ratchet drops deleteLessonData from its allow-list/assertions; two own-doc refusal tests loosened from /can't be deleted yet/ to /can't be deleted/.

## Please check
- Is anything still able to delete a weekly semester's lessons or its appData entry (other callers, other UI paths, old code that expects deleteLessonData)? grep thoroughly, including index.html onclick handlers and other js files.
- isWeeklySemester() defaults unknown/untyped semesters to weekly — any non-weekly semester that would now be wrongly refused (camp seasons other than summer-2026, SDOC years)?
- The camp-season and SDOC removal paths: anything broken by deleting the isCamp variable, the confirm restructuring, or the cache cleanup block?
- Whether the tests prove the change; gaps.
- Anything in the plan's Phase 15 that this decision leaves genuinely unaddressed and should be recorded (not built) — e.g. orphaned cutProjects/changeLog entries no longer arise for weekly semesters at all.
- Firebase invariants: no new writes, no new collections, no rules change.

## Output
Findings: severity (HIGH/MEDIUM/LOW), file:line, concrete scenario, fix. Then SAFE TO COMMIT or NEEDS FIXES.
