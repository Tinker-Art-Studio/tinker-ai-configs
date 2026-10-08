Verdict: **safe to merge**

The accepted-limit reasoning holds. The midnight transition introduces no new path that:

- loses the weekly copy: crossing into Sunday creates a valid Sunday-keyed export, so the 09:00 run correctly reports “already done”;
- corrupts or mixes folders: Saturday and Sunday operations have distinct date prefixes, and completion is validated within each exact folder;
- causes a false freshness alarm: freshness uses the metadata object’s `timeCreated`, not the folder date, at [freshness.js:20](/Users/christiehubley/my-clay-hub/functions/vault/freshness.js:20).

The updated runbook and Decision #64 accurately document the limitation and mitigation.

1. **[nit] The test models the crossing but does not literally execute across midnight.** [export-run.test.js:369](/Users/christiehubley/my-clay-hub/tests/functions/vault/export-run.test.js:369)

   It seeds an already-running Saturday operation, begins the tested invocation at Sunday 00:10, and correctly proves that:

   - the retry takes the Sunday key;
   - it ignores the Saturday-prefix operation;
   - it starts a distinct Sunday-prefix export;
   - Sunday’s scheduled run reuses that completed export.

   That adequately covers the production consequence, but the title slightly overstates the mechanics: the test never runs the first attempt before midnight or advances the clock across midnight. This is not merge-blocking because the adjacent test already proves the late-Saturday key, and this test proves the post-crossing behavior.

The new targeted test passes under Node 22.23.3. No blocking or should-fix findings.
