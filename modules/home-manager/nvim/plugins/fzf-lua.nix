{ ... }:
{
  programs.nixvim.plugins.fzf-lua = {
    enable = true;
    profile = "fzf-tmux";
  };
}
