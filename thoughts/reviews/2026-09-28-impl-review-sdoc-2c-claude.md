Read-only review complete. I read the full diff, the Phase 2C design (revision 6), the surrounding code, and — for the live-data step the design mandated — the latest production backup.

---

# Implementation review — SDOC Phase 2C (08af635 vs 44a5159)

## Verdict: **CHANGES NEEDED** — one HIGH (a pre-deploy data step, already provable), one MEDIUM (hostile-value crash), plus LOWs.

### What's faithful and correct

- **Stale-baseline semantics.** `v.detailsBase` is set only in `renderDayOffDetailsSection()` (app.js:12986-12992), which runs only on open and after this popup's own verified save. Ticks, material actions and the debounced reload write `v.plan` (app.js:13175) and never touch `detailsBase` — the exact re-basing hazard round 2 identified is closed.
- **Write shape.** One `tx.set(..., {merge:true})` with `FieldValue.delete()` sentinels, identity + `detailsEditId` only (firebase-data.js:2810-2816); the record-absent-and-both-empty no-op returns before any write. Camp read (`dayOffAssertCampHasTitle`) + `camp.yearKey` + `expected` compared inside the transaction, all reads before the write.
- **Read-back / ownership.** `verifyDayOffPlanWrite(..., 'detailsEditId')` is the generalisation the design asked for, not a copy; `null` → `renamed` + `dayOffInstallVerified(…, null)` + `scheduleDayOffReload(0)`; a different id → `savedSince`, never a failure. `dayOffInstallVerified` (firebase-data.js:2604) installs synchronously, so reading the new baseline from `currentDayOffPlans` is equivalent to `result.doc`.
- **Container lifecycle + view token.** `clearDayOffDetailsSection()` at Loading, on close; the token check `dayOffMaterialsView !== view` covers **both** the success and the `catch` arm (app.js:12955, 12960) — round 5's gap. Every save re-checks `box.dataset.for === campId|||title`.
- **XSS.** Clean at every path I traced. `escHtml` does *not* escape quotes, but all three details/vision sites are text contexts (`<li>`, `<div class="field-text">`, `<textarea>` — `<` escaped, so no `</textarea>` breakout); every attribute uses `sdocEscA`/`escAttr` inside double quotes; hrefs pass the `new URL()` http(s) gate and `.href` normalisation; no auto-linking of the vision. `CONTENT_FIELDS` (firebase-data.js:19) confirmed free of both new fields, so 2B's allow-list genuinely blocks a teacher write.
- **Summer untouched.** `isSummerNoPlanTitle` (app.js:4151) unchanged; the broadening is at the `isDayOffNoPlanTitle` wrapper only. `renderTeacherView` (app.js:1599) and `renderAdminGrid` (app.js:5053) branch to the SDOC renderers before the summer `linkifyText` sites (app.js:2166, 5453), so the new slot fields never reach them.

---

### HIGH — live "n/a" record is orphaned on deploy; two of Christie's material items disappear

`dayOffCampTitles()` now filters `n/a`, so **the record that already exists in production goes dark.** From `~/tinker-backups/tinker-backup-2026-09-28T17-27-54.json`:

```
camp fvrhezgd8AwIWk0N4xbD  "Northern Lights Canvas Painting"  2026-10-12
  projects: { block1: "Canvas Painting part 1", block2: "… part 2", openStudio: "n/a" }
plan  sdoc-2026-27|||fvrhezgd8AwIWk0N4xbD|||n__SLASH__a
  materialItems: { "Canvas" 12x16 unwrapped ×1 per camper,
                   "Uniposcas" ×1 per table — "to add final details/outlines/break up space" }
```

After this ships: no Materials button for it (app.js:12916), it drops out of `dayOffCampMaterialsSummary` (firebase-data.js:1972) so the camp's "N of M items ticked" and the event checklist shrink silently, and it leaves Teacher View. `saveDayOffCamp`'s orphan prompt filters *both* sides through `dayOffCampTitles` (firebase-data.js:2437), so `dayOffPlanHasUserData` no longer protects it on a project edit — only camp deletion's `campId` query still sees it. That is precisely the "data disappeared" shape CLAUDE.md warns about, and the design named this check ("re-check live data over every camp's projects map and every record title") as a build-time requirement.

**Fix before deploy, not in code:** snapshot to JSON, then either move those two items onto the project they belong to (they read as Canvas Painting materials) or retype that block as a real title — then re-run this scan. It is not a code defect; the code is correct and the data is not lost, but shipping without it makes real content vanish from the app.

### MEDIUM — `projectLinks` is trusted as an array in two renderers

`js/app.js:11499` (`sdocAboutHtml`) and `js/app.js:12921` (`renderDayOffMaterialsCell`) use `(lesson.projectLinks || []).length` / `.map(...)` with no `Array.isArray`, unlike `renderDayOffDetailsSection` (app.js:12989) and `dayOffPlanHasUserData` (firebase-data.js:2038), which both guard. The rules let any classbook user write any field of this collection — the gap the design states plainly — so a stored `projectLinks: "x"` makes `.map` throw inside `openPlanEditor`, and the teacher's whole plan editor fails to render (not just the About block). Fix: `const links = Array.isArray(lesson.projectLinks) ? lesson.projectLinks : [];` at both sites. D5 writes a valid array, so no test covers it.

### LOW

1. **Dead parameters.** `renderDayOffDetailsSection(plan, { status, error, keepTyped })` — `error` and `keepTyped` are never passed by either caller (a refused save keeps typed text by *not* re-rendering). Drop them (`/zero-tech-debt`).
2. **Close-confirm can lie.** Save in flight → Done is not disabled → `dayOffDetailsDirty()` is still true → "Discard the details you were typing?" → accept closes, but the write lands. Small window; either disable Done while `dayOffDetailsSaving`, or word it as "still saving".
3. **Stale comment.** `SDOC_BLOCKS` (firebase-data.js:1887-1888) still says only `"—" marks a block deliberately unused`; the design asked for both comment sites and only firebase-data.js:1911-1912 was updated.
4. **`savedSince` wording.** The status says "reopen to see them" while the section is immediately re-rendered *with* them (app.js:13013).
5. **`'A link is too long.'`** (firebase-data.js:2779) doesn't name the link, unlike the scheme message beside it.
6. **`#sdoc-details-vision`** is the only ID selector in the SDOC CSS; and the modal now has two `.simple-modal-body` blocks (20px padding each) — worth one look in the real app.

### Test gaps

- No test that an **ordinary** teacher plan save leaves `projectDetails`/`projectLinks` intact on the record. D8 only covers an explicit hijack payload; the design's BDD ("both are present") isn't exercised. This is the data-safety case that matters most and is cheap to add to T22.
- `projectLinks` is never tested against the 2B allow-list (only `projectDetails`), and the popup's `savedSince` status branch (app.js:13011) is untested.

I did not run `npm test` (read-only brief); the suite should be green before the deploy ask regardless.
