# Skill Builder

Build, update, or fix skills in the `tinker-ai-configs` repository. A skill is a markdown file that Claude Code loads when you type `/skill-name`.

## Skill location

All skills live in: `~/tinker-ai-configs/skills/`

Each skill is a single `.md` file: `~/tinker-ai-configs/skills/<skill-name>.md`

They are symlinked into `~/.claude/commands/` so Claude Code can invoke them.

## Creating a new skill

1. Write the skill file:

```bash
# Use Write tool or editor — NOT echo/cat
# File: ~/tinker-ai-configs/skills/<new-skill-name>.md
```

Skill file structure:
```markdown
# Skill Title

One-line description of when to use this skill.

## When to invoke
[clear trigger conditions]

## Steps / Instructions
[what Claude should do when this skill is invoked]

## $ARGUMENTS
[if the skill takes arguments, explain them here]
```

2. Symlink it into commands:

```bash
ln -sf ~/tinker-ai-configs/skills/<new-skill-name>.md ~/.claude/commands/<new-skill-name>.md
```

3. Verify it loads:

```bash
ls -la ~/.claude/commands/<new-skill-name>.md
# Should show the symlink target
```

4. Commit and push:

```bash
cd ~/tinker-ai-configs
git add skills/<new-skill-name>.md
git commit -m "skill: add <new-skill-name> — <one-line description>"
git push
```

## Updating an existing skill

Edit the file directly in `~/tinker-ai-configs/skills/`. The symlink means the change is immediately live in `~/.claude/commands/`. Commit and push after every edit.

## Fixing a broken skill

1. Read the current skill: `cat ~/tinker-ai-configs/skills/<skill-name>.md`
2. Identify what's wrong: unclear trigger, missing steps, wrong command, stale path
3. Edit the file (use the Edit tool, not echo/sed)
4. Test by invoking the skill
5. Commit and push

## Skill quality checklist

- [ ] Clear "when to invoke" section — when should Christie or Claude use this?
- [ ] No hard-coded dates or session-specific state
- [ ] Paths are absolute (`~/tinker-ai-configs/...`, `/Users/christiehubley/studio-hub/...`)
- [ ] Firebase commands use `--only` flag
- [ ] References to other skills use `/skill-name` format
- [ ] Committed and pushed — an unpushed skill change is not done

## Available skills

- `/planning-workflow` — research → plan → review → execute
- `/development-workflow` — TDD/BDD for data-write/rules/delete changes
- `/product-principles` — Tinker stack defaults, app registry, behavior rules
- `/html-plan-review` — publish and review plans in the browser
- `/second-model-review` — get a second Claude opinion on a plan or implementation
- `/skill-builder` — this skill
- `/repo-bootstrap` — stamp CLAUDE.md + AGENTS.md into a repo
- `/architecture-docs` — produce architecture and data-flow documentation

## Push discipline

An edited skill file in `~/tinker-ai-configs/skills/` that isn't pushed to GitHub is not done. After every skill change, verify:

```bash
cd ~/tinker-ai-configs
git status          # should show clean working tree
git log origin/main..HEAD  # should be empty (nothing unpushed)
```
