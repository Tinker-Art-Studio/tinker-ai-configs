# Phase 15 review, round 1 — Claude (independent agent, read-only)

Run as a fresh in-session Claude agent: the `claude --print` CLI still reported an expired login. Same brief as `classbook-ds-phase15-round1-input.md`.

## Verdict: SAFE TO COMMIT (LOW-1 worth tightening)

- **Nothing else can delete a weekly semester.** `deleteSemester` has one UI caller (the bar's Delete button); no `deleteLessonData` caller remains; other `delete currentConfig.semesters[...]` sites are in-tab rollbacks, not deletes.
- **No non-weekly semester wrongly refused.** Camp seasons and SDOC years always stamp their type; only an old untyped entry defaults to weekly, which is the safe direction.
- **Camp/SDOC removal intact.** SDOC event-count refusal, rollback on a failed write and cache cleanup unchanged; the existing tests still hold.
- **Tests prove the change** (both RED would fail on the old code; overrides of `getAuthUser`/`getActiveSemesterKey` work on these classic-script declarations).

## Findings
- **LOW-1:** with `isCamp` gone, an unrecognised stored type (typo or future fourth type) would get the camp wording and lose its appData entry. → Fixed: removal (and the button) only for `isCampSeason || isDayOffYear`; everything else refused. Test added.
- **LOW-2:** the rewritten `readServerSemesterLessonMap` comment named a caller that doesn't exist. → Fixed: says no app code calls it today.
- **LOW-3:** stale comments (helper "mirrors deleteLessonData", two "lives in its own document" reasons). → Fixed. The camp test's leftover `window.deleteLessonData` stub is harmless.

## Record, not build
1. The block is app-only: studio-hub rules still let manager+ remove a weekly appData entry and classbook roles delete the `fall-2026` key from lessonData. A rules-level deny would be the backstop.
2. Archiving doesn't exist yet though the alert mentions it; old semesters accumulate in the admin dropdown (Published toggle hides them from teachers). Follow-up: `classbook-make-active-semester`.
3. The rest of the original Phase 15 design is moot (no new cutProjects/changeLog orphans from weekly deletes; failure-surfacing for a lesson delete no longer applies).
4. `fall-2026` stays in `curriculum/lessonData` until its term-end move.
