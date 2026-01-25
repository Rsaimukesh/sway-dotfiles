#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT1"
SOUND_DIR="$HOME/.local/share/sounds"

LOW=20
CRITICAL=10

LOW_SOUND="$SOUND_DIR/battery-low.wav"
CRITICAL_SOUND="$SOUND_DIR/battery-critical.wav"

# ---- REQUIRED ENV FOR SWAY ----
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export PULSE_SERVER="unix:$XDG_RUNTIME_DIR/pulse/native"
export WAYLAND_DISPLAY="wayland-0"
export XDG_SESSION_TYPE="wayland"

while true; do
  CAPACITY=$(cat "$BAT_PATH/capacity")
  STATUS=$(cat "$BAT_PATH/status")

  echo "Battery: $CAPACITY% | $STATUS"

  if [[ "$STATUS" != "Charging" ]]; then
    if [ "$CAPACITY" -le "$CRITICAL" ]; then
      notify-send -u critical "🔋 Battery CRITICAL" "$CAPACITY% remaining"
      sleep 0.3
      paplay "$CRITICAL_SOUND"
      sleep 300

    elif [ "$CAPACITY" -le "$LOW" ]; then
      notify-send -u normal "🔋 Battery LOW" "$CAPACITY% remaining"
      sleep 0.3
      paplay "$LOW_SOUND"
      sleep 300
    fi
  fi

  sleep 60
done
