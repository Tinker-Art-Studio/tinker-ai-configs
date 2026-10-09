# Implementation review r1 — Claude (in-session agent), Oct 9 2026

Diff: `7de92fe..claude/step4-data-loss-panel` (1b5a699, 8605db3). Plan: training-hub-data-loss-check-panel.html.
Reviewer ran tsc (clean) and vitest (172/172). Verdict: **SHIP AFTER FIXES** — nothing safety- or data-blocking.

Verified OK: firebase 8.10.1 compat supports `get({source:'server'})` and rejects offline with code `unavailable`;
rules ↔ app manager definition agree; non-managers/demo can't trigger reads; hook order before early returns;
StrictMode/run-once/busy/unmount guards; Record baseline can't bless a loss without confirm; replace semantics;
legacy baseline load; no Firestore writes.

MEDIUM
1. Ratchet-to-peak + real delete paths (assignments, observations) → routine cleanup ≥25% below peak raises a red
   "Tell Christie" banner. Add card copy for deliberate deletes, or ratchet partially.
2. The hook has no tests (confirm-before-lower, cancel, once-only auto, unmount drop, no auto without baseline).

LOW
3. "Baseline not changed." can be false: runCheck ratchets before the confirm (useDataLossCheck.ts:64/110).
4. Every non-permission error is labelled "Couldn't reach Firebase" — only unavailable/deadline-exceeded should be.
5. A rules regression that breaks the main snapshot load shows "Unable to load data"; the card is unreachable then
   (pre-existing). Note it in the plan.
6. Engine docstring says "per page load", hook says "per sign-in" — pick one.
7. Inactive (active:false) manager gets the "permissions (rules)" banner — rare; app doesn't check `active`.
