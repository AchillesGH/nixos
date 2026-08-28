{pkgs, ...}: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=zstd" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.timeout = 0;

  # Temporary patch for error (graceful, non-blocking) during boot
  # until I figure out what triggered it.
  # Context for future: Happend after update, possible causes might
  # be lanzaboote update measured boot, still unlikely. Systemd version
  # did NOT change across the update. LUKS tpm-backed unlocking still
  # works flawlessly.
  systemd.services."systemd-pcrlogin@".enable = false;
  systemd.services."systemd-pcrlogin@1002".enable = false;
}
