{ pkgs, ... }:
let
  wgu = pkgs.writeShellScriptBin "wgu" ''
    ls -1 /etc/wireguard | sed -e 's/\..*$//' | fzf | xargs wg-quick up
  '';
  wgd = pkgs.writeShellScriptBin "wgd" ''
    ls -1 /etc/wireguard | sed -e 's/\..*$//' | fzf | xargs wg-quick down
  '';
in
{
  home.packages = with pkgs; [
    wireguard-go
    wireguard-tools
    wgu
    wgd
  ];
}
