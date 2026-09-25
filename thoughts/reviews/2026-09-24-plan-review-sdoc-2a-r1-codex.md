## Verdict: CHANGES NEEDED

### HIGH

- **Rename “move” is not concurrency-safe as designed.** A forced read followed by a batch copy/delete can overwrite a newer tick or material edit: Allie ticks the old document after Christie’s read but before the batch; the batch copies the stale snapshot to the new key and deletes Allie’s update. The camp update is also currently separate ([firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2266)). Make the camp update plus every old/new plan move one Firestore transaction, and have all material/tick writers transactionally verify that the camp still exists and still contains that project title.

- **Phase 1 camp deletion gains a new race once prep users can create plans.** `deleteDayOffCamp()` queries existing plans, then deletes only those returned ([firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2330)). Scenario: deletion queries zero plans; Allie creates the first tick document; deletion commits and leaves an orphan plan. The transactional camp/title check above is required; deletion should also delete deterministic refs for every current project title, not merely query results.

### MEDIUM

- **The reload claim is unsafe.** `mergeSummerReload()` preserves only `SUMMER_SAVED_FIELDS` ([firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1038)). A reload begun before a tick can finish after the writer’s read-back and replace the in-memory material state with its earlier snapshot. Extend SDOC kept fields—or explicitly invalidate/supersede in-flight reload generations after each action. “Fresh read wins” does not cover an already-running stale read.

- **Visibility needs three coordinated gates, not the two named.** Kathy/Allie’s deployed permissions do allow event/camp reads and plan create/update; manager+ also has every required permission ([firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:684)). However, the CA selector is currently manager-only ([app.js](/Users/christiehubley/tinker-spring-curriculum/js/app.js:4207)), and existing structural buttons are gated only by load success, not role ([app.js](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12072)). Define one capability matching the rules—manager+ or `classbook-admin`—for structural/material editing, while prep only gets checklist/sign-off. Also, a standalone `role: prep` user without `classbook` is denied all three collections, contradicting “any role: prep”; either require `classbook` in the outcome or change rules.

- **Completion can become misleading.** Scenario: Christie signs off, then changes quantity, adds an item, or changes headcount; the green badge remains. Specify that material-list or capacity changes invalidate/clear camp sign-off atomically. Removing an item should also delete its `materialsChecked.<id>` path; otherwise an invisible tick keeps `dayOffPlanHasUserData()` true indefinitely.

- **The model section remains materially stale.** It still specifies teacher-edited `materialsList`, while 2A introduces an admin-owned `materials` map. Update the canonical Plan/In-memory rows and Phase 2B acceptance, not merely say 2A “supersedes” them.

### LOW

- Plain teachers receive all unpublished SDOC collections during startup because rules allow `classbook` reads and `loadDayOffCampData()` loads every SDOC year ([firebase-data.js](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:2016)). They remain hidden in selectors, but data is inspectable through browser tooling. This matches the model’s accepted UI-only visibility, but should be stated explicitly.

### Open questions

- Allow completion with the proposed warning; it is an intentional sign-off. Keep the unchecked count visible.
- Use add order plus ↑/↓. Give ties a stable `itemId` fallback and perform reorder writes only on `materials.<id>.order` paths.
