{pkgs, ...}: let
  flake-ignore = pkgs.writeShellScriptBin "flake-ignore" ''
    git add --indent-to-add $1 && git update-index --assume-unchanged $1
  '';
in {
  home.packages = [ flake-ignore ];
}

