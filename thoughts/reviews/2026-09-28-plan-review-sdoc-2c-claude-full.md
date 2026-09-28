# Review record — Classbook SDOC Phase 2C, revision 1 (Sep 28 2026)

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html#phase-2c`
Code read-only @ `22ed027`. Rules: `/Users/christiehubley/studio-hub/firestore.rules:699-703`.

**Verdict: CHANGES NEEDED** (8 findings; the design's shape is right, the render path and the
writer's exists/not-exists split are not).

## Citations — verified
All cited symbols exist and point at the code the plan describes: `linkifyText` app.js:8206 ✓,
`isSummerNoPlanTitle` app.js:4148 ✓, Teacher View `title === '—'` app.js:1750 ✓,
`captureDayOffMaterialDrafts` app.js:12957 ✓, `DAY_OFF_PLAN_WRITABLE` firebase-data.js:2561 ✓,
`readDayOffPlan` firebase-data.js:2776 ✓. Two are 1–2 lines high (comment line, not the function):
`dayOffPlanHasUserData` is **2018** (plan says 2016), `isDayOffNoPlanTitle` is **2009** (plan says 2008).
Verified true: `CONTENT_FIELDS` (firebase-data.js:19) does **not** contain `projectDetails`, so the
allow-list isolation claim holds; the rename move copies the whole record (firebase-data.js:2461-2464);
`verifyDayOffPlanWrite` (2712) checks only written/cleared fields, so a concurrent details save cannot
break a teacher's save (BDD D7 holds); `dayOffRenamePairs` (2500) filters both sides through
`dayOffCampTitles`, so typing "n/a" over a project is a removal (prompted), not a silent move.

## Findings
1. **HIGH — the render path is quote-unsafe; the XSS BDD proves the wrong thing.**
   `linkifyText` (app.js:8206) = `escHtml` (app.js:8159) which escapes `& < >` only, then wraps
   `https?://[^\s<]+` in `href="$1"`. `https://x.com/"onmouseover="alert(1)` survives escaping and
   breaks the attribute → executes. The plan's payload (`<img onerror>`) is escaped, so D4 passes
   while the hole is open. Fix: render the vision as `sdocEsc(text).replace(/\n/g,'<br>')` — links
   live in `projectLinks`, nothing needs linkifying — or tighten the regex to `[^\s<"']+`, which also
   closes it for summer's `projectDetails`/`projectInspiration` (app.js:2166, 11514-11516). Change
   D4's payload to the quote vector.
2. **MEDIUM — `FieldValue.delete()` cannot ride in a plain `tx.set`.** The plan's writer splits
   update/set on existence and says an emptied field is a delete. Use one branch instead:
   `tx.set(ref, {...identity, ...}, {merge:true})` with delete sentinels, exactly as `saveDayOffPlan`
   (firebase-data.js:2681-2684) — safe because the camp read + `dayOffAssertCampHasTitle` is the lock.
   Also: no-op when the record is absent and both fields are empty.
3. **MEDIUM — no stale-editor guard; `projectLinks` is written whole.** Two planners in the same
   popup: B's Save silently drops A's link. Compare the record's current `projectDetails`/`projectLinks`
   inside the transaction against what the popup opened with (`dayOffMaterialsView.plan`) and refuse
   as the camp editor does (firebase-data.js:2445-2450). Add the BDD.
4. **MEDIUM — "read-back (readDayOffPlan) checks both fields landed" is false.** `readDayOffPlan`
   (firebase-data.js:2776) reads and installs; it verifies nothing (2A's writers don't verify either).
   Either call `verifyDayOffPlanWrite` (2712) with `{projectDetails, projectLinks}` or state the
   explicit comparison.
5. **MEDIUM — say where "About this project" goes.** The editor body is one ternary,
   `${sdoc ? sdocMaterialsHtml : <summer reference section>}` (app.js:11507-11519). The new section is
   a new `sdocAboutHtml` inside the `sdoc` branch. The plan's "the shared editor's reference section
   idea carries over" invites un-gating that section instead — which would render the same field name
   under summer's label plus `projectAdminNotes` (writable by any classbook user, rules:701).
6. **MEDIUM — the close-confirm will not fire.** `closeDayOffMaterials` (app.js:12950-12956) decides
   "typed" from `[d.name, d.qty, d.size, d.notes]` over `v.drafts`, and an unkeyed row lands at
   `'new'`. A details draft in the same bag is invisible to that test (and can collide). Use a separate
   `v.detailsDraft`, extend the typed test and the message. D2 asserts this, so it would be caught —
   after the implementer has already written it the wrong way.
7. **MEDIUM — name the helper per site.** `isDayOffNoPlanTitle` (firebase-data.js:2009-2013) delegates
   to `isSummerNoPlanTitle` whenever it exists; the literals live only in the dead fallback, so editing
   the fallback changes nothing in production — broaden the wrapper. Keep the validator's
   same-title-twice check (firebase-data.js:2224) on the broadened `isDayOffNoPlanTitle`: switching it
   to `isDayOffUnusedBlock` would start refusing "Open Studio" typed in two blocks of one day.
   app.js:1750 is the one site that takes `isDayOffUnusedBlock`.
8. **LOW — two "already true" claims, and one staleness.** `dayOffBlocksToFill` (firebase-data.js:1911)
   counts only absent blocks, so "n/a" already counts as filled — no change, but the comments at
   firebase-data.js:1888/1912 still say only "—". The admin list (app.js:12481) and camp-editor grid
   (12810) show titles raw and should keep showing "n/a" as typed — say so, so nobody "fixes" them.
   Once "n/a" is unplannable, a pre-existing record under that title leaves `dayOffCampTitles`, so the
   project-removal prompt (firebase-data.js:2422-2427) can never see it (camp deletion still can, via
   the campId query at 2525-2541). Re-run the no-such-record check at build time over each camp's
   `projects` map, not just record titles — the Sep 28 backup claim will be days stale.

## BDD coverage
D1–D12 would catch a partial implementation of the visible behaviour (marker, read-only for prep,
teacher section, delete-on-empty, rename carry, removal prompt, n/a in Teacher View + block counting).
Blind spots: finding 1 (wrong payload), finding 3 (no concurrent-planner case), the ≤5,000-char /
≤10-link / duplicate-drop limits, and a direct assertion that `DAY_OFF_PLAN_WRITABLE` refuses
`projectDetails`. Nothing in 2C touches summer or the rules; `no rules change` is correct
(rules:699-703 already allow create/update for `classbook`).
