{
  description = "Hyprland nixos";

  inputs = {
    #devenv.url = "github:cachix/devenv";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim.url = "github:pfassina/lazyvim-nix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pixie-sddm = {
      url = "github:xCaptaiN09/pixie-sddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    rose-pine-hyprcursor,
    pixie-sddm,
    lazyvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "ali";
    hostName = "Clara";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.clara = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs username;};
          };
        }
      ];
      specialArgs = {inherit inputs username hostName;};
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    checks.${system} = {
      formatting = pkgs.runCommand "check-nix-formatting" {} ''
        ${pkgs.alejandra}/bin/alejandra --check \
          ${./configuration.nix} \
          ${./flake.nix} \
          ${./home.nix} \
          ${./system-packages.nix}
        touch "$out"
      '';

      shell-syntax = pkgs.runCommand "check-shell-syntax" {} ''
        ${pkgs.bash}/bin/bash -n \
          ${./config/hypr/scripts/MoveWindow.sh} \
          ${./config/hypr/scripts/SwitchKeyboardLayout.sh} \
          ${./config/hypr/UserScripts/WallpaperRandom.sh} \
          ${./config/hypr/UserScripts/WallpaperSelect.sh} \
          ${./scripts/cliphist.sh}
        ${pkgs.zsh}/bin/zsh -n \
          ${./scripts/zen-fast} \
          ${./scripts/zen-launch} \
          ${./scripts/zen-warmup}
        touch "$out"
      '';
    };
  };
}
