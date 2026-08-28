{config, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        ControllerMode = "bredr";
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
