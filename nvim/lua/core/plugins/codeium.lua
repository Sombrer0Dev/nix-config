return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
      tools = {language_server = "/etc/profiles/per-user/arsokolov/bin/codeium_language_server"},
    })
	end,
}
