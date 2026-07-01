#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"
WALLPAPER_DIR="$HOME/Pictures"
SWAY_CONFIG="$CONFIG_DIR/sway/config"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[x]${NC} $1"; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

cleanup() {
    if [ $? -ne 0 ]; then
        echo
        err "Setup failed at step: $CURRENT_STEP"
    fi
}
trap cleanup EXIT

CURRENT_STEP="initializing"

echo "========================================"
echo "  Sway Dotfiles — Full Setup"
echo "========================================"
echo

# ── 1. INSTALL DEPENDENCIES ──────────────────────────────────
CURRENT_STEP="installing dependencies"
info "Checking distribution..."
if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
elif command -v zypper &>/dev/null; then
    PKG_MANAGER="zypper"
    INSTALL_CMD="sudo zypper install -y"
else
    warn "Unsupported package manager. Install dependencies manually (see dependencies.txt)."
fi

if [ -n "${PKG_MANAGER:-}" ]; then
    log "Package manager detected: $PKG_MANAGER"
    read -rp "Install required packages? [Y/n] " REPLY
    if [[ ! "$REPLY" =~ ^[Nn] ]]; then
        log "Installing dependencies..."

        if [ "$PKG_MANAGER" = "apt" ]; then
            sudo apt update
            # Install all packages from dependencies.txt (skip comments/empty lines)
            while IFS= read -r pkg; do
                [ -z "$pkg" ] && continue
                [[ "$pkg" =~ ^# ]] && continue
                PKGS="$PKGS $pkg"
            done < "$REPO_DIR/dependencies.txt"
            # Add extras not in deps.txt
            PKGS="$PKGS playerctl foot blueman pavucontrol curl wget unzip"
            sudo apt install -y $PKGS
        elif [ "$PKG_MANAGER" = "pacman" ]; then
            sudo pacman -S --noconfirm sway swaylock waybar rofi kitty mako grim slurp wl-clipboard brightnessctl network-manager-applet qalculate-gtk thunar libinput-gestures libinput playerctl foot blueman pavucontrol curl wget unzip
        elif [ "$PKG_MANAGER" = "dnf" ]; then
            sudo dnf install -y sway swaylock waybar rofi kitty mako grim slurp wl-clipboard brightnessctl nm-connection-editor qalculate-gtk thunar libinput-gestures libinput playerctl foot blueman pavucontrol curl wget unzip
        elif [ "$PKG_MANAGER" = "zypper" ]; then
            sudo zypper install -y sway swaylock waybar rofi kitty mako-notifier grim slurp wl-clipboard brightnessctl nm-connection-editor qalculate-gtk thunar libinput-gestures libinput-tools playerctl foot blueman pavucontrol curl wget unzip
        fi
        log "Dependencies installed."
    else
        warn "Skipping package installation."
    fi
fi

# ── 2. NERD FONT ──────────────────────────────────────────────
CURRENT_STEP="installing Nerd Font"
FONT_NAME="JetBrainsMono"
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list | grep -qi "$FONT_NAME" 2>/dev/null; then
    read -rp "Install JetBrainsMono Nerd Font? [Y/n] " REPLY
    if [[ ! "$REPLY" =~ ^[Nn] ]]; then
        log "Downloading JetBrainsMono Nerd Font..."
        mkdir -p "$FONT_DIR"
        curl -fLo /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        unzip -qo /tmp/JetBrainsMono.zip -d "$FONT_DIR" 2>/dev/null
        rm -f /tmp/JetBrainsMono.zip
        fc-cache -fv "$FONT_DIR" 2>/dev/null
        log "Font installed."
    fi
else
    log "JetBrainsMono Nerd Font already installed."
fi

# ── 3. CREATE DIRECTORIES ─────────────────────────────────────
CURRENT_STEP="creating directories"
log "Creating config directories..."
mkdir -p "$CONFIG_DIR" "$LOCAL_BIN" "$LOCAL_SHARE/sounds" "$WALLPAPER_DIR"

# ── 4. LINK CONFIG FILES ──────────────────────────────────────
CURRENT_STEP="linking configs"
log "Linking configurations..."

# Backup existing configs
for dir in sway waybar rofi kitty mako wob; do
    if [ -e "$CONFIG_DIR/$dir" ] && [ ! -L "$CONFIG_DIR/$dir" ]; then
        warn "Backing up existing $CONFIG_DIR/$dir → $CONFIG_DIR/${dir}.bak"
        mv "$CONFIG_DIR/$dir" "$CONFIG_DIR/${dir}.bak"
    fi
done
if [ -e "$CONFIG_DIR/libinput-gestures.conf" ] && [ ! -L "$CONFIG_DIR/libinput-gestures.conf" ]; then
    warn "Backing up existing libinput-gestures.conf → libinput-gestures.conf.bak"
    mv "$CONFIG_DIR/libinput-gestures.conf" "$CONFIG_DIR/libinput-gestures.conf.bak"
fi

ln -sf "$REPO_DIR/sway"   "$CONFIG_DIR/sway"
ln -sf "$REPO_DIR/waybar" "$CONFIG_DIR/waybar"
ln -sf "$REPO_DIR/rofi"   "$CONFIG_DIR/rofi"
ln -sf "$REPO_DIR/kitty"  "$CONFIG_DIR/kitty"
ln -sf "$REPO_DIR/mako"   "$CONFIG_DIR/mako"
ln -sf "$REPO_DIR/wob"    "$CONFIG_DIR/wob"
ln -sf "$REPO_DIR/gestures/libinput-gestures.conf" "$CONFIG_DIR/libinput-gestures.conf"

log "Configs linked."

# ── 5. INSTALL SCRIPTS ────────────────────────────────────────
CURRENT_STEP="installing scripts"
log "Installing scripts..."
cp "$REPO_DIR/waybar/scripts/battery_notify.sh" "$LOCAL_BIN/battery_notify.sh"
chmod +x "$LOCAL_BIN"/*.sh "$REPO_DIR/sway"/*.sh "$REPO_DIR/waybar/scripts"/*.sh 2>/dev/null || true

# ── 6. WALLPAPER SETUP ────────────────────────────────────────
CURRENT_STEP="setting up wallpaper"
log "Setting up wallpaper..."

AVAILABLE_WALLPAPERS=("$REPO_DIR/assets/wallpapers"/*)
echo "Available wallpapers:"
select WP in "${AVAILABLE_WALLPAPERS[@]}" "Skip"; do
    if [ "$WP" = "Skip" ]; then
        warn "Skipping wallpaper setup. Update path manually in $SWAY_CONFIG."
        break
    fi
    if [ -n "$WP" ]; then
        WP_BASENAME=$(basename "$WP")
        cp "$WP" "$WALLPAPER_DIR/$WP_BASENAME"
        log "Wallpaper copied to $WALLPAPER_DIR/$WP_BASENAME"

        # Update sway config wallpaper path
        sed -i "s|^output \* bg .*|output * bg $WALLPAPER_DIR/$WP_BASENAME fill|" "$SWAY_CONFIG"
        log "Sway config updated with wallpaper path."
        break
    fi
    echo "Invalid selection."
done

# ── 7. DOWNLOAD NOTIFICATION SOUNDS ───────────────────────────
CURRENT_STEP="downloading sounds"
log "Downloading notification sounds..."
if [ ! -f "$LOCAL_SHARE/sounds/battery-low.wav" ]; then
    wget -qO "$LOCAL_SHARE/sounds/battery-low.wav" "https://actions.google.com/sounds/v1/alarms/beep_short.ogg" 2>/dev/null || warn "Could not download battery-low.wav"
fi
if [ ! -f "$LOCAL_SHARE/sounds/battery-critical.wav" ]; then
    wget -qO "$LOCAL_SHARE/sounds/battery-critical.wav" "https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg" 2>/dev/null || warn "Could not download battery-critical.wav"
fi
log "Sounds ready."

# ── 8. INPUT GROUP ────────────────────────────────────────────
CURRENT_STEP="configuring input group"
if ! groups "$USER" | grep -q '\binput\b'; then
    log "Adding user to 'input' group (required for gestures)..."
    sudo gpasswd -a "$USER" input 2>/dev/null || warn "Could not add to input group. Do it manually: sudo gpasswd -a $USER input"
    warn "You'll need to log out and back in for group changes to take effect."
else
    log "User already in 'input' group."
fi

# ── 9. GESTURES SERVICE ───────────────────────────────────────
CURRENT_STEP="setting up gestures"
log "Setting up libinput-gestures..."
if command -v libinput-gestures-setup &>/dev/null; then
    libinput-gestures-setup autostart 2>/dev/null || true
    libinput-gestures-setup start 2>/dev/null || true
    log "libinput-gestures autostart configured."
fi

# ── 10. CLIPBOARD SERVICE ─────────────────────────────────────
CURRENT_STEP="setting up clipboard"
log "Setting up cliphist (clipboard manager)..."
if command -v cliphist &>/dev/null; then
    mkdir -p "$HOME/.local/share/wl-clipboard"
    log "cliphist found."
else
    warn "cliphist not found. Install it from your package manager or build from source."
fi

# ── 11. FINAL TOUCHES ─────────────────────────────────────────
CURRENT_STEP="finalizing"
log "Making scripts executable..."
chmod +x "$REPO_DIR/waybar/scripts"/*.sh "$REPO_DIR/sway/ctf-mode.sh" "$REPO_DIR/sway/normal-mode.sh" 2>/dev/null || true

echo
echo "========================================"
echo -e "${GREEN}  Setup complete!${NC}"
echo "========================================"
echo
info "Next steps:"
echo "  1. Log out and back in (if group changes were made)."
echo "  2. Start Sway: log in via a TTY and run 'sway' or select Sway from your DM."
echo "  3. Once in Sway:"
echo "     - Reload config:  Super+Shift+R"
echo "     - Restart Waybar: pkill waybar && waybar &"
echo "     - Check Waybar:   waybar -l debug"
echo "  4. Adjust paths in $SWAY_CONFIG if needed:"
echo "     - Lock screen image (Super+L): update 'swaylock -i <path>'"
echo "     - Wallpaper: update 'output * bg <path>'"
echo "  5. Install a clipboard manager if cliphist wasn't available."
echo
