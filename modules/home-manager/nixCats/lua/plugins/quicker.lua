return {
	{
		"quicker.nvim",
		event = "DeferredUIEnter",
		enabled = nixCats("general") or false,
		keys = {
			{
				"<leader>qq",
				function()
					require("quicker").toggle({})
				end,
				desc = "Toggle [Q]uickfix",
			},
			{
				"<leader>ql",
				function()
					require("quicker").toggle({ loclist = true })
				end,
				desc = "Toggle [L]oclist",
			},
			{
				"<leader>qQ",
				function()
					vim.fn.setqflist({}, "a", {
						items = {
							{
								bufnr = vim.api.nvim_get_current_buf(),
								lnum = vim.api.nvim_win_get_cursor(0)[1],
								text = vim.api.nvim_get_current_line(),
							},
						},
					})
				end,
				desc = "Add to [Q]uickfix",
			},
		},
		after = function()
			require("quicker").setup()
		end,
	},
}
