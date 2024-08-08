{ pkgs, ... }:
{
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
      # webcord
      spotify

      dbeaver-bin
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
      openconnect
      playerctl
      devenv
      lua51Packages.lua
      lua51Packages.luarocks
      jq
      delta
    ];
  };
}
