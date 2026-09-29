## Implementation review — Phase A (Firestore rules), before merge and deploy
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A, rev 5).
Diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff
Worktree (read-only): /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence (firestore.rules, rules.test.js). These rules govern EVERY staff app in the tinker-hq-apps project.
Adversarially review the actual code:
1. Does the new /curriculum/{docId} block preserve exactly the old behaviour for every doc other than lessonData / lessons_spring-2026 / storageMigrations, for every role (admin, manager, classbook, classbook-admin, curriculum-admin, no access, archived users, kiosk, reminder bot)? Any statement that now grants more than before?
2. Does it implement Phase A exactly (fence, move, rollback with existsAfter, verified gating, delete rules)? Any bypass (set with merge, set without merge, batch vs transaction, field-path tricks, creating lessonData when absent, map-valued 'spring-2026' vs dotted paths)?
3. Will the Classbook's real current writes to lessonData keep working (saveSingleLesson dotted per-field updates, saveMultipleLessonFields, saveLessonData merge-set, deleteLessonKey, Q&A/help replies — see /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js and js/app.js), including when lessonData is near 1 MiB? Anything in Studio Hub or other apps writing /curriculum?
4. Rules limits/cost: get/exists call counts per request, evaluation on a near-1 MiB doc.
5. Are the tests meaningful (would a wrong rule pass them)? Gaps?
Verdict: SAFE TO MERGE AND DEPLOY or NOT (minimum list). Do not edit files or run tests.
