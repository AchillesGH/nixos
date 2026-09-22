{pkgs, ...}: {
  xdg.autostart.entries = [
    "${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"
  ];

  xdg.configFile = {
    "Proton/VPN/settings.json".text = builtins.toJSON {
      protocol = "wireguard";
      killswitch = 2;
      custom_dns = {
        enabled = false;
        ip_list = [
        ];
      };
      ipv6 = true;
      anonymous_crash_reports = false;
      features = {
        netshield = 2;
        moderate_nat = false;
        vpn_accelerator = true;
        port_forwarding = false;
        split_tunneling = {
          enabled = false;
          mode = "exclude";
          config_by_mode = {
            exclude = {
              mode = "exclude";
              app_paths = [
              ];
              ip_ranges = [
              ];
            };
            include = {
              mode = "include";
              app_paths = [
              ];
              ip_ranges = [
              ];
            };
          };
        };
      };
    };
    "Proton/VPN/app-config.json".text = builtins.toJSON {
      tray_pinned_servers = [
        "JP"
        "US"
      ];
      connect_at_app_startup = "FASTEST";
      start_app_minimized = true; # required since autostart entry does not have `--start-minimized`
    };
  };
}
