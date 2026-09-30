{ inputs, pkgs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        telemetry_enabled = false;
        avatar_path = "/home/arsokolov/.face";
      };

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-monochrome";
      };

      backdrop = {
        enabled = true;
      };

      notification = {
        enable_daemon = true;
      };

      osd = {
        kinds = {
          keyboard_layout = false;
        };
      };

      dock = {
        enabled = false;
      };

      wallpaper = {
        enabled = true;
        directory = "/home/arsokolov/Documents/walls";
      };

      location = {
        auto_locate = false;
        address = "Moscow, Russia";
      };

      idle = {
        pre_action_fade_seconds = 5.0;
        behavior = {
          "screen-off" = {
            timeout = 1200;
            action = "screen_off";
            enabled = true;
          };
          lock = {
            timeout = 1260;
            action = "lock";
            enabled = true;
          };
          suspend = {
            timeout = 1800;
            action = "suspend";
            enabled = true;
          };
        };
      };

      desktop_widgets = {
        enabled = true;
      };

      bar.main = {
        position = "top";
        font_scale = 1.1;
        capsule = true;
        start = [
          "control-center"
          "notifications"
          "workspaces"
        ];
        center = [
          "clock"
        ];
        end = [
          "media"
          "keyboard_layout"
          "network"
          "bluetooth"
          "volume"
          "tray"
          "session"
        ];
      };

      widget = {
        keyboard_layout = {
          show_icon = false;
        };
        network = {
          vpn_status = "both";
          show_label = false;
        };
        control-center = {
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake-white.png";
        };
        media = {
          max_length = 140;
          art_size = 20;
          hide_artist = true;
        };
        tray = {
          drawer = true;
        };
        workspaces = {
          show_labels = false;
        };
      };
    };
  };
}
