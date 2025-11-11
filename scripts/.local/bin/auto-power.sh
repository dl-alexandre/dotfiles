#!/bin/bash
# Auto-switch CPU governor and thermal policy based on charging state

STATUS=$(cat /sys/class/power_supply/*/status 2>/dev/null | grep -i "charging\|full" | head -1)

if [[ "$STATUS" =~ "Charging"|"Full" ]]; then
  GOVERNOR="performance"
  POLICY="fair_share"
  MSG="Performance mode (charging)"
else
  GOVERNOR="powersave"
  POLICY="step_wise"
  MSG="Power save mode (battery)"
fi

echo "Switching to $GOVERNOR governor and $POLICY thermal policy..."
echo "$GOVERNOR" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
echo "$POLICY" | sudo tee /sys/class/thermal/thermal_zone*/policy > /dev/null

notify-send "Power Profile" "$MSG"
