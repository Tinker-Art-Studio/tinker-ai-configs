# Plan review — Classbook SDOC Phase 2C (project details + "n/a" blocks), revision 1

Plan: ~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html — section id="phase-2c" and the top
Decisions Log entry. Context: phases 1, 2A, 2A.1, 2B are built and live (read id="phase-2b" for the teacher save
path and its allow-list). Code read-only at /Users/christiehubley/tinker-spring-curriculum @ 22ed027 (js/app.js,
js/firebase-data.js, e2e/); rules /Users/christiehubley/studio-hub/firestore.rules. Do NOT edit anything.

Review for: data safety (can the new writer or the n/a change lose/corrupt plans, materials, ticks, sign-off, or
touch summer?); interactions with 2A's writers, 2B's saveDayOffPlan/verifier/reload protection, the rename move and
removal guards; every SDOC site that special-cases '—' or no-plan titles (did the design find them all? validator
duplicate-title check, blocksToFill, admin list, teacher view, dayOffCampTitles, rename pairing); XSS/link safety;
draft capture in the popup; whether the BDD would catch a partial implementation. Verify citations.
Verdict READY / CHANGES NEEDED; numbered findings with severity + file:line + fix; under ~900 words.
