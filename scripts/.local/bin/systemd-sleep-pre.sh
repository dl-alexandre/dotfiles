#!/bin/bash
# This runs before sleep/suspend
# Called by systemd with: $1 = "pre" and $2 = "suspend|hibernate|hybrid-sleep"

[ "$1" = "pre" ] || exit 0

# Check if lid is closed and AC is connected
if grep -q "closed" /proc/acpi/button/lid/LID0/state 2>/dev/null && \
   grep -q "^1$" /sys/class/power_supply/ADP1/online 2>/dev/null; then
    echo "Lid closed + AC power: switching to external display instead of suspending"
    DISPLAY=:0 xrandr --output HDMI-A-1 --primary --auto --output eDP-1 --off
    exit 1  # Prevent sleep
fi

exit 0
