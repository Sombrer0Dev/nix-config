{ lib, inputs, ... }:
{
  programs.hyprpanel.settings = {
    wallpaper.image = lib.mkForce "/home/arsokolov/Documents/walls/flowers/a_group_of_flowers_on_a_black_background.png";
    layout = lib.mkForce {
      "bar.layouts" = {
        "0" = {
          left = [
            "dashboard"
            "workspaces"
          ];
          "middle" = [
            "media"
          ];
          "right" = [
            "volume"
            "kbinput"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
        "1" = {
          "left" = [
            "dashboard"
            "workspaces"
          ];
          "middle" = [
            "media"
          ];
          "right" = [
            "volume"
            "kbinput"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
        "2" = {
          "left" = [
            "dashboard"
            "workspaces"
          ];
          "middle" = [
            "media"
          ];
          "right" = [
            "volume"
            "kbinput"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
        "3" = {
          "left" = [
            "dashboard"
            "workspaces"
          ];
          "middle" = [
            "media"
          ];
          "right" = [
            "volume"
            "kbinput"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
      };
    };
  };
}
