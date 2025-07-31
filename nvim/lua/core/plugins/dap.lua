local M = {
	"mfussenegger/nvim-dap",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {

		{
			"leoluz/nvim-dap-go",
			config = true,
		},
		{
			"mfussenegger/nvim-dap-python",
			keys = {
				{
					"<leader>dPt",
					function()
						require("dap-python").test_method()
					end,
					desc = "Debug Method",
					ft = "python",
				},
				{
					"<leader>dPc",
					function()
						require("dap-python").test_class()
					end,
					desc = "Debug Class",
					ft = "python",
				},
			},
			config = function()
				require("dap-python").setup()
			end,
		},
		-- fancy UI for the debugger
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
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
	},

	config = function()
		local dap = require("dap")
		local fzf = require("fzf-lua")
		local dapui = require("dapui")

		require("which-key").add({
			{ "<F2>", dap.continue, desc = "Continue" },
			{ "<F3>", dap.step_over, desc = "Step Over" },
			{ "<F4>", dap.step_into, desc = "Step Into" },
			{ "<F5>", dap.step_out, desc = "Step Out" },

			{ "<leader>d", group = "Debug" },
			{ "<leader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
			{
				"<leader>dB",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Set Breakpoint Condition",
			},
			{
				"<leader>dC",
				function()
					dap.set_breakpoint(nil, nil, vim.fn.input("Log Point Message: "))
				end,
				desc = "Log Point Message",
			},
			{ "<leader>dc", dap.continue, desc = "Start/Continue" },
			{ "<leader>du", dapui.toggle, desc = "Toggle Debug UI" },

			{ "<leader>ds", group = "Step" },
			{ "<leader>dso", dap.step_over, desc = "Step Over" },
			{ "<leader>dsi", dap.step_into, desc = "Step Into" },
			{ "<leader>dsu", dap.step_out, desc = "Step Out" },

			{ "<leader>dr", group = "Repl" },
			{ "<leader>dro", dap.repl.open, desc = "Open" },
			{ "<leader>drl", dap.repl.run_last, desc = "Run Last" },

			{
				"<leader>df",
				function()
					fzf.fzf_exec({ "scopes", "stacks", "watches", "breakpoints", "repl", "console" }, {
						actions = {
							["default"] = function(selected)
								if not selected or #selected <= 0 then
									return
								end

								for _, sel in ipairs(selected) do
									dapui.float_element(sel, nil)
								end
							end,
						},
						winopts = {
							fullscreen = false,
							width = 0.1,
							height = 0.1,
							relative = "cursor",
							row = 1,
							col = 0,
						},
					})
				end,
				desc = "Float elements",
			},
		})
	end,
}
vim.api.nvim_set_hl(0, "red", { fg = "#ff6e5e" })

vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "red", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "C", texthl = "red", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
return M
