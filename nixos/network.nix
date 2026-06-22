{ pkgs, ... }:
{
  boot.extraModprobeConfig = "options cfg80211 ieee80211_regdom=IN";
  hardware.wirelessRegulatoryDatabase = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = false;
  networking.resolvconf.enable = false;
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    Network = {
      NameResolvingService = "systemd";
    };
    General = {
      EnableNetworkConfiguration = true;
      AddressRandomization = "once";
      AddressRandomizationRange = "full";
      Country = "IN";
    };
  };

  services.resolved.enable = true;
  services.resolved.settings.Resolve = {
    DNSSEC = "allow-downgrade";
    Domains = [ "~." ];
    DNSOverTLS = true;
    FallbackDNS = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  networking.nameservers = [
    "45.90.28.0#264978.dns.nextdns.io"
    "2a07:a8c0::#264978.dns.nextdns.io"
    "45.90.30.0#264978.dns.nextdns.io"
    "2a07:a8c1::#264978.dns.nextdns.io"
  ];
  networking.firewall = rec {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

}
