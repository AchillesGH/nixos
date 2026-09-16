{
  pkgs,
  lib,
  ...
}: {
  home.username = "confman";
  home.homeDirectory = "/home/confman";
  home.stateVersion = "26.11";

  imports = [../shared/helix];

  programs.helix = {
    settings.theme = "onedark_transparent";
    themes = {
      onedark_transparent = {
        "inherits" = "onedark";
        "ui.background" = {};
      };
    };
    languages. language-server = {
      nixd = {
        command = "${lib.getExe pkgs.nixd}";
        args = ["--semantic-tokens=true"];
        config.nixd = let
          nixosConfiguration = "nixos";
          flakeRef = "(builtins.getFlake (toString /home/confman/system/.))";
          nixosOpts = "${flakeRef}.nixosConfigurations.${nixosConfiguration}.options";
        in {
          nixpkgs.expr = "${flakeRef}.inputs.nixpkgs";
          options = {
            nixos.expr = nixosOpts;
            home-manager.expr = "${nixosOpts}.home-manager.users.type.getSubOptions []";
          };
        };
      };
    };
  };

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
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFusnqYKJXGm7nIG7iyIOW/zSjUbH7y8lsVHB4DOv8qT achillesgh@proton.me";
      signByDefault = true;
    };
    settings = {
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "Nord";
    };
  };
}
