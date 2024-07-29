{ pkgs, ... }:
let
  bman = pkgs.writeShellScriptBin "bman" ''
    page=$(man -k . | fzf-tmux --nth 1,2)
    echo $page | awk 'BEGIN {ORS=" "}; {print $2} {print $1}'| tr -d '()' | xargs man
  '';

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
  ];
}
