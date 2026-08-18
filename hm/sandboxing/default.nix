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
      extraDbusPolicies ? { },
      enablePasta ? false,
    }:
    let
      sandbox = mkNixPak {
        config = { sloth, ... }: {

          imports = [
            inputs.nixpak.nixpakModules.network
          ];
          app.package = package;
          flatpak.appId = appId;
          pasta.enable = enablePasta;
          dbus.policies = {
            "org.freedesktop.Notifications" = "talk";
            "org.freedesktop.ScreenSaver" = "talk";
            "${appId}" = "own";
            "${appId}.*" = "own";
            "org.mpris.MediaPlayer2" = "talk";
            "org.mpris.MediaPlayer2.*" = "own";
            "org.freedesktop.DBus" = "talk";
            "org.gtk.vfs.*" = "talk";
            "org.gtk.vfs" = "talk";
            "ca.desrt.dconf" = "talk";
            "org.freedesktop.portal.*" = "talk";
            "org.a11y.Bus" = "talk";
          }
          // extraDbusPolicies;

          gpu.enable = lib.mkDefault true;
          fonts.enable = true;
          locale.enable = true;

          fonts.fonts = osConfig.fonts.packages;
          bubblewrap = {
            network = true;
            shareIpc = true;
            dieWithParent = true;
            tmpfs = [ "/tmp" ];
            newSession = true;
            sockets = {
              wayland = true;
              pipewire = true;
              pulse = true;
            };
            extraStorePaths = [
              osConfig.hardware.graphics.package
              config.xdg.configFile."gtk-3.0/gtk.css".source
              config.xdg.configFile."gtk-3.0/settings.ini".source
            ]
            ++ osConfig.hardware.graphics.extraPackages
            ++ osConfig.fonts.fontconfig.confPackages;
            env = {
              HOME = sloth.homeDir;
              WAYLAND_DISPLAY = sloth.env "WAYLAND_DISPLAY";
              XDG_RUNTIME_DIR = sloth.env "XDG_RUNTIME_DIR";
              TZ = "Asia/Kolkata";
            };

            bind.rw = [
              (sloth.concat' sloth.homeDir "/.config/${folder}")
              (sloth.concat' sloth.homeDir "/Downloads")

              # new
              [
                sloth.appCacheDir
                sloth.xdgCacheHome
              ]
              (sloth.concat' sloth.xdgCacheHome "/fontconfig")
              (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
              (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache_db")
              (sloth.concat' sloth.xdgCacheHome "/radv_builtin_shaders")

              (sloth.concat' sloth.runtimeDir "/at-spi/bus")
              (sloth.concat' sloth.runtimeDir "/gvfsd")
              (sloth.concat' sloth.runtimeDir "/dconf")
              (sloth.concat' sloth.runtimeDir "/doc")
            ];
            bind.ro = lib.mkAfter ([
              (sloth.concat' sloth.xdgConfigHome "/dconf")
              "/etc/fonts"

              [
                "${config.xdg.configFile."gtk-3.0/gtk.css".source}"
                (sloth.concat' sloth.homeDir "/.config/gtk-3.0/gtk.css")
              ]
              [
                "${config.xdg.configFile."gtk-3.0/settings.ini".source}"
                (sloth.concat' sloth.homeDir "/.config/gtk-3.0/settings.ini")
              ]
              "/run/cups/cups.sock"
              "/run/avahi-daemon/socket"
            ]

            );
          };

        };
      };
    in
    sandbox.config.env;
in
{
  home.packages = [
    (
      mkFFBrowserSandbox {
        package = config.programs.firefox.finalPackage;
        appId = "org.mozilla.firefox";
        folder = "mozilla";
      }
      // {
        meta.priority = -1;
      }
    )

    (
      mkFFBrowserSandbox {
        package = config.programs.brave.finalPackage;
        appId = "com.brave.Browser";
        folder = "BraveSoftware";
        enablePasta = true;
        extraDbusPolicies = {
          "org.freedesktop.secrets" = "talk";
        };
      }
      // {
        meta.priority = -1;
      }
    )

    (mkFFBrowserSandbox {
      package = inputs.zen-browser.packages.${pkgs.system}.beta.override {
        cfg = {
          speechSynthesisSupport = false;
          pipewireSupport = true;
        };
      };
      appId = "org.mozilla.zen";
      folder = "zen";
    })

    (mkFFBrowserSandbox {
      package = pkgs.librewolf-bin;
      appId = "org.mozilla.librewolf";
      folder = "librewolf";
    })

  ];

}
