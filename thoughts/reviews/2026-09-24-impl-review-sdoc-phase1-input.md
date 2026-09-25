You are an independent implementation reviewer. Read-only: do NOT edit files, do NOT run any deploy (firebase/netlify) command, never read ~/.config/configstore/firebase-tools.json. Do not run a second-model review yourself.

## Change under review
Repo: /Users/christiehubley/tinker-spring-curriculum (The Classbook — curriculum planning web app, vanilla JS + Firebase compat SDK, shared Firebase project with ~15 other apps).
Diff: `git -C /Users/christiehubley/tinker-spring-curriculum diff main..sdoc-phase1` (single commit a1b8b86; ~1800 lines; js/firebase-data.js "Day Off Camps" section, js/app.js new "SCHOOL DAY OFF CAMPS — Curriculum Admin" section at the end plus small edits at type-routing sites, index.html, css, e2e/day-off-camps.spec.js, e2e/global-setup.js, e2e/helpers/login.js, one new test in e2e/data-safety.spec.js).
Design doc (authoritative): /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html — read "The model" and "Phase 1" (1.1–1.6). Phases 2–4 are NOT in scope.
Firestore rules for the three new collections (dayOffCamps_events, dayOffCamps_camps, dayOffCamps_lessonData) are already deployed: /Users/christiehubley/studio-hub/firestore.rules (search "SCHOOL DAY OFF CAMPS").

## Acceptance criteria (Phase 1)
- Admin creates "SDOC YYYY-YY" (semesterType 'day-off-camps') from + New Semester; unpublished; teachers never see it; cannot be published until Phase 2.
- Curriculum Admin: add/edit/remove events (label, dates, district, notes) and camps (title, AM/PM/FULL + hours, location, studio/age/capacity placements, teachers from the year's pool, days ⊆ event dates, 1–3 projects per day). Chronological by month.
- Guards: date outside year or in two events refused; dropping an event date a camp uses refused; event removal refused while it has camps; camp removal refused while any plan has user data (text/photo/Q&A/planComplete/materials); project rename warns before orphaning a plan with content; Settings refuses removing a teacher a camp uses and narrowing the year past an event; year delete refused while events exist.
- Nothing else changes: weekly semesters and Summer 2026 behave exactly as before.
- Also in this commit: the appData "Stamp semester types" read-back now compares with a key-order-insensitive stableJson (it produced false alarms in production today).

## Firebase invariants to check
- Partial edits via update() of only changed fields; creates via one set(); no setDoc over existing docs.
- All writes awaited; undefined/empty strings stripped; emptied optionals deleted explicitly.
- Every writer refuses after a failed load (lessonDataLoadedSuccessfully === false).
- A permission error loading SDOC data must trip the app-wide load guard (loud), never a silent empty list.
- No write path can touch curriculum/lessonData or summerCamps_* for an SDOC year.
- Queries: only single-field equality (no composite indexes needed).

## What I want
Concrete bugs only, ranked HIGH/MEDIUM/LOW, each with file:line and a concrete failure scenario (inputs/state → wrong result). Especially: data loss or silent overwrite, a guard that can be bypassed, regressions to weekly/summer behaviour, XSS via unescaped user text in the new HTML, listener/reload interactions (setupLessonDataListener, mergeSummerReload, snapshotCampSeasons), and anything in the plan's Phase 1 that was not implemented. Do NOT run the test suite (two reviewers run in parallel and would collide on emulator ports; the author ran it: 242/242 + 29/29). Keep the report under 800 words.
