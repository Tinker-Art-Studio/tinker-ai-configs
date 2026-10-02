**Verdict: READY WITH FIXES.** Every round-1 blocker is genuinely fixed: create is one transaction, own-doc delete is cut, the seed becomes production-shaped, the migration gate is guarded, the delete rule allows Phase D's undo, the list helpers are literal, and the stale config-fallback claims are corrected. The two "Not taken" rationales hold, with one caveat under finding 4. All cited line numbers check out at Classbook `1532121` and studio-hub `a254b15`. What remains are specification gaps in the new revision-2 material. Findings 1 to 5 must be fixed in the plan before B2 starts. None needs a redesign.

## Findings

**1. Major: the fence ANDed onto the rollback statement flips a passing rules test, and the plan claims both.**
Evidence: plan lines 106-107 say every lessonData statement gets `noNewLessonDataKeys()`, line 120 says every existing Spring-fence test stays passing. `rules.test.js` on origin/main at 2722-2723 asserts the rollback transaction succeeds, and it re-adds `spring-2026`, which is outside the allowed list. The statement is `firestore.rules:739-741`.
Fix: leave the manager-only statement at 739-741 un-fenced. Its `affectedKeys().hasOnly(['spring-2026'])` already means the only key it can add is `spring-2026`, under rollback conditions that are dead in production because verified is one-way. Fence only the create at 733 and the shared update at 736-738. Reword "Spring's literal rules stay exactly as deployed" to say which statements change: the `isStorageMoveDoc` helper and the two fenced lessonData statements.

**2. Major, a blocker if built literally: the adopt path's `tx.set` wipes the adopted document.**
Evidence: plan line 68 says the transaction "adopts an existing document" and then "tx.sets the document (slots or stamp only)". A set without merge replaces the real lessons with two stamps. Today's no-copy adopt writes no lesson data at all, `app.js:5009-5011`, and `data-safety.spec.js:4234-4236` asserts the adopted orphan is byte-for-byte intact.
Fix: when adopting, write nothing to the lessons document and only `tx.update` appData. Simpler for Oct 5: refuse whenever the document exists at all. The Phase 0 follow-up confirms none exist, and atomic create means the app can never produce one, so adopt is dead code. Either way, port the 4234-4236 assertion.

**3. Major: B1 cannot be green before B2 under the Phase A rules, so the stated order is impossible.**
Evidence: plan lines 140 and 263 order B1, then Phase A merge, then B2. Under pre-B2 code `OWN_DOC_SEMESTERS = ['spring-2026']` at `firebase-data.js:85`, so a slug test semester routes to lessonData at `firebase-data.js:119-120` and `1021-1024`, where the fence denies the new key. Every e2e helper writes into lessonData, `e2e/helpers/firestore.js:187-241`.
Fix: B1 and B2 are one Classbook PR, developed against a studio-hub worktree on the Phase A branch through `TINKER_STUDIO_HUB_DIR` at `e2e/emulators/config.js:54`. Merge Phase A once that PR is green against it, merge the Classbook PR straight after, deploy rules, then the Classbook. Say plainly that Classbook main's suite is red against studio-hub main in between.

**4. Major: the config-only delete of a "missing" semester can orphan a real document.**
Evidence: plan lines 71, 158 and 187. "Missing" is in-memory listener state in `ownDocSource`, and deleteSemester writes config from in-memory state, `app.js:4660-4663`. If the document exists after all, the generic rules then let a manager delete it, plan lines 110-111, and let anyone with a stale tab keep editing it, line 109. The Decisions Log's "Not taken Codex 3" rationale assumes no orphan path exists. This is the one such path.
Fix: replace the remedy with a manager-only "Create its storage" action: a transaction that reads `lessons_<key>`, refuses if it exists, else sets the two stamps. The create rule already allows it because config holds the key. Nothing is removed, the own-doc delete refusal stays uniform, and the Codex 3 rationale holds. If the config-only delete stays, run it inside a transaction that reads the document and aborts when it exists.

