{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.gaming = {
    enable = lib.mkEnableOption "Gaming";
  };

  config = lib.mkIf config.gaming.enable {
    # opengl
    hardware.graphics.enable = true;

    # gpu drivers
    services.xserver.videoDrivers = [ "amdgpu" ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
    ];
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/arsokolov/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
