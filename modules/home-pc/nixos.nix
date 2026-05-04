{
  inputs,
  hostname,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.trusted-users = [
    "root"
    username
  ];
  hyprland.enable = false;
  niri.enable = true;
  gnome.enable = true;

  networking.hostName = "home-pc";

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs hostname;
    };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        inputs.nixvim.homeModules.nixvim

        inputs.nix-index-database.homeModules.default
        { programs.nix-index-database.comma.enable = true; }

        ../home-manager/nvim
        ../home-manager/vimrc.nix

        ../home-manager/browser.nix
        ../home-manager/dconf.nix
        ../home-manager/git.nix
        ../home-manager/niri.nix

        ../home-manager/noctalia.nix

        ../home-manager/shell.nix
        ../home-manager/theme.nix
        ../home-manager/kitty.nix
        ../home-manager/tmux.nix
        ../generic/home.nix

        ../home-manager/work.nix

        # Basic modules
        ../home-manager/packages.nix
      ]
      ++ [
        # Overrides
        # ./hyprland.nix
      ];
    };
  };
}
