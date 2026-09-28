I read `js/firebase-data.js`, `js/app.js`, the new emulator test, `js/firebase-config.js`, and traced every writer of `timeclock_settings/lockedPeriods`. I did **not** run `npm test` (it needs approval in this session), and `~/studio-hub/firestore.rules` and `~/payroll-tool/index.html` are outside this session's sandbox — everything below is from reading the source, and I flag the two unverified items explicitly. No files were edited.

## The transaction is sound (question 1)

Compat v10.8.0 (`index.html:1146-1148`) delegates `Firestore.runTransaction(fn)` to the modular `runTransaction`, which resolves to the callback's return value — returning `{ok, reason}` is correct, not a quirk you're relying on. `tx.set(ref, data, {merge:true})` is supported; reads-before-writes is satisfied; the computed key `2026-09-01_2026-09-15` has no dots, and `set` treats top-level keys as literal field names regardless.

Retries: returning normally on `already-locked` is not an abort, so no retry and an empty write set. On a genuine `ABORTED` retry the callback re-reads and recomputes `lockedAt`, and Firestore commits the write set once — no double-write. The `already-locked` payload cannot be stale; it comes from the attempt that committed.

One behavioural change worth knowing: persistence is on (`firebase-config.js:30`), and transactions bypass the cache and require the server. Offline, the old `set()` promise would hang or apply locally; now the lock fails fast with `reason: 'error'`. That's an improvement for payroll.

## Finding 1 — a cache-served read reports `ok: true`, so the `!read.ok` guard misses the commonest failure

`js/firebase-data.js:110` calls `query.get()` with no options. That is `source: 'default'`: try the server, **fall back to the local cache** when it can't be reached, and resolve successfully. Persistence is enabled with `synchronizeTabs`, so that cache is durable across sessions. `fromCache` appears nowhere in this repo, and `initOfflineDetection` (`js/app.js:42-67`) only shows a banner — nothing disables the Lock button.

