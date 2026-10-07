{
  inputs,
  config,
  pkgs,
  ...
}: {
  home.username = "achilles";
  home.homeDirectory = "/home/achilles";
  imports = [
    inputs.zen-browser.homeModules.twilight-official
    inputs.stylix.homeModules.stylix
    ./hyprland
    ./waybar
    ./rofi
    ./helix
    ./notifs.nix
    ./browsers.nix
    ./user_shell.nix
    ./protonvpn.nix
    ./xdg.nix
  ];

  xdg.desktopEntries.nemo = {
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };

  home.stateVersion = "26.11";
  home.packages = with pkgs; [
    apksigner
    awww
    base16-schemes
    bind
    brightnessctl
    clang
    loupe
    exiftool
    gcr_3
    ghostscript
    grimblast
    hyprlock
    hyprpicker
    imagemagick
    impala
    kdePackages.isoimagewriter
    kdePackages.qt6ct
    libreoffice-stable
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
    python314Packages.curl-cffi
    qalculate-qt
    qpdf
    qrtool
    ripgrep-all
    rofi-bluetooth
    rofimoji
    usbguard-notifier
    uutils-coreutils-noprefix
    vlc
    vscodium
    wl-clipboard
    xhost
    xlsclients
  ];

  systemd.user.services.usbguard-notifier = {
    Unit = {
      Description = "USBGuard notifier";
      After = ["usbguard.target"];
    };
    Service.ExecStart = "${pkgs.usbguard-notifier}/bin/usbguard-notifier";
    Install.WantedBy = ["default.target"];
  };

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
    # setAsDefaultBrowser = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight-official;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.btop.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    enable = true;
    package = pkgs.rose-pine-hyprcursor;
    name = "rose-pine-hyprcursor";
    hyprcursor.enable = true;
    x11.enable = true;
    size = 24;
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

  programs.keepassxc = {
    autostart = true;
    enable = true;
  };

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

  services.udiskie = {
    enable = true;
    tray = "auto";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
