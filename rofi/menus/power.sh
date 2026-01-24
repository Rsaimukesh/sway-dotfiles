#!/bin/sh

STYLE="$HOME/.config/rofi/launchers/type-5/style-3.rasi"

choice=$(printf "🔒 Lock\n💤 Suspend\n🔄 Reboot\n⏻ Shutdown\n❌ Cancel" | \
rofi -dmenu -p "Power" -theme "$STYLE")

case "$choice" in
  *Lock) swaylock ;;
  *Suspend) systemctl suspend ;;
  *Reboot) systemctl reboot ;;
  *Shutdown) systemctl poweroff ;;
esac
