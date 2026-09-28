I read the three files at `067bba5` rather than the diff. One thing up front: **I could not run `npm test`** — `npm test` and `npx jest` were both denied in this non-interactive session, so the 1797 count is your number, not mine. Everything below is static verification. I made no edits (this repo needs your written approval).

The commit is mostly right. Three of the four fixes do what they claim. The roster fix does not.

---

## 1. The roster fix does not prevent the failure it was written for — and the rationale cites a function that doesn't exist

`js/app.js:2838-2847`. The comment and the commit message both say:

> `seedEmployees` can overwrite the stored roster after a failed read while leaving `employeeRosterLoaded` true… A lock then passes the guard with a roster that cannot do the `emp_` merge.

There is no `seedEmployees` in this repo. `grep -rn "seedEmploy" js/` returns only that comment. The real clobber path is `saveEmployeeRoster(employeeRoster)` — `js/app.js:5902`, `6114`, `6584` — which writes the **whole global array** back to Firestore.

`js/app.js:6114` is the live one:

```js
employeeRoster.push({ id, name, claimedBy: null, active: true });
const success = await saveEmployeeRoster(employeeRoster);
```

Global is `[]` from a failed read (four call sites assign `roster.roster`, which is `[]` on failure) → an admin adds one person → the stored roster becomes a one-element array and every `claimedBy` is gone.

Now run the new guard against that state. `loadEmployeeRosterResult` (`js/firebase-data.js:416`) returns `{ ok: true, roster: [thatOnePerson] }`. `rosterNow.ok` is `true`. `calcPeriodTotals(read.entries, [onePerson])` does no `emp_` merge for anybody, and the payroll snapshot splits every claimed person into two rows — **the exact harm the guard exists for, through a read that is perfectly `ok`.**

Reading the roster fresh only helps when the *global* is wrong. It cannot help when the *stored document* is wrong, which is what the commit message describes. `.ok` is not the predicate that detects this; only comparing against what the screen merged, or a non-empty/`claimedBy`-present check, would be.

Same shape at the empty end: `loadEmployeeRosterResult` returns `{ ok: true, roster: [] }` for a missing document, so "the roster document is gone" reads as a successful lock. The declaration comment at `js/app.js:5572` says "an empty one is not the same as none" — the code has never made that distinction, and this commit didn't add it.

## 2. The stored snapshot is now computed from a different roster than the screen

`calcPeriodTotals` has exactly one caller in the file — `js/app.js:2848`, the lock. `renderAdminTimesheets` (`js/app.js:2094-2110`) and `exportTimesheetsXlsx` (`js/app.js:2280`) each carry their own inline copy of the `emp_` merge, reading the **global** `employeeRoster`.

Before this commit both paths read the same global, so the snapshot's merge always matched the screen's merge. After it, the lock reads fresh and the screen does not, and nothing re-renders. If a `claimedBy` changed between page load and the click, the manager confirms a dialog naming only the period, sees no difference, and a different set of rows lands in the document payroll treats as authoritative.

This inverts af15db0's own stated purpose ("the lock can no longer store totals nobody saw"). The section header at `js/app.js:2003` — `// ─── Period Totals (shared by renderAdminTimesheets + lock) ──` — is now false.

Cheapest fix that restores the invariant: assign `employeeRoster = rosterNow.roster` after the successful read, so the next render converges, and `employeeRosterLoaded` stops being a lie.

## 3. `employeeRosterLoaded` is now write-only

Assigned at `js/app.js:2903`, declared at `5572`, read nowhere:

```
js/app.js:2841:  // ...while leaving employeeRosterLoaded true...   ← comment
js/app.js:2903:  employeeRosterLoaded = rosterResult.ok;            ← write
js/app.js:5572:let employeeRosterLoaded = false;                    ← decl
```

Its comment still claims it guards the payroll snapshot. Yes, it's dead — delete it, or make it real per #2.

## 4. `typeof v.totalHours !== 'number'` lets `NaN` through

`js/firebase-data.js:180-184`. `typeof NaN === 'number'`, and `calcPeriodTotals` can emit it:

