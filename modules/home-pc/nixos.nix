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
  hyprland.enable = true;
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
      imports =
        [
          # Basic modules
          ../home-manager/packages.nix

          # ../home-manager/nvim.nix
          ../home-manager/nixCats/default.nix
          ../home-manager/browser.nix
          ../home-manager/dconf.nix
          ../home-manager/git.nix
          ../home-manager/hyprland.nix
          ../home-manager/hyprpanel.nix
          ../home-manager/shell.nix
          ../home-manager/theme.nix
          ../home-manager/kitty.nix
          ../home-manager/tmux.nix
          ../generic/home.nix

          ../home-manager/work.nix
        ]
        ++ [
          # Overrides
          ./hyprland.nix
          ./hyprpanel.nix
        ];
    };
  };
}
