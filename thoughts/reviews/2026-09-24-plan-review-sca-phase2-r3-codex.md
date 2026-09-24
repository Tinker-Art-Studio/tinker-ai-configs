### Round-2 confirmation

| Finding | Resolved by revised Phase 2 |
|---|---|
| Codex 1 — structure freeze | Yes — structural fields are immutable from creation; recovery uses delete/recreate. |
| Codex 2 — stale cross-season creates | Yes — `assertCanCreate()` guards Add handlers and every CSV batch. |
| Codex 3 — team backfill selector | Yes — all selectors consistently use missing `seasons.2026`. |
| Codex 4 — unsafe 2027 photos | Yes — photo add/remove is disabled outside 2026. |
| Codex 5 — CSV partial failure | Yes — preallocated IDs, manifest, progress reporting, and idempotent retry are specified. |
| Codex 6 — topic-ID contract | Yes — deterministic encoded/hashed IDs cover every season; same-key and legacy fallback renames are defined. |
| Codex 7 — concurrent session duplicates | Yes — explicitly accepted and accurately bounded as a named limit. |
| Codex 8 — write-path tests/production access | Yes — every new writer is red-first on the emulator; production tests are non-writing checks only. |
| Claude 1 — legacy structure freeze | Yes — structure is immutable for 2026 and all future seasons. |
| Claude 2 — registry data source | Yes — `load()` reads the entire registry and exposes a synchronous map. |
| Claude 3 — team classifier contradiction | Yes — missing `seasons.2026` is used throughout. |
| Claude 4 — shared-collection gating | Yes — team is gated; stock items/settings intentionally remain editable. |
| Claude 5 — dynamic controls/CSS | Yes — the persistent `!important` rule covers static and rendered controls. |
| Claude 6 — sixth computed-ID collection | Yes — `projectLibrary` joins `COMPUTED_ID_KEYS`. |
| Claude 7 — 2026 topic creation/rename | Yes — deterministic IDs apply in 2026, with legacy name fallback. |
| Claude 8 — short final week | Yes — `last camp day` and absent/empty-array parity are specified. |
| Claude 9 — emulator switch | Yes — hostname plus explicit flag, initialized before `Season.load()`, with a production-origin refusal test. |
| Claude 10 — cross-app test ownership | Yes — the local normalizer contract is tested here; the full grid test belongs to Classbook Phase 4. |
| Claude 11 — straggler automation | Yes — deterministic IDs/import years remain automatic; only auto-ID documents require a choice. |
| Claude 12 — public deploy contents | Yes — explicit `dist/` allow-list and post-deploy 404 checks are specified; the test account is retired. |
| Claude 13 — `{season}` escape hatch | Yes — Phase 2 has zero statically enforced callers. |
| Claude 14 — sticky `currentMoved` | Yes — post-switch assertions explicitly occur after reload. |
| Claude 15 — note creation gating | Yes — handlers and CSV batches call `assertCanCreate()`. |
| Claude 16 — dead prep functions | Yes — all four are removed; `prepStatus` is retained only for shape parity. |
| Claude 17 — retired helper in scenario | Yes — the scenario now names `Season.writeRef()`. |
| Claude 18 — year badge | Yes — cards render `season`, not `importYear`. |
| Claude 19 — CSV resume behavior | Yes — the partial-failure and retry contract is explicit and tested. |
| Claude 20 — line drift | Yes — corrected where material and the implementer is told to re-grep all sites. |

### Findings

1. **HIGH — “never-current” deletion is not reliable and can silently reconnect orphaned data.**  
   **Evidence:** [Phase 2 §2.5](/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:327) relies on `wasCurrentAt`, but legacy 2026 has no marker; after switching to 2027 it appears never-current and becomes deletion-eligible. Rules only require that the season is not current and do not inspect `wasCurrentAt` ([firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:780)). A never-current Classbook season may also already contain stamped documents; deleting and recreating the same year makes those documents valid and visible again under the replacement structure.  
   **Fix:** seed an immutable `wasCurrentAt` on 2026 before enabling deletion, enforce marker preservation/deletion eligibility in rules, and refuse deletion unless a forced-server scan proves there are zero documents stamped with that season.

2. **MEDIUM — the synchronous registry map becomes stale after the Phase 2 registry writes.**  
   **Evidence:** `load()` fills the map once ([Phase 2 §2.1](/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:293)), but creation, edits, deletion, and `teamMigratedAt` subsequently update Firestore. `teamMigrated()` and make-current preconditions still read the cached map, so a completed backfill can continue appearing incomplete and a newly created season can remain absent until an undocumented reload.  
   **Fix:** require a forced-server registry refresh—or a full page reload—after every registry mutation and after the team backfill completes.

3. **MEDIUM — the proposed topic encoding is not collision-free.**  
   **Evidence:** [Phase 2 §2.6](/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:333) uses `encodeFirestoreKey`, which replaces `/` with the literal `__SLASH__` ([Classbook helper](/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:25)). Distinct normalized names such as `A/B` and `A__SLASH__B` therefore claim the same uniqueness document. Hashing occurs only above 200 bytes and does not resolve this case.  
   **Fix:** always hash the normalized UTF-8 name, or use a provably bijective escaping scheme; add an encoding-collision test.

4. **LOW — the stale-tab text contradicts the cross-season editing contract.**  
   **Evidence:** cross-season `writeRef()` is “never gated” and existing notes remain editable ([Phase 2 §2.1](/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:283)), but the listener and test text say `_current` moving makes “every `writeRef`” refuse ([same section](/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:303), [tests](/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-app-seasons.html:374)).  
   **Fix:** change both statements to “every per-season `writeRef`”; explicitly test that existing Kid Notes/Next Year edits still work while `assertCanCreate()` refuses new notes.

execution-ready for Christie's go — no
