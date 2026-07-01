#!/bin/bash
# ~/.config/waybar/scripts/brightness.sh
# Shows brightness with tiered icon

RAW=$(brightnessctl -m -d amdgpu_bl0 2>/dev/null | cut -d',' -f4)
# Fallback to any backlight device
if [ -z "$RAW" ]; then
  RAW=$(brightnessctl -m | cut -d',' -f4)
fi

LEVEL=${RAW//%/}

if   [ "$LEVEL" -ge 80 ]; then ICON=""
elif [ "$LEVEL" -ge 50 ]; then ICON=""
elif [ "$LEVEL" -ge 20 ]; then ICON=""
else                            ICON=""
fi

echo "$ICON $RAW"
