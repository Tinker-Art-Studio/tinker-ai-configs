# Plan review — round 4 (confirmation), Classbook SDOC Phase 2B revision 4

Plan: `~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html` § `phase-2b` + top Decisions Log.
Code read-only @ `2894adf`; rules `/Users/christiehubley/studio-hub/firestore.rules`.
Scope: confirm the round-3 fixes; report only NEW HIGH/MEDIUM problems those fixes introduce.

## Verdict — **CHANGES NEEDED** (3 MEDIUM, 1 LOW). Everything else confirmed.

## Round-3 fixes — all present and correct
- Edit-stamp read-back (own stamp → strict; different stamp → later save wins, **including cleared fields
  and photo removal**), replacing the clock comparison — plan ¶ "Forced read-back".
- SDOC branch sits after the stamping lines `firebase-data.js:1363-1364`, not merely after the load guard
  (`:1358`), so the narrow `{planComplete}` write (`app.js:2119`) carries a stamp; a stampless payload throws.
- Both rename paths (title-missing refusal, missing-document read-back) schedule `scheduleDayOffReload()`;
  `{reload:false}` is limited to the ordinary success path.
- Editor-split table has the Save-call row with `{ dayOffAuth }` computed at save time.
- Stale `teacherMappings[uid]` falls through to matching when the mapped name is not in the year's pool.
- BDDs added for clear-vs-later-text, photo-removal-vs-replacement, own-stamp injected failure,
  planComplete stamping, and the two-Alex resolver.

## The three risks named in the brief — checked, cleared
1. **Two saves sharing a stamp?** Effectively no. The stamp is `name + new Date().toISOString()`
   (`firebase-data.js:1363-1364`). Editor saves are serialized per lesson via `summerLessonSaveChains`
   (`app.js:11461-11470`), so a client cannot race itself; a collision needs the same display name **and**
   the same millisecond (same user, second tab). Note `lastEditedBy` is a display name, not a uid — see LOW.
2. **Do 2A writers stamp the same doc?** No. `setDayOffMaterialCheck` writes only `materialChecks.<id>`
   (`firebase-data.js:2662`); `saveDayOffMaterialItem` only `materialItems.<id>`, identity-only on create
   (`:2586`); reorder writes only `order`; sign-off is its own `#signoff` doc (`:2702-2722`). Nothing but
   `saveSingleLesson` touches `lastEditedBy/At` on a plan doc → no spurious "different stamp" from 2A.
3. **Does the compare survive the round-trip?** Yes. `lastEditedAt` is an ISO **string**, so
   `JSON.parse(JSON.stringify(stripped))` (`:1390`) preserves it and `readDayOffPlan` returns raw
   `snap.data()` (`:2554`) with no Timestamp conversion — `===` is sound. Add one plan sentence pinning
   "a client ISO string, never `serverTimestamp()`", or the compare silently breaks later.

## New findings

### M1 — MEDIUM — a no-op save writes nothing, but the verifier still runs and invents a rename
`firebase-data.js:1381-1384` (plan: "Same empty-save block"). SDOC payloads carry **no identity fields**
(plan: "none from the editor"), so open → change nothing → Save produces `{lastEditedBy, lastEditedAt}`
only: the empty-save block returns without writing. The verifier "always runs", so:
- project never planned (no doc) → `readDayOffPlan` → `null` → **"Saved — but this project was just renamed
  by the planner; reopen the camp"** plus a scheduled reload, for a save that did nothing;
- doc exists → stamp differs from the never-written one → "Saved — Kathy has edited this plan since".

**Fix:** `saveDayOffPlan()` returns before the verifier when the empty-save block fires (nothing was written,
so there is nothing to verify). BDD: "Save with nothing changed → ✓ Saved, no read-back message, no reload."

### M2 — MEDIUM — the `written` set must be computed after the strip and the photo translation
Plan: strict arm = "every written value must equal what was sent". The editor represents photo removal as
`photoUrl:'' , photoPath:''` in the payload (`app.js:11553-11554`, `:11587`), and the SDOC branch translates
that pair into `FieldValue.delete()`; the empty-content strip (`firebase-data.js:1388-1389`) likewise drops
fields from the write. If `written` is taken from the payload as sent, every photo removal by the sole editor
reads back **absent** and fails strict verification — "Save may not have completed" — contradicting the
round-3 BDD that requires absence.

**Fix:** state that `verifyDayOffPlanWrite(ref, written, cleared)` takes `written` = the post-strip,
post-translation payload minus clears, and that a removed photo pair counts in `cleared`, not `written`.

### M3 — MEDIUM — the shared save chain still decides by clock, right after the verifier installs someone else's copy
`app.js:11605-11608`: after `saveSingleLesson` resolves, the chain re-installs its own `savedLesson` whenever
`editedAtOf(cache[lessonKey]) < editedAtOf(savedLesson)`. For SDOC the verifier has just replaced the whole
slot map — `readDayOffPlan` installs, `dayOffInstallPlan` → `rebuildDayOffSlots` rebuilds
`currentLessonData[yearKey]` wholesale (`firebase-data.js:2098-2101`). Consequences:
- benign "different stamp" arm with B's clock **behind** A's: A's copy overwrites B's freshly installed text
  in memory, and `{reload:false}` means nothing corrects it — the teacher is told "reopen to see her changes"
  while the list still shows A's;
- missing-document (rename) arm: `editedAtOf(undefined) === 0`, so the deleted slot is **re-created** under
  the old title (the M1 reload clears it, but only after it renders).

Round 3 took the clock out of the verifier; this line is the same heuristic immediately downstream of it.
**Fix:** skip `:11605-11608` (and the failure-path displaced-copy adoption) when `isDayOffYear(semKey)` — the
verifier's installed server copy is authoritative — and add the exception to the editor-split table row for
"Save chain… shared, one copy". BDD: A saves, B's save lands with an earlier client clock → after A's save
settles, the slot holds B's text.

### L1 — LOW — the "edited since" message can name the signed-in user herself
`lastEditedBy` is a display name. Same user in a second tab (or the list's Plan-complete write racing an
editor save) yields "Saved — Fixture Teacher has edited this plan since". **Fix:** when the server
`lastEditedBy` equals my own name, say "This plan was saved again from another window — reopen to see the
latest."

## Not changed
Verdicts on Phase 2A.1 (READY) and the Decisions Log entries stand from round 3.
