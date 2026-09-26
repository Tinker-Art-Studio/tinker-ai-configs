# Verdict: CHANGES NEEDED (3 MEDIUM, 5 LOW — no data-safety or write-path problem)

Nothing edited. I did **not** run the emulator suite (read-only session), so the test assessment is by reading.

**Clean:** only 2A's two writers are called, `firebase-data.js` untouched, every write awaited, no `setDoc` of partial data. View token checked after every `await`; `allSettled` per plan; `refreshDayOffSignoff()` for every camp on open (M19 genuinely pins that). `pendingDayOffTicks` re-keyed at **both** 2A sites (12691, 12765); both existing `markDayOffCampComplete` onclick callers still work. No interpolation into any `onclick` — camp/event ids, titles and item ids all come from `dataset`; everything else through `sdocEsc`/`sdocEscA`; modal title via `textContent`. The modal sits outside `#ca-grid-wrapper`, so `renderAdminGrid()` can't destroy it, and `data-sticky` + the inline backdrop handler don't fight app.js:374. M8's `.sdoc-camps-table .sdoc-actions button` count-0 still holds.

### 1. MEDIUM — rows and the per-camp badge read two different models
`js/app.js:12901`. Rows and the `n of m ticked` header come from `v.plans`; the badge's counts and its `items &&` gate come from `dayOffCampMaterialsSummary()` → `currentDayOffPlans`. Every tick calls `scheduleDayOffReload()`, and ~3 s later `loadDayOffCampData()` **replaces** `currentDayOffPlans[yearKey]` wholesale (firebase-data.js:2092), orphaning `v.plans`. Another tab's tick or list change then shows in the badge and on the card behind, but not in the rows being read. **Fix:** at the top of `renderDayOffEventMaterials()` re-sync each non-`Error` key from `currentDayOffPlans`, accumulate per-camp `{items, ticked}` while building sections, and pass that into `renderDayOffEventSignoff()`.

### 2. MEDIUM — `campErrors` mixes two channels; a tick erases a load failure
`js/app.js:12831` + `12937`. A failed `refreshDayOffSignoff()` leaves the **cached** sign-off in place and records the message. A later successful tick in that camp runs `v.campErrors.delete(campId)` — the warning disappears while "✓ Materials complete" keeps showing for a sign-off never confirmed: exactly the round-2 finding this refresh exists for. **Fix:** separate `signoffErrors` (open only) from `tickErrors`; render both.

### 3. MEDIUM — a failed pre-flight read makes "Materials complete" do nothing, silently
`js/app.js:12793`: the `for … await readDayOffPlan(...)` loop is outside the try/catch, so a read failure rejects `markDayOffCampComplete` — no alert, no error line, no `renderAdminGrid()`, no `onDone`, and from an onclick the rejection is unhandled. Pre-existing in 2A, but 2A.1 puts it on a surface that promises per-section errors. **Fix:** wrap the loop, surface the message, still call `onDone?.()`.

### 4. LOW — `onDone` can overwrite a section error with an unconfirmed plan
`js/app.js:12953` also runs on **Undo**, where nothing was re-read, so a title whose read failed at open silently gains a page-load-stale list with no error. **Fix:** resync only when `complete === true`.

### 5. LOW — close keeps the body, under the card's class names
`js/app.js:12842` removes `open` but leaves the rendered body, and the modal reuses `.sdoc-mat-complete-btn` / `.sdoc-mat-done` (12906, 12909) — so once opened, the card's unscoped selectors, M8's `prep.click('.sdoc-mat-complete-btn')` (spec:251) included, match two elements. Nothing breaks today; it's a landmine. **Fix:** clear the body on close; drop the shared class and style `.sdoc-evmat-complete-btn`.

### 6. LOW (tests) — capability gate untested
The plan's teacher scenario has no case; M16 only covers "no items". Dropping `ticker &&` at `js/app.js:12159` passes M16–M21. **Fix:** M22 in M10's style (spec:402).

### 7. LOW (tests) — button count, Esc, backdrop never asserted
`Materials checklist · n of m ticked` is never read, so a wrong `evMat` reduce (12158) slips; a missing Esc handler (12960) or backdrop handler (index.html:282) passes everything. **Fix:** assert the button text in M16 and after the close in M17; add Esc + backdrop cases.

### 8. LOW (tests) — two claims narrower than they read
M21's payload has no quotes, so it can't catch an `onclick`-string regression — the 2A finding the design cites. And `spyUpdates` (e2e/helpers/sdoc.js:72) hooks `update`/`tx.*` but not a non-transaction `doc.set()`, so M16's "reads without writing" is narrower than it sounds. **Fix:** a hostile title with `'` and `"`, located via `data-camp-id` + `:has-text`.

Full write-up with fixes and a verification plan: `/Users/christiehubley/.claude/plans/implementation-review-melodic-mist.md`.
