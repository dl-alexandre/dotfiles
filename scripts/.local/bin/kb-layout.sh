#!/usr/bin/env bash
set -euo pipefail

DEV="apple-inc.-apple-internal-keyboard-/-trackpad"
JSON="$(hyprctl -j devices || true)"

read -r VARIANT KEYMAP < <(
  jq -r --arg dev "$DEV" '
    .keyboards[] | select(.name==$dev)
    | [.variant, .active_keymap] | @tsv
  ' <<<"$JSON"
)

# prefer active_keymap if it is meaningful
LAYOUT="$KEYMAP"

# fallback if active_keymap is empty
if [[ -z "$LAYOUT" || "$LAYOUT" == "null" ]]; then
  LAYOUT="$VARIANT"
fi

# Normalize
case "${LAYOUT,,}" in
*dvorak*) out="DV" ;;
*us* | *english*) out="US" ;;
*) out="??" ;; # unknown layout
esac

printf '%s\n' "$out"
