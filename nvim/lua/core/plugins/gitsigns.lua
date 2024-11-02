local M = {
	"lewis6991/gitsigns.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- event = { "BufReadPre", "BufNewFile" },
	config = function()
		local function mappings()
			local wk = require("which-key")
			local icons = require("mini.icons")
			local gs = package.loaded.gitsigns
      local diff = require('diffview')

			wk.add({
				{ "<leader>g", group = "Git" },
				{ "<leader>g<Enter>", "<cmd>lua require('neogit').open({kind='replace'})<cr>", desc = "NeoGit" },
				{ "<leader>gw", "<cmd>Neogit worktree<cr>", desc = "Worktrees" },
				{ "<leader>gS", gs.stage_buffer, desc = "Stage buffer" },
				{
					"<leader>gs",
					gs.stage_hunk,
					desc = "Stage hunk",
					mode = { "n", "v" },
				},
				{ "<leader>gu", gs.undo_stage_hunk, desc = "Undo stage hunk" },
				{ "<leader>gr", group = "Reset" },
				{ "<leader>grR", gs.reset_buffer, icon = icons.get("filetype", "git"), desc = "Reset buffer" },
				{ "<leader>grr", gs.reset_hunk, desc = "Reset hunk", mode = { "n", "v" } },
				{ "<leader>gp", gs.preview_hunk, desc = "Preview hunk" },
				{
					"<leader>gB",
					function()
						gs.blame_line({ full = true })
					end,
					desc = "Blame full",
				},
				{ "<leader>gb", gs.toggle_current_line_blame, desc = "Blame line" },
				{ "<leader>gD", '<cmd>DiffviewOpen<cr>', desc = "Diff" },
				{ "<leader>gd", gs.toggle_deleted, desc = "Show deleted" },
        {"gH", "<cmd><C-U>Gitsigns select_hunk<cr>", desc="Select hunk", mode={"o", "x"}},
			})
		end

		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 0,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})
		mappings()
	end,
}

return M
