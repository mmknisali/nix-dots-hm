{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  # Home Manager release this config was first used with. Independent from the
  # NixOS system.stateVersion in configuration.nix (25.11).
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    qt6.qtwayland
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
  home.file.".config/rofi".source = ./config/rofi;
  home.file.".config/starship.toml".source = ./config/starship/starship.toml;
  home.file.".config/hyprlock" = {
    source = ./config/hyprlock;
    recursive = true;
  };
  home.file.".config/hypr/hyprlock.conf".source = ./config/hyprlock/hyprlock.conf;

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

      # The marker is shared by terminals in the same login session, but is
      # naturally different after a logout/reboot. mkdir makes the claim atomic.
      session_id="''${XDG_SESSION_ID:-''${HYPRLAND_INSTANCE_SIGNATURE:-}}"
      if [[ -n "''${XDG_RUNTIME_DIR:-}" && -n "$session_id" ]] \
        && command -v freshfetch >/dev/null 2>&1 \
        && mkdir "$XDG_RUNTIME_DIR/freshfetch-$session_id" 2>/dev/null; then
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

  # Discover same-user instances even when NixOS activates Home Manager from
  # systemd without a compositor environment. Never reload during a dry run.
  home.activation.reloadHyprland = lib.hm.dag.entryAfter ["linkGeneration"] ''
    if [[ -z "''${DRY_RUN_CMD:-}" ]]; then
      PATH=${lib.makeBinPath [pkgs.hyprland pkgs.python3]}:$PATH \
        ${pkgs.python3}/bin/python3 ${./scripts/reload-hyprland.py}
    fi
  '';

  services.swaync.enable = true;

  services.cliphist.enable = true;
  services.polkit-gnome.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 240;
          on-timeout = "brightnessctl --save set 20%";
          on-resume = "brightnessctl --restore";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
        }
      ];
    };
  };

  programs.direnv.enable = true;

  programs.starship = {
    enable = true;
  };

  imports = [inputs.lazyvim.homeManagerModules.default ./modules/home/waybar.nix];
  programs.lazyvim.enable = true;
}
