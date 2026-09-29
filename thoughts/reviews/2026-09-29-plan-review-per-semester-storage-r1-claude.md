I read the plan in full and verified its claims against the code. Here's what holds and what doesn't.

## Verdict: **NOT execution-ready**

The research is unusually careful — every `lessonStoreFor` citation is exact (`firebase-data.js:64-72`; callers `:811, :1387, :1479`, `app.js:3636, 5848, 7155, 7240`), and the 13 `doc('lessonData')` sites in the reader/writer table match the grep exactly. But there are four defects that lose or hide lesson data, one internal contradiction that blocks the only phase that frees space, and a materially wrong safety citation.

---

## 1. Data safety of Phases 3–4

**A. The listener will blank Spring in every open tab, every few minutes.** `firebase-data.js:1186` does `currentLessonData = doc.data()` — it *replaces* the whole model with the legacy document's contents. The only maps carried across are camp seasons, via `snapshotCampSeasons()` at `:1094-1100`, which filters on `isCampSeason(k) || isDayOffYear(k)`. A migrated **weekly** semester matches neither predicate, so it is dropped on every legacy snapshot.

Failing input: Spring migrated, Fall still legacy. A Fall teacher saves a lesson → legacy snapshot fires → `currentLessonData['spring-2026']` becomes `undefined` in every tab until the `lessons_spring-2026` listener happens to re-fire (it won't; nothing changed there). Spring renders empty. This is the May 2026 incident reproduced on a schedule. The plan's "the live listener follows the same split" doesn't cover it.

**B. Phase 3's verification produces false mismatches that discard real edits.** Step 3 requires `lessons_K` to deep-equal the transaction's source map. But the moment the transaction commits, the fence is live and *all* legitimate saves go to `lessons_K`. Manager clicks Move at 4:00:00; a teacher's save lands in `lessons_K` at 4:00:01; verify reads at 4:00:02 → not equal → loud alert → manager clicks "Move back" → the app reads `lessonData[K]` again and that 4:00:01 edit is orphaned in a document nothing reads. The verify needs to be "every source key present and equal-or-newer by `lastEditedAt`", not deep-equal.

**C. Phase 4's precondition contradicts Phase 3 and will refuse forever.** Phase 4 refuses unless `lessonData[K]` deep-equals *the Phase 3 snapshot*. Phase 3's own BDD says: "a lesson is saved between the snapshot and the transaction → the transaction copies the newer data; the snapshot is older." So one autosave in that window makes the two permanently unequal, and the only phase that actually frees space can never run. Phase 4 must compare against **what the transaction wrote**, persisted at move time — not the pre-transaction download.

**D. Phase 4 silently empties Spring for every tab open at the time.** `setupConfigListener()` is **never called** (`app.js:11328` says so explicitly, and the grep confirms zero callers). So an open tab's `currentConfig` is frozen at load. Post-move it keeps `lessonStoreFor(K) === 'weekly'`, keeps reading `lessonData[K]`, and has no `lessons_K` listener. That's fine for writes (the fence catches them — this is the design working), but on Phase 4's delete the legacy snapshot arrives with `K` gone → Spring goes blank with no error. The plan's claim that teachers see nothing beyond "one reload error on save" is wrong for Phase 4, and understated for Phase 3 (reads silently stop tracking other people's edits from the instant of the move).

**E. A new-style semester's first save throws `not-found`.** `update()` on a non-existent document fails. `saveSingleLesson` (`:1438`), `saveMultipleLessonFields` (`:1500`), `deleteLessonKey` (`:830`) have no `not-found` fallback, unlike `savePrepWeekData` (`:562-572`) and `updateAppData` (`:233-238`). Today this is unreachable because `lessonData` always exists. Failing input: admin creates "Spring 2027" *without* Copy-from (writes no slots), a teacher types a plan → `lessons_spring-2027.update(...)` → `FirebaseError: NOT_FOUND` → "Error saving lesson".

**F. `createNewSemester` writes the copied slots to the wrong document.** `saveLessonData(key, emptyLessons)` runs at `app.js:4965`; `currentConfig.semesters[key] = newSem` (carrying `lessonStore:'doc'`) is not assigned until `:4980`. `semesterTypeOf`/`lessonStoreFor` read `currentConfig.semesters[semKey]`, so at write time the new key is still `'weekly'` → the slots land in `curriculum/lessonData`, the new semester reads an empty `lessons_key` and shows zero lessons, and the shared document you're shrinking gains dead weight. The compensating `deleteLessonData(key)` at `:4994` has the same problem in reverse.

---

## 2. Reader/writer completeness — **no**

The 13 in-app `doc('lessonData')` sites are complete and correct. Everything else in the app (prep dashboard, diagnostics, material forecasts, change history) reads `currentLessonData` in memory, which is why finding A is the load-bearing risk. Missing from the plan:

| Missing | Where | Why it matters |
|---|---|---|
| `computeClassbookContentByTeacher` | `tinker-backups/backup.js:370-389`, → `backupStatus/latest` at `:471` | The automated per-teacher content-loss detector reads **only** `curriculum/lessonData` (`:382`). After Phase 4 it goes permanently blind to Spring, and on the first run after the delete every teacher trips the 10% drop alarm. `curriculum` is also Tier-1 (`:38`). Per your `backup-js-uses-cli-token` memory an agent must not touch this file — so it's your edit, and the plan has to say so. |
| `renderContentCount()` | `app.js:7578-7600` | Same blindness in-app: `computeLiveContentCountByTeacher` (`:7518`) vs `backupStatus/latest.classbookContentByTeacher` (`:7588`). Both sides go blind; there's a window where live has dropped and the baseline hasn't. |
| `studio-hub/test-alerts.js:98, 143` | Admin SDK writer of `curriculum/lessonData` (the `qaData` key in the plan's doc shape) | Bypasses rules entirely, so "enforced on the server for every role" isn't literally true. |
| `backupLessonData` / `restoreFromBackup` | `firebase-data.js:979-1002` | No callers anywhere (dead), but in the ratchet's path. Also: `lessonData_backup` shares the same 1 MiB cap — Spring (551 KB) + Fall (420 KB) would fill it too. |
| e2e direct writers | `data-safety.spec.js:3079, 3203, 4434, 4546`; `day-off-teacher.spec.js:530`; `day-off-camps.spec.js:58, 706` | The Phase-1 ratchet ("no `doc('lessonData')` outside the helper") must exempt `e2e/`, or the suite won't build. |
| `e2e/fixtures/seed/curriculum.json` | 5,269 bytes | Needs a `lessons_K` fixture for Phase 1's BDD. |

**Wrong citation with safety consequences:** the plan says "The nightly backup copies the whole `curriculum` collection", citing `summer-camp-app/scripts/backup-firestore.js:39`. That file's own header (lines 9–16) says: paste into a browser console on localhost, *"RECOMMENDED: Run once a week."* It is neither nightly nor automated. The conclusion is still true — `tinker-backups/backup.js` does back up `curriculum` (`:38`, `:56`) — but Phase 4's "Reversible: the snapshot plus the nightly backup" is resting on the wrong artifact.

**Also missed — `deleteSemester` breaks for migrated semesters.** `app.js:4585` calls `deleteLessonData(key)` = `update({K: delete})` on `lessonData`. Under Phase 2's stated exception ("a **manager** update that only deletes exactly that key"), a `classbook-admin` deleting a migrated semester is denied — a capability they have today (`firestore.rules:675-678`). And `curriculum/lessons_K` is left orphaned either way.

---

## 3. Phase 2 rules design

**The mechanism is sound.** `request.resource.data` on an `update` is the post-write merged document, `diff().affectedKeys()` reports added/removed/changed **top-level** keys, so a dotted write to `spring-2026.x.qaThread` surfaces as `spring-2026`, and a stale tab re-*creating* the key after Phase 4 also surfaces as `spring-2026`. That part works.

**Three problems:**

- **"Narrowing the manager catch-all" is not a narrowing.** `firestore.rules:654` is `allow read, write: if isManagerOrAbove();` and `:666` is a separate `allow create, update`. Rules OR across statements, so you cannot add a condition — you have to split `:654` into separate `read` / `create` / `update` / `delete` statements. The blast radius is contained (only the Classbook and Studio Hub's read-only alerts touch `/curriculum`), but it's a bigger edit than the plan implies, in the file that governs every staff app.

- **Drop the `get(appData)`.** It costs `exists()` + `get()` = two extra billed document reads and a round trip on *every* teacher lesson save; `get()` on a missing doc returns null and `.data` on null denies, so the "behaves as an empty list" BDD needs explicit `exists()` guarding; and — worst — it makes the fence depend on a document managers can write, so "Move back" or a stray appData edit silently disarms it. There are exactly two semesters to migrate. Put the literal in the rule: `!...affectedKeys().hasAny(['spring-2026'])`. One extra rules deploy for Fall, which Phase 5 already plans for. The fence then can only be changed through the guard + sha phrase, which matches your posture everywhere else.

- **Rules test coverage is zero and the fixtures prove nothing about the real document.** `studio-hub/rules.test.js` has no `curriculum/lessonData` fixture at all — it uses `curriculum/spring-2026` seeded as `{ title: 'Spring Curriculum' }` (`:264`), and the Classbook seed is 5.2 KB. Every Phase 2 test would be new, and a green suite says nothing about `diff()`/`affectedKeys()` materializing a 972 KB document on every save. That has to be proven against a near-cap fixture in the emulator before deploy, not assumed.

---

## 4. Loading and listeners

Beyond finding A:

- **`setupLessonDataListener` is called twice** — `app.js:676` (Today View) and `app.js:5038` (Curriculum Admin). Teardown is a single `lessonDataUnsubscribe` (`firebase-data.js:1116`). Per-semester listeners need an array and an all-unsubscribe, or the Today View's callback keeps firing alongside the Admin one.
- **The generation counter is a trap.** `globalListenerGeneration` (`:303`) is bumped by every legacy snapshot (`:1181`) and gates the summer reload; a superseded reload returns `'stale'` and never sets `lessonDataLoadedSuccessfully = true` (`:1131, :1143-1145`). On first load you'd subscribe legacy + Spring + Fall and get three near-simultaneous first snapshots. If the per-semester listeners bump the generation, the legacy listener's in-flight summer reload goes stale → the flag never flips → the red banner stays up and **every writer in the app refuses**. If they don't bump it, a per-semester permission error is silent. The plan doesn't decide this, and it's the most likely way to ship an app-wide outage.
- **Cost is a genuine win.** Today one listener re-sends ~972 KB on every change anywhere; after the split, a Fall save re-sends 420 KB and Spring's tab-load cost drops. `readAdminLessonDoc` (`app.js:5835`) does a forced-server full-document read per existence check — that gets cheaper too, once both semesters are out.

---

## 5. Ordering, and a faster path

**The ordering is right but the relief is last, and there's no headroom instrumentation.** Nothing is freed until Phase 4, which sits behind: a large Phase 1 refactor + one Netlify deploy + one Studio Hub deploy → a shared rules change + sha approval + deploy → new manager UI with a transaction → a production run → "a few days" → Phase 4. Realistically one to three weeks against 52 KB of headroom, while Fall is actively being written into the same document. Meanwhile the only headroom monitor is "run a console snippet every few days" — a human polling loop.

**The emergency lever as written is the May 2026 incident, on purpose.** "Spring would show as empty in the app until Phase 1's code is live" — on the studio's largest semester, with no code that can read the new location, at the exact moment everyone is already stressed. It should never be pulled in that order.

What I'd recommend instead, and it's mostly a scoping change rather than a redesign:

1. **Narrow the first pass to Spring, hard-coded.** Spring 2026 ran Jan–May; it is finished and nobody edits it. Drop `migratedSemesters`, the `lessonStore` config flag, the appData `get()` in rules, "Move back", and both manager buttons. Phase 3 becomes a one-off snapshot + copy + verify (the same manual, console-driven shape you already use for migrations), not a new transaction-plus-two-buttons UI surface that is itself new code capable of losing data. Generalize for Fall in Phase 5, where the second semester justifies the abstraction.
2. **Ship the rules fence for `spring-2026` first, before any code.** It's ~6 lines plus tests, one sha approval, and it breaks nothing — Spring is dormant. It also stops Spring growing while the rest lands.
3. **Add a headroom readout to the admin Diagnostics panel in Phase 1** (client-side, read-only), so 52 KB isn't tracked by a human remembering to paste a snippet.
4. **Fix the emergency lever's order**: read-side code first, *then* copy, *then* delete. Never delete before the app can read the new location.

---

## Minimum list to reach execution-ready

1. Listener: migrated weekly semesters must survive `currentLessonData = doc.data()` (`firebase-data.js:1186`) — extend or replace `snapshotCampSeasons()` (`:1094-1100`), and decide explicitly whether per-semester listeners bump `globalListenerGeneration` and whether they may touch `lessonDataLoadedSuccessfully`.
2. Per-semester listener teardown: array + unsubscribe-all, for the two `setupLessonDataListener` call sites (`app.js:676`, `:5038`).
3. Phase 3 verification: equal-or-newer by `lastEditedAt`, not deep-equal, and persist the transaction's source map (or hash) as the record.
4. Phase 4 precondition: compare against what the transaction wrote, not the pre-transaction snapshot. As written it can never run.
5. Phase 4 read-side: an open tab must not silently blank. Either poll/verify `appData` before trusting a missing key, or make the legacy listener treat "a semester I was rendering just vanished" as a loud reload prompt.
6. `not-found` fallback on the first write to a non-existent `lessons_K` (`saveSingleLesson`, `saveMultipleLessonFields`, `deleteLessonKey`), matching `savePrepWeekData:562-572`.
7. `createNewSemester`: set the new semester's config *before* `saveLessonData` (`app.js:4965` vs `:4980`), and route `deleteLessonData` / `readServerSemesterLessonMap` by store.
8. `deleteSemester` for a migrated semester: delete the `lessons_K` document, keep `classbook-admin` able to do it, and clean up the migration record.
9. Rules: replace the `get(appData)` design with a literal semester key; state that `:654` must be split into per-operation statements; add the Phase 2 cases to `studio-hub/rules.test.js` (which has no `lessonData` fixture today) **including one near-1 MB fixture**.
10. Add the missing readers/writers to the plan and say who fixes `tinker-backups/backup.js:370-389` — and correct the backup citation and the word "nightly".
11. Re-scope to one hard-coded semester for the first pass; add a headroom readout; fix the emergency lever's ordering.

Two smaller ones worth folding in: the ratchet must exempt `e2e/`, and the safety checklist's "No whole-lesson `set()`" is inaccurate — `saveLessonData` (`:817`) is a whole-*semester* merge-set and becomes a whole-*document* merge-set, reached from `createLessonSlotsForRoster` on every Settings save.

I haven't changed any files. Want me to write this up as a review artifact you can link alongside the plan?
