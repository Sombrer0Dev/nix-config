{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # imports = [ inputs.niri.homeModules.config ];
  home.packages = with pkgs; [
    xwayland-satellite # xwayland support
  ];
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #     xdg-desktop-portal-gnome
  #   ];
  #   config = {
  #     common = {
  #       default = [ "gtk" ];
  #     };
  #     niri = {
  #       default = [
  #         "gtk"
  #         "gnome"
  #       ];
  #       "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
  #       # "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
  #     };
  #   };
  # };
  # home.sessionVariables = {
  #   XDG_CURRENT_DESKTOP = "niri";
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_SESSION_DESKTOP = "niri";
  # };
  programs.niri = {
    # enable = true;
    settings = {
      input = {
        focus-follows-mouse.enable = true;
        keyboard.xkb.layout = "us, ru";
        keyboard.xkb.options = "grp:win_space_toggle";
        keyboard.repeat-delay = 200;
        keyboard.repeat-rate = 35;
        workspace-auto-back-and-forth = true;
      };
      binds = {
        "Mod+A".action.spawn-sh =
          "niri msg action focus-column-right && niri msg action move-column-left && niri msg action focus-window-previous";

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
        "Mod+B" = {
          repeat = false;
          action.expand-column-to-available-width = [ ];
        };
        "Mod+P" = {
          action.center-column = [ ];
        };
        "Mod+Shift+P" = {
          action.center-visible-columns = [ ];
        };

        "Mod+S" = {
          action.focus-workspace = "scratch";
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
        "Mod+Left".action.focus-column-or-monitor-left = [ ];
        "Mod+Right".action.focus-column-or-monitor-right = [ ];
        "Mod+Up".action.focus-window-or-workspace-up = [ ];
        "Mod+Down".action.focus-window-or-workspace-down = [ ];
        "Mod+H".action.focus-column-or-monitor-left = [ ];
        "Mod+L".action.focus-column-or-monitor-right = [ ];
        "Mod+K".action.focus-window-or-workspace-up = [ ];
        "Mod+J".action.focus-window-or-workspace-down = [ ];

        "Mod+Ctrl+K".action.set-column-width = "-10%";
        "Mod+Ctrl+J".action.set-column-width = "+10%";
        "Mod+Ctrl+Shift+K".action.set-window-height = "-10%";
        "Mod+Ctrl+Shift+J".action.set-window-height = "+10%";

        "Mod+Shift+Left".action.move-column-left-or-to-monitor-left = [ ];
        "Mod+Shift+Right".action.move-column-right-or-to-monitor-right = [ ];
        "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = [ ];
        "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = [ ];
        "Mod+Shift+H".action.move-column-left-or-to-monitor-left = [ ];
        "Mod+Shift+L".action.move-column-right-or-to-monitor-right = [ ];
        "Mod+Shift+K".action.move-window-up-or-to-workspace-up = [ ];
        "Mod+Shift+J".action.move-window-down-or-to-workspace-down = [ ];

        # Mouse bindings
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = [ ];
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = [ ];
        };
        "Mod+Shift+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-column-right = [ ];
        };
        "Mod+Shift+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-column-left = [ ];
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
