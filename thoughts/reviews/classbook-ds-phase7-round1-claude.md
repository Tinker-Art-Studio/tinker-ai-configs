I reviewed the working tree, not just the handed-over diff — and the tree moved while I was reading it.

**Note on scope:** `/private/tmp/.../phase7.diff` is stale. Since the review started, `js/app.js` grew (280 → 313 changed lines), `e2e/data-safety.spec.js` grew (326 → 488), and a third file appeared — `e2e/spring-own-doc.spec.js`. Several issues I had drafted (baseline read after the await, the stale 1.5 s timer wiping the ⚠️ status, `getTvSemKey()` read live at save time instead of captured) are already fixed in the current tree, with tests labelled "review r1". Findings below are against the tree as of now. I did not run `npm test` (per your instruction).

---

## Findings

**MEDIUM — `js/app.js:3717` — `pendingRemove` survives a save that uploaded a new photo, and the next autosave deletes that photo**

`if (photoInput?.dataset?.pendingRemove === 'true' && !hasNewPhoto) photoInput.dataset.pendingRemove = '';` — the pre-change code cleared the flag unconditionally on the success path. The two states are normally mutually exclusive only because the file-picker's `reader.onload` (`js/app.js:3376`) clears `pendingRemove`, and that handler has no `onerror`. Scenario: teacher clicks "× Remove" on an existing photo (`pendingRemove='true'`), then picks a replacement; the `FileReader` fails or never fires (revoked file handle, decode failure). Save: `hasNewPhoto` is true, the upload and write land correctly, line 3717 skips the reset. The flag is still `'true'`, so the next autosave gets past the "nothing to save" early return at 3596 *because of that flag*, takes the `pendingRemove` branch (3657/3685), writes `photoUrl: ''`/`photoPath: ''` and then deletes the just-uploaded object from Storage at 3704. Silent photo loss.
Fix: `if (photoInput) photoInput.dataset.pendingRemove = '';`

**MEDIUM — `js/app.js:3627-3630` — the existence check runs on every autosave, and it is a cache-bypassing read of the whole semester document**

Not a defect, a cost decision the plan never evaluated and which I don't think should ship unsigned-off. `adminLessonStillExistsWithRetry` → `readAdminLessonDoc(..., {source:'server'})` → `readWeeklySemesterMap` (`js/firebase-data.js:207`) fetches the entire semester map, forced to the server. For `fall-2026` that target is the shared `curriculum/lessonData` document (your storage note puts it near 44% of 1 MiB); for every other weekly semester it's that semester's own `curriculum/lessons_<key>` doc. Phase 9 pays this once per explicit Save click; here the 2 s autosave pays it too, so a teacher writing a plan on a phone in class triggers one full-document download per pause in typing. Options: keep it unconditional for manual Save and for autosave run it only on the first autosave of an editor session plus at most every N seconds thereafter; or raise the autosave debounce. Both reopen a bounded TOCTOU window — which Phase 9 already accepts by design — so it's a trade, your call, not mine.

**LOW — `js/app.js:3610` (and pre-existing at 3776) — the autosave's "Not saved" warning renders in the same colour as "✓ Saved"**

Neither `--error` nor `--success` is defined in `:root` (`css/styles.css:3`). `color: var(--error)` is therefore invalid at computed-value time, and `color` falls back to `inherit` — the same colour `.auto-save-status`'s own `color: var(--success)` already resolves to. For a manual save the `alert()` carries the message, but for an autosave stop that status line is the *only* signal, and the ⚠️ emoji is the only thing distinguishing it. Fix: add `--error`/`--success` to `:root`, or use a literal colour at 3610/3776.

**LOW — coverage gap: "remove photo" when the server already has none** (`js/app.js:3657`, `3697`)

This is the one branch where `saveSingleLesson` is skipped entirely (`payload` empty) while the baseline is still advanced and the UI says "✓ Saved". I traced it and it is correct — no write, no delete, `logTeacherEdit` returns early on an empty `changedFields`, the cache is rebased on the fresh copy — but nothing pins it.

**LOW — coverage gap: rewritten Test 7 drops its Stage 1B regression assertion** (`e2e/data-safety.spec.js:268`)

The old test proved the call sites pass `currentLessonData[...][key]` rather than the stale `lesson` closure. Phase 7 makes that irrelevant to the *payload*, but `originalLesson` is still what `lesson` falls back to for a non-weekly semester (`js/app.js:3626`), where it feeds the local cache, the change log and the photo-delete target. The `|| lesson` fallbacks at 3324/3334/3559 are now unasserted anywhere.

---

## Verified as correct

- **Diff vs. `buildLessonFieldUpdates` (`js/firebase-data.js:1992`).** Empty `CONTENT_FIELDS` are stripped, but a changed-and-now-empty content field is by construction always in `fieldsToClear` too (baseline non-empty ⇒ changed), so a clear always travels as `FieldValue.delete()`. Non-content clears (`inspoLink`, `shortDetails`, `materials`) ride as explicit `''`. `materialsList` arrays and the `planComplete` boolean survive the `JSON.parse(JSON.stringify())` pass. `updates` can never be empty — `saveSingleLesson` stamps `lastEditedBy/At` first. The new clear-matrix test pins all of this.
- **No silent-drop path found.** `payload` empty ⟺ the early return would have fired, except the photo-remove no-op above. The camp branch's `hasContent` guard (which *would* silently swallow a title-only diff payload) is unreachable: `renderTeacherView` routes camps to `renderSummerCampView` and SDOC years to `renderDayOffTeacherView` before any `tv-edit-btn`/`openLessonDetailModal` is rendered.
- **Serialization.** No deadlock (`Inner` catches everything; the `finally` always clears the flag), no lost queue (`teSaveInFlight` flips and the recursive call re-arms it with no interleaving window), the manual-beats-auto merge is correct in all four orderings, and the queued rerun is correctly keyed on the *editor element* plus its lesson key. `teStatusTimer` is cleared at the top of every save and its callback re-checks `isCurrentEditor() && !teSaveInFlight`.
- **Title check false positives.** `modal.dataset.serverTitle` is advanced from `updatedLesson.projectTitle` after each success, so this editor's own rename doesn't re-prompt, and accepting a swap doesn't re-prompt on later saves (test 52 pins it). Another admin's rename *does* prompt — correct per the Phase 9 design, just worth knowing it's a rename, not only a swap.
- **The new tests genuinely fail against the old code.** Payload keys (old sent the whole lesson), concurrent edit (old resent stale `processStep3`/photo/materials), moved/deleted (old had no check, the dotted-path update recreates the key), swapped, read-fails-closed (`__readCalls` would be 0), typed-during-save (old re-read the DOM into the baseline), overlapping saves (old would log and write twice), photo guard (old sent the stale `photoPath` and deleted the wrong object). Test 7's rewrite is also genuinely RED.
- **`e2e/spring-own-doc.spec.js:282`** — the ratchet rename to `saveTeacherEditInner` is necessary and correct; I confirmed `refuseIfWeeklySemesterPaused` is still before the first `await` inside the new inner function, and that `body()`'s `\n}\n` slice terminates at the right brace.
- **Other callers.** `sendTeacherQaMessage`'s reopen at `js/app.js:3904` is unaffected — a save finishing against the replaced editor hits the `isCurrentEditor()` guard and leaves the new modal's baseline, status and `serverTitle` alone (pinned by the keyA/keyB test). No Firebase-invariant violations: `updateDoc`-style per-field paths only, no new collections, so no rules change.

**Verdict: NEEDS FIXES** — the `pendingRemove` reset at `js/app.js:3717`, plus a decision from you on the per-autosave server read.
