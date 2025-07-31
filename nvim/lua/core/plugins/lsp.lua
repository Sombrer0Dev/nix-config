return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "onsails/lspkind-nvim" },
			"williamboman/mason.nvim",
		},
		opts = {
			inlay_hints = true,
		},
		config = function()
			require("core.plugins.lsp.lsp")
		end,
	},
}
