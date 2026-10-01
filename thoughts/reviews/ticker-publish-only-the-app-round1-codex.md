Execution-ready: no. The publish-directory and Netlify function design is sound, but I found three blocking plan gaps.

## BLOCKING

1. Folder-level copying is not a durable allowlist.

   [Plan:71](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:71>) copies all of `js/`, `css/`, and `assets/`. Any future debug file, source map, fixture, backup, or ignored file placed in those directories becomes public automatically. `git status --porcelain` will not catch ignored files; `.DS_Store` is already ignored at [.gitignore:4](/Users/christiehubley/tinker-timeclock/.gitignore:4).

   Use a file-level allowlist, or make the build fail if those directories contain anything outside a committed, enumerated set. This is necessary to satisfy “a new file lands later” and “every deployed byte is committed.”

2. The proposed deployment flow asks approval before local build/tests.

   [Plan:78](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:78>) has `npm run deploy` build and immediately deploy, while Christie must approve before invoking it. The global workflow requires “Build and test locally first,” then ask, then deploy once ([CLAUDE.md:60](</Users/christiehubley/.claude/CLAUDE.md:60>)). The plan also defines wiring tests but never makes passing tests a deploy prerequisite.

   Add a non-deploying preflight command that builds and runs the wiring/full test suite. Run it before requesting approval. The production command should repeat cheap deterministic guards, then deploy without another mutable preparation step.

3. Password reset is described but not a completion gate.

   The plan correctly says permanent old deploy URLs remain accessible and password resets are what close the exposure ([Plan:48](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:48>)), but resets are absent from acceptance/completion. Add an explicit Christie-confirmed reset prerequisite or final acceptance item. Otherwise the phase can be declared successful while the eight exposed credentials remain usable.

## MEDIUM

1. The function check proves only one of nine functions exists.

   [Plan:89](</Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html:89>) probes only `preview-shift-reminders`. The app also calls the schedule-builder, push, schedule-change email, and four time-off email functions—for example [app.js:5671](/Users/christiehubley/tinker-timeclock/js/app.js:5671) and [app.js:9445](/Users/christiehubley/tinker-timeclock/js/app.js:9445).

   Safe `GET` probes can expect `405` from each POST-only function without sending anything. The scheduled function cannot be tested by URL; verify its deployed schedule metadata separately. Its inline hourly registration is intact at [send-shift-reminders.js:83](/Users/christiehubley/tinker-timeclock/netlify/functions/send-shift-reminders.js:83).

2. The completeness check can miss `sw.js` itself.

   The browser registers `/sw.js` at [app.js:106](/Users/christiehubley/tinker-timeclock/js/app.js:106), but `sw.js` is not inside its own `APP_SHELL`, and the proposed completeness inputs do not include service-worker registrations. If a build regression omitted `sw.js`, faithful checking would not enumerate it and the fallback could return `index.html` at that URL.

   Add explicit required entrypoints: `/index.html`, `/manifest.json`, `/sw.js`, plus expected content types. Normalize the `APP_SHELL` entry `/` to `index.html` during local existence checks.

3. Post-deploy checks need transport failure handling.

   Hashing `curl -s` output alone can treat a failed request as empty content; an empty local file could therefore falsely match. Use `curl --fail --show-error --location`, verify status explicitly, and hash only after a successful download.

## LOW

- The private-body test is logically sound for meaningful leaks. Netlify’s non-forced fallback is shadowed by an existing file, so an exposed file with different content will fail. A leaked file could pass only if its bytes were identical to `index.html`, in which case it exposes no additional information.
- The fallback does not ordinarily hide a missing deployed app file: faithful comparison receives `index.html` instead and detects the byte mismatch. The explicit `sw.js` omission above is the important exception because an absent file is never enumerated.
- All current `APP_SHELL` paths exist within the proposed static set. The maskable icons are also included through `assets/`. Push notifications use the included `/assets/icon-192.png`.
- I found nothing currently in `js/`, `css/`, or `assets/` that should be private. `firebase-config.js` and the browser VAPID public key are necessarily public browser configuration; no private credential belongs in those directories.

## Functions/config conclusion

Yes: `publish = "dist"` and `netlify deploy --prod --dir dist` do not relocate the repository base. The functions directory and `included_files` remain relative to that base, so [netlify.toml:3](/Users/christiehubley/tinker-timeclock/netlify.toml:3) and [netlify.toml:10](/Users/christiehubley/tinker-timeclock/netlify.toml:10) continue to resolve `netlify/functions` and `js/schedule-helpers.js`. This matches Netlify’s [functions configuration documentation](https://docs.netlify.com/build/functions/configuration/) and [CLI deploy-directory precedence](https://docs.netlify.com/api-and-cli-guides/cli-guides/get-started-with-cli/).

The existing local Netlify bundle manifest also contains all nine functions and records `send-shift-reminders` with `0 * * * *`, supporting that the current bundler setup handles the shared helper correctly.

I attempted the permitted live-site checks, but this environment could not resolve `tinker-timeclock.netlify.app`, so I could not independently revalidate current live responses.

execution-ready no
