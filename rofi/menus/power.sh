#!/bin/bash
# ~/.config/rofi/menus/power.sh
# Power menu with live system stats shown as message

# ── gather stats ────────────────────────────────────────────
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
RAM_USED=$(free -h | awk '/^Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -n | tail -1)
TEMP=$((TEMP / 1000))
BAT=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
BAT_STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1)
DISK=$(df -h / | awk 'NR==2 {print $5 " used, " $4 " free"}')
UPTIME=$(uptime -p | sed 's/up //')
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -n1)

MSG="  CPU: ${CPU}%    RAM: ${RAM_USED}/${RAM_TOTAL}    Temp: ${TEMP}°C\n  Battery: ${BAT}% (${BAT_STATUS})    Vol: ${VOL}    Disk: ${DISK}\n  Uptime: ${UPTIME}"

# ── options ─────────────────────────────────────────────────
OPTIONS="⟳  Reload Sway\n  Lock Screen\n⏾  Suspend\n  Hibernate\n↺  Reboot\n⏻  Shutdown"

CHOSEN=$(echo -e "$OPTIONS" | rofi \
  -dmenu \
  -p "  Power" \
  -mesg "$MSG" \
  -theme-str '
    window { width: 360px; border-radius: 16px; }
    mainbox { padding: 12px; }
    message { padding: 8px 12px; border-radius: 10px; }
    listview { lines: 6; }
    element { border-radius: 10px; padding: 10px 14px; }
  ')

case "$CHOSEN" in
  "⟳  Reload Sway")   swaymsg reload ;;
  "  Lock Screen")   loginctl lock-session ;;
  "⏾  Suspend")       systemctl suspend ;;
  "  Hibernate")    systemctl hibernate ;;
  "↺  Reboot")        systemctl reboot ;;
  "⏻  Shutdown")      systemctl poweroff ;;
esac
