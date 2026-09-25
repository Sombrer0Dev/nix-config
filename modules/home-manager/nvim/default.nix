{ config, ... }:
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

    extraConfigLua = ''
      vim.fn.mkdir(vim.o.undodir, "p")
    '';

    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes:1";
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      termguicolors = true;
      undofile = true;
      undodir = [ "${config.xdg.stateHome}/nvim/undo" ];
    };
  };
}
