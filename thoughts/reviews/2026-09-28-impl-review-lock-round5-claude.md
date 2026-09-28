I read the repo rather than the summary — and the first thing to report is not about the diff.

## Before anything else: the working tree is not `82f9de7`, and it is changing as I read it

```
 M js/app.js
 M js/firebase-data.js
 M js/schedule-helpers.js
 M pay-period-lock.emulator.test.js
 M schedule-editor-wiring.test.js
 M schedule-helpers.test.js
```

When I started, `git status` showed only `.claude/` and `deno.lock`. Two tool calls later `js/firebase-data.js` and `js/schedule-helpers.js` were modified; by the time I finished, four more files were. The new code is signed `(Codex, round five)` in its comments and introduces a shared `findMalformedTotal()` in `js/schedule-helpers.js`.

So: **another session is mid-edit in this tree right now.** Everything below is a review of commit `82f9de7` read out of git, not of the tree. And per your own deploy rule — clean tree, pushed commit, "if the dirty files aren't yours, say so instead of deploying them" — this tree must not be deployed by anyone until that work lands or is cleared. This is the Sep 21 shared-tree situation again, in your own repo instead of studio-hub.

---

## 1. Is the `employeeRosterLoaded` deletion complete and safe?

**Yes.** Repo-wide sweep (no include filter, excluding `node_modules`/`.git`) finds exactly two hits, both the negative assertion in `schedule-editor-wiring.test.js:367-368`. Nothing in `index.html`, the other HTML tools, `netlify/functions/`, `sw.js`, or any inline handler.

Removing the assignment from `loadSchedulesData` left nothing dangling — `rosterResult` is still consumed on the line above (`employeeRoster = rosterResult.roster`), so only `.ok` became unread. No behaviour change. The wiring test's ordering assertion (`employeeRoster = rosterNow.roster` between `if (result.ok)` and `renderAdminTimesheets()`) still holds.

One check worth recording: the sibling flag `allUsersLoaded` is **not** in the same state — it has two real readers (`app.js:3229`, `app.js:5769`). So the commit message's "two writes, zero reads" is specific to the flag you deleted and correct.

Nit: the negative test asserts against `src` (app.js only), not the repo. If the flag were reintroduced in an inline script it would pass. Harmless.

## 2. `keys.find` + the returned `name`

The `name` read is safe against every shape you asked about — `null` and numbers and strings fail `typeof v === 'object'`, an array's `.name` is `undefined`, all fall to `null`. Fine.

But the refactor introduced a real hole, and it's in the `find`, not the `name`:

