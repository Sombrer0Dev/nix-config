{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];
  home.packages = with pkgs; [
    xwayland-satellite # xwayland support
  ];
  programs.niri = {
    enable = true;
    settings = {
      input.keyboard.xkb.layout = "us, ru";
      binds = {
        "Mod+Enter".action.spawn = "kitty";
        "Mod+Tab".action.spawn = "noctalia-shell ipc call launcher toggle";
        "Mod+Q".action.close-window = [ ];

        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+h".action.focus-column-left = [ ];
        "Mod+l".action.focus-column-right = [ ];
        "Mod+k".action.focus-window-up = [ ];
        "Mod+j".action.focus-window-down = [ ];
      };
      spawn-at-startup = [
        { argv = [ "noctalia-shell" ]; }
      ];
    };

  };
}
