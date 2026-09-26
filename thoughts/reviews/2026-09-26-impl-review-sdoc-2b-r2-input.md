# Implementation review ROUND 2 (confirmation) — Classbook SDOC Phase 2B

Repo /Users/christiehubley/tinker-spring-curriculum, branch sdoc-2b-teacher-plans, working tree vs `main` (218f622):
`git diff main` (saved at ~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2b-r2.diff). Read-only.

Round 1: ~/tinker-ai-configs/thoughts/reviews/2026-09-26-impl-review-sdoc-2b-codex.md and ...-claude-full.md.
Fixes made:
- photo pair enforced across payload AND clears (one-sided clears, value+clear of the same field, one-sided value: refused) — T9
- Teacher View: initTeacherView re-entry refreshes when the view is/was SDOC; the (CSS-hidden) Teacher View semester
  selector now calls setGlobalSemester; leaving SDOC clears the picker and restores the teacher group — T20
- renderQaActivityPanel clears for SDOC years — T21
- two SDOC years: loadDayOffCampData records its start seq; after each year's merge, healDayOffYearAfterReload
  rebuilds that year's slots from currentDayOffPlans if any plan was verified after its queries began
- SDOC renderers use sdocEsc/sdocEscA; view-only textarea styling
- tests: T12 fires a real input event + scripted Save click; T14 drives the three Q&A writers (alerts, no qaThread,
  curriculum/lessonData untouched); T5 same-user same-millisecond save and photo-removal-vs-replacement race;
  T18 failed save after photo upload then retry; T19 sign-off byte-identical + tick/save interleavings
Confirm each round-1 finding is fixed; look only for NEW HIGH/MEDIUM problems. Verdict READY / CHANGES NEEDED,
findings with severity + file:line + fix, under ~600 words.
