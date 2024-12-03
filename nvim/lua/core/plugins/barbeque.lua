return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	enabled = false,
	dependencies = {
		"SmiteshP/nvim-navic",
	},
	opts = {
		-- configurations go here
		exclude_filetypes = { "netrw", "toggleterm" },
	},
}
