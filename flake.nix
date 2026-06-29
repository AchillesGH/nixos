{
  description = "Nix flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      stylix,
      lanzaboote,
      nix-cachyos-kernel,
      zen-browser,
      sops-nix,
      nixpak,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkNixPak = nixpak.lib.nixpak {
        inherit (pkgs) lib;
        inherit pkgs;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {

        inherit system;
        specialArgs = { inherit inputs mkNixPak; };
        modules = [

          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [
                nix-cachyos-kernel.overlays.pinned
              ];
              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
            }
          )
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs mkNixPak; };
            home-manager.sharedModules = [ ];
            home-manager.users.achilles = ./hm;
            home-manager.users.confman = ./manager;
          }
          ./nixos/configuration.nix

        ];
      };
    };

}
