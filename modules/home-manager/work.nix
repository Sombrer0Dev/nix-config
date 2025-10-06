{ pkgs, ... }:
let
  # vpnpt= pkgs.writeShellScriptBin "vpnpt" ''
  #   sudo openconnect vpn.mtt.ru --user=avsokolov --authgroup=MTT_RemoteAccess
  # '';
in
{
  home.packages = [
    # vpnpt
    pkgs.mattermost-desktop
    pkgs.networkmanager-openvpn
    pkgs.openvpn
  ];
}
