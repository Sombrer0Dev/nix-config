local M = {
	"folke/noice.nvim",
	enabled = true,
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
      notify = {
        -- Noice can be used as `vim.notify` so you can route any notification like other messages
        -- Notification messages have their level and other properties set.
        -- event is always "notify" and kind can be any log level as a string
        -- The default routes will forward notifications to nvim-notify
        -- Benefit of using Noice for this is the routing and consistent history view
        enabled = true,
        view = "notify",
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