**5. Major for the schedule: the B1 list misses most of what the transaction breaks.**
Evidence: `data-safety.spec.js:3945-3949`, `4040-4047` and `8358-8363` stub `window.updateAppData` to observe or fail the config write, which the transaction never calls. Lines 4013-4100 test the compensating delete that no longer exists. `OTHER_SEM` at 4604 is a second test semester. The ratchet at `spring-own-doc.spec.js:169-200` pins `isOwnDocSemester(semesterKey)` and an allowed-function list for lessonData access.
Fix: list them. Route the helpers in `e2e/helpers/firestore.js` by semester. Give the create tests a seam that survives the transaction, such as a rules-denied role or an injectable commit, and rewrite R4-11 as "neither exists". Slug key plus config entry plus seeded document for both test semesters. Update the ratchet. Budget 1.5 to 2 days for B1 and B2 together, not "about a day".

**6. Minor: legacy-fallback code stays but its tests are retired.**
Evidence: plan lines 72, 150 and 155 keep the legacy fallback for record-bearing semesters, `firebase-data.js:1455-1460`, while B1 retires the pre-move and undo tests.
Fix: keep one staged test where the own document vanishes for a record-bearing semester and the legacy copy shows without blanking, or drop the branch until Phase D.

**7. Minor: pin the semester key to the rules regex in the app.**
Evidence: the slug at `app.js:4961` happens to produce keys matching `^[a-z0-9]+(-[a-z0-9]+)*$`, but nothing asserts it. A key that fails the regex gets ordinary-doc rules, where any classbook role may create or delete its document.
Fix: refuse a key that fails the same regex in createNewSemester, and add one ratchet test that pins both regexes to the same literal.

**8. Minor: appData absent inside the transaction is unspecified.**
Evidence: plan line 68 uses `tx.update`, which fails on a missing document. `updateAppData` falls back to a merge-set at `firebase-data.js:368-375`. Plan line 238 only says creation needs the read to succeed.
Fix: in the transaction, if appData is absent, `tx.set` the nested payload with merge, so `existsAfter` is true and the create rule passes. Add two rules tests: create in a transaction that also creates appData with the key is allowed; create alone while appData is absent is denied.

**9. Minor: Studio Hub range bounds typo.**
Evidence: plan line 75 gives both bounds as `lessons_`.
Fix: upper bound `lessons\`` or `lessons_\uf8ff`, in the design and the B′ tests.

**10. Minor: tests still missing.** Rules: a manager can create lessonData with only meta keys. Classbook e2e: adopt or refuse leaves existing content intact, the create-storage remedy end to end, a transaction refusal does not alert twice on a retry, and the ratchet from finding 7.

## Verified as stated

- Rules language: `keys().toSet().difference(...).hasOnly(list)`, `matches` on the whole string, `replace` with a regex, `let` bindings, `existsAfter` and `getAfter` outside a batch returning current state are all valid. The map-diff semantics are right: existing keys may change or disappear, a removed non-allowed key cannot come back.
- Extending `isStorageMoveDoc` with the regex excludes new documents from both ordinary grants, `firestore.rules:700` and `712-726`, and reads stay open. Q&A, cut bank, prep, change log and roster slots add no top-level lessonData key.
- No other app touches `curriculum`. The only readers are Studio Hub alerts and its manual test tools, which write `qaData` that already exists in production. `backup.js:388-394` tallies every `lessons_*` document.
- Alert IDs are already semester-qualified, `classbook-qa-alerts.js:41-42` on origin/main, so B′'s dismissal scenario holds without work.
- Config has no live listener, `app.js:11477`, so reconcile-on-create is sufficient.
- Codex 5 "Not taken" holds: the empty strings are the slot schema, written only into a document the same transaction confirmed absent.
- Nothing conflicts with "every past semester stays in the app" or makes the cross-semester search harder. The Archive-by-flag constraint is stated and correct, since removing a config entry also unlocks the delete rule.

## For Oct 5

Doable with two cuts and B′ trailing: refuse any existing `lessons_<key>` document instead of adopting it, and replace the config-only delete with "Create its storage". Those remove code and tests rather than adding them. One Classbook PR for B1 plus B2 is roughly two days, Phase A with its tests roughly one, reviews and the two deploys half a day.

I edited nothing, ran no deploys, and touched no production data or credentials. I can save this as `thoughts/reviews/2026-10-01-plan-review-new-semesters-own-doc-r2-fable.md` beside the round-1 files if you want.
