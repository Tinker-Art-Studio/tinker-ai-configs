## Verdict: CHANGES NEEDED

All round-one findings are correctly folded into Phase 3 revision 2 and the Decisions Log:

- Generation-gated, server-only SDOC reloads with preserved prior maps.
- Stamp advances only after a successful gated installation.
- Failures trip the shared guard, retain figures, and make the editor read-only.
- Both lifecycle call sites are named.
- Freshness label, timestamp formatting, per-camp counting, progress labels, and attribute escaping are corrected.
- The expanded BDD covers the identified races and edge cases.

One new MEDIUM issue:

### MEDIUM — The shared reload may invoke the wrong view’s callback, leaving Curriculum Admin stale

[app.js:650](/Users/christiehubley/tinker-spring-curriculum/js/app.js:650), [app.js:676](/Users/christiehubley/tinker-spring-curriculum/js/app.js:676), [app.js:5015](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5015), [app.js:5038](/Users/christiehubley/tinker-spring-curriculum/js/app.js:5038), [firebase-data.js:1164](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1164)

`setupLessonDataListener()` has one global subscription/hook. Visiting Teacher View replaces Curriculum Admin’s listener with Teacher View’s callback. On returning to Curriculum Admin, `initCurriculumAdmin()` immediately returns because `caInitialized` is already true. The proposed refresh then uses `summerReloadHook`, but its current Teacher View callback does not redraw Curriculum Admin; in its SDOC branch it renders Teacher View only when that tab is active, then returns.

Consequently, a refresh can successfully install newer data and advance the stamp while the visible plan rows remain unchanged.

Specify a callback-independent redraw: either unify listener rendering based on the active tab, or require every successful/current reload callback to redraw active Curriculum Admin. Add a BDD that visits Teacher View, returns to Curriculum Admin, then verifies an external save plus refresh updates both rows and stamp.

Read-only review; nothing edited.
