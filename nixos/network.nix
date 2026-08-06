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
      AddressRandomization = "once";
      AddressRandomizationRange = "full";
      Country = "IN";
    };
  };

  services.resolved.enable = true;
  services.resolved.settings.Resolve = {
    DNSSEC = "yes";
    # Domains = [ "~." ];
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
    allowedTCPPortRanges = lib.mkForce [ ];
    allowedUDPPortRanges = lib.mkForce [ ];
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

  /*
    services.avahi = {
      enable = false;
      nssmdns4 = true;
      openFirewall = true;
    };
    services.printing = {
      enable = false;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
  */

}
