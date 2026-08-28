{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-bin.override {
    cfg = {
      speechSynthesisSupport = false;
      pipewireSupport = true;
    };
  };

  programs.firefox.policies = {
  };
}
