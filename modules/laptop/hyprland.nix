{ lib, ... }:
{
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NDV_BACKEND = "direct";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };
  wayland.windowManager.hyprland.settings = {
    exec-once = [ "jetbrains-toolbox" ];
    monitor = lib.mkForce [
      "eDP-1, 1920x1200@60.00Hz, 0x0, 1"
    ];
  };
}
