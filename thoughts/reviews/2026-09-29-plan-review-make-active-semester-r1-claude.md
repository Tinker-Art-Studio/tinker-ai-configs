I read the plan in full and verified every "what exists today" claim against the worktree at `2ef2e62`. Most of the research is accurate. Three findings would stop or mislead execution, and there are several smaller ones.

## Claims I confirmed

- `activeSemester` set-only-when-missing — `js/app.js:11318-11319`, `:11247` ✓
- What it controls — `app.js:68, 76, 818, 4492-4496, 4514-4522, 4530, 4590, 10687, 10702-10705` ✓
- It does *not* move returning users — `app.js:13, 65-70, 96-100` ✓
- `getActiveSemesterKey()` returns the *selection* first — `js/firebase-data.js:3117-3123`; `getCurrentWeekNum()` follows it via `getActiveSemester()` — `app.js:1243-1244` ✓. `getTvSemKey()` (`app.js:635-638`) and `getSettingsSemKey()` (`app.js:10659-10661`) are both aliases of it.
- "Active" ≠ visible — `canSeeSemester()` `app.js:277-284` ✓
- `updateAppData` one `update()` of named paths, refuses on failed load / bad registry — `firebase-data.js:212-239` ✓
- `toggleSemesterPublish` is the right template — `app.js:4604-4630` ✓
- No live config listener — only reference to `setupConfigListener` outside its own definition is the comment at `app.js:11328` ✓
- **No other Tinker app reads `activeSemester`** ✓ — and I checked wider than the plan's list. The only cross-app reader of the `curriculum` collection is `studio-hub/js/alerts.js:562`, which reads `curriculum/lessonData` and iterates *all* semesters (`:573`), plus `summer-camp-app/scripts/backup-firestore.js:39` which just backs the collection up. Neither depends on the active flag. `summer-camp-app`'s `'curriculum'` (`js/app.js:85`, `js/config.js:63`) is its own tab/field name, not this collection.
- No rules change needed ✓ — `studio-hub/firestore.rules:652-669` is document-level; a new **field** on `curriculum/appData` needs nothing. And `settingsFieldPathsFor` + `extraPaths` (`app.js:11295-11319`) only ever write `semesters.<key>.*`, `teacherMappings`, `activeSemester`, so a Settings save can't clobber `activeSemesterSwitchAt`.

## High — these block or mislead

**1. The e2e setup can't write `appData`. `e2e/helpers/firestore.js` signs in as a non-manager.**
`getDb()` signs in as `TEST_ACCOUNT` (`helpers/firestore.js:57`) = `e2e-admin-uid`, `role: staff`, `appAccess: ['classbook','curriculum-admin']` (`e2e/emulators/config.js:42-49`, `e2e/fixtures/seed/users.json`). The rules deny exactly that: `allow create, update: if (…) && docId != 'appData'` (`firestore.rules:666-669`). There is no appData helper in that file. So "adds a test-only weekly semester to `appData` in `beforeEach` through the emulator helper" fails on the first hook.

Worth knowing *why* this has never bitten: **no spec has ever written `appData` for real.** Every existing appData test stubs `window.updateAppData` and asserts the payload (`data-safety.spec.js:3947-3949, 7596-7610, 7774, 7789`). Your spec would be the first to mutate shared emulator config. I'd follow the house pattern — stub-and-assert-payload for the shape scenarios, plus one real manager write for the round-trip and one real non-manager write for the rules refusal — rather than inventing a manager-authenticated helper and a restore protocol.

**2. Phase 1's UI premise is wrong: the Settings "Editing Semester" dropdown can't select anything.**
`index.html:411` is `onchange="loadSettingsForm()"` — nothing else binds it. `getSettingsSemKey()` returns the *header's* `globalSemesterKey`, and `loadSettingsForm()` rebuilds the options with `selected` on that key (`app.js:10681-10689`). So picking Fall 2026 there redraws the form for the current semester and snaps the dropdown back. Today the only way to get Settings onto a non-active semester is the header dropdown — which changes the whole app's semester.

