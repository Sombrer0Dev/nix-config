{ pkgs, ... }:
let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';
  get-worktree-branch = pkgs.writeShellApplication {
    name = "get-worktree-branch";
    runtimeInputs = with pkgs; [
      git
      ripgrep
    ];
    text = ''
      if [ $# -eq 0 ]; then
        QUERY=""
      else
        QUERY="$1"
      fi
      git worktree list --porcelain | rg worktree | awk '{print $2}' | fzf --query "$QUERY" --select-1
    '';
  };
  delete-worktree-branch = pkgs.writeShellApplication {
    name = "delete-worktree-branch";
    runtimeInputs = with pkgs; [
      git
      ripgrep
    ];
    text = ''
      if [ $# -eq 0 ]; then
        QUERY=""
      else
        QUERY="$1"
      fi
      git worktree remove "$(git worktree list --porcelain | rg worktree | awk '{print $2}' | fzf --query "$QUERY" --select-1)"
    '';
  };
  add-worktree-branch = pkgs.writeShellApplication {
    name = "add-worktree-branch";
    runtimeInputs = with pkgs; [
      git
      ripgrep
    ];
    text = ''
      if [ $# -eq 0 ]; then
        QUERY=""
      else
        QUERY="$1"
      fi

      BRANCH="$(git branch --format='%(refname:short)' |fzf --query "$QUERY" --select-1)"
      WORKTREE_PATH="$(git worktree list | rg bare | awk '{print $1}')";
      git worktree add "$WORKTREE_PATH/$BRANCH"
      echo "$WORKTREE_PATH/$BRANCH"
    '';
  };

  rf = pkgs.writeShellApplication {
    name = "rf";
    runtimeInputs = with pkgs; [
      fzf
      ripgrep
      neovim
      bat
    ];
    runtimeEnv = {
      RELOAD = "rg --column --line-number --no-heading --color=always --smart-case {q} || :";
    };
    text = ''
      rm -f /tmp/rg-fzf-{r,f}
      INITIAL_QUERY="''${*:-}"
      fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload($RELOAD)+unbind(ctrl-r)" \
        --bind "change:reload:sleep 0.1; $RELOAD" \
        --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
        --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RELOAD)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt "1. ripgrep> " \
        --delimiter : \
        --header "╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱" \
        --preview "bat --color=always {1} --highlight-line {2}" \
        --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
        --bind "enter:become(nvim {1} +{2})" \
        --bind "ctrl-o:execute:nvim {1} +{2}"
    '';
  };

  rfq = pkgs.writeShellApplication {
    name = "rfq";
    runtimeInputs = with pkgs; [
      fzf
      ripgrep
      neovim
      bat
    ];
    runtimeEnv = {
      RELOAD = "rg --column --line-number --no-heading --color=always --smart-case {q} || :";
    };
    text = ''
      rm -f /tmp/rg-fzf-{r,f}
      INITIAL_QUERY="''${*:-}"
      set +u
      fzf --ansi --disabled --multi --query "$INITIAL_QUERY" \
        --bind "start:reload($RELOAD)+unbind(ctrl-r)" \
        --bind "change:reload:sleep 0.1; $RELOAD" \
        --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
        --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RELOAD)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt "1. ripgrep> " \
        --delimiter : \
        --header "╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱" \
        --preview "bat --color=always {1} --highlight-line {2}" \
        --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
        --bind "enter:become(nvim +cw -q {+f})" \
        --bind "ctrl-o:execute:echo $FZF_SELECT_COUNT"
    '';
  };
in
{
  home.packages = [
    bman
    rf
    rfq
    add-worktree-branch
    delete-worktree-branch
    get-worktree-branch
  ];
}
