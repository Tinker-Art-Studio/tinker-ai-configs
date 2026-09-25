# Plan review ROUND 8 (targeted confirmation, Phase 2B) — Classbook SDOC, 2B revision 7b

Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html — section id="phase-2b" (the bullet
"A reload in flight must not undo a verified save") and the top Decisions Log entry. Code read-only at
/Users/christiehubley/tinker-spring-curriculum @ 2894adf; do NOT edit anything.
Your round-7 finding: ~/tinker-ai-configs/thoughts/reviews/2026-09-25-plan-review-sdoc-2b-round7-codex.md.

Confirm the fix (dayOffInstallSeq read before loadDayOffCampData's queries; verified installs record a higher
value; the reload keeps those in-memory plan docs; mergeSummerReload unchanged) closes it — consider the listener
path (setupLessonDataListener reloadSummer at firebase-data.js ~1116-1160) as well as summerReloadHook, the
generation gate, and 2A's tick installs. Only NEW HIGH/MEDIUM problems block. Verdict READY / CHANGES NEEDED; ≤300 words.
Also confirm the protectedKeys bypass in mergeSummerReload (fresh verified slot taken whole, no keepMine, no parking; summer unaffected).
