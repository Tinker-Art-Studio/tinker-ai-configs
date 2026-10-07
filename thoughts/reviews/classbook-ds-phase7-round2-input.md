You are an independent implementation reviewer, ROUND 2. Do NOT edit files, do not run npm test (another run holds the ports), do not run a second-model review yourself.

Same change as round 1 — the round-1 prompt follows for context, then what changed since.

----- ROUND 1 PROMPT -----

## Change under review
Repo: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase7 (git worktree of the Classbook app, branch claude/classbook-phase7-teacher-editor, base origin/main 696b301). The uncommitted diff is in /private/tmp/claude-501/-Users-christiehubley-tinker-spring-curriculum/2c686b46-254d-4806-9de3-3a9a0aa388e0/scratchpad/phase7.diff (run `git -C /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase7 diff` too). Files: js/app.js (teacher editor saveTeacherEdit / saveTeacherEditInner / teSnapshotOf / getTeChangedFields, openTeacherEditModal) and e2e/data-safety.spec.js (new describe block "saveTeacherEdit() diff-only payload + existence check (Data Safety Plan Phase 7)" + rewritten Test 7).

Plan: Classbook Data Safety Plan, Phase 7 — ~/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html (large HTML; search "Phase 7 — Non-summer editor"). It was designed Aug 2026; the Resume Instructions say: execute against the CURRENT function, reuse the shipped shape of Phase 9 (saveAdminEdit / saveAdminEditInner in js/app.js: snapshot diff, forced-server existence check via adminLessonStillExistsWithRetry, fresh-copy rebase after the check).

What the change does:
1. Firestore payload = only fields that differ from the open-time/last-save baseline (teOriginalData), plus photoUrl/photoPath only when this save replaced/removed the photo. The cached lesson (originalLesson) is never spread into the payload. (Previously {...originalLesson, ...formData} minus Q&A fields was written via saveSingleLesson's per-field dotted-path update.)
2. Weekly semesters: forced-server existence check before any side effect. Gone -> stop, no write (no ghost). Different projectTitle at the key (swap/paste) -> manual save confirm(); autosave just stops with a status line. Read failure twice -> stop. After the check the FRESH server copy is used for the photo-delete target, the "remove photo" check, the local cache and the change log.
3. New dirty baseline after a save = the formData that save SENT (previously a fresh DOM read after the await, which absorbed text typed during the save so it was never saved).
4. Serialization: one save at a time; a call during an in-flight save is queued once and run afterwards (manual beats auto); queued run skipped if the editor was closed / reopened on another lesson.
5. A save that finishes after its editor was closed/reopened doesn't touch the new editor's baseline/status.

## Acceptance criteria
- A teacher/admin edit never overwrites another client's newer value of a field this editor did not change (content, inspoLink, materials/materialsList, photo, Q&A, identity/scheduling fields), regardless of listener timing.
- Intentional clears still persist (FieldValue.delete via fieldsToClear).
- No ghost/partial lesson is ever created at a key whose lesson moved/was deleted.
- Nothing the user typed is lost or silently marked saved.
- No regressions: photo upload/replace/remove + delete-after-save ordering, change log, own-doc semester refusal (refuseIfWeeklySemesterPaused / isOwnDocRefusal), load-failure guard, Cmd+S, autosave.

## Please check especially
- Correctness of the diff logic vs what saveSingleLesson()/buildLessonFieldUpdates() in js/firebase-data.js do with the payload (stripping empty CONTENT_FIELDS, non-content '' values, materialsList arrays, planComplete booleans).
- Any path where an edit is silently dropped, or the baseline is advanced past something not saved (failure paths, stop paths, queued saves, photo-only saves, a "remove photo" when the server already has none).
- The serialization wrapper: deadlocks, lost queued saves, recursion, stale originalLesson in the rerun, interaction with the 1.5 s "Saved!" timers / button disabled state.
- The existence check: cost (it reads the whole semester map from the server on every save incl. autosave) — is that acceptable or is there a material problem; title-mismatch false positives (e.g. this same editor renamed the title in an earlier save; another admin renamed it).
- Whether the new tests genuinely prove the fix (would they pass against the old code?), and gaps in coverage.
- Anything in other callers of saveTeacherEdit / openTeacherEditModal (e.g. sendTeacherQaMessage reopening the modal) broken by the change.

## Firebase invariants
updateDoc-style partial writes only (no setDoc for partial edits); strip undefined/empty before writes; await all critical writes; no new collections (none here) -> no rules change.

## Output
A list of findings, each: severity (HIGH/MEDIUM/LOW), file:line, concrete failure scenario, suggested fix. Verify each claim against the code. Then a one-line verdict: SAFE TO COMMIT or NEEDS FIXES.
----- END ROUND 1 PROMPT -----

## Round 1 findings and what was done (verify each fix; the current diff is /private/tmp/claude-501/-Users-christiehubley-tinker-spring-curriculum/2c686b46-254d-4806-9de3-3a9a0aa388e0/scratchpad/phase7-r2.diff, or run git -C /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/phase7 diff)
Codex r1 (/private/tmp/claude-501/-Users-christiehubley-tinker-spring-curriculum/2c686b46-254d-4806-9de3-3a9a0aa388e0/scratchpad/review-codex-r1.md) and Claude r1 (/private/tmp/claude-501/-Users-christiehubley-tinker-spring-curriculum/2c686b46-254d-4806-9de3-3a9a0aa388e0/scratchpad/review-claude-r1.md) — read both.
- HIGH semester read at save time -> modal.dataset.semKey captured at open; saveTeacherEditInner uses it; callers and queued rerun use the editor's semKey.
- HIGH global baseline read after the await -> `baseline` captured at the start of saveTeacherEditInner and used for diff, clears, logging; global teOriginalData only reassigned when isCurrentEditor().
- MEDIUM re-prompt after accepting a swap -> modal.dataset.serverTitle (set at open, advanced to the saved lesson's title after each success) is the identity baseline, not the form baseline.
- MEDIUM 1.5 s timer -> single teStatusTimer, cleared at the start of every save; callback checks isCurrentEditor() && !teSaveInFlight.
- MEDIUM (Claude) pendingRemove left set beside a new photo -> requestedRemove captured at start; flag cleared on success when hasNewPhoto || requestedRemove.
- LOW (Claude) var(--error) undefined -> --error defined in css/styles.css :root.
- LOW tests: added "review r1" tests (semester switch, editor replaced during the read, after accepting a swap, status timer, clear matrix, remove-then-replace, remove when already removed). Each RED one was confirmed failing against the pre-fix code.
- NOT changed (owner decision pending): the forced-server existence read on every autosave (cost). Don't re-report it unless you find a correctness problem in it.
- e2e/spring-own-doc.spec.js ratchet renamed to saveTeacherEditInner.

## Round 2 job
1. Verify each fix is correct and complete; look for regressions the fixes introduced (especially the queue keyed on the editor element, captured semKey fallback to getTvSemKey(), serverTitle advance, requestedRemove vs a Remove clicked mid-save).
2. One more fresh pass over the whole current saveTeacherEdit/saveTeacherEditInner for anything both reviewers missed.
Output: findings with severity, file:line, concrete scenario, fix — then SAFE TO COMMIT or NEEDS FIXES.
