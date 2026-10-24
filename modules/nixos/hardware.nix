{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [];
  boot.kernelModules = [];
  boot.initrd.kernelModules = [];

  zramSwap.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libglvnd
      intel-media-driver
      vulkan-loader
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Includes SOF firmware for Intel DSP/DMIC.
  hardware.enableRedistributableFirmware = true;

  services.udev.extraRules = ''
    # CP210x (Silicon Labs) - common on ESP32 boards
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0660", GROUP="dialout"

    # Sony DualShock 3
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0660", TAG+="uaccess"
  '';

  services.interception-tools = {
    enable = true;

    plugins = with pkgs; [
      interception-tools-plugins.caps2esc
    ];

    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE \
          | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc \
          | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
}
