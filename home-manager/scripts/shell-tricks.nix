{pkgs, ...}: let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';
  direnv-switch = pkgs.writeShellScriptBin "direnv-switch" ''
    export APP_ENV="$1"
    direnv allow
  '';
in {
  home.packages = [ bman direnv-switch ];
}
