I could not read the plan — `/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-copied-camp-review.html` is outside the permitted directories and both `Read` and `Bash` were denied on it, and this session is non-interactive so there's no way to grant access mid-run. So I could not verify the plan's own claims or judge its BDD scenarios against what it actually wrote. Everything below is a direct audit of the code against the questions you listed, plus the scenarios the findings imply. To get the plan-verification half, either re-run with that path readable or copy the file into the repo.

---

## Verified positive (your first question, answered)

**Deriving "unreviewed" from `carriedForwardFrom` + absent `reviewedAt` is correct for the curriculum collection.** I checked every writer:

- `carry-forward.js:159` sets `carriedForwardFrom` on every copied curriculum doc unconditionally, inside the all-or-nothing transaction at `carry-forward.js:463-477`. All 23 production copies have it.
- Nothing else ever puts it on a curriculum doc. `createCamp` builds its payload from the editor form only (`camp-admin.js:114` ← `app.js:503` ← `app.js:439-455`); `copyCurriculum` writes only `blocks`/`notes`/`updatedAt` (`app.js:13351-13355`).
- **No writer can drop `reviewedAt`.** All six curriculum writes in `app.js` are `.update(Season.patch(…))` (`app.js:2137, 9235, 10950, 11311, 12536, 13351`) — zero `set()`. `camp-admin.js` uses `tx.update` on both the same-name path (`:180`) and the rename path (`:217`). The only `set()`s create brand-new docs (`camp-admin.js:123`, `carry-forward.js:472`).
- A rename never changes the curriculum doc id (`camp-admin.js:142, 217`), so `reviewedAt` survives A→B→C.

That part of the design holds. The findings are around it.

---

## Findings

**1 · HIGH · Lesson Plans never reads `summerCamps_curriculum`, so a badge there cannot come from `reviewedAt`.**
`loadLessonPlans` reads exactly three collections — `summerCampsProjects`, `summerCampsSchedule`, `summerCampsCampComplete` (`js/app.js:2828-2832`) — and `renderLessonCampsList` renders off `topic.name` (`js/app.js:9595-9651`). Meanwhile `carry-forward.js:169` writes `carriedForwardFrom` onto the **topic** doc too. So the tempting implementation (read it off the topic) gives you a flag that "Mark reviewed" — writing `reviewedAt` to the curriculum doc — never clears: permanently unreviewed in Lesson Plans.
*Fix:* either add a fourth read of `summerCampsCurriculum` to `loadLessonPlans` and join `topic.name === curriculum.campTopic` (safe: `saveCamp` moves both in one transaction, `camp-admin.js:180-189, 215-217`), or state explicitly that the badge is curriculum-tab-only and do not render it in Lesson Plans.

**2 · HIGH · `carriedForwardFrom` is on four collections, not one.**
`carry-forward.js:159` (curriculum), `:169` (projectLibrary topic), `:177` (projectDetails), `:195` (materials). The 23 copies therefore produced ~23 topics plus every detail and material doc carrying the field. Any `isUnreviewed(doc)` helper that isn't hard-scoped to curriculum — or any Firestore rule keyed on the field's presence — will classify project-detail and material docs as unreviewed camps.
*Fix:* name the derivation `isCampUnreviewed(curriculumDoc)`, assert the doc has `campTopic` and `blocks`, and never call it on the other three collections.

**3 · HIGH · No role gate exists on the Curriculum editor — staff and prep can already open it.**
The tab button carries no role class (`index.html:49`), unlike Days Off (`:60`) and Settings (`:62`). `applyRoleRestrictions` hides `materials`/`projects`/`settings` for `prep` only (`js/auth.js:200-209`) and never touches `curriculum`. The editor modal (`index.html:1123-1190`) has no `admin-manager-only` anywhere — not even on `.save-curriculum-btn` (`index.html:1183`). The only gate is `.curriculum-controls.admin-manager-only` (`index.html:73`), and the editor is reached by clicking a card (`js/app.js:216-222`), not through those controls.
*Fix:* put the Mark reviewed button behind an explicit check (`isSeasonAdmin()` at `js/app.js:4803`, or the `admin-manager-only` class), and treat the rule as the real gate — the plan should say which roles the rule allows.

