I've read Phase 2, both round-1 reviews, and verified every load-bearing claim against `4ba983d`, the Classbook, and the rules. Here is the round-2 confirmation.

---

## 1. Round-1 findings — did the revision resolve them?

**Codex (16).** ✅ = resolved; ⚠️ = partly, see my findings below.

| # | Claim | Verdict |
|---|---|---|
| C1 | `docId()` wrong season for past reads | ✅ `readDocId`/`writeDocId` split (plan:274,284), scenario plan:391 |
| C2 | `ref()` can't gate writes and serve reads | ✅ `readRef`/`writeRef` (plan:273,278) |
| C3 | `_current` listener not race-free | ✅ stated as an honest limit + rules-hardening recorded (plan:293, 406) |
| C4 | CSV import violates snapshot + non-overwrite | ⚠️ fixed except failure/resume → **L8** |
| C5 | e2e plan violates emulator-only | ⚠️ made a 2A prerequisite, mechanism unspecified → **M7, M8** |
| C6 | photo save order + Storage delete rule | ✅ deferred explicitly as a Phase 3 prerequisite (plan:325) — consistent, since the path change doesn't touch deletes |
| C7 | seven `doc.ref` writes, not six | ✅ `:12246` named (verified: `batch.update(doc.ref…)` at :12234, `docs[0].ref.update` at :12246) |
| C8 | structural-edit race + write method | ⚠️ `firstMadeCurrentAt` + `update()`-only, but 2026 is never frozen → **H1** |
| C9 | team classification/canonicalization | ⚠️ builder ✅, classifier contradicts itself → **M1** |
| C10 | optimistic cache lacks `season`; past-view create | ✅ plan:330 |
| C11 | Kid Notes filter leaves returning undefined | ✅ plan:332 + scenario plan:484 |
| C12 | `timeSlot` must store the key | ✅ plan:324 |
| C13 | topic duplicates + chained renames | ⚠️ 2027 ✅, 2026 branch unguarded → **M5** |
| C14 | `canEdit()` misses unconditional controls | ⚠️ inventory ✅, mechanism fails → **M3** |
| C15 | computed-ID rule too syntactic | ✅ inverted rule (plan:298) |
| C16 | 11 pages not all writers | ✅ reworded + hardening-doc update (plan:258) |

**Claude (30).** Resolved unless noted.

