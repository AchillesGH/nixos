{ pkgs, config, ... }:
{
  programs.uwsm.enable = true;
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    greeterManagesPlymouth = true;

    settings = rec {
      default_session.command =
        with pkgs;
        "${lib.getExe tuigreet} --time --user-menu --remember --remember-session";

      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "achilles";
      };

    };

  };
  services.displayManager.sessionPackages = [
    config.home-manager.users.achilles.wayland.windowManager.hyprland.finalPackage
  ];
}
