return {
	"neogit",
	enabled = nixCats("general") or false,
	event = "DeferredUIEnter",
	after = function(plugin)
		local neogit = require("neogit")
		local wk = require("which-key")

		neogit.setup({
			{
				-- ascii | unicode
				graph_style = "unicode",
				integrations = { fzf_lua = true },
			},
		})

		wk.add({
			{ "<leader>g<Enter>", "<cmd>Neogit kind=replace<cr>", desc = "NeoGit" },
		})
	end,
}
