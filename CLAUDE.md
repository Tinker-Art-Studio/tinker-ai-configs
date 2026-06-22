# tinker-ai-configs — CLAUDE.md

This repo is the source of truth for Christie's Claude Code skills, plans, and AI development configs for Tinker Art Studio.

## Structure

```
skills/           — Claude Code skills (symlinked into ~/.claude/commands/)
thoughts/plans/   — HTML plan files (registered with local plan-reviewer)
docs/             — Reference docs
```

## Skills

Each `.md` file in `skills/` is a Claude Code skill. They are symlinked into `~/.claude/commands/` and available as `/skill-name` commands.

Current skills:
- `/planning-workflow` — research → plan → review → execute (phase by phase)
- `/development-workflow` — TDD/BDD for any Firestore write, rules change, or delete
- `/product-principles` — Tinker stack defaults, app registry, behavior defaults
- `/html-plan-review` — publish and review plans in the local plan-reviewer
- `/second-model-review` — independent review from a second Claude Code instance
- `/skill-builder` — build and fix skills
- `/repo-bootstrap` — stamp CLAUDE.md + AGENTS.md into any Tinker repo
- `/architecture-docs` — produce architecture and data-flow documentation

## Adding a new skill

See `/skill-builder` for the full workflow. Short version:
1. Write `skills/<name>.md`
2. Symlink: `ln -sf ~/tinker-ai-configs/skills/<name>.md ~/.claude/commands/<name>.md`
3. Commit and push — an unpushed skill is not done

## Plan reviewer

Plans live in `thoughts/plans/<slug>.html` and are registered with the local plan-reviewer:
- Service: http://127.0.0.1:4317
- Start: `brew services start nodaste-lab/plan-reviewer/plan-reviewer`
- Health: `curl -fsS http://127.0.0.1:4317/health`

## Push discipline

Every skill edit must be committed and pushed. Unpushed = not done.

```bash
cd ~/tinker-ai-configs
git status          # must be clean
git log origin/main..HEAD  # must be empty
```

## Firebase safety

This repo contains skill files and plans only — no Firebase credentials, no production data. Skills reference the shared rules file at `/Users/christiehubley/studio-hub/firestore.rules`.
