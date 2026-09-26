# Implementation review — Classbook SDOC Phase 2A.1 (event materials checklist)

## Change under review
Repo /Users/christiehubley/tinker-spring-curriculum, branch sdoc-2a1-event-checklist (uncommitted working tree vs 2894adf).
The full diff: ~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2a1.diff (also `git diff` in the repo).
Files: js/app.js (dayOffEventCamps sorter, event-card button, openDayOffEventMaterials / renderDayOffEventMaterials /
renderDayOffEventSignoff / tickDayOffEventMaterial / markDayOffEventCampComplete / closeDayOffEventMaterials, Esc
handler, markDayOffCampComplete options, pendingDayOffTicks re-keyed to lessonKey|itemId), index.html (new modal),
css/styles.css, e2e/day-off-materials.spec.js (M16–M21). Read-only: do NOT edit anything.

## Design it implements
~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html → section id="phase-2a1" (revision 3,
reviewed clean by Codex + Claude). It is UI only over 2A's existing writers setDayOffMaterialCheck() and
setDayOffCampSignoff() (js/firebase-data.js), which must be unchanged.

## What to check
- Does it match the design (acceptance, UI mechanics, view token after every await, allSettled, sign-off refresh on
  open, pendingDayOffTicks re-keyed at BOTH 2A sites, markDayOffCampComplete callers still working, XSS: nothing
  user-controlled in onclick strings, everything escaped)?
- Any way the checklist shows a wrong state (stale counts/badges, a tick shown that isn't saved or vice versa),
  or a write happens that isn't 2A's tick/sign-off?
- Concurrency: ticks while another tick is pending, re-render while pending, closing mid-load, reopening quickly,
  switching semester while open.
- The existing 2A popup's behaviour unchanged (M1–M15)?
- Firebase invariants: all writes awaited, no new write paths, no setDoc of partial data.
- Test adequacy: do M16–M21 actually prove the claims? Anything a broken implementation would still pass?

## Output
Verdict READY / CHANGES NEEDED; numbered findings with severity (HIGH/MEDIUM/LOW), file:line, concrete fix.
Under ~800 words.
