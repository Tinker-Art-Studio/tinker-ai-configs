# Implementation review ROUND 2 (confirmation) — Classbook SDOC Phase 2C

Read-only. Target: `git diff 44a5159` on `sdoc-2c-project-details` (08af635 + uncommitted fixes).
Verified: `node --check` on both JS files passes. `npm test` not run (read-only brief) — the suite must be
green before the deploy ask.

## Verdict: READY

## Round-1 findings — all confirmed fixed

| Round-1 finding | Status |
|---|---|
| **MEDIUM** (both reviewers) `projectLinks` trusted as an array in `sdocAboutHtml` + `renderDayOffMaterialsCell` | Fixed — `js/app.js:11501-11502` (`typeof … === 'string'` / `Array.isArray`) and `js/app.js:12925` (`hasDetails` guards both). T22 and D11 open the teacher editor and the popup over `projectLinks: 'https://not-an-array.test'` + `projectDetails: {oops:1}` and assert no `pageerror`. |
| **MEDIUM** (codex) malformed fields bypass removal/rename protection and the stale-baseline check | Fixed — `dayOffPlanHasUserData` (`js/firebase-data.js:2037-2041`) counts any present non-empty value, malformed included; `saveDayOffProjectDetails` (`js/firebase-data.js:2786-2789`) throws `DayOffValidationError` on a malformed stored shape *inside* the transaction, so nothing is written. D11 asserts both plus `projectLinks` still `'https://not-an-array.test'` after the refusal. |
| **HIGH** (claude) live `n/a` record orphaned; two material items go dark | Resolved in data, verified against `~/tinker-backups/tinker-backup-2026-09-28T17-58-11.json`: camp `fvrhezgd8AwIWk0N4xbD` now has `Canvas` on "Canvas Painting part 1" and `Uniposcas` on part 2. Nothing user-visible vanishes on deploy. |
| **LOW** (codex) test names overstate coverage (D5/D9/D10) | Fixed — D5 is now the hostile-stored-values render test; D9's name defers Teacher View to T23; D10 covers both directions (`n/a` → real title asserts nothing moved, stray record untouched). |
| **LOW 1** dead `error` / `keepTyped` params | Fixed — `renderDayOffDetailsSection(plan, { status })` only. |
| **LOW 2** close-confirm can lie during a save | Fixed — `closeDayOffMaterials` returns with "Still saving the details" while `dayOffDetailsSaving`. |
| **LOW 3** stale `SDOC_BLOCKS` comment | Fixed at both sites (`js/firebase-data.js:1888`, `:1913`); `dayOffBlocksToFill` genuinely counts `n/a` as filled (D9 asserts `empty === 1`). |
| **LOW 4** `savedSince` wording | Fixed — "showing their version". |
| **LOW 5** `'A link is too long.'` unnamed | Fixed — quotes the first 60 chars. |
| Details error box colliding with the materials `.sdoc-errors` | Fixed — own `#sdoc-details-errors` / `.sdoc-details-errors`; D2 and D11 target it, and D-popup waits are scoped to `#sdoc-materials-modal-body`. |
| New tests D8 / D10 / D11 / T22 / T23 | All present and assert what their names claim. |
| **LOW 6** `#sdoc-details-vision` ID selector; two stacked `.simple-modal-body` (20px padding each) | **Still open** — cosmetic, still wants one look in the real app. |

Also re-confirmed unchanged from round 1: no remaining `=== '—'` SDOC comparisons (`js/app.js:4151` is
summer's own rule, untouched); `dayOffRenamePairs` (`js/firebase-data.js:2517-2518`) derives both sides from
`dayOffCampTitles`, so `n/a` is never a rename `from` or `to` — nothing can be moved onto or off it.

## New — both LOW, neither blocking

1. **The leftover `n/a` record does not surface as a discardable list.** With `n/a` filtered out of
   `dayOffCampTitles`, there is no Materials button, no event-checklist line, no camp-summary contribution
   and no orphan prompt (`leaving` at `js/firebase-data.js:2439` filters it too). Its only appearance is
   `deleteDayOffCamp`'s refusal — that path queries by `campId` (`js/firebase-data.js:2541`), so it sees the
   record and refuses with *"It has projects with a plan or materials list: n/a"*, naming a title that
   appears nowhere in the UI. Consequence: "Northern Lights Canvas Painting" can't be deleted from the app
   until that record is cleared out of band. Harmless today (data is duplicated, not lost) — the data note
   just overstates the recovery path.
2. **Keystrokes during an in-flight details save are discarded.** A successful save calls
   `renderDayOffDetailsSection(saved, { status })`, rebuilding the textarea from the server doc. Only the
   button is disabled, not the textarea, so anything typed during the round-trip is lost and focus/caret
   moves. Same window the Done fix closed; worth disabling the textarea + link inputs too, or re-rendering
   only the status line.

## Before the deploy ask

- `npm test` green (emulator suite; count grows over time — read the printed number).
- No `firestore.rules` change in this diff, so no rules deploy is implied.
