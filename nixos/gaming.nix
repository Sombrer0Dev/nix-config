{pkgs, lib, config, ...}: {
  options.gaming = {
    enable = lib.mkEnableOption "Hyprland";
  };


  config = lib.mkIf config.gaming.enable {
    # opengl
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

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
      STEAM_EXTRA_COMPAT_TOOLS_PATH =
      "/home/sombrer01/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}

