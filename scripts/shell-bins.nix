{ pkgs, ... }:
let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';
  tmux-tabs = pkgs.writeShellApplication {
    name = "tmux-tabs";
    text = ''
      set +u
      # If we're in SSH, use the host
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          echo "$(whoami)@$(hostname -s)"
      else
          # Otherwise show only the current directory
          basename "$PWD"
      fi
    '';
  };
in
{
  home.packages = [
    bman
    tmux-tabs
  ];
}
