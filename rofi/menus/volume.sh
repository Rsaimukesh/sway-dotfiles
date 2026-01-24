#!/bin/sh

STYLE="$HOME/.config/rofi/launchers/type-5/style-3.rasi"

choice=$(printf "🔊 Volume Up\n🔉 Volume Down\n🔇 Mute" | \
rofi -dmenu -p "Volume" -theme "$STYLE")

case "$choice" in
  *Up) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
  *Down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
  *Mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
esac
