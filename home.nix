{ config, pkgs, caelestia-shell, ... } :

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
  home.file.".config/starship.toml".source = ./config/starship/starship.toml;
  home.file.".config/uwsm".source = ./config/uwsm;
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

}

