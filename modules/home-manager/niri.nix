{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.homeModules.niri ];
  home.packages = with pkgs; [
    xwayland-satellite # xwayland support
  ];
  programs.niri = {
    enable = true;
    settings = {
      input = {
        focus-follows-mouse.enable = true;
        keyboard.xkb.layout = "us, ru";
        keyboard.xkb.options = "grp:win_space_toggle";
        keyboard.repeat-delay = 200;
        keyboard.repeat-rate = 35;
      };
      binds = {
        "Mod+Return".action.spawn = "kitty";
        "Mod+Tab".action.spawn-sh = "noctalia-shell ipc call launcher toggle";
        "Mod+Q" = {
          repeat = false;
          action.close-window = [ ];
        };
        "Mod+W" = {
          repeat = false;
          action.toggle-window-floating = [ ];
        };
        "Mod+Shift+W" = {
          repeat = false;
          action.switch-preset-window-height = [ ];
        };
        "Mod+F" = {
          repeat = false;
          action.maximize-column = [ ];
        };
        "Mod+Shift+F" = {
          repeat = false;
          action.fullscreen-window = [ ];
        };
        "Mod+Ctrl+F" = {
          repeat = false;
          action.expand-column-to-available-width = [ ];
        };
        "Mod+P" = {
          action.center-column = [ ];
        };
        "Mod+Shift+P" = {
          action.center-visible-columns = [ ];
        };

        "Mod+Shift+S" = {
          repeat = false;
          action.screenshot = {
          };
        };

        "Mod+T" = {
          repeat = false;
          action.toggle-overview = {
          };
        };
        # Window Management
        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+H".action.focus-column-left = [ ];
        "Mod+L".action.focus-column-right = [ ];
        "Mod+K".action.focus-window-up = [ ];
        "Mod+J".action.focus-window-down = [ ];

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Plus".action.set-column-width = "+10%";

        "Mod+Shift+Left".action.move-column-left = [ ];
        "Mod+Shift+Right".action.move-column-right = [ ];
        "Mod+Shift+Up".action.move-window-up = [ ];
        "Mod+Shift+Down".action.move-window-down = [ ];
        "Mod+Shift+H".action.move-column-left = [ ];
        "Mod+Shift+L".action.move-column-right = [ ];
        "Mod+Shift+K".action.move-window-up = [ ];
        "Mod+Shift+J".action.move-window-down = [ ];

        # Mouse bindings
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = [ ];
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = [ ];
        };
      };
      spawn-at-startup = [
        { argv = [ "noctalia-shell" ]; }
      ];
      layout = {
        background-color = "transparent";
        focus-ring = {
          width = 1.5;
          active.gradient = {
            from = "#fffefe";
            to = "#6b6c71";
          };
        };
      };
      window-rules = [
        {
          matches = [
            {
              app-id = "steam";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "org.gnome.Nautilu";
            }
          ];
          open-floating = true;
          opacity = 0.95;
        }
        {
          matches = [
            {
              app-id = "steam";
              title = ''r#"^notificationtoasts_\d+_desktop$"#'';
            }
          ];
          default-floating-position = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        }
        {
          geometry-corner-radius = {
            bottom-left = 20.0;
            bottom-right = 20.0;
            top-left = 20.0;
            top-right = 20.0;
          };
          clip-to-geometry = true;
        }
      ];
      layer-rules = [
        {
          matches = [
            {
              namespace = "^noctalia-overview";
            }
          ];
          place-within-backdrop = true;
        }
      ];
      debug = {
        honor-xdg-activation-with-invalid-serial = [ ];
      };
    };
  };
}
