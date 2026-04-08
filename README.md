# NixOS Hyprland Dotfiles

A NixOS configuration using Hyprland (Wayland) with Home Manager, featuring the caelestia-shell desktop environment.

![Hyprland](https://img.shields.io/badge/WM-Hyprland-blue)
![Shell](https://img.shields.io/badge/Shell-caelestia--shell-purple)
![Platform](https://img.shields.io/badge/Platform-NixOS-green)

## Overview

This repository contains my NixOS system configuration with:
- **Window Manager**: Hyprland (Wayland compositor)
- **Desktop Shell**: caelestia-shell (Quickshell-based)
- **Shell**: Zsh with Oh-My-Zsh via HyDE
- **Status Bar**: caelestia-shell's built-in bar (no waybar)
- **Terminal**: Kitty
- **Editor**: Neovim (LazyVim config)

## Hardware

| Component | Details |
|-----------|---------|
| CPU | Intel Whiskey Lake-U (Intel UHD Graphics 620) |
| GPU | NVIDIA GeForce MX110 (with PRIME Sync) |
| Display | Integrated + External via Intel |
| Audio | PipeWire |

## Quick Start

### Prerequisites

- NixOS with flakes enabled
- `nix-command` and `flakes` experimental features

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Update flake inputs:
```bash
nix flake update
```

3. Rebuild the system:
```bash
sudo nixos-rebuild switch --flake .#clara
```

4. Reboot

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
    │   ├── layouts/      # Lock screen layouts
    │   ├── colors.conf   # Color definitions
    │   └── scripts/      # Widget scripts
    ├── kitty/            # Terminal emulator
    ├── nvim/             # Neovim (LazyVim)
    ├── rofi/             # Application launcher
    ├── starship/         # Shell prompt
    ├── waybar/           # Status bar
    └── zsh/              # Zsh configuration
        ├── .zshrc        # Main zshrc (loads hyde)
        ├── .zshenv       # Environment variables
        └── user.zsh      # User customizations
```

## Features

### SDDM Login Screen

- **Theme**: pixie-sddm (Google Pixel UI inspired)
- **Qt6**: Modern Qt6 support
- **Wallpaper**: Dynamic backgrounds from wallpapers folder

### Hyprlock Screen Locker

- **Theme**: Hyprlock-Dots (Layout 1)
- **Widgets**: Time, date, battery indicator
- **Wallpaper**: Uses system wallpaper with blur effects

### NVIDIA GPU Support

- PRIME Sync mode (NVIDIA dGPU + Intel iGPU)
- Proprietary NVIDIA drivers
- Full Wayland support with GBM backend
- Kernel mode setting enabled

### SDDM

- **Display Manager**: SDDM with Wayland support
- **Theme**: pixie-sddm (Material Design 3 inspired)
- **Auto-login**: Disabled (password required)

### Hyprland

- XWayland enabled for X11 apps
- Custom keybindings (see `config/hypr/keybindings.conf`)
- Window rules for common apps
- Multi-monitor support

### Caelestia-Shell

The desktop shell provides:
- **Bar**: Built-in Quickshell-based status bar
- **Launcher**: Application launcher (Super+A)
- **Dashboard**: System overview (Super+D)
- **Notifications**: Integrated notification center
- **Wallpaper Switcher**: Via launcher
- **Idle Management**: Lock/suspend/hibernate timeouts

### Shell (Zsh)

- Starship prompt
- Oh-My-Zsh via HyDE
- Zsh syntax highlighting
- Zsh autosuggestions
- FZF integration

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
| `Super + B` | Browser (Firefox) |
| `Super + A` | Launcher (Rofi) |
| `Super + Tab` | Window switcher (Rofi) |
| `Super + M` | Music player |
| `Super + L` | Lock screen (hyprlock) |

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

### Caelestia-Shell Shortcuts

| Key | Action |
|-----|--------|
| `Super + D` | Open dashboard |
| `Super + A` | Open launcher |
| `Super + N` | Open notifications |

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
- `uwsm` - Window stack manager (installed but not used)
- `rofi` - Application launcher
- `swaynotificationcenter` - Notification daemon
- `playerctl` - Media player control
- `wlogout` - Logout screen
- `blueman` - Bluetooth manager
- `tailscale` - VPN client
- `firefox` - Web browser
- `sddm` - Simple Desktop Display Manager
- `hyprlock` - Screen locker

### Home Manager Packages

- `xdg-desktop-portal-hyprland` - XDG portal for Hyprland
- `qt6.qtwayland` - Qt6 Wayland support
- `libsForQt5.qtwayland` - Qt5 Wayland support

## Environment Variables

Key environment variables set:

| Variable | Value | Purpose |
|----------|-------|---------|
| `NIXOS_OZONE_WL` | `1` | Enable Wayland in Electron apps |
| `GBM_BACKEND` | `nvidia-drm` | NVIDIA GBM backend |
| `__GLX_VENDOR_LIBRARY_NAME` | `nvidia` | Use NVIDIA GLX |
| `LIBVA_DRIVER_NAME` | `nvidia` | NVIDIA VA-API |
| `XDG_SESSION_TYPE` | `wayland` | Wayland session |

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

### Caelestia-Shell Not Starting

1. Check if caelestia is installed:
```bash
which caelestia
```

2. Check Hyprland logs:
```bash
tail -f ~/.hyprland.log
```

3. Try starting manually:
```bash
caelestia shell -d
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
- [NixOS](https://nixos.org) - Operating system
