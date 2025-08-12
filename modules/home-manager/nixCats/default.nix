{
  config,
  lib,
  inputs,
  ...
}:
let
  utils = inputs.nixCats.utils;
in
{
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      enable = true;
      # nixpkgs_version = inputs.nixpkgs;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];
      # see the packageDefinitions below.
      # This says which of those to install.
      packageNames = [ "nixvim" ];

      luaPath = ./.;

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = (
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          # to define and use a new category, simply add a new list to a set here,
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              fzf
              fd
              ripgrep
              trash-cli
            ];
            lua = with pkgs; [
              lua-language-server
              stylua
            ];
            nix = with pkgs; [
              nixd
              alejandra
            ];
            py = with pkgs; [
              jedi-language-server
              black
              ruff
              debugpy
              isort

              python312
            ];
            rust = with pkgs; [
            ];
            go = with pkgs; [
              gopls
              delve
              golint
              golangci-lint
              gotools
              go-tools
              go
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            general = with pkgs.vimPlugins; [
              # lazy loading isnt required with a config this small
              # but as a demo, we do it anyway.
              lze
              lzextras
              fzf-lua
              cyberdream-nvim
              vim-sleuth
              vim-CtrlXA
              vim-repeat
              which-key-nvim
            ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            go = with pkgs.vimPlugins; [
              nvim-dap-go
            ];
            py = with pkgs.vimPlugins; [
              nvim-dap-python
            ];
            rust = with pkgs.vimPlugins; [
            ];
            lua = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
            general = with pkgs.vimPlugins; [
              pkgs.neovimPlugins.neogit
              pkgs.neovimPlugins.starlite
              pkgs.neovimPlugins.blink-tmux
              pkgs.neovimPlugins.oil-git-nvim
              plenary-nvim
              noice-nvim
              nvim-notify
              nui-nvim
              oil-nvim
              quicker-nvim
              render-markdown-nvim
              smart-splits-nvim
              friendly-snippets
              blink-ripgrep-nvim
              luasnip
              barbecue-nvim
              nvim-bqf
              git-conflict-nvim
              dial-nvim
              demicolon-nvim
              flit-nvim
              inc-rename-nvim
              incline-nvim
              indent-blankline-nvim
              leap-nvim
              nvim-nio
              neotest
              neotest-python
              mini-nvim
              promise-async
              nvim-ufo
              treesj
              nvim-lspconfig
              vim-startuptime
              blink-cmp
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
              lualine-nvim
              lualine-lsp-progress
              gitsigns-nvim
              nvim-lint
              conform-nvim
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
              nvim-autopairs
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [ ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            # test = {
            #   CATTESTVAR = "It worked!";
            # };
          };

          # categories of the function you would have passed to withPackages
          python3.libraries = {
            # test = [ (_:[]) ];
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            # test = [
            #   '' --set CATTESTVAR2 "It worked again!"''
            # ];
          };
        }
      );

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nixvim =
          { pkgs, name, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              # unwrappedCfgPath = "/path/to/here";
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [
                "vi"
                # "nixvim"
              ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            # and a set of categories that you want
            categories = {
              general = true;
              lua = true;
              nix = true;
              zig = false;
              rust = false;
              go = false;
            };
            # anything else to pass and grab in lua with `nixCats.extra`
            extra = {
              nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
            };
          };
      };
    };
  };
}
