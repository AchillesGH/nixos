{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      starship init fish | source
      fastfetch
    '';
    shellAliases = {
      "cat" = "bat -p";
      "man" = "batman";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [░▒▓](fg:white)[  ](bg:white fg:base00)[▶](bg:magenta fg:white)$directory[](fg:magenta bg:orange)$git_branch$git_status[](fg:orange)
        $character'';

      right_format = "$c $rust $python $cmd_duration $status $time";

      cmd_duration = {
        show_notifications = true;
      };

      directory = {
        style = "fg:base00 bg:magenta bold";
        format = "[ $path $read_only ]($style)";
        truncation_length = 8;
        truncation_symbol = "…/";
        read_only = "";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      python = {
        format = "[$symbol $version [$virtualenv](italic $style)]($style)";
        symbol = "";
      };

      git_branch = {
        symbol = "";
        style = "bg:orange fg:base00";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:orange fg:base00";
        format = "[$all_status$ahead_behind ]($style)";
      };

      rust = {
        symbol = "";
        format = "[ $symbol ($version) ](fg:#F74C00)";
      };

      c = {
        symbol = "";
        format = "[ $symbol ($name $version) ](fg:#6395CC)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        format = "[  $time ](fg:#a0a9cb)";
      };

      status = {
        disabled = false;
        failure_style = "fg:#ed8796";
        success_style = "fg:#a6da95";
        format = "[ $symbol $common_meaning$signal_name]($style) $maybe_int";
        success_symbol = "󰄭";
        symbol = "󰅖";
      };
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 0;
        };
      };

      display = {
        separator = " ⟩\t";
        constants = [
          "──────────────────────────────"
        ];
      };

      modules = [
        /*
          {
            type = "title";
            keyWidth = 10;
            key = "User";
          }
        */
        {
          type = "os";
          key = "  OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "  ├";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "  ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "  └";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "blue";
        }
        {
          type = "lm";
          key = "  ├󰧨";
          keyColor = "blue";
        }
        {
          type = "wmtheme";
          key = "  ├󰉼";
          keyColor = "blue";
        }
        {
          type = "icons";
          key = "  ├󰀻";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "  └";
          keyColor = "blue";
        }
        {
          type = "host";
          key = "  PC";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "  ├󰻠";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "  ├󰍛";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "  ├";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "  ├󰑭";
          keyColor = "green";
        }
        {
          type = "swap";
          key = "  ├󰓡";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = "  ├󰅐";
          keyColor = "green";
        }
        {
          type = "display";
          key = "  └󰍹";
          keyColor = "green";
        }
      ];
    };
  };
}
