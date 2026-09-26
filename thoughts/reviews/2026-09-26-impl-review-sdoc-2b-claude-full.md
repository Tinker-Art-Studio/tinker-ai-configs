# Implementation review — Classbook SDOC Phase 2B (teachers plan their days)

Branch `sdoc-2b-teacher-plans`, uncommitted tree vs `main` (218f622). Read-only review against
`~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2b` (revision 7).

## Verdict: CHANGES NEEDED — two small fixes (F1, F2); the rest are follow-ups

No path I could find loses or corrupts a plan, materials, ticks, the sign-off doc,
`curriculum/lessonData`, or a summer lesson. The save branch, allow-lists, edit-stamp verifier,
photo-pair translation and the editor split all match the design and read correctly. `node --check`
passes on all three changed JS files.

### What I verified clean

- **Save path.** The SDOC branch sits after the stamping lines and before `lessonStoreFor()`
  (`js/firebase-data.js:1378`), so the six other callers keep refusing by construction — I read all
  four `lessonStoreFor` call sites in app.js (`:3618`, `:7135`, `:7220`, plus `saveLessonData`) and
  each catches the throw and refuses out loud. Allow-lists cover both payload and clears; identity
  and `lastEditId` are applied last and are not caller-writable; `editId` is minted once before the
  transaction. Transaction is compat-correct (both `tx.get`s precede the `tx.set`), the camp read is
  a genuine lock, and the in-transaction re-check of `camp.teachers` is present.
- **Photo pair.** `photoUrl`/`photoPath` empty-pair → `FieldValue.delete()` of both, half-empty pair
  throws, and the removed pair is counted as *cleared* not *written* (`:2627-2631`), so a removal
  can't fail its own strict check. Old object deleted only after the verified save, against
  `savedLesson.photoPath` — so a co-teacher's replacement survives and only my own old object goes.
