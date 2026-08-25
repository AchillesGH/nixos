{
  config,
  lib,
  pkgs,
  ...
}:
{
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
    DNSSEC = "yes";
    DNSOverTLS = "yes";
    LLMNR = false;
    MulticastDNS = false;
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
    restartUnits = [ "systemd-resolved.service" ];
    mode = "0444";
  };

  networking.firewall = rec {
    enable = true;
    allowedTCPPortRanges = lib.mkForce [ ];
    allowedUDPPortRanges = lib.mkForce [ ];
  };

  networking.wg-quick.interfaces = {
    proton-us = {
      autostart = false;
      configFile = "/etc/wireguard/laptop-US-FREE-85.conf";
    };
  };
}
