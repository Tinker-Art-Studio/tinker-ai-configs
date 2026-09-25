# Review — Classbook SDOC Phase 2A.1 + Phase 2B (design, revision 1)

Reviewed: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html`
sections `#phase-2a1`, `#phase-2b`, and the Sep 25 Decisions Log entry. Code read-only @ `2894adf`;
rules @ studio-hub working tree.

**Citation check first:** every `file:line` in 2B is accurate at `2894adf` — `lessonStoreFor` 64,
`seasonForSemester` 113, `verifySummerLessonWrite` 1319, `saveSingleLesson` 1357,
`uploadSummerCampPhoto` 1536, `deleteLessonPhoto` 1560, `assertDayOffWritable` 1953,
`rebuildDayOffSlots` 2098, `dayOffAssertCampHasTitle` 2536, `readDayOffPlan` 2551,
`setDayOffMaterialCheck` 2649, `setDayOffCampSignoff` 2694; app.js 647-651, 527-562, 784-809,
1510-1577, 2066-2074, 4272/4371/4392, 7257-7284, 11162-11849 (11170-11184, 11200-11215, 11435-11438,
11547, 11578-11582, 11615-11621); `firestore.rules:699-703`; `storage.rules:12-18`. Nothing wrong found.
(The *model* section's citations are older — `canEditLesson()` is 564-574, not 518-528 — but the model
is context only.)

## Verdicts

| Section | Verdict |
|---|---|
| Phase 2A.1 — event materials checklist | **CHANGES NEEDED** (3 MEDIUM, 1 LOW — all mechanical) |
| Phase 2B — teachers plan their days | **CHANGES NEEDED** (2 HIGH, 3 MEDIUM) |
| Decisions Log, Sep 25 | **READY** — accurate to the code it summarises |

---

## Findings

### 1. HIGH — adding `'dayOff'` to `lessonStoreFor()` converts all six other callers from "throw" to "write weekly"

**Plan:** *"2B adds `SEMESTER_TYPES.dayOff → 'dayOff'` to that switch and audits its other six callers so
each still refuses SDOC explicitly."*

Every one of the six is an `=== 'camp'` test with a **weekly fall-through**, not a three-way branch:

- `saveLessonData` `firebase-data.js:811` → falls to `curriculum/lessonData.set({[semesterKey]: lessons}, {merge:true})` at `:817-821`
- `saveMultipleLessonFields` `:1465` → falls to `.update(combined)` at `:1494`
- `sendTeacherQaMessage` `app.js:3396-3403`, `sendHelpResponse` `:6913-6920`, `sendQaReply` `:6998-7005` → each handles `'camp'`, then writes dotted `{semKey}.{key}.qaThread` paths into the shared doc
- `adminLessonStillExistsWithRetry` `:5606` → `isSummer` false ⇒ reads the weekly doc, reports `exists:false`

Today the **throw at `firebase-data.js:71`** is the only thing stopping an SDOC key from creating a nested
map inside `curriculum/lessonData` — the May-2026 incident document. The comment at `:56-63` says exactly
this. "Audit" understates six required code edits, and the build order ("data branch (`lessonStoreFor` +
caller audit, …)") lets the switch land first.

**Fix (preferred): don't widen the switch at all.** Keep `lessonStoreFor()` throwing for `dayOff`, and put
`if (isDayOffYear(semesterKey)) return await saveDayOffPlan(...)` in `saveSingleLesson()` **before** the
`lessonStoreFor()` call at `:1373`. The other six keep throwing with zero edits and zero regression
surface, and the BDD scenario ("each refuses — no write") holds by construction. If the switch is widened
anyway, list the six refusal edits as explicit build steps and add a static check that no `=== 'camp'`
site lacks a `dayOff` arm.

### 2. HIGH — the SDOC edit gate can never resolve a name for a two-teacher camp

**Plan:** *"`canEditDayOffPlan(slot)` = `canPlanDayOffCamps()` or `slot.teachers` includes my name"*, with
`getTeacherNameForCurrentUser()` *"matching against the set of single names"*.

`app.js:527-562` builds its candidate set from `currentLessonData[getActiveSemesterKey()]` slot `.teacher`
values (`:541-543`). For SDOC every slot's `.teacher` is `teachers.join(' + ')` (`firebase-data.js:2115`).
So for a camp with two teachers — Christie's live "Mariah, Kaitlyn" year — the fallback yields no
single-name candidate, returns `null`, and **both assigned teachers get a read-only "View only" editor on
their own plan**. `populateTvTeacherList()`'s staff filter (`:794-796`) then produces an empty list, so
nothing is selectable either.

