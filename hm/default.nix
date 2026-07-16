{
  inputs,
  config,
  pkgs,
  osConfig,
  ...
}:

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
    ./sandboxing
  ];
  home.stateVersion = "26.11";
  home.packages = with pkgs; [
    google-fonts
    gcr
    pandoc
    wl-clipboard
    papirus-icon-theme
    brightnessctl
    bind
    libreoffice-fresh
    apksigner
    kdePackages.qt6ct
    protonup-qt
    ripgrep-all
    libsForQt5.qt5ct
    vscodium
    nemo-with-extensions
    nemo-preview
    nemo-emblems
    iwmenu
    rofi-bluetooth
    uutils-coreutils-noprefix
    hyprlock
    imagemagick
    awww
    base16-schemes
    hyprpicker
    rofimoji
    grim
    nwg-bar
    grimblast
    kdePackages.gwenview
    hyprshutdown
    vlc
    proton-vpn
    qalculate-qt
    impala
    ghostscript
    overskride
    loupe
    maple-mono.NL-TTF
    qpdfview
    qpdf
    exiftool
    python314Packages.curl-cffi
    kdePackages.isoimagewriter
    android-studio
    clang-tools
    clang
  ];
  programs.obs-studio.enable = true;
  programs.obs-studio.package = (
    pkgs.obs-studio.override {
      cudaSupport = true;
    }
  );
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
  home.file = {
    "Downloads".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/UserData/Downloads";
    "Documents".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/UserData/Documents";
    "Pictures".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/UserData/Pictures";
    "Videos".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/UserData/Videos";
    "Music".source = config.lib.file.mkOutOfStoreSymlink "/mnt/data/UserData/Music";
  };
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
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 0;
        };
      };

      display = {
        separator = " ⟩\t";
        constants = [
          "──────────────────────────────"
        ];
      };

      modules = [
        /*
          {
            type = "title";
            keyWidth = 10;
            key = "User";
          }
        */
        {
          type = "os";
          key = "  OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "  ├";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "  ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "  └";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "blue";
        }
        {
          type = "lm";
          key = "  ├󰧨";
          keyColor = "blue";
        }
        {
          type = "wmtheme";
          key = "  ├󰉼";
          keyColor = "blue";
        }
        {
          type = "icons";
          key = "  ├󰀻";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "  └";
          keyColor = "blue";
        }
        {
          type = "host";
          key = "  PC";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "  ├󰻠";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "  ├󰍛";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "  ├";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "  ├󰑭";
          keyColor = "green";
        }
        {
          type = "swap";
          key = "  ├󰓡";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = "  ├󰅐";
          keyColor = "green";
        }
        {
          type = "display";
          key = "  └󰍹";
          keyColor = "green";
        }
      ];
    };
  };
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
      "application/pdf" = "org.gnome.Papers.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
      "image/avif" = "org.gnome.Loupe.desktop";
      "image/heic" = "org.gnome.Loupe.desktop";
      "image/jxl" = "org.gnome.Loupe.desktop";

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
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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
  stylix.image = ./neon_shallows.jxl;
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
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [░▒▓](fg:white)[  ](bg:white fg:base00)[▶](bg:magenta fg:white)$directory[](fg:magenta bg:orange)$git_branch$git_status[](fg:orange)
        $character'';

      right_format = "$c $rust $python $cmd_duration $status $time";

      cmd_duration = {
        show_notifications = true;
      };

      directory = {
        style = "fg:base00 bg:magenta bold";
        format = "[ $path $read_only ]($style)";
        truncation_length = 8;
        truncation_symbol = "…/";
        read_only = "";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      python = {
        format = "[$symbol $version [$virtualenv](italic $style)]($style)";
        symbol = "";
      };

      git_branch = {
        symbol = "";
        style = "bg:orange fg:base00";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:orange fg:base00";
        format = "[$all_status$ahead_behind ]($style)";
      };

      rust = {
        symbol = "";
        format = "[ $symbol ($version) ](fg:#F74C00)";
      };

      c = {
        symbol = "";
        format = "[ $symbol ($name $version) ](fg:#6395CC)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        format = "[  $time ](fg:#a0a9cb)";
      };

      status = {
        disabled = false;
        failure_style = "fg:#ed8796";
        success_style = "fg:#a6da95";
        format = "[ $symbol $common_meaning$signal_name]($style) $maybe_int";
        success_symbol = "󰄭";
        symbol = "󰅖";
      };
    };
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      starship init fish | source
      fastfetch
    '';
    shellAliases = {
      "cat" = "bat -p";
      "man" = "batman";
    };
  };
  programs.ssh.matchBlocks."codeberg.org" = {
    identityFile = "~/.ssh/id_ed25519";
    user = "git";
  };

  programs.git = {
    enable = true;
    settings.user.name = "achillesgh";
    settings.user.email = "achillesgh@proton.me";

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEVvSiGN3cYS8/Lgfnrc+jjxkx4XeG5VKDQSf7zfXQxY achillesgh@proton.me"; # contents of your .pub file
      signByDefault = true;
    };
    settings = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };
  programs.quickshell = {
    enable = true;
  };
}
