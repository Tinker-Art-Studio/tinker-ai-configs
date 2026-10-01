## Findings

**MEDIUM — the new wiring test does not fully pin the state-machine behavior it claims to cover.** [schedule-editor-wiring.test.js:2361](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2361)

Several broken versions would still pass:

- Removing the `return` after the alert in `openConfirmSubModal` would allow a saving box/context to be replaced; the assertion at line 2374 only requires `alert(`.
- Reversing or removing the manager’s choice at [js/app.js:8067](/Users/christiehubley/tinker-timeclock/js/app.js:8067) would still pass because the test only looks for the 60-second comparison.
- Removing the button restoration at [js/app.js:8267](/Users/christiehubley/tinker-timeclock/js/app.js:8267) would leave the open box’s Confirm button permanently disabled after a settled refusal/failure, yet the test only checks that `_confirmSubBusy` is cleared.

A behavioral test using a deferred save, fake time, and a minimal modal DOM should exercise close-before/after-timeout, opening another context, old-save settlement, double submit, and final button state.

## Current implementation trace

I found no defect in the actual production paths:

- Cancel before one minute visibly refuses and does not close.
- Cancel after one minute explicitly warns that the save may still finish.
- `onlyIfCtx` prevents an old operation from closing or clearing a newer box.
- Every path after `_confirmSubBusy = true` passes through `finally`, clearing busy and restoring the button.
- All earlier returns occur before this invocation disables the button.
- Synchronous busy acquisition occurs before the first `await`, preventing two saves in the same page from starting together.
- A genuinely never-settling promise can leave `_confirmSubBusy` true, but the modal becomes closable after one minute; this is not a settled-path leak.

The revised Secured-warning regexes now pin both `!confirm(...)` polarity and the `names.length` condition.

No tests were run, per the read-only/no-writing instruction.

**Ready to push for deploy review — no.** The implementation looks sound, but the concurrency regression tests should genuinely pin the behavior first.
