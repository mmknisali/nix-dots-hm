{username, ...}: {
  # Sandbox for unattended OpenCode runs. The container only sees
  # /home/${username}/sandbox (mounted at /work), not the rest of the home
  # directory, dotfiles or keys. No privateNetwork: it shares the host network,
  # because the models need internet access.
  containers.opencode = {
    autoStart = false;
    bindMounts."/work" = {
      hostPath = "/home/${username}/sandbox";
      isReadOnly = false;
    };
    config = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        opencode
        git
        cloudflared
        devenv
        php
        php.packages.composer
        nodejs
      ];
      # Same UID as the host user (first normal user, normally 1000; check
      # with `id -u`) so files in the sandbox stay owned by you on the host.
      users.users.agent = {
        isNormalUser = true;
        uid = 1000;
      };
      system.stateVersion = "25.11";
    };
  };

  # Create the shared sandbox directory so no manual mkdir is needed.
  systemd.tmpfiles.rules = [
    "d /home/${username}/sandbox 0755 ${username} users -"
  ];
}
