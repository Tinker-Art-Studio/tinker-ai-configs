**Deadline — correct.** `refreshDayOffYear` (`js/app.js:12679`) releases on resolution *or* a 30 s timer, with `release` guarded by `if (dayOffRefreshInFlight !== run) return`.

- *Two overlapping reloads?* Not harmfully. `summerReloadHook` bumps `globalListenerGeneration` synchronously at entry (`js/firebase-data.js:1388`), so run2 marks run1 stale before run1 can resume. Run1's only install points are behind `isCurrent()` — the side maps at `firebase-data.js:2427` and the merge/stamp/guard/banner block after the gate check at `1347` — so a resumed run1 writes nothing and returns `'stale'`; the hook skips `callback` on `'stale'`, so no double redraw either.
- *Hung promise releasing a newer gate?* No — the identity check covers both the hung run and the stray timer left by a normal resolution.

**Other fixes hold.** Both `loadLessonData` catches set `dayOffRefreshFailed` over config-derived `dayOffYearKeys()`, so the flag lands even when every camp read fails. `markDayOffYearInstalled` moved past both merge loops with no `await` after the `isCurrent()` gate — window closed. `onLessonDataReload` (`app.js:696`) redraws on `'ok'` and `'failed'`, and `release` re-renders the controls afterwards, so the button lands enabled.

**"Not fixed" reasons all hold.** (a) `'no-listener'` is reachable only via `app.js:225` when `caInitialized` (set at `5115`) is true but `setupLessonDataListener` (`5136`, four awaits later) hasn't run; the first server snapshot reloads and redraws. (b) is genuinely the pre-existing 2B ordering. (c) `loadDayOffCampData` already used `{source:'server'}` (`2407`).

**LOW, not blocking:** after the deadline fires, the button re-enables with the old stamp and no "gave up" notice. And `markDayOffYearInstalled` is still inside the *startup* loop (`firebase-data.js:971`), so with two SDOC years a year-2 failure leaves year 1 showing a fresh stamp *and* "Couldn't refresh" — same family as deferred (b).

**Tests:** P18 genuinely pins the deadline (without it the second `await` never resolves). P17 leaves the outer catch (`986`) unpinned; P19 pins only the not-today branch. Suite count 372 is from the commit message — I did not re-run it.

ready to merge — yes

Full notes: `/Users/christiehubley/.claude/plans/implementation-review-round-toasty-peacock.md`
