# Plan review ROUND 6 (short, targeted) — Classbook SDOC Phase 3: re-verification after the storage move
Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html, id="phase-3". Read ONLY the
"Re-verification against 132fef2" paragraph, the "Redraw on every install — one shared listener callback" paragraph,
and the top Decisions Log entry.

Code is READ-ONLY at /Users/christiehubley/tinker-spring-curriculum, now at main = 132fef2 (PR #5: Spring 2026 moved
to its own document). Phase 3's design was approved against 2ef2e62; `git diff 2ef2e62 132fef2 -- js/` shows what moved.
Do NOT edit anything anywhere.

Check:
(a) Spot-check the line map against 132fef2 — any reference pointing at the wrong thing?
(b) Spring's own-doc listeners (firebase-data.js ~1420-1457) and recheckOwnDocAfterLegacyLoss() now call the same
    listener callback without an SDOC reload. With Phase 3's shared onLessonDataReload() (both inits register one
    function that redraws each INITIALISED view), is anything wrong — double renders that matter, a redraw of the SDOC
    list that misreports the stamp / "Couldn't refresh" state, or an interaction with the generation gate?
(c) The known limitation: get({source:'server'}) can return stale data after a Listen transport error. Is accepting it
    as display-only correct for Phase 3 (no Phase 3 writes; 2B editor reads on open)? Check the claim that Phase 3's
    SDOC queries can't use a transaction in this SDK, and whether the 2B editor's open/save path depends on a
    source:'server' read in a way this limitation would make unsafe.
Only NEW HIGH/MEDIUM block. Verdict READY / CHANGES NEEDED; ≤300 words.
