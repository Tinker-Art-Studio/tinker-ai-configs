- **HIGH — `js/app.js:3587,3601,3550`**  
  The save target semester is read from the global selector rather than captured when the modal opens. `setGlobalSemester()` re-renders the page but does not remove the body-level modal. If the editor opens in semester A, the selector changes to semester B, and the same lesson key/title exists in B, Save writes the form changes into B. If the title differs, manual confirmation can still authorize writing to the wrong semester. The queued rerun also resolves `currentLessonData` through the current semester.  
  **Suggested fix:** store `semKey` and a unique editor token on the modal at open time, pass that captured `semKey` through every save call, and require queued reruns to match both token and semester.

- **HIGH — `js/app.js:3627,3650-3652,3725,3748`**  
  The save captures `formData` before the forced read but continues consulting the mutable global `teOriginalData` afterward. While the read is pending, closing/reopening an editor replaces `teOriginalData`. If both lessons have the same title, the old save can proceed and derive `fieldsToClear` from the new editor’s baseline. Example: lesson A’s form has an empty `introPitch`, lesson B’s baseline has a non-empty one, and A is saving a different field; reopening B during A’s read can cause A’s `introPitch` to be deleted even though it was not changed in A.  
  **Suggested fix:** capture an immutable baseline at the start of `saveTeacherEditInner()` and use it for changed fields, title comparison, clears, and logging. Only assign the global baseline after confirming the original modal/token is still current.

- **MEDIUM — `js/app.js:3627-3635,3748`**  
  After the user confirms saving onto a swapped project, the expected server title remains the old form title. The accepted save succeeds, but every later autosave sees the same title mismatch and stops; every later manual save asks for confirmation again. The existing swap test ends immediately after the first accepted save and misses this.  
  **Suggested fix:** maintain a separate expected server identity/title, rebased to `payload.projectTitle ?? freshTitle` after success. Do not use the dirty-form baseline as the slot-identity baseline.

- **MEDIUM — `js/app.js:3750-3753`**  
  Each successful save leaves an uncancelled 1.5-second timer. When a queued save starts immediately afterward, the first timer can enable the button and clear the status while the second save is still running. It can also erase a “Not saved” or “Save failed” message produced by the queued run. Slow photo uploads or server reads make this readily observable.  
  **Suggested fix:** keep one timer handle or save generation, cancel it whenever another save begins, and have the callback verify the same editor token and latest generation before changing UI.

- **MEDIUM — `js/app.js:3614`, `js/app.js:6010-6014`**  
  Every autosave performs a forced-server download of the entire semester map. Weekly semester documents can approach 1 MiB, so each two-second typing pause may transfer nearly 1 MiB per active editor, with twice that on retry. Firestore bills this as a document read, but latency and bandwidth remain material. Phase 9’s manual-only pattern is substantially less frequent.  
  **Suggested fix:** retain the fail-closed check but consider stronger autosave coalescing or a storage model that permits reading/checking one lesson. Do not replace it with a cache-only check.

- **LOW — `e2e/data-safety.spec.js:6305-6604`**  
  The new tests are genuinely red against the old full-payload implementation, but important paths remain uncovered: semester changes with an open editor, editor replacement during the existence read, a second save after accepting a title mismatch, a queued failure after the prior success timer starts, intentional content deletion, clearing non-content strings, clearing `materialsList`, and `planComplete: false`.  
  **Suggested fix:** add focused tests for the two HIGH races and the serialization timer, plus a payload/result matrix for all clear/value shapes.

**NEEDS FIXES**