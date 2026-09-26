# Implementation review ROUND 2 (confirmation) — Classbook SDOC Phase 2A.1

Read-only. Working tree on `sdoc-2a1-event-checklist` vs `2894adf`. Nothing edited; the emulator
suite was not run (assessment by reading). Round-1 inputs:
`2026-09-26-impl-review-sdoc-2a1-codex.md`, `...-claude-full.md`.

**Verdict: CHANGES NEEDED — 1 MEDIUM (small, local fix). No data-safety or write-path problem.**

## Round-1 findings — all confirmed fixed

| Round 1 | Status |
|---|---|
| claude 1 / codex 2 (two models) | Fixed. `v.plans` is gone; rows, header and badge all read `currentDayOffPlans` / `currentDayOffSignoffs`. Per-camp `count` accumulates while the projects render (`js/app.js:12884-12920`) and is passed to `renderDayOffEventSignoff` — `dayOffCampMaterialsSummary` is no longer called from the modal, and the two counts use the same live-item/live-tick rules (`firebase-data.js:1936-1948`). |
| claude 2 (channel mixing) | Fixed. `readErrors` / `signoffErrors` / `tickErrors` are separate; the sign-off control is withheld entirely while `signoffErrors.has(camp.id)` (`12919`), so a failed sign-off read can never show a cached "Materials complete". M24 pins it, including the later tick. |
| claude 3 / codex 1 (silent dead button) | Fixed. The pre-check loop is wrapped: alert + `renderAdminGrid()` + `onDone({reread:false})` (`12789-12799`). `isCurrent` is checked after the reads, after the confirm, and after the write before alert/`onDone` (`12800`, `12805`, `12820`). Card callers unchanged via the options default. |
| claude 4 (Undo clears errors) | Fixed. `onDone({ reread: complete })`; the wrapper deletes `readErrors` only when `reread` (`12981-12984`). Confirm-cancel passes `reread:true`, which is right — those reads did happen. |
| claude 5 (DOM + class names) | Fixed. `body.innerHTML = ''` on close (`12871`); `.sdoc-evmat-complete-btn` / `.sdoc-evmat-done`, styled separately. `.sdoc-errors:empty{display:none}` (styles.css:7175) keeps the always-rendered error div invisible, and `pre-wrap` shows the `\n`-joined pair. |
| claude 6,7,8 / codex 3 (tests) | Fixed: M16/M17 button text, M17 Esc + backdrop, M19 sign-off write spy (`calls.length === 2`, all on the sign-off doc), M21 quotes + `__pwned`, M22 teacher gate, M23 shared item id, M24 failed sign-off read, M25 close/reopen + sign-off across a close. `prep` is the per-test `page` fixture, so M25's `page.on('dialog')` cannot leak. |

## New finding

### MEDIUM — a superseded open's reads still install into the shared cache
`js/app.js:12856-12864`. On close+reopen, the first open's in-flight
`readDayOffPlan` / `refreshDayOffSignoff` are never cancelled; the view-token check only suppresses
its *render*. Both install into `currentDayOffPlans` / `currentDayOffSignoffs`
(`firebase-data.js:2551-2559`, `2677-2682`). If the older read resolves last, the cache — now the
modal's single model — holds the older copy, and the next re-render (any tick in that camp) shows it:
an item as unticked, or a "Materials complete" badge for a sign-off a planner's quantity edit had
deleted. That is the exact stale badge the re-read on open exists to prevent, and it is the one half
of codex-1 #2 the one-model refactor did not close; `setDayOffMaterialCheck` guards the same
"older read lands last" hazard deliberately (`firebase-data.js:2670-2672`). M25 proves only that the
late load does not *draw*.
**Fix:** keep the jobs promise on a module-level `dayOffEventMaterialsJobs`; in
`openDayOffEventMaterials`, `await` the previous one (settled) before issuing the new reads, so the
newest read always lands last. ~3 lines.

## LOW (no action required)
- The card button counts page-stale plans for a camp whose list fails in the modal, so
  `Materials checklist · x of y` can disagree with the modal header (`12158`).
- The confirm's unticked count comes from fresh reads, the rows behind it do not — no redraw before
  the confirm (`12803`).
- `readErrors` / `signoffErrors` survive a successful background reload, so an error can outlive the
  failure (documented as deliberate at `12833-12836`).
- The `tickErrors` comment (`12822`) says it holds sign-off errors; sign-off failures only `alert`.
- `${dis}` plus the pending guard can emit `disabled` twice (`12901`).

## Verification
`npm test -- --grep "Phase 2A"`, then full `npm test` (the `markDayOffCampComplete` signature change
is on M4/M8/M13/M14's path).

---
Not written to `~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2a1-r2-claude.md`
(0 bytes) — this session is read-only; copy from here.
