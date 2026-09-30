{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "${pkgs.tmux}/bin/tmux";
      terminal.shell.args = [
        "new-session"
        "-A"
        "-s"
        "nix"
      ];
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        # opacity = 0.7;
      };

      font = {
        normal = {
          family = "MonaspiceKr Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MonaspiceKr Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MonaspiceXe Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MonaspiceXe Nerd Font";
          style = "BoldItalic";
        };
        # size = 12;
      };
    };
  };
}
