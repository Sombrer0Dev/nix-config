{
  description = "Configuration of Sombrer0Dev";

  nixConfig = {
    extra-substituters = [
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/v4.7.7";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";

    # Editors
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixvim.url = "github:nix-community/nixvim";
    codex-nix.url = "github:SecBear/codex-nix";

    # SecureBoot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs = {
        rust-overlay.follows = "rust-overlay";
        nixpkgs.follows = "nixpkgs";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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
        ./modules/generic/locale.nix
        ./modules/generic/nautilus.nix
        ./modules/generic/vless.nix

        # DE
        ./modules/generic/cosmic.nix
        ./modules/generic/niri.nix
        ./modules/generic/hyprland.nix
        inputs.nix-index-database.nixosModules.default
      ];
      # CACHE
      cache = [
        {
          nix.settings = {
            substituters = [
              "https://cache.nixos.org"
              "https://niri.cachix.org"
              "https://noctalia.cachix.org"
            ];
            trusted-public-keys = [
              "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
              "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            ];
          };
        }
      ];

    in
    {
      nixosConfigurations.home-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # stdenv.hostPlatform.system = "x86_64-linux";
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
                inputs.nix-vscode-extensions.overlays.default
                # add any other overlays you need
              ];
            }
            ./modules/home-pc/nixos.nix
            ./modules/home-pc/secure-boot.nix
            ./modules/generic/gpu.nix
            inputs.lanzaboote.nixosModules.lanzaboote
          ];
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # stdenv.hostPlatform.system = "x86_64-linux";
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
            # ./modules/generic/gaming.nix
            ./modules/laptop/specialisations.nix
          ];
      };
    };
}
