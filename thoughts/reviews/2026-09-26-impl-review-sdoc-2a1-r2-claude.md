# Round 2 (confirmation) — SDOC Phase 2A.1

**Verdict: CHANGES NEEDED — 1 MEDIUM (small, local fix). No data-safety or write-path problem.**

## Round-1 findings: all confirmed fixed

- **One model** (claude 1 / codex 2): `v.plans` is gone. Rows, header and badge all read `currentDayOffPlans`/`currentDayOffSignoffs`; per-camp `count` accumulates while the projects render (`js/app.js:12884-12920`) and is handed to `renderDayOffEventSignoff`, so the badge and the rows count the same live items/ticks as `dayOffCampMaterialsSummary` (`firebase-data.js:1936`).
- **Channel mixing** (claude 2): `readErrors`/`signoffErrors`/`tickErrors` separate; the sign-off control is withheld entirely while `signoffErrors.has(camp.id)` (`12919`), so a failed sign-off read can never show a cached "Materials complete". M24 pins it including the later tick.
- **Silent dead button** (claude 3 / codex 1): pre-check loop wrapped — alert + `renderAdminGrid()` + `onDone({reread:false})` (`12789`); `isCurrent` checked after the reads, after the confirm, and after the write before alert/`onDone` (`12800`, `12805`, `12820`). Card callers unchanged.
- **Undo clearing errors** (claude 4): `onDone({reread: complete})`; `readErrors` deleted only when `reread` (`12981`). Confirm-cancel passes `reread:true`, which is correct — those reads did happen.
- **Close/class names** (claude 5): `body.innerHTML=''` (`12871`); own classes. `.sdoc-errors:empty{display:none}` + `pre-wrap` (styles.css:7175) handle the always-rendered error div and the `\n`-joined pair.
- **Tests** (claude 6-8 / codex 3): button text, Esc + backdrop, sign-off write spy (2 calls, both the sign-off doc), quotes + `__pwned`, teacher gate, shared item id, failed sign-off read, close/reopen. `prep` is the per-test `page` fixture, so M25's `page.on('dialog')` can't leak.

## New finding

**MEDIUM — a superseded open's reads still install into the shared cache.** `js/app.js:12856-12864`. On close+reopen the first open's `readDayOffPlan`/`refreshDayOffSignoff` are not cancelled — the view token only suppresses its *render*. Both install into the caches (`firebase-data.js:2551`, `2677`), which are now the modal's single model. If the older read resolves last, the next re-render (any tick in that camp) shows the older copy: an item unticked, or a "Materials complete" badge for a sign-off a planner's quantity edit had deleted — the exact stale badge the re-read on open exists to prevent. It's the half of codex #2 the one-model refactor didn't close, and `setDayOffMaterialCheck` guards the same "older read lands last" hazard deliberately (`firebase-data.js:2670`). M25 proves only that the late load doesn't *draw*.
**Fix (~3 lines):** hold the jobs promise in a module-level `dayOffEventMaterialsJobs` and `await` the previous one before issuing the new reads, so the newest read always lands last.

## LOW, no action needed
Card button counts page-stale plans for a camp whose list fails in the modal (`12158`); the confirm's count is fresher than the rows behind it (`12803`); `readErrors` survive a successful background reload (documented as deliberate, `12833`); the `tickErrors` comment (`12822`) claims sign-off errors it never holds; `disabled` can be emitted twice (`12901`).

Verify with `npm test -- --grep "Phase 2A"`, then the full `npm test` (the `markDayOffCampComplete` signature is on M4/M8/M13/M14's path).

Full write-up is in the plan file. I did not write `~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2a1-r2-claude.md` (still 0 bytes) — this session is read-only, so copy it from there.