**Fix:** the plan already prescribes the single-name set; it must additionally (a) say this is a
*separate* SDOC name resolver taking the yearKey, not a patch inside the shared function (whose
weekly/summer behaviour must not move), and (b) add a BDD scenario where a **two-teacher** camp's second
teacher opens and saves **with no `teacherMappings[uid]` entry** — today's scenario would pass with this
bug if the fixture happens to have a mapping.

### 3. MEDIUM — the payload allow-list does not cover `fieldsToClear`

**Plan:** *"only CONTENT_FIELDS, photoUrl, photoPath, planComplete, lastEditedBy, lastEditedAt from the
caller; anything else is dropped"* — and *"the client's payload allow-list below is the only thing keeping
teacher saves off `materialItems`/`materialChecks`/sign-off docs."*

`fieldsToClear` is a **separate parameter** (`firebase-data.js:1357`), applied after sanitisation as
`FieldValue.delete()` and explicitly *"not restricted to CONTENT_FIELDS"* (`:1348-1356`, `:1391-1393`). A
clear list naming `materialItems` deletes the planner's whole list; naming `campId`/`yearKey` makes the doc
invisible to `loadDayOffCampData`'s `where('yearKey')` query (`:2076-2087`) — the plan's own "data appears
missing" failure mode.

**Fix:** intersect `fieldsToClear` with the same allow-list in the dayOff branch. Add a spy test that a
clear of `materialItems` is dropped. Also add a BDD case for the *normal* clear path (a content field that
had text and is now empty) — the current BDD never exercises it.

### 4. MEDIUM — `initTeacherView()`'s SDOC branch returns before the listeners are bound

`app.js:647-651` sets `tvInitialized = false` and returns. Below it sit the auto-select block (`:661-684`),
the `teacherSelect` change listener (`:686-693`) and the `tv-class-filter` listener (`:695-699`). If the
branch keeps returning early, the SDOC teacher picker is **inert** for managers. If it stops returning
early with `tvInitialized` still reset, `setupLessonDataListener()` (`:620`) re-subscribes on every visit
and the listeners stack.

**Fix:** state what the SDOC branch does with `tvInitialized` and `setupLessonDataListener`, and guard the
change listener with a `dataset.listenerAttached` flag as `renderTvSemesterSelector()` does at `:743`.
BDD: a manager switches the SDOC teacher picker twice and gets exactly one render each time.

### 5. MEDIUM — the editor-split table misses four summer-only pieces the shared body still runs

**Plan:** *"Inside, `isDayOffYear(semKey)` switches only these pieces."* It misses:

- `markQaAsRead(lessonKey)` `:11190` — a localStorage read-mark for a thread SDOC will never have
- the "Project Reference Materials" collapsible `:11234-11245` — renders `projectDetails` /
  `projectInspiration` / `projectAdminNotes`, none of which exist on an SDOC slot
  (`buildDayOffSlots`, `firebase-data.js:2101-2125`) ⇒ an empty section
- the **Print button** `:11838-11840` → `printProject(campName, projectTitle)`, which the plan itself lists
  under "Not used for SDOC (`:11851`)" — it must be *hidden*, not merely unused
- `finishClose()` `:11793-11831` closes over the outer `campName/projectTitle/block` **parameters**, which
  `openPlanEditor(semKey, lessonKey)` will no longer have; and the backdrop handler `:11849` closes the
  modal, contradicting Christie's Sep 24 "both SDOC editors no longer close on a backdrop click
  (`data-sticky`)"

### 6. MEDIUM — 2A.1: re-keying `pendingDayOffTicks` breaks the per-project popup's double-tick guard

**Plan:** *"shares the `pendingDayOffTicks` set keyed by `lessonKey|itemId`."* Both existing reads key by
the bare item id: the guard at `app.js:12752` and the render at `:12679`
(`${pendingDayOffTicks.has(it.id) ? 'disabled' : ''}`). Re-keying without changing both silently disables
the guard M3 and M14 were written for.

**Fix:** name both sites as edits; keep M14 and add a 2A.1 twin that double-ticks one item from the event
checklist while the first write is in flight.

### 7. MEDIUM — 2A.1: sign-off refreshes `currentDayOffPlans`, but the view holds its own `plans` Map

`markDayOffCampComplete()` (`app.js:12769-12787`) calls `readDayOffPlan()` for **every** title of the camp
at `:12777` before computing `expected`. That refreshes `currentDayOffPlans`, not
`dayOffEventMaterialsView.plans`. An `onDone` that just re-renders would show "✓ Materials complete" beside
counts from before the refresh.

**Fix:** the `onDone` must re-sync every `lessonKey` of that camp from `currentDayOffPlans` into the view
Map (the tick path already does this for one key), then render.

