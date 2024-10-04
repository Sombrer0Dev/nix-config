local M = {}
vim.g.go_keymaps = false
vim.g.haskell_keymaps = false

function M.default_autocmds()
	return {
		{
			"FileType",
			function()
				if not vim.g.go_keymaps then
					vim.g.go_keymaps = true
					require("legendary").keymaps({
						{ "<leader>ca", "<cmd>GoCodeAction<cr>", description = "Code action" },
						{ "<leader>cl", "<cmd>GoCodeLenAct<cr>", description = "Toggle Lens" },
						{ "<leader>ce", "<cmd>GoIfErr<cr>", description = "Add if err" },
						{ "<leader>cJ", "<cmd>'<,'>GoJson2Struct<cr>", description = "Json to struct", mode = "v" },
						{ "<leader>cS", "<cmd>GoFillStruct<cr>", description = "Autofill struct" },
						{ "<leader>cha", "<cmd>GoAddTag<cr>", description = "Add tags to struct" },
						{ "<leader>chr", "<cmd>GoRMTag<cr>", description = "Remove tags to struct" },
						{ "<leader>chc", "<cmd>GoCoverage<cr>", description = "Test coverage" },
						{ "<leader>chg", "<cmd>lua require('go.comment').gen()<cr>", description = "Generate comment" },
						{ "<leader>chv", "<cmd>GoVet<cr>", description = "Go vet" },
						{ "<leader>cht", "<cmd>GoModTidy<cr>", description = "Go mod tidy" },
						{ "<leader>chi", "<cmd>GoModInit<cr>", description = "Go mod init" },
						{ "<leader>chI", "<cmd>GoImpl<cr>", description = "Go implement interface" },
						{ "<leader>ctr", "<cmd>GoTest<cr>", description = "Run tests" },
						{ "<leader>cta", "<cmd>GoAlt!<cr>", description = "Open alt file" },
						{ "<leader>cts", "<cmd>GoAltS!<cr>", description = "Open alt file in split" },
						{ "<leader>ctv", "<cmd>GoAltV!<cr>", description = "Open alt file in vertical split" },
						{ "<leader>ctu", "<cmd>GoTestFunc<cr>", description = "Run test for current func" },
						{ "<leader>ctf", "<cmd>GoTestFile<cr>", description = "Run test for current file" },
					})
					local wk = require("which-key")
					wk.add({
						{ "<leader>c", group = "Coding" },
						{ "<leader>ch", group = "Helper" },
						{ "<leader>ct", group = "Tests" },
					})
				end
			end,
			opts = {
				pattern = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
			},
		},
		{
			-- turn current line blame off in insert mode,
			-- back on when leaving insert mode
			name = "GitSignsCurrentLineBlameInsertModeToggle",
			{
				{ "InsertLeave", "InsertEnter" },
				function()
					local ok, gitsigns_config = pcall(require, "gitsigns.config")
					if not ok then
						return
					end

					local enabled = gitsigns_config.config.current_line_blame
					local mode = vim.fn.mode()
					if (mode == "i" and enabled) or (mode ~= "i" and not enabled) then
						pcall(vim.cmd --[[@as function]], "Gitsigns toggle_current_line_blame")
					end
				end,
			},
		},
	}
end

return M
