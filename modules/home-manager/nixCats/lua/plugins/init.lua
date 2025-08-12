return {
	{ import = "plugins.which-key" },
	{ import = "plugins.blink" },
	{ import = "plugins.conform" },
	{ import = "plugins.dap" },
	{ import = "plugins.fzf" },
	{ import = "plugins.gitsigns" },
	{ import = "plugins.lazydev" },
	{ import = "plugins.lint" },
	{ import = "plugins.lualine" },
	{ import = "plugins.mini" },
	{ import = "plugins.startuptime" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.bqf" },
	{ import = "plugins.incline" },
	{ import = "plugins.noice" },
	{ import = "plugins.oil" },
	{ import = "plugins.quicker" },
	{ import = "plugins.render-markdown" },
	{ import = "plugins.smart-splits" },

	{ "nvim-treesitter-textobjects", dep_of = { "demicolon.nvim" } },
	{ import = "plugins.demicolon" },

	{ "plenary.nvim", dep_of = { "neogit", "neotest" } },
	{ import = "plugins.neogit" },
	{ import = "plugins.neotest" },

	{
		"git-conflict.nvim",
		enabled = nixCats("general") or false,
		event = "DeferredUIEnter",
	},
	{
		"flit.nvim",
		enabled = nixCats("general") or false,
		event = { "BufReadPre", "BufNewFile" },
		after = function(plugin)
			require("flit").setup({
				multiline = false,
			})
		end,
	},
	{
		"inc-rename.nvim",
		enabled = nixCats("general") or false,
		event = { "BufReadPre", "BufNewFile" },
		after = function(plugin)
			require("inc_rename").setup({})
		end,
	},
	{
		"indent-blankline.nvim",
		enabled = nixCats("general") or false,
		event = { "BufReadPost", "BufNewFile" },
		after = function(plugin)
			require("ibl").setup({})
		end,
	},
	{
		"leap.nvim",
		enabled = nixCats("general") or false,
		event = { "BufReadPost", "BufNewFile" },
		dep_of = "flit.nvim",
		after = function()
			require("leap").setup({})
			vim.keymap.set("n", "<CR>", "<Plug>(leap)")
		end,
	},
	{
		"starlite-nvim",
		enabled = nixCats("general") or false,
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			local map = vim.keymap.set
			local default_options = { silent = true }
			map("n", "*", ":lua require'starlite'.star()<cr>", default_options)
			map("n", "g*", ":lua require'starlite'.g_star()<cr>", default_options)
			map("n", "#", ":lua require'starlite'.hash()<cr>", default_options)
			map("n", "g#", ":lua require'starlite'.g_hash()<cr>", default_options)
		end,
	},
	{
		"treesj",
		keys = {
			{ "<space>msm", "<cmd>TSJSplit<cr>", desc = "Split with treesitter" },
			{ "<space>msj", "<cmd>TSJJoin<cr>", desc = "Join with treesitter" },
			{ "<space>mss", "<cmd>TSJToggle<cr>", desc = "Split/Join with treesitter" },
		},
		after = function()
			require("treesj").setup({--[[ your config ]]
			})
			require("which-key").add({
				{ "<leader>ms", group = "Split/Join" },
			})
		end,
	},
}
