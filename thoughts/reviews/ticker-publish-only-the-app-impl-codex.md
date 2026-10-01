No BLOCKING defect found, but four MEDIUM spec gaps mean I would not deploy this commit unchanged.

### MEDIUM

1. Completeness parsing can pass an incomplete app. [scripts/build-dist.sh:40](/Users/christiehubley/tinker-timeclock/scripts/build-dist.sh:40)

   The HTML parser recognizes only double-quoted lowercase `src`/`href` attributes, while `APP_SHELL` recognizes only single-quoted entries. For example, a tracked `<script src='vendor/runtime.js'>` is outside the candidate set and invisible to completeness, so the build can pass without publishing it. The test duplicates these parsing limitations at [schedule-editor-wiring.test.js:2460](/Users/christiehubley/tinker-timeclock/schedule-editor-wiring.test.js:2460), so it does not catch the hole.

2. The live private check does not cover every exposed path category required by acceptance. [scripts/must-not-be-public.txt:8](/Users/christiehubley/tinker-timeclock/scripts/must-not-be-public.txt:8)

   It probes only 3 of the repository’s 27 test files and only one of the nine top-level function source files. Thus “tests” and `netlify/functions/*.js` are not all checked live. The `dist/` allowlist should prevent publication, but `check-live.sh` does not prove the plan’s “every path in the table” outcome.

3. Exit 2 destroys the information required by the instructed retry. [scripts/deploy.sh:33](/Users/christiehubley/tinker-timeclock/scripts/deploy.sh:33), [scripts/check-live.sh:73](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:73), [scripts/check-live.sh:102](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:102)

   `deploy.sh` deletes the previous-shell snapshot regardless of whether `check-live` returns 2. The printed retry omits that snapshot. If a private edge still serves the previous shell on the retry, `PREV_HASH` is empty and the same CDN lag is falsely reported as a public leak rather than remaining inconclusive.

4. Function probes verify status only, not the required JSON response. [scripts/check-live.sh:87](/Users/christiehubley/tinker-timeclock/scripts/check-live.sh:87)

   The preview function passes on any 401, and the seven POST-only functions pass on any 405, regardless of content type or body. A generic platform/proxy response could therefore produce a false positive. The plan specifies 401 JSON and 405 JSON as the positive signals.

### LOW

1. A committed, explicitly allowlisted dot-file can reach `dist/`. [scripts/candidate-set.sh:8](/Users/christiehubley/tinker-timeclock/scripts/candidate-set.sh:8), [scripts/build-dist.sh:35](/Users/christiehubley/tinker-timeclock/scripts/build-dist.sh:35)

   For example, `assets/.secret` is a candidate and can be listed in the public manifest, after which `git archive` copies it. Uncommitted and unlisted files cannot reach `dist/`; this only contradicts the broader “no dot-files” claim. Netlify’s dot-path filtering would then likely make the post-upload faithful check fail.

2. Valid filenames containing whitespace cause a false refusal. [scripts/build-dist.sh:35](/Users/christiehubley/tinker-timeclock/scripts/build-dist.sh:35), [scripts/build-dist.sh:47](/Users/christiehubley/tinker-timeclock/scripts/build-dist.sh:47)

   Both manifest expansion and reference iteration use shell word splitting. No current filename is affected.

The deployment gates themselves are sound: exact full SHA, clean tree, `main`, exact `origin/main`, fetch before comparison, complete preflight before upload, SHA deploy message, and correct propagation of `check-live` exit 2. There is no ordinary path through `deploy.sh` that skips preflight.

The first deploy is not guaranteed to trip: its changed `index.html` gets a cache-busted request and one retry. Persistent private-path CDN lag can return 2 as designed, but the documented rerun then has the false-leak problem above.

Ready to deploy — no.
