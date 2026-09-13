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
  } @ inputs: {
    nixosConfigurations.clara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ali = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
      specialArgs = {inherit inputs;};
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
