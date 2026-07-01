#!/bin/bash
# ~/.config/waybar/scripts/weather.sh
# Fetches weather from wttr.in — outputs JSON for waybar (text + tooltip)
# Requires: curl

LOCATION="${WAYBAR_WEATHER_LOCATION:-}"   # set env var or leave blank for auto-detect

# Single request for display line
WEATHER=$(curl -sf --max-time 10 "https://wttr.in/${LOCATION}?format=%c+%t" 2>/dev/null)

if [ -z "$WEATHER" ]; then
  echo '{"text": "󰖙  N/A", "tooltip": "Weather unavailable", "class": "unavailable"}'
  exit 0
fi

# Detailed tooltip (one-line format)
TOOLTIP=$(curl -sf --max-time 10 "https://wttr.in/${LOCATION}?format=%C,+%t+(feels+%f)+💧%h+💨%w" 2>/dev/null)
TOOLTIP="${TOOLTIP:-No details available}"

# Escape for JSON
WEATHER_ESC=$(echo "$WEATHER" | sed 's/\\/\\\\/g; s/"/\\"/g')
TOOLTIP_ESC=$(echo "$TOOLTIP" | sed 's/\\/\\\\/g; s/"/\\"/g')

echo "{\"text\": \"$WEATHER_ESC\", \"tooltip\": \"$TOOLTIP_ESC\"}"
