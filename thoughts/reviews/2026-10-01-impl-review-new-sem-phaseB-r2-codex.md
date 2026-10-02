Verdict: **SAFE TO DEPLOY**

1. **Low — concurrent failures can still lose a banner.** `showStorageNotice()` overwrites the single owner; if A fails, B fails, then B recovers, B’s snapshot hides the banner while A remains failed. Write guards remain intact. `js/firebase-data.js:336`, `js/firebase-data.js:350`, `js/firebase-data.js:1706`

2. **Low — two specs overstate integration coverage.** The migration test directly mutates globals rather than producing an initial-read/listener failure, and the listener-error test directly assigns `ownDocSource` and calls banner helpers. They verify the recovery/ownership logic but not the actual error callbacks. `e2e/new-semester-own-doc.spec.js:355`, `e2e/new-semester-own-doc.spec.js:373`

Codex r1-2 is **not new in this change**; the cached-input race already applies to Fall’s existing move/swap/copy/paste paths.
