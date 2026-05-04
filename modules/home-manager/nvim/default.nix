{ pkgs, ... }:
{
  imports = [
    ./plugins
    ./languages
    # ./languages/python.nix
    # ./languages/nix.nix
    # ./languages/bash.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      termguicolors = true;
    };
  };
}
