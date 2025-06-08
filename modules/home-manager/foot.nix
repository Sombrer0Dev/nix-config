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
      colors = {
        # alpha = 0.8;
        background = "16181a";
        foreground = "ffffff";

        ## Normal/regular colors (color palette 0-7)
        regular0 = "16181a"; # black
        regular1 = "ff6e5e"; # red
        regular2 = "5eff6c"; # green
        regular3 = "f1ff5e"; # yellow
        regular4 = "5ea1ff"; # blue
        regular5 = "bd5eff"; # magenta
        regular6 = "5ef1ff"; # cyan
        regular7 = "ffffff"; # white

        ## Bright colors (color palette 8-15)
        bright0 = "3c4048"; # bright black
        bright1 = "ff6e5e"; # bright red
        bright2 = "5eff6c"; # bright green
        bright3 = "f1ff5e"; # bright yellow
        bright4 = "5ea1ff"; # bright blue
        bright5 = "bd5eff"; # bright magenta
        bright6 = "5ef1ff"; # bright cyan
        bright7 = "ffffff"; # bright white

      };
    };
  };
}
