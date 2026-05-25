{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";

      # Layout
      enabled_layouts = "fat:bias=50;full_size=1;mirrored=false";

      # Behavior
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      allow_remote_control = true;
      listen_on = "unix:@mykitty";

      # Font
      font_family = "MonaspiceKr Nerd Font";
      bold_font = "MonaspiceKr Nerd Font Bold";
      italic_font = "MonaspiceKr Nerd Font Italic";
      bold_italic_font = "MonaspiceKr Nerd Font Bold Italic";
      font_size = 11;

      symbol_map = "U+0400-U+04FF Source Sans Pro";

      # UI
      window_padding_width = 5;
      cursor_trail = 1;

      # Colors (your theme preserved)
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
    keybindings = {
      # --- SPLITS ---
      "alt+/" = "launch --location=vsplit";
      "alt+'" = "launch --location=hsplit";

      # --- NAVIGATION ---
      "alt+h" = "neighboring_window left";
      "alt+j" = "neighboring_window down";
      "alt+k" = "neighboring_window up";
      "alt+l" = "neighboring_window right";

      # --- RESIZE ---
      "alt+shift+h" = "resize_window narrower 3";
      "alt+shift+l" = "resize_window wider 3";
      "alt+shift+j" = "resize_window shorter 3";
      "alt+shift+k" = "resize_window taller 3";

      # --- CLOSE PANE ---
      "alt+q" = "close_window";

      # --- POPUP (tmux popup replacement) ---
      "alt+t" = "launch --type=overlay";

      # # --- HINTS (super-fingers replacement) ---
      # "f" = "kitten hints";

      # --- SCROLLBACK SEARCH ---
      "alt+shift+f" = "search";

      # --- RESET FONT ---
      "alt+shift+0" = "change_font_size all 0";
    };

    extraConfig = ''
      # Better scrolling feel
      scrollback_lines 10000

      # Open scrollback in nvim (like tmux copy-mode++)
      map ctrl+shift+g launch --stdin-source=@screen_scrollback nvim

      # Copy on select (optional)
      copy_on_select yes

      # Smarter hints (URLs, paths, etc.)
      kitten_alias hints hints --alphabet "asdfghjklqwertyuiopzxcvbnm"

      # Optional: open links directly
      map ctrl+shift+o kitten hints --type=url --program=xdg-open

      # Disable alt mappings inside Neovim (important)
      map --when-focus-on var:IS_NVIM alt+h
      map --when-focus-on var:IS_NVIM alt+j
      map --when-focus-on var:IS_NVIM alt+k
      map --when-focus-on var:IS_NVIM alt+l

      map --when-focus-on var:IS_NVIM alt+shift+h
      map --when-focus-on var:IS_NVIM alt+shift+j
      map --when-focus-on var:IS_NVIM alt+shift+k
      map --when-focus-on var:IS_NVIM alt+shift+l
    '';

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
