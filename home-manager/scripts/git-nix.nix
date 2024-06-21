{pkgs, ...}: let
  flake-ignore = pkgs.writeShellScriptBin "flake-ignore" ''
    git add --intent-to-add $1 && git update-index --assume-unchanged $1
  '';
  nx-stage = pkgs.writeShellScriptBin "nx-stage" ''
    git add . && git commit -m "$1" && git push
  '';
in {
  home.packages = [ flake-ignore nx-stage ];
}

