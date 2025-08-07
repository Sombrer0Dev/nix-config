return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "onsails/lspkind-nvim" },
		},
		opts = {
			inlay_hints = true,
		},
		config = function()
			require("core.plugins.lsp.lsp")
		end,
	},
}
