return {
	"danymat/neogen",
	keys = {
		{ "<leader>cc", "<cmd>lua require('neogen').generate()<cr>", desc = "Generate comment" },
	},
	config = function()
		require("neogen").setup({
			enabled = true,
			snippet_engine = "luasnip",
			languages = {
				python = {
					template = {
						annotation_convention = "google_docstrings",
					},
				},
			},
		})
	end,
	-- Uncomment next line if you want to follow only stable versions
	-- version = "*"
}
