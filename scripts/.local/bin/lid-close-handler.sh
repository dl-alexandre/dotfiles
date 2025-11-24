#!/bin/bash

# Log for debugging
exec >> /tmp/lid-close-handler.log 2>&1
echo "[$(date)] Lid close event detected"

# Check if plugged into power
if grep -q "^1$" /sys/class/power_supply/ADP1/online 2>/dev/null; then
    echo "[$(date)] AC power detected - switching to external display"
    # Switch to external display only
    DISPLAY=:0 xrandr --output HDMI-A-1 --primary --auto --output eDP-1 --off
else
    echo "[$(date)] On battery - suspending"
    systemctl suspend
fi
