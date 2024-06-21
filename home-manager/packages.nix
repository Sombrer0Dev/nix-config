{pkgs, inputs, ...}: {
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nx-switch.nix
    ./scripts/git-nix.nix
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
      # inputs.yandex-music.packages.${system}.default

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
