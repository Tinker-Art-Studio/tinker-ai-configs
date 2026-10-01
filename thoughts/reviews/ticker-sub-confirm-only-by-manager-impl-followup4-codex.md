MEDIUM — [js/app.js:8239](/Users/christiehubley/tinker-timeclock/js/app.js:8239): `anotherBoxOpen` is captured before `await getAllTimeOffRequests()`. After the saving box closes, a manager can open box B during that await. When it resolves, the stale `false` still causes `openTimeOffDetail(ctx.requestId)` at line 8243, replacing the detail behind box B. Box B’s context remains correct, so this does not enable concurrent saves or confirm the wrong sub, but it violates the stated “leave another open box and the detail behind it alone” behavior. The condition must be evaluated after the await.

MEDIUM — [schedule-editor-wiring.test.js:2384](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2384): the new test explicitly claims to pin the late-save behavior, but its regex accepts the broken snapshot described above. It would pass even though a box opened during the refresh has its underlying detail replaced. A test must model that interleaving, or at minimum require the current-context check after `getAllTimeOffRequests()` resolves.

Everything else in the requested state-machine review is sound:

- Under one minute, cancel/× cannot appear to cancel a saving confirmation.
- After the warned escape hatch, a newer box/context cannot be closed or cleared by the older save.
- A newer box remains closable while the older save is pending.
- All paths after `_confirmSubBusy = true` reach `finally`; no settled path leaves it true.
- The busy gate is set before the first `await`, so two saves cannot start concurrently.
- Every early return before the busy assignment leaves the button unchanged; reopened boxes explicitly reset it.
- The structural tests do catch the cited return, polarity, saving-context scope, button reset, one-save gate, and `finally` restoration mutations.

Tests were not run, per the read-only instruction.

ready to push for deploy review — no.
