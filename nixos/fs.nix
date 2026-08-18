{ config, pkgs, ... }:
let
  standardOpts = [
    "rw"
    "space_cache=v2"
    "noatime"
    "nofail"
    "ssd"
    "discard=async"
  ];
  dbMountOptions = [
    "ro"
    "x-gvfs-hide"
    # Resolves symlinks as if they were real files
    # Needed for things like OnlyOffice
    "resolve-symlinks"
  ];

in
{
  environment.etc."crypttab" = {
    text = ''
      data /dev/disk/by-uuid/df4a89ec-9765-415e-8986-5e559b1f4f49 /root/data.key noauto,tpm2-device=auto,discard
    '';
  };
  fileSystems."/home".options = [
    "compress=zstd:3"
  ];
  fileSystems."/nix".options = [
    "compress=zstd:1"
  ]
  ++ standardOpts;

  fileSystems."/mnt/data" = {
    device = "/dev/mapper/data";
    fsType = "btrfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "nosuid"
      "nodev"
      "compress=zstd:2"
    ]
    ++ standardOpts;
  };

  fileSystems."/home/achilles/Downloads" = {
    device = "/mnt/data/UserData/Downloads";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/achilles/Documents" = {
    device = "/mnt/data/UserData/Documents";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/achilles/Pictures" = {
    device = "/mnt/data/UserData/Pictures";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/achilles/Videos" = {
    device = "/mnt/data/UserData/Videos";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/achilles/Music" = {
    device = "/mnt/data/UserData/Music";
    fsType = "none";
    options = [ "bind" ];
  };

  systemd.tmpfiles.rules = [
    "d /home/shared 0770 achilles sharedfiles - -"
    "d /mnt/data 0700 achilles users"
  ];

  fileSystems."/boot".options = [
    "noexec"
    "nosuid"
    "nodev"
  ];

  # Fix/workaround for distrobox access to host themes from wiki
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems."/usr/share/fonts" = {
    device = "/run/current-system/sw/share/X11/fonts";
    fsType = "fuse.bindfs";
    options = dbMountOptions;
  };

  # Icons
  fileSystems."/usr/share/icons" = {
    device = "/run/current-system/sw/share/icons";
    fsType = "fuse.bindfs";
    options = dbMountOptions;

  };

  # Themes
  fileSystems."/usr/share/themes" = {
    device = "/run/current-system/sw/share/themes";
    fsType = "fuse.bindfs";
    options = dbMountOptions;
  };

  boot.resumeDevice = "/dev/disk/by-label/swap";
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
      options = [
        "nofail"
      ];
      encrypted = {
        enable = true;
        label = "swap";
        blkDev = "/dev/disk/by-label/luks_swap";
      };
    }
  ];

}
