## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html — read it in full.
Repo: /Users/christiehubley/tinker-timeclock (branch fix/sub-confirm-manager-only). READ-ONLY for you: no edits, no tests that
write, no deploys, no `netlify` commands. Do NOT read or modify anything under /Users/christiehubley/tinker-timeclock/.claude/
(another session works there). You may curl the live site read-only: https://tinker-timeclock.netlify.app
Reference implementation: /Users/christiehubley/tinker-spring-curriculum/scripts/{build-dist,check-live,deploy}.sh (Classbook).
Key files: netlify.toml, sw.js (APP_SHELL), manifest.json, index.html, js/*, css/*, assets/*, netlify/functions/*, package.json,
.gitignore, .netlifyignore, CLAUDE.md, AGENTS.md.

## What I want reviewed
- Is the allowlist complete? Anything the app, the service worker, the manifest, push notifications, or any function needs at
  a URL on the site that would go missing from dist/? Anything in js/ css/ assets/ that should NOT be public?
- Will functions (scheduled send-shift-reminders, the email functions, preview-shift-reminders) still bundle and deploy with
  publish = "dist" via `netlify deploy --prod --dir dist` from the repo root? Any config that is resolved relative to the publish dir?
- The single-page fallback (/* -> /index.html 200): is the check-live "private" test (body equals dist/index.html or 404) sound?
  Could a leaked file ever pass it? Could the fallback itself hide a missing app file from the "faithful" check?
- Service worker: sw.js at dist root, v25 install caching APP_SHELL — any path that 404s and breaks install?
- deploy.sh guards (clean tree, pushed HEAD, sha message). Anything missing vs the Tinker deploy rules in ~/.claude/CLAUDE.md?
- What did I miss? Rank BLOCKING / MEDIUM / LOW with file:line. End with: execution-ready yes/no.
