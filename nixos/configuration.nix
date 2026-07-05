{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./fs.nix
    ./time.nix
    ./intel.nix
    ./security.nix
    ./network.nix
    ./audio.nix
    ./bluetooth.nix
    ./users.nix
    ./virtualization.nix
    ./mgmt.nix
    ./sandboxing.nix
  ];
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/home/confman/.config/sops/age/keys.txt";
    useTmpfs = true;
    secrets = {
      nextdns = { };
    };
  };

  nix.settings.substituters = lib.mkAfter [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  programs.ssh.startAgent = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.trusted-users = [ "confman" ];
  services.fwupd.enable = true;
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--autopower"
    ];
  };
  boot.kernelParams = [
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];
  boot.resumeDevice = "/dev/disk/by-label/swap";
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
      options = [
        "nofail"
        "discard"
      ];
      encrypted = {
        enable = true;
        label = "swap";
        blkDev = "/dev/disk/by-label/luks_swap";
      };
    }
  ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.timeout = 0;
  nixpkgs.config.allowUnfree = true;

  systemd.oomd.enable = true;
  # Set your time zone.

  programs.fish.enable = true;

  services.flatpak.enable = true;
  programs.steam.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      prettybat
    ];

  };
  # programs.hyprland.enable = true;
  # programs.hyprland.withUWSM = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    sbctl
    git
    nixfmt
    usbutils
    tzdata
    packet
    android-tools
    parted
    stylua
    vulnix
    gpg-tui
    (ffmpeg-full.override {
      withUnfree = true;
    })
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
  };

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  services.upower.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.allowed-users = [
    "confman"
    "@wheel"
  ];
  system.stateVersion = "26.11"; # Did you read the comment?
  programs.labwc.enable = true;

  services.syncthing = {
    enable = true;
    user = "achilles";
    dataDir = "/home/achilles/Backups/GrapheneOS";
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };
  systemd.services.syncthing.unitConfig = {
    after = [ "graphical.target" ];
    wantedBy = lib.mkForce [ ];
  };
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Adwaita Sans" ];
      serif = [ "Roboto Serif" ];
      monospace = [ "Maple Mono" ];
    };
    antialias = true;
    hinting.style = "slight";
    hinting.enable = true;
    subpixel.rgba = "rgb";
    subpixel.lcdfilter = "default";

    localConf = ''
      <?xml version="1.0"?>
              <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
              <fontconfig>
                <alias><family>-apple-system</family><prefer><family>Adwaita Sans</family></prefer></alias>
                <alias><family>Segoe UI</family><prefer><family>Adwaita Sans</family></prefer></alias>
                <alias><family>Georgia</family><prefer><family>Gelasio</family></prefer></alias>
                <alias><family>Latin Modern Roman</family><prefer><family>LMRoman10</family></prefer></alias>
                <alias><family>Arial</family><prefer><family>Arimo</family></prefer></alias>
                <alias><family>Calibri</family><prefer><family>Carlito</family></prefer></alias>
                <alias><family>Verdana</family><prefer><family>Bitstream Vera Sans</family></prefer></alias>
                <alias><family>SFMono-Regular</family><prefer><family>SF Mono</family></prefer></alias>
      	  <match target="font">
                    <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
                </match>
              </fontconfig>
    '';
  };

  fonts.packages = with pkgs; [
    # Adobe
    source-code-pro
    source-sans
    source-serif
    # General
    dejavu_fonts
    freefont_ttf
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    hack-font
    ibm-plex
    jetbrains-mono

    # OTF/TeX
    lmodern
    gyre-fonts

    # TTF
    ttf_bitstream_vera
    caladea
    carlito
    libertine

    # Nerd fonts (nixpkgs 25.05+)
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    # Adwaita (usually pulled in by GTK, but explicit)
    adwaita-fonts
    maple-mono.variable
  ];
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

  programs.dconf.enable = true;

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      INTEL_GPU_POWER_PROFILE_ON_AC = "base";
      INTEL_GPU_POWER_PROFILE_ON_BAT = "power_saving";

      INTEL_GPU_MIN_FREQ_ON_AC = 300;
      INTEL_GPU_MAX_FREQ_ON_AC = 1300;

      INTEL_GPU_MIN_FREQ_ON_BAT = 300;
      INTEL_GPU_MAX_FREQ_ON_BAT = 600;

    };
  };
  console.earlySetup = true;

  services.kmscon = {
    enable = true;
    config = {
      font-size = 16;
      hwaccel = true;
      font-name = "Maple Mono";
    };
    extraOptions = "--term xterm-256color";
  };
}
