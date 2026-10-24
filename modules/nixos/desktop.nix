{pkgs, ...}: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # The KDE/Qt6 build and theme dependencies avoid cursor/module errors.
  services.displayManager.sddm.package = pkgs.kdePackages.sddm;
  services.displayManager.sddm.theme = "pixie";
  services.displayManager.sddm.extraPackages = with pkgs; [
    kdePackages.qt5compat
    kdePackages.qtsvg
    qt6.qtdeclarative
  ];

  fonts.packages = with pkgs; [
    lexend
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.caskaydia-cove
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  programs.gamemode.enable = true;
  programs.firefox.enable = true;
  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "rose-pine-hyprcursor";
    XCURSOR_SIZE = "24";
  };

  # The Hyprland module supplies both Hyprland and GTK portal backends.

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # HDMI screens on laptops often report a missing ELD through jack
  # detection, which makes WirePlumber mark every HDMI profile as
  # "available: no" and the sinks never show up. Disable jack detection
  # for this card so the HDMI sinks are always usable; analog stereo keeps
  # its higher priority and stays the default sink.
  services.pipewire.wireplumber.extraConfig."99-hdmi-screens" = {
    "monitor.alsa.rules" = [
      {
        matches = [{device.name = "~alsa_card.pci-0000_00_1f.3";}];
        actions.update-props = {
          "api.alsa.disable-jack-detection" = true;
        };
      }
    ];
  };

  security.pam.services.hyprlock = {};
}
