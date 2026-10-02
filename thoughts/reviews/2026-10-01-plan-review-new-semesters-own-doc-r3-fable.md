**Verdict: READY WITH FIXES.** Every round-2 finding is fixed, the Codex r2-5 refusal holds for the code that will be deployed, and the new revision-3 material is correct against the actual code and rules. The fixes below are minor specification gaps; none needs a redesign, and nothing should be cut for Oct 5.

**Round 2, checked.** Codex 1/Fable 3 (one PR against the Phase A branch, A → Classbook → rules → Classbook deploy): the order is right, and the window where Classbook main is red is stated. Codex 2/Fable 2 (no adopt path): refusal plus the byte-for-byte port of `data-safety.spec.js:4234-4236`. Codex 3/Fable 1 (rollback un-fenced): `firestore.rules:739-741` stays as deployed; `rules.test.js:2722` keeps passing. Codex 4 (state table): present. Fable 4 ("Create its storage"): replaces the config-only delete; the create rule admits it because `getAfter(appData)` already holds the key. Codex 6, Fable 5-10: all in. Codex r2-5 evidence verified: the eight `updateAppData` call sites are all per-semester dotted paths, the only whole-doc write is the merge-set fallback for an absent appData at `firebase-data.js:374`, and the only entry removal is `app.js:4663`, behind the own-doc refusal at `:4624`.

## Findings

1. **Minor — the r2-5 rationale is true for new code but silent about stale tabs.** A pre-deploy tab's `OWN_DOC_SEMESTERS = ['spring-2026']` (`firebase-data.js:85`) treats Spring 2027 as legacy, so its `deleteSemester` passes `:4624` and removes the config entry at `:4663`; the generic rules then let a manager delete the orphaned document and anyone edit it. The real mitigation already exists: config has no listener (`app.js:11477`), so a stale tab can only delete a semester it loaded or created itself. Fix: say this in the edge case and Decisions Log, and keep Phase C's "hard-refresh every tab" as the stated mitigation. No rules change.

2. **Minor — the state table has a hole.** "Document absent + unverified record + legacy map absent" matches no row (row 4 needs the legacy map). Today that branch shows the "storage changed, reload" notice at `firebase-data.js:1460`. Fix: add the row as error, same as row 6.

3. **Minor — the creating tab is read-only until the first snapshot.** After the transaction, `ownDocSource[key]` is undefined until the reconciled listener delivers a server snapshot; under the table's "unknown means read-only" rule the admin's immediate Settings save or edit gets the pause message. Fix: after commit, set the source to `ownDoc` and install the written map before reconcile, and add a scenario "the creating tab adds a roster class without reload".

4. **Minor — roster-slot transaction wording.** "Dotted `tx.update` per new key" should be one `tx.update` carrying every absent slot path plus the stamps: one write, one rules evaluation, no multiple writes to one document inside a transaction. For the Fall variant the transaction runs on the hot `lessonData` document, so a contention abort surfaces as "Error saving settings" (`app.js:11503`) after the config write at `:11471` already landed. Fix: the alert must say settings saved, slots not created, press Save again.

5. **Minor — two tests to add.** Rules: create `lessons_spring-2027` in a transaction whose appData write adds a different key (`spring-2028`) → denied, pinning the `lessonsSemKey()` match. Note alongside it that a manager can already create `lessons_fall-2026` under these rules (config holds the key, no record) and that Phase D's move must refuse an existing target, as the parent procedure does. e2e: "Create its storage" is hidden and refused while the migration state is unknown (absent + unknown is error, not missing).

6. **Minor — citation nits.** The config-failure stop is `app.js:159`, not `:151`; alerts are `:563-665`; the backup tally is `:388-394`.

## Verified as stated

- Rules language: `keys().toSet().difference(...).hasOnly(list)`, `matches` on the whole segment, `replace` with a regex, guarded `exists`/`get`, `existsAfter`/`getAfter` returning current state outside a transaction. Create uses `request.resource.data.keys().hasOnly(...)` since `resource` is null there. The un-fenced rollback statement can only ever add `spring-2026` because of its `hasOnly`.
- Every existing Spring-fence test still passes under the fence, including the merge-set at `rules.test.js:2676`, the create at `:2689` and the near-1 MiB fixture at `:2815`. No ordinary-doc test uses an ID matching the regex.
- Extending `isStorageMoveDoc` removes new `lessons_*` documents from the three ordinary grants at `firestore.rules:700`, `712-716`, `722-726`; reads and ID-range list queries stay open to manager and classbook roles.
- Q&A, replies, cut bank, roster slots and Settings route through `weeklyLessonTarget` or are paused up front (`app.js:11382` for Settings), so no flow adds a top-level key to `lessonData`. The Classbook never writes `qaData`; only Studio Hub's manual test tool does, and it exists in production.
- Alert IDs are already semester-qualified (`classbook-qa-alerts.js:41-42`), so B′'s dismissal scenario holds.
- Nothing conflicts with "every past semester stays in the app" or the cross-semester search: documents are only ever added, and the range query plus `appData` names is all the search needs.
- Oct 5 is doable: Phase A about one day, B1+B2 about two, reviews and deploys half a day, B′ trailing. Keep the Spring fold in Phase D as planned.

I edited nothing, ran no deploys and touched no production data or credentials. This review is not saved to `thoughts/reviews` under the read-only constraint.
