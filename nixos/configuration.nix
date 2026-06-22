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
  ];
  programs.ssh.startAgent = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.trusted-users = [ "confman" ];
  services.fwupd.enable = true;
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
  boot.kernelParams = [
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/f17b357d-ed1d-4ccd-b0b4-430b30280cee";
      randomEncryption.enable = true;
      randomEncryption.allowDiscards = true;
      options = [ "discard" ];
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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.flatpak.enable = true;
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
  programs.fish.enable = true;

  programs.steam.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      prettybat
    ];

  };
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.firefox.enable = true;
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
    packet
    android-tools
    parted
    stylua
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
  };

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
    dataDir = "/home/achilles/Backups/Phone";
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };

  fonts.packages = with pkgs; [
    # Adobe
    source-code-pro
    source-sans
    source-serif
    # General
    cantarell-fonts
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
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    # Adwaita (usually pulled in by GTK, but explicit)
    adwaita-fonts
  ];
  services.xserver.displayManager.startx.enable = true;
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    greeterManagesPlymouth = true;

    settings = rec {
      default_session.command =
        with pkgs;
        "${lib.getExe tuigreet} --time --user-menu --remember --remember-session";
    };
  };
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

}
