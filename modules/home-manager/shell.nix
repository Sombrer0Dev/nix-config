{ pkgs, lib, ... }:
let
  aliases = {
    "ll" = "eza";
    "l" = "ls";

    ":q" = "exit";
    "q" = "exit";

    "gs" = "git status";
    "gb" = "git branch";
    "gsw" = "git switch";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
    "gall" = "git add . && git commit";

    "del" = "trash put";
    "ls" = "eza -l";
    "tree" = "eza -T";
    "clear" = "clear && tput cup $(tput lines) 0";
    "work-add" = "worktree $(_fzf_git_branches)";
  };
in
{
  options.shellAliases =
    with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = { };
    };

  config = {
    home.packages = with pkgs; [
      zsh-forgit
      zsh-fzf-history-search
      zsh-fzf-tab
    ];
    programs = {
      zsh = {
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
        zplug = {
          enable = true;
          plugins = [
            {
              name = "zsh-users/zsh-completions";
            }
          ];
        };
        shellAliases = aliases;
        autocd = true;
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initContent = ''
          SHELL=${pkgs.zsh}/bin/zsh

          if command -v nix-your-shell > /dev/null; then
            nix-your-shell zsh | source /dev/stdin
          fi

          source ~/.p10k.zsh

          # Keybindings
          bindkey -e
          bindkey "^[[1~" beginning-of-line
          bindkey "^[[4~" end-of-line
          bindkey "^[[3~" delete-char

          # Completion
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*:git-checkout:*' sort false
          zstyle ':completion:*:descriptions' format '[%d]'
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'
          zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
          zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          zstyle ':fzf-tab:*' switch-group '<' '>'
          # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

          # zvm_after_init() {
          source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
          if [ -n "$TMUX" ]; then
            precmd() { tmux rename-window "$(tmux-tabs | cut -c -20)"; }
          fi

          # }
        '';
      };

      bash = {
        shellAliases = aliases;
        enable = true;
        initExtra = ''
          SHELL=${pkgs.bash}
        '';
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        tmux.enableShellIntegration = true;
      };
      bat = {
        enable = true;
        themes = {
          cyberdream = {
            src = pkgs.fetchFromGitHub {
              owner = "scottmckendry";
              repo = "cyberdream.nvim";
              rev = "b0e14290e737b1ae3f3cdcaf9bdcc7c3070ab88e";
              sha256 = "sha256-T+fNR3iZOosdCIb+0DaCukyVdnTUtKu4VdTwHX/5sgg=";
            };
            file = "./extras/textmate/cyberdream.tmTheme";
          };
        };
        config = {
          theme = "\"cyberdream\"";
        };
      };
    };

  };
}
