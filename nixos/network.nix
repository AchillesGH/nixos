{ config, pkgs, ... }:
{
  boot.extraModprobeConfig = "options cfg80211 ieee80211_regdom=IN";
  hardware.wirelessRegulatoryDatabase = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = false;
  networking.resolvconf.enable = false;
  networking.dhcpcd.enable = false;
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

  sops.templates.resolved = {
    content = ''
      [Resolve]
      DNS=45.90.28.0#${config.sops.placeholder.nextdns}.dns.nextdns.io
      DNS=2a07:a8c0::#${config.sops.placeholder.nextdns}.dns.nextdns.io
      DNS=45.90.30.0#${config.sops.placeholder.nextdns}.dns.nextdns.io
      DNS=2a07:a8c1::#${config.sops.placeholder.nextdns}.dns.nextdns.io
      	'';
    path = "/etc/systemd/resolved.conf.d/dns.conf";
    mode = "0444";
  };
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
