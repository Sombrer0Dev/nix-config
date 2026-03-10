{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  options.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf config.niri.enable {
    imports = [ inputs.niri.nixosModules.niri ];
    programs.niri.enable = true;
  };
}
