#!/bin/sh

STYLE="$HOME/.config/rofi/launchers/type-5/style-3.rasi"

choice=$(printf "🔆 Brightness Up\n🔅 Brightness Down" | \
rofi -dmenu -p "Brightness" -theme "$STYLE")

case "$choice" in
  *Up) brightnessctl set +5% ;;
  *Down) brightnessctl set 5%- ;;
esac
