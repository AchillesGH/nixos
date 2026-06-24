{
  pkgs,
  config,
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
    }:
    let
      sandbox = mkNixPak {
        config = { sloth, ... }: {

          imports = [
            inputs.nixpak.nixpakModules.gui-base
            inputs.nixpak.nixpakModules.network
          ];
          app.package = package;
          flatpak.appId = appId;
          dbus.policies = {
            "org.freedesktop.Notifications" = "talk";
            "org.freedesktop.ScreenSaver" = "talk";
          };

          fonts.fonts = config.fonts.packages;
          bubblewrap = {
            network = true;
            shareIpc = true;
            tmpfs = [ "/tmp" ];
            bindEntireStore = false;
            extraStorePaths = [
              config.hardware.graphics.package
            ]
            ++ config.hardware.graphics.extraPackages
            ++ config.fonts.fontconfig.confPackages;
            clearEnv = true;
            env = {
              HOME = sloth.homeDir;
              WAYLAND_DISPLAY = sloth.env "WAYLAND_DISPLAY";
              XDG_RUNTIME_DIR = sloth.env "XDG_RUNTIME_DIR";
            };

            bind.rw = [
              (sloth.concat' sloth.homeDir "/.config/${folder}")
              (sloth.concat' sloth.homeDir "/Downloads")
            ];
            bind.ro = [ "/etc/fonts" ];
          };

        };
      };
    in
    sandbox.config.env;
in
{

  environment.systemPackages = [

    (mkFFBrowserSandbox {
      package = inputs.zen-browser.packages.${pkgs.system}.beta;
      appId = "app.zen_browser.zen";
      folder = "zen";
    })
    (mkFFBrowserSandbox {
      package = pkgs.firefox-bin;
      appId = "org.mozilla.FirefoxBinRestricted";
      folder = "mozilla";
    })
    (mkFFBrowserSandbox {
      package = pkgs.zsh;
      appId = "org.debug.Sandbox";
      folder = "debug";
    })
  ];

}
