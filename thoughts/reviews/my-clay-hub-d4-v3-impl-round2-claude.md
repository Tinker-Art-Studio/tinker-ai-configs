I could not run the suite here (the sandbox refuses `node --test` / `npm run test:functions` without an interactive approval), so everything below is from reading the code, the installed `google-gax` / `@google-cloud/storage` sources, the plan and the two round-1 reviews.

## 1. Round-1 findings — each one checked

**Codex**

| # | Status | Where |
|---|---|---|
| 1 blocking — the budget doesn't bound Google calls | **resolved** | `functions/vault/deadline.js:18-29` (limiter) + `export-run.js:100-102` (limiter, limited bucket, `callOptions`), applied at `:111` (folder listing), `:120-122` (operation listing), `:162-165` (export), `:178` (poll); `freshness.js:33-36` + `vault-config.js:31-32` for `vaultFresh` |
| 2 blocking — the restore runbook's "fresh copy" | **resolved** | `DATA-RESTORE.md:41-46`: a manual Console export to `manual/pre-restore-<date>`, verified by its own metadata file, with the "already done" reason spelled out |
| 3 should-fix — the error path permitted an unreviewed IAM widening | **resolved** | `DATA-RESTORE.md:86-88` now says stop, record the exact permission and principal, change nothing until Christie approves |
| 4 nit — DECISIONS #63 "No identity can import" | **resolved** | `DECISIONS.md:80`: "No deployed function or service account can import into production (only Christie, as Owner, by hand)" |

**Claude**

| # | Status | Where |
|---|---|---|
| 1 should-fix — pre-restore copy | resolved (same as Codex 2) | `DATA-RESTORE.md:41-46` |
| 2 should-fix — budget doesn't bound calls | resolved | as above |
| 3 should-fix — when Firestore writes `.overall_export_metadata` is unproven | **resolved in the plan, correctly not in code** | plan V-4 step 8: while the first real export runs, Christie opens the folder; if the metadata file is already there, stop and revise the completeness test |
| 4 should-fix — the rehearsal database's rules | resolved | `DATA-RESTORE.md:38-40`: created in production mode, Rules tab checked before importing |
| 5 should-fix — `index.js`'s handler body runs in no test | resolved | `tests/functions/vault/wiring.test.js` — the real `index.js` with only `clients.js` faked, asserting the database path, the prefix shape and that it waited for the complete folder |
| 6 nit — fresh suffix doesn't exclude what's in hand | resolved | `export-run.js:152-159`; test at `export-run.test.js:309-316` |
| 7 nit — an unknown state anywhere fails every run | resolved | `readExportOperation` no longer judges state (`export-run.js:69-85`); `checkState` (`:87-90`) is applied only after the prefix filter (`:127`) and in `waitFor` (`:181`); tests at `:238-266` |
| 8 nit — `listFolders` caps folders but not pages | resolved | `vault-bucket.js:20-21`, `vault-config.js:33-34`; test `vault-bucket.test.js:23-26` |
| 9 nit — the second "already done" is untested | resolved | reachability comment `export-run.js:136`; test `export-run.test.js:318-331` makes the export land between the two listings |
| 10 nit — `firebase-admin` unused | **deliberately not changed, and the stated reason is correct** — it is a *non-optional* peer dependency of firebase-functions 7.4.0 (`functions/vault/node_modules/firebase-functions/package.json`: `firebase-admin` is in `peerDependencies` and absent from `peerDependenciesMeta`), so npm installs it either way |
| 11 nit — untested defensive branches | resolved | `tests/functions/vault/vault-bucket.test.js` covers all of them |

## 2. The new deadline handling

**Can a path still exceed 1,500 s / 20 s / Cloud Run's timeout?** I couldn't find one. Every call that leaves the process is wrapped: `bucket.getFiles` through `limitedBucket` (`deadline.js:32-34`), `listOperationsAsync` per `next()` (`export-run.js:122`), `exportDocuments` (`:162`), `getOperation` (`:178`). `limit` recomputes `deadline - now()` on each call and rejects outright at zero (`deadline.js:20-24`), so the page loops in `listFolders`/`completeMetadata` and the 1,000-item operation loop are all bounded in aggregate, not per call. The only unwrapped wait is `sleep(POLL_MS)`, guarded by `limit.left() <= C.POLL_MS` before it (`export-run.js:193`). Client construction happens in `index.js:41-42` before the clock starts, but it does no I/O. 1,500 s + cold start is comfortably inside `timeoutSeconds: 1800`.

