## Findings

1. **Blocker — Phase 4, direct reminder leaf updates**  
   The proposed `update(['futureSchedule','overrides',date,'remind'])` is vulnerable to the exact race already fixed in [`applyScheduleEditsTransaction()`](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:234). If another manager deletes `futureSchedule` after the view loads, the toggle can recreate a bounds-less `futureSchedule.overrides`; [`getShiftForDate()`](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:260) then treats it as active for every date and can hide the base schedule. If the override itself was deleted, the update can recreate an invalid `{remind:true}` shift.  
   **Plan change:** make single and bulk toggles transactions, one transaction per schedule document. Re-read the document, confirm the selected map is still resolver-active and the date still contains a non-null shift object, then update the leaf. Stale rows must be skipped, reloaded, and reported—not recreated. Add emulator scenarios for concurrent future-block removal, override deletion, and override replacement with `null`.

2. **Blocker — Phase 5, the log does not deduplicate concurrent sends**  
   `logExists → send → create log` is a classic check/send race. Two invocations can both observe no log and both send before either creates it. A crash after Resend accepts the email but before Firestore writes the log has the same duplicate risk.  
   **Plan change:** pass a deterministic Resend idempotency key such as `ticker-shift-reminder/{uid}/{date}` through [`_lib/email.js`](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/email.js:1), while retaining “log only after accepted send.” Resend officially supports SDK idempotency keys for 24 hours, which covers same-day invocation retries. On a conflicting log create, re-read the document and treat an existing matching log as success rather than `log-failed`. Add a simultaneous-two-runs test and a send-success/log-failure/retry test. [Resend idempotency documentation](https://resend.com/changelog/idempotency-keys)

3. **Blocker — Phase 5, a partial run can permanently miss recipients**  
   Netlify Scheduled Functions have a non-configurable 30-second execution limit. The plan gives no concurrency, batching, deadline, or retry strategy. A timeout after processing some recipients leaves the rest unsent, and the next day does not retry them because `reminderDateFor()` advances to a different shift date. The plan’s statement that a log failure may cause “a second email tomorrow” is therefore incorrect. [Netlify Scheduled Functions limits](https://docs.netlify.com/build/functions/scheduled-functions/)  
   **Plan change:** use bounded concurrent sends or Resend’s batch API, and schedule retry opportunities during the same Denver 9 AM hour. For example, `0,15,30,45 15,16 * * *` plus the Denver-hour gate handles both UTC offsets with four useful attempts and fewer no-op invocations than hourly. Combine this with provider idempotency. Add a worst-case-volume test and a partial-timeout/retry scenario. “No log on send-failed” is correct, but only after same-window retries exist.

4. **Should-fix — Phase 1/3, the AI signature does not reach the real write path and may erase existing flags**  
   The plan changes `applyScheduleEdits(doc, edits, {remind})`, but production calls it inside [`applyScheduleEditsTransaction(uid, edits)`](/Users/christiehubley/tinker-timeclock/js/firebase-data.js:248), and [`handleAiSaveEdits()`](/Users/christiehubley/tinker-timeclock/js/app.js:5269) calls that two-argument adapter. The plan does not explicitly change either signature. Also, AI writes replace the whole dated override leaf. With the default checkbox unticked, editing an already-flagged shift would rebuild it without `remind` and silently clear the flag.  
   **Plan change:** thread an explicit reminder mode through `handleAiSaveEdits → applyScheduleEditsTransaction → applyScheduleEdits`. Use at least `set` versus `preserve`; unticked/default should preserve an existing flag while leaving new shifts unflagged. Clearing belongs in the explicit Reminders view. Add wiring and emulator tests for both new and already-flagged overrides.

5. **Should-fix — Phase 3, existing import paths knowingly drop the flag**  
   The claimed outcome that nothing drops `remind` contradicts the plan’s decision not to extend the importer. Both [`schedule-import.html`](/Users/christiehubley/tinker-timeclock/schedule-import.html:262) and the integrated CSV writer in [`app.js`](/Users/christiehubley/tinker-timeclock/js/app.js:5778) replace the complete `futureSchedule`, including `overrides`. Re-running an equivalent import after flags were applied removes them.  
   **Plan change:** either preserve `remind:true` when an incoming non-null override retains the same date, or detect existing flagged future overrides and block/explicitly confirm their removal with a pre-write snapshot. Add a rerun-import scenario. Simply documenting that the importer wipes flags is not sufficient for the Phase 1 safety outcome.

6. **Should-fix — Phase 2/0, the bot is broader than claimed and the “no UI login” assertion is false**  
   Reading `timeclock_settings/employees` exposes the entire roster document, including plaintext kiosk PINs written in [`setStaffPin()`](/Users/christiehubley/tinker-timeclock/js/app.js:5806). Listing `users` exposes every field, not just email. Thus the credential blast radius is schedules, user records, roster/PINs, and log creation—not merely schedules/emails. This is functionally sufficient but over-privileged relative to “exactly what the job needs.”  
   
   Separately, [`requireAuth()`](/Users/christiehubley/tinker-timeclock/js/auth-guard.js:46) does not refuse accounts without a user document: it attempts bootstrap creation and, on failure, catches the error, creates an in-memory staff identity, hides the guard, and shows the app.  
   **Plan change:** either introduce a minimal manager-maintained reminder-directory projection and let the bot read that, or explicitly accept and document the PIN exposure as a security decision. Add an explicit reminder-bot UID refusal/sign-out in the browser auth guard. Test that the bot cannot enter the UI and cannot access any collection beyond the named four.

7. **Should-fix — Phase 2, log-create rules validate too little**  
   `keys().hasAll(...)` permits arbitrary extra fields; `uid`, `date`, `to`, `sentAt`, and `shift` have no type or shape validation; `shift` is not even required despite being in the data model. A compromised bot can create malformed or oversized permanent audit documents and pre-suppress reminders.  
   **Plan change:** require `hasOnly(...)`, field types and lengths, a real date-shaped string, `sentAt == request.time` using a server timestamp, a bounded exact `shift` shape, and existence of the referenced schedule document. Add denial tests for extra keys, wrong types, missing shift, non-server timestamps, nonexistent schedule UIDs, kiosk access, staff collection queries, and archived-manager access. The UID-only identity check itself is stronger than the current [`isKiosk()`](/Users/christiehubley/studio-hub/firestore.rules:38) precedent, and staff currently have no route to the proposed log.

8. **Should-fix — Phase 4/5, late flags and preview authentication are underspecified**  
   A shift flagged after its “two days before at 9 AM” instant will never send, yet the view would say “sends …” and sub-confirmation always promises a reminder. The preview comparison can also fail open if implemented literally and both the header and `REMINDER_PREVIEW_SECRET` are absent.  
   **Plan change:** add a `too late—will not send` status and conditional sub-confirmation wording. Require a configured, non-empty preview secret before comparing it, use a timing-safe comparison, validate `date` with the existing real-date helper, and return only the minimum preview PII. Add scenarios for same-day/next-day flags, missing server secret, malformed dates, and a load/auth failure occurring before any response data is produced.

9. **Should-fix — BDD coverage is not sufficient to catch the riskiest partial implementations**  
   The current scenarios cover ordinary persistence and selection well, but not concurrency, adapter propagation, importer reruns, hard timeout, or malformed-rule inputs.  
   **Plan change:** add the scenarios called out above, plus:

   - Existing flagged AI override + default-unticked batch remains flagged.
   - Original employee shift already had `remind:true`; time-off apply/reverse restores it.
   - Schedule/users/roster read failure aborts the entire job rather than appearing as empty data.
   - Spring-forward, month-end, and year-end date arithmetic.
   - A second run after send success/log failure records the log without sending twice.
   - Bulk Reminders transaction reports only stale rows while committing valid rows.

## Checked and found sound

- [`getShiftForDate()`](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:260) returns stored override objects unchanged, so `remind` naturally survives resolution; recurring shifts do not accidentally inherit it.
- Generalizing [`buildOverridesWrite()`](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:657) from the cleared-note sentinel to `note` and `remind` is the correct merge-write fix.
- Ignoring only `remind` during [`stillHoldsWhatWeWrote()`](/Users/christiehubley/tinker-timeclock/js/timeoff-schedule.js:210), while deleting stale reminder keys during restoration, matches the intended “toggle is not a hand edit” behavior.
- Excluding `remind` from `normaliseShift()` correctly prevents a reminder-only toggle from generating a schedule-change email.
- UID-only bot pinning is preferable to copying the kiosk email-token exceptions.
- Manager-only log reads and no staff read path are consistent with the current rules structure.
- Denver calendar-day arithmetic plus a local-hour gate is the right DST model; DST changes do not make 9 AM ambiguous.
- The no-service-account, no CLI-token design complies with the credential rule.

This was a read-only design review; no files or Firestore data were changed.
