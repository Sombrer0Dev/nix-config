{pkgs, ...}:{
  home.packages = with pkgs; [ wireguard-go wireguard-tools ];
}

