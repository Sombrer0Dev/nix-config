{ ... }:
{
  programs.nixvim.plugins.blink-cmp = {
    enable = true;
    settings = {
      completion.documentation.auto_show = true;
      fuzzy.implementation = "prefer_rust";
      keymap.preset = "default";
      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
        "ripgrep"
        "git"
      ];
      sources.providers = {
        lsp = {
          name = "LSP";
          module = "blink.cmp.sources.lsp";
          score_offset = 90;
        };
        git = {
          module = "blink-cmp-git";
          name = "git";
          score_offset = 100;
          opts = {
            commit = { };
            git_centers = {
              git_hub = { };
            };
          };
        };
        ripgrep = {
          async = true;
          module = "blink-ripgrep";
          name = "Ripgrep";
          score_offset = 100;
          opts = {
            prefix_min_len = 3;
            context_size = 5;
            max_filesize = "1M";
            project_root_marker = ".git";
            project_root_fallback = true;
            search_casing = "--ignore-case";
            additional_rg_options = { };
            fallback_to_regex_highlighting = true;
            ignore_paths = { };
            additional_paths = { };
            debug = false;
          };
        };
      };
    };
  };
  programs.nixvim.plugins.blink-indent.enable = true;
  programs.nixvim.plugins.blink-pairs.enable = true;
  programs.nixvim.plugins.blink-ripgrep.enable = true;
  programs.nixvim.plugins.blink-cmp-git.enable = true;
}
