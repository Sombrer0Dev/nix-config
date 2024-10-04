local vo = vim.opt_local
vo.tabstop = 2
vo.shiftwidth = 2
vo.softtabstop = 2

local ht = require("haskell-tools")
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
require("legendary").keymaps({
	{ "<space>cl", vim.lsp.codelens.run, description = "CodeLens" },
	{ "<space>chs", ht.hoogle.hoogle_signature, description = "Hoogle Sinature" },
	-- Evaluate all code snippets
	{ "<space>che", ht.lsp.buf_eval_all, description = "Evaluate all code snippets" },
	-- Toggle a GHCi repl for the current package
	{ "<leader>chr", ht.repl.toggle, description = "Toggle REPl for current project" },
	-- Toggle a GHCi repl for the current buffer
	{
		"<leader>chR",
		function()
			ht.repl.toggle(vim.api.nvim_buf_get_name(0))
		end,
		description = "Toggle REPL for current buffer",
	},
	{ "<leader>chq", ht.repl.quit, description = "Quit REPL" },
})
local wk = require("which-key")
wk.add({
	{ "<leader>c", group = "Coding" },
	{ "<leader>ch", group = "Helper" },
	-- { "<leader>ct", group = "Tests" },
})
