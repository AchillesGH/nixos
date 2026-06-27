{
  pkgs,
  config,
  osConfig,
  lib,
  mkNixPak,
  inputs,
  ...
}:
let
  mkFFBrowserSandbox =
    {
      package ? pkgs.firefox-bin,
      appId,
      folder,
      debug ? false,
    }:
    let
      sandbox = mkNixPak {
        config = { sloth, ... }: {

          imports = [
            inputs.nixpak.nixpakModules.network
            ./gui-base.nix
          ];
          app.package = package;
          flatpak.appId = appId;
          dbus.policies = {
            "org.freedesktop.Notifications" = "talk";
            "org.freedesktop.ScreenSaver" = "talk";
          };

          bubblewrap = {
            network = true;
            shareIpc = true;
            bindEntireStore = debug;
            tmpfs = [ "/tmp" ];
            newSession = true;

            env = {
              HOME = sloth.homeDir;
              WAYLAND_DISPLAY = sloth.env "WAYLAND_DISPLAY";
              XDG_RUNTIME_DIR = sloth.env "XDG_RUNTIME_DIR";
              TZ = "Asia/Kolkata";
            };

            bind.rw = [
              (sloth.concat' sloth.homeDir "/.config/${folder}")
              (sloth.concat' sloth.homeDir "/Downloads")
            ];
            bind.ro = lib.mkAfter (
              [
                "/etc/fonts"

              ]
              ++ (if debug then [ "/run/current-system/" ] else [ ])
            );
          };

        };
      };
    in
    sandbox.config.env;
in
{
  programs.firefox.package = (
    mkFFBrowserSandbox {
      package = pkgs.firefox-bin;
      appId = "org.mozilla.firefox";
      folder = "mozilla";
    }
  );

  home.packages = [
    (mkFFBrowserSandbox {
      package = inputs.zen-browser.packages.${pkgs.system}.beta;
      appId = "org.mozilla.zen";
      folder = "zen";
    })
  ];

}
