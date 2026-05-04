{
  pkgs,
  ...
}:
let
  gpu-pkgs = with pkgs; [

    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];
in
{
  config = {
    # opengl
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr
        rocmPackages.rocm-runtime
        rocmPackages.rocm-device-libs
      ];
    };
    hardware.amdgpu.opencl.enable = true;
    environment.systemPackages =
      with pkgs;
      gpu-pkgs
      ++ [
        mangohud
        protonup-ng
      ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/arsokolov/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
