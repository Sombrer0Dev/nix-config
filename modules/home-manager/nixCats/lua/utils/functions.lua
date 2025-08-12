local cmd = vim.cmd
local api = vim.api
local fn = vim.fn

local M = {}
--- Get the number of open buffers
--- @return number
M.get_buffer_count = function()
	local count = 0
	for _, buf in ipairs(api.nvim_list_bufs()) do
		if fn.bufname(buf) ~= "" then
			count = count + 1
		end
	end
	return count
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
	return string.format("#%x", int_color)
end
--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
M.get_hlgroup = function(name, fallback)
	if fn.hlexists(name) == 1 then
		local group = api.nvim_get_hl(0, { name = name })

		local hl = {
			fg = group.fg == nil and "NONE" or M.parse_hex(group.fg),
			bg = group.bg == nil and "NONE" or M.parse_hex(group.bg),
		}

		return hl
	end
	return fallback or {}
end

return M