| # | Claim | Verdict |
|---|---|---|
| 1,2,6,7 | `ref()`/`stamp()` gating, `docId()` default, weekly-prep rule | ✅ all four |
| 3 | `teamMigratedAt` via viewing doc | ⚠️ `registryDoc('2026')` ✅, but no data source → **H2** |
| 4 | backfill `undefined` + legacy `studio` | ✅ plan:351 (canonical builder, `studio` included, throws on undefined) |
| 5 | seventh `doc.ref` write | ✅ |
| 8 | 4-digit season ID | ✅ plan:303 |
| 9 | `breaks` omitted from generator | ✅ plan:315 |
| 10 | generator parity can't pass | ⚠️ `note` dropped, week 11 still impossible → **M6** |
| 11,12 | returning card; badges on viewing | ✅ plan:332-333 + scenarios |
| 13 | `canEdit()` misses markup controls | ⚠️ 3 static named, 13 dynamic missed → **M3** |
| 14 | 2.0 removal range breaks `try` | ✅ verified :7683-7687 + :7692, `try { applySeasonLabels(); }` survives |
| 15 | `importTeachersFromSchedule` imports nobody | ✅ plan:356 + scenario plan:416 |
| 16 | rename under-specified | ⚠️ pre-edit name ✅, 2026 gap → **M5** |
| 17 | gating forecloses carry-forward | ⚠️ `{season}` hook ✅, unenforced → **L1** |
| 18 | straggler resolution = second write path | ✅ named exception (plan:311) + scenario plan:436 |
| 19 | e2e can't run / goes stale | ✅ moved to emulator |
| 20 | missing scenarios | ✅ all eight added (plan:391,389,424,408,412,420,428,432) |
| 21 | sessionStorage survives make-current | ✅ plan:292 |
| 22 | six root `.js` one-offs | ✅ seven named; all 7 + 11 pages verified present |
| 23 | prep-render location | ⚠️ location ✅, but four functions are dead, not two → **L4** |
| 24 | `runGuardedDestructiveWrite` kept | ✅ plan:257 |
| 25 | `backup.js` includes the registry | ✅ claimed verified (I can't read `~/tinker-backups` from here — unverified by me) |
| 26 | hard-coded studio lists | ✅ plan:304 |
| 27 | `importYear` loosening named | ✅ plan:311 |
| 28 | structure count includes cross-season keys | ✅ count dropped as the primary rule |
| 29 | cache-busters + deploy message | ✅ plan:380 (verified `season.js?v=2`/`app.js?v=52` at index.html:1759-1764) |
| 30 | weeklyPrep never read | ✅ plan:298 |

---

## 2 & 3. New findings

### HIGH

**1. Summer 2026's structure is never frozen — `firstMadeCurrentAt` cannot exist for it, and registry writes bypass the read-only chokepoint entirely.**
plan:317 keys the freeze on `firstMadeCurrentAt` being absent. That field is new in Phase 2, and 2026's registry doc was written in Phase 1: `season-migration.js:182-184` seeds only the seed fields + `createdAt/By/updatedAt/By`, and `switchOn` writes only `{season, setAt, setBy}` to `_current` (`season-migration.js:304`). So for 2026 the field is absent → **structure editable forever**. And nothing in 2.1 catches it: `summerCamps_seasons` is not in `COLLECTION_NAMES` (`js/season.js:29-47`), so no registry write can ever pass through `writeRef`.
*Failure:* 2027 is current, 2026 is "read-only". Christie opens Settings → Seasons → Edit Summer 2026 and changes the week count or a break. `Season.weekForDate()` (`season.js:357-384`) and all nine `weekStructure[w]` reads (`app.js:855, 1383, 1438, 3946, 13658, 14227, 14266, 14496, 14525`) now mis-map the season holding 5,365 records.
*Fix:* (a) define `structureFrozen(s) = !!registryDoc(s).firstMadeCurrentAt || s === Season.LEGACY_SEASON`, **and** write `firstMadeCurrentAt` onto `summerCamps_seasons/2026` as the first step of 2B (one admin action; `firestore.rules:774-776` already permits it). (b) State in 2.5 which registry edits are allowed for a *non-current* season (recommend: name only) and enforce it in the form, since `writeRef` can't. (c) Write `_current` and `firstMadeCurrentAt` in **one batch** — as specified they are two writes (plan:318), and `_current` landing alone leaves 2027 current with its structure still editable; both rules permit the batch (`firestore.rules:774-776` and `:790-794`, whose `exists()` reads pre-write state). (d) Scenario: "Given 2027 is current, When Christie opens Edit on Summer 2026, Then dates / week count / breaks / structure / studio removal are refused and only the name is editable."

**2. `Season.registryDoc()`, `teamMigrated()` and `seasons()` have no defined data source — `load()` reads at most two documents.**
plan:267-269 introduces all three; plan:353 makes `teamMigrated() = registryDoc('2026').teamMigratedAt` the switch between flat-field and `seasons[viewing]` mode for every Team read *and* write. But `js/season.js:198-236` reads exactly `_current` and the one season doc it names, and `state` holds a single `doc`; `seasonDoc()` is synchronous (`:251-260`) and every caller treats it so. The plan fixed *which* doc to read and left *when it is available* open.
*Failure:* implemented as a lazy/async read, `teamMigrated()` is `undefined` on first render → the Team tab renders and `saveTeamMember` writes in flat-field mode while 2027 is current, overwriting the frozen 2026 copy — the corruption round-1 #3 identified. (Credit where due: the scenario at plan:408 *would* catch the worst outcome if written exactly as stated.)
*Fix:* say in 2.1 that `load()` does one forced-server `get()` of the whole `summerCamps_seasons` collection — it holds a handful of docs and the read rule already permits listing, which is exactly what the Classbook does at `tinker-spring-curriculum/js/firebase-data.js:369-380` — keeps an `{ [id]: data }` map in `state`, and serves `seasons()`, `doc()`, `registryDoc(id)` and `teamMigrated()` synchronously from it. Add `season.emulator` cases: `registryDoc('2026').teamMigratedAt` readable while viewing 2027; `teamMigrated()` is `false` (not `undefined`) in legacy mode and when the field is absent.

### MEDIUM

**3. 2.8 contradicts itself on the backfill classifier.** plan:351 says "for each team doc **without `seasons.2026`** (not 'without `seasons`' — review)". plan:352 then says "updates only for docs missing `seasons`", and the scenario at plan:470 says "only docs without `seasons` are touched". A partial implementation follows the executable bits and strands any doc with a `seasons` map lacking `2026` — the exact case round-1 raised. *Fix:* change plan:352 and plan:470 to `seasons.2026`.

**4. `writeRef`'s gate is undefined for the three SHARED collections, and the app's team/stockItems writers never used `Season.ref()`.**
`season.js:68` — `SHARED_KEYS = ['summerCampsTeam','summerCampsStockItems','summerCampsSettings']`. plan:278-280 specifies only "per-season key" and "cross-season keys". Meanwhile `app.js:5940, 5944, 5961, 6194` (team) and `app.js:3007, 3052, 3071` (stock items) write via raw `db.collection(COLLECTIONS.…)`, already allow-listed as `NOT_PER_SEASON_WRITERS` in `test/season-completeness.test.js:46-53`.
Two consequences: (a) 2.1's new rule "writes must come from `writeRef`" is red on seven live sites with no stated path to green — so it gets weakened ad hoc during implementation; (b) nobody has decided whether **stock items** are editable from a past-season view. They are studio facts, not summer facts — but plan:388 asserts "no edit control on … Materials", and stock-item editing lives there (`app.js:2867-3071`). *Fix:* decide per shared key — team gated (via its three writers' own `isViewingCurrent()` checks, plus one emulator test per writer, because the completeness check cannot see them); stockItems/settings not gated — and name the allow-list entries. Add a stock-items-in-a-2026-view scenario.

