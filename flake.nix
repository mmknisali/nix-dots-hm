{
  description = "Hyprland nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "ali";
    hostName = "Clara";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (nixpkgs) lib;

    # Keep path contexts when putting files into build scripts. `path:.`
    # includes local/ignored hardware configuration; Git flakes do not.
    nixFiles =
      [./configuration.nix ./flake.nix ./home.nix ./system-packages.nix]
      ++ lib.filesystem.listFilesRecursive ./modules;
    nixArgs = lib.escapeShellArgs (map (file: "${file}") nixFiles);
    bashFiles = ''${./config/hypr}/scripts/*.sh ${./config/hypr}/UserScripts/*.sh ${./config/hyprlock}/scripts/*.sh'';
    zshFiles = ''${./scripts}/cliphist.sh ${./scripts}/zen-*'';
    waybarFiles = ''${./config/waybar}/config ${./config/waybar}/Modules* ${./config/waybar}/UserModules ${./config/waybar}/configs/*'';
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

    formatter.${system} = pkgs.alejandra;

    checks.${system} = {
      formatting = pkgs.runCommand "check-nix-formatting" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${nixArgs}
        touch "$out"
      '';

      shell-syntax = pkgs.runCommand "check-shell-syntax" {} ''
        for file in ${bashFiles}; do
          ${pkgs.bash}/bin/bash -n "$file"
        done
        for file in ${zshFiles}; do
          ${pkgs.zsh}/bin/zsh -n "$file"
        done
        export PYTHONPYCACHEPREFIX="$TMPDIR/pycache"
        ${pkgs.python3}/bin/python3 -m py_compile ${./config/hypr}/UserScripts/*.py ${./config/hypr}/scripts/*.py ${./scripts}/*.py
        DOTS_SCRIPT_ROOT=${./scripts} DOTS_WAYBAR_ROOT=${./config/waybar} \
          ${pkgs.python3}/bin/python3 ${./tests/test-scripts.py}
        touch "$out"
      '';

      # Hyprland 0.56 embeds Lua 5.5, so the config has to be valid 5.5.
      lua-syntax = pkgs.runCommand "check-hypr-lua-syntax" {} ''
        for file in ${./config/hypr}/*.lua; do
          ${pkgs.lua5_5}/bin/luac -p "$file"
        done
        touch "$out"
      '';

      waybar-json = pkgs.runCommand "check-waybar-json" {} ''
        ${pkgs.python3}/bin/python3 ${./scripts/jsonc-check.py} ${waybarFiles}
        touch "$out"
      '';

      rofi-rasi = pkgs.runCommand "check-rofi-rasi" {} ''
        export HOME="$TMPDIR/rofi-home"
        mkdir -p "$HOME/.config"
        ln -s ${./config/rofi} "$HOME/.config/rofi"
        for file in ${./config/rofi}/*.rasi ${./config/rofi}/themes/*.rasi; do
          if ! ${pkgs.rofi}/bin/rofi -no-config -theme "$file" -dump-theme > theme.out 2> theme.err; then
            cat theme.err >&2
            exit 1
          fi
          if grep -E 'Failed to parse|configuration failed|needs to be set' theme.err; then
            echo "rofi failed to validate $file" >&2
            exit 1
          fi
        done
        DOTS_ROFI_BIN=${pkgs.rofi}/bin/rofi DOTS_ROFI_ROOT=${./config/rofi} \
          ${pkgs.python3}/bin/python3 ${./tests/test-rofi.py}
        touch "$out"
      '';

      statix = pkgs.runCommand "check-statix" {} ''
        for file in ${nixArgs}; do
          ${pkgs.statix}/bin/statix check --config ${./statix.toml} "$file"
        done
        touch "$out"
      '';
      deadnix = pkgs.runCommand "check-deadnix" {} ''
        ${pkgs.deadnix}/bin/deadnix --fail ${nixArgs}
        touch "$out"
      '';
      shellcheck = pkgs.runCommand "check-shellcheck" {} ''
        ${pkgs.shellcheck}/bin/shellcheck ${bashFiles}
        touch "$out"
      '';
      luacheck = pkgs.runCommand "check-luacheck" {} ''
        ${pkgs.luaPackages.luacheck}/bin/luacheck --config ${./.luacheckrc} ${./config/hypr}/*.lua
        touch "$out"
      '';
    };
  };
}
