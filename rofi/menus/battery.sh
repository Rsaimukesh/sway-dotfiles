#!/bin/sh

STYLE="$HOME/.config/rofi/launchers/type-5/style-3.rasi"

BAT=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
STAT=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)

choice=$(printf "🔋 Battery: %s%%\n⚡ Status: %s\n────────────\nPower Settings\nBattery Info\nClose" \
"$BAT" "$STAT" | rofi -dmenu -p "Battery" -theme "$STYLE")

case "$choice" in
  "Power Settings")
    xfce4-power-manager-settings 2>/dev/null || gnome-control-center power ;;
  "Battery Info")
    notify-send "Battery" "Level: $BAT%\nStatus: $STAT" ;;
esac
