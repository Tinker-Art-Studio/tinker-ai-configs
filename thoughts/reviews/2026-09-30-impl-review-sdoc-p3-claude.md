# Implementation review — SDOC Phase 3 (`c7400df`)

## MEDIUM — a stalled refresh is swallowed for the rest of the session
`js/app.js:12669-12687`. `dayOffRefreshInFlight` clears only in `done()`, on settle. A `get({source:'server'})` on a connected-but-stalled socket doesn't reject, so one hung reload leaves ↻ at "Refreshing…" **and makes every later automatic refresh return the same dead promise** — exactly the staleness Phase 3 exists to kill, with no message. Fix: a deadline on the gate.

## MEDIUM — a startup SDOC failure never sets the failure flag
`js/firebase-data.js:977-980`. `loadLessonData`'s catch trips the guard but not `dayOffRefreshFailed`, unlike the listener's catch (`:1367-1369`). The panel then reads "No day-off dates yet" + "Not refreshed yet" with no "Couldn't refresh" — the misleading-empty-state shape this app has history with. Mitigated: `initCurriculumAdmin` registers the listener unconditionally and its first snapshot reload sets the flag, so the window is ~1 s. One-line fix.

## LOW
- `js/app.js:12677` — the second `renderAdminGrid()` is dead weight: `summerReloadHook` already calls the callback on both `'ok'` and `'failed'`, so each refresh rebuilds the table twice.
- `js/app.js:12677` — `'no-listener'` is a silent no-op (CA re-entry racing `initCurriculumAdmin`'s awaits): ↻ does nothing, no message, stamp unmoved.
- `js/firebase-data.js:1349-1353` vs `:1369` — a throw in `healDayOffYearAfterReload`/`mergeSummerReload` *after* the stamp is set gives stamp-now + failed, i.e. "Couldn't refresh — showing the last full refresh (now)".
- `js/app.js:702` — `renderAdminGrid(); renderHelpQueue();` share one `try`; isolation is per view, not per call (same for TV's branch).
- `js/app.js:12690` — time-only stamp; a page open overnight shows an ambiguous "3:07".
- Test hazard: the one-shot `runTransaction` hooks (`e2e/day-off-teacher.spec.js:243,276,307,326`, `e2e/day-off-materials.spec.js:280`) are all installed *after* any editor open, so none breaks — but one installed before "Open plan" would now be eaten by the editor's read.
- Test gap: `teacherViewOnReload`'s non-SDOC branches (`js/app.js:666-689`) are unpinned — nothing tests that an expanded summer camp survives a reload, or the `hasTeachers` re-init.

## Verified clean
Hidden redraws clobber nothing (SDOC/CA modals are static `index.html` elements outside `#ca-grid-wrapper`; summer CA keeps no expansion state; TV keeps its `anyExpanded` guard); `tvInitialized` is set before registration, so the gate never skips a redraw; lifecycle calls can't fire on startup or loop (`previousKey` captured pre-mutation; P11 pins it); a camp-season failure marking all SDOC years **is** right — nothing installs before the generation gate; the compat `runTransaction(tx => tx.get(ref))` resolves to the snapshot, commits zero writes, and rejects offline into the existing `catch` at `js/app.js:11658`; escaping is sound (text via `sdocEsc`, attributes via `sdocEscA`, both new `onclick`s carry no `${…}`, so the PR #3 ratchet at `e2e/onclick-quotes.spec.js:126` stays green); 8 `<th>`/8 `<td>`; P10, P14 and P16 would each fail on the pre-Phase-3 code.

**ready to merge — yes** (the two MEDIUMs as follow-ups).

Review written to `/Users/christiehubley/.claude/plans/implementation-review-fancy-liskov.md`. I made no changes to the repo and ran nothing that writes.
