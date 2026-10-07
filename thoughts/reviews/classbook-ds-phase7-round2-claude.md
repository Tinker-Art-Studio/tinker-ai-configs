I reviewed the live working tree, which changed three times while I was reading it — the photo fix landed at 11:23:24, after I had written it up as a finding. Findings below are against the tree as of **11:26** (`js/app.js` 11:23:24, `e2e/data-safety.spec.js` 11:25:36, `css/styles.css` 11:10:06, `e2e/spring-own-doc.spec.js` 11:04:19). I did not run `npm test`.

## Round-1 fixes — all seven verified

| r1 finding | Fix | Verdict |
|---|---|---|
| HIGH semester read at save time | `modal.dataset.semKey` at open (`js/app.js:3296`), consumed at `:3603`, callers `:3324`/`:3334`, queued rerun `:3559` | **Correct.** Also removes a latent throw: `lessonStoreFor()` (`:3646`) throws for an SDOC year, and a live `getTvSemKey()` could have handed it one. (Not reachable anyway — `renderTeacherView` returns at `:1631` for SDOC and at `:1674` for camps, so `openTeacherEditModal` only ever sees weekly.) |
| HIGH global baseline read after the await | `baseline` at `:3604`, used at `:3610`, `:3684-3686`, `:3770` | **Correct.** `teOriginalData` is only reassigned behind `isCurrentEditor()` (`:3781`), and `teSnapshotOf` returns a fresh object, so an in-flight save's `baseline` can never be mutated under it. |
| MEDIUM re-prompt after accepting a swap | `modal.dataset.serverTitle` (`:3296`, read `:3605`, advanced `:3795`) | **Correct.** Identity baseline is now separate from the form baseline; a cancelled swap correctly does *not* advance it. |
| MEDIUM 1.5 s timer | single `teStatusTimer`, cleared `:3606`, callback guards `:3798` | **Correct.** The only path that neither re-arms nor restores the button is `refuseIfWeeklySemesterPaused` (`:3623`), and that is a static config — it can't be false for save 1 and true for save 2. |
| MEDIUM `pendingRemove` beside a new photo | `photoRev` counter (`:3537`, bumped `:3361`/`:3376`/`:3392`, captured `:3613`, compared `:3740`) + requeue `:3744` + photo clause in `isTeEditDirty` `:3529` | **Correct** — see note below. |
| LOW `var(--error)` undefined | `css/styles.css:29` | **Correct** for the error state. |
| LOW ratchet rename | `e2e/spring-own-doc.spec.js:282` | **Correct.** `refuseIfWeeklySemesterPaused` (`:3623`) precedes the first `await` (`:3649`), and no comment in between contains the word `await` to false-match `/\bawait\b/`. |

On the photo fix specifically — I had this written up as a MEDIUM (the previous `if (photoInput && (hasNewPhoto || requestedRemove))` discarded a Remove clicked during an upload, contradicting its own comment). The `photoRev` design that replaced it is sound: the rev is captured pre-await alongside `uploadedFile`/`hasNewPhoto`/`requestedRemove`; `photoInput` and `modal` are both captured references, so a replaced editor's input is never touched; the direct `teSaveQueued` write is guarded by `!teSaveQueued` (an already-queued manual save wins) and re-validated by the consumer's identity check at `:3558`; and the requeue terminates because the rerun captures the new rev.

## Remaining findings

**LOW — `js/app.js:3663` — a plain rename by an admin stops every autosave for an open editor, reported only in the footer**

`projectTitle` is the slot's only identity proxy, so an admin retitling a project (common, and not a swap) makes `freshTitle !== openedTitle`. For `auto: true` the save stops at `:3665` with a status-line message and no dialog. A teacher who doesn't watch the footer keeps typing against a dead autosave until they close, where `isTeEditDirty()` at least prompts. No data loss, but "Discard them?" is one wrong click from losing the session. Phase 9 made this trade for manual saves only; extending it to autosave is new. Fix (product call, not a code defect): on the first autosave stop of an editor session, escalate once — disable the autosave for that editor and surface it where the teacher will see it, rather than repeating a footer line every 2 s.

