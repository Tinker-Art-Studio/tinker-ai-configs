# Implementation review — Classbook SDOC Phase 2A.1 (event materials checklist)

## Context
Review of the uncommitted working tree on `sdoc-2a1-event-checklist` (vs `2894adf`) against
`~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2a1` (revision 3).
Files: `js/app.js`, `index.html`, `css/styles.css`, `e2e/day-off-materials.spec.js`.
Nothing in the repo was edited. The emulator suite was **not** run (read-only session); the test
assessment below is by reading.

**Verdict: CHANGES NEEDED** — 3 MEDIUM, 5 LOW. No data-safety or write-path problem.

## Verified clean
- Writes: only `setDayOffMaterialCheck()` and `setDayOffCampSignoff()`; `js/firebase-data.js` untouched;
  every write awaited; no `setDoc` of partial data; no new collection.
- View token checked after every `await` (12837, 12933, 12945/12951); `Promise.allSettled` per plan;
  `refreshDayOffSignoff()` for every camp on open (M19 pins the stale-badge case).
- `pendingDayOffTicks` re-keyed `lessonKey|itemId` at **both** 2A sites (12691 render, 12765 guard);
  two existing `markDayOffCampComplete(id, bool)` onclick callers still work via the options default.
- XSS: no interpolation into any `onclick`; `camp.id`/`eventId`/`title`/item ids all read from
  `dataset`; every text node through `sdocEsc`/`sdocEscA`; modal title via `textContent`.
- Modal sits outside `#ca-grid-wrapper`, so `renderAdminGrid()` cannot destroy it. `data-sticky` +
  the inline backdrop handler do not fight the generic overlay handler (app.js:374); there is no
  other `Escape` handler for overlays.
- M8's `.sdoc-camps-table .sdoc-actions button` count-0 assertion is unaffected by the new
  event-header button (scoped to the table).

## Findings

### 1. MEDIUM — the checklist's rows and its per-camp badge read two different models
`js/app.js:12901`. Rows and the `n of m ticked` header come from `v.plans`; the badge's
`items`/`ticked` (and the `items &&` gate) come from `dayOffCampMaterialsSummary()`, i.e.
`currentDayOffPlans`. Every tick calls `scheduleDayOffReload()`, and ~3 s later
`loadDayOffCampData()` **replaces** `currentDayOffPlans[yearKey]` wholesale (firebase-data.js:2092),
so `v.plans` then holds orphaned objects. A tick or list change from another tab shows in the badge
("· 1 unticked") and on the card behind, but not in the rows the user is reading. A project whose
read failed at open contributes 0 to the header and its stale count to the badge.
**Fix:** in `renderDayOffEventMaterials()` re-sync each non-`Error` key from `currentDayOffPlans`
at the top, accumulate per-camp `{items, ticked}` while building the sections, and pass that to
`renderDayOffEventSignoff()` instead of calling `dayOffCampMaterialsSummary()`.

### 2. MEDIUM — `campErrors` mixes two error channels, and a tick erases a load failure
`js/app.js:12831` + `12937`. A failed `refreshDayOffSignoff()` leaves the **cached** sign-off in
place and records the message in `campErrors`. A later successful tick in that camp runs
`v.campErrors.delete(campId)` — the warning vanishes while "✓ Materials complete" keeps showing for
a camp whose sign-off was never confirmed (exactly the round-2 finding this refresh exists for).
**Fix:** separate `signoffErrors` (set on open only) from `tickErrors` (set/cleared per tick);
render both in the camp's `.sdoc-errors`.

### 3. MEDIUM — a failed pre-flight read makes "Materials complete" do nothing, silently
`js/app.js:12793`: `for (const t of titles) await readDayOffPlan(...)` sits outside the try/catch.
A read failure rejects `markDayOffCampComplete`, so there is no `alert`, no error line, no
`renderAdminGrid()`, no `onDone` — and from an onclick the rejection is unhandled. The button
appears dead. Pre-existing in 2A, but 2A.1 puts it on a second surface that promises per-section
errors. **Fix:** wrap the refresh loop; on failure surface the message (the checklist can route it
through the camp's error map via `onDone`) and still call `onDone?.()`.

### 4. LOW — `onDone` can replace a per-section error with an unconfirmed plan
`js/app.js:12953`. The resync runs on the **Undo** path too, where `markDayOffCampComplete` re-reads
nothing. A title whose read failed at open then silently gains a page-load-stale list with no error
shown. **Fix:** resync only when `complete === true`, or have `markDayOffCampComplete` report the
titles it actually re-read.

### 5. LOW — close leaves the checklist in the DOM, under the card's own class names
`js/app.js:12842` removes `open` but keeps the rendered body; the modal's controls reuse
`.sdoc-mat-complete-btn` / `.sdoc-mat-done` (12906, 12909). Once the checklist has been opened, the
card's unscoped selectors — including M8's `prep.click('.sdoc-mat-complete-btn')` (spec:251) — match
two elements. No test breaks today (M8 never opens it), but it is a landmine.
**Fix:** `body.innerHTML = ''` in `closeDayOffEventMaterials()`, and drop `sdoc-mat-complete-btn`
from the modal's button (style `.sdoc-evmat-complete-btn` alongside it in CSS).

### 6. LOW (tests) — the capability gate is untested
The plan's teacher scenario has no case; M16 only proves the button is absent when there are **no
items**. Dropping `ticker &&` at `js/app.js:12159` passes M16–M21.
**Fix:** M22 in M10's style (spec:402 — swap `getAuthUser` to `appAccess: ['classbook']`, re-render,
assert `.sdoc-event-mat-btn` count 0).

### 7. LOW (tests) — the button's own count, Esc and backdrop are never asserted
`Materials checklist · n of m ticked` is never read, so a wrong `evMat` reduce (`js/app.js:12158`)
goes unnoticed; Esc (`js/app.js:12960`) and the backdrop (`index.html:282`) are new paths with no
coverage — a missing Esc handler passes everything.
**Fix:** assert the button text in M16 and again after the close in M17; add Esc + backdrop close
assertions (each must also leave the grid redrawn).

### 8. LOW (tests) — two narrower-than-they-read claims
M21's payload has no quote characters, so it cannot catch an `onclick`-string regression — the very
2A finding the design cites. And `spyUpdates` (e2e/helpers/sdoc.js:72) hooks `update`, `tx.update`,
`tx.set`, `tx.delete` but **not** a non-transaction `doc.set()`/`.delete()`, so M16's "reads without
writing" is narrower than it sounds. **Fix:** add a hostile title containing `'` and `"` (locate via
`data-camp-id` + `:has-text`, not a `[data-title="…"]` selector) and assert `window.__pwned === 0`
after ticking it.

## Verification for the fixes
`cd /Users/christiehubley/tinker-spring-curriculum && npm test -- --grep "Phase 2A"` (emulators;
needs Java + the `firebase` CLI). Then the full `npm test`, since findings 1–4 touch
`markDayOffCampComplete()`, which M4/M8/M13/M14 exercise.
