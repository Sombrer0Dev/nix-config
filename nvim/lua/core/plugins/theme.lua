local themes = {
	nightfox = {
		"EdenEast/nightfox.nvim",
		config = function()
			require("core.plugins.themes.nightfox")
		end,
	},
	tundra = {
		"sam4llis/nvim-tundra",
		config = function()
			require("core.plugins.themes.tundra")
		end,
	},
	tokyonight = {
		"folke/tokyonight.nvim",
		branch = "main",
		config = function()
			require("core.plugins.themes.tokyonight")
		end,
	},
	kanagawa = {
		"rebelot/kanagawa.nvim",
		config = function()
			require("core.plugins.themes.kanagawa")
		end,
	},
	oxocarbon = {
		"nyoom-engineering/oxocarbon.nvim",
		config = function()
			require("core.plugins.themes.oxocarbon")
		end,
	},
	catppuccin = {
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("core.plugins.themes.catppuccin")
		end,
	},
	cyberdream = {
		"scottmckendry/cyberdream.nvim",
		config = function()
			require("core.plugins.themes.cyberdream")
		end,
	},
	onedark = {
		"olimorris/onedarkpro.nvim",
		config = function()
			require("core.plugins.themes.onedark")
		end,
	},
	rosepine = {
		"rose-pine/neovim",
		config = function()
			require("core.plugins.themes.rosepine")
		end,
	},
}

local selectedTheme = themes[vim.g.config.theme.name]

return selectedTheme
