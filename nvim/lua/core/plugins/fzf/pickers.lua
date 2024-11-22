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

function M.command_history()
	local fzflua = require("fzf-lua")

	fzflua.command_history({
		winopts = {
			fullscreen = false,
			height = 0.40,
			width = 0.40,
			preview = {
				hidden = "hidden",
			},
		},
	})
end

function M.git_branches()
	local fzflua = require("fzf-lua")
	local utils = require("utils.functions")
	local winopts = {
		fullscreen = false,
		width = 0.6,
		height = 0.4,
	}

	fzflua.fzf_exec({
		"Local branches",
		"Remote branches",
		"All branches",
	}, {
		actions = {
			["default"] = function(selected)
				if not selected or #selected <= 0 then
					return
				end
				if selected[1] == "Local branches" then
					fzflua.git_branches({
						winopts = winopts,
						cwd = vim.t.Cwd or utils.safe_cwd(),
						cmd = "git branch --color",
						prompt = "Local❯ ",
					})
				elseif selected[1] == "Remote branches" then
					fzflua.git_branches({
						winopts = winopts,
						cwd = utils.safe_cwd(vim.t.Cwd),
						cmd = "git branch --remotes --color",
						prompt = "Remote❯ ",
					})
				elseif selected[1] == "All branches" then
					fzflua.git_branches({
						winopts = winopts,
						cwd = utils.safe_cwd(vim.t.Cwd),
						cmd = "git branch --all --color",
						prompt = "All❯ ",
					})
				end
			end,
		},
		winopts = {
			fullscreen = false,
			width = 0.1,
			height = 0.1,
			relative = "cursor",
			row = 1,
			col = 0,
		},
	})
end

