## Findings

**MEDIUM — Canceling “Record baseline” can still modify the baseline.**  
[useDataLossCheck.ts:60](</Users/christiehubley/Documents/New project/src/hooks/useDataLossCheck.ts:60>) ratchets during every `runCheck()`. `recordBaseline()` invokes it before asking for confirmation at line 108. If one collection is slightly lower while another grew, canceling preserves the lower count but still raises the other baseline; the UI then incorrectly says “Baseline not changed.”  
**Fix:** add a `ratchet` option to `runCheck()` and disable it during the pre-record check. Only mutate after confirmation.

**MEDIUM — The displayed baseline becomes stale after a ratchet.**  
[useDataLossCheck.ts:64](</Users/christiehubley/Documents/New project/src/hooks/useDataLossCheck.ts:64>) ratchets storage, then stores the pre-ratchet result. [dataSafetyCheckView.ts:47](</Users/christiehubley/Documents/New project/src/lib/dataSafetyCheckView.ts:47>) prefers `entry.baselineCount`, so after growth the table shows the old baseline even though the footer says it was raised and localStorage contains the higher count.  
**Fix:** after a successful ratchet, rebuild/patch the clean result against the newly loaded baseline, or consistently render the current stored baseline.

**LOW — The critical hook behavior is untested.**  
[dataLossIncidentCheck.test.ts:336](</Users/christiehubley/Documents/New project/src/lib/dataLossIncidentCheck.test.ts:336>) verifies the engine using a fake, and the view tests cover pure formatting, but there are no tests for StrictMode, once-per-sign-in behavior, busy suppression, unmount/sign-out results, manager gating, or the confirmation/ratchet interaction above.  
**Fix:** add hook/component tests with deferred promises and StrictMode; specifically assert that canceling record performs no localStorage write.

No HIGH findings. Firebase v8 does support query `.get({source:'server'})`; it rejects when the server is unavailable, and Firestore errors expose stable `code` values including `unavailable` and `permission-denied` ([GetOptions](https://firebase.google.com/docs/reference/js/v8/firebase.firestore.GetOptions), [FirestoreError](https://firebase.google.com/docs/reference/js/v8/firebase.firestore.FirestoreError)). The implementation preserves that code correctly. Manager/demo gating and hook ordering look sound, and the feature performs no Firestore writes.

Both non-writing TypeScript checks passed. Exact `npx tsc -b` and Vitest execution were prevented by the enforced read-only filesystem because they create build-info/temp files; Vitest collected no runnable tests before failing with `EPERM`.

**Verdict: SHIP AFTER FIXES**
