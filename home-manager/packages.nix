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
    ];
    cli = [
      zoxide
      bat
      eza
      fd
      ripgrep
      fzf
      trash-cli
    ];
  };
}
