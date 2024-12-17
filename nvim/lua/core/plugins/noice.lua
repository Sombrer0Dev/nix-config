local M = {
	"folke/noice.nvim",
	enabled = false,
	dependencies = {
		"rcarriga/nvim-notify",
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					opts = { skip = true },
				},
			},
			markdown = {},
			presets = {
				bottom_search = true,
				long_message_to_split = true,
				lsp_doc_border = true,
				command_palette = false,
				inc_rename = true,
			},
			cmdline = {
				view = "cmdline",
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
		})
	end,
}

return M
