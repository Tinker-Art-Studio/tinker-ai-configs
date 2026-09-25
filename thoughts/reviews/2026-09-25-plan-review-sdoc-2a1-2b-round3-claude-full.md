# Round-3 confirmation review — SDOC Phase 2A.1 + 2B, revision 3

Read-only review of `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html`
(`#phase-2a1`, `#phase-2b`, top three Decisions Log entries) against
`tinker-spring-curriculum @ 2894adf` and `studio-hub/firestore.rules`.

| Section | Verdict |
|---|---|
| **Phase 2A.1** | **READY** |
| **Phase 2B** | **CHANGES NEEDED** — 3 MEDIUM |
| Decisions Log (Sep 25 ×3) | READY — accurate record of both rounds |

## 1. Round-2 findings — all correctly folded in

Verified each against the code, not just the prose:

- **Codex 1 / Claude F1 (`ref` undefined).** Fixed: `saveSingleLesson(…, opts)` with
  `opts.dayOffAuth`, `campId`/`projectTitle` taken from the in-memory slot. Confirmed the slot
  really carries them — `firebase-data.js:2039` (`campId`), `:2050` (`projectTitle`), and the
  plan-doc spread at `:2031` is overridden by the camp-derived values, so they cannot be
  poisoned by a stale doc. `lessonKey === dayOffLessonKey(...)` equality retained; a BDD pins
  the real UI call path.
- **Codex 2 / Claude F3 (photo removal).** Fixed by translating the `''` pair to
  `FieldValue.delete()`. The editor always sends a *complete* pair — `app.js:11553-11554` sets
  both, `:11587` writes both under one `photoChanged` flag — so "a half-empty pair throws" can
  never fire from the real editor, including on a legacy `photoUrl`-only doc. Storage cleanup
  still runs only after the confirmed save (`app.js:11615-11621`).
- **Codex 3 (classbook key in the predicate).** Fixed: `hasClassbook` in `dayOffAuth` and in the
  transaction arm, plus the "name IS on the camp but no classbook → read-only" BDD.
  `canTickDayOffMaterials()` already requires it (`app.js:271`), matching `firestore.rules:699-701`.
- **Codex 4 (first-name fuzzy match).** Fixed: unique-first-name-only, else `null`, with the
  Alex Smith / Alex Jones BDD. The shared resolver's first-hit behaviour (`app.js:553-557`) is
  left untouched for weekly/summer.
- **Claude F2 (strict read-back).** Folded in for content/photo/`planComplete` — see M2 for the
  half that was left strict.
- **Claude F4 (cross-file auth).** Fixed: `dayOffAuth` passed in, missing throws. The
  `typeof`-guard precedent is real (`firebase-data.js:1978-1979`).
- **Claude F5 (2A.1 stale sign-off).** Fixed: `refreshDayOffSignoff()` per camp in the
  `allSettled` batch. Confirmed it is a pure server read (`firebase-data.js:2677-2682`) — safe
  for prep users, no write.
- **Claude F6 (autosave reload).** Fixed via `dayOffInstallPlan(…, {reload:false})` + the
  10-autosave BDD — see M1 for the case it over-reaches.
- **Claude F7/F8 (LOW).** `markDayOffCampComplete(campId, complete)` confirmed at
  `app.js:12769`, reading `getAdminSemKey()` at `:12770` and ending in an unconditional
  `renderAdminGrid()` (`:12787`) that prep users already exercise from the camp cards today;
  conditional Print binding is in the editor table.

Nothing regressed, and no round-1 finding was lost.

## 2. New findings (Phase 2B)

### M1 — MEDIUM — after a rename, nothing re-queries the camps, so "reopen the camp" shows the teacher nothing

**Plan text:** benign case — *"Saved — but this project was just renamed by the planner; reopen
the camp"*; refusal case — *"copy your text, close, and reopen the camp"*; install via
`dayOffInstallPlan(…, { reload:false })`.

**Code evidence:** `readDayOffPlan()` deletes the key when the doc is gone
(`firebase-data.js:2557`); `dayOffInstallPlan()` only rebuilds slots and (today) schedules the
reload (`:2545-2551`); the camp's `projects` map — which holds the *new* title — is refreshed
only by `reloadSummerForModeChange()` behind `scheduleDayOffReload()` (`:2515-2518`). The
refusal path throws before any install, so it schedules nothing either. The teacher's
`currentDayOffCamps` therefore still lists the old title: reopening the camp offers the same
dead title (forced read → null), and the renamed one never appears.

**Fix:** keep `{reload:false}` for the ordinary success path only. On the title-missing refusal
and on the missing-document read-back, call `scheduleDayOffReload()` (or an awaited
`loadDayOffCampData()`) before showing the message, and change the copy to "…reopen the camp —
the list is refreshing". Add it to the two rename BDDs: *then the camp list shows the new title
without a page reload*.

