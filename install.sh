#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"
WALLPAPER_DIR="$HOME/Pictures"
SWAY_CONFIG="$CONFIG_DIR/sway/config"

echo "Installing Sway dotfiles..."

# ── directories ──
mkdir -p "$CONFIG_DIR" "$LOCAL_BIN" "$LOCAL_SHARE/sounds" "$WALLPAPER_DIR"

# ── link configs ──
echo "Linking configurations..."
ln -sf "$REPO_DIR/sway"   "$CONFIG_DIR/sway"
ln -sf "$REPO_DIR/waybar" "$CONFIG_DIR/waybar"
ln -sf "$REPO_DIR/rofi"   "$CONFIG_DIR/rofi"
ln -sf "$REPO_DIR/kitty"  "$CONFIG_DIR/kitty"
ln -sf "$REPO_DIR/mako"   "$CONFIG_DIR/mako"
ln -sf "$REPO_DIR/wob"    "$CONFIG_DIR/wob"
ln -sf "$REPO_DIR/gestures/libinput-gestures.conf" "$CONFIG_DIR/libinput-gestures.conf"

# ── scripts ──
echo "Installing scripts..."
cp "$REPO_DIR/waybar/scripts/battery_notify.sh" "$LOCAL_BIN/battery_notify.sh"
chmod +x "$LOCAL_BIN"/*.sh "$REPO_DIR/sway"/*.sh "$REPO_DIR/waybar/scripts"/*.sh 2>/dev/null || true

# ── wallpaper ──
echo ""
echo "Select a wallpaper:"
AVAILABLE_WALLPAPERS=("$REPO_DIR/assets/wallpapers"/*)
select WP in "${AVAILABLE_WALLPAPERS[@]}" "Skip"; do
    if [ "$WP" = "Skip" ]; then
        echo "Skipping wallpaper."
        break
    fi
    if [ -n "$WP" ]; then
        cp "$WP" "$WALLPAPER_DIR/wallpaper"
        sed -i "s|^output \* bg .*|output * bg $WALLPAPER_DIR/wallpaper fill|" "$SWAY_CONFIG"
        echo "Wallpaper set."
        break
    fi
    echo "Invalid selection."
done

# ── notification sounds ──
echo "Downloading notification sounds..."
wget -qO "$LOCAL_SHARE/sounds/battery-low.wav" "https://actions.google.com/sounds/v1/alarms/beep_short.ogg" 2>/dev/null || echo "Warning: Could not download battery-low.wav"
wget -qO "$LOCAL_SHARE/sounds/battery-critical.wav" "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg" 2>/dev/null || echo "Warning: Could not download battery-critical.wav"

echo ""
echo "Done."
echo ""
echo "Next steps:"
echo "  1. Set lock screen image: cp ~/path/to/image ~/Pictures/lockscreen"
echo "  2. Reload Sway: swaymsg reload"
echo "  3. Restart Waybar: pkill waybar && waybar &"
echo ""
