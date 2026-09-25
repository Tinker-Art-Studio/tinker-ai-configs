Full review written to `/Users/christiehubley/.claude/plans/plan-review-jiggly-lemon.md`. Here it is.

**Citation check:** every `file:line` in 2B is accurate at `2894adf` — I spot-checked all ~30 (`lessonStoreFor` 64, `saveSingleLesson` 1357, `verifySummerLessonWrite` 1319, `dayOffAssertCampHasTitle` 2536, `readDayOffPlan` 2551, `setDayOffMaterialCheck` 2649, `setDayOffCampSignoff` 2694, app.js 647-651 / 527-562 / 784-809 / 1510-1577 / 2066-2074 / 4272 / 4371 / 4392 / 7257-7284 / 11162-11849, `firestore.rules:699-703`, `storage.rules:12-18`). Nothing wrong. The *model* section's citations are older (`canEditLesson()` is 564-574, not 518-528).

| Section | Verdict |
|---|---|
| **Phase 2A.1** — event materials checklist | **CHANGES NEEDED** (3 MEDIUM, 1 LOW — all mechanical) |
| **Phase 2B** — teachers plan their days | **CHANGES NEEDED** (2 HIGH, 3 MEDIUM) |
| **Decisions Log, Sep 25** | **READY** — accurate to the code it summarises |

---

### 1. HIGH — adding `'dayOff'` to `lessonStoreFor()` turns all six other callers from "throw" into "write weekly"

Plan: *"adds `SEMESTER_TYPES.dayOff → 'dayOff'` to that switch and **audits** its other six callers so each still refuses SDOC explicitly."*

Every one of the six is an `=== 'camp'` test with a **weekly fall-through**, not a three-way branch:
- `saveLessonData` `firebase-data.js:811` → `curriculum/lessonData.set({[semesterKey]: lessons}, {merge:true})` at `:817-821`
- `saveMultipleLessonFields` `:1465` → `.update(combined)` at `:1494`
- `sendTeacherQaMessage` `app.js:3396`, `sendHelpResponse` `:6913`, `sendQaReply` `:6998` → dotted `{semKey}.{key}.qaThread` into the shared doc
- `adminLessonStillExistsWithRetry` `:5606` → reads the weekly doc, reports `exists:false`

The throw at `firebase-data.js:71` is today the *only* thing keeping an SDOC key out of `curriculum/lessonData` — the May-2026 incident document. "Audit" understates six required edits, and the build order lets the switch land first.

**Fix — don't widen the switch.** Keep `lessonStoreFor()` throwing for `dayOff`; put `if (isDayOffYear(semesterKey)) return await saveDayOffPlan(...)` in `saveSingleLesson()` **before** the `lessonStoreFor()` call at `:1373`. Six callers unchanged, zero regression surface, and the BDD "each refuses — no write" holds by construction.

### 2. HIGH — the edit gate can never resolve a name for a two-teacher camp

`getTeacherNameForCurrentUser()` (`app.js:527-562`) builds candidates from slot `.teacher` values (`:541-543`). For SDOC every slot's `.teacher` is `teachers.join(' + ')` (`firebase-data.js:2115`). For Christie's live Mariah/Kaitlyn camps the fallback returns `null` → `canEditDayOffPlan` false → **both assigned teachers get a read-only "View only" editor on their own plan**, and `populateTvTeacherList()`'s staff filter (`:794-796`) empties the picker.

The plan prescribes the single-name set, but must add: (a) it's a *separate* SDOC resolver taking the yearKey, not a patch inside the shared one; (b) a BDD case where the **second** teacher of a two-teacher camp saves **with no `teacherMappings[uid]`** — today's scenario would pass with the bug if the fixture has a mapping.

### 3. MEDIUM — the payload allow-list doesn't cover `fieldsToClear`

`fieldsToClear` is a separate parameter (`firebase-data.js:1357`), applied as `FieldValue.delete()` after sanitisation and explicitly *"not restricted to CONTENT_FIELDS"* (`:1348-1356`, `:1391-1393`). A clear naming `materialItems` deletes the planner's list; naming `campId`/`yearKey` makes the doc invisible to `loadDayOffCampData`'s query (`:2076-2087`) — the plan's own "data appears missing" mode. Intersect `fieldsToClear` with the same allow-list; add a spy test. The BDD also never exercises the *normal* clear path.

### 4. MEDIUM — `initTeacherView()`'s SDOC branch returns before the listeners bind

