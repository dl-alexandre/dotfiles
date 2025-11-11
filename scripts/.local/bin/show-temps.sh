#!/bin/bash
for zone in /sys/class/thermal/thermal_zone*/; do
  name=$(basename "$zone")
  temp=$(cat "$zone/temp" 2>/dev/null | awk '{print $1/1000}')
  echo "$name: ${temp}°C"
done | notify-send "Thermal Zones" "$(cat)"
