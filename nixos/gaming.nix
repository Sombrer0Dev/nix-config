{pkgs, lib, config, ...}: {
  options.gaming = {
    enable = lib.mkEnableOption "Hyprland";
  };


  # opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # gpu drivers
  services.xserver.videoDrivers = [ "amdgpu" ];


  config = lib.mkIf config.gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];

    programs.gamemode.enable = true;
  };
}

