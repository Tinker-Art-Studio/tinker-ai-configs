# Verdict: CHANGES NEEDED — 1 HIGH, 4 MEDIUM, 2 LOW

Read-only design is sound (no new fields/writers/collections/rules; correct reuse of `buildDayOffSlots`, `dayOffCampTitles`, `calculateLessonProgress`, `openPlanEditor`). The problems are in the refresh path, the freshness story, and two counting/formatting specs. Full review written to `/Users/christiehubley/.claude/plans/plan-review-replicated-emerson.md`.

**1. HIGH — `refreshDayOffYear()` is ungated; a slow refresh reverts newer data and stamps it "as of now".** `loadDayOffCampData()` defaults `isCurrent = () => true` (`js/firebase-data.js:2120`, `:2144-2149`) and installs the four caches wholesale. The listener's reload *is* generation-gated (`:1123`, `:1130`), fires on every `curriculum/lessonData` snapshot and redraws the grid (`js/app.js:5040-5041`). A refresh issued first but resolving last overwrites it — a teacher's save from another device, a camp another planner removed — then paints the newest time on the oldest data. The install-sequence protection (`:2139-2143`) only covers *this tab's* verified saves, so "a refresh racing the listener's reload is harmless" is false for exactly the case Phase 3 exists to show. Fix: pass an `isCurrent` token, or call the gated `summerReloadHook()`/`reloadSummerForModeChange()` (`:1107-1110`, `:1164-1169`). Also state what `previous` goes to `mergeSummerReload()` — omitted, it returns at `:1053`.

**2. MEDIUM — the load-guard sentence contradicts itself.** Today's loads *do* trip it (`reloadSummer`'s catch sets `lessonDataLoadedSuccessfully = false` + banner + retry, `:1146-1158`). Swallowing the error inline leaves the admin list **writable** (`js/app.js:12520`) over stale figures on a rules regression — the "data disappeared" class. Trip the guard *and* show the inline message.

**3. MEDIUM — no hook exists for "re-read when Curriculum Admin is opened".** The only per-tab hook is `initCurriculumAdmin()` (`js/app.js:218-219`), which is `if (caInitialized) return;` (`:5015-5016`) — once per page load. Name the tab click handler (`:205-222`) and the semester-change branch (`:132-138`). Add a BDD pinning one refresh per entry, zero per tick.

**4. MEDIUM — "dates via `formatDayOffDate`" prints `lastEditedAt` raw.** It parses `` `${iso}T00:00:00` `` (`js/firebase-data.js:2005-2008`); `lastEditedAt` is a full ISO timestamp (`:1371`), so it returns the input unchanged — "last edited by Mariah, 2026-10-05T14:22:31.123Z". "Malformed is not shown" won't catch it. Slice to 10 chars; assert the rendered form.

**5. MEDIUM — roll-up counting unspecified for one title in two camps of an event** (2A.1 says that's two records/two plans). Say "per (campId, title)" and add the BDD; the current three-distinct-titles scenario passes either implementation.

**6. LOW — three pills, four labels.** `getProgressLabel` has `'ready'` → "Almost Done" (`js/app.js:929`, `:937`); unreachable for SDOC only because `campName` zeroes `hasMaterials` (`:922-924`, `js/firebase-data.js:2088`). Say so; reuse `getProgressLabel()`.

**7. LOW — freshness.** The three queries use plain `.get()` (`:2126-2128`), unlike `dayOffServerDocs` (`:2114`); offline it falls back to cache and stamps a new time on old data. And the listener refreshes the same data without moving the stamp.

**Verified correct:** all three cited line numbers resolve; `finishClose` (`js/app.js:12180-12184`) does call `renderTeacherView()` then `onClosed?.()`, and since `getAdminSemKey() === getTvSemKey()` it takes the SDOC branch — the `syncDayOffTeacherPicker` note is accurate and mild (`:1706-1707`). `canEditDayOffPlan`'s `slot.yearKey` fallback is safe (`js/firebase-data.js:2083`). Unused/no-plan exclusion is right. XSS handling is sound — but note `escAttr` escapes `"` and not `'` (`js/app.js:8149-8151`), so the "data-attribute, never `onclick`" rule is load-bearing: the existing buttons at `:12562-12577` interpolate auto-IDs into single-quoted `onclick`s, and a project title there would break out on an apostrophe. Worth a sentence in the plan.

**BDD vs a partial implementation:** it would not catch F1, F3, F4 or F5 — one scenario each.
