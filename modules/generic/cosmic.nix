{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.cosmic = {
    enable = lib.mkEnableOption "Cosmic";
  };

  config = lib.mkIf config.cosmic.enable {
    # xdg.portal = {
    #   enable = true;
    #   # xdgOpenUsePortal = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-gnome
    #     # xdg-desktop-portal-wlr
    #   ];
    # };
    services = {
      xserver.enable = true;
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
      desktopManager.cosmic.xwayland.enable = true;
    };
  };

}
