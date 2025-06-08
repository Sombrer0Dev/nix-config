{
  description = "Configuration of Sombrer0Dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker.url = "github:abenz1267/walker";
    niri.url = "github:sodiboo/niri-flake";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "arsokolov";
      genericModules = [
        ./modules/generic/audio.nix
        ./modules/generic/gnome.nix
        ./modules/generic/locale.nix
        ./modules/generic/nautilus.nix
        ./modules/generic/system.nix
      ];

    in
    {
      nixosConfigurations.home-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs username;
          hostname = "home-pc";
        };
        modules = genericModules ++ [
          {
            services.xserver.videoDrivers = [ "amdgpu" ];
            nixpkgs.overlays = [
              inputs.hyprpanel.overlay
              inputs.niri.overlays.niri
              # add any other overlays you need
            ];
          }
          ./modules/home-pc/nixos.nix
          ./modules/generic/gaming.nix
          ./modules/generic/hyprland.nix
        ];
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs username;
          hostname = "laptop";
        };
        modules = genericModules ++ [
          (
            { config, ... }:
            {
              nixpkgs.overlays = [
                inputs.hyprpanel.overlay
                inputs.niri.overlays.niri
                # add any other overlays you need
              ];
              services.xserver.videoDrivers = [ "nvidia" ];
              hardware.nvidia = {
                modesetting.enable = true;
                powerManagement.enable = false;
                powerManagement.finegrained = false;
                open = true;
                nvidiaSettings = true;
                package = config.boot.kernelPackages.nvidiaPackages.stable;
              };
            }
          )
          ./modules/laptop/nixos.nix
          ./modules/generic/gaming.nix
          ./modules/generic/hyprland.nix
        ];
      };

    };
}
