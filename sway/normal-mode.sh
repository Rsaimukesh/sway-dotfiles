#!/bin/bash
# ─────────────────────────────────────────
#  NORMAL MODE RESTORE — restarts all
#  services killed by ctf-mode.sh
# ─────────────────────────────────────────

echo "[NORMAL] Restoring normal mode..."

# Kill CTF minimal waybar
pkill -x waybar

# Restore gaps and borders
swaymsg gaps inner all set 10
swaymsg gaps outer all set 5
swaymsg default_border pixel 2

# Restart all background services
mako &
mkfifo /tmp/wob 2>/dev/null || true
tail -f /tmp/wob | wob &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
~/.config/waybar/scripts/battery_notify.sh &

# Restart full waybar
sleep 1
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css &

# Restore Mod+Return back to kitty
swaymsg 'bindsym Mod4+Return exec kitty'

echo "[NORMAL] Normal mode restored."
notify-send "Normal Mode ON" "All services restored — kitty terminal back" --urgency=normal 2>/dev/null || true
