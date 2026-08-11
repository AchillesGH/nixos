{ pkgs, ... }:

let
  sysrbs = pkgs.writeShellApplication {
    name = "sysrbs-cmd";
    runtimeInputs = [ pkgs.nixos-rebuild ];
    text = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake /home/achilles/nixos#nixos";
  };

  sysrbb = pkgs.writeShellApplication {
    name = "sysrbb-cmd";
    runtimeInputs = [ pkgs.nixos-rebuild ];
    text = "${pkgs.nixos-rebuild}/bin/nixos-rebuild boot --flake /home/achilles/nixos#nixos";
  };

in
{
  environment.systemPackages = [
    sysrbs
    sysrbb
  ];
}
