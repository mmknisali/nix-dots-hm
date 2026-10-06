# nix-dots-hm

NixOS and Home Manager configuration for the `clara` Hyprland workstation.

## What Is Managed

- NixOS system, users, networking, audio, Bluetooth, Docker, and Tailscale
- Home Manager services for Waybar, Hypridle, Cliphist, SwayNC, and Hyprpaper
- Hyprland, Waybar, Rofi, Kitty, Zsh, and related desktop configuration
- LazyVim and Zen Browser through flake inputs

## Repository Layout

- `flake.nix`: inputs, host definition, shared host/user values, and checks
- `configuration.nix`: NixOS services and host policy
- `system-packages.nix`: explicitly installed system packages
- `home.nix`: Home Manager programs, services, and dotfile links
- `config/`: application configuration and desktop scripts
- `wallpapers/`: SDDM and desktop assets

## Installation

The machine-specific `hardware-configuration.nix` is intentionally ignored. Generate it locally after cloning:

```bash
git clone https://github.com/mmknisali/nix-dots-hm.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

The configuration currently targets user `ali`, host `Clara`, and `x86_64-linux`. Review those values in `flake.nix`, then evaluate before activating:

```bash
nix flake check --no-build "path:."
nix build --dry-run "path:.#nixosConfigurations.clara.config.system.build.toplevel"
```

When the evaluation is clean, apply the configuration:

```bash
sudo nixos-rebuild switch --flake "path:.#clara"
sudo passwd ali
```

Use the `path:.` form because the ignored hardware configuration must be included in the flake source. The password is deliberately not stored in this repository.

## Maintenance

Format and validate changes with:

```bash
nix run "path:.#formatter.x86_64-linux" -- configuration.nix flake.nix home.nix system-packages.nix
nix flake check --no-build "path:."
nix build "path:.#checks.x86_64-linux.formatting"
nix build "path:.#checks.x86_64-linux.shell-syntax"
nix build --dry-run "path:.#nixosConfigurations.clara.config.system.build.toplevel"
```

DNSCrypt is configured but disabled by default. SSH is also disabled by default.
