{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.extraModprobeConfig = "options cfg80211 ieee80211_regdom=IN";
  hardware.wirelessRegulatoryDatabase = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.resolvconf.enable = false;
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.settings = {
    General = {
      EnableNetworkConfiguration = false;
      AddressRandomization = "network";
      AddressRandomizationRange = "full";
      Country = "IN";
    };
  };

  services.resolved.enable = true;
  services.resolved.settings.Resolve = {
    DNS = ["127.0.0.1:53"];
    Domains = ["~."];
    LLMNR = false;
    MulticastDNS = false;
  };

  sops.templates."dnscrypt-proxy.toml" = {
    content = ''
      server_names = ['nextdns-${config.sops.placeholder."nextdns"}']
      ipv4_servers = true
      ipv6_servers = false

      listen_addresses = ["127.0.0.1:53"]
      ignore_system_dns = true

      require_dnssec = true
      require_nolog = false
      require_nofilter = false

      http3 = true
      http3_probe = true
      force_tcp = false
      timeout = 5000
      keepalive = 30

      bootstrap_resolvers = ["9.9.9.9:9953", "1.1.1.1:53"]
      netprobe_address = "9.9.9.9:443"
      netprobe_timeout = 60

      block_unqualified = true
      block_undelegated = true
      block_ipv6 = false
      reject_ttl = 50

      cache = true
      cache_size = 4096
      cache_min_ttl = 60
      cache_max_ttl = 86400
      cache_neg_min_ttl = 60
      cache_neg_max_ttl = 600

      use_syslog = true

      [static.nextdns-${config.sops.placeholder."nextdns"}]
          stamp = '${config.sops.placeholder."nextdns_stamp"}'
    '';

    mode = "0440";
    restartUnits = ["dnscrypt-proxy.service"];
  };

  services.dnscrypt-proxy = {
    enable = true;
    configFile = config.sops.templates."dnscrypt-proxy.toml".path;
  };

  # For DynamicUser=true in dnscrypt-proxy.service
  systemd.services.dnscrypt-proxy.serviceConfig = {
    LoadCredential = "dnscrypt-proxy.toml:${config.sops.templates."dnscrypt-proxy.toml".path}";
    ExecStart = lib.mkForce "${pkgs.dnscrypt-proxy}/bin/dnscrypt-proxy -config \${CREDENTIALS_DIRECTORY}/dnscrypt-proxy.toml";
  };

  networking.firewall = rec {
    enable = true;
    allowedTCPPortRanges = lib.mkForce [];
    allowedUDPPortRanges = lib.mkForce [];
  };
}
