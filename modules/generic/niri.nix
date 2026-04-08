{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  imports = [ inputs.niri.nixosModules.niri ];
  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;
    systemd.user.services.niri-flake-polkit.enable = false;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common = {
          default = [ "gtk" ];
        };
        niri = {
          default = [
            "gtk"
            "gnome"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
      };
    };
  };
}
