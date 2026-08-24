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
    DNSSEC = "allow-downgrade";
    LLMNR = false;
    MulticastDNS = false;
    FallbackDNS = false;
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
