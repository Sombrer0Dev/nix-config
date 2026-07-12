{ pkgs, ... }:
{
  programs.amnezia-vpn = {
    enable = true;
    # tunMode = true;
  };
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