**4 · HIGH · The Firestore rule is unverifiable from here, and no test in this repo can catch a miss.**
`/Users/christiehubley/studio-hub/firestore.rules` was denied to me, so I could not check whether the `summerCamps_curriculum` update rule at ~827 constrains the writable field set. If it does, `reviewedAt`/`reviewedBy` is denied — and per this repo's own documented pattern that surfaces as data silently looking wrong, not as an error. There is no `.rules` file in this repo (`find . -name '*.rules'` → nothing), and every suite here drives `firebase-admin`, which bypasses rules entirely.
*Fix:* the plan must include reading that rule block, and — if it's field-constrained — a rules edit plus a test in `studio-hub`'s suite, shipped in the same commit per your own invariant. Don't rely on `npm run test:carry-forward` to prove the write works.

**5 · MED · A past-season view will show the Mark reviewed button enabled.**
`PAST_SEASON_HIDE` lists `.save-curriculum-btn` but nothing new (`js/app.js:5634-5661`), and `PAST_SEASON_LOCK` only matches `#curriculum-editor-modal input, textarea, select` (`js/app.js:5667`) — `lockPastSeasonFields` disables elements, and a `<button>` matches none of those selectors (`js/app.js:5677-5684`). `Season.writeRef` would refuse the write loudly (`js/season.js:443`), so no data damage, but the control shouldn't be there.
The sweep in `e2e/season-read-only.spec.js` does match `/mark\b/` in its `EDIT_TEXT` regex and does open the curriculum editor — **but it runs with 2027 current viewing 2026, and no 2026 camp has `carriedForwardFrom`**, so a conditionally-rendered button never appears and the test passes green over the gap.
*Fix:* add the selector to `PAST_SEASON_HIDE`, and add a read-only case with 2028 registered/current viewing 2027 (where carried camps exist) — otherwise the regression is invisible until next summer.

**6 · MED · The editor's save lock does not cover a new button.**
`saveCurriculum` disables `#curriculum-editor-modal input, textarea, select, .save-curriculum-btn` (`js/app.js:396-398`); a `#mark-reviewed-btn` is in none of those, and `curriculumManualSaving` (`js/app.js:353`) gates only autosave (`:357, :377`). So Mark reviewed can fire mid-save. No field is lost — everything is `update`+`patch` — but the concrete bad outcome is: the user renames, Save's duplicate check throws (`camp-admin.js:196-198`), nothing renames, and the camp is now marked reviewed under the name it still has. Reverse order is clean: a queued autosave landing after Mark reviewed is an `update` that preserves `reviewedAt` (`js/app.js:9235-9240`).
*Fix:* include the button in the `fields` disable list, and have its handler `return` while `curriculumManualSaving` is true and `await settleCurriculumAutoSave()` (`js/app.js:361-365`) first.

**7 · MED · `window.CURRICULUM_CAMPS` goes stale after marking, and one path populates it from outside the Curriculum tab.**
It is assigned only in `loadCurriculum` (`js/app.js:160`) and, when empty, once by `loadKidNotes` (`js/app.js:7657-7660`) — which never refreshes it afterwards. The array passed to `renderCurriculumGrid` is the same object (`:161`), and the click handler closes over it (`:219`), so mutating the camp object in place updates both the card data and the editor's `campData`. But nothing re-renders the card.
*Fix:* on success, mutate the camp object in `window.CURRICULUM_CAMPS` and re-render (or call `loadCurriculum()`); don't re-read `campData` expecting freshness. Project Details and Materials Hub are safe — they re-read curriculum on every tab switch (`js/app.js:81-132, 658, 700`).

**8 · MED · `reviewedBy` has two incompatible actor shapes already in this codebase.**
Carry-forward stamps `createdBy` with `seasonActor()`, an **email** (`js/app.js:4807-4809`, passed at `:13028`). `createCamp` stamps it with `currentUser.uid` (`js/app.js:505`). `window.STAFF_NAMES` is keyed by uid (`js/app.js:150-153`), which is what the co-teacher line renders through (`js/app.js:204`). So "Reviewed by …" will print a raw email or a raw uid depending on which you pick.
*Fix:* pick uid (consistent with `STAFF_NAMES` and `sharedWith`) and say so in the plan; render with the same `STAFF_NAMES?.[uid] || uid` fallback.

