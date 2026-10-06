{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  home.username = "ali";
  home.homeDirectory = "/home/${username}";
  # Home Manager release this config was first used with. Independent from the
  # NixOS system.stateVersion in configuration.nix (25.11).
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    qt6.qtwayland
    libsForQt5.qtwayland
    opencode
    wl-clipboard
  ];

  #importing config files
  home.file.".config/hypr" = {
    source = ./config/hypr;
    recursive = true;
  };
  home.file.".config/kitty" = {
    source = ./config/kitty;
    recursive = true;
  };
  #home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/starship.toml".source = ./config/starship/starship.toml;
  #home.file.".config/uwsm".source = ./config/uwsm;
  home.file.".config/waybar" = {
    source = ./config/waybar;
    recursive = true;
  };
  home.file.".config/hyprlock" = {
    source = ./config/hyprlock;
    recursive = true;
  };
  home.file.".config/hypr/hyprlock.conf".source = ./config/hyprlock/hyprlock.conf;

  #  home.file.".config/opencode/opencode.json".source = ./config/opencode/opencode.json;
  # home.file.".config/opencode/oh-my-openagent.json".source = ./config/opencode/oh-my-openagent.json;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["${config.home.homeDirectory}/Pictures/wallpapers/winter-16.png"];
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/Pictures/wallpapers/winter-16.png";
          fit_mode = "cover";
        }
        {
          monitor = "HDMI-A-1";
          path = "${config.home.homeDirectory}/Pictures/wallpapers/winter-16.png";
          fit_mode = "cover";
        }
      ];
    };
  };

  # Hyprlock - screen locker (package only, config via file above)
  programs.hyprlock = {
    enable = true;
  };

  home.file.".local/bin/zen-fast" = {
    source = ./scripts/zen-fast;
    executable = true;
  };

  home.file."Pictures/wallpapers/winter-16.png".source = ./wallpapers/winter-16.png;
  home.file."Pictures/wallpapers/profile.jpeg".source = ./wallpapers/profile.jpeg;

  home.file.".local/bin/zen-warmup" = {
    source = ./scripts/zen-warmup;
    executable = true;
  };

  home.file.".local/bin/zen-launch" = {
    source = ./scripts/zen-launch;
    executable = true;
  };

  home.file.".local/bin/cliphist-menu" = {
    source = ./scripts/cliphist.sh;
    executable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      size = 10000;
      save = 10000;
      append = true;
      share = true;
      ignoreSpace = true;
      ignoreAllDups = true;
    };
    historySubstringSearch.enable = true;
    shellAliases = {
      c = "clear";
      l = "eza -lh --icons=auto";
      ls = "eza -1 --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "eza -lhD --icons=auto";
      lt = "eza --icons=auto --tree";
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gl = "git log --oneline -10";
      gd = "git diff | bat";
      gb = "git branch";
      gco = "git checkout";
      gcl = "git clone";
      gf = "git fetch";
      gm = "git merge";
      gr = "git rebase";
      gst = "git stash";
      gstp = "git stash pop";
      gstl = "git stash list";
      cat = "bat";
      op = "opencode";
      opc = "opencode --continue";
    };
    initContent = ''
      if [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv zsh)"
      elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
      elif command -v brew >/dev/null 2>&1; then
        eval "$(brew shellenv zsh)"
      fi

      if command -v freshfetch >/dev/null 2>&1; then
        freshfetch
      fi
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.opencode/bin"
    "$HOME/.spicetify"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.activation.removeLegacyConfigDirectories = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    for config_dir in hypr kitty waybar hyprlock zsh; do
      config_path="$HOME/.config/$config_dir"
      if [[ -L "$config_path" ]]; then
        legacy_target="$(${pkgs.coreutils}/bin/readlink "$config_path")"
        case "$legacy_target" in
          ${builtins.storeDir}/*-home-manager-files/.config/"$config_dir")
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm "$config_path"
            ;;
        esac
      fi
    done
  '';

  services.swaync.enable = true;

  services.cliphist.enable = true;
/*
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  */
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  programs.direnv.enable = true;

  programs.starship = {
    enable = true;
  };

  imports = [inputs.lazyvim.homeManagerModules.default];
  programs.lazyvim.enable = true;
}
