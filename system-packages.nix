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
    rofi
    playerctl
    wlogout
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
    kdePackages.qtstyleplugin-kvantum
    poweralertd
    libnotify
    jq
    python3
    cava
    libimobiledevice
    mangohud
    # Launched from the waybar modules (see config/waybar/configs/[TOP] Everforest)
    gnome-system-monitor
    baobab
    nvtopPackages.intel
  ];
}
