{ pkgs, lib, ... }:
let
  aliases = {
    "ll" = "ls";
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
  };
in
{
  options.shellAliases =
    with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = { };
    };

  config.programs = {
    zsh = {
      shellAliases = aliases;
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh
        workswitch() {
          cd $(get-worktree-branch $1)
        }
        workdel() {
          delete-worktree-branch $1
        }
        workadd() {
          cd $(add-worktree-branch $1)
        }
      '';
    };

    bash = {
      shellAliases = aliases;
      enable = true;
      initExtra = ''
        SHELL=${pkgs.bash}
        workswitch() {
          cd $(get-worktree-branch $1)
        }
        workdel() {
          delete-worktree-branch $1
        }
        workadd() {
          cd $(add-worktree-branch $1)
        }
      '';
    };

    fish = {
      enable = true;
      shellAliases = aliases;
      interactiveShellInit = ''
        set SHELL ${pkgs.fish}
        nix-your-shell fish | source

        function workswitch -d "Swtich git worktree"
          cd (get-worktree-branch $argv)
        end
        function workdel -d "Delete git worktree"
          delete-worktree-branch $argv
        end
        function workadd -d "Create new git worktree"
          cd (add-worktree-branch $argv)
        end
      '';
      shellInit = "set -gx SHELL '${pkgs.fish}/bin/fish'";
      plugins = [
        {
          name = "pure.fish";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "nix.fish";
          src = pkgs.fetchFromGitHub {
            owner = "kidonng";
            repo = "nix.fish";
            rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
            hash = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
          };
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
      ];
    };

  };
  config.programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  config.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  config.programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  config.programs.bat = {
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
  # config.programs.nix-index = {
  #   enable = true;
  #   enableFishIntegration = true;
  #   enableZshIntegration = true;
  #   enableBashIntegration = true;
  # };
}
