{
	description = "Hyprland nixos";

  inputs.devenv.url = "github:cachix/devenv/9e5c17caf0ead1bb29d430d4c0a26a77bc5d374b";
  
	inputs = {
	  nixpkgs.url = "nixpkgs/nixos-unstable";
	  home-manager = {
	    url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
	  };
	  zen-browser = {
	    url = "github:tstachl/zen-browser-flake";
	    inputs.nixpkgs.follows = "nixpkgs";
	    inputs.home-manager.follows = "home-manager";
	  };
	  rose-pine-hyprcursor = {
	    url = "github:ndom91/rose-pine-hyprcursor";
	    inputs.nixpkgs.follows = "nixpkgs";
	  };
	};

	outputs = { self, nixpkgs, home-manager, zen-browser, rose-pine-hyprcursor, ... }@inputs: {
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
	        };
	      }
	    ];
	    specialArgs = { inherit inputs; };
	  };
	};

}
