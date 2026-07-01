#!/bin/bash
# ~/.config/waybar/scripts/brightness.sh
# Shows brightness with tiered icon

RAW=$(brightnessctl -m 2>/dev/null | cut -d',' -f4)

LEVEL=${RAW//%/}

if   [ "$LEVEL" -ge 80 ]; then ICON=""
elif [ "$LEVEL" -ge 50 ]; then ICON=""
elif [ "$LEVEL" -ge 20 ]; then ICON=""
else                            ICON=""
fi

echo "$ICON $RAW"
