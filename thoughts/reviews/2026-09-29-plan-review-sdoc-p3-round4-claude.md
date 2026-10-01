## Round 4 — Phase 3, revision 4

**Verdict: READY** (2 LOWs, non-blocking)

**Round-3 MEDIUM — fixed.** Verified against `2ef2e62`:

- There are exactly two `setupLessonDataListener` call sites (`app.js:676`, `app.js:5038`), and it unsubscribes before re-registering (`firebase-data.js:1116`), so one callback owns the single listener. Adding `renderAdminGrid(); renderHelpQueue();` to Teacher View's callback, gated on the active tab and placed before the SDOC early return (682‑686), makes both branches redraw Curriculum Admin — so the automatic retries (1151‑1157) and snapshot reloads (1190‑1194) now refresh the rows, stamp, message and editability. `renderAdminGrid()` keys off `getAdminSemKey()`, independent of `getTvSemKey()`, so drawing it from Teacher View's callback is safe. The calls match Curriculum Admin's own callback exactly (5038‑5043).
- Cited lines check out: `openPlanEditor`'s `canEdit` is `app.js:11515` and is SDOC-scoped as described.
- The two new BDDs (retry-after-failure; snapshot reload with Teacher View visited) cover exactly the dropped paths. Deferring the build until the per-semester storage migration lands is right — it reworks this listener.

**LOW 1 — the "vice versa" claim is over-broad, though the drop is still correct.** `initCurriculumAdmin` is guarded by `caInitialized`, never reset, so it registers once — but it is *awaited at startup after* `setupTabs()` (183 → 188) and then awaits `loadChangeLog/loadCutProjects/loadFutureProjects`. Clicking Teacher View inside that window lets `initTeacherView` fully build and register (no await: `currentLessonData` is already loaded at 168), after which `initCurriculumAdmin` resumes and clobbers it at 5038. So Curriculum Admin's callback *can* own the listener with Teacher View fully initialised. Phase 3 is unharmed (that callback redraws the admin list), and stale Teacher View is pre-existing — reword the claim rather than re-adding the fix.

**LOW 2** — say `dayOffRefreshFailed[yearKey]` is set inside the gated reload's `'failed'` resolution (behind `isCurrent()`), not only at the button's call site, mirroring where the stamp clears it; otherwise a retry/snapshot failure shows only the global banner.
