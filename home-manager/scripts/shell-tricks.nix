{pkgs, ...}: let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';
in {
  home.packages = [ flake-ignore nx-stage ];
}