### M2 — MEDIUM — cleared fields stayed strict, re-creating the clobber-invite F2 fixed

**Plan text:** *"checks strictly that the identity stamp equals the camp's and every cleared
field is absent; for content, photo fields and `planComplete` it accepts either the value sent
or a server `lastEditedAt` newer than this save's"*.

**Code evidence:** clears go through `FieldValue.delete()` (`firebase-data.js:1393`), and the
shared editor derives `fieldsToClear` from any content field that had text and is now empty
(`app.js:11525-11527`). Two teachers on one camp is the designed case (D4). Teacher A empties
`closure`; teacher B types into `closure` and saves a second later. A's read-back finds
`closure` present → the strict arm throws *"Save may not have completed"* — the exact message
round 2 removed because it invites a re-save that clobbers B.

**Fix:** apply the same tolerance to clears: absent **or** a server `lastEditedAt` newer than
this save's → the "Lisa has edited this plan since" message, not a failure. Only the identity
stamp stays strictly compared. Add a BDD twinning the existing concurrent-`closure` case with a
clear.

### M3 — MEDIUM — the branch's insertion point decides whether narrow writes carry `lastEditedBy/At` at all

**Plan text:** *"`saveSingleLesson()` gets `if (isDayOffYear(semesterKey)) return await
saveDayOffPlan(...)` before its `lessonStoreFor()` call (`:1373`), after the load guard."*

**Code evidence:** the load guard ends at `firebase-data.js:1360`; `:1361` initialises
`curriculumDb` and `:1363-1364` stamp `lastEditedBy`/`lastEditedAt` **onto the caller's object**.
Two callers depend on that stamp rather than setting it: the Plan complete checkbox sends
`{ planComplete: requested }` only (`app.js:2119`) and reads the stamp back off the payload
afterwards (`:2123-2125`). (The editor does set its own, `app.js:11516-11517`.) Inserted
immediately after the guard, an SDOC `planComplete` write lands with no `lastEditedAt`, so the
new read-back's baseline is `0` (`lessonEditedAtMs`, `:1009`) and *any* pre-existing server
stamp counts as "someone edited since" — a `planComplete` that never landed is reported as
saved. `curriculumDb` would also be uninitialised (`assertDayOffWritable()` re-inits it,
`:1956`, so this one is benign).

**Fix:** say explicitly that the branch goes **after `:1364`**, so `lastEditedBy`/`lastEditedAt`
are stamped on the payload first (they are already in the writable set), and that
`verifyDayOffPlanWrite()` refuses to run its tolerance arm when the payload carries no
`lastEditedAt`. BDD: a failed narrow `planComplete` write surfaces as a failure, not as
"edited since".

## 3. LOW (not blocking)

- **L1 — `dayOffAuth` has no home in the editor-split table.** The table's save-chain row says
  "shared, one copy", but the only call site is `await saveSingleLesson(semKey, lessonKey,
  payload, fieldsToClear)` (`app.js:11595`) and a missing `dayOffAuth` throws. Add a table row:
  *Save call — appends `{ dayOffAuth }` for SDOC, computed at save time*. (Computing it at save
  time is what makes the "removed from the camp mid-edit" BDD pass.)
- **L2 — `teacherMappings[uid]` is trusted without checking it is in the SDOC pool.** If the
  mapping holds a full name and camps hold first names, the resolver returns a name no camp
  lists; with the new in-transaction arm the teacher now gets a hard "you're no longer on this
  camp" refusal rather than yesterday's view-only. Fall through to the exact/unique-first
  matching when the mapped name is not in the pool.

## 4. Checked and cleared

- `dayOffAuth` works for planners and prep: `canTickDayOffMaterials()` (`app.js:268-272`) is
  computed client-side and short-circuits the teacher-name arm, so Kathy/Allie never need name
  resolution; `assertDayOffWritable()` (`:1953-1957`) is only the load guard, so it does not
  lock teachers out.
- The read-back's `readDayOffPlan()` does install a whole server doc into `currentDayOffPlans`
  (`:2554-2558`) — which `setDayOffMaterialCheck()` deliberately avoids (`:2666-2670`) — but a
  tick that lands in that window schedules its own reload (`:2680`), which `{reload:false}` does
  not cancel, so the stale tick self-heals within ~3 s.
- "The camp read is the lock" still holds for the save vs. rename (`:2412`), camp delete
  (`:2494-2504`) and both 2A writers; the sign-off's `expected` counts (`:2718-2722`) are
  unaffected by an allow-listed `set(…, {merge:true})`.
- 2A.1 adds no write of its own: `setDayOffMaterialCheck` (`:2649`), `setDayOffCampSignoff`
  (`:2694`) and `refreshDayOffSignoff` (`:2677`) are unchanged.

**Bottom line:** 2A.1 is ready to build. 2B needs three text fixes (M1–M3) and two LOWs; none
is a redesign.
