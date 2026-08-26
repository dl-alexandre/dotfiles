#!/bin/zsh
# Rebalance a workspace after it loses a window. AeroSpace currently has no
# window-closed subscription event, so this uses a lightweight periodic snapshot.
# It deliberately never closes windows based on an empty or late-loading title.
#
# Started by ~/Library/LaunchAgents/com.dl-alexandre.aerospace-autobalance.plist

set -u

AEROSPACE=/opt/homebrew/bin/aerospace
[ -x "$AEROSPACE" ] || AEROSPACE="$HOME/.local/bin/aerospace"
[ -x "$AEROSPACE" ] || AEROSPACE=/usr/local/bin/aerospace

INTERVAL=2

typeset -A counts

snapshot_counts() {
    "$AEROSPACE" list-windows --all --format '%{workspace}' 2>/dev/null \
        | /usr/bin/awk 'NF { count[$0]++ } END { for (ws in count) print ws "\t" count[ws] }'
}

while true; do
    while IFS=$'\t' read -r ws n; do
        [ -z "$ws" ] && continue
        prev="${counts[$ws]:-}"
        if [ -n "$prev" ] && [ "$n" -lt "$prev" ] && [ "$n" -gt 0 ]; then
            "$AEROSPACE" balance-sizes --workspace "$ws" >/dev/null 2>&1
        fi
        counts[$ws]=$n
    done < <(snapshot_counts)

    sleep "$INTERVAL"
done