Every Phase 1 acceptance bullet and BDD line reads "Editing Semester = Fall 2026" as though that control works. Either fix it in Phase 1 (`onchange="setGlobalSemester(this.value)"`) or reword to the header semester. Please confirm by hand in the running app before deciding — this is a behaviour I read off the source, not off a browser.

**3. Making Fall active silently arms the Delete button on Spring 2026.**
`deleteSemester` refuses only `key === currentConfig.activeSemester` (`app.js:4530-4533`), and `renderSemesterSelector` renders the 🗑 Delete button only for non-active semesters (`app.js:4522`). The moment Fall becomes active, Spring 2026 gains a Delete button in Curriculum Admin — and for a weekly semester that path runs `deleteLessonData(key)` (`firebase-data.js:961-966`), a `FieldValue.delete()` of the entire semester's lesson map. That is the most destructive button in the app, newly exposed on the semester holding a year of real lessons, at exactly the moment everyone's attention is on the new term. The plan doesn't mention it anywhere. At minimum it belongs in the safety section and the confirmation text; I'd also add a lesson-count second confirm for a weekly delete, and a BDD scenario.

## Medium

**4. The "old semester is a draft" warning is false, and contradicts the plan's own research.** Phase 1 proposes "Spring 2026 is a draft, so teachers will stop seeing it." Teachers never saw it: `canSeeSemester` returns false for any `published === false` semester regardless of active (`app.js:282`) — which your own row at plan line 53 says. Drop that line. The real inconsistency is in the other direction: `app.js:10705` renders "Active Semester — always visible to teachers" while `10704` hides the publish toggle, so an unpublished active semester is invisible *and* unpublishable from the UI. Phase 1's auto-publish makes that badge honest going forward — say so as an intended fix.

**5. Phase 2 stores a time, not a target.** `activeSemesterSwitchAt` says "someone asked for a switch at T"; the browser then lands on whatever `activeSemester` is at load time. Sequence: Fall made active, ticked (T1) → before all browsers have loaded, someone makes Summer active, unticked → those browsers jump to Summer, which nobody asked to switch everyone to. Store `activeSemesterSwitchTo` alongside and apply only if it still equals `activeSemester`, or state the "go to whatever's active" semantics deliberately.

**6. Marking a switch "seen" for someone who wasn't moved consumes it permanently.** Your invisible-active-semester scenario asserts exactly this. If the semester is published later, that browser is never moved. Narrow window given auto-publish, but make it a decision rather than a side effect.

**7. Re-rendering the header selector double-binds its change handler.** `initGlobalSemesterSelector` attaches `select.addEventListener('change', …)` at `app.js:86` with no attach-once guard — unlike `renderTvSemesterSelector`, which guards on `select.dataset.listenerAttached` (`app.js:825`). It's already called again at `4724` and `4845` after creating a semester, so the bug pre-exists; `makeSemesterActive` adds another. It matters because `setGlobalSemester` can `switchTab('teacher-view')` and re-run renders (`app.js:102-142`). Add the same guard, or re-render options without re-binding.

**8. Missed consumer: Teacher View's own selector.** `renderTvSemesterSelector` labels the active semester "(current)" (`app.js:818-819`), and `initTeacherView`'s already-built branch only redraws it conditionally (`app.js:653-655`). Your acceptance lists Settings, header and Curriculum Admin. Add it to the re-render set.

## Low

