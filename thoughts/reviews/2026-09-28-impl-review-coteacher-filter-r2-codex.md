All three findings are fixed:

- Prototype-key UIDs are preserved via own-property checks.
- `sharedWith` is deduplicated before rendering, eliminating ambiguous duplicate controls and saved values.
- Cache completeness is handled by resetting both maps together and retrying when `STAFF_NAMES_UNAVAILABLE` is set.

The related `loadCurriculum` and `staffNamesForDialog` paths maintain the new cache state correctly. I found no new correctness or access-preservation issues in `HEAD`. No files were edited.

safe to ship
