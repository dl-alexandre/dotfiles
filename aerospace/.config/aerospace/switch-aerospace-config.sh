#!/bin/bash

# This script switches the AeroSpace configuration based on the number of connected monitors.

CONFIG_DIR="/Users/developer/.config/aerospace"
AEROSPACE_CONFIG="$CONFIG_DIR/aerospace.toml"
DESKTOP_CONFIG="$CONFIG_DIR/aerospace.toml.desktop"
LAPTOP_CONFIG="$CONFIG_DIR/aerospace.toml.laptop"

MONITOR_COUNT=$(~/.local/bin/aerospace list-monitors --count)

if [ "$MONITOR_COUNT" -gt 1 ]; then
    echo "Multiple monitors detected. Switching to desktop configuration."
    ln -sf "$DESKTOP_CONFIG" "$AEROSPACE_CONFIG"
else
    echo "Single monitor detected. Switching to laptop configuration."
    ln -sf "$LAPTOP_CONFIG" "$AEROSPACE_CONFIG"
fi

~/.local/bin/aerospace reload-config
