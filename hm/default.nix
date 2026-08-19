{
  inputs,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  imv = "org.gnome.Loupe.desktop";
in
{
  home.username = "achilles";
  home.homeDirectory = "/home/achilles";
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.stylix.homeModules.stylix
    ./hyprland
    ./waybar
    ./rofi
    ./nvim
    ./notifs.nix
    ./browsers.nix
    ./user_shell.nix
    ./sandboxing
  ];
  home.stateVersion = "26.11";
  home.packages = with pkgs; [
    android-studio
    apksigner
    awww
    base16-schemes
    bind
    brightnessctl
    clang
    clang-tools
    loupe
    exiftool
    gcr
    ghostscript
    grimblast
    hyprlock
    hyprpicker
    imagemagick
    impala
    iwmenu
    kdePackages.isoimagewriter
    kdePackages.qt6ct
    libreoffice-fresh
    libsForQt5.qt5ct
    moodle-dl
    nemo-emblems
    nemo-preview
    nemo-with-extensions
    overskride
    pandoc
    papirus-icon-theme
    protonup-qt
    proton-vpn
    proton-vpn-cli
    python314Packages.curl-cffi
    qalculate-qt
    qpdf
    qrtool
    ripgrep-all
    rofi-bluetooth
    rofimoji
    uutils-coreutils-noprefix
    vlc
    vscodium
    wl-clipboard

    (pkgs.octaveFull.withPackages (
      ps: with ps; [
        control
        signal
        symbolic
        image
        statistics
        optim
      ]
    ))
  ];
  programs.obs-studio.enable = true;
  programs.obs-studio.package = (
    pkgs.obs-studio.override {
      cudaSupport = true;
    }
  );
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
    wlrobs
    obs-backgroundremoval
    obs-pipewire-audio-capture
    obs-gstreamer
    obs-vkcapture
  ];

  services.pipewire.enable = true;
  services.pipewire.pulseConfigs = {

    "pulse-server" = {
      "pulse.properties" = {
        "server.address" = [
          "unix:native"
          "tcp:127.0.0.1:4713"
        ];
      };
    };

  };

  programs.yt-dlp.enable = true;
  programs.direnv.enable = true;
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    # package = inputs.zen-browser.packages.${pkgs.system}.beta;
    package = null;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
  xdg.userDirs.setSessionVariables = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.extraConfig.SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
  xdg.configFile."nwg-bar/bar.json".text = ''
    [
     {
       "label": "Lock",
       "exec": "hyprlock",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-lock-screen.svg"
     },
     {
       "label": "Logout",
       "exec": "hyprshutdown -t \"Logging out...\"",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-log-out.svg"
     },
     {
       "label": "Reboot",
       "exec": "hyprshutdown -t \"Rebooting...\" -p \"reboot\"",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-reboot.svg"
     },
     {
       "label": "Shutdown",
       "exec": "hyprshutdown -p \"systemctl -i poweroff\"",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-shutdown.svg"
     }
    ]
  '';
  xdg.configFile."nwg-bar/style.css".text = ''
    window {
            background-color: rgba (0, 0, 0, 1.0)
    }

    /* Outer bar container, takes all the window width/height */
    #outer-box {
    	margin: 0px
    }

    /* Inner bar container, surrounds buttons */
    #inner-box {
    	background-color: rgba (0, 0, 0, 0.85);
    	border-radius: 10px;
    	border-style: none;
    	border-width: 1px;
    	border-color: rgba (156, 142, 122, 0.7);
    	padding: 5px;
    	margin: 5px
    }

    button, image {
    	background: none;
    	border: none;
    	box-shadow: none
    }

    button {
    	padding-left: 10px;
    	padding-right: 10px;
    	margin: 5px
    }

    button:hover {
    	background-color: rgba (255, 255, 255, 0.1)
    }
  '';
  programs.btop.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
  home.pointerCursor = {
    gtk.enable = true;
    enable = true;
    package = pkgs.rose-pine-hyprcursor;
    name = "rose-pine-hyprcursor";
    hyprcursor.enable = true;
    x11.enable = true;
    size = 24;
  };
  xdg.enable = true;
  xdg.desktopEntries.nemo = {
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      "text/html" = "zen-beta.desktop";
      "application/pdf" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "image/jpeg" = imv;
      "image/png" = imv;
      "image/gif" = imv;
      "image/webp" = imv;
      "image/tiff" = imv;
      "image/bmp" = imv;
      "image/svg+xml" = imv;
      "image/avif" = imv;
      "image/heic" = imv;
      "image/jxl" = imv;

    };
  };
  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
        # exec-arg = ""; # argument
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":"; # Hides all window control buttons
      };
    };
  };
  services.gnome-keyring.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.chromium.enable = true;
  programs.brave.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      shell_integration = "no-cursor";
      cursor_shape = "block";
      cursor_trail = 1;
      background_blur = 1;
      window_padding_width = 10;
      tab_bar_style = "fade";
      tab_fade = 1;
      active_tab_font_style = "bold";
      inactive_tab_font_style = "bold";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
    };
  };

  # wayland.windowManager.hyprland = {
  #enable = true; # enable Hyprland
  #package = null;
  #    portalPackage = null;

  #};

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/circus.yaml";
  stylix.polarity = "dark";
  stylix.targets.gtksourceview.colors.enable = false;
  stylix.overlays.enable = false;
  stylix.icons.enable = true;
  stylix.icons.dark = "Papirus";
  stylix.icons.light = "Papirus";
  stylix.icons.package = pkgs.papirus-icon-theme;
  stylix.targets.zen-browser.enable = false;
  stylix.targets.btop.enable = true;
  stylix.targets.qt.enable = true;
  stylix.image = ./neon_shallows.png;
  stylix.fonts = {
    serif = {
      name = "serif";
    };

    sansSerif = {
      name = "sans-serif";
    };

    monospace = {
      name = "monospace";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix = {
    opacity = {
      terminal = 0.9;
      applications = 0.9;
      desktop = 1.0;
      popups = 1.0;
    };

  };

  programs.git = {
    enable = true;
    settings.user.name = "achillesgh";
    settings.user.email = "achillesgh@proton.me";
    signing = {
      key = "39401C866F3B879FDC6CA2A39CB1383F1B41B400";
      signByDefault = true;
      format = "openpgp";
    };
  };
  programs.quickshell = {
    enable = true;
  };
}
