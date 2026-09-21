#!/bin/bash
# Claude Code PreToolUse hook (matcher: Bash) — denies a raw `firebase deploy` and names the guard instead.
#
# Wired in ~/.claude/settings.json (TRUE user scope — every session, every cwd) as:
#   "command": "bash /Users/christiehubley/tinker-ai-configs/scripts/firebase-deploy-hook.sh || exit 2"
# The `|| exit 2` is what makes it fail closed: Claude Code ignores a hook that exits 1 or is missing (127);
# only exit 2 or an explicit deny blocks. A missing or crashing script therefore blocks EVERY Bash call,
# loudly, until fixed — the honest price (proven live on Sep 21 2026: renaming this file blocked `true`).
# A timeout is fail-open by platform design; this script reads stdin and runs one grep, nothing else, so it
# cannot time out in practice.
#
# What it is: a habit-breaker for the ordinary `cd ~/studio-hub && firebase deploy --only …` a session
# reaches for from memory. What it is NOT: a security boundary — text matching cannot see through a wrapper
# script; the real boundaries are scripts/deploy-rules.sh (deploys from git, leaves a receipt) and the
# firebase.json predeploy byte-check. The guard's own inner `firebase deploy` is a subprocess this hook
# never sees, so the guard needs no exemption — and an exemption would be a bypass
# (`deploy-rules.sh --status; firebase deploy …`).
#
# Plan: ~/tinker-ai-configs/thoughts/plans/firebase-deploy-guard.html
set -euo pipefail

cmd="$(/usr/bin/jq -r '.tool_input.command // empty')"
[ -n "$cmd" ] || exit 0

# `firebase` or `firebase-tools` at a token start (bare, after a path separator, after `npx `, after
# `cd … &&`), optionally with global flags, then ` deploy` as a word. Catches: bare, compound, absolute
# paths, ./node_modules/.bin/firebase, npx firebase-tools, firebase --project x deploy, $(…), heredocs,
# bash -c '…'. A quoted mention (echo "firebase deploy") does not match — the closing quote breaks the
# word boundary — which is fine: fewer false positives.
if ! printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])(firebase|firebase-tools)([^;&|]*[[:space:]])?deploy([[:space:]]|$)'; then
  exit 0
fi

/usr/bin/jq -n --arg reason \
"firebase deploy is gated (Firebase Backend Resilience Plan). Deploys for tinker-hq-apps go through the guard, from any cwd:
    /Users/christiehubley/studio-hub/scripts/deploy-rules.sh --status
    /Users/christiehubley/studio-hub/scripts/deploy-rules.sh --approved <full sha> [--target firestore:rules|storage|firestore:indexes]
Christie's phrase is 'approved to change firebase <full sha>' — --status prints the exact sentence and --diff the change to paste when asking. If you only meant to read text containing 'firebase deploy', use Read/Grep instead of Bash. See ~/.claude/CLAUDE.md → FIREBASE RULES." \
  '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
exit 0
