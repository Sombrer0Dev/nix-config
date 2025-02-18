{ pkgs, ... }:

let
  emacsWithNativeComp = pkgs.emacs30-pgtk;
in
{
  services.emacs = {
    enable = false;
    package = emacsWithNativeComp;
  };
  # Configure Emacs
  programs.emacs = {
    enable = false;
    package = emacsWithNativeComp;

    # Optionally, specify additional Emacs packages.
    extraPackages = epkgs: [
      # epkgs.use-package
      # epkgs.magit
      # epkgs.org
      epkgs.vterm
    ];
  };
}

