{ config, pkgs, ... } :

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  #importing config files
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/kitty".source = ./config/kitty;
  home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/starship".source = ./config/starship;
  home.file.".config/uwsm".source = ./config/uwsm;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/zsh".source = ./config/zsh;


  #install zsh and configure
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    initExtra = ''
    eval "$(starship init zsh)"
    '';

  };

  programs.starship = {
  enable = true;
  configFile = ./config/starship/starship.toml;
};

}

