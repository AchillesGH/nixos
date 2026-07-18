{ config, lib, pkgs, ... }:
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
      NameResolvingService = "none";
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
    DNSSEC = "yes";
    Domains = [ "~." ];
    DNSOverTLS = "yes";
    LLMNR = false;
    MulticastDNS = false;
    FallbackDNS = false;
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
    allowedTCPPortRanges = [ ];
    allowedUDPPortRanges = [ ];
    extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 1714:1764 -s 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 1714:1764 -s 192.168.1.0/24 -j nixos-fw-accept
    '';
  };

  networking.wg-quick.interfaces = {
    proton-us = {
      autostart = false;
      configFile = "/etc/wireguard/laptop-US-FREE-85.conf";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

}
