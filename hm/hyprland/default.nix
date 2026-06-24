{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hypridle.nix
  ];
  services.hyprpolkitagent.enable = true;
  services.cliphist = {
    enable = true;

    systemdTargets = [ "graphical-session.target" ];

    extraOptions = [
      "-max-dedupe-search"
      "10"
      "-max-items"
      "500"
    ];
    allowImages = true;

  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          fit_mode = "fill";
        }
      ];
    };
  };

  systemd.user.services = {
    cliphist.Service.Slice = "background.slice";
    cliphist-images.Service.Slice = "background.slice";
    hyprpaper.Service.Slice = "background.slice";
  };
  systemd.user.services.kdeconnect.Service.Environment = lib.mkForce "";

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;
    systemd.enable = false;
    extraConfig = ''
      ${builtins.readFile ./hyprland.lua}
      hl.permission({ binary = "${lib.getExe pkgs.grim}", type = "screencopy", mode = "allow" })
      hl.permission({ binary = "${lib.getExe pkgs.hyprpicker}", type = "screencopy", mode = "allow" })
      hl.permission({ binary = "${lib.getExe pkgs.grimblast}", type = "screencopy", mode = "allow" })
      hl.permission({ binary = "${lib.getExe config.programs.hyprlock.package}", type = "screencopy", mode = "allow" })
      hl.permission({ binary = "${config.wayland.windowManager.hyprland.finalPortalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped", type = "screencopy", mode = "allow" })
    '';
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
