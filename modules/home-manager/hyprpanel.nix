{
  ...
}:
{
  programs.hyprpanel = {
    enable = true;

    settings = {

      theme = {
        font = {
          size = "1.1rem";
        };
        bar = {
          transparent = true;
          floating = true;
          buttons = {
            enableBorders = false;
            borderSize = "0.1em";
            y_margins = "-0.1em";
            radius = "0.7em";
            dashboard = {
              enableBorder = false;
            };
            workspaces = {
              enableBorder = false;
              smartHighlight = true;
              # active = "#b4befe";
              # occupied = "#62a0ea";
              # hover = "#62a0ea";
            };
            windowtitle = {
              enableBorder = false;
            };
            systray = {
              enableBorder = false;
            };
            modules = {
              kbLayout = {
                enableBorder = false;
              };
              netstat = {
                enableBorder = false;
              };
            };
            monochrome = true;
            spacing = "0.50em";
            padding_y = "0.2rem";
            padding_x = "0.7rem";
            opacity = 100;
          };
          outer_spacing = "1em";
          layer = "top";
          margin_top = "0.5em";
          border_radius = "0.4em";
          margin_sides = "0.5em";
          margin_bottom = "0.5em";
          border = {
            location = "none";
          };
          enableShadow = false;
          menus = {
            monochrome = true;
            border = {
              radius = "0.7em";
            };
            menu = {
              power = {
                scaling = 100;
              };
              dashboard = {
                profile = {
                  radius = "3em";
                };
              };
            };
            card_radius = "0.4em";
          };
          opacity = 50;
        };
        osd = {
          duration = 2500;
          orientation = "horizontal";
          location = "top right";
          margins = "50px 50px 50px 50px";
          muted_zero = true;
          radius = "0.6em";
        };
        matugen = true;
        matugen_settings = {
          variation = "standard_1";
          scheme_type = "monochrome";
          mode = "dark";
        };

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
              "windowtitle"
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

      terminal = "kitty";
    };
  };
}
