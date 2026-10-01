## MEDIUM

- [js/app.js:7643](/Users/christiehubley/tinker-timeclock/js/app.js:7643), [schedule-editor-wiring.test.js:2436](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2436) — The guard fixes out-of-order reads for different request IDs, including the cited “another request’s box” case. It does not implement “last request opened wins” when two reads target the same request: both see the same `viewingRequestId`, so an older snapshot can render last and restore stale toggles. The wiring test passes that broken case because it checks only ID equality, not a per-invocation token.

## LOW

- [schedule-editor-wiring.test.js:2374](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2374) — The improved hung-save message is accurate, but the regex accepts any text after “Reload the page”; reverting to the former incomplete advice would still pass.

The secured-warning wording and brace-bounded regex cleanup resolve their findings without a new issue. Tests were not run.

ready to push for deploy review — no.
