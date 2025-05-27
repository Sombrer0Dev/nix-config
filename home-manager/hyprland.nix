{ inputs, pkgs, ... }:
let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprlock-blur = pkgs.writeShellScriptBin "hyprlock-blur" ''
    ${pkgs.grim}/bin/grim -o DP-2 -l 0 /tmp/screenshot1.png &
    ${pkgs.grim}/bin/grim -o HDMI-A-1 -l 0 /tmp/screenshot2.png &
    wait &&
    hyprlock
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-hyprspace.packages.${pkgs.system}.default
      # plugins.hyprexpo
      # plugins.hyprbars
      # plugins.borderspp
    ];

    settings = {
      exec-once = [
        "nm-applet"
        "hiddify"
        "hyprpanel"
        "pkill mako"
      ];

      monitor = [
        "DP-1, 2560x1440@180.06Hz, 2560x0, 1"
        "DP-2, 2560x1440@59.95Hz, 0x0, 1"
      ];
      workspace = [
        "1,monitor:DP-1"
        "2,monitor:DP-2"
        "w[t1], gapsout:0, gapsin:0"
        "w[tg1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
      };

      input = {
        kb_layout = "us, ru";
        kb_options = "grp:win_space_toggle";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };
        sensitivity = -0.1;
        accel_profile = "flat";
        force_no_accel = 0;
        repeat_delay = 200;
        repeat_rate = 35;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      gestures = {
        workspace_swipe = "off";
      };

      windowrule =
        let
          f = regex: "float, ${regex}";
          fs = { regex, size }: "float, size ${size}, ^(${regex})";
        in
        [
          (f "title:org.gnome.Calculator")
          (f "title:org.gnome.Nautilus")
          (f "title:pavucontrol")
          (f "title:nm-connection-editor")
          (f "title:blueberry.py")
          (f "title:org.gnome.Settings")
          (f "title:org.gnome.design.Palette")
          (f "title:Color Picker")
          (f "title:xdg-desktop-portal")
          (f "title:xdg-desktop-portal-gnome")
          (f "title:transmission-gtk")
          (f "title:Picture-in-Picture")
          # (fs {
          #   size = "50% 50%";
          #   regex = "Bitwarden";
          # })
          "bordercolor rgb(EE5396) rgb(EE5396),fullscreen:1"
        ];
      windowrulev2 =
        let
          f = text: "float, ${text}";
        in
        [
          (f "title:Picture-in-Picture")
        ];

      bind =
        let
          binding =
            mod: cmd: key: arg:
            "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          ws = binding "SUPER" "workspace";
          wsfocus = binding "SUPER" "focusworkspaceoncurrentmonitor";
          resizeactive = binding "SUPER ALT" "resizeactive";
          mvwindow = binding "SUPER SHIFT" "movewindow";
          mvtows = binding "SUPER SHIFT" "movetoworkspace";
          arr = [
            1
            2
            3
            4
            5
            6
            7
          ];
        in
        [
          # "CTRL SHIFT, R,    ${e} quit; ags -b hypr"
          "SUPER, TAB, exec , walker --modules applications,websearch"
          # "SUPER, Tab,       ${e} -t overview"
          # ",XF86PowerOff,    ${e} -r 'powermenu.shutdown()'"
          # "SUPER SHIFT, P,   ${e} -r 'powermenu.shutdown()'"
          # "SUPER SHIFT, V,   ${e} -r 'recorder.start()'"
          "SUPER SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
          # "SUPER CONTROL, S, ${e} -r 'recorder.screenshot(true)'"
          "SUPER, Return, exec, kitty"

          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "SUPER, Q, killactive"
          "SUPER, W, togglefloating"
          "SUPER, F, fullscreen, 1"
          "SUPER, P, togglesplit"
          "SUPER, G, togglegroup"
          "SUPER CONTROL, G, changegroupactive"

          "SUPER, T, togglespecialworkspace, special"
          "SUPER CONTROL, T, movetoworkspace, special"

          (mvfocus "k" "u")
          (mvfocus "j" "d")
          (mvfocus "l" "r")
          (mvfocus "h" "l")
          (resizeactive "k" "0 -40")
          (resizeactive "j" "0 40")
          (resizeactive "l" "40 0")
          (resizeactive "h" "-40 0")
          (mvwindow "k" "u")
          (mvwindow "j" "d")
          (mvwindow "l" "r")
          (mvwindow "h" "l")
        ]
        ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: wsfocus (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr);

      bindle = [
        ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
        ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ];

      bindl = [
        ",XF86AudioPlay,  exec, ${playerctl} play-pause"
        ",XF86AudioPrev,  exec, ${playerctl} previous"
        ",XF86AudioNext,  exec, ${playerctl} next"
        ",XF86AudioMute,  exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      decoration = {
        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 1.0e-2;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      plugin = {
        overview = {
          centerAligned = true;
          hideTopLayers = true;
          hideOverlayLayers = true;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          reverseSwipe = true;
        };
        hyprbars = {
          bar_color = "rgb(2a2a2a)";
          bar_height = 28;
          col_text = "rgba(ffffffdd)";
          bar_text_size = 11;
          bar_text_font = "Ubuntu Nerd Font";

          buttons = {
            button_size = 0;
            "col.maximize" = "rgba(ffffff11)";
            "col.close" = "rgba(ff111133)";
          };
        };
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          blur_passes = 1; # 0 disables blurring
          blur_size = 7;
          noise = 1.17e-2;
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 95;
          font_family = "Ubuntu Nerd Mono";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 22;
          font_family = "Ubuntu Nerd Mono";
          position = "0, 200";
          halign = "center";
          valign = "center";

        }
      ];

      image = {
        path = "/home/arsokolov/Documents/avatar.jpg";

        position = "0, 50";
        halign = "center";
        valign = "center";
      };

      input-field = {
        size = "200,50";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgb(111, 45, 104)";
        fade_on_empty = false;
        rounding = -1;
        check_color = "rgb(30, 107, 204)";
        placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
        hide_input = false;
        position = "0, -100";
        halign = "center";
        valign = "center";
      };
    };
  };

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  imports = [inputs.walker.homeManagerModules.default];
  programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    config = {
      search.placeholder = "Example";
      ui.fullscreen = true;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };

    # If this is not set the default styling is used.
    # style = ''
    #   * {
    #     color: #dcd7ba;
    #   }
    # '';
  };
    services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

}
