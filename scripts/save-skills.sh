#!/bin/bash
# Auto-commit and push any skill changes after a Claude session.
# Run by the Claude Stop hook. Also callable manually: ~/tinker-ai-configs/scripts/save-skills.sh

cd ~/tinker-ai-configs || exit 0

# Check for any changes (staged, unstaged, or new files)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  exit 0  # nothing to do
fi

git add skills/ CLAUDE.md docs/ thoughts/plans/ 2>/dev/null
CHANGED=$(git diff --cached --name-only)

if [ -z "$CHANGED" ]; then
  exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
git commit -m "auto: save skill changes ($TIMESTAMP)"

# Push only if a remote is configured
if git remote get-url origin &>/dev/null; then
  git push
fi
