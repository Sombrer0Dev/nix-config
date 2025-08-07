local M = {}

-- use in some pickers for split search
-- local default_cmd = "belowright new | wincmd J | resize 20"
-- winopts = {
--   split = default_cmd,

---@param opts {cwd?:string} | table
function M.files(opts)
	opts = opts or {}

	local fzflua = require("fzf-lua")
	local utils = require("utils.functions")

	if not opts.cwd then
		opts.cwd = utils.safe_cwd(vim.t.Cwd)
	end
	local cmd = nil
	if vim.fn.executable("fd") == 1 then
		local fzfutils = require("fzf-lua.utils")
		-- fzf-lua.defaults#defaults.files.fd_opts
		cmd = string.format(
			[[fd --color=never --type f --hidden --follow --exclude .git -x printf "{}: {/} %s\n"]],
			fzfutils.ansi_codes.italic("{//}")
		)
		opts.fzf_opts = {
			-- process ansi colors
			["--ansi"] = "",
			["--with-nth"] = "2..",
			["--delimiter"] = "\\s",
			["--tiebreak"] = "begin,index",
		}
		-- opts._fmt = opts._fmt or {}
		-- opts._fmt.from = function(entry, _opts)
		--   local s = fzfutils.strsplit(entry, ' ')
		--   return s[3]
		-- end
	end
	opts.cmd = cmd

	opts.winopts = {
		fullscreen = false,
		height = 0.60,
		width = 0.40,
		preview = {
			hidden = "hidden",
		},
	}
	opts.ignore_current_file = true

	return fzflua.files(opts)
end

---@param no_buffers? boolean
function M.buffers_or_recent(no_buffers)
	local fzflua = require("fzf-lua")
	local fzfutils = require("core.plugins.fzf.utils")
	local bufopts = {
		header_separator = "  ",
		-- fzf_opts = { ["--tmux"] = "center,30%,25%" },
		filename_first = true,
		sort_lastused = true,
		-- winopts = {
		-- 	height = 0.3,
		-- 	width = 0.3,
		-- 	fullscreen = false,
		-- 	preview = {
		-- 		hidden = "hidden",
		-- 	},
		-- },
	}
	local oldfiles_opts = {
		header_separator = "  ",
		-- fzf_opts = { ["--tmux"] = "center,30%,25%" },
		prompt = " Recent: ",
		cwd_only = true,
		include_current_session = true,
		-- winopts = {
		-- 	height = 0.3,
		-- 	width = 0.3,
		-- 	fullscreen = false,
		-- 	preview = {
		-- 		hidden = "hidden",
		-- 	},
		-- },
		-- keymap = {
		-- 	-- fzf = {
		-- 	--   ['tab'] = 'down',
		-- 	--   ['btab'] = 'up',
		-- 	--   ['ctrl-j'] = 'toggle+down',
		-- 	--   ['ctrl-i'] = 'down',
		-- 	-- },
		-- },
	}
	local buffers_actions = {}

	local oldfiles_actions = {
		actions = {
			["ctrl-e"] = {
				desc = "switch",
				header = "switch",
				fn = function()
					return fzflua.buffers(vim.tbl_extend("force", {
						query = fzfutils.get_last_query(),
					}, bufopts, buffers_actions))
				end,
			},
			["ctrl-f"] = {
				desc = "find-files",
				header = "find-files",
				fn = function()
					local query = fzfutils.get_last_query()
					if query == "" or not query then
						vim.notify("please provide query before switch to find files mode.")
						return
					end

					M.files({
						cwd = oldfiles_opts.cwd,
						query = query,
					})
				end,
			},
		},
	}
	buffers_actions = {
		actions = {
			["ctrl-e"] = {
				desc = "switch",
				header = "switch",
				function()
					fzflua.oldfiles(vim.tbl_extend("force", {
						query = fzfutils.get_last_query(),
					}, oldfiles_opts, oldfiles_actions))
				end,
			},
		},
	}

	local count = #vim.fn.getbufinfo({ buflisted = 1 })
	if no_buffers or count <= 1 then
		--- open recent.
		fzflua.oldfiles(vim.tbl_extend("force", {}, oldfiles_opts, oldfiles_actions))
		return
	end
	local _bo = vim.tbl_extend("force", {}, bufopts, buffers_actions)
	return require("fzf-lua").buffers(_bo)
end

return M
