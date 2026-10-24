# Hyprland NixOS Dotfiles

NixOS and Home Manager configuration for user `ali`, host `Clara`, on
`x86_64-linux`. These values live in `flake.nix`.

## Active Configuration

| Path | Purpose |
| --- | --- |
| `configuration.nix` | Host composition, user/password policy, locale, Nix maintenance |
| `modules/nixos/hardware.nix` | Boot, Intel graphics, Bluetooth, input devices, zram |
| `modules/nixos/desktop.nix` | Hyprland/UWSM, SDDM, fonts, portals, audio |
| `modules/nixos/services.nix` | Networking, power, Docker, printing, TRIM |
| `home.nix` | User programs, desktop services, immutable dotfile links |
| `modules/home/waybar.nix` | Declarative Waybar layout/style selection |
| `config/hypr/hyprland.lua` | Lua entry point and sibling configuration modules |
| `config/kitty/hyde.conf` | Kitty settings; background opacity `0.75`, opaque text |
| `config/waybar/config`, `style.css` | Default bar layout and stylesheet |
| `config/rofi/config.rasi` | Loads `themes/KooL_style-16-Modern.rasi` |

Hyprland 0.56 uses Lua 5.5. The `hl` API is supplied by Hyprland; syntax and
lint checks cannot prove that every runtime API call works.

LazyVim is managed by `programs.lazyvim`, not `config/nvim/`. The tracked
`config/nvim/` starter and `config/opencode/` are not deployed. Alternative
Waybar layouts/styles and Rofi themes are retained as optional presets, not
independent active configurations. They are still syntax-checked. The files
under `wallust/` are fixed palettes; no Wallust generation is configured.

## Desktop Behavior

- `SUPER + T`: normal Kitty in the current workspace.
- `SUPER + /`: searchable cheat sheet built from live bind descriptions.
- `SUPER + backslash`: toggle `special:terminal`, launching `kitty --class kitty-scratch` when needed.
- `SUPER + M`: show the Spotify scratchpad; `SUPER + S` toggles it.
- Plain F10/F11/F12 reach applications. Audio uses XF86Audio keys and is capped at 100%.
- `SUPER + Delete` and `CTRL + ALT + Delete` open the logout menu, rather than immediately exiting.
- Move/resize uses `SUPER + left/right mouse button`; SUPER+Z/X are unbound.

The optional Waybar module named `custom/hint` also opens the cheat sheet.
There is no module literally named `custom/keybinds`.

The scratchpad terminal has its own class so normal Kitty launches are not
silently sent to a hidden special workspace. Kitty background transparency is
controlled only by Kitty, not a compositor opacity rule that would fade text.

## Session Services

Choose the **Hyprland (UWSM-managed)** SDDM session. `withUWSM = true` enables
the session manager; its readiness handling starts `graphical-session.target`.
Waybar, Hyprpaper, SwayNC, Cliphist, the polkit agent, and Hypridle are managed
as user services. Hyprland's normal systemd environment export is sufficient
with the pinned UWSM version; no duplicate D-Bus import command is added.

Hypridle dims after 4 minutes, locks after 5 minutes, and powers the displays
off after 5.5 minutes. Input restores brightness/displays. Idle inhibition is
honored; the optional `custom/hypridle` control can stop/start the service.
UPower is enabled for `poweralertd`.

Home Manager's reload helper discovers instances under the activating user's
runtime directory, even without `HYPRLAND_INSTANCE_SIGNATURE`, and reloads
each using `hyprctl -i`. It checks IPC responses and configuration errors,
reports failures, skips non-graphical sessions, and does not run in dry-run
activation. A full reset handles migration from the old hyprlang parser.
It does not delete arbitrary generated or user configuration files.

## Declarative Appearance

Home Manager owns Waybar and Rofi configuration. Do not copy over their store
links. To select a different Waybar preset, add to `home.nix`:

```nix
dotfiles.waybar = {
  layout = ./config/waybar/configs/"[TOP] Default";
  style = ./config/waybar/style/"[Catppuccin] Mocha.css";
};
```

Rebuild, then restart `waybar.service` if necessary. The service receives the
chosen paths explicitly and tracks them as restart triggers. `WaybarLayout.sh`
explains these options; `WaybarStyles.sh` only restarts Waybar and does not
pretend to select a style.

