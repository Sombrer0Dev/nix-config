{ pkgs, hostname, ... }:
let
  genericPackages = with pkgs; [
    blueberry
    btop
    delta
    docker-compose
    easyeffects
    eza
    fd
    fzf-git-sh
    hiddify-app
    hyprpicker
    jq
    lua51Packages.lua
    lua51Packages.luarocks
    matugen
    nix-your-shell
    obs-studio
    playerctl
    presenterm
    ripgrep
    spotify
    sshfs
    steam-run
    telegram-desktop
    trash-cli
    uv
    vlc
    zoxide
  ];
  hostPackages = {
    "home-pc" = with pkgs; [
      postman
      gimp
    ];
    "laptop" = with pkgs; [
      wdisplays
      prismlauncher
    ];
  };
  perHost = hostPackages.${hostname} or [];
in
{
  imports = [
    ../../scripts/nix-scripts.nix
    ../../scripts/shell-bins.nix
  ];

  home.packages = genericPackages ++ perHost;
}
