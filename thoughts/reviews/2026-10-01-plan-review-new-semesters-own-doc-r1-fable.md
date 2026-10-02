**Verdict: NOT READY.** The design direction is right (own-doc by default, one literal legacy list, one generic `lessons_*` rule, a fence on added keys), and every line number I checked is accurate at Classbook 1532121 and studio-hub a254b15. But the plan misstates its test impact, the routed delete can make a semester unreachable, and two rules expressions deny everything as written. One more revision fixes all of it; the schedule still works if the cuts at the end are taken.

## Findings

**1. Major: Phase A alone breaks the Classbook suite, and Phase B breaks it again. "Default seed unchanged" is wrong.**
- The suite loads rules from the studio-hub checkout, see e2e/emulators/config.js:54-55. Merging Phase A changes what the Classbook tests run against.
- The data-safety spec writes a brand-new top-level key into lessonData through the real writers. See e2e/data-safety.spec.js:475 and 502-523, about 460 references. The added-keys fence denies the first such write.
- Under Phase B code that key is weekly by default and not legacy, so it routes to its own document, which is missing, so every writer refuses. Its id also fails the regex, so in rules it would be an ordinary document.
- The seed keeps Spring 2026 inside lessonData with no own document and no migration record, see e2e/fixtures/seed/curriculum.json:59-129. Under the new code Spring is "missing", so teacher-view, linkify and day-off specs that read fixture Spring lessons fail too.
- Fix: seed Spring as moved and verified, add a legacy `fall-2026` map to the seeded lessonData, rename the test semester to a slug key with its own seeded config entry and document, point the spec's four lessonData reads at the own document, and retire the move and undo states in spring-own-doc.spec.js. Budget a day. Pull studio-hub first, the checkout is behind origin/main.

**2. Major: routed delete as two writes violates the "stays in the app" requirement.**
- Plan line 74 removes the config entry, then deletes the document, and accepts an orphan. Today's order is the same, app.js:4660-4685, with the document step warn-only.
- A refused or failed document delete leaves the lessons on the server and the semester gone from every selector. Nothing is lost, but the semester is unreachable, and re-creating it with "Copy from" is refused.
- Fix: one batch holding the config field delete and the document delete. The rules were already designed for that batch. Also specify that a config-only semester, whose document is missing, deletes without a download, or the "delete and create again" remedy in the missing notice cannot be followed.

**3. Major: create should be one transaction, not a transaction plus a config write plus compensation.**
- Plan line 71 keeps today's shape, app.js:5074-5096. A transaction may read and write both documents, and nothing in the rules gates a `lessons_*` create on another document.
- Fix: in one transaction, read appData and the lessons document, decide refuse or adopt, then set the lessons document and update the semesters field. Fall back to a merge-set only when appData is absent, as firebase-data.js:368-375 does. Keep the two guards at firebase-data.js:349-360 in front. This deletes the compensating delete, the orphan state, and the read-to-update window noted at app.js:5070-5073.

**4. Major: the generic delete rule blocks Phase D's undo.**
- Plan line 73 allows delete only when the key is absent from the projected appData. During a Fall move the semester stays in config, so the parent plan's one-transaction undo, which Phase D reuses at plan line 200, is denied. Today's rule allows it while unverified, rules 748-750 on origin/main.
- Fix: delete when manager-plus and either the key is gone from projected config, or a migration record exists for the key and is not verified. Add the matching test.
- Also note in Phase D that the storageMigrations rules stay Spring-literal, rules 754-772, so a Fall record's verified flag gets no cross-document check until a second rules deploy generalises them.

**5. Major: two rules expressions deny everything as written.**
- The migration gate calls get on storageMigrations. The Classbook seed has no such document, so the call errors and every own-doc update fails in the suite. Guard it:
```
!exists(p) || !(semKey in get(p).data) || get(p).data[semKey].get('verified', false) == true
```
- The delete rule needs `!existsAfter(appData) ||` in front of the projected-semesters check.
- Rules lists have no plus operator. Spell the legacy-plus-meta list as one literal or use concat. The set difference, hasOnly, matches and replace calls are all valid rules language.

**6. Minor: drop `qaData` from the allowed meta keys.** Only Studio Hub's manual test tools write it into production lessonData, test-alerts.js:98-117 and test-alerts-browser.html:227-246 on origin/main. If Phase 0 finds it present it is an existing key and stays editable anyway.

**7. Minor: Phase 0 should list every curriculum document id and every weekly key.** Any other id matching the regex silently changes rules for that document. Any weekly key outside `^[a-z0-9-]+$` falls to ordinary-document rules, where any classbook role could create or delete its lessons document. Also refuse an empty key in createNewSemester, app.js:4961 checks only the name.

**8. Minor: stale claims.** Plan lines 79 and 207 say config silently falls back to defaults on a permission error. loadConfig now fails loud, firebase-data.js:305-319, and only a missing appData yields defaults, which include Spring 2026 at 641-643. The rules range runs to 772, not 748. The ratchet must exempt that default and the camp key at firebase-data.js:45.

**9. Minor: other-tab behaviour after a delete is unspecified.** The listener branch at firebase-data.js:1455-1460 treats a vanished document as a rollback. For a semester with no migration record, specify "missing, deleted elsewhere, reload", never writable, and add the scenario. Also say whether createNewSemester re-runs the whole listener setup, which bumps the generation and re-reads every camp season.

**10. Minor: trajectory and the future search.** Every tab will hold a live listener and a full copy of every own-doc semester, roughly half a megabyte each, two more per year. Fine for now; note that past semesters can later be read once instead of listened, and that the search should use a document-id range query at search time. The Archive plan must hide semesters by a config flag and never remove the config entry, since removal also unlocks the delete rule. State that explicitly.

**11. Minor: Studio Hub details.** Give the range bounds, at least `lessons_` and below `lessons_\uf8ff`, derive the semester key from the document id, and collapse the received set to two sources. Add a rules test for the list query, allowed for manager and classbook roles, denied for no-access. It is missing from the Phase A list.

**12. Minor: tests still missing.** Rules: appData absent then delete allowed; `lessons_` and an uppercase id fall to ordinary rules; a classbook-role merge-set that would create a missing own document is denied; classbook-role updates that add or remove top-level lesson keys are allowed; a manager set over an existing own document counts as an update. Classbook e2e: two own-doc semesters carried across one lessonData snapshot, firebase-data.js:1410-1425; delete in another tab; the stale-tab config-only recreate flow end to end.

**13. Minor: parallelise loadOwnDocSemesters.** It awaits each document in sequence, firebase-data.js:910-924.

## Verified as stated

Folding Spring's literal rules is safe: the key is absent from lessonData, the fence blocks re-adding it, and the rollback branch is dead because verified is one-way. The generic update gate matches today's Spring gate. backup.js already tallies every `lessons_*` document, lines 388-392. No other app reads curriculum documents except Studio Hub alerts and its test tools. Cut bank, change log, prep data and roster slot creation are unaffected.

## For Oct 5

- Take findings 2 and 3. They remove code rather than add it.
- Let the Studio Hub half trail the Classbook deploy. Alerts only matter once Spring 2027 is published.
- Consider keeping the Spring-literal rules and their roughly sixty tests untouched, with the generic block excluding that one id, and fold at Phase D. It saves the largest test rewrite.
- Keep the gauge minimal: a list of own-doc semesters with sizes.
- Finding 1 is the critical path. Scope it before Phase A merges.

I edited nothing, ran no deploys, and touched no production data. I can write this up into thoughts/reviews as the round 1 file if you want it alongside the earlier reviews.
