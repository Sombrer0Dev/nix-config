{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pypkg = pkgs.python312Packages;
in
{
  home.sessionVariables = {
    MANPAGER = "nvim -c 'Man!' -o -";
    LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.so";
  };
  xdg = {
    configFile = {
      ripgrep_ignore.text = ''
        .git/
        yarn.lock
        package-lock.json
        packer_compiled.lua
        .DS_Store
        .netrwhist
        dist/
        node_modules/
        **/node_modules/
        wget-log
        wget-log.*
        /vendor
      '';
      nvim = {

        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nix-config/nvim";
        recursive = true;
      };
    };
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

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
    defaultEditor = true;

    extraLuaPackages = ps: [ ps.jsregexp ];
    extraPackages =
      with pkgs;
      with pypkg;
      with nodePackages;
      [
        git
        gcc
        gnumake
        sqlite
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
        python
        php

        # config helpers
        vale
        nixd
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
