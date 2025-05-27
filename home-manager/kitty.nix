{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "tmux new-session -A -s nix";

      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      # window_padding_width = 10;
      cursor_trail = 1;
      font_size = 11;
      window_padding_width = 5;
      font_family = "MonaspiceKr Nerd Font";
      bold_font = "MonaspiceKr Nerd Font Bold";
      italic_font = "MonaspiceKr Nerd Font Italic";
      bold_italic_font = "MonaspiceKr Nerd Font Bold Italic";
      symbol_map = "U+0400-U+04FF Source Sans Pro"; # Cyrillic range
      allow_hidpi = true;

      background_opacity = 0.9;
      background = "#16181a";
      foreground = "#ffffff";
      cursor = "#ffffff";
      cursor_text_color = "#16181a";
      selection_background = "#3c4048";
      color0 = "#16181a";
      color8 = "#3c4048";
      color1 = "#ff6e5e";
      color9 = "#ff6e5e";
      color2 = "#5eff6c";
      color10 = "#5eff6c";
      color3 = "#f1ff5e";
      color11 = "#f1ff5e";
      color4 = "#5ea1ff";
      color12 = "#5ea1ff";
      color5 = "#bd5eff";
      color13 = "#bd5eff";
      color6 = "#5ef1ff";
      color14 = "#5ef1ff";
      color7 = "#ffffff";
      color15 = "#ffffff";
      selection_foreground = "#ffffff";
      active_tab_foreground = "#000000";
      active_tab_background = "#ffbd5e";
      inactive_tab_foreground = "#ffffff";
      inactive_tab_background = "#16181a";
    };
  };
}
