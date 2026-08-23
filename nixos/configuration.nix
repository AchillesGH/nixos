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
  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    useTmpfs = true;
    secrets = {
      nextdns = { };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  nix.package = pkgs.lixPackageSets.stable.lix;
  nixpkgs.config.allowUnfree = true;

  nix.settings.trusted-users = [ "confman" ];

  systemd.oomd.enable = true;
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  services.fwupd.enable = true;
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--autopower"
    ];
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
    google-authenticator
    gpg-tui
    (ffmpeg-full.override {
      withUnfree = true;
    })
  ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 40;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.allowed-users = [
    "confman"
    "@wheel"
  ];
  system.stateVersion = "26.11";

  /*
    services.syncthing = {
      enable = true;
      user = "achilles";
      dataDir = "/home/achilles/Backups/GrapheneOS";
      openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    };
  */
  systemd.services.syncthing.unitConfig = {
    after = [ "graphical.target" ];
    wantedBy = lib.mkForce [ ];
  };

  programs.dconf.enable = true;
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

  programs.fuse.enable = true; # for xdg-desktop-porta-gtk

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  programs.ssh.startAgent = true;
}
