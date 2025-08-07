{
  pkgs,
  inputs,
  username,
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
    # let nh handle it
    automatic = false;
    # dates = "daily";
    # options = "--delete-older-than 7d";
  };

  time.hardwareClockInLocalTime = true;

  # programs.ssh.startAgent = true;
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
  users.extraGroups.vborusers.members = [ "arsokolov" ];

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
    cachix
    home-manager
    neovim
    go
    inputs.zen-browser.packages.${pkgs.system}.default
    cargo
    git
    wget
    networkmanagerapplet
    sqlite

    # pycharm
    # jetbrains.pycharm-community

    # office
    # libreoffice-qt
    # jre_minimal
    # hunspell
    # hunspellDicts.en_US
    # hunspellDicts.ru_RU
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    printing.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
  };
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
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
  services.openvpn.servers = {
    officeVPN = {
      config = ''config /home/arsokolov/Documents/PTsecurity.ovpn'';
      updateResolvConf = true;
    };
  };

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

  # users
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

  # Nix Helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 3d";
    flake = "/home/arsokolov/Documents/nix-config";
  };

  system.stateVersion = "24.05";
}
