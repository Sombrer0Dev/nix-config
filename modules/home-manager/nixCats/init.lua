-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("options")
require("autocmds")
require("keymap")
require("colorscheme")

require("lze").load({
	{ import = "plugins" },
})

require("plugins.lsp")
