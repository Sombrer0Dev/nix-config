{
  config,
  lib,
  pkgs,
  ...
}:
let
  nvimConfigDir = "${config.home.homeDirectory}/Documents/nvim";
in
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimConfigDir;

  home.activation.cloneNvimConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ ! -e "${nvimConfigDir}/.git" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/sombrer0dev/nvim "${nvimConfigDir}"
    fi
  '';
}
