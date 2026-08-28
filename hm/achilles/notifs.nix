{pkgs, ...}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 400;
        height = 400;
        origin = "top-center";
        offset = "10x20";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = true;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 1;
        sort = true;
        # font = "FiraCode 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;
        /*
        icon_path =
        let
          gnome = "${pkgs.gnome-icon-theme}/share/icons/gnome";
          papirus = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
        in
        "${gnome}/16x16/status/:${gnome}/16x16/devices/"
        + ":${papirus}/48x48/actions/:${papirus}/48x48/apps/"
        + ":${papirus}/48x48/devices/:${papirus}/48x48/emblems/"
        + ":${papirus}/48x48/emotes/:${papirus}/48x48/mimetypes/"
        + ":${papirus}/48x48/places/:${papirus}/48x48/status/";
        */
        sticky_history = true;
        history_length = 20;
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 8;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
        # separator_color = "#9f8c8c";
        frame_color = "#ffb3b6";
        highlight = "#ffb3b6";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        timeout = 3;
        #background = "#1a1111";
        # foreground = "#f0dede";
        #highlight = "#723338";
        default_icon = "dialog-information";
      };

      urgency_normal = {
        timeout = 6;
        #background = "#1a1111";
        #foreground = "#f0dede";
        #highlight = "#723338";
        default_icon = "dialog-information";
      };

      urgency_critical = {
        timeout = 0;
        #background = "#ffb4ab";
        #foreground = "#690005";
        # highlight = "#ffb4ab";
        default_icon = "dialog-error";
      };
    };
  };

  # Ensure icon theme packages are present in the user environment
  home.packages = with pkgs; [
    papirus-icon-theme
  ];
}
