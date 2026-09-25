# Round 6 — Phase 2B revision 6: **READY**

No new HIGH or MEDIUM. Two LOW wording notes.

**The five round-5 fixes are all in, and three check out against the code:**

- **`lastEditId`** — generated inside `saveDayOffPlan()` after allow-list validation, applied last with the identity stamp, not caller-writable (a caller-supplied value throws), not clearable, and passed as `verifyDayOffPlanWrite(ref, editId, written, cleared)`. This takes Codex M-1's *other* resolution: the id stays out of the caller allow-list and is stamped like identity, so the enumeration remains literally exhaustive for caller payloads. No SDOC caller sends it (`{ planComplete }`, `app.js:2119`; the editor builds from form fields).
- **Model row 58** now names `lastEditId` as "written only by `saveDayOffPlan()`".
- **No-op BDD** now keeps the editor's "✓ Saved" (matching the shared success block, `app.js:11643-11651`), with no write/read-back/message/reload.
- **`getRandomValues` fallback** — cites `newDayOffItemId()` at `firebase-data.js:1911-1917`; the citation is exact and that is the guarded pattern.
- **Own-name wording** now covers the same-window autosave/checkbox interleave.

**The L-3 rejection is correct.** `firebase-data.js:1124-1128` runs `mergeSummerReload(yearKey, …)` for every day-off year on every reload — and it's *effective*, not just called: `buildDayOffSlots()` (`:2027`) spreads the plan doc onto the slot so `lastEditedAt` is present for `lessonEditedAtMs()` (`:1008`); `SUMMER_SAVED_FIELDS` (`:1016`) is exactly the SDOC plan's saved shape; `displacedSummerServerCopies` is keyed `semKey|lessonKey` (`:1028`). Round 5 was looking at `rebuildDayOffSlots()` (`:2098-2101`) — the local post-save install, which does replace wholesale and park nothing, but isn't the reload path. Not adopting it was right, and the split table's wording is accurate.

**LOW (non-blocking):**
- **L-1** — the save-path prose still says the no-op "returns before the verifier: no message, no reload" while the BDD now says "✓ Saved". `saveDayOffPlan()` shows no messages, so it can only mean the verifier's — but "no read-back message" would close the gap for good.
- **L-2** — state that the id is generated once, *before* `runTransaction`. The plan's "after allow-list validation" implies it; if it ever moved inside the callback, an SDK retry would regenerate it and the verifier would compare a stale id → a spurious "edited since" (never a false failure).

The full review is drafted at `/Users/christiehubley/.claude/plans/plan-review-round-dapper-moonbeam.md`. Nothing in the repo or the plan was touched.
