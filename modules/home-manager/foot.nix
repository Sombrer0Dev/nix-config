{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "fish -c 'tmux new-session -A -s nix'";
        font = "MonaspiceKr Nerd Font:size=9, UbuntuMono Nerd Font:size=9";
        font-bold = "MonaspiceKr Nerd Font:size=9";
        font-italic = "MonaspiceKr Nerd Font:size=9";
        font-bold-italic = "MonaspiceKr Nerd Font:size=9";
        pad = "10x10 center";
      };
    };
  };
}
