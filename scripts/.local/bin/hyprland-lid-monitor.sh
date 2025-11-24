#!/bin/bash
# Monitor for lid close events and handle display switching in Hyprland

exec >> /tmp/hyprland-lid-monitor.log 2>&1

echo "[$(date)] Hyprland lid monitor started, PID=$$"

# Get the DISPLAY variable - it may be from the parent session
if [ -z "$DISPLAY" ]; then
    DISPLAY=$(ps -u $(id -u) -o pid= | xargs -I {} sh -c 'cat /proc/{}/environ 2>/dev/null | tr "\0" "\n" | grep "^DISPLAY="' | head -1 | cut -d= -f2)
fi
echo "[$(date)] Using DISPLAY=$DISPLAY"

# Function to handle lid event
handle_lid_event() {
    local LID_STATE="$1"
    echo "[$(date)] Lid state changed to: $LID_STATE"
    
    if [ "$LID_STATE" = "closed" ]; then
        AC_STATUS=$(cat /sys/class/power_supply/ADP1/online 2>/dev/null)
        echo "[$(date)] AC_STATUS=$AC_STATUS"
        if [ "$AC_STATUS" = "1" ]; then
            echo "[$(date)] Lid closed + AC power - switching to external display"
            DISPLAY="$DISPLAY" xrandr --output HDMI-A-1 --primary --auto --output eDP-1 --off 2>&1 | tee -a /tmp/hyprland-lid-monitor.log
            echo "[$(date)] Display switch executed"
        else
            echo "[$(date)] Lid closed + battery - suspending system"
            systemctl suspend
        fi
    else
        echo "[$(date)] Lid opened - restoring both displays"
        DISPLAY="$DISPLAY" xrandr --output eDP-1 --primary --auto --output HDMI-A-1 --auto --right-of eDP-1 2>&1 | tee -a /tmp/hyprland-lid-monitor.log
        echo "[$(date)] Display restore executed"
    fi
}

# Polling loop - check every 0.5 seconds for state changes
echo "[$(date)] Starting lid state polling..."
PREV_STATE=""
while true; do
    CURRENT_STATE=$(cat /proc/acpi/button/lid/LID0/state 2>/dev/null | grep -o "open\|closed")
    
    if [ -z "$CURRENT_STATE" ]; then
        echo "[$(date)] ERROR: Could not read lid state"
        sleep 1
        continue
    fi
    
    if [ "$CURRENT_STATE" != "$PREV_STATE" ]; then
        handle_lid_event "$CURRENT_STATE"
        PREV_STATE="$CURRENT_STATE"
    fi
    
    sleep 0.5
done
