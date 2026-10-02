## IMPLEMENTATION review — Phase B (Classbook) + Phase B' (Studio Hub alerts), before deploy
Spec (approved plan): /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html (Design + Phase B + Phase B' + the storage-state table)
1. Classbook: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/new-semesters-own-doc, branch claude/new-semesters-own-doc, commit 7873077 on top of origin/main 1532121.
   Diff: git -C /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/new-semesters-own-doc show 7873077 -- js/ css/   (tests: same commit, e2e/)
2. Studio Hub alerts: /Users/christiehubley/studio-hub/.claude/worktrees/new-semesters-alerts, commit 0673e40 (git show 0673e40).
3. The rules these run against (already reviewed SAFE): /Users/christiehubley/studio-hub/.claude/worktrees/new-semesters-rules, commits f9b1123 + 56a274a.

Production today: lessonData = fall-2026 + meta + TEST leftovers; lessons_spring-2026 (verified move); semesters fall-2026, spring-2026, sdoc-2026-27, summer-2026. Christie creates Spring 2027 (copy from Fall 2026) right after deploy. Hard requirement: every past semester stays loaded/readable; nothing may make lessons look blank/deleted or let a stale copy overwrite newer server data.

## Check, against the real code
- Can ANY path still write a new semester into lessonData, write an own-doc semester while its state isn't 'editable', or overwrite existing lessons with stale/blank data (createNewSemester, addMissingLessonSlots/createLessonSlotsForRoster, saveLessonData, deleteLessonKey, createOwnDocStorage, Q&A writers, executeCopyPlan, move/swap, cut/paste)?
- createWeeklySemesterStorage transaction: correct refusals, retries, no partial state; installOwnDocMap/reconcile after commit; the copy path's slots.
- ownDocStorageState table incl. 'vanished' and unknown migration state; listener carry-over across lessonData snapshots for N own-doc semesters; reconcileOwnDocListeners; teardown in setupLessonDataListener; the 'rollback' fallback; notice + "Create its storage" button (manager only, never when unknown/vanished).
- Regressions for Fall 2026 (legacy) and Spring 2026 (moved, verified): teacher view, admin grid, Q&A, cut bank, copy plan, Settings, counts, gauge.
- Studio Hub: range listener replace semantics, id filtering, legacy exclusion, degraded/first-snapshot handling, dismissal migration unchanged.
- Tests: do the e2e changes still test what they used to (data-safety rewrites — esp. the replaced createNewSemester block, the listener "ping" now via fall-2026, the stubs moved to addMissingLessonSlots/createWeeklySemesterStorage)? Anything weakened? Missing scenarios from the plan?
- Firebase invariants: partial updates, awaited writes, no undefined, empty-field exception only where approved (slot template into absent keys/doc).

## Constraints
READ-ONLY: edit nothing, deploy nothing, no production data, never read ~/.config/configstore/firebase-tools.json. You may read files and git history; don't run the emulator suite (the author reports: Classbook 374 + 33 passing across runs, final full run in progress; studio-hub alerts 31/31; rules 678 + 141).

## Output
Verdict (SAFE TO DEPLOY / FIX FIRST), numbered findings with severity, file:line evidence, concrete fix. Terse.
