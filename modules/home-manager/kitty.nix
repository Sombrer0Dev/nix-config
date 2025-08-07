{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+0" = "change_font_size all 0";
      # "ctrl+space>enter" = "new_window";
      # "ctrl+space>x" = "close_window";
      # "ctrl+space>h" = "kitty_scrollback_nvim";
      # "ctrl+space>g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
    };

    # actionAliases = {
    #   "kitty_scrollback_nvim" =
    #     "kitten /home/arsokolov/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";
    # };
    # extraConfig = ''
    #   map alt+j neighboring_window down
    #   map alt+k neighboring_window up
    #   map alt+h neighboring_window left
    #   map alt+l neighboring_window right
    #
    #   # Unset the mapping to pass the keys to neovim
    #   map --when-focus-on var:IS_NVIM alt+j
    #   map --when-focus-on var:IS_NVIM alt+k
    #   map --when-focus-on var:IS_NVIM alt+h
    #   map --when-focus-on var:IS_NVIM alt+l
    #
    #   # the 3 here is the resize amount, adjust as needed
    #   map alt+shift+j kitten relative_resize.py down  3
    #   map alt+shift+k kitten relative_resize.py up    3
    #   map alt+shift+h kitten relative_resize.py left  3
    #   map alt+shift+l kitten relative_resize.py right 3
    #
    #   map --when-focus-on var:IS_NVIM alt+shift+j
    #   map --when-focus-on var:IS_NVIM alt+shift+k
    #   map --when-focus-on var:IS_NVIM alt+shift+h
    #   map --when-focus-on var:IS_NVIM alt+shift+l
    # '';
    settings = {

      shell = "tmux new-session -A -s nix";
      # shell = "${pkgs.zsh}/bin/zsh";
      enabled_layouts = "fat:bias=50;full_size=1;mirrored=false";

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

      allow_remote_control = true;
      listen_on = "unix:@mykitty";

      background_opacity = 0.7;
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
    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
