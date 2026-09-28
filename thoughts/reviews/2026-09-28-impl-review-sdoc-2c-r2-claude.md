# Verdict: **READY**

## Round-1 findings — all confirmed fixed

| Finding | Status |
|---|---|
| **MEDIUM** (both) `projectLinks` trusted as an array in `sdocAboutHtml` + `renderDayOffMaterialsCell` | Fixed — `js/app.js:11501` and `js/app.js:12925` guard with `typeof`/`Array.isArray`. T22 and D11 open both the teacher editor and the popup over `projectLinks: 'https://not-an-array.test'` + `projectDetails: {oops:1}` and assert no `pageerror`. |
| **MEDIUM** (codex) malformed fields bypass removal/rename + stale-baseline protection | Fixed — `dayOffPlanHasUserData` (`firebase-data.js:2037-2041`) counts any present non-empty value; the writer throws inside the transaction on a malformed stored shape (`:2786-2789`), so nothing is written. D11 asserts both, plus the field untouched after the refusal. |
| **HIGH** (claude) live `n/a` record orphaned, two items go dark | Resolved in data — verified in `tinker-backup-2026-09-28T17-58-11.json`: `Canvas` is on "Canvas Painting part 1", `Uniposcas` on part 2. Nothing user-visible vanishes. |
| **LOW** (codex) D5/D9/D10 names overstate coverage | Fixed — D5 is the hostile-render test, D9 defers Teacher View to T23 by name, D10 covers both directions. |
| **LOW 1–5** dead params · close-confirm lie · `SDOC_BLOCKS` comment · `savedSince` wording · unnamed long link | All fixed. `dayOffBlocksToFill` genuinely counts `n/a` as filled (D9: `empty === 1`). |
| Details errors colliding with materials `.sdoc-errors` | Fixed — own `#sdoc-details-errors`; popup waits are scoped to `#sdoc-materials-modal-body`. |
| **LOW 6** `#sdoc-details-vision` ID selector; two stacked `.simple-modal-body` | **Still open** — cosmetic, still wants one look in the real app. |

Re-confirmed: no remaining `=== '—'` SDOC comparisons (`app.js:4151` is summer's own rule, untouched); `dayOffRenamePairs` derives both sides from `dayOffCampTitles`, so `n/a` can never be a rename source or target — nothing moves onto or off it.

## New — both LOW, neither blocking

1. **The leftover `n/a` record won't surface as a discardable list.** With `n/a` filtered from `dayOffCampTitles` there's no Materials button, no checklist line, no summary contribution, and no orphan prompt (`leaving` filters it at `firebase-data.js:2439`). Its only appearance is `deleteDayOffCamp`'s refusal — that path queries by `campId` (`:2541`), so it refuses with *"It has projects with a plan or materials list: n/a"*, naming a title visible nowhere. So "Northern Lights Canvas Painting" can't be deleted from the app until that record is cleared out of band. Harmless today (data duplicated, not lost) — the data note just overstates the recovery path.
2. **Keystrokes during an in-flight save are discarded.** A successful save re-renders the textarea from the server doc; only the button is disabled, so text typed during the round-trip is lost and focus/caret moves. Same window the Done fix closed — disable the inputs too, or re-render only the status line.

`node --check` passes on both files. I did not run `npm test` (read-only brief) — it should be green before the deploy ask. Full write-up in the plan file.
