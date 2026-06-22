{ config, pkgs, ... }:

{
  home.username = "confman";
  home.homeDirectory = "/home/confman";
  home.stateVersion = "26.11";
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "achillesgh";
      user.email = "achillesgh@proton.me";
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFusnqYKJXGm7nIG7iyIOW/zSjUbH7y8lsVHB4DOv8qT achillesgh@proton.me";
      signByDefault = true;
    };
    settings = {
      gpg = {
        format = "ssh";
      };
    };
  };
}
