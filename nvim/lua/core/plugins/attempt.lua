return {
	"m-demare/attempt.nvim", -- No need to specify plenary as dependency
	keys = {
		{
			"<leader>an",
			function()
				require("attempt").new_select()
			end,
			mode = "n",
			desc = "New tmp buffer selecting ext",
		},
		{
			"<leader>ai",
			function()
				require("attempt").new_input_ext()
			end,
			mode = "n",
			desc = "New tmp buffer inputing ext",
		},
		{
			"<leader>a",
			function()
				require("attempt").run()
			end,
			mode = "n",
			desc = "Run tmp buffer",
		},
		{
			"<leader>a",
			function()
				require("attempt").run()
			end,
			mode = "n",
			desc = "Run tmp buffer",
		},
	},
	config = function()
		require("attempt").setup({
			autosave = false,
			list_buffers = true, -- This will make them show on other pickers (like :Telescope buffers)
			ext_options = { "lua", "js", "py", "cpp", "c", "sh" }, -- Options to choose from
			format_opts = { [""] = "[None]" }, -- How they'll look
		})
		local attempt = require("attempt")
		local map = vim.keymap.set

		map("n", "<leader>an", attempt.new_select) -- new attempt, selecting extension
		map("n", "<leader>ai", attempt.new_input_ext) -- new attempt, inputing extension
		map("n", "<leader>ar", attempt.run) -- run attempt
		map("n", "<leader>ad", attempt.delete_buf) -- delete attempt from current buffer
		map("n", "<leader>ac", attempt.rename_buf) -- rename attempt from current buffer
		map("n", "<leader>al", "Telescope attempt") -- search through attempts
		--or: map('n', '<leader>al', require('attempt.snacks').picker)
		--or: map('n', '<leader>al', attempt.open_select) -- use ui.select instead of telescope/snacks.nvim
	end,
}
