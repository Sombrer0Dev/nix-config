{
  description = "Configuration of Sombrer0Dev";

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      hyprpanel,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit system;
          };
          # > Our main nixos configuration file <
          modules = [
            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "arsokolov@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.hyprpanel.overlay
            ];
          }; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs;
            inherit system;
          };
          # > Our main home-manager configuration file <
          modules = [
            (
              { pkgs, ... }:
              {
                nix.package = pkgs.nix;
                home.username = "arsokolov";
                home.homeDirectory = "/home/arsokolov/";
                imports = [
                  ./nixos/home.nix
                ];
              }
            )
          ];
        };
      };
    };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };
}
