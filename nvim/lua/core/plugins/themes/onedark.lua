require("onedarkpro").setup({
	colors = require('core.plugins.themes.c_onedark.colors'),
	highlights = require("core.plugins.themes.c_onedark.highlights"),
	styles = {
		comments = "italic",
		methods = "bold",
		functions = "bold",
	},
	options = {
		transparency = false, -- Use a transparent background?
		terminal_colors = true, -- Use the colorscheme's colors for Neovim's :terminal?
		highlight_inactive_windows = true, -- When the window is out of focus, change the normal background?
	},
})

vim.cmd("colorscheme onedark")