**LOW — `js/app.js:3361` — `bumpTePhotoRev()` fires before the file guards**

The bump precedes `if (!file) return;` and the 5 MB rejection. A rejected oversize file chosen during an in-flight save moves the rev, so that save skips the clear branch at `:3740` and queues an extra autosave which has nothing photo-related left to do. Harmless (one redundant no-op save), but the bump belongs below both guards — only a change that actually alters the photo state should count.

**LOW — `css/styles.css:29` — only half of the r1 CSS fix landed**

`--success` is still undefined, so `.auto-save-status { color: var(--success) }` (`:5145`) is invalid at computed-value time and "✓ Saved" inherits the body colour. That's now enough to distinguish it from the red "⚠️ Not saved", so the r1 concern is addressed — but `--success` is still dead at `:5145` and `:6705` (`.summer-project.complete`'s border falls back to `currentColor`, same as `.incomplete`'s equally-undefined `--warning`). Pre-existing and cosmetic.

**Note, not a defect** — diff-only saving means a lesson whose materials live only in the legacy free-text `materials` field no longer gets its parsed `materialsList` backfilled on an unrelated save (the derived value equals the baseline, so it is never "changed"). I checked every reader (`:955`, `:1491`, `:2731`, `:2804`, `:3052`, `:4299`) and each falls back to `lesson.materials`, so nothing degrades.

## Fresh pass — things I checked and found correct

- **Payload vs `buildLessonFieldUpdates`** (`js/firebase-data.js:1992`): a cleared content field is necessarily in both `changedFields` and `fieldsToClear`, so the stripped `''` always arrives as `FieldValue.delete()`; non-content clears (`inspoLink`, `shortDetails`, `materials`, `projectTitle`) ride as explicit `''`; `materialsList` arrays and the `planComplete` boolean survive the JSON pass; `updates` can never be empty because `saveSingleLesson` stamps `lastEditedBy/At` onto the payload object first (which is also what `:3752` relies on). The clear-matrix test pins all of it.
- **No silent-drop path.** `payload` is empty only when `requestedRemove && !hasNewPhoto && !lesson.photoUrl` — a remove of a photo the server no longer has — and then `changedFields` is empty too, so `logTeacherEdit` returns early and the baseline advance is a no-op. Every stop/failure path leaves `teOriginalData`, `photoInput.value` and `pendingRemove` untouched.
- **Serialization.** No deadlock (`Inner` catches everything; `finally` always clears the flag), no lost queue, the manual-beats-auto merge at `:3546` is right in all four orderings including `teSaveQueued === null` (`undefined === editor` → `false` → `true`), and `confirm()` blocking the chain can't produce a dialog loop — an accepted swap advances `serverTitle` before the queued rerun reads it, a cancelled one leaves the rerun as a quiet `auto` stop.
- **Existence check.** `weeklyRef.update()` can't create a document, and weekly slots are real Firestore writes (`createLessonSlotsForRoster` → `addMissingLessonSlots`, `:11672`), never in-memory scaffolds — so the check can't refuse a brand-new slot's first save. `pendingRemove` and `oldPhotoPath` both read the fresh copy, so a photo another client already removed or replaced is handled correctly in both directions.
- **Other callers.** `sendTeacherQaMessage`'s reopen (`:3909`) is safe: a save completing against the replaced editor hits `isCurrentEditor()` and leaves the new modal's baseline, status, `serverTitle` and `photoRev` alone. Firebase invariants hold — dotted-path partial updates only, no `setDoc`, every critical write awaited, no new collections, so no rules change.

## One thing blocking commit

`js/app.js` was last edited 3 minutes before I finished, and the Phase 7 block now has 17 tests including two written this round (`data-safety.spec.js:6785` "Remove clicked mid-save", `:6827` "unsaved photo counts as unsaved work"). I traced both against the landed `photoRev` code and expect them green, but neither they nor the other 15 have been run against this revision in my presence, and I was asked not to run the suite.

**NEEDS FIXES** — nothing I'd block on in the code itself (the three remaining findings are LOW and none risks data), but the verdict can't be SAFE TO COMMIT until `npm test` is green on this revision, since the implementation under review is minutes old and untested.
