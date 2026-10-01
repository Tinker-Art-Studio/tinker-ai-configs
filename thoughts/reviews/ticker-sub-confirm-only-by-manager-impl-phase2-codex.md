## BLOCKING

- [js/app.js:8021](/Users/christiehubley/tinker-timeclock/js/app.js:8021), [js/app.js:4502](/Users/christiehubley/tinker-timeclock/js/app.js:4502) — Stored XSS remains possible in checkbox values. `escapeHtml()` uses `textContent → innerHTML`, which escapes text markup but does not encode quotation marks. It is therefore unsafe inside `value="${escapeHtml(d)}"`. A stored date containing `"` can break out of the attribute and add event-handler attributes when the manager opens the modal. The label text itself is safe; the `value` attribute is not. Build the checkbox with DOM APIs and assign `.value`, or use an attribute-context encoder.

- [js/app.js:8049](/Users/christiehubley/tinker-timeclock/js/app.js:8049), [js/app.js:8078](/Users/christiehubley/tinker-timeclock/js/app.js:8078), [js/app.js:8133](/Users/christiehubley/tinker-timeclock/js/app.js:8133), [js/app.js:8188](/Users/christiehubley/tinker-timeclock/js/app.js:8188) — Cancel/× does not cancel an in-flight confirmation. `submitConfirmSub()` captures `ctx`, then awaits schedule reads while Cancel and × remain enabled. Closing clears the global context, but the captured local object survives and can still write the old schedule and confirm the old request. If another request is opened meanwhile, the old operation’s success then calls `closeConfirmSubModal()`, closing the new dialog and clearing its context. This can produce a confirmation after the manager clicked Cancel. A per-open generation/token check around every post-await write, or preventing dismissal while the operation is active, is needed.

## MEDIUM

- [schedule-editor-wiring.test.js:2307](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2307) — The XSS test asserts the vulnerable construction as correct. It checks for `escapeHtml(d)` inside a quoted attribute but never supplies a date containing `"`, so it would pass the broken implementation and may resist a safe DOM-based rewrite.

- [schedule-editor-wiring.test.js:2316](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2316) — Phase 2’s orchestration coverage is almost entirely source regexes. There is no behavioral test for all/one/none ticked, overwrite cancellation, mixed/all missing shifts, full rollback after a date move, or Cancel/reopen during an in-flight submit. The pure-helper and emulator guard tests are real, but the two blocking defects above pass the new suite.

## LOW

- [index.html:711](/Users/christiehubley/tinker-timeclock/index.html:711) — The Phase 1 follow-up wording still slightly overpromises: “for anyone signed in to Ticker” says a shift will be added, but a signed-in person can still resolve as `ambiguous` or be excluded as inactive, and those branches confirm without a schedule write. “For anyone Ticker can match to one active account” would be accurate.

- [js/app.js:8099](/Users/christiehubley/tinker-timeclock/js/app.js:8099) — When every ticked date lacks a normal shift, the function returns before the date-specific `noShiftDates` alert at line 8214. It correctly writes and confirms nothing and restores the button, but the manager gets only a generic message rather than the named dates promised by the acceptance heading.

- [timeoff-sub-confirm.emulator.test.js:58](/Users/christiehubley/tinker-timeclock/timeoff-sub-confirm.emulator.test.js:58), [schedule-editor-wiring.test.js:2357](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2357) — The two mirrored helpers are currently verbatim, and their exact-body comparison is sound. The transaction itself is only a structural mirror, not a verbatim copy—the comparison merely checks that the dates-guard text exists. The combined production-order ratchet and emulator “colleague confirmed” test do correctly protect the new guard ordering, so this is documentation/test-scope imprecision rather than an implementation defect.

## Phase 1 follow-up

Commit `2f0d2b6` otherwise does what it claims:

- Initial-read rejection and missing-document paths both return the Save button before refusing.
- The stale-form wording is neutral about who acted.
- `editRefusalMessage()` now uses the passed opening snapshot rather than the global.
- The re-confirm notice formats one or multiple names correctly.
- The reversed-name and partial-date tests now exercise meaningful cases.
- No new write or rollback regression was introduced by those changes.

## End-to-end Phase 2 trace

- All dates ticked: every copyable date reaches conflict detection, schedule payload, `appliedOverrides`, email, and reminders.
- One unticked: it reaches none of those paths.
- None ticked: returns before disabling or writing.
- Mixed copyable/non-copyable: writes and confirms only the copyable subset, emails only that subset, then names the skipped dates.
- All non-copyable: no schedule/request write; generic alert; button restored through `finally`.
- Overwrite prompt canceled: no write; button restored.
- Dates moved while open: request update refuses with `field:'dates'`; full checked rollback is attempted; the request remains unconfirmed.
- Dates moved plus same sub confirmed elsewhere: `appliedOverrides`/`subUid`/`confirmed` checks precede dates, producing `sub-changed`; rollback is partitioned so the colleague’s coverage is retained.
- Fresh re-read failure in that branch: the fixed message lists `Object.keys(appliedOverrides)` and leaves the schedule untouched rather than throwing on `${dates}`.
- Cancel/× then a later submit call while closed: no-op as intended. An already-running submit remains unsafe as described above.
- All refusal returns after the button is disabled pass through `finally`, so the Confirm button is restored.

The five other `confirmTimeOffSub()` callers pass no `dates`; the optional guard does not affect them. New writes are awaited, the request mutation is transactional, rollback writes are checked, and the new records contain no explicit `undefined`.

I did not run tests or make any changes, per the read-only instruction.

**Phase 2 OK to build on — no.**
