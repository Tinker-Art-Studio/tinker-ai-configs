**Verdict: CHANGES NEEDED** — all round-1 findings are correctly fixed; two NEW MEDIUMs come out of the fixes themselves (both specification gaps, quick to close).

## Round-1 fixes — confirmed against the code
- **Codex HIGH (planner-owned not rules-enforced)** → stated plainly as UI-level (rules 699-703 do allow any `classbook` user to create/update), explicit `auth {canPlan}` argument, rules field-pin stays a 2B follow-up. ✓
- **Merge-set + delete sentinels + no-op** → matches `saveDayOffPlan` (firebase-data.js:2681-2684). ✓
- **Render path** → no `linkifyText`; `sdocEsc` + `<br>`, no autolink; link only via `new URL()` + http(s), href through `sdocEscA` (= `escAttr`, app.js:12416/8149 — escapes `"`); D4 payload swapped to the quote vector. ✓
- **Explicit read-back** (`readDayOffPlan` 2776 verifies nothing), **`sdocAboutHtml` inside the sdoc branch** (11507-11519), **separate `detailsDraft`** (`closeDayOffMaterials` 12948 tests only the four material fields), **wrapper broadened at `isDayOffNoPlanTitle` with each site named** (validator 2224 keeps the broad rule; Teacher View takes the unused helper), **n/a + draft BDD coverage**. All ✓.

## New findings

**1. MEDIUM — the stale-editor guard's `expected` has no defined source or re-base rule.** `dayOffMaterialsView.plan` is *not* "the values it opened with": it is overwritten from `currentDayOffPlans` after every material action (app.js:13034) and every tick (app.js:13091), and the debounced reload replaces those maps wholesale (`dayOffInstallPlan` 2767 does not mark the key verified the way `dayOffInstallVerified` 2591 does). Both readings fail: taken from `v.plan` at save time, a prep tick between A's save and B's Save re-bases B's baseline to A's links, the guard passes, and B's whole-array write silently drops A's link — the exact loss the guard exists to prevent; pinned at open, the planner's own second Save is refused against her own first. Fix: `expected` = the baseline the current `detailsDraft` was seeded from, re-based only by a verified read (open, or the save's own read-back installed via `dayOffInstallVerified`); say what happens when a redraw brings different details while the draft is dirty. BDD: two saves without reopening; another planner's link arriving via a tick redraw mid-typing.

**2. MEDIUM — a 5,000-char textarea inside a body other users re-render.** `renderDayOffMaterialsList()` replaces `body.innerHTML` wholesale on every tick/add/reorder/error (13016-13026). The draft rule restores the text, not focus, caret or scroll — fine for 2A's one-line rows, disruptive mid-paragraph. Restore focus + selection after a redraw, or don't re-render the block while it holds focus.

**3. LOW ×3** — name the fourth wrapper site (`saveDayOffPlan` refuses no-plan titles, firebase-data.js:2637); `isDayOffUnusedBlock('')` must be false or the swap at app.js:1749 shadows "project not assigned yet" (1750-1754); with no edit id, a third save between commit and read-back reports "Save may not have completed" for a save that landed.

Full record written to `/Users/christiehubley/.claude/plans/plan-review-round-misty-leaf.md` (the round-2 review files in `thoughts/reviews/` are still empty — I didn't write to them, per "do not edit anything").
