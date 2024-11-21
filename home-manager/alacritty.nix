{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.tmux}/bin/tmux";
      shell.args = [
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

      # colors = {
      #   primary = {
      #     background = "#16181a";
      #     foreground = "#ffffff";
      #   };
      #   selection = {
      #     background = "#3c4048";
      #     foreground = "#ffffff";
      #   };
      #   normal = {
      #     black = "#16181a";
      #     blue = "#5ea1ff";
      #     cyan = "#5ef1ff";
      #     green = "#5eff6c";
      #     magenta = "#bd5eff";
      #     red = "#ff6e5e";
      #     white = "#ffffff";
      #     yellow = "#f1ff5e";
      #   };
      #   bright = {
      #     black = "#3c4048";
      #     blue = "#5ea1ff";
      #     cyan = "#5ef1ff";
      #     green = "#5eff6c";
      #     magenta = "#bd5eff";
      #     red = "#ff6e5e";
      #     white = "#ffffff";
      #     yellow = "#f1ff5e";
      #   };
      #   indexed_colors = [
      #     {
      #       index = 16;
      #       color = "#ffbd5e";
      #     }
      #     {
      #       index = 17;
      #       color = "#ff6e5e";
      #     }
      #   ];
      # };
    };
  };
}
