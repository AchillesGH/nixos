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
      listen_addresses = ["127.0.0.1:53"]
      max_clients = 250
      ipv4_servers = true
      ipv6_servers = false
      dnscrypt_servers = true
      doh_servers = true
      odoh_servers = false
      require_dnssec = false
      require_nolog = true
      require_nofilter = true
      disabled_server_names = []
      force_tcp = false
      timeout = 5000
      http3 = true
      keepalive = 30
      log_file = "/var/log/dnscrypt-proxy/dnscrypt-proxy.log"
      use_syslog = true
      log_files_max_size = 10
      log_files_max_age = 7
      log_files_max_backups = 1
      cert_refresh_delay = 240
      bootstrap_resolvers = ["9.9.9.11:53", "8.8.8.8:53"]
      ignore_system_dns = true
      netprobe_timeout = 60
      netprobe_address = "9.9.9.9:53"
      block_ipv6 = false
      block_unqualified = true
      block_undelegated = true
      reject_ttl = 10
      cache = true
      cache_size = 4096
      cache_min_ttl = 60
      cache_max_ttl = 86400
      cache_neg_min_ttl = 60
      cache_neg_max_ttl = 600

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
