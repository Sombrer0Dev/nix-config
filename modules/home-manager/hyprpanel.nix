{
  ...
}:
{
  programs.hyprpanel = {
    enable = true;

    settings = {

      theme = {
        matugen_settings = {
          variation = "standard_1";
          mode = "dark";
          scheme_type = "monochrome";
        };
        matugen = true;
      };

      tear = true;

      menus = {
        clock = {
          weather = {
            location = "Moscow";
            unit = "metric";
            enabled = false;
          };
          time = {
            military = true;
            hideSeconds = true;
          };
        };
      };

      bar = {
        layouts = {
          "*" = {
            left = [
              "dashboard"
              "workspaces"
            ];
            middle = [ "media" ];
            right = [
              "volume"
              "kbinput"
              "bluetooth"
              "systray"
              "clock"
              "notifications"
            ];
          };
        };
        clock = {
          format = "%a %b %d  %H:%M:%S";
        };
        notifications = {
          show_total = true;
        };
        customModules = {
          kbLayout = {
            label = true;
            labelType = "code";
          };
        };
        bluetooth = {
          label = false;
        };
        workspaces = {
          monitorSpecific = true;
        };
        launcher = {
          icon = "{ø}";
          autoDetectIcon = false;
        };
      };

      theme = {
        font = {
          size = "1.1rem";
        };
        bar = {
          buttons = {
            enableBorders = true;
            dashboard = {
              enableBorder = true;
            };
            background_opacity = 100;
            opacity = 100;
          };
          border = {
            location = "none";
          };
          enableShadow = false;
          menus = {
            enableShadow = false;
            opacity = 100;
          };
          transparent = false;
          opacity = 50;
        };
      };

      terminal = "kitty";
    };
  };
}
