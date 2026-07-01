#!/bin/bash
# ~/.config/waybar/scripts/battery_notify.sh
# Enhanced battery monitor with low/critical/full charge alerts

BAT_PATH="/sys/class/power_supply/BAT1"
SOUND_DIR="$HOME/.local/share/sounds"

LOW=30
CRITICAL=10
FULL=100

LOW_SOUND="$SOUND_DIR/battery-low.wav"
CRITICAL_SOUND="$SOUND_DIR/battery-critical.wav"
FULL_SOUND="$SOUND_DIR/battery-full.wav"

# ── Wayland / PulseAudio env ─────────────────────────────────
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export PULSE_SERVER="unix:$XDG_RUNTIME_DIR/pulse/native"
export WAYLAND_DISPLAY="wayland-0"
export XDG_SESSION_TYPE="wayland"

NOTIFIED_LOW=0
NOTIFIED_CRITICAL=0
NOTIFIED_FULL=0

while true; do
  CAPACITY=$(cat "$BAT_PATH/capacity" 2>/dev/null)
  STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)

  echo "[battery_notify] $CAPACITY% | $STATUS"

  # ── DISCHARGING alerts ───────────────────────────────────
  if [[ "$STATUS" == "Discharging" ]]; then
    NOTIFIED_FULL=0   # reset full flag when unplugged

    if [ "$CAPACITY" -le "$CRITICAL" ] && [ "$NOTIFIED_CRITICAL" -eq 0 ]; then
      notify-send -u critical -i battery-caution \
        "Battery CRITICAL" "${CAPACITY}% — plug in now!"
      sleep 0.3
      paplay "$CRITICAL_SOUND" 2>/dev/null
      NOTIFIED_CRITICAL=1
      NOTIFIED_LOW=1
      sleep 300
      continue

    elif [ "$CAPACITY" -le "$LOW" ] && [ "$NOTIFIED_LOW" -eq 0 ]; then
      notify-send -u normal -i battery-low \
        "Battery LOW" "${CAPACITY}% remaining"
      sleep 0.3
      paplay "$LOW_SOUND" 2>/dev/null
      NOTIFIED_LOW=1
      sleep 300
      continue
    fi

    # Reset critical flag if capacity rises (e.g. brief charge)
    [ "$CAPACITY" -gt "$CRITICAL" ] && NOTIFIED_CRITICAL=0
    [ "$CAPACITY" -gt "$LOW" ]      && NOTIFIED_LOW=0

  # ── CHARGING / FULL alerts ───────────────────────────────
  elif [[ "$STATUS" == "Charging" || "$STATUS" == "Full" ]]; then
    NOTIFIED_LOW=0
    NOTIFIED_CRITICAL=0

    if [ "$CAPACITY" -ge "$FULL" ] && [ "$NOTIFIED_FULL" -eq 0 ]; then
      notify-send -u low -i battery-full \
        "Battery Full" "You can unplug now."
      paplay "$FULL_SOUND" 2>/dev/null
      NOTIFIED_FULL=1
    fi
  fi

  sleep 60
done