So the caller-side half of the Path A fix does not fire for a dropped connection: `read.ok` is `true`, the roster flag is `true`, and `calcPeriodTotals` produces plausible but possibly stale or partial totals. The transaction happens to cover the *fully* offline case (it can't reach the server either, so the lock fails). The gap is the flap window — cache-served read, connectivity back by the time the transaction runs — which writes a snapshot nobody could have reviewed against current data, with no confirm and no warning.

This is also the direct answer to question 3: **yes**, there is one case where `isEmpty` is a symptom rather than a fact, and it's this one. Otherwise `isEmpty` is exactly "zero entries returned" — `calcPeriodTotals` emits a key for every uid with at least one entry (`js/app.js:1996-2012`), so `{}` ⟺ empty `read.entries`. And the confirm text ("This period has NO hours for anyone") gives the manager no hint that "…or we couldn't reach the server" is a possibility.

Cheap fix, in the spirit of the rest of the change — report, don't gate:

```js
return { ok: true, fromCache: !!(snap.metadata && snap.metadata.fromCache),
         entries: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
```

and refuse on `read.fromCache` in `handleLockPeriod` only. The seven display callers keep working offline. (`get({ source: 'server' })` on the shared function would also work but would break them.)

## Finding 2 — `employeeRosterLoaded` can be `true` while `employeeRoster` is wrong

The flag is set in exactly one place (`js/app.js:2876-2878`), but `employeeRoster` is assigned in eleven. Four of those go through the **swallowing** `loadEmployeeRoster()`, and one is not fail-safe:

`seedEmployees` (`js/app.js:6031-6048`) does `let roster = await loadEmployeeRoster()`. A failed read yields `[]`, so `existingIds` is empty, every `SEED_EMPLOYEES` name is appended, and `saveEmployeeRoster(roster)` — a full `set()` with no merge (`js/firebase-data.js:483`) — replaces the roster document with seed-only entries. Then `employeeRoster = roster` while the flag stays `true`. A lock after that passes the roster guard with a roster that has lost every `claimedBy`, so the `emp_` merge silently doesn't happen and the payroll snapshot splits one person into two rows — precisely the harm the guard was added for.

The roster-overwrite itself is pre-existing and outside this diff, but it's the same swallowed-read shape, and it now also defeats the new guard. Within this change's scope the fix is to stop trusting a global written by eleven call sites: have `handleLockPeriod` call `loadEmployeeRosterResult()` itself, right next to the entries read.

The ordering half of question 6 is fine: `loadSchedulesData` is awaited at `js/app.js:136` before `hideLoading()`, and the flag defaults to `false`, so an unreached path fails safe.

## Finding 3 — Unlock (question 7)

A failed lock-status read **cannot** misdirect unlock: `getLockedPeriods()` returning `{}` renders `isLocked: false`, and the Unlock button lives inside `lockEl.innerHTML` (`js/app.js:2060-2062`), so it isn't rendered at all. That specific worry is unfounded.

The reachable one is the offset race. `handleUnlockPeriod` re-derives its period from the mutable global (`getPayPeriod(adminTsPeriodOffset)`, `js/app.js:2844`), but the button in the DOM belongs to the period current at render time. After `adminTsPeriodOffset--` (`js/app.js:2038`) the stale button stays clickable through two awaited reads. A click in that window unlocks the newly-selected period — and unlock is an irreversible `FieldValue.delete()` of the record of what was paid. The confirm names the new label, which is the only thing catching it.

Fix is one line, matching what `openAdminEntryEditor` already does: render the key into the handler, `handleUnlockPeriod('${period.key}')`.

The same race exists on Lock and is harmless there — `handleLockPeriod` captures `period` once and reads that period's own entries, so it stays self-consistent.

## Tests (question 8)

- **The hybrid test passes for the wrong reason.** `pay-period-lock.emulator.test.js:105-113` seeds a locked period and asserts only `r.ok === false`. It is the Path B test with a different payload. There is no partial-snapshot detection in `lockPayPeriod` for it to exercise — the refusal is `already-locked` — and the test would pass if the function refused for any reason whatsoever. Assert `reason: 'already-locked'` so it at least records which guard fired.
- **Nothing tests the transaction.** All eight tests seed, then call once. A plain `get`-then-`set` with an existence check would pass every one of them. The transaction exists for the interleaving — two managers, or one double-click on a button that is never disabled — and that is the single thing untested. Two concurrent `lockPayPeriod` calls asserting exactly one `ok: true`, one `already-locked`, and one stored `lockedAt` would pin it.
- **Fixture shape drift.** `TOTALS` is `{name, hours}`; `calcPeriodTotals` produces `{name, regular, overtime, totalHours}` (`js/app.js:2024-2029`), which is the Payroll Tool's contract. `lockPayPeriod` is shape-agnostic so nothing fails, but the tests don't document the real record.
- The realm shim at line 44 is correct and correctly explained — an async function's promise comes from its creating realm's intrinsic, not the `Promise` global you injected. Note it means the tests run under the Admin SDK, which ignores rules; see below.

## Questions 4 and 5

**No missed caller.** `lockPayPeriod` has exactly one (`js/app.js:2832`), it destructures properly, and `index.html` has no inline `onclick` reaching it. Grep confirms `timeclock_settings/lockedPeriods` has one writer and one deleter, so Path A's *write* side is genuinely closed.

**The wrapper is behaviourally identical** for every caller: `[]` when not ready, `[]` on throw, mapped docs otherwise. Two corrections to your framing: it's **seven** other callers, not five (`js/app.js:937, 2073, 2263, 4755, 4897, 5043, 5195`); and `js/app.js:5043` assigns the result to an unused `allEntries` — a full pay-period read on every alert dismissal, dead before this change.

## Firebase invariants, and two things I could not verify

From the diff: no blind `setDoc` (the only `set` is merge-scoped to one period key inside the transaction); the critical write is awaited; no bulk delete or import; no new collection and no rules change needed. One nit against the "strip empty-string fields" rule: `calcPeriodTotals` emits `name: emp.name || ''`, so an entry with no `name` writes an empty string into the payroll record. Pre-existing, low.

**Verify before deploying:** the transaction adds a **read** of `timeclock_settings/lockedPeriods` to a path that previously only wrote. If managers have write-but-not-read on that document, locking now fails closed with "Failed to lock period". `getLockedPeriods()` swallows its errors, so the UI would never have revealed such an asymmetry. The rules file is outside this session's sandbox — check `allow read` for the locking role. This fails closed, so there's no corruption risk, only a broken feature.

**Not checked:** `~/payroll-tool/index.html:2828`, also outside the sandbox. The document shape and the field names `name/regular/overtime/totalHours` are unchanged by this diff, so the contract holds from the producing side.

## Structural note

The period totals are now computed by three copies of the same logic — `calcPeriodTotals` (`js/app.js:1994`), inline in `renderAdminTimesheets` (`2083-2098` + `2145-2151`), and inline again in `exportTimesheetsXlsx` (`2266-2283`). I checked: they currently agree, including rounding. But "the locked totals match what the manager saw" is the whole point of this commit and it rests on three copies staying in sync with nothing pinning them. Having `renderAdminTimesheets` take its header numbers from `calcPeriodTotals` would make the claim structural instead of coincidental.

**Bottom line:** the transaction is correct, Path B is closed, and the write-side of Path A is closed. Path A's caller-side guard has one real hole (finding 1) and the roster guard has one (finding 2); both are small, targeted fixes. Findings 1–3 are worth doing before this ships.
