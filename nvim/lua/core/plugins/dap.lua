local M = {
	"mfussenegger/nvim-dap",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {

		{
			"leoluz/nvim-dap-go",
			config = true,
		},
		{
			"williamboman/mason.nvim",
			enabled = not vim.g.is_nix,
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "delve" })
			end,
		},
		{
			"mfussenegger/nvim-dap-python",
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
    },
			config = function()
				local path = require("mason-registry").get_package("debugpy"):get_install_path()
				require("dap-python").setup(path .. "/venv/bin/python")
			end,
		},
		-- fancy UI for the debugger
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
      -- stylua: ignore
      opts = {},
			config = function(_, opts)
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup(opts)
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close({})
				end
			end,
		},

		-- virtual text for the debugger
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},

		-- which key integration
		{
			"folke/which-key.nvim",
			optional = true,
			opts = {
				defaults = {
					["<leader>d"] = { name = "+debug" },
				},
			},
		},

		-- mason.nvim integration
		{
			"jay-babu/mason-nvim-dap.nvim",
			enabled = not vim.g.is_nix,
			dependencies = "mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			opts = {
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
				},
			},
		},
	},

  config = function()
    local dap = require('dap')
    local fzf = require("fzf-lua")
    local dapui = require("dapui")

    require("which-key").add({
      { '<F2>', dap.continue, desc = 'Continue' },
      { '<F3>', dap.step_over, desc = 'Step Over' },
      { '<F4>', dap.step_into, desc = 'Step Into' },
      { '<F5>', dap.step_out, desc = 'Step Out' },

      { '<leader>d', group='Debug'},
      { '<leader>db', dap.toggle_breakpoint, desc='Toggle Breakpoint'},
      { '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))  end, desc='Set Breakpoint Condition'},
      { '<leader>dC', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log Point Message: ')) end, desc='Log Point Message'},
      { '<leader>dc', dap.continue, desc='Start/Continue'},
      { '<leader>du', dapui.toggle, desc='Toggle Debug UI'},

      { '<leader>ds', group='Step'},
      { '<leader>dso', dap.step_over, desc='Step Over'},
      { '<leader>dsi', dap.step_into, desc='Step Into'},
      { '<leader>dsu', dap.step_out, desc='Step Out'},

      { '<leader>dr', group='Repl'},
      { '<leader>dro', dap.repl.open, desc='Open'},
      { '<leader>drl', dap.repl.run_last, desc='Run Last'},

      { '<leader>df', function()
        fzf.fzf_exec({'scopes', 'stacks', 'watches', 'breakpoints', 'repl', 'console'}, {
          actions = {
            ['default'] = function(selected)
              if not selected or #selected <= 0 then
                return
              end

              for _, sel in ipairs(selected) do
                dapui.float_element(sel, nil)
              end
            end
          },
          winopts = {
            fullscreen = false,
            width = 0.1,
            height = 0.1,
            relative = 'cursor',
            row = 1,
            col = 0,
          },

        })
      end, desc = 'Float elements'
      }
    })
  end
}
return M
