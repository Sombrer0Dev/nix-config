{pkgs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
  ];

  packages = with pkgs; {
    linux = [
      telegram-desktop
      transmission_4-gtk
      gnome-secrets
      blueberry
      webcord

      postman
      zoom-us
    ];
    cli = [
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