- `calculateDayHours` (`js/app.js:1965`) returns `Math.max(0, paidMs / 3600000)` — `Math.max(0, NaN)` is `NaN`, reached whenever a `clock-in` entry's `timestamp` doesn't parse.
- `calculateOvertimeForPeriod`: `weeks[k] += NaN` → `NaN > 40` is **false** → `regular += NaN`.
- `Math.round(NaN * 100) / 100` → `NaN`.

Result: `{ name: 'X', regular: NaN, overtime: 0, totalHours: NaN }`. Firestore stores `NaN` as a double, so it lands in the contract document.

Reachability, honestly: no current in-app write path produces a bad stored `timestamp` — `js/app.js:1274`, `1297`, `2505`, `2595` all go through `.toISOString()`, which throws on an Invalid Date rather than writing one. So this needs a document from an older schema, a console edit, or an import. Given this app's migration history (`emp_` ids, `migratedFromChain`), that isn't hypothetical. `Number.isFinite(v.totalHours)` is free and is what the guard means.

Related: the comment says the Payroll Tool reads "totalHours / regular / overtime" but the check only looks at `totalHours` — and `regular` is precisely the field that goes `NaN` while `overtime` stays `0`.

## 5. `malformed-totals` is routed into the "try again" branch

`js/app.js:2858-2861`. The new reason falls through to:

```js
alert('Failed to lock period — nothing was changed. Please try again.');
```

Retrying will never make a malformed snapshot well-formed. A manager hits this at a payroll deadline and retries indefinitely with no indication of what's wrong. `no-totals` and `not-ready` have the same problem, but `malformed-totals` is new here. It needs its own message, or at least one that doesn't say "try again."

## 6. The `fromCache` guard fails open, and the roster read has none

`js/firebase-data.js:114`: `fromCache: !!(snap.metadata && snap.metadata.fromCache)`. If `metadata` is ever absent the guard silently reports "fresh" and stops guarding — for an irreversible payroll write, the defensive `&&` is pointed the wrong way.

That is not theoretical in your own harness: the emulator tests run `firebase-admin`, whose `QuerySnapshot` has no `.metadata`, so this expression is always `false` there. **The new guard has no executable test anywhere** — only the source-regex at `schedule-editor-wiring.test.js:326`.

And the roster read you added one line later is a plain `doc.get()` with the same `source:'default'` cache fallback, with no `fromCache` check at all. In practice the entries check fires first and returns early, so the window is narrow (connection drops between the two awaits, recovers before the transaction). But it's the same hole, one read later.

## 7. `getPayPeriodByKey` — correct for real keys, incomplete as an object

Verified correct for everything the app produces. `formatDateStr` (`js/app.js:4410`) emits `YYYY-MM-DD` with `padStart`, so keys have exactly one `_` and no HTML metacharacters. The labels match `getPayPeriod` exactly: `getPayPeriod` builds `new Date(y, m, 1)` (local midnight) and `getPayPeriodByKey` parses `'…T12:00:00'` (local noon) — both render the same calendar date through `toLocaleDateString` with no `timeZone`, including across a year boundary.

Two real gaps:

- **It returns `{ key, startStr, endStr, label }`; `getPayPeriod` returns those plus `start` and `end` Dates.** Unlock uses only `key` and `label`, so it's fine today. But the two now look interchangeable and are not — a future caller doing `period.start` gets `undefined` silently.
- **`handleUnlockPeriod`'s fallback keeps the bug alive.** `const period = periodKey ? getPayPeriodByKey(periodKey) : getPayPeriod(adminTsPeriodOffset)` — the re-derive-from-mutable-offset path you just removed is still in the function. Unreachable from the one call site, but a second call site that forgets the argument gets the race back with no signal. `if (!periodKey) return;` makes the invariant enforceable.

On a malformed key, nothing dangerous happens: `unlockPayPeriod` does `set({[key]: FieldValue.delete()}, {merge: true})` on a field that doesn't exist — a no-op that returns `true`. It won't delete the wrong thing; it'll report success having done nothing.

---

## Answers to what you asked

