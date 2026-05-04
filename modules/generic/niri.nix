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

    # Fix services starting before niri-session
    systemd.user.services.xdg-desktop-portal = {
      after = [ "xdg-desktop-autostart.target" ];
    };

    systemd.user.services.xdg-desktop-portal-gtk = {
      after = [ "xdg-desktop-autostart.target" ];
    };

    systemd.user.services.xdg-desktop-portal-gnome = {
      after = [ "xdg-desktop-autostart.target" ];
    };

    systemd.user.services.niri-flake-polkit = {
      after = [ "xdg-desktop-autostart.target" ];
    };

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "niri";
      GDK_BACKEND = "wayland";
    };
    environment.systemPackages = [
      pkgs.xdg-desktop-portal-gtk
    ];
    xdg.portal = {
      enable = true;
      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.portal.ScreenCast" = "gnome";
      };

      # # wlroots backend (THIS is what gives ScreenCast)
      # gtk.enable = true;

      # GTK portal for file pickers etc (optional but recommended)
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
