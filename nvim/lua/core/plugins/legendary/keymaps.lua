local M = {}

function M.default_keymaps()
	---@param options { forward: boolean }
	local function qfjump(options)
		return function()
			require("demicolon.jump").repeatably_do(function(opts)
				local direction = (opts.forward == nil or opts.forward) and "next" or "previous"
				pcall(vim.cmd, "c" .. direction)
			end, options)
		end
	end

	local function djump(options)
		return function()
			require("demicolon.jump").repeatably_do(function(opts)
				if opts.forward == nil or opts.forward then
					pcall(vim.diagnostic.jump, { diagnostic = vim.diagnostic.get_next() })
				else
					pcall(vim.diagnostic.jump, { diagnostic = vim.diagnostic.get_prev() })
				end
			end, options)
		end
	end

	local function git_jump(options)
		return function()
			require("demicolon.jump").repeatably_do(function(opts)
				local direction = (opts.forward == nil or opts.forward) and "next" or "prev"
				pcall(vim.cmd, "Gitsigns " .. direction .. "_hunk")
			end, options)
		end
	end

	return {
		{ "<ESC>", "<C-\\><C-n>", mode = "t" },

		{ "<ESC>", "<cmd>noh<CR>", mode = "n" },

		-- allow moving the cursor through wrapped lines using j and k,
		{ "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true }, mode = { "n", "v" } },
		{ "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true }, mode = { "n", "v" } },

		{ "<leader>mp", "<cmd>Precognition toggle<cr>", mode = "n" },
		-- { "<leader>mh", "<cmd>Hardtime toggle<cr>", mode = "n" },
		{ "n", "nzzzv", mode = "n" },
		{ "N", "Nzzzv", mode = "n" },

		-- better indenting
		{ "<", "<gv", mode = "v" },
		{ ">", ">gv", mode = "v" },
		{ "J", ":m '>+1<CR>gv=gv", mode = "v" },
		{ "K", ":m '<-2<CR>gv=gv", mode = "v" },
		-- paste over currently selected text without yanking it
		{ "p", '"_dp', mode = "x" },
		{ "P", '"_dP', mode = "x" },

		-- Diagnostic keymaps
		{
			"[d",
			qfjump({ forward = true }),
			description = "Go to previous diagnostic message",
			mode = "n",
		},
		{
			"]d",
			qfjump({ forward = false }),
			description = "Go to next diagnostic message",
			mode = "n",
		},
		{ "<leader>e", vim.diagnostic.open_float, description = "Floating diagnostic", mode = "n" },

		{
			"[c",
			function()
				vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() })
			end,
			description = "Go to previous diagnostic message",
			mode = "n",
		},
		{
			"]c",
			function()
				vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_next() })
			end,
			description = "Go to next diagnostic message",
			mode = "n",
		},
		{
			"]q",
			qfjump({ forward = true }),
			description = "Next qf entry",
		},
		{
			"[q",
			qfjump({ forward = false }),
			description = "Previous qf entry",
		},
		{ "<leader>qd", vim.diagnostic.setqflist, description = "Open diagnostics list" },
		{ "<leader>qg", "<cmd>Gitsigns setqflist<cr>", description = "Open git list" },

		-- Search for 'FIXME', 'HACK', 'TODO', 'NOTE'
		{
			"<leader>qt",
			function()
				require("utils.functions").search_todos()
			end,
			description = "List TODOs",
		},

		-- LSP hover and fold preview
		{ "K", vim.lsp.buf.hover, description = "Hover doc or preview fold", mode = "n" },
		{ "<leader>a", "<cmd>Grapple toggle<cr>", description = "Grapple mark" },
		{ "<C-e>", "<cmd>Grapple open_tags<cr>", description = "Grapple open tags" },
		{ "<C-n>", "<cmd>Grapple select index=1<cr>" },
		{ "<C-t>", "<cmd>Grapple select index=2<cr>" },
		{ "<C-l>", "<cmd>Grapple select index=3<cr>" },
		{ "<C-p>", "<cmd>Grapple select index=4<cr>" },
		{
			"<leader>h",
			function()
				require("harpeek").toggle({
					winopts = {
						row = vim.api.nvim_win_get_height(0) - 15,
						border = "none",
					},
				})
			end,
			description = "Harpeek",
		},
	}
end

return M
