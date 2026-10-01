## Plan under review (ROUND 3, v3)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-publish-only-the-app.html — read it in full.
Repo: /Users/christiehubley/tinker-timeclock (branch fix/sub-confirm-manager-only). READ-ONLY for you: no edits, no tests that
write, no deploys, no `netlify` commands. Do NOT read or modify anything under /Users/christiehubley/tinker-timeclock/.claude/
(another session works there). You may curl the live site read-only: https://tinker-timeclock.netlify.app
Reference implementation: /Users/christiehubley/tinker-spring-curriculum/scripts/{build-dist,check-live,deploy}.sh (Classbook).
Key files: netlify.toml, sw.js (APP_SHELL), manifest.json, index.html, js/*, css/*, assets/*, netlify/functions/*, package.json,
.gitignore, .netlifyignore, CLAUDE.md, AGENTS.md.

## What I want reviewed
Earlier reviews: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/ticker-publish-only-the-app-round1-{claude,codex}.md and -round2-codex.md (Claude round 2 returned nothing).
- Did v3 resolve each round-1 and round-2 BLOCKING/MEDIUM correctly? Name any not resolved or resolved wrongly.
- New in v3, check hard: git archive + dist-manifest.txt + the "no unlisted tracked file" refusal (which set exactly? any false
  refusal on the current tree?); completeness before upload; preflight vs deploy split and the --approved <sha> gate; ship-from-main;
  check-live order, curl flags, the per-function expected statuses; anything that would make the FIRST real deploy fail spuriously.
- Rank BLOCKING / MEDIUM / LOW with file:line. End with: execution-ready yes/no.

