# sway-config

Personal Wayland setup for Sway + Waybar with Rofi launchers/menus, Kitty, and multi-finger touchpad gestures via libinput-gestures.

## Included
- [sway/](sway/) – Sway WM config, keybindings, autostart
- [waybar/](waybar/) – Waybar modules, styles, and scripts (including battery notifications)
- [rofi/](rofi/) – Rofi app launcher (Type-7), powermenu (Type-6), applets, and scripts
- [kitty/](kitty/) – Kitty terminal config
- [mako/](mako/) – Mako notification daemon config
- [wob/](wob/) – WOB (overlay bar) config for volume/brightness
- [gestures/](gestures/) – Touchpad gestures (libinput-gestures)
- [assets/](assets/) – Wallpapers and notification sounds

## Requirements
Install the following packages (Debian/Ubuntu/Kali names):

See [dependencies.txt](dependencies.txt) for the complete package list.

Quick install:
```bash
sudo apt update && sudo apt install -y $(tr '\n' ' ' < dependencies.txt | sed 's/#.*//g')
```

Notes:
- `pactl` is used for audio volume; on PipeWire install `pipewire-pulse` (or `pulseaudio-utils` for PulseAudio).
- Fonts: install a Nerd Font for icons/glyphs (e.g., JetBrainsMono Nerd Font).
- Gestures: ensure your user is in the `input` group: `sudo gpasswd -a "$USER" input` then log out/in.

## Install / Update
Copy or symlink these into `~/.config`. Automated scripts are provided:

### Full Automated Setup (Recommended for new installs)
```bash
# From the repo root
bash setup.sh
```

This will:
- Install required system packages (with confirmation)
- Install JetBrainsMono Nerd Font (with confirmation)
- Back up existing configs, link all config directories to `~/.config/`
- Copy battery notification script to `~/.local/bin/`
- Set up wallpaper from `assets/wallpapers/` (interactive selection)
- Update sway config wallpaper path automatically
- Download notification sounds to `~/.local/share/sounds/`
- Add user to `input` group for gestures
- Configure and start libinput-gestures

### Quick Install (configs only)
```bash
bash install.sh
```
Links configs without dependency management or wallpaper setup.

### Manual Install
```bash
# From the repo root
ln -s "$PWD/sway" ~/.config/sway
ln -s "$PWD/waybar" ~/.config/waybar
ln -s "$PWD/rofi" ~/.config/rofi
ln -s "$PWD/kitty" ~/.config/kitty
ln -s "$PWD/mako" ~/.config/mako
ln -s "$PWD/wob" ~/.config/wob
ln -s "$PWD/gestures/libinput-gestures.conf" ~/.config/libinput-gestures.conf

# Copy battery script
mkdir -p ~/.local/bin
cp waybar/scripts/battery_notify.sh ~/.local/bin/battery_notify.sh
chmod +x ~/.local/bin/battery_notify.sh
```

### Autostart & Apply
- Sway autostarts Waybar, Mako, and Gestures (see [sway/config](sway/config)).
- Reload Sway after changes: `swaymsg reload`.
- If needed, restart Waybar: `pkill waybar || true && waybar &`.
- Refresh gestures: `libinput-gestures-setup restart`.

## Keybindings (Super = Win key)
From [sway/config](sway/config):

Applications
- Super (release): App launcher (Rofi Type-7)
- Super + Enter: Terminal (Kitty)
- Super + B: Browser (Firefox)
- Super + F: File manager (Thunar)
- Super + C: Clipboard menu (Rofi)
- Super + X: Power menu (Rofi Type-6)
- Super + L: Lock screen (swaylock)

CTF Mode
- Super + F1: CTF lean mode (kills services, minimal waybar, foot terminal)
- Super + F2: Restore normal mode (all services, kitty, full waybar)

Window management
- Focus: Super + Arrows (←/→/↑/↓)
- Move: Super + Shift + Arrows
- Split: Super + H (horizontal), Super + V (vertical)
- Layout: Super + S (stack), Super + W (tabbed), Super + E (toggle)
- Actions: Super + Space (float), Super + Shift + Space (focus mode toggle)
- Kill: Super + Q
- Fullscreen: Super + Shift + F

Workspaces
- Switch: Super + 1..0
- Move container: Super + Shift + 1..0
- Prev/Next workspace: Super + Ctrl + Left/Right

Screenshots
- Print: Full screen → `Pictures/screenshot_YYYY-MM-DD_HH:MM:SS.png`
- Super + Shift + S: Area to file (grim + slurp)
- Super + Ctrl + S: Area to clipboard (wl-copy)

