Review complete. I read the plan's Data model + Phase 2, the full `firestore.rules`, the test file (fixtures, helpers, new suites), `js/auth-guard.js`, the other auth listeners in Ticker, and the doc edits. I could not run the emulator here (the `firebase emulators:exec` invocation needs approval in this non-interactive session), so every finding below is from rules semantics; I left a probe test in the scratchpad that exercises all of them — command at the end.

## Findings

**1. should-fix (before deploy) — `firestore.rules:462` — the `lastAttemptAt` clause denies every later update once the field exists**

`request.resource.data` on an update is the *post-write* document, so after a failed attempt has stamped `lastAttemptAt`, `'lastAttemptAt' in request.resource.data` is true on every subsequent update and its value is the OLD timestamp ≠ `request.time`. Concrete: claim created → `updateDoc({ attempts: 1, error: 'Resend: 500', lastAttemptAt: serverTimestamp() })` (allowed) → send succeeds → `updateDoc({ sentAt: serverTimestamp() })` → **DENIED**. That is exactly the plan's retry path (Phase 5, "retried at the next ticks up to 3 attempts"): the person receives the email but the claim can never be marked sent, the job re-claims/re-sends (Resend's key dedupes for 24 h, so no duplicate email) until `attempts` hits 3, then the view shows a failure that isn't one. Nothing is over-granted — this is the rule being stricter than the plan's contract. Fix (and same shape is what the acceptance criterion "only the outcome fields… server timestamps" actually means):
```
&& (!request.resource.data.diff(resource.data).affectedKeys().hasAny(['lastAttemptAt'])
    || request.resource.data.lastAttemptAt == request.time)
```
(Alternative: leave the rule and have Phase 5's `markSent` always write `lastAttemptAt: serverTimestamp()` too — but then the rule's comment must say so; the rule fix is cleaner.) Add the test: fail once, then `updateDoc({ sentAt: serverTimestamp() })` **succeeds**.

**2. should-fix — `rules.test.js` "bot may record a failed attempt…" — seven denials are masked by #1, so the clauses they annotate are unpinned**

After the first `{ attempts: 1, error, lastAttemptAt }` write, every following `assertFails` in that test (`attempts: 0`, `attempts: 4`, `to`, `shift`, `error` × 501, `sentAt: new Date`, …) is denied by the stale-`lastAttemptAt` clause regardless of the clause it is meant to test. Mutation check: delete `<= 3`, or `>= resource.data.attempts`, or `error.size() <= 500`, or `sentAt == request.time` from the rule and the suite stays green. The commit's "6 that can fail did fail" only shows the grants are needed, not that the denials are load-bearing. Fix: after #1 these become real; also add `lastAttemptAt: serverTimestamp()` to each mutation payload so the only deny reason is the clause under test, and add `attempts: 1.5` (pins `is int`) and `error: 5` (pins `is string`). Then re-run the clause-by-clause mutation.

**3. should-fix — `rules.test.js` — nothing pins `allow get` vs `allow read` for the bot on the log**

The plan's draft had `allow read: if isReminderBot()`; the implementation tightened to `get`, but a regression back to `read` passes every test. Add as the bot: `assertFails(getDocs(collection(db, 'timeclock_reminder_log')))` and `assertFails(getDocs(query(collection(db,'timeclock_reminder_log'), where('uid','==','reminder-sched-uid'))))`. (Same for `users`: the list denial is tested, good.)

**4. should-fix (test) + note for Phase 5 — `claimedAt` is immutable but untested, and the plan's stale-claim logic depends on it being refreshable**

The update rule correctly excludes `claimedAt` from `affectedKeys`, but no test pins it — add `assertFails(updateDoc(ref, { claimedAt: serverTimestamp() }))`. Consequence for Phase 5: "skip if `claimedAt` newer than 10 min, else bump" can only ever bump `attempts`/`lastAttemptAt`; after the first re-claim, `claimedAt` stays old forever, so every overlapping run within the next 10 min also passes the staleness check and re-sends. Phase 5 must use `lastAttemptAt ?? claimedAt` for the freshness check. Record it in the plan so the rule isn't loosened later to "fix" it.

**5. nit — `firestore.rules:166` — an admin can still create `users/{botUid}`**

