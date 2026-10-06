{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    uwsm
    rofi
    playerctl
    wlogout
    polkit_gnome
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    eza
    spotify
    kdePackages.dolphin
    docker-compose
    bat
    (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
      background = ./wallpapers/winter-16.png;
      avatar = ./wallpapers/profile.jpeg;
    })
    freshfetch
    brightnessctl
    hyprshot
    hyprpicker
    grim
    slurp
    btop
    pwvucontrol
    networkmanagerapplet
    nwg-look
    nwg-displays
    kdePackages.qtstyleplugin-kvantum
    poweralertd
    libnotify
    jq
    python3
    cava
    libimobiledevice
  ];
}
