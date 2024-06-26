{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-scripts.nix
    ./scripts/git-nix.nix
    ./scripts/shell-tricks.nix
  ];

  packages = with pkgs; {
    linux = [
      telegram-desktop
      vlc
      obs-studio
      transmission_4-gtk
      gnome-secrets
      blueberry
      gimp
      webcord
      spotify

      postman
      zoom-us
    ];
    cli = [
      nix-your-shell
      zoxide
      bat
      eza
      fd
      ripgrep
      fzf
      trash-cli
      direnv
      openconnect
    ];
  };
}
