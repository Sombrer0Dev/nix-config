{ config, lib, ... }:
{
  options.packages =
    with lib;
    let
      packagesType = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
    in
    {
      linux = packagesType;
      cli = packagesType;
    };

  config = {
    home.packages = with config.packages; cli ++ linux;
  };
}
