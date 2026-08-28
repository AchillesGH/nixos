{...}: {
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    # Using non-free driver since disabling GSP firmware on open-source
    # drivers has no effect.
    open = false;
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Disable GSP since with GSP firwmare on, RTD3 does not work on
    # Turing cards.
    gsp.enable = false;

    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}
