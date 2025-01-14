{ pkgs, ... }:
{
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/nix-scripts.nix
    ./scripts/worktree.nix
    ./scripts/shell-bins.nix
  ];

  packages = with pkgs; {
    linux = [
      telegram-desktop
      vlc
      blueberry
      gimp
      brave
      spotify
      bitwarden-desktop
      postman
      zoom-us
      nekoray
      rofi
      tofi
      hyprpicker
      obs-studio

      prismlauncher
    ];
    cli = [
      nix-your-shell
      fzf-git-sh
      zoxide
      eza
      fd
      ripgrep
      trash-cli
      playerctl
      lua51Packages.lua
      lua51Packages.luarocks
      jq
      delta
      nodePackages.vscode-json-languageserver
      steam-run
      bitwarden-cli
      uv
      btop
    ];
  };
}
