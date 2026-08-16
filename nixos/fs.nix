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

  fileSystems."/boot".options = [
    "noexec"
    "nosuid"
    "nodev"
  ];

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
