require("cyberdream").setup({
	-- Enable transparent background
	transparent = vim.g.config.theme.cyberdream.transparent,

	-- Enable italics comments
	italic_comments = true,

	-- Replace all fillchars with ' ' for the ultimate clean look
	hide_fillchars = false,

	-- Modern borderless telescope theme
	borderless_telescope = true,

	-- Set terminal colors used in `:terminal`
	terminal_colors = true,

	theme = {
		variant = vim.g.config.theme.cyberdream.dark and "dark" or "light", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
		highlights = {
			-- Highlight groups to override, adding new groups is also possible
			-- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

			-- Example:
			Comment = { fg = "#7b8496", bg = "NONE", italic = true },
			CursorLineNr = { fg = "#16181A", bg = "#656C7B" },
			CursorLine = { fg = "NONE", bg = "NONE" },

			-- Complete list can be found in `lua/cyberdream/theme.lua`
		},

		-- Override a highlight group entirely using the color palette
		-- overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
		-- 	return {
		-- 	    CursorLine = { bg = "#7B8496"},
		-- 	}
		-- end,

		-- Override a color entirely
		colors = {
			-- For a list of colors see `lua/cyberdream/colours.lua`
			-- Example:
			-- green = "#00ff00",
			-- magenta = "#ff00ff",
		},
	},

	-- Disable or enable colorscheme extensions
	extensions = {
		cmp = true,
		fzflua = true,
		dashboard = true,
		indentblankline = true,
		lazy = true,
		leap = true,
		hop = true,
		noice = true,
		whichkey = true,
		notify = true,
		mini = true,
		grapple = false,
		gitsigns = true,
	},
})

--2d3036
vim.cmd("colorscheme cyberdream")
