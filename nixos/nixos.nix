{ inputs, lib, ... }:
let
  username = "arsokolov";
in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./system.nix
    ./audio.nix
    ./locale.nix
    ./nautilus.nix
    ./hyprland.nix
    ./gnome.nix
    ./gaming.nix
  ];

  nix.settings.trusted-users = [
    "root"
    username
  ];
  hyprland.enable = true;
  gaming.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    extraGroups = [
      "nixosvmtest"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "docker"
    ];
  };

  home-manager = {
    # backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ../home-manager/nvim.nix
        ../home-manager/emacs.nix
        ../home-manager/browser.nix
        ../home-manager/dconf.nix
        ../home-manager/git.nix
        ../home-manager/hyprland.nix
        ../home-manager/packages.nix
        ../home-manager/shell.nix
        ../home-manager/theme.nix
        ../home-manager/kitty.nix
        ../home-manager/alacritty.nix
        ../home-manager/foot.nix
        ../home-manager/ghostty.nix
        ../home-manager/tmux.nix
        ./home.nix

        ../home-manager/work.nix
      ];
    };
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = [ "Gnome" ];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };

    # hyprland.configuration = {
    #   system.nixos.tags = [ "Hyprland" ];
    #   gnome.enable = lib.mkForce false;
    #   hyprland.enable = false;
    # };
  };
}
