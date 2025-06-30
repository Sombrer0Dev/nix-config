{ lib, ... }:
{
  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1, 1920x1200@60.00Hz, 0x0, 1"
  ];
}
