I read Phase 2 in full (plan:240–535), both round-2 reviews, and re-verified the load-bearing claims against `4ba983d`, the Classbook, and the rules.

## 1. Round-2 findings vs. the revised text

| # | Round-2 claim | Status in the revised Phase 2 |
|---|---|---|
| Codex 1 | `firstMadeCurrentAt` freeze unreliable | Resolved — marker dropped; structure fixed **at creation** for every season (plan:327) |
| Codex 2 | Ungated cross-season `writeRef` → stale creates | Resolved — `assertCanCreate()` at handler entry + re-checked per CSV batch (plan:290, 304, 344) |
| Codex 3 | Two backfill eligibility rules | Resolved — one selector `missing seasons.2026` in dry run, batches, resume, tests (plan:362-363, 506) |
| Codex 4 | Photo data-loss deferred while 2027 opens | Resolved as stated — add/remove disabled outside 2026 (plan:335) — but see finding 5 |
| Codex 5 | CSV partial-batch contract | Resolved — preallocated IDs, manifest, idempotent retry, injected-failure test (plan:344, 379) |
| Codex 6 | Topic IDs: no 2026 contract, unsafe rename | Resolved in text — deterministic ID in every season, encode/SHA-1, same-key in-place, name fallback (plan:333) — but see finding 2 |
| Codex 7 | Session duplicate race | Accepted named limit (plan:334) — not re-raised |
| Codex 8 | Untested write paths + production screenshots | Resolved — plan:380 enumerates every new write path red-first; screenshots now from the seeded emulator (plan:388) |
| Claude 1 | 2026 never frozen | Resolved — same as Codex 1 |
| Claude 2 | `registryDoc`/`teamMigrated`/`seasons` no data source | Resolved — whole-collection forced-server load, synchronous map, `teamMigrated()` false not undefined (plan:293) — but see finding 3 |
| Claude 3 | 2.8 classifier contradiction | Resolved (plan:362-363, 506) |
| Claude 4 | Shared-key gating undefined | Resolved in principle — team gated at entry, stockItems/settings not (plan:294) — but see finding 1 |
| Claude 5 | CSS mechanism + 13 missed sites | **Partly** — `!important` rule + 13 `app.js` sites added (plan:301), but the selector is wrong and the static inventory is 3 of 8 → finding 1 |
| Claude 6 | `projectLibrary` not a computed-ID key | Resolved — sixth key, migration classifier follows (plan:308) |
| Claude 7 | No 2026 uniqueness lock | **Partly** — deterministic ID now in every season, but the lock misses pre-existing sheet-ID topics → finding 2 |
| Claude 8 | Generator parity impossible | Resolved — "last camp day" input; absent ≡ `[]`; notes not asserted (plan:325) |
| Claude 9 | Emulator switch location/proof | Resolved — hostname **and** flag, decided in `config.js` before `Season.load()`, scenario plan:460 |
| Claude 10 | Cross-app slot test has nowhere to live | Resolved in 2.6 (contract test here, cross-app test in Phase 4) — leftover wording at plan:382, see contradictions |
| Claude 11 | "Needs a choice" retires the sweep | Resolved — deterministic stragglers still auto-stamped; only auto-ID asks (plan:321, 464-466) |
| Claude 12 | `.env.test` in publish dir | Resolved — 404 verified (dotfiles skipped) + `dist/` allow-list + delete/rotate (plan:259, 373) |
| Claude 13 | `{ season }` unenforced | Resolved — allow-listed by file+function like `RAW_ALLOWED`, empty in Phase 2 (plan:295) |
| Claude 14 | Sticky `currentMoved` vs revert | Resolved — every post-switch assertion is after a reload (plan:302) |
| Claude 15 | Note creation gated only in UI | Resolved — `assertCanCreate()` (plan:304) |
| Claude 16 | Four dead prep functions | Resolved (plan:260) |
| Claude 17 | Scenario names retired helpers | Resolved (plan:412) |
| Claude 18 | Card year badge on `importYear` | Resolved (plan:345) |
| Claude 19 | CSV failure/resume | Resolved (plan:344) |
| Claude 20 | Line drift | **Partly** — header says re-grep and cites 66, but plan:298 still says "~79"; cited numbers at :308/:314/:315 unchanged |

## 2 & 3. Findings

**1. HIGH — the read-only CSS rule hides two whole tabs and the shared stock-item controls.** plan:301 specifies `body.season-read-only .admin-manager-only, body.season-read-only [data-requires-writable] { display: none !important }`. `.admin-manager-only` is a **role** class, not a per-season-writability class, and it is on whole tabs: `index.html:58` / `:541` (Notes for Next Year button + `<main>`), `:59` / `:784` (Staff Days Off), plus `:465` `#add-stock-item-btn` and `app.js:3764` `.add-suggested-stock`. In a 2026 view this hides the entire Notes for Next Year tab — contradicting the acceptance sentence at plan:246 and scenario plan:399-401 ("existing Kid Notes and Notes for Next Year remain editable") — and the stock-item controls, contradicting plan:294 and scenario plan:452. `!important` beats the tab-switch code that sets inline `display`, so nothing can undo it. **Fix:** drop `.admin-manager-only` from the selector — `body.season-read-only [data-requires-writable] { display: none !important }` alone — and put the attribute on the 13 `app.js` sites and the three per-season static controls (`index.html:72, :133, :1658`); correct the static inventory (8 `.admin-manager-only` sites, not 3) and note that stock items live on the **Stock Totals** tab (`index.html:56, :427`), not Materials.

