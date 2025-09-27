#!/usr/bin/env bash
set -euo pipefail

DEV="apple-inc.-apple-internal-keyboard-/-trackpad"

# Grab devices JSON once
JSON="$(hyprctl -j devices || true)"

# Try explicit variant first (newer Hyprland sometimes exposes it),
# then fall back to active_keymap string.
VARIANT="$(
  printf '%s' "$JSON" |
    jq -r --arg dev "$DEV" '
      (.keyboards[] | select(.name==$dev) | .variant // empty) // empty'
)"

if [[ -z "${VARIANT}" ]]; then
  KEYMAP="$(
    printf '%s' "$JSON" |
      jq -r --arg dev "$DEV" '
        (.keyboards[] | select(.name==$dev) | .active_keymap // empty) // empty'
  )"
else
  KEYMAP=""
fi

# Normalize to DV / US
out="US"
if [[ "${VARIANT,,}" == "dvorak" ]] || [[ "${KEYMAP,,}" =~ dvorak ]]; then
  out="DV"
fi

printf '%s\n' "$out"
