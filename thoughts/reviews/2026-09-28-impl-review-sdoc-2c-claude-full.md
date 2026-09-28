# Plan review ROUND 5 (targeted confirmation) — Classbook SDOC Phase 2C, revision 5

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2c` + top Decisions Log entry.
Code read-only @ `22ed027`. Nothing edited.

**Verdict: CHANGES NEEDED** — both round-3 MEDIUMs and the round-4 MEDIUM are fixed; one NEW MEDIUM, a gap in the
view-token fix revision 5 itself added.

## Round-3 + round-4 fixes — confirmed

- **MED (Details container lifecycle).** Revision 5 names all three clearing points (`openDayOffMaterials()` at
  "Loading…" — app.js:12920, its read-failure `return`, `closeDayOffMaterials()` — :12946), draws the section only
  after a successful open read, and re-checks camp/title on every Save. ✓
- **MED (install / re-base on the server read-back).** Both id branches install the server document via
  `dayOffInstallVerified()` (firebase-data.js:2591) and re-base the baseline on it. The generalisation of
  `verifyDayOffPlanWrite()` (:2712) by id-field name + identity is sound: it already returns the server doc in both
  branches and takes `identity`. ✓
- **MED (round 4, view token).** `openDayOffMaterials()` capturing its view object and dropping a superseded read is
  exactly `tickDayOffMaterial`'s guard (app.js:13089). BDD added. ✓
- Citation fixed: `#sdoc-materials-modal-body` is index.html:276. ✓

## NEW finding

### MEDIUM — the view token covers only the *successful* read; a superseded read **failure** still paints over the new popup and wipes its Details

`openDayOffMaterials()`'s `catch` (app.js:12931-12933) writes `err.message` into `#sdoc-materials-modal-body` and
returns — a branch the token sentence ("drops the result") does not reach, while the lifecycle sentence still commits
to emptying the Details container "on its read-failure return", unconditionally. Open A, open B (B renders), A's read
then rejects → B's popup shows A's error instead of B's materials, and B's Details section and typed vision are
dropped. That breaks 2C's own acceptance ("typing survives every redraw").

**Fix:** one clause — the token check guards the whole post-await body, `catch` included: a superseded open does
nothing at all (no error paint, no emptying, no baseline drop). BDD: A's read is held, B opens, A's read *fails* → B
still shows B's materials and B's typed details.

### LOW (round-4 LOWs not applied)

- `v.plan` is overwritten at app.js:**13032** and **13090**; the plan still says 13034 / 13091.
- `verifyDayOffPlanWrite` returns `null` when the doc is gone (rename-after-commit; `saveDayOffPlan` → `status:
  'renamed'`). The details read-back text still covers only the same-id and different-id branches — say what `null`
  does there.
