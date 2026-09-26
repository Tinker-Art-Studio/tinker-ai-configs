# Implementation review — SDOC Phase 2B

## Verdict: CHANGES NEEDED — two small fixes (F1, F2); everything else is a follow-up

No path loses or corrupts a plan, materials, ticks, the sign-off doc, `curriculum/lessonData`, or a summer lesson. The save branch, allow-lists, verifier, photo-pair translation and the editor split all match the design. `node --check` passes on all three JS files.

**Verified clean:** the SDOC branch sits after the stamp and before `lessonStoreFor()` (`firebase-data.js:1378`) — I read all six other lesson writers and each refuses out loud; allow-lists cover payload *and* clears; `editId` minted once pre-transaction; compat transaction is read-then-write with the camp as a real lock plus the in-transaction `camp.teachers` re-check; photo removal becomes two real deletes and is counted as *cleared*, not *written*, so it can't fail its own check; old object deleted only after the verified save. For summer, `openPlanEditor` has no `await` before building the modal, the destructured `campName/projectTitle/block` are provably the caller's values, Print is optional-chained so the close handlers still bind, and the existing `openModal()` helper (`data-safety.spec.js:59`) drives the whole pinned summer suite through the split. Read-only mode is genuinely read-only (the file input is inside the hidden upload area). Everything in the new markup is escaped; keys travel only in `data-` attributes.

### F1 — MEDIUM — reload protection has a window with two or more SDOC years
`firebase-data.js:2107`, `:2122-2126`, `:1043`, `:1130-1133`. `protectedKeys` is frozen when *that year's* load finishes but consumed after every remaining year has awaited. With one SDOC year there's no gap (lines 1131‑1133 are synchronous); with two, a save verified while year B queries isn't in year A's set, so A's pre-save `fresh` map is installed — and `keepMine` can't help, since `previous[key]` is the same pre-save copy. `currentDayOffPlans` keeps the verified doc, so nothing is lost and the next reload heals it, but the list shows stale status until then. The design's guarantee holds only for a single year, and there'll be a second next August. **Fix:** return `startSeq` and test `dayOffVerifiedAt[semKey]?.[key] > startSeq` per key inside `mergeSummerReload`, instead of passing a pre-built Set.

### F2 — MEDIUM (test) — T12's "no write attempted" assertion is vacuous
`day-off-teacher.spec.js:431-437` sets `.value` directly, which fires no `input` event, so `triggerAutoSave` never arms — `writes === 0` would pass with the read-only gate deleted entirely. **Fix:** `el.dispatchEvent(new Event('input', { bubbles: true }))` after the assignment (`page.fill` can't be used on a `readOnly` textarea).

### F3 — MEDIUM (test) — five listed BDD cases have no test
Save-fails-after-photo-upload (the one photo path where a bug breaks an image); sign-off doc byte-identical during a teacher save; the three Q&A writers T14 omits; photo removal racing a co-teacher's replacement; and switching Teacher View SDOC ↔ weekly — which is exactly where F4/F5 live.

### F4/F5 — LOW — Teacher View switch-away gaps
`app.js:1692` hides the teacher `.tv-control-group`; the non-SDOC path (`:1596`) restores only the class group, and `populateTvTeacherList`'s restore targets `.tv-teacher-selector`, which doesn't exist in `index.html` (long-dead branch). And `:1601` clears `tvTeacherListFor` before the `if (lessons)` guard, so a semester with no lesson map keeps the SDOC names forever.

### F6–F8 — LOW
Design said `sdocEsc`/`sdocEscA`; the code uses raw `escHtml`, which throws on a non-string (safe today — every field is validated non-empty — but a missing field takes the whole render down). `readDayOffPlanForEditor` duplicates `readDayOffPlan`. `.view-only` has no CSS and textareas are `readOnly` rather than `disabled`, so a viewer gets no visual cue.

Full write-up with fixes: `/Users/christiehubley/.claude/plans/implementation-review-precious-sutherland.md`. I made no changes to the repo.
