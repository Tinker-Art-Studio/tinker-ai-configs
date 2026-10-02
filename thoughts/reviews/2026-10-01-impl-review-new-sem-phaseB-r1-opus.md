# Implementation review: new semesters in their own document, Phase B + B' (round 1, Opus)

Classbook 7873077 + f3f744e (worktree new-semesters-own-doc). Studio Hub alerts 0673e40. Rules f9b1123 + 56a274a, read for context only.

## Verdict: SAFE TO DEPLOY

I found no path that writes a new semester into `curriculum/lessonData`. No path writes an own-doc semester outside the 'editable' state, except the two creation transactions, which are creation by design. No path overwrites existing lessons with stale or blank data, and Fall 2026 and Spring 2026 are not affected. All findings below are Low or Info. Only #1 and #2 are worth fixing before Spring 2027 gets real use, and neither one blocks the deploy.

## What I verified (evidence)

- **Lesson writers.** Every one goes through `weeklyLessonTarget` (js/firebase-data.js:182-190). That covers saveSingleLesson, deleteLessonKey (:1214), addMissingLessonSlots (:1193), the Q&A writers (:1929, :1984), and the app.js callers (:3766, :7267, :7356).
  - The only direct `lessonData` writers left are saveLessonData's legacy branch (:1177, reached only when `!isOwnDocSemester`) and deleteLessonData (:1355, refused for own-doc at :1349).
  - `isOwnDocSemester` is now "weekly and not in the legacy list" (:83). An unknown or new key therefore defaults to its own document, and its state is 'unknown', so the write is refused.
  - No leftover references to OWN_DOC_SEMESTERS, OWN_DOC_PAUSED_MESSAGE or ownDocUnsubscribes.
- **saveLessonData's whole-map merge.** Its only remaining caller is restoreFromBackup (:1391), and nothing calls that. backupLessonData is also unused.
- **createWeeklySemesterStorage (:363-384).**
  - Inside one transaction it reads appData and the document, then refuses if appData is missing, the key is already in the server config, or the document exists.
  - The refusals throw inside the transaction, so it aborts with no retry and no partial state.
  - It checks the key pattern and the legacy list up front, and createNewSemester checks both again (app.js:4966-4978).
  - After the commit: `currentConfig.semesters[key]` is set, then installOwnDocMap, then reconcile (app.js:5073-5076). This happens only after `await` resolves; the catch at :5060 leaves the tab untouched.
- **addMissingLessonSlots (:1188-1207).** It runs weeklyLessonTarget before the transaction (refused unless editable), reads on the server, writes only absent keys with dotted paths, and refuses a missing document.
  - Lesson keys are `[a-z0-9-]` only (app.js:11583), so the dotted paths are safe.
  - createLessonSlotsForRoster is gated to weekly semesters (app.js:11523), and saveSettings is gated by refuseIfWeeklySemesterPaused before any write (app.js:11372).
- **ownDocStorageState (:133-150).** It matches the table:
  - A null migration state gives 'unknown'.
  - A document that vanished with no record gives 'error'.
  - Absent with a verified or malformed record gives 'error'.
  - 'rollback' requires an unverified record plus a lessonData copy.
  - The button appears only for 'missing' and admin/manager (:281), and createOwnDocStorage re-checks the state and refuses an existing document inside its transaction (:298-313).
- **Spring 2026 (moved, verified).**
  - Load: 'ownDoc' plus the verified record gives 'editable'.
  - lessonData snapshot: the map is carried across (:1608-1612).
  - Vanish: it becomes 'vanished', the record is verified, so the state is 'error'. The screen keeps the lessons and shows the notice; nothing is blanked (:1609-1613).
- **Fall 2026 (legacy).** It routes to lessonData with the `fall-2026.` prefix and is not affected by any own-doc path. Its slot writes are now targeted (tested at new-semester-own-doc.spec.js:197-203).
- **Studio Hub (alerts.js:647-673).**
  - Each snapshot replaces the set. Ids pass through `classbookOwnDocSemKey` (the regex plus legacy exclusion, classbook-qa-alerts.js:29-33), and `buildClassbookQaAlerts` excludes legacy keys again.
  - Degraded-before-first and keep-last-on-error behave as before. Dismissals (legacyId) are unchanged.
  - The query is allowed by the rules: curriculum reads don't depend on docId (firestore.rules:739, :751).
