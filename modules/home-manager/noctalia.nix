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
        position = "top";
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
              id = "plugin:privacy-indicator";
              hideInactive = true;
            }
          ];
          center = [
            {
              id = "Clock";
            }
            {
              id = "Spacer";
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
              id = "VPN";
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
        generationMethod = "monochrome";
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
        avatarImage = "/home/arsokolov/.face";
      };
      location = {
        name = "Moscow, Russia";
        firstDayOfWeek = 1;
      };
      plugins = {
        autoUpdate = true;
      };
      idle = {
        enabled = true;
        screenOffTimeout = 1200;
        lockTimeout = 1260;
        suspendTimeout = 1800;
        fadeDuration = 5;
      };
      desktopWidgets = {
        enabled = true;
        overviewEnabled = true;
        gridSnap = true;
        monitorWidgets = [
          {
            name = "DP-1";
            widgets = [
              {
                id = "MediaPlayer";
                hideMode = "visible";
                roundedCorners = true;
                showAlbumArt = true;
                showBackground = true;
                showButtons = true;
                showVisualizer = true;
                visualizerType = "wave";
                # x = 16;
                # y = 52;
              }
              {
                id = "Weather";
                roundedCorners = true;
                showBackground = true;
                # x = 10;
                # y = 159;
              }
            ];
          }
        ];
      };
    };
  };
}
