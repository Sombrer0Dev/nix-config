return {
  ft = 'md',
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
	config = function()
		require("render-markdown").setup({
			completions = { blink = { enabled = true } },
		})
	end,
}