- **Tests.**
  - The old "copy-from pre-check" and "recovery by re-creating over leftovers" cases are now covered by the "existing document refused, untouched" case (new-semester-own-doc.spec.js:146-156).
  - R4-11 now exercises a real transaction that the rules deny, and checks that neither document exists.
  - The ping through fall-2026 still lands on lessonData, as the listener tests need.
  - The stub moved from saveLessonData to addMissingLessonSlots and keeps the R4-12 "nothing cached before persistence" assertion.
  - Nothing that still applies has been weakened.

## Findings

1. **Low: a config weekly semester whose lessons are still in lessonData would show as "missing", empty, with "Create its storage" offered.**
   - Where: ownDocStorageState :146 returns 'missing' for "absent and no record" without checking `lastLegacyLessonData`. The carry-over at :1610-1612 then deletes the fresh legacy map (`else delete currentLessonData[semKey]`).
   - If any weekly config semester other than fall-2026 still has lessons in lessonData (an inventory miss, or an older semester someone re-adds), it would look empty, and a manager could create a blank document that hides the real lessons.
   - Production per the inventory: none.
   - Fix (defensive): in ownDocStorageState, `if (!hasRecord && src === 'absent' && lastLegacyLessonData && hasOwn(lastLegacyLessonData, semKey)) return 'error'`. In the carry-over, only delete when lessonData has no copy.

2. **Low: after a storageMigrations listener error, the 'unknown' state never recovers, and the notice wrongly says "still loading — try again in a moment".**
   - Where: :568-572 sets the state to null. onSnapshot errors are terminal, so every own-doc semester (Spring and Spring 2027) stays read-only until a reload, while the message at :160 implies it will clear by itself.
   - Fix: track a `storageMigrationsFailed` flag and show "couldn't be checked — reload the page" for unknown-after-error.

3. **Low: the carry-over treats an unknown migration state as "no record".**
   - Where: `hasRecord` (:1606) is false when `storageMigrationState === null`. A semester that is 'absent' and in rollback would therefore have its lessonData copy deleted from view (:1610-1612).
   - This can't happen in production: Spring is verified, verified is one-way, and new semesters never get records.
   - Fix: when the state is null, keep `previousOwn ?? doc.data()[semKey]`.

4. **Low: the Classbook content count doesn't filter ids the way Studio Hub does.**
   - Where: app.js:7615-7618 adds `own.id.slice(8)` for every `lessons_*` document. A stray `lessons_fall-2026` (the rules allow a manager to create it: isNewLessonsDoc only excludes spring-2026, firestore.rules:687) would make Fall count from the stray document and skip lessonData.
   - Fix: apply the same regex and legacy exclusion as `classbookOwnDocSemKey`.
   - Optional: also exclude legacy keys in the rules' isNewLessonsDoc.

5. **Low: "copy from" an own-doc semester that isn't loaded silently creates zero slots.**
   - Where: app.js:5025 uses `currentLessonData[copyFromKey] || {}`. Only `lessonDataLoadedSuccessfully` is checked, so a source in 'error' or 'unknown' produces a semester with the roster copied but no slots.
   - The planned copy is from Fall (legacy), so this doesn't affect it.
   - Fix: if `isOwnDocSemester(copyFromKey) && ownDocStorageState(copyFromKey) !== 'editable' && !== 'paused'`, refuse with "reload first".

6. **Info: addMissingLessonSlots has no type guard of its own.** It relies on its only caller's weekly gate (app.js:11523). For a camp key it would route to `lessonData` with the `summer-2026.` prefix, which the rules would refuse. Fix: add `if (lessonStoreFor(semesterKey) !== 'weekly') throw` at the top (defence in depth).

7. **Info: stale pre-deploy tabs.** A tab running the old JS shows Spring 2027 as empty (it treats it as legacy), and every write from it is denied by the Phase A rules (`noNewLessonDataKeys`). A no-copy create from an old tab leaves a config-only semester, which the 'missing' path and "Create its storage" handle. Ask staff to reload after the deploy.

8. **Info: Studio Hub cost.** The range listener reads every `lessons_*` document, each up to 1 MiB, on every Studio Hub load, and this grows by one document per semester. That's acceptable now; revisit with the Phase E retention work.

9. **Info: tests.**
   - Nothing tests "rollback, then a later lessonData snapshot", or the storageMigrations listener error mid-session (#2, #3).
   - The Studio Hub alert tests mock `FieldPath` and never run the real range query against the emulator. The Classbook content-count spec (:311) does run it under the rules for a manager, so the query shape is proven.
