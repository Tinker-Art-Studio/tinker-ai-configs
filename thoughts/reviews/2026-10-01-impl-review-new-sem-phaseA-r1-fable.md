**Verdict: SAFE TO DEPLOY** (rules content). Two process preconditions below must be met first. I could not run the suite myself in this session (the emulator command needs interactive approval), so the 673 + 141 result is taken as reported. I did verify by hand that exactly 53 of the 134 new tests would fail on the old rules, which matches the commit's claim.

**Spec conformance** (check 1): exact. Fence on `lessonData` create and the shared update only (`firestore.rules:775-782`); rollback statement untouched (`:783-785`); generic `lessons_*` block (`:797-806`) with the plan's pattern, exclusion, and three conditions; Spring 2026 statements byte-identical (`:788-794`); `isStorageMoveDoc()` extended (`:713`) so the ordinary manager, classbook-role, and classbook-admin grants (`:740, :752, :762`) exclude new lessons docs. No other statement can reach a `lessons_*` or `lessonData` write: prepCycleConfig, Spring, and storageMigrations statements are docId-literal.

**Rules-language** (check 3): all correct. `matches` with RE2 anchors; `replace` takes a regex and `^lessons_` strips the prefix once; `keys().toSet().difference().hasOnly(list)` is valid API; `getAfter`/`existsAfter` on a different document outside a batch return current state, so single-doc updates and deletes behave (the tests confirm). Error-tolerant `||` makes a non-map migration record deny every path except a delete whose semester has already left config, which is the intended undo. Distinct documents read per request: users, storageMigrations, appData, i.e. 3, within the limit of 10.

## Findings

1. **Low, process** — Phase A must not merge or deploy until the Classbook B1+B2 PR is green against this branch. The Classbook worktree `.claude/worktrees/new-semesters-own-doc` has only uncommitted edits so far. Phase A alone is production-safe (stale "Copy from" is refused with nothing written), but the plan's order was accepted by both reviewers. Fix: finish and test the Classbook PR, then PR this branch, then `--status`/`--diff` on the merged sha.

2. **Low, precondition** — Phase 0's follow-up (confirm no production `curriculum` doc ID other than `lessons_spring-2026` matches the regex) is not recorded as done in the Decisions Log. Any such doc would become manager-gated and, if its slug isn't a config key, unwritable by everyone. Fix: Christie checks the Console ID range `lessons`…`lessont` before saying the sha phrase.

3. **Low, test** — `rules.test.js:3022` "NON_MANAGER CANNOT create it (even with the appData entry)" passes on the old rules too: the transaction's `appData` update is manager-only, so it fails regardless of the create rule. The role gate is actually proven by the merge-set test at `:3031`. Fix (optional): rename to say what it pins, or drop it.

4. **Low, design note for Phase B′** — a manager can create `lessons_<k>` for any config key, including `fall-2026` or `sdoc-2026-27` (`firestore.rules:797-799`; documented by the test at `:3047`). The Studio Hub range listener planned in B′ treats any `lessons_<k>` as that semester's source and ignores its `lessonData` copy, so a stray `lessons_fall-2026` would hide Fall Q&A alerts. Fix: B′ should also require the key to be an own-doc semester, or filter by the legacy list.

5. **Info** — `qaData` is in production `lessonData` but is not in the allowed list, so it can never be re-added once removed, and `lessonData` cannot be recreated with it. Zero references to `qaData` in the Classbook's `js/`, so this is dead data. No change needed.

6. **Info, missing tests** (not blocking): a manager batch that edits `lessons_<k>` while removing its config entry is denied by `getAfter` (Phase E will need to sequence around this); `appData` lacking a `semesters` field denies create and update; a transaction creating `lessons_spring-2027` that also adds `spring-2027` to `lessonData` is denied.

**Deploy path:** merge to `origin/main`, then run `--status` and `--diff` from the guard and paste the diff verbatim. The approval sentence must name the merged commit's full sha, which will differ from `f9b1123` if GitHub creates a merge commit.
