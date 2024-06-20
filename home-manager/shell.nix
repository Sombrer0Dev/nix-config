{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "db" = "distrobox";
    "tree" = "eza --tree";
    "nv" = "nvim";

    "ll" = "ls";
    "éé" = "ls";
    "és" = "ls";
    "l" = "ls";

    ":q" = "exit";
    "q" = "exit";

    "gs" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";

    "del" = "trash put";
  };
in {
  options.shellAliases = with lib; mkOption {
    type = types.attrsOf types.str;
    default = {};
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
      '';
    };

    bash = {
      shellAliases = aliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}";
    };

    fish = {
      enable = true;
      shellInit = "set -gx SHELL '${pkgs.fish}/bin/fish'";
      plugins = [
        {
          name = "pure.fish";
          src = pkgs.fetchFromGitHub {
            "owner" = "pure-fish";
            "repo" = "pure";
            "rev" = "28447d2e7a4edf3c954003eda929cde31d3621d2";
            "hash" = "sha256-8zxqPU9N5XGbKc0b3bZYkQ3yH64qcbakMsHIpHZSne4=";
          };
        }
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            "owner" = "PatrickF1";
            "repo" = "fzf.fish";
            "rev" = "8920367cf85eee5218cc25a11e209d46e2591e7a";
            "hash" = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
          };
        }
        {
          name = "autopair.fish";
          src = pkgs.fetchFromGitHub {
            "owner" = "jorgebucaran";
            "repo" = "autopair.fish";
            "rev" = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
            "hash" = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
          };
        }
        {
          name = "puffer.fish";
          src = pkgs.fetchFromGitHub {
            "owner" = "nickeb96";
            "repo" = "puffir-fish";
            "rev" = "12d062eae0ad24f4ec20593be845ac30cd4b5923";
            "hash" = "sha256-2niYj0NLfmVIQguuGTA7RrPIcorJEPkxhH6Dhcy+6Bk=";
          };
        }
      ];
    };

  };
  config.programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
