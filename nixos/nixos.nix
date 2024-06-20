{
  inputs,
  lib,
  ...
}: let
  username = "sombrer01";
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./system.nix
    ./audio.nix
    ./locale.nix
    ./nautilus.nix
    ./hyprland.nix
    ./gnome.nix
  ];

  hyprland.enable = true;

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
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ../home-manager/nvim.nix
        ../home-manager/ags.nix
        ../home-manager/browser.nix
        ../home-manager/dconf.nix
        ../home-manager/git.nix
        ../home-manager/hyprland.nix
        ../home-manager/packages.nix
        ../home-manager/shell.nix
        ../home-manager/theme.nix
	../home-manager/alacritty.nix
        ../home-manager/tmux.nix
        ./home.nix
      ];
    };
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = ["Gnome"];
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
    };

  #   # TODO maybe fix this
  #   hyprland.configuration = {
  #     system.nixos.tags = ["Hyprland"];
  #     hyprland.enable = lib.mkForce true;
  #     gnome.enable = false;
  #   };
  };
}
