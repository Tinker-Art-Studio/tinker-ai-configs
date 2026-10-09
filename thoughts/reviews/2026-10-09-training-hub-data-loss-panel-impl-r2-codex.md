- **MEDIUM** — The safety check still cannot detect the rules regression it is meant to diagnose. [App.tsx:119](/Users/christiehubley/Documents/New%20project/src/App.tsx:119) enables it only after the main snapshot succeeds with `snapshotSource === 'live'`; when that snapshot is denied, the source remains `demo` and [App.tsx:191](/Users/christiehubley/Documents/New%20project/src/App.tsx:191) renders only “Unable to load data.” No diagnostic collection reads run and no permissions banner appears. This Round-1 finding remains unfixed.  
  **Fix:** allow the check for an authenticated manager independently of snapshot success, and render the safety card—or its diagnostic result—on the snapshot error screen.

- **LOW** — The new tests do not test the React lifecycle claims. [dataLossCheckController.test.ts:119](/Users/christiehubley/Documents/New%20project/src/lib/dataLossCheckController.test.ts:119) manually calls `detach()`/`attach()`, so it would still pass if [useDataLossCheck.ts:28](/Users/christiehubley/Documents/New%20project/src/hooks/useDataLossCheck.ts:28) recreated controllers on rerender, effects ran in the wrong order, or cleanup stopped detaching. The controller behavior is well covered, but the Round-1 request for StrictMode/hook tests remains incomplete.  
  **Fix:** add a React StrictMode hook/component test with a deferred check; verify one controller/check per `TrainingApp` mount, rerenders and `enabled` transitions, unmount suppression, and remount delivery.

The cancel-without-write, post-ratchet display, preserved `checkedAt`, detached busy reset, and error classification fixes are correct.

**Verdict: SHIP AFTER FIXES**
