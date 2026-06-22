# Repo Bootstrap

Stamp `CLAUDE.md` and `AGENTS.md` into an existing repo. ALWAYS extend — never overwrite. If either file already exists, read it first and append only what's missing.

## $ARGUMENTS

Pass the repo path: `/repo-bootstrap ~/some-app/`  
Or run without arguments from within the repo directory.

## Step 1 — Identify the repo

```bash
REPO="${ARGUMENTS:-$(pwd)}"
echo "Bootstrapping: $REPO"
ls "$REPO"
```

## Step 2 — Read existing files (if any)

```bash
cat "$REPO/CLAUDE.md" 2>/dev/null && echo "--- CLAUDE.md exists, will extend ---"
cat "$REPO/AGENTS.md" 2>/dev/null && echo "--- AGENTS.md exists, will extend ---"
```

## Step 3 — Determine what's missing

Check which sections are absent from existing files. Required sections for CLAUDE.md:
- App overview (what it does, who uses it)
- Local dev (localhost port, how to start)
- Firestore collections used (with links to rules)
- Firebase safety invariants (see below)
- Skill references

Required sections for AGENTS.md:
- Firebase safety invariants (abbreviated)
- Commit discipline
- Test requirements

## Step 4 — Write or extend CLAUDE.md

If `CLAUDE.md` doesn't exist, create it. If it exists, append the missing sections only.

Template for new file:
```markdown
# [App Name] — CLAUDE.md

## What this app does
[One paragraph: purpose, who uses it, key workflow]

## Local development
- Port: [XXXX]
- Start: `npx http-server . -p XXXX` (or app-specific command)
- Firebase project: `tinker-hq-apps`

## Firestore collections
- `[collection-name]`: [what it stores]
  - Rule in: `/Users/christiehubley/studio-hub/firestore.rules`

## Firebase safety invariants
These apply to every change in this repo:
- Use `updateDoc` for partial edits — never `setDoc` for a partial update
- Strip `undefined` and empty-string fields before any write
- `await` all critical Firestore writes
- Snapshot to JSON before any bulk delete or import
- New collection → add rule to `/Users/christiehubley/studio-hub/firestore.rules` in the same commit
- Deploy rules: `cd /Users/christiehubley/studio-hub && firebase deploy --only firestore:rules`
- NEVER run bare `firebase deploy`
- Rules source of truth: `/Users/christiehubley/studio-hub/firestore.rules` only

## Data-loss pattern to know
If data appears missing or blank, check rules before assuming data loss. Several apps have
`loadConfig()` functions that silently fall back to defaults on permission errors.

## Skills
- `/planning-workflow` — use before any non-trivial feature or data change
- `/development-workflow` — required for any Firestore write, rules change, or delete
- `/product-principles` — stack defaults and app registry
- `/html-plan-review` — publish and review plans before execution
- `/second-model-review` — independent review of plans or implementations
- `/repo-bootstrap` — this skill

## Deployment
- Platform: [Netlify / Render / n/a]
- Deploy: [netlify deploy --prod / auto on git push / manual]
- ⚠️ Always ask before running `netlify deploy` — each build costs credits
```

## Step 5 — Write or extend AGENTS.md

```markdown
# [App Name] — AGENTS.md

## Firebase Safety (non-negotiable)
- `updateDoc` for partial updates; `setDoc` only for intentional full overwrites
- Strip empty fields before writing; `await` all writes
- Snapshot before bulk delete/import
- New collection → new rule in `/Users/christiehubley/studio-hub/firestore.rules`, same commit
- Deploy: `firebase deploy --only firestore:rules` from `/Users/christiehubley/studio-hub/`

## Test requirements
- Data-write / rules / delete changes: write a failing emulator test first, then fix, then green
- Emulator: `cd /Users/christiehubley/studio-hub && firebase emulators:start --only firestore`
- Rules test suite: `cd /Users/christiehubley/studio-hub && npm test` (must pass: 29/29)

## Commit discipline
- Commit after each phase, not at the end of a session
- Message format: `type: what changed and why` (fix, feat, refactor, docs, chore)
- Never commit with `--no-verify`

## Planning
- Use `/planning-workflow` for any non-trivial change
- Plans live in: `~/tinker-ai-configs/thoughts/plans/<slug>.html`
- No execution without a reviewed plan for any data-write or rules change
```

## Step 6 — Commit

```bash
cd "$REPO"
git add CLAUDE.md AGENTS.md
git commit -m "docs: add Firebase-safety CLAUDE.md and AGENTS.md via repo-bootstrap"
```

## What NOT to do

- Do not overwrite existing CLAUDE.md/AGENTS.md content
- Do not add project-specific Firebase credentials or keys to these files
- Do not hardcode Christie's name in role examples
- Do not add app-specific business logic — that belongs in the app's own docs
