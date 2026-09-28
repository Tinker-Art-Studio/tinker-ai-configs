# Plan review ROUND 2 (confirmation) — Classbook SDOC Phase 2C, revision 2

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2c` + the top Decisions Log entry.
Code read-only @ `22ed027`. Nothing edited.

**Verdict: CHANGES NEEDED** — every round-1 finding is correctly fixed; two NEW MEDIUMs come out of the fixes
(both are specification gaps in the new text, not design errors).

## Round-1 fixes — all confirmed against the code

| Round 1 | Revision 2 | Verified |
|---|---|---|
| Codex HIGH (planner-owned not rules-enforced) | Stated as UI-level, same accepted gap as 2A `materialItems`; explicit `auth {canPlan}` argument, missing → throws; rules field-pin stays a 2B follow-up | rules 699-703 do allow any `classbook` user to create/update — the plan now says so plainly |
| Codex MED (delete sentinel in a create) / Claude MED 2 | One `tx.set(…, {merge:true})` with `FieldValue.delete()`, no-op when absent + both empty | matches `saveDayOffPlan` firebase-data.js:2681-2684 |
| Codex MED (n/a BDD too thin) | Table-driven every spelling + duplicate save + real→n/a prompted removal + n/a→real + admin-list-as-typed + summer pinned | ✓ |
| Codex MED (draft/protection gaps) | Drafts across failed add / reorder / refused save; links-only removal, camp delete, rename destination | ✓ |
| Claude HIGH 1 (render path) | No `linkifyText`; `sdocEsc` + `<br>`, no autolink; link only if `new URL()` + http(s), href = `.href` via `sdocEscA`; D4 payload changed to the quote vector | `sdocEscA` = `escAttr` (app.js:12416, 8149) escapes `"` ✓; summer's hole deferred as its own task |
| Claude MED 4 (read-back) | Explicit field comparison, not `readDayOffPlan` | ✓ `readDayOffPlan` (2776) verifies nothing |
| Claude MED 5 ("About this project") | New `sdocAboutHtml` inside the `sdoc` branch; summer reference section not un-gated | ✓ app.js:11507-11519 |
| Claude MED 6 (close-confirm) | Own `v.detailsDraft`, never in `v.drafts`; extended typed test + message | ✓ `closeDayOffMaterials` 12948 tests only the four material fields |
| Claude MED 7 (wrapper per site) | Broadened at the `isDayOffNoPlanTitle` wrapper; validator (2224) keeps the broad rule; Teacher View takes `isDayOffUnusedBlock`; comments/admin list as typed; build-time live re-check | ✓ all named sites exist and behave as described |

## NEW findings

### 1. MEDIUM — `expected` (the stale-editor guard) has no defined source or re-base rule
`dayOffMaterialsView.plan` is **not** "the values it opened with": it is overwritten from
`currentDayOffPlans` after every material action (app.js:13034) and every tick (app.js:13091), and the
debounced reload replaces those maps wholesale (`scheduleDayOffReload`, firebase-data.js:2746;
`dayOffInstallPlan` 2767 does *not* mark the key verified the way `dayOffInstallVerified` 2591 does).
So the two readings of the plan sentence both fail:

- **`expected` read from `v.plan` at save time** — a prep tick between A's save and B's Save re-bases B's
  baseline to A's links; the guard passes and B's whole-array write silently drops A's link. That is
  exactly the loss the guard was added for.
- **`expected` pinned at open** — the planner's own *second* Save details in the same popup is refused
  against her own first save ("changed in another tab").

**Fix:** `expected` is the baseline the current `detailsDraft` was seeded from; it is re-based **only** by a
verified read — the open-time `readDayOffPlan`, or the save's own read-back, installed through
`dayOffInstallVerified` (2591) so an in-flight reload cannot roll it back. State what happens when a redraw
brings different details while the draft is dirty (warn, keep the draft — never swap silently). BDD: save
details twice without reopening; another planner's link arriving via a tick redraw mid-typing.

### 2. MEDIUM — a 5,000-character textarea inside a body other users re-render
`renderDayOffMaterialsList()` replaces `body.innerHTML` wholesale on every tick, add, reorder and error
(app.js:13016-13026). The draft rule restores the *text*, not focus, caret or scroll — acceptable for 2A's
one-line rows, disruptive mid-paragraph (a prep tick yanks the cursor out of the vision). Say the details
block restores focus + selection after a redraw, or is not re-rendered while it holds focus. Add it to the
D2 BDD.

### 3. LOW (three)
- Name the fourth wrapper site: `saveDayOffPlan` refuses `isDayOffNoPlanTitle` titles (firebase-data.js:2637),
  so an existing "n/a" record also becomes unsaveable — desired, but unlisted.
- `isDayOffUnusedBlock('')` must be **false**, or the swap at app.js:1749 shadows the "project not assigned
  yet" branch at 1750-1754.
- The read-back writes no edit id, so a third save landing between commit and read reports "Save may not have
  completed" for a save that did land — and the re-save it invites is then refused by the guard. One
  sentence naming that as accepted is enough.

Line citations are within a line of the functions (`isDayOffNoPlanTitle` 2010, `dayOffPlanHasUserData` 2019,
Teacher View 1749 — the plan cites the comment lines). Harmless.
