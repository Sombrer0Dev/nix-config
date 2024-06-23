{pkgs, ...}: let
  flake-ignore = pkgs.writeShellScriptBin "flake-ignore" ''
    git add --intent-to-add $1 && git update-index --assume-unchanged $1
  '';
  nix-stage = pkgs.writeShellScriptBin "nx-stage" ''

  ''
in {
  home.packages = [ flake-ignore ];
}
