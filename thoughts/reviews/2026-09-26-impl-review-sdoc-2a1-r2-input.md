# Implementation review ROUND 2 (confirmation) — Classbook SDOC Phase 2A.1 (event materials checklist)

Repo /Users/christiehubley/tinker-spring-curriculum, branch sdoc-2a1-event-checklist, uncommitted working tree vs
2894adf (`git diff`; also saved at ~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2a1-r2.diff).
Read-only — do NOT edit anything.

Round 1: ~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2a1-codex.md and
...-claude-full.md (or ...-claude.md). Fixes made:
- one model: rows, counts and the sign-off badge all render from currentDayOffPlans/currentDayOffSignoffs; the view
  keeps only readErrors / signoffErrors / tickErrors (separate channels); sign-off controls withheld while the
  camp's sign-off or any of its lists failed to load
- markDayOffCampComplete(campId, complete, { yearKey, onDone({reread}), isCurrent }): pre-check read loop wrapped
  (alert + onDone, never a silent no-op), isCurrent checked after the reads, after the confirm, and after the write
  before alert/onDone; card callers unchanged
- onDone clears readErrors only when complete re-read the lists (not on Undo)
- close clears the body; checklist uses its own classes (sdoc-evmat-complete-btn / sdoc-evmat-done), not the card's
- tests: button text (M16/M17), Esc + backdrop (M17), sign-off write spy (M19), quotes in names (M21), teacher gate
  (M22), shared item id across two projects (M23), failed sign-off read + later tick (M24), close/reopen during load
  and sign-off started before a close (M25)

Confirm each round-1 finding is fixed; look only for NEW HIGH/MEDIUM problems. Verdict READY / CHANGES NEEDED,
findings with severity + file:line + fix, under ~500 words.
