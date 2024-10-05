local icons = require("utils.icons")
local M = {
	"folke/which-key.nvim",
	opts = {
    preset = 'modern',
    delay=500,
		icons = {
      mappings=false,
			breadcrumb = icons.arrows.DoubleArrowRight, -- symbol used in the command line area that shows your active key combo
			separator = icons.arrows.SmallArrowRight, -- symbol used between a key and it's label
			group = icons.ui.List.." ", -- symbol prepended to a group
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
