#!/bin/bash
# PreToolUse guard for `firebase deploy`.
#
# All 21 Tinker apps share one Firebase project and therefore ONE rules file,
# /Users/christiehubley/studio-hub/firestore.rules. A rules deploy run from any
# other repo replaces that file's rules for every app at once.
#
# Two things are checked, because either alone leaves a hole:
#   1. the session's working directory must be studio-hub
#   2. the command must not `cd` somewhere else first — with the session in
#      studio-hub, `cd ~/recap && firebase deploy` passes check 1 while
#      actually deploying from recap.
STUDIO_HUB="/Users/christiehubley/studio-hub"

cmd="$(jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

# Not a firebase deploy: nothing to say.
printf '%s' "$cmd" | grep -qE '(^|[;&|]|[[:space:]])firebase[[:space:]]+deploy([[:space:]]|$)' || exit 0

deny() {
  jq -n --arg reason "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$reason}}'
  exit 0
}

cwd="$(pwd)"
if [ "$cwd" != "$STUDIO_HUB" ]; then
  deny "firebase deploy must be run from $STUDIO_HUB (current directory: $cwd). cd there first, then retry."
fi

# Every `cd` in the command must target studio-hub. Tilde and quotes are
# normalised; a bare `cd` (home) or `cd -` counts as leaving.
printf '%s' "$cmd" \
  | grep -oE '(^|[;&|]|[[:space:]])cd([[:space:]]+[^;&|]*)?' \
  | sed -E 's/^[^c]*cd//' \
  | while IFS= read -r target; do
      target="$(printf '%s' "$target" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/^"//; s/"$//; s/^'"'"'//; s/'"'"'$//')"
      target="${target/#\~/$HOME}"
      target="${target%/}"
      [ "$target" = "$STUDIO_HUB" ] && continue
      printf 'BADCD:%s\n' "${target:-<home>}"
    done | grep -q '^BADCD:' && {
      bad="$(printf '%s' "$cmd" | grep -oE 'cd[[:space:]]+[^;&|]*' | head -1)"
      deny "This command changes directory before deploying ($bad). firebase deploy must actually run in $STUDIO_HUB — a deploy from anywhere else would overwrite the shared rules for all Tinker apps. Run the deploy without the cd, from $STUDIO_HUB."
    }

exit 0
