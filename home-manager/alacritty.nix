{
  pkgs,
  lib,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.tmux}/bin/tmux";
      shell.args = [ "new-session" "-A" "-s" "general"];
    };
  };
}
