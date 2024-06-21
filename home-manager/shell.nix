{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "tree" = "eza --tree";

    "ll" = "ls";
    "l" = "ls";

    ":q" = "exit";
    "q" = "exit";

    "gs" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
    "gall" = "git add . && git commit";

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
      shellAliases = aliases;
      interactiveShellInit = ''
        nix-your-shell fish | source
        direnv hook fish | source
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
    enableBashIntegration = true;
  };
}
