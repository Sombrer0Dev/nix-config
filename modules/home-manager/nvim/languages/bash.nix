{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.lsp.servers.bashls.enable = true;

    extraPackages = with pkgs; [
      bash-language-server
      shellcheck
      shfmt
    ];
  };
}
