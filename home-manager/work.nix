{pkgs, ...}:{
  vpnmtt = pkgs.writeShellScriptBin "vpnmtt" ''
    sudo openconnect vpn.mtt.ru --user=avsokolov --authgroup=MTT_RemoteAccess
  '';
}
