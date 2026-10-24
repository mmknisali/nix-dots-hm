{hostName, ...}: {
  networking.hostName = hostName;
  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;
  services.printing.enable = true;
  services.usbmuxd.enable = true;

  services.tailscale.enable = true;
  # Covers the tailnet port and subnet routes.
  services.tailscale.openFirewall = true;

  # Used by the Waybar power-profiles-daemon module.
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.fstrim.enable = true;

  # DNSCrypt is configured but intentionally disabled.
  services.dnscrypt-proxy = {
    enable = false;
    settings = {
      ipv6_servers = false;
      require_dnssec = false;
      bootstrap_resolvers = ["9.9.9.11:53" "1.1.1.1:53"];
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  services.openssh.enable = false;
  services.zapret = {
    enable = true;
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
    ];
  };
}
