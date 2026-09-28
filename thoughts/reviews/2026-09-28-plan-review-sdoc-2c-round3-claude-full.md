# Plan review ROUND 3 (final confirmation) — Classbook SDOC Phase 2C, revision 3

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2c` + the top Decisions Log entry.
Code read-only @ `22ed027`. Nothing edited.

**Verdict: CHANGES NEEDED** — every round-2 finding is correctly fixed; two NEW MEDIUMs, both one-sentence
spec gaps in text that revision 3 itself introduced.

## Round-2 fixes — confirmed against the code

- **Codex MED (writer contract).** Signature is now `saveDayOffProjectDetails(yearKey, campId, title, { details, links, expected, auth })`, both new inputs required and refused before any write. The false "the rules' planner condition matches" claim is gone, replaced by the true one — `firestore.rules:699-703` does let any `classbook` user create/update this collection. ✓
- **Claude MED 1 (baseline).** `expected` is the popup's open-time server read (`readDayOffPlan`, app.js:12929), re-based only by this popup's own verified save, explicitly never from `v.plan` (overwritten at app.js:13032 and :13090). Both consequences stated, both BDDs added. ✓
- **Claude MED 2 (textarea inside a redrawn body).** Details moved to its own `#sdoc-materials-details` container, outside `renderDayOffMaterialsList()`'s wholesale `body.innerHTML` (app.js:13016) — focus/caret kept, no draft bag. ✓
- **LOWs.** `saveDayOffPlan`'s no-plan refusal (firebase-data.js:2637) now named; `isDayOffUnusedBlock('')` is false; `detailsEditId` separates "someone saved after me" from a real failure. ✓
- **Spot-checks that hold:** `isSummerNoPlanTitle('')` is true, so the broadened wrapper keeps `''` a no-plan title (`dayOffCampTitles` 2048, validator 2224 unchanged in that respect); `dayOffRenamePairs` (2500-2502) *and* the orphan `leaving` set (2422-2423) both filter through `dayOffCampTitles`, so real→"n/a" really is a prompted removal, not a move; `deleteDayOffCamp`'s campId query (2525) still sees records under n/a titles; the rename move copies the whole doc (2465), so details carry; `DAY_OFF_PLAN_WRITABLE` (2561) is a strict allow-list holding neither field; `sdocEscA` = `escAttr` (8149) escapes `"`.

## NEW findings

### 1. MEDIUM — the Details container's lifecycle on open / failed open / close is unspecified, so a stale section can write to the wrong project

Moving Details out of the redrawn body means nothing clears it any more. `openDayOffMaterials` (app.js:12920)
repoints `dayOffMaterialsView` at the new project, paints "Loading…" into `#sdoc-materials-modal-body`, opens the
modal, and only then awaits the read; on a read failure it paints the error and `return`s **without reaching a
render**. `closeDayOffMaterials` (12946) clears no container at all. So the previous project's textarea, typed
text, live **Save details** button and its `expected` baseline stay on screen while `view.campId/title` name a
different project — briefly on every open, permanently after a failed one. Pressing Save there writes A's text to
B's record, and the stale guard does not catch it in the common case (A's baseline absent, B's details absent).

**Fix:** one sentence — the Details container is cleared and its baseline dropped in `openDayOffMaterials` at the
moment the body shows "Loading…", on the error return, and in `closeDayOffMaterials`; Save details is not rendered
until the open read succeeds. BDD: type in A, close, open B (and a variant where B's read throws).

### 2. MEDIUM — the different-`detailsEditId` branch doesn't say *what* is installed or re-based

"Then it installs through `dayOffInstallVerified()`" doesn't name the value. In that branch the server holds the
other planner's details, so installing *what this save sent* would pin a wrong copy into `currentDayOffPlans` and
mark it newer than any reload (`dayOffVerifiedAt`, firebase-data.js:2591-2596) — the debounced reload can never
correct it. `saveDayOffPlan` already gets this right (`dayOffInstallVerified(yearKey, lessonKey, server)`, 2702);
say the details writer installs the read-back document the same way, and that the baseline in that branch becomes
the server values (otherwise the popup's next Save is refused although nothing has changed since).

Also worth a line: `verifyDayOffPlanWrite` (2712) already *is* this read-back — identity strict, own id → every
value must match, different id → return the server doc, not a failure. Reuse it with the id field as a parameter
rather than writing a second copy.

### LOW

- "its comments at 1888/1912" sits after `app.js:1750` and reads as app.js, where those lines are summer-calendar
  code; the comments meant are **firebase-data.js**:1887-1888 (`SDOC_BLOCKS`) and 1911-1912 (`dayOffBlocksToFill`).
- `#sdoc-materials-details` is new markup — index.html:276 has only the one `simple-modal-body`; name the edit.
- `closeDayOffMaterials` is app.js:12946 (plan says 12950); everything else is within a line or two.
