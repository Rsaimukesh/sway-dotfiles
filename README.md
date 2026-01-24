# sway-config

Personal Wayland setup for Sway + Waybar with Rofi launchers/menus, Alacritty, and multi-finger touchpad gestures via libinput-gestures.

## Included
- [sway/](sway/) – Sway WM config, keybindings, autostart
- [waybar/](waybar/) – Waybar modules, styles, and scripts
- [rofi/](rofi/) – Rofi app launcher (Type-5) and menu scripts
- [alacritty/](alacritty/) – Alacritty terminal config
- [libinput-gestures.conf](libinput-gestures.conf) – Touchpad gestures mapped to Sway actions

## Requirements
Install the following packages (Debian/Ubuntu/Kali names):

```bash
sudo apt update && sudo apt install -y \
	sway swaylock waybar rofi alacritty mako-notifier \
	grim slurp wl-clipboard brightnessctl \
	libinput-gestures libinput-tools \
	thunar qalculate-gtk nm-connection-editor xfce4-power-manager
```

Notes:
- `pactl` is used for audio volume; on PipeWire install `pipewire-pulse` (or `pulseaudio-utils` for PulseAudio).
- Fonts: install a Nerd Font for icons/glyphs (e.g., JetBrainsMono Nerd Font).
- Gestures: ensure your user is in the `input` group: `sudo gpasswd -a "$USER" input` then log out/in.

## Install / Update
Copy or symlink these into `~/.config`.

### Option A: Copy
```bash
# From the repo root
cp -r sway ~/.config/
cp -r waybar ~/.config/
cp -r rofi ~/.config/
cp -r alacritty ~/.config/
cp libinput-gestures.conf ~/.config/
```

### Option B: Symlink (recommended)
```bash
# From the repo root
ln -s "$PWD/sway" ~/.config/sway
ln -s "$PWD/waybar" ~/.config/waybar
ln -s "$PWD/rofi" ~/.config/rofi
ln -s "$PWD/alacritty" ~/.config/alacritty
ln -s "$PWD/libinput-gestures.conf" ~/.config/libinput-gestures.conf
```

### Autostart & Apply
- Sway autostarts Waybar, Mako, and Gestures (see [sway/config](sway/config#L15-L23)).
- Reload Sway after changes: `swaymsg reload`.
- If needed, restart Waybar: `pkill waybar || true && waybar &`.
- Refresh gestures: `libinput-gestures-setup restart`.

## Keybindings (Super = Win key)
From [sway/config](sway/config):

Applications
- Super (release): App launcher (Rofi Type-5)
- Super + Enter: Terminal (Alacritty)
- Super + B: Browser (Firefox)
- Super + F: File manager (Thunar)
- Super + C: Clipboard menu (Rofi)
- Super + X: Power menu (Rofi)

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
- Volume: XF86Audio{Raise/Lower/MonoMute} → `pactl`
- Brightness: XF86MonBrightness{Up/Down} → `brightnessctl`
- Calculator: XF86Calculator → `qalculate-gtk`
- Lock: XF86ScreenSaver → `swaylock`

Session
- Super + Shift + R: Reload Sway
- Super + Shift + E: Exit Sway (confirmation dialog)

Touchpad
- Tap: enabled, Natural scroll: enabled, Middle emulation: enabled

## Touchpad Gestures
From [libinput-gestures.conf](libinput-gestures.conf):

3‑finger swipes
- Left: Workspace prev
- Right: Workspace next
- Up: Open Rofi (drun)
- Down: Focus parent

4‑finger swipes
- Up: Fullscreen toggle
- Down: Power menu (Rofi)

Pinch (2 fingers)
- Out: Fullscreen toggle
- In: Close focused window (kill)

Gesture service tips
- Start on login: this config runs `libinput-gestures-setup start` from Sway autostart.
- If you prefer session service: `libinput-gestures-setup autostart`.
- User must be in `input` group.

## Waybar
Config at [waybar/config](waybar/config) and [waybar/style.css](waybar/style.css).

Modules
- Left: Appmenu (opens Rofi), Workspaces
- Center: Clock (click to toggle date/time display)
- Right: Brightness, Volume, Network, CPU, Memory, Battery, Power

Clicks (custom modules)
- Brightness: opens [rofi/menus/brightness.sh](rofi/menus/brightness.sh)
- Volume: opens [rofi/menus/volume.sh](rofi/menus/volume.sh)
- Battery: opens [rofi/menus/battery.sh](rofi/menus/battery.sh)
- Power: opens [rofi/menus/power.sh](rofi/menus/power.sh)

Note: Brightness device is set to `amdgpu_bl0` in the config; adjust as needed.

## Rofi Menus & Launcher
- App launcher: [rofi/launchers/type-5/launcher.sh](rofi/launchers/type-5/launcher.sh) (theme switch via `theme` var)
- Menus: [power](rofi/menus/power.sh), [brightness](rofi/menus/brightness.sh), [volume](rofi/menus/volume.sh), [battery](rofi/menus/battery.sh)
- Image assets used by some themes are under [rofi/images/](rofi/images/)

Clipboard note
- The binding uses `rofi -show clipboard`. If you use Greenclip, change to:
	`rofi -modi "clipboard:greenclip print" -show clipboard` and install `greenclip`.

## Troubleshooting
- Gestures not working: ensure `groups | grep input` shows `input`. Then `libinput-gestures-setup restart`.
- Waybar not showing data: run `waybar -l debug` to inspect. Verify executables like `brightnessctl`, `pactl` exist.
- Screenshots: ensure `grim`, `slurp`, and `wl-clipboard` are installed.
- Fonts/icons missing: verify Nerd Font is installed and selected in Alacritty and Waybar icons display.

## Contributing / Personalization
- Tweak paths and device names in [sway/config](sway/config) and [waybar/config](waybar/config).
- Edit Rofi theme via `theme` in [rofi/launchers/type-5/launcher.sh](rofi/launchers/type-5/launcher.sh).
- Adjust images in [rofi/images/](rofi/images/) or update `.rasi` files under [rofi/launchers/type-5](rofi/launchers/type-5).

