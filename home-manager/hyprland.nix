{ inputs, pkgs, ... }:
let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
in
{
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

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
        "ags -b hypr"
        "xterm"
        "nm-applet"
      ];

      monitor = [
        "DP-2, 1920x1080, 0x0, 1"
        "HDMI-A-1, 2560x1440, 1920x0, 1"
      ];
      workspace = [
        "1,monitor:HDMI-A-1"
        "2,monitor:DP-2"
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
        sensitivity = -0.7;
        accel_profile = "flat";
        force_no_accel = 1;
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
          f = regex: "float, ^(${regex})$";
        in
        [
          (f "org.gnome.Calculator")
          (f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "spotify")
          (f "nm-connection-editor")
          (f "blueberry.py")
          (f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          (f "transmission-gtk")
          (f "com.github.Aylur.ags")
          ("bordercolor rgb(EE5396) rgb(EE5396),fullscreen:1")
        ];

      bind =
        let
          binding =
            mod: cmd: key: arg:
            "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          ws = binding "SUPER" "workspace";
          resizeactive = binding "SUPER ALT" "resizeactive";
          mvwindow = binding "SUPER SHIFT" "movewindow";
          mvtows = binding "SUPER SHIFT" "movetoworkspace";
          e = "exec, ags -b hypr";
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
          "CTRL SHIFT, R,    ${e} quit; ags -b hypr"
          "SUPER, Backspace, ${e} -t launcher"
          "SUPER, Tab,       ${e} -t overview"
          ",XF86PowerOff,    ${e} -r 'powermenu.shutdown()'"
          "SUPER SHIFT, P,   ${e} -r 'powermenu.shutdown()'"
          "SUPER SHIFT, V,   ${e} -r 'recorder.start()'"
          "SUPER SHIFT, S,   ${e} -r 'recorder.screenshot()'"
          "SUPER CONTROL, S, ${e} -r 'recorder.screenshot(true)'"
          "SUPER, Return, exec, xterm"

          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "SUPER, Q, killactive"
          "SUPER, W, togglefloating"
          "SUPER, F, fullscreen, 1"
          "SUPER, O, fakefullscreen"
          "SUPER, P, togglesplit"

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
        drop_shadow = "yes";
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";

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
}
