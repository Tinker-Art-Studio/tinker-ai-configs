## Findings

### Blocker

1. A denied user read does not stop already-started workers; reminders are still claimed and sent after the run has declared `read-failed`.

   [shift-reminder.js:139](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:139), [shift-reminder.js:171](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:171), [shift-reminder.test.js:157](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.test.js:157)

   Concrete input: four due people `a,b,c,d`, concurrency 4, with `getUser('b') → {ok:false, error:'permission-denied'}` while the other three reads succeed. I executed this case: the result was:

   ```json
   {
     "aborted": "read-failed",
     "claimed": ["a", "c", "d"],
     "sent": ["a@x.com", "c@x.com", "d@x.com"]
   }
   ```

   The wrong output is both the three sends and the log line claiming “nothing further sent.” The test hides this by forcing `concurrency: 1`.

   A related hole is [shift-reminder-firestore.js:84](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder-firestore.js:84): a denied transaction `get` of the log is flattened into `claim-failed`, so the run does not abort and logs at INFO.

   Exact change: split execution into a read/preflight phase and a claim/send phase. Resolve every required `users/{remindUid}` read with bounded concurrency before making any claim; if any read fails, abort with no writes. Also return typed failure information from `claim` so a failed log read/permission error aborts loudly instead of becoming an ordinary per-row skip. Add a concurrency-4 test where one delayed/denied read proves zero claims and zero sends.

