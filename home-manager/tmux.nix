{ lib, pkgs, ... }:
let
  tmux-mighty-scroll = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "scroll";
    pluginName = "mighty-scroll";
    src = pkgs.fetchFromGitHub {
      owner = "noscript";
      repo = "tmux-mighty-scroll";
      rev = "36618744e0a84446deccec468ad5b08d7f16f985";
      hash = "sha256-HQtvUIS32QEjNAzP8oD69MNGr+HlRjLAVXewdU9alDg=";
    };
  };
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "fingers";
    pluginName = "super-fingers";
    src = pkgs.fetchFromGitHub {
      owner = "artemave";
      repo = "tmux_super_fingers";
      rev = "2771f791a03880b3653c043cff48ee81db66212b";
      hash = "sha256-GnVlV8JRKVx6muVKYvqkCSMds7IBTYp1NFEgQnnuYEc=";
    };
  };
  tmux-sessionx = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "sessionx";
    version = "20240119";

    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-sessionx";
      rev = "52b837b09f84bc39c84c018f049f801b44b5ed40";
      hash = "sha256-7JglXguOnCrt6OwnlPQ6xaNAvOhGFIFtgRRF+MD55Cs=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postPatch = ''
      substituteInPlace sessionx.tmux \
      --replace "\$CURRENT_DIR/scripts/sessionx.sh" "$out/share/tmux-plugins/sessionx/scripts/sessionx.sh"
      substituteInPlace scripts/sessionx.sh \
      --replace "/tmux-sessionx/scripts/preview.sh" "$out/share/tmux-plugins/sessionx/scripts/preview.sh"
      substituteInPlace scripts/sessionx.sh \
      --replace "/tmux-sessionx/scripts/reload_sessions.sh" "$out/share/tmux-plugins/sessionx/scripts/reload_sessions.sh"
    '';

    postInstall = ''
        chmod +x $target/scripts/sessionx.sh
        wrapProgram $target/scripts/sessionx.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            zoxide
            fzf
            gnugrep
            gnused
            coreutils
          ]
        }
      chmod +x $target/scripts/preview.sh
        wrapProgram $target/scripts/preview.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            coreutils
            gnugrep
            gnused
          ]
        }
      chmod +x $target/scripts/reload_sessions.sh
        wrapProgram $target/scripts/reload_sessions.sh \
        --prefix PATH : ${
          with pkgs;
          lib.makeBinPath [
            coreutils
            gnugrep
            gnused
          ]
        }
    '';
  };

in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    clock24 = true;

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmux-mighty-scroll

      {
        plugin = tmux-super-fingers;
        extraConfig = ''
          set -ga update-environment EDITOR
        '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          unbind e
          set -g @sessionx-bind "e"
          set -g @sessionx-zoxide-mode 'on'
        '';
      }
    ];

    extraConfig = ''
      set -g base-index 1
      setw -g pane-base-index 1
      set -as terminal-features ",alacritty*:RGB"
      set-option -g focus-events on

      # Enable mouse control (clickable windows, panes, resizable panes)
      set -g mouse on
      setw -g mouse on
      # to enable mouse scroll, see https://github.com/tmux/tmux/issues/145#issuecomment-150736967
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"


      unbind C-b
      set-option -g prefix C-Space
      bind-key C-Space send-prefix


      unbind "'"
      bind "'" split-window -v -c '#{pane_current_path}' -l 15
      bind / split-window -h -c '#{pane_current_path}' -l 50

      bind-key '"' command-prompt -p index "select-window -t ':%%'"
      unbind %

      # reload config file (change file location to your the tmux.conf you want to use)
      bind r source-file ~/.config/tmux/tmux.conf

      # Smart pane switching with awareness of Neovim splits.
      bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h'  'select-pane -L'
      bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j'  'select-pane -D'
      bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k'  'select-pane -U'
      bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l'  'select-pane -R'

      # Smart pane resizing with awareness of Neovim splits.
      bind-key -n M-H if -F "#{@pane-is-vim}" 'send-keys M-H' 'resize-pane -L 3'
      bind-key -n M-J if -F "#{@pane-is-vim}" 'send-keys M-J' 'resize-pane -D 3'
      bind-key -n M-K if -F "#{@pane-is-vim}" 'send-keys M-K' 'resize-pane -U 3'
      bind-key -n M-L if -F "#{@pane-is-vim}" 'send-keys M-L' 'resize-pane -R 3'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      bind-key -n -N 'Toggle popup window' M-t if-shell -F '#{==:#{session_name},popup}' {
          detach-client
      } {
          display-popup -d "#{pane_current_path}" -xC -yC -w 50% -h 50% -E 'tmux attach-session -t popup || tmux new-session -s popup'
      }


      # DESIGN TWEAKS

      # don't do anything when a 'bell' rings
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # clock mode
      setw -g clock-mode-colour colour1

      # copy mode
      setw -g mode-style 'fg=colour1 bg=colour18 bold'

      # pane borders
      set -g pane-border-style 'fg=colour238'
      set -g pane-active-border-style 'fg=colour1'

      # statusbar
      set -g status-position bottom
      set -g status-justify centre
      set -g status-style 'fg=colour1'
      set -g status-right '%Y-%m-%d %H:%M '
      set -g status-right-length 50
      set -g status-left-length 100

      setw -g window-status-current-style 'fg=colour0 bg=colour1 bold'
      setw -g window-status-current-format ' #I #W #F '

      setw -g window-status-style 'fg=colour1 dim'
      setw -g window-status-format ' #I #[fg=colour7]#W #[fg=colour1]#F '

      setw -g window-status-bell-style 'fg=colour2 bg=colour1 bold'

      # messages
      set -g message-style 'fg=colour2 bg=colour0 bold'
      set-option -g default-command 'tput cup "$(tput lines)"; exec "$SHELL" -l'
    '';
  };
}
