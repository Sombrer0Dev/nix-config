{
  description = "Configuration of Sombrer0Dev";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    hyprland.url = "github:hyprwm/Hyprland";
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
        ./modules/generic/system.nix
        ./modules/generic/audio.nix
        ./modules/generic/gnome.nix
        ./modules/generic/cosmic.nix
        ./modules/generic/locale.nix
        ./modules/generic/nautilus.nix
      ];
      # CACHE
      cache = [
        {
          nix.settings = {
            substituters = [
              "https://walker.cachix.org"
              "https://hyprland.cachix.org"
              # "https://walker-git.cachix.org"
            ];
            trusted-substituters = [ "https://hyprland.cachix.org" ];
            trusted-public-keys = [
              "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              # "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
            ];
          };
        }
      ];

    in
    {
      nixosConfigurations.home-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs username;
          hostname = "home-pc";
        };
        modules =
          cache
          ++ genericModules
          ++ [
            {
              services.xserver.videoDrivers = [ "amdgpu" ];
              nixpkgs.overlays = [
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
        modules =
          cache
          ++ genericModules
          ++ [
            (
              { config, ... }:
              {
                nixpkgs.overlays = [
                  # add any other overlays you need
                ];
                services.xserver.videoDrivers = [ "nvidia" ];
                hardware.nvidia = {
                  modesetting.enable = true;
                  powerManagement.enable = false;
                  powerManagement.finegrained = false;
                  open = false;
                  nvidiaSettings = true;
                  package = config.boot.kernelPackages.nvidiaPackages.production;
                  prime = {
                    sync.enable = true;
                    intelBusId = "PCI:0:2:0";
                    nvidiaBusId = "PCI:1:0:0";
                    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
                  };
                };
              }
            )
            ./modules/laptop/nixos.nix
            ./modules/generic/gaming.nix
            ./modules/generic/hyprland.nix
            ./modules/laptop/specialisations.nix
          ];
      };
    };
}
