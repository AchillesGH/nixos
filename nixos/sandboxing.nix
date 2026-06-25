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
      debug ? false,
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
            bindEntireStore = debug;
            tmpfs = [ "/tmp" ];
            extraStorePaths = [
              config.hardware.graphics.package
            ]
            ++ config.hardware.graphics.extraPackages
            ++ config.fonts.fontconfig.confPackages;
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
            bind.ro = [ "/etc/fonts" ] ++ (if debug then [ "/run/current-system/" ] else [ ]);
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
      appId = "org.mozilla.zen";
      folder = "zen";
    })
    (mkFFBrowserSandbox {
      package = pkgs.firefox-bin;
      appId = "org.mozilla.firefox";
      folder = "mozilla";
    })
    (mkNixPak {
      config = { sloth, ... }: {

        imports = [
          inputs.nixpak.nixpakModules.gui-base
        ];
        app.package = pkgs.papers;
        flatpak.appId = "org.gnome.Papers";
        fonts.fonts = config.fonts.packages;
        bubblewrap = {
          bindEntireStore = false;
          tmpfs = [ "/tmp" ];
          extraStorePaths = [
            config.hardware.graphics.package
            config.home-manager.users.achilles.xdg.configFile."gtk-4.0/gtk.css".source
            config.home-manager.users.achilles.xdg.configFile."gtk-4.0/settings.ini".source

          ]
          ++ config.hardware.graphics.extraPackages
          ++ config.fonts.fontconfig.confPackages;
          bind.ro = [
            "${config.home-manager.users.achilles.home-files}/.config/gtk-4.0"
          ];
        };
      };
    }).config.env

  ];

}