Media & Hardware Keys
- Volume: XF86Audio{Raise/Lower/Mute} → `pactl`
- Brightness: XF86MonBrightness{Up/Down} → `brightnessctl`
- Mic Mute: XF86AudioMicMute → `pactl set-source-mute`
- Playback: XF86Audio{Play/Pause/Next/Prev/Stop} → `playerctl`
- Calculator: XF86Calculator → `qalculate-gtk`
- Lock: XF86ScreenSaver → `swaylock`

Session
- Super + Shift + R: Reload Sway
- Super + Shift + E: Exit Sway (confirmation dialog)
- Super + L: Lock screen

Touchpad
- Tap: enabled, Natural scroll: enabled, Middle emulation: enabled

## Touchpad Gestures
From [gestures/libinput-gestures.conf](gestures/libinput-gestures.conf):

3‑finger swipes
- Left: Workspace next
- Right: Workspace prev
- Up: Workspace prev
- Down: Workspace next

Gesture service tips
- Start on login: this config runs `libinput-gestures-setup start` from Sway autostart.
- If you prefer session service: `libinput-gestures-setup autostart`.
- User must be in `input` group.

## Waybar
Config at [waybar/config](waybar/config) and [waybar/style.css](waybar/style.css).

Modules
- Left: Appmenu, Workspaces, Sway Mode, Media (playerctl)
- Center: Clock (with calendar on click)
- Right: Weather, Network, Bluetooth, Volume, Brightness, CPU, Memory, Disk, Battery, Power

Clicks (custom modules)
- Weather: Open wttr.in in browser
- Network: Open nm-connection-editor
- Bluetooth: Open blueman-manager
- Volume: Toggle mute (left-click), pavucontrol (right-click)
- Brightness: Scroll to adjust
- CPU/Memory: Open btop
- Power: Power menu (Rofi)

Note: Brightness device is set to `amdgpu_bl0` in the config; adjust as needed.

## Rofi Menus & Launcher
- App launcher: [rofi/launchers/type-7/launcher.sh](rofi/launchers/type-7/launcher.sh) (style-5 theme)
- Power menu: [rofi/powermenu/type-6/powermenu.sh](rofi/powermenu/type-6/powermenu.sh) (with live system stats)
- Scripts/shortcuts: [rofi/scripts/](rofi/scripts/) — launcher and powermenu type shortcuts
- Image assets used by themes are under [rofi/images/](rofi/images/)

Clipboard note
- The binding uses `rofi -dmenu` with cliphist. If you use Greenclip, change to:
	`rofi -modi "clipboard:greenclip print" -show clipboard` and install `greenclip`.

## Battery Notifications & Mako
### Mako Config
Notification daemon styling at [mako/config](mako/config):
- Default: Dark background (#1e1e2e), white text
- Critical alerts: Red background (#b71c1c), orange border, no timeout
- Font: JetBrainsMono Nerd Font, 10pt

### Battery Monitor
Script at [waybar/scripts/battery_notify.sh](waybar/scripts/battery_notify.sh):
- Monitors battery status every 60 seconds (called from Sway autostart)
- Low alert: At 30% battery capacity
- Critical alert: At 10% battery capacity
- Full charge alert: At 100% (when plugged in)
- Plays notification sounds and sends desktop alerts via Mako
- Debounce logic prevents repeat notifications until state changes

### Setup Sounds
Notification sounds are located in [assets/sounds/](assets/sounds/). To download them, use the install script or run:
```bash
mkdir -p ~/.local/share/sounds
wget -O ~/.local/share/sounds/battery-low.wav https://actions.google.com/sounds/v1/alarms/beep_short.ogg
wget -O ~/.local/share/sounds/battery-critical.wav https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg
```

## Troubleshooting
- Gestures not working: ensure `groups | grep input` shows `input`. Then `libinput-gestures-setup restart`.
- Waybar not showing data: run `waybar -l debug` to inspect. Verify executables like `brightnessctl`, `pactl` exist.
- Screenshots: ensure `grim`, `slurp`, and `wl-clipboard` are installed.
- Fonts/icons missing: verify Nerd Font is installed and selected in Kitty and Waybar icons display.

## CTF Mode
Bindings `Mod+F1` / `Mod+F2` toggle between CTF lean mode and normal desktop:
- **CTF Mode** kills Mako, WOB, cliphist, Waybar; strips gaps/borders; launches minimal Waybar; swaps Kitty → Foot terminal.
- **Normal Mode** restores all services, gaps, full Waybar, and Kitty.

See [sway/ctf-mode.sh](sway/ctf-mode.sh) and [sway/normal-mode.sh](sway/normal-mode.sh).

## Contributing / Personalization
- Tweak paths and device names in [sway/config](sway/config) and [waybar/config](waybar/config).
- Edit Rofi theme in [rofi/launchers/type-7/launcher.sh](rofi/launchers/type-7/launcher.sh).
- Adjust images in [rofi/images/](rofi/images/) or update `.rasi` files under [rofi/launchers/](rofi/launchers/).

