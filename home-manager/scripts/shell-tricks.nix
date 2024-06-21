{pkgs, ...}: let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';
  direnv-switch = pkgs.writeShellScriptBin "direnv-switch" ''
    set -euo pipefail

    env_name=$1
    env_file=.env.''${env_name}

    if [[ ! -f $env_file ]]; then
      echo "env $env_name not found" >&2
      exit 1
    fi

    cat <<NEW_ENVRC > .envrc
    log Loading environment "$env_name"
    dotenv "$env_file"
    NEW_ENVRC

    direnv allow .
  '';
in {
  home.packages = [ bman direnv-switch ];
}
