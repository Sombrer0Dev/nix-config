return {
	"smart-splits.nvim",
	event = "DeferredUIEnter",
	enabled = nixCats("general") or false,
	after = function(plugin)
		require("smart-splits").setup({})
		vim.keymap.set("n", "<S-A-h>", require("smart-splits").resize_left)
		vim.keymap.set("n", "<S-A-j>", require("smart-splits").resize_down)
		vim.keymap.set("n", "<S-A-k>", require("smart-splits").resize_up)
		vim.keymap.set("n", "<S-A-l>", require("smart-splits").resize_right)
		-- moving between splits
		vim.keymap.set("n", "<A-h>", require("smart-splits").move_cursor_left)
		vim.keymap.set("n", "<A-j>", require("smart-splits").move_cursor_down)
		vim.keymap.set("n", "<A-k>", require("smart-splits").move_cursor_up)
		vim.keymap.set("n", "<A-l>", require("smart-splits").move_cursor_right)
	end,
}
