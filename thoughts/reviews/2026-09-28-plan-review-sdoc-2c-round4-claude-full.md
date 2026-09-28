# Plan review ROUND 4 (targeted confirmation) — Classbook SDOC Phase 2C, revision 4

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2c` + the top Decisions Log entry.
Code read-only @ `22ed027`. Nothing edited.

**Verdict: CHANGES NEEDED** — both round-3 MEDIUMs are fixed; one NEW MEDIUM, a one-sentence gap in the
lifecycle text revision 4 itself added.

## Round-3 fixes — confirmed

- **MED 1 (Details container lifecycle).** Revision 4 names all three clearing points — `openDayOffMaterials()`
  at "Loading…", its read-failure `return`, and `closeDayOffMaterials()` (app.js:12946) — draws the section
  (and Save) only after a successful open read, and adds a per-Save re-check that the view's camp/title are the
  ones the section was drawn for. BDD covers A→B including a failed B read. ✓
- **MED 2 (install / re-base).** Both branches now install *the server read-back document, never what this save
  sent*, through `dayOffInstallVerified()`, and the baseline becomes those server values — so the different-id
  branch can't pin a wrong copy past `dayOffVerifiedAt` (firebase-data.js:2591-2596), and the next Save isn't
  falsely refused. Reuse of `verifyDayOffPlanWrite()` (2712) parameterised by id field + identity is sound: that
  function already takes `identity`, is already "own id ⇒ strict written/cleared, different id ⇒ return the
  server doc". ✓
- LOWs applied: `firebase-data.js:1887-1888 / 1911-1912`; `#sdoc-materials-details` named as new index.html
  markup (~276, beside `simple-modal-body`); `closeDayOffMaterials` :12946.
- Re-checked and holding: `buildDayOffSlots` spreads the whole plan doc (2066), so `projectDetails`/`projectLinks`
  reach the teacher's slot; the summer renderers that read `lesson.projectDetails` are unreachable for SDOC
  (`renderAdminGrid` returns at 5053; 2163/12315 are summer-only paths), so reusing the summer field name leaks
  nothing; `CONTENT_FIELDS` (19) and `SUMMER_SAVED_FIELDS` (1016) contain neither field; app.js:1750's
  `title === '—'` sits before the `!title` branch, so `isDayOffUnusedBlock` there keeps "not assigned yet".

## NEW finding

### MEDIUM — a superseded open's read is assigned onto the *new* view, so the Details section can be drawn from project A under project B's identity

`openDayOffMaterials` (app.js:12920) has no view token: it repoints `dayOffMaterialsView` to the new object, then
`dayOffMaterialsView.plan = await readDayOffPlan(...)` (12930) assigns onto **whatever view is current when the
read resolves**, and renders. Open A, then B before A's read lands → B's popup renders A's record.

Revision 4's new guard does not catch this, because the section is drawn *after* the view was repointed: it
records B's camp/title as "drawn for", while its content and its `expected` baseline are A's. The Save re-check
passes. In the common case (neither record has details yet) the write lands — A's vision text on B's record;
otherwise the planner gets a misleading "changed by someone else". The pre-existing 2A half (A's material rows
and item ids under B's title) is closed by the same fix.

**Fix:** one sentence — `openDayOffMaterials()` captures its view object and, after the read, returns without
assigning or rendering if `dayOffMaterialsView` is no longer it; the Details section is therefore never drawn
from a superseded read. Exactly the guard `tickDayOffMaterial` already uses (`if (dayOffMaterialsView !== v)
return;`, app.js:13089) and the chaining 2A.1's review added for the event checklist. BDD: open A, open B before
A's read resolves → B shows B's materials and B's details, nothing from A.

### LOW

- `v.plan` is overwritten at app.js:**13032** and **13090** (the plan now says 13034 / 13091).
- `verifyDayOffPlanWrite` returns `null` when the document is gone (the rename-after-commit case, handled in
  `saveDayOffPlan` as `status: 'renamed'`). The details writer's read-back text covers only the same-id and
  different-id branches — say what a `null` does there (treat as renamed: install `null`, schedule the reload,
  tell her to reopen the camp).
