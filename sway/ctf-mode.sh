#!/bin/bash
# ─────────────────────────────────────────
#  CTF LEAN MODE — kills heavy services,
#  strips gaps, launches minimal waybar
# ─────────────────────────────────────────

echo "[CTF] Entering lean mode..."

# Kill heavy background services
pkill -x mako
pkill -x wob
pkill -f "wl-paste"
pkill -f "cliphist"
pkill -f "battery_notify.sh"
pkill -x waybar

# Strip gaps and borders for more screen space
swaymsg gaps inner all set 0
swaymsg gaps outer all set 0
swaymsg default_border pixel 1

# Launch minimal waybar (clock + battery only)
waybar -c ~/.config/waybar/ctf-config -s ~/.config/waybar/ctf-style.css &

# Override Mod+Return to launch foot
# (sway variables can't be changed at runtime, so we rebind the key directly)
swaymsg 'bindsym Mod4+Return exec foot'

echo "[CTF] Lean mode active. Mod+Enter now opens foot."
notify-send "CTF Mode ON" "Lean mode active — foot terminal, minimal waybar" --urgency=normal 2>/dev/null || true
