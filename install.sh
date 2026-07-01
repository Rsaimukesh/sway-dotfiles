#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"

echo "📦 Installing Sway dotfiles..."

# Create directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_BIN"
mkdir -p "$LOCAL_SHARE/sounds"

# Install configs
echo "📁 Linking configurations..."
ln -sf "$REPO_DIR/sway" "$CONFIG_DIR/sway"
ln -sf "$REPO_DIR/waybar" "$CONFIG_DIR/waybar"
ln -sf "$REPO_DIR/rofi" "$CONFIG_DIR/rofi"
ln -sf "$REPO_DIR/kitty" "$CONFIG_DIR/kitty"
ln -sf "$REPO_DIR/mako" "$CONFIG_DIR/mako"
ln -sf "$REPO_DIR/wob" "$CONFIG_DIR/wob"
ln -sf "$REPO_DIR/gestures/libinput-gestures.conf" "$CONFIG_DIR/libinput-gestures.conf"

# Install battery notification script
echo "🔋 Installing battery monitor..."
mkdir -p "$LOCAL_BIN"
cp "$REPO_DIR/waybar/scripts/battery_notify.sh" "$LOCAL_BIN/battery_notify.sh"
chmod +x "$LOCAL_BIN/battery_notify.sh"

# Download notification sounds
echo "🔊 Downloading notification sounds..."
mkdir -p "$LOCAL_SHARE/sounds"
wget -O "$LOCAL_SHARE/sounds/battery-low.wav" https://actions.google.com/sounds/v1/alarms/beep_short.ogg 2>/dev/null || echo "⚠️  Warning: Could not download battery-low.wav"
wget -O "$LOCAL_SHARE/sounds/battery-critical.wav" https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg 2>/dev/null || echo "⚠️  Warning: Could not download battery-critical.wav"

echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Review and adjust configs in ~/.config/sway, ~/.config/waybar, etc."
echo "2. Reload Sway: swaymsg reload"
echo "3. Restart Waybar: pkill waybar && waybar &"
echo ""
