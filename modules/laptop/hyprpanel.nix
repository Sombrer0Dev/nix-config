{ lib, inputs, ... }:
{
  programs.hyprpanel.settings = {
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
