Reviewed read-only at `4ba983dfb8e63abfd90f701f2c71ae3860faa7a9`. I found eight remaining design issues.

## Round-1 confirmation

“C” refers to the 16 Codex findings; “L” refers to the 30 Claude findings.

| ID | Status | Revised Phase 2 |
|---|---|---|
| C1 | Resolved | Separate `readDocId()`/`writeDocId()` and explicit Open Studio behavior ([plan:263](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:263>), [plan:298](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:298>)). |
| C2 | Resolved | `readRef()`/`writeRef()` split plus completeness enforcement ([plan:271](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:271>), [plan:288](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:288>)). |
| C3 | Resolved by narrowing guarantee | The listener race is now stated honestly; hard enforcement is explicitly deferred ([plan:293](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:293>)). |
| C4 | Partial | Sparse-field protection, preview, snapshot, and bounded batches were added, but failure/resume remains unspecified; see finding 5. |
| C5 | Partial | Emulatorizing e2e is now a prerequisite, but new write-path coverage is incomplete and production screenshot testing remains; see finding 8. |
| C6 | Not resolved | Photo ordering and denied deletes are only deferred to Phase 3; see finding 4. |
| C7 | Resolved | All seven snapshot-reference writes are named ([plan:289](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:289>)). |
| C8 | Partial | `firstMadeCurrentAt` replaces the racy empty-count rule, but leaves legacy, atomicity, and Classbook-race holes; see finding 1. |
| C9 | Partial | Canonical builder and `registryDoc('2026')` are specified, but the backfill selector contradicts itself; see finding 3. |
| C10 | Resolved | Add/CSV is current-view-only and optimistic records include `season` ([plan:330](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:330>)). |
| C11 | Resolved | Existing returning-camper cards are expressly preserved ([plan:332](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:332>)). |
| C12 | Resolved | Session `timeSlot` stores the slot key ([plan:324](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:324>)). |
| C13 | Partial | Deterministic topic IDs and transactional rename were added, but 2026 and normalized-ID edge cases remain; see finding 6. |
| C14 | Resolved | Unconditional, markup, autosave, drag/drop, and handler controls are covered ([plan:291](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:291>)). |
| C15 | Resolved | The computed-ID rule now follows local assignments and tests indirect violations ([plan:298](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:298>)). |
| C16 | Resolved | Pages are accurately described; seven root scripts and the external documentation reference are included ([plan:258](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:258>)). |
| L1 | Resolved | Direct reads use ungated `readRef()`. |
| L2 | Partial | Existing cross-season note edits remain possible, but ungated collection writes also permit stale creates; see finding 2. |
| L3 | Resolved | `teamMigrated()` explicitly reads `registryDoc('2026')` ([plan:353](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:353>)). |
| L4 | Partial | Present-key copying and legacy `studio` are covered, but the selection contradiction can still strand documents; see finding 3. |
| L5 | Resolved | Seven snapshot-reference writes are listed. |
| L6 | Resolved | Read/write document IDs are separated. |
| L7 | Resolved | Indirect computed IDs are included in the completeness rule. |
| L8 | Resolved | Four-digit validation is explicit ([plan:303](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:303>)). |
| L9 | Resolved | `breaks` is generator output and validated ([plan:315](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:315>)). |
| L10 | Resolved | Generator parity excludes hand-written notes. |
| L11 | Resolved | Earlier returning-camper cards remain visible. |
| L12 | Resolved | Badges explicitly use the viewing season ([plan:333](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:333>)). |
| L13 | Resolved | Static markup controls receive writable-state handling. |
| L14 | Resolved | The import-removal range now preserves the `try` block ([plan:257](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:257>)). |
| L15 | Resolved | Schedule import deduplicates by the current season entry ([plan:356](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:356>)). |
| L16 | Partial | Pre-edit name is used, but normalized-name renames remain unsafe; see finding 6. |
| L17 | Resolved | Carry-forward passes `{season: current()}` explicitly ([plan:278](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:278>)). |
| L18 | Resolved | Straggler assignment is a restricted audited exception ([plan:311](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:311>)). |
| L19 | Partial | Two-season assertions moved to emulator fixtures, but production screenshot testing remains; see finding 8. |
| L20 | Resolved | All eight requested scenarios were added or replaced by the explicit current-view-only note-creation behavior ([plan:387](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:387>)–[434](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:434>)). |
| L21 | Resolved | Make-current clears the stored viewing season ([plan:292](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:292>)). |
| L22 | Resolved | All seven deployed root scripts are included. |
| L23 | Resolved | Dead prep functions are correctly located outside the import block. |
| L24 | Resolved | `DataSafety.runGuardedDestructiveWrite` is deliberately retained. |
| L25 | Resolved | Registry export is added; both collections are already in backup tiers ([backup.js:30](</Users/christiehubley/tinker-backups/backup.js:30>), [backup.js:50](</Users/christiehubley/tinker-backups/backup.js:50>)). |
| L26 | Resolved | All three missed studio lists are named ([plan:304](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:304>)). |
| L27 | Resolved | Dropping the `importYear` agreement check is explicitly named ([plan:311](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:311>)). |
| L28 | Partial | The cross-season-note count was removed, but the replacement freeze invariant is incomplete; see finding 1. |
| L29 | Resolved | Cache-busters and clean, SHA-labelled deployment are specified ([plan:380](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:380>)). |
| L30 | Resolved | Weekly prep is expressly identified as write-only ([plan:298](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:298>)). |