**2. The button quoting is correct.** `grep -F` confirms `js/app.js:2073` produces `onclick="handleUnlockPeriod('2026-09-01_2026-09-15')"` — valid HTML, handler gets the key, and no key the app generates can break out. `handleUnlockPeriod` is a top-level declaration in a non-module `<script>` (`index.html:1158`), so it's on `window`.

But you edited a line that has an unescaped sink right next to the new one:

```js
lockEl.innerHTML = 'This pay period is locked. ' + (lockInfo.lockedBy || '') + ' locked it on ' + …
```

`lockedBy` is `getAuthUser().name` — a stored display name — interpolated raw into `innerHTML`. The file already escapes for exactly this (`js/app.js:2243`: `const safeUidAttr = escapeHtml(uid);` before putting a uid in an `onclick`). Low severity; on the line you touched.

**4. `snap.metadata.fromCache` is the right signal and the caller is the right layer.** It's present on a compat `QuerySnapshot`, and `getDocsViaSnapshotListener` uses `waitForSyncWhenOnline: true` — it only raises a cached snapshot once OnlineState is *Offline*, so `fromCache: true` really does mean "the server was unreachable," not "cache was warm." Persistence is on (`js/firebase-config.js:30`), so the hole you're closing was real. Reporting rather than gating is correct: the seven `getEntriesByDateRange` display callers (I count exactly seven: `js/app.js:937, 2084, 2274, 4780, 4922, 5068, 5220`) should keep working offline.

One false-positive to know about: the SDK flips to Offline after a ~10s first-connection timeout, so a slow-but-working connection refuses the lock and tells the manager to "reconnect" when they *are* connected. It fails safe, so it's a message-wording issue, not a bug.

**6. The concurrency test is real but not guaranteed.** It genuinely distinguishes a transaction from get-then-set: two concurrent merge-sets would both return `ok: true` (`{merge: true}` recurses into nested maps, so `employeeTotals` would union to three uids) and `expect(wins).toHaveLength(1)` would fail. The catch is that nothing *forces* interleaving — if the two calls happen to serialize, a get-then-set implementation passes too. In practice `Promise.all` puts both `tx.get` calls in flight together, so it works; just don't treat it as a guarantee. Minor flake risk: if the loser exhausts its 5 retries it returns `reason: 'error'`, not `'already-locked'`, and the assertion at line 163 fails.

**7. The slice boundaries are fine.** `handleLockPeriod` → `handleUnlockPeriod(` spans bytes 113185–116295 = ~3110 chars, inside the new `>500 / <4000` window — though that leaves only ~890 chars of headroom before the bound fires spuriously. The tricky regex verifies: `grep -F "handleUnlockPeriod(\\'' + period.key + '\\')"` matches exactly once. `not.toMatch(/await getEntriesByDateRange\(/)` still correctly misses `getEntriesByDateRangeResult(` because of the literal `\(`.

Nothing else broke. No test asserts the full return shape of `getEntriesByDateRangeResult`, so adding `fromCache` is safe. The slice-boundary pattern is used ~50 times across `schedule-editor-wiring.test.js`; only the one you fixed was touched by this change.

## Firebase invariants

Clean. `tx.set(…, { merge: true })` inside the transaction, guarded by the `existing` read — not a blind `setDoc`. No `undefined` written: `lockedBy` falls back to `'unknown'`, `lockedAt` is an ISO string, totals come from `calcPeriodTotals` which always sets all four fields. `return await _db.runTransaction(…)` is awaited, and `handleLockPeriod` awaits `lockPayPeriod`. No new collection, no rules change needed, no bulk delete or import.

One nit against your own CLAUDE.md rule ("strip `undefined` and empty-string fields before any write"): `calcPeriodTotals` writes `name: emp.name || ''`, so a nameless entry stores an empty string inside `employeeTotals`. Pre-existing, not from this diff.

## What I'd change before this ships

Blocking: **#1** (the roster guard doesn't detect the failure it names, and the comment cites a nonexistent function) and **#2** (screen and snapshot now disagree). Both are in the fix that was supposed to be the careful one.

Cheap and worth doing in the same pass: `Number.isFinite` for #4, a real message for `malformed-totals` (#5), and deleting or wiring up `employeeRosterLoaded` (#3).
