{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.tmux}/bin/tmux";
      shell.args = [ "new-session" "-A" "-s" "general"];
      window.padding = {
        x = 5;
        y = 5;
      };

      font = {
        normal={
          family = "MonaspiceKr Nerd Font";
          style = "Regular" ;
        };
        bold={
          family = "MonaspiceKr Nerd Font";
          style = "Bold" ;
        };
        italic={
          family = "MonaspiceXe Nerd Font";
          style = "Italic" ;
        };
        bold_italic={
          family = "MonaspiceXe Nerd Font";
          style = "BoldItalic" ;
        };
        # size = 12;
      };

      colors = {
        primary = {
          background = "#161616";
          foreground = "#f2f4f8";
          dim_foreground = "#b6b8bb";
          bright_foreground = "#f9fbff";
        };
        cursor = {
          text = "#f2f4f8";
          cursor = "#b6b8bb";
        };
        vi_mode_cursor = {
          text = "#f2f4f8";
          cursor = "#33b1ff";
        };
        search = {
          matches = {
            foreground = "#f2f4f8";
            background = "#525253";
          };
          focused_match = {
            foreground = "#f2f4f8";
            background = "#3ddbd9";
          };
        };
        footer_bar = {
          foreground = "#f2f4f8";
          background = "#353535";
        };
        hints = {
          start = {
            foreground = "#f2f4f8";
            background = "#3ddbd9";
          };
          end = {
            foreground = "#f2f4f8";
            background = "#353535";
          };
        };
        selection = {
          text = "#f2f4f8";
          background = "#2a2a2a";
        };
        normal = {
          black = "#282828";
          red = "#ee5396";
          green = "#25be6a";
          yellow = "#08bdba";
          blue = "#78a9ff";
          magenta = "#be95ff";
          cyan = "#33b1ff";
          white = "#dfdfe0";
        };
        bright = {
          black = "#484848";
          red = "#f16da6";
          green = "#46c880";
          yellow = "#2dc7c4";
          blue = "#8cb6ff";
          magenta = "#c8a5ff";
          cyan = "#52bdff";
          white = "#e4e4e5";
        };
        dim = {
          black = "#222222";
          red = "#ca4780";
          green = "#1fa25a";
          yellow = "#07a19e";
          blue = "#6690d9";
          magenta = "#a27fd9";
          cyan = "#2b96d9";
          white = "#bebebe";
        };
        # indexed_colors = {
        #   index = 16;
        #   color = "#3ddbd9";
        # };
        # indexed_colors = {
        #   index = 17;
        #   color = "#ff7eb6";
        # };
      };
    };
  };
}