## Remaining and new findings

1. **HIGH — `firstMadeCurrentAt` does not establish a reliable structure-freeze invariant.**

   The plan allows structural edits whenever that field is absent, asserting that nothing can have written the season before it became current ([plan:317](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:317>)). That is false for legacy 2026: its existing seed has no marker ([season.js:412](</Users/christiehubley/summer-camp-app/js/season.js:412>)), yet it already has production documents. It is also false for a future pre-current season because the Classbook can write lesson, completion, and help documents directly ([firebase-data.js:854](</Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:854>), [firebase-data.js:904](</Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:904>), [firebase-data.js:931](</Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:931>)). Its forced-server count followed by a separate registry update retains the original cross-client race. Finally, the text does not require `_current` and the first marker to be written atomically; rules permit both updates but do not enforce the marker ([firestore.rules:774](</Users/christiehubley/studio-hub/firestore.rules:774>), [firestore.rules:790](</Users/christiehubley/studio-hub/firestore.rules:790>)).

   **Fix:** make structural fields immutable after registry creation—the simplest safe rule originally recommended. If pre-current editing is essential, seed 2026 as locked, introduce an authoritative lock protocol coordinated with the Classbook, and transactionally/batch-update `_current` plus `firstMadeCurrentAt`. Add legacy-2026, concurrent-Classbook-write, and injected-partial-failure tests.

2. **HIGH — ungated cross-season `writeRef()` makes stale Kid Notes/Next Year creation possible after `_current` moves.**

   The revised API says cross-season keys are “never gated” while `stamp()` uses the in-memory current season ([plan:277](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:277>)). The listener is explicitly asynchronous ([plan:293](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:293>)). Existing creation sites use `.add(Season.stamp(...))` for Notes for Next Year, manual Kid Notes, and CSV Kid Notes ([app.js:6350](</Users/christiehubley/summer-camp-app/js/app.js:6350>), [app.js:6938](</Users/christiehubley/summer-camp-app/js/app.js:6938>), [app.js:7098](</Users/christiehubley/summer-camp-app/js/app.js:7098>)). Hiding Add/CSV at render time does not stop an already-open modal or multi-batch import. After the listener fires, `currentMoved` still does not affect a never-gated cross-season reference.

   **Fix:** distinguish existing-document edits from creates. Add a current-season create guard/helper that checks `!currentMoved`, accepts an explicit target, and is rechecked before each CSV batch. Existing cross-season `update/delete` can remain ungated. Test `_current` moving with an Add modal open and midway through CSV import.

   The default `writeRef → viewing()` rule otherwise covers ordinary writes correctly. Carry-forward’s explicit current target and the audited straggler exception are the only legitimate past-view exceptions identified.

3. **HIGH — the team backfill still has two incompatible eligibility rules.**

   The canonical requirement correctly says to migrate every doc missing `seasons.2026` ([plan:351](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:351>)). The very next item says batches update only docs missing `seasons` ([plan:352](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:352>)), and the resume scenario repeats that narrower rule ([plan:468](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:468>)). A partially migrated doc with `seasons.2027` but no `seasons.2026` would be skipped and prevent verification/make-current. Current schedule import creates flat documents with no `scheduleGroups` or `additionalRoles`, confirming why the present-key builder matters ([app.js:6194](</Users/christiehubley/summer-camp-app/js/app.js:6194>)).

   **Fix:** replace every selector with “missing `seasons.2026`,” including dry-run counts, batch selection, resume scenario, and tests. Add a fixture containing `seasons.2027` but no `seasons.2026`.

