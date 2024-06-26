{ config, pkgs, ... }: let
pkgs2405= import
    (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz")
    # reuse the current configuration
    {};
in{
  home.packages = with pkgs; [
    pkgs2405.beekeeper-studio
  ];
}


