#!/bin/bash
# Tests for scripts/firebase-deploy-hook.sh — the deny matrix (raw deploys + F12's function-changing commands), the
# allow cases, and the documented split-line gap. Run: bash scripts/firebase-deploy-hook.test.sh
# (Written with the Write tool, never typed into a Bash command: the hook would deny the command itself.)
# Plans: thoughts/plans/firebase-deploy-guard.html; thoughts/plans/firebase-functions-deploy-guard.html (F12, D2-4).
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/firebase-deploy-hook.sh"
PASS=0; FAIL=0

run_hook() { /usr/bin/jq -n --arg c "$1" '{tool_input: {command: $c}}' | bash "$HOOK"; }
deny() {
  local out code
  out="$(run_hook "$1")"; code=$?
  if [ "$code" = 0 ] && [ "$(printf '%s' "$out" | /usr/bin/jq -r '.hookSpecificOutput.permissionDecision' 2>/dev/null)" = deny ] \
     && printf '%s' "$out" | grep -qF 'my-clay-hub functions:  /Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh --status --codebase <name>' \
     && printf '%s' "$out" | grep -qF 'tinker-hq-apps rules:   /Users/christiehubley/studio-hub/scripts/deploy-rules.sh --status' \
     && printf '%s' "$out" | grep -qF 'my-clay-hub rules:      /Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh --status' \
     && printf '%s' "$out" | grep -qF 'have no guarded path yet — ask Christie'; then
    PASS=$((PASS+1)); printf '  ✓ denied:  %s\n' "$1"
  else
    FAIL=$((FAIL+1)); printf '  ✗ NOT denied (exit %s): %s\n      %s\n' "$code" "$1" "$out"
  fi
}
allow() {
  local out code
  out="$(run_hook "$1")"; code=$?
  if [ "$code" = 0 ] && [ -z "$out" ]; then PASS=$((PASS+1)); printf '  ✓ allowed: %s\n' "$1"
  else FAIL=$((FAIL+1)); printf '  ✗ NOT allowed (exit %s): %s\n      %s\n' "$code" "$1" "$out"; fi
}

echo "raw deploys (unchanged)"
deny 'firebase deploy'
deny 'firebase deploy --only functions:core'
deny 'cd ~/my-clay-hub && firebase deploy --only firestore:rules --project my-clay-hub'
deny 'npx firebase-tools deploy'
deny './node_modules/.bin/firebase deploy'
deny '/Users/christiehubley/my-clay-hub/node_modules/.bin/firebase --project my-clay-hub deploy'
deny 'node node_modules/firebase-tools/lib/bin/firebase.js deploy --only functions:core'
deny 'firebase deploy;ls'
deny 'x=$(firebase deploy)'
deny 'firebase deploy&& echo done'
deny 'firebase deploy|tee log'
deny 'echo `firebase deploy`'

echo "F12: function-changing commands"
for sub in 'functions:delete canary --region us-central1' 'functions:deletegcfartifacts' \
           'functions:secrets:set API_KEY' 'functions:secrets:destroy API_KEY' 'functions:secrets:prune' \
           'functions:secrets:access API_KEY' 'functions:artifacts:setpolicy' \
           'functions:config:set a.b=c' 'functions:config:unset a' 'functions:config:clone --from x' 'functions:config:export'; do
  deny "firebase ${sub}"
  deny "npx firebase-tools --project my-clay-hub ${sub}"
  deny "cd /tmp && /Users/christiehubley/my-clay-hub/node_modules/.bin/firebase ${sub}"
done
deny 'firebase functions:delete'                        # at the very end of the command
deny 'firebase functions:deletegcfartifacts'            # the longer alternative on its own
deny 'x=$(firebase functions:config:export)'
deny "bash -c 'firebase functions:secrets:access KEY'"
deny 'node node_modules/firebase-tools/lib/bin/firebase.js functions:delete canary'

echo "allowed: read-only siblings and unrelated commands"
allow 'ls'
allow 'firebase functions:list --json --project my-clay-hub'
allow 'firebase functions:log'
allow 'firebase functions:secrets:get API_KEY'
allow 'firebase functions:secrets:describe API_KEY'
allow 'firebase functions:config:get'
allow 'firebase functions:deletefoo'                    # not a command; the anchor keeps it from matching delete
allow 'firebase emulators:start --only functions'
allow 'echo "firebase deploy"'                          # a quoted mention (documented)
allow 'bash /Users/christiehubley/tinker-ai-configs/scripts/firebase-deploy-hook.sh'
allow '/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh --status --codebase core'
allow 'firebase functions:list; ./deploy-thing'         # the separator ends the firebase command

echo "the documented gap: a backslash-newline split is not caught (the predeploy backstop still refuses a deploy)"
allow $'firebase \\\n  functions:delete canary'
allow $'firebase \\\n  deploy'
echo "the documented gap: a subcommand directly followed by a quote (the rule that lets a quoted mention through)"
allow 'bash -c "firebase deploy"'
allow 'bash -c "firebase functions:secrets:prune"'
deny 'bash -c "firebase functions:delete canary"'     # …but only when the quote is DIRECTLY after the subcommand
deny 'bash -c "firebase deploy --only functions:core"'

echo
echo "hook tests: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
