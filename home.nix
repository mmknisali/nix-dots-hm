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

  # Waybar scripts
  home.file.".local/bin/waybar-launch" = {
    source = ./config/waybar/launch.sh;
    executable = true;
  };
  home.file.".local/bin/waybar-toggle" = {
    source = ./config/waybar/toggle.sh;
    executable = true;
  };
  home.file.".local/bin/waybar-themeswitcher" = {
    source = ./config/waybar/themeswitcher.sh;
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
    alias c='clear'                                                        # clear terminal
    alias l='eza -lh --icons=auto'                                         # long list
    alias ls='eza -1 --icons=auto'                                         # short list
    alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
    alias ld='eza -lhD --icons=auto'                                       # long list dirs
    alias lt='eza --icons=auto --tree'
    alias ..='cd ..'
    alias ...='cd ../..'
    alias .3='cd ../../..'
    alias .4='cd ../../../..'
    alias .5='cd ../../../../..'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit -m'
    alias gp='git push'
    alias gl='git log --oneline -10'
    alias gd='git diff | bat'
    alias gb='git branch'
    alias gco='git checkout'
    alias gcl='git clone'
    alias gf='git fetch'
    alias gm='git merge'
    alias gr='git rebase'
    alias gst='git stash'
    alias gstp='git stash pop'
    alias cat='bat'  
    alias op='opencode'
    alias opc='opencode --continue'
    alias gstl='git stash list'
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

