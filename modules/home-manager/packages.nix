{
  pkgs,
  hostname,
  inputs,
  ...
}:
let
  genericPackages = with pkgs; [
    libnotify
    blueman
    btop
    delta
    docker-compose
    eza
    fd
    gh
    hyprpicker
    jq
    zoxide
    proton-pass-cli
    lua51Packages.lua
    lua51Packages.luarocks
    matugen
    nix-your-shell
    obs-studio
    playerctl
    ripgrep
    spotify
    sshfs
    bubblewrap
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

    # nvim tooling (LSP servers, formatters, debuggers, treesitter CLI)
    tree-sitter
    ty
    ruff
    mypy
    python3Packages.debugpy
    bash-language-server
    shellcheck
    shfmt

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    inputs.codex-nix.packages.${stdenv.hostPlatform.system}.default
    inputs.claude-code.packages.${stdenv.hostPlatform.system}.default

    # load
    nodejs

  ];
  hostPackages = {
    "home-pc" = with pkgs; [
      # postman
      # gimp
      jetbrains-toolbox
      prismlauncher
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
