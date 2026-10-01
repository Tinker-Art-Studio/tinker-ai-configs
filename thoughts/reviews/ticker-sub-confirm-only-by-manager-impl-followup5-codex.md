## MEDIUM

- [js/app.js:8246](/Users/christiehubley/tinker-timeclock/js/app.js:8246) — The guard now correctly runs after `getAllTimeOffRequests()`, fixing the cited race. However, `openTimeOffDetail()` itself awaits another Firestore read at line 7641 and renders unconditionally at line 7837. During that await, the manager can navigate to another request and open its confirmation box; the older detail then renders behind that different request’s box. The “do not swap another box’s detail” finding is therefore not fully resolved.

- [schedule-editor-wiring.test.js:2385](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2385) — The assertion pins placement after the first await but passes the broken behavior above because it never accounts for the asynchronous `openTimeOffDetail()` refresh.

The hung-save wording, submit-button lookup assertion, and nameless-sub warning wording resolve their cited findings without introducing another issue. Tests were not run, per the read-only instruction.

ready to push for deploy review — no.
