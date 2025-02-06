return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader>re", mode = "x", "<CMD>Refactor extract<CR>", desc = "Extract function" },
		{ "<leader>rf", mode = "x", "<CMD>Refactor extract_to_file<CR>", desc = "Extract function to file" },
		{ "<leader>rv", mode = "x", "<CMD>Refactor extract_var<CR>", desc = "Extract variable" },
		{ "<leader>rI", mode = "x", "<CMD>Refactor inline_func<CR>", desc = "Inline function" },

		{ "<leader>ri", mode = { "n", "x" }, "<CMD>Refactor inline_var<CR>", desc = "Inline variable" },

		{ "<leader>rb", mode = "x", "<CMD>Refactor extract_block<CR>", desc = "Extract code block" },
		{ "<leader>rB", mode = "x", "<CMD>Refactor extract_block_to_file<CR>", desc = "Extract code block to file" },
	},
	lazy = false,
	config = function()
		require("refactoring").setup({
			prompt_func_return_type = {
				go = false,
				java = false,

				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			prompt_func_param_type = {
				go = false,
				java = false,

				cpp = false,
				c = false,
				h = false,
				hpp = false,
				cxx = false,
			},
			printf_statements = {},
			print_var_statements = {},
			show_success_message = true, -- shows a message with information about the refactor on success
			-- i.e. [Refactor] Inlined 3 variable occurrences
		})
	end,
}
