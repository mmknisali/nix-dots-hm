{
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    # Host-specific and gitignored; generate on the target machine.
    ./hardware-configuration.nix
    ./system-packages.nix
    ./modules/nixos/hardware.nix
    ./modules/nixos/desktop.nix
    ./modules/nixos/services.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # This is a runtime string, not a Nix path: the hash is never read into the
  # store or inspected during flake evaluation. Provision it as root, mode 0600.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    hashedPasswordFile = "/etc/nixos-secrets/${username}-hash";
    extraGroups = ["dialout" "networkmanager" "wheel"];
    packages = [];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Spotify is the only explicitly allowed unfree package.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) ["spotify"];

  # First installed NixOS release; independent of Home Manager's stateVersion.
  system.stateVersion = "25.11";
}
