{ pkgs, hostname, ... }:
let
  genericPackages = with pkgs; [
    libnotify
    blueman
    btop
    delta
    docker-compose
    eza
    fd
    fzf-git-sh
    throne
    hyprpicker
    jq
    zoxide
    lua51Packages.lua
    lua51Packages.luarocks
    matugen
    nix-your-shell
    obs-studio
    playerctl
    ripgrep
    spotify
    sshfs
    # steam-run
    # openvpn
    openssl
    pinentry-gnome3
    gpu-screen-recorder

    telegram-desktop
    obsidian
    # kotatogram-desktop

    trash-cli

    # vlc
    nil
    nixd
    nixfmt

  ];
  hostPackages = {
    "home-pc" = with pkgs; [
      # postman
      # gimp
      jetbrains-toolbox
    ];
    "laptop" = with pkgs; [
      wdisplays
      # prismlauncher
      jetbrains-toolbox
    ];
  };
  perHost = hostPackages.${hostname} or [ ];
in
{
  imports = [
    ../../scripts
  ];

  home.packages = genericPackages ++ perHost;
}
