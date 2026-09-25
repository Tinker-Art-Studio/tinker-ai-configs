**Verdict: Phase 2B revision 4 — CHANGES NEEDED (3 MEDIUM, 1 LOW).** All round-3 fixes are present and correct.

## Round-3 fixes confirmed
Edit-stamp read-back (own stamp strict / different stamp = later save wins, including clears and photo removal); SDOC branch placed after the stamping lines `firebase-data.js:1363-1364`, with a stampless payload throwing; both rename paths scheduling `scheduleDayOffReload()` while `{reload:false}` stays on the ordinary success path; the Save-call row with `{ dayOffAuth }`; stale `teacherMappings` falling through. New BDDs cover clear-vs-later-text, photo-removal-vs-replacement, injected own-stamp failure, planComplete stamping, two Alexes.

## The three named risks — checked, cleared
1. **Two saves sharing a stamp:** effectively no. Editor saves are serialized per lesson (`summerLessonSaveChains`, `app.js:11461-11470`), so a client can't race itself; a collision needs the same display name *and* the same millisecond.
2. **2A writers stamping the same doc:** no. `setDayOffMaterialCheck` writes only `materialChecks.<id>` (`firebase-data.js:2662`), `saveDayOffMaterialItem` only `materialItems.<id>` (`:2586`), sign-off is its own doc (`:2702-2722`). Only `saveSingleLesson` ever writes `lastEditedBy/At` → no spurious "different stamp".
3. **Round-trip:** `lastEditedAt` is an ISO **string**, so `JSON.parse(JSON.stringify())` (`:1390`) preserves it and `readDayOffPlan` returns raw `snap.data()` (`:2554`) — no Timestamp. Worth one plan sentence pinning "client ISO string, never `serverTimestamp()`".

## New findings

**M1 — MEDIUM — a no-op save writes nothing, but the verifier still runs and invents a rename.** `firebase-data.js:1381-1384`. SDOC payloads carry no identity fields, so "open, change nothing, Save" produces `{lastEditedBy, lastEditedAt}` only → the empty-save block returns without writing. The verifier "always runs", so a never-planned project (no doc) gets **"Saved — but this project was just renamed by the planner; reopen the camp"** plus a scheduled reload; an existing doc gets "Kathy has edited this since". **Fix:** return before the verifier when the empty-save block fires; BDD "Save with nothing changed → ✓ Saved, no message, no reload".

**M2 — MEDIUM — `written` must be computed after the strip and the photo translation.** The editor sends removal as `photoUrl:''/photoPath:''` (`app.js:11553-11554`, `:11587`), which the branch turns into `FieldValue.delete()`; the empty-content strip (`:1388-1389`) also drops fields. If `written` is the payload as sent, the round-3 strict arm ("every written value equals what was sent") fails every photo removal with "Save may not have completed" — contradicting its own BDD. **Fix:** state `written` = post-strip, post-translation payload minus clears; a removed photo pair counts as `cleared`.

**M3 — MEDIUM — the shared save chain still decides by clock, right after the verifier installs another client's copy.** `app.js:11605-11608` re-installs `savedLesson` whenever `editedAtOf(cache[lessonKey]) < editedAtOf(savedLesson)` — but the verifier has just rebuilt the whole slot map (`rebuildDayOffSlots`, `firebase-data.js:2098-2101`). In the benign "different stamp" arm with B's clock behind A's, A's copy overwrites B's freshly installed text and `{reload:false}` means nothing corrects it; in the missing-document arm, `editedAtOf(undefined) === 0` re-creates the deleted old-title slot. Round 3 took the clock out of the verifier; this is the same heuristic immediately downstream. **Fix:** skip `:11605-11608` (and the displaced-copy adoption) when `isDayOffYear(semKey)`, and note the exception in the editor-split table.

**L1 — LOW — the "edited since" message can name the signed-in user herself** (second tab; `lastEditedBy` is a display name). Use a different wording when it equals my own name.

Full write-up with evidence: `/Users/christiehubley/.claude/plans/plan-review-round-sequential-wadler.md` (plan mode blocked writing to `~/tinker-ai-configs/thoughts/reviews/` — say the word and I'll copy it there).
