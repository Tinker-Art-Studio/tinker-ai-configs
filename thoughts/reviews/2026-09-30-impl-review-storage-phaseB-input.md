## Implementation review — Phase B (Classbook + Studio Hub alerts), before deploy
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase B; Phase A rules are LIVE: studio-hub 0caf415).
Diffs:
- Classbook: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-classbook.diff (worktree, read-only: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81, branch claude/spring-own-doc)
- Studio Hub: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff (worktree, read-only: /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc)
Note: the implementation keeps lessonStoreFor() returning 'weekly' for Spring and routes writes through a new weeklyLessonTarget() instead of a new 'ownDoc' store value — check that this is complete.
Adversarially review the actual code:
1. Can any lesson edit be lost, misrouted, duplicated, or silently refused for any semester (Fall especially — it must behave exactly as before)? Every writer and reader of weekly lessons, incl. paths not in the diff that read/write currentLessonData and then persist.
2. Listener logic: initial load vs listener ordering, the legacy carry-across, recheckOwnDocAfterLegacyLoss, the move and rollback transitions, error states, teardown/double registration, interaction with globalListenerGeneration / reloadSummer / lessonDataLoadedSuccessfully, SDOC and camp seasons.
3. The "editing is paused" window: every Spring write path refused with a clear message (none throwing obscure errors or half-writing); what the UI shows.
4. Studio Hub alerts: union/rebuild correctness, dismissal migration, cleanup, errors.
5. Tests: meaningful and non-leaking (the admin reset helper), gaps.
Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
