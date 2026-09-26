## Verdict: READY

Read-only review of `git diff main` plus the untracked `e2e/day-off-teacher.spec.js`. `node --check` passes on all five changed/new JS files. The emulator suite was not run (read-only).

### Round-1 findings — all confirmed fixed

| # | Status |
|---|---|
| Codex 1 / photo pair | **Fixed.** `js/firebase-data.js:2653-2656` rejects one-sided payload, half-empty pair, one-sided clear, and value+clear of the same field; the empty pair is converted to a real delete of both. T9 drives all four refusals. |
| Codex 2 / TV semester switching | **Fixed.** `js/app.js:653-656` refreshes an already-built Teacher View when the year is (or was) SDOC; `:826-832` makes the TV selector call `setGlobalSemester` and sync the header. T20 covers header→SDOC, SDOC→weekly, the TV selector, and change-on-another-tab. |
| Codex 3 / Q&A panel | **Fixed.** `js/app.js:1266` clears and returns for SDOC; T21 pins it with a stray `qaThread`. |
| Codex 4 / F3 test gaps | **Fixed.** T14 now drives `sendTeacherQaMessage` / `sendHelpResponse` / `sendQaReply` (3 alerts, no `qaThread`, no `curriculum/lessonData` key); T18 failed-save-after-upload + retry; T19 sign-off byte-identity + tick interleavings; T5 photo removal vs replacement and same-user/same-millisecond. |
| F1 / two SDOC years | **Fixed.** `startSeq` at `firebase-data.js:2108`, protection at `:2126`, `healDayOffYearAfterReload` at `:2569`, called at `:1134`. |
| F2 / T12 vacuous | **Fixed.** T12 now fires a real `input` event and a scripted Save click, then waits 2600 ms. |
| F4 (teacher group), F8 (view-only CSS) | **Fixed** (`app.js:1616-1621`, `styles.css:7248`). |
| F5 | **Moot** — `app.js:1618` now clears the picker's SDOC names unconditionally, so the described symptom is gone. |
| F7 | **Moot** — the two readers no longer do the same thing (`readDayOffPlanForEditor` bumps the verified sequence; `readDayOffPlan` does not). |

### New findings — no HIGH or MEDIUM

I could not construct a path in the new code that loses or corrupts a plan, materials, ticks, the sign-off doc, `curriculum/lessonData`, or a summer lesson. Save-path checks I re-verified as sound: allow-lists across payload *and* clears, identity/`lastEditId` applied last, `editId` minted once, both `tx.get`s before `tx.set`, in-transaction `camp.teachers` re-check, `camp.yearKey` check, sign-off/no-plan title refusal, and the `curriculum/{year}/…` photo path (T10 exercises the real Storage rules).

**LOW — `healDayOffYearAfterReload` discards the whole year's merge** — `firebase-data.js:2569` → `rebuildDayOffSlots`. When any plan verifies during a reload's window, the rebuild replaces the entire slot map `mergeSummerReload` just built, dropping `keepMine` for *other* plans in that year. Only an unverified in-flight optimistic copy is affected; it reverts to the server copy in the list until its own save verifies, and no server state is touched. Fix if you want it tight: rebuild only the keys whose seq beat `startSeq`.

**LOW — a plain editor read is marked "verified"** — `readDayOffPlanForEditor` (`:2611`) calls `dayOffInstallVerified`, so a reload whose query result is *newer* than that read is discarded in its favour. Narrow (needs the query to execute server-side after the read) and self-heals next reload.

**LOW — the "no teacher yet" publish warning can silently not fire** — `app.js:4610` counts from `currentDayOffCamps[key]`; after a failed SDOC load that map can be empty, so `bare === 0` and the year publishes with no prompt.

**LOW — F6 only half-applied.** The Teacher View renderers use `sdocEsc`/`sdocEscA`, but the editor's SDOC `metaHtml` (`app.js:11486-11490`) still uses `escHtml` on `campName`, `projectTitle`, `eventLabel`, the dates and the placements. All are strings by construction today; the swap is free.

**Test follow-up (not blocking):** the two-SDOC-year ordering that F1 was about has no test — T16 exercises `heal` with one year only. A second `TEST_DATA_SAFETY_sdoc2` year, gating only its queries, would pin it.
