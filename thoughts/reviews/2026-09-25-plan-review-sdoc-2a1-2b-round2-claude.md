# Round-2 confirmation review — SDOC 2A.1 + 2B, revision 2

| Section | Verdict |
|---|---|
| **Phase 2A.1** | **CHANGES NEEDED** (1 MEDIUM, 1 LOW) |
| **Phase 2B** | **CHANGES NEEDED** (1 HIGH, 4 MEDIUM, 1 LOW) |
| **Decisions Log, Sep 25 ×2** | **READY** |

## 1. Round-1 fixes — all correct

Every Codex finding (10) and Claude finding (11) is present in revision 2 and accurate against `2894adf`. Spot-verified the load-bearing ones: `fieldsToClear` really is unrestricted (`firebase-data.js:1348-1356`, `:1393`); `verifySummerLessonWrite()` really checks only non-emptiness and returns nothing (`:1319-1340`); `lessonStoreFor()` still throws for `dayOff` (`:64-72`) and the branch-before approach leaves all six callers untouched; `mergeSummerReload()` *does* run on SDOC years (`:1127`) and `SUMMER_SAVED_FIELDS` (`:1016`) is exactly 2B's writable set, so the model's "superseded" note is right. Kathy/Allie's edit right is consistent with the rules: `canTickDayOffMaterials()` (`app.js:268-272`) requires the `classbook` key `firestore.rules:700-701` needs.

Nothing regressed. The editor-split table, listener branches, `pendingDayOffTicks` re-keying, sign-off re-sync and all three new BDD gaps are in.

## 2. New findings

**F2 — HIGH — the strict read-back turns "last save wins" into a false failure.** ¶23 has the verifier check every written value *equals* what was sent. `verifySummerLessonWrite()` only checks non-emptiness (`firebase-data.js:1336`), which is why summer never hits this. Two teachers on one camp (the point of D4) editing `closure` seconds apart: the earlier saver's forced read returns the later value and throws *"Save may not have completed"*. Her natural response — re-save — clobbers the other teacher. Also fires on `lastEditedBy/At` every time, and on `planComplete` ticked from the list mid-save. **Fix:** strict equality for the identity stamp and cleared-field absence only; for content/photo/`planComplete` accept equality *or* a server `lastEditedAt` newer than mine (`lessonEditedAtMs`, `:1009`) as a benign overwrite with its own message.

**F1 — MEDIUM — the branch's inputs have no home.** ¶17 calls `saveDayOffPlan(semesterKey, lessonKey, ref, lessonData, fieldsToClear)`; `ref` is undefined anywhere in the plan, and `saveSingleLesson` has four parameters (`:1357`), both callers passing exactly those (`app.js:11606`, `:2120`). ¶21 requires `{yearKey, campId, projectTitle}` "from the slot" but nothing carries it — the natural repair is the `split('|||')` ¶21 forbids. Name the source: `currentLessonData[semKey][lessonKey]` carries `campId`/`projectTitle` (`:2040-2053`); assert `lessonKey === dayOffLessonKey(...)`; delete `ref`.

**F3 — MEDIUM — photo removal is not a clear anywhere.** ¶20 says it is; the shared body (kept as one copy by ¶35) sets `photoUrl=''`/`photoPath=''` into the payload (`app.js:11551-11556`, `:11572`), and `fieldsToClear` is built only from the seven content fields (`:11525-11527`). Pick one and say it; add the missing photo-removal BDD.

**F4 — MEDIUM — the in-transaction re-check reaches app.js from firebase-data.js.** `canTickDayOffMaterials()` and the new resolver are app.js; the branch is firebase-data.js. It resolves at call time (`index.html:564-565`), but this file's one app.js dependency is `typeof`-guarded (`:1979`) — the same pattern here silently *skips* the check. Pass `{canEditAnywhere, myTeacherName}` in from the caller; an unresolvable name must refuse, not skip.

**F5 — MEDIUM (2A.1) — the checklist's sign-off state is stale.** Each camp section shows Materials complete / Undo, whose state comes from `currentDayOffSignoffs` (`:2688`) — but ¶9's read list is `readDayOffPlan()` only. A planner's qty change deletes the sign-off doc in the same transaction (`:2588`), so a freshly-opened checklist shows "✓ Materials complete" for a camp that isn't. Write is safe (`expected`, `:2718`); display isn't. Add `refreshDayOffSignoff()` per camp to the `allSettled` batch.

**F6 — MEDIUM (2B) — every autosave schedules a full SDOC reload.** ¶23 installs via `dayOffInstallPlan()`, which ends in `scheduleDayOffReload()` (`:2525`) → three queries + re-render. Summer triggers none. Say which install path 2B uses and add a long-typing-session BDD.

**F7/F8 — LOW** — `markDayOffCampComplete`'s signature change has `onclick`-string callers (`app.js:12590`) and an unconditional `renderAdminGrid()` (`:12787`); and `getElementById('summer-lesson-print').addEventListener` (`:11842`) is unconditional, so hiding Print throws mid-setup and leaves the close handlers below it unbound.

## 3. Confirmed sound

The "camp read is the lock" argument holds, and also for `deleteDayOffCamp` (it writes `campRef` `:2502`; its read-set covers the plan refs the save writes `:2494`). The rename-before-read-back "benign" case is genuinely benign — the rename reads `fromRef` (`:2403`), so a later commit must carry the text (`:2414-2418`). Worth one added sentence: the editor's always-sent identity fields (`app.js:11578-11582`) are *not* in the writable set, so ¶37's "none from the editor" branch is load-bearing — miss it and every teacher save throws.

Full review written to the plan file.
