#!/bin/bash

LOW=30
CRITICAL=15

BATTERY_PATH="/sys/class/power_supply/BAT0"
STATUS=$(cat "$BATTERY_PATH/status")
CAPACITY=$(cat "$BATTERY_PATH/capacity")

LOW_SOUND="$HOME/.local/share/sounds/battery-low.wav"
CRITICAL_SOUND="$HOME/.local/share/sounds/battery-critical.wav"

# Only notify when discharging
[ "$STATUS" != "Discharging" ] && exit 0

STATE_FILE="/tmp/battery_notify_state"
LAST=$(cat "$STATE_FILE" 2>/dev/null || echo 100)

if [ "$CAPACITY" -le "$CRITICAL" ] && [ "$LAST" -gt "$CRITICAL" ]; then
    notify-send -u critical "🔴 Battery Critical" "Battery at ${CAPACITY}%!\nPlug in NOW."
    paplay "$CRITICAL_SOUND"
    echo "$CAPACITY" > "$STATE_FILE"

elif [ "$CAPACITY" -le "$LOW" ] && [ "$LAST" -gt "$LOW" ]; then
    notify-send -u normal "🟠 Battery Low" "Battery at ${CAPACITY}%"
    paplay "$LOW_SOUND"
    echo "$CAPACITY" > "$STATE_FILE"
fi
