{ config, pkgs, ... } :

{
  home.username = "ali";
  home.homeDirectory = "/home/ali";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
}

