{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.lsp.servers.nil_ls.enable = true;

    extraPackages = with pkgs; [
      nil
      nixfmt
    ];
  };
}
