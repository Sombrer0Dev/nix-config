{ inputs, ... }:
let
  hyprpanelConfig = builtins.fromJSON (builtins.readFile ../../hyprpanel/hyprpanel_config.json);
in
{
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];
  programs.hyprpanel = {
    enable = true;
    config.enable = false;
    # hyprland.enable = true;

    # settings = hyprpanelConfig;
    # settings = {
    #   layout = {
    #     "bar.layouts" = {
    #       "0" = {
    #         left = [
    #           "dashboard"
    #           "workspaces"
    #         ];
    #         "middle" = [
    #           "media"
    #         ];
    #         "right" = [
    #           "volume"
    #           "kbinput"
    #           "bluetooth"
    #           "systray"
    #           "clock"
    #           "notifications"
    #         ];
    #       };
    #       "1" = {
    #         "left" = [
    #           "dashboard"
    #           "workspaces"
    #         ];
    #         "middle" = [
    #           "media"
    #         ];
    #         "right" = [
    #           "volume"
    #           "kbinput"
    #           "bluetooth"
    #           "systray"
    #           "clock"
    #           "notifications"
    #         ];
    #       };
    #       "2" = {
    #         "left" = [
    #           "dashboard"
    #           "workspaces"
    #           "windowtitle"
    #         ];
    #         "middle" = [
    #           "media"
    #         ];
    #         "right" = [
    #           "volume"
    #           "clock"
    #           "notifications"
    #         ];
    #       };
    #     };
    #   };
    #   wallpaper.image = "/home/arsokolov/Documents/walls/flowers/a_group_of_flowers_on_a_black_background.png";
    #   theme.matugen_settings.variation = "standard_1";
    #   theme.matugen_settings.mode = "dark";
    #   theme.matugen_settings.scheme_type = "monochrome";
    #   theme.matugen = true;
    #   theme.bar.buttons.enableBorders = true;
    #   tear = true;
    #   menus.clock.weather.location = "Moscow";
    #   menus.clock.weather.unit = "metric";
    #   menus.clock.weather.enabled = false;
    #   menus.clock.time.military = true;
    #   menus.clock.time.hideSeconds = true;
    #   bar.clock.format = "%a %b %d  %H:%M:%S";
    #   bar.notifications.show_total = true;
    #   bar.customModules.kbLayout.label = true;
    #   bar.customModules.kbLayout.labelType = "code";
    #   bar.bluetooth.label = false;
    #   bar.workspaces.monitorSpecific = true;
    #   bar.launcher.icon = "{ø}";
    #   bar.launcher.autoDetectIcon = false;
    #   theme.bar.buttons.dashboard.enableBorder = true;
    #   theme.bar.border.location = "none";
    #   theme.bar.enableShadow = false;
    #   terminal = "kitty";
    #   theme.bar.menus.enableShadow = false;
    #   scalingPriority = "gdk";
    #   theme.bar.menus.opacity = 100;
    #   theme.bar.transparent = false;
    #   theme.bar.opacity = 50;
    #   theme.bar.buttons.background_opacity = 100;
    #   theme.bar.buttons.opacity = 100;
    # };

  };
}