**2. HIGH — the topic uniqueness lock does not cover 2026's existing camps.** plan:333 claims names are unique per season "in every season, 2026 included", with the deterministic topic doc as the lock, and notes the 2026 ID "cannot collide with the sheet IDs already there." That non-collision is the hole: every existing 2026 topic (written by the `saveTopics` importer, `app.js:8738`, removed in 2.0) has a sheet ID, so `topic|||<key>` never exists for it and a new camp duplicating an imported 2026 camp name is created without refusal — two entries in Lesson Plans (`app.js:2714`) and the Materials dropdown (`app.js:11162`), two curriculum docs sharing a `campTopic`, and colliding `teacher|||camp|||block|||project` keys in the Classbook. Scenario plan:456 only covers a camp created through the new path. **Fix:** before the transaction, run the normalized `where('name','==', …)` within-season query the rename path already specifies and refuse on any match (client transactions can't run queries, so it has to be the pre-check; the in-transaction ID read still catches concurrent creates). Add a scenario: "a new camp named the same as an imported 2026 camp is refused."

**3. MEDIUM — the whole-registry `load()` never says what to do with `_current`.** plan:293 keeps `{ [id]: data }` for the whole collection and serves `seasons()` from it; `_current` lives in that same collection (`firestore.rules:785-794`) and has neither a 4-digit ID nor a week structure. plan:313 has `load()` validate a season doc and refuse an ID that isn't `/^\d{4}$/`, and plan:302 shows the switcher "only when more than one season is registered". Read literally: the switcher appears with one season registered, and validation red-banners every user at startup. **Fix:** one line — the season map holds only `/^\d{4}$/` docs, `_current` is taken from the same snapshot but kept separately, and validation runs on the viewing season's doc only.

**4. MEDIUM — after a season has been current, its structure can never be corrected and it can never be deleted.** plan:327 freezes structure at creation for every season and offers "Delete this season" only while `wasCurrentAt` is unset. A wrong last camp day or week count — a brand-new input added in round 2 (plan:325) — discovered after "Make 2027 current" has no in-app repair: edit refused, delete refused, and no out-of-band procedure is stated. The delete rule already accepts the doc-count race ("deletion leaves any document stamped with that season unregistered, which the scan lists as invalid by name"), so `wasCurrentAt` is a stricter gate than the risk warrants. **Fix:** offer delete for any season that is **not current**, showing a forced-server count of documents stamped with it (zero = clean; non-zero named in the dialog); keep `wasCurrentAt` as the warning, not the gate. Add one line to the make-current confirmation: "the week structure is permanent from here."

**5. MEDIUM — photos become un-editable everywhere the moment 2027 is current.** plan:335 disables photo add/remove outside 2026; make-current makes 2026 read-only. From that moment until Phase 3 ships, no project photo can be added or removed in any season — against plan:246's "2027 is where every edit goes". The unsafe path is deletion (`app.js:12860-12865`, `:13031-13072`) and the cross-season URL sharing that only carry-forward creates; neither applies to a photo **added** to a fresh 2027 project. **Fix:** allow adding in the current season (upload → Firestore, no delete branch), keep removal disabled until Phase 3 — or state plainly in 2.6/Q-section that photos are frozen until Phase 3, so Christie decides.

**6. MEDIUM — the `dist/` deploy collides with the standing deploy rule.** plan:259 makes the deploy `netlify deploy --prod --dir dist`, but plan:392's ritual has no build step and still requires "deploy from a clean, pushed tree with `--message "$(git rev-parse HEAD)"`". `dist/` is not in `.gitignore`, so building it dirties the tree and fails the clean-tree precondition; gitignoring it means the deployed bytes are not the bytes of the commit the message names. **Fix:** add `dist/` to `.gitignore` and make the ritual "clean+pushed check → `scripts/build-dist.sh` (a pure copy from the working tree) → deploy → live-bytes check against the committed sources."

**7. LOW — `js/config.js` ships with no cache-buster.** `index.html:1756` is `src="js/config.js"` with no `?v=`, yet 2A changes it twice (sheet config removal, plan:257; the emulator switch, plan:373). plan:392 says to bump "every changed `js/` file (`index.html:1759-1764`)" — a range that excludes it. **Fix:** give `config.js` a `?v=` and cite `:1756-1764`.

**8. LOW — nothing statically keeps future cross-season creates behind `assertCanCreate()`.** The completeness check enforces writes-through-`writeRef` (plan:298), but `writeRef` is deliberately ungated for kidNotes/notesNextYear (plan:283), so the guard lives only in three hand-written handlers plus their tests. **Fix:** allow-list `.add(`/`.set(` on the two cross-season keys by file+function, the way `{ season }` and `Season.raw()` are (plan:295), so a new create site is red until reviewed.

**Internal contradictions left in the text**
- plan:298 "`Season.ref()` … ~79 call sites" vs plan:242 "66 call sites" — actual count is 66 in `js/app.js` (70 incl. tests). Fix :298.
- plan:294 and scenario plan:452 place stock items on Materials; they are on Stock Totals (`index.html:56, :427, :461-484`). And plan:382's sweep bullet omits the stock-items exclusion plan:294 promises "a scenario says so."
- plan:334 moves the full cross-app slot check to a Classbook-repo test in Phase 4; plan:382 still lists "the Classbook-slot scenario for a new session runs against the same emulator data."
- plan:344: "a retry re-plans from the server" vs "an allocated create ID that already exists is skipped" — if it re-plans, the manifest IDs are not reused and that clause is dead; idempotency comes from the name+camp+week de-dup. Say which.
- plan:290 `assertCanCreate()` = "`isViewingCurrent() && !currentMoved`" duplicates the `!currentMoved` already inside `isViewingCurrent()` (plan:268).

execution-ready for Christie's go — no
