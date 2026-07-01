#!/bin/bash
# ~/.config/waybar/scripts/media.sh
# Shows currently playing media via playerctl
# Uses Nerd Font icons only (no emoji mixing)

PLAYER=$(playerctl -l 2>/dev/null | head -n1)

if [ -z "$PLAYER" ]; then
  echo ""
  exit 0
fi

STATUS=$(playerctl --player="$PLAYER" status 2>/dev/null)

if [ "$STATUS" = "Playing" ]; then
  ICON="󰎈"
elif [ "$STATUS" = "Paused" ]; then
  ICON="󰏤"
else
  echo ""
  exit 0
fi

TITLE=$(playerctl --player="$PLAYER" metadata title 2>/dev/null | cut -c1-25)
ARTIST=$(playerctl --player="$PLAYER" metadata artist 2>/dev/null | cut -c1-20)

if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
  echo "$ICON  $ARTIST — $TITLE"
elif [ -n "$TITLE" ]; then
  echo "$ICON  $TITLE"
else
  echo "$ICON"
fi
