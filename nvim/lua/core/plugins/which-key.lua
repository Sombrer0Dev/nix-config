local icons = require("utils.icons")
local M = {
	"folke/which-key.nvim",
	opts = {
		icons = {
      mappings=false,
			breadcrumb = icons.arrows.DoubleArrowRight, -- symbol used in the command line area that shows your active key combo
			separator = icons.arrows.SmallArrowRight, -- symbol used between a key and it's label
			group = icons.ui.List.." ", -- symbol prepended to a group
		},
		layout = {
			height = { min = 3, max = 25 }, -- min and max height of the columns
			width = { min = 5, max = 50 }, -- min and max width of the columns
			spacing = 10, -- spacing between columns
			align = "center", -- align columns left, center or right
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>c", group = "Code",},
			{ "<leader>d", group = "Debug",},
			{ "<leader>f", group = "Fzf",},
			{ "<leader>l", group = "LSP",},
			{ "<leader>m", group = "Misc",},
			{ "<leader>q", group = "QuickFix"},
			{ "<leader>t", group = "Test",},
		})
	end,
}

return M