**`keys.find()` returns the key, and `if (badKey)` is a truthiness test on a value that can legitimately be falsy.** `Object.keys({'': rec})` is `['']`; `[''].find(...)` returns `''`; `if ('')` is false. A malformed record stored under the empty-string uid **passes the guard and gets written into the payroll snapshot**. `keys.some()` could not do this — the refactor turned a total predicate into a truthiness test. Reachability is narrow (needs a `timeclock_entries` doc with `uid: ''`; `calcPeriodTotals` builds keys straight from `e.uid`, and its roster branch is guarded by `emp.claimedBy &&` so it can't produce `''`), but this is the one guard standing between a NaN and the Payroll Tool. `if (badKey !== undefined)` is the whole fix.

And **yes, the first-of-several problem is real.** `find` names one person; a bad CSV import can easily produce several. The manager fixes Anika, locks, is refused naming Jess, fixes, locks again — a shorter loop than "no information", but this branch exists specifically to end the loop. `filter` + a count closes it.

## 3. The alert text — the `NaNh total` claim

The mechanical claim **is true**: `app.js:2272` is `<strong>${total.toFixed(2)}h</strong> total`, `total` is `ot.regular + ot.overtime`, `calcPeriodTotals` computes the identical expression, `Math.max(0, NaN)` and `Math.round(NaN*100)/100` are both `NaN`, and `NaN.toFixed(2)` is `"NaN"`. The card reads `NaNh total`.

**The "only visible tell" claim is false**, and it is now frozen in a code comment *and* a test comment:

- A bad **clock-out** timestamp (the main NaN source) makes `formatTime` hit its `isNaN(date)` guard and return `''`, so the row renders `9:00 AM–...` with `-` hours — visually identical to an open punch. And no ⚠️ Open punch pill fires, because that detector requires *no clock-out document*, and the document exists.
- A bad **break-end** timestamp renders both times normally with `-` hours.

So there is a second visible tell, and it is the only one that says *which day*. "Fix that entry" is the instruction the message gives, and the message points at the one symptom that can't locate the entry. `calcPeriodTotals` already has `dailyHours` keyed by date — the bad date is knowable and could be named.

Also: a bad **clock-in** produces no NaN at all — see the adjacent finding below.

## 4. Anything stale

- The `handleLockPeriod` comment "the only visible tell is the person's card header" — false, per above.
- Same claim repeated in the `schedule-editor-wiring.test.js` comment.
- Test title: `'a refusal retrying cannot fix names WHO, and the symptom that is actually on screen'` parses as a garbled noun phrase; it wants "a refusal **that** retrying cannot fix names WHO…". Round four caught a test whose title contradicted its assertion; this one just doesn't parse.
- `js/firebase-data.js` comment "find, not some: ONE employee blocks the whole period" is accurate for the commit but is the line that carries finding #2.

## 5. `handleLockPeriod` as a whole

The order is correct and the reads are right. `loadEmployeeRosterResult` does genuinely return `fromCache` (I checked — it isn't a dead guard). `period` is captured once at the top, so prev/next clicks during the two awaits cannot desync the key from the totals — the same hazard `handleUnlockPeriod` closes by parameter, closed here by capture. A double-click gets refused by the transaction as `already-locked`. Nothing stored differs from what was confirmed.

Two paths where the *message* diverges from reality:

**The malformed check is on the wrong side of the confirm.** `Number(employeeTotals[uid].totalHours) || 0` counts the NaN person as **zero hours**. So the manager is shown "5 people, 120 hours. *These are the numbers payroll will use.*" — a total that silently omits someone whose hours are unknown — approves it, and *only then* is refused. Nothing bad is stored, so it isn't a data defect. But the confirm dialog states a number that will never be stored, and the `|| 0` is precisely the mask that hides the problem from the person being asked to approve. This is the same family as the ORDER defect the rewrite was named after.

**The generic error branch asserts something it can't know.** `alert('Failed to lock period — nothing was changed.')` fires from the `catch` around `runTransaction`. A commit that is sent but whose response is lost, after the SDK exhausts its retries, leaves the period locked while the alert says nothing changed. The three pre-write refusals can honestly claim "nothing was locked"; this one can't. (Recovery works — the retry hits `already-locked` — but the sentence is a "red row"-class assertion.)

Minor: the confirm shows one aggregate hours figure, while what payroll actually uses is three numbers per person, and overtime is paid at 1.5×. "These are the numbers payroll will use" with no OT split is a small overstatement.

### Adjacent, pre-existing, and larger than anything in this diff

A bad **clock-in** timestamp doesn't produce NaN — it produces silence. `calculateDayHours` sets `clockInTime = NaN`, and the clock-out branch is `else if (e.type === 'clock-out' && clockInTime)` — **`NaN` is falsy**, so the pairing is skipped and the day totals `0`. `0` is finite, so the malformed guard passes, the lock succeeds, and the day renders `-` / `-` — indistinguishable from a no-show. An employee who worked gets paid zero, with no refusal and no NaN anywhere.

Not introduced here, not in your out-of-scope list, and it's the hole this guard doesn't cover. Its own change.

## Firebase invariants

| Invariant | Result |
|---|---|
| Guarded merge, never a blind `setDoc` | ✅ `tx.set(..., {merge:true})` inside a transaction that pre-checks `existing` |
| Critical writes awaited | ✅ `return await _db.runTransaction(...)`; caller awaits `lockPayPeriod` |
| No new collection / no rules change | ✅ only `timeclock_settings/lockedPeriods`. I could not read `~/studio-hub/firestore.rules` — it's outside this session's allowed directory — so I'm taking your rules:443 verification as given |
| No bulk delete/import | ✅ |
| **`undefined` / empty strings stripped** | ❌ **violated.** `calcPeriodTotals` emits `name: emp.name \|\| ''`, and `lockPayPeriod` writes `totals` verbatim — an entry with no `name` field writes `name: ''` into the payroll contract document |

## 6. Is it ready to deploy?

**No** — three independent reasons, in order of how much they should stop you:

1. **The tree isn't yours right now.** Six files modified by another session, mid-flight. Nothing here can be deployed until that's resolved.
2. **It hasn't converged.** Five real items in `82f9de7`: the falsy-key bypass, first-of-several, the confirm-before-validate ordering with the `|| 0` mask, the empty-string write, and the "only visible tell" claim now baked into a comment and a test.
3. **I could not run the tests.** `npm test`, `firebase emulators:exec`, and even `node` were all refused in this non-interactive session, so the 1800-passing claim is unverified by me. Everything above is static reading plus certain JS semantics.

One thing that should shift your read of #2: I derived the `|| 0` mask, the first-of-several gap, and the falsy-key hole from HEAD **before** I noticed the dirty tree. The concurrent session then turns out to have landed fixes for the same three (`filter` + `count` closes both the falsy key and first-of-several; the caller now validates before confirming; the `|| 0` is gone), plus the empty-string strip, plus it dropped the screen assertion from the message for the reason I'd have given ("these totals come from a fresh read, so the card on screen… need not show the same thing"). Two reviewers converging on the same list independently is the useful signal here — not that the code is converged, but that the *findings* are.

What survives that work, still open: the generic error branch's "nothing was changed"; no day-level locator in the message even though `dailyHours` knows the date; the OT split missing from the confirm; the garbled test title; and the silent-zero clock-in bug.

Two things to flag to the other session, since its code now touches the cross-app contract: the pre-write `clean` rebuild is an **allowlist** — it silently drops any field a future producer adds to a record the Payroll Tool reads; and `js/firebase-data.js` now depends on a `schedule-helpers.js` global at a call site outside its `try`, so every vm-sandbox harness that exercises `lockPayPeriod` must inject `findMalformedTotal` (it correctly did so for `pay-period-lock.emulator.test.js`; the browser is fine because the call resolves long after both scripts load).
