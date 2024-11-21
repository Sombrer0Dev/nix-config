{ pkgs, lib, ... }:
let
  pypkg = pkgs.python312Packages;
in
{
  xdg = {
    # TODO
    configFile.nvim.source = ../nvim;
    desktopEntries."nvim" = lib.mkIf pkgs.stdenv.isLinux {
      name = "NeoVim";
      comment = "Edit text files";
      icon = "nvim";
      exec = "xterm -e ${pkgs.neovim}/bin/nvim %F";
      categories = [ "TerminalEmulator" ];
      terminal = false;
      mimeType = [ "text/plain" ];
    };
    desktopEntries."gnome-control-center" = lib.mkIf pkgs.stdenv.isLinux {
      name = "GNOME Control Center";
      comment = "GNOME control center";
      icon = "gnome";
      exec = "gnome-control-center";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    withRuby = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages =
      with pkgs;
      with pypkg;
      with nodePackages;
      [
        git
        gcc
        gnumake
        sqlite.dev
        unzip
        wget
        curl
        tree-sitter
        trash-cli
        ripgrep
        fd
        fzf
        cargo
        go
        python3
        php

        # config helpers
        vale
        nil
        lua-language-server
        stylua

        # lsp servers
        gopls
        ruff
        sqls
        jedi-language-server
        marksman
        yaml-language-server
        bash-language-server

        # formatters
        black
        gotools
        gofumpt
        sqlfluff
        nixfmt-rfc-style
      ];
  };
}
