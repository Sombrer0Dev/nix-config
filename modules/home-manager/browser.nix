{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    sessionVariables.BROWSER = "firefox";
  };

  xdg.desktopEntries."gnome-control-center" = lib.mkIf pkgs.stdenv.isLinux {
    name = "GNOME Control Center";
    comment = "GNOME control center";
    icon = "gnome";
    exec = "gnome-control-center";
  };

  programs.chromium = {
    enable = true;
  };
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      name = "Default";
      settings = {
        "browser.tabs.loadInBackground" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };
    };
  };
}