**9 · MED · Adding the fields to `FIELDS.curriculum.dropped` is necessary and sufficient — but untested.**
For everything else you asked about, `dropped` is enough: `knownOf` folds `dropped` into the known set (`carry-forward.js:142-144`) so `noteUnknown` stays quiet (`:133-140`); `season-migration.js` classifies only by the `season` field (no curriculum field list — only `IMMUTABLE_SEED_FIELDS` at `:36`, which is registry-only); `data-safety.js` snapshots whole documents with no field list (`:24-34`); the receipt payload is a fixed shape (`carry-forward.js:390-400`); the completeness checker cares only about call shape, which `writeRef(...).doc(id).update(Season.patch(...))` satisfies with no allow-list entry.
The gap is proof: `test/carry-forward.emulator.test.js:158-169` asserts the exact output key set and "every source key in exactly one bucket" — but only over `FULL_CURRICULUM`, which has no `reviewedAt`. So a 2027→2028 copy dropping the flag is asserted nowhere.
*Fix:* add `reviewedAt`/`reviewedBy` to the `FULL_CURRICULUM` fixture; lines 160 and 168 then prove the drop. Note `:243-244` asserts the topic payload exactly — if you also stamp the topic, that assertion must change deliberately.

**10 · LOW · Address the doc by id, never by `campTopic`.**
Six live `where('campTopic','==',…).limit(1)` sites (`js/app.js:4513, 9943, 9944, 10892, 10930, 10973, 12534`). Within 2027 they're safe — per-season name uniqueness is enforced by `createCamp` (`camp-admin.js:97-101`), `saveCamp` (`:193-198`) and carry-forward's `currentNames` check (`carry-forward.js:283-284, 334-338`). But a rename between opening the editor and clicking Mark reviewed makes a name lookup write the wrong doc or nothing.
*Fix:* use `window.CURRICULUM_EDIT_ID`, exactly as `autoSaveCurriculum` does (`js/app.js:9236`).

**11 · LOW · Coal Creek twins are marked independently — say so.**
`COAL_CREEK_PREFIX = 'Tinker @ Coal Creek: '` (`js/app.js:4`), `getBaseCampName` (`:11-13`). The twin is a separate curriculum doc with a distinct exact `campTopic`, so `==` lookups can't confuse them and each carries its own `carriedForwardFrom`. Marking "Dragons" reviewed leaves "Tinker @ Coal Creek: Dragons" unreviewed. The copy dialog already pairs them visually with a "Coal Creek pair" pill (`js/app.js:13130-13135`), so a reviewer will expect pairing here too.
*Fix:* decide and state it. If independent, say it in the badge tooltip.

**12 · LOW · Sheet-era duplicate topics survive a rename under the old name.**
`saveCamp` moves one topic and leaves look-alikes as `extraTopics` (`camp-admin.js:158-165`), surfaced as a warning (`js/app.js:492-495`). The rename path copies the whole old topic doc onto the new lock id minus `season` (`camp-admin.js:206-215`), so `carriedForwardFrom`/`sourceTopicId` — and a `reviewedAt` if you put one on the topic — follow the rename correctly. But a leftover duplicate keeps the old name and its own provenance, so any name-keyed join (finding 1) double-counts it.

**13 · LOW · Escape the badge text.**
`renderCurriculumGrid` interpolates `camp.campTopic` raw at `js/app.js:197`, while the "Copied from" line immediately below uses `escapeSeasonText` (`:206`). Copy line 206's pattern, not line 197's.

---

## BDD scenarios these findings imply

I can't tell you what your list missed without reading it, but a partial implementation would survive all of these unless they're present:

1. A 2027 camp copied from 2026 shows the badge; a camp created with "+ Add New Camp" in 2027 does not — same tab, same render.
2. Mark reviewed, then **without reloading**, the card's badge is gone (catches finding 7).
3. Mark reviewed, then Save with an unchanged name → `reviewedAt` still present (catches any `set()` regression).
4. Type in the grid to arm autosave, click Mark reviewed, let autosave land → `reviewedAt` still present (finding 6).
5. Mark reviewed on a copy, then rename it → still reviewed, and the Lesson Plans entry moved (findings 1, 12).
6. Copy a reviewed 2027 camp into 2028 → the 2028 copy is unreviewed (finding 9; needs the fixture change to be provable).
7. Signed in as `staff` and as `prep`: the Curriculum tab opens, a card opens the editor, and Mark reviewed is absent — and if it were clicked, the rule denies it (findings 3, 4).
8. 2028 current, viewing 2027: the badge shows, the button does not (finding 5).
9. Both Coal Creek twins listed; marking one leaves the other (finding 11).
10. Rules test in `studio-hub`: a manager can write `reviewedAt`/`reviewedBy` and nothing else new; a staff user cannot (finding 4).

---

**not execution-ready: the plan document itself could not be read (path denied, non-interactive session), so its claims and BDD scenarios are unverified; and on the code side findings 1–4 are unresolved — Lesson Plans has no curriculum read at all, `carriedForwardFrom` spans four collections, the Curriculum editor has no role gate, and the `summerCamps_curriculum` rule was unreadable while no suite in this repo exercises rules.**
