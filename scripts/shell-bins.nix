{ pkgs, ... }:
let
  fgrep = pkgs.writeShellApplication {
    name = "fgrep";
    runtimeInputs = with pkgs; [
      ripgrep
      fd
      fzf
      neovim
      bat
      gawk
      gnugrep
    ];
    checkPhase = "";
    text = ''
      set -euo pipefail

      RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
      INITIAL_QUERY="''${*:-}"

      selected="$(
        fzf \
          --ansi \
          --phony \
          --query "$INITIAL_QUERY" \
          --delimiter : \
          --prompt 'Rg> ' \
          --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || true' \
          --preview-window 'right,60%,border-left,+{2}+3/3' \
          --bind "start:reload:$RG_PREFIX {q} || true" \
          --bind "change:reload:$RG_PREFIX {q} || true" \
          --bind "ctrl-g:change-prompt(Files> )+disable-search+unbind(change)+reload(fd --type f --hidden --follow --exclude .git || true)"
      )"

      [ -n "$selected" ] || exit 0

      file="$(printf '%s' "$selected" | awk -F: '{print $1}')"
      line="$(printf '%s' "$selected" | awk -F: '{print $2}')"

      if [ -n "''${line:-}" ] && printf '%s' "$line" | grep -Eq '^[0-9]+$'; then
        exec nvim "+$line" "$file"
      else
        exec nvim "$file"
      fi
    '';
  };
  # Search project files and open selected file in nvim.
  ffile = pkgs.writeShellApplication {
    name = "ffile";
    runtimeInputs = with pkgs; [
      fd
      fzf
      neovim
      bat
    ];
    text = ''
      set -euo pipefail

      selected="$(
        fd --type f --hidden --follow --exclude .git |
          fzf \
            --ansi \
            --prompt 'Files> ' \
            --preview 'bat --style=numbers --color=always {} 2>/dev/null || sed -n "1,200p" {}' \
            --preview-window 'right,60%,border-left'
      )"

      [ -n "$selected" ] || exit 0
      exec nvim "$selected"
    '';
  };
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
    fgrep
    ffile
  ];
}
