## Verdict: READY

Revision 7b closes the round-7 MEDIUM.

- `dayOffInstallSeq` is captured before `loadDayOffCampData()` launches its three queries.
- A verified 2B save records a strictly higher sequence and installs its server-read document.
- A reload that started earlier therefore preserves that document and returns its protected key.
- Both entry paths—the listener’s `reloadSummer()` and `summerReloadHook()`—flow through this logic.
- The generation gate still prevents superseded reloads from installing or rendering.
- 2A tick installs remain sound: a tick committed before the teacher transaction is included in its verified read; a later tick replaces the in-memory document while retaining the key’s higher verification marker. Its scheduled reload remains unchanged.

The `protectedKeys` bypass in `mergeSummerReload()` is the necessary final piece: a protected SDOC slot is taken whole from the fresh, preservation-adjusted result. It does not run clock-based `keepMine`, does not park a displaced copy, and therefore cannot combine the verified `lastEditId` with older text from a skewed-clock slot.

Summer behavior is unchanged because summer callers provide no protected-key set and retain the existing merge, parking, and recovery behavior.

The top Decisions Log entry accurately records the round-7 finding and its resolution. The skewed-clock stale-query BDD covers the failure mode.

No new HIGH or MEDIUM problems found. No files edited.