- **`updateAppData` isn't purely one `update()`** — on `not-found` it falls back to `set(nestFieldPaths(payload), {merge:true})` (`firebase-data.js:233-238`). Irrelevant for a document that exists, but the atomicity claim should say so.
- **Rules phrasing.** `classbook`/`classbook-admin`/`curriculum-admin` *can read* `appData` (`firestore.rules:665`); they're denied only create/update. That read is precisely what makes Phase 2 work for teachers — state it positively.
- **Two stale `'spring-2026'` literals** become quietly wrong after the switch: `firebase-data.js:3122` (`|| 'spring-2026'`) and `getDefaultConfig()` `:504`. Both only fire when `currentConfig` is null/absent (a banner state), so no live bug. There's a static ratchet for `summer-2026` (`static-checks.spec.js:45`) but none for this.
- **Phase 2 must write `localStorage.globalSemesterKey` itself** — the `setItem` at `app.js:69` is inside the fallback branch, which your pre-check will make false. The BDD asserts it; the Shape paragraph should too.
- **No saved teacher session exists.** `global-setup.js:63-70` writes only the admin and manager states. `login(page,'teacher')` on the default storageState returns the signed-in *admin* (`helpers/login.js:100-104`). Phase 2's teacher browser needs a blank storageState + `signInViaForm(page,'teacher')`; the creds exist (`login.js:45`, `users.json`). Also note `MANAGER_STATE_PATH` is currently used by no spec — yours would be the first.
- **Leak blast radius.** `workers: 1` (`playwright.config.js:22`) and alphabetical ordering put `active-semester.spec.js` **first**. A leaked `activeSemesterSwitchAt` or semester key would poison `day-off-camps.spec.js:398-411` ("SDOC R6", which drives `initGlobalSemesterSelector` directly) and `day-off-teacher.spec.js:661` ("T20", which reads `currentConfig.activeSemester` to find "the weekly semester"). Restore in `afterEach` **and** `afterAll`, with read-back. `lastUpdated`/`lastUpdatedBy` can't be restored to fixture values — nothing asserts them today, and `app.js:10918` already models ignoring exactly those two in a whole-document diff; copy that for your "only `activeSemester` changed" assertion.
- **Eligibility must use `semesterTypeOf()`/`isWeeklySemester()`** (`firebase-data.js:45-53`), never a key prefix — there's a ratchet against prefix routing (`static-checks.spec.js:108`). Note the seed's `spring-2026` carries no `semesterType` field, so give your test semester an explicit `semesterType: 'weekly'`.
- **Test count**: `^\s*test(` across `e2e/*.spec.js` is **323**, not 327. Re-count at execution time rather than trusting the number.

## BDD gaps (a partial implementation could still pass)

Missing: (a) a payload-keys assertion for the auto-publish case, in the house style `expect(Object.keys(payload).sort()).toEqual([...])` (`data-safety.spec.js:7610`); (b) "a second tab already open is unaffected until reload" — Phase 2 asserts this in prose, nothing tests it; (c) the manager who performs the switch is themselves subject to it on their next load; (d) a UI-level check that the button is absent for a non-manager (cheap — `setupRoleAccess` hides Settings at `app.js:328-329`); (e) `updateAppData` refusing because `seasonRegistryMode` is `error`/`unknown` (`firebase-data.js:221-223`) — a live failure mode of this exact button, and the one most likely to hit Christie mid-term-change.

## On your other questions, plainly

- **Safety invariants**: the write shape is right — named dotted paths, awaited, exact restore including "field was absent", no new collection, no rules change. My objections are about the two *consequences* the plan doesn't name (finding 3) and the e2e mechanics (finding 1), not the write itself.
- **Multiple tabs / shared devices / clock skew**: the design holds. Tabs are consistent because `globalSemesterKey` is shared localStorage; a shared studio device consumes the switch once and every subsequent user on it lands on the new semester anyway, which is what you want; the not-equal comparison does neutralise skew as claimed. Ordering relative to `app.js:65-70` is correct — pre-setting a visible key makes the condition at `:65` false, so it won't override you, and nothing reads `globalSemesterKey` between `app.js:13` and the call at `:158`. First load after deploy moves nobody (verified: nothing reads the field until it exists).
- **The plan's Q1/Q2 recommendations** both look right to me; Q1 in particular is forced by `getCurrentWeekNum` only meaning anything for weekly semesters.
