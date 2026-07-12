{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers.ty.enable = true;
    };

    extraPackages = with pkgs; [
      ty
      ruff
      mypy
      python3Packages.debugpy
    ];
  };
}
