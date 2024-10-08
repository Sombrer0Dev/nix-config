local cmd = vim.cmd
local fn = vim.fn

local M = {}

--- Check if the minimum Neovim version is satisfied
--- Expects only the minor version, e.g. "9" for 0.9.1
---@param version number
---@return boolean
M.isNeovimVersionsatisfied = function(version)
	return version <= tonumber(vim.version().minor)
end

---checks if a command is available
---@param command string
---@return boolean
M.isExecutableAvailable = function(command)
	return vim.fn.executable(command) == 1
end

---notify
---@param message string
---@param level integer
---@param title string
M.notify = function(message, level, title)
	local notify_options = {
		title = title,
		timeout = 2000,
	}
	vim.api.nvim_notify(message, level, notify_options)
end

-- Check if a variable is not empty nor nil
M.isNotEmpty = function(s)
	return s ~= nil and s ~= ""
end

--- Check if path exists
M.path_exists = function(path)
	return vim.loop.fs_stat(path)
end

-- toggle quickfixlist
M.toggle_qf = function()
	local windows = fn.getwininfo()
	local qf_exists = false
	for _, win in pairs(windows) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		cmd("cclose")
		return
	end
	if M.isNotEmpty(fn.getqflist()) then
		cmd("copen")
	end
end

-- toggle colorcolumn
M.toggle_colorcolumn = function()
	local value = vim.api.nvim_get_option_value("colorcolumn", {})
	if value == "" then
		M.notify("Enable colocolumn", 1, "functions.lua")
		vim.api.nvim_set_option_value("colorcolumn", "79", {})
	else
		M.notify("Disable colocolumn", 1, "functions.lua")
		vim.api.nvim_set_option_value("colorcolumn", "", {})
	end
end

-- move over a closing element in insert mode
M.escapePair = function()
	local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
	local line = vim.api.nvim_get_current_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local after = line:sub(col + 1, -1)
	local closer_col = #after + 1
	local closer_i = nil
	for i, closer in ipairs(closers) do
		local cur_index, _ = after:find(closer)
		if cur_index and (cur_index < closer_col) then
			closer_col = cur_index
			closer_i = i
		end
	end
	if closer_i then
		vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
	else
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end
end

-- @author kikito
-- @see https://codereview.stackexchange.com/questions/268130/get-list-of-buffers-from-current-neovim-instance
-- currently not used
function M.get_listed_buffers()
	local buffers = {}
	local len = 0
	for buffer = 1, vim.fn.bufnr("$") do
		if vim.fn.buflisted(buffer) == 1 then
			len = len + 1
			buffers[len] = buffer
		end
	end

	return buffers
end

function M.map(mode, l, r, opts)
	opts = opts or {}
	vim.keymap.set(mode, l, r, opts)
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			-- client.server_capabilities.semanticTokensProvider = nil
			on_attach(client, buffer)
		end,
	})
end

---returns OS dependent path separator
---@return string
M.path_separator = function()
	local is_windows = vim.fn.has("win32") == 1
	if is_windows == true then
		return "\\"
	else
		return "/"
	end
end

---Merge two tables into the first table
---@param t1 table
---@param t2 table
---@return table
M.merge_tables = function(t1, t2)
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			M.merge_tables(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

---returns the number of items in a table
---@param t table
---@return integer
M.table_length = function(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

---Search for TODO|HACK|FIXME|NOTE with rg and
---populate quickfixlist with the results
M.search_todos = function()
	local result
	result = vim.fn.system("rg --json --case-sensitive -w 'TODO|HACK|FIXME|NOTE'")
	if result == nil then
		return
	end
	local lines = vim.split(result, "\n")
	local qf_list = {}

	for _, line in ipairs(lines) do
		if line ~= "" then
			local data = vim.fn.json_decode(line)
			if data ~= nil then
				if data.type == "match" then
					local submatches = data.data.submatches[1]
					table.insert(qf_list, {
						filename = data.data.path.text,
						lnum = data.data.line_number,
						col = submatches.start,
						text = data.data.lines.text,
					})
				end
			end
		end
	end

	if next(qf_list) ~= nil then
		vim.fn.setqflist(qf_list)
		vim.cmd("copen")
	else
		local utils = require("utils.functions")
		utils.notify("No results found!", vim.log.levels.INFO, "Search TODOs")
	end
end

M.is_empty = function(str)
	return str == nil or str == ""
end

M.is_home_dir = function(path)
	local homeDir = os.getenv("HOME") or os.getenv("USERPROFILE") or vim.uv.os_homedir()
	homeDir = homeDir:gsub("[\\/]+$", "") -- Remove trailing path separators
	path = path:gsub("[\\/]+$", "") -- Remove trailing path separators
	return path == homeDir
end

M.is_fs_root = function(path)
	if vim.uv.os_uname().version:match("Windows") then
		return path:match("^%a:$")
	else
		return path == "/"
	end
end

local local_cwd = vim.uv.cwd()
---@param loose_or_path? boolean|string
M.safe_cwd = function(loose_or_path)
	if loose_or_path == true then
		return vim.uv.cwd()
	end
	local cwd = (type(loose_or_path) == "string" and loose_or_path ~= "") and loose_or_path or vim.uv.cwd()
	if M.is_home_dir(cwd) or M.is_fs_root(cwd) then
		return local_cwd
	end
	return cwd
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
    return string.format("#%x", int_color)
end

--- Get the number of open buffers
--- @return number
M.get_buffer_count = function()
	local count = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.bufname(buf) ~= "" then
			count = count + 1
		end
	end
	return count
end

--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
M.get_hlgroup = function(name, fallback)
	if vim.fn.hlexists(name) == 1 then
		local group = vim.api.nvim_get_hl(0, { name = name })

		local hl = {
			fg = group.fg == nil and "NONE" or M.parse_hex(group.fg),
			bg = group.bg == nil and "NONE" or M.parse_hex(group.bg),
		}

		return hl
	end
	return fallback or {}
end

return M
