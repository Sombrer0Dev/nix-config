{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  time.hardwareClockInLocalTime = true;

  programs.ssh.startAgent = true;
  programs.seahorse.enable = true;
  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman = {
      enable = true;
    };
    docker.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # gpg signing
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    # settings = {
    #   # default-key = "44F7B7979D3A27B189E0841E8333735E784DF9D4";
    # };
  };

  # packages
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    go
    ghostty
    inputs.zen-browser.packages.${pkgs.system}.default
    cargo
    bottles
    git
    wget
    vesktop
    distrobox
    networkmanagerapplet
    hyprpanel
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm = lib.mkIf config.hyprland.enable {
        enable = true;
        wayland = true;
      };
    };
    printing.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
      {
        from = 8080;
        to = 8085;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # network
  networking.networkmanager.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
    settings.General.Disable = "Headset"; # to disable headphones micro
    settings.Policy.AutoEnable = true; # to disable headphones micro
  };

  # bootloader
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 10;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "24.05";
}
