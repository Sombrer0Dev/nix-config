{
  pkgs,
  ...
}:
{
  config = {
    # opengl
    hardware.graphics.enable = true;

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
