{
	description = "Hyprland nixos";

	inputs = {
	  nixpkgs.url = "nixpkgs/nixos-unstable";
	  home-manager = {
	    url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
    
	  };
	  caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
      };
  };

	outputs = { nixpkgs, home-manager, caelestia-shell, ... }: {
	  nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
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
      extraSpecialArgs = { inherit caelestia-shell; };
	        };
	      }
	    ];
	  };
	};

}
