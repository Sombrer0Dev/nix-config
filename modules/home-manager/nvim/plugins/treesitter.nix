{ ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
      ensure_installed = [
        "python"
        "nix"
        "bash"
        "lua"
        "vim"
        "markdown"
      ];
    };
  };
}
