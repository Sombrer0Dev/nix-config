{ lib, ... }:
{
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "DP-1, 2560x1440@180.06Hz, 2560x0, 1"
    "DP-2, 2560x1440@59.95Hz, 0x0, 1"
  ];
}
