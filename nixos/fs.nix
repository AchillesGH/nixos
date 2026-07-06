{ config, pkgs, ... }:
{
  environment.etc."crypttab" = {
    text = ''
      data /dev/disk/by-uuid/df4a89ec-9765-415e-8986-5e559b1f4f49 /root/data.key noauto
    '';
  };
  fileSystems."/mnt/data" = {
    device = "/dev/mapper/data";
    fsType = "btrfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "nosuid"
      "nodev"
      "relatime"
      "compress=zstd" # transparent compression
      "space_cache=v2" # faster free space lookup
      "noatime" # better than relatime for btrfs
      "nofail"
    ];
  };
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

}
