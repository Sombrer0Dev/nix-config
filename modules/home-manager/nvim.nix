{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  helpers = config.lib.nixvim;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    luaLoader.enable = true;
    # options = {
    #   number = true;
    #   relativenumber = true;
    #   termguicolors = true;
    #   completeopt = "menu,menuone,noselect";
    #   mapleader = " ";
    # };
    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      completeopt = [
        "menuone"
        "noselect"
        "noinsert"
      ];
      signcolumn = "yes";
      mouse = "a";
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      expandtab = true;
      tabstop = 4;
      shiftwidth = 2;
      softtabstop = 0;
      smarttab = true;
      clipboard = {
        providers.wl-copy.enable = true; # Use wl-copy for wayland and xsel for Xorg
        register = "unnamedplus";
      };
      encoding = "utf-8";
      fileencoding = "utf-8";
      undofile = true;
      swapfile = true;
      backup = false;
      autoread = true;
      ruler = true;
      scrolloff = 5;
      diagnostics = {
        update_in_insert = true;
        severity_sort = true;
        float = {
          border = "rounded";
        };
        jump = {
          severity.__raw = "vim.diagnostic.severity.WARN";
        };
      };
      userCommands = {
        Q.command = "q";
        Q.bang = true;
        Wq.command = "q";
        Wq.bang = true;
        WQ.command = "q";
        WQ.bang = true;
        W.command = "q";
        W.bang = true;
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    extraPackages = with pkgs; [
      # LSP
      pyright
      clang-tools
      nil
      lua-language-server
      typescript-language-server
      gopls
      rust-analyzer
      marksman

      # Formatters
      black
      clang-tools
      nixfmt
      nodePackages.prettier
      gofumpt
      rustfmt
    ];
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    # LSP
    lsp = {
      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gD";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          action = helpers.mkRaw "function() vim.diagnostic.jump({ count=-1, float=true }) end";
          key = "]d";
        }
        {
          action = helpers.mkRaw "function() vim.diagnostic.jump({ count=1, float=true }) end";
          key = "[d";
        }
      ];
    };
    plugins.lsp = {
      enable = true;
      servers = {
        pyright.enable = true;
        clangd.enable = true;
        nil_ls.enable = true;
        jsonls.enable = true;
        lua_ls = {
          enable = true;
          settings.Lua.diagnostics.globals = [ "vim" ];
        };
        ts_ls.enable = true;
        gopls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        marksman.enable = true;
      };
    };

    plugins.luasnip = {
      enable = true;
      fromLua = [ { } ];
      settings = {
        update_events = [
          "TextChanged"
          "TextChangedI"
        ];
        delete_check_events = "TextChanged";
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
        ext_opts = {
          "__rawKey__require('luasnip.util.types').choiceNode".active.virt_text = [
            [
              "󱥸"
              "Special"
            ]
          ];
          "__rawKey__require('luasnip.util.types').insertNode".active.virt_text = [
            [
              ""
              "Boolean"
            ]
          ];
        };
      };
    };

    plugins.blink-pairs = {
      enable = true;
      settings.highlights.groups = [
        "BlinkPairsOrange"
        "BlinkPairsPurple"
        "BlinkPairsBlue"
        "BlinkPairsCyan"
        "BlinkPairsYellow"
        "BlinkPairsGreen"
      ];
    };

    plugins.blink-ripgrep = {
      enable = true;
    };
    plugins.blink-cmp = {
      enable = true;
      luaConfig.pre = ''
        local source_dedup_priority = { "lsp", "path", "snippets", "buffer", "ripgrep" }
        local show_orig = require("blink.cmp.completion.list").show
        require("blink.cmp.completion.list").show = function(ctx, items_by_source)
        	local seen = {}
        	for _, source in ipairs(source_dedup_priority) do
        		if items_by_source[source] then
        			items_by_source[source] = vim.tbl_filter(function(item)
        				local did_seen = seen[item.label]
        				seen[item.label] = true
        				return not did_seen
        			end, items_by_source[source])
        		end
        	end
        	return show_orig(ctx, items_by_source)
        end
      '';
      settings = {
        completion = {
          documentation.auto_show = true;
          list.max_items = 20;
          menu.draw.treesitter = [ "lsp" ];
        };
        snippets.preset = "luasnip";
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "ripgrep"
            # "copilot"
          ];
          providers = {
            snippets.opts.show_autosnippets = false;
            # copilot = {
            #   async = true;
            #   module = "blink-copilot";
            #   name = "Copilot";
            # };
            ripgrep = {
              module = "blink-ripgrep";
              name = "Ripgrep";
            };
          };
        };
      };
    };

    # Conform (formatters)
    plugins.conform-nvim = {
      enable = true;
      formattersByFt = {
        python = [ "black" ];
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
        nix = [ "nixpkgs_fmt" ];
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        json = [ "prettier" ];
        markdown = [ "prettier" ];
        go = [ "gofumpt" ];
        rust = [ "rustfmt" ];
      };
      formatOnSave.lspFallback = true;
    };

    #   # Git
    plugins.gitsigns.enable = true;
    plugins.neogit.enable = true;

    #   # Tmux navigator
    plugins.tmux-navigator.enable = true;
    plugins.which-key = {
      enable = true;
    };
  };
}
