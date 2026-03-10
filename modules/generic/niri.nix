{
  inputs,
  config,
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
  };
}
