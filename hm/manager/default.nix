{ config, pkgs, ... }:

{
  home.username = "confman";
  home.homeDirectory = "/home/confman";
  home.stateVersion = "26.11";
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings."*" = {
      AddKeysToAgent = "yes";
      Compression = "no";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
      ForwardAgent = "no";
      HashKnownHosts = "no";
      ServerAliveCountMax = 3;
      ServerAliveInterval = 0;
      UserKnownHostsFile = "~/.ssh/known_hosts";
    };

  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "achillesgh";
      user.email = "achillesgh@proton.me";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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