For `vaultFresh`: `FRESH_BUDGET_MS` 20 s against `timeoutSeconds: 30` (`index.js:60`), and `answerFreshness` catches the expiry into the 500 (`freshness.js:37-40`), so the uptime check always gets a real response.

**Can a timeout produce a wrong outcome?** No. Every expiry is a rejection, so there is no path to a false success. The important property — a cut-short listing must never read as "no folders" / "no metadata" — holds: `listFolders` and `completeMetadata` only ever return a complete answer or throw (`vault-bucket.js:23-37`, `:61-69`), and a rejected `limit` propagates out of the `await` rather than producing a falsy result, so e.g. `export-run.js:188` can't emit the misleading "says SUCCESSFUL but holds no complete export" on a timeout. An `exportDocuments` that times out but succeeded server-side lands in the already-designed O5 case: the next Scheduler retry either resumes it (step 2) or writes a second *complete* folder under a different suffix, now with the suffix-collision window narrowed by the `taken` set.

**The gax `{ timeout }` option** is used correctly, and all three methods take it: `exportDocuments(request, options)` (`firestore_admin_client.d.ts:825`), `getOperation(request, options, callback)` (`:1549`, delegating at `firestore_admin_client.js:2191`), `listOperationsAsync(request, options)` (`:1580`, `:2223`). It is milliseconds. For `getOperation`/`listOperations` (retry codes non-empty) `CallSettings.merge` sets `initialRpcTimeoutMillis`, `maxRpcTimeoutMillis` and `totalTimeoutMillis` all to it (`google-gax/build/src/gax.js:176-180`), so gax's retry window really does close at the deadline; for `exportDocuments` (`non_idempotent: []`) it becomes the single RPC's gRPC deadline via `addTimeoutArg` (`createApiCall.js:117`). A fresh options object is built per call, which matters because the generated client mutates it (`firestore_admin_client.js:2184-2190`).

**Lost races.** No unhandled rejections. `realTimeLimit` races both branches so a late rejection of the real call is already handled, and the timer is cleared in `.finally` (`deadline.js:14`); the zero-budget branch explicitly attaches a `.catch` (`:22`). The abandoned operation iterator leaves no dangling promise, and gax's iterator has no `return()` for `for await` to have called either (`paginationCalls/pageDescriptor.js:112-118`), so replacing the `for await` with a manual `next()` loop loses nothing.

## 3. Did the fixes break anything?

No. I walked the round-1 tests that still exist against the changed code: the budget-expiry test (`export-run.test.js:151-161`) still lands inside its window (the condition moved from `left < POLL_MS` to `left <= POLL_MS`, so it gives up at 1,485,000 ms instead of 1,500,000 — both satisfy the assertion); `checkState`'s relocation keeps every fail-closed path for the run's own exports (`:127`, `:181`); `taken` (`:152`) can't throw, because `ours` is already filtered to `gs://<BUCKET>/weekly/<key>-` before `folderOf` sees it; `limitedBucket` exposes only `getFiles`, which is all `vault-bucket.js` ever calls (asserted textually at `surface.test.js:50-52`); and `vault-bucket.js` requiring `vault-config` introduces no cycle.

## 4. Tests and fakes

The new tests are real, not vacuous. `export-run.test.js:278-288` asserts the run gave up at *exactly* the budget and that the hung read got only the remainder; `:301-307` drives a genuinely slow listing to reach the `START_RESERVE_MS` branch; `:318-331` constructs the finishes-between-the-two-listings race rather than asserting it abstractly; `vault-bucket.test.js` hits each defensive branch with the shape that triggers it. `settlesWithin` (`fakes.js:72-76`) is a good addition — a hung call that isn't bounded fails in 5 s with a clear message instead of poisoning the run. The fakes stay faithful: operations are still encoded with the pinned protos and decoded through gax's own proto-loader options, and `fakeTimeLimit` only short-circuits promises explicitly marked `hang`.