- **Summer preservation.** `openPlanEditor` has no `await` on the summer path, so the modal is still
  built synchronously; `campName/projectTitle/block` destructured from `lesson` are provably the same
  values the old parameters carried (the caller's loop matched on all three); Print binding is now
  optional-chained so the close handlers below it always bind; Q&A, reference section, backdrop
  close, post-save cache re-install, failure revert and displaced-copy adoption are untouched for
  summer. The existing `openModal()` helper in `data-safety.spec.js:59` drives every summer editor
  test through `openLessonModal`, so the split is exercised by the pinned suite.
- **XSS.** Everything in the new markup is escaped; keys travel only in `data-` attributes and are
  read back via `this.dataset` / `CSS.escape`. No `escForOnclick` needed.
- **Read-only mode** is really read-only: `#summer-photo-input` lives inside the hidden
  `#summer-photo-upload-area`, `.te-photo-remove-btn` is hidden, Save is hidden, and `saveLesson()`
  re-checks `canEditDayOffPlan` anyway (`js/app.js:11702`).
- **Initial-load reload path** (`js/firebase-data.js:776`) is covered by the in-loader protection, so
  it needs no `mergeSummerReload` change.

---

## Findings

### F1 — MEDIUM — the reload protection has a window with two or more SDOC years
`js/firebase-data.js:2107`, `:2122-2126`, `:1043`, `:1130-1133`

`protectedKeys` is frozen when *that year's* `loadDayOffCampData()` finishes, but it is consumed later,
after every remaining year's queries have awaited (`for (const yearKey of dayOffKeys) fresh[yearKey] =
await loadDayOffCampData(...)`). With one SDOC year there is no window (lines 1131-1133 are
synchronous). With two, a save verified while year B is querying is not in year A's already-computed
set, so `mergeSummerReload` installs A's pre-save `fresh` map into `currentLessonData` —
`keepMine` can't save it either, because `previous[key]` is the same pre-save copy. `currentDayOffPlans`
keeps the verified doc, so nothing is lost and the next reload heals it, but the list shows pre-save
status/`planComplete` until then. The design's guarantee ("a reload must not undo a verified save") is
only met for a single year today, and Christie will have a second SDOC year next August.

**Fix:** evaluate protection at install time instead of at query time. Return `startSeq` from
`loadDayOffCampData` (e.g. as a second non-enumerable property) and in `mergeSummerReload` test
`dayOffVerifiedAt[semKey]?.[key] > startSeq` per key, rather than passing a pre-built `Set`. Keep the
in-loader `plans[key] = verified` as-is for the initial-load path.

### F2 — MEDIUM (test) — T12's "no write attempted" assertion is vacuous
`e2e/day-off-teacher.spec.js:431-437`

It sets `document.getElementById('summer-intro-pitch').value = 'x'` and counts `runTransaction`
calls. A programmatic `.value` assignment fires no `input` event, so `triggerAutoSave` never arms —
`writes === 0` would hold even if the read-only gate were deleted entirely. This is the design's
"no write is attempted (spy)" case, and it currently proves nothing.

**Fix:** after setting `.value`, dispatch the event the real UI would:
`el.dispatchEvent(new Event('input', { bubbles: true }))`, then wait 2600 ms and assert 0. (`page.fill`
can't be used — the textarea is `readOnly`.) That exercises `saveLesson()`'s `canEditDayOffPlan` gate.

### F3 — MEDIUM (test) — five design BDD cases have no test
T1–T17 are strong and I could not construct a broken implementation that passes them for the *save
path*. These listed cases are missing:

1. **Save fails after a new photo uploaded** — old photo still exists, Firestore still points at it,
   the new upload is an orphan at its own path, clear error. This is the one photo path where a bug
   breaks an image, and T10 only covers success.
2. **Sign-off doc byte-identical before/after a teacher save in a signed-off camp.** Structurally safe
   (the save touches only `planRef`), but it is the listed pin.
3. **`sendTeacherQaMessage` / `sendHelpResponse` / `sendQaReply` refuse an SDOC key.** T14 covers only
   four of the six sites. I read all three and they do refuse, so this is a pin, not a bug.
4. **Photo removal racing a co-teacher's replacement** → "edited since", replacement stays, only my old
   object deleted.
5. **Switching Teacher View SDOC ↔ weekly/summer** — untested, and it is where F4/F5 live.

### F4 — LOW — the teacher picker stays hidden after leaving an SDOC year
`js/app.js:1692` vs `:1596`

`syncDayOffTeacherPicker` hides `select.closest('.tv-control-group')` for a single-name staff user, and
the non-SDOC path of `renderTeacherView` restores only the *class* filter group. Nothing restores the
teacher group: `populateTvTeacherList` (`:873`) targets `.tv-teacher-selector`, which does not exist in
`index.html` — that branch has always been dead. So a plain teacher who views an SDOC year and then
switches to a weekly semester loses the (harmless, single-name) teacher dropdown until reload.

**Fix:** at `:1596`, restore the teacher group alongside the class group, or have
`syncDayOffTeacherPicker` hide the same element `populateTvTeacherList` intends to.

### F5 — LOW — leaving SDOC clears the rebuild flag even when it can't rebuild
`js/app.js:1601-1611`

`tvTeacherListFor = null` is set before the `if (lessons)` guard. For a semester with no lesson map yet
(a brand-new weekly semester), the picker keeps the SDOC single names and no later render will rebuild
it. **Fix:** only clear `tvTeacherListFor` inside the `if (lessons)` branch.

### F6 — LOW — deviation: `escHtml`/`escAttr` instead of the design's `sdocEsc`/`sdocEscA`
`js/app.js:1717-1755`, `:11468-11475`

The design says "All text via sdocEsc/sdocEscA". `escHtml` is `str.replace(...)` — it throws on a
non-string. Every field used (`camp.title`, `timeSlot`, `timeLabel`, `location`, `placements[].*`,
`ev.label`) is validated non-empty by `validateDayOffCamp`, so this is safe today; but a single missing
field makes the whole Teacher View render throw rather than degrade. `sdocEsc` (`js/app.js:12395`) is
the null-safe wrapper already in the file. Cheap swap.

### F7 — LOW — `readDayOffPlanForEditor` duplicates `readDayOffPlan`
`js/firebase-data.js:2599-2606` vs `:2758-2766`

Same server read and same cache install, written twice. Prefer
`const data = await readDayOffPlan(yearKey, slot.campId, slot.projectTitle)` then
`dayOffInstallVerified(yearKey, lessonKey, data)`.

### F8 — LOW — `.view-only` has no CSS and textareas are `readOnly`, not `disabled`
`js/app.js:11586-11587`, `css/styles.css` (nothing added)

The design says "every input is disabled". `readOnly` textareas look fully editable; the only cue is
"View only" in the footer. Add a `.view-only textarea { background: …; cursor: default }` rule (or set
`disabled`) so a viewer isn't left typing into a dead field.

---

## Notes, not findings

- `verifyDayOffPlanWrite`'s strict identity check will report a false "Save may not have completed"
  if the planner moves the camp to another event between commit and read-back. The design chose strict
  identity deliberately; recording it only.
- Unticking Plan complete on a plan with no document creates an otherwise-empty doc carrying
  `planComplete: false` + identity. `dayOffPlanHasUserData()` treats it as removable, so it is harmless.
- `closeModal` saves pending text rather than asking before discarding (design: "× asks before
  discarding unsaved text"). Saving is the stronger behaviour; no change wanted.
- `dayOffAuthFor` inlines the `classbook` check because the design's `hasAppAccess()` does not exist in
  this codebase. Correct call.
