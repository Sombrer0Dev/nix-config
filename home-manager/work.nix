{pkgs, ...}: let
  vpnmtt = pkgs.writeShellScriptBin "vpnmtt" ''
    sudo openconnect vpn.mtt.ru --user=avsokolov --authgroup=MTT_RemoteAccess
  '';
  linphone = pkgs.linphone;
  twinkle = pkgs.twinkle;
in {
  home.packages = [ vpnmtt linphone twinkle];
}
