return {
	"nvim-lint",
	enabled = nixCats("general") or false,
	event = "FileType",
	after = function(plugin)
		require("lint").linters_by_ft = {
			go = nixCats("go") and { "golangcilint" } or nil,
			-- markdown = { "vale" },
			python = nixCats("py") and { "flake8", "pylint", "mypy" } or nil,
		}
		vim.keymap.set("n", "<leader>L", function()
			require("lint").try_lint()
		end, { desc = "lint buffer" })
	end,
}