`app.js:647-651` sets `tvInitialized = false` and returns — above the auto-select block (`:661-684`), the `teacherSelect` change listener (`:686-693`) and `tv-class-filter` (`:695-699`). Keep returning early → the SDOC picker is inert. Stop returning early with `tvInitialized` still reset → `setupLessonDataListener()` (`:620`) re-subscribes each visit and listeners stack. Say what happens to both; guard with `dataset.listenerAttached` as `:743` does.

### 5. MEDIUM — the editor-split table misses four summer-only pieces

Plan: *"switches only these pieces."* It misses `markQaAsRead(lessonKey)` `:11190`; the "Project Reference Materials" collapsible `:11234-11245` (renders `projectDetails`/`projectInspiration`/`projectAdminNotes`, none on an SDOC slot → empty section); the **Print button** `:11838-11840` → `printProject(campName, projectTitle)`, which the plan itself lists as unused — it must be *hidden*; and `finishClose()` `:11793-11831`, which closes over the outer `campName/projectTitle/block` **parameters** `openPlanEditor(semKey, lessonKey)` won't have. Also `:11849` closes on backdrop, contradicting Christie's Sep 24 `data-sticky` decision for SDOC editors.

### 6. MEDIUM — 2A.1: re-keying `pendingDayOffTicks` breaks the existing double-tick guard

Both reads key by the bare item id: `app.js:12752` and the render at `:12679`. Re-keying to `lessonKey|itemId` without changing both silently disables the guard M3/M14 were written for. Name both sites; add a 2A.1 twin of M14.

### 7. MEDIUM — 2A.1: sign-off refreshes `currentDayOffPlans`, not the view's `plans` Map

`markDayOffCampComplete()` (`:12769-12787`) calls `readDayOffPlan()` for **every** title at `:12777`. An `onDone` that just re-renders shows "✓ Materials complete" beside pre-refresh counts. The `onDone` must re-sync every `lessonKey` of that camp from `currentDayOffPlans` first.

### 8–11 LOW
- `markDayOffCampComplete()` takes its year from `getAdminSemKey()` (`:12770`); the checklist has its own `yearKey` — pass it.
- `verifySummerLessonWrite()` (`:1319-1340`) returns `undefined`; "install the read-back" needs `readDayOffPlan()` (`:2551`), as every 2A writer does. Decide the message for the benign case where a rename commits between commit and read-back (`saveDayOffCamp` already carried the text, `:2414-2418`).
- Photo path: signature says `lessonKey`, path says `{planDocId}` — use `dayOffPlanDocId()` (`:2071`). `getPhotoPath()` (`:1515`) already emits this exact shape with `uniquePhotoSuffix()`.
- The model's round-2 `mergeSummerReload()` flag is now moot — the reload already runs it on SDOC years (`:1139-1141`) and `SUMMER_SAVED_FIELDS` (`:1016`) *is* 2B's allow-list. One sentence so it doesn't read as dropped.

---

### Where nothing needs changing

- **Q2, transactions: sound.** The reason is that the save transaction reads `campRef` and `saveDayOffCamp`'s rename *always* `tx.update(campRef, …)` (`:2412`) — so the compat SDK's read-set check forces a retry, and the retry fails `dayOffAssertCampHasTitle()` (`:2536`). Same against `deleteDayOffCamp` (`:2489-2504`). Tick/sign-off read the plan doc, so a concurrent save retries; `set(…, {merge:true})` never clobbers `materialChecks`. No residual race found — but **record the "camp read is the lock" argument in the plan**; it's currently implicit.
- **Q7, publish: complete.** `isPublishableType()` has exactly three consumers — `:4272`, `:4371`, `:10414`. `canSeeSemester()` (`:277-283`) already admits a published SDOC year for plain teachers.
- **Q6, permissions: consistent.** `canPlanDayOffCamps()` (`:261-266`) ↔ `firestore.rules:690`/`695`; `canTickDayOffMaterials()` (`:268-272`) ↔ `:700-701`. Excluding `hasPrepAccess()` is a deliberate UI narrowing of a rule that allows the write — right for Sep 24, correctly flagged.
- **Q8, XSS: handled.** Ids via `DAY_OFF_ITEM_ID` (`:1922-1925`), handler reads `dataset`.

### BDD gaps beyond those above
No scenario asserts the sign-off doc is byte-identical after a teacher save (only `materialItems`/`materialChecks`); none runs a save while `scheduleDayOffReload()` (`:2525-2529`) is mid-flight — newly reachable, because 2B is what first puts `lastEditedAt` on an SDOC slot; 2A.1's write-spy should also assert **no** `dayOffCamps_camps` write.

I made no changes to the app, the rules, or the plan document — only the review file above.
