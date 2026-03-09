{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "default";
        position = "right";
        outerCorners = true;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
              enableColorization = true;
            }
            {
              id = "NotificationHistory";
            }
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          center = [
            {
              id = "Clock";
            }
          ];
          right = [
            {
              id = "MediaMini";
            }
            {
              id = "KeyboardLayout";
              showIcon = false;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Volume";
            }
            {
              id = "Tray";
            }
            {
              id = "SessionMenu";
            }
          ];
        };
      };
      colorSchemes = {
        useWallpaperColors = true;
        darkMode = true;
        generationMethod = "Monochrome";
      };
      dock = {
        enabled = false;
      };
      wallpaper = {
        enabled = true;
        directory = "/home/arsokolov/Documents/walls";
        viewMode = "recursive";
        enableOverviewWallpaper = true;
      };
      general = {
        telemetryEnabled = false;
        # avatarImage = "/home/drfoobar/.face";
        # radiusRatio = 0.2;
      };
      location = {
        name = "Moscow, Russia";
      };
      plugins = {
        autoUpdate = false;
      };
    };
  };
}
