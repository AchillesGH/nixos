{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-bin;
  programs.firefox.policies = {
  };
}
