## Verdict

No blockers found. Every write the bot makes conforms to the live rules by inspection; the claim/send/mark flow is sound. Six should-fixes, mostly about what happens *around* the happy path (deterministic send failures exhausting claims with no documented recovery, an address in the shared email helper's failure log, a duplicate-send edge the Phase 4 log half-accepted), then nits.

Two caveats on my process: `npm test` and a docs fetch both needed approvals that this session couldn't grant, so I did not run the suite myself and could not confirm one rules-language detail (noted below). Everything else below is from reading the code, the live rules, the rules tests, and the SDK sources in `node_modules`.

---

## Findings

### Should-fix

**1. A deterministic send failure exhausts every due claim in three ticks, and there is no in-app or documented way back.**
`netlify/functions/_lib/shift-reminder-firestore.js:115` (`markFailed` always increments), `send-shift-reminders.js:37-41` (config check omits `RESEND_API_KEY`), `_lib/email.js:16-20`.
Concrete: `RESEND_API_KEY` is set in "all contexts" for the existing functions but the three new vars are production-only — or the key is rotated and the env lags. 9 AM tick: claim → `sendEmail` throws `RESEND_API_KEY not configured` → `attempts: 1`. 10 AM: stale → reclaim → same → 2. 11 AM: 3. From noon: `exhausted` for every (doc, date) in the window; the D-1 ticks hit the same log ids. Every reminder due that morning is lost; the view shows "failed ✗ RESEND_API_KEY not configured" with no retry. Nobody can reset it through the app — the rules forbid delete for everyone and `attempts` can only go up. The same happens for a 3-hour Resend outage.
Change: (a) in `runOnce` treat a missing `RESEND_API_KEY` as "not configured" (exit before any claim — claiming with a send that is guaranteed to fail is what burns attempts); the preview doesn't send, so leave `readBotConfig` as is and add the check in `send-shift-reminders.js:37`. (b) Document the recovery in CLAUDE.md's job section: deleting `timeclock_reminder_log/{docId}_{date}` in the Firebase console (rules don't apply there) makes the next tick re-claim and send. (c) Optional, bigger: don't count transient failures (5xx/network/429) toward `attempts` — omitting `attempts` from the update is rule-legal (`attempts >= resource.data.attempts`, rules.test.js:1711) — but `sendEmail` currently throws away the status code, so this needs plumbing.

**2. A person with two documents can be emailed twice across ticks; the claim is keyed by document, the dedupe by account.**
`js/schedule-helpers.js:359` (per-run dedupe by `remindUid`), `_lib/shift-reminder-firestore.js:84-101` (claim reads only its own id).
Concrete: `emp_grey` (stored `remindUid: grey`, i.e. the failed-migration state the Decisions log names) and `grey` both flagged for Oct 17. 9 AM: `selectRemindersDue` keeps the first document seen → claims `emp_grey_2026-10-17`, sends. Both rows show "sent ✓" (the second by date + address). The manager tidies by unticking the `emp_grey` row at 9:30. 10 AM: `grey` is now the only flagged document → claim `grey_2026-10-17` → no log → create → second email. The Decisions log accepts the reassign variant of this; the untick variant isn't listed and is a more natural manager action.
Change: have `selectRemindersDue` return `siblings` (the other docIds it deduped for the same `remindUid`+date, plus the document's `migratedFrom` / `migratedFromChain`), and in `claim` `tx.get` each `${sibling}_${date}` *before* any write (lite requires reads first) — skip `already-sent` if any has `sentAt`. All GETs are within the bot's grant; no rules change.

**3. The shared email helper logs the recipient address on every failure path.**
`_lib/email.js:18, 36, 41` — `console.error('[email] Send failed:', { to, subject, error })`.
Concrete: Resend returns 500 for Grey → the function log carries `to: 'grey@…'`, contradicting "never an address" (the commit message and `send-shift-reminders.js:10`). Pre-existing helper behaviour, but this job is the first thing that runs it unattended every hour.
Change: log a redacted form (`to: redact(to)` → `g***@domain`) in the three places; the job already logs `docId`/`date` for correlation.

**4. Exact-payload writes are pinned by regex, not by a rules test — `increment(1)`, the bare re-claim, and `markSent` on a claim that never had an `error` are unexercised against the rules.**
`schedule-editor-wiring.test.js:1900-1902` pins the source strings; `studio-hub/rules.test.js:1669-1712` uses literal `attempts: 1`, always tests `deleteField()` after an error exists, and never sends `{ lastAttemptAt: serverTimestamp() }` alone. The Ticker emulator suite runs without rules (`shift-reminder.emulator.test.js:9-10`).
By reading, all three pass (transforms are applied before rule evaluation; `diff().affectedKeys()` doesn't include a key absent on both sides). But the common production path — first-attempt success — is the one no test proves against the rules.
Change: three `assertSucceeds` in the log `describe` using the adapters' literal payloads: `updateDoc(ref, { lastAttemptAt: serverTimestamp() })` on a fresh claim; `updateDoc(ref, { attempts: increment(1), lastAttemptAt: serverTimestamp(), error: 'x' })`; `updateDoc(freshRef, { sentAt: serverTimestamp(), error: deleteField() })` with no prior error.

**5. The 20 s deadline is measured from after sign-in + `loadSchedules`, and only stops *starting* work.**
`_lib/shift-reminder.js:134, 173`; `send-shift-reminders.js:50`.
Concrete: cold start ~1 s, sign-in ~0.7 s, `getDocs` ~0.4 s = ~2 s before `startedAt`. A `processOne` started at 19.9 s does a lite transaction (begin + get + commit, 3 RPCs) + Resend + `updateDoc`; a slow Resend tail of 4-5 s puts completion at ~27-28 s of the 30 s scheduled-function budget. Nothing is lost (the claim goes stale and the next tick re-sends under the same key), but the run's summary line is never printed.
Change: pass `startedAt` from the top of `runOnce` (or set `deadlineMs: 15 * 1000`).

**6. "Run now" — I could not confirm this button exists for Netlify scheduled functions.** `CLAUDE.md:25`, plan Phase 5.
If it doesn't, the first production run is simply the next top-of-hour tick after 9 AM Denver (≤ 60 min wait). `netlify functions:invoke` runs the function *locally* under `netlify dev` — not in production, and it would need the bot credentials in a local `.env` — so it must not be used as the substitute. Adjust the runbook line to "wait for the next hourly tick" unless Christie sees the button.

### Nits

- **`no-email` conflates two view states.** `_lib/shift-reminder.js:142` skips a flag naming nobody as `no-email`; the view says `no-account`. The preview therefore can't tell "no linked account" from "account has no email on file". `skip(item, 'no-account')` (and the plan's BDD wording).
- **One malformed `remindUid` halts the whole job for the window.** `_lib/shift-reminder-firestore.js:74` — `doc(db, 'users', 'a/b')` throws synchronously inside the `try`, comes back `ok:false`, and the core aborts `read-failed` (`shift-reminder.js:144-149`). App-written uids can't contain `/`, so this needs hand-edited data; still, validate `/^[A-Za-z0-9_-]{1,128}$/` and skip rather than abort, so the abort stays reserved for permission/transport failures.
- **`snapshotShift` clips by UTF-16 code units; if the rules' `size()` counts bytes, a 200-char note with non-ASCII still fails the create.** `_lib/shift-reminder.js:68`, rules `:465`. I could not verify the `size()` semantics (docs fetch declined). Clipping by `Buffer.byteLength` ≤ cap is correct under any definition and costs nothing. Same for `docId.size() <= 64` — `emp_` + a >60-char name slug would be denied every tick, never sent.
- **View/job disagreement after an untick.** With a log present, `reminderRowStatus` (`js/schedule-helpers.js:609-625`) never looks at `row.remind`, so a failed-but-not-exhausted or stale claim whose flag was since removed reads "— retrying" / "retries at the next tick" while the job will never select it. View-side; a `!row.remind` clause before the `failed`/`claimed` returns.
- **Preview runs under the synchronous-function limit (10 s default), not 30.** `preview-shift-reminders.js:39` uses the core's 20 s deadline. On a big day it 502s (harmless, read-only). Pass `deadlineMs: 8000`.
- **Idempotency with a changed payload.** Crash between send and mark, then the shift or name edited before the next tick → Resend rejects the same key with a different body → counted as failures → exhausted while the email was delivered. Rare; noting only so the audit trail's "failed ✗ idempotency…" is recognisable.
- **The 24 h dedupe vs the two-day window.** If `markSent` keeps failing for > 24 h (a rules regression on update), the D-1 ticks re-send for real. The "sent but NOT marked" ERROR line (`send-shift-reminders.js:55`) is the alarm; treat it as page-worthy.
- **Node runtime not pinned.** `@firebase/auth` and `resend` declare `node >= 20`; `netlify.toml` names the bundler but not the runtime. The existing Resend functions work, so it's ≥ 20 today — confirm in the site's function settings.
- **`schedule()` is a build-time marker (`@netlify/functions/dist/main.js:92` is `(cron, handler) => handler`).** If Netlify ever lets HTTP reach a scheduled function, an anonymous GET is an extra tick: gated, idempotent, no output. Harmless either way.

---

## Checked and found sound

**(a) Rule conformance — every bot write**
- Claim create (`shift-reminder-firestore.js:91`): keys are exactly the seven the rules `hasOnly`/`hasAll` (`:450-451`); `uid`/`date` come from the loaded document id and `addCalendarDays` (zero-padded, matches the regex); `logId == uid + '_' + date` by construction (`:62`); `to` is a non-empty string sliced to 254 after the `typeof === 'string' && email` check (`shift-reminder.js:151-153`); `shift` is exactly four strings via `snapshotShift` (`:66-70`); `claimedAt: serverTimestamp()` equals `request.time` at commit; `sentAt: null`; `attempts: 0` serialises as an integer; `exists(schedule)` holds because the id came from the list (a delete in between → permission-denied → `claim-failed`, retried next tick).
- Re-claim (`:93`): only `lastAttemptAt`, server time; reached only when `!existing.sentAt` and `attempts < 3` (`decideClaim`), so `sentAt == null`, `attempts is int`, `>=`, `<= 3` hold on the post-write doc; a pre-existing `error` (≤ 500) survives untouched.
- `markSent` (`:107`): `sentAt == request.time`; `error: deleteField()` is inside the allowed key set whether or not the key existed; only reached after a claim, so `resource.data.sentAt == null`.
- `markFailed` (`:115`): `increment(1)` from ≤ 2 (the `exhausted` guard) → ≤ 3, integer, monotone; `lastAttemptAt` server time; `error` a string ≤ 500. A stale-but-exhausted claim never reaches it.
- `to`, `uid`, `date`, `shift`, `claimedAt` are never touched by an update (`affectedKeys` check at `:473`).

**(b) Claim/attempt semantics**
- Freshness is `lastAttemptAt ?? claimedAt` (`decideClaim` `:58-59`), matching the Phase 2 note; `markSent` clears a stale `error`. The `< 10 min` / `>= 10 min` boundary matches the view's `stale` (`schedule-helpers.js:624`).
- Two concurrent runs: lite's transaction gives the create an `exists(false)` precondition and the update an `updateTime` precondition (`@firebase/firestore lite:735-748`), retries `aborted`/`failed-precondition`/`already-exists` up to 5× (`:874-885`) and re-reads → `claimed` or `already-sent`; `permission-denied` is permanent and not retried, so a rules denial can't spin.
- Crash costs: before claim → nothing; after claim → one tick's delay (re-claim on staleness); after send → a deduplicated re-send and the mark; a failing `markFailed` → retried every tick, bounded by the window, and loud (`marked: false` in the ERROR line).
- Within a run, `selectRemindersDue` dedupes by (account, date) and processes D+1 before D+2, so the recovery day goes first under the deadline.
- `archived` (`users.active === false`) and `no-email` use the same tests as the view (`schedule-helpers.js:629-631`).

**(c) Lambda realities**
- `'0 * * * *'` in UTC is on the hour in Denver (whole-hour offsets, both DST states); the gate reads the Denver hour via `Intl … hourCycle:'h23'` and is computed once per run.
- `deleteApp` on every path: `openBotSession`'s catch (`:44`), `runOnce`'s and the preview's `finally`; app names are unique per session; in the Node auth build proactive token refresh is off by default (`@firebase/auth … totp-*.js:2644`), so no timers outlive a run.
- The lite node build uses global `fetch` and pulls no gRPC (`common-*.node.cjs.js:1763`); `getAuth(app)` precedes `getFirestore(app)`.

**(d) Preview** — the 405 and the secret check precede any env credential read or session open (`preview-shift-reminders.js:19-23`); both sides are hashed so `timingSafeEqual` always compares equal-length digests; 401 body is generic; the 200 body projects `wouldSend` to `docId/name/date`, and `skipped` rows carry only docId/name/date/reason and a Firestore error string; 503/502 name env-var names and an `auth/*` code, only to a secret holder. Nothing before the gate can throw.

**(e) Credentials** — env only (`readBotConfig`); the email is trimmed, the password never; the sign-in failure line logs `err.code` only; the wiring test forbids `password` in any console call; `FIREBASE_CONFIG` is pinned to `js/firebase-config.js` by the wiring test; no `fs`, no REST, and `firebase-admin` is required only by tests (no deployed function imports it).

**(f) Tests** — the emulator suite drives the real lite adapters (the exact create shape, the concurrent-run property `a+b === 1`, kill-after-send → same key + `claimedAt` immutable + `attempts 0`, fail → claimed → retry → `error` cleared) and runs `reminderRowStatus` on the resulting documents. The pure suite covers every skip reason, the abort-on-denied-read (including mid-run), the deadline claiming nothing for un-started items, and the address-free result. What they let through is item 4 above (rule conformance of the transform payloads) — by design of the rules-less emulator.

**(g) Bundling** — `../../../js/…` from `_lib/` and `../../js/…` from the functions dir both resolve to `<repo>/js/schedule-helpers.js`; the helper has no browser globals at top level and a `module.exports` guard; `firebase`'s `node` export conditions select the CJS `firestore/lite` and `auth` builds; `@netlify/functions` v4 ships a CJS entry (`dist/main.cjs`) and `exports.handler = schedule('0 * * * *', handler)` is the documented detection form; `included_files` is redundant with esbuild's bundling and harmless.

**(h) First production run** — beyond items 1, 6 and the Node pin: the checklist needs (i) the three vars in the production context *and* `RESEND_API_KEY`/`EMAIL_FROM_ADDRESS` visible to that context (a Resend "onboarding" sender only delivers to the account owner); (ii) confirmation that the live ruleset carries `timeclock_reminder_log` (the Decisions log records a deploy incident on this file); (iii) Christie's own users doc has `email` and is not `active: false`, and her flagged override carries `remindUid`; (iv) the preview `curl` is Christie's to run — the secret must never pass through a session.
