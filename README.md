# sway-dotfiles

Personal Wayland desktop configuration — Sway, Waybar, Rofi, Kitty, Mako, WOB.

## Overview

| Component | Role | Config |
|-----------|------|--------|
| **Sway** | Tiling Wayland compositor | [`sway/config`](sway/config) |
| **Waybar** | Status bar | [`waybar/config`](waybar/config) · [`waybar/style.css`](waybar/style.css) |
| **Rofi** | App launcher + powermenu | [`rofi/launchers/type-7/`](rofi/launchers/type-7/) · [`rofi/powermenu/type-6/`](rofi/powermenu/type-6/) |
| **Kitty** | GPU-accelerated terminal | [`kitty/kitty.conf`](kitty/kitty.conf) |
| **Mako** | Notification daemon | [`mako/config`](mako/config) |
| **WOB** | Volume/brightness overlay | [`wob/wob.ini`](wob/wob.ini) |
| **libinput-gestures** | Touchpad gestures | [`gestures/libinput-gestures.conf`](gestures/libinput-gestures.conf) |

## Quick Start

```bash
# Full automated setup (deps, fonts, wallpaper, configs)
bash setup.sh

# Or just link configs (if deps already installed)
bash install.sh
```

### Manual

```bash
for dir in sway waybar rofi kitty mako wob; do
  ln -sf "$PWD/$dir" ~/.config/"$dir"
done
ln -sf "$PWD/gestures/libinput-gestures.conf" ~/.config/
mkdir -p ~/.local/bin
cp waybar/scripts/battery_notify.sh ~/.local/bin/
```

Then reload: `swaymsg reload`

## Keybindings

`Super` = Windows key

### Applications

| Key | Action |
|-----|--------|
| Super (release) | App launcher |
| Super + Enter | Terminal (Kitty) |
| Super + B | Browser (Firefox) |
| Super + F | File manager (Thunar) |
| Super + C | Clipboard history |
| Super + X | Power menu |
| Super + L | Lock screen |

### Windows

| Key | Action |
|-----|--------|
| Super + Arrows | Focus |
| Super + Shift + Arrows | Move |
| Super + Q | Kill |
| Super + Space | Toggle float |
| Super + Shift + F | Fullscreen |
| Super + H / V | Split horizontal / vertical |
| Super + S / W / E | Layout: stack / tabbed / toggle |

### Workspaces

| Key | Action |
|-----|--------|
| Super + 1–0 | Switch |
| Super + Shift + 1–0 | Move container |
| Super + Ctrl + ←/→ | Prev / Next |
| Super + KP_1–0 | Numpad switch |
| Super + Shift + KP_1–0 | Numpad move |

### Screenshots

| Key | Action |
|-----|--------|
| Print | Full screen → file |
| Super + Shift + S | Select area → file |
| Super + Ctrl + S | Select area → clipboard |

### Media & Hardware

| Key | Action |
|-----|--------|
| XF86Audio Raise/Lower/Mute | Volume ±5% / toggle |
| XF86AudioMicMute | Mic mute toggle |
| XF86Audio Play/Pause/Next/Prev | Playerctl |
| XF86MonBrightness Up/Down | Brightness ±10% |

### CTF Mode

| Key | Action |
|-----|--------|
| Super + F1 | CTF lean mode (minimal services, foot terminal) |
| Super + F2 | Restore normal mode |

## Waybar

Modules: **Left:** App menu · Workspaces · Sway mode · Now playing  
**Center:** Clock (with calendar)  
**Right:** Weather · Network · Bluetooth · Volume · Brightness · CPU · Memory · Disk · Battery · Power

Click actions: Weather → wttr.in, Network → nm-connection-editor, Bluetooth → blueman-manager, Volume → toggle mute / pavucontrol, CPU/Memory → btop, Power → Rofi powermenu.

Brightness auto-detects the backlight device. No manual configuration needed.

## Touchpad Gestures

| Gesture | Action |
|---------|--------|
| 3-finger swipe left | Workspace next |
| 3-finger swipe right | Workspace prev |
| 3-finger swipe up | Workspace prev |
| 3-finger swipe down | Workspace next |

Requires `input` group: `sudo gpasswd -a "$USER" input` then log out/in.

## Battery Monitor

Script at [`waybar/scripts/battery_notify.sh`](waybar/scripts/battery_notify.sh):
- Polls every 60s, runs via Sway autostart
- **Low:** 30% → `notify-send` + sound
- **Critical:** 10% → urgent notification + sound
- **Full:** 100% when charging → notification
- Debounced — won't repeat until state changes

Notification sounds in [`assets/sounds/`](assets/sounds/).

## Rofi

- **App launcher:** [`rofi/launchers/type-7/`](rofi/launchers/type-7/) — style-5 theme
- **Power menu:** [`rofi/powermenu/type-6/`](rofi/powermenu/type-6/) — live CPU/RAM/temp/battery stats
- **Color themes:** [`rofi/colors/`](rofi/colors/) — 16 presets (catppuccin, dracula, nord, etc.)
- **Images:** [`rofi/images/`](rofi/images/) — used by launcher themes
- **Clipboard:** Uses `cliphist` + `rofi -dmenu`. For Greenclip replace with: `rofi -modi "clipboard:greenclip print" -show clipboard`

## Dependencies

Debian/Ubuntu/Kali: `sway swaylock waybar rofi kitty mako-notifier grim slurp wl-clipboard brightnessctl playerctl foot blueman pavucontrol libinput-gestures libinput-tools thunar curl wget unzip`

See [`dependencies.txt`](dependencies.txt).

## Troubleshooting

- **Gestures:** `groups | grep input` shows `input`? Run `libinput-gestures-setup restart`.
- **Waybar:** Run `waybar -l debug` to inspect. Check `brightnessctl`, `pactl` exist.
- **Screenshots:** Install `grim`, `slurp`, `wl-clipboard`.
- **Icons:** Install a Nerd Font (JetBrainsMono Nerd Font recommended).
- **Audio:** `pactl` requires `pipewire-pulse` or `pulseaudio-utils`.
