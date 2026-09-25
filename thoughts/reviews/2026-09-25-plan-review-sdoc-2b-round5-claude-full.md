# Plan review — round 5 (confirmation), Classbook SDOC Phase 2B revision 5

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html` § `phase-2b` + the round-4
Decisions Log entry. Code read-only @ `2894adf`; rules `/Users/christiehubley/studio-hub/firestore.rules`.
Scope: confirm the round-4 fixes; report only NEW HIGH/MEDIUM problems they introduce.

## Verdict — **CHANGES NEEDED** (2 MEDIUM, 3 LOW). No design rework; all five are plan-wording fixes.

## Round-4 fixes — all present, and three of them checked through the code

- **`lastEditId` per save decides ownership** — present ("compares by save id, not by clock… a fresh
  `crypto.randomUUID()` per save"), with the frozen-clock two-tab BDD. See M-1.
- **No-op saves return before the verifier** — present. Confirmed sound against the real block:
  `!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0`
  (`firebase-data.js:1382`). `lessonHasContent()` reads CONTENT_FIELDS only (`:19-22`), so adding
  `lastEditId`/`lastEditedBy/At` to the payload cannot defeat the no-op test. See M-2 for the BDD.
- **`written` post-strip/post-translation, a removed photo pair as `cleared`** — present and correct.
  The strip touches CONTENT_FIELDS only (`:1389`), so `planComplete:false` (an untick) survives it and is
  still verified; the shared editor only ever sets the photo pair together (`app.js:11553-11554`, `:11587`),
  so the "half-empty pair throws" rule can't misfire on the editor's own payloads.
- **Editor's clock-based post-save re-install skipped for SDOC** — present, and **checked: it loses nothing.**
  On an ordinary SDOC save the verifier installs the server doc whose `lastEditedAt` equals
  `payload.lastEditedAt` (`app.js:11598-11599`), so `editedAtOf(cache) < editedAtOf(savedLesson)`
  (`:11606`) was already false — the line only ever fired in exactly the two cases M3 wants suppressed
  (a co-teacher with a behind clock; `editedAtOf(undefined) === 0` after a rename). Skipping is safe.
- **Own-name "another window" wording** — present. See L-2.

## New findings

### M-1 — MEDIUM — `lastEditId` contradicts the payload allow-list, and the verifier signature can't see it
Plan § 2B, allow-list bullet vs. the "Forced read-back" bullet.
Three gaps, all from the round-4 edit:
1. The verifier is still specified as `verifyDayOffPlanWrite(ref, written, cleared)` — nothing passes it
   **this save's** id, so it cannot decide "own stamp vs. different stamp" at all.
2. `writable = CONTENT_FIELDS, photoUrl, photoPath, planComplete, lastEditedBy, lastEditedAt` is stated as
   exhaustive ("Any other field in the payload… makes the save throw"), but the later bullet says
   `lastEditId` is "in the writable set". Followed literally, either every SDOC save throws, or a caller
   may supply its own id — and a caller that reuses one makes every read-back classify as "mine" →
   strict → the false "Save may not have completed" that round 4 exists to remove.
3. The generation site is unstated, and it cannot be the caller: the list's Plan-complete write builds
   `const payload = { planComplete: requested }` (`app.js:2119`).

**Fix:** signature `verifyDayOffPlanWrite(ref, editId, written, cleared)`; `saveDayOffPlan()` generates
`lastEditId` **itself, after allow-list validation**, applied last with the identity stamp and overriding
anything the caller sent; it is neither caller-writable nor clearable.

### M-2 — MEDIUM — the no-op BDD says "no message"; the shared editor always says "✓ Saved"
Plan § 2B BDD: *"presses Save without typing → nothing is written, **no message**, no reload scheduled."*
Round 4's own M1 fix prescribed *"✓ Saved, no **read-back** message, no reload"* — the word "read-back"
was dropped. The success block is shared and unconditional (`app.js:11643-11651`: `'✓ Saved'`, button
flashes `Saved!`), and `performSave` returns `true` either way. As written the BDD either fails, or forces
an SDOC branch inside the shared success block — the one place the editor split is designed to keep single.
Shipping it would leave Save on an untouched plan visibly dead.

**Fix:** reword to "✓ Saved, no read-back/'edited since' message, no reload scheduled, and no write
(spy on the transaction)."

### L-1 — LOW — bare `crypto.randomUUID()` has no fallback; this file already has the guarded pattern
`crypto.randomUUID` is `undefined` outside a secure context, and this codebase guards for exactly that in
`newDayOffItemId()` (`firebase-data.js:1911-1917`: `typeof crypto !== 'undefined' && crypto.getRandomValues`,
`Math.random` fallback); `uniquePhotoSuffix()` (`:1511`) uses none. Prod (Netlify HTTPS) and the e2e server
(`127.0.0.1`, `e2e/emulators/config.js:26`) are secure contexts, so this is not a shipping risk — but a
studio iPad opening the dev server by LAN IP would throw a TypeError on every save.
**Fix:** reuse `newDayOffItemId()` (or its guard) rather than naming `crypto.randomUUID()`.

### L-2 — LOW — "another window" is the wording for a race that isn't another window
Round 4 added `lastEditId` partly for "autosave racing the Plan complete checkbox under the same account"
— same user, **same window**. That race now lands in the own-name arm and reads "This plan was saved again
from another window."
**Fix:** "This plan was saved again elsewhere — reopen to see the latest", or suppress the message when the
later save is also mine.

### L-3 — LOW — the split table's displaced-copy claim is false for SDOC
The last table row says displaced-copy recovery "already works for SDOC (`displacedSummerServerCopies`,
`firebase-data.js:1028`)". It does not: that map is populated **only** by `mergeSummerReload()`
(`:1038-1068`), which the SDOC path never calls — `rebuildDayOffSlots()` (`:2098-2101`) replaces the slot
map wholesale, parking nothing. So M3's "skip the failure-path displaced-copy adoption" is a no-op for
SDOC, not a behaviour change (harmless, but the row misleads).
Worth recording separately, and **pre-existing, not a round-4 regression**: SDOC has no `mergeSummerReload`
equivalent, so a `scheduleDayOffReload()` whose query predates a save clobbers the saved text in the view
until the next reload. The plan's "scheduleDayOffReload mid-flight" BDD should be expected to expose this.

## Not changed
Phase 2A.1 (READY) and the earlier Decisions Log entries stand from rounds 3–4.

---

## Next step on approval
Write this review to
`~/tinker-ai-configs/thoughts/reviews/2026-09-25-plan-review-sdoc-2b-round5-claude.md`
(the file exists and is empty). No code, plan or rules changes — review only.
