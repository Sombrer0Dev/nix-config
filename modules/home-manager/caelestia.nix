{ inputs, ... }:
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ ];
    };
    settings = {
      general = {
        terminal = [ "kitty" ];
      };
      bar = {
        workspace = {
          activeIndicator = false;
          perMonitorWorkspaces = true;
          showWindows = false;
        };
        status = {
          showBattery = false;
          showKbLayout = true;
          showMicrophone = true;
        };
      };
      paths.wallpaperDir = "~/Documents/favourite_walls/a_close_up_of_a_flower_02.jpg";
      border = {
        rounding = 25;
        thickness = 10;
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