### 8. LOW — 2A.1: `markDayOffCampComplete()` takes its year from `getAdminSemKey()` (`:12770`)

The event checklist carries its own `yearKey`. A semester change while the popup is open would write the
sign-off under `dayOffSignoffDocId(wrongYearKey, campId)`. Pass `v.yearKey` explicitly, or close the popup
on a semester change.

### 9. LOW — `verifySummerLessonWrite()` returns nothing, so "install the read-back" needs `readDayOffPlan()`

`firebase-data.js:1319-1340` returns `undefined`; it only throws. Every 2A writer installs via
`readDayOffPlan()` (`:2551`), which does the forced server read, installs into `currentDayOffPlans`, and
deletes the key when the doc has moved. Say that, and decide the message for the benign case: if a rename
commits between the save's commit and the read-back, the read-back finds nothing and the teacher sees
"Save may not have completed" even though `saveDayOffCamp`'s move carried their text (`:2414-2418`).

### 10. LOW — photo path: signature and path disagree

`uploadDayOffPlanPhoto(yearKey, lessonKey, file)` vs `curriculum/{yearKey}/{planDocId}/demo-{unique}.jpg`.
Say `dayOffPlanDocId(yearKey, campId, title)` (`:2071`). `storage.rules:12-18`'s `{allPaths=**}` matches
either, so this is spec hygiene, not a rules gap. Worth noting that `getPhotoPath()` (`:1515`) already
emits exactly this shape with `uniquePhotoSuffix()` — the new function is only the guard wrapper.

### 11. LOW — the model's round-2 `mergeSummerReload()` flag is left dangling

The model still says *"Phase 2's editor design must extend the kept-fields list for SDOC slots"*. It is
moot: the reload already runs `mergeSummerReload()` on SDOC years (`firebase-data.js:1139-1141`), and
`SUMMER_SAVED_FIELDS` (`:1016`) is **exactly** 2B's allow-list, while `materialsList` is superseded by 2A's
`materialItems`. One sentence in 2B so a reviewer doesn't read it as dropped.

---

## Questions answered where nothing needs changing

- **Q2 — transaction soundness: sound, and worth stating the argument in the plan.** The reason the save
  transaction is safe is that it reads `campRef`, and `saveDayOffCamp`'s rename transaction *always*
  `tx.update(campRef, …)` (`firebase-data.js:2412`). The compat SDK's optimistic read-set check therefore
  forces a retry, and the retry fails `dayOffAssertCampHasTitle()` (`:2536`). Same protection against
  `deleteDayOffCamp` (`:2489-2504`). The tick/sign-off transactions read the plan doc, so a concurrent save
  retries; `set(…, {merge:true})` never clobbers `materialChecks`. No residual race found. Record the
  "camp read is the lock" reasoning — it is the whole argument and it is currently implicit.
- **Q7 — publish inventory is complete.** `isPublishableType()` has exactly three consumers: `app.js:4272`
  (CA bar), `:4371` (`toggleSemesterPublish`), `:10414` (Settings). `canSeeSemester()` (`:277-283`) already
  admits a published SDOC year for plain teachers. Nothing else gates it.
- **Q6 — permissions are consistent.** `canPlanDayOffCamps()` (`:261-266`) mirrors `firestore.rules:690`
  and `:695`; `canTickDayOffMaterials()` (`:268-272`) mirrors the `hasAppAccess('classbook')` clause on
  `:700-701`. `canEditDayOffPlan` excluding `hasPrepAccess()` (`:291-295`, honoured by `canEditLesson()`
  `:568`) is a deliberate UI narrowing of a rule that *allows* the write — right for Christie's Sep 24
  "view-only", and correctly flagged for her.
- **Q8 — XSS in 2A.1 is handled.** Item ids come through `DAY_OFF_ITEM_ID` (`firebase-data.js:1922-1925`)
  and the handler reads `dataset`, never an interpolated `onclick` — the 2A review finding is correctly
  carried. The hostile-title/item-name test is the right one to keep.

## BDD gaps beyond those named above

- No scenario asserts the 2B save leaves the camp's **sign-off doc**
  (`dayOffCamps_lessonData/{dayOffSignoffDocId}`) byte-identical — the current one checks only
  `materialItems`/`materialChecks`.
- No scenario runs a teacher save while `scheduleDayOffReload()` (`:2525-2529`) is mid-flight — that is the
  `mergeSummerReload` path (#11) and it is now reachable for the first time, because 2B is what puts
  `lastEditedAt` on an SDOC slot.
- 2A.1's "spy asserts the only writes are 2A's tick/sign-off transactions" should also assert **no**
  `dayOffCamps_camps` write — the checklist reads camps but must never touch them.
