local Align = { provider = "%=" }
local Space = { provider = " " }

return {
	"rebelot/heirline.nvim",
	-- You can optionally lazy-load heirline on UiEnter
	-- to make sure all required plugins and colorschemes are loaded before setup
	-- event = "UiEnter",
	dependencies = { "SmiteshP/nvim-navic" },
	enabled = true,

	config = function()
		local colors = require("cyberdream.colors").default
		local c = require("core.plugins.heirline.components")
		require("heirline").load_colors(colors)
		require("heirline").setup({
      -- stylua: ignore start
			statusline = {
        c.ViMode, Space, c.WorkingDir, Space, c.FileName, Space, c.Git, Space, c.Diagnostics, Align,
        c.MacroRec, c.Debugger, Align,
        c.LSPNames, Space, c.Ruler, Space, c.ScrollBar
      },
			-- stylua: ignore end
			winbar = { c.Navic },
			-- tabline = { c.Navic },
			-- statuscolumn = {},
		})
	end,
}
