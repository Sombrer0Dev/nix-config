{ pkgs, lib, ... }:
let
  epkgs = import <nixos> {
    overlays = [
      (import (
        builtins.fetchTarball {
          url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        }
      ))
    ];
  };
in
{
  xdg = {
    configFile.emacs.source = ../emacs;
    desktopEntries."emacs" = lib.mkIf pkgs.stdenv.isLinux {
      name = "Emacs";
      comment = "Edit text files";
      icon = "emacs";
      exec = "emacs";
      categories = [ "TextEditor" ];
      terminal = false;
      mimeType = [ "text/plain" ];
    };
  };

  services.emacs = {
    enable = true;
    package = epkgs.emacs-pgtk;
  };

  programs.emacs = {
    enable = true;
    package = epkgs.emacs-pgtk;
  };
}
