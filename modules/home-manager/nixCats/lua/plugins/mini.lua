return {
	"mini.nvim",
	enabled = nixCats("general") or false,
	event = "DeferredUIEnter",
	after = function(plugin)
		require("mini.pairs").setup()
		require("mini.comment").setup()

		MiniIcons = require("mini.icons")
		MiniIcons.setup()
		MiniIcons.mock_nvim_web_devicons()

		require("mini.ai").setup()
		require("mini.hipatterns").setup()

		require("mini.surround").setup({
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		})
	end,
}
