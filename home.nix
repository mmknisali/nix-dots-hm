{ inputs, config, pkgs, ... }:

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "25.05";

home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    qt6.qtwayland
    libsForQt5.qtwayland
];

  #importing config files
  home.file.".config/hypr" = {
    source = ./config/hypr;
    recursive = true;
  };
  home.file.".config/kitty" = {
    source = ./config/kitty;
    recursive = true;
  };
  #home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/starship.toml".source = ./config/starship/starship.toml;
  #home.file.".config/uwsm".source = ./config/uwsm;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/zsh".source = ./config/zsh;
  home.file.".config/hyprlock" = {
    source = ./config/hyprlock;
    recursive = true;
  };

  home.file.".config/opencode/opencode.json".source = ./config/opencode/opencode.json;
  home.file.".config/opencode/oh-my-openagent.json".source = ./config/opencode/oh-my-openagent.json;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${config.home.homeDirectory}/Pictures/wallpapers/winter-16.png" ];
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/Pictures/wallpapers/winter-16.png";
          fit_mode = "cover";
        }
        {
          monitor = "HDMI-A-1";
          path = "${config.home.homeDirectory}/Pictures/wallpapers/winter-16.png";
          fit_mode = "cover";
        }
      ];
    };
  };

  # Hyprlock - screen locker (package only, config via file above)
  programs.hyprlock = {
    enable = true;
  };

  home.file.".local/bin/zen-twilight" = {
    source = ./scripts/zen-fast;
    executable = true;
  };

  home.file."Pictures/wallpapers/winter-16.png".source = ./wallpapers/winter-16.png;
  home.file."Pictures/wallpapers/profile.jpeg".source = ./wallpapers/profile.jpeg;

  home.file.".local/bin/zen-warmup" = {
    source = ./scripts/zen-warmup;
    executable = true;
  };

  home.file.".local/bin/zen-launch" = {
    source = ./scripts/zen-launch;
    executable = true;
  };

  home.file.".local/bin/cliphist" = {
    source = ./scripts/cliphist.sh;
    executable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      export ZDOTDIR="$HOME/.config/zsh"
      source "$ZDOTDIR/.zshrc"
    '';
  };
  
  services.swaync.enable = true;

  programs.direnv.enable = true;

  programs.starship = {
    enable = true;
  };

  imports = [ inputs.lazyvim.homeManagerModules.default ];
  programs.lazyvim.enable = true;


  wayland.windowManager.hyprland.settings = {
    env = [
      #"WLR_NO_HARDWARE_CURSORS,1" # Fixes "invisible mouse" bug on NVIDIA
    ];
  };
}

