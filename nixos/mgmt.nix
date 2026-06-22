{ pkgs, ... }:

let
  sysrbs = pkgs.writeShellApplication {
    name = "sysrbs-cmd";
    runtimeInputs = [ pkgs.nixos-rebuild ];
    text = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake /home/confman/system#nixos";
  };

  sysrbb = pkgs.writeShellApplication {
    name = "sysrbb-cmd";
    runtimeInputs = [ pkgs.nixos-rebuild ];
    text = "${pkgs.nixos-rebuild}/bin/nixos-rebuild boot --flake /home/confman/system#nixos";
  };

in
{
  environment.systemPackages = [
    sysrbs
    sysrbb
  ];
}
