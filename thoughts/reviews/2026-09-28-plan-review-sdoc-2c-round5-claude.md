**Verdict: CHANGES NEEDED** (one new MEDIUM; everything previously flagged is fixed)

**Confirmed fixed**
- **Details container lifecycle (round‑3 MED 1):** revision 5 names all three clearing points — `openDayOffMaterials()` at "Loading…" (app.js:12920), its read‑failure `return`, `closeDayOffMaterials()` (:12946) — draws the section only after a successful open read, and re‑checks the view's camp/title on every Save.
- **Install / re‑base on the server read‑back (round‑3 MED 2):** both id branches install the *server* document through `dayOffInstallVerified()` (firebase-data.js:2591) and re‑base the baseline on it. Generalising `verifyDayOffPlanWrite()` (:2712) by id‑field name + identity is sound — it already returns the server doc in both branches and already takes `identity`.
- **Round‑4 MED (view token):** matches `tickDayOffMaterial`'s existing guard (app.js:13089); BDD added. Citation fixed — `#sdoc-materials-modal-body` really is index.html:276.

**New MEDIUM — the token covers only the successful read**

`openDayOffMaterials()`'s `catch` (app.js:12931‑12933) paints `err.message` into `#sdoc-materials-modal-body` and returns. The token sentence says "drops the result", which doesn't reach that branch, while the lifecycle sentence still commits to emptying the Details container "on its read-failure return", unconditionally. So: open A, open B (B renders), A's read then rejects → B's popup shows A's error instead of B's materials, and B's Details section plus any typed vision are dropped. That breaks 2C's own acceptance ("typing survives every redraw").

Fix is one clause: the token check guards the whole post‑await body, `catch` included — a superseded open does nothing at all. BDD: A's read held, B opens, A's read *fails* → B still shows B's materials and B's typed details.

**LOWs from round 4, still unapplied:** `v.plan` is overwritten at app.js:**13032** / **13090** (plan says 13034/13091); and `verifyDayOffPlanWrite` returning `null` (doc gone → `saveDayOffPlan`'s `renamed`) is still unaddressed in the details read‑back text.

Full write‑up: `/Users/christiehubley/.claude/plans/plan-review-round-lexical-crown.md`. Nothing in the repo was touched.
