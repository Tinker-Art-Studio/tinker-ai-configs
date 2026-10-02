**Verdict: SAFE TO DEPLOY.**

Every round-1 fix the commit message claims is present and correct; I found no new bug in js/. Checked specifically:

- **Migration-record recovery** (`js/firebase-data.js:1661-1676`): state is set before the loop, only the rollback row reinstalls, the callback fires once. `currentLessonData` is never null here, since both init paths await `loadLessonData` first (`js/app.js:719`, `:5096`).
- **Carry-over branches** (`:1625-1647`): src 'absent' with known state and no record keeps the tab's copy or the snapshot's; with unknown state it never drops a copy. The rollback row still takes the fresh snapshot copy. Nothing new reaches a write.
- **Unlisted legacy copy → 'error'** (`:154-158`): no "Create its storage" button, `createOwnDocStorage` refuses, the own-doc listener's first 'absent' answer leaves the screen alone (`:1719-1721`).
- **Banner ownership** (`:336-353`): all six `showStorageNotice` callers pass a key; no remaining direct `storage-notice-banner` hides in js/. The existing Spring spec's banner assertions are unaffected.
- **Copy-from refusal** (`js/app.js:5016`): thrown before `createWeeklySemesterStorage`, so nothing is written. Refusing 'rollback' too is conservative, not wrong.
- **Count filter** (`js/app.js:7624-7625`): identical to Studio Hub's `classbookOwnDocSemKey` (pattern plus legacy exclusion).
- **Codex r1-2**: agreed, not new. Move/swap/copy/paste read the same listener cache for Fall today; this change only extends the pattern to the new store.

Findings (both Low, neither blocks):

1. **Spec claims more than it tests.** `e2e/new-semester-own-doc.spec.js:326-336`: the staged Fall lessons have only `projectTitle`, which is not in `CONTENT_FIELDS` (`js/firebase-data.js:22`), so Fall contributes zero to the count with or without the filter. The "never hides Fall's count" half is unexercised; the test only catches the stray content being tallied. Give one Fall lesson an `introPitch` in `stageFall` or in this test and assert the Fixture Teacher count is unchanged. Also add `lessons_Bad Id` to `STAGED_DOCS` so a mid-test failure doesn't leak it.

2. **Stale copy preferred over the fresh snapshot** in the two new branches (`js/firebase-data.js:1634-1640`): when the tab already holds a lessonData copy and the new snapshot also has one, the older copy wins. Both are lessonData copies, the semester is read-only in these states, and the pre-fix code behaved the same way, so it is display-only. Optional: only fall back to `previousOwn` when the snapshot lacks the key.
