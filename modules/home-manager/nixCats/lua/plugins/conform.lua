vim.api.nvim_create_user_command("FormatDisable", function()
	vim.g.enable_autoformat = false
end, {
	desc = "Disable autoformat-on-save",
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.g.enable_autoformat = true
end, {
	desc = "Re-enable autoformat-on-save",
})

return {
	"conform.nvim",
	enabled = nixCats("general") or false,
	keys = {
		{ "<leader>F", desc = "Format buffer" },
	},
	-- colorscheme = "",
	after = function(plugin)
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = nixCats("lua") and { "stylua" } or nil,
				go = nixCats("go") and { "gofmt", "golint" } or nil,
				python = nixCats("py") and { "black", "ruff", "isort" } or nil,
				nix = nixCats("nix") and { "nixfmt" } or nil,
				zig = nixCats("zig") and { "zigfmt" } or nil,
			},
			format_on_save = function(_)
				if vim.g.enable_autoformat then
					return { timeout_ms = 500, lsp_fallback = true }
				end
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>F", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "[F]ormat [F]ile" })

		vim.keymap.set("n", "<leader><C-f>", function()
			if vim.g.enable_autoformat then
				vim.cmd("FormatDisable")
			else
				vim.cmd("FormatEnable")
			end
			vim.notify(
				string.format("Autoformatting %s", vim.g.enable_autoformat and "on" or "off"),
				vim.log.levels.INFO
			)
		end, { desc = "Toggle autoformat" })
	end,
}
