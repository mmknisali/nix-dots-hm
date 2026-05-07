{ config, pkgs, ... } :

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "25.05";

#home manager packages
home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    qt6.qtwayland
    libsForQt5.qtwayland
    brightnessctl
    hyprshot
    hyprpicker
    grim
    slurp
    btop
];

  #importing config files
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/kitty".source = ./config/kitty;
  home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/starship.toml".source = ./config/starship/starship.toml;
  #home.file.".config/uwsm".source = ./config/uwsm;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/zsh".source = ./config/zsh;
  home.file.".config/hyprlock" = {
    source = ./config/hyprlock;
    recursive = true;
  };

  # Hyprpaper - wallpaper daemon
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/ali/Pictures/wallpapers/winter-16.png" ];
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "/home/ali/Pictures/wallpapers/winter-16.png";
          fit_mode = "cover";
        }
        {
          monitor = "HDMI-A-1";
          path = "/home/ali/Pictures/wallpapers/winter-16.png";
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

  home.file = {
    "Pictures/wallpapers/winter-16.png".source = ./wallpapers/winter-16.png;
    "Pictures/wallpapers/profile.jpeg".source = ./wallpapers/profile.jpeg;
  };

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
    eval "$(starship init zsh)"
    eval "$(direnv hook zsh)"
    # Aliases are defined in ~/.config/zsh/.zshrc
    freshfetch
  '';
  };
  
  services.swaync.enable = true;


  programs.starship = {
  enable = true;
};

  # imports = [caelestia-shell.homeManagerModules.default];
  
  # programs.caelestia = {
  #   enable = true;
  #   cli.enable = true;
  # };

  wayland.windowManager.hyprland.settings = {
   decoration = {
    blur = {
      enabled = true;
      size = 3;
      passes = 1;
      };
  };
  env = [
    "LIBVA_DRIVER_NAME,nvidia"
    "WLR_NO_HARDWARE_CURSORS,1" # Fixes "invisible mouse" bug on NVIDIA
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
  ];
};

 
}