---@param no_buffers? boolean
function M.buffers_or_recent(no_buffers)
	local fzflua = require("fzf-lua")
	local fzfutils = require("core.plugins.fzf.utils")
	local bufopts = {
		fzf_opts = { ["-p"] = "30%,25%" },
		filename_first = true,
		sort_lastused = true,
		winopts = {
			height = 0.3,
			width = 0.3,
			fullscreen = false,
			preview = {
				hidden = "hidden",
			},
		},
	}
	local oldfiles_opts = {
		fzf_opts = { ["-p"] = "30%,25%" },
		prompt = " Recent: ",
		cwd_only = true,
		include_current_session = true,
		winopts = {
			height = 0.3,
			width = 0.3,
			fullscreen = false,
			preview = {
				hidden = "hidden",
			},
		},
		keymap = {
			-- fzf = {
			--   ['tab'] = 'down',
			--   ['btab'] = 'up',
			--   ['ctrl-j'] = 'toggle+down',
			--   ['ctrl-i'] = 'down',
			-- },
		},
	}
	local buffers_actions = {}

	local oldfiles_actions = {
		actions = {
			["ctrl-e"] = function()
				return fzflua.buffers(vim.tbl_extend("force", {
					query = fzfutils.get_last_query(),
				}, bufopts, buffers_actions))
			end,
			["ctrl-f"] = function()
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
	}
	buffers_actions = {
		actions = {
			["ctrl-e"] = function()
				fzflua.oldfiles(vim.tbl_extend("force", {
					query = fzfutils.get_last_query(),
				}, oldfiles_opts, oldfiles_actions))
			end,
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

--- @param _opts table
local function callgrep(_opts, callfn)
	local utils = require("utils.functions")
	local fzfutils = require("core.plugins.fzf.utils")
	local opts = vim.tbl_deep_extend("force", {}, _opts)

	opts.cwd_header = true

	if not opts.cwd then
		opts.cwd = vim.t.Cwd or utils.safe_cwd()
	end

	opts.no_header = false
	opts.winopts = {
		fullscreen = false,
		height = 0.90,
		width = 1,
	}
	opts.rg_opts = opts.rg_opts
		or [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]]

	opts.actions = vim.tbl_extend("keep", {
		["ctrl-h"] = function()
			--- toggle hidden files search.
			opts.rg_opts = fzfutils.toggle_cmd_option(opts.rg_opts, "--hidden")
			return callfn(opts)
		end,
		["ctrl-a"] = function()
			--- toggle rg_glob
			opts.rg_glob = not opts.rg_glob
			if opts.rg_glob then
				opts.prompt = opts.prompt .. "(G): "
			else
				-- remove (G): from prompt
				opts.prompt = string.gsub(opts.prompt, "%(G%): ", "")
			end
			-- usage: {search_query} --{glob pattern}
			-- hello --*.md *.js
			return callfn(opts)
		end,
	}, opts.actions)

	return callfn(opts)
end

--- @see https://github.com/ibhagwan/fzf-lua/wiki/Advanced#preview-overview
---@param opts {max_depth?:number,cwd?:string, ret:bool} | table
function M.folders(opts)
	opts = opts or {}

	local fzflua = require("fzf-lua")
	local fzfutils = require("core.plugins.fzf.utils")
	local path = require("fzf-lua.path")
	local utils = require("utils.functions")

	if not opts.cwd then
		opts.cwd = utils.safe_cwd(vim.t.Cwd)
	end
	local preview_cwd = opts.cwd

	-- https://github.com/ibhagwan/fzf-lua/commit/36d850b29b387768e76e59799029d1e69aee2522
	-- opts.fd_opts = string.format('--type directory  --max-depth %s', opts.max_depth or 4)
	-- opts.find_opts = [[-type d -not -path '*/\.git/*' -printf '%P\n']]
	local cmd = string.format([[fd --color always --type directory --max-depth %s]], opts.max_depth or 4)
	local has_exa = vim.fn.executable("eza") == 1

	opts.prompt = "󰥨  Folders❯ "
	opts.cmd = cmd
	opts.cwd_header = true
	opts.cwd_prompt = true
	opts.toggle_ignore_flag = "--no-ignore-vcs"
	opts.winopts = {
		fullscreen = false,
	}
	opts.fzf_opts = {
		["--preview-window"] = "nohidden,down,50%",
		["--preview"] = fzflua.shell.raw_preview_action_cmd(function(items)
			if has_exa then
				return string.format(
					"cd %s ; eza --color=always --icons=always --group-directories-first -a %s",
					preview_cwd,
					items[1]
				)
			end
			return string.format("cd %s ; ls %s", preview_cwd, items[1])
		end),
	}

	opts.actions = {
		["default"] = function(selected, selected_opts)
			local first_selected = selected[1]
			if not first_selected then
				return
			end
			local entry = path.entry_to_file(first_selected, selected_opts)
			local entry_path = entry.path
			if not entry_path then
				return
			end

			if opts.proj then
				vim.cmd("cd " .. entry_path)
				vim.cmd('FzfLua files formatter="path.filename_first"')
				return
			end
			require("oil").open(entry_path)
		end,
		["ctrl-g"] = function(_, o)
			opts.cmd = fzfutils.toggle_cmd_option(o.cmd, "--no-ignore-vcs")
			return fzflua.fzf_exec(opts.cmd, opts)
		end,
		["ctrl-h"] = function(_, o)
			--- toggle hidden
			opts.cmd = fzfutils.toggle_cmd_option(o.cmd, "--hidden")
			return fzflua.fzf_exec(opts.cmd, opts)
		end,
	}

	return fzflua.fzf_exec(cmd, opts)
end

function M.grep(opts, is_live, is_word)
	local fzfutils = require("core.plugins.fzf.utils")
	opts = opts or {}
	opts.fzf_opts = { ["-p"] = "95%,90%" }
	if is_live == nil then
		is_live = true
	end
	if is_word == nil then
		is_word = false
	end

	local fzflua = require("fzf-lua")
	if is_word then
		opts.search = vim.fn.expand("<cword>")
	end
	if is_live then
		opts.prompt = "󱙓  Live Grep❯ "
		-- fixed strings search
		opts.rg_opts =
			"--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --fixed-strings"
		local copyopts = vim.deepcopy(opts)

		opts.actions = {
			["ctrl-k"] = function()
				local new_opts = vim.deepcopy(copyopts)
				new_opts.rg_opts = fzfutils.toggle_cmd_option(opts.rg_opts, "--fixed-strings")
				new_opts.rg_opts = fzfutils.toggle_cmd_option(new_opts.rg_opts, "-e", true)
				new_opts.query = fzfutils.get_last_query()
				vim.print(new_opts.rg_opts)
				fzflua.live_grep(new_opts)
			end,
		}
	else
		opts.input_prompt = "󱙓  Grep❯ "
	end
	return callgrep(
		opts,
		-- schedule: fix fzf picker show and dismiss issue.
		vim.schedule_wrap(function(opts_local)
			if is_live then
				return fzflua.live_grep(opts_local)
			else
				return fzflua.grep(opts_local)
			end
		end)
	)
end

function M.zoxide()
	local fzflua = require("fzf-lua")

	fzflua.fzf_exec("zoxide query -l -s", {
		fzf_opts = {
			["--with-nth"] = "2",
			["--no-sort"] = "",
		},
		prompt = "Zoxide❯ ",
		actions = {
			["default"] = function(selected, _)
				local path = vim.split(selected[1]:gsub("^%s*", ""), " ")[2]
				require("oil").open(path)
				vim.cmd("cd " .. path)
			end,
		},
	})
end

function M.fixtures()
	require("fzf-lua").grep({ search = "def " .. vim.fn.expand("<cword>") })
end

local function switch_tmux(name)
	local output = io.popen("tmux list-panes"):read("*all")
	if #SPLIT(output, "\n") > 2 then
		os.execute("tmux send-keys -t .+ C-c")
		local cmd = "tmux send-keys -t .+ 'workswitch " .. name .. "' KPENTER"
		os.execute(cmd)
	end
end
function M.switch_worktree()
	local fzflua = require("fzf-lua")

	fzflua.fzf_exec("git worktree list | rg -v bare | awk '{print $1}'", {
		actions = {
			["enter"] = {
				desc = "change-directory",
				fn = function(sel)
					if type(next(sel)) == "nil" then
						return
					end

					require("git-worktree").switch_worktree(vim.fs.basename(sel[1]))
					switch_tmux(sel[1])
				end,
			},
			["ctrl-d"] = function(sel)
				if type(next(sel)) == "nil" then
					return
				end
				require("git-worktree").delete_worktree(sel[1])
			end,
		},
	})
end

function M.add_worktree()
	vim.ui.input({ prompt = "Input worktree name" }, function(str)
		if str == nil then
			return
		end

		local fzflua = require("fzf-lua")

		fzflua.fzf_exec("git branch --format='%(refname:short)'", {
			actions = {
				["enter"] = {
					desc = "choose-branch",
					fn = function(sel)
						require("git-worktree").create_worktree(str, sel[1], "origin")
						switch_tmux(sel[1])
					end,
				},
			},
		})
	end)
end

return M
