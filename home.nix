{ config, pkgs, caelestia-shell, ... } :

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

#home manager packages
home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    qt6.qtwayland
    libsForQt5.qtwayland
];

  #importing config files
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/kitty".source = ./config/kitty;
  home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/starship.toml".source = ./config/starship/starship.toml;
  #home.file.".config/uwsm".source = ./config/uwsm;
  #home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/zsh".source = ./config/zsh;


  #install zsh and configure
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
    eval "$(starship init zsh)"
    '';
  };
  
  services.swaync.enable = true;


  programs.starship = {
  enable = true;
};

  imports = [caelestia-shell.homeManagerModules.default];
  
  programs.caelestia = {
    enable = true;
    cli.enable = true;

  };

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
    "XDG_SESSION_TYPE,wayland"
    "WLR_NO_HARDWARE_CURSORS,1" # Fixes "invisible mouse" bug on NVIDIA
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
  ];
};

 
}

