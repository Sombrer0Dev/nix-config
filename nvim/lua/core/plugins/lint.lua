return {
	"mfussenegger/nvim-lint",
	keys = {
    {
		"<leader>L",
		function()
			require("lint").try_lint()
		end,
		mode = "",
		desc = "lint buffer",
    },
	},
	config = function()
		require("lint").linters_by_ft = {
			markdown = { "vale" },
			python = { "flake8", "pylint", "mypy" },
		}
	end,
}
