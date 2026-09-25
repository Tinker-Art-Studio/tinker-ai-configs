# Plan review — round 5 (2B revision 5)

## Verdict: **CHANGES NEEDED** (2 MEDIUM, 3 LOW) — all plan-wording fixes, no design rework.

### Round-4 fixes — present, and three checked through the code

- **No-op returns before the verifier** — sound against the real block (`firebase-data.js:1382`). `lessonHasContent()` reads CONTENT_FIELDS only (`:19-22`), so `lastEditId`/`lastEditedBy/At` in the payload can't defeat the no-op test.
- **`written` post-strip/post-translation** — correct. The strip touches CONTENT_FIELDS only (`:1389`), so an untick (`planComplete:false`) survives and is still verified; the editor only ever sets the photo pair together (`app.js:11553-11554`, `:11587`), so "half-empty pair throws" can't misfire.
- **Clock-based re-install skipped for SDOC — verified it loses nothing.** On an ordinary SDOC save the installed server doc's `lastEditedAt` equals `payload.lastEditedAt` (`app.js:11598-11599`), so `:11606`'s `<` was already false. The line only ever fired in the two cases M3 suppresses.

### M-1 — MEDIUM — `lastEditId` contradicts the allow-list, and the verifier can't see it
Three gaps from the round-4 edit: (1) the signature is still `verifyDayOffPlanWrite(ref, written, cleared)` — nothing passes **this save's** id, so it can't decide own-vs-different at all; (2) `writable = …lastEditedBy, lastEditedAt` is stated as exhaustive, but a later bullet says `lastEditId` is "in the writable set" — followed literally, either every save throws, or a caller may supply an id, and a reused one makes every read-back "mine" → strict → the false "Save may not have completed" round 4 exists to remove; (3) the generation site is unstated and can't be the caller — the list builds `{ planComplete: requested }` (`app.js:2119`).
**Fix:** `verifyDayOffPlanWrite(ref, editId, written, cleared)`; `saveDayOffPlan()` generates the id itself **after** allow-list validation, applied last with identity, overriding the caller; not caller-writable, not clearable.

### M-2 — MEDIUM — the no-op BDD says "no message"; the shared editor always says "✓ Saved"
The BDD dropped round 4's own word "read-back". The success block is shared and unconditional (`app.js:11643-11651`). As written the BDD either fails or forces an SDOC branch inside the one block the split keeps single — shipping it leaves Save on an untouched plan visibly dead.
**Fix:** "✓ Saved, no read-back/'edited since' message, no reload, no write (spy)."

### LOWs
- **L-1** `crypto.randomUUID()` is undefined outside a secure context; this file already guards for that in `newDayOffItemId()` (`firebase-data.js:1911-1917`). Prod and the e2e server (`127.0.0.1`) are fine — reuse the existing helper anyway.
- **L-2** `lastEditId` was added partly for autosave-vs-Plan-complete — same user, **same window** — which now reads "saved again from another window."
- **L-3** The table's "displaced-copy recovery already works for SDOC" is false: that map is filled only by the summer-only `mergeSummerReload()` (`:1038-1068`); `rebuildDayOffSlots()` (`:2098-2101`) parks nothing. Separately and **pre-existing**: SDOC has no `mergeSummerReload` equivalent, so a reload whose query predates a save clobbers the view — the plan's own "reload mid-flight" BDD should expose it.

Full review written to the plan file. On approval I'd copy it to `~/tinker-ai-configs/thoughts/reviews/2026-09-25-plan-review-sdoc-2b-round5-claude.md` (exists, empty) — review only, no code/plan/rules changes.