`!isReminderBot()` only stops the bot creating its own doc; the admin `allow write` can create `users/JO8U8…` with `role: 'manager'`, at which point the Netlify-held password is a manager credential for all 21 apps. Only reachable by an admin typing the uid (Studio Hub's Add Member creates the auth user first and keys the doc off the new uid, `js/app.js:1339`), so low risk — either record it as accepted in the plan's Decisions log, or add a `isReminderBotUid(userId)` helper and `&& !isReminderBotUid(userId)` to the admin write line (with a test: admin `setDoc(users/BOT, { role: 'manager' })` denied).

**6. nit — `firestore.rules:449` — `shift` may be `{}`**

`hasOnly` without `hasAll` lets a claim carry an empty shift snapshot; the view's "sent — shift changed since" compare and the email body assume `start`/`end`. Add `&& request.resource.data.shift.keys().hasAll(['start', 'end'])` and a test.

**7. nit — Ticker: the refusal covers `requireAuth()` only**

`?mode=kiosk` (`js/app.js:8765`), `schedule-import.html:220`, `summer-camp-sync.html:323`, `grant-timeclock-access.html:48` each run their own `onAuthStateChanged` and would accept a bot session; the rules deny every read so nothing leaks (kiosk PIN lookup on `timeclock_settings/employees` is denied). Belt-only gap; fine to leave, worth a line in the plan.

**8. nit — `tinker-timeclock/AGENTS.md:11`** names `netlify/functions/send-shift-reminders.js` and `preview-shift-reminders.js` as existing; neither exists yet (`netlify/functions/` has no reminder files). Mark them "(Phase 5, not yet built)".

**9. nit — count:** the suite adds 9 tests, not 8; three are pure-denial (`bot cannot write a schedule`, `bot is denied on the roster…`, `a RESOLVED claim…`), not two.

## Checked and found sound

- **Rules language:** `allow get` is the right granular op; `keys().hasOnly/hasAll` correct; the regex is RE2-safe (`[0-9]` instead of the plan's `\d` — good change; `matches` is a full match and anchored anyway); `+` string concat for `logId`; `exists()` path interpolation matches the file's existing `$(request.auth.uid)` usage; `diff().affectedKeys()` is the same construct already shipped in the meetings rule; `is int` holds because the JS/lite SDK serialises safe integers as `integerValue` (1.5 → double → denied); `resource.data.sentAt == null` is true for an explicit null and *errors → deny* when the key is absent (safe direction).
- **`request.time` equality with `serverTimestamp()`:** holds on create and on update, in emulator and production (transforms resolve to the commit time before rules evaluate); the payroll `settingsHistory` rule already relies on it in prod. The lite SDK exports `serverTimestamp`, `runTransaction`, `updateDoc`, and serialises `null` as `nullValue`; it sends the same `Write` + `updateTransforms` over REST, so no emulator/prod or full/lite divergence. Transactions share one commit time, so the claim `tx.set` and any `tx.update` bump pass.
- **Update rule limits:** cannot resurrect a resolved claim (`resource.data.sentAt == null`, pinned by the `updateDoc({ sentAt: serverTimestamp() })`-after-resolve assertion — that one *is* load-bearing); cannot touch `to`/`shift`/`uid`/`date`/`claimedAt` (affectedKeys); attempts monotonic, capped at 3, int; `sentAt` only server time; deleting `sentAt` or `attempts` errors → deny; `error: deleteField()` on mark-sent is allowed (good — Phase 5 should do it). `sentAt` set with `attempts` still 0 is harmless.
- **Bot can never get a users doc by its own hand:** create rule `!isReminderBot()` closes the guard bootstrap (`users/{uid}.set(defaults)`) and any merge-set on a missing doc; self-update needs an existing doc; manager/admin branches call `getUserData()` which errors on the missing doc; `push-notifications.js:93`'s merge-set has no `role` → create rule denies. The auth guard's bootstrap write is asserted verbatim in the test.
- **No widening:** each new grant is its own `allow` line; `isReminderBot()` is false for unauthenticated requests (`request.auth == null` short-circuits) and any other uid; minting the uid needs a custom token (service account — blocked); `!isReminderBot()` is a no-op for every other principal; no other collection's rules changed. Managers/admins read the log; staff-with-timeclock, kiosk, archived manager, anonymous denied; nobody but the bot writes; no delete anywhere.
- **Tests:** use the job's real shapes (`getDocs(collection('timeclock_schedules'))`, `getDoc(users/x)`, get-then-set-then-update on the claim); fixtures are disposable with no id collisions (10-01 seeded resolved, 10-17/18/19 written, 10-20/11-30 only in denied writes); the emulator is fresh per `emulators:exec` run so no cross-run pollution; the seeded `timeclock_settings/employees` doc doesn't disturb any existing test.
- **Ticker guard order:** the reload branch runs first, but after the reload `authResolvedUid` is null so the refusal fires — one reload, no loop. `signOut()` inside the handler re-enters once with `user === null`, which just shows the guard; `setupAuthForm()` is idempotent; the error text is set after `signOut()` resolves and the null pass doesn't clear it. `requireAuth()` never resolves for the bot, so `app.js:121` never proceeds. Sound.

## Probe you can run

`/private/tmp/claude-501/-Users-christiehubley-studio-hub/7f1bd200-b84f-4df8-ab4c-76fa91096ad6/scratchpad/reminder.probe.test.js` exercises #1 (fail → `{ sentAt }` only), #3 (bot list/query the log), #4 (`claimedAt` refresh), #5 (admin creates `users/{bot}`), #6 (`shift: {}`), plus `increment()`, float/string `attempts`, manager merge-write on the log, bot `clayMembers` self-create, and the transaction shapes. It uses a throwaway project id and touches nothing in the repo:

```bash
cd /Users/christiehubley/studio-hub && firebase emulators:exec --only firestore --project tinker-hq-probe \
  "node --experimental-vm-modules node_modules/.bin/jest --rootDir /Users/christiehubley/studio-hub \
   --roots /private/tmp/claude-501/-Users-christiehubley-studio-hub/7f1bd200-b84f-4df8-ab4c-76fa91096ad6/scratchpad \
   --modulePaths /Users/christiehubley/studio-hub/node_modules --testMatch '**/reminder.probe.test.js'"
```

Expected: the first probe line prints `DENIED  markSent after a failed attempt, { sentAt } only` — that's finding #1.
