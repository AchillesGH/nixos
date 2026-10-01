# This contains configurations that don't affect programs directly.
{config, ...}: let
  defaultApps = {
    imv = "org.gnome.Loupe.desktop";
    browser = "zen-twilight.desktop";
    fileMan = "nemo.desktop";
    pdfReader = "chromium-desktop.desktop"; # for sandboxing
  };
in {
  xdg.enable = true;
  xdg.localBinInPath = true;
  xdg.configFile."mimeapps.list".force = true;

  xdg.autostart = {
    enable = true;
    readOnly = true;
  };

  xdg.userDirs.setSessionVariables = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.extraConfig.SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [defaultApps.fileMan];
      "application/x-gnome-saved-search" = [defaultApps.fileMan];
      "text/html" = [defaultApps.browser];
      "application/pdf" = ["chromium-browser.desktop"];
      "x-scheme-handler/http" = [defaultApps.browser];
      "x-scheme-handler/https" = [defaultApps.browser];
      "x-scheme-handler/about" = [defaultApps.browser];
      "x-scheme-handler/unknown" = [defaultApps.browser];
      "image/jpeg" = [defaultApps.imv];
      "image/png" = [defaultApps.imv];
      "image/gif" = [defaultApps.imv];
      "image/webp" = [defaultApps.imv];
      "image/tiff" = [defaultApps.imv];
      "image/bmp" = [defaultApps.imv];
      "image/svg+xml" = [defaultApps.imv];
      "image/avif" = [defaultApps.imv];
      "image/heic" = [defaultApps.imv];
      "image/jxl" = [defaultApps.imv];
    };
  };
}
