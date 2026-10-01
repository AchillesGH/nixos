{
  config,
  pkgs,
  ...
}: {
  stylix.targets.rofi.enable = false;
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-power-menu
      rofi-calc
    ];

    theme = ./theme.rasi;
    settings = {
      cycle = true;
      modes = "drun,window";
      fixed-num-lines = false;
      show-icons = true;
      terminal = "kitty";
      run-command = "uwsm app -- {cmd}";
      run-shell-command = "uwsm app -- {terminal} -1e sh -c {cmd}";
      drun-url-launcher = "xdg-open";
      disable-history = false;
      case-sensitive = false;
      sidebar-mode = true;
      matching = "normal";
      sort = true;
      sorting-method = "fzf";
      scroll-method = 1;
      window-format = "{w} {c} : {t}";
      display-drun = " 󰣆  Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      display-filebrowser = "   Files";
      display-calc = " 󰪚  Calc";
      steal-focus = true;
    };
  };
}
