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
#
# The same token rules also deny the function-changing commands that have no guarded path (plan
# firebase-functions-deploy-guard.html, F12): functions:delete and functions:deletegcfartifacts (each alternative is
# anchored by the trailing space-or-end, since one contains the other), functions:secrets:set|destroy|prune,
# functions:secrets:access (prints a secret's plaintext), functions:artifacts:setpolicy and
# functions:config:set|unset|clone|export (in 15.22.3, export copies Runtime Config into a Secret Manager secret).
# Read-only siblings (functions:list, functions:log, functions:secrets:get, functions:config:get) stay allowed.
# The subcommand ends at whitespace, the end, a shell operator (; & | )) or a backtick, so `firebase deploy;ls` and
# `$(firebase deploy)` are caught too (D2-4; before, only whitespace or the end ended it).
# Known gaps, documented and tested (firebase-deploy-hook.test.sh): (1) grep matches line by line, so a command split
# with a backslash-newline between `firebase` and its subcommand is not caught; (2) a subcommand directly followed by a
# quote (bash -c "firebase deploy") is not caught — the same rule that lets a quoted mention through. The predeploy
# backstop still refuses a deploy started either way; the function-changing commands have no backstop. This hook is a
# habit-breaker, not a security boundary.
if ! printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_.-])(firebase|firebase-tools)([^;&|]*[[:space:]])?(deploy|functions:delete|functions:deletegcfartifacts|functions:secrets:(set|destroy|prune|access)|functions:artifacts:setpolicy|functions:config:(set|unset|clone|export))([[:space:];&|)`]|$)'; then
  exit 0
fi

/usr/bin/jq -n --arg reason \
"firebase deploy and function-changing commands are gated (Firebase Backend Resilience Plan). Each project deploys only through its own guard, from any cwd — start with --status:
    tinker-hq-apps rules:   /Users/christiehubley/studio-hub/scripts/deploy-rules.sh --status
    my-clay-hub rules:      /Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh --status
    my-clay-hub functions:  /Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh --status --codebase <name>
Christie's phrase is 'approved to change firebase <full sha>' — --status prints the exact sentence and command, and --diff the change to paste when asking. An approval counts only for that project's guard, never the other one. If you only meant to read text containing 'firebase deploy', use Read/Grep instead of Bash. See ~/.claude/CLAUDE.md → FIREBASE RULES. Deleting a function, secrets, runtime config and artifact changes have no guarded path yet — ask Christie." \
  '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
exit 0