**5. The `body.season-read-only` + `[data-requires-writable]` mechanism can't hide three of the controls it must hide, and the inventory misses 13 more.**
plan:291's three static class-gated controls check out (`index.html:72, :133, :1658`). But `app.js` renders `.admin-manager-only` **13** more times, three with an inline `style="display: flex"` (`app.js:10080, 12345, 12388`) — a class-scoped `display:none` loses to an inline `display:flex`. And "applied after `applyRoleRestrictions()`" (`auth.js:137-152`, which runs once at sign-in) describes a one-time DOM sweep, while these tables re-render on every tab switch and after every save. *Fix:* specify a stylesheet rule with `!important` (`body.season-read-only .admin-manager-only, body.season-read-only [data-requires-writable] { display: none !important }`) — stateless, so it survives re-renders — add the 13 `app.js` sites to the inventory, and keep the handler-entry `canEdit()` check as the real guard.

**6. `projectLibrary` becomes a computed-ID collection but is not added to `COMPUTED_ID_KEYS`, and 2.2 still says "five".**
plan:323 gives topic docs `writeDocId('topic|||' + name)` and calls it "a sixth computed-ID collection"; plan:298 writes the completeness rule against "the five"; `season.js:79-85` lists five without `summerCampsProjects`; and `season-migration.js:95` keys the "ID agrees with season" check off `Season.COMPUTED_ID_KEYS`. *Fix:* state that `summerCampsProjects` joins `COMPUTED_ID_KEYS` (safe — existing 2026 sheet IDs parse as 2026 via `season.js:343-347`), that 2.2's rule covers six collections, and that the migration classifier follows.

**7. Camps created while 2026 is current get no uniqueness lock, and rename then can't find the old topic doc.**
plan:323 restricts the deterministic ID to "non-2026 seasons", but 2B ships while 2026 is still current (plan:377-378 — 2027 is created and made current *after*). So on day one of 2B every "+ Add New Camp" takes the 2026 branch: auto-ID, no transaction, no uniqueness — and a later rename tries to delete `writeDocId('topic|||' + preEditName)`, which was never created, leaving the stale entry in Lesson Plans (`app.js:2745-2747`) and the Materials dropdown (`app.js:11162`) forever. That is round-1 C13/#16 un-fixed for 2026. *Fix:* use the deterministic ID for **every** season (`writeDocId('topic|||x')` returns the bare `topic|||x` for 2026 — `season.js:336-340` — which cannot collide with the sheet IDs already there), and on rename fall back to `where('name','==',preEditName)` within the season when the deterministic doc is absent. Mirror the plan:428 scenario for a camp created while 2026 is current.

