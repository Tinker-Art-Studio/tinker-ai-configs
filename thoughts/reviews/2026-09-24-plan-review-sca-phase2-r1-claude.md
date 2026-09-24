I've read the Phase 2 section in full and checked its load-bearing claims against the code at `4ba983d`, the Classbook at `b2bbaac`-era production bytes, and `firestore.rules`. Findings below.

---

## HIGH

**1. `Season.ref()` gating on `isWritable()` breaks eight *read* paths in a read-only season — including the entire Open Studio tab.**

2.1 defines `Season.ref(key)` as "throws `SeasonReadOnlyError` unless `isWritable()`". But `ref()` is not a write-only helper today: eight call sites use it for `.get()`.

Evidence: `js/app.js:13675-13676` (`Season.ref('summerCampsOpenStudio').doc(\`week_${week}\`)` then `await docRef.get()` — this is `loadOpenStudioWeek`, the whole tab's data load), `:11206-11207`, `:11269`, `:11560`, `:11708` (materials detail/edit reads), `:12766`, `:12780` (copy-curriculum source/dest reads), `:12910` (project-details read). `js/season.js:292-295` shows `ref()` today is a plain `CollectionReference` with no gate.

Viewing Summer 2026 with 2027 current would throw on every one of these — Open Studio blank, materials modal dead, copy-camp dead. That is the exact class of bug the Sep 23 log entry describes.

Fix: gate the *write*, not the reference. Either (a) `Season.ref(key)` stays ungated and `Season.stamp()`/a new `Season.patch()` gate plus a completeness rule "`.set(`/`.update(`/`.delete(`/`.add(` on a per-season ref must be inside a `canEdit()` branch", or (b) split into `Season.readRef(key)` (ungated, viewing-scoped) and `Season.writeRef(key)` (gated), and say in 2.1 which of the ~79 `Season.ref(` sites becomes which. Add a scenario (see #20).

---

**2. `Season.stamp()` gating on `isWritable()` breaks Kid Notes and Notes for Next Year in every past season — contradicting the plan's own acceptance line.**

2.1: "`Season.stamp(p)` // stamps `current()` — and throws unless `isWritable()`", with the exemption expressed only on `ref()` ("cross-season keys … never gated"). `stamp()` takes no collection key (`js/season.js:307-319`), so it cannot know the write is a kid note.

Evidence: every cross-season create goes through it — `js/app.js:6938` (`Season.ref('summerCampsKidNotes').add(Season.stamp(doc))`), `:7098` (CSV import), `:6350` (`summerCampsNotesNextYear` add). The acceptance paragraph and 2.7 both promise "Kid Notes and Notes for Next Year stay editable in every season."

Fix: give `stamp()` the key — `Season.stamp(key, payload)` or `Season.stamp(payload, { key })` — and skip the gate for `ALL_SEASONS_KEYS`. Note the signature change touches every existing `stamp()` call site, which belongs in 2A's scope, not 2B's.

---

**3. `teamMigratedAt` is written to `summerCamps_seasons/2026` but read through `Season.doc()`, which 2.1 redefines as the *viewing* season's document.**

2.8: "Completion is recorded as `teamMigratedAt` on `summerCamps_seasons/2026` — the switch the app reads" and "until `teamMigratedAt` exists the Team tab behaves exactly as today (flat fields)". 2.1: "`Season.doc()` // the VIEWING season's registry doc".

Consequence: viewing 2027, `Season.doc().teamMigratedAt` is `undefined` → the Team tab silently drops back to flat-field mode → `saveTeamMember` writes 2027 role/weeks/studios into the *flat* fields that 2.8 declares frozen. That overwrites the frozen 2026 copy — the one thing the additive design exists to protect — and the Ticker's `summer-camp-sync.html:338` then reads 2027 data believing it is 2026.

Fix: the switch must not be season-scoped. Put it on `summerCamps_seasons/_current` (or expose `Season.teamMigrated()` that reads the `2026` doc explicitly, independent of viewing), and add a scenario: "Given the backfill has run and 2027 is current and viewed, When Christie edits a person, Then only `seasons.2027` changes and every flat field is byte-identical."

---

**4. The team backfill as specified writes `undefined` for absent flat fields, and silently drops the legacy `studio` field.**

2.8: "one `update({ 'seasons.2026': { …its flat per-season fields… } })`". This write bypasses `Season.stamp()` (team is shared), so there is no sanitizer — and `firebase.firestore()` here has never set `ignoreUndefinedProperties`, so a nested `undefined` fails the whole batch with `invalid-argument`.

Evidence: `js/app.js:6194-6212` — `importTeachersFromSchedule` creates team docs with `name, role, studios, hireStatus, weeks, scheduleDays, scheduleStart, scheduleEnd, notes, createdAt/By, updatedAt/By` and **no `scheduleGroups`, no `additionalRoles`**. Any such doc never subsequently edited through `saveTeamMember` (`:5924-5936`, which always writes all nine) has holes. A naive nine-field copy therefore wedges the migration at that document, with no in-app way past it.

Separately, the `seasons['2026']` shape in 2.8 omits `studio` (the legacy singular), listing it only among the frozen flat fields — but `js/app.js:5474` still reads it as a fallback (`m.studios || (m.studio ? (m.studio === 'Both' ? ['Tinker','Clay Hub'] : [m.studio]) : [])`). After the switch those people lose their studio in the roster filter.

Fix: build the entry from the keys actually present (`for (const f of PER_SEASON_TEAM_FIELDS) if (f in data) entry[f] = data[f]`), include `studio` in the per-season field list, and state that verify's "deep-equal" treats an absent flat field as an absent `seasons.2026` key. Add the emulator case: "a doc created by `importTeachersFromSchedule` (no `scheduleGroups`/`additionalRoles`) backfills without error."

---

## MEDIUM

**5. There are seven snapshot-`doc.ref` write sites, not six.**

2.1 lists `10368, 10394, 10661, 10901, 11021, 12234`. The seventh is `js/app.js:12246` — `await currSnap.docs[0].ref.update(Season.patch({ publishedToClassbook: true, publishedToClassbookAt: now }))` in `publishCampToClassbook`, on `summerCamps_curriculum`. I ran the exhaustive pattern (`\.ref\.(set|update|delete)` plus `batch.*(x.ref`) over `js/*.js`; those seven are the complete set and there are no transactions outside `season-migration.js`.

The proposed new completeness rule would catch it, but the plan's count is quoted as evidence that `ref()` is a complete chokepoint. Fix: correct the list to seven and name `publishCampToClassbook`.

---

**6. `Season.docId()` defaulting to `current()` makes a past-season *read* fetch the current season's document.**

2.1: "`Season.docId(id)` // `current()` by default, like `stamp()`". 2.2: "(and reads through the same helper so a 2027 view reads its own doc)". These contradict. With 2027 current and a tab viewing 2026, `js/app.js:13675` becomes `.doc(Season.docId('week_3'))` → `season-2027|||week_3` — the Open Studio tab shows **2027's** week under a "Viewing Summer 2026 — read-only" banner.

Fix: `docId()` must default to `viewing()` (writes are only possible when `viewing() === current()`, so this is strictly safer), or take an explicit season at every computed-ID site. Say which in 2.2, and add a scenario asserting the 2026 view reads `week_3` and the 2027 view reads `season-2027|||week_3`.

---

**7. The proposed computed-ID completeness rule misses the one weekly-prep site it is written for.**

2.2: "`.doc(<template literal or concatenation>)` on any of the five computed-ID collections must be `.doc(Season.docId(…))`". Evidence: `js/app.js:10962-10963` builds the ID into a variable first — `const docId = \`${campTopic.replace(/\s+/g,'_')}_week${weekNum}\`;` then `Season.ref('summerCampsWeeklyPrep').doc(docId)`. At the call site the argument is an `Identifier`, so a literal/concatenation rule is green on the live bug. (Open Studio's seven sites *are* literal at the call site and would be caught.)

Fix: invert the rule — on a computed-ID collection, `.doc(x)` must be `Season.docId(...)` *unless* `x` is provably a snapshot/doc id; reuse the existing intra-function variable tracking (`test/season-completeness.test.js` already does this for `.add(`). Add "red on a planted `.doc(variableHoldingATemplateLiteral)`" to 2.9.

---

**8. Nothing enforces that a new season's document ID is exactly four digits — and a non-four-digit season makes `parseDocId()` silently mis-parse.**

2.5 says "Christie enters the year" and writes `summerCamps_seasons/{year}`. The rule (`firestore.rules:774-776`) only requires `season == docId`; it does not constrain the shape. But `js/season.js:24` `SEASON_PREFIX_RE = /^season-(\d{4})\|\|\|.../` and the Classbook's `listRegisteredSeasons` (`tinker-spring-curriculum/js/firebase-data.js:375`) both require `^\d{4}$`. A season called `2027b` would produce IDs `season-2027b|||…` that `parseDocId()` returns as `{ season: '2026', legacyId: 'season-2027b|||…' }` — a mis-stamped document class the straggler sweep would then "fix" to 2026.

Fix: the create form validates `/^\d{4}$/` on the ID and refuses otherwise; add it to the 2.3 validator list and a `season.emulator` case.

---

**9. The week-structure generator's output list omits `breaks` — which both apps need.**

2.5: the generator "produces `week1Monday`, `startDate`/`endDate` and every week's `numDays`/`daysOff`/`note`/`dateRange`". It never says the `breaks` array is written to the registry doc. `Season.weekForDate()` (`js/season.js:366-383`) reads `season.breaks` to keep camp weeks and calendar weeks aligned, and the Classbook's `breakWeeksFromRegistry` (`firebase-data.js:419-426`) is the only way its Summer 2027 grid learns about a July 4 week. Without it, 2027 dates after the break map to the wrong camp week in this app and the Classbook draws no break column.

Fix: name `breaks: [{ afterWeek, label }]` as a generator output and add it to the 2.3 validator ("`breaks` is an array of `{afterWeek:int≥1}`").

---

**10. The generator's "reproduces the stored 2026 `weekStructure` exactly" parity test cannot pass as specified.**

`js/config.js:93-105` shows the stored structure carries free text no generator can derive: week 6's `note: 'After break Jun 29 - Jul 3'` (hyphen) beside week 1's `dateRange: 'May 26–29'` (en dash), week 11's `note: '2-day camps'` and `daysActive: ['Monday','Tuesday']`. (`numDays` and `daysActive` are, incidentally, read nowhere in `app.js`.)

Fix: scope the parity assertion to the structural fields (`numDays`, `daysOff`, `daysActive`, `dateRange`) and state that `note` is generator-seeded but user-editable — otherwise this test will be "fixed" by hard-coding 2026 strings into the generator.

---

**11. Kid Notes: the returning-camper *card* disappearing from the current-season view is an unnamed behaviour change.**

2.7 names one delta (manually-added notes start counting as returning). It misses a second. Today `js/app.js:6594-6598` builds `names2026` and `:6612-6614` deliberately **keeps** a 2025 note in the 2026 view when that child also has a 2026 note; `:6641` then badges *that 2025 card* "↩ Returning camper". Under a straight `season`-equality filter those older cards vanish entirely, and the plan's redefinition ("this child has a note in any season earlier than the one being viewed") moves the badge onto the current-season card instead. Christie loses the at-a-glance view of last year's notes for a returning child — which is the feature.

Fix: say explicitly whether the earlier-season card still appears in the viewing season's list (recommend: yes, keep the existing carry-through, now keyed on `season`), and add a scenario for it.

---

**12. Kid-note badges must key on the *viewing* season, not `current()`.**

2.7: badges "gain the season" — unspecified which. `js/app.js:7121` reads all seasons and `:7136-7150` keys `campTopic|||week(|||slot)` against schedule cells rendered from `Season.query('summerCampsSchedule')`, i.e. the **viewing** season. Keying the note side on `current()` would show zero badges whenever a past season is viewed.

Fix: state `Season.viewing()` explicitly in 2.7, and extend the existing scenario ("no badge on the 2027 cell") with its mirror: "viewing 2026, the 2026 note still badges the 2026 cell."

---

**13. `canEdit()` misses the markup-level edit controls.**

2.1: "the ~42 `isManagerPlus`/`isAdmin` checks that draw *edit* controls switch to it (controls are drawn in JS with inline handlers, so CSS cannot hide them)". Partly true — but there are also class-gated controls hidden by `applyRoleRestrictions` (`js/auth.js:141-152`): `index.html:72` `<div class="curriculum-controls admin-manager-only">` (holds "+ Add New Camp"), `:133` `os-add-override-btn`, `:1658` `save-match-overrides`. Those stay visible to an admin viewing read-only 2026 and would then throw from `ref()`/`stamp()` rather than being absent — which the plan's own scenario ("there are none") asserts against.

Fix: add a `data-requires-writable` / `body.season-read-only` pass applied after `applyRoleRestrictions()`, and list these three in 2.1.

---

**14. The 2.0 removal range `app.js:7683-7692` cuts into the block that must survive.**

Actual lines: 7683-7687 are the dead `#import-data-btn` binding; 7688-7690 is the "deliberately isolated" comment; 7691 is `try {`; 7692 is `applySheetImportAvailability();`; 7693 is **`applySeasonLabels();`**. Deleting 7683-7692 leaves `applySeasonLabels(); } catch (err) {` with no `try` — a parse error that kills the whole app. That isolated try/catch exists precisely because a throw there decapitated handler registration on Sep 23 (Decisions Log, Sep 23).

Fix: change the range to "7683-7687 and line 7692 only; the `try { applySeasonLabels(); } catch` block stays."

---

**15. `importTeachersFromSchedule` would import nobody in 2027.**

2.8 says it "builds from the current season's schedule, writes `seasons[current]`". But `js/app.js:6173` dedups against every person in `teamData` by name — so in 2027 every returning teacher is skipped, and the button reports "All teachers from the schedule are already in the roster" while nobody has a `seasons.2027` entry.

Fix: in the season model, "already in the roster" means "already has `seasons[current]`". A person who exists but lacks the current season's entry should be offered as "add to 2027 from their 2026 details" — which is the same operation as the "Add to 2027" button. Say so in 2.8.

---

**16. The camp-rename → topic-entry update is under-specified and can't work as written.**

2.6: "a camp rename updates the current season's topic entry whose `name` matches." The update branch (`js/app.js:385-392`) holds only `window.CURRICULUM_EDIT_ID` and the *new* `campTopic`; matching on the new name finds nothing after a rename, leaving a stale topic entry under the old name in Lesson Plans and the Materials dropdown (`:11162`, `:2714`) forever. (There is no delete-camp path anywhere in the app, so stale entries never get cleaned up by another route.)

Fix: read the pre-edit `campTopic` from the loaded curriculum doc (the orphan-reassign flow at `:438-525` already does this) and match on that; add a scenario "rename a 2027 camp → exactly one topic entry, under the new name."

---

**17. Gating `ref()`/`stamp()` on `viewing() === current()` forecloses Phase 3's carry-forward.**

D4 and Phase 3 both say carry-forward is initiated *from the read-only 2026 view* and writes to the current season. With `isWritable() = viewing() === current()`, every write from a 2026 view is refused — including the one write D4 explicitly permits.

Fix: gate on the *target* season, not the viewing one: `Season.ref(key, { season })` / `Season.stamp(payload, { season })` where the default is `current()` and the assertion is `season === current() && !currentMoved`. Phase 2 then needs no change when Phase 3 lands. Say this in 2.1 as the Phase 3 hook (replacing today's zero-call-site `assertWritable`, `js/season.js:403`).

---

**18. The straggler "needs a choice" resolution is an unnamed second write path into a past season.**

2.4 adds a per-row season picker for ambiguous unstamped auto-ID docs. That write goes through `season-migration.js` (`stampAll`, `:212-220`, an `EXEMPT_FILES` module using raw `db.collection`) and can legitimately stamp a document `'2026'` while 2027 is current — i.e. it writes to a read-only season by design.

Fix: name it as an audited exception alongside `Season.raw()`, restrict it to `update({season})` on docs the scan classifies as *missing*, and add a scenario ("a straggler assigned to 2026 while 2027 is current is stamped 2026 and nothing else on the document changes").

---

**19. The 2.9 e2e assertions cannot run before 2B ships, and go stale immediately after.**

2.9's e2e block runs "production, read-only, test account" and asserts "once 2027 exists — the switcher appears, viewing 2026 shows the banner and **no** edit controls … viewing an empty 2027 shows every tab's empty state". 2027 only exists after Christie's step in 2.10, and 2027 stops being empty the moment she starts planning. So Release 2B ships with its own headline behaviour unverified by any test, and the tests then rot.

Fix: move the read-only-view and empty-state assertions to the emulator with seeded two-season fixtures (`test/season.emulator.test.js` already takes an injected `db`); keep e2e to "switcher absent with one season" + the existing `APP_STATE.initialized` guard. Or gate those e2e tests on a registered-seasons count and skip otherwise.

---

**20. Missing scenarios — a partial implementation would pass the current set.**

The 18 scenarios cover writes well and reads not at all. Specifically missing:
- **The read-while-read-only scenario** (finding #1): "Given 2027 is current and a tab is viewing 2026, When Open Studio week 3, a material's detail modal, copy-curriculum and project details are opened, Then each loads 2026's data with zero page errors." Nothing today would catch Open Studio going blank a second time.
- **Kid Notes written from a past-season view** (finding #2): "Given a tab viewing 2026 and 2027 current, When a kid note and a note-for-next-year are added, Then both are written, stamped 2027, and the user is told where they landed."
- **The Classbook at the moment of the flip**: "Given a Classbook tab open on Summer 2026, When `_current` moves to 2027, Then its lesson slots, camp-complete flags, prep-help messages and materials are unchanged (forced-server, counted)." The entry gate is asserted as met but never re-proved at the one moment it matters.
- **Team save after the backfill while 2027 is current and viewed** (finding #3).
- **A team doc missing `scheduleGroups`/`additionalRoles`** (finding #4).
- **Reverting `_current` back to 2026** (2.5 advertises it as reversible; nothing tests it).
- **Camp rename → one topic entry** (finding #16).
- **Deleting a session that has weekly prep / camp-complete / kid-note enrollments** — 2.6 promises a warning; no scenario.

---

## LOW

**21.** The switcher's `sessionStorage['sca.viewingSeason']` survives "Make 2027 current" in the same tab, so Christie's own tab stays read-only on 2026 after the reload. Have make-current clear the key. (2.1/2.5)

**22.** 2.0 removes the 11 one-off `.html` pages but leaves six root `.js` one-offs that also write `summerCamps_*` unstamped and are equally deployed (Netlify `publish = "/Users/christiehubley/summer-camp-app"`, `.netlify/netlify.toml`): `fix-cc-fashion-{days,sessions,totals,trial}.js`, `import-cc-fashion-materials.js`, `check-cc-fashion-sessions.js`, plus `test-firestore.js`. They are console-paste scripts rather than runnable pages, so the risk is lower — but "remove the deployed one-offs" should mean all of them.

**23.** `showEmptyPrepState` / `renderPrepOverview` are at `js/app.js:8994` and `:9010`, i.e. **outside** the `8288-8988` import block the plan places them in. I confirmed neither has a caller; just correct the location. Note `renderPrepOverview` reads `topic.prepStatus` — the field 2.6's new topic entry seeds — so double-check nothing else in the Lesson Plans render depends on it before deleting.

**24.** After 2.0 the sheet imports are the only callers of `DataSafety.runGuardedDestructiveWrite` (`js/app.js:8750, 8900, 8939`); it and its emulator tests become dead until Phase 3. Say whether it is kept deliberately (it should be — Phase 3 carry-forward and Cut Bank want it) so a later cleanup doesn't delete it.

**25.** Neither the in-app Export (`DATA_SAFETY_TRACKED_COLLECTIONS`, `js/app.js:8213-8231`) nor — per the Sep 21 cross-plan note — necessarily `~/tinker-backups/backup.js` includes `summerCamps_seasons`. 2.8's backup gate is the guard for the one Phase 2 data write, and 2.5 writes the registry. Add "confirm `summerCamps_team` **and** `summerCamps_seasons` are in `backup.js`'s `COLLECTIONS`/`TIER1_COLLECTIONS`" as a pre-step in 2.10, and add the registry to the in-app export list.

**26.** 2.3's literal inventory misses two hard-coded studio lists that are already wrong for the season doc's six studios: `index.html:847-852` (`team-filter-studio`: Tinker / Clay Hub / Off-Site) and `:1000-1007` (`day-off-studio`, plus a `Both` value), and `js/app.js:6039-6043` `LOCATION_SECTIONS` in `renderTeamLocationView`. Pre-existing, but 2.8 moves `studios` per season, so this is the moment.

**27.** 2.4's new "valid iff the season is registered" rule quietly drops today's kid-note check that `season` must agree with `importYear` (`js/season-migration.js:103-117`). That's the right loosening, but name it — it is a real detection the sweep stops making.

**28.** 2.5's "no date/week edits once the season has documents" counts all 14 collections, including the two cross-season ones. A kid note stamped 2027 (writable from any view, by design) will block editing 2027's dates. Either exclude `kidNotes`/`notesNextYear` from that count or say the block is intentional.

**29.** 2.10 omits two house rules that apply to these releases: bump the `?v=` cache-busters on every changed `js/` file (`index.html:1759-1764`, currently `season.js?v=2` / `app.js?v=52`), and deploy with `--message "$(git rev-parse HEAD)"` from a clean, pushed tree.

**30.** `summerCamps_weeklyPrep` has exactly one call site in the whole app (the write at `js/app.js:10963`) — it is never read back. 2.2's "reads through the same helper" is moot for it; worth a word so nobody hunts for a read that doesn't exist.

---

## Checked and found correct

So the review isn't read as one-sided — these claims I verified against the code and they hold:

- **Entry gate.** The Classbook filters every summer read by season (`firebase-data.js:1616-1619, 1634-1787`) and uses `_current` only to pick filtered vs legacy (`:315-319, 355-363`). Creating a 2027 doc or moving `_current` genuinely does not touch its Summer 2026. `loadSummerCampData` only throws on empty when `season === null` (`:1635`), so an empty 2027 is safe there.
- **2.2's raw-ID inventory is complete for this app.** `campComplete` and `prepHelpQueue` are never written by computed ID here (`:12010`, `:12028` use snapshot IDs); `lessonData` already goes through `Season.docId()` (`:525`); only Open Studio (7 sites, `:13675/14084/14139/14241/14371/14396/14480`) and weekly prep (`:10963`) build raw ones.
- **2.3's hazard list.** All nine unguarded `weekStructure[...]` sites, `studios.includes` ×3, `studioCapacities[studio]` at `:7488`, `['AM','PM']` at `:3928` and `:7473` with the header/body mismatch at `:7480`, the `w === 5` break at `:3953`, the 11-week clamp at `:13622`, `KN_WEEK_STARTS` at `:6819`, `TEAM_WORK_WEEKS`/gap grid at `:5342`/`:5589-5593`, `loadWeeklyPrepIndex`'s early return before `SCHEDULE_BY_WEEK` — and index.html's team week filter really is missing Week 6.
- **2.4's migration claims.** `sweepStragglers` refuses at `season-migration.js:380-384`; `expectedSeason` returns `LEGACY` for auto-ID collections (`:96`) so `classify` (`:116`) would mark every legitimate 2027 doc invalid. The registry-driven replacement, including "plus `'2025'` for imported kid notes", correctly covers a 2027 kid note that has no `importYear`.
- **2.5 rule compatibility.** `firestore.rules:774-776` permits manager+ creates with `season == docId`; `:790-794` requires `_current` to name an existing season doc, so make-current genuinely cannot share a batch with create; reverting `_current` to 2026 is allowed. `registrySeasonProblems` (`firebase-data.js:385-396`) requires exactly what 2.5 says, and Re-sync copies exactly `name, startDate, numWeeks, breakWeeks, timeSlots, studios` (`tinker-spring-curriculum/js/app.js:10489`).
- **2.6 session payload.** It matches `parseSessionsData` (`js/app.js:8419-8432`) field for field, and the string form is safe: both `normalizeTimeSlot` here (`:3889-3895`) and the Classbook's `normalizeSlot` fold `'AM (9am-12pm)'` and `'AM'` to the same key. The Classbook reads only `campTopic`, `week`, `studio`, `timeSlot`, `teacher`, `maxCapacity` off these docs. `projectLibrary`'s field really is `name` (`:11171`).
- **2.8's `teamMigratedAt` does not violate Phase 1's registry rule.** `IMMUTABLE_SEED_FIELDS` (`season-migration.js:36`) is dates/weeks only, and an `update()` keeps `season == docId` so the rule passes. (It must be `update()`, not `set()` — worth stating.)
- **2.8's "no other app reads `summerCamps_team`"** — confirmed: only this app, `fix-lead-teacher-weeks.html:136/264` (which does write the flat `weeks`, as claimed, and is removed in 2.0), and `tinker-timeclock/summer-camp-sync.html:338`.
- **2.0's 11 pages are genuinely unreferenced** anywhere in the repo including `test/` and `e2e/`, and they really are deployed (publish dir is the repo root). The only live references to removed symbols are `season-completeness.test.js:346` and the `ownsDoc` block in `season.emulator.test.js:315-341`, both of which the plan names. `data-safety.emulator.test.js`'s `'importCurriculumData'` occurrences are string labels, not references — correctly left alone.
- **P2-D5's storage path change needs no rules deploy** — `studio-hub/storage.rules:39` is `match /projectDetailPhotos/{allPaths=**}`.
- **`Season.assertWritable` does have zero call sites** (`js/season.js:403`, definition and export only).
- **Release 2A is genuinely behaviour-identical** with one season registered: `isWritable()` is always true, `docId()` returns byte-identical 2026 IDs, and the registry-driven classifier accepts exactly what the hard-coded one did.

---

**Verdict:** the shape of Phase 2 is right, but it is not execution-ready — findings 1–4 would each ship a visibly broken or data-damaging app, and three of them come from the same root cause: `ref()`/`stamp()`/`doc()` being redefined without separating *read scope* (viewing) from *write target* (current).
