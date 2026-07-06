{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "modesetting" ];
  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.enable_psr=0"
  ];
  # boot.initrd.kernelModules = [ "xe" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
  };

}