2. Crash recovery does not provide the promised no-duplicate/delay-only guarantee.

   [shift-reminder.js:155](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:155), [shift-reminder.js:160](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:160), [shift-reminder-firestore.js:89](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder-firestore.js:89), [shift-reminder.test.js:218](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.test.js:218)

   Concrete input A:

   - 09:00: Resend accepts Grey’s 10–2 email; Lambda dies before `markSent`.
   - Manager changes the shift to 11–3 or the user’s email/name changes.
   - 10:00 retry uses the same idempotency key but a different request payload.

   Resend validates both key and payload, so this returns `409 invalid_idempotent_request`; the job records failures and eventually exhausts instead of marking the already-delivered email sent. The existing test changes only the clock and verifies only the key.

   Concrete input B:

   - The same crash occurs at 09:00 two days before the shift.
   - No invocation succeeds for more than 24 hours.
   - The shift remains in the following day’s reminder window.

   Resend retains idempotency keys for only 24 hours, so the retry can send a second email. [Resend documents both the payload match and 24-hour retention](https://resend.com/changelog/idempotency-keys).

   Exact change: make retries use an immutable, persisted delivery payload. Either extend the claim/rules to store every payload-affecting value, including the greeting name, or make the email generic and regenerate it exclusively from the existing claim’s stored `to`, `date`, and `shift`; `claim()` must return that stored payload on reclaim. Separately, the >24-hour ambiguity requires a product decision or stronger delivery architecture: either stop automatic retries before Resend’s retention expires and surface manual review, or use a provider/reconciliation mechanism with durable idempotency. The current “never duplicate and never lose” statement cannot be guaranteed after 24 hours.

### Should-fix

3. The 20-second deadline excludes cold start, sign-in, and the schedules read, and does not bound an in-flight send.

   [send-shift-reminders.js:31](/Users/christiehubley/tinker-timeclock/netlify/functions/send-shift-reminders.js:31), [shift-reminder.js:129](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:129), [shift-reminder.js:134](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:134), [shift-reminder.js:171](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:171)

   Concrete input: cold start/sign-in/schedule load consumes 12 seconds; the core then starts its own 20-second clock and begins a Resend request at core second 19. Netlify kills the invocation before send/mark/cleanup completes. Scheduled functions have a fixed [30-second limit](https://docs.netlify.com/build/functions/scheduled-functions/#limitations).

   Exact change: capture an absolute deadline at the first line of `runOnce`, pass it through auth/load/core, reserve cleanup time, and put explicit timeouts/abort signals around authentication, Firestore calls, and Resend. Do not start a claim unless enough budget remains for send plus mark.

4. A schedule can be unticked or changed after loading but still receive the stale reminder.

   [shift-reminder-firestore.js:64](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder-firestore.js:64), [shift-reminder-firestore.js:84](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder-firestore.js:84)

   Concrete input: the job loads a flagged 10–2 shift; a manager unticks it or changes it to 11–3; the claim transaction then reads only the log. Because the schedule document still exists, the rule allows the claim and the old 10–2 email is sent.

   Exact change: inside the claim transaction, also read the schedule document, resolve that date through the shared resolver, and require that it is still flagged for the same `remindUid` and matches the proposed snapshot. Otherwise return `skip: stale-schedule`. Add an emulator race test.

5. Reminder failures leak staff email addresses into function logs.

   [email.js:16](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/email.js:16), [email.js:35](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/email.js:35), [email.js:40](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/email.js:40)

   Concrete input: `RESEND_API_KEY` is absent while Grey is due. `sendEmail` logs `{to: 'grey@…', subject: ...}` even though the reminder function says logs never contain an address.

   Exact change: remove `to` from all three shared error logs, or add a redacted logging mode used by this job. Add assertions against the full `console.error` arguments, not merely that logging occurred.

6. Missing `RESEND_API_KEY` is not treated as “not configured”; it consumes all three attempts.

   [send-shift-reminders.js:37](/Users/christiehubley/tinker-timeclock/netlify/functions/send-shift-reminders.js:37), [email.js:15](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/email.js:15)

   Concrete input: bot email/password are present but `RESEND_API_KEY` is missing. The job signs in, creates claims, marks each send failed, and after three hourly ticks leaves every reminder exhausted.

   Exact change: preflight `RESEND_API_KEY` in the scheduled handler before opening Firebase or claiming anything. Keep preview’s configuration check separate because preview intentionally does not send. Add the missing-env handler test.

7. The preview authorization gate is not literally before everything.

   [preview-shift-reminders.js:18](/Users/christiehubley/tinker-timeclock/netlify/functions/preview-shift-reminders.js:18), [shift-reminder-functions.test.js:32](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder-functions.test.js:32)

   Concrete input: `POST` with no secret returns `405 Method not allowed`, whereas the stated contract is `401` unless the configured secret matches. No credentials or Firestore are touched, but the fail-closed interface is violated.

   Exact change: perform `secretMatches` before the method check; then return 405 only to an authenticated caller. Add `POST` without/with the wrong secret cases.

8. The preview omits the shift it is meant to verify.

   [preview-shift-reminders.js:40](/Users/christiehubley/tinker-timeclock/netlify/functions/preview-shift-reminders.js:40), [shift-reminder.js:163](/Users/christiehubley/tinker-timeclock/netlify/functions/_lib/shift-reminder.js:163)

   Concrete input: Grey has a flagged 10–2 Clay Hub shift. Preview returns only `{docId,name,date}`, so the first-production check cannot verify hours, studio, or note.

   Exact change: include the bounded `snapshotShift` in each address-free `sent`/`wouldSend` record, and assert the serialized response contains no email address.

## Checked and found sound

- The normal claim-create shape conforms to the live rules: exact top-level and shift keys, strings clipped to rule limits, `claimedAt: serverTimestamp()`, `sentAt: null`, `attempts: 0`, and the schedule-existence predicate. A 250-character note becomes 200 characters; non-string start/end values become bounded strings.
- Reclaim changes only `lastAttemptAt` to server time and freshness correctly uses `lastAttemptAt ?? claimedAt`.
- `markSent` uses server time and deletes the stale `error`.
- `markFailed` produces an integer from an existing integer, never decreases attempts, clips errors to 500, and normally cannot run from attempts 3 because `decideClaim` skips exhausted claims. A pathological overlapping stale send can make one `increment(1)` resolve to 4, but the rule denies that write; it cannot persist an illegal value.
- The view and job share `REMINDER_MAX_ATTEMPTS` and `REMINDER_STALE_CLAIM_MS`. The view’s “failed” state can be retryable when `exhausted:false`, which matches the current attempts semantics.
- `remindUid` is now the sole recipient source; no document-ID fallback remains.
- The Firebase client session uses Auth plus `firebase/firestore/lite`, has unique app names for warm invocations, and deletes the app on sign-in failure and every normal post-session path. The job imports neither `firebase-admin` nor credential files/raw REST.
- Preview hashes both secret values before `timingSafeEqual`, returns no credentials or stack traces, and closes successful sessions in `finally`.
- Both shared-helper require paths are correct; the installed CJS entry points resolve for Firebase 12.19.0 and `@netlify/functions` 4.3.0. `included_files` is correctly rooted. Node 20 satisfies all three direct dependencies.
- Hourly cron is UTC, but hourly frequency plus the named Denver-time gate handles DST correctly. Netlify documents that `Run now` invokes the scheduled function immediately; before 9 AM Denver this implementation intentionally exits. [Netlify scheduled-functions documentation](https://docs.netlify.com/build/functions/scheduled-functions/).
- The real concurrent-run emulator assertion is meaningful: it requires total sends and total `sent` results to equal one. However, that emulator runs without rules.

## Test status and production preflight

I could not verify the claimed 836 tests. `npm test` attempted to start the Firestore emulator, but this sandbox rejects localhost port binds with `EPERM`; direct Jest also failed because the read-only sandbox prevented its haste-map temp write. No files were edited.

Before the first production run, I would fix the blockers, then explicitly confirm production/Functions scope for `REMINDER_BOT_EMAIL`, `REMINDER_BOT_PASSWORD`, `REMINDER_PREVIEW_SECRET`, and `RESEND_API_KEY`, plus the intended verified `EMAIL_FROM_ADDRESS`. Preview should be run with the simulated job date—its window is `date+1/date+2`—then use `Run now` after 9 AM Denver and verify the log claim, `sentAt`, Reminders view, and redacted function logs.
