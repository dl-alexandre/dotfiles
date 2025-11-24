#!/bin/bash

# This script runs before suspend to check if we should suppress it when plugged in
# Use with: systemd-sleep.conf or sleep.target

LID_STATE=$(cat /proc/acpi/button/lid/LID0/state 2>/dev/null | grep -o "open\|closed" || echo "unknown")

if [ "$LID_STATE" = "closed" ] && grep -q "^1$" /sys/class/power_supply/ADP1/online 2>/dev/null; then
    echo "Lid closed but AC powered - canceling suspend and switching displays"
    /home/alexandre/.local/bin/lid-close-handler.sh
    exit 1  # Prevent suspend
fi

exit 0  # Allow suspend