4. **HIGH — the project-photo data-loss finding is deferred even though Phase 2 enables 2027 photo use.**

   Current save order remains upload → delete old objects → Firestore write ([app.js:13031](</Users/christiehubley/summer-camp-app/js/app.js:13031>)); deletion failures are swallowed ([app.js:12860](</Users/christiehubley/summer-camp-app/js/app.js:12860>)); and Storage rules deny deletes because `request.resource` is null for deletion ([storage.rules:38](</Users/christiehubley/studio-hub/storage.rules:38>)). Phase 2 merely records this for Phase 3 ([plan:325](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:325>)), while changing new 2027 upload paths and permitting new project-detail work.

   **Fix:** either move the failure-safe save sequence and gated Storage-rule correction into Phase 2, or explicitly disable photo add/remove for non-2026 seasons until Phase 3. Add Storage-emulator failure tests before enabling it.

5. **HIGH — the CSV redesign still lacks a recoverable partial-batch contract.**

   The plan now downloads a snapshot and uses bounded awaited batches ([plan:334](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:334>)), but it does not specify generated IDs for planned creates, a manifest of committed batches, retry/idempotency behavior, or the round-1-requested failure/resume test. Multiple batches can therefore partially commit and a retry can create duplicates. Current code is a per-row write loop and mutates local state as each write succeeds, showing the exact partial-import shape being replaced ([app.js:7054](</Users/christiehubley/summer-camp-app/js/app.js:7054>)–[7101](</Users/christiehubley/summer-camp-app/js/app.js:7101>)).

   **Fix:** preallocate create IDs, include all planned creates/patches and original updated documents in the downloaded manifest, make retry idempotent, and add injected second-batch-failure plus resume/rollback emulator tests.

6. **HIGH — the topic-ID design has no complete 2026 contract and mishandles normalized-name-preserving renames.**

   The plan says every new camp now creates a topic, but deterministic topic IDs apply only to non-2026 seasons, while 2026 sheet-ID topics are “only ever read” ([plan:323](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:323>)). The live app still permits creating a 2026 curriculum document ([app.js:338](</Users/christiehubley/summer-camp-app/js/app.js:338>)–[400](</Users/christiehubley/summer-camp-app/js/app.js:400>)), and Release 2A promises every existing edit continues to work. No topic-write behavior is defined for such a camp.

   Also, `Paper Worlds` → `paper   worlds` produces the same normalized ID. “Create the new doc, then delete the old doc” would target the same reference and can leave no topic. Camp-name validation currently checks only non-empty text ([app.js:341](</Users/christiehubley/summer-camp-app/js/app.js:341>)); a name containing `/` cannot safely be embedded directly as a Firestore document ID.

   **Fix:** define 2026 creation behavior explicitly. Use an encoded or hashed normalized key, branch same-key renames to update the existing topic in place, and transactionally update curriculum plus topic(s). Test 2026 creation, case/whitespace-only rename, slash-containing names, and maximum-length names.

7. **MEDIUM — the session duplicate guard is race-prone by design.**

   Phase 2 promises to reject duplicate camp/week/slot/studio sessions but also specifies auto document IDs ([plan:324](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:324>)). Two tabs can both pass a query-based duplicate check and create separate documents. The existing importer demonstrates the auto-ID/session-ID convention ([app.js:8723](</Users/christiehubley/summer-camp-app/js/app.js:8723>)–[8732](</Users/christiehubley/summer-camp-app/js/app.js:8732>)).

   **Fix:** use a deterministic uniqueness document/key for new sessions or a transaction against a deterministic lock. Add a two-concurrent-creates emulator test asserting exactly one wins.

8. **HIGH — the automated test list still lets several data-write implementations ship untested, and one production-data test remains.**

   The explicit automated list covers the helper split, migration classification, backfill mechanics, CSV field safety, and topic concurrency ([plan:360](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:360>)–[370](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:370>)). It does not require failing emulator tests for:

   - Registry create/edit/make-current/revert and `firstMadeCurrentAt`.
   - Session create/update/delete and dependent-record warning behavior.
   - Team save/add-to-season/remove/open-position/import/delete after migration.
   - Cross-season note create-versus-edit gating.
   - Manual straggler resolution.

   These are all new data-write paths. Separately, Release 2A still calls for screenshot parity “taken on production read-only” ([plan:376](</Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:376>)), while the current Playwright harness authenticates with `.env.test` credentials against the app’s configured Firebase ([playwright.config.js:1](</Users/christiehubley/summer-camp-app/playwright.config.js:1>), [login.js:6](</Users/christiehubley/summer-camp-app/e2e/helpers/login.js:6>)). That conflicts with the emulator-only test requirement even after the main e2e suite is moved.

   **Fix:** enumerate red-first emulator tests for every listed writer and destructive path. Generate screenshot parity from seeded emulator fixtures; limit post-deploy production verification to non-test live-byte/app-shell checks.

**Verdict: Phase 2 is not execution-ready for Christie’s go.**
