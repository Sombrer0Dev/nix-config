{ pkgs, hostname, ... }:
let
  genericPackages = with pkgs; [
    blueberry
    btop
    delta
    docker-compose
    eza
    fd
    fzf-git-sh
    hiddify-app
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
    steam-run
    openvpn

    telegram-desktop
    bottles
    # kotatogram-desktop

    trash-cli

    # vlc

  ];
  hostPackages = {
    "home-pc" = with pkgs; [
      postman
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
    ../../scripts/nix-scripts.nix
    ../../scripts/shell-bins.nix
    ../../scripts/worktree.nix
    ../../scripts/work-scripts.nix
  ];

  home.packages = genericPackages ++ perHost;
}