If an older chooser already replaced a managed file with a real file and left
a `.backup`, archive those copies deliberately before activation. This setup
does not delete or overwrite existing user backups to force a rebuild through.

Rofi's `@theme` line selects its theme declaratively. Its search settings use
fuzzy matching and `fzf` ranking, the sorter supported by the pinned Rofi 2.0.
The newer `fzf-v2` sorter prevents Rofi 2.0 from starting. The footer uses a
separate, non-expanding `textbox-footer` so errors remain readable and the
results list keeps its full height. `ChangeBlur.sh` uses a single Lua `eval` to read
and toggle blur, rather than assuming a version-specific JSON field. In
Hyprland's Lua IPC, `dispatch 'hl.dsp.…'` invokes a dispatcher and `eval` runs
ordinary Lua; both forms are valid for their respective operations.

## Installation

Review all host-specific settings before activating. Generate the ignored
hardware configuration on the target machine:

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

Use `path:.` so this ignored hardware file is included. Git flakes include
tracked working-tree changes but exclude untracked and ignored files; a
commit is not required merely to test tracked edits. No helper can bypass
that source selection with `builtins.path` inside a Git flake.

### Password Hash

`users.users.ali.hashedPasswordFile` is the runtime string
`/etc/nixos-secrets/ali-hash`. No password file is read during evaluation or
copied into the Nix store. Provision it **before a fresh installation**:

```bash
sudo install -d -m 0700 /etc/nixos-secrets
sudo install -o root -g root -m 0600 /dev/null /etc/nixos-secrets/ali-hash
nix run nixpkgs#mkpasswd -- -m yescrypt | sudo tee /etc/nixos-secrets/ali-hash >/dev/null
```

To migrate an existing local hash without changing the password, use
`sudo install -o root -g root -m 0600 "$HOME/.config/nixos/password-hash" /etc/nixos-secrets/ali-hash`
after creating the directory. Change the username/path together when adapting
the host. Existing mutable users normally retain their current password;
fresh accounts need a provisioned hash or a password set during installation.
There is no blanket guarantee against lockout when a password file is absent.

### Validate and Activate

```bash
nix flake check --print-build-logs "path:."
nix build --no-link "path:.#nixosConfigurations.clara.config.system.build.toplevel"
sudo nixos-rebuild switch --flake "path:.#clara"
```

`UpdateFlake.sh` and `Distro_update.sh` use `DOTS_DIR`, defaulting to
`~/.dotfiles`. The scheduled lock-update workflow checks updates before
opening a PR; repository settings must permit Actions to create PRs. It does
not auto-merge them.

## Checks

CI runs `nix flake check "path:."`, which **builds every check**. By contrast,
`--no-build` only evaluates derivations and is not a validation run.

| Check | Scope |
| --- | --- |
| `formatting` | Alejandra on host, home, flake, package list, and modules |
| `statix` | Nix lint; repeated dotted module keys intentionally allowed |
| `deadnix` | Unused Nix bindings |
| `shell-syntax` | Each Bash/Zsh script separately, Python compilation and mocked helper tests |
| `shellcheck` | All Bash desktop scripts; Zsh scripts use Zsh syntax validation |
| `lua-syntax` | Lua 5.5 parser on Hyprland modules |
| `luacheck` | Static Lua analysis with Hyprland's injected `hl` global |
| `waybar-json` | JSONC configuration syntax |
| `rofi-rasi` | Rofi parser/type diagnostics plus regression checks for the supported sorter and footer layout, without requiring a live display |

Validate the running session after activation:

```bash
hyprctl configerrors
systemctl --user status graphical-session.target polkit-gnome.service hypridle.service
```

Docker remains rootful and requires `sudo` for this user. Membership in the
`docker` group grants root-equivalent access; no such membership is added
implicitly. Rootless Docker is a separate migration because existing rootful
containers and volumes are not automatically migrated.

## Licensing

The root `LICENSE` contains GPL version 3 for identified GPL-derived desktop
material. MIT and Apache-2.0 components retain their own terms and notices.
See `THIRD_PARTY_NOTICES.md` and `licenses/` for upstream attribution, full
MIT notices, and unresolved historical/asset provenance. This is not a blanket
claim of ownership or permission for files of unknown origin.
