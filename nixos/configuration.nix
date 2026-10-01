{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./fs.nix
    ./time.nix
    ./intel.nix
    ./nvidia.nix
    ./power.nix
    ./security.nix
    ./network.nix
    ./audio.nix
    ./bluetooth.nix
    ./virtualization.nix
    ./mgmt.nix
    ./fonts.nix
    ./users.nix
    ./greetd.nix
  ];

  documentation.dev.enable = true;

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    useTmpfs = true;
    secrets = {
      nextdns = {};
      nextdns_stamp = {};
      main_user_pwd_hash = {};
    };
  };

  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      trusted-users = ["confman"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [
        "confman"
        "@wheel"
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  systemd.oomd.enable = true;
  services.fwupd.enable = true;
  services.kmscon.enable = true;
  services.scx.enable = true;

  programs.bat.enable = true;
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.dconf.enable = true;
  programs.nh.enable = true;
  programs.fuse.enable = true; # for xdg-desktop-porta-gtk
  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    sbctl
    git
    alejandra
    usbutils
    tzdata
    packet
    android-tools
    parted
    stylua
    google-authenticator
    gpg-tui
    ffmpeg-full
    age
    man-pages
    man-pages-posix
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 90;
  };

  system.stateVersion = "26.11";

  console.earlySetup = true;
  services.kmscon = {
    config = {
      font-size = 16;
      hwaccel = true;
      font-name = "Maple Mono";
    };
    extraOptions = "--term xterm-256color";
  };
  services.scx = {
    scheduler = "scx_bpfland";
  };

  programs.bat.extraPackages = with pkgs.bat-extras; [
    batdiff
    batman
    prettybat
  ];
  programs.nh = {
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/confman/system";
  };
}