**8. The generator parity test still cannot pass: no listed input describes 2026's short final week.**
plan:315's inputs are year, name, first camp day, week count, break weeks, single days off; plan:462 asserts `endDate` and every week's `numDays`/`daysActive`/`dateRange`. The stored doc has `endDate: '2026-08-11'` and week 11 `{ numDays: 2, daysActive: ['Monday','Tuesday'], dateRange: 'Aug 10–11' }` (`js/config.js:69, 104`) — but week 11's Monday is Aug 10 and its Friday is Aug 14, so those six inputs yield a 5-day week 11 ending Aug 14. Separately, weeks 2–10 carry **no** `daysOff` and no `daysActive` key at all (`config.js:95-103`), so the comparison must treat absent and `[]` as equal or it fails on nine weeks. *Fix:* add "last camp day" (or final-week length) to the inputs, and state the absent-vs-empty rule — otherwise this test gets "fixed" by hard-coding 2026.

**9. 2.9 doesn't say where the emulator switch lives or how it's proven never to fire in production.**
`js/config.js:12-16` initializes Firebase and `db` unconditionally with no emulator branch; `playwright.config.js` serves local files while `e2e/helpers/login.js` signs in with **production** `.env.test` credentials; `AGENTS.md:26-27` requires the emulator. So the harness has to add a `useEmulator()` branch to shipped code, ordered before `Season.load()` (which runs in the auth bootstrap), and the fixtures need per-role users where there is one account today. *Fix:* name the switch (hostname in `localhost`/`127.0.0.1` **and** an explicit flag), add a test asserting the deployed origin cannot enter emulator mode, say the login helper becomes role-parameterized (plan:384 needs four roles), and drop or qualify "the existing 33 tests move over unchanged".

**10. The cross-app "new 2027 session lands in the right Classbook slot" test has nowhere to live.** plan:324 and plan:370 put it in this repo's e2e run, but the Classbook is a separate app (`/Users/christiehubley/tinker-spring-curriculum`) this harness doesn't serve. *Fix:* state either that it is a pure test in this repo against the Classbook's normalizer/loader contract, or a test added in the Classbook repo against the same seeded emulator — and which.

**11. "Every unstamped auto-ID doc becomes 'needs a choice'" retires the automatic sweep where stragglers actually come from.**
plan:311 is blanket. But `expectedSeason()` is already deterministic for the computed-ID collections via `parseDocId` (`season-migration.js:91-97`) and for kid notes via `importYear` (`:82-87`) — and the computed-ID collections are exactly where stale-tab writes land (the Classbook writes `lessonData`/`campComplete`/`prepHelpQueue`). Phase 1's own accepted limitation is that "`saveMaterials` merges against a filtered read, so an unstamped straggler with the same key duplicates until the sweep catches it"; if the sweep can no longer act automatically, those duplicates persist until someone opens Settings. *Fix:* keep the automatic stamp where the answer is deterministic, restrict "needs a choice" to unstamped **auto-ID** docs, and say how a pending choice is surfaced at sign-in (`autoSweepStragglers`, `app.js:4403`, is silent today).

**12. `.env.test` holds production credentials and sits in the Netlify publish directory.**
`.netlify/netlify.toml` → `publish = "/Users/christiehubley/summer-camp-app"`; `.env.test` exists at that root; `.gitignore:34` ignores it, so it is absent from git but present on disk — and `netlify deploy` uploads what is on disk. 2.0's entire rationale is "at the repo root and therefore deployed with the app"; this file is a credential, so it belongs in that reasoning. *Fix:* check first (`curl -sI https://tinker-in-house-summer-camp-app.netlify.app/.env.test`); regardless, add a deny header/redirect or move to a build-output publish dir, and make 2.9's emulator move end with `.env.test` deleted and that account's password rotated. Audit the other root files the publish dir ships (`playwright.config.js`, `AGENTS.md`, `CLAUDE.md`, five review `.md` files, `e2e/`, `test/`).

### LOW

