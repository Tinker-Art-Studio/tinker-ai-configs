# Round 3 — SDOC Phase 2C, revision 3

**Verdict: CHANGES NEEDED** — every round-2 finding is correctly fixed; two NEW MEDIUMs, both one-sentence spec gaps in text revision 3 itself introduced. Code read-only @ `22ed027`, nothing edited. Full write-up: `~/.claude/plans/plan-review-round-piped-wreath.md`.

## Round-2 fixes — confirmed against the code

- **Codex MED (writer contract):** signature is now `saveDayOffProjectDetails(…, { details, links, expected, auth })`, both required and refused before any write; the false "the rules' planner condition matches" claim is replaced by the true one — `firestore.rules:699-703` does let any `classbook` user create/update this collection. ✓
- **Claude MED 1 (baseline):** `expected` = the popup's open-time server read (app.js:12929), re-based only by its own verified save, explicitly never from `v.plan` (overwritten at 13032/13090). Both consequences stated. ✓
- **Claude MED 2 (textarea in the redrawn body):** Details moved to `#sdoc-materials-details`, outside `renderDayOffMaterialsList()`'s `body.innerHTML` (13016). ✓
- **LOWs:** `saveDayOffPlan`'s refusal (firebase-data.js:2637) named; `isDayOffUnusedBlock('')` false; `detailsEditId` separates "someone saved after me" from a failure. ✓
- Spot-checks hold: `isSummerNoPlanTitle('')` is true so `''` stays a no-plan title; `dayOffRenamePairs` (2500-2502) *and* the orphan `leaving` set (2422) both filter through `dayOffCampTitles`, so real→"n/a" really is a prompted removal; `deleteDayOffCamp`'s campId query (2525) still sees n/a records; the rename move copies the whole doc (2465); `DAY_OFF_PLAN_WRITABLE` (2561) holds neither field; `sdocEscA`=`escAttr` (8149) escapes `"`.

## NEW

**1. MEDIUM — the Details container's lifecycle is unspecified, so a stale section can write to the wrong project.** Moving it out of the redrawn body means nothing clears it. `openDayOffMaterials` (12920) repoints the view, paints "Loading…", and on a read failure paints the error and `return`s **without reaching a render**; `closeDayOffMaterials` (12946) clears nothing. The previous project's textarea, typed text, live Save button and baseline stay on screen while `view.campId/title` name a different project — briefly on every open, permanently after a failed one. Save then writes A's text to B's record, and the stale guard misses it when both baselines are absent. Fix: clear the container and drop its baseline at "Loading…", on the error return, and on close; don't render Save until the open read succeeds. BDD: type in A, close, open B (and a variant where B's read throws).

**2. MEDIUM — the different-`detailsEditId` branch doesn't say what is installed or re-based.** In that branch the server holds the other planner's details, so installing *what this save sent* pins a wrong copy and marks it newer than any reload (`dayOffVerifiedAt`, 2591-2596) — the debounced reload can never correct it. `saveDayOffPlan` already installs the read-back doc (2702); say the details writer does the same, and that the baseline there becomes the server values. Also: `verifyDayOffPlanWrite` (2712) already *is* this read-back — reuse it with the id field as a parameter rather than writing a second copy.

**LOW:** "comments at 1888/1912" reads as app.js (summer-calendar code) but means firebase-data.js:1887-1888 and 1911-1912; `#sdoc-materials-details` is new markup in index.html:276 — name the edit; `closeDayOffMaterials` is 12946, not 12950.
