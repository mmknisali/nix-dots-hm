# NixOS Hyprland Dotfiles

A NixOS configuration using Hyprland (Wayland) with Home Manager.

![Hyprland](https://img.shields.io/badge/WM-Hyprland-blue)
![Platform](https://img.shields.io/badge/Platform-NixOS-green)

## Overview

This repository contains my NixOS system configuration with:
- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: waybar
- **Shell**: Zsh with HyDE
- **Terminal**: Kitty
- **Editor**: Neovim (LazyVim config)
- **Browser**: Zen Browser (twilight)
- **Login**: SDDM with pixie-sddm theme
- **Lock Screen**: Hyprlock-Dots (Layout 1)

## Hardware

| Component | Details |
|-----------|---------|
| CPU | Intel Whiskey Lake-U (Intel UHD Graphics 620) |
| GPU | Intel UHD Graphics 620 (NVIDIA MX110 present but **disabled** in config) |
| Display | Integrated + External via Intel |
| Audio | PipeWire |

## Quick Start

### Prerequisites

- NixOS with flakes enabled
- `nix-command` and `flakes` experimental features

### Installation

1. Clone this repository:
```bash
git clone https://github.com/mmknisali/nix-dots-hm.git ~/.dotfiles
cd ~/.dotfiles
```

2. Update flake inputs:
```bash
nix flake update
```

3. (First-time only) Generate the host-specific hardware config:
```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```
This file is gitignored on purpose and must exist on the target machine for the build to succeed.

4. Rebuild the system:
```bash
sudo nixos-rebuild switch --flake .#clara
```

5. Reboot

### Post-Installation

The system is configured with:
- **Login**: SDDM with pixie-sddm theme (graphical login)
- **Auto-start Hyprland**: Launches automatically via SDDM
- **Lock Screen**: Hyprlock-Dots (Layout 1)

## Configuration Structure

```
.
├── configuration.nix     # NixOS system configuration
├── home.nix              # Home Manager user configuration
├── flake.nix             # Nix flake definition
├── hardware-configuration.nix  # Hardware-specific NixOS config
├── wallpapers/           # Wallpaper images
└── config/               # User configuration files
    ├── hypr/             # Hyprland window manager
    │   ├── hyprland.conf # Main config (sources other files)
    │   ├── keybindings.conf
    │   ├── monitors.conf
    │   ├── userprefs.conf
    │   └── windowrules.conf
    ├── hyprlock/         # Hyprlock screen locker (Hyprlock-Dots)
    │   ├── hyprlock.conf   # Main config (loads layout)
    │   ├── layouts/      # Lock screen layouts
    │   │   └── layout1.conf
    │   ├── colors.conf   # Color definitions
    │   └── scripts/      # Widget scripts
    ├── kitty/            # Terminal emulator
    ├── nvim/             # Neovim config (optional; Neovim is managed via the LazyVim Home Manager module)
    ├── rofi/             # Application launcher
    ├── starship/         # Shell prompt
    ├── waybar/           # Status bar
    └── zsh/              # Zsh configuration (HyDE-compatible, but HyDE itself is not installed via this flake)
        ├── .zshrc        # Main zshrc
        ├── .zshenv       # Environment variables
        └── user.zsh      # User customizations
```

## Features

### SDDM Login Screen

- **Theme**: pixie-sddm (Google Pixel UI inspired)
- **Qt6**: Modern Qt6 support
- **Wayland**: Enabled for native Wayland sessions
- **Auto-login**: Disabled (password required)

### Hyprlock Screen Locker

- **Theme**: Hyprlock-Dots (Layout 1)
- **Widgets**: Time, date, battery indicator
- **Wallpaper**: Uses system wallpaper with blur effects

### NVIDIA GPU Support

- NVIDIA is currently **disabled** in `configuration.nix` (the `hardware.nvidia` block is commented out).
- The system runs on the Intel Whiskey Lake-U iGPU (UHD Graphics 620) with the open `modesetting`/i915 driver.
- To re-enable NVIDIA, uncomment the `hardware.nvidia` block and adjust the bus IDs to your hardware, then rebuild.

### Hyprland

- XWayland enabled for X11 apps
- Custom keybindings (see `config/hypr/keybindings.conf`)
- Window rules for common apps
- Multi-monitor support
- Blur effects enabled

### Shell (Zsh)

- Starship prompt
- Oh-My-Zsh via HyDE
- Zsh syntax highlighting
- Zsh autosuggestions
- direnv integration

### Waybar Style Reload

The Waybar configuration ships multiple style presets under `config/waybar/style/` and `config/waybar/configs/`.

- **Keybinding**: `Super + Ctrl + T` (or `Right Alt + Right Ctrl`) - Restart Waybar so style/config changes are reloaded.
- Style selection scripts live in `config/hypr/scripts/` (e.g. `WaybarStyles.sh`, `WaybarLayout.sh`).

Switch the active preset by editing the style symlink/config and pressing the reload keybinding.

## Keybindings

### Main Modifiers

- `$mainMod` = Super (Windows key)
- `$mainMod Shift` = Super + Shift

### Window Management

| Key | Action |
|-----|--------|
| `Super + Q` | Close active window |
| `Super + F` | Toggle fullscreen |
| `Super + Space` | Toggle floating |
| `Super + J` | Split horizontal |
| `Super + V` | Split vertical |
| `Super + Arrow` | Move window |

### Applications

| Key | Action |
|-----|--------|
| `Super + T` | Terminal (Kitty) |
| `Super + B` | Browser (Zen Browser) |
| `Backslash` | Toggle terminal special workspace |
| `Super + A` | Launcher (Rofi) |
| `Super + Tab` | Window switcher (Rofi) |
| `Super + M` | Music player |
| `Super + L` | Lock screen (Hyprlock-Dots) |
| `Super + Ctrl + T` | Reload Waybar styles |

### Media Keys

| Key | Action |
|-----|--------|
| `F10` / `XF86AudioMute` | Toggle mute |
| `F11` / `XF86AudioLowerVolume` | Volume down |
| `F12` / `XF86AudioRaiseVolume` | Volume up |
| `F9` / `XF86AudioPlay` | Play/Pause |
| `F5` / `XF86AudioNext` | Next track |
| `F4` / `XF86AudioPrev` | Previous track |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

## Packages

### System Packages

- `vim` - Text editor
- `wget` - Download utility
- `git` - Version control
- `hyprpaper` - Wallpaper daemon
- `waybar` - Status bar
- `neovim` - Text editor
- `kitty` - Terminal emulator
- `starship` - Shell prompt
- `uwsm` - Window stack manager
- `rofi` - Application launcher
- `swaynotificationcenter` - Notification daemon
- `playerctl` - Media player control
- `wlogout` - Logout screen
- `blueman` - Bluetooth manager
- `tailscale` - VPN client
- `polkit-gnome` - Authentication agent
- `cliphist` - Clipboard manager
- `wl-clipboard` - Wayland clipboard
- `direnv` - Environment variable manager
- `eza` - Modern ls replacement
- `hyprlock` - Screen locker
- `sddm` - Simple Desktop Display Manager
- `zen-browser` - Web browser (twilight edition)

### Home Manager Packages

- `xdg-desktop-portal-hyprland` - XDG portal for Hyprland
- `qt6.qtwayland` - Qt6 Wayland support
- `libsForQt5.qtwayland` - Qt5 Wayland support

## Environment Variables

Key environment variables set (in `configuration.nix` → `environment.sessionVariables`):

| Variable | Value | Purpose |
|----------|-------|---------|
| `NIXOS_OZONE_WL` | `1` | Enable Wayland in Electron apps |
| `HYPRCURSOR_THEME` | `rose-pine-hyprcursor` | Cursor theme for Hyprland |
| `HYPRCURSOR_SIZE` | `24` | Cursor size for Hyprland |
| `XCURSOR_THEME` | `rose-pine-hyprcursor` | Cursor theme for XWayland/Qt |
| `XCURSOR_SIZE` | `24` | Cursor size for XWayland/Qt |

> Mangohud/gamemode are **not** enabled globally (they were removed to avoid wrapping every GUI app). Enable them per-game via `gamemoderun`/mangohud launchers instead.

## Troubleshooting

### GPU Issues

If NVIDIA GPU is not working:

1. Check PRIME status:
```bash
nvidia-smi
```

2. Verify bus IDs match your hardware (modify in `configuration.nix`):
```bash
lspci -D -d ::03xx
```

3. Check NVIDIA kernel modules:
```bash
lsmod | grep nvidia
```

### Audio Issues

1. Check PipeWire status:
```bash
pw-cli list objects | grep -i audio
```

2. Set default sink:
```bash
wpctl set-default @DEFAULT_AUDIO_SINK@
```

### Screen Tearing

If you experience screen tearing:

1. Enable PRIME Sync (already enabled in config)
2. Or force full composition pipeline:
```nix
hardware.nvidia.forceFullCompositionPipeline = true;
```

Add to `configuration.nix` and rebuild.

### Hyprlock Not Working

1. Check hyprlock config:
```bash
cat ~/.config/hyprlock/hyprlock.conf
```

2. Test hyprlock:
```bash
hyprlock
```

3. Check logs:
```bash
tail -f ~/.hyprlock.log
```

## Maintenance

### Update System

```bash
# Update flake inputs
nix flake update

# Rebuild
sudo nixos-rebuild switch --flake .#clara
```

### Update Home Manager

```bash
home-manager switch
```

### Backup Configuration

The system backs up original files with `.backup` extension before overwriting.

## Contributing

This is a personal dotfiles repository. Feel free to:
- Fork and adapt for your own use
- Suggest improvements via issues
- Ask questions via discussions

## Credits

- [Hyprland](https://hyprland.org) - Window manager
- [pixie-sddm](https://github.com/xCaptaiN09/pixie-sddm) - SDDM theme
- [Hyprlock-Dots](https://github.com/mahaveergurjar/Hyprlock-Dots) - Hyprlock configuration
- [LazyVim](https://www.lazyvim.org) - Neovim configuration
- [NixOS](https://nixos.org) - Operating system