---

## Findings

### Should-fix

**1. `functions/vault/deadline.js` — the module the whole round-1 blocking fix rests on has no test of its own, and its expiry path never runs.**
Every test that exercises a timeout injects `fakeTimeLimit` (`fakes.js:60-68`) in place of `realTimeLimit`, and the fake re-implements the message text (`fakes.js:63` duplicates `deadline.js:11`). So the assertions at `export-run.test.js:272` and `freshness.test.js:99` are matching the *fake's* string. The real `realTimeLimit` runs only on its happy path (the frozen clocks in `freshness.test.js` and `wiring.test.js` never let it fire), and `makeLimiter`'s zero-budget branch (`deadline.js:21-24`) and `limitedBucket`'s label (`:33`) are asserted nowhere. If `realTimeLimit` failed to reject — a cleared-too-early timer, an `unref()` surprise — the budget would be inert in production and no suite would go red, and a healthy V-4 bootstrap wouldn't show it either. This is the same shape as round-1 Claude's should-fix 5, which was accepted and fixed. A ~15-line `tests/functions/vault/deadline.test.js` closes it: `realTimeLimit` rejects with its message after `ms` and resolves when the promise wins (both with a short real `ms`), `limit` throws "the run's budget is used up" at zero and swallows the call's own rejection, and `limitedBucket` labels with `bucket.name`.

### Nits

**2. `export-run.js:120` — the operation listing's gax deadline is computed once for every page.**
`callOptions()` is evaluated at the start of step 2, and `OperationsClient.listOperationsAsync` freezes it into one `CallSettings` (`google-gax/build/src/operationsClient.js:364-368`, spread per page at `paginationCalls/pageDescriptor.js:108`), so page 7's gRPC deadline is still "the time left when the listing began". The outer `limit('listing operations', listing.next())` bounds the wall clock, so nothing can overrun — the client-side deadline is just looser than the code reads as intending.

**3. `deadline.js:1-4` — the comment's "600 s" is only true of Storage.**
`@google-cloud/storage`'s default really is `totalTimeout: 600` s with `maxRetries: 3` (`storage.js:367, 373`), and those calls are the ones that could have carried a run past 1,800 s. The gax side never could: `CallSettings.merge` collapses `totalTimeoutMillis` to the method's own `timeout_millis` (`gax.js:176-180` with `operations_client_config.json`'s 60,000), so `getOperation` was already a single ~60 s attempt. Worth correcting so the next reader knows the wall-clock wrapper — not the gax `timeout` — is what does the work here. (Side effect of passing the full remainder: an early poll now holds one attempt open for ~1,400 s where it used to give up at 60 s. Harmless given the wrapper, but `Math.min(limit.left(), 90_000)` would keep the failure fast as well as bounded.)

**4. `export-run.test.js:290-299` doesn't cover the third call site.**
It wraps `exportDocuments` and `getOperation` to check `opts.timeout`; `listOperationsAsync` (`export-run.js:120`) is the one place not asserted. One more wrapper in the same test.

**5. `freshness.js:17-23` with `vault-config.js:30, 32` — 20 s covers up to 501 sequential listings.**
At the real folder count (~8–9, from the 56-day lifecycle on a weekly export) this is a second or two. If `weekly/` ever accumulated folders, `vaultFresh` would start answering 500 "error" — which the uptime check reads as not-fresh and emails about after 6 hours — while the vault is actually fine. A line in V12's residual risks rather than a code change.

**6. `export-run.js:149-151` — the trade behind `START_RESERVE_MS` isn't stated.**
Refusing to start means that if all four Scheduler attempts spend >1,200 s on the reads, the week gets no copy at all, where starting one with 200 s left would still have completed server-side and shown up as a complete folder for `vaultFresh` (the run throws either way). Not starting an export the run can't observe is the defensible choice — the comment just doesn't say it was a choice.

**7. The plan's V7 prose still describes the old budget** (`my-clay-hub-d4-vault-export.html:111`: "Waiting polls every 15 s with a budget of 1,500 s"). The Decisions-log entry at `:438` records the amendment, which is this repo's established pattern, so this is a note only.

---

**merge after fixes**
