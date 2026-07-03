{ config, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
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
