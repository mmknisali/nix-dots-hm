# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Clara"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  #nix-commands and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # SDDM configuration
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.theme = "pixie";

  #fonts for icons and waybar
  fonts.packages = with pkgs; [
  lexend
  nerd-fonts.jetbrains-mono
  nerd-fonts.symbols-only
  nerd-fonts.caskaydia-cove
 ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # withUWSM = true;
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # NVIDIA Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libglvnd
      intel-media-driver
      vulkan-loader
      nvidia-vaapi-driver
      mangohud
      gamemode
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    nvidiaSettings = true;
    
    # PRIME Sync for hybrid graphics
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  # Wayland/NVIDIA environment variables  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    MANGOHUD = "1";
    ENABLE_GAMEMODE = "1";
  };

  # Kernel parameters
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  # Load NVIDIA modules at boot
  boot.kernelModules = [ "nvidia" "nvidia-drm" "nvidia-modeset" ];

  # Load NVIDIA in initramfs for early KMS
  boot.initrd.kernelModules = [ "nvidia-drm" "nvidia-modeset" ];


  # Enable the X11 windowing system.
 # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
   # layout = "us";
    #variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ali = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$SrFGf/IANp31e26ZiPQ2o0$UaQ1ruggDowaDrOtVN674gPkx.XqyWAEsfp7.UbJ1wA";
    description = "ali";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.config.problems.handlers = {
    nvidia-x11.broken = "warn";
  };
  #enable bluetooth stuff
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  };

  #enable blueman
  services.blueman.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    hyprpaper
    waybar
    neovim
    kitty
    starship
    uwsm
    rofi
    swaynotificationcenter
    playerctl
    wlogout
    blueman
    tailscale
    polkit_gnome
    cliphist
    wl-clipboard
    (inputs.zen-browser.packages.x86_64-linux.twilight)
    (inputs.devenv.packages.x86_64-linux.default)
    direnv
    eza
    hyprlock
    docker
    docker-compose
    bat 
    (pkgs.stdenv.mkDerivation {
      name = "pixie-sddm";
      src = pkgs.fetchFromGitHub {
        owner = "xCaptaiN09";
        repo = "pixie-sddm";
        rev = "main";
        sha256 = "sha256-NkjWP/y3kLRjYM0Wr3l7ndbMx3XYxQFXy07C28vrUSU=";
      };
      installPhase = ''
        mkdir -p $out/share/sddm/themes/pixie
        cp -r * $out/share/sddm/themes/pixie/
      '';
    })
    ];

    #eenable tailscale
    services.tailscale.enable = true;
    
  #enable nix ld 
  programs.nix-ld.enable = true;
    
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # PAM configuration for hyprlock
  security.pam.services.hyprlock = {};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