**13. The `{ season }` escape hatch ships in 2A unenforced.** plan:278-283 makes `writeRef(key, {season})` the Phase 3 hook and says it "may only CREATE", with no mechanism. The gate compares the *parameter* to `current()`, not the document — so `writeRef(key, {season: current()}).doc(<2026 id>).update(…)` from a 2026 view passes. *Fix:* statically allow-list the opts form the way `Season.raw()` is (`test/season-completeness.test.js:61`, `RAW_ALLOWED`, empty today) so Phase 2 provably has zero call sites.

**14. `currentMoved` is sticky, so the revert scenario can't pass in the tab that watched the flip.** plan:293 vs plan:420-422. Sticky is the safer behaviour given the caches at `app.js:5330-5344` — just say the revert is asserted after a reload.

**15. Cross-season note *creation* is gated only in the UI.** plan:294/330 offer Add/CSV only in the current view, but `writeRef` never gates those keys (plan:280), so nothing refuses a stale handler. Give the two create handlers an entry-point `isViewingCurrent()` assertion, like Team's writers get (plan:356).

**16. Four dead prep functions, not two — and `prepStatus` is read only by dead code.** plan:257 removes `showEmptyPrepState` (`:8994`) and `renderPrepOverview` (`:9010`). `renderPrepTeacherProgress` (`:9091`) has no callers at all, and `renderPrepCampsList` (`:9150`) is called only from inside `renderPrepOverview` (`:9079`). All five `prepStatus` reads (`:9023, 9033, 9119, 9167, 9187`) live inside those four. *Fix:* delete all four; then either drop `prepStatus` from 2.6's payload (plan:323) or say it's shape parity with the retired `parseTopicsData` (`app.js:8456`). (The rest of 2.6's topic payload is right — Lesson Plans reads only `name` and `ageRange`, `app.js:9307-9360`.)

**17. The scenario at plan:399-401 still names the retired helpers.** "When: the write reaches `Season.ref()`/`Season.stamp()`" — `ref()` is retired (plan:288) and `stamp()` is deliberately ungated (plan:285). A partial implementation following this scenario puts the gate back in `stamp()` and re-breaks Kid Notes in every past season. → "reaches `Season.writeRef()`".

**18. The card's year badge is a second `importYear` reader 2.7 doesn't mention.** `app.js:6647` renders `note.importYear` as a badge; CSV-imported and hand-added notes never set it (`app.js:7097`), so under an "All" view 2027 notes would show no year while old spreadsheet ones do. Name it and switch it to `season`.

**19. The CSV import still has no failure/resume story** (Codex's round-1 ask). plan:334 has the snapshot, preview, non-empty patching and bounded awaited batches, but not what happens when batch 3 of 5 throws. At 18 notes the blast radius is small — one sentence closes it.

**20. Line-reference drift.** `Season.ref(` has **66** call sites, not "~79" (plan:288). Open Studio's third site is `:14139`, not `:14140` (plan:298). `studios.includes` is `:3922` not `:3921`; `studioCapacities[studio]` is `:7488` not `:7489` (plan:304). `loadWeeklyPrepIndex`'s early return is `:734-741`, not `:723-730` (plan:305). Everything else I spot-checked is exact: `:7683-7687` + `:7692` with the `try` surviving; `:13623`'s clamp; `:12234`/`:12246`; `:10962-10963`; `:8994`/`:9010`; `index.html:72/133/1658`; `index.html:1759-1764`; storage `:12852`/`:12864`; all 11 pages and 7 root scripts present; `~42` role checks (43 occurrences). Tell the implementer to re-grep rather than trust the numbers.

### What would let a partial implementation pass the current scenario set

No scenario protects a past season's **registry** (#1); none covers **shared-collection** editing in a past view (#4); none covers a camp **created or renamed while 2026 is current** (#7); none asserts the emulator switch **cannot engage on the production origin** (#9); plan:365 tests that the sweep *runs* with `_current = 2027` but not that it still **stamps** anything (#11); and 2.9's "red on the live code" for the `writeRef` rule is ambiguous about the seven team/stockItems sites until #4 is decided.

---

**Verdict: not execution-ready — the design is right in shape and round 1 landed almost everywhere, but findings 1 and 2 are unanswered design questions (a past season's structure is unprotected; the switch that guards the one data backfill has no defined data source), and 3–8 are text fixes that a partial implementation would otherwise resolve the wrong way.**
