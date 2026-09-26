# Round 3 (targeted confirmation) — Classbook SDOC Phase 2A.1

**Verdict: READY.** Both round-2 MEDIUMs are fixed. No new HIGH/MEDIUM.

Scope: working tree vs `2894adf`, read-only. `node --check` on `js/app.js` and
`e2e/day-off-materials.spec.js` pass, `git diff --check` clean, and the tree diff is
byte-identical to the saved `…-r3.diff`. Emulator suite not run.

## Codex MEDIUM — cached complete sign-off + a failed list

Fixed. `js/app.js:12919` now reads
`v.signoffErrors.has(camp.id) || count.failed ? '' : renderDayOffEventSignoff(…)`, so badge,
Undo and button all disappear together. `count.failed` is set inside the `projects` map
(`12898`), which is a `const` evaluated before the section template — the flag is complete when
the head is built. The withheld state still says why: the failing project renders
`Couldn't load this list: …` inline.

M26 (`e2e/day-off-materials.spec.js:613`) pins it: camp signed off on the server, `Glaze Day`'s
read stubbed to throw, then asserts count 0 for `.sdoc-evmat-done`, `.sdoc-evmat-complete-btn`
and `text=Undo`. `refreshDayOffSignoff` is left real, so the complete sign-off is genuinely in
`currentDayOffSignoffs` — the case Codex said M20 missed.

## Claude MEDIUM — a superseded open's reads landing last

Fixed. `js/app.js:12844,12858-12873`: `previous` is captured, the async IIFE `await previous`
then re-checks `dayOffEventMaterialsView !== view` **before** issuing any read, and
`dayOffEventMaterialsJobs = run.catch(() => {})` is assigned synchronously before `await run`.
Two rapid clicks therefore chain in click order, and a doubly-superseded open reads nothing.

Answers to the two specific questions:

- **Deadlock / poisoned chain: no.** Every job carries its own `.catch`, `Promise.allSettled`
  never rejects, and the stored link is `run.catch(() => {})` — so even a synchronous throw
  inside the IIFE lets the next open through.
- **Anything else awaiting it: no.** `dayOffEventMaterialsJobs` appears only at `12844`,
  `12858`, `12872`.

M25 was updated to match: it holds reads, closes, reopens, asserts the reopen still shows
`Loading` after 500 ms with `__gate.length > 0`, releases, then asserts one `.sdoc-evmat-count`
and a visible section. The hold is always released, so the chain is never left pending across
tests.

## LOW — residuals, no action needed this round

1. **Starvation if a read never settles.** The chain is only as live as its slowest link: a
   `readDayOffPlan` that never settles leaves every later open on `Loading…` forever, where
   before it broke only its own open. `get({ source: 'server' })` rejects when offline rather
   than hanging, so this needs a genuinely stuck stream. If it ever bites, race `previous`
   against a timeout rather than unpicking the chain.
2. **Other read paths bypass the chain.** The sign-off pre-check loop (`12796`) and the re-read
   after a refused tick (`12976`) install into the same shared caches without joining
   `dayOffEventMaterialsJobs`. Click *Materials complete*, close, reopen the same event, and the
   pre-check's older snapshot can land after the reopen's reads. Narrower than the fixed case —
   it needs a concurrent edit by someone else inside that window, and the late read triggers no
   render or write of its own (`isCurrent()` short-circuits both) — so the symptom is stale rows
   on the *next* redraw only. One line if you want it closed: route the pre-check loop through
   the same chain from `markDayOffEventCampComplete`.

## Note

`~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2a1-r3-claude.md` is still
0 bytes — this session is read-only outside the plan file, so copy this write-up there.

Verify with `npm test -- --grep "M2"` for the checklist tests, then the full `npm test`
(`markDayOffCampComplete`'s new signature is on M4/M8/M13/M14's path).
