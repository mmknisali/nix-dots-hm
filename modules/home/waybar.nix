{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.waybar;
  sourcePrefix = "${toString ../../config/waybar}/";
  # Keep the whole preset tree in the store so CSS sibling imports work.
  presetPath = file:
    if lib.hasPrefix sourcePrefix (toString file)
    then "${../../config/waybar}/${lib.removePrefix sourcePrefix (toString file)}"
    else "${file}";
in {
  options.dotfiles.waybar = {
    layout = lib.mkOption {
      type = lib.types.path;
      default = ../../config/waybar/config;
      description = "Declarative Waybar layout file.";
    };
    style = lib.mkOption {
      type = lib.types.path;
      default = ../../config/waybar/style.css;
      description = "Declarative Waybar stylesheet.";
    };
  };

  config = {
    home.file.".config/waybar" = {
      source = ../../config/waybar;
      recursive = true;
    };
    # Serve selected files via explicit arguments rather than replacing the
    # Home Manager links. Includes/imports still resolve under ~/.config/waybar.
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
    systemd.user.services.waybar.Service.ExecStart =
      lib.mkForce
      "${lib.getExe config.programs.waybar.package} --config ${lib.escapeShellArg (presetPath cfg.layout)} --style ${lib.escapeShellArg (presetPath cfg.style)}";
    systemd.user.services.waybar.Unit.X-Restart-Triggers = [
      (presetPath cfg.layout)
      (presetPath cfg.style)
    ];
  };
}
